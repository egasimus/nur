{cairo
,dbus
,fetchFromGitHub
,glib
,gobject-introspection
,gtk3
,lib
,mkYarnPackage
,nodePackages
,nodejs-10_x
,pkg-config
,python2
,...}: let
  rev    = "9b98f5f";
  sha256 = "0cgz9556y21da2dmf3zcr30p71ba3pkxbrlbbnhl89f44zswg5ry";
in mkYarnPackage {

  meta = {
    broken = true;
  };

  name = "pugmenu-${rev}";
  src = fetchFromGitHub {
    owner = "egasimus";
    repo  = "pugmenu";
    inherit rev sha256;
  };
  nativeBuildInputs = [python2 pkg-config nodePackages.npm];
  buildInputs = [gtk3 gobject-introspection glib cairo dbus];
  propagatedBuildInputs = [nodejs-10_x];
  LD_LIBRARY_PATH = lib.strings.makeLibraryPath [
    gtk3
    gobject-introspection
    glib
    cairo
    dbus
  ];
  preConfigure = "ls -al";
}
