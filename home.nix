{ config, pkgs, inputs, ... }:
let
  dotfiles = "/home/tbear/nixdots/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    niri = "niri";
    hypr = "hypr";
    qtile = "qtile";
    noctalia = "noctalia";
    mango = "mango";
    Ambxst = "Ambxst";
    btop = "btop";
    cosmic = "cosmic";
  };
in
{


  imports = [
    ./terminal.nix
    ./apps.nix
    ./spicetify.nix
    ./caelestia.nix
    #./openclaw.nix
  ];

  home.username = "tbear";
  home.homeDirectory = "/home/tbear";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  services.kdeconnect = {
  enable = true;
  indicator = true; # Starts the tray indicator automatically
  };

  # 2. Ensure Fish is ready for Nix on Fedora
  programs.fish = {
  enable = true;
  interactiveShellInit = ''
    # Only source this on non-NixOS systems (like UrsaOS)
    # NixOS doesn't have this file because it handles paths differently
    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    end
    '';
  };

  home.packages = with pkgs; [
    gcc

    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        (nix-search-tv.overrideAttrs (oldAttrs: {
          env.GOEXPERIMENT = "jsonv2";
          disallowedReferences = [ ];
          disallowedRequisites = [ ];
        }))
      ];
      text = ''exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"'';
    })


  ];

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      # Use a plain string path for the symlink target
      source = config.lib.file.mkOutOfStoreSymlink "/home/tbear/nixdots/config/${subpath}";
    })
    configs;

  # Also update this one:
  xdg.dataFile."Ambxst/wallpapers.json".source =
    config.lib.file.mkOutOfStoreSymlink "/home/tbear/nixdots/config/Ambxst/wallpapers.json";
}
