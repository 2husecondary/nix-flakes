{
  inputs,
  lib,
  pkgs,
  config,
  path,
  ...
}:
{
  services.gnome = {
    sushi.enable = true;
    tinysparql.enable = true;
    localsearch.enable = true;
    at-spi2-core.enable = true;
    gnome-keyring.enable = true;
    core-utilities.enable = true;
    glib-networking.enable = true;
    core-developer-tools.enable = true;
    gnome-remote-desktop.enable = true;
    gnome-settings-daemon.enable = true;
    gnome-online-accounts.enable = true;
    gnome-browser-connector.enable = true;
  };
  services.sysprof.enable = true;
  programs.ssh = {
    startAgent = true;
    askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
  };
  # services.xserver = {
  services.xserver.displayManager.gdm = {
    enable = true;
    autoSuspend = true;
  };
  services.xserver.desktopManager.gnome.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.displayManager.defaultSession = "plasma";
  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    mouse.accelSpeed = "0";
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
  };
  programs = {
    gnome-terminal.enable = true;
    calls.enable = true;
    kdeconnect.enable = true;
  };
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      adw-gtk3
      adwaita-qt
      adwaita-qt6
      adwsteamgtk
      catppuccin-kde
      capitaine-cursors
      catppuccin-kvantum
      ;
    inherit (inputs.lightly.packages.${pkgs.system})
      darkly-qt5
      darkly-qt6
      ;
    inherit (pkgs)
      gparted
      gradience
      pop-launcher
      sysprof
      ;
    inherit (pkgs.kdePackages)
      breeze
      breeze-gtk
      breeze-icons
      ;
    inherit (pkgs.kdePackages)
      ark
      kclock
      konsole
      dolphin
      merkuro # mail client
      filelight
      # kio
      kio-fuse
      kio-admin
      kio-extras
      kio-gdrive
      kio-zeroconf
      kio-extras-kf5
      dolphin-plugins
      # For some reason it's not enabled by default
      kauth
      signond
      qtspeech
      accounts-qt
      calendarsupport
      kaccounts-providers
      kaccounts-integration
      signon-kwallet-extension
      # formatws
      qtsvg # svg
      ffmpegthumbs # thumbnailer itself
      kimageformats # gimp
      qtimageformats # webp etc
      kdesdk-thumbnailers # test
      kdegraphics-thumbnailers # blender etc
      # misc
      discover
      kcmutils
      flatpak-kcm
      packagekit-qt
      ;
    inherit (pkgs)
      gnome-boxes
      gnome-tweaks
      gnome-themes-extra
      adwaita-icon-theme
      ;
    inherit (pkgs.gnomeExtensions)
      arcmenu
      kimpanel
      pop-shell
      gsconnect
      dash-to-dock
      appindicator
      blur-my-shell
      rounded-corners
      smart-auto-move
      clipboard-history
      dual-monitor-toggle
      ;
    catppuccin-gtk = pkgs.catppuccin-gtk.override {
      accents = [ "rosewater" ];
      size = "compact";
      tweaks = [ "normal" ];
      variant = "mocha";
    };
    # signond_wrapped = pkgs.callPackage ../../../home/shared/programs/signon/wrapper.nix {
    #   inherit lib;
    #   inherit (pkgs.kdePackages) signond signon-kwallet-extension;
    #   signon-plugin-oauth2 = pkgs.callPackage (
    #     path + /home/shared/programs/signon/signon-plugin-oauth2.nix
    #   ) { };
    #   # signond = pkgs.callPackage ../../../home/shared/programs/signon/signond.nix { };
    #   withKWallet = true;
    #   withOAuth2 = true;
    # };
    # signond = pkgs.callPackage ../../../home/shared/programs/signon/signond.nix {
    #   inherit lib;
    #   inherit (pkgs.kdePackages)
    #     qmake
    #     qtbase
    #     wrapQtAppsHook
    #     signon-kwallet-extension
    #     ;
    #   withOAuth2 = true;
    #   withKWallet = true;
    #   # signon-ui = pkgs.callPackage (path + /home/shared/programs/signon/signon-ui.nix) {
    #   #   inherit lib;
    #   #   inherit (pkgs.kdePackages)
    #   #     accounts-qt
    #   #     ;
    #   # };
    # };
  };
  environment.gnome.excludePackages = builtins.attrValues {
    inherit (pkgs) gnome-console gnome-builder;
  };
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;
  services.dbus.packages = [ pkgs.gcr ];
  nixpkgs.overlays = [
    (self: super: {
      mutter = super.mutter.overrideAttrs (old: {
        src = inputs.mutter-triple-buffering-src;
        preConfigure = ''
          cp -a "${inputs.gvdb-src}" ./subprojects/gvdb
        '';
      });
    })
  ];
}
