{ pkgs ? import <nixpkgs> {} }: {

  # special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  _100r      = pkgs.callPackage ./pkgs/_100r      {};
  arcan      = pkgs.callPackage ./pkgs/arcan      {};
  butterflow = pkgs.callPackage ./pkgs/butterflow {};
  caprine    = pkgs.callPackage ./pkgs/caprine    {};
  gxkb       = pkgs.callPackage ./pkgs/gxkb       {};
  orjail     = pkgs.callPackage ./pkgs/orjail     {};
  tor        = pkgs.callPackage ./pkgs/tor        {};
}
