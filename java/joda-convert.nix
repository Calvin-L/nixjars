{lib, buildJavaPackage, fetchFromGitHub, guava, testWithJUnit4}:

buildJavaPackage rec {
  pname = "joda-convert";
  version = "2.2.3";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "JodaOrg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-luyhKUrn4L1wiYXbGZ6DZTGQ2f0obzbJLCBb9OCS3xs=";
  };
  deps = [
    guava
  ];
  checkPhase = testWithJUnit4 {};
}
