{lib, buildJavaPackage, fetchFromGitHub,
 jsr305, checker-qual, error-prone-annotations, j2objc-annotations,
 failureaccess,
 testWithJUnit4}:

let

  guava-version = "33.3.1";
  guava-license = lib.licenses.asl20;
  guava-src = fetchFromGitHub {
    owner = "google";
    repo = "guava";
    rev = "v${guava-version}";
    hash = "sha256-SnZ7+lft8r/VXzaY+jGb4SWhJyeEm4uW+s6V6r8qI6M=";
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
