{ config, lib, pkgs, inputs, ... }:

{
  home-manager.users.tbear = { 
    imports = [
      inputs.nix-openclaw.homeManagerModules.openclaw
    ];

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
            apiKey = "YOUR_MINIMAX_API_KEY"; # Set via environment variable or replace
            # No baseUrl needed - uses default MiniMax endpoint
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
            
            # Reasonable context limits
            contextTokens = 32000; 
            compaction.mode = "safeguard";

            models."minimax/MiniMax-M2.5" = {};
          };

          # --- CHANNELS (Telegram - the one you're using!) ---
          channels.telegram = {
            enabled = true;
            # Bot token - set via environment variable OPENCLAW_TELEGRAM_BOT_TOKEN
            # or replace with your actual token
            botToken = "YOUR_TELEGRAM_BOT_TOKEN";
          };

          # --- PLUGINS ---
          plugins.entries = {
            # Keep Discord disabled since you're using Telegram
            discord.enabled = false;
            
            # Enable useful plugins
            terminal.enabled = true;
            browser.enabled = true;
            files.enabled = true;
          };
        };
      };
    };
  };
}
