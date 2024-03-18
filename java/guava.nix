{lib, buildJavaPackage, fetchFromGitHub,
 jsr305, checker-qual, error-prone-annotations, j2objc-annotations,
 failureaccess,
 testWithJUnit4}:

let

  guava-version = "33.0.0";
  guava-license = lib.licenses.asl20;
  guava-src = fetchFromGitHub {
    owner = "google";
    repo = "guava";
    rev = "v${guava-version}";
    hash = "sha256-IfvLvIysr+5KLxJ79RaFvFUev4vKRz74gACsy9P8q0Y=";
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
    failureaccess
  ];
  # checkPhase = testWithJUnit4 {
  #   testSrcDir = "guava-tests/test";
  # };
}
