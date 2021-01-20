{stdenv, python38, fetchFromGitHub,...}: stdenv.mkDerivation rec {
  pname = "troop";
  rev = "f52e0b6aa8c4d071dbadb6c1ab0123ba4a39e30d";
  name = "${pname}-${rev}";
  src = fetchFromGitHub {
    owner = "Qirky";
    repo = "Troop";
    inherit rev;
    sha256 = "15g86gb1zivy3s8dfhgz0c3czqg053rmvp46qscgj5qkr2vbaifs";
  };
  installPhase = ''
    mkdir -p $out/bin $out/lib $out/doc
    mv *.md $out/doc/
    mv *.py $out/lib/
    mv src $out/lib/

    echo "#!/bin/sh" > $out/bin/troop-server
    echo "pushd $out/lib; trap popd exit" >> $out/bin/troop-server
    echo "python run-server.py" >> $out/bin/troop-server
    chmod +x $out/bin/troop-server

    echo "#!/bin/sh" > $out/bin/troop-client
    echo "pushd $out/lib; trap popd exit" >> $out/bin/troop-client
    echo "python run-client.py" >> $out/bin/troop-client
    chmod +x $out/bin/troop-client
  '';
  propagatedBuildInputs = [ python38 python38.pkgs.tkinter ];
}
