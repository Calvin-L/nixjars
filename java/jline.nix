{lib, stdenv, buildJavaPackage, fetchFromGitHub,
 cmake, jdk,
 testWithJUnit5, easymock}:

let

  version = "3.27.1";
  license = lib.licenses.bsd3;
  src = fetchFromGitHub {
    owner = "jline";
    repo = "jline3";
    rev = "jline-${version}";
    hash = "sha256-+g+TaAVdK5WoQ1/8VGX/BJh34lGXKeLiLCJJypaXOwk=";
  };

in rec {

  native-jni = stdenv.mkDerivation {
    pname = "jline-native-jni";
    inherit version src;
    meta = {
      inherit license;
    };
    nativeBuildInputs = [
      cmake
    ];
    buildInputs = [
      jdk
    ];
    preConfigure = ''
      cd native/src/main/native
      cat >CMakeLists.txt <<EOF
      cmake_minimum_required(VERSION 3.26)
      project(jline-jni-native C)
      find_package(JNI REQUIRED)
      add_library(jline-jni MODULE jlinenative.h jlinenative.c clibrary.c kernel32.c)
      target_link_libraries(jline-jni PRIVATE JNI::JNI)
      install(
        TARGETS jline-jni
        LIBRARY
          DESTINATION lib)
      EOF
    '';
  };

  native = buildJavaPackage {
    pname = "jline-native";
    inherit version license src;
    propagatedBuildInputs = [
      native-jni
    ];
    sourceRoot = "${src.name}/native";
    configurePhase = ''
      rm -rv src/main/resources/org/jline/nativ
      libpath=$(find ${native-jni}/lib -iname 'libjline-jni.*' -type f | head -n1)
      test -e "$libpath"
      substituteInPlace src/main/java/org/jline/nativ/JLineNativeLoader.java \
        --replace-fail 'String jlineNativeLibraryPath = System.getProperty("library.jline.path");' "String jlineNativeLibraryPath = \"$(dirname "$libpath")\";"
      substituteInPlace src/main/java/org/jline/nativ/JLineNativeLoader.java \
        --replace-fail 'String jlineNativeLibraryName = System.getProperty("library.jline.name");' "String jlineNativeLibraryName = \"$(basename "$libpath")\";"
    '';
    checkPhase = ''
      echo 'Testing JNI import...'
      cat >Test.java <<EOF
        public class Test {
          public static void main(String[] args) {
            org.jline.nativ.JLineNativeLoader.initialize();
          }
        }
      EOF
      javac -classpath "$CLASS_OUTPUT_DIR" Test.java
      java -classpath ".:$RUNTIME_CLASSPATH" Test
    '';
  };

  terminal = buildJavaPackage {
    pname = "jline-terminal";
    inherit version license src;
    sourceRoot = "${src.name}/terminal";
    deps = [
      native
    ];
    checkPhase = testWithJUnit5 { testDeps=[easymock]; };
  };

  reader = buildJavaPackage {
    pname = "jline-reader";
    inherit version license src;
    sourceRoot = "${src.name}/reader";
    deps = [
      terminal
    ];
  };

}
