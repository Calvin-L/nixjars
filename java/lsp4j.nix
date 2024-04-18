{lib, buildJavaPackage, fetchFromGitHub,
 runtimeClasspath,
 lsp4j, gson, guava, xtext}:

let
  version = "0.21.1";
  license = lib.licenses.epl20;
  src = fetchFromGitHub {
    owner = "eclipse-lsp4j";
    repo = "lsp4j";
    rev = "v${version}";
    hash = "sha256-Lp+bWi+4su+rBTq+kYVS0htiv4qOThcXMZUEnYhRwHI=";
  };
in {

  jsonrpc = buildJavaPackage {
    pname = "lsp4j-jsonrpc";
    inherit version license src;
    srcDir = "org.eclipse.lsp4j.jsonrpc/src/main/java";
    deps = [
      gson
    ];
  };

  jsonrpc-debug = buildJavaPackage {
    pname = "lsp4j-jsonrpc-debug";
    inherit version license src;
    srcDir = "org.eclipse.lsp4j.jsonrpc.debug/src/main/java";
    deps = [
      gson
      lsp4j.jsonrpc
    ];
  };

  generator = buildJavaPackage rec {
    pname = "lsp4j-generator";
    inherit version license src;
    srcDir = "xtend-generated-java";
    deps = [
      lsp4j.jsonrpc
      lsp4j.jsonrpc-debug
      xtext.xtend-lib
      xtext.xtend-lib-macro
      xtext.xbase-lib
      guava
      gson
    ];
    nativeBuildInputs = [
      xtext.xtend-core.bin
    ];
    configurePhase = ''
      mkdir xtend-generated-java
      xtend_cp='${runtimeClasspath deps}'
      echo "Compiling xtend files with classpath $xtend_cp"
      xtendc -verbose \
        -cp "$xtend_cp" \
        -d xtend-generated-java \
        org.eclipse.lsp4j.generator/src/main/java
    '';
  };

  debug = buildJavaPackage rec {
    pname = "lsp4j-debug";
    inherit version license src;
    srcDir = "xtend-generated-java";
    deps = [
      lsp4j.jsonrpc
      lsp4j.jsonrpc-debug
      gson
    ];
    nativeBuildInputs = [
      xtext.xtend-core.bin
    ];
    compileOnlyDeps = [
      lsp4j.generator
    ];
    configurePhase = ''
      cp -r org.eclipse.lsp4j.debug/src/main/java xtend-generated-java
      xtend_cp='${runtimeClasspath (deps ++ compileOnlyDeps)}'
      echo "Compiling xtend files with classpath $xtend_cp"
      xtendc -verbose \
        -cp "$xtend_cp" \
        -d xtend-generated-java \
        org.eclipse.lsp4j.debug/src/main/java
    '';
  };

}
