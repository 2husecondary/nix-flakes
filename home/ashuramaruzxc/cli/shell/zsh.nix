{ config, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      # Directory navigation
      ".." = "cd ../";
      ".3" = "cd ../../";
      ".4" = "cd ../../../";
      ".5" = "cd ../../../../";

      # File operations
      ls = "ls --color";
      lt = "ls --human-readable --size -1 -S --classify";
      ll = "ls -al";
      llf = "ls -alF";
      ld = "ls -d .*";
      mv = "mv -iv";
      cp = "cp -iv";
      rm = "rm -v";
      grep = "grep --color=auto";
      mkdir = "mkdir -pv";
      untar = "tar -zxvf";
      targz = "tar -cvzf";

      # System information
      mount-c = "mount | column -t";
      path = "echo -e $PATH | tr ':' '\n' | nl | sort";
      xdg-data-dirs = "echo -e $XDG_DATA_DIRS | tr ':' '\n' | nl | sort";
      hist = "history";
      h = "history";

      # Network tools
      myip = "curl ipinfo.io/ip && printf '%s\n'";
      ports = "ss -tulanp";
      fastping = "ping -c 100 -i 0.1";

      # Security tools
      gpg-encrypt = "gpg -c --no-symkey-cache --cipher-algo=AES256";
      uuid = "uuidgen -x | tr a-z A-Z";
      sha1 = "openssl sha1";

      # Utilities
      bc = "bc -l";
      diff = "colordiff";
      j = "jobs -l";
      now = "date +'%T'";
      nowtime = "now";
      nowdate = "date +'%d-%m-%Y'";

      # Media downloading
      ytmp4 = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'";
      ytdlp = "yt-dlp --embed-thumbnail --no-mtime -S res,ext:mp4:m4a --recode mp4";

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

    history = {
      size = 10000;
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      share = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      autoload -Uz compinit && compinit
      # Custom completion styles

      zstyle ":completion:*" menu select
      zstyle ":completion:*:descriptions" format ""
      zstyle ":completion:*:descriptions" style ""
      zstyle ":completion:*:descriptions" color ""

      # Define a custom style for the selected completion item
      zstyle ":completion:*" list-colors ""

      # Fixed key bindings
      bindkey "^A" beginning-of-line   # Changed from vi-beginning-of-line
      bindkey "^E" end-of-line         # Changed from vi-end-of-line
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word

      # Add more common key bindings
      bindkey "^R" history-incremental-search-backward
      bindkey "^S" history-incremental-search-forward
      bindkey "^P" up-line-or-history
      bindkey "^N" down-line-or-history
      bindkey "^K" kill-line
      bindkey "^U" kill-whole-line
      bindkey "^L" clear-screen
    '';
  };

  catppuccin = {
    zsh-syntax-highlighting = {
      enable = true;
      flavor = "mocha";
    };
  };
}
