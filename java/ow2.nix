{lib, buildJavaPackage, fetchurl}:

let

version = "9.6";
license = lib.licenses.bsd3;
src = fetchurl {
  url = "https://gitlab.ow2.org/asm/asm/-/archive/ASM_9_6/asm-ASM_9_6.tar.bz2";
  hash = "sha256-/+gHEc8rVwosZVNuCYuPyJvJLFPquBycJXVKfmNe/j4=";
};
srcName = "asm-ASM_9_6"; # for some reason src.name doesn't work :(

in rec {

  asm = buildJavaPackage {
    pname = "ow2-asm";
    inherit version license src;
    sourceRoot = "${srcName}/asm";
  };

  asm-tree = buildJavaPackage {
    pname = "ow2-asm-tree";
    inherit version license src;
    sourceRoot = "${srcName}/asm-tree";
    deps = [
      asm
    ];
  };

  asm-commons = buildJavaPackage {
    pname = "ow2-asm-commons";
    inherit version license src;
    sourceRoot = "${srcName}/asm-commons";
    deps = [
      asm
      asm-tree
    ];
  };

  asm-analysis = buildJavaPackage {
    pname = "ow2-asm-analysis";
    inherit version license src;
    sourceRoot = "${srcName}/asm-analysis";
    deps = [
      asm
      asm-tree
    ];
  };

  asm-util = buildJavaPackage {
    pname = "ow2-asm-util";
    inherit version license src;
    sourceRoot = "${srcName}/asm-util";
    deps = [
      asm
      asm-analysis
      asm-tree
    ];
  };

}
