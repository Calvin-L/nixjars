{lib, buildJavaPackage, fetchFromGitHub,
 checker-qual, picocli,
 testWithJUnit5}:

rec {

  reflection-util = buildJavaPackage rec {
    pname = "plume-lib-reflection-util";
    version = "1.1.4";
    license = lib.licenses.mit;
    src = fetchFromGitHub {
      owner = "plume-lib";
      repo = "reflection-util";
      rev = "v${version}";
      hash = "sha256-eERhTw7Kgkktv+jucYx0g5gt1aoklyVQ616tkVEAAis=";
    };
    deps = [
      checker-qual
    ];
    checkPhase = testWithJUnit5 {};
  };

  hashmap-util = buildJavaPackage rec {
    pname = "plume-lib-hashmap-util";
    version = "0.0.1";
    license = lib.licenses.mit;
    src = fetchFromGitHub {
      owner = "plume-lib";
      repo = "hashmap-util";
      rev = "v${version}";
      hash = "sha256-ouhdrlMsBbKlDM9x6D3JzzPMQMkV9sYgGNwPfz/4ZPU=";
    };
    deps = [
      checker-qual
    ];
    checkPhase = testWithJUnit5 {};
  };

  util = buildJavaPackage rec {
    pname = "plume-lib-util";
    version = "1.9.3";
    license = lib.licenses.mit;
    src = fetchFromGitHub {
      owner = "plume-lib";
      repo = "plume-util";
      rev = "v${version}";
      hash = "sha256-DcimcthjX4xS6jubHOm+S8fmpxW0jWSI1DmsPn8nccw=";
    };
    deps = [
      checker-qual

      reflection-util
      hashmap-util
    ];
    checkPhase = testWithJUnit5 {};
  };

  # merging = buildJavaPackage {
  #   pname = "plume-lib-merging";
  #   version = "0.0";
  #   license = lib.licenses.mit;
  #   src = fetchFromGitHub {
  #     owner = "plume-lib";
  #     repo = "merging";
  #     rev = "d3e7194146c5e3bd717b7c1827d1d0d80bd3b2f1";
  #     hash = "sha256-lLFXhqq6tjN8G4ImkpkeU8sWunKeO2mpxZDwtYl26H4=";
  #   };
  #   deps = [
  #     checker-qual
  #     util
  #     picocli
  #   ];
  #   checkPhase = testWithJUnit5 {};
  # };

}
