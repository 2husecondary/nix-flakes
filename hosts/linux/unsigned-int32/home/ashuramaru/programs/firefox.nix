{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  bypass-paywalls-clean =
    let
      version = "latest";
    in
    inputs.firefox-addons.lib.${pkgs.system}.buildFirefoxXpiAddon {
      pname = "bypass-paywalls-clean";
      inherit version;
      addonId = "magnolia@12.34";
      url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-${version}.xpi";
      name = "bypass-paywall-clean-${version}";
      sha256 = "sha256-UEK7MY6IefdimjlmXsKa4i3HDi2skdmEdaAzxQkAoQ4=";
      meta = {
        homepage = "https://twitter.com/Magnolia1234B";
        description = "Bypass Paywalls of (custom) news sites";
        license = lib.licenses.mit;
        platforms = lib.platforms.all;
      };
    };
in
{
  programs.floorp = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.unstable.floorp else pkgs.floorp;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        # hacks
        "gfx.webrender.all" = true; # Force enable GPU acceleration
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes

        # settings
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "extensions.webextensions.restrictedDomains" = ''
          accounts-static.cdn.mozilla.net,accounts.firefox.com,addons.cdn.mozilla.net,addons.mozilla.org,api.accounts.firefox.com,content.cdn.mozilla.net,discovery.addons.mozilla.org,install.mozilla.org,oauth.accounts.firefox.com,profile.accounts.firefox.com,support.mozilla.org,sync.services.mozilla.com,metrics.tenjin-dk.com,cloud.tenjin-dk.com,public.tenjin.com,private.tenjin.com,beta.foldingathome.org
        '';
      };
      extensions = builtins.attrValues {
        inherit (inputs.firefox-addons.packages.${pkgs.system})
          # necessity
          mullvad
          clearurls
          ublock-origin
          foxyproxy-standard
          facebook-container
          user-agent-string-switcher

          # Scripts
          firemonkey

          # UI/UX
          stylus
          tabliss
          darkreader
          firefox-color
          tree-style-tab

          # devtools
          angular-devtools
          react-devtools
          reduxdevtools
          vue-js-devtools

          # utils
          floccus
          bitwarden
          web-archives
          sponsorblock
          search-by-image
          return-youtube-dislikes
          gnome-shell-integration

          # Misc
          steam-database
          old-reddit-redirect
          firefox-translations
          multi-account-containers
          reddit-enhancement-suite

          # Dictionaries
          ukrainian-dictionary
          french-dictionary
          dictionary-german
          polish-dictionary
          bulgarian-dictionary
          ;
        bpc = bypass-paywalls-clean;
      };
      search = {
        force = true;
        order = [
          "Kagi"
          "Google"
          "DuckDuckGo"
          "Home Manager"
          "Nix Options"
          "Nix Packages"
          "NixOS Wiki"
          "GitHub"
          "SteamDB"
          "ProtonDB"
          "YouTube"
          "YoutubeMusic"
        ];
        default = "Kagi";
        privateDefault = "Kagi";
        engines =
          let
            update = 7 * 24 * 60 * 60 * 1000;
          in
          {
            "Google".metaData.alias = "@g";
            "Bing".metaData.hidden = true;
            "You".metaData.hidden = true;
            "You.com".metaData.hidden = true;
            "Kagi" = {
              urls = [
                {
                  template = "https://kagi.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
                {
                  template = "https://kagi.com/api/autosuggest";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                  type = "application/x-suggestions+json";
                }
              ];
              iconUpdateURL = "https://assets.kagi.com/v2/favicon-32x32.png";
              updateInterval = update;
              definedAliases = [ "@kagi" ];
            };
            "DuckDuckGo" = {
              urls = [
                {
                  template = "https://duckduckgo.com";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://duckduckgo.com/favicon.ico";
              updateInterval = update;
              definedAliases = [ "@ddg" ];
            };
            "Home Manager" = {
              urls = [
                {
                  template = "https://mipmip.github.io/home-manager-option-search";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "unstable";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hm" ];
            };
            "Nix Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "type";
                      value = "options";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nq" ];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Wiki" = {
              urls = [
                {
                  template = "https://nixos.wiki/index.php";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nw" ];
            };
            "GitHub" = {
              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://github.com/favicon.ico";
              updateInterval = update;
              definedAliases = [ "@gh" ];
            };
            "SteamDB" = {
              urls = [
                {
                  template = "https://steamdb.info/search";
                  params = [
                    {
                      name = "a";
                      value = "app";
                    }
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://steamdb.info/static/logos/512px.png";
              updateInterval = update;
              definedAliases = [ "@steamdb" ];
            };
            "ProtonDB" = {
              urls = [
                {
                  template = "https://www.protondb.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://www.protondb.com/sites/protondb/images/favicon.ico";
              updateInterval = update;
              definedAliases = [ "@protondb" ];
            };
            "YouTube" = {
              urls = [
                {
                  template = "https://www.youtube.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://www.youtube.com/s/desktop/5d5de6d9/img/favicon.ico";
              updateInterval = update;
              definedAliases = [
                "@yt"
                "@youtube"
              ];
            };
            "YoutubeMusic" = {
              urls = [
                {
                  template = "https://music.youtube.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://www.youtube.com/s/desktop/5d5de6d9/img/favicon.ico";
              updateInterval = update;
              definedAliases = [
                "@ytm"
                "@ym"
              ];
            };
          };
      };

    };
    policies = {
      DisableTelemetry = true;
      OfferToSaveLogins = true;
      OfferToSaveLoginsDefault = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
    };

    nativeMessagingHosts = [
      pkgs.firefoxpwa
      pkgs.gnome-browser-connector
      pkgs.kdePackages.plasma-browser-integration
      pkgs.keepassxc
    ];
  };
  home.packages = [ pkgs.firefoxpwa ];
}
