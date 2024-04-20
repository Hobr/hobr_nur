{ lib, config, stdenv, fetchFromGitHub, fetchurl, fetchpatch,

meson, cmake, luajit, ninja, pkg-config, wrapGAppsHook, wxGTK32, python3
, gettext,

boost, ffmpeg_4, ffms, fftw, fontconfig, icu, libGL, libGLU, libX11, libass
, libiconv, libuchardet, zlib, jansson,

alsaSupport ? stdenv.isLinux, alsa-lib, openalSupport ? true, openal
, portaudioSupport ? false, portaudio
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio
, spellcheckSupport ? true, hunspell,

darwin }:

let
  inherit (darwin.apple_sdk.frameworks)
    AppKit Carbon Cocoa CoreFoundation CoreText IOKit OpenAL QuartzCore;

  luajit52 = luajit.override { enable52Compat = true; };

  # from subprojects folder
  bestsource = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "bestsource";
    rev = "ba1249c1f5443be6d0ec2be32490af5bbc96bf99";
    hash = "sha256-9BnyRzF33otju3W503O18JuTyvp+hFxk6JMwrozKoZY=";
  };

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

  gtest = fetchurl {
    url = "https://github.com/google/googletest/archive/release-1.8.1.zip";
    hash = "sha256-kngnwYPQFzTMXP74Xg/z9akv/mGI4NGOkJxe/r8ooMc=";
  };

  gtest_patch = fetchurl {
    url = "https://wrapdb.mesonbuild.com/v1/projects/gtest/1.8.1/1/get_zip";
    hash = "sha256-959f1G4JUHs/LgmlHqbrIAIO/+VDM19a7lnzDMjRWAU=";
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "aegisub";
  version = "11";

  src = fetchFromGitHub {
    owner = "arch1t3cht";
    repo = "Aegisub";
    rev = "feature_${finalAttrs.version}";
    hash = "sha256-yEXDwne+wros0WjOwQbvMIXk0UXV5TOoV/72K12vi/c=";
  };

  nativeBuildInputs = [
    meson
    cmake
    luajit52
    ninja
    pkg-config
    wrapGAppsHook
    wxGTK32
    python3
    gettext
  ];

  buildInputs = [
    boost
    ffmpeg_4
    ffms
    fftw
    fontconfig
    icu
    libGL
    libGLU
    libX11
    libass
    libiconv
    libuchardet
    wxGTK32
    zlib
    jansson
  ] ++ lib.optionals alsaSupport [ alsa-lib ] ++ lib.optionals openalSupport
    [ (if stdenv.isDarwin then OpenAL else openal) ]
    ++ lib.optionals portaudioSupport [ portaudio ]
    ++ lib.optionals pulseaudioSupport [ libpulseaudio ]
    ++ lib.optionals spellcheckSupport [ hunspell ]
    ++ lib.optionals stdenv.isDarwin [
      AppKit
      Carbon
      Cocoa
      CoreFoundation
      CoreText
      IOKit
      QuartzCore
    ];

  patches = [
    # Replace bestaudiosource with bestscore
    (fetchpatch {
      name = "0001-bas-to-bs.patch";
      url =
        "https://aur.archlinux.org/cgit/aur.git/plain/0001-bas-to-bs.patch?h=aegisub-arch1t3cht&id=bbbea73953858fc7bf2775a0fb92cec49afb586c";
      hash = "sha256-T0Msa8rpE3Qo++Tq6J/xdsDX9f1vVIj/b9rR/iuIGK4=";
    })
    # Fix unable to generate git_version.h
    ./0002-remove-git-version.patch
    # Fix meson unable exec python respack
    ./0003-respack-unable-run.patch
  ];

  env = {
    BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
    BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";
  };

  mesonBuildType = "release";

  mesonFlags = [
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
  ] ++ lib.optionals stdenv.isDarwin [
    # Follow https://github.com/arch1t3cht/Aegisub/blob/feature_11/.github/workflows/ci.yml
    "--force-fallback-for=ffms2"
    (lib.mesonOption "default_library" "static")
    (lib.mesonBool "build_osx_bundle" true)
    (lib.mesonBool "local_boost" true)
  ];

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

  meta = {
    homepage = "https://github.com/arch1t3cht/Aegisub";
    description = "An advanced subtitle editor; arch1t3cht's fork";
    longDescription = ''
      Aegisub is a free, cross-platform open source tool for creating and
      modifying subtitles. Aegisub makes it quick and easy to time subtitles to
      audio, and features many powerful tools for styling them, including a
      built-in real-time video preview.
    '';
    # The Aegisub sources are itself BSD/ISC, but they are linked against GPL'd
    # softwares - so the resulting program will be GPL
    license = with lib.licenses; [ bsd3 ];
    mainProgram = "aegisub";
    platforms = lib.platforms.unix;
  };
})
