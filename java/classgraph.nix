{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "classgraph";
  version = "4.8.163";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-Y0xv/Ip3sYwnrDFf8i+1QqlJm6GvNpz1bPAJcFwJ2K0=";
  };
}
