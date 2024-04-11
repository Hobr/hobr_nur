{ lib, config, stdenv, fetchFromGitHub, fetchurl, meson, ninja, cmake
, pkg-config, luajit, gettext, python3, wrapGAppsHook, fontconfig, libass, boost
, wxGTK32, icu, ffms, fftw, libuchardet, ffmpeg_4, jansson, libGL, zlib, libX11
, spellcheckSupport ? true, hunspell ? null, openalSupport ? false
, openal ? null, alsaSupport ? stdenv.isLinux, alsa-lib ? null
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio ? null
, portaudioSupport ? false, portaudio ? null, darwin, }:
assert spellcheckSupport -> (hunspell != null);
assert openalSupport -> (openal != null);
assert alsaSupport -> (alsa-lib != null);
assert pulseaudioSupport -> (libpulseaudio != null);
assert portaudioSupport -> (portaudio != null);
let
  inherit (darwin.apple_sdk.frameworks)
    CoreText CoreFoundation AppKit Carbon IOKit Cocoa;
  inherit (lib) optional;

  luajit52 = luajit.override { enable52Compat = true; };

  bestsource = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "bestsource";
    # https://github.com/arch1t3cht/Aegisub/blob/feature_11/subprojects/bestsource.wrap#L3
    rev = "ba1249c1f5443be6d0ec2be32490af5bbc96bf99";
    hash = "sha256-9BnyRzF33otju3W503O18JuTyvp+hFxk6JMwrozKoZY=";
    fetchSubmodules = true;
  };

  vapoursynth = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vapoursynth";
    # https://github.com/arch1t3cht/Aegisub/blob/feature_11/subprojects/vapoursynth.wrap#L3
    rev = "R59";
    hash = "sha256-6w7GSC5ZNIhLpulni4sKq0OvuxHlTJRilBFGH5PQW8U=";
  };

  AviSynthPlus = fetchFromGitHub {
    owner = "AviSynth";
    repo = "AviSynthPlus";
    # https://github.com/arch1t3cht/Aegisub/blob/feature_11/subprojects/avisynth.wrap#L3
    rev = "v3.7.2";
    hash = "sha256-PNIrDRJNKWEBPEKlCq0nE6UW0prVswE6mW+Fi4ROTAc=";
    fetchSubmodules = true;
  };

  gtest = fetchurl {
    # https://github.com/arch1t3cht/Aegisub/blob/feature_11/subprojects/gtest.wrap#L4
    url = "https://github.com/google/googletest/archive/release-1.8.1.zip";
    hash = "sha256-kngnwYPQFzTMXP74Xg/z9akv/mGI4NGOkJxe/r8ooMc=";
  };

  gtest_patch = fetchurl {
    # https://github.com/arch1t3cht/Aegisub/blob/feature_11/subprojects/gtest.wrap#L8
    url = "https://wrapdb.mesonbuild.com/v1/projects/gtest/1.8.1/1/get_zip";
    hash = "sha256-959f1G4JUHs/LgmlHqbrIAIO/+VDM19a7lnzDMjRWAU=";
  };
in stdenv.mkDerivation rec {
  pname = "aegisub";
  version = "feature_11";

  src = fetchFromGitHub {
    owner = "arch1t3cht";
    repo = "Aegisub";
    rev = version;
    hash = "sha256-yEXDwne+wros0WjOwQbvMIXk0UXV5TOoV/72K12vi/c=";
  };

  nativeBuildInputs = [ meson ninja cmake pkg-config luajit52 gettext python3 ];

  buildInputs = [
    fontconfig
    libass
    boost
    wxGTK32
    icu
    ffms
    fftw
    libuchardet
    ffmpeg_4
    jansson
    libGL
    zlib
    libX11
  ] ++ optional alsaSupport alsa-lib ++ optional openalSupport openal
    ++ optional portaudioSupport portaudio
    ++ optional pulseaudioSupport libpulseaudio
    ++ optional spellcheckSupport hunspell ++ lib.optionals stdenv.isDarwin [
      CoreText
      CoreFoundation
      AppKit
      Carbon
      IOKit
      Cocoa
    ];

  env = {
    BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
    BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";
  };

  patches = [
    # https://aur.archlinux.org/cgit/aur.git/tree/0001-bas-to-bs.patch?h=aegisub-arch1t3cht
    ./0001-bas-to-bs.patch
    # Fix git_version.h unable to generate
    ./0002-remove-git-version.patch
    # Fix meson unable exec python respack
    # https://github.com/arch1t3cht/Aegisub/pull/121
    ./0003-respack-unable-run.patch
  ];

  mesonFlags = [
    "--buildtype=release"
    (lib.mesonBool "b_lto" false)
    (lib.mesonOption "default_audio_output" "auto")
    (lib.mesonEnable "alsa" alsaSupport)
    (lib.mesonEnable "openal" openalSupport)
    (lib.mesonEnable "libpulse" pulseaudioSupport)
    (lib.mesonEnable "portaudio" portaudioSupport)
    (lib.mesonEnable "directsound" false)
    (lib.mesonEnable "xaudio2" false)

    (lib.mesonEnable "ffms2" true)
    (lib.mesonEnable "avisynth" true)
    (lib.mesonEnable "bestsource" true)
    (lib.mesonEnable "vapoursynth" true)

    (lib.mesonEnable "fftw3" true)
    (lib.mesonEnable "uchardet" true)
    (lib.mesonEnable "csri" true)
    (lib.mesonEnable "hunspell" spellcheckSupport)
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    cp -r --no-preserve=mode ${bestsource} subprojects/bestsource
    cp -r --no-preserve=mode ${AviSynthPlus} subprojects/avisynth
    cp -r --no-preserve=mode ${vapoursynth} subprojects/vapoursynth

    mkdir subprojects/packagecache
    cp -r --no-preserve=mode ${gtest} subprojects/packagecache/gtest-1.8.1.zip
    cp -r --no-preserve=mode ${gtest_patch} subprojects/packagecache/gtest-1.8.1-1-wrap.zip

    meson subprojects packagefiles --apply bestsource
    meson subprojects packagefiles --apply avisynth
    meson subprojects packagefiles --apply vapoursynth
  '';

  meta = with lib; {
    description =
      "Cross-platform advanced subtitle editor, with new feature branches.";
    homepage = "https://github.com/arch1t3cht/Aegisub";
    license = licenses.bsd3;
    platforms = platforms.unix;
    mainProgram = "aegisub";
  };
}
