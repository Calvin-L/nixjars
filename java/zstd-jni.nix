{lib, stdenv, buildJavaPackage, fetchFromGitHub,
 zstd, jdk, cmake}:

let

  version = "1.5.5-6";
  license = lib.licenses.bsd2;
  src = fetchFromGitHub {
    owner = "luben";
    repo = "zstd-jni";
    rev = "v${version}";
    hash = "sha256-c6T8Re4AgLZ699ZOoavPlg6MvhctQOQdc71QBSZMOGg=";
  };

  zstd-jni-native = stdenv.mkDerivation {
    pname = "zstd-jni-native";
    inherit src version;
    nativeBuildInputs = [
      cmake
    ];
    buildInputs = [
      zstd
      jdk
    ];
    preConfigure = ''
      cd src/main/native
      rm -rv zstd.h zdict.h zstd_errors.h common compress decompress dictBuilder legacy
      all_src=$(find . -iname 'jni*.c' -type f)
      cat >CMakeLists.txt <<EOF
      cmake_minimum_required(VERSION 3.26)
      project(zstd-jni-native C)
      find_package(zstd REQUIRED)
      find_package(JNI REQUIRED)
      add_library(zstd-jni-${version} MODULE $all_src)
      target_link_libraries(zstd-jni-${version} PRIVATE zstd JNI::JNI)
      install(
        TARGETS zstd-jni-${version}
        LIBRARY
          DESTINATION lib)
      EOF
    '';
    meta = {
      inherit license;
    };
  };

in buildJavaPackage {
  pname = "zstd-jni";
  inherit version license src;
  propagatedBuildInputs = [
    zstd-jni-native
  ];
  configurePhase = ''
    libpath=$(find ${zstd-jni-native}/lib -iname 'libzstd-jni-*' -type f | head -n1)
    substituteInPlace src/main/java/com/github/luben/zstd/util/Native.java \
      --replace-fail 'System.getProperty(nativePathOverride)' "\"$libpath\""

    cat >src/main/java/com/github/luben/zstd/util/ZstdVersion.java <<EOF
      package com.github.luben.zstd.util;
      public class ZstdVersion {
        public static final String VERSION = "${version}";
      }
    EOF
  '';
  checkPhase = ''
    echo 'Testing JNI import...'
    cat >Test.java <<EOF
    class Test {
      public static void main(String[] args) {
        com.github.luben.zstd.util.Native.load();
      }
    }
    EOF
    javac Test.java
    java Test
  '';
}
