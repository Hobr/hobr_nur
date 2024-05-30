{
  lib,
  python3,
  fetchFromGitHub,
  case-converter,
  eseries,
  quart-schema,
  easyeda2ato,
}:
with python3.pkgs;
buildPythonApplication rec {
  pname = "atopile";
  version = "0.2.53";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "atopile";
    rev = "v${version}";
    hash = "sha256-W2/JupgaO7GX31fv6U9Sm3gTKAvSxlL4Q9jLpD55oB4=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
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
    pyyaml
  ];

  passthru.optional-dependencies = {
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
    description = "Design circuit boards with code! Get software-like design reuse, validation, version control and collaboration in hardware; starting with electronics";
    homepage = "https://github.com/atopile/atopile";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "atopile";
  };
}
