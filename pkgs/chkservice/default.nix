{fetchFromGitHub
,stdenv
,cmake
,pkg-config
,systemd
,ncurses
,...}: let
  repo = "chkservice";
  rev = "ea40b14";
in stdenv.mkDerivation {
  name = "${repo}-${rev}";
  src = fetchFromGitHub {
    inherit repo rev;
    owner = "linuxenko";
    sha256 = "1jd1qcaix31vlpl56194gc06dj8rfr90x86wxgxa6sv6chl7yg0x";
  };
  nativeBuildInputs = [cmake pkg-config];
  buildInputs = [systemd ncurses];
}
