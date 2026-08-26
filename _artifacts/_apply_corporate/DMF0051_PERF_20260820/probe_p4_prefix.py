# -*- coding: utf-8 -*-
"""P4 후보 사전평가 — ORI_V 선행축소(prefix 12자)로 실제로 줄어드는가? (읽기 전용, set-based)

⚠ 축소 기준은 반드시 SUBSTR(ITEM_ID,1,12) prefix — _B_V 가 prefix 로 MAX 집계하므로
   정확 ITEM_ID 축소는 MAX 그룹을 바꿔 값 등가를 깬다 (DMF0022 작업자 경고).
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(t, sql):
    print(f"\n=== {t} ===")
    cur.execute(sql)
    print(" | ".join(c[0] for c in cur.description))
    for r in cur.fetchall():
        print(" | ".join("" if x is None else str(x) for x in r))


q("div40 ITEM_SN 총량 vs CURRENT 원장 prefix 로 축소 시", """
WITH SN AS (SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN WHERE DIVISION_ID='40'),
     PFX AS (SELECT DISTINCT SUBSTR(ITEM_ID,1,12) P FROM SCM_MGR.DM_PLN_BP_FCST WHERE DIVISION_ID='40')
SELECT (SELECT COUNT(*) FROM SN) SN_ROWS,
       (SELECT COUNT(*) FROM PFX) LEDGER_PREFIXES,
       (SELECT COUNT(*) FROM SN JOIN PFX ON SUBSTR(SN.ITEM_ID,1,12)=PFX.P) SN_KEPT
  FROM DUAL""")

q("div40 ITEM_SN vs BP 버전 1본 prefix 로 축소 시", """
WITH SN AS (SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN WHERE DIVISION_ID='40'),
     PFX AS (SELECT DISTINCT SUBSTR(ITEM_ID,1,12) P FROM SCM_MGR.DM_PLN_BP_FCST_C
              WHERE DIVISION_ID='40' AND VERSION_NO='BP_M_20260810_V001')
SELECT (SELECT COUNT(*) FROM SN) SN_ROWS,
       (SELECT COUNT(*) FROM PFX) LEDGER_PREFIXES,
       (SELECT COUNT(*) FROM SN JOIN PFX ON SUBSTR(SN.ITEM_ID,1,12)=PFX.P) SN_KEPT
  FROM DUAL""")

q("div81 (RAW 0행 케이스) — 축소 시 0행이 되는지", """
WITH SN AS (SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN WHERE DIVISION_ID='81'),
     PFX AS (SELECT DISTINCT SUBSTR(ITEM_ID,1,12) P FROM SCM_MGR.DM_PLN_BP_FCST
              WHERE DIVISION_ID='81' AND YYYYMM BETWEEN '202608' AND '202702')
SELECT (SELECT COUNT(*) FROM SN) SN_ROWS,
       (SELECT COUNT(*) FROM PFX) LEDGER_PREFIXES,
       (SELECT COUNT(*) FROM SN JOIN PFX ON SUBSTR(SN.ITEM_ID,1,12)=PFX.P) SN_KEPT
  FROM DUAL""")

q("ORI_V 소비처가 필요로 하는 범위 확인 — RAW_DATA ITEM_ID 의 prefix 가 SN 에 없을 수 있나", """
WITH PFX AS (SELECT DISTINCT SUBSTR(ITEM_ID,1,12) P FROM SCM_MGR.DM_PLN_BP_FCST WHERE DIVISION_ID='40'),
     SNP AS (SELECT DISTINCT SUBSTR(ITEM_ID,1,12) P FROM SCM_MGR.SCM_MST_ITEM_SN WHERE DIVISION_ID='40')
SELECT (SELECT COUNT(*) FROM PFX) LEDGER_PFX,
       (SELECT COUNT(*) FROM (SELECT P FROM PFX INTERSECT SELECT P FROM SNP)) BOTH,
       (SELECT COUNT(*) FROM (SELECT P FROM PFX MINUS SELECT P FROM SNP)) LEDGER_ONLY
  FROM DUAL""")
con.close()
