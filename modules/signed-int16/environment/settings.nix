{ pkgs, ... }:
{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  services.udev = {
    packages = builtins.attrValues {
      inherit (pkgs) opentabletdriver;
      inherit (pkgs.gnome) gnome-settings-daemon;
      inherit (pkgs.gnome2) GConf;
    };
  };
}
