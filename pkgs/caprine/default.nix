{ pkgs, stdenv, mkYarnPackage, ... }: let
  electron = pkgs.callPackage ./Electron9.nix {};
  version = "2.48.0";
in mkYarnPackage rec {
  name = "caprine-${version}";
  packageJson = ./Caprine.package.json;
  yarnLock = ./Caprine.yarn.lock;
  src = pkgs.fetchFromGitHub {
    owner = "sindresorhus";
    repo = "caprine";
    rev = "refs/tags/v${version}";
    sha256 = "0xnm76xic57f8izlndsd888x25agrrw4l46lndf93bingr4zw56c";
  };
  buildInputs = [ electron ];
  buildPhase = ''
    # compile typescript to javascript
    pushd deps/caprine
    node_modules/.bin/tsc
    popd

    # create launcher script
    mkdir -p $out/bin
    echo "#!/bin/sh" > $out/bin/caprine
    echo "${electron}/bin/electron \$@ $out/libexec/caprine/deps/caprine" >> $out/bin/caprine
    chmod +x $out/bin/caprine
  '';
}

