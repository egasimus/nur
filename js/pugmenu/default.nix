{ lib
, cairo
, dbus
, fetchFromGitHub
, glib
, gobject-introspection
, gtk3
, nodejs-12_x
, pkg-config
, python2
, runCommand
, yarn
}: let

  node       = nodejs-12_x;
  rev        = "9b98f5f";
  sha256     = "0cgz9556y21da2dmf3zcr30p71ba3pkxbrlbbnhl89f44zswg5ry";
  outputHash = "1q3nkfng7zbxgl5khflcfdd559ch79rdy4pdc6d9jmz20xglv171";
  mkNodePackage = (import ../mkNodePackage.nix) { inherit lib runCommand; };

in mkNodePackage {

  name = "pugmenu";
  meta = {
    description = "tray icon, configurable with Pug";
    homepage = "https://github.com/egasimus/hydralisque";
    license = lib.licenses.gpl3Only;
  };
  src = fetchFromGitHub {
    owner = "egasimus";
    repo  = "pugmenu";
    inherit rev sha256;
  };
  inherit outputHash;
  entryPoint = ''
    #!/bin/sh
    yarn versions
    pushd $(dirname $(dirname $0))
    ${node.out}/bin/node pugmenu $@
  '';

  buildInputs = [
    cairo
    dbus
    glib
    gobject-introspection
    gtk3
    node
    pkg-config
    python2
    yarn
  ];
  #LD_LIBRARY_PATH = lib.strings.makeLibraryPath [
    #gtk3
    #gobject-introspection
    #glib
    #cairo
    #dbus
  #];
  #preConfigure = "ls -al";
}
