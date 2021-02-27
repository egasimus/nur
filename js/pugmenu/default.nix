{ lib
, cairo
, dbus
, fetchFromGitHub
, glib
, gobject-introspection
, gtk3
, nodejs-14_x
, pkg-config
, python2
, runCommand
, yarn
}: let

  node       = nodejs-14_x;
  rev        = "9b98f5f";
  sha256     = "0cgz9556y21da2dmf3zcr30p71ba3pkxbrlbbnhl89f44zswg5ry";
  outputHash = "1zk1wm13sbs4jpr9g47yy7aq4vrm198b1psnbw750jlclhj5w2dw";
  mkNodePackage = (import ../mk-node-package.nix) { inherit lib runCommand; };

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
