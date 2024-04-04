# [1/327] Generating git_version.h with a custom command
# FAILED: git_version.h
# /build/source/tools/version.sh /build/source/build /build/source
# git repo not found and no cached git_version.h
{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  meson,
  ninja,
  cmake,
  pkg-config,
  luajit,
  gettext,
  wrapGAppsHook,
  fontconfig,
  libass,
  boost,
  wxGTK32,
  icu,
  ffms,
  fftw,
  libuchardet,
  ffmpeg,
  jansson,
  libGL,
  spellcheckSupport ? true,
  hunspell ? null,
  openalSupport ? false,
  openal ? null,
  alsaSupport ? stdenv.isLinux,
  alsa-lib ? null,
  pulseaudioSupport ? config.pulseaudio or stdenv.isLinux,
  libpulseaudio ? null,
  portaudioSupport ? false,
  portaudio ? null,
}:
assert spellcheckSupport -> (hunspell != null);
assert openalSupport -> (openal != null);
assert alsaSupport -> (alsa-lib != null);
assert pulseaudioSupport -> (libpulseaudio != null);
assert portaudioSupport -> (portaudio != null); let
  inherit (lib) optional;
  luajit52 = luajit.override {enable52Compat = true;};
  vapoursynth = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vapoursynth";
    rev = "R59";
    hash = "sha256-6w7GSC5ZNIhLpulni4sKq0OvuxHlTJRilBFGH5PQW8U=";
  };
  AviSynthPlus = fetchFromGitHub {
    owner = "AviSynth";
    repo = "AviSynthPlus";
    rev = "v3.7.2";
    hash = "sha256-PNIrDRJNKWEBPEKlCq0nE6UW0prVswE6mW+Fi4ROTAc=";
    fetchSubmodules = true;
  };
  bestsource = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "bestsource";
    rev = "ba1249c1f5443be6d0ec2be32490af5bbc96bf99";
    hash = "sha256-9BnyRzF33otju3W503O18JuTyvp+hFxk6JMwrozKoZY=";
    fetchSubmodules = true;
  };
  gtest = fetchurl {
    url = "https://github.com/google/googletest/archive/release-1.8.1.zip";
    hash = "sha256-kngnwYPQFzTMXP74Xg/z9akv/mGI4NGOkJxe/r8ooMc=";
  };
  gtest_patch = fetchurl {
    url = "https://wrapdb.mesonbuild.com/v1/projects/gtest/1.8.1/1/get_zip";
    hash = "sha256-959f1G4JUHs/LgmlHqbrIAIO/+VDM19a7lnzDMjRWAU=";
  };
in
  stdenv.mkDerivation rec {
    pname = "aegisub";
    version = "11";

    src = fetchFromGitHub {
      owner = "arch1t3cht";
      repo = "Aegisub";
      rev = "feature_${version}";
      hash = "sha256-yEXDwne+wros0WjOwQbvMIXk0UXV5TOoV/72K12vi/c=";
    };

    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/video/aegisub/default.nix
    # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=aegisub-arch1t3cht-git
    # https://github.com/arch1t3cht/Aegisub/blob/feature/meson.build
    nativeBuildInputs = [
      meson
      ninja
      cmake
      pkg-config
      luajit52
      gettext
    ];

    buildInputs =
      [
        fontconfig
        libass
        boost
        wxGTK32
        icu
        ffms
        fftw
        libuchardet
        ffmpeg
        jansson
        libGL
      ]
      ++ optional alsaSupport alsa-lib
      ++ optional openalSupport openal
      ++ optional portaudioSupport portaudio
      ++ optional pulseaudioSupport libpulseaudio
      ++ optional spellcheckSupport hunspell;

    env = {
      BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
      BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";
      NIX_CFLAGS_COMPILE = "-I${luajit52}/include";
      NIX_CFLAGS_LINK = "-L${luajit52}/lib";
    };

    # https://github.com/arch1t3cht/Aegisub/blob/feature/meson_options.txt
    # https://github.com/NixOS/nixpkgs/blob/8dab54e2b3c4d0c946e1a24cad6bf23e552b2b36/pkgs/development/libraries/gstreamer/ugly/default.nix#L68
    # https://github.com/NixOS/nixpkgs/blob/8dab54e2b3c4d0c946e1a24cad6bf23e552b2b36/pkgs/servers/pulseaudio/default.nix#L96
    mesonFlags = [
      "--buildtype=release"
      (lib.mesonEnable "alsa" false)

      (lib.mesonBool "b_lto" false)
      (lib.mesonEnable "openal" false)
      (lib.mesonEnable "libpulse" true)
      (lib.mesonEnable "portaudio" false)
      (lib.mesonEnable "directsound" false)
      (lib.mesonEnable "xaudio2" false)

      (lib.mesonOption "default_audio_output" "PulseAudio")

      (lib.mesonEnable "ffms2" true)
      (lib.mesonEnable "avisynth" true)
      (lib.mesonEnable "bestsource" true)
      (lib.mesonEnable "vapoursynth" true)

      (lib.mesonEnable "fftw3" true)
      (lib.mesonEnable "hunspell" true)
      (lib.mesonEnable "uchardet" true)
      (lib.mesonEnable "csri" true)
    ];

    hardeningDisable = [
      "bindnow"
      "relro"
    ];
    enableParallelBuilding = true;

    preConfigure = ''
      cp -r --no-preserve=mode ${vapoursynth} subprojects/vapoursynth
      cp -r --no-preserve=mode ${AviSynthPlus} subprojects/avisynth
      cp -r --no-preserve=mode ${bestsource} subprojects/bestsource

      mkdir subprojects/packagecache
      cp -r --no-preserve=mode ${gtest} subprojects/packagecache/gtest-1.8.1.zip
      cp -r --no-preserve=mode ${gtest_patch} subprojects/packagecache/gtest-1.8.1-1-wrap.zip

      meson subprojects packagefiles --apply bestsource
      meson subprojects packagefiles --apply avisynth
      meson subprojects packagefiles --apply vapoursynth


      mkdir -p build
      #echo "#define BUILD_GIT_VERSION_NUMBER 0" >> build/git_version.h
      #echo "#define BUILD_GIT_VERSION_STRING feature_${version} >> build/git_version.h
    '';

    meta = with lib; {
      description = "Cross-platform advanced subtitle editor, with new feature branches.";
      homepage = "https://github.com/arch1t3cht/Aegisub";
      license = licenses.bsd3;
      mainProgram = "aegisub";
      platforms = platforms.all;
    };
  }
