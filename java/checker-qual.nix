{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "checker-qual";
  version = "3.48.1";
  # NOTE: while the Checker Framework is licensed under the GPL2 with
  # classpath exception (licenses.gpl2Classpath), the quals library has a
  # much more permissive MIT license:
  # https://github.com/typetools/checker-framework/blob/master/checker-qual/LICENSE.txt
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "typetools";
    repo = "checker-framework";
    rev = "checker-framework-${version}";
    hash = "sha256-NAp2E7RIuOZMeMVGTvRGuX1WzQZtJGT4eSZX4lxnvzI=";
    sparseCheckout = ["checker-qual"];
  };
  sourceRoot = "${src.name}/checker-qual";
  manifestProperties = {
    "Automatic-Module-Name" = "org.checkerframework.checker.qual";
  };
}
