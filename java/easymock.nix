{lib, buildJavaPackage, fetchFromGitHub,
 ow2, objenesis, byte-buddy, junit4, junit, testng}:

buildJavaPackage rec {
  pname = "easymock";
  version = "5.2.0";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "easymock";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-/6O4hYlBmJ3cEUmrzJ5EsdiBESZaJRTfOxiJpA4bYEk=";
  };
  sourceRoot = "${src.name}/core";
  deps = [
    objenesis
    byte-buddy
  ];
  compileOnlyDeps = [
    junit4
    junit.jupiter-api
    testng.core-api
    # dexmaker # requires Android SDK
  ];
  runtimeOnlyDeps = [
    ow2.asm
  ];
  patchPhase = ''
    rm src/main/java/org/easymock/internal/AndroidClassProxyFactory.java
    substituteInPlace src/main/java/org/easymock/internal/MocksControl.java --replace-fail \
      'return classProxyFactory = new AndroidClassProxyFactory();' \
      ""
  '';
}
