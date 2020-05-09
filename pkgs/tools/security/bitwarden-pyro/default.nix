{ stdenv
, fetchFromGitHub
, buildPythonPackage
, rofi
, bitwarden-cli
, keyutils
, libnotify
, slop
, pyyaml
, setuptools

, x11Support ? !stdenv.isDarwin, xclip, xsel, xdotool, wmctrl
, waylandSupport ? false, wl-clipboard, ydotool
}:

buildPythonPackage rec {
  pname = "bitwarden-pyro";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "mihalea";
    repo = "bitwarden-pyro";
    rev = "v${version}";
    sha256 = "10plrlla6b61xv1afnmdammcqwmpdwhda8zlbk1csx5q0y77narp";
  };

  buildInputs = [
    rofi
    bitwarden-cli
    libnotify
    keyutils
    slop
  ] ++ stdenv.lib.optionals x11Support [
    xclip
    xsel
    xdotool
    wmctrl
  ] ++ stdenv.lib.optionals waylandSupport [
    wl-clipboard
    ydotool
  ];

  propagatedBuildInputs = [
    pyyaml
    setuptools
    keyutils
  ];

  meta = with stdenv.lib; {
    description = "Bitwarden python interface built on Rofi, allowing for fast selection and insertion of passwords ";
    homepage = "https://github.com/mihalea/bitwarden-pyro";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ luc65r albakham ];
  };
}
