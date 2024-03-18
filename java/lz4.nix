{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "lz4";
  version = "1.8.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "lz4";
    repo = "lz4-java";
    rev = version;
    hash = "sha256-nMtCczppYMUE58+b6hrz6GO7Ld98q/LQQNi+JasiEQI=";
  };
  srcDir = "src/java";
  resourceDir = "src/resources";
}
