# -*- coding: utf-8 -*-
"""실행 중 커서의 전체 SQL 텍스트에서 힌트 존재 여부 + 배포 소스의 힌트 확인"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("SELECT SQL_FULLTEXT, ROUND(ELAPSED_TIME/1e6), TO_CHAR(FIRST_LOAD_TIME) FROM V$SQL WHERE SQL_ID='fndp8c35xn8y5'")
r = cur.fetchone()
if r:
    txt = r[0].read() if hasattr(r[0], "read") else r[0]
    print("커서 elapsed=%ss  first_load=%s  len=%d" % (r[1], r[2], len(txt)))
    for h in ("DYNAMIC_SAMPLING(11)", "NO_PUSH_PRED", "USE_HASH", "NO_MERGE", "LEADING"):
        print("  힌트 '%s' 포함: %s" % (h, h in txt))
else:
    print("커서 없음(이미 종료)")

print("\n== 배포된 소스의 LOC 문장 힌트 ==")
cur.execute("""SELECT LINE, RTRIM(TEXT) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND (INSTR(TEXT,'NO_PUSH_PRED')>0 OR INSTR(TEXT,'DYNSAMP3')>0)
                ORDER BY LINE""")
for ln, t in cur.fetchall():
    print("%6d| %s" % (ln, t[:170]))
con.close()
