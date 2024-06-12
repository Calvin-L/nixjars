{lib, fetchFromGitHub, buildJavaPackage,
  testWithJUnit5, junit, commons-lang, mockito, guava}:

buildJavaPackage rec {
  pname = "commons-io";
  version = "2.16.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-io";
    rev = "rel/commons-io-${version}";
    hash = "sha256-BSTfju2X8TEIwDeFGrF98CVshZoscZLhv5XjG7YaxEE=";
  };
  # checkPhase = testWithJUnit5 {
  #   testDeps = [
  #     commons-lang
  #     mockito
  #     guava
  #     junit.jupiter-params
  #   ];
  # };
}
