{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "servlet-api";
  version = "4.0.3";
  license = lib.licenses.epl20;
  src = fetchFromGitHub {
    owner = "eclipse-ee4j";
    repo = "servlet-api";
    rev = "${version}-RELEASE";
    sha256 = "1vlv0zmifi5xklkp01cm3a0b37ih8z8xhgps4bl4ml118nm9l384";
  };
  srcDir = "api/src/main/java";
}
