{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.nix-openclaw.homeManagerModules.openclaw
  ];

  programs.openclaw = {
    enable = true;

    # Use the package from the flake input — good, but note: if you want the full openclaw CLI/tools too,
    # you may want pkgs.openclaw or the default; gateway-only is fine if that's your intent.
    package = inputs.nix-openclaw.packages.${pkgs.system}.openclaw-gateway;

    instances.default = {
      enable = true;

      stateDir = "/home/tbear/.openclaw";  # This is fine; module uses ~/.openclaw by default anyway

      # Optional but helpful: explicit workspace dir (matches your config.workspace below)
      workspaceDir = "/home/tbear/.openclaw/workspace";

      config = {
        # GATEWAY — already good, but add explicit port if not default (you have it)
        gateway = {
          mode = "local";
          bind = "loopback";  # or "127.0.0.1" — both work
          port = 18789;
          auth = {
            mode = "token";
            # Security: NEVER commit plaintext tokens to git!
            # Better options:
            # 1. Use sops-nix/agenix: tokenFile = "/run/secrets/openclaw-gateway-token";
            # 2. Or read from env at runtime, but declarative is better.
            # For now (testing), you can keep it, but move to secrets ASAP.
            token = "4d7f6fac31a1db59369a8f574fb3fff33523be993d7d5f5d";
          };
        };

        # MODEL (MiniMax) — looks fine, but ensure apiKey is handled securely (similar to token)
        models.providers.minimax = {
          apiKey = "sk-cp-tpheF4BIB-XzWrH8vglSh73meEwqr8NkCzheNIeWkZSsVTmCthwpNSyPF0cAfOU7BJD-HfzEyewITzGy4tylcAdov0utoY2J9VA7oLTLvxXMSP1fE0kSX98";  
          baseUrl = "https://api.minimax.chat";
          models = [
            {
              id = "MiniMax-M2.5";
              name = "MiniMax";
            }
          ];
        };

        # AGENT defaults — good
        agents.defaults = {
          model.primary = "minimax/MiniMax-M2.5";
          workspace = "/home/tbear/.openclaw/workspace";
          contextTokens = 32000;
          compaction.mode = "safeguard";
          memorySearch.enabled = false;  
          
        };

        # CHANNELS — Telegram
        channels.telegram = {
          enabled = true;
          botToken = "8577047097:AAEGgSXQe6kt9hmIQTSjiaH3veOQPi8nZ-A";  
        };

        # PLUGINS — syntax is slightly off
        # The module expects plugins.entries to be an attrset of { pluginName = { enabled = true; ... }; }
        # But better: use the recommended top-level plugins list for declarative sources
        # Your current form works if the module accepts it, but switch to this for future-proofing:
        # plugins = [
        #   { source = "github:some-org/discord-plugin"; }  # example
        # ];
        # For now, if discord is built-in or from flake, keep as-is or adjust:
        plugins.entries = {
          discord = {
            enabled = true;
            # Add config.env or config.settings if the plugin needs them
          };
          # Add more plugins here as needed
        };
      };
    };

    # Optional but very useful: Customize the generated systemd service
    # This helps with restarts, logs, dependencies, etc.
  };

  systemd.user.services.openclaw-gateway = lib.mkIf config.programs.openclaw.instances.default.enable {
  Service.Restart = "always";
  Service.RestartSec = lib.mkForce "5s";  
  Install = {
    WantedBy = [ "default.target" ];
    };
  }; 

  home.file.".openclaw/openclaw.json".force = true;  
}
