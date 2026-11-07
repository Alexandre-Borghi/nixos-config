{ config, pkgs, ... }:
{
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
  systemd.user.services.nextcloud-client.Service.Environment = [
    "XDG_DATA_DIRS=${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${config.home.profileDirectory}/share"
  ];
}
