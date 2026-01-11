{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = [

    inputs.ambxst.packages.${pkgs.system}.default

  ];
}
