{lib, buildJavaPackage, fetchFromGitHub, jdk, rsync,
 testWithJUnit5, junit, jmh}:

let
  javaMajorVersion = lib.strings.toIntBase10 (builtins.elemAt (lib.strings.splitString "." (jdk.version)) 0);
  specialCodeVersion =
    if javaMajorVersion >= 22 then "22"
    else if javaMajorVersion >= 21 then "21"
    else if javaMajorVersion >= 17 then "17"
    else if javaMajorVersion >= 11 then "11"
    else "8";
in buildJavaPackage rec {
  pname = "fastdoubleparser";
  version = "1.0.1";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "wrandelshofer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sqxgPW+pJiEqLM+IwApxM3x/eaPBkLgCDZceGX1tFQc=";
  };

  # jdk.incubator.vector not available, so no FastDoubleVector for you!
  patchPhase = ''
    target='${srcDir}'
    ${rsync}/bin/rsync -av --ignore-existing 'fastdoubleparser-dev/src/main/java/' "$target/"
    find "$target" \( -name FastDoubleVector.java \) -print -delete
    rm -v fastdoubleparser-dev/src/test/java/ch.randelshofer.fastdoubleparser/ch/randelshofer/fastdoubleparser/EarlyAccessEightDigitsVectorTest.java
    rm -v fastdoubleparser-dev/src/test/java/ch.randelshofer.fastdoubleparser/ch/randelshofer/fastdoubleparser/JmhEightDigits.java
  '';

  srcDir = "fastdoubleparser-java${specialCodeVersion}/src/main/java";

  checkPhase = testWithJUnit5 {
    testSrcDirs = ["fastdoubleparser-dev/src/test/java"];
    testDeps = [
      jmh.core
      junit.jupiter-params
    ];
    jvmArgs = ["-DenableLongRunningTests=false"];
  };
}
