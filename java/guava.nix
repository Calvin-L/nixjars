{lib, buildJavaPackage, fetchFromGitHub,
 jsr305, checker-qual, error-prone-annotations, j2objc-annotations,
 failureaccess, jspecify,
 testWithJUnit4}:

let

  guava-version = "33.6.0";
  guava-license = lib.licenses.asl20;
  guava-src = fetchFromGitHub {
    owner = "google";
    repo = "guava";
    rev = "v${guava-version}";
    hash = "sha256-ESkYseHPJlLA92T8fGXQxJJnIiNvziYdP2vA44y/VGY=";
  };

in

buildJavaPackage {
  pname = "guava";
  version = guava-version;
  license = guava-license;
  src = guava-src;
  srcDir = "guava/src";
  compileOnlyDeps = [
    jsr305
    checker-qual
    error-prone-annotations
    j2objc-annotations
  ];
  deps = [
    jspecify # annotations have runtime retention
  ];
  propagatedBuildInputs = [
    failureaccess
  ];
  # checkPhase = testWithJUnit4 {
  #   testSrcDirs = ["guava-tests/test"];
  # };
}
