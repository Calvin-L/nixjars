{lib, fetchFromGitHub, buildJavaPackage}:

buildJavaPackage rec {
  pname = "commons-csv";
  version = "1.10.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = pname;
    rev = "rel/${pname}-${version}";
    hash = "sha256-JCo+riCpSuSRdHMTstouFMScP4OejRLbEN3r7haM8P0=";
  };
}
