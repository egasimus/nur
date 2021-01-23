# downloader based on https://github.com/NixOS/nixpkgs/issues/94032#issuecomment-733637809
# which is itself based on https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=davinci-resolve
# repackager based on https://www.danieltufvesson.com/makeresolvedeb

{ appimageTools
, autoPatchelfHook
, bash
, callPackage
, dpkg
, e2fsprogs
, fakeroot
, fetchurl
, fuse
, glib
, glibc
, kmod
, lib
, pkgs
, runCommand
, stdenv
, strace
, targetPlatform
, utillinux
, vmTools
, xorriso
, zlib
}: let

  rpath = stdenv.lib.makeLibraryPath [ fuse glib glibc zlib ];

  pname = "davinci-resolve";
  version = "16.2.7-1";

  installer = let
    name = "${pname}-${version}-src";
    context = rec {
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "1bbj7ahz5gzcj5sh1a57a5xajbzyq6q71rahi49w3vwpk46bq3sw";
      impureEnvVars = lib.fetchers.proxyImpureEnvVars;
      nativeBuildInputs = with pkgs; [ curl gnused unzip ];

      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      DOWNLOADID = "9b15a70f5ce1418686be3479612f1134";
      REFERID = "b86a2a4c7a3b4ebfafcc6765f7e3d3a5";
      SITEURL = "https://www.blackmagicdesign.com/api/register/us/download/${DOWNLOADID}";
      USERAGENT = builtins.concatStringsSep " " [
        "User-Agent: Mozilla/5.0 (X11; Linux ${targetPlatform.platform.kernelArch})"
                    "AppleWebKit/537.36 (KHTML, like Gecko)"
                    "Chrome/77.0.3865.75"
                    "Safari/537.36" ];
      REQJSON = ''{ 
         "firstname": "Arch", 
         "lastname": "Linux", 
         "email": "someone@archlinux.org", 
         "phone": "202-555-0194", 
         "country": "us", 
         "state": "New York", 
         "city": "AUR", 
         "product": "DaVinci Resolve" 
      }'';
    };
  in runCommand name context ''
    REQJSON="$(  printf '%s' "$REQJSON"   | sed 's/[[:space:]]\+/ /g')"
    USERAGENT="$(printf '%s' "$USERAGENT" | sed 's/[[:space:]]\+/ /g')"
    RESOLVEURL=$(curl \
         -s \
         -H 'Host: www.blackmagicdesign.com' \
         -H 'Accept: application/json, text/plain, */*' \
         -H 'Origin: https://www.blackmagicdesign.com' \
         -H "$USERAGENT" \
         -H 'Content-Type: application/json;charset=UTF-8' \
         -H "Referer: https://www.blackmagicdesign.com/support/download/$REFERID/Linux" \
         -H 'Accept-Encoding: gzip, deflate, br' \
         -H 'Accept-Language: en-US,en;q=0.9' \
         -H 'Authority: www.blackmagicdesign.com' \
         -H 'Cookie: _ga=GA1.2.1849503966.1518103294; _gid=GA1.2.953840595.1518103294' \
         --data-ascii "$REQJSON" \
         --compressed \
         "$SITEURL")
    curl --retry 3 --retry-delay 3 \
         -H "Host: sw.blackmagicdesign.com" \
         -H "Upgrade-Insecure-Requests: 1" \
         -H "$USERAGENT" \
         -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" \
         -H "Accept-Language: en-US,en;q=0.9" \
         --compressed \
         "$RESOLVEURL" \
         > resolve.zip
    mkdir -p $out
    unzip resolve.zip -d $out
    rm resolve.zip
  '';

  unpacked = let
    name = "${pname}-${version}-unpacked";
    context = {
      nativeBuildInputs = [ bash fakeroot dpkg strace xorriso ];
    };
    script = ''
      mkdir -p $out
      cd $out
      xorriso -osirrox on -indev ${installer}/DaVinci_Resolve_16.2.7_Linux.run -extract / .
      ls -al
    '';
  in runCommand name context script;

  #makeresolvedeb = (callPackage ../makeresolvedeb/default.nix {});

in stdenv.mkDerivation {

  meta = {
    broken = true;
    license.free = false;
  };

  name = "${pname}-${version}";
  src = unpacked;
  nativeBuildInputs = [ e2fsprogs strace ];
  phases = [ "installPhase" ];
  installPhase = ''
    function copy () { cp -rv --no-preserve=all "$@"; }
    function fixld () { patchelf --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 "$1"; }

    mkdir -pv $out

    mkdir -pv $out/opt/resolve/
    copy $src/bin $out/opt/resolve/
    fixld $out/opt/resolve/bin/resolve

    copy $src/Control                         $out/opt/resolve/
    copy $src/DaVinci\ Resolve\ Panels\ Setup $out/opt/resolve/
    copy $src/Developer                       $out/opt/resolve/
    copy $src/docs                            $out/opt/resolve/
    copy $src/Fusion                          $out/opt/resolve/
    copy $src/graphics                        $out/opt/resolve/
    copy $src/libs                            $out/opt/resolve/
    copy $src/LUT                             $out/opt/resolve/
    copy $src/Onboarding                      $out/opt/resolve/
    copy $src/plugins                         $out/opt/resolve/
    copy $src/UI_Resource                     $out/opt/resolve/

    mkdir -pv $out/opt/resolve/easyDCP

    mkdir -pv $out/opt/resolve/.license

    mkdir -pv $out/opt/resolve/Fairlight

    mkdir -pv $out/opt/resolve/scripts
    cd $src/scripts
    cp -rv script.checkfirmware $out/opt/resolve/scripts/
    cp -rv script.getlogs.v4    $out/opt/resolve/scripts/
    cp -rv script.start         $out/opt/resolve/scripts/

    mkdir -pv $out/opt/resolve/share
    cd $src/share
    cp -rv default-config.dat    $out/opt/resolve/share/
    cp -rv log-conf.xml          $out/opt/resolve/share/
    cp -rv default_cm_config.bin $out/opt/resolve/share/

    mkdir -pv $out/lib
    cd $src/share/panels
    tar -zxvf dvpanel-framework-linux-x86_64.tgz -C $out/lib libDaVinciPanelAPI.so

    mkdir -pv $out/bin/BlackmagicRawAPI
    #ln -sv $out/opt/resolve/libs/libBlackmagicRawAPI.so $out/opt/resolve/bin/libBlackmagicRawAPI.so
    #ln -sv $out/opt/resolve/libs/libBlackmagicRawAPI.so $out/opt/resolve/bin/BlackmagicRawAPI/libBlackmagicRawAPI.so

    mkdir -pv "$out/var/BlackmagicDesign/DaVinci Resolve"
  '';
  
  #installPhase = let
    #name = "${pname}-extract";
  #in vmTools.runInLinuxVM (runCommand name {
    #memSize = 2048;
    #nativeBuildInputs = [ pkgs.gnome3.zenity utillinux kmod strace ];
    #buildInputs = [ fuse glib glibc zlib ];
  #} ''
    #cd ${src}
    #echo foo
    #ls -al
    #echo '${rpath}'
    ##autoPatchelf ./DaVinci_Resolve_16.2.7_Linux.run
    ##patchelf --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 ./DaVinci_Resolve_16.2.7_Linux.run
    ##patchelf --print-interpreter ./DaVinci_Resolve_16.2.7_Linux.run
    ##patchelf --set-rpath ${rpath} ./DaVinci_Resolve_16.2.7_Linux.run
    ##patchelf --print-rpath ./DaVinci_Resolve_16.2.7_Linux.run
    ##unshare -m -r
    #modprobe fuse
    #mount
    #ls /tmp
    #pwd
    #ls `pwd`
    #whoami
    #./DaVinci_Resolve_16.2.7_Linux.run
    #ls -al /tmp
    #exit 123
	#'');
}
