{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.base
  ];

  # required by the NVIDIA driver
  nixpkgs.config.allowUnfree = true;

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

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];
  hardware.nvidia = {
    modesetting.enable = true; # required for Wayland
    open = false; # Pascal isn't supported by the open kernel modules
    # R580 is the last driver branch to support the Pascal architecture of the
    # GTX 1060
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    powerManagement.enable = true; # suspend/resume services
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  environment.sessionVariables.WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card2";

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
