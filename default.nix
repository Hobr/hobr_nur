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

  atopile = pkgs.callPackage ./pkgs/atopile {
    case-converter = pkgs.callPackage ./pkgs/case-converter { };
    eseries = pkgs.callPackage ./pkgs/eseries {
      docopt-subcommands = pkgs.callPackage ./pkgs/docopt-subcommands { };
    };
    quart-schema = pkgs.callPackage ./pkgs/quart-schema { };
    easyeda2ato = pkgs.callPackage ./pkgs/easyeda2ato { };
  };
  easyeda2ato = pkgs.callPackage ./pkgs/easyeda2ato { };
  case-converter = pkgs.callPackage ./pkgs/case-converter { };
  eseries = pkgs.callPackage ./pkgs/eseries {
    docopt-subcommands = pkgs.callPackage ./pkgs/docopt-subcommands { };
  };
  docopt-subcommands = pkgs.callPackage ./pkgs/docopt-subcommands { };
  quart-schema = pkgs.callPackage ./pkgs/quart-schema { };

  easyeda2kicad = pkgs.callPackage ./pkgs/easyeda2kicad { };
  # ultimatevocalremovergui = pkgs.callPackage ./pkgs/ultimatevocalremovergui { };
  # storyboarder = pkgs.callPackage ./pkgs/storyboarder { };
  # paperlib = pkgs.callPackage ./pkgs/paperlib { };
  # liteloaderqqnt = pkgs.callPackage ./pkgs/liteloaderqqnt { };
  # icdea-stardnd = pkgs.callPackage ./pkgs/icdea-stardnd { };
  # iceda-pro = pkgs.callPackage ./pkgs/iceda-pro { };
  # rvemu = pkgs.callPackage ./pkgs/rvemu { };
  # njuemu = pkgs.callPackage ./pkgs/njuemu { };
  # gem5 = pkgs.callPackage ./pkgs/gem5 { };
  # rife-ncnn-vulkan = pkgs.callPackage ./pkgs/rife-ncnn-vulkan { };
  # real-esrgan = pkgs.callPackage ./pkgs/real-esrgan { };
  # waifu2x-ncnn-vulkan = pkgs.callPackage ./pkgs/waifu2x-ncnn-vulkan { };
  # terminalizer = pkgs.callPackage ./pkgs/terminalizer { };
  # howdy = pkgs.callPackage ./pkgs/howdy { };
  # o3de = pkgs.callPackage ./pkgs/o3de { };
}
