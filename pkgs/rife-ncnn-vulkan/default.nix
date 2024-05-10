{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  vulkan-headers,
  vulkan-loader,
}:

stdenv.mkDerivation rec {
  pname = "rife-ncnn-vulkan";
  version = "20221029";

  src = fetchFromGitHub {
    owner = "nihui";
    repo = "rife-ncnn-vulkan";
    rev = version;
    hash = "sha256-iLtBrEuUqvxB63MuKBYz9UpaxU/va4TFl+OxPC8hB1s=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  cmakeDir = "../src";

  meta = with lib; {
    description = "RIFE, Real-Time Intermediate Flow Estimation for Video Frame Interpolation implemented with ncnn library";
    homepage = "https://github.com/nihui/rife-ncnn-vulkan";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "rife-ncnn-vulkan";
    platforms = platforms.all;
  };
}
