{lib, fetchFromGitHub, buildJavaPackage,
 osgi,
 eclipse-equinox}:

let

version = "4.31";
license = lib.licenses.epl20;
src = fetchFromGitHub {
  owner = "eclipse-platform";
  repo = "eclipse.platform";
  rev = "R${builtins.replaceStrings ["."] ["_"] version}";
  hash = "sha256-c5zqY1gi8stoRxoNIEA7/Tz6Xu4pFIs9kI5jqYKa+60=";
};

in

rec {

  core-jobs = buildJavaPackage {
    pname = "eclipse-platform-core-jobs";
    inherit version license src;
    srcDir = "runtime/bundles/org.eclipse.core.jobs/src";
    deps = [
      osgi.framework
      eclipse-equinox.common
      eclipse-equinox.osgi-supplement
    ];
  };

  core-contenttype = buildJavaPackage {
    pname = "eclipse-platform-core-contenttype";
    inherit version license src;
    srcDir = "runtime/bundles/org.eclipse.core.contenttype/src";
    deps = [
      osgi.service-prefs
      eclipse-equinox.common
      eclipse-equinox.registry
      eclipse-equinox.preferences
      eclipse-equinox.osgi-supplement
    ];
  };

  core-runtime = buildJavaPackage {
    pname = "eclipse-platform-core-runtime";
    inherit version license src;
    srcDir = "runtime/bundles/org.eclipse.core.runtime/src";
    resourceDir = "runtime/bundles/org.eclipse.core.runtime/src"; # messy :(
    deps = [
      osgi.framework
      osgi.service-prefs
      osgi.service-log
      osgi.resource
      osgi.util-tracker
      eclipse-equinox.common
      eclipse-equinox.preferences
      eclipse-equinox.registry
      eclipse-equinox.app
      eclipse-equinox.osgi-supplement
      eclipse-equinox.osgi-container
      core-contenttype
      core-jobs
    ];
  };

  core-filesystem = buildJavaPackage {
    pname = "eclipse-platform-core-filesystem";
    inherit version license src;
    srcDir = "resources/bundles/org.eclipse.core.filesystem/src";
    deps = [
      osgi.framework
      osgi.util-tracker
      eclipse-equinox.osgi-supplement
      core-runtime
      eclipse-equinox.common
      eclipse-equinox.registry
    ];
  };

  core-expressions = buildJavaPackage {
    pname = "eclipse-platform-core-expressions";
    inherit version license src;
    srcDir = "runtime/bundles/org.eclipse.core.expressions/src";
    deps = [
      core-runtime
      eclipse-equinox.common
      eclipse-equinox.osgi-supplement
      eclipse-equinox.osgi-framework
      eclipse-equinox.registry
      eclipse-equinox.preferences
    ];
  };

  core-resources = buildJavaPackage {
    pname = "eclipse-platform-core-resources";
    inherit version license src;
    srcDir = "resources/bundles/org.eclipse.core.resources/src";
    deps = [
      osgi.framework
      osgi.util-tracker
      osgi.service-log
      osgi.service-component
      osgi.service-prefs
      eclipse-equinox.common
      eclipse-equinox.preferences
      eclipse-equinox.registry
      eclipse-equinox.osgi-framework
      eclipse-equinox.osgi-supplement
      core-jobs
      core-filesystem
      core-runtime
      core-contenttype
      core-expressions
    ];
  };

  debug-variables = buildJavaPackage {
    pname = "eclipse-platform-core-variables";
    inherit version license src;
    srcDir = "debug/org.eclipse.core.variables/src";
    deps = [
      eclipse-equinox.common
      eclipse-equinox.preferences
      eclipse-equinox.registry
      eclipse-equinox.osgi-supplement
      core-runtime
      osgi.framework
      osgi.service-prefs
    ];
  };

  debug-core = buildJavaPackage {
    pname = "eclipse-platform-debug";
    inherit version license src;
    srcDir = "debug/org.eclipse.debug.core/core";
    deps = [
      eclipse-equinox.common
      eclipse-equinox.preferences
      eclipse-equinox.registry
      eclipse-equinox.osgi-supplement
      core-expressions
      core-filesystem
      core-jobs
      core-resources
      core-runtime
      debug-variables
      osgi.framework
      osgi.service-prefs
      osgi.util-tracker
    ];
  };

}
