{lib, buildJavaPackage, fetchFromGitHub,
 opentest4j, byte-buddy, hamcrest,
 junit4, junit}:

buildJavaPackage rec {
  pname = "assertj-core";
  version = "3.25.3";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "assertj";
    repo = "assertj";
    rev = "assertj-build-${version}";
    hash = "sha256-cFTG8DFgwqjPXIReyEKLRbGK2T6m6epoLSYHABy7Ct8=";
  };
  sourceRoot = "${src.name}/${pname}";
  deps = [
    byte-buddy
    hamcrest
  ];
  compileOnlyDeps = [
    opentest4j
    junit4
    junit.jupiter-api
    junit.platform-commons
  ];
}
