{lib, buildJavaPackage, fetchFromGitHub,
 jsr305, checker-qual, error-prone-annotations, j2objc-annotations,
 failureaccess,
 testWithJUnit4}:

let

  guava-version = "33.2.1";
  guava-license = lib.licenses.asl20;
  guava-src = fetchFromGitHub {
    owner = "google";
    repo = "guava";
    rev = "v${guava-version}";
    hash = "sha256-zHoHRuPj1mFUbBR2P31qI2t17twXLRGnGLniZeD0NsQ=";
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
