{lib, fetchFromGitHub, buildJavaPackage,
 commons-io, commons-codec}:

buildJavaPackage rec {
  pname = "commons-csv";
  version = "1.12.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = pname;
    rev = "rel/${pname}-${version}";
    hash = "sha256-siZAFGSg3kItqKOvdrf/2zbvA12Rml4u++zncFQ9M/Q=";
  };
  deps = [
    commons-io
    commons-codec
  ];
}
