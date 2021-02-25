{lib, runCommand}:
  {name, outputHash, entryPoint, ...}@args:
    let
      context = {
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        impureEnvVars  = lib.fetchers.proxyImpureEnvVars;
      }//args;
    in runCommand name context ''
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
      echo '${entryPoint}' >> bin/${name}
      chmod +x bin/${name}
    ''
