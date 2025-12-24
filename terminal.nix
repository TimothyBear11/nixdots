{ config, pkgs, ... }:

{

  imports = [
    ./terminal/fish.nix
    ./terminal/nvim.nix
    ./terminal/kitty.nix
  ];


  home.packages = with pkgs; [
    foot
    kdePackages.konsole
    btop
    bootdev-cli
    starship
    fastfetch
    gh
    eza
  ];
}


