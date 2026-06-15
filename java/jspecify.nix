{lib, fetchFromGitHub, buildJavaPackage}:

buildJavaPackage rec {
  pname = "jspecify";
  version = "1.0.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "jspecify";
    repo = "jspecify";
    rev = "v${version}";
    hash = "sha256-WgVRaGm9lYhMeMM6QWUezXtUsXkaK/iPt1gj2koWNu8=";
  };
  patchPhase = ''
    rsync -av --ignore-existing 'src/java9/java/' 'src/main/java/'
  '';
}
