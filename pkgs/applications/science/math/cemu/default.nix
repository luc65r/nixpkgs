{ stdenv
, fetchFromGitHub
, lib
, SDL2
, libGL
, libarchive
, libusb-compat-0_1
, qtbase
, qmake
, wrapQtAppsHook
, git
, libpng_apng
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "CEmu";
  version = "1.3";
  src = fetchFromGitHub {
    owner = "CE-Programming";
    repo = "CEmu";
    rev = "v${version}";
    sha256 = "1wcdnzcqscawj6jfdj5wwmw9g9vsd6a1rx0rrramakxzf8b7g47r";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
    git
    pkg-config
  ];

  buildInputs = [
    SDL2
    libGL
    libarchive
    libusb-compat-0_1
    qtbase
    libpng_apng
  ];

  qmakeFlags = [
    "gui/qt"
    "CONFIG+=ltcg" # https://github.com/CE-Programming/CEmu/issues/366
  ];

  meta = with lib; {
    changelog = "https://github.com/CE-Programming/CEmu/releases/tag/v${version}";
    description = "Third-party TI-84 Plus CE / TI-83 Premium CE emulator, focused on developer features";
    homepage = "https://ce-programming.github.io/CEmu";
    license = licenses.gpl3;
    maintainers = with maintainers; [ luc65r ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
