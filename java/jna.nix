{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "jna";
  version = "5.14.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "java-native-access";
    repo = pname;
    rev = version;
    hash = "sha256-a5l9khKLWfvTHv53utfbw344/UNQOnIU93+wZNQ0ji4=";
  };
  srcDir = "src";
  # checkPhase = testWithJUnit4 { testSrcDir = "test"; testDeps = [hamcrest]; }; # package org.reflections does not exist
}
