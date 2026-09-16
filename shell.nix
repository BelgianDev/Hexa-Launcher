{ pkgs ? import <nixpkgs> {} }:

let
  runtimeLibs = with pkgs; [ # Required for Minecraft
    (lib.getLib stdenv.cc.cc)
    glfw3-minecraft
    openal
    alsa-lib
    libjack2
    libpulseaudio
    pipewire
    libGL
    libX11
    libXcursor
    libXext
    libXrandr
    libXxf86vm
    udev
    vulkan-loader
  ];
in
pkgs.mkShell {
  name = "minecraft-electron-shell";

  buildInputs = with pkgs; [
    nodejs_22
    electron
    openjdk17
  ] ++ runtimeLibs;

  shellHook = ''
    # Make all native libraries visible at runtime
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath runtimeLibs}

    # Electron setup
    export PATH="${pkgs.electron}/bin:$PATH"
    export ELECTRON_SKIP_BINARY_DOWNLOAD=1
    export ELECTRON_PATH="${pkgs.electron}/libexec/electron/electron"
 
    echo "NPM will fail to resolve the electron path, instead use \"run\" to start the launcher"
    alias run="electron ."
  '';
}
