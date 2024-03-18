{lib, buildJavaPackage, fetchFromGitHub, jsr305}:

buildJavaPackage rec {
  pname = "spotbugs-annotations";
  version = "4.8.3";
  license = lib.licenses.lgpl21;
  src = fetchFromGitHub {
    owner = "spotbugs";
    repo = "spotbugs";
    rev = version;
    hash = "sha256-L61Fs+pbVdxP4pkgKfHILmhQf/jd35Mb66U9o2qvXno=";
  };
  sourceRoot = "${src.name}/${pname}";
  deps = [
    jsr305
  ];
}
