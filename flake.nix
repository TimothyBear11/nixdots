{
  description = "UrsaOS & NixOS - Logic meets Magic";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

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
    illogical-flake.url = "github:soymou/illogical-flake";
    illogical-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    youtuiOverlay = final: prev: {
      youtui = final.callPackage ./youtui.nix {};
    };
  in {
    nixosConfigurations.my-nix-den = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix

        inputs.mangowc.nixosModules.mango
        inputs.dms.nixosModules.default
        home-manager.nixosModules.home-manager

        {
          nixpkgs.overlays = [
            youtuiOverlay
            inputs.nix-openclaw.overlays.default
          ];
          nixpkgs.config.allowUnfree = true;

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";

            # This injects the Home Manager library (lib.hm) into the user modules
            extraSpecialArgs = {
              inherit inputs;
              lib = nixpkgs.lib.extend (self: super: {
                hm = home-manager.lib.hm;
              });
            };

            users.tbear = {
              imports = [
                ./home.nix
                ./openclaw.nix
              ];
            };
          };
        }
      ];
    };

    homeConfigurations.tbear = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ youtuiOverlay inputs.nix-openclaw.overlays.default ];
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit inputs; };
      modules = [
        inputs.mangowc.hmModules.mango
        ./home.nix
        ./openclaw.nix
      ];
    };
  };
}
