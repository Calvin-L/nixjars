{lib, pkgs, callPackage, fetchurl, jdk, jre, packageOverrides}:

let

recurseIntoAttrs = lib.attrsets.recurseIntoAttrs;

callPackage = lib.callPackageWith (pkgs // self);

precompiledJar = callPackage ./support-functions/precompiledJar.nix {};

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
  builtins.concatStringsSep ":" (builtins.map (d: "${if d ? lib then d.lib else d.out}/${d.outputJar}") (builtins.filter (d: d ? outputJar) deps));

runtimeClasspath = deps:
  builtins.concatStringsSep ":" (builtins.map (d: "${if d ? lib then d.lib else d.out}/${d.outputJar}") (builtins.filter (d: d ? outputJar) (collect-recursive deps (d: if d ? outputJar then d.buildInputs ++ d.runtimeOnlyDeps else []) {})));

self = (rec {

  inherit
    callPackage
    precompiledJar
    jdk
    jre
    compileClasspath
    runtimeClasspath;

  testWithJUnit4 = callPackage ./support-functions/testWithJUnit4.nix {
    buildDirName = buildDirName;
  };

  testWithJUnit5 = callPackage ./support-functions/testWithJUnit5.nix {
    buildDirName = buildDirName;
  };

  testWithTestNG = callPackage ./support-functions/testWithTestNG.nix {
    buildDirName = buildDirName;
  };

  buildJavaPackage = callPackage ./support-functions/buildJavaPackage.nix {
    buildDirName = buildDirName;
  };

  ant = callPackage ./java/ant.nix {};
  antlr          = antlr4;
  antlr-runtime  = antlr4-runtime;
  antlr2         = antlr-stage2.antlr2;
  antlr3         = antlr-stage2.antlr3;
  antlr3-runtime = antlr-stage2.antlr3-runtime;
  antlr4         = antlr-stage2.antlr4;
  antlr4-runtime = antlr-stage2.antlr4-runtime;
  aopalliance = callPackage ./java/aopalliance.nix {};
  apache-felix = recurseIntoAttrs (callPackage ./java/apache-felix.nix {});
  apfloat = callPackage ./java/apfloat.nix {};
  apiguardian = callPackage ./java/apiguardian.nix {};
  argparse4j = callPackage ./java/argparse4j.nix {};
  assertj-core = callPackage ./java/assertj.nix {};
  bnd-annotation = callPackage ./java/bnd.nix {};
  brotli-dec = callPackage ./java/brotli-dec.nix {};
  byte-buddy = callPackage ./java/byte-buddy.nix {};
  byte-buddy-agent = callPackage ./java/byte-buddy-agent.nix {};
  cal10n-api = callPackage ./java/cal10n-api.nix {};
  checker-qual = callPackage ./java/checker-qual.nix {};
  classgraph = callPackage ./java/classgraph.nix {};
  cmdreader = callPackage ./java/cmdreader.nix {};
  commons-bcel = callPackage ./java/commons/bcel.nix {};
  commons-bsf = callPackage ./java/commons/bsf.nix {};
  commons-cli = callPackage ./java/commons/cli.nix {};
  commons-codec = callPackage ./java/commons/codec.nix {};
  commons-compress = callPackage ./java/commons/compress.nix {};
  commons-csv = callPackage ./java/commons/csv.nix {};
  commons-io = callPackage ./java/commons/io.nix {};
  commons-lang = callPackage ./java/commons/lang.nix {};
  commons-logging = callPackage ./java/commons/logging.nix {};
  commons-math = callPackage ./java/commons/math.nix {};
  commons-net = callPackage ./java/commons/net.nix {};
  commons-rng = recurseIntoAttrs (callPackage ./java/commons/rng.nix {});
  commons-rng-client-api = commons-rng.client-api;
  commons-rng-core = commons-rng.core;
  commons-rng-simple = commons-rng.simple;
  commons-text = callPackage ./java/commons/text.nix {};
  conversantmedia-disruptor = callPackage ./java/conversantmedia-disruptor.nix {};
  dex2jar = recurseIntoAttrs (callPackage ./java/dex2jar.nix {});
  dexlib2 = callPackage ./java/dexlib2.nix {};
  easymock = callPackage ./java/easymock.nix {};
  eclipse-emf = callPackage ./java/eclipse/emf.nix {};
  eclipse-equinox = recurseIntoAttrs (callPackage ./java/eclipse/equinox.nix {});
  eclipse-jdt = recurseIntoAttrs (callPackage ./java/eclipse/jdt.nix {});
  eclipse-mwe = recurseIntoAttrs (callPackage ./java/eclipse/mwe.nix {});
  eclipse-pde = recurseIntoAttrs (callPackage ./java/eclipse/pde.nix {});
  eclipse-platform = recurseIntoAttrs (callPackage ./java/eclipse/platform.nix {});
  eclipse-platform-ui = callPackage ./java/eclipse/platform-ui.nix {};
  ejc = eclipse-jdt.core-compiler-batch;
  error-prone-annotations = callPackage ./java/error-prone-annotations.nix {};
  failureaccess = callPackage ./java/failureaccess.nix {};
  fastdoubleparser = callPackage ./java/fastdoubleparser.nix {};
  fetchMaven = callPackage ./support-functions/fetchMaven.nix {};
  findbugs-annotations = spotbugs-annotations;
  gson = callPackage ./java/gson.nix {};
  guava = callPackage ./java/guava.nix {};
  guava-testlib = callPackage ./java/guava-testlib.nix {};
  guice = callPackage ./java/guice.nix {};
  hamcrest = callPackage ./java/hamcrest.nix {};
  heros = callPackage ./java/heros.nix {};
  icu4j-core = callPackage ./java/icu4j-core.nix {};
  isorelax = callPackage ./java/isorelax.nix {};
  j2objc-annotations = callPackage ./java/j2objc-annotations.nix {};
  jackson = recurseIntoAttrs (callPackage ./java/jackson.nix {});
  jakarta-activation = callPackage ./java/jakarta/activation.nix {};
  jakarta-inject-api = callPackage ./java/jakarta/inject-api.nix {};
  jakarta-mail = callPackage ./java/jakarta/mail.nix {};
  jakarta-oro = callPackage ./java/jakarta/oro.nix {};
  jakarta-regexp = callPackage ./java/jakarta/regexp.nix {};
  jakarta-servlet-api = callPackage ./java/jakarta/servlet-api.nix {};
  janino = recurseIntoAttrs (callPackage ./java/janino.nix {});
  jansi = callPackage ./java/jansi.nix {};
  javapoet = callPackage ./java/javapoet.nix {};
  javassist = callPackage ./java/javassist.nix {};
  jcommander = callPackage ./java/jcommander.nix {};
  jctools-core = callPackage ./java/jctools-core.nix {};
  jeromq = callPackage ./java/jeromq.nix {};
  jgrapht = recurseIntoAttrs (callPackage ./java/jgrapht.nix {});
  jheaps = callPackage ./java/jheaps.nix {};
  jline = recurseIntoAttrs (callPackage ./java/jline.nix {});
  jmh = callPackage ./java/openjdk-jmh.nix {};
  jmh-core = jmh.core;
  jms-api = callPackage ./java/jms-api.nix {};
  jna = callPackage ./java/jna.nix {};
  jna-platform = callPackage ./java/jna-platform.nix {};
  jnacl = callPackage ./java/jnacl.nix {};
  joda-convert = callPackage ./java/joda-convert.nix {};
  joda-time = callPackage ./java/joda-time.nix {};
  jopt-simple = callPackage ./java/jopt-simple.nix {};
  jose4j = callPackage ./java/jose4j.nix {};
  jspecify = callPackage ./java/jspecify.nix {};
  jsr305 = callPackage ./java/jsr305.nix {};
  jungrapht = recurseIntoAttrs (callPackage ./java/jungrapht.nix {});
  junit = recurseIntoAttrs (callPackage ./java/junit.nix {});
  junit4 = callPackage ./java/junit4.nix { testWithJUnit4 = testWithJUnit4.override { junit4 = junit4-untested; takari-cpsuite = takari-cpsuite-untested; }; };
  junit4-untested = callPackage ./java/junit4.nix { testWithJUnit4 = null; };
  kafka = recurseIntoAttrs (callPackage ./java/kafka.nix {});
  lmax-disruptor = callPackage ./java/lmax-disruptor.nix {};
  log4j = recurseIntoAttrs (callPackage ./java/log4j.nix {});
  log4j-1_2-api = log4j.log4j-1_2-api;
  log4j-api = log4j.log4j-api;
  log4j-core = log4j.log4j-core;
  log4j-slf4j = log4j.log4j-slf4j;
  logback = recurseIntoAttrs (callPackage ./java/logback.nix {});
  lombok = callPackage ./java/lombok.nix {};
  lombok-patcher = callPackage ./java/lombok-patcher.nix {};
  lsp4j = callPackage ./java/lsp4j.nix {};
  lz4 = callPackage ./java/lz4.nix {};
  mockito = callPackage ./java/mockito.nix {};
  msv = recurseIntoAttrs (callPackage ./java/msv.nix {});
  no-class-dups = callPackage ./java/no-class-dups {};
  objenesis = callPackage ./java/objenesis.nix {};
  open-test-reporting = callPackage ./java/open-test-reporting.nix {};
  opentest4j = callPackage ./java/opentest4j.nix {};
  osgi = recurseIntoAttrs (callPackage ./java/osgi.nix {});
  ow2 = recurseIntoAttrs (callPackage ./java/ow2.nix {});
  ow2-asm = ow2.asm;
  ow2-asm-commons = ow2.asm-commons;
  ow2-asm-tree = ow2.asm-tree;
  picocli = callPackage ./java/picocli.nix {};
  plume-lib = recurseIntoAttrs (callPackage ./java/plume-lib.nix {});
  prettier4j = callPackage ./java/prettier4j.nix {};
  reactive-streams = callPackage ./java/reactive-streams.nix {};
  relaxng-datatype = callPackage ./java/relaxng-datatype.nix {};
  slf4j = recurseIntoAttrs (callPackage ./java/slf4j.nix {});
  snakeyaml = callPackage ./java/snakeyaml.nix {};
  snappy = callPackage ./java/snappy.nix {};
  sootup = recurseIntoAttrs (callPackage ./java/sootup.nix {});
  spotbugs-annotations = callPackage ./java/spotbugs-annotations.nix {};
  stax2-api = callPackage ./java/stax2-api.nix {};
  takari-cpsuite = callPackage ./java/takari-cpsuite.nix {};
  takari-cpsuite-untested = callPackage ./java/takari-cpsuite.nix { junit4 = junit4-untested; };
  testng = recurseIntoAttrs (callPackage ./java/testng.nix {});
  threetenbp = callPackage ./java/threetenbp.nix {};
  tla-community-modules = callPackage ./java/tla-community-modules.nix {};
  tlatools = callPackage ./java/tlatools.nix {};
  treelayout = callPackage ./java/treelayout.nix {};
  tukaani-xz = callPackage ./java/tukaani-xz.nix {};
  univocity-parsers = callPackage ./java/univocity-parsers.nix {};
  vavr = callPackage ./java/vavr.nix {};
  vavr-match = callPackage ./java/vavr-match.nix {};
  wala = recurseIntoAttrs (callPackage ./java/wala.nix {});
  woodstox-core = callPackage ./java/woodstox-core.nix {};
  xml-resolver = callPackage ./java/xml-resolver.nix {};
  xtendc = xtext.xtend-core;
  xtext = recurseIntoAttrs (callPackage ./java/eclipse/xtext.nix {});
  zstd-jni = callPackage ./java/zstd-jni.nix {};
} // (packageOverrides self));

in self
