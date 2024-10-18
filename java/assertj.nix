{lib, buildJavaPackage, fetchFromGitHub,
 opentest4j, byte-buddy, hamcrest,
 junit4, junit}:

buildJavaPackage rec {
  pname = "assertj-core";
  version = "3.26.3";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "assertj";
    repo = "assertj";
    rev = "assertj-build-${version}";
    hash = "sha256-3YqP6/Gx2pD/Dhxi2ezRQlpY406jBLo8LprW1/3CSgQ=";
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
