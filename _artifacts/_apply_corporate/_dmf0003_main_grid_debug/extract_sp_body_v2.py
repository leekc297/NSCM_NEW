"""Extract DMF0003_GET_MKT_FCST_DATA SP body from corporate Oracle via ALL_SOURCE row-by-row."""
import os, pathlib
import oracledb

dsn  = os.environ["NSCM_ORA_DSN"]
user = os.environ["NSCM_ORA_USER"]
pwd  = os.environ["NSCM_ORA_PASS"]

out = pathlib.Path(__file__).parent / "extracted_sp_body_v2.sql"

# Configure oracledb thin mode with EUC-KR fallback (사내 NLS_LANG 한글)
oracledb.defaults.fetch_lobs = False

with oracledb.connect(user=user, password=pwd, dsn=dsn) as con:
    cur = con.cursor()
    # ALL_SOURCE TEXT column is VARCHAR2(4000) — fetch raw bytes
    cur.execute("""
        SELECT LINE, TEXT
          FROM ALL_SOURCE
         WHERE OWNER='SCM_MGR' AND NAME='DMF0003_GET_MKT_FCST_DATA' AND TYPE='PROCEDURE'
         ORDER BY LINE
    """)
    with out.open("w", encoding="utf-8", errors="replace") as f:
        cnt = 0
        for line, text in cur:
            t = text if text is not None else ""
            f.write(f"{line:5d}| {t.rstrip()}\n")
            cnt += 1
    print(f"extracted: {out} ({cnt:,} lines)")
