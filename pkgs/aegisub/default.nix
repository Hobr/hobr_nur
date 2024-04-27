{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,

  meson,
  cmake,
  luajit,
  ninja,
  pkg-config,
  intltool,
  python3,
  gettext,

  dav1d,
  expat,
  ffmpeg,
  fftw,
  freetype,
  fontconfig,
  fribidi,
  harfbuzz,
  icu,
  jansson,
  libass,
  libGL,
  libGLU,
  libiconv,
  libpng,
  libuchardet,
  libX11,
  nasm,
  wxGTK32,
  zlib,

  alsaSupport ? stdenv.isLinux,
  alsa-lib,
  openalSupport ? true,
  openal,
  portaudioSupport ? false,
  portaudio,
  pulseaudioSupport ? config.pulseaudio or stdenv.isLinux,
  libpulseaudio,
  spellcheckSupport ? true,
  hunspell,

  darwin
}:

let
  inherit (darwin.apple_sdk.frameworks)
    AppKit
    Carbon
    Cocoa
    CoreFoundation
    CoreText
    IOKit
    OpenAL
    QuartzCore;

  luajit = luajit.override { enable52Compat = true; };

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

  ffms2 = fetchFromGitHub {
    owner = "arch1t3cht";
    repo = "ffms2";
    rev = "f463e4cae01e57f130742ebc7594a926da9d7261";
    hash = "sha256-wt6FMQC57FMHHed+tJ2w+b/x/tswfmRM3WRBBKyufHg=";
  };

  boost = fetchurl {
    url = "https://boostorg.jfrog.io/artifactory/main/release/1.74.0/source/boost_1_74_0.tar.gz";
    hash = "sha256-r/8205KIUSC8rAeRSMF30fb3cw7D1HIzqlGwr6TblKU=";
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
stdenv.mkDerivation (finalAttrs: {
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
    luajit
    ninja
    pkg-config
    intltool
    python3
    gettext
  ];

  buildInputs = [
    dav1d
    expat
    ffmpeg
    fftw
    freetype
    fontconfig
    fribidi
    harfbuzz
    icu
    jansson
    libass
    libGL
    libGLU
    libiconv
    libpng
    libuchardet
    libX11
    nasm
    wxGTK32
    zlib
  ]
  ++ lib.optionals alsaSupport [ alsa-lib ]
  ++ lib.optionals openalSupport [ openal ]
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
    OpenAL
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

  mesonBuildType = "release";
  dontUseCmakeConfigure = true;

  mesonFlags = [
    "--force-fallback-for=ffms2"
    (lib.mesonOption "default_library" "static")
    (lib.mesonBool "local_boost" true)

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
  ]
  ++ lib.optionals stdenv.isDarwin [ (lib.mesonBool "build_osx_bundle" true) ];

  preConfigure = ''
    cp -r --no-preserve=mode ${bestsource} subprojects/bestsource
    cp -r --no-preserve=mode ${AviSynthPlus} subprojects/avisynth
    cp -r --no-preserve=mode ${vapoursynth} subprojects/vapoursynth
    cp -r --no-preserve=mode ${ffms2} subprojects/ffms2

    mkdir subprojects/packagecache
    cp -r --no-preserve=mode ${gtest} subprojects/packagecache/gtest-1.8.1.zip
    cp -r --no-preserve=mode ${gtest_patch} subprojects/packagecache/gtest-1.8.1-1-wrap.zip
    cp -r --no-preserve=mode ${boost} subprojects/packagecache/boost_1_74_0.tar.gz

    meson subprojects packagefiles --apply bestsource
    meson subprojects packagefiles --apply avisynth
    meson subprojects packagefiles --apply vapoursynth
    meson subprojects packagefiles --apply ffms2
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
    license = with lib.licenses; [
      bsd3
    ];
    mainProgram = "aegisub";
    platforms = lib.platforms.unix;
  };
})
