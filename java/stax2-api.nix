{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "stax2-api";
  version = "4.2";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "FasterXML";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1mmml24sy09s7czbgs78qdpmch7xbnd363iw4c4gkldf5m88c5j4";
  };
}
