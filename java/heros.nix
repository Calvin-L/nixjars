{lib, buildJavaPackage, fetchFromGitHub,
 guava, slf4j,
 testWithJUnit4, mockito}:

buildJavaPackage rec {
  pname = "heros";
  version = "1.2.1";
  license = lib.licenses.lgpl21;
  src = fetchFromGitHub {
    owner = "soot-oss";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/qeWR9rwC/yX2OBUWwKs7BphpV1G8PaYZkPxQttRx3Q=";
  };
  srcDir = "src";
  deps = [
    guava
    slf4j.api
  ];

  # not updated for Mockito 5.x
  # checkPhase = testWithJUnit4 {
  #   testSrcDirs = ["test"];
  #   testDeps = [mockito];
  # };
}
