{lib, buildJavaPackage, fetchFromGitHub, jsr305}:

buildJavaPackage rec {
  pname = "spotbugs-annotations";
  version = "4.8.6";
  license = lib.licenses.lgpl21;
  src = fetchFromGitHub {
    owner = "spotbugs";
    repo = "spotbugs";
    rev = version;
    hash = "sha256-1i2FhedUvPRIVrJf4sF/TPaRFliOKaVCT83d8GQFEFA=";
  };
  sourceRoot = "${src.name}/${pname}";
  deps = [
    jsr305
  ];
}
