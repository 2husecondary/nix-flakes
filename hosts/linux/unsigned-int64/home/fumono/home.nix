{ pkgs, path, ... }:
{
  imports = [
    (path + /home/ashuramaruzxc/dev/vim.nix)
  ] ++ (import (path + /home/ashuramaruzxc/cli/default.nix));
  home = {
    username = "fumono";
    packages = builtins.attrValues {
      # Utils
      inherit (pkgs) thefuck;
    };
    stateVersion = "24.11";
  };
}
