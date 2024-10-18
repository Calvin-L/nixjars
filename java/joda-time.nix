{lib, buildJavaPackage, fetchFromGitHub, joda-convert}:

buildJavaPackage rec {
  pname = "joda-time";
  version = "2.13.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "JodaOrg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dhT02vwKElZzQODDsdi+YKqmHRLv9/Nq/2fVIjc/Skk=";
  };
  deps = [
    joda-convert
  ];
}
