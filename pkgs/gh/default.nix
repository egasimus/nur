{buildGoModule, fetchFromGitHub, ...}: buildGoModule rec {
  pname = "gh";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "10ixjrb56ddqxla7mfxqnf74zissjx66akcyvgl9xfmww0bvg64x";
  };
  modSha256 = "079zbm57xfcskwhsfj1x0c0lg6ip6c6dbk8hfwrzkpy8gfs2ysmr";
  vendorSha256 = "079zbm57xfcskwhsfj1x0c0lg6ip6c6dbk8hfwrzkpy8gfs2ysmr";
  preInstall = ''ls -al cmd/*; mkdir -p $out/bin'';
  #buildPhase = "make";
  subPackages = [ "cmd/gh" ];
}
