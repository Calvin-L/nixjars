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

let dollar = "$"; in

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
  resourceDir = "src/resources";
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

  # - disable a few obscure tasks with massive dependency trees
  # - copy resources to resources folder (and fill out version info); for some
  #   reason Ant wants resources from BOTH src/main/ and src/resources/
  patchPhase = ''
    rm -r src/main/org/apache/tools/ant/types/optional/image
    rm -r src/main/org/apache/tools/ant/taskdefs/optional/image
    rm -r src/main/org/apache/tools/ant/taskdefs/optional/NetRexxC.java
    rm -r src/main/org/apache/tools/ant/taskdefs/optional/ssh
    rm -r src/main/org/apache/tools/ant/taskdefs/optional/Xalan2TraceSupport.java
    rm -r src/main/org/apache/tools/ant/taskdefs/optional/jdepend
    substituteInPlace src/main/org/apache/tools/ant/taskdefs/email/MimeMailer.java \
      --replace-fail 'javax.mail' 'jakarta.mail'
    substituteInPlace src/main/org/apache/tools/ant/taskdefs/email/MimeMailer.java \
      --replace-fail 'javax.activation' 'jakarta.activation'

    rsync -av --exclude '*.java' src/main/ src/resources/
    substituteInPlace src/resources/org/apache/tools/ant/version.txt \
      --replace-fail '${dollar}{project.version}' '${version}' \
      --replace-fail '${dollar}{TODAY}' "$(date)"
  '';
  exes = [
    { name = "ant"; class = "org.apache.tools.ant.launch.Launcher"; }
  ];
}
