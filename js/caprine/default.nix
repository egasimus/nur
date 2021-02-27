{ pkgs
, lib
, git
, yarn
, nodejs-14_x
, electron_10
, runCommand
, ... }: let
  electron      = electron_10;
  mkNodePackage = ((import ../mkNodePackage.nix) {inherit lib runCommand;});
in mkNodePackage rec {
  outputHash = "06wq6w2bxifmsnj87bmky1wmab9zwwf90h7v9xpfrmdi0j9gvr0d";
  name = "caprine-git";
  src = ./caprine;
  buildInputs = [ git yarn electron_10 electron.buildInputs ];
  propagatedBuildInputs = [ electron ];
  entryPoint = ''
    #!/bin/sh
    set -x
    ${electron.out}/bin/electron $(dirname $(realpath $(dirname $0))) $@
  '';
  postInstall = ''
    ${nodejs-14_x}/bin/node node_modules/.bin/tsc
  '';
}

