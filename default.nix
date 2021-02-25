{ pkgs ? import <nixpkgs> {} }: let
  pkg = x: pkgs.callPackage x {};
in {

  # special (FIXME how are they used?)
  lib      = import ./__lib { inherit pkgs; }; # functions
  modules  = import ./__modules;               # NixOS modules
  overlays = import ./__overlays;              # nixpkgs overlays

  chkservice = pkg ./chkservice;

  # network
  orjail = pkg ./orjail;
  tor    = pkg ./tor;

  # electron
  caprine             = pkg ./caprine; # TODO caprine-tor
  gh                  = pkg ./gh;
  ledger-nano-desktop = pkg ./ledger-nano-desktop;
  standardnotes       = pkg ./standardnotes;

  # gui
  arcan   = pkg ./arcan;
  gxkb    = pkg ./gxkb;
  pugmenu = pkg ./pugmenu;

  # art
  _100r       = pkg ./_100r;
  hydra       = pkg ./hydra;
  ossia       = pkg ./ossia;
  praxis-live = pkg ./praxis-live;
  troop       = pkg ./troop;

  # video
  butterflow      = pkg ./butterflow;
  cinelerra-gg    = pkg ./cinelerra-gg;
  davinci-resolve = pkg ./davinci-resolve;
  hydralisque     = pkg ./hydralisque;

  # audio
  din                  = pkg ./din;
  jack_midi_clock      = pkg ./jack_midi_clock;
  pavucontrol-vertical = pkg ./pavucontrol-vertical;
  reaper               = pkg ./reaper;
  scarlett-mixer       = pkg ./scarlett-mixer;
  wineasio             = pkg ./wineasio;
}
