{ lib, newScope, stdenv, pkgs, callPackage }: let
  EH = import ../EH.nix;
in lib.makeScope
  newScope
  (self:
    (let electron = electron_8; in {
      dotgrid = callPackage ({ pkgs, stdenv, electron_8 }: stdenv.mkDerivation {
        name        = "100r-dotgrid-git";
        src         = ./Dotgrid;
        buildInputs = [ electron ];
        phases      = [ "buildPhase" ];
        buildPhase  = EH.wrapHTML electron "dotgrid" ./Dotgrid.main.js;
      }) {};
      ronin = callPackage ({ pkgs, stdenv, electron_8 }: stdenv.mkDerivation {
        name        = "100r-ronin-git";
        src         = ./Ronin;
        buildInputs = [ electron ];
        phases      = [ "buildPhase" ];
        buildPhase  = EH.wrapHTML electron "ronin" ./Ronin.main.js;
      }) {};
      orca = callPackage ({ pkgs, stdenv, electron_8, mkYarnPackage }: mkYarnPackage rec {
        name         = "100r-orca-git";
        src          = ./Orca;
        packageJSON  = ./Orca/desktop/package.json;
        yarnLock     = ./Orca.yarn.lock;
        buildInputs  = [ electron ];
        pname        = "Orca";
        installPhase = EH.subdirInstallPhase pname;
        distPhase    = EH.subdirDistPhase electron pname "orca-osc";
      }) {};
    }) // (let electron = electron_7; in {
      left = callPackage ({ pkgs, stdenv, electron_7, mkYarnPackage }: mkYarnPackage rec {
        name         = "100r-left-git";
        src          = ./Left;
        packageJSON  = ./Left.package.json;
        yarnLock     = ./Left.yarn.lock;
        buildInputs  = [ electron ];
        pname        = "Left";
        installPhase = EH.subdirInstallPhase pname;
        distPhase    = EH.subdirDistPhase electron pname "left";
      }) {};
      marabu = callPackage ({ pkgs, stdenv, electron, mkYarnPackage }: mkYarnPackage rec {
        name         = "100r-marabu-git";
        src          = ./Marabu;
        packageJSON  = ./Marabu.package.json;
        yarnLock     = ./Marabu.yarn.lock;
        buildInputs  = [ electron ];
        pname        = "Marabu";
        installPhase = EH.subdirInstallPhase pname;
        distPhase    = EH.subdirDistPhase electron pname "marabu";
      }) {};
    }) // (let electron = electron_6; in {
      pilot = callPackage ({ pkgs, stdenv, electron_6, mkYarnPackage }: mkYarnPackage rec {
        name         = "100r-pilot-git";
        src          = ./Pilot;
        packageJSON  = ./Pilot.package.json;
        yarnLock     = ./Pilot.yarn.lock;
        buildInputs  = [ electron ];
        pname        = "Pilot";
        installPhase = EH.subdirInstallPhase pname;
        distPhase    = EH.subdirDistPhase electron pname "pilot-osc";
      }) {};
    })
  )
