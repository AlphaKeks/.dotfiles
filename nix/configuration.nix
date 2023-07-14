# https://GitHub.com/AlphaKeks/.dotfiles
# Documentation: `nixos-help` or `man 5 configuration.nix`

{ inputs, lib, pkgs, config, ... }:
let
	user = "alphakeks";
	stateVersion = "22.11";
	configs = ../configs;
	packages = ./pkgs;
	# neovim = pkgs.neovim;
	neovim = inputs.neovim-nightly.defaultPackage.x86_64-linux;
in
{
	# {{{ Nix

	system = {
		stateVersion = "${stateVersion}";
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

	# }}}

	# {{{ Hardware

	imports = [
		./hardware-configuration.nix
		inputs.home-manager.nixosModules.home-manager
	];

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

	# }}}

	# {{{ ResidentSleeper

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

	# }}}

	# {{{ System

	users = {
		users = {
			"${user}" = {
				isNormalUser = true;
				initialPassword = "bensmom";
				extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
				shell = pkgs.zsh;
				packages = with pkgs; [
					htop
					tmux
					qemu
					qemu_kvm
					libvirt
					dnsmasq
					vde2
					netcat-openbsd
					bridge-utils
					dconf
					pciutils
				];
			};
		};
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

	environment = {
		systemPackages = with pkgs; [
			zsh
			vim-full
			curl
			wget
			git
			coreutils
			bc
			zip unzip gzip
			killall
			gnupg
			pinentry pinentry-gnome
		];
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
				symbolsFile = "${configs}/X11/xkb/symbols/alpha";
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

		gnome = {
			gnome-keyring = {
				enable = true;
			};
		};
	};

	# }}}

	# {{{ nixpkgs

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

	# }}}

	# {{{ Virtualization

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
				enable = true;
				setSocketVariable = true;
				daemon = {
					settings = {
						data-root = "/mnt/dev/docker-rootless";
					};
				};
			};
		};
	};

	# }}}

	# {{{ home-manager

	home-manager = {
		users = {
			"${user}" = { stdenv, lib, pkgs, ... }: {

				# {{{ nixpkgs

				nixpkgs = {
					config = {
						allowUnfree = true;
					};

					overlays = [
						(final: prev: {
							osu-git = prev.callPackage "${packages}/osu-lazer-bin.nix" {
								src = inputs.osu;
								inherit (final) lib stdenv fetchurl fetchzip appimageTools;
							};
						})

						(final: prev: {
							inkdrop = prev.callPackage "${packages}/inkdrop.nix" {
								inherit (final)
									stdenv
									lib
									libxkbcommon
									libdrm
									alsaLib
									atk
									at-spi2-atk
									cairo
									cups
									dbus
									dpkg
									expat
									fontconfig
									freetype
									fetchurl
									gdk-pixbuf
									glib
									gtk2
									gtk3
									libpulseaudio
									makeWrapper
									nspr
									nss
									pango
									udev
									xorg
									libuuid
									at-spi2-core
									libsecret
									coreutils
									mesa
									gnome;
							};
						})
					];
				};

				# }}}

				# {{{ Home

				home = {
					stateVersion = "${stateVersion}";
					username = "${user}";
					homeDirectory = "/home/${user}";
					packages = with pkgs; [
						zsh
						"${neovim}"
						wezterm
						jetbrains-mono
						firefox

						# CLI tools
						jq
						fzf
						bat
						exa
						delta
						ripgrep-all
						btop
						neofetch
						tokei
						hyperfine
						starship
						lazygit
						websocat
						gh
						direnv nix-direnv
						gnumake
						cmake
						meson
						just
						yt-dlp
						pass
						gdb
						perf-tools
						cargo-flamegraph
						cargo-expand
						cargo-watch
						rustup

						# Dev
						gcc
						postgresql
						docker-compose
						podman-compose
						lua-language-server
						taplo
						nodePackages_latest.typescript-language-server
						nodePackages_latest.prettier
						nodePackages_latest.eslint
						nodePackages_latest.eslint_d

						# Desktop
						xclip
						gparted
						pavucontrol
						flameshot
						xfce.thunar
						obs-studio
						showmethekey
						peek
						gimp
						easyeffects
						discord
						signal-desktop
						picom
						rofi
						inkdrop
						obsidian
						luajitPackages.lgi # for awesome
						osu-git
					];

					file = {
						".bashrc" = {
							source = "${configs}/shells/bash/bashrc";
						};
						".zlogin" = {
							source = "${configs}/shells/zsh/zlogin";
						};
						".zshenv" = {
							source = "${configs}/shells/zsh/zshenv";
						};
						".zshrc" = {
							source = "${configs}/shells/zsh/zshrc";
						};
						".zhist" = {
							source = "${configs}/shells/zsh/zhist";
						};
						".zsh/plugins" = {
							source = "${configs}/shells/zsh/plugins";
							recursive = true;
						};
						".Xresources" = {
							source = "${configs}/desktop/.Xresources";
						};
						".xprofile" = {
							source = "${configs}/desktop/.xprofile";
						};
						"gtkrc" = {
							source = "${configs}/desktop/gtkrc";
						};
						"gtkrc-2.0" = {
							source = "${configs}/desktop/gtkrc-2.0";
						};
						".icons" = {
							source = "${configs}/desktop/.icons";
							recursive = true;
						};
						".themes" = {
							source = "${configs}/desktop/.themes";
							recursive = true;
						};
						".config/bat" = {
							source = "${configs}/cli/bat";
							recursive = true;
						};
						".config/btop" = {
							source = "${configs}/cli/btop";
							recursive = true;
						};
						".config/neofetch" = {
							source = "${configs}/cli/neofetch";
							recursive = true;
						};
						".config/tmux" = {
							source = "${configs}/cli/tmux";
							recursive = true;
						};
						".config/dunst" = {
							source = "${configs}/desktop/dunst";
							recursive = true;
						};
						".config/gtkrc" = {
							source = "${configs}/desktop/gtkrc";
						};
						".config/gtkrc-2.0" = {
							source = "${configs}/desktop/gtkrc-2.0";
						};
						".config/gtk-3.0" = {
							source = "${configs}/desktop/gtk-3.0";
							recursive = true;
						};
						".config/gtk-4.0" = {
							source = "${configs}/desktop/gtk-4.0";
							recursive = true;
						};
						".config/picom" = {
							source = "${configs}/desktop/picom";
							recursive = true;
						};
						".config/rofi" = {
							source = "${configs}/desktop/rofi";
							recursive = true;
						};
						".config/waybar" = {
							source = "${configs}/desktop/waybar";
							recursive = true;
						};
						".config/alacritty" = {
							source = "${configs}/terminals/alacritty";
							recursive = true;
						};
						".config/kitty" = {
							source = "${configs}/terminals/kitty";
							recursive = true;
						};
						".config/wezterm" = {
							source = "${configs}/terminals/wezterm";
							recursive = true;
						};
						".config/lazygit" = {
							source = "${configs}/tools/lazygit";
							recursive = true;
						};
						".config/rustfmt" = {
							source = "${configs}/tools/rustfmt";
							recursive = true;
						};
						".config/prettier" = {
							source = "${configs}/tools/prettier";
							recursive = true;
						};
						".config/starship.toml" = {
							source = "${configs}/shells/prompts/starship.toml";
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

				# }}}

			};
		};
	};

	# }}}
}

# vim: foldmethod=marker foldlevel=0 indentexpr=c
