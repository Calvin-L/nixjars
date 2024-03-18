{lib, buildJavaPackage, fetchFromGitHub, slf4j,
 cal10n-api, javassist}:

let

version = "2.0.12";
license = lib.licenses.mit;
src = fetchFromGitHub {
  owner = "qos-ch";
  repo = "slf4j";
  rev = "v_${version}";
  sha256 = "sha256-nKzRImwc1d8eIEjRD0cxV/pt6kLBvzPgvic5Q82IHuU=";
};

in {

  api = buildJavaPackage rec {
    pname = "slf4j-api";
    inherit version license src;
    srcDir = "slf4j-api/src/main/java";
  };

  ext = buildJavaPackage rec {
    pname = "slf4j-ext";
    inherit version license src;
    srcDir = "slf4j-ext/src/main/java";
    compileOnlyDeps = [
      cal10n-api
      javassist
    ];
    deps = [
      # commons-lang_2 # not listed in pom.xml
      slf4j.api
    ];
  };

}
