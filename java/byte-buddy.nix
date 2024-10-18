{lib, buildJavaPackage, fetchFromGitHub,
 ow2, jsr305, findbugs-annotations, jna}:

buildJavaPackage rec {
  pname = "byte-buddy";
  version = "1.15.5";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "raphw";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-wHdznDFto4sd8RGXJjCdef05YsXIXKtBCjZvjq5cFQs=";
  };
  sourceRoot = "${src.name}/byte-buddy-dep";
  deps = [
    findbugs-annotations
    jna
    jsr305
    ow2.asm
    ow2.asm-commons
  ];
}
