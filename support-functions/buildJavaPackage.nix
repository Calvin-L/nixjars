{lib, stdenvNoCC, jdk, jre, rsync, makeWrapper, no-class-dups,
 buildDirName, compileClasspath, runtimeClasspath}:

args@{
  pname,
  version,
  license,
  srcDir ? "src/main/java",
  resourceDir ? null,
  checkForClassDups ? true,
  deps ? [],
  compileOnlyDeps ? [],
  runtimeOnlyDeps ? [],
  nativeBuildInputs ? [],
  annotationProcessors ? [],
  sourceEncoding ? "UTF-8",
  extraJavacArgs ? [],
  manifestProperties ? {},
  checkPhase ? null,
  exes ? [],
  meta ? {},
  ...}:

let
  dollar = "$";
  outputJar = "lib/java/${pname}-${version}.jar";
  # makeWrapper docs:
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
  mkExe = e: ''
    outexe="${dollar}{!outputBin}/bin/${e.name}"
    echo " --> creating $outexe (${e.class})"
    makeWrapper \
      '${jre}/bin/java' \
      "$outexe" \
      --add-flags "-XX:+UseParallelGC ${e.class}" \
      --set CLASSPATH "${dollar}{!outputLib}"/'${outputJar}:${runtimeClasspath (deps ++ runtimeOnlyDeps)}'
  '';
  copyResources = if resourceDir != null then ''
    echo ' --> Copying resources'
    rsync -av --exclude='*.java' ${resourceDir}/ ${buildDirName}/classes/
  '' else ''
    if [[ -d src/main/resources ]]; then
      echo ' --> Copying resources'
      rsync -av --exclude='*.java' src/main/resources/ ${buildDirName}/classes/
    fi
  '';
  annotationsArgs = if annotationProcessors == []
    then []
    else ["-processorpath" (runtimeClasspath compileOnlyDeps) "-processor" (builtins.concatStringsSep "," annotationProcessors)];
  actuallyDoClassDupCheck = checkForClassDups && (compileOnlyDeps ++ deps) != [];
in

stdenvNoCC.mkDerivation (
  builtins.removeAttrs args [
    "license" "srcDir" "resourceDir" "checkForClassDups"
    "deps" "compileOnlyDeps" "runtimeOnlyDeps" "nativeBuildInputs"
    "annotationProcessors" "sourceEncoding" "extraJavacArgs"
    "manifestProperties" "exes"] // {
  inherit
    pname
    version
    outputJar
    runtimeOnlyDeps;
  nativeBuildInputs =
    [jdk rsync] ++
    nativeBuildInputs ++
    compileOnlyDeps ++
    lib.optionals (exes != []) [makeWrapper] ++
    lib.optionals actuallyDoClassDupCheck [no-class-dups];
  buildInputs = deps;
  doCheck = checkPhase != null;
  buildPhase = ''
    runHook preBuild

    mkdir ${buildDirName}
    mkdir ${buildDirName}/classes
    export CLASSPATH='${compileClasspath (deps ++ compileOnlyDeps)}'
    echo " --> Compile classpath: '$CLASSPATH'"
    ${if actuallyDoClassDupCheck then "no-class-dups \"$CLASSPATH\"" else "echo 'Skipping class dup check'"}
    find '${srcDir}' -iname '*.java' -type f | sort >${buildDirName}/java-files
    echo ' --> Compiling' $(wc -l < ${buildDirName}/java-files) '.java files'
    javac \
      -encoding ${sourceEncoding} \
      --module-path "$CLASSPATH" \
      ${lib.strings.escapeShellArgs annotationsArgs} \
      ${lib.strings.escapeShellArgs extraJavacArgs} \
      @${buildDirName}/java-files \
      -d ${buildDirName}/classes
    ${copyResources}
    export CLASSPATH="${buildDirName}/classes:$CLASSPATH"

    echo 'Manifest:'
    touch MANIFEST.MF
    ${builtins.concatStringsSep ";" (builtins.map (p: "echo '${p}: ${manifestProperties.${p}}' >>MANIFEST.MF") (builtins.attrNames manifestProperties))}
    cat MANIFEST.MF

    runHook postBuild
  '';

  outputs = if exes == [] then ["out"] else ["bin" "lib" "out"];

  # NOTE: --date argument helps ensure byte-for-byte reproducibility.  Without
  # it, timestamps of the contents are included in the JAR file.  The actual
  # date selection doesn't matter much; I happen to think the start of the new
  # millenium is an elegant choice.
  installPhase = ''
    echo " --> Creating JAR ${dollar}{!outputLib}/${outputJar}"
    mkdir -p "$(dirname "${dollar}{!outputLib}/${outputJar}")"
    jar -c \
      --date='2000-01-01T00:00:00Z' \
      --manifest=MANIFEST.MF \
      -f "${dollar}{!outputLib}/${outputJar}" \
      -C ${buildDirName}/classes .
    ${builtins.concatStringsSep "\n" (builtins.map mkExe exes)}
  '';
  meta = (meta // {
    license = license;
  });
})
