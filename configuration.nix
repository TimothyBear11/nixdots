{ config, lib, pkgs, inputs, ... }:

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
  boot.kernelPackages = inputs.cachyos.legacyPackages.${pkgs.system}."linuxPackages-cachyos-lts"; 

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ "https://xddxdd.cachix.org" ];
    extra-trusted-public-keys = [ "xddxdd.cachix.org-1:ay1QqcAsEbcpaFybWIieIg++nSabaHu7dFrRAccE6V0=" ];
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
