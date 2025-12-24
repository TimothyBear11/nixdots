{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./desktops.nix
    ./gaming.nix
    ./fontsAndNeeds.nix
    ./qtile.nix
    ./lazyvim.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # "extra" versions just append to the system defaults
    extra-substituters = [ "https://cachyos.cachix.org" ];
    extra-trusted-public-keys = [ "cachyos.cachix.org-1:f/sSj99Y9H7K0x2A62LOn9p81NndP3T195Y85dToV7o=" ];
  };

  networking.hostName = "my-nix-den";
  networking.networkmanager.enable = true;
  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.fish.enable = true;

  users.users.tbear = {
    isNormalUser = true;
    description = "Timothy Bear";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  system.stateVersion = "25.05";
}
