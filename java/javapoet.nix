{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "javapoet";
  version = "1.13.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "square";
    repo = pname;
    rev = "javapoet-${version}";
    hash = "sha256-Pj28ZTJFi9WB5Qnl8XIrSkRkzdA4De0o4vL9Ww9XjuA=";
  };
}
