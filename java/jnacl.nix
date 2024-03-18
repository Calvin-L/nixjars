{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "jnacl";
  version = "1.0";
  license = lib.licenses.bsd2;
  src = fetchFromGitHub {
    owner = "neilalexander";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Kjt7MFK11Dha3sps5y0KdqCk+5or8qCLQb+TKdX9Rak=";
  };
}
