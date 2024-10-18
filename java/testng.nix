{lib, buildJavaPackage, fetchFromGitHub,
 testng, guice, slf4j, jsr305, junit4, snakeyaml, jcommander}:

let

version = "7.10.2";
license = lib.licenses.asl20;
src = fetchFromGitHub {
  owner = "testng-team";
  repo = "testng";
  rev = version;
  hash = "sha256-BchoeVdC101hizKLuJaMCqiC313ejw0FrrprYhT+KI8=";
};

in {

  collections = buildJavaPackage {
    pname = "testng-collections";
    inherit version license src;
    sourceRoot = "${src.name}/testng-collections";
  };

  reflection-utils = buildJavaPackage {
    pname = "testng-reflection-utils";
    inherit version license src;
    sourceRoot = "${src.name}/testng-reflection-utils";
    deps = [
      testng.collections
    ];
  };

  core-api = buildJavaPackage {
    pname = "testng-core-api";
    inherit version license src;
    sourceRoot = "${src.name}/testng-core-api";
    deps = [
      guice
      jsr305
      slf4j.api
      testng.collections
      testng.reflection-utils
    ];
  };

  runner-api = buildJavaPackage {
    pname = "testng-runner-api";
    inherit version license src;
    sourceRoot = "${src.name}/testng-runner-api";
    deps = [
      jsr305
      testng.collections
      testng.core-api
    ];
  };

  core = buildJavaPackage {
    pname = "testng-core";
    inherit version license src;
    sourceRoot = "${src.name}/testng-core";
    deps = [
      guice
      jcommander
      jsr305
      junit4
      snakeyaml
      testng.collections
      testng.core-api
      testng.reflection-utils
      testng.runner-api
    ];
  };

}
