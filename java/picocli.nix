{lib, buildJavaPackage, fetchFromGitHub}:

let version = "4.7.6"; in
buildJavaPackage {
  pname = "picocli";
  version = version;
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "remkop";
    repo = "picocli";
    rev = "v${version}";
    hash = "sha256-ljOJmxs5ZGQcx1LpCLryczAQBCy/bsEFbUINM2tQT3c=";
  };
}
