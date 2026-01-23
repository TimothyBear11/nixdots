{ config, pkgs, inputs, ... }:

{

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";

  services.displayManager.sddm.enable = true;

  services.desktopManager.plasma6.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.niri.enable = true;

  
  programs.mango.enable = true;
  
  qt = {
    enable = true;
    platformTheme = "qt5ct"; # This allows qt5ct/qt6ct to manage the theme
  };

  # 2. Add the correct packages
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    libsForQt5.qt5ct
    kdePackages.qt6ct
    # Optional: If you use Kvantum for the DMS look
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
  ];

  # 3. Force the theme engine for Hyprland/Niri
  # This tells Qt apps "Look at the qtct config files for your colors"
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    # Force Wayland for Qt apps to prevent them from using XWayland
    QT_QPA_PLATFORM = "wayland;xcb"; 
  };
  
  }
