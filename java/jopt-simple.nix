{lib, fetchFromGitHub, buildJavaPackage, testWithJUnit4}:

buildJavaPackage rec {
  pname = "jopt-simple";
  version = "5.0.4";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-pKZG/QYT+mrb+v2ZGqNV/j/Ou+jkydy5eqk739xSabg=";
  };
  # sourceRoot = "${src.name}/net.sf.joptsimple";
  # checkPhase = testWithJUnit4 {};
}
