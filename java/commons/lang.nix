{lib, fetchFromGitHub, buildJavaPackage}:

buildJavaPackage rec {
  pname = "commons-lang";
  version = "3.13.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-lang";
    rev = "rel/${pname}-${version}";
    hash = "sha256-YIvtWUF5/m6JktWmiZY71QF3nZnVmD83KZ1uU5BzU5U=";
  };
  srcDir = "src/main";
}
