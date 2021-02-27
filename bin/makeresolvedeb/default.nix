{pkgs,stdenv,fetchurl,...}: stdenv.mkDerivation {
  name = "makeresolvedeb";
  src = fetchurl {
    url = "https://www.danieltufvesson.com/download/?file=makeresolvedeb/makeresolvedeb_1.4.3_multi.sh.tar.gz";
    sha256 = "1f58zgshnrqain5za8jc42b9x3b0zw5jrgfzxhwh1j8hc49bs2zs";
  };
  phases = [ "unpackPhase" ];
  unpackPhase = ''
    mkdir -p $out/bin
    cd $out/bin
    tar -xf $src
    ls -al
  '';
}
