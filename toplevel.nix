{lib, pkgs, callPackage, fetchurl, jdk, jre, packageOverrides}:

let

recurseIntoAttrs = lib.attrsets.recurseIntoAttrs;

callPackage = lib.callPackageWith (pkgs // self);

precompiledJar = callPackage ./support-functions/precompiledJar.nix {
  runtimeClasspath = runtimeClasspath;
};

antlr3-bootstrap = precompiledJar rec {
  pname = "antlr-bootstrap";
  version = "3.5.3";
  license = lib.licenses.bsd3;
  src = fetchurl {
    url = "https://www.antlr3.org/download/antlr-${version}-complete-no-st3.jar";
    hash = "sha256-7FBbTFgXMCwwRASuTSYCF3kRgaNE80Gavas7D8V8DIM=";
  };
  exes = [
    { name="antlr"; class = "org.antlr.Tool"; }
  ];
};

antlr-stage1 = callPackage ./java/antlr.nix { antlr3-bootstrap = antlr3-bootstrap; };
antlr-stage2 = callPackage ./java/antlr.nix { antlr3-bootstrap = antlr-stage1.antlr3; };

buildDirName = "nix_build_dir";

collect-recursive = d: succ: seen:
  if d == []
  then []
  else
    let hd = builtins.head d; in
    let hd_as_str = builtins.hashString "sha256" (builtins.toString hd); in
    let tl = builtins.tail d; in
    if builtins.hasAttr hd_as_str seen
    then collect-recursive tl succ seen
    else [hd] ++ (collect-recursive (tl ++ succ hd) succ (seen // {"${hd_as_str}"=true;}));

compileClasspath = deps:
  builtins.concatStringsSep ":" (builtins.map (d: "${d}/${d.outputJar}") (builtins.filter (d: d ? outputJar) deps));

runtimeClasspath = deps:
  builtins.concatStringsSep ":" (builtins.map (d: "${d}/${d.outputJar}") (builtins.filter (d: d ? outputJar) (collect-recursive deps (d: if d ? outputJar then d.buildInputs ++ d.runtimeOnlyDeps else []) {})));

self = (rec {

  inherit
    callPackage
    precompiledJar
    jdk
    jre;

  testWithJUnit4 = callPackage ./support-functions/testWithJUnit4.nix {
    buildDirName = buildDirName;
    compileClasspath = compileClasspath;
    runtimeClasspath = runtimeClasspath;
  };

  testWithJUnit5 = callPackage ./support-functions/testWithJUnit5.nix {
    buildDirName = buildDirName;
    compileClasspath = compileClasspath;
    runtimeClasspath = runtimeClasspath;
  };

  testWithTestNG = callPackage ./support-functions/testWithTestNG.nix {
    buildDirName = buildDirName;
    compileClasspath = compileClasspath;
    runtimeClasspath = runtimeClasspath;
  };

  buildJavaPackage = callPackage ./support-functions/buildJavaPackage.nix {
    buildDirName = buildDirName;
    compileClasspath = compileClasspath;
    runtimeClasspath = runtimeClasspath;
  };

  fetchMaven = callPackage ./support-functions/fetchMaven.nix {};

  # avalon-logkit = callPackage ./java/avalon-logkit.nix {};

  brotli-dec = callPackage ./java/brotli-dec.nix {};

  tukaani-xz = callPackage ./java/tukaani-xz.nix {};

  ow2 = recurseIntoAttrs (callPackage ./java/ow2.nix {});
  ow2-asm = ow2.asm;
  ow2-asm-commons = ow2.asm-commons;
  ow2-asm-tree = ow2.asm-tree;

  zstd-jni = callPackage ./java/zstd-jni.nix {};

  lmax-disruptor = callPackage ./java/lmax-disruptor.nix {};

  conversantmedia-disruptor = callPackage ./java/conversantmedia-disruptor.nix {};

  janino = recurseIntoAttrs (callPackage ./java/janino.nix {});

  jansi = callPackage ./java/jansi.nix {};

  jms-api = callPackage ./java/jms-api.nix {};

  jctools-core = callPackage ./java/jctools-core.nix {};

  argparse4j = callPackage ./java/argparse4j.nix {};

  jose4j = callPackage ./java/jose4j.nix {};

  lz4 = callPackage ./java/lz4.nix {};

  snappy = callPackage ./java/snappy.nix {};

  kafka = recurseIntoAttrs (callPackage ./java/kafka.nix {});

  jnacl = callPackage ./java/jnacl.nix {};

  jeromq = callPackage ./java/jeromq.nix {};

  log4j = recurseIntoAttrs (callPackage ./java/log4j.nix {});
  log4j-api = log4j.log4j-api;
  log4j-core = log4j.log4j-core;
  log4j-1_2-api = log4j.log4j-1_2-api;
  log4j-slf4j = log4j.log4j-slf4j;

  slf4j = recurseIntoAttrs (callPackage ./java/slf4j.nix {});

  cal10n-api = callPackage ./java/cal10n-api.nix {};

  javassist = callPackage ./java/javassist.nix {};

  apache-felix = recurseIntoAttrs (callPackage ./java/apache-felix.nix {});

  jakarta-activation = callPackage ./java/jakarta/activation.nix {};

  jakarta-mail = callPackage ./java/jakarta/mail.nix {};

  jakarta-inject-api = callPackage ./java/jakarta/inject-api.nix {};

  jakarta-servlet-api = callPackage ./java/jakarta/servlet-api.nix {};

  jline = recurseIntoAttrs (callPackage ./java/jline.nix {});

  easymock = callPackage ./java/easymock.nix {};

  objenesis = callPackage ./java/objenesis.nix {};

  byte-buddy = callPackage ./java/byte-buddy.nix {};

  byte-buddy-agent = callPackage ./java/byte-buddy-agent.nix {};

  jna = callPackage ./java/jna.nix {};

  jna-platform = callPackage ./java/jna-platform.nix {};

  findbugs-annotations = spotbugs-annotations;

  spotbugs-annotations = callPackage ./java/spotbugs-annotations.nix {};

  commons-cli = callPackage ./java/commons/cli.nix {};
  commons-math = callPackage ./java/commons/math.nix {};
  commons-logging = callPackage ./java/commons/logging.nix {};
  commons-lang = callPackage ./java/commons/lang.nix {};
  commons-text = callPackage ./java/commons/text.nix {};
  commons-compress = callPackage ./java/commons/compress.nix {};
  commons-csv = callPackage ./java/commons/csv.nix {};
  commons-bcel = callPackage ./java/commons/bcel.nix {};
  commons-net = callPackage ./java/commons/net.nix {};
  commons-bsf = callPackage ./java/commons/bsf.nix {};
  commons-io = callPackage ./java/commons/io.nix {};
  commons-rng = recurseIntoAttrs (callPackage ./java/commons/rng.nix {});
  commons-rng-client-api = commons-rng.client-api;
  commons-rng-core = commons-rng.core;
  commons-rng-simple = commons-rng.simple;

  osgi = recurseIntoAttrs (callPackage ./java/osgi.nix {});

  eclipse-equinox = recurseIntoAttrs (callPackage ./java/eclipse/equinox.nix {});
  eclipse-platform = recurseIntoAttrs (callPackage ./java/eclipse/platform.nix {});
  eclipse-mwe = recurseIntoAttrs (callPackage ./java/eclipse/mwe.nix {});
  xtext = recurseIntoAttrs (callPackage ./java/eclipse/xtext.nix {});
  xtendc = xtext.xtend-core;

  jakarta-oro = callPackage ./java/jakarta/oro.nix {};

  jakarta-regexp = callPackage ./java/jakarta/regexp.nix {};

  ant = callPackage ./java/ant.nix {};

  eclipse-jdt = recurseIntoAttrs (callPackage ./java/eclipse/jdt.nix {});
  ejc = eclipse-jdt.core-compiler-batch;

  eclipse-emf = callPackage ./java/eclipse/emf.nix {};

  eclipse-platform-ui = callPackage ./java/eclipse/platform-ui.nix {};

  treelayout = callPackage ./java/treelayout.nix {};

  antlr2         = antlr-stage2.antlr2;
  antlr3-runtime = antlr-stage2.antlr3-runtime;
  antlr3         = antlr-stage2.antlr3;
  antlr4-runtime = antlr-stage2.antlr4-runtime;
  antlr4         = antlr-stage2.antlr4;
  antlr-runtime  = antlr4-runtime;
  antlr          = antlr4;

  jopt-simple = callPackage ./java/jopt-simple.nix {};

  joda-convert = callPackage ./java/joda-convert.nix {};
  joda-time = callPackage ./java/joda-time.nix {};

  jmh = callPackage ./java/openjdk-jmh.nix {};
  jmh-core = jmh.core;

  icu4j-core = callPackage ./java/icu4j-core.nix {};

  classgraph = callPackage ./java/classgraph.nix {};

  lsp4j = callPackage ./java/lsp4j.nix { runtimeClasspath=runtimeClasspath; };

  tlatools = callPackage ./java/tlatools.nix {};

  gson = callPackage ./java/gson.nix {};

  j2objc-annotations = callPackage ./java/j2objc-annotations.nix {};

  checker-qual = callPackage ./java/checker-qual.nix {};

  error-prone-annotations = callPackage ./java/error-prone-annotations.nix {};

  guava = callPackage ./java/guava.nix {};
  guava-testlib = callPackage ./java/guava-testlib.nix {};
  failureaccess = callPackage ./java/failureaccess.nix {};
  guice = callPackage ./java/guice.nix {};

  aopalliance = callPackage ./java/aopalliance.nix {};

  jsr305 = callPackage ./java/jsr305.nix {};

  fastdoubleparser = callPackage ./java/fastdoubleparser.nix {};

  jackson = recurseIntoAttrs (callPackage ./java/jackson.nix {});

  relaxng-datatype = callPackage ./java/relaxng-datatype.nix {};

  isorelax = callPackage ./java/isorelax.nix {};

  xml-resolver = callPackage ./java/xml-resolver.nix {};

  msv = recurseIntoAttrs (callPackage ./java/msv.nix {});

  bnd-annotation = callPackage ./java/bnd.nix {};

  woodstox-core = callPackage ./java/woodstox-core.nix {};

  stax2-api = callPackage ./java/stax2-api.nix {};

  snakeyaml = callPackage ./java/snakeyaml.nix {};

  reactive-streams = callPackage ./java/reactive-streams.nix {};

  hamcrest = callPackage ./java/hamcrest.nix {};

  junit4-untested = callPackage ./java/junit4.nix { testWithJUnit4 = null; };
  junit4 = callPackage ./java/junit4.nix {
    testWithJUnit4 = testWithJUnit4.override { junit4 = junit4-untested; takari-cpsuite = takari-cpsuite-untested; };
  };

  takari-cpsuite-untested = callPackage ./java/takari-cpsuite.nix { junit4 = junit4-untested; };
  takari-cpsuite = callPackage ./java/takari-cpsuite.nix {};

  testng = recurseIntoAttrs (callPackage ./java/testng.nix {});

  jcommander = callPackage ./java/jcommander.nix {};

  apiguardian = callPackage ./java/apiguardian.nix {};

  opentest4j = callPackage ./java/opentest4j.nix {};

  junit = recurseIntoAttrs (callPackage ./java/junit.nix {});

  assertj-core = callPackage ./java/assertj.nix {};

  mockito = callPackage ./java/mockito.nix {};

  univocity-parsers = callPackage ./java/univocity-parsers.nix {};

  open-test-reporting = callPackage ./java/open-test-reporting.nix {};

  picocli = callPackage ./java/picocli.nix {};

  javapoet = callPackage ./java/javapoet.nix {};

  cmdreader = callPackage ./java/cmdreader.nix {};

  lombok-patcher = callPackage ./java/lombok-patcher.nix {};

  lombok = callPackage ./java/lombok.nix {};

} // (packageOverrides self));

in self
