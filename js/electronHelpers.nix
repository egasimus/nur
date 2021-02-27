{
  wrapHTML = electron: name: main: ''
    mkdir -p $out/lib/${name}
    cp -r $src/* $out/lib/${name}
    echo '{"main":"main.js"}' > $out/lib/${name}/package.json
    cat ${main} > $out/lib/${name}/main.js

    mkdir -p $out/bin
    echo '#!/bin/sh' > $out/bin/${name}
    echo "${electron}/bin/electron $out/lib/${name}" >> $out/bin/${name}
    chmod +x $out/bin/${name}
  '';

  subdirInstallPhase = pname: ''
    runHook preInstall
    mkdir -p $out/{bin,libexec/${pname}}
    mv node_modules $out/libexec/${pname}/node_modules
    mv deps $out/libexec/${pname}/deps
    runHook postInstall
  '';

  subdirDistPhase = electron: name: command: ''
    cd $out
    unlink "$out/libexec/${name}/deps/${name}/node_modules"
    ln -s "$out/libexec/${name}/node_modules" "$out/libexec/${name}/deps/${name}/desktop/node_modules"
    ls -al
    ls -al libexec
    mkdir -p bin
    cd bin
    echo '#!/bin/sh' > ${command}
    echo "cd $out/libexec/${name}/deps/${name}" >> ${command}
    echo "${electron}/bin/electron $out/libexec/${name}/deps/${name}/desktop" >> ${command}
    chmod 0755 $out/bin/${command}
    true
  '';
}
