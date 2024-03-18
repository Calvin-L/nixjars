{lib, fetchFromGitHub, buildJavaPackage,
  commons-lang,
  testWithJUnit5, junit, assertj-core, mockito, commons-io, commons-rng-client-api, commons-rng-simple, jmh-core}:

buildJavaPackage rec {
  pname = "apache-commons-text";
  version = "1.11.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-text";
    rev = "rel/commons-text-${version}";
    hash = "sha256-rsfNGOSDgKJgqdiYHxn/ZPZhQvoEdc6acDskj+hOmyA=";
  };
  sourceEncoding = "ISO-8859-1";

  # TODO: pull in GraalVM js and js-scriptengine for the tests...
  patchPhase = ''
    rm -v src/test/java/org/apache/commons/text/StringSubstitutorWithInterpolatorStringLookupTest.java
    rm -v src/test/java/org/apache/commons/text/lookup/ScriptStringLookupTest.java
  '';
  deps = [
    commons-lang
  ];
  checkPhase = testWithJUnit5 {
    testDeps = [
      junit.jupiter-params
      assertj-core
      mockito
      commons-io
      commons-rng-client-api
      commons-rng-simple
      jmh-core
    ];
  };
}
