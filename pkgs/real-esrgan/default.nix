{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "real-esrgan";
  version = "unstable";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xinntao";
    repo = "Real-ESRGAN";
    rev = "a4abfb2979a7bbff3f69f58f58ae324608821e27";
    hash = "sha256-dctuI3GYEZBcYYAR4VqwXr8vUJXoVFvyH5bYCIaAWho=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    basicsr
    facexlib
    gfpgan
    numpy
    opencv-python
    pillow
    torch
    torchvision
    tqdm
  ];

  pythonImportsCheck = [ "real_esrgan" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/xinntao/Real-ESRGAN";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    mainProgram = "real-esrgan";
  };
}
