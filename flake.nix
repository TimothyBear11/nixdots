{
  description = "NixOS - Logic meets Magic";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Renamed to mangowm to match your module usage
    mangowm.url = "github:mangowm/mango";
    mangowm.inputs.nixpkgs.follows = "nixpkgs";

    ambxst.url = "github:Axenide/Ambxst";
    ambxst.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    caelestia-shell.url = "github:caelestia-dots/shell";

    dms.url = "github:AvengeMedia/DankMaterialShell";
    dms.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    nix-openclaw.url = "github:openclaw/nix-openclaw";
    nix-openclaw.inputs.nixpkgs.follows = "nixpkgs";

    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    millennium.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    youtuiOverlay = final: prev: {
      youtui = final.callPackage ./youtui.nix {};
    };

    app2unitOverlay = final: prev: {
      app2unit = prev.app2unit.overrideAttrs (old: {
        postPatch = "";
      });
    };
  in {
    nixosConfigurations.my-nix-den = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix

        # Corrected prefixes
        inputs.mangowm.nixosModules.mango
        inputs.dms.nixosModules.default
        home-manager.nixosModules.home-manager

        {
          nixpkgs.overlays = [
            youtuiOverlay
            app2unitOverlay # Added the missing overlay
            inputs.nix-openclaw.overlays.default
            inputs.millennium.overlays.default
          ];
          nixpkgs.config.allowUnfree = true;

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            extraSpecialArgs = { inherit inputs; };
            users.tbear = {
              imports = [
                ./home.nix
                #./openclaw.nix
                # Note: Spicetify-nix or other inputs usually get imported in home.nix
              ];
            };
          };
        }
      ];
    };

    # Standalone HM config (if you use home-manager switch)
    homeConfigurations.tbear = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
            youtuiOverlay
            app2unitOverlay
            inputs.nix-openclaw.overlays.default
        ];
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit inputs; };
      modules = [
        # Note: HM standalone uses different module syntax than NixOS modules
        # Ensure mangowm provides a homeManagerModules if using here
        ./home.nix
        #./openclaw.nix
      ];
    };
  };
}
