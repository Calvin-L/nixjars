{lib, stdenvNoCC, runtimeClasspath, jre, makeWrapper}:

{pname, version, src, license, runtimeOnlyDeps ? [], exes ? []}:

let
  # TODO: dedup with buildJavaPackage
  dollar = "$";
  outputJar = "lib/java/${pname}-${version}.jar";
  mkExe = e: ''
    outexe="${dollar}{!outputBin}/bin/${e.name}"
    echo " --> creating $outexe (${e.class})"
    makeWrapper \
      '${jre}/bin/java' \
      "$outexe" \
      --add-flags "-XX:+UseParallelGC ${e.class}" \
      --set CLASSPATH "${dollar}{!outputLib}"/'${outputJar}:${runtimeClasspath runtimeOnlyDeps}'
  '';
in

stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    runtimeOnlyDeps
    outputJar;
  unpackPhase = "true";
  installPhase = ''
    mkdir -p "${dollar}{!outputLib}/lib/java"
    cp -v --reflink=auto "$src" "${dollar}{!outputLib}/${outputJar}"
    ${builtins.concatStringsSep "\n" (builtins.map mkExe exes)}
  '';
  nativeBuildInputs = lib.optional (exes != []) [makeWrapper];
  outputs = if exes == [] then ["out"] else ["bin" "lib" "out"];
  meta = {
    license = license;
  };
}
