{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "relaxng-datatype";
  version = "2011.1";
  license = lib.licenses.bsd3; # https://github.com/java-schema-utilities/relaxng-datatype-java/issues/1
  src = fetchFromGitHub {
    owner = "java-schema-utilities";
    repo = "relaxng-datatype-java";
    rev = "relaxngDatatype-${version}";
    hash = "sha256-XK5UILKaYQYIbnXzEFPs2UIDCrHNxmFkiJ5yake9dx4=";
  };
}
