{ stdenvNoCC
, fetchFromGitHub
, rofi
, bitwarden-cli
, jq

, x11Support ? !stdenvNoCC.isDarwin, xclip, xsel, xdotool
, waylandSupport ? false, wl-clipboard, ydotool
}:

stdenvNoCC.mkDerivation rec {
  pname = "bitwarden-rofi";
  version = "a53cc1e21097c201a56b560b8f634a032330d61b";

  src = fetchFromGitHub {
    owner = "mattydebie";
    repo = "bitwarden-rofi";
    rev = version;
    sha256 = "0cwpc3am9kqn9pxqq8kaqg8150y3bln8a6gzm5nfh61357m55xba";
  };

  buildInputs = [
    rofi
    bitwarden-cli
    jq
  ] ++ stdenvNoCC.lib.optionals x11Support [
    xclip
    xsel
    xdotool
  ] ++ stdenvNoCC.lib.optionals waylandSupport [
    wl-clipboard
    ydotool
  ];

  dontBuild = true;

  postPatch = ''
    sed -i "s|^DIR=.\+$|DIR='$out/lib'|" bwmenu
  '';

  installPhase = ''
    install -Dm755 -t $out/bin bwmenu
    install -Dm644 -t $out/lib lib-bwmenu
  '';

  meta = with stdenvNoCC.lib; {
    description = "Wrapper for Bitwarden and Rofi";
    homepage = "https://github.com/mattydebie/bitwarden-rofi";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ luc65r albakham ];
  };
}
