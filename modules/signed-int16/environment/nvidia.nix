{ config, pkgs, ... }:
{
  boot.kernelParams = [ "module_blacklist=i915" ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    modesetting.enable = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    nvidiaSettings = true;
  };
  environment.systemPackages = with pkgs; [
    nvtopPackages.full
  ];
}
