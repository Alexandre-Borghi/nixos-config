{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  home.username = "alex";
  home.homeDirectory = "/home/alex";

  home.preferXdgDirectories = true;
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      setSessionVariables = true;
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/dl";
      pictures = "${config.home.homeDirectory}/pics";
      videos = "${config.home.homeDirectory}/vids";
    };
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    systemd.enable = true;
    config = {
      modifier = "Mod1";
      terminal = "alacritty";
      defaultWorkspace = "workspace number 1";
      input."*".xkb_layout = "fr";
      output."*".mode = "1920x1080";
      # Disable sway-bar because we're using waybar
      bars = [ ];
      window = {
        titlebar = false;
        hideEdgeBorders = "both";
      };
      floating.criteria = [
        { title = "Volume Control"; } # pavucontrol
        # flameshot
        { title = "Save screenshot"; }
        { title = "Capture Launcher"; }
      ];
      keybindings =
        let
          cfg = config.wayland.windowManager.sway.config;
          modifier = cfg.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Shift+Return" = "exec ${cfg.terminal}";
          "${modifier}+p" = "exec ${cfg.menu}";
          "${modifier}+Shift+c" = "kill";
          "${modifier}+Shift+l" = "exec swaylock";
          "Mod4+b" = "exec firefox";

          "${modifier}+ampersand" = "workspace number 1";
          "${modifier}+eacute" = "workspace number 2";
          "${modifier}+quotedbl" = "workspace number 3";
          "${modifier}+apostrophe" = "workspace number 4";
          "${modifier}+parenleft" = "workspace number 5";
          "${modifier}+minus" = "workspace number 6";
          "${modifier}+egrave" = "workspace number 7";
          "${modifier}+underscore" = "workspace number 8";
          "${modifier}+ccedilla" = "workspace number 9";
          "${modifier}+agrave" = "workspace number 10";

          "${modifier}+Shift+ampersand" = "move container to workspace number 1";
          "${modifier}+Shift+eacute" = "move container to workspace number 2";
          "${modifier}+Shift+quotedbl" = "move container to workspace number 3";
          "${modifier}+Shift+apostrophe" = "move container to workspace number 4";
          "${modifier}+Shift+parenleft" = "move container to workspace number 5";
          "${modifier}+Shift+minus" = "move container to workspace number 6";
          "${modifier}+Shift+egrave" = "move container to workspace number 7";
          "${modifier}+Shift+underscore" = "move container to workspace number 8";
          "${modifier}+Shift+ccedilla" = "move container to workspace number 9";
          "${modifier}+Shift+agrave" = "move container to workspace number 10";
        };
    };
  };
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "sway-session.target" ];
    };
    settings = [
      {
        height = 24;
        spacing = 0;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "sway/scratchpad"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "disk"
          "network"
          "power-profiles-daemon"
          "battery"
          "clock"
          "tray"
        ];
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "󰅶 {icon} {format_source}";
          format-muted = "󰅶 {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "󰂑";
            headset = "󰂑";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} 󰊗";
          tooltip-format = "{ifname} via {gwaddr} 󰊗";
          format-linked = "{ifname} (No IP) 󰊗";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%H:%M %d/%m/%Y}";
        };
        tray.spacing = 10;
      }
    ];
  };

  home.packages = with pkgs; [
    btop
    inputs.mistral-vibe.packages.${pkgs.system}.default
  ];

  programs.bash = {
    enable = true;
    historyControl = [
      "ignoreboth"
      "erasedups"
    ];
    historyFile = "$XDG_STATE_HOME/bash_history";
  };
  home.shellAliases = {
    ll = "ls -lhF";
    la = "ls -lhFa";
    gs = "git status";
  };

  programs.alacritty = {
    enable = true;
    theme = "alabaster_dark";
  };

  programs.vim = {
    enable = true;
  };
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    globals = {
      mapleader = " ";
    };
    opts = {
      colorcolumn = "80"; # Highlight column 80
      termguicolors = true; # Enable true colors
      ignorecase = true; # Ignore case in search
      swapfile = false; # Disable swap files
      autoindent = true; # Enable auto indentation
      expandtab = true; # Use spaces instead of tabs
      tabstop = 4; # Number of spaces for a tab
      softtabstop = 4; # Number of spaces for a tab when editing
      shiftwidth = 4; # Number of spaces for autoindent
      shiftround = true; # Round indent to multiple of shiftwidth
      signcolumn = "yes:1"; # Always show sign column
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers
      numberwidth = 2; # Width of the line number column
      wrap = false; # Disable line wrapping
      cursorline = true; # Highlight the current line
      scrolloff = 8; # Keep 8 lines above and below the cursor
      undofile = true; # Enable persistent undo
      completeopt = [
        "menuone"
        "popup"
        "noinsert"
      ]; # Options for completion menu
      winborder = "rounded"; # Use rounded borders for windows
    };
    clipboard.register = "unnamedplus";
    keymaps = [
      {
        mode = "n";
        key = "<space>";
        action = "<Nop>";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>FzfLua files<CR>";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>FzfLua live_grep<CR>";
      }
    ];
    plugins = {
      fzf-lua.enable = true;
      lspconfig.enable = true;
      lsp-format.enable = true;
    };
    lsp = {
      codelens.enable = true;
      completion = {
        enable = true;
        settings = {
          autotrigger = true;
        };
      };
      documentColor.enable = true;
      inlayHints.enable = true;
      inlineCompletion.enable = true;
      linkedEditingRange.enable = true;
      onTypeFormatting.enable = true;
      semanticTokens.enable = true;
      servers = {
        nixd.enable = true;
      };
    };
    diagnostic.settings = {
      virtual_text.virt_text_pos = "eol";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      core.autocrlf = "input";
      user = {
        name = "Alexandre Borghi";
        email = "alexandre@aborghi.fr";
        signingKey = "~/.ssh/id_ed25519.pub";
      };
      init.defaultBranch = "main";
      commit.gpgSign = true;
      tag.gpgSign = true;
      gpg.format = "ssh";
      pull.rebase = true;
      diff.renames = "copies";
    };
    signing.allowedSigners = ''
      alexandre@aborghi.fr ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAd7EVcjXuUbN0kNHvQV+QWZlzesqOIzlnFIwVSNs4cs alex@nixos-vm
    '';
  };

  programs.firefox = {
    enable = true;
    languagePacks = [
      "en-US"
      "fr"
    ];
    profiles.default = {
      search = {
        default = "ddg";
        force = true;
        engines = {
          ddg = {
            name = "DuckDuckGo";
            urls = [
              {
                template = "https://duckduckgo.com";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
                definedAliases = [ "@np" ];
              }
            ];
          };
          google.metaData.hidden = true;
          bing.metaData.hidden = true;
          perplexity.metaData.hidden = true;
          qwant.metaData.hidden = true;
          startpage.metaData.hidden = true;
          wikipedia.metaData.hidden = true;
        };
      };
      settings = {
        "sidebar.verticalTabs" = true;
        "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
        # Move sidebar to the right
        "sidebar.position_start" = false;
        "browser.newtabpage.activity-stream.widgets.weather.enabled" = false;
        # Disable newtabpage shortcuts
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.urlbar.suggest.topsites" = false;
        # Automatically enable extensions
        "extensions.autoDisableScopes" = 0;
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
      ];
    };
    policies = {
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      SkipTermsOfUse = true;
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles."default" = {
      isDefault = true;
      accountsOrder = [
        "Personal"
        "Business"
        "Apps"
        "UTC"
        "Junior UTC"
      ];
      settings = {
        "calendar.week.start" = 1;
      };
    };
  };

  accounts.email.accounts =
    let
      googleImap = {
        host = "imap.gmail.com";
        port = 993;
        tls.enable = true;
      };
      googleSmtp = {
        host = "smtp.gmail.com";
        port = 587;
        tls.enable = true;
        tls.useStartTls = true;
      };
      oauthSettings = id: {
        # 10 = OAuth2
        "mail.server.server_${id}.authMethod" = 10;
        "mail.smtpserver.smtp_${id}.authMethod" = 10;
      };
    in
    {
      "Personal" = {
        primary = true;
        realName = "Alexandre Borghi";
        address = "alexandre@aborghi.fr";
        userName = "borghi.alexandre.12@gmail.com";

        imap = googleImap;
        smtp = googleSmtp;

        thunderbird = {
          enable = true;
          settings =
            id:
            {
              "mail.identity.id_${id}.reply_to" = "alexandre@aborghi.fr";
            }
            // oauthSettings id;
        };
      };
      "Apps" = {
        realName = "Alexandre Borghi";
        address = "apps@aborghi.fr";
        userName = "alex.apps.12@gmail.com";

        imap = googleImap;
        smtp = googleSmtp;

        thunderbird = {
          enable = true;
          settings =
            id:
            {
              "mail.identity.id_${id}.reply_to" = "apps@aborghi.fr";
            }
            // oauthSettings id;
        };
      };
      "Business" = {
        realName = "Alexandre Borghi";
        address = "contact@aborghi.fr";
        userName = "aborghi.pro@gmail.com";

        imap = googleImap;
        smtp = googleSmtp;

        thunderbird = {
          enable = true;
          settings =
            id:
            {
              "mail.identity.id_${id}.reply_to" = "contact@aborghi.fr";
            }
            // oauthSettings id;
        };
      };
      "UTC" = {
        realName = "Alexandre Borghi";
        address = "alexandre.borghi@etu.utc.fr";
        userName = "borghial";

        imap = {
          host = "imaps.utc.fr";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "smtps.utc.fr";
          port = 465;
          tls.enable = true;
        };

        thunderbird.enable = true;
      };
      "Junior UTC" = {
        realName = "Alexandre Borghi";
        address = "aborghi@juniorutc.fr";
        userName = "aborghi@juniorutc.fr";

        imap = googleImap;
        smtp = googleSmtp;

        thunderbird = {
          enable = true;
          settings = id: oauthSettings id;
        };
      };
    };
  accounts.calendar.accounts = {
    "Personal" = {
      remote = {
        url = "https://cloud.aborghi.fr/remote.php/dav/calendars/alex/personal";
        userName = "alex";
        type = "caldav";
      };
      thunderbird = {
        enable = true;
        color = "#1877f2";
      };
    };
    "Contact birthdays" = {
      remote = {
        url = "https://cloud.aborghi.fr/remote.php/dav/calendars/alex/contact_birthdays";
        userName = "alex";
        type = "caldav";
      };
      thunderbird = {
        enable = true;
        readOnly = true;
        color = "#ffdf00";
      };
    };
  };
  accounts.contact.accounts = {
    "Contacts" = {
      remote = {
        url = "https://cloud.aborghi.fr/remote.php/dav/addressbooks/users/alex/contacts";
        userName = "alex";
        type = "carddav";
      };
      thunderbird.enable = true;
    };
  };

  # Mistral Vibe
  home.sessionVariables.VIBE_HOME = "${config.xdg.configHome}/vibe";
  xdg.configFile."vibe/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    theme = "rose-pine";
  };

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        savePath = "/home/alex/pics/screenshots";
        startupLaunch = true;
      };
    };
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}
