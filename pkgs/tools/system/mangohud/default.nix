{ stdenv
, fetchFromGitHub
, meson
, ninja
, python3
, cmake
, pkgconfig
, git
, libX11
, glslang
, libglvnd
, vulkan-headers

, wayland ? false
, x11 ? true
}:

stdenv.mkDerivation rec {
  pname = "MangoHud";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "flightlessmango";
    repo = pname;
    # rev = "v${version}";
    rev = "634adb4b3e1b683804faad90840f20cf4829ee32";
    fetchSubmodules = true;
    sha256 = "0afdmzsqji8f4v1w30dar7bcw5hzzh2yhbgl6amivkw0ckri5myh";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkgconfig
    git
  ];

  buildInputs = [
    glslang
    libglvnd
    vulkan-headers
    libX11
    (python3.withPackages (pp: with pp; [ Mako ]))
  ];

  postPatch = ''
    patchShebangs .
    ln -sv ${vulkan-headers}/include/vulkan modules/Vulkan-Headers
    ln -sv ${vulkan-headers}/share/vulkan/registry/vk.xml modules/Vulkan-Headers
    echo true > modules/Vulkan-Headers/clone_headers.sh
  '';

  buildPhase = ''
    ./build.sh build
  '';

  configurePhase = ''
    ./build.sh configure
  '';

  installPhase = ''
    install -vm644 -D ./build/release/usr/lib/mangohud/lib32/libMangoHud.so $out/lib/mangohud/lib32/libMangoHud.so
    install -vm644 -D ./build/release/usr/lib/mangohud/lib64/libMangoHud.so $out/lib/mangohud/lib64/libMangoHud.so
    install -vm644 -D ./build/release/usr/share/vulkan/implicit_layer.d/MangoHud.x86.json $out/share/vulkan/implicit_layer.d/MangoHud.x86.json
    install -vm644 -D ./build/release/usr/share/vulkan/implicit_layer.d/MangoHud.x86_64.json $out/share/vulkan/implicit_layer.d/MangoHud.x86_64.json
    install -vm644 -D ./build/release/usr/share/doc/mangohud/MangoHud.conf.example $out/share/doc/mangohud/MangoHud.conf.example
    install -vm755 ./build/release/usr/bin/mangohud.x86 $out/bin/mangohud.x86
    install -vm755 ./build/release/usr/bin/mangohud $out/bin/mangohud
  '';

  meta = with stdenv.lib; {
    changelog = "https://github.com/flightlessmango/MangoHud/releases/tag/v${version}";
    description = "A Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more.";
    homepage = "https://github.com/flightlessmango/MangoHud";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ luc65r ];
  };
}
