{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    # ------------------------------------------------------------
    # Environment variables
    # These must be available before Starship initializes
    # ------------------------------------------------------------
    shellInit = ''
      set -gx STARSHIP_CONFIG "$HOME/nixdots/config/starship.toml"
    '';

    # ------------------------------------------------------------
    # Interactive shell startup
    # Runs only for real terminals, not scripts
    # ------------------------------------------------------------
    interactiveShellInit = ''
      # Disable the default Fish greeting (cleaner startup)
      set -g fish_greeting ""

      # Optional system info splash
      # Only runs if fastfetch is installed
      if type -q fastfetch
        fastfetch \
          --logo "$HOME/nixdots/Pictures/tbearlogo.png" \
          --logo-type auto \
          --logo-width 35 \
          --logo-height 30
      end

      # Load custom Fish functions (modular & editable without rebuild)
      if test -d "$HOME/nixdots/config/fish/functions"
        for f in $HOME/nixdots/config/fish/functions/*.fish
          source $f
        end
      end
    '';

    # ------------------------------------------------------------
    # Abbreviations (expand inline as you type)
    # ------------------------------------------------------------
    shellAbbrs = {
      flakeup = "nix flake update";

      gs   = "git status";
      ga   = "git add .";
      gc   = "git commit -m";
      gp   = "git push";
      gd   = "git diff";
      gds  = "git diff --staged";
      gl   = "git pull --rebase";
      gco  = "git checkout";
      gb   = "git branch -vv";
      gcm  = "git checkout main && git pull";
      gundo = "git reset --soft HEAD~1";
    };

    # ------------------------------------------------------------
    # Aliases (command replacements)
    # ------------------------------------------------------------
    shellAliases = {
      vim = "nvim";

      # Modern ls replacement
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first";

      # Quick navigation helpers
      d  = "cd ~";
      dl = "cd ~/Downloads";
      dt = "cd ~/Documents";
      proj = "cd ~/projects";
      zd = "z down";
      zp = "z projects";
    };
  };

  # ------------------------------------------------------------
  # Shell integrations
  # ------------------------------------------------------------

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
  };
}
