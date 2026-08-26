# -*- coding: utf-8 -*-
"""DMF0049 저장 대상 테이블 NOT NULL 컬럼 + DEFAULT 현황 실측 (읽기 전용).

사용자 확정(2026-08-20): "TABLE 내 NOT NULL COLUMN 의 경우 DEFAULT ON NULL '-' NOT NULL 설정"
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

TABLES = ["DM_PLN_SALES_ETC_REPORT_C"]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# 저장 SP 가 INSERT 하는 표 실명 확인 (하드코딩 검증)
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
               WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY'
               AND UPPER(TEXT) LIKE '%INSERT INTO%' ORDER BY LINE""")
print("== SP INSERT 대상 ==")
for ln, t in cur.fetchall():
    print(f"  L{ln}: {t.strip()[:100]}")

for tb in TABLES:
    print(f"\n== {tb} NOT NULL 컬럼 ==")
    cur.execute("""SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE,
                          NULLABLE, DEFAULT_ON_NULL, DATA_DEFAULT
                   FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t
                   ORDER BY COLUMN_ID""", {"t": tb})
    rows = cur.fetchall()
    nn = [r for r in rows if r[5] == "N"]
    print(f"  전체 {len(rows)}컬럼 / NOT NULL {len(nn)}")
    for r in nn:
        dflt = r[7].read() if hasattr(r[7], "read") else r[7]
        print(f"  {r[0]:26} {r[1]:10} DEF_ON_NULL={r[6]} DEFAULT={str(dflt).strip() if dflt else '-'}")
con.close()
