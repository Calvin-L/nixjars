{lib, buildJavaPackage, fetchFromGitHub, fetchurl,
 jungrapht, jgrapht, jheaps, slf4j,
 testWithJUnit4}:

let
  version = "1.4";
  license = lib.licenses.bsd3;
  src = fetchFromGitHub {
    owner = "tomnelson";
    repo = "jungrapht-visualization";
    rev = "v${version}";
    hash = "sha256-9sUeZYxCYzlx6hg0Qh5e2wQdnLWNxM3VUj631qponu8=";
  };
in {

  layout = buildJavaPackage {
    pname = "jungrapht-layout";
    inherit version license src;
    sourceRoot = "${src.name}/jungrapht-layout";
    deps = [
      jgrapht.core
      jheaps
      slf4j.api
    ];
    checkPhase = testWithJUnit4 {};
  };

  visualization = buildJavaPackage {
    pname = "jungrapht-visualization";
    inherit version license src;
    sourceRoot = "${src.name}/jungrapht-visualization";
    deps = [
      jgrapht.core
      jungrapht.layout
      slf4j.api
    ];
    checkPhase = testWithJUnit4 {
      testDeps = [
        # TODO: bug in build infrastructure: `jheaps` should be discovered
        #       automatically because it is a transitive run-time dependency
        jheaps
      ];
    };
  };

}
