{ pkgs, path, ... }:
{
  imports = [
    (path + /home/ashuramaruzxc/dev/vim.nix)
  ] ++ (import (path + /home/ashuramaruzxc/cli/default.nix));
  home = {
    username = "root";
    packages = builtins.attrValues {
      # Utils
      inherit (pkgs) thefuck;
    };
    stateVersion = "24.11";
  };
  programs.tmux.enable = true;
  catppuccin.tmux = {
    flavor = "mocha";
    extraConfig = ''
      set -g @catppuccin_status_modules_right "application session user host date_time"
    '';
  };
}
