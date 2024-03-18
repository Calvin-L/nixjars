{lib, compileClasspath, runtimeClasspath, buildDirName, junit}:

{testSrcDir ? "src/test/java", testResourceDir ? "src/test/resources", testDeps ? [], jvmArgs ? []}:
  ''
    if [[ ! -d ${testSrcDir} ]]; then
      echo "No ${testSrcDir} folder!"
      false
    fi

    export CLASSPATH="$CLASSPATH:${compileClasspath ([junit.jupiter-api] ++ testDeps)}"
    echo " --> Test compile classpath: $CLASSPATH"

    find ${testSrcDir} -iname '*.java' -type f | sort >${buildDirName}/java-files-test
    echo ' --> Compiling' $(wc -l < ${buildDirName}/java-files-test) '.java files'
    mkdir ${buildDirName}/test-classes
    javac \
      --module-path "$CLASSPATH" \
      @${buildDirName}/java-files-test \
      -d ${buildDirName}/test-classes

    if [[ -d ${testResourceDir} ]]; then
      echo ' --> Copying test resources'
      rsync -av ${testResourceDir}/ ${buildDirName}/test-classes/
    fi

    export CLASSPATH="$CLASSPATH:${buildDirName}/test-classes:${runtimeClasspath ([junit.platform-console junit.jupiter-engine] ++ testDeps)}"
    echo " --> Test runtime classpath: $CLASSPATH"
    java ${lib.strings.escapeShellArgs jvmArgs} org.junit.platform.console.ConsoleLauncher --scan-class-path
  ''
