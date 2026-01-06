{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    tree
    gh # Required for credentials
  ];

  programs.git = {
    enable = true;
    config = {
      # 1. Identity (So you can delete ~/.gitconfig safely)
      user = {
        name = "TimothyBear11"; 
        email = "timothybear1183@pm.me"; 
      };
      
      # 2. Set default branch to main
      init = {
        defaultBranch = "main";
      };
      
      # 3. Fix the credential helper (Nix-proof)
      credential = {
        helper = "!gh auth git-credential";
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
