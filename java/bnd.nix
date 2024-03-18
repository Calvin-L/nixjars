{lib, buildJavaPackage, fetchFromGitHub, osgi}:

let
version = "7.0.0";
license = lib.licenses.asl20;
src = fetchFromGitHub {
  owner = "bndtools";
  repo = "bnd";
  rev = version;
  hash = "sha256-Im9Pprj/oLeWYjpF0a3pX7JfdM17TmspaYnpnPMVmBk=";
};
in
buildJavaPackage {
  pname = "bnd-annotation";
  inherit version license src;
  srcDir = "biz.aQute.bnd.annotation/src";
  deps = [
    osgi.annotation
    osgi.annotation-versioning
    osgi.resource
    osgi.namespace-service
    osgi.namespace-extender
    osgi.service-serviceloader
  ];
}
