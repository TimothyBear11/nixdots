{ config, pkgs, ... }:

{

  programs.mango = {
    enable = true;
    enableSession = true;
  };
}
