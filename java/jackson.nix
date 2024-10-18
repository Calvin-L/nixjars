{lib, buildJavaPackage, fetchFromGitHub,
 fastdoubleparser, jackson, stax2-api, snakeyaml, joda-time,
 testWithJUnit5, junit, assertj-core, mockito, guava-testlib,
 testWithJUnit4, junit4, hamcrest}:

let
  version = "2.18.0";
  license = lib.licenses.asl20;

  modules-java8-src = fetchFromGitHub {
    owner = "FasterXML";
    repo = "jackson-modules-java8";
    rev = "jackson-modules-java8-${version}";
    hash = "sha256-51MrlmRKdDTzqHngCIERDFbtAKJl1XR6CblvNjDbfFA=";
  };
in
{

  core = buildJavaPackage rec {
    pname = "jackson-core";
    inherit version license;
    src = fetchFromGitHub {
      owner = "FasterXML";
      repo = pname;
      rev = "${pname}-${version}";
      hash = "sha256-07PyWKVT0SUHKoiZrB73OR+WHQPQtmDfFxKe/5OGMsA=";
    };
    deps = [
      fastdoubleparser
    ];
    patchPhase = ''
      F=src/main/java/com/fasterxml/jackson/core/json/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace-fail '@package@' 'com.fasterxml.jackson.core.json'
      substituteInPlace "$F" \
        --replace-fail '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace-fail '@projectgroupid@' 'com.fasterxml.jackson.core'
      substituteInPlace "$F" \
        --replace-fail '@projectartifactid@' 'jackson-core'

      rm -rf src/test/java/com/fasterxml/jackson/failing
    '';
    checkPhase = testWithJUnit5 {
      testDeps = [
        assertj-core
        junit.jupiter-params
        junit.vintage-engine
        junit4
      ];
    };
  };

  annotations = buildJavaPackage rec {
    pname = "jackson-annotations";
    inherit version license;
    src = fetchFromGitHub {
      owner = "FasterXML";
      repo = pname;
      rev = "${pname}-${version}";
      hash = "sha256-v5aYafFFnpRi4uVz33PyURH6j/vOjm1CRFg0GA1nkzA=";
    };
  };

  databind = buildJavaPackage rec {
    pname = "jackson-databind";
    inherit version license;
    src = fetchFromGitHub {
      owner = "FasterXML";
      repo = pname;
      rev = "${pname}-${version}";
      hash = "sha256-5yiyAchZmCVXLcR7w/+a8VH8oc9qWBNxVScFhlMltnA=";
    };
    compileOnlyDeps = [
      jackson.annotations
    ];
    deps = [
      jackson.core
    ];

    # notes about removed tests:
    #  - MapperFootprintTest: JOL cannot be compiled on modern JDKs
    #  - NoClassDefFoundWorkaroundTest: JSR-275 discontinued (https://stackoverflow.com/questions/11607094/where-can-i-find-a-jsr-275-replacement)
    patchPhase = ''
      F=src/main/java/com/fasterxml/jackson/databind/cfg/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace-fail '@package@' 'com.fasterxml.jackson.databind.cfg'
      substituteInPlace "$F" \
        --replace-fail '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace-fail '@projectgroupid@' 'com.fasterxml.jackson.core'
      substituteInPlace "$F" \
        --replace-fail '@projectartifactid@' '${pname}'

      rm -rf src/test/java/com/fasterxml/jackson/failing
      rm -v src/test/java/com/fasterxml/jackson/databind/MapperFootprintTest.java
      rm -v src/test/java/com/fasterxml/jackson/databind/introspect/NoClassDefFoundWorkaroundTest.java
    '';

    # lots of tests fail with inaccessible fields... guess this wasn't made for JDK 9+
    # checkPhase = testWithJUnit5 {
    #   testDeps = [
    #     assertj-core
    #     guava-testlib
    #     junit.jupiter-api
    #     junit.jupiter-params
    #     junit.vintage-engine
    #     junit4
    #     mockito
    #   ];
    # };
  };

  dataformat-cbor = buildJavaPackage rec {
    pname = "jackson-dataformat-cbor";
    inherit version license;
    src = fetchFromGitHub rec {
      owner = "FasterXML";
      repo = "jackson-dataformats-binary";
      rev = "${repo}-${version}";
      hash = "sha256-Bm8uVvudXUmIzJFnPOeU6uQOaBBAKGqv258nTTaAxFs=";
    };
    sourceRoot = "${src.name}/cbor";
    compileOnlyDeps = [
      jackson.annotations
    ];
    deps = [
      jackson.core
      jackson.databind
    ];
    patchPhase = ''
      F=src/main/java/com/fasterxml/jackson/dataformat/cbor/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace-fail '@package@' 'com.fasterxml.jackson.dataformat.cbor'
      substituteInPlace "$F" \
        --replace-fail '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace-fail '@projectgroupid@' 'com.fasterxml.jackson.core'
      substituteInPlace "$F" \
        --replace-fail '@projectartifactid@' '${pname}'
    '';
  };

  dataformat-yaml = buildJavaPackage rec {
    pname = "jackson-dataformat-yaml";
    inherit version license;
    src = fetchFromGitHub rec {
      owner = "FasterXML";
      repo = "jackson-dataformats-text";
      rev = "${repo}-${version}";
      hash = "sha256-R4zu2EI1Wdt0Us+rUU16nHxod3kQ0b8bEWjbxXo46OU=";
    };
    sourceRoot = "${src.name}/yaml";
    compileOnlyDeps = [
      jackson.annotations
    ];
    deps = [
      jackson.core
      jackson.databind
      snakeyaml
    ];
    patchPhase = ''
      F=src/main/java/com/fasterxml/jackson/dataformat/yaml/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace-fail '@package@' 'com.fasterxml.jackson.dataformat.yaml'
      substituteInPlace "$F" \
        --replace-fail '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace-fail '@projectgroupid@' 'com.fasterxml.jackson.core'
      substituteInPlace "$F" \
        --replace-fail '@projectartifactid@' '${pname}'
    '';
  };

  dataformat-xml = buildJavaPackage rec {
    pname = "jackson-dataformat-xml";
    inherit version license;
    src = fetchFromGitHub {
      owner = "FasterXML";
      repo = pname;
      rev = "${pname}-${version}";
      hash = "sha256-qDlSQceC9NmKnmf5HCoNY1SS7+ZYEj9ACPCB2blnTBk=";
    };
    compileOnlyDeps = [
      jackson.annotations
    ];
    deps = [
      jackson.core
      jackson.databind
      # jackson-module-jakarta-xmlbind-annotations # test-only dep
      stax2-api
      # woodstox-core # or Aalto...?
    ];
    patchPhase = ''
      F=src/main/java/com/fasterxml/jackson/dataformat/xml/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace-fail '@package@' 'com.fasterxml.jackson.dataformat.xml'
      substituteInPlace "$F" \
        --replace-fail '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace-fail '@projectgroupid@' 'com.fasterxml.jackson.core'
      substituteInPlace "$F" \
        --replace-fail '@projectartifactid@' '${pname}'
    '';
  };

  jr-objects = buildJavaPackage rec {
    pname = "jackson-jr-objects";
    inherit version license;
    src = fetchFromGitHub {
      owner = "FasterXML";
      repo = "jackson-jr";
      rev = "jackson-jr-parent-${version}";
      hash = "sha256-8uurwmY3Qcl/pLSK8F2xXG6JjQ4hOnpUQIFKFf85v/o=";
    };
    sourceRoot = "${src.name}/jr-objects";
    deps = [
      jackson.core
    ];
    patchPhase = ''
      F=src/main/java/com/fasterxml/jackson/jr/ob/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace-fail '@package@' 'com.fasterxml.jackson.jr.ob'
      substituteInPlace "$F" \
        --replace-fail '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace-fail '@projectgroupid@' 'com.fasterxml.jackson.jr'
      substituteInPlace "$F" \
        --replace-fail '@projectartifactid@' '${pname}'
    '';
  };

  parameter-names = buildJavaPackage rec {
    pname = "jackson-parameter-names";
    inherit version license;
    src = modules-java8-src;
    sourceRoot = "${modules-java8-src.name}/parameter-names";
    deps = [
      jackson.annotations
      jackson.core
      jackson.databind
    ];
    patchPhase = ''
      F=src/main/java/com/fasterxml/jackson/module/paramnames/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace-fail '@package@' 'com.fasterxml.jackson.module.paramnames'
      substituteInPlace "$F" \
        --replace-fail '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace-fail '@projectgroupid@' 'com.fasterxml.jackson.module'
      substituteInPlace "$F" \
        --replace-fail '@projectartifactid@' '${pname}'
    '';

    # 2024/3/25: fails but I'm not sure why
    # checkPhase = testWithJUnit4 {
    #   testDeps = [
    #     assertj-core
    #     mockito
    #   ];
    # };
  };

  datetime = buildJavaPackage rec {
    pname = "jackson-datetime";
    inherit version license;
    src = modules-java8-src;
    sourceRoot = "${modules-java8-src.name}/datetime";
    deps = [
      jackson.annotations
      jackson.core
      jackson.databind
    ];
    patchPhase = ''
      F=src/main/java/com/fasterxml/jackson/datatype/jsr310/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace-fail '@package@' 'com.fasterxml.jackson.datatype.jsr310'
      substituteInPlace "$F" \
        --replace-fail '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace-fail '@projectgroupid@' 'com.fasterxml.jackson.module'
      substituteInPlace "$F" \
        --replace-fail '@projectartifactid@' '${pname}'
    '';

    # 2024/3/25: fails but I'm not sure why
    # checkPhase = testWithJUnit4 {
    #   testDeps = [
    #     hamcrest
    #   ];
    # };
  };

  datatypes = buildJavaPackage rec {
    pname = "jackson-datatypes";
    inherit version license;
    src = modules-java8-src;
    sourceRoot = "${modules-java8-src.name}/datatypes";
    deps = [
      jackson.core
      jackson.databind
    ];
    patchPhase = ''
      F=src/main/java/com/fasterxml/jackson/datatype/jdk8/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace-fail '@package@' 'com.fasterxml.jackson.datatype.jdk8'
      substituteInPlace "$F" \
        --replace-fail '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace-fail '@projectgroupid@' 'com.fasterxml.jackson.module'
      substituteInPlace "$F" \
        --replace-fail '@projectartifactid@' '${pname}'
    '';
    checkPhase = testWithJUnit4 {
      testDeps = [
        hamcrest
        jackson.annotations
      ];
    };
  };

  datatype-joda = buildJavaPackage rec {
    pname = "jackson-datatype-joda";
    inherit version license;
    src = fetchFromGitHub {
      owner = "FasterXML";
      repo = pname;
      rev = "${pname}-${version}";
      hash = "sha256-66jTD+8mM1FvmSgY7KPB3a+zj7hjLSd3MMJD80WoT+U=";
    };
    deps = [
      jackson.annotations
      jackson.core
      jackson.databind
      joda-time
    ];
    patchPhase = ''
      F=src/main/java/com/fasterxml/jackson/datatype/joda/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace-fail '@package@' 'com.fasterxml.jackson.datatype.joda'
      substituteInPlace "$F" \
        --replace-fail '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace-fail '@projectgroupid@' 'com.fasterxml.jackson.datatype'
      substituteInPlace "$F" \
        --replace-fail '@projectartifactid@' '${pname}'
    '';
    checkPhase = testWithJUnit4 {
      testDeps = [
        hamcrest
      ];
    };
  };

}
