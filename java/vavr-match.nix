{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "vavr-match";
  version = "0.10.4";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "vavr-io";
    repo = pname;
    rev = "5954318042da69898d42853a7cb98860ac090164";
    hash = "sha256-TTuAoV6UGYYYse8bRLJdlQ9gszvEmIqkt7Uld44Fg28=";
  };
}
