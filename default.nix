{ pkgs ? import <nixpkgs> {} }: let
  pkg = x: pkgs.callPackage x {};
in {
  _100r                = pkg ./_100r;
  arcan                = pkg ./arcan;
  butterflow           = pkg ./butterflow;
  caprine              = pkg ./caprine; # TODO caprine-tor
  chkservice           = pkg ./chkservice;
  cinelerra-gg         = pkg ./cinelerra-gg;
  davinci-resolve      = pkg ./davinci-resolve;
  din                  = pkg ./din;
  gamestonk-terminal   = pkg ./gamestonk-terminal;
  gh                   = pkg ./gh;
  gxkb                 = pkg ./gxkb;
  hydra                = pkg ./hydra;
  hydralisque          = pkg ./hydralisque;
  jack_midi_clock      = pkg ./jack_midi_clock;
  ledger-live-desktop  = pkg ./ledger-live-desktop;
  orjail               = pkg ./orjail;
  ossia                = pkg ./ossia;
  pavucontrol-vertical = pkg ./pavucontrol-vertical;
  praxis-live          = pkg ./praxis-live;
  pugmenu              = pkg ./pugmenu;
  reaper               = pkg ./reaper;
  scarlett-mixer       = pkg ./scarlett-mixer;
  standardnotes        = pkg ./standardnotes;
  tor                  = pkg ./tor;
  troop                = pkg ./troop;
  wineasio             = pkg ./wineasio;
}
