{lib, buildJavaPackage, fetchFromGitHub,
 tlatools, gson, commons-lang, commons-math, jgrapht, jungrapht}:

buildJavaPackage rec {
  pname = "tla-community-modules";
  license = lib.licenses.mit;
  version = "202405171516";
  src = fetchFromGitHub {
    owner = "tlaplus";
    repo = "CommunityModules";
    rev = version;
    hash = "sha256-xdutDP1LYJYswIBgB8RjhEWHUREI96e+Xba5m0Ulxmg=";
  };
  srcDir = "modules";
  resourceDir = "modules";
  deps = [
    commons-lang
    commons-math
    gson
    jgrapht.core
    jungrapht.layout
    tlatools.lib
  ];
}
