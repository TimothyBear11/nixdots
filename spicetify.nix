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
    
    # Select your theme
    theme = spicePkgs.themes.comfy;
    colorScheme = "Nord";



    # Select extensions
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
      # playlistIcons # Some common ones
    ];
  }; 

  }
