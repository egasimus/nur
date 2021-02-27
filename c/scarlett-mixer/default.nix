{fetchFromGitHub
,alsaLib
,cairo
,cmake
,fetchgit
,libGLU
,lv2
,mesa
,meson
,ninja
,pango
,pkg-config
,stdenv
}:let
  repo = "scarlett-mixer";
  rev  = "a29c0a2";
in stdenv.mkDerivation {
  name = "${repo}-${rev}";
  src = fetchgit {
    url = "https://github.com/x42/${repo}.git";
    inherit rev;
    fetchSubmodules = true;
    sha256 = "03743pbzg6hzdckdqffrpiw6c19hcc5zl2a14sxyi8h3vy16fqjp";
  };
  nativeBuildInputs = [pkg-config meson ninja];
  buildInputs = [pango cairo lv2 alsaLib mesa libGLU];
  installPhase = ''
    mkdir -p $out/bin
    mv scarlett-mixer $out/bin/
  '';
}
