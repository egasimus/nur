{ lib
, stdenv
, fetchFromGitHub
, runCommand
, electron_11
, nodejs-14_x
, pkg-config
, xlibs
, yarn
}: let

  rev    = "e730d7af04c28cff628e7074d49226d22e363e19";
  sha256 = "0cgz9556y21da2dmf3zcr30p71ba3pkxbrlbbnhl89f44zswg000";
  mkNodePackage = (import ../mk-node-package.nix) { inherit lib runCommand; };

in mkNodePackage {
  name = "hydralisque-${rev}";
  outputHash = "0rpm6jvamx7rycarw78y17gzrkkkrs4sydin8lylx4435sa1p4s1";
  meta = {
    description = "video masher based on Olivia Jack's Hydra";
    homepage = "https://github.com/egasimus/hydralisque";
    license = lib.licenses.agpl3Only;
  };
  src = fetchFromGitHub {
    owner = "egasimus";
    repo  = "hydralisque";
    inherit rev sha256;
  };
  entryPoint = ''
    #!/bin/sh
    pushd $(dirname $(dirname $0))
    ${electron_11.out}/bin/electron electron/app.js $@
  '';
  buildInputs = [
    electron_11
    electron_11.buildInputs
    nodejs-14_x
    pkg-config
    xlibs.libX11
    xlibs.libXext
    xlibs.libXi
    yarn
  ];
}
