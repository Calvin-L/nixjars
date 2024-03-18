{lib, buildJavaPackage, fetchFromGitHub}:

let
  icu4j-version = "74.1";
  icu4j-license = lib.licenses.mit; # https://github.com/unicode-org/icu/blob/main/LICENSE
  icu4j-src = fetchFromGitHub {
    owner = "unicode-org";
    repo = "icu";
    rev = "release-74-1";
    sparseCheckout = ["icu4j"];
    hash = "sha256-xtsHiRt4WczDG/PIx6XO+NjMgI0etPk8lsjkBKYeYRk=";
  };
in buildJavaPackage {
  pname = "icu4j-core";
  version = icu4j-version;
  license = icu4j-license;
  src = icu4j-src;
  sourceRoot = "${icu4j-src.name}/icu4j/main/core";
}
