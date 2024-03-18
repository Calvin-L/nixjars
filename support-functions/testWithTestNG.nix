{lib, compileClasspath, runtimeClasspath, buildDirName, testng}:

{testSrcDir ? "src/test/java", testResourceDir ? "src/test/resources", testDeps ? [], jvmArgs ? []}:
  ''
    if [[ ! -d ${testSrcDir} ]]; then
      echo "No ${testSrcDir} folder!"
      false
    fi

    export CLASSPATH="$CLASSPATH:${compileClasspath ([testng.core-api] ++ testDeps)}"
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

    echo '<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">' >nixsupport-testng.xml
    echo '<suite name="TestSuite" verbose="1">' >>nixsupport-testng.xml
    echo '<test name="Test">' >>nixsupport-testng.xml
    echo '<packages>' >>nixsupport-testng.xml
    for d in $(find ${testSrcDir} -type d -printf '%P\n' | tr '/' '.'); do
      echo "Test package: $d"
      echo '<package name="'"$d"'"/>' >>nixsupport-testng.xml
    done
    echo '</packages>' >>nixsupport-testng.xml
    echo '</test>' >>nixsupport-testng.xml
    echo '</suite>' >>nixsupport-testng.xml

    export CLASSPATH="$CLASSPATH:${buildDirName}/test-classes:${runtimeClasspath ([testng.core] ++ testDeps)}"
    echo " --> Test runtime classpath: $CLASSPATH"
    java ${lib.strings.escapeShellArgs jvmArgs} org.testng.TestNG nixsupport-testng.xml
  ''
