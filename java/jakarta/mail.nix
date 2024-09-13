{lib, buildJavaPackage, fetchFromGitHub,
 jakarta-activation}:

buildJavaPackage rec {
  pname = "jakarta-mail";
  version = "2.1.2";
  license = [
    lib.licenses.epl20
    lib.licenses.gpl2Classpath
  ];
  src = fetchFromGitHub {
    owner = "jakartaee";
    repo = "mail-api";
    rev = "${version}";
    hash = "sha256-J/ryrt7aAEriKB0ls58FJfwkHNn3UIx6TeWh1WzHAg8=";
  };
  srcDir = "api/src/main/java";
  # note `mv` below; don't need to include this file in resources
  configurePhase = ''
    mv ${srcDir}/../resources/jakarta/mail/Version.java ${srcDir}/jakarta/mail/Version.java
    substituteInPlace ${srcDir}/jakarta/mail/Version.java --replace-fail \
      '$'''{mail.version}' \
      '${version}'
  '';
  deps = [jakarta-activation];
}
