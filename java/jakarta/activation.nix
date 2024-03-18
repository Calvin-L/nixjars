{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "jakarta-activation";
  version = "2.1.2";
  license = lib.licenses.bsd3;
  src = fetchFromGitHub {
    owner = "jakartaee";
    repo = "jaf-api";
    rev = "${version}";
    hash = "sha256-2w7pWg5gxesrC93zVCgoCBsXLfTSjI3fFI1LEYopNM0=";
  };
  srcDir = "api/src/main/java";
}
