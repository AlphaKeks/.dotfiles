# https://git.sr.ht/~fd/nix-configs/tree/02c23ae9f72801e0343157fdfef714d3d84ff26b/item/custompkgs/mission-center/default.nix

{ pkgs, ... }:
with pkgs;
let
	pname = "mission-center";
	version = "0.2.3";

	src = fetchFromGitLab {
		owner = "mission-center-devs";
		repo = pname;
		rev = "v${version}";
		hash = "sha256-htSuFsHvEsfHS1mJ0l5ZrZBa1Ir9PZ5Yqm9ezYU4zeU=";
	};
	nvtop = fetchFromGitHub {
		owner = "Syllo";
		repo = "nvtop";
		rev = "9a8458b541a195a0c5cadafb66e240962c852b39";
		hash = "sha256-iFBZbESRTuwgLSUuHnjcXwmpvdeQrd3oUJd7BRyxu84=";
	};
in stdenv.mkDerivation rec {
	inherit src version pname;

	cargoDepsBase = rustPlatform.importCargoLock {
		lockFile = ./Cargo.lock;
		outputHashes = {
			 "pathfinder_canvas-0.5.0" = "sha256-k2Sj69hWA0UzRfv91aG1TAygVIuOX3gmipcDbuZxxc8=";
		};
	};
	cargoDepsProxy = rustPlatform.importCargoLock {
		lockFile = ./proxy-Cargo.lock;
	};

	cargoDeps = symlinkJoin {
		name = "cargo-vendor-dir";
		paths = [ cargoDepsBase cargoDepsProxy ];
	};

	nativeBuildInputs = [
		pkg-config
		meson
		ninja
		rustc
		cargo
		cmake
		rustPlatform.cargoSetupHook
		python311Full
		libxml2
		wrapGAppsHook
	];

	buildInputs = [
		wayland
		glib
		cairo
		gdk-pixbuf
		gtk4
		pango
		gettext
		graphene
		libadwaita
		udev
		blueprint-compiler
		libdrm
		desktop-file-utils
		mesa
		appstream-glib
		dmidecode
	];

	postPatch = ''
		echo -e "[wrap-file]\ndirectory = nvtop-src\n[provide]\ndependency_names = nvtop" > ./subprojects/nvtop.wrap
		cp -r --no-preserve=mode,ownership "${nvtop}" ./subprojects/nvtop-src
		cd ./subprojects/nvtop-src
		mkdir -p include/libdrm
		for patchfile in $(ls ../packagefiles/nvtop*.patch); do
		  patch -p1 < $patchfile
		done
		cd ../..
		patchShebangs data/hwdb/generate_hwdb.py
		sed -i 's|cmd.arg("dmidecode")|cmd.arg("${pkgs.dmidecode}/bin/dmidecode")|g' src/sys_info_v2/mem_info.rs
	'';

	meta = with lib; {
		description = "Monitor your CPU, Memory, Disk, Network and GPU usage";
		homepage = "https://gitlab.com/mission-center-devs/mission-center";
		license = licenses.gpl3;
		mainProgram = "missioncenter";
		maintainers = with maintainers; [ "9p4" ];
		platforms = platforms.linux;
	};
}
