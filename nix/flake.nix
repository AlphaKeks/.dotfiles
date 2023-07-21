# https://GitHub.com/AlphaKeks/.dotfiles

{
	inputs = {
		nixpkgs = {
			url = "github:nixos/nixpkgs/645ff62e09d294a30de823cb568e9c6d68e92606";
		};

		hardware = {
			url = "github:nixos/nixos-hardware";
		};

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs = {
				nixpkgs = {
					follows = "nixpkgs";
				};
			};
		};

		osu = {
			url = "https://github.com/ppy/osu/releases/latest/download/osu.AppImage";
			flake = false;
		};

		neovim-nightly = {
			url = "github:neovim/neovim?dir=contrib";
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

