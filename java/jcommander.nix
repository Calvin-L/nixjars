{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "jcommander";
  version = "1.83";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "cbeust";
    repo = pname;
    rev = version;
    hash = "sha256-dXl0N+/jwNgKALO1/rzslTgtN/s4esU06dFt05DUu5c=";
  };
}
