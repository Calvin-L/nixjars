{lib, fetchFromGitHub, buildJavaPackage}:

buildJavaPackage rec {
  pname = "commons-lang";
  version = "3.14.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-lang";
    rev = "rel/${pname}-${version}";
    hash = "sha256-9q8yHmZ5KR5mqyXCCoNxXEmB8oJSq1u1BokbiNWTzis=";
  };
  srcDir = "src/main";
}
