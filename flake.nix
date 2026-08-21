{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    #inputs.gazelle.url = "github:Zeus-Deus/gazelle-tui";
    
    };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix
       
       home-manager.nixosModules.default
      ];
    };
  };
}

