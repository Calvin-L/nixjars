{lib, buildJavaPackage, fetchsvn}:

buildJavaPackage rec {
  pname = "jakarta-oro";
  license = lib.licenses.asl20;
  version = "2.0.8";
  src = fetchsvn {
    url = "https://svn.apache.org/repos/asf/jakarta/oro/tags/oro-${version}/";
    hash = "sha256-Y+GpUojwiSf98L+M2yARxDV2ECZcSUdFwvxxle3DgIw=";
  };
  srcDir = "src/java";
}
