{lib, fetchFromGitHub, buildJavaPackage, commons-lang}:

buildJavaPackage rec {
  pname = "commons-bcel";
  version = "6.10.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "commons-bcel";
    rev = "rel/${pname}-${version}";
    hash = "sha256-2dCbSK6SkBoGAHnbxrqZIHV+ogjelnob7jXrutPMRM0=";
  };
  srcDir = "src/main";
  deps = [
    commons-lang
  ];
}
