{
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    kernelPackages = pkgs.unstable.linuxPackages_xanmod;
    supportedFilesystems = [ "ntfs" ];
  };
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      configurationLimit = 30;
    };
    generationsDir.copyKernels = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    timeout = 10;
  };
  ### ----------------BOOT------------------- ###
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/26EA-3BB2";
    fsType = "vfat";
  };
  ### ----------------BOOT------------------- ###
  boot.initrd = {
    availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "uas"
      "sd_mod"
    ];
    kernelModules = [
      # modules
      "vfat"
    ];
  };
  ### ---------------boot drive-------------------- ###
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/29bfb700-f152-42f9-ab82-7a3faa2d4cc5";
    fsType = "ext4";
    options = [
      "noatime"
    ];
  };
  ### ---------------boot drive-------------------- ###

  ### ---------------anything else-------------------- ###
  fileSystems."/mnt/big" = {
    device = "/dev/disk/by-uuid/74248E2A248DF002";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };
  fileSystems."/mnt/wiwi" = {
    device = "/dev/disk/by-uuid/E4467BA4467B75E0";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };
  ### ---------------anything else-------------------- ###
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
  system.fsPackages = [ pkgs.sshfs ];
  environment.systemPackages = [ pkgs.cifs-utils pkgs.btop pkgs.cdrtools ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
