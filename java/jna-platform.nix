{lib, buildJavaPackage, jna}:

buildJavaPackage rec {
  pname = "jna-platform";
  version = jna.version;
  license = jna.meta.license;
  src = jna.src;
  sourceRoot = "${src.name}/contrib/platform";
  srcDir = "src";
  deps = [
    jna
  ];
}
