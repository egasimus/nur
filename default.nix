{ pkgs ? import <nixpkgs> {} }: let
  pkg = x: pkgs.callPackage x {};
in {
  davinci-resolve     = pkg ./bin/davinci-resolve;
  ledger-live-desktop = pkg ./bin/ledger-live-desktop;
  standardnotes       = pkg ./bin/standardnotes;
  reaper              = pkg ./bin/reaper;

  _100r               = pkg ./js/_100r;
  caprine             = pkg ./js/caprine; # TODO caprine-tor
  hydralisque         = pkg ./js/hydralisque;
  pugmenu             = pkg ./js/pugmenu;

  arcan                = pkg ./c/arcan;
  butterflow           = pkg ./c/butterflow;
  chkservice           = pkg ./c/chkservice;
  cinelerra-gg         = pkg ./c/cinelerra-gg;
  din                  = pkg ./c/din;
  gxkb                 = pkg ./c/gxkb;
  jack_midi_clock      = pkg ./c/jack_midi_clock;
  orjail               = pkg ./c/orjail;
  ossia                = pkg ./c/ossia;
  pavucontrol-vertical = pkg ./c/pavucontrol-vertical;
  scarlett-mixer       = pkg ./c/scarlett-mixer;
  tor                  = pkg ./c/tor;
  wineasio             = pkg ./c/wineasio;

  gamestonk-terminal = pkg ./py/gamestonk-terminal;
  troop              = pkg ./py/troop;

  gh      = pkg ./go/gh;
  traitor = pkg ./go/traitor;

  praxis-live = pkg ./java/praxis-live;

}
