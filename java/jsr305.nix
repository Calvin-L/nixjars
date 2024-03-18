{lib, buildJavaPackage, fetchurl, unzip}:

# NOTE: this has been discontinued, but it is still in very widespread use.
buildJavaPackage rec {
  pname = "jsr305";
  version = "3.0.2";
  license = lib.licenses.bsd3; # https://github.com/findbugsproject/findbugs/issues/128
  src = fetchurl {
    url = "https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/${version}/jsr305-${version}-sources.jar";
    sha256 = "0fq6mai14sg5rj1swxfc90xha0qnqwl4iiqxb5m8qw6hfbi8b7hw";
  };
  unpackCmd = "mkdir jsr305 && ${unzip}/bin/unzip -d jsr305 \"$curSrc\"";
  srcDir = ".";
}
