{lib, buildJavaPackage, fetchurl}:

buildJavaPackage rec {
  pname = "jakarta-regexp";
  license = lib.licenses.asl20;
  version = "1.5";
  src = fetchurl {
    url = "https://archive.apache.org/dist/jakarta/regexp/source/jakarta-regexp-${version}.tar.gz";
    hash = "sha256-eegK+MvraN2tdaGqYkTXrNYhdr/Wm83AZA0RF33N6X0=";
  };
  srcDir = "src/java";
}
