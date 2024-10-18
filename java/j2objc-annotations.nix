{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "j2objc";
  version = "2.8";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "${version}";
    sparseCheckout = ["annotations"];
    hash = "sha256-dQbXYcmqpa7/ztZuR2R3fAisNJ9zrqEQTpByYwRzasw=";
  };
  sourceRoot = "${src.name}/annotations";
}
