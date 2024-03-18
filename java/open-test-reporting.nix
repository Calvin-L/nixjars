{lib, buildJavaPackage, fetchFromGitHub, open-test-reporting}:

let
  version = "0.1.0-M1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "ota4j-team";
    repo = "open-test-reporting";
    rev = "r${version}";
    hash = "sha256-B+en7KnC+xrQ6IhmCZRSg8qF6PRm0oqVP9JZAs0Ee6s=";
  };
in {
  schema = buildJavaPackage {
    pname = "open-test-reporting-schema";
    inherit version license src;
    sourceRoot = "${src.name}/schema";
  };

  events = buildJavaPackage {
    pname = "open-test-reporting-events";
    inherit version license src;
    sourceRoot = "${src.name}/events";
    deps = [
      open-test-reporting.schema
    ];
  };
}
