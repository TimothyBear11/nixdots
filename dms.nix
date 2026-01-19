{ pkgs, inputs, ... }:
{

  programs.dms-shell = {
  enable = true;

  systemd = {
    enable = false;             # Systemd service for auto-start
    restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
  };

  # Core features
  enableSystemMonitoring = true;     # System monitoring widgets (dgop)
  enableVPN = true;                  # VPN management widget
  enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
  enableAudioWavelength = true;      # Audio visualizer (cava)
  enableCalendarEvents = true;       # Calendar integration (khal)
};

}
