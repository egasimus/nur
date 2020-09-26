{pkgs,stdenv,fetchgit,...}: let
  jack = pkgs.jack2;
  wine = pkgs.wineWowPackages.staging;
in stdenv.mkDerivation rec {
  pname = "wineasio";
  rev = "e71741863fc89ac5c78eba2018ec1737499a287b";
  name = "${pname}-${rev}";
  src = fetchgit {
    url = "https://github.com/wineasio/wineasio.git";
    sha256 = "0an96bp683n7wwwwa2f6945v2pn4q2q6vn0v73kc0k5cqns11qc6";
    fetchSubmodules = true;
    inherit rev;
  };
  patches = [ ./prefix.patch ];
  buildInputs = [ jack wine pkgs.pkgconfig ];
  buildPhase = ''
    make PREFIX=${wine.out} 64
  '';
  installPhase = ''
    ls -al build64
    mkdir -p $out/lib64/wine
    cp build64/wineasio.dll.so $out/lib64/wine
  '';
}
