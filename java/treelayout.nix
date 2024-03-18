{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "treelayout";
  version = "1.0.3";
  license = lib.licenses.bsd3; # https://github.com/abego/treelayout/blob/master/org.abego.treelayout/src/LICENSE.TXT
  src = fetchFromGitHub {
    owner = "abego";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U/Ud2+Cb8Qodm9tF56F7tw0HXT8wzp0/sMCHlShGvqI=";
  };
  sourceRoot = "${src.name}/org.abego.treelayout";
}
