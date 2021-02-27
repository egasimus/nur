{ pkgs, stdenv }: stdenv.mkDerivation rec {
  name = "din-47";
  src = pkgs.fetchurl {
    url = "https://archive.org/download/dinisnoise_source_code/din-47.tar.gz";
    sha256 = "0012nrxgqnsqnjjh15gc1hddx1j9892g2qfwgk09z84dc3nbxz6r";
  };
  nativeBuildInputs = with pkgs; [ boost SDL libjack2 tcl mesa ];
  CXXFLAGS="-O3 -D__UNIX_JACK__";
  CFLAGS="-O3";
  LIBS="-ljack";
  postUnpack = ''export prefix=$out'';
}
