{lib, buildJavaPackage, fetchFromGitHub, osgi}:

let
  version = "7.0.5";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "felix-dev";
    rev = "org.apache.felix.framework-${version}";
    hash = "sha256-UxxpWUzWIzCXAZLQrpPCcvedtjkW6uEskKJVUoFvk/A=";
  };
in {

  # framework = buildJavaPackage {
  #   pname = "apache-felix-framework";
  #   inherit version license src;
  #   srcDir = "framework/src/main/java";
  #   deps = [
  #     osgi.annotation-versioning
  #     osgi.service-resolver
  #     apache-felix-resolver
  #   ];
  # };

  resolver = buildJavaPackage {
    pname = "apache-felix-resolver";
    inherit version license src;
    srcDir = "resolver/src/main/java";
    deps = [
      osgi.annotation-versioning
      osgi.resource
      osgi.framework
    ];
  };

}
