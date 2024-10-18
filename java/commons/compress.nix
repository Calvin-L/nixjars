{lib, fetchFromGitHub, buildJavaPackage,
 osgi, zstd-jni, brotli-dec, tukaani-xz, ow2-asm,
 commons-io, commons-lang, commons-codec}:

buildJavaPackage rec {
  pname = "commons-compress";
  version = "1.27.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "apache";
    repo = pname;
    rev = "rel/${pname}-${version}";
    hash = "sha256-BiFnXh/oyBiarxot7WNKV9UZN3H9ytZCYF6Zzo7ZUQw=";
  };
  sourceEncoding = "iso-8859-1";
  deps = [
    commons-io
    commons-lang
    commons-codec
  ];
  compileOnlyDeps = [
    osgi.core
    zstd-jni
    brotli-dec
    tukaani-xz
    ow2-asm
  ];
}
