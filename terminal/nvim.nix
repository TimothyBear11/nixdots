{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    # Using extraPackages is better than home.packages 
    # because it links these tools specifically for Neovim.
    extraPackages = with pkgs; [
      # --- Essentials ---
      ripgrep
      fd
      fzf
      wl-clipboard
      unzip
      
      # --- LSPs & Formatters ---
      lua-language-server
      nil
      nixpkgs-fmt
      nodejs_22
      
      # --- Build Tools for Mason/Treesitter ---
      gcc
      gnumake
      cargo # If you do any Rust or Mason builds
    ];
  };
}
