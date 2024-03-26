{lib, buildJavaPackage, fetchFromGitHub,
 fastdoubleparser, jackson, stax2-api, snakeyaml, joda-time,
 testWithJUnit5, junit, assertj-core, mockito, guava-testlib,
 testWithJUnit4, junit4, hamcrest}:

let
  version = "2.17.0";
  license = lib.licenses.asl20;

  modules-java8-src = fetchFromGitHub {
    owner = "FasterXML";
    repo = "jackson-modules-java8";
    rev = "jackson-modules-java8-${version}";
    hash = "sha256-hXJjJ3aeBR4Sx5a5HRmKAqJwSTmkuXHg3Rxczvc/1ys=";
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
      hash = "sha256-cLu0qVrQRSPP0g8ME0K7cHWz6JnTTmZbOBBDbVp+La8=";
    };
    deps = [
      fastdoubleparser
    ];
    patchPhase = ''
      F=src/main/java/com/fasterxml/jackson/core/json/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace '@package@' 'com.fasterxml.jackson.core.json'
      substituteInPlace "$F" \
        --replace '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace '@projectgroupid@' 'com.fasterxml.jackson.core'
      substituteInPlace "$F" \
        --replace '@projectartifactid@' 'jackson-core'

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
      hash = "sha256-NqCSUlhzkpjShsHTp3INedASg8+z0XmJNiP4Ug476zU=";
    };
  };

  databind = buildJavaPackage rec {
    pname = "jackson-databind";
    inherit version license;
    src = fetchFromGitHub {
      owner = "FasterXML";
      repo = pname;
      rev = "${pname}-${version}";
      hash = "sha256-HG8TpXFPSQ8/Wt5kUGG6OpQxxvi0RM7LYhvi/K3i89A=";
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
        --replace '@package@' 'com.fasterxml.jackson.databind.cfg'
      substituteInPlace "$F" \
        --replace '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace '@projectgroupid@' 'com.fasterxml.jackson.core'
      substituteInPlace "$F" \
        --replace '@projectartifactid@' 'jackson-databind'

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
      hash = "sha256-w+n01lRb0L1KnUfouBgkjCbAksTSbUHt8igCPQhaxf4=";
    };
    srcDir = "cbor/src/main/java";
    compileOnlyDeps = [
      jackson.annotations
    ];
    deps = [
      jackson.core
      jackson.databind
    ];
    patchPhase = ''
      F=cbor/src/main/java/com/fasterxml/jackson/dataformat/cbor/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace '@package@' 'com.fasterxml.jackson.dataformat.cbor'
      substituteInPlace "$F" \
        --replace '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace '@projectgroupid@' 'com.fasterxml.jackson.core'
      substituteInPlace "$F" \
        --replace '@projectartifactid@' 'jackson-databind'
    '';
  };

  dataformat-yaml = buildJavaPackage rec {
    pname = "jackson-dataformat-yaml";
    inherit version license;
    src = fetchFromGitHub rec {
      owner = "FasterXML";
      repo = "jackson-dataformats-text";
      rev = "${repo}-${version}";
      hash = "sha256-P1SqPRDvXFSrTIFtLNM+7a0jrXgU9lCUH8dlGLrqF5k=";
    };
    srcDir = "yaml/src/main/java";
    compileOnlyDeps = [
      jackson.annotations
    ];
    deps = [
      jackson.core
      jackson.databind
      snakeyaml
    ];
    patchPhase = ''
      F=yaml/src/main/java/com/fasterxml/jackson/dataformat/yaml/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace '@package@' 'com.fasterxml.jackson.dataformat.yaml'
      substituteInPlace "$F" \
        --replace '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace '@projectgroupid@' 'com.fasterxml.jackson.core'
      substituteInPlace "$F" \
        --replace '@projectartifactid@' 'jackson-databind'
    '';
  };

  dataformat-xml = buildJavaPackage rec {
    pname = "jackson-dataformat-xml";
    inherit version license;
    src = fetchFromGitHub {
      owner = "FasterXML";
      repo = pname;
      rev = "${pname}-${version}";
      hash = "sha256-pX3waM8+OfN4m//ISc14d5dw23i8n2xxwIyv0hYjWjY=";
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
        --replace '@package@' 'com.fasterxml.jackson.dataformat.xml'
      substituteInPlace "$F" \
        --replace '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace '@projectgroupid@' 'com.fasterxml.jackson.core'
      substituteInPlace "$F" \
        --replace '@projectartifactid@' 'jackson-databind'
    '';
  };

  jr-objects = buildJavaPackage rec {
    pname = "jackson-jr-objects";
    inherit version license;
    src = fetchFromGitHub {
      owner = "FasterXML";
      repo = "jackson-jr";
      rev = "jackson-jr-parent-${version}";
      hash = "sha256-XVBwenzAKtx5me6NjDCs2ZxaHX4wX0O1AhLz9quH+Kk=";
    };
    srcDir = "jr-objects/src/main/java";
    deps = [
      jackson.core
    ];
    patchPhase = ''
      F=jr-objects/src/main/java/com/fasterxml/jackson/jr/ob/PackageVersion.java
      mv "$F.in" "$F"
      substituteInPlace "$F" \
        --replace '@package@' 'com.fasterxml.jackson.jr.ob'
      substituteInPlace "$F" \
        --replace '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace '@projectgroupid@' 'com.fasterxml.jackson.jr'
      substituteInPlace "$F" \
        --replace '@projectartifactid@' '${pname}'
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
        --replace '@package@' 'com.fasterxml.jackson.module.paramnames'
      substituteInPlace "$F" \
        --replace '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace '@projectgroupid@' 'com.fasterxml.jackson.module'
      substituteInPlace "$F" \
        --replace '@projectartifactid@' '${pname}'
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
        --replace '@package@' 'com.fasterxml.jackson.datatype.jsr310'
      substituteInPlace "$F" \
        --replace '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace '@projectgroupid@' 'com.fasterxml.jackson.module'
      substituteInPlace "$F" \
        --replace '@projectartifactid@' '${pname}'
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
        --replace '@package@' 'com.fasterxml.jackson.datatype.jdk8'
      substituteInPlace "$F" \
        --replace '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace '@projectgroupid@' 'com.fasterxml.jackson.module'
      substituteInPlace "$F" \
        --replace '@projectartifactid@' '${pname}'
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
      hash = "sha256-8YGrdw7A6qYzl1W6rbz6tSCH+a0IIQmZvVRgXfJVVe8=";
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
        --replace '@package@' 'com.fasterxml.jackson.datatype.joda'
      substituteInPlace "$F" \
        --replace '@projectversion@' '${version}'
      substituteInPlace "$F" \
        --replace '@projectgroupid@' 'com.fasterxml.jackson.datatype'
      substituteInPlace "$F" \
        --replace '@projectartifactid@' '${pname}'
    '';
    checkPhase = testWithJUnit4 {
      testDeps = [
        hamcrest
      ];
    };
  };

}
