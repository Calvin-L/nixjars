{lib, fetchFromGitHub, buildJavaPackage}:

# CAUTION: appears abandoned: https://github.com/uniVocity/univocity-parsers/issues/534
buildJavaPackage rec {
  pname = "univocity-parsers";
  version = "2.9.1";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "uniVocity";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VeN7nnqVVWunFTaIffEsVGI24y7fkpUupwrOnkSM+wM=";
  };

  # fix various "error: reference to Record is ambiguous [...] interface com.univocity.parsers.common.record.Record in com.univocity.parsers.common.record and class java.lang.Record in java.lang match"
  patchPhase = ''
    substituteInPlace \
      src/main/java/com/univocity/parsers/common/*.java \
      src/main/java/com/univocity/parsers/common/iterators/*.java \
      src/main/java/com/univocity/parsers/fixed/*.java \
      --replace-quiet 'import com.univocity.parsers.common.record.*;' 'import com.univocity.parsers.common.record.*; import com.univocity.parsers.common.record.Record;'
  '';
  # checkPhase = testWithTestNG {};
}
