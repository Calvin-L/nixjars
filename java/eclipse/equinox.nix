{lib, fetchFromGitHub, buildJavaPackage,
 osgi,
 apache-felix,
 eclipse-platform, eclipse-pde}:

let

version = "4.33";
license = lib.licenses.epl20;
src = fetchFromGitHub {
  owner = "eclipse-equinox";
  repo = "equinox";
  rev = "R${builtins.replaceStrings ["."] ["_"] version}";
  hash = "sha256-DbcPaAHcxH/OahpOcsKNRf2Iq3kuYGfg6Lafl4sE/Mw=";
};

in

rec {

  osgi-supplement = buildJavaPackage {
    pname = "eclipse-equinox-osgi-supplement";
    inherit version license src;
    srcDir = "bundles/org.eclipse.osgi/supplement/src";
    deps = [
      eclipse-pde.apitools-annotations
      osgi.annotation-versioning
      osgi.framework
      osgi.resource
      osgi.service-log
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

    patches = [
      # undo https://github.com/eclipse-equinox/equinox/commit/d5e0f4976aa3e0f4f768c782f525f2dd5a4a9fa9#diff-fd1e68916b3a1f200d762ced3898f9fde3e920ca7ffc2456c56a90d8676028bc
      ./equinox-hide-PermutationType.patch
    ];

    # whatever this horseshit is, I refuse to support it
    configurePhase = ''
      rm -r bundles/org.eclipse.osgi/container/src/org/eclipse/osgi/internal/cds
      substituteInPlace bundles/org.eclipse.osgi/container/src/org/eclipse/osgi/internal/hookregistry/HookRegistry.java \
        --replace-fail 'import org.eclipse.osgi.internal.cds.CDSHookConfigurator;' "" \
        --replace-fail 'configurators.add(CDSHookConfigurator.class.getName());' ""
    '';
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
