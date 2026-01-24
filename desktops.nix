{ config, pkgs, inputs, ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.hyprland.enable = true;
  programs.niri.enable = true;
  programs.mango.enable = true;
  programs.dconf.enable = true; # <-- ADDED

  security.polkit.enable = true; # <-- ADDED

  # Polkit Agent Service
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };

  # XDG Portals for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    libsForQt5.qt5ct
    kdePackages.qt6ct
    wl-clipboard
    kanshi
    wlr-randr
    grim
    slurp
    pavucontrol
    polkit_gnome
    gnome-keyring # <-- Optional: Helps with app passwords
  ];

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
