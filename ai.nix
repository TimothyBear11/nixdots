{ config, pkgs, ... }:

{
  # 1. GRAPHICS & ROCm SETUP
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.rocminfo
      rocmPackages.rocm-smi
    ];
  };

  # 2. SYSTEM PACKAGES
  environment.systemPackages = with pkgs; [
    lmstudio
    gemini-cli
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
  ];

}    

  
