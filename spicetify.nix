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
    
    # Comfy theme - clean and modern
    theme = spicePkgs.themes.comfy;
    
    # catppuccin-mocha: deep blue base with nice cyan accents - great match for your dragon!
    colorScheme = "catppuccin-mocha";

    # Select extensions
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
  }; 

  }
