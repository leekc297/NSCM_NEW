import pathlib, re
SRC = pathlib.Path(__file__).parent.parent / "_dmf0003_dynamic_property" / "extracted_sp_body.sql"
PREFIX_RE = re.compile(r"^\s*\d+\|\s?")
raw = SRC.read_text(encoding="utf-8").splitlines()
print(f"Total lines: {len(raw)}")
for i in range(955, 962):
    print(f"raw[{i}] = {raw[i]!r}")
    print(f"     → clean: {PREFIX_RE.sub('', raw[i])!r}")
