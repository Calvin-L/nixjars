{lib, buildJavaPackage, fetchFromGitHub,
 janino,
 ant}:

let
  version = "3.1.6";
  license = lib.licenses.bsd3;
  src = fetchFromGitHub {
    owner = "janino-compiler";
    repo = "janino";
    rev = "v${version}";
    hash = "sha256-afsve6wD6lmxgVcsvv9JcMdkLxNgaKujXFqGjOyoRFc=";
  };
in {

  commons-compiler = buildJavaPackage {
    pname = "janino-commons-compiler";
    inherit version license src;
    sourceRoot = "${src.name}/commons-compiler";
    manifestProperties = {
      "Automatic-Module-Name" = "commons.compiler";
    };
  };

  janino = buildJavaPackage {
    pname = "janino";
    inherit version license src;
    sourceRoot = "${src.name}/janino";
    deps = [
      janino.commons-compiler
    ];
    compileOnlyDeps = [
      ant
    ];
  };

}
