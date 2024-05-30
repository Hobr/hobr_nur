{
  lib,
  python3,
  fetchFromGitHub,
}:
with python3.pkgs;
buildPythonApplication rec {
  pname = "easyeda2kicad";
  version = "0.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uPesy";
    repo = "easyeda2kicad.py";
    rev = "v${version}";
    hash = "sha256-yHwYYWX6gmzQcp/bNq5ouMYkO5oSsAOIhvyyZgdlCRs=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    pydantic
    requests
  ];

  pythonImportsCheck = [ "easyeda2kicad" ];

  meta = with lib; {
    description = "Convert any LCSC components (including EasyEDA) to KiCad library";
    homepage = "https://github.com/uPesy/easyeda2kicad.py";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "easyeda2kicad";
  };
}
