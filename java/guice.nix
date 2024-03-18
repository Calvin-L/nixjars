{lib, buildJavaPackage, fetchFromGitHub,
 error-prone-annotations, jsr305, guava, ow2-asm, jakarta-inject-api, aopalliance}:

buildJavaPackage rec {
  pname = "guice";
  version = "7.0.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "google";
    repo = "guice";
    rev = version;
    hash = "sha256-RKoXCU1aTBsmnAVxWL+7m6KJU3ujVqWbRPg8OqH2XZ4=";
  };
  srcDir = "core/src";
  compileOnlyDeps = [
    error-prone-annotations
    jsr305
  ];
  deps = [
    guava
    ow2-asm
    jakarta-inject-api
    aopalliance
  ];
}
