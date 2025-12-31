{ config, pkgs, lib, ... }:

{

  services.xserver.enable = true;

  services.xserver.windowManager.qtile = {
    enable = true;

    extraPackages = python3Packages: with python3Packages; [
     # qtile-extras
     # qtile-bonsai
    ];
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    wlr-randr
    grim
    slurp
#    mako
    fuzzel

  ];
}


