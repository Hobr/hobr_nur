# nix-build -A mypackage
{
  pkgs ? import <nixpkgs> { },
}:
{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  aegisub = pkgs.callPackage ./pkgs/aegisub { };
  rime-ice = pkgs.callPackage ./pkgs/rime-ice { };
}
