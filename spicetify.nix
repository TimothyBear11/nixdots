{ inputs, pkgs, ... }:
let
  # This grabs the Spicetify packages (themes, extensions) for your system
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  # 1. Import the Spicetify Home Manager module
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  # 2. Configure Spicetify
  programs.spicetify = {
    enable = true;
    
    # Dribbblish theme - fully customizable colors!
    theme = spicePkgs.themes.dribbblish;
    
    # Custom color scheme matching the Blue Dragon wallpaper (cyan/electric blue)
    colorScheme = "dragonBlue";

    # Custom colors for dribbblish
    colors = {
      # Background tones - deep navy like the dragon
      "background" = "#0a1628";
      "background-overlay" = "#0d1f3c";
      "background-elevated" = "#132744";
      
      # Accent - electric cyan from the dragon's glow
      accent = "#00d4ff";
      
      # Text
      "text-base" = "#e8f4fc";
      "text-shadow" = "#00d4ff";
      
      # Other elements
      "player" = "#1a3a5c";
      "card" = "#0d2240";
      "tab-active" = "#00d4ff";
      "button" = "#00a8cc";
      "button-active" = "#00d4ff";
      "nav-active" = "#00d4ff";
    };

    # Select extensions
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
  }; 

  }
