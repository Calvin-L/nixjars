{lib, buildJavaPackage, fetchFromGitHub,
 commons-logging,
 commons-bcel,
 commons-net,
 commons-bsf,
 log4j-1_2-api,
 tukaani-xz,
 xml-resolver,
 jakarta-oro,
 jakarta-regexp,
 jakarta-mail,
 jakarta-activation,
 junit4,
 junit}:

buildJavaPackage rec {
  pname = "ant";
  version = "1.10.14";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "ant";
    rev = "rel/${version}";
    hash = "sha256-nt81VDsC+jFEgxQZ8acsDW17TozZiAIXL2u+4g+EpMw=";
  };
  srcDir = "src/main";
  deps = [
    commons-logging
    commons-bcel
    commons-net
    commons-bsf
    log4j-1_2-api
    tukaani-xz
    xml-resolver
    jakarta-oro
    jakarta-regexp
    jakarta-mail
    jakarta-activation
    junit4
    junit.platform-engine
    junit.platform-launcher
    junit.platform-commons
  ];

  # !??
  configurePhase = ''
    rm -r src/main/org/apache/tools/ant/types/optional/image
    rm -r src/main/org/apache/tools/ant/taskdefs/optional/image
    rm -r src/main/org/apache/tools/ant/taskdefs/optional/NetRexxC.java
    rm -r src/main/org/apache/tools/ant/taskdefs/optional/ssh
    rm -r src/main/org/apache/tools/ant/taskdefs/optional/Xalan2TraceSupport.java
    rm -r src/main/org/apache/tools/ant/taskdefs/optional/jdepend
    substituteInPlace src/main/org/apache/tools/ant/taskdefs/email/MimeMailer.java \
      --replace 'javax.mail' 'jakarta.mail'
    substituteInPlace src/main/org/apache/tools/ant/taskdefs/email/MimeMailer.java \
      --replace 'javax.activation' 'jakarta.activation'
  '';
  exes = [
    { name = "ant"; class = "org.apache.tools.ant.launch.Launcher"; }
  ];
}
