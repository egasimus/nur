{ pkgs, stdenv, ... }: stdenv.mkDerivation rec {
  name = "gxkb";
  src = pkgs.fetchFromGitHub {
    owner = "zen-tools";
    repo = "gxkb";
    rev = "131ee0b";
    sha256 = "04x4i2xwq1wmd2i0d8qmr7zxs3aspqh195jpwhqanj1s8x86a5b9";
  };
  nativeBuildInputs = with pkgs; [ bash which autoconf automake pkgconfig ];
  buildInputs = with pkgs; [ gtk2 libwnck libxklavier ];
  buildPhase = ''
    ls -al
    bash ./autogen.sh
    ./configure --enable-appindicator=no
    make
  '';
  installPhase = ''
    ls -al *
    mkdir -p $out/bin
    cp src/gxkb $out/bin/
  '';
}
