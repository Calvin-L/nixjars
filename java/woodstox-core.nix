{lib, buildJavaPackage, fetchFromGitHub,
 stax2-api, msv, relaxng-datatype, osgi, bnd-annotation}:

buildJavaPackage rec {
  pname = "woodstox-core";
  version = "6.5.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "FasterXML";
    repo = "woodstox";
    rev = "${pname}-${version}";
    hash = "sha256-8QRF1LgmiITfCG+9WNK+g+lU6rgJcBuFAPWcg0ngZUs=";
  };
  deps = [
    stax2-api
  ];
  compileOnlyDeps = [
    msv.xsdlib
    msv.core
    relaxng-datatype
    osgi.core
    bnd-annotation
  ];
}
