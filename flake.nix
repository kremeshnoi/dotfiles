{
  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pgf = {
      url = "github:kremeshnoi/pgf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-wsl, nix-darwin, home-manager, sops-nix, nix-index-database, pgf, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    homeManager = {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        sharedModules = [
          sops-nix.homeManagerModules.sops
          pgf.homeManagerModules.default
        ];
        users.kremeshnoi = import ./home;
      };
    };
  in
  {
    formatter.${system} = pkgs.nixfmt;

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [ nixfmt sops age nvd ];
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-wsl.nixosModules.default
        nix-index-database.nixosModules.nix-index
        home-manager.nixosModules.home-manager
        ./nixos/configuration.nix
        homeManager
      ];
    };

    darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
      modules = [
        nix-index-database.darwinModules.nix-index
        home-manager.darwinModules.home-manager
        ./darwin/configuration.nix
        homeManager
      ];
    };
  };
}
