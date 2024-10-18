{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "classgraph";
  version = "4.8.177";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-x8x3Ledq2u5EdGJRFZ0DHoOGu93MOaI5hlhhkv21XUI=";
  };
  checkForClassDups = false; # this is a dependency of the dedup infrastructure
}
