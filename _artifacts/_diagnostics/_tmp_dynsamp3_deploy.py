# -*- coding: utf-8 -*-
"""DYNSAMP3 — LOC 메저 생성 SELECT 에 조인방식 힌트 (PUSHED PREDICATE 차단)

실측(2026-08-10, SQL_ID 8c6fzxtrsp2c3 라이브 플랜):
    3   NESTED LOOPS                       ACT 7,622
    4    VIEW            (A: QTY 그룹)      ACT 7,636
    11   VIEW PUSHED PREDICATE (B: AMT)    ← A 행마다 B 서브쿼리 재실행
    15    TABLE ACCESS FULL GT_DMF0_MEASURE  ACT 7,637회
    17    INDEX RANGE SCAN PK_..._REPORT_C   (버전 전 구간을 매회 재스캔)

DYNAMIC_SAMPLING(11) 은 카디널리티만 보정할 뿐 조인예측푸시(JPPD)를 막지 못했다.
⇒ B 를 통째로 1회 산출해 해시조인: NO_PUSH_PRED(B) + NO_MERGE(A/B) + USE_HASH + LEADING.
결과 동등성: 힌트는 실행계획만 바꾼다(행 집합 불변).
"""
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


def live_body(cur):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                    AND TYPE='PACKAGE BODY' ORDER BY LINE""")
    return "CREATE OR REPLACE " + "".join(r[0] for r in cur.fetchall()).lstrip()


u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
body = live_body(cur)
io.open(OUT / "BACKUP_PKG_DMF0044_BODY_pre_dynsamp3_20260810.sql", "w", encoding="utf-8").write(body)

T4 = "\t" * 4
OLD = (T4 + "INSERT /*+ DYNAMIC_SAMPLING(11) */ INTO DM_PLN_SALES_PLAN_REPORT_C\n"
       + T4 + "(  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD\n")
assert body.count(OLD) == 1, "LOC INSERT 앵커 %d" % body.count(OLD)
# 그 문장의 SELECT 첫 줄 (본문 전체에서 유일한 형태)
SEL_OLD = "\t\t\t\tSELECT A.DATA_TYPE, NVL(A.DIVISION_ID, '-') ,NVL(A.VERSION_NO, '-') ,A.CUTOFF_TYPE ,A.CUTOFF_YYYYMMDD\n"
assert body.count(SEL_OLD) == 1, "SELECT 앵커 %d" % body.count(SEL_OLD)
SEL_NEW = ("\t\t\t\t-- DYNSAMP3 2026-08-10: JPPD(VIEW PUSHED PREDICATE) 차단 — B(AMT)를 1회 산출 후 해시조인.\n"
           "\t\t\t\tSELECT /*+ LEADING(A B) USE_HASH(B) NO_MERGE(A) NO_MERGE(B) NO_PUSH_PRED(B) */"
           " A.DATA_TYPE, NVL(A.DIVISION_ID, '-') ,NVL(A.VERSION_NO, '-') ,A.CUTOFF_TYPE ,A.CUTOFF_YYYYMMDD\n")
patched = body.replace(SEL_OLD, SEL_NEW)
MARKS = {"AUTHUNION 2026-08-09": 1, "20260805 MERGE-ON 파리티 복원": 1, "PIVOTSEL 2026-08-10": 1,
         "PRODUCTDETAIL 2026-08-10": 2, "M.CALC_YN = '-'": 12, "RPTGRP-STUB 2026-08-10": 14,
         "NVL(d_Result_Date, '-')": 14, "SEQGRP 2026-08-10": 3, "ETCDEL 2026-08-10": 1,
         "DYNSAMP 2026-08-10": 3, "DYNSAMP2 2026-08-10": 1, "DYNSAMP3 2026-08-10": 1}
for m, k in MARKS.items():
    assert patched.count(m) == k, "마커 %s %d≠%d" % (m, patched.count(m), k)
assert len(patched.splitlines()) - len(body.splitlines()) == 1
io.open(OUT / "PKG_DMF0044_BODY_DYNSAMP3_20260810.sql", "w", encoding="utf-8").write(patched)
print("patch OK (+1행, 마커 12종 검증) — 배포")
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 300")
cur.execute(patched.rstrip().rstrip("/").rstrip())
cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS "
            "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1")
for r in cur.fetchall():
    print(" ", r[0], r[1])
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'")
print("  errors =", cur.fetchone()[0])
con.close()
