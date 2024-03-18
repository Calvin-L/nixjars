{lib, buildJavaPackage, fetchsvn}:

buildJavaPackage {
  pname = "xml-resolver";
  version = "1.2";
  license = lib.licenses.asl20; # https://xerces.apache.org/xml-commons/licenses.html
  src = fetchsvn {
    url = "http://svn.apache.org/repos/asf/xerces/xml-commons/tags/xml-commons-resolver-1_2";
    hash = "sha256-0nl68zWzl7DSMCG+85fv13DBckH+azF/iSUG/Wo2Ovo=";
  };
  srcDir = "java/src";
  configurePhase = ''
    rm -r java/src/org/apache/xml/resolver/tests
  '';
}
