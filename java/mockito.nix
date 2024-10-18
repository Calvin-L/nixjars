{lib, buildJavaPackage, fetchFromGitHub,
  byte-buddy, byte-buddy-agent, objenesis, ow2-asm,
  junit4, hamcrest, opentest4j}:

let dollar = "$"; in

buildJavaPackage rec {
  pname = "mockito";
  version = "5.14.2";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "mockito";
    repo = "mockito";
    rev = "v${version}";
    hash = "sha256-vm7Yo43YpRKMhzHJARuZB9K0Gd4A67ajaIrMVluzs2M=";
  };
  sourceRoot = "${src.name}/mockito-core";
  patchPhase = ''
    substituteInPlace src/main/java/org/mockito/internal/creation/bytebuddy/InlineBytecodeGenerator.java \
      --replace-fail 'net.bytebuddy.jar.asm.' 'org.objectweb.asm.' \

    substituteInPlace src/main/java/org/mockito/internal/creation/bytebuddy/MockMethodAdvice.java \
      --replace-fail 'net.bytebuddy.jar.asm.' 'org.objectweb.asm.' \
  '';

  # https://github.com/mockito/mockito/blob/9821ce031942a21e2f7333df38cf3d680cceaf76/gradle/mockito-core/inline-mock.gradle#L7
  postBuild = ''
    MMD="$(find . -name 'MockMethodDispatcher.class')"
    mv -v "$MMD" "${dollar}{MMD%.class}.raw"
    rm -fv "$(dirname "$MMD")"/*.class
  '';

  deps = [
    byte-buddy
    byte-buddy-agent
    objenesis
    ow2-asm
  ];
  compileOnlyDeps = [
    junit4
    hamcrest
    opentest4j
  ];
}
