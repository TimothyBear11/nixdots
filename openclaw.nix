{ config, lib, pkgs, inputs, ... }:

{
  # Import the module from the flake input
  imports = [
    inputs.nix-openclaw.homeManagerModules.openclaw
  ];

  # Configuration starts here - NO "home-manager.users.tbear" wrapper!
  programs.openclaw = {
    enable = true;
    package = inputs.nix-openclaw.packages.${pkgs.system}.openclaw-gateway;

    instances.default = {
      enable = true;
      stateDir = "/home/tbear/.openclaw";

      config = {
        # --- GATEWAY ---
        gateway = {
          mode = "local";
          bind = "loopback";
          port = 18789;
          auth = {
            mode = "token";
            token = "4d7f6fac31a1db59369a8f574fb3fff33523be993d7d5f5d";
          };
        };

        # --- MODEL (MiniMax) ---
        models.providers.minimax = {
          apiKey = "YOUR_MINIMAX_API_KEY";
          baseUrl = "https://api.minimax.chat";
          models = [
            {
              id = "MiniMax-M2.5";
              name = "MiniMax";
            }
          ];
        };

        # --- AGENT ---
        agents.defaults = {
          model.primary = "minimax/MiniMax-M2.5";
          workspace = "/home/tbear/.openclaw/workspace";
          contextTokens = 32000;
          compaction.mode = "safeguard";
          models."minimax/MiniMax-M2.5" = {};
        };

        # --- CHANNELS ---
        channels.telegram = {
          enabled = true;
          botToken = "YOUR_TELEGRAM_BOT_TOKEN";
        };

        # --- PLUGINS ---
        plugins.entries = {
          discord.enabled = false;
          terminal.enabled = true;
          browser.enabled = true;
          files.enabled = true;
        };
      };
    };
  };
}
