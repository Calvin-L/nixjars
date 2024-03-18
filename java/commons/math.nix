{lib, fetchurl, buildJavaPackage}:

buildJavaPackage rec {
  pname = "commons-math";
  version = "3.6.1";
  license = lib.licenses.asl20;
  src = fetchurl {
    url = "https://downloads.apache.org/commons/math/source/commons-math3-${version}-src.tar.gz";
    sha256 = "46171449bcfb7d76912275ed1af9ef7de03f7eb1cb9a801e3faf304cc8f586a6";
  };
}
