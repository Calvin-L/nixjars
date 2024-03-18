{buildJavaPackage,
 guava, junit4, checker-qual, jsr305, j2objc-annotations, error-prone-annotations, failureaccess}:

buildJavaPackage {
  pname = "guava-testlib";
  version = guava.version;
  license = guava.meta.license;
  src = guava.src;
  sourceRoot = "${guava.src.name}/guava-testlib";
  srcDir = "src";
  deps = [
    checker-qual
    error-prone-annotations
    failureaccess
    guava
    j2objc-annotations
    jsr305
    junit4
  ];
}
