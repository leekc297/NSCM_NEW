"""새 중복 검증(저장 후 모습) vs 현재 검증 — GT(세션 임시 테이블)만 채워 판정 비교. 원장 무변경."""
import sys, re, glob, datetime
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
import oracledb
import build_package as B
u,p,d = conn_info(); c = oracledb.connect(user=u,password=p,dsn=d); cur=c.cursor()
V, DIV, SEQ = 'R_S_20261002_V001_C', '40', 174
print("TEST AT", datetime.datetime.now().isoformat(timespec='seconds'), d)
base = open(sorted(glob.glob(r"C:/Projects/NSCM/_artifacts/_apply_corporate/DMF0049_DUPKEYMSG_20261028/PKG_DMF0049_BODY.ASIS_*.sql"))[-1], encoding='utf-8').read().split('\n')
old = "\n".join(base[1015:1040]).replace("SELECT COUNT(*) INTO v_chk FROM (", "SELECT COUNT(*) FROM (").rstrip().rstrip(';')
new = B.NEW1.split("SELECT COUNT(*) INTO v_chk FROM (")[1].split("-- [E20261028-DUPKEYMSG] NEW-END")[0].rstrip().rstrip(';').rstrip().rstrip(')')
new = "SELECT COUNT(*) FROM (" + new + ")"
def q(sql): return re.sub(r'\bv_division_id\b', ':div', re.sub(r'\bv_version_no\b', ':ver', sql))
OLD, NEW = q(old), q(new)
cols = "ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ, DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY, COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, MEASURE, YYYYMMDD, QTY"
def load(flag, seq_expr, cust="A.CUST_REPORT", extra_where=""):
    cur.execute(f"""INSERT INTO SCM_MGR.GT_DMF0049_RESULTS_MST ({cols})
      SELECT '{flag}', NULL, A.DIVISION_ID, A.VERSION_NO, {seq_expr}, A.DEPARTMENT_ID, A.DEPT_ID, {cust}, A.END_CUST_REPORT, A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT,
             A.PRODUCT_GROUP, A.ITEM_ID, A.PRODUCT_DETAILS, A.CURRENCY, A.COMPANY_ID, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.MEASURE, A.YYYYMMDD, TO_CHAR(A.QTY)
        FROM DM_PLN_SALES_ETC_REPORT_C A WHERE A.VERSION_NO=:v AND A.DIVISION_ID=:d AND A.DATA_SEQ=:s {extra_where}""", v=V, d=DIV, s=SEQ)
    return cur.rowcount
def judge(name, expect):
    cur.execute(OLD, div=DIV, ver=V); o = cur.fetchone()[0]
    cur.execute(NEW, div=DIV, ver=V); n = cur.fetchone()[0]
    ok = (n > 0) == expect
    print(f"{name:<60} 현재={o:>3}  신규={n:>3}  기대={'중복' if expect else '통과'}  {'PASS' if ok else 'FAIL'}")
    cur.execute("DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST")
cur.execute("DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST")
cur.execute("SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d AND DATA_SEQ=:s", v=V, d=DIV, s=SEQ); print("원장 세트 174 행수", cur.fetchone()[0])
load('I', "NULL"); judge("S1 기존 세트와 같은 키로 신규 세트 저장 (이번 증상)", True)
load('M', "TO_CHAR(A.DATA_SEQ)"); judge("S2 기존 세트를 그대로 수정 저장", False)
load('I', "NULL", cust="'ZZ_DUPTEST'"); judge("S3 다른 키(Cust. Report 변경)로 신규 세트 저장", False)
load('D', "TO_CHAR(A.DATA_SEQ)"); load('I', "NULL"); judge("S4 기존 세트 삭제 + 같은 키 신규 세트 (한 번에 저장)", False)
load('I', "NULL", cust="'ZZ_DUPTEST'"); load('I', "NULL", cust="'ZZ_DUPTEST'"); judge("S5 같은 키 신규 세트 2개를 한 번에 저장", True)
load('M', "TO_CHAR(A.DATA_SEQ)", cust="'ZZ_DUPTEST'"); judge("S6 기존 세트의 Cust.(Report) 를 다른 값으로 수정", False)
load('I', "NULL", extra_where="AND A.MEASURE='SalesAmt_LOC'"); judge("S7 기존 세트와 같은 키, 메저 1개만 신규 저장", True)
c.rollback()
cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DMF0049_RESULTS_MST"); print("GT 잔여", cur.fetchone()[0])
