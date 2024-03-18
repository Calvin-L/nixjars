{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "reactive-streams";
  version = "1.0.4";
  license = lib.licenses.mit0;
  src = fetchFromGitHub {
    owner = "reactive-streams";
    repo = "reactive-streams-jvm";
    rev = "v${version}";
    hash = "sha256-03WPFxkk8SoaP75mpaalIlTemDRTy5n0Pvfe3JLrg2g=";
  };
  srcDir = "api";
}
