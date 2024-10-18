{lib, fetchFromGitHub, buildJavaPackage,
 guice, guava,
 osgi,
 eclipse-platform, eclipse-equinox, eclipse-emf,
 commons-logging, commons-cli,
 log4j-1_2-api}:

let

eclipse-mwe-version = "2.19.0";
eclipse-mwe-license = lib.licenses.epl20;
eclipse-mwe-src = fetchFromGitHub {
  owner = "eclipse";
  repo = "mwe";
  rev = "v${eclipse-mwe-version}";
  hash = "sha256-otGcNkHwjyi0qviIQePibwsEj6BDOyb8GG/KFrSWQ8o=";
};

in

rec {

  utils = buildJavaPackage {
    pname = "eclipse-mwe-utils";
    version = eclipse-mwe-version;
    license = eclipse-mwe-license;
    src = eclipse-mwe-src;
    srcDir = "plugins/org.eclipse.emf.mwe.utils/src";
    deps = [
      commons-logging
      core
      runtime
      eclipse-emf.codegen-ecore
      eclipse-emf.common
      eclipse-emf.ecore
      eclipse-emf.ecore-xmi
    ];
  };

  runtime = buildJavaPackage {
    pname = "eclipse-mwe-runtime";
    version = eclipse-mwe-version;
    license = eclipse-mwe-license;
    src = eclipse-mwe-src;
    srcDir = "plugins/org.eclipse.emf.mwe2.runtime/src";
    deps = [
      log4j-1_2-api
      guice
    ];
  };

  core = buildJavaPackage {
    pname = "eclipse-mwe-core";
    version = eclipse-mwe-version;
    license = eclipse-mwe-license;
    src = eclipse-mwe-src;
    srcDir = "plugins/org.eclipse.emf.mwe.core/src";
    deps = [
      eclipse-emf.common
      eclipse-emf.ecore
      eclipse-platform.core-runtime
      runtime
      commons-logging
      commons-cli
      eclipse-equinox.common
      eclipse-equinox.app
      osgi.framework
    ];
  };

  lib = buildJavaPackage {
    pname = "eclipse-mwe-lib";
    version = eclipse-mwe-version;
    license = eclipse-mwe-license;
    src = eclipse-mwe-src;
    srcDir = "plugins/org.eclipse.emf.mwe2.lib/src";
    deps = [
      runtime
      utils
      eclipse-emf.codegen
      eclipse-emf.codegen-ecore
      eclipse-emf.common
      eclipse-emf.ecore
      guava
      log4j-1_2-api
    ];
  };

}
