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

          # --- MODEL ---
          models.providers.openai-local = {
            baseUrl = "http://127.0.0.1:1234/v1";
            apiKey = "lm-studio";
            api = "openai-completions"; 
            models = [
              { 
                id = "mistralai/ministral-3-14b-reasoning"; # Or your rnj ID
                name = "LocalModel"; 
              }
            ];
          };

          # --- AGENT (SPEED OPTIMIZATIONS) ---
          agents.defaults = {
            model.primary = "openai-local/mistralai/ministral-3-14b-reasoning";
            workspace = "/home/tbear/.openclaw/workspace";
            
            # Reduce history to 5000 tokens to prevent looping
            contextTokens = 5000; 
            compaction.mode = "safeguard";

            models."openai-local/mistralai/ministral-3-14b-reasoning" = {};
          };

          # --- CHANNELS ---
          channels.discord = {
            enabled = true;
            token = "YOUR_NEW_DISCORD_TOKEN"; 
            groupPolicy = "allowlist";
            guilds."528389665489944580".channels."528389665489944582".allow = true;
          };

          # --- DISABLE HEAVY TOOLS (This fixes the 12k n_keep) ---
          plugins.entries = {
            discord.enabled = true;
            # Disabling these removes thousands of tokens from the prompt
            terminal.enabled = false;
            browser.enabled = false;
            files.enabled = false;
            python.enabled = false;
          };
        };
      };
    };
  };
}
