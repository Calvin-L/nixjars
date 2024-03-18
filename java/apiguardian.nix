{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "apiguardian";
  version = "1.1.2";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apiguardian-team";
    repo = "apiguardian";
    rev = "r${version}";
    hash = "sha256-3KOLE2XcbSpGr3iXFY6vVt4PFbkCpLT1SK0oPrbjfWU=";
  };
}
