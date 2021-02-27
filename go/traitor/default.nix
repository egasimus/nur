{buildGoModule, fetchFromGitHub, ...}: buildGoModule rec {
  pname   = "traitor";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner  = "liamg";
    repo   = "traitor";
    rev    = "ebe73626219514e80abcb3ce0640e9135fc14993";
    sha256 = "0w8is4kpcfmsnaacqyns48gfw0xbpgd99rxa3alx8rv3k9mghay8";
  };
  #modSha256 = "079zbm57xfcskwhsfj1x0c0lg6ip6c6dbk8hfwrzkpy8gfs20000";
  vendorSha256 = null;#"079zbm57xfcskwhsfj1x0c0lg6ip6c6dbk8hfwrzkpy8gfs2y000";
  preInstall = ''ls -al cmd/*; mkdir -p $out/bin'';
  subPackages = [ "cmd/traitor" ];
}

