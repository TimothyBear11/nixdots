{ config, pkgs, lib, ... }:

{
  # Qtile window manager - Wayland version
  services.xserver.windowManager.qtile = {
    enable = true;
    package = pkgs.python3Packages.qtile.overrideAttrs (oldAttrs: {
      doCheck = false;
      doInstallCheck = false;
    });
    extraPackages = python3Packages: with python3Packages; [
      qtile-extras
      dbus-next
      pulsectl-asyncio
      psutil
    ];
  };

  # Add fuzzel launcher and control tools
  environment.systemPackages = with pkgs; [
    fuzzel
    brightnessctl
    pamixer
  ];
}
