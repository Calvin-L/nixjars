{lib, buildJavaPackage, fetchFromGitHub,
 logback,
 jakarta-activation, jakarta-mail, jakarta-servlet-api,
 slf4j, janino, jansi}:

let

  version = "1.5.3";
  license = [lib.licenses.epl20 lib.licenses.lgpl21];
  src = fetchFromGitHub {
    owner = "qos-ch";
    repo = "logback";
    rev = "v_${version}";
    hash = "sha256-8aB4Fa4bckoVDb/bxUEcStyrdQVR+iXRxM+MawPCaIE=";
  };

in {

  core = buildJavaPackage {
    pname = "logback-core";
    inherit version license src;
    sourceRoot = "${src.name}/logback-core";
    deps = [
      jakarta-activation
      jakarta-mail
      jakarta-servlet-api
      janino.commons-compiler
      janino.janino
      jansi
    ];
  };

  classic = buildJavaPackage {
    pname = "logback-classic";
    inherit version license src;
    sourceRoot = "${src.name}/logback-classic";
    deps = [
      jakarta-activation
      jakarta-mail
      jakarta-servlet-api
      logback.core
      slf4j.api
    ];
  };

}
