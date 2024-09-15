{lib, compileClasspath, runtimeClasspath, buildDirName, junit}:

{testSrcDirs ? ["src/test/java"], testResourceDirs ? null, testDeps ? [], jvmArgs ? []}:
  let
    copyTestResources = if testResourceDirs != null then
      ''
        echo ' --> Copying test resources'
        for testResourceDir in ${lib.strings.escapeShellArgs testResourceDirs}; do
          rsync -av "$testResourceDir/" ${buildDirName}/test-classes/
        done
      ''
    else
      ''
        if [[ -d src/test/resources ]]; then
          echo ' --> Copying test resources'
          rsync -av src/test/resources/ ${buildDirName}/test-classes/
        fi
      '';
  in
  ''
    for testSrcDir in ${lib.strings.escapeShellArgs testSrcDirs}; do
      if [[ ! -d "$testSrcDir" ]]; then
        echo "No $testSrcDir folder!"
        false
      fi
    done

    export TEST_COMPILE_CLASSPATH="$CLASS_OUTPUT_DIR:$COMPILE_CLASSPATH:${compileClasspath ([junit.jupiter-api] ++ testDeps)}"
    echo " --> Test compile classpath: $TEST_COMPILE_CLASSPATH"

    find ${lib.strings.escapeShellArgs testSrcDirs} -iname '*.java' -type f | sort >${buildDirName}/java-files-test
    echo ' --> Compiling' $(wc -l < ${buildDirName}/java-files-test) '.java files'
    mkdir ${buildDirName}/test-classes
    javac \
      -classpath "$TEST_COMPILE_CLASSPATH" \
      --module-path "$TEST_COMPILE_CLASSPATH" \
      @${buildDirName}/java-files-test \
      -d ${buildDirName}/test-classes

    ${copyTestResources}

    export TEST_RUNTIME_CLASSPATH="${buildDirName}/test-classes:$RUNTIME_CLASSPATH:${runtimeClasspath ([junit.platform-console junit.jupiter-engine] ++ testDeps)}"
    echo " --> Test runtime classpath: $TEST_RUNTIME_CLASSPATH"
    java -classpath "$TEST_RUNTIME_CLASSPATH" ${lib.strings.escapeShellArgs jvmArgs} org.junit.platform.console.ConsoleLauncher --scan-class-path
  ''
