let nixpkgs = import <nixpkgs> {}; in
let nixjars = import ./.. {
  nixpkgs = nixpkgs;
  packageOverrides = pkgs: {
    commons-lang = pkgs.precompiledJar rec {
      pname = "commons-lang";
      version = "3.14.0";
      license = nixpkgs.lib.licenses.asl20;
      src = pkgs.fetchMaven {
        groupId = "org.apache.commons";
        artifactId = "commons-lang3";
        inherit version;
        hash = "sha256-e5a/PuaJSau1vEZVWawnDgVRWW+jRSP934kOxBjd4Tw=";
      };
    };
  };
};
in
nixjars.commons-bcel
