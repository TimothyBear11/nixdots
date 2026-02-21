{ config, pkgs, inputs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixdots/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    nvim = "nvim";
    niri = "niri";
    hypr = "hypr";
    qtile = "qtile";
    noctalia = "noctalia";
    mango = "mango";
    Ambxst = "Ambxst";
    btop = "btop";
  };
in
{
  

  imports = [
    ./terminal.nix
    ./apps.nix
    ./spicetify.nix
    ./caelestia.nix
    ./openclaw.nix
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

    inputs.zen-browser.packages.${pkgs.system}.default

  ];  

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  xdg.dataFile."Ambxst/wallpapers.json".source =
    create_symlink "${dotfiles}/Ambxst/wallpapers.json";
}
