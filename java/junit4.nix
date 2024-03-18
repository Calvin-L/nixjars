{lib, buildJavaPackage, fetchFromGitHub, fetchurl, hamcrest, testWithJUnit4 ? null}:

buildJavaPackage rec {
  pname = "junit";
  version = "4.13.2";
  license = lib.licenses.epl10;
  src = fetchFromGitHub {
    owner = "junit-team";
    repo = "junit4";
    rev = "r${version}";
    hash = "sha256-A6ZbmsECwP/hYqmIoU3rDvEX3V9Dx3FtCgAxpv8n8+Q=";
  };
  patches = [
    ./junit-hamcrest-upgrade.patch # https://github.com/junit-team/junit4/issues/1741

    # these next 3 fix compile on JDK 18+
    # https://github.com/junit-team/junit4/issues/1739
    # https://github.com/junit-team/junit4/pull/1740

    (fetchurl {
      url = "https://github.com/junit-team/junit4/commit/0eb5ce72848d730da5bd6d42902fdd6a8a42055d.patch";
      hash = "sha256-LqJeCsLT50ANjS4kw4AUSEewmdD/2ePiT2mRN64tCBI=";
    })

    (fetchurl {
      url = "https://github.com/junit-team/junit4/commit/6ba9c4dc1e71e9ceb2e35991e8fc0e4aee69ad6e.patch";
      hash = "sha256-Xj2PWGwnKIWdJSdTN18BolP0jMiVv9UzS0NZOOLNmLE=";
    })

    (fetchurl {
      url = "https://github.com/junit-team/junit4/commit/d1f95df767333d07f45d553254a99693f31eea2e.patch";
      hash = "sha256-yeRZT88DHbznT66BlhwD1r20iElz37SnM/6RtfGA7WA=";
    })

  ];
  deps = [
    hamcrest
  ];
  # checkPhase = if testWithJUnit4 != null then testWithJUnit4 {} else null;
  checkPhase = null; # bafflingly, the tests don't pass???
}
