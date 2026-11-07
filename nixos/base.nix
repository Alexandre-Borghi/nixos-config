{
  lib,
  pkgs,
  ...
}:
{
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

  networking.networkmanager.enable = true;

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
      mako # notifications daemon
      power-profiles-daemon # used in waybar's "power-profiles-daemon"
      swayidle
      swaylock
      wl-clipboard
      wmenu
    ];
  };

  xdg.portal = {
    config.sway.default = lib.mkForce [
      "wlr"
      "gtk"
    ];
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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  programs.dconf.enable = true;

  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
    initialPassword = "1234";
  };

  environment.systemPackages = with pkgs; [
    glib
    gsettings-desktop-schemas
    pavucontrol
    vim
    wget
  ];
  # remove .compose-cache from $HOME
  environment.sessionVariables.XCOMPOSECACHE = "$HOME/.cache/compose-cache";

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
    ];
    fontconfig.useEmbeddedBitmaps = true;
  };
}
