{lib, buildJavaPackage, fetchurl}:

let

version = "9.7.1";
license = lib.licenses.bsd3;
src = fetchurl {
  url = "https://gitlab.ow2.org/asm/asm/-/archive/ASM_9_7_1/asm-ASM_9_7_1.tar.bz2";
  hash = "sha256-lueDoqyxj5jEt8Y1Xyv7EvhNZAxsgcQwrvYjm7SzCWA=";
};
srcName = "asm-ASM_9_7_1"; # for some reason src.name doesn't work :(

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
