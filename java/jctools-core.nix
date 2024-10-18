{lib, buildJavaPackage, fetchFromGitHub, osgi}:

buildJavaPackage rec {
  pname = "jctools-core";
  version = "4.0.5";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "JCTools";
    repo = "JCTools";
    rev = "v${version}";
    hash = "sha256-698Fa9DafOr9ai8UQLlV5Ag/y9PA7AzveNq97x8vePs=";
  };
  sourceRoot = "${src.name}/${pname}";
  deps = [osgi.annotation-bundle];
}
