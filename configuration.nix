{
  config,
  lib,
  pkgs,
  ...
}:

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
    crypt_vda2 = {
      device = "/dev/vda2";
    };
  };

  networking.hostName = "nixos-vm";
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
      mako
      power-profiles-daemon # Used in waybar "power-profiles-daemon" module
      swayidle
      swaylock
      wl-clipboard
      wmenu
    ];
  };

  services.gnome.gnome-keyring.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "1234";
  };

  programs.firefox = {
    enable = true;
    languagePacks = [
      "en-US"
      "fr"
    ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    libnotify
    nixfmt
    nixfmt-tree
    pavucontrol
    vim
    wget
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
