{ pkgs ? import <nixpkgs> {} }: let
  pkg = x: pkgs.callPackage x {};
in {

  # special
  lib      = import ./lib { inherit pkgs; }; # functions
  modules  = import ./modules;               # NixOS modules
  overlays = import ./overlays;              # nixpkgs overlays

  _100r                = pkg ./pkgs/_100r;
  arcan                = pkg ./pkgs/arcan;
  butterflow           = pkg ./pkgs/butterflow;
  caprine              = pkg ./pkgs/caprine;
  davinci-resolve      = pkg ./pkgs/davinci-resolve;
  din                  = pkg ./pkgs/din;
  gh                   = pkg ./pkgs/gh;
  gxkb                 = pkg ./pkgs/gxkb;
  hydra                = pkg ./pkgs/hydra;
  jack_midi_clock      = pkg ./pkgs/jack_midi_clock;
  orjail               = pkg ./pkgs/orjail;
  ossia                = pkg ./pkgs/ossia;
  pavucontrol-vertical = pkg ./pkgs/pavucontrol-vertical;
  praxis-live          = pkg ./pkgs/praxis-live;
  reaper               = pkg ./pkgs/reaper;
  tor                  = pkg ./pkgs/tor;
  troop                = pkg ./pkgs/troop;
  wineasio             = pkg ./pkgs/wineasio;
}
