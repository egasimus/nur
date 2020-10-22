{ stdenv, fetchFromGitHub, jack2, pkgconfig }: let
  rev = "554baec3";
in stdenv.mkDerivation rec {
  name = "orjail-${rev}";
  src = fetchFromGitHub {
    owner = "x42";
    repo = "jack_midi_clock";
    inherit rev;
    sha256 = "1acw9ys8mnzkp6v3s1r7nn8jz7z9a88vlch7g57wizp7ir4kq9mg";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ jack2 ];
  installPhase = ''
    mkdir -p $out/bin
    cp jack_midi_clock jack_mclk_dump $out/bin/

    mkdir -p $out/doc
    cp AUTHORS COPYING ChangeLog README.md $out/doc
  '';
}

