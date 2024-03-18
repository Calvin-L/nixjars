{lib, fetchFromGitHub, buildJavaPackage,
 osgi, zstd-jni, brotli-dec, tukaani-xz, ow2-asm}:

buildJavaPackage rec {
  pname = "commons-compress";
  version = "1.22";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = pname;
    rev = "rel/${version}";
    hash = "sha256-L7b8ajfdNRAjPMB13+X/B5ZTZ52szrlwRpfstDlAMwI=";
  };
  sourceEncoding = "iso-8859-1";
  compileOnlyDeps = [
    osgi.core
    zstd-jni
    brotli-dec
    tukaani-xz
    ow2-asm
  ];
}
