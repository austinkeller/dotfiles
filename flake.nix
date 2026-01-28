{
  description = "Home Manager configuration for austinkeller";

  inputs = {
    # Default: stable darwin channel (better binary cache coverage)
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";

    # Unstable: for packages that need bleeding edge (e.g., claude-code)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "aarch64-darwin";
      # Default pkgs from stable darwin channel
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      # Unstable for specific packages that need newer versions
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations."austinkeller" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit unstable; };
      };
    };
}
