{
  description = "UrsaOS & NixOS - Logic meets Magic";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    mangowc.url = "github:DreamMaoMao/mangowc";
    mangowc.inputs.nixpkgs.follows = "nixpkgs";
    dms.url = "github:AvengeMedia/DankMaterialShell";
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    ambxst.url = "github:Axenide/Ambxst";
    ambxst.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    nix-openclaw.url = "github:openclaw/nix-openclaw";
    caelestia-shell.url = "github:caelestia-dots/shell";
    caelestia-shell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, mangowc, spicetify-nix, nix-openclaw, caelestia-shell, ... }:
  let
    system = "x86_64-linux";

    # --- CHANGE 1 START ---
    # Define the overlay
    youtuiOverlay = final: prev: {
      youtui = final.callPackage ./youtui.nix {};
    };

    # Apply it to the standalone pkgs
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        youtuiOverlay
        nix-openclaw.overlays.default
      ];
      config.allowUnfree = true;
    };
    # --- CHANGE 1 END ---

  in {
    nixosConfigurations.my-nix-den = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./openclaw.nix

        mangowc.nixosModules.mango
        inputs.dms.nixosModules.default
        home-manager.nixosModules.home-manager


        # --- CHANGE 2 START ---
        # Apply the overlay to the NixOS system
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [ youtuiOverlay ];
          environment.systemPackages = [ pkgs.youtui ];
        })
        # --- CHANGE 2 END ---

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.tbear = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };

    homeConfigurations.tbear = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        inputs.mangowc.hmModules.mango
        ./home.nix
      ];
    };
  };
}
