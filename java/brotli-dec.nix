{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "brotli-dec";
  version = "1.1.0";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "google";
    repo = "brotli";
    rev = "v${version}";
    # hash = "sha256-CswS0jCGv8Pbh6BkBAYoeEtU8txdvpJLJFM33XkKw3A="; # broken 2023/10/18?
    # hash = "sha256-5YNQemVQKMn14ra9i6HQcJx7lgS7sd8rlS9JxqEm2aw=";
    # leaveDotGit = true; # get entire tree, not just archive members (which are only C code)

    sparseCheckout = ["java/org/brotli/dec"];
    hash = "sha256-x/B7SalLgqLmy8RfcKcqv/VlIkAWSpRhrT4N+y3lZFQ=";
  };
  srcDir = "java/org/brotli/dec";
  configurePhase = ''
    rm '${srcDir}'/*Test.java
  '';
}
