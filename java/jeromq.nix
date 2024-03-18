{lib, buildJavaPackage, fetchFromGitHub, jnacl}:

buildJavaPackage rec {
  pname = "jeromq";
  version = "0.5.4";
  license = lib.licenses.mpl20;
  src = fetchFromGitHub {
    owner = "zeromq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KUJTejp7zx2HvesKTv0JSr9yVt4cRgLyG4K3HOkkHNs=";
  };
  deps = [
    jnacl
  ];
}
