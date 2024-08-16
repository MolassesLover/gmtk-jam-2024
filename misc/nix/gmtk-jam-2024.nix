{ pkgs, lib, stdenv,
nixgl ? import (fetchTarball "https://github.com/nix-community/nixGL/archive/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a.tar.gz") { } 
}:
stdenv.mkDerivation rec {
  name = "gmtk-jam-2024";

  src = ../../src;

  meta = with lib; { license = licenses.mit; };

  # As of August 16th, Godot 4.3 hasn't been added to Nixpkgs yet.
  buildInputs = [
    pkgs.autoPatchelfHook

    ((pkgs.godot_4.overrideAttrs (previousAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "godotengine";
        repo = "godot";
        rev = "77dcf97d82cbfe4e4615475fa52ca03da645dbd8";
        hash = "sha256-v2lBD3GEL8CoIwBl3UoLam0dJxkLGX0oneH6DiWkEsM=";
      };
    })))

    pkgs.unzip
    nixgl.auto.nixGLDefault
  ];

  shellHook = ''
    alias gmtk-jam-2024="nixGL gmtk-jam-2024 -e"
  '';

  templates = pkgs.fetchurl {
    url =
      "https://downloads.tuxfamily.org/godotengine/4.3/Godot_v4.3-stable_export_templates.tpz";
    hash = "sha256-9fENuvVqeQg0nmS5TqjCyTwswR+xAUyVZbaKK7Q3uSI=";
  };

  buildPhase = ''
    	# Prevent Nix from writing to the non-writable /homeless-shelter/ directory
    	export HOME=$(pwd)
    	export TEMPLATE_DIRECTORY=$HOME/.local/share/godot/export_templates/4.3.stable/
    	mkdir -p "$TEMPLATE_DIRECTORY"
        unzip ${templates} -d /tmp/
	mv /tmp/templates/* "$TEMPLATE_DIRECTORY"
	mkdir -p $out/bin/
	godot4 --headless --export-release "Linux/X11" $out/bin/gmtk-jam-2024
  '';

  installPhase = '' 
  	runHook preInstall
	runHook postInstall
  '';
}
