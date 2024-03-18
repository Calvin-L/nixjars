{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "conversantmedia-disruptor";
  version = "1.2.21";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "conversant";
    repo = "disruptor";
    rev = version;
    hash = "sha256-ClRG5Fw8p2R/fGo6hTZc/RrWmeHJBWK8m9/itpm67l0=";
  };
}
