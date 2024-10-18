{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "error-prone-annotations";
  version = "2.33.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "google";
    repo = "error-prone";
    rev = "v${version}";
    hash = "sha256-uDh1WIgap7jQl6TrTUsnjxHMtWpXKUAbsCE0xj3jP8Y=";
  };
  sourceRoot = "${src.name}/annotations";
}
