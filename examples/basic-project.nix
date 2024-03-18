let nixpkgs = import <nixpkgs> {}; in
let nixjars = import ./.. { nixpkgs=nixpkgs; }; in

nixjars.buildJavaPackage rec {
  pname = "crash-safe-io";
  version = "0.1";
  license = nixpkgs.lib.licenses.mit;
  src = nixpkgs.fetchFromGitHub {
    owner = "Calvin-L";
    repo = pname;
    rev = "4a744b9f2b8f1d5cbcb841d738497fcfd9ff7756";
    hash = "sha256-4WYN7cGSNXrdwbmVw+Vyqj1Je+AKIoqFK9UwCzEEyJ8=";
  };
  compileOnlyDeps = [
    nixjars.checker-qual
  ];
  checkPhase = nixjars.testWithTestNG {};
}
