{lib, buildJavaPackage, fetchFromGitHub, osgi}:

buildJavaPackage rec {
  pname = "snappy";
  version = "1.1.10.5";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "xerial";
    repo = "snappy-java";
    rev = "v${version}";
    hash = "sha256-B0TjlXxOS5V76kNm/SwDxaq3tgFbec7UwpodhfvmOsU=";
  };
  compileOnlyDeps = [
    osgi.core
  ];
}
