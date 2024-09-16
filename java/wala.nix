{lib, buildJavaPackage, fetchFromGitHub,
 jspecify, gson, guava, commons-io, osgi, dexlib2, slf4j,
 eclipse-platform, eclipse-equinox, eclipse-jdt,
 testWithJUnit5, hamcrest, assertj-core}:

let

version = "1.6.6";
license = lib.licenses.bsd3;
src = fetchFromGitHub {
  owner = "wala";
  repo = "WALA";
  rev = "v${version}";
  hash = "sha256-ZVa4agAh1coNB7XMk3jW2CKsfPlHM63w51Sh9Z2IrsU=";
};

in rec {

  core = buildJavaPackage {
    pname = "wala-core";
    inherit version license src;
    sourceRoot = "${src.name}/core";
    deps = [
      util
      shrike
      gson
    ];

    # excessively complex test fixture nonsense
    # checkPhase = testWithJUnit5 {
    #   testDeps = [hamcrest assertj-core];
    # };
  };

  cast = buildJavaPackage {
    pname = "wala-cast";
    inherit version license src;
    sourceRoot = "${src.name}/cast";
    deps = [
      core
      util
      shrike

      commons-io
    ];
    patchPhase = ''
      rm -v src/test/java/com/ibm/wala/cast/test/TestNativeTranslator.java
    '';
    checkPhase = testWithJUnit5 {};
  };

  cast-java = buildJavaPackage {
    pname = "wala-cast-java";
    inherit version license src;
    sourceRoot = "${src.name}/cast/java";
    deps = [
      cast
      util
      core
      shrike
    ];
  };

  cast-java-ecj = buildJavaPackage {
    pname = "wala-cast-java-ecj";
    inherit version license src;
    sourceRoot = "${src.name}/cast/java/ecj";
    deps = [
      cast
      cast-java
      core
      shrike
      util

      eclipse-equinox.common
      eclipse-jdt.core
      eclipse-jdt.core-compiler-batch
      eclipse-platform.core-runtime
      osgi.framework
    ];
    # checkPhase = testWithJUnit5 { # This should work but it can't find the resources :(
    #   testSrcDirs = ["src/test/java" "../src/testFixtures/java"];
    #   testResourceDirs = ["../test/data"];
    # };
  };

  util = buildJavaPackage {
    pname = "wala-util";
    inherit version license src;
    sourceRoot = "${src.name}/util";
    deps = [
      jspecify
    ];
    checkPhase = testWithJUnit5 {
      testDeps = [hamcrest];
    };
  };

  shrike = buildJavaPackage {
    pname = "wala-shrike";
    inherit version license src;
    sourceRoot = "${src.name}/shrike";
    deps = [
      util
    ];
  };

  dalvik = buildJavaPackage {
    pname = "wala-dalvik";
    inherit version license src;
    sourceRoot = "${src.name}/dalvik";
    deps = [
      core
      util
      shrike

      dexlib2
      guava
      slf4j.api
    ];
  };

}
