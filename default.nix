{ pkgs ? import <nixpkgs> {} }: let
  pkg = x: pkgs.callPackage x {};
in {

  # special
  lib      = import ./__lib { inherit pkgs; }; # functions
  modules  = import ./__modules;               # NixOS modules
  overlays = import ./__overlays;              # nixpkgs overlays

  chkservice           = pkg ./chkservice;

  # clients
  caprine              = pkg ./caprine;
  gh                   = pkg ./gh;

  # gui
  arcan                = pkg ./arcan;
  gxkb                 = pkg ./gxkb;
  pugmenu              = pkg ./pugmenu;

  # network
  orjail               = pkg ./orjail;
  tor                  = pkg ./tor;

  # art
  _100r                = pkg ./_100r;
  hydra                = pkg ./hydra;
  ossia                = pkg ./ossia;
  praxis-live          = pkg ./praxis-live;
  troop                = pkg ./troop;

  # video
  butterflow           = pkg ./butterflow;
  cinelerra-gg         = pkg ./cinelerra-gg;
  #davinci-resolve      = pkg ./davinci-resolve;

  # audio
  din                  = pkg ./din;
  jack_midi_clock      = pkg ./jack_midi_clock;
  pavucontrol-vertical = pkg ./pavucontrol-vertical;
  reaper               = pkg ./reaper;
  scarlett-mixer       = pkg ./scarlett-mixer;
  wineasio             = pkg ./wineasio;
}
