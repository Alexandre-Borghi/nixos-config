{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nur,
      ...
    }:
    {
      nixosModules = import ./nixos;
      homeManagerModules = import ./home-manager;

      nixosConfigurations.msi = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/msi/configuration.nix
          home-manager.nixosModules.default
          nur.modules.nixos.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.alex = ./hosts/msi/home.nix;
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
