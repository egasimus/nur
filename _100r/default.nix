{ lib
, newScope
, stdenv
, electron_8
, electron_7
, electron_6
, mkYarnPackage
, callPackage
, pkgs
}: let
  EH  = import ../electronHelpers.nix;
  pkg = x: callPackage ({}: stdenv.mkDerivation x) {};
in lib.makeScope
  newScope
  (self:
    (let electron = electron_8; in {
      dotgrid = pkg {
        name        = "100r-dotgrid-git";
        src         = ./Dotgrid;
        buildInputs = [ electron ];
        phases      = [ "buildPhase" ];
        buildPhase  = EH.wrapHTML electron "100r-dotgrid" ./Dotgrid.main.js;
      };
      ronin = pkg {
        name        = "100r-ronin-git";
        src         = ./Ronin;
        buildInputs = [ electron ];
        phases      = [ "buildPhase" ];
        buildPhase  = EH.wrapHTML electron "100r-ronin" ./Ronin.main.js;
      };
      orca = pkg rec {
        name         = "100r-orca-git";
        src          = ./Orca;
        packageJSON  = ./Orca/desktop/package.json;
        yarnLock     = ./Orca.yarn.lock;
        buildInputs  = [ electron ];
        pname        = "Orca";
        installPhase = EH.subdirInstallPhase pname;
        distPhase    = EH.subdirDistPhase electron pname "100r-orca";
      };
    }) // (let electron = electron_7; in {
      left = pkg rec {
        name         = "100r-left-git";
        src          = ./Left;
        packageJSON  = ./Left.package.json;
        yarnLock     = ./Left.yarn.lock;
        buildInputs  = [ electron ];
        pname        = "Left";
        installPhase = EH.subdirInstallPhase pname;
        distPhase    = EH.subdirDistPhase electron pname "100r-left";
      };
      marabu = pkg rec {
        name         = "100r-marabu-git";
        src          = ./Marabu;
        packageJSON  = ./Marabu.package.json;
        yarnLock     = ./Marabu.yarn.lock;
        buildInputs  = [ electron ];
        pname        = "Marabu";
        installPhase = EH.subdirInstallPhase pname;
        distPhase    = EH.subdirDistPhase electron pname "100r-marabu";
      };
    }) // (let electron = electron_6; in {
      pilot = pkg rec {
        name         = "100r-pilot-git";
        src          = ./Pilot;
        packageJSON  = ./Pilot.package.json;
        yarnLock     = ./Pilot.yarn.lock;
        buildInputs  = [ electron ];
        pname        = "Pilot";
        installPhase = EH.subdirInstallPhase pname;
        distPhase    = EH.subdirDistPhase electron pname "100r-pilot";
      };
    })
  )
