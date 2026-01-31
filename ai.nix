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

  # 3. OLLAMA SERVICE
  services.ollama = {
    enable = true;
    
    # FIX: Explicitly select the ROCm package as requested by the error message
    package = pkgs.ollama-rocm;
    
    # This option should still be valid in Unstable. 
    # If this also causes an error, remove it and uncomment section #4 below.
    rocmOverrideGfx = "10.3.0"; 
    
    loadModels = [ "llama3.2" ];
    
    host = "0.0.0.0";
    openFirewall = true;
  };

  # 4. (Fallback) Force Environment Variables
  # Only uncomment this if 'rocmOverrideGfx' above causes an error "option does not exist".
  # systemd.services.ollama.environment = {
  #   HSA_OVERRIDE_GFX_VERSION = "10.3.0";
  # };
}
