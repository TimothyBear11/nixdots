{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # Controller support - just need udev rules
  services.udev = {
    extraRules = ''
      # Xbox controller udev rules
      SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02ea", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02ff", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02e0", MODE="0666"
    '';
  };

  environment.systemPackages = with pkgs; [
    heroic
    protonup-qt
    lutris
  ];
}
