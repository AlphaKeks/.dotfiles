# https://GitHub.com/AlphaKeks/.dotfiles

{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    hardware = {
      url = "github:nixos/nixos-hardware";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    osu = {
      url = "https://github.com/ppy/osu/releases/latest/download/osu.AppImage";
      flake = false;
    };
  };

  outputs = { nixpkgs, hardware, home-manager, ...} @ inputs: {
    nixosConfigurations = {
      btw = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./configuration.nix ];
      };
    };
  };
}

# vim: et ts=2 sw=2 sts=2 ai si ft=nix