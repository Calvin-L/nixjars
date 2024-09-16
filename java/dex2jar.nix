{lib, fetchFromGitHub, buildJavaPackage,
 ow2, commons-compress, antlr3, antlr3-runtime, antlr4, antlr4-runtime,
 testWithJUnit4}:

let

version = "2.4";
src = fetchFromGitHub {
  owner = "pxb1988";
  repo = "dex2jar";
  rev = "v${version}";
  hash = "sha256-rbCR78/POLhLUSDplbz3ZivXmE4OBc5bLX9OcfzEMLE=";
};
license = lib.licenses.asl20;

in

rec {

  ir = buildJavaPackage {
    pname = "dex2jar-ir";
    inherit version src license;
    sourceRoot = "${src.name}/dex-ir";
    deps = [
      reader-api
    ];
    checkPhase = testWithJUnit4 {};
  };

  reader-api = buildJavaPackage {
    pname = "dex2jar-reader-api";
    inherit version src license;
    sourceRoot = "${src.name}/dex-reader-api";
  };

  reader = buildJavaPackage {
    pname = "dex2jar-reader";
    inherit version src license;
    sourceRoot = "${src.name}/dex-reader";
    deps = [
      reader-api

      commons-compress
    ];
    checkPhase = testWithJUnit4 {};
  };

  tools = buildJavaPackage {
    pname = "dex2jar-tools";
    inherit version src license;
    sourceRoot = "${src.name}/dex-tools";
    deps = [
      translator
      smali
      jasmin
      writer
      ir
      reader-api
      reader
      base-cmd

      ow2.asm
      ow2.asm-util
      ow2.asm-tree
      ow2.asm-commons
      ow2.asm-analysis
    ];
    patchPhase = ''
      rm -v src/main/java/com/googlecode/d2j/signapk/SunJarSignImpl.java
      rm -v src/main/java/com/googlecode/dex2jar/tools/ApkSign.java
    '';
    checkPhase = testWithJUnit4 {
      testDeps = [
        antlr3-runtime
      ];
    };
  };

  translator = buildJavaPackage {
    pname = "dex2jar-translator";
    inherit version src license;
    sourceRoot = "${src.name}/dex-translator";
    deps = [
      ir
      reader
      reader-api
      smali
      # jasmin
      base-cmd

      ow2.asm
      ow2.asm-util
      ow2.asm-tree
      ow2.asm-commons
      ow2.asm-analysis
    ];

    # requires a bunch of Android stuff
    # checkPhase = testWithJUnit4 {};
  };

  writer = buildJavaPackage {
    pname = "dex2jar-writer";
    inherit version src license;
    sourceRoot = "${src.name}/dex-writer";
    deps = [
      reader
      reader-api
    ];
    checkPhase = testWithJUnit4 {};
  };

  jasmin = buildJavaPackage {
    pname = "dex2jar-jasmin";
    inherit version src license;
    sourceRoot = "${src.name}/d2j-jasmin";
    nativeBuildInputs = [antlr3.bin];
    configurePhase = ''
      antlr src/main/antlr3/com/googlecode/d2j/jasmin/Jasmin.g
      mkdir -p src/main/java/com/googlecode/d2j/jasmin/
      mv -v src/main/antlr3/com/googlecode/d2j/jasmin/*.java src/main/java/com/googlecode/d2j/jasmin/
    '';
    deps = [
      base-cmd

      antlr3-runtime
      ow2.asm
      ow2.asm-tree
      ow2.asm-util
    ];
    checkPhase = testWithJUnit4 {};
  };

  smali = buildJavaPackage {
    pname = "dex2jar-smali";
    inherit version src license;
    sourceRoot = "${src.name}/d2j-smali";
    nativeBuildInputs = [antlr4.bin];
    configurePhase = ''
      mkdir -p src/main/java/com/googlecode/d2j/smali/antlr4/
      antlr \
        -visitor \
        -o src/main/java/com/googlecode/d2j/smali/antlr4/ \
        -package com.googlecode.d2j.smali.antlr4 \
        src/main/antlr4/com/googlecode/d2j/smali/antlr4/Smali.g4
    '';
    deps = [
      base-cmd
      reader
      reader-api
      writer

      antlr4-runtime
    ];
    # checkPhase = testWithJUnit4 {}; # requires some android nonsense :(
  };

  base-cmd = buildJavaPackage {
    pname = "dex2jar-base-cmd";
    inherit version src license;
    sourceRoot = "${src.name}/d2j-base-cmd";
  };

}
