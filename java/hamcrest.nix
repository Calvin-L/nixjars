{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "hamcrest";
  version = "2.2";
  license = lib.licenses.bsd3;
  src = fetchFromGitHub {
    owner = "hamcrest";
    repo = "JavaHamcrest";
    rev = "v${version}";
    hash = "sha256-tiTIC1ArY23q0czpSEH5tm+QHQXkDvtHKZ+MjtmxsHk=";
  };
  srcDir = "hamcrest/src/main/java";
  patches = [./hamcrest-generics.patch]; # fix compilation on newer JDKs
  checkPhase = null; # TODO: stage 2 to test junit with itself
}
