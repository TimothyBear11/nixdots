{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./desktops.nix
    ./gaming.nix
    ./fontsAndNeeds.nix
    ./qtile.nix
    ./lazyvim.nix
    ./ai.nix
    ./dev.nix
    ./ambxst.nix
    ./dms.nix
    ./noctalia.nix
  ];

  # --- Boot & Kernel ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

  # --- Nix Housekeeping & Settings ---
  nix = {
    # 1. Weekly Garbage Collection
    # This deletes old generations so your disk doesn't fill up.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # 2. Storage Optimization
    # Deduplicates identical files in the store. 
    # (Runs via a timer to avoid slowing down active builds)
    optimise.automatic = true;

    settings = {
      download-buffer-size = 1073741824; # 1GB
      experimental-features = [ "nix-command" "flakes" ];
      
      # 3. Trusted Users
      # Allows sudo users (wheel) to configure binary caches 
      # (useful if you ever pull from Cachix or other repos)
      trusted-users = [ "root" "@wheel" ];
    };
  };

  # --- Networking ---
  networking.hostName = "my-nix-den";
  networking.networkmanager.enable = true;

  # --- Virtualization ---
  virtualisation.podman.enable = true;

  # --- Audio & Services ---
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  # --- Locale & Time ---
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.nix-ld.enable = true;
  programs.kdeconnect.enable = true;

  programs.appimage = {
  enable = true;
  binfmt = true;
};

  # --- Users ---
  programs.fish.enable = true;

  users.users.tbear = {
    isNormalUser = true;
    description = "Timothy Bear";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  system.stateVersion = "25.05";
}
