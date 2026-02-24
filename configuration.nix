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
    ./cachykernel.nix
  ];

  # --- Boot & Kernel ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Nix Housekeeping & Settings ---
  nix = {
    # 1. Weekly Garbage Collection
    # This deletes old generations so your disk doesn't fill up.
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
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
  services.geoclue2.enable = true;

  # --- Virtualization ---
  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  programs.dconf.enable = true;



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

  home-manager = {
    backupFileExtension = lib.mkForce "hm-backup";  

    users.tbear = import ./home.nix;  # or however you're importing the user's HM config
    overwriteBackup = true;  
  };

  users.users.tbear = {
    isNormalUser = true;
    description = "Timothy Bear";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };

  system.stateVersion = "25.05";
}
