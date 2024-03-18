{lib, buildJavaPackage, fetchFromBitbucket, slf4j}:

buildJavaPackage rec {
  pname = "jose4j";
  version = "0.9.3";
  license = lib.licenses.asl20;
  src = fetchFromBitbucket {
    owner = "b_c";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-+bwinzw1Zv43QaW27pqG/juOtM09L/YBdO6y9HcyK2M=";
  };
  deps = [
    slf4j.api
  ];
}
