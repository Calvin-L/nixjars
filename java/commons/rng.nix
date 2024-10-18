{lib, fetchFromGitHub, buildJavaPackage,
  testWithJUnit5, junit, opentest4j, commons-math}:

let
version = "1.6";
src = fetchFromGitHub {
  owner = "apache";
  repo = "commons-rng";
  rev = "rel/commons-rng-${version}";
  hash = "sha256-WuUX3TjdSfnK8BfXMnISsXaAJYtdam+5HFJ70jnORJo=";
};
license = lib.licenses.asl20;

client-api = buildJavaPackage rec {
  pname = "commons-rng-client-api";
  inherit version src license;
  sourceRoot = "${src.name}/${pname}";
  checkPhase = testWithJUnit5 {
    testDeps = [
      junit.jupiter-params
    ];
  };
};

core = buildJavaPackage rec {
  pname = "commons-rng-core";
  inherit version src license;
  sourceRoot = "${src.name}/${pname}";
  deps = [
    client-api
  ];

  ## Tests are probabilistic and will fail randomly
  # checkPhase = testWithJUnit5 {
  #   testDeps = [
  #     commons-math
  #     junit.jupiter-params
  #     opentest4j
  #   ];
  # };
};

simple = buildJavaPackage rec {
  pname = "commons-rng-simple";
  inherit version src license;
  sourceRoot = "${src.name}/${pname}";
  deps = [
    client-api
    core
  ];

  ## Tests are probabilistic and will fail randomly
  # checkPhase = testWithJUnit5 {
  #   testDeps = [
  #     commons-math
  #     junit.jupiter-params
  #     opentest4j
  #   ];
  # };
};

in {
  client-api = client-api;
  core = core;
  simple = simple;
}
