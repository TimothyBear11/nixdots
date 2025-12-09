{ config, pkgs, ... }:

{

  imports = [
    ./terminal/fish.nix
    ./terminal/nvim.nix
  ];


  home.packages = with pkgs; [
    kitty
    foot
    btop
    bootdev-cli
    starship
    fastfetch
    gh
    eza
  ];
}


