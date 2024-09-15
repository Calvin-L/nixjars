{lib, compileClasspath, runtimeClasspath, buildDirName, testng}:

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

    export TEST_COMPILE_CLASSPATH="$CLASS_OUTPUT_DIR:$COMPILE_CLASSPATH:${compileClasspath ([testng.core-api] ++ testDeps)}"
    echo " --> Test compile classpath: $TEST_COMPILE_CLASSPATH"

    find ${lib.strings.escapeShellArgs testSrcDirs} -iname '*.java' -type f | sort >${buildDirName}/java-files-test
    echo ' --> Compiling' $(wc -l < ${buildDirName}/java-files-test) '.java files'
    mkdir ${buildDirName}/test-classes
    javac \
      -classpath "$TEST_COMPILE_CLASSPATH" \
      --module-path "$CLASSPATH" \
      @${buildDirName}/java-files-test \
      -d ${buildDirName}/test-classes

    ${copyTestResources}

    echo '<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">' >nixsupport-testng.xml
    echo '<suite name="TestSuite" verbose="1">' >>nixsupport-testng.xml
    echo '<test name="Test">' >>nixsupport-testng.xml
    echo '<packages>' >>nixsupport-testng.xml
    for d in $(find ${lib.strings.escapeShellArgs testSrcDirs} -type d -printf '%P\n' | tr '/' '.'); do
      echo "Test package: $d"
      echo '<package name="'"$d"'"/>' >>nixsupport-testng.xml
    done
    echo '</packages>' >>nixsupport-testng.xml
    echo '</test>' >>nixsupport-testng.xml
    echo '</suite>' >>nixsupport-testng.xml

    export TEST_RUNTIME_CLASSPATH="${buildDirName}/test-classes:$RUNTIME_CLASSPATH:${runtimeClasspath ([testng.core] ++ testDeps)}"
    echo " --> Test runtime classpath: $TEST_RUNTIME_CLASSPATH"
    java -classpath "$TEST_RUNTIME_CLASSPATH" ${lib.strings.escapeShellArgs jvmArgs} org.testng.TestNG nixsupport-testng.xml
  ''
