{lib, fetchFromGitHub, buildJavaPackage}:

buildJavaPackage rec {
  pname = "threetenbp";
  version = "1.7.0";
  license = lib.licenses.bsd3;
  src = fetchFromGitHub {
    owner = "ThreeTen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WMjLRtppxnKm7L1sdRX6PnYFMry8Ibvck864bu3Iw0Y=";
  };
  manifestProperties = {
    "Automatic-Module-Name" = "org.threeten.bp";
  };
}
