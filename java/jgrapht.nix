{lib, buildJavaPackage, fetchFromGitHub, fetchurl,
 jgrapht, jheaps, apfloat,
 testWithJUnit5, junit, hamcrest, jmh-core, commons-math}:

let
  # broken due to https://github.com/jgrapht/jgrapht/issues/1154
  # version = "1.5.2";
  # license = [lib.licenses.epl20 lib.licenses.lgpl21];
  # src = fetchFromGitHub {
  #   owner = "jgrapht";
  #   repo = "jgrapht";
  #   rev = "jgrapht-${version}";
  #   hash = "sha256-VRvM6Na/oeMVZDJP5/ThWA19/gyaWMz4r63/BavCn4A=";
  # };

  version = "1.5.3-alpha";
  license = [lib.licenses.epl20 lib.licenses.lgpl21];
  src = fetchFromGitHub {
    owner = "jgrapht";
    repo = "jgrapht";
    rev = "6324b1354547505d5b62f65a9bf507b54b04e41a";
    hash = "sha256-AF0k8hm07CflCDneW/UybRYWnDeqScavlGsTsXgzxsM=";
  };
in {

  core = buildJavaPackage {
    pname = "jgrapht-core";
    inherit version license src;
    sourceRoot = "${src.name}/jgrapht-core";
    deps = [
      jheaps
      apfloat
    ];

    patchPhase = ''
      find src/test/java -type f -not -iname 'FastTestSuite.java' -print -delete
    '';

    checkPhase = testWithJUnit5 {
      testDeps = [
        junit.platform-suite-api
        junit.jupiter-params
        hamcrest
        jmh-core
        commons-math
      ];
    };
  };

}
