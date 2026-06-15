{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "j2objc";
  version = "3.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "${version}";
    sparseCheckout = ["annotations"];
    hash = "sha256-TMknuS8DoPkCTJ4QHTQj+1Y+GI6wSm3M+3Kg1DypWgs=";
  };
  sourceRoot = "${src.name}/annotations";
}
