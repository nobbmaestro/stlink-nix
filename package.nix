{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:
stdenv.mkDerivation rec {
  pname = "stlink";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "stlink-org";
    repo = "stlink";
    rev = "v${version}";
    sha256 = "sha256-9Pm3zaecl7xKQLMlfcFd9eT5djK49vVZrpHcdZ27vg8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DLIBUSB_LIBRARY=${lib.getLib libusb1}/lib/libusb-1.0.dylib"
    "-DLIBUSB_INCLUDE_DIR=${lib.getDev libusb1}/include/libusb-1.0"
  ];

  meta = with lib; {
    description = "Open source STM32 MCU programming toolset";
    homepage = "https://github.com/stlink-org/stlink";
    license = licenses.bsd3;
    platforms = [ "aarch64-darwin" ];
    maintainers = [ "nobbmaestro" ];
  };
}
