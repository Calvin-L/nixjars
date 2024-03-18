{lib, buildJavaPackage, fetchFromBitbucket}:

buildJavaPackage rec {
  pname = "snakeyaml";
  version = "2.2";
  license = lib.licenses.asl20;
  src = fetchFromBitbucket {
    owner = "snakeyaml";
    repo = "snakeyaml";
    rev = "${pname}-${version}";
    hash = "sha256-RRxJSNYP6QpJANA3QQDHkYL4mxv2Ylo0gPqDDJeZCpw=";
  };
}
