"""GAP 358 검증 — DB 의 현재 PKG_DMF0049 BODY 에서 중복 검증 문장을 그대로 추출해 실행(세션 GTT 만 사용, 원장 무변경).

T1 자기연결 커버리지: GT 에 V004 원장 13,287행 그대로 적재 → 검증 문장의 JOIN 성립 원장 행 수 (GAP: 158 → 13,287 기대)
T2 중복 탐지(빈 값 키): COUNTRY_CODE NULL 원장 1행의 키를 GT 에 2행 적재 → v_chk (보완 전 0 = 누락, 보완 후 1)
T3 대조(빈 값 없는 키): 12키 모두 값 있는 원장 1행의 키를 GT 에 2행 → v_chk 보완 전/후 모두 1
T4 비중복: COUNTRY_CODE NULL 원장 1행 키 GT 1행 → v_chk 0 (오탐 없음)
"""
import sys, re, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info

V, DIV = "R_S_20260823_V004", "40"
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print("DB", cur.fetchone())
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0049' AND OBJECT_TYPE='PACKAGE BODY'"); print("LAST_DDL", cur.fetchone()[0])
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY' ORDER BY LINE")
body = "".join(r[0] for r in cur.fetchall())
m = re.search(r"SELECT COUNT\(\*\) INTO v_chk FROM \((.*?)\n    \);", body, re.S)
assert m and body.count("SELECT COUNT(*) INTO v_chk FROM (") == 1
inner = m.group(1).replace("v_division_id", ":div").replace("v_version_no", ":ver")
print("patched" if "GAP358 2026-10-15" in body else "original", "statement")
CHK = f"SELECT COUNT(*) FROM ({inner}\n)"
COV = re.sub(r"SELECT A\.VERSION_NO\s", "SELECT DISTINCT A.ROWID RID ", inner, count=1)
COV = "SELECT COUNT(*) FROM (" + re.sub(r"\n\s*GROUP BY.*", "", COV, flags=re.S) + ")"
COLS = "VERSION_NO,DIVISION_ID,DEPARTMENT_ID,DEPT_ID,ITEM_ID,MEASURE,YYYYMMDD,CURRENCY,COMPANY_ID,END_CUST_REPORT,CUST_REPORT,PRODUCT_GROUP,COUNTRY_CODE"


def load(where, times):
    cur.execute("DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST")
    for _ in range(times):
        cur.execute(f"INSERT INTO SCM_MGR.GT_DMF0049_RESULTS_MST ({COLS},ACTIVE_FLAG,QTY) SELECT {COLS},'U','1' FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d {where}", v=V, d=DIV)


def run(sql):
    cur.execute(sql, div=DIV, ver=V); return cur.fetchone()[0]


load("", 1); print("T1 coverage join rows:", run(COV), "/ GT", run("SELECT COUNT(*) FROM SCM_MGR.GT_DMF0049_RESULTS_MST WHERE :div IS NOT NULL AND :ver IS NOT NULL"))
one_null = "AND ROWID=(SELECT MIN(ROWID) FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d AND COUNTRY_CODE IS NULL)"
one_full = "AND ROWID=(SELECT MIN(ROWID) FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d AND COUNTRY_CODE IS NOT NULL AND CUST_REPORT IS NOT NULL)"
load(one_null, 2); print("T2 dup(empty key) v_chk:", run(CHK))
load(one_full, 2); print("T3 dup(full key)  v_chk:", run(CHK))
load(one_null, 1); print("T4 single(empty)  v_chk:", run(CHK))
cn.rollback()
