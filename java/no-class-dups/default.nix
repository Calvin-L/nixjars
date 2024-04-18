{lib, buildJavaPackage, classgraph}:

buildJavaPackage {
  pname = "no-class-dups";
  version = "1.0.0";
  src = ./.;
  license = lib.licenses.mit;
  checkForClassDups = false; # this is a dependency of the dedup infrastructure
  deps = [
    classgraph
  ];
  exes = [
    { name="no-class-dups"; class="org.nixjars.NoClassDups"; }
  ];
}
