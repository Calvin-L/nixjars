{lib, fetchFromGitHub, buildJavaPackage,
 jsr305, commons-lang, commons-io, guava, slf4j, jgrapht, ow2, dex2jar, wala, heros,
 antlr4, antlr4-runtime,
 testWithJUnit5}:

let

version = "1.3.0";
src = fetchFromGitHub {
  owner = "soot-oss";
  repo = "SootUp";
  rev = "v${version}";
  hash = "sha256-dBDKpZXMJiUWdLBxAWGdaamX+NlYllIvnmp5QolYe2Q=";
};
license = lib.licenses.lgpl21;

in

rec {

  core = buildJavaPackage {
    pname = "sootup-core";
    inherit version src license;
    sourceRoot = "${src.name}/sootup.core";
    compileOnlyDeps = [jsr305];
    deps = [
      commons-lang
      guava
      jgrapht.core
      slf4j.api
    ];
    checkPhase = testWithJUnit5 {};
  };

  java-core = buildJavaPackage {
    pname = "sootup-java-core";
    inherit version src license;
    sourceRoot = "${src.name}/sootup.java.core";
    compileOnlyDeps = [jsr305];
    deps = [
      core

      commons-lang
      guava
      slf4j.api
    ];
    checkPhase = testWithJUnit5 {};
  };

  java-bytecode = buildJavaPackage {
    pname = "sootup-java-bytecode";
    inherit version src license;
    sourceRoot = "${src.name}/sootup.java.bytecode";
    compileOnlyDeps = [jsr305];
    deps = [
      core
      java-core

      guava
      ow2.asm
      ow2.asm-commons
      ow2.asm-tree
      ow2.asm-util
      slf4j.api
      commons-io
      dex2jar.tools
    ];

    # Tests are broken on Java 9+ because they use DefaultRTJarAnalysisInputLocation,
    # which looks for rt.jar, which has been removed.
    # See: https://github.com/soot-oss/SootUp/blob/c32189450088aadaf0a810b9598051f07d50754a/sootup.java.bytecode.frontend/src/main/java/sootup/java/bytecode/frontend/inputlocation/DefaultRTJarAnalysisInputLocation.java#L38
    # checkPhase = testWithJUnit5 {};
  };

  analysis = buildJavaPackage {
    pname = "sootup-analysis";
    inherit version src license;
    sourceRoot = "${src.name}/sootup.analysis";
    compileOnlyDeps = [jsr305];
    deps = [
      core
      callgraph

      commons-lang
      guava
      heros
      slf4j.api
    ];

    # Tests are broken on Java 9+ because they need rt.jar, which has been removed.
    # checkPhase = testWithJUnit5 {
    #   testDeps = [
    #     java-core
    #     java-bytecode
    #     java-sourcecode
    #   ];
    # };
  };

  callgraph = buildJavaPackage {
    pname = "sootup-callgraph";
    inherit version src license;
    sourceRoot = "${src.name}/sootup.callgraph";
    compileOnlyDeps = [jsr305];
    deps = [
      core
      java-core

      guava
      jgrapht.core
      slf4j.api
    ];

    # Tests are broken on Java 9+ because they use DefaultRTJarAnalysisInputLocation,
    # which looks for rt.jar, which has been removed.
    # See: https://github.com/soot-oss/SootUp/blob/c32189450088aadaf0a810b9598051f07d50754a/sootup.java.bytecode.frontend/src/main/java/sootup/java/bytecode/frontend/inputlocation/DefaultRTJarAnalysisInputLocation.java#L38
    # checkPhase = testWithJUnit5 {
    #   testDeps = [java-bytecode java-sourcecode];
    # };
  };

  java-sourcecode = buildJavaPackage {
    pname = "sootup-java-sourcecode";
    inherit version src license;
    sourceRoot = "${src.name}/sootup.java.sourcecode";
    compileOnlyDeps = [jsr305];
    deps = [
      core
      java-core

      guava
      slf4j.api
      wala.cast
      wala.cast-java
      wala.cast-java-ecj
      wala.core
      wala.dalvik
      wala.shrike
      wala.util
    ];
    checkPhase = testWithJUnit5 {};
  };

  jimple-parser = buildJavaPackage {
    pname = "sootup-jimple-parser";
    inherit version src license;
    sourceRoot = "${src.name}/sootup.jimple.parser";
    nativeBuildInputs = [antlr4.bin];
    compileOnlyDeps = [jsr305];
    deps = [
      core
      java-core

      antlr4-runtime
      commons-io
      slf4j.api
    ];
    configurePhase = ''
      antlr \
        -visitor \
        -package sootup.jimple \
        -o src/main/java/sootup/jimple/ \
        src/main/antlr4/sootup/jimple/Jimple.g4
    '';
    checkPhase = testWithJUnit5 {};
  };

}
