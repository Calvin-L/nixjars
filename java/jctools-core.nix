{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "jctools-core";
  version = "4.0.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "JCTools";
    repo = "JCTools";
    rev = "v${version}";
    hash = "sha256-6pH2oOVYZOKrtYs2rgrvcbhc4lyx+Ii46Sqs9Xb1Mco=";
  };
  srcDir = "${pname}/src/main/java";
}
