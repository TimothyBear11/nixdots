{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  # THIS IS THE CRUCIAL MISSING LINE:
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    
    # Comfy fits the modern, rounded COSMIC aesthetic perfectly
    theme = spicePkgs.themes.comfy;
    colorScheme = "custom";

    # Injecting the Marchborn Guardian Palette
    customColorScheme = {
      text               = "E1E8E6";  # Soft Aqua-Parchment
      subtext            = "B0BDBA";  # Dimmed subtitle text
      main               = "151A1C";  # Deep Slate Teal background
      sidebar            = "151A1C";  # Seamless background blending
      player             = "151A1C";  # Bottom player bar
      card               = "1D2427";  # Elevated panels and albums
      shadow             = "090C0D";  # Rich drop shadows
      selected-row       = "2A5A5C";  # Muted Aquamarine for hovered tracks
      button             = "FF4D4D";  # Bloodstone Glow for play buttons
      button-active      = "FF7373";  # Lighter red when clicked
      button-disabled    = "2A5A5C";
      tab-active         = "1D2427";
      notification       = "56B6C2";  # Tech Aquamarine for popups
      notification-error = "FF7373";
      misc               = "1D2427";
    };

    # A few solid extensions to pair with it
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
  };
}
