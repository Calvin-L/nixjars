{lib, buildJavaPackage, fetchFromGitHub,
 rsync, vavr-match,
 testWithJUnit4, assertj-core}:

buildJavaPackage rec {
  pname = "vavr";
  version = "0.10.4";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "vavr-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-24UQP0XUe5XR2AWqsPYyt6UsFxcTdB93Ij+sd9NZE4E=";
  };
  sourceRoot = "${src.name}/${pname}";
  nativeBuildInputs = [
    rsync
  ];
  deps = [
    vavr-match
  ];
  patchPhase = ''
    rsync -av src-gen/ src/
    substituteInPlace src/main/java/io/vavr/API.java \
      --replace-fail 'return yield(' 'return this.yield('
  '';

  # might require vavr-match-processor shenanigans?
  # checkPhase = testWithJUnit4 {
  #   testDeps = [assertj-core];
  # };
}
