{lib, buildJavaPackage, fetchFromGitHub,
 jakarta-activation, testWithJUnit4, hamcrest}:

buildJavaPackage rec {
  pname = "jakarta-mail";
  version = "2.1.3";
  license = [
    lib.licenses.epl20
    lib.licenses.gpl2Classpath
  ];
  src = fetchFromGitHub {
    owner = "jakartaee";
    repo = "mail-api";
    rev = "${version}";
    hash = "sha256-AqrnuJldeVRc3OUNt9ni3emJA3wQlckpAihgWmaam2k=";
  };
  sourceRoot = "${src.name}/api";
  # note `mv` below; don't need to include this file in resources
  configurePhase = ''
    test -e src/main/java/jakarta/mail/internet/HeaderTokenizer.java
    mv src/main/resources/jakarta/mail/Version.java src/main/java/jakarta/mail/Version.java
    substituteInPlace src/main/java/jakarta/mail/Version.java --replace-fail \
      '$'''{mail.version}' \
      '${version}'
  '';
  deps = [jakarta-activation];

  # Need a solution for testing packages with module-info.java
  # checkPhase = testWithJUnit4 { testDeps = [hamcrest]; };
}
