{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "tukaani-xz";
  version = "1.9";
  license = lib.licenses.publicDomain; # https://tukaani.org/xz/java.html, 2023/10/1
  src = fetchFromGitHub {
    owner = "tukaani-project";
    repo = "xz-java";
    rev = "v${version}";
    hash = "sha256-W3CtViPiyMbDIAPlu5zbUdvhMkZLVxZzB9niT49jNbE=";
  };
  srcDir = "src";
}
