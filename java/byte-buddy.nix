{lib, buildJavaPackage, fetchFromGitHub,
 ow2, jsr305, findbugs-annotations, jna}:

buildJavaPackage rec {
  pname = "byte-buddy";
  version = "1.14.12";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "raphw";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-SL6tEBgb8nMYd7yUu8Vf5MiTlqjBFmho3/SAuT4qxrw=";
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
