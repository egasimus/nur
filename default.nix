{ pkgs ? import <nixpkgs> {} }: {

  # special
  lib      = import ./lib { inherit pkgs; }; # functions
  modules  = import ./modules;               # NixOS modules
  overlays = import ./overlays;              # nixpkgs overlays

  _100r           = pkgs.callPackage ./pkgs/_100r           {};
  arcan           = pkgs.callPackage ./pkgs/arcan           {};
  butterflow      = pkgs.callPackage ./pkgs/butterflow      {};
  caprine         = pkgs.callPackage ./pkgs/caprine         {};
  davinci-resolve = pkgs.callPackage ./pkgs/davinci-resolve {};
  din             = pkgs.callPackage ./pkgs/din             {};
  gh              = pkgs.callPackage ./pkgs/gh              {};
  gxkb            = pkgs.callPackage ./pkgs/gxkb            {};
  hydra           = pkgs.callPackage ./pkgs/hydra           {};
  orjail          = pkgs.callPackage ./pkgs/orjail          {};
  ossia           = pkgs.callPackage ./pkgs/ossia           {};
  praxis-live     = pkgs.callPackage ./pkgs/praxis-live     {};
  reaper          = pkgs.callPackage ./pkgs/reaper          {};
  tor             = pkgs.callPackage ./pkgs/tor             {};
  wineasio        = pkgs.callPackage ./pkgs/wineasio        {};
}
