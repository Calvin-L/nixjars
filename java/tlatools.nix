{lib, buildJavaPackage, fetchFromGitHub,
 gson, jakarta-mail, jline, lsp4j, commons-math, prettier4j}:

buildJavaPackage {
  pname = "tlatools";
  license = lib.licenses.mit;
  version = "1.8.0.2026.8.31";
  src = fetchFromGitHub {
    owner = "tlaplus";
    repo = "tlaplus";
    rev = "95b800c676b3312ce97d7478d1081cd468ece75c";
    sparseCheckout = ["tlatools/org.lamport.tlatools"];
    hash = "sha256-xNoa1/kBB89Uh2Ptc+NzeG6Rl63rGmmYstQgyP2fSG8=";
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
    rm -rfv tlatools/org.lamport.tlatools/src/org/apache
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
