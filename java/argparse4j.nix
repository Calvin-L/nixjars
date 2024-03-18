{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "argparse4j";
  version = "0.9.0";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "argparse4j";
    repo = "argparse4j";
    rev = "${pname}-${version}";
    hash = "sha256-yxETVeCIgetFEUb7D7lmFYli9sIbJIUesIhYGvQfEsQ=";
  };
  sourceRoot = "${src.name}/main";
}
