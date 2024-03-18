{lib, fetchFromGitHub, buildJavaPackage, testWithJUnit4}:

buildJavaPackage rec {
  pname = "apache-commons-cli";
  version = "1.4";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-cli";
    rev = "cli-${version}";
    hash = "sha256-gaEwoqin9nzYYM6yglR++jwowGZBBbaxKs1q6yfp+7U=";
  };
  checkPhase = testWithJUnit4 {};
}
