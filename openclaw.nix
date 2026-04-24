{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.nix-openclaw.homeManagerModules.openclaw
  ];

  programs.openclaw = {
    enable = true;

    # Use the package from the overlay
    package = pkgs.openclaw-gateway;

    instances.default = {
      enable = true;
      systemd.enable = true;
      stateDir = "${config.home.homeDirectory}/.openclaw";
      workspaceDir = "${config.home.homeDirectory}/.openclaw/workspace";

      config = {
        # GATEWAY
        gateway = {
          mode = "local";
          bind = "loopback";
          port = 18789;
          auth = {
            mode = "token";
            token = "4d7f6fac31a1db59369a8f574fb3fff33523be993d7d5f5d";
          };
        };

        # MODEL (MiniMax)
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

        # AGENT defaults
        agents.defaults = {
          model.primary = "minimax/MiniMax-M2.5";
          workspace = "${config.home.homeDirectory}/.openclaw/workspace";
          contextTokens = 32000;
          compaction.mode = "safeguard";
          memorySearch.enabled = false;
        };

        # CHANNELS — Telegram
        channels.telegram = {
          enabled = true;
          botToken = "8577047097:AAEGgSXQe6kt9hmIQTSjiaH3veOQPi8nZ-A";
        };
      };
    };
  };
}
