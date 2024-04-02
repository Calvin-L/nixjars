{ lib, buildJavaPackage,
  fetchurl, fetchFromGitHub,
  antlr3-bootstrap, icu4j-core, treelayout }:

# We have to resolve a frustrating circular dependency:
#
# -> antlr3
#     -> antlr4-stringtemplate
#         -> antlr3                (!)
#
# Fortunately, antlr4-stringtemplate only needs antlr3 at compile-time.  So
# here's what we do:
#
#  1. call in a precompiled binary (antlr3-bootstrap)
#  2. build this stuff once using the precompiled binary
#  3. rebuild everything using the binaries from step 2
#
# Step 3 is not technically necessary, but it does ensure that everything is
# compatible with each other.

rec {
  antlr-license = lib.licenses.bsd3;

  antlr2 = buildJavaPackage rec {
    pname = "antlr";
    license = antlr-license;
    version = "2.7.7";
    src = fetchurl {
      url = "https://www.antlr2.org/download/antlr-${version}.tar.gz";
      hash = "sha256-hTrrAhrvdYa9op50prAwBry1ZadVyGtmAy2Owxtn27k=";
    };
    srcDir = "antlr";
    configurePhase = "true";
    exes = [
      { name = "antlr"; class = "antlr.Tool"; }
    ];
  };

  antlr3-version = "3.5.3";
  antlr3-license = antlr-license;
  antlr3-src = fetchFromGitHub {
    owner = "antlr";
    repo = "antlr3";
    rev = antlr3-version;
    hash = "sha256-cWcaUzFhjU76IFetT2PFPYeiVFYN19uk8O7KN8foyz0=";
  };

  antlr3-stringtemplate = buildJavaPackage {
    pname = "antlr-stringtemplate";
    version = "3.2.1";
    license = antlr3-license;
    src = fetchFromGitHub {
      owner = "antlr";
      repo = "stringtemplate3";
      rev = "68f2a42e8038f8e716e9666909ea485ee8aff45a";
      hash = "sha256-qKciZYyzjYTqnB6qWrYnfGnf/kAnCnELC0xcOJPdbrs=";
    };
    srcDir = "src";
    deps = [
      antlr2
    ];
    patchPhase = ''
      substituteInPlace \
        src/org/antlr/stringtemplate/language/*.g \
        src/org/antlr/stringtemplate/misc/StringTemplateTreeView.java \
        --replace-fail 'import org.antlr.stringtemplate.*;' 'import org.antlr.stringtemplate.*; import org.antlr.stringtemplate.StringTemplate;'
    '';
    configurePhase = ''
      pushd src/org/antlr/stringtemplate/language
      antlr template.g
      antlr angle.bracket.template.g
      antlr action.g
      antlr eval.g
      antlr group.g
      antlr interface.g
      popd
    '';
  };

  antlr3-runtime = buildJavaPackage {
    pname = "antlr-runtime";
    version = antlr3-version;
    license = antlr3-license;
    src = antlr3-src;
    srcDir = "runtime/Java/src/main";
    deps = [
      antlr3-stringtemplate
    ];
  };

  antlr3 = buildJavaPackage {
    pname = "antlr";
    version = antlr3-version;
    license = antlr3-license;
    src = antlr3-src;
    sourceRoot = "${antlr3-src.name}/tool";
    srcDir = "src/main";
    resourceDir = "src/main/resources";
    compileOnlyDeps = [
      antlr3-bootstrap
    ];
    deps = [
      antlr3-runtime
      antlr3-stringtemplate
      antlr4-stringtemplate # :facepalm:
    ];
    configurePhase = ''
      pushd src/main/antlr3/org/antlr/grammar/v3
      antlr ANTLR.g
      antlr ActionAnalysis.g
      antlr DefineGrammarItemsWalker.g
      antlr ANTLRTreePrinter.g
      antlr ActionTranslator.g
      antlr LeftRecursiveRuleWalker.g
      antlr ANTLRv3.g
      antlr AssignTokenTypesWalker.g
      antlr TreeToNFAConverter.g
      antlr ANTLRv3Tree.g
      antlr CodeGenTreeWalker.g
      popd
    '';
    exes = [
      { name = "antlr"; class = "org.antlr.Tool"; }
    ];
  };

  antlr4-version = "4.13.1";
  antlr4-src = fetchFromGitHub {
    owner = "antlr";
    repo = "antlr4";
    rev = antlr4-version;
    hash = "sha256-ky9nTDaS+L9UqyMsGBz5xv+NY1bPavaSfZOeXO1geaA=";
  };

  antlr4-runtime = buildJavaPackage {
    pname = "antlr-runtime";
    version = antlr4-version;
    license = antlr-license;
    src = antlr4-src;
    srcDir = "runtime/Java/src";
  };

  antlr4-stringtemplate = buildJavaPackage rec {
    pname = "antlr-stringtemplate";
    version = "4.3.3";
    license = antlr-license;
    src = fetchFromGitHub {
      owner = "antlr";
      repo = "stringtemplate4";
      rev = version;
      hash = "sha256-IjCLoJUGjJ7ELXr2DGxBUvjMqHz70sO1dNgIJNJtYWg=";
    };
    srcDir = "src";
    compileOnlyDeps = [
      antlr3-bootstrap
    ];
    deps = [
      antlr3-runtime
    ];
    configurePhase = ''
      pushd src/org/stringtemplate/v4/compiler
      antlr STParser.g
      antlr CodeGenerator.g
      antlr Group.g
      popd
    '';
  };

  antlr4-unicodedatacompiler = buildJavaPackage {
    pname = "antlr4-unicodedatacompiler";
    version = antlr4-version;
    license = antlr-license;
    src = antlr4-src;
    srcDir = "tmp";
    deps = [
      antlr4-stringtemplate
      antlr4-runtime
      icu4j-core
    ];
    configurePhase = ''
      mkdir tmp
      mkdir -p tmp/org/antlr/v4/unicode
      cp tool/src/org/antlr/v4/unicode/UnicodeDataTemplateController.java tmp/org/antlr/v4/unicode
      cat >tmp/org/antlr/v4/unicode/Main.java <<EOF
        package org.antlr.v4.unicode;
        import java.util.*;
        import java.nio.file.Path;
        import java.nio.file.Paths;
        import java.nio.file.Files;
        import java.nio.charset.StandardCharsets;
        import org.stringtemplate.v4.*;
        import org.antlr.v4.unicode.UnicodeDataTemplateController;
        public class Main {
          public static void main(String[] args) throws Exception {
            Path filename = Paths.get(args[0]);
            String template = new String(Files.readAllBytes(filename), StandardCharsets.US_ASCII);

            STGroup group = new STGroupString(template);
            ST st = group.getInstanceOf("unicodedata");
            for (Map.Entry<String, Object> entry : UnicodeDataTemplateController.getProperties().entrySet()) {
              st.add(entry.getKey(), entry.getValue());
            }

            String result = st.render();
            System.out.println(result);
          }
        }
      EOF
    '';
    exes = [
      { name = "compile-unicode-data"; class = "org.antlr.v4.unicode.Main"; }
    ];
  };

  antlr4 = buildJavaPackage {
    pname = "antlr";
    version = antlr4-version;
    license = antlr-license;
    src = antlr4-src;
    sourceRoot = "${antlr4-src.name}/tool";
    srcDir = "src";
    resourceDir = "resources";
    compileOnlyDeps = [
      antlr3
      antlr4-unicodedatacompiler
    ];
    deps = [
      antlr3-runtime # !?
      antlr4-runtime
      antlr4-stringtemplate
      treelayout
      icu4j-core
    ];
    configurePhase = ''
      mkdir -p src/org/antlr/v4/tool/unicode
      compile-unicode-data \
        resources/org/antlr/v4/tool/templates/unicodedata.st \
        >src/org/antlr/v4/tool/unicode/UnicodeData.java

      rm resources/org/antlr/v4/tool/templates/unicodedata.st

      pushd src/org/antlr/v4/parse
      antlr ActionSplitter.g
      antlr ANTLRLexer.g
      antlr ANTLRParser.g
      antlr ATNBuilder.g
      antlr BlockSetTransformer.g
      antlr LeftRecursiveRuleWalker.g
      antlr GrammarTreeVisitor.g
      popd

      pushd src/org/antlr/v4/codegen
      antlr -lib ../parse SourceGenTriggers.g
      popd
    '';
    exes = [
      { name = "antlr"; class = "org.antlr.v4.Tool"; }
    ];
  };

}
