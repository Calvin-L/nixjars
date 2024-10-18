{lib, fetchFromGitHub, buildJavaPackage}:

buildJavaPackage rec {
  pname = "commons-lang";
  version = "3.17.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-lang";
    rev = "rel/${pname}-${version}";
    hash = "sha256-JTtRG3OTjqNA5ULWm4yEe2aHF9CH9TqfFUbYs8kX334=";
  };
  srcDir = "src/main";
}
