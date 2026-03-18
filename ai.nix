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

  # 3. OLLAMA & AI SERVICES
  services.ollama = {
    enable = true;
    # The updated way to declare ROCm acceleration in NixOS:
    package = pkgs.ollama-rocm;

    # Force ROCm compatibility for the RX 6700 XT (gfx1031)
    rocmOverrideGfx = "10.3.0";
    # Automatically download and load this model on startup
    loadModels = [ "llama3.2" ];
  };
}
