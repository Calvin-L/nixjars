{lib, buildJavaPackage, fetchFromGitHub,
 ant, eclipse-equinox, eclipse-platform, eclipse-platform-ui,
 eclipse-jdt,
 osgi}:

let
  version = "4.31";
  license = lib.licenses.epl20;
  src = fetchFromGitHub {
    owner = "eclipse-jdt";
    repo = "eclipse.jdt.core";
    rev = "R${builtins.replaceStrings ["."] ["_"] version}";
    hash = "sha256-7/yuDSILmHomkCXo3rOMQFdL5nGZc4xufs0ixiOlrLI=";
  };

  debug-src = fetchFromGitHub {
    owner = "eclipse-jdt";
    repo = "eclipse.jdt.debug";
    rev = "R${builtins.replaceStrings ["."] ["_"] version}";
    hash = "sha256-KXTnKuu9PX4lw2zf3Ix18I9Nn96nzAh2p6ganEwmyYo=";
  };
in {
  core-compiler-batch = buildJavaPackage {
    pname = "eclipse-jdt-core-compiler-batch";
    inherit version license src;
    srcDir = "org.eclipse.jdt.core.compiler.batch/src";
    resourceDir = "org.eclipse.jdt.core.compiler.batch/src"; # messy :(
    compileOnlyDeps = [
      ant
    ];

    # incredibly hacky and broken
    configurePhase = ''
      substituteInPlace org.eclipse.jdt.core.compiler.batch/src/org/eclipse/jdt/internal/compiler/apt/model/ElementsImpl9.java \
        --replace-fail '@Override' ""
      substituteInPlace org.eclipse.jdt.core.compiler.batch/src/org/eclipse/jdt/internal/compiler/apt/model/ElementsImpl9.java \
        --replace-fail 'getOutermostTypeElement(element)' 'null'
      substituteInPlace org.eclipse.jdt.core.compiler.batch/src/org/eclipse/jdt/internal/compiler/parser/Parser.java \
        --replace-fail 'import org.eclipse.jdt.internal.compiler.ast.*;' 'import org.eclipse.jdt.internal.compiler.ast.*; import org.eclipse.jdt.internal.compiler.ast.StringTemplate;'
    '';

    exes = [
      { name = "ejc"; class = "org.eclipse.jdt.internal.compiler.batch.Main"; }
    ];
  };

  core = buildJavaPackage {
    pname = "eclipse-jdt-core";
    inherit version license src;
    srcDir = "org.eclipse.jdt.core";
    compileOnlyDeps = [
      ant
    ];
    deps = [
      eclipse-jdt.core-compiler-batch
      eclipse-equinox.app
      eclipse-equinox.common
      eclipse-equinox.osgi-supplement
      eclipse-equinox.preferences
      eclipse-equinox.registry
      eclipse-platform-ui.jface-text
      eclipse-platform.core-contenttype
      eclipse-platform.core-filesystem
      eclipse-platform.core-jobs
      eclipse-platform.core-resources
      eclipse-platform.core-runtime
      osgi.framework
      osgi.service-prefs
    ];
  };

  debug = buildJavaPackage {
    pname = "eclipse-jdt-debug";
    inherit version license;
    src = debug-src;
    srcDir = "org.eclipse.jdt.debug";
    deps = [
      eclipse-equinox.common
      eclipse-equinox.preferences
      eclipse-equinox.registry
      eclipse-jdt.core
      eclipse-jdt.core-compiler-batch
      eclipse-equinox.osgi-supplement
      eclipse-platform.core-expressions
      eclipse-platform.core-jobs
      eclipse-platform.core-resources
      eclipse-platform.core-runtime
      eclipse-platform.debug-core
      osgi.framework
      osgi.service-prefs
    ];
  };

  debug-launching = buildJavaPackage {
    pname = "eclipse-jdt-debug-launching";
    inherit version license;
    src = debug-src;
    srcDir = "org.eclipse.jdt.launching";
    deps = [
      eclipse-equinox.common
      eclipse-equinox.preferences
      eclipse-equinox.registry
      eclipse-jdt.core
      eclipse-jdt.core-compiler-batch
      eclipse-jdt.debug
      eclipse-equinox.osgi-supplement
      eclipse-platform.core-expressions
      eclipse-platform.core-jobs
      eclipse-platform.core-resources
      eclipse-platform.core-runtime
      eclipse-platform.debug-core
      eclipse-platform.debug-variables
      osgi.framework
      osgi.service-prefs
    ];
  };
}
