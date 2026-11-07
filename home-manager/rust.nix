{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup
    cargo-leptos
    sass
  ];

  programs.cargo = {
    enable = true;
    package = null;
    cargoHome = "${config.xdg.dataHome}/cargo";
    settings = {
      build.target-dir = "${config.xdg.cacheHome}/cargo-target";
    };
  };
}
