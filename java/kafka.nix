{lib, buildJavaPackage, fetchFromGitHub,
 kafka,
 zstd-jni, lz4, snappy, slf4j, argparse4j, jackson, jose4j}:

let

  version = "3.6.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "kafka";
    rev = version;
    hash = "sha256-RFE0yAgBXkU6QSv8ybZGCiJFsdfOHxisd3j8rEcrUes=";
  };

in {

  generator = buildJavaPackage {
    pname = "kafka-generator";
    inherit version license src;
    srcDir = "generator/src/main/java";
    deps = [
      argparse4j
      jackson.core
      jackson.databind
      jackson.annotations
    ];
    exes = [
      { name = "kafka-generator"; class = "org.apache.kafka.message.MessageGenerator"; }
    ];
  };

  clients = buildJavaPackage {
    pname = "kafka-clients";
    inherit version license src;
    srcDir = "clients/src/main/java";
    deps = [ # https://github.com/apache/kafka/blob/3.6.0/build.gradle
      zstd-jni
      lz4
      snappy
      slf4j.api
    ];
    compileOnlyDeps = [
      jackson.core
      jackson.databind
      # jackson.jdk8types
      jose4j
      kafka.generator
    ];
    configurePhase = ''
      kafka-generator \
        -p org.apache.kafka.common.message \
        -o clients/src/main/java/org/apache/kafka/common/message \
        -i clients/src/main/resources/common/message \
        -t ApiMessageTypeGenerator \
        -m MessageDataGenerator JsonConverterGenerator
    '';
  };

}
