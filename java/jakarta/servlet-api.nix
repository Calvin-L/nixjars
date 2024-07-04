{lib, buildJavaPackage, fetchFromGitHub, testWithJUnit5, junit, hamcrest}:

buildJavaPackage rec {
  pname = "jakarta-servlet-api";
  license = lib.licenses.epl20;
  version = "6.1.0";
  src = fetchFromGitHub {
    owner = "jakartaee";
    repo = "servlet";
    rev = "${version}-RELEASE";
    hash = "sha256-641Zny3fCQbuERiewC7luO/LMzXRkN1q5Oml+8wPnAo=";
  };
  sourceRoot = "${src.name}/api";

  # fails with various OSGi-related problems (missing bundles)
  # checkPhase = testWithJUnit5 { testDeps = [junit.jupiter-params hamcrest]; };
}
