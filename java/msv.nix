{lib, buildJavaPackage, fetchFromGitHub,
 msv,
 relaxng-datatype, isorelax, xml-resolver}:

let

  version = "2022.7";
  license = lib.licenses.bsd3; # per https://xmlark.github.io/msv/
  src = fetchFromGitHub {
    owner = "xmlark";
    repo = "msv";
    rev = "msv-${version}";
    hash = "sha256-jsS5ASWwisjpt2gL3ywY0mi5uP3v0upZoo2NwEnvO/M=";
  };

in {

  xsdlib = buildJavaPackage {
    pname = "xsdlib";
    inherit version license src;
    srcDir = "xsdlib/src/main/java";
    deps = [
      relaxng-datatype
    ];
  };

  core = buildJavaPackage {
    pname = "msv-core";
    inherit version license src;
    srcDir = "msv/src/main/java";
    deps = [
      msv.xsdlib
      relaxng-datatype
      isorelax
    ];
    compileOnlyDeps = [
      xml-resolver
    ];
  };

}
