{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "tukaani-xz";
  version = "1.10";
  license = lib.licenses.publicDomain; # https://tukaani.org/xz/java.html, 2023/10/1
  src = fetchFromGitHub {
    owner = "tukaani-project";
    repo = "xz-java";
    rev = "v${version}";
    hash = "sha256-vW0C4QrRY0VBIpbWKEGVGfgsxg7MyFU++VLnbbKUb+c=";
  };
  srcDir = "src";
}
