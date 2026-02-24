{ config, pkgs, lib, ... }:

{
  # Qtile window manager - Wayland version
  services.xserver.windowManager.qtile = {
    enable = true;
    extraPackages = python3Packages: with python3Packages; [
      qtile-extras
      dbus-next
      pulsectl
    ];
  };

  # Add fuzzel launcher (NixOS level)
  environment.systemPackages = with pkgs; [
    fuzzel
  ];
}
