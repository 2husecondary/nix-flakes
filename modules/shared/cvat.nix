{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cvat;
in
{
  options.services.cvat = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = lib.mdDoc ''
        Enable Computer Vision Annotation Tool service
      '';
    };
    config = lib.mkIf cfg.enable { environment.systemPackages = [ ]; };
  };
}
