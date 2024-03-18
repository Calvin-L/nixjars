{lib, fetchurl}:

{groupId, artifactId, version, extension ? "jar", hash ? ""}:
  # consider:
  # $ mvn dependency:get -Dartifact="$artifactId" -Dmaven.repo.local=$out/.m2
  fetchurl {
    url = "https://repo1.maven.org/maven2/${lib.replaceStrings ["."] ["/"] groupId}/${artifactId}/${version}/${artifactId}-${version}.${extension}";
    inherit hash;
  }
