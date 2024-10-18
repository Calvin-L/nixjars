{lib, fetchFromGitHub, buildJavaPackage,
  testWithJUnit5, junit, commons-lang, mockito, guava}:

buildJavaPackage rec {
  pname = "commons-io";
  version = "2.17.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-io";
    rev = "rel/commons-io-${version}";
    hash = "sha256-Mnf1fn6LepQq4wffnuz/I30NvdC/+vm+1d4oQTx15XY=";
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
