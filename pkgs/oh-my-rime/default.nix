{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "oh-my-rime";
  version = "2024-05-07 10:08";

  src = fetchFromGitHub {
    owner = "Mintimate";
    repo = "oh-my-rime";
    rev = "f06f9a6022125cf62ce858b758796fea339a2782";
    hash = "sha256-oCGgwNrQNSlRIgwm8DZk+sb+qP4kDWc929ea3SaTQ3s=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    cp -r * $out/share/rime-data/
  '';

  meta = with lib; {
    description = "薄荷输入法";
    homepage = "https://github.com/Mintimate/oh-my-rime";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
