{ lib, stdenv, fetchFromGitHub, runCommand
, electron_11
, nodejs-14_x
, pkg-config
, xlibs
, yarn
}: let
  context = {};
in runCommand "hydralisque" {

  name = "hydralisque";
  outputHash = "0rpm6jvamx7rycarw78y17gzrkkkrs4sydin8lylx4435sa1p4s1";
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  meta = {
    description = "video masher based on Olivia Jack's Hydra";
    homepage = "https://github.com/egasimus/hydralisque";
    license = lib.licenses.agpl3Only;
  };
  src = fetchFromGitHub {
    owner = "egasimus";
    repo = "hydralisque";
    rev = "73031f47f858e0be26002b603f70a94775d930b7";
    sha256 = "1x0fp9kfibygs9jimkxhrkjsfg56x0bgj43fcqybnv4xzd3j48p2";
  };

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
  impureEnvVars = lib.fetchers.proxyImpureEnvVars;
} ''
  echo $out
  mkdir -p $out
  cp -r --no-preserve=all $src/* $out/
  cd $out
  ls -al
  export HOME=$out
  touch .yarnrc
  yarn --global-folder=$out --use-yarnrc=.yarnrc --ignore-optional --ignore-scripts
  ls -al
  rm -rf .cache .yarnrc

  mkdir -p bin
  echo '#!/bin/sh' > bin/hydralisque
  echo 'pushd $(dirname $(dirname $0))' >> bin/hydralisque
  echo '${electron_11.out}/bin/electron electron/app.js' >> bin/hydralisque
  chmod +x bin/hydralisque
''
