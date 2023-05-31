{ src, lib, stdenv, fetchurl, fetchzip, appimageTools }:

let
  pname = "osu-lazer-bin";
  version = "git-latest";
  name = "${pname}-${version}";

  linux = appimageTools.wrapType2 rec {
    inherit name pname version meta src;

    extraPkgs = pkgs: with pkgs; [ icu ];

    extraInstallCommands =
      let contents = appimageTools.extract { inherit pname version src; };
      in
      ''
        mv -v $out/bin/${pname}-${version} $out/bin/osu\!
        install -m 444 -D ${contents}/osu\!.desktop -t $out/share/applications
        for i in 16 32 48 64 96 128 256 512 1024; do
          install -D ${contents}/osu\!.png $out/share/icons/hicolor/''${i}x$i/apps/osu\!.png
        done
      '';
  };

  meta = with lib; {
    description = "Rhythm is just a *click* away (AppImage version for score submission and multiplayer, and binary distribution for Darwin systems)";
    homepage = "https://osu.ppy.sh";
    license = with licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable # osu-framework contains libbass.so in repository
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ delan stepbrobd alphakeks ];
    mainProgram = "osu!";
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
  };
in
linux
