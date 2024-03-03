{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    package = pkgs.unstable.nushell;
    shellAliases = {
      # Distrobox
      arch = "distrobox enter arch";
      void = "distrobox enter void"; # Fixed typo: distrbox -> distrobox
      gentoo = "distrobox enter gentoo";

      # System admin
      s = "sudo";

      # Nix operations
      update = "nix flake update /etc/nixos";
      check = "nix flake check";
      darwin-rebuild = "darwin-rebuild switch --flake /etc/nixos#unsigned-int8"; # Fixed typo: darwin-rebuld -> darwin-rebuild
      darwin-rebuild-trace = "darwin-rebuild switch --show-trace 2>/dev/stdout --flake /etc/nixos#unsigned-int8 | grep 'while evaluating derivation'";
      linux-rebuild = "nixos-rebuild switch --use-remote-sudo";
      linux-rebuild-trace = "nixos-rebuild build --show-trace 2>/dev/stdout | grep 'while evaluating derivation'";
      vms = "nixos-build-vms";
      buildvm = "nixos-rebuild build-vm";
      buildvm_ = "nixos-rebuild build-vm-with-bootloader";
      test = "nixos-rebuild test";

      # Add neofetch = fastfetch alias
      neofetch = "fastfetch";
    };

    configFile.text = ''
      # Generic
      $env.EDITOR = "nvim";
      $env.VISUAL = "nvim";
      $env.config.show_banner = false;
      $env.config.buffer_editor = "nvim";

      # Vi
      $env.config.edit_mode = "vi";
      $env.config.cursor_shape.vi_insert = "line"
      $env.config.cursor_shape.vi_normal = "block"

      let $config = {
        rm_always_trash: true
        shell_integration: true
        highlight_resolved_externals: true
        use_kitty_protocol: true
        completion_algorithm: "fuzzy"
      }
    '';

    extraConfig =
      let
        customCompletions = pkgs.fetchFromGitHub {
          owner = "nushell";
          repo = "nu_scripts";
          rev = "698e24064710f9dcaca8d378181c8b954e37ac6e";
          hash = "sha256-VcPydbV2zEhQGJajBI1DRuJYJ/XKbTWsCGecDLGeLAs=";
        };
        completionTypes = [
          "curl"
          "gh"
          "git"
          "man"
          "nix"
          "ssh"
          "tar"
          "vscode"
        ];
        sourceCommands = map (t: "source ${customCompletions}/custom-completions/${t}/${t}-completions.nu") completionTypes;
      in
      builtins.concatStringsSep "\n" sourceCommands;
  };
}
