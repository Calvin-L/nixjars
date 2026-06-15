{lib, buildJavaPackage, fetchFromGitHub,
 apiguardian}:

buildJavaPackage rec {
  pname = "prettier4j";
  license = lib.licenses.mit;
  version = "0.3.2";
  src = fetchFromGitHub {
    owner = "opencastsoftware";
    repo = "prettier4j";
    rev = "v${version}";
    hash = "sha256-6pGRQ2TErcdaj6B8z+7EDId69NlUixQD8uNEP8nDQ6U=";
  };
  deps = [
    apiguardian
  ];
}
