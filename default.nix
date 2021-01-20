{ pkgs ? import <nixpkgs> {} }: let
  pkg = x: pkgs.callPackage x {};
in {

  # special
  lib      = import ./__lib { inherit pkgs; }; # functions
  modules  = import ./__modules;               # NixOS modules
  overlays = import ./__overlays;              # nixpkgs overlays

  # programs
  _100r                = pkg ./_100r;
  arcan                = pkg ./arcan;
  butterflow           = pkg ./butterflow;
  caprine              = pkg ./caprine;
  chkservice           = pkg ./chkservice;
  cinelerra-gg         = pkg ./cinelerra-gg;
  #davinci-resolve      = pkg ./davinci-resolve;
  din                  = pkg ./din;
  gh                   = pkg ./gh;
  gxkb                 = pkg ./gxkb;
  hydra                = pkg ./hydra;
  jack_midi_clock      = pkg ./jack_midi_clock;
  orjail               = pkg ./orjail;
  ossia                = pkg ./ossia;
  pavucontrol-vertical = pkg ./pavucontrol-vertical;
  praxis-live          = pkg ./praxis-live;
  pugmenu              = pkg ./pugmenu;
  reaper               = pkg ./reaper;
  scarlett-mixer       = pkg ./scarlett-mixer;
  tor                  = pkg ./tor;
  troop                = pkg ./troop;
  wineasio             = pkg ./wineasio;
}
