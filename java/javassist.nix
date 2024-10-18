{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "javassist";
  version = "3.30.2";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "jboss-javassist";
    repo = "javassist";
    rev = "rel_3_30_2_ga";
    hash = "sha256-Y0tk+IP/zXSOXyfXZtq4xnl2dJq3DEP2RF4yGIvNQ0A=";
  };
  srcDir = "src/main/javassist";
}
