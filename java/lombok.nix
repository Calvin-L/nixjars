{lib, precompiledJar, fetchMaven}:

precompiledJar rec {
  pname = "lombok";
  version = "1.18.30";
  license = lib.licenses.mit;
  src = fetchMaven {
    groupId = "org.projectlombok";
    artifactId = pname;
    inherit version;
    hash = "sha256-FBUbR1gtVwtN4WoUfs4729GazkruW946VXjIfbnsuZg=";
  };
}
