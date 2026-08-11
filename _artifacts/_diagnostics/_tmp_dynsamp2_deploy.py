# -*- coding: utf-8 -*-
"""DYNSAMP2 — LOC 메저 생성 문장 힌트 적용 + 배포 (일회성. 본 스크립트는 _tmp_ 접두 임시)"""
import sys
import pathlib
import io

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

OUT = pathlib.Path(__file__).resolve().parents[1] / "_apply_corporate"
body = io.open(OUT / "BACKUP_PKG_DMF0044_BODY_pre_dynsamp2_20260810.sql", encoding="utf-8").read()
T4 = "\t" * 4
OLD = (T4 + "INSERT INTO DM_PLN_SALES_PLAN_REPORT_C\n"
       + T4 + "(  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD\n")
NEW = (T4 + "-- DYNSAMP2 2026-08-10: LOC 메저 생성 — 방금 적재된 REPORT_C 를 2회 GROUP BY 후 10컬럼 자기조인.\n"
       + T4 + "--   GT_DMF0_MEASURE(무통계 GTT) 조인 오추정 → NL 폭주(V$SQL 실측 buffer 18.3억, 회당 ~270s).\n"
       + T4 + "INSERT /*+ DYNAMIC_SAMPLING(11) */ INTO DM_PLN_SALES_PLAN_REPORT_C\n"
       + T4 + "(  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD\n")
assert body.count(OLD) == 1, "앵커 %d" % body.count(OLD)
patched = body.replace(OLD, NEW)
MARKS = {"AUTHUNION 2026-08-09": 1, "20260805 MERGE-ON 파리티 복원": 1, "PIVOTSEL 2026-08-10": 1,
         "PRODUCTDETAIL 2026-08-10": 2, "M.CALC_YN = '-'": 12, "RPTGRP-STUB 2026-08-10": 14,
         "NVL(d_Result_Date, '-')": 14, "SEQGRP 2026-08-10": 3, "ETCDEL 2026-08-10": 1,
         "DYNSAMP 2026-08-10": 3, "DYNSAMP2 2026-08-10": 1}
for m, k in MARKS.items():
    assert patched.count(m) == k, "마커 %s %d≠%d" % (m, patched.count(m), k)
assert len(patched.splitlines()) - len(body.splitlines()) == 2
io.open(OUT / "PKG_DMF0044_BODY_DYNSAMP2_20260810.sql", "w", encoding="utf-8").write(patched)
print("patch OK (+2행, 마커 11종 검증) — 배포")
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
cur.execute(patched.rstrip().rstrip("/").rstrip())
cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS "
            "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1")
for r in cur.fetchall():
    print(" ", r[0], r[1])
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'")
print("  errors =", cur.fetchone()[0])
con.close()
