{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    tree

  ];

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    cascadia-code
    monaspace
    hack-font
    fantasque-sans-mono
    pkgs.nerd-fonts.comic-shanns-mono
    nerd-fonts.victor-mono
    nerd-fonts.iosevka
    nerd-fonts.recursive-mono
    nerd-fonts.geist-mono
  ];
}
