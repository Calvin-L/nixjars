{lib, buildJavaPackage, fetchFromGitHub, osgi}:

buildJavaPackage rec {
  pname = "snappy";
  version = "1.1.10.7";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "xerial";
    repo = "snappy-java";
    rev = "v${version}";
    hash = "sha256-5o1wAWNQyregGxtLQIAU1werudYciTWzhF9eeWIIiC8=";
  };
  compileOnlyDeps = [
    osgi.core
  ];
}
