"""PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST — 원천 메저명 대소문자 비교 결함 수정 [E20260929-MAKECFCASE]

사용자 신고 (2026-09-29) : "클라우드 반영 후 CUSTOMER FCST EXCEL UPLOAD 했는데, CUST_FCST MEASURE 데이터가 생성되지 않습니다."

원인 :
  원천 조회 `MEASURE IN ('Customer Fcst', 'CUST_FCST_EDI')` — AS-IS(SP2:87976) 리터럴 그대로.
  AS-IS MSSQL 은 DB 기본 정렬 CI(대소문자 무시)라 반영 SP 가 쓰는 'Customer FCST' 와 매칭됐으나,
  Oracle 은 대소문자를 구분해 **Excel 업로드분('Customer FCST')이 CUST_FCST 합산에서 전부 빠짐** (EDI 분만 생성).
  사내 실측: 업로드 키 GM_US_BQN/A17LG8001/ACEN4065I-A1 'Customer FCST' 110/120/130 존재 · 같은 키 CUST_FCST 0건.
  AS-IS 주석 근거: "CUST_FCST = Customer FCST + CUST_FCST_EDI 임" (SP2:21185 외 다수).

수정 : `UPPER(MEASURE) IN ('CUSTOMER FCST', 'CUST_FCST_EDI')` — AS-IS CI 비교 파리티. 그 외 무변경.
호출처 : PKG_DMF0014.P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST · PR_DM_PLN_CUST_FCST_TO_MKT_FCST · PR_DM_DNM_EDI_CALLOFF_MKT_FCST
         (EDI 경로도 이제 Excel 분을 합산 — AS-IS 동일 동작)
usage: python apply_makecf.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

NAME, TYP = "PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST", "PROCEDURE"
ASIS = HERE / "00_BACKUP_ASIS" / f"{NAME}.PRE_MAKECF.sql"
TOBE = HERE / "01_APPLY" / f"{NAME}.MAKECF.sql"
TAG = "E20260929-MAKECFCASE"

OLD = "               AND MEASURE IN ('Customer Fcst', 'CUST_FCST_EDI')\n"
NEW = ("               AND UPPER(MEASURE) IN ('CUSTOMER FCST', 'CUST_FCST_EDI')   /*[" + TAG + "] AS-IS MSSQL CI 비교 파리티 —\n"
       "                                                                             반영 SP 가 쓰는 'Customer FCST'(Excel 분)가 대소문자 차이로 누락되던 결함*/\n")


def fetch(cur):
    # FRESH-GATE: 항상 DB 에서 새로 읽은 원문 기준
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=NAME, t=TYP)
    return "".join(r[0] for r in cur.fetchall())


def ddl(text):
    head, rest = text.split("\n", 1)
    head = re.sub(r'(?i)^\s*PROCEDURE\s+"?\w+"?', f'CREATE OR REPLACE PROCEDURE SCM_MGR."{NAME}"', head, count=1)
    return head + "\n" + rest


def body_of(f):
    t = f.read_text(encoding="utf-8")
    return re.sub(r"\n/\s*$", "", t[t.index("CREATE OR REPLACE"):].rstrip())


def status(cur):
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
    return cur.fetchone()


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL"); assert cur.fetchone()[0].upper() == "ZIOUI1", "대상 DB 가 ZIOUI1 아님"
    if mode == "backup":
        src = fetch(cur)
        assert TAG not in src, "이미 반영"
        assert src.count(OLD) == 1, f"앵커 {src.count(OLD)}회 (기대 1)"
        patched = src.replace(OLD, NEW)
        stamp = (f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={status(cur)[1]} "
                 f"FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1\n"
                 f"-- [{TAG}] 원천 메저 대소문자 무시 비교 (Customer FCST 누락 수정)\n"
                 "SET DEFINE OFF\nSET SQLBLANKLINES ON\n")
        ASIS.parent.mkdir(parents=True, exist_ok=True); TOBE.parent.mkdir(parents=True, exist_ok=True)
        ASIS.write_text(stamp + ddl(src).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        TOBE.write_text(stamp + ddl(patched).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        print("backup ok — 1곳 치환")
    elif mode == "apply":
        # FRESH-GATE: 적용 직전 DB 원문 == 백업본
        assert ddl(fetch(cur)).rstrip() == body_of(ASIS), "FRESH-GATE 실패: 백업 이후 DB 원문 변경 — 중단"
        cur.execute(body_of(TOBE))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=NAME, t=TYP)
        errs = cur.fetchall()
        print(NAME, status(cur), "errors", len(errs), "applied==TOBE", ddl(fetch(cur)).rstrip() == body_of(TOBE))
        for x in errs[:10]: print("  ", x)
        # 의존 객체 재컴파일 확인
        cur.execute("SELECT D.NAME, O.STATUS FROM USER_DEPENDENCIES D JOIN USER_OBJECTS O ON O.OBJECT_NAME=D.NAME AND O.OBJECT_TYPE=D.TYPE WHERE D.REFERENCED_NAME=:n", n=NAME)
        print("dependents", cur.fetchall())
    elif mode == "restore":
        cur.execute(body_of(ASIS)); print("restored", status(cur))


if __name__ == "__main__":
    main()
