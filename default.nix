{ nixpkgs ? import <nixpkgs> { },
  packageOverrides ? pkgs: {} }:

nixpkgs.callPackage ./toplevel.nix { inherit packageOverrides; }
