{ pkgs, inputs, ... }:

let
  # The Python environment with our missing dependency
  caelestiaPython = pkgs.python313.withPackages (ps: with ps; [
    materialyoucolor
  ]);
in
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    
    # 1. Let the module do EVERYTHING naturally to get the command back
    package = inputs.caelestia-shell.packages.${pkgs.system}.default;
    cli.enable = true;

    systemd.enable = false; 

    settings = {
      scheme = {
        name = "dynamic";
        source = "/home/tbear/nixdots/Pictures/tbearlogo.png";
      };

      font.family.clock = "Acme"; 

      background = {
        visualiser.enabled = true;
        desktopClock = {
          enabled = true;
          position = "top-right";
        };
      };

      paths.wallpaperDir = "~/nixdots/Pictures/Wallpapers"; 
    };
  };

  # 2. The Ultimate Hijack (Fish Function)
  # This dynamically finds the hidden Python script, cracks open its 
  # hardcoded PYTHONPATH, injects our library, and runs it directly.
  programs.fish.functions = {
    caelestia = ''
      # Find the real binary installed by the module
      set -l target_bin (command -s caelestia)
      
      if test -z "$target_bin"
          echo "Command not found. Rebuild might have failed."
          return 1
      end

      # Resolve the Nix symlinks to find the actual store directory
      set -l real_bin (realpath $target_bin)
      set -l real_dir (dirname $real_bin)
      set -l wrapped_bin "$real_dir/.caelestia-wrapped"

      # If it's a Nix-wrapped Python script...
      if test -f $wrapped_bin
          # Extract the strict PYTHONPATH Nix tried to lock it to
          set -l orig_ppath (cat $real_bin | grep "export PYTHONPATH=" | cut -d '=' -f 2- | tr -d "'\"")
          
          # Inject our materialyou library path into it
          set -x PYTHONPATH "${caelestiaPython}/${pkgs.python313.sitePackages}:$orig_ppath"
          
          # Execute the hidden python script directly to bypass the lock!
          eval $wrapped_bin $argv
      else
          # Fallback just in case
          eval $real_bin $argv
      end
    '';
  };
}
