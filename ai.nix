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

  # 3. GLOBAL ENV VARS (For CLI usage outside the service)
  environment.variables = {
    HSA_OVERRIDE_GFX_VERSION = "10.3.0";
    ROC_ENABLE_PRE_VEGA = "1";
  };

  # 4. OLLAMA SERVICE
  services.ollama = {
    enable = true;
    # FIX: We use the specific package instead of the 'acceleration' option
    package = pkgs.ollama-rocm;
    loadModels = [ "llama3.2" ];
  };

  # 5. SERVICE OVERRIDES (Crucial for RX 6700 XT Service)
  # We still need to inject the spoofing variable into the systemd service
  systemd.services.ollama.environment = {
    HSA_OVERRIDE_GFX_VERSION = "10.3.0";
    ROC_ENABLE_PRE_VEGA = "1";
  };
}
