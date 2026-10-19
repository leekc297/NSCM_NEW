"""GAP 377 — DMF0053 Bucket Only Weekly 주 합계 보완 (사내 ZIOUI1). AS-IS DMF0053_GET_SPREAD_TITLE / DMF0053_GET_CUST_FCST_WATERFALL 파리티.

T1~T4 머리글 P_DMF0053_GET_SPREAD_TITLE (사용자설정·기본 2분기 각 1 = 각 2건)
  T1 기간 칸 폭: ONLY_WEEKLY 100, 그 외 50
  T2 월별 주 칸(W_ + 월 + 주차): ONLY_WEEKLY 제외
  T3 월 칸(M_): ONLY_WEEKLY 제외 + T4 ONLY_WEEKLY 주 칸(W_ + 기간 내 마지막 날 월 + 주차, 대분류 'MM.DD ~ MM.DD', 정렬 마지막 날||'21')
G1~G2 조회 P_DMF0053_GET_CUST_FCST_WATERFALL 동적 SQL (각 1건)
  G1 BASIS_YYYYMMWW = 그 ISO 주의 기간 내 마지막 날 월 + 주차 (AS-IS #CALENDAR) — 날짜별 월 사용 폐기
  G2 위 키를 주는 CW 인라인 뷰 LEFT JOIN (CAL 조인·다른 Bucket 무영향)

사용: python apply_corp.py plan | apply | rollback
"""
import os, sys, datetime, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = "SCM_MGR", "PKG_DMF0053", "PACKAGE BODY"
MARK = "GAP377 2026-10-15"
M = f"[{MARK}]"

T1_OLD = "                     , '' AS FIXED_FLAG, 50 AS COLUMN_WIDTH\n"
T1_NEW = f"                     , '' AS FIXED_FLAG, CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 100 ELSE 50 END AS COLUMN_WIDTH  --{M} AS-IS width\n"
T2_OLD = ("                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD\n"
          "                         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME\n")
T2_NEW = ("                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD\n"
          f"                           AND P_BUCKET <> 'ONLY_WEEKLY'  --{M}\n"
          "                         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME\n")
T3_OLD = ("                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD\n"
          "                         GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME\n"
          "                       ) T\n")
T3_NEW = ("                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD\n"
          f"                           AND P_BUCKET <> 'ONLY_WEEKLY'  --{M}\n"
          "                         GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME\n"
          "                        UNION ALL\n"
          f"                        --{M} ONLY_WEEKLY: one column per ISO week (AS-IS C20220620-000567)\n"
          "                        SELECT 'W_' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 1, 6) || A.ISO_WEEK AS COLUMN_NAME\n"
          "                             , A.WEEK_NAME AS COLUMN_LABEL_NAME\n"
          "                             , A.WEEK_NAME AS SMALL_CLASS_LABEL_NAME\n"
          "                             , SUBSTR(MIN(A.BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MIN(A.BASIS_YYYYMMDD), 7, 2)\n"
          "                               || ' ~ ' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 7, 2) AS LARGE_CLASS_LABEL_NAME\n"
          "                             , '' AS DAY_CODE\n"
          "                             , TO_NUMBER(MAX(A.BASIS_YYYYMMDD) || '21') AS SORT_ORDER_NO\n"
          "                          FROM SCM_SYS_CALENDAR_M A\n"
          "                         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD\n"
          "                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD\n"
          "                           AND P_BUCKET = 'ONLY_WEEKLY'\n"
          "                         GROUP BY A.ISO_YYYYWW, A.ISO_WEEK, A.WEEK_NAME\n"
          "                       ) T\n")
G1_OLD = "         , SUBSTR(CAL.BASIS_YYYYMM, 1, 6) || CAL.ISO_WEEK AS BASIS_YYYYMMWW\n"
G1_NEW = f"         , CW.BASIS_YYYYMMWW AS BASIS_YYYYMMWW  /* {M} AS-IS #CALENDAR week key */\n"
G2_OLD = "      JOIN SCM_SYS_CALENDAR_M CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD\n"
G2_NEW = (G2_OLD +
          f"      /* {M} week key = month of the last in-period day of the ISO week + ISO_WEEK (AS-IS #CALENDAR) */\n"
          "      LEFT OUTER JOIN ( SELECT ISO_YYYYWW, ISO_WEEK, SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK AS BASIS_YYYYMMWW\n"
          "                          FROM SCM_SYS_CALENDAR_M\n"
          "                         WHERE BASIS_YYYYMMDD BETWEEN ''' || P_FROM_YYYYMMDD || ''' AND ''' || P_TO_YYYYMMDD || '''\n"
          "                         GROUP BY ISO_YYYYWW, ISO_WEEK ) CW ON CAL.ISO_YYYYWW = CW.ISO_YYYYWW AND CAL.ISO_WEEK = CW.ISO_WEEK\n")
OPS = [("T1", T1_OLD, T1_NEW, 2), ("T2", T2_OLD, T2_NEW, 2), ("T3", T3_OLD, T3_NEW, 2), ("G1", G1_OLD, G1_NEW, 1), ("G2", G2_OLD, G2_NEW, 1)]
MARK_N = 2 + 2 + 2 * 2 + 1 + 1   # 마커 출현 줄 수


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
    print("BEFORE LAST_DDL/STATUS", meta, "lines", len(base.splitlines()))
    stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    if mode in ("plan", "apply"):
        assert base.count(MARK) == 0, "이미 적용됨(마커 존재)"
        tobe = apply_ops(base)
        assert tobe.count(MARK) == MARK_N, f"마커 {tobe.count(MARK)} != {MARK_N}"
        assert rollback_ops(tobe) == base, "원복 시뮬레이션 불일치"
        open(os.path.join(HERE, f"PKG_DMF0053_BODY.ASIS_{stamp}.sql"), "w", encoding="utf-8", newline="").write(base)
        open(os.path.join(HERE, f"PKG_DMF0053_BODY.TOBE_{stamp}.sql"), "w", encoding="utf-8", newline="").write(tobe)
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
