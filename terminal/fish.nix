{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    # Set environment variables here so they are ready before the prompt loads
    shellInit = ''
      set -gx STARSHIP_CONFIG ~/nixdots/config/starship.toml
    '';

    # Commands that run when you open a terminal
    interactiveShellInit = ''
      # QoL: Disable the "Welcome to fish" message
      set -g fish_greeting ""

      # Fastfetch with custom logo
      # The check ensures the shell still opens even if fastfetch isn't installed
      if type -q fastfetch
        fastfetch --logo ~/nixdots/Pictures/tbearlogo.png --logo-type auto --logo-width 35 --logo-height 30
      end
    '';

    # Abbreviations expand in place (type 'nrs' + space -> see full command)
    shellAbbrs = {
      flakeup = "nix flake update";

      # Git shortcuts are huge quality of life
      gs = "git status";
      ga = "git add .";
      gc = "git commit -m";
      gp = "git push";
    };

    shellAliases = {
      vim = "nvim";

      # Optional: Map ls to eza for icons and better formatting
      # (Only works if you enable eza below)
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first";
    };

    functions = {
      # Custom rebuild function
      nrs = {
        body = ''
          # Navigate to your config
          pushd ~/nixdots > /dev/null
          
          # Stage changes (crucial for Flakes!)
          git add .
          
          # Run the rebuild
          if sudo nixos-rebuild switch --flake .#my-nix-den
            # If successful, check if a commit message was provided
            if set -q argv[1]
              git commit -m "$argv[1]"
              git push
              echo "✅ Build successful and pushed to GitHub!"
            else
              echo "✅ Build successful! (No commit message provided)"
            end
          else
            echo "❌ Build failed. Keeping changes staged for fix."
          end
          
          popd > /dev/null
        '';
      };

      goodnight = {
        body = ''
          # 1. Safely find the git root or exit if not in a repo
          
          set -l repo_root (git rev-parse --show-toplevel 2>/dev/null)
          
          if test -z "$repo_root"
            echo "Error: You are not inside a git repository."
            return 1
          end

          cd $repo_root

          echo "Updating flake inputs..."
          nix flake update

          echo "Staging changes..."
          git add .

          echo "Rebuilding..."
          
          # 2. Rebuild NixOS
          if sudo nixos-rebuild switch --flake .#my-nix-den
            echo "Rebuild successful."

          # 3. Check if there are actually changes to commit to avoid errors
          if not git diff --staged --quiet
            echo "Committing and pushing..."
            git commit -m "end of night updates"
            git push
          else
            echo "No changes to commit."
          end

          echo "Shutting down in 10 seconds... (Press Ctrl+C to cancel)"
          sleep 10
          sudo shutdown -h now
          else
            echo "Rebuild failed. Aborting shutdown."
            return 1
          end
          '';
        };
      };

  };

  # --- Integrations ---

  # Enable Starship Prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Enable Zoxide (Smart 'cd')
  # Usage: type 'z down' to jump to 'Downloads' automatically
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Enable Eza (Modern 'ls' replacement)
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
  };
}
