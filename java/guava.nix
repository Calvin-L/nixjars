{lib, buildJavaPackage, fetchFromGitHub,
 jsr305, checker-qual, error-prone-annotations, j2objc-annotations,
 failureaccess,
 testWithJUnit4}:

let

  guava-version = "33.4.0";
  guava-license = lib.licenses.asl20;
  guava-src = fetchFromGitHub {
    owner = "google";
    repo = "guava";
    rev = "v${guava-version}";
    hash = "sha256-eIvZpBlKgJhO3QdcpsU4sJWXh5EwT12XXC6xc/y8r3I=";
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
  manifestProperties = {
    "Automatic-Module-Name" = "com.google.common";
  };
  # checkPhase = testWithJUnit4 {
  #   testSrcDirs = ["guava-tests/test"];
  # };
}
