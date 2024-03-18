{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "error-prone-annotations";
  version = "2.23.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "google";
    repo = "error-prone";
    rev = "v${version}";
    hash = "sha256-nCIeGSIEwwHuS2T86Ee+PhfMETU/H016lLYSmGE3fn0=";
  };
  srcDir = "annotations/src/main/java";
}
