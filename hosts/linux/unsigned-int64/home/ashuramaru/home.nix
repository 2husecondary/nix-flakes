{ pkgs, path, ... }:
{
  imports = [
    (path + /home/ashuramaruzxc/dev/vim.nix)
  ] ++ (import (path + /home/ashuramaruzxc/cli/default.nix));
  home = {
    username = "ashuramaru";
    packages = builtins.attrValues {
      # Utils
      inherit (pkgs) ani-cli thefuck;
    };
    stateVersion = "24.11";
  };
}
