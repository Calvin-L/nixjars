{lib, buildJavaPackage, fetchFromGitHub,
 eclipse-emf, eclipse-platform, eclipse-equinox, eclipse-jdt,
 eclipse-platform-ui, osgi}:

let
  version = "2.39.0";
  license = lib.licenses.epl20;
  src = fetchFromGitHub {
    owner = "eclipse-emf";
    repo = "org.eclipse.emf";
    rev = "R${builtins.replaceStrings ["."] ["_"] version}";
    hash = "sha256-S/N+xOP4QDd2nUVIC/7jm6oYa8etEjTs7hfzWnufHIE=";
  };
in {
  common = buildJavaPackage {
    pname = "eclipse-emf-common";
    inherit version license src;
    srcDir = "plugins/org.eclipse.emf.common";
    sourceEncoding = "iso-8859-1";
    deps = [
      eclipse-platform.core-runtime
      eclipse-equinox.common
      osgi.framework
      osgi.resource
      eclipse-equinox.osgi-container
    ];
    configurePhase = ''
      substituteInPlace plugins/org.eclipse.emf.common/src/org/eclipse/emf/common/archive/ArchiveURLConnection.java \
        --replace-fail 'return yield(' 'return this.yield('
      substituteInPlace plugins/org.eclipse.emf.common/src/org/eclipse/emf/common/archive/ArchiveURLConnection.java \
        --replace-fail ': yield(' ': this.yield('
      substituteInPlace plugins/org.eclipse.emf.common/src/org/eclipse/emf/common/util/BasicEMap.java \
        --replace-fail 'return yield(' 'return this.yield('
    '';
  };

  ecore = buildJavaPackage {
    pname = "eclipse-emf-ecore";
    inherit version license src;
    srcDir = "plugins/org.eclipse.emf.ecore";
    resourceDir = "plugins/org.eclipse.emf.ecore"; # messy :(
    sourceEncoding = "iso-8859-1";
    deps = [
      eclipse-emf.common
      osgi.framework
      eclipse-platform.core-runtime
      eclipse-equinox.common
      eclipse-equinox.registry
      eclipse-equinox.preferences
      eclipse-platform.core-jobs
      eclipse-platform.core-contenttype
      eclipse-platform.core-resources
    ];
    # > error: invalid use of a restricted identifier 'yield' [...] (to invoke
    # > a method called yield, qualify the yield with a receiver or type name)
    configurePhase = ''
      substituteInPlace plugins/org.eclipse.emf.ecore/src/org/eclipse/emf/ecore/util/EcoreUtil.java \
        --replace-fail '= yield(' '= this.yield('
    '';
  };

  ecore-xmi = buildJavaPackage {
    pname = "eclipse-emf-ecore-xmi";
    inherit version license src;
    srcDir = "plugins/org.eclipse.emf.ecore.xmi";
    sourceEncoding = "iso-8859-1";
    deps = [
      eclipse-emf.ecore
      eclipse-emf.common
      eclipse-platform.core-runtime
      eclipse-platform.core-contenttype
      eclipse-equinox.common
      eclipse-equinox.registry
      osgi.framework
    ];
  };

  codegen = buildJavaPackage {
    pname = "eclipse-emf-codegen";
    inherit version license src;
    srcDir = "plugins/org.eclipse.emf.codegen/src";
    sourceEncoding = "iso-8859-1";
    deps = [
      eclipse-equinox.app
      eclipse-equinox.common
      eclipse-equinox.registry
      eclipse-jdt.core
      eclipse-jdt.core-compiler-batch
      eclipse-equinox.osgi-supplement
      eclipse-platform.core-jobs
      eclipse-platform.core-resources
      eclipse-platform.core-runtime
      eclipse-platform-ui.jface-text
      eclipse-emf.common
      osgi.framework
    ];
  };

  codegen-ecore = buildJavaPackage {
    pname = "eclipse-emf-codegen-ecore";
    inherit version license src;
    srcDir = "plugins/org.eclipse.emf.codegen.ecore/src";
    sourceEncoding = "iso-8859-1";
    deps = [
      eclipse-equinox.app
      eclipse-equinox.common
      eclipse-equinox.preferences
      eclipse-equinox.registry
      eclipse-jdt.core
      eclipse-jdt.core-compiler-batch
      eclipse-jdt.debug-launching
      eclipse-platform.core-jobs
      eclipse-platform.core-resources
      eclipse-platform.core-runtime
      eclipse-platform-ui.jface-text
      eclipse-emf.codegen
      eclipse-emf.common
      eclipse-emf.ecore
      eclipse-emf.ecore-xmi
      osgi.framework
    ];
  };
}
