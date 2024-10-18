{lib, fetchFromGitHub, buildJavaPackage}:

buildJavaPackage rec {
  pname = "commons-net";
  version = "3.11.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-net";
    rev = "rel/${pname}-${version}";
    hash = "sha256-TzzYKIWDD+rtugpJIf6mmV2Zgm0heBcJgUkdircIeRE=";
  };
}
