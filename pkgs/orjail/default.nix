{ bash, stdenv, fetchFromGitHub }: let
  rev = "a0b9e6c60b5952dcb286cceb595b29f9fd36ae95";
in stdenv.mkDerivation rec {
  name = "orjail-${rev}";
  src = fetchFromGitHub {
    owner = "orjail";
    repo = "orjail";
    inherit rev;
    sha256 = "1ymzrlbv8hdvfrv654nccy7by3ixm29qypfmgj7hrd00y3gg0h4l";
  };
  patchPhase = ''
    patchShebangs make-helper.bsh
  '';
  installPhase = ''
    mkdir -p $out/bin
    mv usr/sbin/orjail $out/bin
  '';
  nativeBuildInputs = [ bash ];
}
