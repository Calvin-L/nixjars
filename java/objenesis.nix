{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "objenesis";
  version = "3.4";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "easymock";
    repo = pname;
    rev = version;
    hash = "sha256-WUcQrh4PiW7M3hhfrm79jqv55NXrJQbzhNQzOjj5lPk=";
  };
  sourceRoot = "${src.name}/main";
}
