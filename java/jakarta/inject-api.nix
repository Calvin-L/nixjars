{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "jakarta-inject-api";
  version = "2.0.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "jakartaee";
    repo = "inject";
    rev = version;
    hash = "sha256-SsPR8C1olO+p+pjrvxUcDzPY+Pjdu5POJyxhWvoJMR4=";
  };
}
