{ lib
, stdenv
, fetchFromGitHub
, runCommand
, electron_11
, nodejs-14_x
, pkg-config
, xlibs
, yarn

}: let SHA256 = {

  # git pointer. update this to build the next upstream version.
  commit   = "e730d7af04c28cff628e7074d49226d22e363e19";

  # changes in this indicate changes to the checkout process
  checkout = "0zwlrxymjpgpydgy4mg29ydvcjjvr2gzb37igyjvmymr0v0h9vgx";

  # changes in this indicate changes to the build output
  output   = "0m4xvzda969zkdca724qx3zqb56n5w59q89lm9lwvhfs6mzrxc6r";

}; in ((import ../mkNodePackage.nix) {inherit lib runCommand;}) {
  outputHash = SHA256.output;
  name = "hydralisque-git";
  meta = {
    description = "video masher based on Olivia Jack's Hydra";
    homepage = "https://github.com/egasimus/hydralisque";
    license = lib.licenses.agpl3Only;
  };
  src = fetchFromGitHub {
    owner  = "egasimus";
    repo   = "hydralisque";
    rev    = SHA256.commit;
    sha256 = SHA256.checkout;
  };
  entryPoint = ''
    #!/bin/sh
    pushd $(dirname $(dirname $0))
    ${electron_11.out}/bin/electron @hydralisque/electron/app.js $@
  '';
  buildInputs = [
    electron_11
    electron_11.buildInputs
    nodejs-14_x
    pkg-config
    xlibs.libX11
    xlibs.libXext
    xlibs.libXi
    yarn
  ];
  propagatedBuildInputs = [
    electron_11
  ];
}
