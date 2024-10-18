{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "jakarta-activation";
  version = "2.1.3";
  license = lib.licenses.bsd3;
  src = fetchFromGitHub {
    owner = "jakartaee";
    repo = "jaf-api";
    rev = "${version}";
    hash = "sha256-zRh4ie9F1qwXUKeCfM90xmsMU+gE1mgeOHeyIuy8/Y4=";
  };
  sourceRoot = "${src.name}/api";
}
