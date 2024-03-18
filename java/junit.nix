{lib, buildJavaPackage, fetchFromGitHub,
 junit,
 junit4, apiguardian, opentest4j, open-test-reporting, univocity-parsers, picocli}:

let
  version = "5.10.0";
  license = lib.licenses.epl20;
  src = fetchFromGitHub {
    owner = "junit-team";
    repo = "junit5";
    rev = "r${version}";
    hash = "sha256-aljJWg46q0EB3yZTm6OmCY9artoMPN3IO4UAlD3oJ0M=";
  };
in {

  platform-commons = buildJavaPackage {
    pname = "junit-platform-commons";
    inherit version license src;
    srcDir = "junit-platform-commons/src/main/java";
    deps = [
      apiguardian
    ];
  };

  platform-engine = buildJavaPackage {
    pname = "junit-platform-engine";
    inherit version license src;
    srcDir = "junit-platform-engine/src/main/java";
    deps = [
      apiguardian
      junit.platform-commons
      opentest4j
    ];
  };

  platform-launcher = buildJavaPackage {
    pname = "junit-platform-launcher";
    inherit version license src;
    srcDir = "junit-platform-launcher/src/main/java";
    deps = [
      apiguardian
      junit.platform-commons
      junit.platform-engine
    ];
    patchPhase = ''
      substituteInPlace junit-platform-launcher/src/main/java/org/junit/platform/launcher/TestIdentifier.java \
        --replace-fail 'SerializedForm(ObjectInputStream.GetField fields) throws IOException {' 'SerializedForm(ObjectInputStream.GetField fields) throws IOException, ClassNotFoundException {'
    '';
  };

  jupiter-api = buildJavaPackage {
    pname = "junit-jupiter-api";
    inherit version license src;
    sourceRoot = "${src.name}/junit-jupiter-api";
    deps = [
      apiguardian
      junit.platform-commons
      opentest4j
    ];
  };

  jupiter-engine = buildJavaPackage {
    pname = "junit-jupiter-engine";
    inherit version license src;
    sourceRoot = "${src.name}/junit-jupiter-engine";
    deps = [
      apiguardian
      junit.jupiter-api
      junit.platform-commons
      junit.platform-engine
      opentest4j
    ];
  };

  jupiter-params = buildJavaPackage {
    pname = "junit-jupiter-params";
    inherit version license src;
    sourceRoot = "${src.name}/junit-jupiter-params";
    deps = [
      apiguardian
      junit.jupiter-api
      junit.platform-commons
      univocity-parsers
    ];
  };

  platform-console = buildJavaPackage {
    pname = "junit-platform-console";
    inherit version license src;
    sourceRoot = "${src.name}/junit-platform-console";
    deps = [
      apiguardian
      junit.platform-commons
      junit.platform-engine
      junit.platform-launcher
      junit.platform-reporting
      opentest4j
      picocli
    ];
    exes = [
      { name = "junit-platform-console"; class = "org.junit.platform.console.ConsoleLauncher"; }
    ];
  };

  platform-reporting = buildJavaPackage {
    pname = "junit-platform-reporting";
    inherit version license src;
    sourceRoot = "${src.name}/junit-platform-reporting";
    deps = [
      apiguardian
      junit.platform-commons
      junit.platform-engine
      junit.platform-launcher
      open-test-reporting.events
      open-test-reporting.schema
      opentest4j
    ];
  };

  platform-suite-api = buildJavaPackage {
    pname = "junit-platform-suite-api";
    inherit version license src;
    sourceRoot = "${src.name}/junit-platform-suite-api";
    deps = [
      apiguardian
      junit.platform-commons
    ];
  };

  platform-suite-commons = buildJavaPackage {
    pname = "junit-platform-suite-commons";
    inherit version license src;
    sourceRoot = "${src.name}/junit-platform-suite-commons";
    deps = [
      apiguardian
      junit.platform-commons
      junit.platform-engine
      junit.platform-launcher
      junit.platform-suite-api
    ];
  };

  platform-runner = buildJavaPackage {
    pname = "junit-platform-runner";
    inherit version license src;
    sourceRoot = "${src.name}/junit-platform-runner";
    deps = [
      apiguardian
      junit.platform-commons
      junit.platform-engine
      junit.platform-launcher
      junit.platform-suite-api
      junit.platform-suite-commons
      junit4
    ];
  };

  vintage-engine = buildJavaPackage {
    pname = "junit-vintage-engine";
    inherit version license src;
    sourceRoot = "${src.name}/junit-vintage-engine";
    deps = [
      apiguardian
      junit.platform-commons
      junit.platform-engine
      junit.platform-runner
      junit4
      opentest4j
    ];
  };

}
