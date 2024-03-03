_: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    sessionVariables = { };
    profileExtra = '''';
    initExtra = ''
      shopt -s autocd
      set -o vi
      eval "$(thefuck --alias)"
      export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
    '';
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
  };
}
