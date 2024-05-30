{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python310,
  ffmpeg,
}:
let
  defaultOverrides = [
    (self: super: {
      aioaladdinconnect = super.aioaladdinconnect.overridePythonAttrs (oldAttrs: rec {
        version = "0.1.58";
        src = fetchPypi {
          pname = "AIOAladdinConnect";
          inherit version;
          hash = "sha256-ymynaOKvnqqHIEuQc+5CagsaH5cHnQit8ileoUO6G+I=";
        };
      });
    })
  ];

  python = python310.override { packageOverrides = lib.composeManyExtensions defaultOverrides; };
in
python.pkgs.buildPythonApplication rec {
  pname = "ultimatevocalremovergui";
  version = "5.6";

  src = fetchFromGitHub {
    owner = "Anjok07";
    repo = "ultimatevocalremovergui";
    rev = "v${version}";
    hash = "sha256-2FV7qO40LcyJTrHiWeCzAPvelcgGc+InrsXv9/QGLkA=";
  };

  build-system = with python.pkgs; [
    setuptools
    wheel
  ];

  dependencies =
    with python.pkgs;
    (
      [
        tkinter
        altgraph
        audioread
        certifi
        cffi
        cryptography
        einops
        future
        julius
        #kthread
        librosa
        llvmlite
        #matchering
        ml-collections
        natsort
        omegaconf
        opencv4
        pillow
        psutil
        pydub
        pyglet
        pyperclip
        #pyrubberband
        pytorch-lightning
        pyyaml
        resampy
        scipy
        #soundstretch
        torch
        urllib3
        wget
        samplerate
        screeninfo
        #diffq
        playsound
        onnx
        onnxruntime
        #onnxruntime-gpu
        #onnx2pytorch
        #dora
        numpy
      ]
      ++ lib.optionals (!stdenv.isDarwin) [
        soundfile
        pysoundfile
      ]
    );

  buildInputs = [ ffmpeg ];

  meta = with lib; {
    description = "GUI for a Vocal Remover that uses Deep Neural Networks";
    homepage = "https://github.com/Anjok07/ultimatevocalremovergui";
    license = licenses.free;
    maintainers = with maintainers; [ ];
    mainProgram = "ultimatevocalremovergui";
    platforms = platforms.all;
  };
}
