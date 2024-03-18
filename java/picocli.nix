{lib, buildJavaPackage, fetchFromGitHub}:

let version = "4.7.5"; in
buildJavaPackage {
  pname = "picocli";
  version = version;
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "remkop";
    repo = "picocli";
    rev = "v${version}";
    hash = "sha256-9skScFsuu3Wj9QTlRnWDZe1ZOqfJtk2pYmq/rtRNWWM=";
  };
}
