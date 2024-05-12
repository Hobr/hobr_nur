{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ultimatevocalremovergui";
  version = "5.6";

  src = fetchFromGitHub {
    owner = "Anjok07";
    repo = "ultimatevocalremovergui";
    rev = "v${version}";
    hash = "sha256-2FV7qO40LcyJTrHiWeCzAPvelcgGc+InrsXv9/QGLkA=";
  };

  meta = with lib; {
    description = "GUI for a Vocal Remover that uses Deep Neural Networks";
    homepage = "https://github.com/Anjok07/ultimatevocalremovergui";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    mainProgram = "ultimatevocalremovergui";
    platforms = platforms.all;
  };
}
