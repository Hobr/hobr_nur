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
  oh-my-rime = pkgs.callPackage ./pkgs/oh-my-rime { };
  # rife-ncnn-vulkan = pkgs.callPackage ./pkgs/rife-ncnn-vulkan { };
  # real-esrgan = pkgs.callPackage ./pkgs/real-esrgan { };
}
