{lib, buildJavaPackage, fetchFromGitHub,
 tlatools, gson, commons-lang, commons-math, jgrapht, jungrapht}:

buildJavaPackage rec {
  pname = "tla-community-modules";
  license = lib.licenses.mit;
  version = "202607311834";
  src = fetchFromGitHub {
    owner = "tlaplus";
    repo = "CommunityModules";
    rev = version;
    hash = "sha256-1zP1xc5skCMxuq+WAvBBzrdLlFhOUd9Rcmuoqjui0lM=";
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
