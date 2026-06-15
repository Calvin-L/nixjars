{buildJavaPackage, guava}:

buildJavaPackage {
  pname = "failureaccess";
  version = "1.0.3";
  license = guava.meta.license;
  src = guava.src;
  srcDir = "futures/failureaccess/src";
}
