{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "swingmusic";
  version = "1.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "swingmx";
    repo = "swingmusic";
    rev = "v${version}";
    hash = "sha256-Bm7RBmVRCRvAxculH9an05yj7Rta0yttCfyJnMvwbjI=";
  };

  nativeBuildInputs = [ python3.pkgs.poetry-core ];

  propagatedBuildInputs = with python3.pkgs; [
    colorgram-py
    flask
    flask-compress
    flask-cors
    flask-restful
    locust
    pendulum
    pillow
    psutil
    rapidfuzz
    requests
    setproctitle
    show-in-file-manager
    tabulate
    tinytag
    tqdm
    unidecode
    waitress
    watchdog
  ];

  pythonImportsCheck = [ "swing_music_player" ];

  meta = with lib; {
    description = "Swing Music is a beautiful, self-hosted music player for your local audio files. Like a cooler Spotify ... but bring your own music";
    homepage = "https://github.com/swingmx/swingmusic";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "swingmusic";
  };
}
