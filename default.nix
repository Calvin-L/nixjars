{ nixpkgs ? import <nixpkgs> { } }:

nixpkgs.callPackage ./toplevel.nix {}
