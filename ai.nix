{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.rocminfo
      rocmPackages.rocm-smi
    ];
  };

  environment.systemPackages = with pkgs; [
    lmstudio
    ollama-rocm
    gemini-cli
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
  ];

  environment.variables = {
    # CRITICAL: RX 6700 XT (gfx1031) requires spoofing gfx1030 to work with most ROCm apps
    HSA_OVERRIDE_GFX_VERSION = "10.3.0";

    # Optional: Improves performance allocation
    ROC_ENABLE_PRE_VEGA = "1";
  };

  # Ensure the ollama service picks up the environment variable
  systemd.services.ollama.environment = {
    HSA_OVERRIDE_GFX_VERSION = "10.3.0";
  };
}
