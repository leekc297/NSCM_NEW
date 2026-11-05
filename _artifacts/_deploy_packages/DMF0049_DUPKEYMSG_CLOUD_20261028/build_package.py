"""DMF0049_DUPKEYMSG 클라우드 패키지 생성기 — 새 중복 검증 문장(AI = 저장 후 모습)을 한 곳에서 만들어
10_APPLY / 99_ROLLBACK SQL 과 시나리오 시험(scenario_test.py)이 같은 문장을 쓰게 한다.

  python build_package.py           → A_DB/10_APPLY_DUPKEYMSG_PATCH.sql, A_DB/99_ROLLBACK_DUPKEYMSG_PATCH.sql 생성
  SOURCE-FRESH 스탬프 = 사내 PKG_DMF0049 BODY 를 이 실행 시점에 조회한 LAST_DDL (FRESH-GATE 확인용 기록)
"""
import os, sys, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

HERE = os.path.dirname(os.path.abspath(__file__))
MARK = "[E20261028-DUPKEYMSG]"
ORIG = "--" + MARK + "ORIG "          # 원래 줄을 이 접두로 주석 보존 (원복 시 접두만 제거)

# 저장 후 모습: 원장 중 이번 저장분이 같은 PK 로 바꾸거나 지우는 행은 빼고 + 저장분 중 삭제(D)가 아닌 행
AI = """SELECT A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.ITEM_ID, A.MEASURE, A.YYYYMMDD, A.CURRENCY
     , A.COMPANY_ID, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP, A.COUNTRY_CODE, 'A' AS SRC
  FROM DM_PLN_SALES_ETC_REPORT_C A
 WHERE A.DIVISION_ID = v_division_id AND A.VERSION_NO = v_version_no
   AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                     WHERE B.DATA_SEQ = TO_CHAR(A.DATA_SEQ) AND B.MEASURE = A.MEASURE AND B.YYYYMMDD = A.YYYYMMDD )
UNION ALL
SELECT B.VERSION_NO, B.DIVISION_ID, B.DEPARTMENT_ID, B.DEPT_ID, B.ITEM_ID, B.MEASURE, B.YYYYMMDD, B.CURRENCY
     , B.COMPANY_ID, B.END_CUST_REPORT, B.CUST_REPORT, B.PRODUCT_GROUP, B.COUNTRY_CODE, 'B' AS SRC
  FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
 WHERE NVL(B.ACTIVE_FLAG, '/') <> 'D'"""

GRP = """GROUP BY NVL(X.VERSION_NO,'/'), NVL(X.DIVISION_ID,'/'), NVL(X.DEPARTMENT_ID,'/'), NVL(X.DEPT_ID,'/'), NVL(X.ITEM_ID,'/')
       , NVL(X.MEASURE,'/'), NVL(X.YYYYMMDD,'/'), NVL(X.CURRENCY,'/'), NVL(X.COMPANY_ID,'/'), NVL(X.END_CUST_REPORT,'/')
       , NVL(X.CUST_REPORT,'/'), NVL(X.PRODUCT_GROUP,'/'), SCM_MGR.FN_GET_COUNTRY_KR_NAME(X.COUNTRY_CODE)
HAVING COUNT(*) > 1 AND MAX(X.SRC) = 'B'"""


def indent(txt, n):
    return "\n".join((" " * n + l) if l else l for l in txt.split("\n"))


HEAD = (f"-- {MARK} NEW-BEGIN 2026.10.28 저장 후 모습(원장에 남을 행 + 이번 저장분) 기준 12키 중복 검증\n"
        "--   구 검증(원장 x 저장분 COUNT>1)은 같은 세트를 두 번째 저장할 때 1건으로 세어 통과 -> MOBILE 병합 검증 메시지로 넘어갔다.\n"
        "--   키 중복 메시지가 먼저 나오도록 변경(사용자 요청 2026-10-28). 이번 저장분이 낀 묶음만 판정.")
TAIL = f"-- {MARK} NEW-END"

# 블록1: 중복 건수
NEW1 = indent(HEAD, 4) + "\n" + indent(
    "SELECT COUNT(*) INTO v_chk FROM (\n"
    "    SELECT 1\n"
    "      FROM (\n" + indent(AI, 12) + "\n"
    "           ) X\n" + indent(GRP, 5) + "\n"
    ");", 4) + "\n" + indent(TAIL, 4)

# 블록2: 첫 중복 묶음 키 값 (안내문용) — 바깥 SELECT 의 T.* 컬럼명 유지
NEW2 = indent(HEAD, 14) + "\n" + indent(
    "FROM ( SELECT MAX(X.VERSION_NO) VERSION_NO, MAX(X.DIVISION_ID) DIVISION_ID, MAX(X.DEPARTMENT_ID) DEPARTMENT_ID\n"
    "            , MAX(X.DEPT_ID) DEPT_ID, MAX(X.ITEM_ID) ITEM_ID, MAX(X.MEASURE) MEASURE, MAX(X.YYYYMMDD) YYYYMMDD\n"
    "            , MAX(X.CURRENCY) CURRENCY, MAX(X.COMPANY_ID) COMPANY_ID, MAX(X.END_CUST_REPORT) END_CUST_REPORT\n"
    "            , MAX(X.CUST_REPORT) CUST_REPORT, MAX(X.PRODUCT_GROUP) PRODUCT_GROUP\n"
    "            , SCM_MGR.FN_GET_COUNTRY_KR_NAME(MAX(X.COUNTRY_CODE)) AS COUNTRY_KR_NAME\n"
    "         FROM (\n" + indent(AI, 15) + "\n"
    "              ) X\n" + indent(GRP, 8) + " ) T", 14) + "\n" + indent(TAIL, 14)


def plsql_lit(s):
    assert "~]" not in s and "\t" not in s
    return "q'~" + s + "~'"


def build():
    import oracledb
    from ora import conn_info
    u, p, d = conn_info()
    cur = oracledb.connect(user=u, password=p, dsn=d).cursor()
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0049' AND OBJECT_TYPE='PACKAGE BODY'")
    last_ddl = cur.fetchone()[0]
    fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    apply_sql = open(os.path.join(HERE, "_tpl_10_apply.sql"), encoding="utf-8").read()
    apply_sql = (apply_sql.replace("{{STAMP}}", f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0049 PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 기준본 대조 · 클라우드는 자기 USER_SOURCE 를 패치)")
                          .replace("{{NEW1}}", plsql_lit(NEW1 + "\n"))
                          .replace("{{NEW2}}", plsql_lit(NEW2 + "\n")))
    assert "{{" not in apply_sql
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    open(os.path.join(HERE, "A_DB", "10_APPLY_DUPKEYMSG_PATCH.sql"), "w", encoding="utf-8", newline="\n").write(apply_sql)
    print("built 10_APPLY  LAST_DDL", last_ddl, "FETCHED", fetched)


if __name__ == "__main__":
    build()
