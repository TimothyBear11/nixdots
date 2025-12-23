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

    # --- ADD THESE ---
    unzip          # REQUIRED: Mason uses this to unpack servers
    wl-clipboard   # REQUIRED: For clipboard support on Hyprland/Niri
    # -----------------
  ];
}
