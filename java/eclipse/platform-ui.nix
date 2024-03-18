{lib, buildJavaPackage, fetchFromGitHub,
 osgi,
 eclipse-equinox, eclipse-platform, eclipse-platform-ui}:

let
  version = "4.31";
  license = lib.licenses.epl20;
  src = fetchFromGitHub {
    owner = "eclipse-platform";
    repo = "eclipse.platform.ui";
    rev = "R${builtins.replaceStrings ["."] ["_"] version}";
    hash = "sha256-xAbB9Bte/YLj1IppBXY3v76Ysq9OiZQuTQ6LLc4WC7A=";
  };
in {

  core-commands = buildJavaPackage {
    pname = "eclipse-platform-ui-core-commands";
    inherit version license src;
    srcDir = "bundles/org.eclipse.core.commands/src";
    deps = [
      eclipse-equinox.common
    ];
  };

  jface-text = buildJavaPackage {
    pname = "eclipse-platform-ui-jface-text";
    inherit version license src;
    srcDir = "bundles/org.eclipse.text/src";
    deps = [
      eclipse-equinox.common
      eclipse-equinox.osgi-supplement
      eclipse-platform.core-runtime
      osgi.service-prefs
      eclipse-equinox.preferences
      eclipse-platform-ui.core-commands
      osgi.framework
    ];
  };

}
