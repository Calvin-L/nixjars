{lib, fetchFromGitHub, buildJavaPackage,
 osgi,
 apache-felix,
 eclipse-platform}:

let

version = "4.31";
license = lib.licenses.epl20;
src = fetchFromGitHub {
  owner = "eclipse-equinox";
  repo = "equinox";
  rev = "R${builtins.replaceStrings ["."] ["_"] version}";
  hash = "sha256-naexkmRmXPGgFGKm6NktQRcvP4KIFqno2kqrpPQxxuk=";
};

in

rec {

  osgi-supplement = buildJavaPackage {
    pname = "eclipse-equinox-osgi-supplement";
    inherit version license src;
    srcDir = "bundles/org.eclipse.osgi/supplement/src";
    deps = [
      osgi.service-log
      osgi.framework
      osgi.resource
      osgi.service-resolver
    ];
  };

  osgi-container = buildJavaPackage {
    pname = "eclipse-equinox-osgi-container";
    inherit version license src;
    srcDir = "bundles/org.eclipse.osgi/container/src";
    deps = [
      osgi.framework
      osgi.util-tracker
      osgi.resource
      osgi.service-log
      osgi.service-resolver
      osgi.service-condition
      osgi.service-condpermadmin
      osgi.service-permissionadmin
      osgi.service-packageadmin
      osgi.service-startlevel
      osgi.service-url
      osgi.dto
      apache-felix.resolver
      osgi-supplement
      # openj9-sharedclasses-ibm-oti-shared
    ];

    # whatever this horseshit is, I refuse to support it
    configurePhase = ''
      rm -r bundles/org.eclipse.osgi/container/src/org/eclipse/osgi/internal/cds
      substituteInPlace bundles/org.eclipse.osgi/container/src/org/eclipse/osgi/internal/hookregistry/HookRegistry.java \
        --replace 'import org.eclipse.osgi.internal.cds.CDSHookConfigurator;' "" \
        --replace 'configurators.add(CDSHookConfigurator.class.getName());' ""
    '';
  };

  osgi-framework = buildJavaPackage {
    pname = "eclipse-equinox-osgi-framework";
    inherit version license src;
    srcDir = "bundles/org.eclipse.osgi/osgi/src";
    deps = [
      osgi.annotation-versioning
      osgi-container
    ];
  };

  common = buildJavaPackage {
    pname = "eclipse-equinox-common";
    inherit version license src;
    srcDir = "bundles/org.eclipse.equinox.common/src";
    deps = [
      osgi-supplement
      osgi.framework
      osgi.service-component
      osgi.service-log
      osgi.service-packageadmin
      osgi.service-url
      osgi.util-tracker
    ];
  };

  registry = buildJavaPackage {
    pname = "eclipse-equinox-registry";
    inherit version license src;
    srcDir = "bundles/org.eclipse.equinox.registry/src";
    resourceDir = "bundles/org.eclipse.equinox.registry/src"; # messy :(
    deps = [
      osgi.util-tracker
      osgi.framework
      osgi.service-packageadmin
      common
      osgi-supplement
      osgi-container
      eclipse-platform.core-jobs
    ];
  };

  preferences = buildJavaPackage {
    pname = "eclipse-equinox-preferences";
    inherit version license src;
    srcDir = "bundles/org.eclipse.equinox.preferences/src";
    deps = [
      osgi.service-prefs
      osgi.framework
      osgi.service-packageadmin
      osgi.util-tracker
      common
      registry
      osgi-supplement
    ];
  };

  app = buildJavaPackage {
    pname = "eclipse-equinox-app";
    inherit version license src;
    srcDir = "bundles/org.eclipse.equinox.app";
    deps = [
      osgi.framework
      osgi.util-tracker
      osgi.service-condpermadmin
      osgi.service-packageadmin
      osgi.service-event
      osgi-supplement
      registry
      common
    ];
  };

}
