{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "atopile";
  version = "0.2.49";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "atopile";
    rev = "v${version}";
    hash = "sha256-fM4y2O3wRLogV/fSonqhyGuasOeHUuG/COp1yIgZeZk=";
  };

  nativeBuildInputs = [
    python3.pkgs.hatch-vcs
    python3.pkgs.hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    antlr4-python3-runtime
    attrs
    case-converter
    cattrs
    click
    deepdiff
    easyeda2ato
    eseries
    fastapi
    gitpython
    igraph
    jinja2
    natsort
    networkx
    packaging
    pandas
    pint
    pygls
    quart
    quart-cors
    quart-schema
    rich
    ruamel-yaml
    schema
    scipy
    semver
    toolz
    uvicorn
    watchfiles
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    dev = [
      antlr4-tools
      black
      debugpy
      ruff
    ];
    docs = [
      mkdocs
      mkdocs-drawio-file
      mkdocs-material
    ];
    test = [
      pytest
      pytest-asyncio
      pytest-datafiles
      pytest-html
      requests
    ];
  };

  pythonImportsCheck = [ "atopile" ];

  meta = with lib; {
    description = "Design circuit boards with code! ✨ Get software-like design reuse 🚀, validation, version control and collaboration in hardware; starting with electronics";
    homepage = "https://github.com/atopile/atopile";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "atopile";
  };
}
