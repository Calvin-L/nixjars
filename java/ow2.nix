{lib, buildJavaPackage, fetchurl}:

let

version = "9.6";
license = lib.licenses.bsd3;
src = fetchurl {
  url = "https://gitlab.ow2.org/asm/asm/-/archive/ASM_9_6/asm-ASM_9_6.tar.bz2";
  hash = "sha256-/+gHEc8rVwosZVNuCYuPyJvJLFPquBycJXVKfmNe/j4=";
};

in rec {

  asm = buildJavaPackage {
    pname = "ow2-asm";
    inherit version license src;
    srcDir = "asm/src/main/java";
  };

  asm-tree = buildJavaPackage rec {
    pname = "ow2-asm-tree";
    inherit version license src;
    srcDir = "asm-tree/src/main/java";
    deps = [
      asm
    ];
  };

  asm-commons = buildJavaPackage rec {
    pname = "ow2-asm-commons";
    inherit version license src;
    srcDir = "asm-commons/src/main/java";
    deps = [
      asm
      asm-tree
    ];
  };

}
