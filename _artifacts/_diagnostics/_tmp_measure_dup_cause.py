# -*- coding: utf-8 -*-
"""GET_MEASURE 8배 중복 원인 확정 — EDIT_AUTH_V 조인이 행을 곱한다"""
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

print("== 원천 SCM_MST_SHEET_MEASURE (DMF0044 / MDF Reports / SalesAmt_*) ==")
cur.execute("""SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, DIVISION_ID
                 FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                WHERE PROGRAM_ID='DMF0044' AND SHEET_NAME='MDF Reports'
                  AND COLUMN_NAME IN ('SalesAmt_KRW','SalesAmt_LOC')
                ORDER BY SORT_ORDER_NO""")
rows = cur.fetchall()
for r in rows:
    print("  %-14s %-18s so=%-4s DIVISION_ID=%s" % r)
print("  원천 행수 =", len(rows), "(기대 2)")

print("\n== 사용자 편집권한 뷰 rows (minyonglee1 / DMF0044 / UNIT_TP_CD='D') ==")
cur.execute("""SELECT UNIT_ID, EDIT_YN FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID='minyonglee1' AND MNU_ID='DMF0044' AND UNIT_TP_CD='D'
                ORDER BY UNIT_ID""")
auth = cur.fetchall()
for r in auth:
    print("  UNIT_ID=%-10s EDIT_YN=%s" % r)
print("  권한 행수 =", len(auth))

print("\n== 조인 결과 재현 (현행 SQL) ==")
cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_MEASURE T1
                INNER JOIN (SELECT * FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
                             WHERE USER_ID='minyonglee1' AND MNU_ID='DMF0044' AND UNIT_TP_CD='D') T2
                   ON T2.UNIT_ID IN (SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID,'[^,]+',1,LEVEL))
                                       FROM DUAL CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID,'[^,]+',1,LEVEL) IS NOT NULL)
               WHERE T1.PROGRAM_ID='DMF0044' AND T1.SHEET_NAME='MDF Reports'
                 AND T1.COLUMN_NAME IN ('SalesAmt_KRW','SalesAmt_LOC')""")
print("  현행 반환 행수 =", cur.fetchone()[0], "(관측 16)")

print("\n== 정정안 재현 (EXISTS 필터 + MAX 스칼라) ==")
cur.execute("""SELECT T1.COLUMN_NAME, T1.COLUMN_LABEL_NAME,
                      NVL((SELECT MAX(T2.EDIT_YN) FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V T2
                            WHERE T2.USER_ID='minyonglee1' AND T2.MNU_ID='DMF0044' AND T2.UNIT_TP_CD='D'
                              AND T2.UNIT_ID IN (SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID,'[^,]+',1,LEVEL))
                                                   FROM DUAL CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID,'[^,]+',1,LEVEL) IS NOT NULL)),'N')
                 FROM SCM_MGR.SCM_MST_SHEET_MEASURE T1
                WHERE T1.PROGRAM_ID='DMF0044' AND T1.SHEET_NAME='MDF Reports'
                  AND T1.COLUMN_NAME IN ('SalesAmt_KRW','SalesAmt_LOC')
                  AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V T2
                               WHERE T2.USER_ID='minyonglee1' AND T2.MNU_ID='DMF0044' AND T2.UNIT_TP_CD='D'
                                 AND T2.UNIT_ID IN (SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID,'[^,]+',1,LEVEL))
                                                      FROM DUAL CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID,'[^,]+',1,LEVEL) IS NOT NULL))
                ORDER BY T1.SORT_ORDER_NO""")
fixed = cur.fetchall()
for r in fixed:
    print("  %-14s %-18s EDIT_YN=%s" % r)
print("  정정안 반환 행수 =", len(fixed), "(기대 2)")

print("\n== 같은 패턴(EDIT_AUTH_V INNER JOIN)을 쓰는 다른 SP ==")
cur.execute("""SELECT DISTINCT NAME FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND TYPE IN ('PACKAGE BODY','PROCEDURE')
                  AND INSTR(UPPER(TEXT),'SCM_ADM_USER_MNU_EDIT_AUTH_V')>0 ORDER BY NAME""")
for r in cur.fetchall():
    print("  ", r[0])
con.close()
