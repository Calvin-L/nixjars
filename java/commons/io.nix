{lib, fetchFromGitHub, buildJavaPackage,
  testWithJUnit5, junit, commons-lang, mockito, guava}:

buildJavaPackage rec {
  pname = "commons-io";
  version = "2.15.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-io";
    rev = "rel/commons-io-${version}";
    hash = "sha256-6PiXQowGAK3VGvySWk11Jmskhfn0MSkg/4SklaRyThE=";
  };
  # sourceEncoding = "ISO-8859-1";
  deps = [
    # commons-lang
  ];
  # checkPhase = testWithJUnit5 {
  #   testDeps = [
  #     commons-lang
  #     mockito
  #     guava
  #     junit.jupiter-params
  #   ];
  # };
}
