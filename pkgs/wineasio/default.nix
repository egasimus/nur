{stdenv
,fetchgit
,pkgconfig
,pkgs
,...}: let
  repo = "wineasio";
  rev  = "e7174186";
  jack = pkgs.jack2;
  wine = pkgs.wineWowPackages.staging;
in stdenv.mkDerivation rec {
  name = "${repo}-${rev}";
  src = fetchgit {
    url = "https://github.com/wineasio/${repo}.git";
    sha256 = "0an96bp683n7wwwwa2f6945v2pn4q2q6vn0v73kc0k5cqns11qc6";
    fetchSubmodules = true;
    inherit rev;
  };
  patches = [ ./prefix.patch ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ jack wine ];
  buildPhase = ''
    make PREFIX=${wine.out} 64
  '';
  installPhase = ''
    ls -al build64
    mkdir -p $out/lib64/wine
    cp build64/wineasio.dll.so $out/lib64/wine
  '';
}
