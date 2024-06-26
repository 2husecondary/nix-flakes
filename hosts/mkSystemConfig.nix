{
  lib,
  inputs,
  nixpkgs,
  nixpkgs-23_11,
  darwin,
  meanvoid-overlay,
  nur,
  agenix,
  home-manager,
  flatpaks,
  aagl,
  spicetify-nix,
  hyprland,
  path,
  vscode-server,
  ...
}:
let
  homeManager = import ./homeManagerModules.nix {
    inherit
      lib
      inputs
      nixpkgs
      nixpkgs-23_11
      darwin
      nur
      ;
    inherit home-manager spicetify-nix flatpaks;
    inherit path;
  };
  inherit (homeManager) homeManagerModules;
  cfg = {
    nixpkgs.config = {
      allowUnfree = lib.mkDefault true;
    };
  };
in
{
  mkSystemConfig = {
    linux =
      {
        hostName,
        system,
        useHomeManager ? false,
        useHyprland ? false,
        useNur ? false,
        useAagl ? false,
        useFlatpak ? false,
        useVscodeServer ? false,
        useNvidiaVgpu ? false,
        users ? [ ],
        modules ? [ ],
        ...
      }:
      let
        hostname = hostName;
        defaults = [
          { config = cfg; }
          agenix.nixosModules.default
        ] ++ modules;
        sharedModules = lib.flatten [
          (lib.optional useHyprland hyprland.nixosModules.default)
          (lib.optional useNur nur.nixosModules.nur)
          (lib.optional useAagl aagl.nixosModules.default)
          (lib.optionals useFlatpak [
            flatpaks.nixosModules.default
            {
              config.services.flatpak = {
                enable = lib.mkDefault true;
                remotes = {
                  "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
                  "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
                };
              };
            }
          ])
          (lib.optionals useVscodeServer [
            vscode-server.nixosModules.default
            { config.services.vscode-server.enable = lib.mkDefault true; }
          ])
          (lib.optionals useNvidiaVgpu [
            meanvoid-overlay.nixosModules.kvmfr
            meanvoid-overlay.nixosModules.nvidia-vGPU
          ])
          (lib.optionals useHomeManager (homeManagerModules.nixos hostName users))
          defaults
        ];
      in
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            hostname
            users
            path
            ;
          host = {
            inherit hostName;
          };
        };
        modules = [ (path + "/hosts/${hostName}/configuration.nix") ] ++ sharedModules;
      };

    darwin =
      {
        hostName,
        system,
        useHomeManager ? false,
        users ? [ ],
        modules ? [ ],
        ...
      }:
      let
        hostname = hostName;
        defaults = [ { config = cfg; } ] ++ modules;
        sharedModules = lib.flatten [
          (lib.optional useHomeManager (homeManagerModules.darwin hostName users))
          defaults
        ];
      in
      darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            hostname
            users
            path
            ;
          inherit darwin nixpkgs nixpkgs-23_11;
          host = {
            inherit hostName;
          };
        };
        modules = [ (path + /hosts/darwin/${hostName}/configuration.nix) ] ++ sharedModules;
      };
  };
}
