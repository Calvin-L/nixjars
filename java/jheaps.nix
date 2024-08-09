{lib, buildJavaPackage, fetchFromGitHub,
 testWithJUnit4}:

buildJavaPackage rec {
  pname = "jheaps";
  license = lib.licenses.mit;
  version = "0.14";
  src = fetchFromGitHub {
    owner = "d-michail";
    repo = "jheaps";
    rev = "${pname}-${version}";
    hash = "sha256-vdUBcjCuZSO24fz6dCo8FhlcA/itmMsax6EKt+J1bHQ=";
  };
  manifestProperties = {
    "Automatic-Module-Name" = "org.jheaps";
  };
  checkPhase = testWithJUnit4 {};
}
