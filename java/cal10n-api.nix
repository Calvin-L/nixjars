{lib, buildJavaPackage, fetchFromGitHub}:

buildJavaPackage rec {
  pname = "cal10n-api";
  version = "0.8.1";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "qos-ch";
    repo = "cal10n";
    rev = "v_${version}";
    sha256 = "0w7ida4whamvrmgvmbzrx8ila5bfm32y6b551fz4314vd9msas5m";
  };
  srcDir = "cal10n-api/src/main/java";
}
