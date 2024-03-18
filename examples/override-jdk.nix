let nixpkgs = import <nixpkgs> {}; in
let nixjars = import ./.. { nixpkgs=nixpkgs; }; in

(nixjars.override {
  jdk=nixpkgs.jdk17_headless;
  jre=nixpkgs.jdk17_headless; }).antlr
