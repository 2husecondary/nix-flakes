{
  lib,
  pkgs,
  path,
  ...
}:
{
  imports =
    [
      ./_.env.nix
      ### ----------------SERVICES------------------- ###
      ./services/proton.nix
      ./services/easyeffects.nix
      ./services/systemd-utils.nix
      ### ----------------SERVICES------------------- ###
      ### ----------------PROGRAMS------------------- ###
      ./programs/firefox.nix
      ./programs/chromium.nix
      ./programs/flatpak.nix
      (path + /home/shared/programs/discord.nix)
      ### ----------------PROGRAMS------------------- ###
    ]
    ++ lib.flatten [
      (lib.concatLists [
        (import (path + /home/ashuramaruzxc/dev/default.nix))
        (import (path + /home/ashuramaruzxc/cli/default.nix))
      ])
    ];

  home = {
    username = "ashuramaru";
    packages = builtins.attrValues {
      # Multimedia
      inherit (pkgs)
        vlc
        nicotine-plus
        quodlibet-full
        ;
      inherit (pkgs.kdePackages)
        k3b
        kamera
        ktorrent
        ;
      # Graphics & Design
      inherit (pkgs)
        krita # Digital painting
        gimp # Image editing
        inkscape # Vector graphics
        godot3 # Game engine
        obs-studio # Streaming and recording
        blender # 3D creation suite
        ;
      inherit (pkgs.kdePackages)
        kdenlive # Video editing
        ;
      # Productivity
      inherit (pkgs)
        libreoffice-fresh
        anki # Flashcard app
        obsidian
        tenacity # Audio recording/editing
        ;
      # Social & Communication
      inherit (pkgs)
        tdesktop # Telegram desktop
        dino # Jabber client
        signal-desktop # Signal desktop client
        ;
      # Utilities
      inherit (pkgs)
        pavucontrol # PulseAudio volume control
        qpwgraph
        helvum # Jack controls
        feather # monero

        yt-dlp # youtube and whatnot media downloader
        ani-cli # Anime downloader
        thefuck # Correcting previous command
        cdrtools # cd burner CLI
        imgbrd-grabber
        media-downloader
        ;

      # Gaming
      inherit (pkgs.unstable) osu-lazer-bin;
      inherit (pkgs)
        # Utils
        mangohud # Vulkan overlay
        goverlay # Game overlay for Linux

        # Misc
        xemu # Xbox emulator
        np2kai # PC-98 emulator
        bottles # Play On Linux but modern
        flycast # Sega Dreamcast emulator
        prismlauncher # Minecraft launcher

        # Nintendo
        mgba # Game Boy Advance emulator
        dolphin-emu # GameCube and Wii emulator
        cemu # Wii U emulator
        ryujinx # Nintendo Switch emulator

        # PlayStation
        chiaki # PS4 Remote Play
        duckstation # PlayStation 1 emulator
        pcsx2 # PlayStation 2 emulator
        ppsspp # PlayStation Portable emulator
        rpcs3 # PlayStation 3 emulator
        shadps4 # PlayStation 4 emulator

        # Stores
        heroic # Epic Games Store client
        gogdl # GOG Galaxy downloader
        ;

      # File Management & Desktop Enhancements
      cinnamon = pkgs.nemo-with-extensions.override {
        extensions = [
          pkgs.nemo-qml-plugin-dbus
          pkgs.nemo-python
          pkgs.nemo-emblems
          pkgs.nemo-fileroller
          pkgs.folder-color-switcher
        ];
      };

      # Development Tools
      inherit (pkgs) android-studio nixd;
      inherit (pkgs) mono powershell;
      inherit (pkgs) sass deno;
      inherit (pkgs.jetbrains) dataspell datagrip;
      dotnetCorePackages = pkgs.dotnetCorePackages.combinePackages [
        pkgs.dotnetCorePackages.sdk_8_0
        pkgs.dotnetCorePackages.sdk_9_0
      ];
      riderWithPlugins = pkgs.unstable.jetbrains.plugins.addPlugins pkgs.unstable.jetbrains.rider [
        "python-community-edition"
        "nixidea"
        "nix-lsp"
        "csv-editor"
        "ini"
        "better-direnv"
        "catppuccin-icons"
        "catppuccin-theme"
        "rainbow-brackets"
      ];
      clionWithPlugins = pkgs.unstable.jetbrains.plugins.addPlugins pkgs.unstable.jetbrains.clion [
        "ini"
        "rust"
        "nixidea"
        "nix-lsp"
        "csv-editor"
        "better-direnv"
        "catppuccin-icons"
        "catppuccin-theme"
        "rainbow-brackets"
      ];
      ideaUltimateWithPlugins = pkgs.unstable.jetbrains.plugins.addPlugins pkgs.unstable.jetbrains.idea-ultimate [
        "go"
        "ini"
        "rust"
        "python"
        "nixidea"
        "nix-lsp"
        "csv-editor"
        "better-direnv"
        "catppuccin-icons"
        "catppuccin-theme"
        "rainbow-brackets"
      ];
    };
    stateVersion = "24.11";
  };
  programs = {
    rbw = {
      enable = true;
      settings = {
        email = "ashuramaru@tenjin-dk.com";
        base_url = "https://bitwarden.tenjin-dk.com";
        lock_timeout = 600;
        pinentry = pkgs.pinentry-qt;
      };
    };
    mpv = {
      #TODO: write mpv config
      enable = true;
    };
    tmux.enable = true;
    btop.enable = true;
  };
  catppuccin = {
    fcitx5 = {
      enable = true;
      apply = true;
      flavor = "mocha";
    };
    mpv = {
      enable = true;
      flavor = "mocha";
      accent = "rosewater";
    };
    tmux = {
      flavor = "mocha";
      extraConfig = ''
        set -g @catppuccin_status_modules_right "application session user host date_time"
      '';
    };
    btop = {
      enable = true;
      flavor = "mocha";
    };
  };
}
