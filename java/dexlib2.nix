{lib, buildJavaPackage, fetchFromGitHub,
 guava, jsr305}:

buildJavaPackage rec {
  pname = "dexlib2";
  version = "2.5.2";
  license = lib.licenses.bsd3; # https://github.com/JesusFreke/smali/blob/2771eae0a11f07bd892732232e6ee4e32437230d/NOTICE
  src = fetchFromGitHub {
    owner = "JesusFreke";
    repo = "smali";
    rev = "v${version}";
    sparseCheckout = [pname];
    hash = "sha256-u3VQHyfuCrOxbHAL/VfiFzmMwFA+Y/aRPu2d4XKjLKI=";
  };
  sourceRoot = "${src.name}/${pname}";
  deps = [
    guava
    jsr305
  ];
}
