{
  config,
  pkgs,
  lib,
  ...
}:
{
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
      menu = "wmenu-run -f \"monospace Normal 14\"";
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

  services.swayidle =
    let
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "${pkgs.sway}/bin/swaymsg 'output * power ${status}'";
      minutes = 60;
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 5 * minutes;
          command = lock;
        }
        {
          timeout = 10 * minutes;
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 15 * minutes;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = {
        before-sleep = (display "off") + "; " + lock;
        after-resume = display "on";
        lock = (display "off") + "; " + lock;
        unlock = display "on";
      };
    };

  services.mako = {
    enable = true;
    settings = {
      background-color = "#000000";
      border-color = "#ffffff";
      border-radius = 0;
      default-timeout = 5 * 1000;
    };
  };

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        savePath = "${config.xdg.userDirs.pictures}/screenshots";
        startupLaunch = true;
      };
    };
  };

  services.blueman-applet = {
    enable = true;
    systemdTargets = [ "sway-session.target" ];
  };

  programs.alacritty = {
    enable = true;
    theme = "alabaster_dark";
  };

  programs.obs-studio.enable = true;
  services.easyeffects.enable = true;

  home.packages = with pkgs; [
    dbeaver-bin
    libreoffice
    simple-scan
    vlc
  ];
}
