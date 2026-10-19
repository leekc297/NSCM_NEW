"""DMF0003 VMIDIOJOIN — 40 조회 최종 동적 SQL 의 GT_DMF0003_VMI_DIO 조인을 키 등호 조인으로 (사내 ZIOUI1).

원인: P_DMF0003_GET_MKT_FCST_DATA 최종 동적 SQL(OPEN O_RC1 FOR V_SQL_TEXT) 의 VM 조인
        ON A.ITEM_ID = CASE WHEN '40' = '40' THEN VM.KEY_JOIN ELSE A.ITEM_ID END
       AND ( '40' = '40' OR A.SCM_SITE_ID = VM.KEY_JOIN )
      등호 오른쪽이 CASE 라 키 조인으로 인식되지 않음 → 해시 조인 불가 → 결과 75,254행마다 GT(183행) 전체 스캔(NESTED LOOPS)
      사내 실측 2026-10-16: 40 전체 Measure 41.7~43.8초 중 34.2초 · ASH 69 표본 중 68 이 이 줄(계획 41번).
조치(사용자 결정 2026-10-16 "1. 적용" = 현재 TO-BE 결과 유지): 40 일 때만 ON 절 문구를 'A.ITEM_ID = VM.KEY_JOIN' 으로 만든다.
      40 의미 = 기존과 동일(A.ITEM_ID = VM.KEY_JOIN AND 참). 40 외 사업부는 ELSE 분기에 원래 문구 그대로 → 생성 SQL 1바이트도 안 바뀜.
      같은 세션 대조: 1.3초 · 3,065행 · 결과 전체 동일.
범위: PKG_DMF0003 BODY 3줄(9411~9413). 원장·메타·FE·BE·GTT 무변경. 문구 전부 ASCII(클라우드 패치와 단일 원천).

사용: python apply_corp.py plan | apply | rollback
"""
import os, sys, datetime, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = "SCM_MGR", "PKG_DMF0003", "PACKAGE BODY"
MARK = "E20261016-VMIDIOJOIN"
M = f"[{MARK}]"

J1_OLD = ("        '  ON  A.ITEM_ID     = CASE WHEN ''' || P_DIVISION_ID || ''' = ''40'' THEN VM.KEY_JOIN ELSE A.ITEM_ID END' || CHR(10) ||\n"
          "        '  AND ( ''' || P_DIVISION_ID || ''' = ''40''  ' || CHR(10) ||\n"
          "        '        OR A.SCM_SITE_ID = VM.KEY_JOIN )' || CHR(10) ||\n")
J1_NEW = ("        CASE WHEN P_DIVISION_ID = '40'\n"
          f"             THEN '  ON  A.ITEM_ID     = VM.KEY_JOIN' || CHR(10)    --{M} 40 = item key equi-join (CASE-wrapped ON blocked hash join -> per-row full scan of GT). Same result. Other divisions: original text below\n"
          "             ELSE '  ON  A.ITEM_ID     = CASE WHEN ''' || P_DIVISION_ID || ''' = ''40'' THEN VM.KEY_JOIN ELSE A.ITEM_ID END' || CHR(10) ||\n"
          "                  '  AND ( ''' || P_DIVISION_ID || ''' = ''40''  ' || CHR(10) ||\n"
          "                  '        OR A.SCM_SITE_ID = VM.KEY_JOIN )' || CHR(10)\n"
          "        END ||\n")
OPS = [("J1", J1_OLD, J1_NEW, 1)]
MARK_N = 1   # 마커 출현 줄 수


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
