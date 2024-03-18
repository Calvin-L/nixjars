{lib, fetchFromGitHub, buildJavaPackage,
 jopt-simple, commons-math}:

let

version = "1.37";
license = lib.licenses.gpl2;
src = fetchFromGitHub {
  owner = "openjdk";
  repo = "jmh";
  rev = version;
  hash = "sha256-moPadiw5b7DQI8EH7s3D0kvKjbV/RaTNOA8HiL99Dho=";
};

in

rec {

  core = buildJavaPackage rec {
    pname = "jmh-core";
    inherit version license src;
    sourceRoot = "${src.name}/${pname}";
    deps = [
      commons-math
      jopt-simple
    ];
  };

}
