{lib, buildJavaPackage, fetchFromGitHub,
 guava, threetenbp,
 testWithJUnit5, assertj-core}:

buildJavaPackage rec {
  pname = "joda-convert";
  version = "3.0.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "JodaOrg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BEeHe1guJMvD4JsxwWvC3VvCTDyk2pOcHfOYtIuzcGg=";
  };
  deps = [
    guava
    threetenbp
  ];
  checkPhase = testWithJUnit5 {
    testDeps = [assertj-core];
  };
}
