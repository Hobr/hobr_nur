{
  lib,
  python3,
  fetchFromGitHub,
}:

with python3.pkgs;
buildPythonApplication rec {
  pname = "docopt-subcommands";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abingham";
    repo = "docopt-subcommands";
    rev = "5693cbac24701c53e55fa182c1d563736e6a0557";
    hash = "sha256-bNFmRMzyC9BQB/J0ACqYxkS7lHG4CWd5/by7QgCopFo=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ docopt ];

  pythonImportsCheck = [ "docopt_subcommands" ];

  meta = with lib; {
    description = "Create subcommand-based command-line programs with docopt";
    homepage = "https://github.com/abingham/docopt-subcommands";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "docopt-subcommands";
  };
}
