{ inputs, pkgs, ... }:
let
  gamePkgs = inputs.nix-gaming.packages.${pkgs.system};
  tenjinPkgs = inputs.meanvoid-overlay.packages.${pkgs.system};
  ipc = gamePkgs.wine-discord-ipc-bridge;
in
{
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs =
        pkgs:
        (with pkgs; [
          yad
          gnome.zenity
          xorg.xhost
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          curl
          imagemagick
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
          libgdiplus
          glxinfo
          mesa-demos
          vulkan-tools
          vulkan-headers
          vulkan-caps-viewer
          vulkan-validation-layers
          vulkan-extension-layer
          vulkan-loader
          vkBasalt
          mangohud
          steamtinkerlaunch
        ])
        ++ (with gamePkgs; [ wine-discord-ipc-bridge ]);
    };
  };
  environment.systemPackages =
    (with pkgs; [
      winetricks
      scummvm
      inotify-tools
    ])
    ++ (with pkgs.wineWowPackages; [
      stagingFull
      waylandFull
    ])
    ++ (with tenjinPkgs; [ thcrap-proton ])
    ++ (with gamePkgs; [ wine-discord-ipc-bridge ]);

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [ gamePkgs.proton-ge ];
    };
    gamemode = {
      enable = true;
      enableRenice = true;
      settings.custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
  environment.sessionVariables = rec {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = [ "\${HOME}/.steam/root/compatibilitytools.d:${gamePkgs.proton-ge}" ];
  };
}
