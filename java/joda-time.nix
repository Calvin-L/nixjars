{lib, buildJavaPackage, fetchFromGitHub, joda-convert}:

buildJavaPackage rec {
  pname = "joda-time";
  version = "2.12.7";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "JodaOrg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-o7UdqI6h6fBYyTpy2a5PPUGEDu1zWye3cv26EBirBCA=";
  };
  deps = [
    joda-convert
  ];
}
