{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "j2objc";
  version = "2.5";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    sha256 = "10x566ia9mwczbj5ms69nsaqsy7dbwfpmrgbklfk9yp9sanaryc9";
    rev = "${version}";
  };
  srcDir = "annotations/src/main/java";
}
