{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "case-converter";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisdoherty4";
    repo = "python-case-converter";
    rev = "v${version}";
    hash = "sha256-iu6M+ZdzQGcYftRuW5jmPChQzs3Lots3Iu8I0rphdGk=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "caseconverter" ];

  meta = with lib; {
    description = "A case conversion library for Python";
    homepage = "https://github.com/chrisdoherty4/python-case-converter";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "case-converter";
  };
}
