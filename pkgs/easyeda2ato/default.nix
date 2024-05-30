{
  lib,
  python3,
  fetchPypi,
}:

with python3.pkgs;
buildPythonApplication rec {
  pname = "easyeda2ato";
  version = "0.2.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bHhBN+h9Vx9Q4wZVKxMzkEEXzV7hKoQz8i+JpkSFsYA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    pydantic
    requests
  ];

  passthru.optional-dependencies = {
    dev = [ pre-commit ];
  };

  pythonImportsCheck = [ "easyeda2kicad" ];

  meta = with lib; {
    description = "A Python script that convert any electronic components from LCSC or EasyEDA to a Kicad library";
    homepage = "https://pypi.org/project/easyeda2ato/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "easyeda2ato";
  };
}
