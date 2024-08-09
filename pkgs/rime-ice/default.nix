{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "rime-ice";
  version = "2024.08-09";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "f0bf04f32823e12ae9026ff046509c9bb7d2fb5f";
    hash = "sha256-p3Wmv1NMx/Ie1ZblxVxgosb45ZhSY5UNxS7wml8fEE0=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    cp -r * $out/share/rime-data/
  '';

  meta = with lib; {
    description = "Rime 配置：雾凇拼音 | 长期维护的简体词库";
    homepage = "https://github.com/iDvel/rime-ice";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
