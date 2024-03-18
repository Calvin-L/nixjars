{lib, buildJavaPackage, fetchcvs}:

buildJavaPackage rec {
  pname = "aopalliance";
  version = "1.0";
  license = lib.licenses.publicDomain;
  # src = fetchFromGitHub { # unofficial, but official CVS is down as of 2023/10/31 :(
  #   owner = "hoverruan";
  #   repo = pname;
  #   rev = "0d7757ae204e5876f69431421fe9bc2a4f01e8a0";
  #   sparseCheckout = ["aopalliance"];
  #   hash = "sha256-l8cAsn61o46HJWDUWrCZKhy0HrSWpw9pyOrk7sPIfxc=";
  # };
  src = fetchcvs {
    cvsRoot = ":pserver:anonymous@aopalliance.cvs.sourceforge.net:/cvsroot/aopalliance";
    module = "aopalliance";
    sha256 = "75Zr5f9chwVN39s6VCQgrc9HmToQJxRg4DrEZbWwbrc=";
  };
  srcDir = "src/main";
}
