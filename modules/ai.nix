{ config, pkgs, ... }:

{

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.rocminfo
    ];
  };


  environment.systemPackages = with pkgs; [
    lmstudio
    ollama-rocm



    rocmPackages.rocm-smi
    rocmPackages.rocminfo
  ];


  environment.variables = {
    # (Only uncomment if you have crashes with standard settings)
    # HSA_OVERRIDE_GFX_VERSION = "10.3.0";
  };
}
