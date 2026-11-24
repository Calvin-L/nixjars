{lib, buildJavaPackage, fetchFromGitHub,
 gson, jakarta-mail, jline, lsp4j, commons-math, prettier4j}:

buildJavaPackage {
  pname = "tlatools";
  license = lib.licenses.mit;
  version = "1.8.0.2026.11.14";
  src = fetchFromGitHub {
    owner = "tlaplus";
    repo = "tlaplus";
    rev = "bc1b506bdcad80bb518bf3776a9161c34ff0fc4c";
    sparseCheckout = ["tlatools/org.lamport.tlatools"];
    hash = "sha256-ykdFVycjHsoi1r7IOfxBZJFoakwc2OFogz/9RfBqxV8=";
  };
  srcDir = "tlatools/org.lamport.tlatools/src";
  resourceDir = "tlatools/org.lamport.tlatools/src";
  deps = [
    gson
    jakarta-mail
    jline.reader
    jline.terminal
    lsp4j.debug
    lsp4j.jsonrpc
    commons-math
    prettier4j
  ];
  patchPhase = ''
    mv -v tlatools/org.lamport.tlatools/src/org/apache/commons/math3/primes/TLCPrimes.java .
    mv -v tlatools/org.lamport.tlatools/src/org/apache/commons/math3/util/TLCFastMath.java .

    rm -rfv tlatools/org.lamport.tlatools/src/org/apache

    mkdir -p tlatools/org.lamport.tlatools/src/org/apache/commons/math3/{primes,util}
    mv -v TLCPrimes.java   tlatools/org.lamport.tlatools/src/org/apache/commons/math3/primes/
    mv -v TLCFastMath.java tlatools/org.lamport.tlatools/src/org/apache/commons/math3/util/
  '';
  configurePhase = ''
    substituteInPlace tlatools/org.lamport.tlatools/src/util/MailSender.java \
      --replace-fail 'javax.mail' 'jakarta.mail'
  '';
  exes = [
    { name = "tlc2"; class = "tlc2.TLC"; }
    { name = "tlc2repl"; class = "tlc2.REPL"; }
    { name = "tla2sany"; class = "tla2sany.SANY"; }
    { name = "tla2xml"; class = "tla2sany.xml.XMLExporter"; }
    { name = "pcal"; class = "pcal.trans"; }
    { name = "tla2tex"; class = "tla2tex.TLA"; }
  ];
}
