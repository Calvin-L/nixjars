{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "javassist";
  version = "3.27.0-GA";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "jboss-javassist";
    repo = "javassist";
    rev = "rel_3_27_0_ga";
    sha256 = "1m1vhppn3va9rk66g6lf877mx7k66fvcn4rj64s6py42q0hvnlxy";
  };
  srcDir = "src/main/javassist";
}
