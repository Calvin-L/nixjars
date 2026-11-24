{lib, buildJavaPackage, fetchFromGitHub,
 tla-tools, gson, commons-lang, commons-math, jgrapht, jungrapht}:

buildJavaPackage rec {
  pname = "tla-community-modules";
  license = lib.licenses.mit;
  version = "202611191749";
  src = fetchFromGitHub {
    owner = "tlaplus";
    repo = "CommunityModules";
    rev = version;
    hash = "sha256-G0PgkxlHMiL7zNj9irPrY+CVr+Z0DZe4X2iEGr6fGxM=";
  };
  srcDir = "modules";
  resourceDir = "modules";
  deps = [
    commons-lang
    commons-math
    gson
    jgrapht.core
    jungrapht.layout
    tla-tools.lib
  ];
}
