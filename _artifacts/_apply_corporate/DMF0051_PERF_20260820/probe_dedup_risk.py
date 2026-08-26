# -*- coding: utf-8 -*-
"""GT_DM51_SCM_CITY 중복제거의 값 영향 전수 스윕 (원장 전체 × 전 division, set-based).

G 조인 조건이 성립하는 원장 행이 1건이라도 있으면 dedup 은 SUM 을 바꾼다.
매칭 0 이면 dedup 은 전 구간에서 값 무영향(=등가).
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
    cols = [c[0] for c in cur.description]
    print(" | ".join(cols))
    for r in cur.fetchall():
        print(" | ".join("" if x is None else str(x) for x in r))


# G 의 논리내용 = SCM_MST_SITE(div,site) ⋈ CITY ⋈ COUNTRY. 중복배수는 원장 행수.
# 조인 성립 여부 = (div40: 원장 PROJECT_CODE / 그외: 원장 END_CUSTOMER) = SITE.END_CUSTOMER
#                 AND SITE_ITEM.DEPT_ID(=C.DEPT_ID) = SITE.DEPT_ID
# C.DEPT_ID 는 GT_DM51_SCM_MST_SITE_ITEM.DEPT_ID = SSO_USER_INFO 로부터 유도 → 원천 조합으로 근사 전수.
q("① 키 등식만 (END_CUSTOMER 축) — CURRENT 원장 전체", """
WITH S AS (SELECT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER, DEPT_ID FROM SCM_MGR.SCM_MST_SITE)
SELECT A.DIVISION_ID,
       COUNT(*) LEDGER_ROWS,
       SUM(CASE WHEN S.END_CUSTOMER IS NOT NULL THEN 1 ELSE 0 END) SITE_MATCH,
       SUM(CASE WHEN S.END_CUSTOMER = CASE WHEN A.DIVISION_ID='40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
                THEN 1 ELSE 0 END) ENDCUST_EQ
  FROM SCM_MGR.DM_PLN_BP_FCST A
  LEFT JOIN S ON S.DIVISION_ID=A.DIVISION_ID AND S.SCM_SITE_ID=A.SCM_SITE_ID
 GROUP BY A.DIVISION_ID ORDER BY 1""")

q("② 동일 축 — CUTOFF 원장(_C) 전체", """
WITH S AS (SELECT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER, DEPT_ID FROM SCM_MGR.SCM_MST_SITE)
SELECT A.DIVISION_ID,
       COUNT(*) LEDGER_ROWS,
       SUM(CASE WHEN S.END_CUSTOMER = CASE WHEN A.DIVISION_ID='40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
                THEN 1 ELSE 0 END) ENDCUST_EQ
  FROM SCM_MGR.DM_PLN_BP_FCST_C A
  LEFT JOIN S ON S.DIVISION_ID=A.DIVISION_ID AND S.SCM_SITE_ID=A.SCM_SITE_ID
 GROUP BY A.DIVISION_ID ORDER BY 1""")

q("③ END_CUSTOMER 값역 대조 (SITE 쪽 vs 원장 PROJECT_CODE 쪽) div40", """
SELECT (SELECT COUNT(DISTINCT END_CUSTOMER) FROM SCM_MGR.SCM_MST_SITE WHERE DIVISION_ID='40') SITE_ENDCUST_NDV,
       (SELECT COUNT(DISTINCT PROJECT_CODE) FROM SCM_MGR.DM_PLN_BP_FCST WHERE DIVISION_ID='40') LEDGER_PROJ_NDV,
       (SELECT COUNT(*) FROM (SELECT DISTINCT END_CUSTOMER V FROM SCM_MGR.SCM_MST_SITE WHERE DIVISION_ID='40'
                              INTERSECT
                              SELECT DISTINCT PROJECT_CODE FROM SCM_MGR.DM_PLN_BP_FCST WHERE DIVISION_ID='40')) OVERLAP
  FROM DUAL""")
con.close()
