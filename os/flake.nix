{
  description = "Homelab NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs,  ... }@inputs: let
    name = "homelab-0";
    type = "control";
    isclusterinit = true;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations."${name}" =  nixpkgs.lib.nixosSystem {
      specialArgs = {
        meta = {
          isclusterinit = isclusterinit;
          hostname = name;
          nodetype = type;
        };
      };
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
  };
}