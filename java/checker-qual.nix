{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "checker-qual";
  version = "3.42.0";
  # NOTE: while the Checker Framework is licensed under the GPL2 with
  # classpath exception (licenses.gpl2Classpath), the quals library has a
  # much more permissive MIT license:
  # https://github.com/typetools/checker-framework/blob/master/checker-qual/LICENSE.txt
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "typetools";
    repo = "checker-framework";
    rev = "checker-framework-${version}";
    hash = "sha256-qsJPwcU43+TwVVXcVBen+UY5jvBMHfRdHUy6tsD7sxo=";
  };
  srcDir = "checker-qual/src/main/java";
  manifestProperties = {
    "Automatic-Module-Name" = "org.checkerframework.checker.qual";
  };
}
