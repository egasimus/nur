{ stdenv, libXScrnSaver, makeWrapper, fetchurl, wrapGAppsHook, glib, gtk3
, unzip, atomEnv, libuuid, at-spi2-atk, at-spi2-core, libdrm, mesa }@args:
let
  mkElectron = import ./Electron.nix args;
in mkElectron "9.0.2" {
	x86_64-linux = "08326f505692010d6c92f444a25f450cf19323cd98c5d94cab1057e80601caa1";
	x86_64-darwin = "8ab5b48f873582a9231bc85b0f73d9735fabca51364b8c505da8f8238d658da5";
	i686-linux = "2e950e4ab91453f7611fcfedbe90eff844677dbcc7df87a6fe0889bd3d82daaa";
	armv7l-linux = "cc098caebbed5022f26d12f9b5dc316a35dbae0bcf62b9fc72c3b385f93a32d5";
	aarch64-linux = "ee39854d8e9ee06e9b94c457a52b0556f570316bbd755d7022e3eade4b5974d5";
}
