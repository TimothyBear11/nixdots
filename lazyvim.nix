{ config, pkgs, ... }:

{
  # KEEP THIS: This is the "Magic" that allows Mason's 
  # downloaded binaries to actually run on NixOS.
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
    # Add glibc if Mason binaries complain about "libm.so" or "libc.so"
    glibc
  ];
}
