{ stdenv
, pkgs
, lib
, fetchFromGitHub
, yarn2nix }: let

  defaultYarnFlags = [
    "--offline"
    "--frozen-lockfile"
    "--ignore-engines"
    "--ignore-scripts"
  ];

  mkYarnNix = # Generates the yarn.nix from the yarn.lock file
    { yarnLock, flags ? [] }:
      pkgs.runCommand "yarn.nix" {}
      "${yarn2nix}/bin/yarn2nix --lockfile ${yarnLock} --no-patch --builtin-fetchgit ${lib.escapeShellArgs flags} > $out";

  reformatPackageName =   # regex adapted from `validate-npm-package-name`
    pname: with builtins; # will produce 3 parts e.g.
      let                 # "@org/pkg" -> [ "@org/" "org" "pkg" ]
        parts = # "somepackage" -> [ null null "somepackage" ]
          tail (match "^(@([^/]+)/)?([^/]+)$" pname);
        non-null = # if there is no organisation we need to filter out null values.
          filter (x: x != null) parts;
      in concatStringsSep "-" non-null;

  mkYarnPackage =
    { src
    , name                  ? null
    , packageJSON           ? src + "/package.json"
    , yarnLock              ? src + "/yarn.lock"
    , yarnNix               ? mkYarnNix { inherit yarnLock; }
    , yarnFlags             ? defaultYarnFlags
    , yarnPreBuild          ? ""
    , pkgConfig             ? {}
    , extraBuildInputs      ? []
    , publishBinsFor        ? null
    , workspaceDependencies ? [] # List of yarnPackages
    , ... }@attrs:
  let
    package =
      lib.importJSON packageJSON;
    pname =
      package.name;
    safeName =
      reformatPackageName pname;
    version =
      attrs.version or package.version;
    baseName =
      unlessNull name "${safeName}-${version}";

    workspaceDependenciesTransitive = lib.unique (
      (lib.flatten (builtins.map (dep: dep.workspaceDependencies) workspaceDependencies))
      ++ workspaceDependencies
    );

    deps =
      mkYarnModules {
        name = "${safeName}-modules-${version}";
        preBuild = yarnPreBuild;
        workspaceDependencies = workspaceDependenciesTransitive;
        inherit packageJSON pname version yarnLock yarnNix yarnFlags pkgConfig;
      };

    publishBinsFor_
      = unlessNull publishBinsFor [pname];

    linkDirFunction = ''
      linkDirToDirLinks() {
        target=$1
        if [ ! -f "$target" ]; then
          mkdir -p "$target"
        elif [ -L "$target" ]; then
          local new=$(mktemp -d)
          trueSource=$(realpath "$target")
          if [ "$(ls $trueSource | wc -l)" -gt 0 ]; then
            ln -s $trueSource/* $new/
          fi
          rm -r "$target"
          mv "$new" "$target"
        fi
      }
    '';

    workspaceDependencyCopy = lib.concatMapStringsSep "\n"
      (dep: ''
        # ensure any existing scope directory is not a symlink
        linkDirToDirLinks "$(dirname node_modules/${dep.pname})"
        mkdir -p "deps/${dep.pname}"
        tar -xf "${dep}/tarballs/${dep.name}.tgz" --directory "deps/${dep.pname}" --strip-components=1
        if [ ! -e "deps/${dep.pname}/node_modules" ]; then
          ln -s "${deps}/deps/${dep.pname}/node_modules" "deps/${dep.pname}/node_modules"
        fi
      '')
      workspaceDependenciesTransitive;

    in stdenv.mkDerivation (builtins.removeAttrs attrs ["yarnNix" "pkgConfig" "workspaceDependencies"] // {
      inherit src pname;
      name =
        baseName;
      buildInputs =
        [ yarn nodejs rsync ] ++ extraBuildInputs;
      node_modules
        = deps + "/node_modules";
      configurePhase = attrs.configurePhase or ''
        runHook preConfigure
        for localDir in npm-packages-offline-cache node_modules; do
          if [[ -d $localDir || -L $localDir ]]; then
            echo "$localDir dir present. Removing."
            rm -rf $localDir
          fi
        done
        # move convent of . to ./deps/${pname}
        mv $PWD $NIX_BUILD_TOP/temp
        mkdir -p "$PWD/deps/${pname}"
        rm -fd "$PWD/deps/${pname}"
        mv $NIX_BUILD_TOP/temp "$PWD/deps/${pname}"
        cd $PWD
        ln -s ${deps}/deps/${pname}/node_modules "deps/${pname}/node_modules"
        cp -r $node_modules node_modules
        chmod -R +w node_modules
        ${linkDirFunction}
        linkDirToDirLinks "$(dirname node_modules/${pname})"
        ln -s "deps/${pname}" "node_modules/${pname}"
        ${workspaceDependencyCopy}
        # Help yarn commands run in other phases find the package
        echo "--cwd deps/${pname}" > .yarnrc
        runHook postConfigure
      '';
      # Replace this phase on frontend packages where only the generated
      # files are an interesting output.
      installPhase =
        attrs.installPhase or ''
          runHook preInstall
          mkdir -p $out/{bin,libexec/${pname}}
          mv node_modules $out/libexec/${pname}/node_modules
          mv deps $out/libexec/${pname}/deps
          node ${./internal/fixup_bin.js} $out/bin $out/libexec/${pname}/node_modules ${lib.concatStringsSep " " publishBinsFor_}
          runHook postInstall
        '';
      doDist =
        true;
      distPhase =
        attrs.distPhase or ''
          # pack command ignores cwd option
          rm -f .yarnrc
          cd $out/libexec/${pname}/deps/${pname}
          mkdir -p $out/tarballs/
          yarn pack --offline --ignore-scripts --filename $out/tarballs/${baseName}.tgz
        '';
      passthru = { inherit pname package packageJSON deps;
                   workspaceDependencies = workspaceDependenciesTransitive;
                 } // (attrs.passthru or {});
      meta = { inherit (nodejs.meta) platforms;
               description = packageJSON.description or "";
               homepage    = packageJSON.homepage    or "";
               version     = packageJSON.version     or "";
               license     = if packageJSON ? license
                               then spdxLicense packageJSON.license
                               else "";
             } // (attrs.meta or {});
    });

  mkYarnWorkspace = {
    src,
    packageJSON      ? src + "/package.json",
    yarnLock         ? src + "/yarn.lock",
    packageOverrides ? {},
    ...
  }@attrs: let

    package =
      lib.importJSON packageJSON;
    packageGlobs =
      package.workspaces;
    globElemToRegex =
      lib.replaceStrings ["*"] [".*"];
    splitGlob = # PathGlob -> [PathGlobElem]
      lib.splitString "/"; 
    expandGlobList = # Path -> [PathGlobElem] -> [Path]
      # Note: Only directories are included, everything else is filtered out
      base: globElems: let
        elemRegex =
          globElemToRegex (lib.head globElems);
        rest =
          lib.tail globElems;
        children =
          lib.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir base));
        matchingChildren =
          lib.filter (child: builtins.match elemRegex child != null) children;
      in if globElems == []
        then [ base ]
        else lib.concatMap (child: expandGlobList (base+("/"+child)) rest) matchingChildren;
    expandGlob = # Path -> PathGlob -> [Path]
      base: glob:
        expandGlobList base (splitGlob glob);
    packagePaths =
      lib.concatMap (expandGlob src) packageGlobs;
		addPackage = src: let
			packageJSON =
				src + "/package.json";
			package =
				lib.importJSON packageJSON;
			allDependencies =
				lib.foldl (a: b: a // b) {} (map
					(field: lib.attrByPath [field] {} package)
					["dependencies" "devDependencies"]);
			# { [name: String] : { pname : String, packageJSON : String, ... } } -> { [pname: String] : version } -> [{ pname : String, packageJSON : String, ... }]
			getWorkspaceDependencies =
				packages: allDependencies: let
          packageList =
            lib.attrValues packages;
          compose =
            f: g: x: f (g x);
          id =
            x: x;
          composeAll =
            builtins.foldl' compose id;
        in composeAll [
          (lib.filter (x: x != null))
          (lib.mapAttrsToList (pname: _version: lib.findFirst (package: package.pname == pname) null packageList))
        ] allDependencies;
			workspaceDependencies =
				getWorkspaceDependencies packages allDependencies;
			name =
				reformatPackageName package.name;
		in {
			inherit name;
			value = mkYarnPackage (
				builtins.removeAttrs attrs ["packageOverrides"]
				// { inherit src packageJSON yarnLock workspaceDependencies; }
				// lib.attrByPath [name] {} packageOverrides
			);
		};
    packages =
      lib.listToAttrs (map addPackage packagePaths); in
	packages;

in mkYarnWorkspace {

  meta = {
    description = "video masher based on Olivia Jack's Hydra";
    homepage = "https://github.com/egasimus/hydralisque";
    license = lib.licenses.agpl3Only;
  };

  name = "hydralisque";
  src = fetchFromGitHub {
    owner = "egasimus";
    repo = "hydralisque";
    rev = "73031f47f858e0be26002b603f70a94775d930b7";
    sha256 = "1x0fp9kfibygs9jimkxhrkjsfg56x0bgj43fcqybnv4xzd3j48p2";
  };
  yarnNix = ./yarn.nix;

  #nativeBuildInputs = with pkgs; [
    #pkg-config
    #yarn
    #nodePackages.npm
    #nodePackages.node2nix
  #];
  #buildInputs = with pkgs; [
    #electron_11.buildInputs
    #xlibs.libX11
    #xlibs.libXi
    #xlibs.libXext
  #];
  #propagatedBuildInputs = with pkgs; [
    #nodejs-14_x
    #electron_11
  #];

}
