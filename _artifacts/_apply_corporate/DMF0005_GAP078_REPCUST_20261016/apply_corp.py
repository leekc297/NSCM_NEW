"""GAP 78 — DMF0005 Sales Site Project Model 조회 대표 Sold-To/Ship-To = AS-IS 와 같이 유효 여부(VALID_YN) 무관 (사내 ZIOUI1).

AS-IS 최신(운영 추출본 2026-09-17 modules.sql · 개발 DB LGCE_SCMDEV 라이브 2026-10-16) DMF0005_GET_SALES_SITE_MODEL_PRODUCTION
  40 분기 / 82 분기 / 81 분기 3곳 모두 SCM_MST_SITE_CUSTOMER 조인 = DIVISION_ID · SCM_SITE_ID · REP_YN = 'Y' (VALID_YN 조건 없음)
TO-BE PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION BASE 의 SC 조인에 'AND SC.VALID_YN = ''Y''' 가 있어
  대표 거래처가 무효(VALID_YN<>'Y')인 사이트는 Sold-To·Ship-To(+Description) 가 빈칸. 사내 영향 40 220 · 81 90 · 82 238 행.
조치: 해당 조건 1줄을 주석 처리(원문 보존). 대표 거래처 2건 이상 사이트 0 (사내 실측) → 행 수 불변.
범위: PKG_DMF0005 BODY 1줄. 원장·메타·FE·BE 무변경. 문구 ASCII(클라우드 패치와 단일 원천).

사용: python apply_corp.py plan | apply | rollback
"""
import os, sys, datetime, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = "SCM_MGR", "PKG_DMF0005", "PACKAGE BODY"
MARK = "GAP078 2026-10-16"
M = f"[{MARK}]"

V1_OLD = ("         AND SC.REP_YN = 'Y'\n"
          "         AND SC.VALID_YN = 'Y'\n")
V1_NEW = ("         AND SC.REP_YN = 'Y'\n"
          f"--       AND SC.VALID_YN = 'Y'    --{M} AS-IS: representative Sold-To/Ship-To regardless of VALID_YN (40/81/82 same)\n")
OPS = [("V1", V1_OLD, V1_NEW, 1)]
MARK_N = 1


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
    try:
        cur.execute("CREATE OR REPLACE " + src)
    except oracledb.DatabaseError as e:   # 컴파일 오류 동반 생성(ORA-24344)도 예외 → 아래 STATUS 로 판정
        print("CREATE 예외", str(e)[:200])
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
        open(os.path.join(HERE, f"{NAME}_BODY.ASIS_{stamp}.sql"), "w", encoding="utf-8", newline="").write(base)
        open(os.path.join(HERE, f"{NAME}_BODY.TOBE_{stamp}.sql"), "w", encoding="utf-8", newline="").write(tobe)
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
