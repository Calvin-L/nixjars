{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "jansi";
  version = "2.4.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "fusesource";
    repo = "jansi";
    rev = "${pname}-${version}";
    hash = "sha256-VwR3OMEKMH/GQ/sXSkxc2riUQ+kTNpubYCAyHUa+3ZE=";
  };
}
