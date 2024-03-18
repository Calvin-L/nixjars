{lib, fetchFromGitHub, buildJavaPackage, commons-lang}:

buildJavaPackage rec {
  pname = "commons-bcel";
  version = "6.7.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-bcel";
    rev = "rel/${pname}-${version}";
    hash = "sha256-/K3zmPWxzxVK/2AAj6sZQAvlTHA4eMUvFeGf7ZXi5+4=";
  };
  srcDir = "src/main";
  deps = [
    commons-lang
  ];
}
