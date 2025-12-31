{ config, pkgs, inputs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixdots/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    nvim = "nvim";
    foot = "foot";
    hypr = "hypr";
    niri = "niri";
    qtile = "qtile";
    noctalia = "noctalia";
    mango = "mango";
    # Add Ambxst here (Capitalized A to match ~/.config/Ambxst)
    Ambxst = "Ambxst";
  };
in
{
  imports = [
    ./terminal.nix
    ./apps.nix
  ];

  home.username = "tbear";
  home.homeDirectory = "/home/tbear";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
  services.mako.enable = false;

  home.packages = with pkgs; [
    gcc
    # Add Ambxst if you added it to your flake.nix inputs
    # inputs.ambxst.packages.${pkgs.system}.default

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

  # 1. Standard Configs (~/.config/...)
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  # 2. Data Files (~/.local/share/...)
  # This handles the specific wallpaper fix we found
  xdg.dataFile."Ambxst/wallpapers.json".source =
    create_symlink "${dotfiles}/Ambxst/wallpapers.json";
}
