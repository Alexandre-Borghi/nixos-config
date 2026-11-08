{ inputs, ... }:
{
  imports = [
    inputs.self.homeManagerModules.base
    inputs.self.homeManagerModules.desktop
    inputs.self.homeManagerModules.firefox
    inputs.self.homeManagerModules.neovim
    inputs.self.homeManagerModules.nextcloud
    inputs.self.homeManagerModules.rust
    inputs.self.homeManagerModules.thunderbird
  ];

  wayland.windowManager.sway = {
    extraOptions = [ "--unsupported-gpu" ];
    config = {
      output."HDMI-A-2".pos = "0 0";
      output."HDMI-A-3".pos = "1920 0";
      output."DP-1".pos = "3840 0";
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
