{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # --- System Packages ---
  environment.systemPackages = with pkgs; [
    vim
    wget
    gh    # You NEED this installed for the credential helper to work
    tree
    # 'git' is removed here because we enable it below
  ];

  # --- Git Configuration ---
  # This installs git AND configures /etc/gitconfig system-wide
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      credential = {
        "https://github.com" = {
          helper = "!gh auth git-credential";
        };
        "https://gist.github.com" = {
          helper = "!gh auth git-credential";
        };
      };
    };
  };

  # --- Fonts ---
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    cascadia-code
    monaspace
    hack-font
    fantasque-sans-mono
    
    # Nerd Fonts (Grouped for readability)
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.comic-shanns-mono
    nerd-fonts.victor-mono
    nerd-fonts.iosevka
    nerd-fonts.recursive-mono
    nerd-fonts.geist-mono
  ];
}
