{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "jna";
  version = "5.15.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "java-native-access";
    repo = pname;
    rev = version;
    hash = "sha256-PadOJtoH+guPBQ/j6nIBp7BokNz23OQhaYpcFl/wbpQ=";
  };
  srcDir = "src";
  # checkPhase = testWithJUnit4 { testSrcDirs = ["test"]; testDeps = [hamcrest]; }; # package org.reflections does not exist
}
