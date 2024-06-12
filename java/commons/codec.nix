{lib, fetchFromGitHub, buildJavaPackage,
 testWithJUnit5, junit, opentest4j,
 commons-lang, commons-io}:

buildJavaPackage rec {
  pname = "commons-codec";
  version = "1.17.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = pname;
    rev = "rel/${pname}-${version}";
    hash = "sha256-5vXTP4+5rN12kingqjIhpMChDuxsEJtQULafaaiHgg8=";
  };
  checkPhase = testWithJUnit5 {
    testDeps = [
      commons-io
      commons-lang
      junit.jupiter-params
      opentest4j
    ];
  };
}
