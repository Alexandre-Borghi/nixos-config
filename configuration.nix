{ lib, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings = {
    use-xdg-base-directories = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # TODO(alex): enable auto-upgrade
  #system.autoUpgrade = {
  #  enable = true;
  #  flake = "/etc/nixos";
  #  flags = [
  #    "--print-build-logs"
  #    #"--commit-lock-file"
  #  ];
  #  dates = "02:00";
  #  randomizedDelaySec = "45min";
  #};

  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices = {
    "crypt-sda" = {
      device = "/dev/disk/by-uuid/d7f827e6-3f3d-47e2-84c6-4a9b4e8de6e9";
    };
    "crypt-sdb" = {
      device = "/dev/disk/by-uuid/2d7ab199-15b8-4a84-aa80-c95040497a42";
    };
  };
  boot.initrd.services.lvm.enable = true;
  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024;
    }
  ];

  networking.hostName = "msi";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [
    8080
    3000 # Web app testing from mobile devices on local networks
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      session_log = ".local/state/ly-session.log";
    };
  };
  programs.sway = {
    enable = true;
    xwayland.enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      mako
      power-profiles-daemon # Used in waybar "power-profiles-daemon" module
      swayidle
      swaylock
      wl-clipboard
      wmenu
    ];
  };

  # Screen sharing on Wayland (Firefox, etc.)
  xdg.portal = {
    config.sway.default = lib.mkForce [ "wlr" "gtk" ];
    wlr.settings.screencast = {
      chooser_cmd = "${pkgs.wlr-utils}/bin/wlr-chooser";
      chooser_type = "simple";
    };
  };

  services.gnome.gnome-keyring.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.blueman.enable = true;

  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "1234";
  };

  environment.systemPackages = with pkgs; [
    alacritty
    libnotify
    nixfmt
    nixfmt-tree
    pavucontrol
    vim
    wget
    glib
    gsettings-desktop-schemas
  ];

  environment.sessionVariables = {
    # This removes .compose-cache from $HOME
    XCOMPOSECACHE = "$HOME/.cache/compose-cache";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
    ];
    fontconfig.useEmbeddedBitmaps = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
