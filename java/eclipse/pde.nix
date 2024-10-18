{lib, buildJavaPackage, fetchFromGitHub}:

let

version = "4.33";
license = lib.licenses.epl20;
src = fetchFromGitHub {
  owner = "eclipse-pde";
  repo = "eclipse.pde";
  rev = "R${builtins.replaceStrings ["."] ["_"] version}";
  hash = "sha256-zJfLcuwgLmx2k20WlBqN4rOloWniGmyTAP2tvJefltQ=";
};

in

rec {

  apitools-annotations = buildJavaPackage {
    pname = "eclipse-pde-apitools-annotations";
    inherit version license src;
    sourceRoot = "${src.name}/apitools/org.eclipse.pde.api.tools.annotations";
    srcDir = "src";
  };

}
