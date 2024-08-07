{
  lib,
  python3,
  fetchFromGitHub,
  case-converter,
  eseries,
  quart-schema,
  easyeda2ato,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "atopile";
  version = "0.2.63";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "atopile";
    rev = "v${version}";
    hash = "sha256-Gi+gVYjsQKdtUKEz5yQ0D1llfT9NznQjEDTS+JpnAFY=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatch-vcs
    hatchling
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
    fake-useragent
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

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = with lib; {
    description = "Design circuit boards with code! Get software-like design reuse, validation, version control and collaboration in hardware; starting with electronics";
    homepage = "https://github.com/atopile/atopile";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "atopile";
  };
}
