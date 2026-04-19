{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withPython3 = false;
    withRuby = false;
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

  xdg.configFile."nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink "/home/tbear/nixdots/config/nvim/init.lua";
}
