{lib, fetchFromGitHub, buildJavaPackage,
 guava, guice,
 ant,
 classgraph,
 antlr3, antlr3-runtime,
 osgi,
 eclipse-platform, eclipse-equinox, eclipse-mwe,
 eclipse-jdt, eclipse-emf,
 jakarta-inject-api,
 log4j-1_2-api, log4j-core,
 ow2-asm}:

let

xtext-version = "2.32.0";
xtext-license = lib.licenses.epl20;
xtext-src = fetchFromGitHub {
  owner = "eclipse";
  repo = "xtext";
  rev = "v${xtext-version}";
  hash = "sha256-heqRbbv3XuGXtxoQx1EpyrWHABXTSRDeCvQI3zhGmwU=";
};

in

rec {

  xbase-lib = buildJavaPackage {
    pname = "xtext-xbase-lib";
    version = xtext-version;
    license = xtext-license;
    src = xtext-src;
    srcDir = "org.eclipse.xtext.xbase.lib";
    sourceEncoding = "iso-8859-1";
    deps = [
      guava
    ];
  };

  util = buildJavaPackage {
    pname = "xtext-util";
    version = xtext-version;
    license = xtext-license;
    src = xtext-src;
    srcDir = "org.eclipse.xtext.util/src";
    sourceEncoding = "iso-8859-1";
    deps = [
      eclipse-emf.common
      eclipse-emf.ecore
      guava
      guice
      log4j-1_2-api
      xtend-lib-macro
      xbase-lib
      jakarta-inject-api
    ];
  };

  xtext = buildJavaPackage {
    pname = "xtext";
    version = xtext-version;
    license = xtext-license;
    src = xtext-src;
    srcDir = "org.eclipse.xtext";
    # srcDir = "org.eclipse.xtext/src";
    sourceEncoding = "iso-8859-1";
    nativeBuildInputs = [
      antlr3.bin
    ];
    deps = [
      eclipse-emf.common
      eclipse-emf.ecore
      eclipse-emf.ecore-xmi
      guava
      guice
      log4j-1_2-api
      util
      xbase-lib
      xtend-lib-macro
      xtend-lib
      antlr3-runtime
      eclipse-platform.core-runtime
      eclipse-equinox.common
      eclipse-equinox.registry
      osgi.framework
      eclipse-mwe.core
      ow2-asm
      jakarta-inject-api
      eclipse-mwe.runtime
    ];
    patches = [
      ./remove-xpand-based-Xtext2Ecore-Postprocessor.patch
      ./xtext-upgrade-antlr.patch
    ];
    configurePhase = ''
      antlr org.eclipse.xtext/src-gen/org/eclipse/xtext/parser/antlr/internal/InternalXtext.g
    '';
  };

  common-types = buildJavaPackage {
    pname = "xtext-common-types";
    version = xtext-version;
    license = xtext-license;
    src = xtext-src;
    srcDir = "org.eclipse.xtext.common.types";
    sourceEncoding = "iso-8859-1";
    deps = [
      eclipse-emf.ecore
      eclipse-emf.common
      log4j-1_2-api
      guava
      # guice
      ow2-asm
      xtext
      jakarta-inject-api
      guice
      # xtext-common-types-emf-gen
      util
      xbase-lib
      eclipse-mwe.utils
      eclipse-mwe.lib
      eclipse-mwe.core
      eclipse-mwe.runtime
      classgraph
    ];
  };

  generator = buildJavaPackage {
    pname = "xtext-generator";
    version = xtext-version;
    license = xtext-license;
    src = xtext-src;
    srcDir = "org.eclipse.xtext.xtext.generator";
    sourceEncoding = "iso-8859-1";
    deps = [
      antlr3-runtime
      eclipse-jdt.core
      eclipse-mwe.core
      eclipse-mwe.lib
      eclipse-mwe.runtime
      eclipse-mwe.utils
      eclipse-emf.codegen
      eclipse-emf.codegen-ecore
      eclipse-emf.common
      eclipse-emf.ecore
      eclipse-emf.ecore-xmi
      guava
      guice
      jakarta-inject-api
      log4j-1_2-api
      xtend-lib
      xtext
      util
      xbase-lib
    ];
  };

  xbase = buildJavaPackage {
    pname = "xtext-xbase";
    version = xtext-version;
    license = xtext-license;
    src = xtext-src;
    srcDir = "org.eclipse.xtext.xbase";
    sourceEncoding = "iso-8859-1";
    deps = [
      antlr3-runtime
      eclipse-mwe.core
      eclipse-mwe.lib
      eclipse-mwe.runtime
      eclipse-mwe.utils
      eclipse-emf.common
      eclipse-emf.ecore
      eclipse-emf.ecore-xmi
      guava
      guice
      jakarta-inject-api
      log4j-1_2-api
      xtend-lib
      xtext
      common-types
      generator
      util
      xbase-lib
    ];
  };

  # xtext-testing = buildJavaPackage {
  #   name = "xtext-xbase-testing";
  #   version = xtext-version;
  #   license = xtext-license;
  #   src = xtext-src;
  #   srcDir = "org.eclipse.xtext.testing";
  #   sourceEncoding = "iso-8859-1";
  #   deps = [
  #     guava
  #     junit4
  #     eclipse-emf.ecore
  #     eclipse-emf.ecore-xmi
  #     xtext-xbase-lib
  #   ];
  # };

  # xtext-xbase-testing = buildJavaPackage {
  #   name = "xtext-xbase-testing";
  #   version = xtext-version;
  #   license = xtext-license;
  #   src = xtext-src;
  #   srcDir = "org.eclipse.xtext.xbase.testing";
  #   sourceEncoding = "iso-8859-1";
  #   deps = [
  #     eclipse-equinox.common
  #     eclipse-jdt.core
  #     eclipse-jdt.core-compiler-batch
  #     eclipse-platform.core-runtime
  #     eclipse-emf.common
  #     eclipse-emf.ecore
  #     guava
  #     guice
  #     jakarta-inject-api
  #     junit4
  #     log4j-1_2-api
  #     xtext
  #     xtext-common-types
  #     xtext-generator
  #     xtext-testing
  #     xtext-util
  #     xtext-xbase
  #     xtext-xbase-lib
  #   ];
  # };

  xtend-lib = buildJavaPackage {
    pname = "xtend-lib";
    version = xtext-version;
    license = xtext-license;
    src = xtext-src;
    srcDir = "org.eclipse.xtend.lib";
    sourceEncoding = "iso-8859-1";
    deps = [
      xtend-lib-macro
      guava
      xbase-lib
    ];
  };

  xtend-lib-macro = buildJavaPackage {
    pname = "xtend-lib-macro";
    version = xtext-version;
    license = xtext-license;
    src = xtext-src;
    srcDir = "org.eclipse.xtend.lib.macro/src";
    sourceEncoding = "iso-8859-1";
    deps = [
      guava
      xbase-lib
    ];
  };

  xtend-core = buildJavaPackage {
    pname = "xtend-core";
    version = xtext-version;
    license = xtext-license;
    src = xtext-src;
    srcDir = "org.eclipse.xtend.core";
    resourceDir = "org.eclipse.xtend.core/src-gen";
    sourceEncoding = "iso-8859-1";
    compileOnlyDeps = [
      # xtext-xbase-testing
      ant
    ];
    deps = [
      antlr3-runtime
      eclipse-equinox.common
      eclipse-jdt.core
      eclipse-jdt.core-compiler-batch
      eclipse-mwe.runtime
      eclipse-platform.core-runtime
      eclipse-emf.common
      eclipse-emf.ecore
      eclipse-emf.ecore-xmi
      guava
      guice
      jakarta-inject-api
      log4j-1_2-api
      xtend-lib
      xtend-lib-macro
      xtext
      common-types
      generator
      util
      xbase
      xbase-lib
    ];
    runtimeOnlyDeps = [
      log4j-core
    ];
    configurePhase = ''
      rm org.eclipse.xtend.core/src/org/eclipse/xtend/core/compiler/batch/XtendCompilerTester.java
      substituteInPlace org.eclipse.xtend.core/src/org/eclipse/xtend/core/parser/antlr/internal/FlexTokenSource.java \
        --replace 'return Token.EOF_TOKEN;' 'return new CommonToken(Token.EOF);'
    '';
    exes = [
      # https://stackoverflow.com/questions/14092217/command-line-compiler-for-xtend
      { name = "xtendc"; class = "org.eclipse.xtend.core.compiler.batch.Main"; }
    ];
  };

}
