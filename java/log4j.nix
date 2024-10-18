{lib, buildJavaPackage, fetchFromGitHub,
 osgi, jms-api, lmax-disruptor, conversantmedia-disruptor, jctools-core,
 jackson, jspecify,
 woodstox-core, jansi, jakarta-activation, jakarta-mail, kafka,
 jeromq, commons-compress, commons-csv, stax2-api, slf4j,
 bnd-annotation, error-prone-annotations, findbugs-annotations}:

rec {

  log4j-api = buildJavaPackage rec {
    pname = "log4j-api";
    version = "2.24.1";
    license = lib.licenses.asl20;
    src = fetchFromGitHub {
      owner = "apache";
      repo = "logging-log4j2";
      rev = "rel/${version}";
      hash = "sha256-uEPFn90gcrECk4389kA9D2Szr70elMdH8+8sqGh1jTU=";
    };
    # src = fetchurl {
    #   url = "https://downloads.apache.org/logging/log4j/${version}/apache-log4j-${version}-src.tar.gz";
    #   hash = "sha256-mieET0vqMU+jrdKIwXBTYNWdm38coSkGLwfQR30+/8U=";
    # };
    srcDir = "${pname}/src/main/java";
    compileOnlyDeps = [
      bnd-annotation
      error-prone-annotations
      findbugs-annotations
      osgi.annotation-bundle
      osgi.annotation-versioning
      osgi.core
      osgi.resource
      jspecify
    ];
  };

  log4j-core = buildJavaPackage rec {
    pname = "log4j-core";
    version = log4j-api.version;
    license = lib.licenses.asl20;
    src = log4j-api.src;
    srcDir = "${pname}/src/main/java";
    deps = [
      log4j-api
    ];
    compileOnlyDeps = [
      bnd-annotation
      commons-compress
      commons-csv
      conversantmedia-disruptor
      findbugs-annotations
      jackson.annotations
      jackson.core
      jackson.databind
      jackson.dataformat-xml
      jackson.dataformat-yaml
      jakarta-activation
      jakarta-mail
      jansi
      jctools-core
      jeromq
      jms-api
      kafka.clients
      lmax-disruptor
      osgi.annotation-bundle
      osgi.annotation-versioning
      osgi.core
      osgi.resource
      stax2-api
      woodstox-core
      jspecify
    ];
    configurePhase = ''
      substituteInPlace log4j-core/src/main/java/org/apache/logging/log4j/core/net/MimeMessageBuilder.java \
        --replace-fail 'javax.mail' 'jakarta.mail'
      substituteInPlace log4j-core/src/main/java/org/apache/logging/log4j/core/net/SmtpManager.java \
        --replace-fail 'javax.mail' 'jakarta.mail'
      substituteInPlace log4j-core/src/main/java/org/apache/logging/log4j/core/net/SmtpManager.java \
        --replace-fail 'javax.activation' 'jakarta.activation'
    '';
  };

  # This is the "bridge" described here: https://logging.apache.org/log4j/2.x/manual/migration.html
  log4j-1_2-api = buildJavaPackage rec {
    pname = "log4j-1.2-api";
    version = log4j-api.version;
    license = lib.licenses.asl20;
    src = log4j-api.src;
    srcDir = "${pname}/src/main/java";
    compileOnlyDeps = [
      bnd-annotation
      error-prone-annotations
      findbugs-annotations
      jms-api
      log4j-core
      osgi.annotation-bundle
      osgi.annotation-versioning
    ];
    deps = [
      log4j-api
    ];
  };

  log4j-slf4j = buildJavaPackage rec {
    pname = "log4j-slf4j";
    version = log4j-api.version;
    license = lib.licenses.asl20;
    src = log4j-api.src;
    srcDir = "${pname}2-impl/src/main/java";
    compileOnlyDeps = [
      bnd-annotation
      osgi.annotation-bundle
      osgi.annotation-versioning
      slf4j.ext
    ];
    deps = [
      log4j-api
      osgi.framework
      slf4j.api
    ];
  };

}
