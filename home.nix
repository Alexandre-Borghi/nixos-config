{
  config,
  pkgs,
  lib,
  ...
}:

{
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
      }
    ];
  };

  home.packages = with pkgs; [
    btop
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
    defaultEditor = true;
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

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        savePath = "/home/alex/pics/screenshots";
        startupLaunch = true;
      };
    };
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
