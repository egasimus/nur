{ pkgs, fetchurl, appimageTools }: appimageTools.wrapType2 {
  name = "ossia";
  src = fetchurl {
    url    = https://github.com/ossia/score/releases/download/v3.0.0-alpha8/Score.AppImage;
    sha256 = "0js4aaqadmja44fz24ajs1rb1fp9fzliv6yynkb8xalxlxbh2rbp";
  };
  extraPkgs = pkgs: with pkgs; [ xorg.libXau ];
}
