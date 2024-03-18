{lib, fetchFromGitHub, buildJavaPackage, junit4}:

buildJavaPackage rec {
  # https://github.com/takari/takari-cpsuite
  pname = "takari-cpsuite";
  version = "1.2.7";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "takari";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-jrFviOZ7e1775kgtUhohQKtQBANKcr5yVC0CpxI1d2o=";
  };
  deps = [junit4];
}
