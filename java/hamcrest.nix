{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "hamcrest";
  version = "3.0";
  license = lib.licenses.bsd3;
  src = fetchFromGitHub {
    owner = "hamcrest";
    repo = "JavaHamcrest";
    rev = "v${version}";
    hash = "sha256-ntae6XWpD0wEs36YoPsfTl6cSR6ULl6dAJ5oZsV+ih0=";
  };
  srcDir = "hamcrest/src/main/java";
  checkPhase = null; # TODO: stage 2 to test junit with itself
}
