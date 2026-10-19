"""GAP 358 — DMF0049 저장 SP GDW 중복키 검사 연결 조건 12개 빈 값(NULL) 동등 비교 보완 (사내 ZIOUI1).

대상: SCM_MGR.PKG_DMF0049 BODY / P_DMF0049_SAVE_SALES_ETC_REPORT_C [E20250418-001567] 중복 검증 INNER JOIN.
AS-IS(MSSQL) `A.x = B.x` 는 ''='' 가 성립 → Oracle 에선 ''=NULL 이라 빈 값 행이 검사에서 빠짐(158/13,287).
보완: 12개 키(VERSION_NO 제외) 양변 NVL(x,'/') — 사용자 지시 2026-10-15 "NVL(x,'-') 는 NVL(x,'/') 로".

사용: python apply_corp.py plan | apply | rollback
"""
import os, sys, datetime, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = "SCM_MGR", "PKG_DMF0049", "PACKAGE BODY"
MARK = "GAP358 2026-10-15"
KEYS = ["DIVISION_ID", "DEPARTMENT_ID", "DEPT_ID", "ITEM_ID", "MEASURE", "YYYYMMDD", "CURRENCY",
        "COMPANY_ID", "END_CUST_REPORT", "CUST_REPORT", "PRODUCT_GROUP", "COUNTRY_CODE"]
HEAD_OLD = "          INNER JOIN SCM_MGR.GT_DMF0049_RESULTS_MST B\n                  ON A.VERSION_NO = B.VERSION_NO\n"
HEAD_NEW = ("          INNER JOIN SCM_MGR.GT_DMF0049_RESULTS_MST B\n"
            f"                  ON A.VERSION_NO = B.VERSION_NO  --[{MARK}] 12 keys: empty(NULL) equality NVL(x,'/') both sides (AS-IS MSSQL ''='' parity)\n")
OLD = HEAD_OLD + "".join(f"                 AND A.{k} = B.{k}\n" for k in KEYS)
NEW = HEAD_NEW + "".join(f"                 AND NVL(A.{k},'/') = NVL(B.{k},'/')\n" for k in KEYS)


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=TYP)
    return meta, "".join(r[0] for r in cur.fetchall())


def compile_body(cur, src):
    cur.execute("CREATE OR REPLACE " + src)  # oracledb: 컴파일 오류는 성공 경고로 반환 → 아래 상태 판정
    cur.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", o=OWNER, n=NAME, t=TYP)
    return st, cur.fetchall()


def main(mode):
    u, p, d = conn_info()
    cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','SERVICE_NAME'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
    print("DB", cur.fetchone())
    meta, base = fetch(cur)
    print("BEFORE LAST_DDL/STATUS", meta, "lines", len(base.splitlines()))
    stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    if mode in ("plan", "apply"):
        assert base.count(MARK) == 0, "이미 적용됨(마커 존재)"
        assert base.count(OLD) == 1, f"대상 블록 매칭 {base.count(OLD)} != 1 — 원문 변경 여부 확인"
        tobe = base.replace(OLD, NEW)
        open(os.path.join(HERE, f"PKG_DMF0049_BODY.ASIS_{stamp}.sql"), "w", encoding="utf-8", newline="").write(base)
        open(os.path.join(HERE, f"PKG_DMF0049_BODY.TOBE_{stamp}.sql"), "w", encoding="utf-8", newline="").write(tobe)
        print("plan OK — 변경 13줄(ON 줄 주석 1 + 12 키)")
        if mode == "plan":
            return
        # FRESH-GATE
        meta2, now = fetch(cur)
        assert now == base and meta2 == meta, "FRESH-GATE 실패: 착수 후 DB 원문 변경"
        st, errs = compile_body(cur, tobe)
        if st != "VALID" or errs:
            print("COMPILE FAIL", st, errs[:10]); compile_body(cur, base); sys.exit("원문 복원함")
        meta3, after = fetch(cur)
        assert after == tobe, "적용본 != DB 원문"
        print("APPLIED", meta3)
    elif mode == "rollback":
        assert base.count(NEW) == 1
        rb = base.replace(NEW, OLD)
        st, errs = compile_body(cur, rb)
        print("ROLLED BACK", st, errs[:5])
    cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS<>'VALID' AND OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES WHERE REFERENCED_OWNER='SCM_MGR' AND REFERENCED_NAME=:n)", n=NAME)
    print("dependent INVALID", cur.fetchall())


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "plan")
