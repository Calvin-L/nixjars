{lib, buildJavaPackage, fetchFromGitHub, testWithJUnit4}:

buildJavaPackage rec {
  pname = "cmdreader";
  version = "1.5";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "rzwitserloot";
    repo = "com.zwitserloot.cmdreader";
    rev = version;
    hash = "sha256-3YcoezbDoStD1FFRm2oCoTXlxFHrGXPD+KYcEp0rnW8=";
  };
  srcDir = "src";
  checkPhase = testWithJUnit4 { testSrcDir="test"; };
}
