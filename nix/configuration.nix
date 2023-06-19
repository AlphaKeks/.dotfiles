# https://GitHub.com/AlphaKeks/.dotfiles
# Documentation: `nixos-help` or `man 5 configuration.nix`

{ inputs, lib, config, pkgs, ... }: let user = "alphakeks"; in {
	imports = [
		./hardware-configuration.nix
		inputs.home-manager.nixosModules.home-manager
	];

	system = {
		# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
		stateVersion = "22.11";
	};

	nix = {
		settings = {
			auto-optimise-store = true;
			experimental-features = "nix-command flakes";
		};

		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 7d";
		};

		extraOptions = ''
			keep-outputs = true
			keep-derivations = true
		'';

		registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
		nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
	};

	nixpkgs = {
		config = {
			allowUnfree = true;
		};

		overlays = [
			(final: prev: {
				awesome-git = (prev.awesome.overrideAttrs (old:
				let
					extraGIPackages = with prev; [ networkmanager upower playerctl ];
				in
				{
					version = "git-20230518-485661b";
					src = prev.fetchFromGitHub {
						owner = "awesomeWM";
						repo = "awesome";
						rev = "485661b706752212dac35e91bb24a0e16a677b70";
						sha256 = "O0JqK0X8c9uj+c72ocN9i9sWiz1tvGHzN7t4WBQH504=";
					};
					patches = [];
					postPatch = ''
					patchShebangs tests/examples/_postprocess.lua
					patchShebangs tests/examples/_postprocess_cleanup.lua
					'';

					GI_TYPELIB_PATH =
					let
						mkTypeLibPath = pkg: "${pkg}/lib/girepository-1.0";
						extraGITypeLibPaths = prev.lib.forEach extraGIPackages mkTypeLibPath;
					in
					prev.lib.concatStringsSep ":" (extraGITypeLibPaths ++ [ (mkTypeLibPath prev.pango.out) ]);
				}))
				.override {
					gtk3Support = true;
					lua = prev.luajit;
				};
			})
		];
	};

	fileSystems = {
		"/mnt/dev" = {
			device = "/dev/disk/by-uuid/6e4111f2-64d7-414c-8a80-ebe24e64a6a8";
			fsType = "btrfs";
		};
		"/mnt/docker" = {
			device = "/dev/disk/by-uuid/7d1f58a5-e564-4ba1-aa60-017c4b1a3c43";
			fsType = "ext4";
		};
		"/mnt/vms" = {
			device = "/dev/disk/by-uuid/981bfb49-39c3-4c5c-bc47-5db792baabde";
			fsType = "btrfs";
		};
		"/mnt/games" = {
			device = "/dev/disk/by-uuid/50316922-4a8c-4edf-8595-3414e9b87440";
			fsType = "btrfs";
		};
	};

	hardware = {
		opentabletdriver = {
			enable = true;
			daemon = {
				enable = true;
			};
			blacklistedKernelModules = [ "wacom" "hid_uclogic" ];
		};

		opengl = {
			driSupport = true;
			driSupport32Bit = true;
		};
	};

	boot = {
		kernelModules = [ "amdgpu" "kvm-amd" "vfio-pci" ];
		kernelParams = [ "amd_iommu=on" "vfio-pci.ids=10de:1b81,10de:10f0" ];

		loader = {
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot/efi";
			};

			grub = {
				enable = true;
				devices = [ "nodev" ];
				efiSupport = true;
			};
		};
	};

	virtualisation = {
		libvirtd = {
			enable = true;
		};

		docker = {
			enable = true;

			daemon = {
				settings = {
					data-root = "/mnt/docker";
				};
			};

			rootless = {
				enable = false;
				setSocketVariable = true;
				daemon = {
					settings = {
						data-root = "/mnt/docker";
					};
				};
			};
		};
	};

	networking = {
		hostName = "btw";
		networkmanager = {
			enable = true;
		};
	};

	time = {
		timeZone = "Europe/Berlin";
	};

	i18n = {
		defaultLocale = "en_US.UTF-8";
		extraLocaleSettings = {
			LC_ADDRESS = "de_DE.UTF-8";
			LC_IDENTIFICATION = "de_DE.UTF-8";
			LC_MEASUREMENT = "de_DE.UTF-8";
			LC_MONETARY = "de_DE.UTF-8";
			LC_NAME = "de_DE.UTF-8";
			LC_NUMERIC = "de_DE.UTF-8";
			LC_PAPER = "de_DE.UTF-8";
			LC_TELEPHONE = "de_DE.UTF-8";
			LC_TIME = "en_GB.UTF-8";
		};
	};

	console = {
		keyMap = "de";
	};

	security = {
		polkit = {
			enable = true;
		};

		rtkit = {
			enable = true;
		};
	};

	environment = {
		systemPackages = with pkgs; [
			gcc gnumake cmake
			git curl killall bc zip unzip
			vim-full
			xclip mate.mate-polkit xorg.libX11
			gnupg pinentry pinentry-gnome xdg-desktop-portal xdg-desktop-portal-gtk gtk3
		];
	};

	programs = {
		dconf = {
			enable = true;
		};

		zsh = {
			enable = true;
		};

		gnupg = {
			agent = {
				enable = true;
				pinentryFlavor = "gnome3";
				enableSSHSupport = true;
			};
		};
	};

	services = {
		openssh = {
			enable = true;
			settings = {
				PermitRootLogin = "no";
				PasswordAuthentication = false;
			};
		};

		pipewire = {
			enable = true;

			audio = {
				enable = true;
			};

			alsa = {
				enable = true;
				support32Bit = true;
			};

			pulse = {
				enable = true;
			};
		};

		xserver = {
			enable = true;

			videoDrivers = [ "amdgpu" ];

			deviceSection = ''
				Option "TearFree" "true"
				'';

			layout = "alpha";
			extraLayouts.alpha = {
				description = "The best keyboard layout ever to be created";
				languages = [ "eng" ];
				symbolsFile = ../configs/X11/xkb/symbols/alpha;
			};

			libinput = {
				mouse = {
					middleEmulation = false;
				};
			};

			displayManager = {
				gdm = {
					enable = true;
				};
			};

			windowManager = {
				awesome = {
					enable = true;
					package = pkgs.awesome-git;
				};
			};
		};
	};

	systemd = {
		user = {
			services = {
				mate-polkit = {
					description = "polkit-mate-authentication-agent-1";
					wantedBy = [ "graphical-session.target" ];
					wants = [ "graphical-session.target" ];
					after = [ "graphical-session.target" ];
					serviceConfig = {
						Type = "simple";
						ExecStart = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
						Restart = "on-failure";
						RestartSec = 1;
						TimeoutStopSec = 10;
					};
				};
			};
		};
	};

	users.users.${user} = {
		isNormalUser = true;
		initialPassword = "bensmom";
		extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
		shell = pkgs.zsh;
		packages = [];
	};

	home-manager.users.${user} = { config, lib, stdenv, pkgs, ... }: {
		nixpkgs = {
			config = {
				allowUnfree = true;
			};

			overlays = [
				(final: prev: {
					osu-git = prev.callPackage ./pkgs/osu-lazer-bin.nix {
						src = inputs.osu;
						inherit (final) lib stdenv fetchurl fetchzip appimageTools;
					};
				})
			];
		};

		home = {
			stateVersion = "22.11";
			username = "${user}";
			homeDirectory = "/home/${user}";

			packages = with pkgs; [
				# Basic shit
				zsh neovim wezterm tmux firefox
				btop neofetch pavucontrol tokei gparted
				luajitPackages.lgi picom rofi flameshot
				discord signal-desktop xfce.thunar easyeffects gimp yt-dlp
				pass

				# Games
				osu-git steam minecraft

				# Dev
				direnv nix-direnv
				lazygit rustup nodePackages_latest.typescript-language-server taplo nil just jq
				docker-compose podman-compose
				postgresql delta

				# Virtualisation
				qemu qemu_kvm libvirt dnsmasq vde2 netcat-openbsd
				bridge-utils dconf pciutils virt-manager looking-glass-client

				# Twitch
				obs-studio showmethekey
			];

			file = {
				".zlogin".source = ../configs/shells/zsh/zlogin;
				".zshenv".source = ../configs/shells/zsh/zshenv;
				".zshrc".source = ../configs/shells/zsh/zshrc;
				".bashrc".source = ../configs/shells/bash/bashrc;
				".config/btop" = {
					source = ../configs/cli/btop;
					recursive = true;
				};
				".config/neofetch" = {
					source = ../configs/cli/neofetch;
					recursive = true;
				};
				".config/tmux" = {
					source = ../configs/cli/tmux;
					recursive = true;
				};
				".config/wezterm" = {
					source = ../configs/terminals/wezterm;
					recursive = true;
				};
				".Xresources".source = ../configs/desktop/.Xresources;
				".icons".source = ../configs/desktop/icons;
				".themes".source = ../configs/desktop/themes;
				".config/gtkrc".source = ../configs/desktop/gtkrc;
				".config/gtkrc-2.0".source = ../configs/desktop/gtkrc-2.0;
				".config/gtk-3.0" = {
					source = ../configs/desktop/gtk-3.0;
					recursive = true;
				};
				".config/gtk-4.0" = {
					source = ../configs/desktop/gtk-4.0;
					recursive = true;
				};
				".config/awesome" = {
					source = ../configs/desktop/awesome;
					recursive = true;
				};
				".config/picom" = {
					source = ../configs/desktop/picom;
					recursive = true;
				};
				".config/rofi" = {
					source = ../configs/desktop/rofi;
					recursive = true;
				};
				".config/clippy" = {
					source = ../configs/tools/clippy;
					recursive = true;
				};
				".config/rustfmt" = {
					source = ../configs/tools/rustfmt;
					recursive = true;
				};
				".config/lazygit" = {
					source = ../configs/tools/lazygit;
					recursive = true;
				};
				".config/starship.toml".source = ../configs/shells/prompts/starship.toml;
				".local/share/fonts" = {
					source = ../configs/desktop/fonts;
					recursive = true;
				};
			};
		};

		programs = {
			home-manager = {
				enable = true;
			};

			zsh = {
				enable = true;
			};

			direnv = {
				enable = true;
				nix-direnv = {
					enable = true;
				};
			};
		};

		systemd = {
			user = {
				startServices = "sd-switch";
			};
		};
	};
}

