{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nirimod = {
      url = "github:srinivasr/nirimod";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    affinity-nix.url =
      "github:mrshmllow/affinity-nix";

    spicetify-nix.url =
      "github:Gerg-L/spicetify-nix";

    vm-curator.url =
      "github:mroboff/vm-curator";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations.nixos =
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.default

          ({
            pkgs,
            inputs,
            ...
          }: {
            nixpkgs.overlays = [
              inputs.affinity-nix.overlays.default

              (final: prev: {
                vm-curator =
                  inputs.vm-curator.packages
                    .${final.system}
                    .default;
              })
            ];

            environment.systemPackages = with pkgs; [
              affinity-v3
              vm-curator
            ];
          })
        ];
      };
  };
}
