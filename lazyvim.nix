{ config, pkgs, ... }:

{
  # 1. The Magic Fix for Mason binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  # 2. System-wide dependencies that LazyVim assumes exist
  environment.systemPackages = with pkgs; [
    gcc     # C Compiler (needed for Treesitter)
    unzip   # Unzip (needed for Mason)
    nodejs_22 # (Optional) If you want Node available system-wide
  ];
}
