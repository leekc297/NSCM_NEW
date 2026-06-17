"""Extract PKG_COM0000.P_COM0005_GET_PROJECT_BY_DIVISION_POPUP procedure body from package."""
import os, pathlib
import oracledb

oracledb.defaults.fetch_lobs = False
out = pathlib.Path(__file__).parent / "extracted_proj_popup.sql"

with oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"]) as con:
    cur = con.cursor()
    cur.execute("""
        SELECT LINE, TEXT FROM ALL_SOURCE
         WHERE OWNER='SCM_MGR' AND NAME='PKG_COM0000' AND TYPE='PACKAGE BODY'
         ORDER BY LINE
    """)
    full = []
    for line, text in cur:
        full.append((line, text or ""))

# Extract only PROCEDURE P_COM0005_GET_PROJECT_BY_DIVISION_POPUP
target = "P_COM0005_GET_PROJECT_BY_DIVISION_POPUP"
in_proc = False
extracted = []
nesting = 0
for line, text in full:
    upper = text.upper()
    if not in_proc:
        if "PROCEDURE" in upper and target in upper:
            in_proc = True
            extracted.append((line, text))
        continue
    extracted.append((line, text))
    if "END " + target.upper() in upper:
        break

with out.open("w", encoding="utf-8", errors="replace") as f:
    for line, text in extracted:
        f.write(f"{line:5d}| {text.rstrip()}\n")
print(f"extracted: {out} ({len(extracted)} lines, source range {extracted[0][0]}~{extracted[-1][0] if extracted else '-'})")
