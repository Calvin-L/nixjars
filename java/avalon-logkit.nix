{lib, buildJavaPackage, fetchsvn,
 jms-api, jakarta-mail, log4j-1_2-api, servlet-api}:

buildJavaPackage rec {
  pname = "avalon-logkit";
  version = "2.1";
  license = lib.licenses.asl20;
  src = fetchsvn {
    url = "https://svn.apache.org/repos/asf/excalibur/tags/avalon-logkit-${version}-Release";
    hash = "sha256-BwNoCpb0JmMYEomqv6Bf+l2/VayRmaz6xXGygRXmlGg=";
  };
  srcDir = "containerkit/logkit/src/java";
  deps = [
    jms-api
    jakarta-mail
    log4j-1_2-api
    servlet-api
  ];
}
