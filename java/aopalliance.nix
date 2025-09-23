{lib, buildJavaPackage, fetchurl, unzip, cvs}:

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
  # src = fetchcvs {
  #   cvsRoot = ":pserver:anonymous@aopalliance.cvs.sourceforge.net:/cvsroot/aopalliance";
  #   module = "aopalliance";
  #   sha256 = "75Zr5f9chwVN39s6VCQgrc9HmToQJxRg4DrEZbWwbrc=";
  # };

  # With SourceForge CVS offline, this is a bit awkward.  They offer a zip of
  # the CVS repo, not the source, so we need to use CVS to get a working source
  # tree.
  src = fetchurl {
    url = "https://sourceforge.net/code-snapshots/cvs/a/ao/aopalliance.zip";
    hash = "sha256-+zEwT3M/bqpGBTtBiWVPawUHL7D30QFje4jCg8X/WgE=";
  };
  nativeBuildInputs = [
    unzip
    cvs
  ];
  sourceRoot = ".";
  postUnpack = ''
    mkdir checkout
    cd checkout
    cvs -d "$(pwd)/../aopalliance" co aopalliance
    cd aopalliance
  '';

  srcDir = "src/main";
}
