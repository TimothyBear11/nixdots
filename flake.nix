{
  description = "NixOS is a place to learn";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, mangowc, zen-browser, ... }: {
    nixosConfigurations.my-nix-den = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./noctalia.nix
        ./ai.nix
        ./dev.nix
        ./dms.nix

        mangowc.nixosModules.mango
        home-manager.nixosModules.home-manager
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
  };
}
