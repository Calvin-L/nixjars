{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "objenesis";
  version = "3.3";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "easymock";
    repo = pname;
    rev = version;
    hash = "sha256-C2yWoXfY7Og2Va271Fqzmhg+u+d1V5W4aDfRRLmZONo=";
  };
  sourceRoot = "${src.name}/main";
}
