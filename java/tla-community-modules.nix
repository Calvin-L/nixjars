{lib, buildJavaPackage, fetchFromGitHub,
 tlatools, gson, commons-lang, commons-math, jgrapht, jungrapht}:

buildJavaPackage rec {
  pname = "tla-community-modules";
  license = lib.licenses.mit;
  version = "202409181925";
  src = fetchFromGitHub {
    owner = "tlaplus";
    repo = "CommunityModules";
    rev = version;
    hash = "sha256-bHZYUdy7dXlJ9iwGVK4aO4SxOgwNpX8R2ahOZN5Sxrw=";
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
