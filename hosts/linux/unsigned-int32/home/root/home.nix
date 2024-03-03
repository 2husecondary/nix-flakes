{
  lib,
  pkgs,
  path,
  ...
}:
{
  imports =
    [
      (path + /home/ashuramaruzxc/dev/vim.nix)
    ]
    ++ lib.flatten [
      (lib.concatLists [
        (import (path + /home/ashuramaruzxc/cli/default.nix))
      ])
    ];
  home = {
    username = "root";
    packages = builtins.attrValues {
      # Utils
      inherit (pkgs) thefuck hyfetch ipfetch;
    };
    stateVersion = "24.11";
  };
  programs = {
    tmux.enable = true;
    btop.enable = true;
  };
  catppuccin = {
    tmux = {
      flavor = "mocha";
      extraConfig = ''
        set -g @catppuccin_status_modules_right "application session user host date_time"
      '';
    };
    btop.flavor = "mocha";
  };
}
