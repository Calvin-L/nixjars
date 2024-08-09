{lib, buildJavaPackage, fetchFromGitHub, testWithJUnit4, rsync, python3}:

let dollar = "$"; in
buildJavaPackage rec {
  pname = "apfloat";
  license = lib.licenses.mit;
  version = "1.14.0";
  src = fetchFromGitHub {
    owner = "mtommila";
    repo = "apfloat";
    rev = version;
    hash = "sha256-MGkENaSDLy1CdUsrfZJ5HbFK5tJ/32b7MwgphHv8ldE=";
  };
  sourceRoot = "${src.name}/apfloat";
  nativeBuildInputs = [
    rsync
    python3
  ];
  patchPhase = ''
    rsync -av --ignore-existing 'src/main/java9/' 'src/main/java/'
    for f in $(find src/main/template -iname '*.java'); do
      python3 -c '
import os
import re
import sys
from pathlib import PurePath

properties = {}
with open("serialver.properties", "r") as ff:
  for line in ff:
    key, val = line.strip().split("=")
    properties[key] = val

f = PurePath(sys.argv[1])

mappings = [
  ("Int", "int", "Int", "Integer"),
  ("Long", "long", "Long", "Long"),
  ("Float", "float", "Float", "Float"),
  ("Double", "double", "Double", "Double"),
]

for name, primitive, simplename, boxed in mappings:
  out = PurePath("src/main/java") / str(f.relative_to("src/main/template")).replace("Rawtype", name)
  print(f"{f} => {out}")
  with open(f, "r") as ff:
    contents = ff.read()
  contents = re.sub(r"RawType", boxed, contents)
  contents = re.sub(r"rawtype", primitive, contents)
  contents = re.sub(r"Rawtype", simplename, contents)
  for k, v in properties.items():
    contents = re.sub(re.escape("${dollar}{" + k + "}"), v, contents)
  with open(out, "w") as ff:
    ff.write(contents)
      ' "$f"
    done
  '';
  manifestProperties = {
    "Automatic-Module-Name" = "org.apfloat";
  };
  checkPhase = testWithJUnit4 {};
}
