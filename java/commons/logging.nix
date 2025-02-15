{lib, fetchFromGitHub, buildJavaPackage,
 log4j-1_2-api, log4j-api, slf4j, jakarta-servlet-api}:

buildJavaPackage rec {
  pname = "commons-logging";
  version = "1.3.4";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-logging";
    rev = "rel/commons-logging-${version}";
    hash = "sha256-pIy6SBy+niQ/7mbSjLn7d+72C2TBXSWjgurtZtAvoCU=";
  };
  compileOnlyDeps = [
    log4j-1_2-api
    log4j-api
    # log4j-slf4j
    slf4j.api
    # logkit
    # avalon-framework
    # avalon-logkit
    jakarta-servlet-api
  ];

  # fuck this deprecated bullshit
  patchPhase = ''
    rm src/main/java/org/apache/commons/logging/impl/LogKitLogger.java
    rm src/main/java/org/apache/commons/logging/impl/AvalonLogger.java

    substituteInPlace src/main/java/org/apache/commons/logging/impl/ServletContextCleaner.java \
      --replace-quiet 'javax.servlet.' 'jakarta.servlet.'
  '';
}
