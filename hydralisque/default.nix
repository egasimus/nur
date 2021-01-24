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

  mkNodePackage = (import ../mk-node-package.nix) { inherit lib runCommand; };

in mkNodePackage {
  name       = "hydralisque";
  outputHash = "0rpm6jvamx7rycarw78y17gzrkkkrs4sydin8lylx4435sa1p4s1";
  meta = {
    description = "video masher based on Olivia Jack's Hydra";
    homepage = "https://github.com/egasimus/hydralisque";
    license = lib.licenses.agpl3Only;
  };
  entryPoint = ''
    #!/bin/sh
    pushd $(dirname $(dirname $0))
    ${electron_11.out}/bin/electron electron/app.js
  '';
  buildInputs = [
    nodejs-14_x
    electron_11
    pkg-config
    yarn
    electron_11.buildInputs
    xlibs.libX11
    xlibs.libXi
    xlibs.libXext
  ];
}
