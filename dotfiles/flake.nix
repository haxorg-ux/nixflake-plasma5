{

  description = "My first flake!";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Home-manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { 
    self,
    nixpkgs, 
    home-manager,
    ...
    } @ inputs: let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (self) outputs;
    in {
    nixosConfigurations = {
      h4ck = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        modules = [ ./configuration.nix ];
      };
    };

    homeConfigurations = {
      m4teo = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
  };
}
