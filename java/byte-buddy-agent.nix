{lib, buildJavaPackage,
 byte-buddy, jsr305, findbugs-annotations, jna, jna-platform}:

buildJavaPackage rec {
  pname = "byte-buddy-agent";
  version = byte-buddy.version;
  license = byte-buddy.meta.license;
  src = byte-buddy.src;
  sourceRoot = "${src.name}/byte-buddy-agent";
  deps = [
    findbugs-annotations
    jna
    jna-platform
    jsr305
  ];
}
