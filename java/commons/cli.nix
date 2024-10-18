{lib, fetchFromGitHub, buildJavaPackage,
 testWithJUnit5, junit, mockito, commons-io}:

buildJavaPackage rec {
  pname = "apache-commons-cli";
  version = "1.9.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-cli";
    rev = "rel/commons-cli-${version}";
    hash = "sha256-gTsRSxQEIGNZ5HNPC8ckK1hL6u2TDdznbKVfU3zre9Y=";
  };
  checkPhase = testWithJUnit5 {
    testDeps = [
      junit.jupiter-params
      mockito
      commons-io
    ];
  };
}
