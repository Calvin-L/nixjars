{lib, buildJavaPackage, fetchFromGitHub,
 gson, jakarta-mail, jline, lsp4j, commons-math}:

buildJavaPackage {
  pname = "tlatools";
  license = lib.licenses.mit;
  # version = "1.7.1";
  # src = fetchFromGitHub {
  #   owner = "tlaplus";
  #   repo = "tlaplus";
  #   rev = "v${version}";
  #   sha256 = "0gb002n14i028mgcgj33n49mrv1ys890sblx96052sk4brfbrdwj";
  # };
  # version = "1.7.3";
  # src = fetchFromGitHub {
  #   owner = "tlaplus";
  #   repo = "tlaplus";
  #   rev = "3ea322254974cd39a4dd336fff12b203a6743dd1";
  #   hash = "sha256-69oGSRS7pSOyoWcK2dmGheIBX8WZXdjUvRpOKqDiQTQ=";
  # };
  version = "1.8.0.2024.10.17";
  src = fetchFromGitHub {
    owner = "tlaplus";
    repo = "tlaplus";
    rev = "b5512af1c114048e8e633ead1797f4c2419eeea5";
    sparseCheckout = ["tlatools/org.lamport.tlatools"];
    hash = "sha256-haf/tw1DcLzrs46KhD1pPid4CwJ/ckICcs9ELANVFTM=";
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
