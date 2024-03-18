{lib, fetchFromGitHub, buildJavaPackage, log4j-1_2-api, commons-logging}:

# commons-bsf-version = "3.1";
# commons-bsf-license = lib.licenses.asl20;
# commons-bsf-src = fetchFromGitHub {
#   owner = "apache";
#   repo = "commons-bsf";
#   rev = "bsf-${commons-bsf-version}";
#   hash = "sha256-8HideV19OzBCSjAshHPCCTN4pcNUWNTj4D5RVG4f/JE=";
# };

# commons-bsf-api = buildJavaPackage {
#   name = "commons-bsf";
#   version = commons-bsf-version;
#   license = commons-bsf-license;
#   src = commons-bsf-src;
#   srcDir = "bsf-api/src/main/java";
# };

buildJavaPackage rec {
  pname = "commons-bsf";
  version = "2.4.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-bsf";
    rev = "bsf-${version}";
    hash = "sha256-T8Qe1jZqN1C3fcjs7yAWfNBxlKBtBVBNayroMseEWYc=";
  };
  srcDir = "src";
  deps = [
    log4j-1_2-api
    commons-logging
  ];

  # remove optional components
  configurePhase = ''
    rm -r src/org/apache/bsf/engines/jacl
    rm -r src/org/apache/bsf/engines/javascript
    rm -r src/org/apache/bsf/engines/jython
    rm -r src/org/apache/bsf/engines/netrexx
    rm -r src/org/apache/bsf/engines/xslt
  '';
}
