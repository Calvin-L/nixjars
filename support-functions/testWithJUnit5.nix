{lib, compileClasspath, runtimeClasspath, buildDirName, junit}:

{testSrcDir ? "src/test/java", testResourceDir ? "src/test/resources", testDeps ? [], jvmArgs ? []}:
  ''
    if [[ ! -d ${testSrcDir} ]]; then
      echo "No ${testSrcDir} folder!"
      false
    fi

    export TEST_COMPILE_CLASSPATH="$CLASS_OUTPUT_DIR:$COMPILE_CLASSPATH:${compileClasspath ([junit.jupiter-api] ++ testDeps)}"
    echo " --> Test compile classpath: $TEST_COMPILE_CLASSPATH"

    find ${testSrcDir} -iname '*.java' -type f | sort >${buildDirName}/java-files-test
    echo ' --> Compiling' $(wc -l < ${buildDirName}/java-files-test) '.java files'
    mkdir ${buildDirName}/test-classes
    javac \
      -classpath "$TEST_COMPILE_CLASSPATH" \
      --module-path "$TEST_COMPILE_CLASSPATH" \
      @${buildDirName}/java-files-test \
      -d ${buildDirName}/test-classes

    if [[ -d ${testResourceDir} ]]; then
      echo ' --> Copying test resources'
      rsync -av ${testResourceDir}/ ${buildDirName}/test-classes/
    fi

    export TEST_RUNTIME_CLASSPATH="${buildDirName}/test-classes:$RUNTIME_CLASSPATH:${runtimeClasspath ([junit.platform-console junit.jupiter-engine] ++ testDeps)}"
    echo " --> Test runtime classpath: $TEST_RUNTIME_CLASSPATH"
    java -classpath "$TEST_RUNTIME_CLASSPATH" ${lib.strings.escapeShellArgs jvmArgs} org.junit.platform.console.ConsoleLauncher --scan-class-path
  ''
