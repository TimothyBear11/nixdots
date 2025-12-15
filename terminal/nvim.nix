{ config, pkgs, lib, ...}:

{

  home.packages = with pkgs; [
    neovim
    ripgrep
    fd
    fzf
    lua-language-server
    nil
    nixpkgs-fmt
    nodejs
  ];



}
