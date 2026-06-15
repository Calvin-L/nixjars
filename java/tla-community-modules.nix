{lib, buildJavaPackage, fetchFromGitHub,
 tlatools, gson, commons-lang, commons-math, jgrapht, jungrapht}:

buildJavaPackage rec {
  pname = "tla-community-modules";
  license = lib.licenses.mit;
  version = "202604221529";
  src = fetchFromGitHub {
    owner = "tlaplus";
    repo = "CommunityModules";
    rev = version;
    hash = "sha256-3AoHx8GgU9cPTQeCBYpObZCw9L5ClUf2Y4QS8sNTkbw=";
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
