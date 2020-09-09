{ lib, newScope, stdenv, pkgs, callPackage }: let

  electronHelpers = import ../electron-helpers.nix;

in lib.makeScope newScope (self: {

  dotgrid = callPackage ({ pkgs, stdenv, electron_8 }: let
    electron = electron_8;
    rev      = "e848fa0e4f5f4826a5b03085106bb37f1e97735b";
    sha256   = "1gqx1pbmz2qf2gi98aaifbgw4lksy7yykxnfz3j90zqv9l11dgh6";
  in stdenv.mkDerivation {
    name = "dotgrid-${rev}";
    src = pkgs.fetchFromGitHub {
      owner = "hundredrabbits";
      repo = "Dotgrid";
      inherit rev sha256;
    };
    buildInputs = [ electron ];
    phases      = [ "buildPhase" ];
    buildPhase  = electronHelpers.wrapHTML electron "dotgrid" ./Dotgrid.main.js;
  }) {};

  ronin = callPackage ({ pkgs, stdenv, electron_8 }: let
    electron = electron_8;
    rev      = "e375668143f8f12b98fa81e3efe7bccae78ce432";
    sha256   = "19mh62fbs2rryrch32cb1jnwckzd731w4131qb921qwz949ygiqf";
  in stdenv.mkDerivation {
    name = "ronin-${rev}";
    src = pkgs.fetchFromGitHub {
      owner = "hundredrabbits";
      repo = "Ronin";
      inherit rev sha256;
    };
    buildInputs = [ electron ];
    phases      = [ "buildPhase" ];
    buildPhase  = electronHelpers.wrapHTML electron "ronin" ./Ronin.main.js;
  }) {};

  left = callPackage ({ pkgs, stdenv, electron_7, mkYarnPackage }: let
    electron = electron_7;
    rev      = "f944beea8791c0dcb551f7c61a66b9a1ccefbbe6";
    sha256   = "1y6xan6k68fdmp95caar75phf8qi9pd2g3ja1608vh6bi8la2yc3";
  in mkYarnPackage rec {
    name = "left-${rev}";
    src = pkgs.fetchFromGitHub {
      owner = "hundredrabbits";
      repo = "Left";
      inherit rev sha256;
    };
    packageJSON  = ./Left.package.json;
    yarnLock     = ./Left.yarn.lock;
    buildInputs  = [ electron ];
    pname        = "Left";
    installPhase = electronHelpers.subdirInstallPhase pname;
    distPhase    = electronHelpers.subdirDistPhase electron pname "left";
  }) {};

  orca = callPackage ({ pkgs, stdenv, electron_8, mkYarnPackage }: let
    electron = electron_8;
    rev      = "d469077";
    sha256   = "0gj78akn0yi9mvg08gi3761bh0dh38bvd5fs7kz35vp8w9szb04s";
  in mkYarnPackage rec {
    name = "orca-${rev}";
    src = pkgs.fetchFromGitHub {
      owner = "hundredrabbits";
      repo = "Orca";
      inherit rev sha256;
    };
    packageJSON  = src + "/desktop/package.json";
    yarnLock     = ./Orca.yarn.lock;
    buildInputs  = [ electron ];
    pname        = "Orca";
    installPhase = electronHelpers.subdirInstallPhase pname;
    distPhase    = electronHelpers.subdirDistPhase electron pname "orca-osc";
  }) {};

  marabu = callPackage ({ pkgs, stdenv, electron, mkYarnPackage }: let
    rev      = "e22e203d97af2347c7130e7c4a9c62d4067d5a5a";
    sha256   = "1ynbz269i0hnd35q9jf36kq10lkr294x8719nq0m0f8wd6b5hhcv";
  in mkYarnPackage rec {
    name = "marabu-${rev}";
    src  = pkgs.fetchFromGitHub {
      owner = "hundredrabbits";
      repo  = "Marabu";
      inherit rev sha256;
    };
    packageJSON  = ./Marabu.package.json;
    yarnLock     = ./Marabu.yarn.lock;
    buildInputs  = [ electron ];
    pname        = "Marabu";
    installPhase = electronHelpers.subdirInstallPhase pname;
    distPhase    = electronHelpers.subdirDistPhase electron pname "marabu";
  }) {};

  pilot = callPackage ({ pkgs, stdenv, electron_5, mkYarnPackage }: let
    electron = electron_5;
    rev      = "3a2afc0ca9d9d09b008de1410b7f08cad92036c6";
    sha256   = "1pd1zgsyfh83lvwnzmn4krnrp0m54aw10253ckjpqkz8j8va84j3";
  in mkYarnPackage rec {
    name = "pilot-${rev}";
    src = pkgs.fetchFromGitHub {
      owner = "hundredrabbits";
      repo  = "Pilot";
      inherit rev sha256;
    };
    packageJSON  = ./Pilot.package.json;
    yarnLock     = ./Pilot.yarn.lock;
    buildInputs  = [ electron ];
    pname        = "Pilot";
    installPhase = electronHelpers.subdirInstallPhase pname;
    distPhase    = electronHelpers.subdirDistPhase electron pname "pilot-osc";
  }) {};
    
})
