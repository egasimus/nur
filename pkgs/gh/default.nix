{buildGoModule, fetchFromGitHub, ...}: buildGoModule rec {
  pname = "gh";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "10ixjrb56ddqxla7mfxqnf74zissjx66akcyvgl9xfmww0bvg64x";
  };
  modSha256 = "0mmm6qlj4ml217j97mdv5xx0m56xp5159k7qxn7qxjihv7v4fkkk";
  preInstall = ''ls -al cmd/*; mkdir -p $out/bin'';
  #buildPhase = "make";
  subPackages = [ "cmd/gh" ];
}
