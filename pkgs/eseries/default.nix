{
  lib,
  python3,
  fetchFromGitHub,
  docopt-subcommands,
}:

with python3.pkgs;
buildPythonApplication rec {
  pname = "eseries";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rob-smallshire";
    repo = "eseries";
    rev = "bfdeecf404e0e8226fb2a8fce97cc5f426420199";
    hash = "sha256-PgJvkvZOFGPPyAK1PAXHd57xfam9TviB+2hCz1702nY=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    future
    docopt-subcommands
  ];

  pythonImportsCheck = [ "eseries" ];

  meta = with lib; {
    description = "Find value in the E-series (E6, E12, E24, etc) used for electronic components values";
    homepage = "https://github.com/rob-smallshire/eseries";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "eseries";
  };
}
