{lib, buildJavaPackage, fetchcvs}:

buildJavaPackage {
  pname = "isorelax";
  version = "1.1.1";
  license = lib.licenses.asl20;
  # src = fetchFromGitHub { # unofficial, but official CVS is down as of 2023/10/31 :(
  #   owner = "deepin-community";
  #   repo = pname;
  #   rev = "75e2882eaf4133bb7efc762ff9f37548cb19b836";
  #   hash = "sha256-5O5uiywjYNkwx5HDng/DWAMMnzUFKMKvtfLwFC2jo00=";
  # };
  src = fetchcvs {
    cvsRoot = ":pserver:anonymous@iso-relax.cvs.sourceforge.net:/cvsroot/iso-relax";
    module = "src";
    sha256 = "sha256-Sdmao7juS+Yb4k+xN1qDXjuGz3VIXBRLuMg6VkxJeEQ=";
  };
  srcDir = ".";

  # # break a cyclic dependency...
  # # anyways, who even uses the ant rules from this ancient project???
  # #
  # # also fix compilation for JAXB 1.3... official src has this, but not my
  # # unofficial fork...
  # patchPhase = ''
  #   rm -r org/iso_relax/ant/

  #   substituteInPlace org/iso_relax/jaxp/ValidatingDocumentBuilderFactory.java \
  #     --replace 'public boolean isValidating()' '
  # public void setFeature(String name, boolean value) throws ParserConfigurationException {
  #     throw new ParserConfigurationException();
  # }

  # public boolean getFeature(String name) throws ParserConfigurationException {
  #     throw new ParserConfigurationException();
  # }

  # public boolean isValidating()'
  # '';
  patchPhase = ''
    rm -r org/iso_relax/ant/
  '';
}
