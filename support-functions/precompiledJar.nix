{lib, stdenvNoCC, runtimeClasspath, jre, makeWrapper}:

{pname, version, src, license, runtimeOnlyDeps ? [], exes ? []}:

let
  # TODO: dedup with buildJavaPackage
  outputJar = "lib/java/${pname}-${version}.jar";
  mkExe = e: ''
    echo ' --> creating ${e.name} (${e.class})'
    makeWrapper \
      '${jre}/bin/java' \
      $out/bin/'${e.name}' \
      --add-flags "-XX:+UseParallelGC ${e.class}" \
      --set CLASSPATH $out/'${outputJar}:${runtimeClasspath runtimeOnlyDeps}'
  '';
in

stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    runtimeOnlyDeps;
  unpackPhase = "true";
  installPhase = ''
    mkdir -p "$out/lib/java"
    cp -v --reflink=auto "$src" "$out/${outputJar}"
    ${builtins.concatStringsSep "\n" (builtins.map mkExe exes)}
  '';
  nativeBuildInputs = lib.optional (exes != []) [makeWrapper];
  meta = {
    license = license;
  };
}
