{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "quart-schema";
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = "quart-schema";
    rev = version;
    hash = "sha256-3sNxhRvxjfB/86tl+QCyz95TZ69Akm+cvSe6mYbDGSg=";
  };

  nativeBuildInputs = [ python3.pkgs.poetry-core ];

  propagatedBuildInputs = with python3.pkgs; [
    pyhumps
    quart
    typing-extensions
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    docs = [
      pydata_sphinx_theme
      sphinx-tabs
    ];
    msgspec = [ msgspec ];
    pydantic = [ pydantic ];
  };

  pythonImportsCheck = [ "quart_schema" ];

  meta = with lib; {
    description = "Quart-Schema is a Quart extension that provides schema validation and auto-generated API documentation";
    homepage = "https://github.com/pgjones/quart-schema";
    changelog = "https://github.com/pgjones/quart-schema/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "quart-schema";
  };
}
