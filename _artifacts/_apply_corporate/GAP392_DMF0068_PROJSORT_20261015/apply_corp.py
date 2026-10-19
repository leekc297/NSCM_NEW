"""GAP 392 — DMF0068 Demand Manager 조회 결과·Project 선택 목록 정렬 = AS-IS 대소문자 무시 정렬 (사내 ZIOUI1).

원인: AS-IS DB 콜레이션 Latin1_General_CI_AS(대소문자 무시) → ORDER BY 문구는 AS-IS 와 같아도 Oracle(BINARY)은 대문자 우선.
      (예: AS-IS Bosch → Boston Dynamics → BRP → BW.Akasol / TO-BE BRP → BW.Akasol → Bosch → Boston Dynamics)
L1 룩업 P_DMF0068_GET_LOOKUPPROJECT (Project 셀 콤보)           ORDER BY SEGMENT1 → ORDER BY UPPER(D.SEGMENT1), D.SEGMENT1   (1건)
O1 조회 P_DMF0068_GET_ORDERLIST 동적 SQL (SALES_PLAN·BIZ_PLAN 2분기) ORDER BY B.PROJECT_NAME → UPPER(B.PROJECT_NAME), B.PROJECT_NAME (2건)
보조키(원래 값)는 대소문자만 다른 값의 순서를 고정한다. 나머지 정렬키(수주기간 시작·MEASURE)와 SP 결과·원장·메타·FE 무변경.

사용: python apply_corp.py plan | apply | rollback
"""
import os, sys, datetime, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = "SCM_MGR", "PKG_DMF0068", "PACKAGE BODY"
MARK = "GAP392 2026-10-15"
M = f"[{MARK}]"

L1_OLD = ("        WHERE D.LOOKUP_TYPE = 'PROJECT_MODEL_MAPPING'\n"
          "        ORDER BY SEGMENT1;\n")
L1_NEW = ("        WHERE D.LOOKUP_TYPE = 'PROJECT_MODEL_MAPPING'\n"
          f"        ORDER BY UPPER(D.SEGMENT1), D.SEGMENT1;  --{M} AS-IS CI collation order\n")
O1_OLD = "            'ORDER BY B.PROJECT_NAME, NVL(ORDERSTART, ''999999''), B.MEASURE';\n"
O1_NEW = f"            'ORDER BY UPPER(B.PROJECT_NAME), B.PROJECT_NAME, NVL(ORDERSTART, ''999999''), B.MEASURE';  --{M} AS-IS CI collation order\n"
OPS = [("L1", L1_OLD, L1_NEW, 1), ("O1", O1_OLD, O1_NEW, 2)]
MARK_N = 1 + 2   # 마커 출현 줄 수


def apply_ops(src):
    for nm, o, n, c in OPS:
        assert src.count(o) == c, f"{nm} 매칭 {src.count(o)} != {c}"
        src = src.replace(o, n)
    return src


def rollback_ops(src):
    for nm, o, n, c in reversed(OPS):
        assert src.count(n) == c, f"{nm} 적용본 매칭 {src.count(n)} != {c}"
        src = src.replace(n, o)
    return src


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=TYP)
    return meta, "".join(r[0] for r in cur.fetchall())


def compile_body(cur, src):
    cur.execute("CREATE OR REPLACE " + src)
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
    print("BEFORE LAST_DDL/STATUS", meta, "lines", len(base.splitlines()), "CR", base.count("\r"))
    stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    if mode in ("plan", "apply"):
        assert base.count(MARK) == 0, "이미 적용됨(마커 존재)"
        tobe = apply_ops(base)
        assert tobe.count(MARK) == MARK_N, f"마커 {tobe.count(MARK)} != {MARK_N}"
        assert rollback_ops(tobe) == base, "원복 시뮬레이션 불일치"
        open(os.path.join(HERE, f"PKG_DMF0068_BODY.ASIS_{stamp}.sql"), "w", encoding="utf-8", newline="").write(base)
        open(os.path.join(HERE, f"PKG_DMF0068_BODY.TOBE_{stamp}.sql"), "w", encoding="utf-8", newline="").write(tobe)
        print("plan OK — 마커", MARK_N, "· 줄 수", len(base.splitlines()), "->", len(tobe.splitlines()))
        if mode == "plan":
            return
        meta2, now = fetch(cur)   # FRESH-GATE
        assert now == base and meta2 == meta, "FRESH-GATE 실패: 착수 후 DB 원문 변경"
        st, errs = compile_body(cur, tobe)
        if st != "VALID" or errs:
            print("COMPILE FAIL", st, errs[:10]); compile_body(cur, base); sys.exit("원문 복원함")
        meta3, after = fetch(cur)
        assert after == tobe, "적용본 != DB 원문"
        print("APPLIED", meta3)
    elif mode == "rollback":
        st, errs = compile_body(cur, rollback_ops(base))
        print("ROLLED BACK", st, errs[:5])
    cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS<>'VALID' AND OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES WHERE REFERENCED_OWNER='SCM_MGR' AND REFERENCED_NAME=:n)", n=NAME)
    print("dependent INVALID", cur.fetchall())


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "plan")
