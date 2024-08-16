{ 
pkgs ? import <nixpkgs> { },
}: pkgs.callPackage ./misc/nix/gmtk-jam-2024.nix { }
