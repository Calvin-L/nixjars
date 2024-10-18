{lib, fetchFromGitHub, buildJavaPackage,
 testWithJUnit5, junit, opentest4j,
 commons-lang, commons-io}:

buildJavaPackage rec {
  pname = "commons-codec";
  version = "1.17.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = pname;
    rev = "rel/${pname}-${version}";
    hash = "sha256-7SjCRdpcA35GhzkkaB3hTMgzYQGkIDu110J0qvuNTXc=";
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
