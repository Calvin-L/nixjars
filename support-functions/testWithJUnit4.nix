{lib, compileClasspath, runtimeClasspath, buildDirName, junit4, takari-cpsuite}:

{testSrcDir ? "src/test/java", testResourceDir ? "src/test/resources", testDeps ? [], jvmArgs ? []}:
  ''
    if [[ ! -d ${testSrcDir} ]]; then
      echo "No ${testSrcDir} folder!"
      false
    fi

    export CLASSPATH="$CLASSPATH:${compileClasspath ([junit4 takari-cpsuite] ++ testDeps)}"
    echo " --> Test compile classpath: $CLASSPATH"

    echo " --> Generating test suite class"
    mkdir -p ${testSrcDir}/nixsupport
    cat >${testSrcDir}/nixsupport/TestSuite.java <<EOF
      package nixsupport;
      import org.junit.extensions.cpsuite.ClasspathSuite;
      import org.junit.runner.RunWith;
      @RunWith(ClasspathSuite.class)
      public class TestSuite {}
    EOF

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

    export CLASSPATH="$CLASSPATH:${buildDirName}/test-classes:${runtimeClasspath ([junit4 takari-cpsuite] ++ testDeps)}"
    echo " --> Test runtime classpath: $CLASSPATH"
    java ${lib.strings.escapeShellArgs jvmArgs} org.junit.runner.JUnitCore nixsupport.TestSuite
  ''
