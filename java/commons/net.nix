{lib, fetchFromGitHub, buildJavaPackage}:

buildJavaPackage rec {
  pname = "commons-net";
  version = "3.10.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-net";
    rev = "rel/${pname}-${version}";
    hash = "sha256-4kSxWuq5mDC4Iy1RTyGlxmf/Fg+u8e77/eiFJTKsQ2U=";
  };
  deps = [
  ];
}
