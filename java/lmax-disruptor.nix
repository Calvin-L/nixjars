{lib, buildJavaPackage, fetchFromGitHub}:


# # incompatible with log4j-core :(
# lmax-disruptor_4 = buildJavaPackage rec {
#   pname = "lmax-disruptor";
#   version = "4.0.0";
#   license = lib.licenses.asl20;
#   src = fetchFromGitHub {
#     owner = "LMAX-Exchange";
#     repo = "disruptor";
#     rev = version;
#     hash = "sha256-LZVazY8xEYW0eqGOR/GlrRbs0H+Vua3RWnAw4HNAoT8=";
#   };
# }

buildJavaPackage rec {
  pname = "lmax-disruptor";
  version = "3.4.4";
  license = lib.licenses.asl20;
  src = fetchFromGitHub {
    owner = "LMAX-Exchange";
    repo = "disruptor";
    rev = version;
    hash = "sha256-FrvLQ7ba1AEWnrGw79MPpo8Z9ChZHa8SbuMoZMedhQk=";
  };
}
