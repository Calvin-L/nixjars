{lib, fetchurl, buildJavaPackage, log4j-1_2-api, jakarta-servlet-api}:

buildJavaPackage rec {
  pname = "apache-commons-logging";
  version = "1.2";
  license = lib.licenses.asl20;
  src = fetchurl {
    url = "https://downloads.apache.org/commons/logging/source/commons-logging-${version}-src.tar.gz";
    sha256 = "49665da5a60d033e6dff40fe0a7f9173e886ae859ce6096c1afe34c48b677c81";
  };
  compileOnlyDeps = [
    log4j-1_2-api
    # log4j-api
    # log4j-slf4j
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
