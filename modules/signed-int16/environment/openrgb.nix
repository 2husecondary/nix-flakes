{ pkgs, lib, ... }:
let
  blue = pkgs.writeScriptBin "blue" ''
    #!/bin/sh
    NUM_DEVICES=$(${pkgs.openrgb}/bin/openrgb --noautoconnect --list-devices | grep -E '^[0-9]+: ' | wc -l)

    for i in $(seq 0 $(($NUM_DEVICES - 1))); do
      ${pkgs.openrgb}/bin/openrgb --noautoconnect --device $i --mode static --color #3daee9
    done
  '';
in {
  config = {
    boot.kernelModules = [ "i2c-dev" ];
    hardware.i2c.enable = true;

    systemd.services.blue = {
      description = "blue";
      serviceConfig = {
        ExecStart = "${blue}/bin/blue";
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}