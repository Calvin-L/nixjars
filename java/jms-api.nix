{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "jms-api";
  version = "2.0.1";
  license = lib.licenses.cddl;
  src = fetchFromGitHub {
    owner = "javaee";
    repo = "jms-spec";
    rev = "9383d33";
    hash = "sha256-69LQnhJdX/RTwzund3liqTuouKWwJh96M5a6Fa5Z4LU=";
  };
  srcDir = "jms${version}";
}
