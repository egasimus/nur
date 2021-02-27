{pkgs,stdenv,fetchurl,...}: stdenv.mkDerivation rec {
  name = "cinelerra-gg";
  src = fetchurl {
    url = "https://cinelerra-gg.org/download/tars/cinelerra-5.1-arch-20201031.x86_64-static.txz";
    sha256 = "0srk5qb0097cvms2z0ihq316q52hd3jraw08a6a829967li5gjcn";
  };
  sourceRoot = ".";
  nativeBuildInputs = [ pkgs.autoPatchelfHook ];
  buildInputs = with pkgs; [
    alsaLib
    atk
    bzip2
    cairo
    fftwFloat
    fontconfig
    freetype
    gcc-unwrapped
    gdk-pixbuf
    glib
    gnome2.pango
    gtk2-x11
    harfbuzz
    libGLU
    libglvnd
    libpng
    libusb
    libva
    libvdpau
    lzma
    numactl
    openexr
    pulseaudio
    xlibs.libX11
    xlibs.libXext
    xlibs.libXfixes
    xlibs.libXft
    xlibs.libXinerama
    xlibs.libXv
    zlib
  ];
  installPhase = ''
    mkdir -p $out
    cd $out
    cp -r /build/* .
    ls -al
    patchelf --replace-needed libbz2.so.1.0 libbz2.so.1.0.6 mplexlo
    patchelf --replace-needed libbz2.so.1.0 libbz2.so.1.0.6 lv2ui
    patchelf --replace-needed libbz2.so.1.0 libbz2.so.1.0.6 bdwrite
    patchelf --replace-needed libbz2.so.1.0 libbz2.so.1.0.6 hveg2enc
    patchelf --replace-needed libbz2.so.1.0 libbz2.so.1.0.6 cin
  '';
}

