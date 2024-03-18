{lib, buildJavaPackage, fetchFromGitHub, jna, ow2-asm}:

buildJavaPackage rec {
  pname = "lombok-patcher";
  version = "0.50";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "projectlombok";
    repo = "lombok.patcher";
    rev = "v${version}";
    hash = "sha256-CBSG+w8DIW3GcS/TmVXOmk4dNK4O4lxxPic5YPvVPv8=";
  };
  srcDir = "src";
  deps = [
    jna
    ow2-asm
  ];
}
