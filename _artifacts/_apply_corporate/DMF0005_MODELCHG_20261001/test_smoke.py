"""P_DMF0005_SAVE_MODEL_CHANGE_POPUP 실행 검증 (사내 ZIOUI1) — 실데이터 무변경 원칙
  python test_smoke.py candidates   # 테스트 쌍 후보 (참조 0 쌍 / 참조 있는 쌍)
  python test_smoke.py validate     # 검증 7종 — DML 전 중단 경로
  python test_smoke.py zero B A     # 참조 0 쌍 성공 경로 (호출 직전 38 테이블 참조 0 assert)
  python test_smoke.py dryupdate B A # SP 와 같은 동적 UPDATE 문장을 익명 블록에서 실행 후 ROLLBACK
"""
import sys, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

TABLES = [  # (테이블, DIVISION 40 필터) — AS-IS 순서
    ("DM_ANL_KPI_RTF_DEMAND", 1), ("DM_ANL_KPI_RTF_SALES", 1), ("DM_ANL_KPI_SALES_ACCURACY", 1), ("DM_ANL_KPI_SUMMARY", 1),
    ("DM_DNM_EDI_CALLOFF_ITEM", 1), ("DM_DNM_SALES_RESULT_IF", 1), ("DM_HI_CUST_FCST_INPUT", 1), ("DM_HI_MKT_FCST_CHANGE", 1),
    ("DM_HI_SALES_INPUT", 1), ("DM_HI_SITE_ITEM_MAPPING", 1), ("DM_HI_SITE_ITEM_MAPPING_ROWDATA", 1),
    ("DM_MST_BUCKET_CONVERSION", 1), ("DM_MST_BUCKET_CONVERSION_H", 1), ("DM_MST_CAPACITY_ALLOCATION", 1),
    ("DM_MST_CAPACITY_ALLOCATION_H", 1), ("DM_MST_CUSTOMER_MODEL", 1), ("DM_MST_CUSTOMER_MODEL_H", 1),
    ("DM_MST_EDI_CUST_MATERIAL_INFO", 0), ("DM_PLN_BP_FCST", 1), ("DM_PLN_BP_FCST_H", 1), ("DM_PLN_CUSTOMER_PSI", 1),
    ("DM_PLN_CUSTOMER_PSI_H", 1), ("DM_PLN_MKT_FCST", 1), ("DM_PLN_MKT_FCST_CONFIRM", 1), ("DM_PLN_MKT_FCST_H", 1),
    ("DM_PLN_MKT_FCST_PK_DATA_UPDATE_H", 1), ("DM_PLN_MKT_FCST_RESULT", 1), ("DM_PLN_PR_DETAIL", 1),
    ("DM_PLN_SALES_PLAN", 1), ("DM_PLN_SALES_PLAN_H", 1), ("DM_PLN_SALES_PLAN_REPORT_H", 1), ("DM_PLN_SALES_PLAN_RESULT", 1),
    ("SCM_MST_FUTURE_PRICE", 1), ("SCM_MST_FUTURE_PRICE_H", 1), ("SCM_MST_SITE_ITEM", 1), ("SCM_MST_SITE_ITEM_H", 1),
    ("SCM_MST_SITE_ITEM_PRIORITY", 1), ("SCM_MST_SITE_ITEM_PRIORITY_H", 1),
]
USER = "minyonglee1"


def con():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def refs(cur, item):
    out = {}
    for t, f in TABLES:
        cur.execute(f"SELECT COUNT(*) FROM {t} WHERE ITEM_ID = :i" + (" AND DIVISION_ID = '40'" if f else ""), i=item)
        n = cur.fetchone()[0]
        if n:
            out[t] = n
    return out


def call(cur, pairs):
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    data = json.dumps([{"ITEM_ID_BEFORE": b, "ITEM_ID_AFTER": a} for b, a in pairs])
    cur.callproc("PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP", [data, USER, rc])
    return rc.getvalue().fetchall()


def hist_cnt(cur):
    cur.execute("SELECT COUNT(*) FROM DM_DNM_ITEM_CODE_CHANGE_HISTORY")
    return cur.fetchone()[0]


def candidates():
    with con() as c:
        cur = c.cursor()
        cur.execute("""SELECT SUBSTR(ITEM_ID,1,11) P11, LISTAGG(ITEM_ID, ',') WITHIN GROUP (ORDER BY ITEM_ID) IDS
                         FROM (SELECT DISTINCT ITEM_ID FROM DM_MST_ITEM_SINGLE_V
                                WHERE DIVISION_ID='40' AND ITEM_ID LIKE 'MP%' AND LENGTH(ITEM_ID)=12)
                        GROUP BY SUBSTR(ITEM_ID,1,11) HAVING COUNT(*) >= 2 ORDER BY 1 FETCH FIRST 60 ROWS ONLY""")
        groups = cur.fetchall()
        zero, used = None, None
        for p11, ids in groups:
            ids = ids.split(",")
            r = [refs(cur, i) for i in ids]
            for i, rr in zip(ids, r):
                if not rr and zero is None:
                    other = [x for x in ids if x != i][0]
                    if not refs(cur, other):
                        zero = (i, other)
                if rr and used is None and len(rr) >= 2:
                    used = (i, [x for x in ids if x != i][0], rr)
            if zero and used:
                break
        print("ZERO-REF PAIR:", zero)
        print("USED PAIR    :", used)


def validate():
    with con() as c:
        cur = c.cursor()
        cur.execute("""SELECT MIN(ITEM_ID), MAX(ITEM_ID) FROM DM_MST_ITEM_SINGLE_V
                        WHERE DIVISION_ID='40' AND ITEM_ID LIKE 'MP%' AND LENGTH(ITEM_ID)=12""")
        ok1, _ = cur.fetchone()
        sib = ok1[:11] + ("Z" if ok1[11] != "Z" else "Y")   # 앞 11자리 같은 형제(마스터 부재 가능)
        h0 = hist_cnt(cur)
        cases = [
            ("1 BEFORE 12자리 아님", [("MP123", ok1)]),
            ("1' BEFORE 빈값('' = NULL)", [("", ok1)]),
            ("2 AFTER 12자리 아님", [(ok1, "MP12345678901X")]),
            ("3 앞 11자리 다름", [(ok1, "MPZZZZZZZZZZ")]),
            ("4 BEFORE MP 시작 아님", [("XX" + ok1[2:], "XX" + ok1[2:11] + "Q")]),
            ("5 AFTER MP 시작 아님 (BEFORE MP)", [("MP" + ok1[2:], "MP" + ok1[2:11] + "Q")]),
            ("6 전후 동일", [(ok1, ok1)]),
            ("6' 전후 동일 (대소문자만 다름 — CI 동등)", [(ok1, ok1.lower())]),
            ("7 마스터 부재 (AFTER)", [(ok1, sib)]),
        ]
        for name, pairs in cases:
            res = call(cur, pairs)
            print(f"[{name}] {pairs} -> {res}")
        h1 = hist_cnt(cur)
        print("HISTORY 행수 변화:", h0, "->", h1, "(0 이어야 함)")


def zero(b, a):
    with con() as c:
        cur = c.cursor()
        rb, ra = refs(cur, b), refs(cur, a)
        assert not rb and not ra, f"참조 0 아님: {b}={rb} {a}={ra}"   # 호출 직전 assert — 실데이터 무변경 보장
        h0 = hist_cnt(cur)
        import time
        t0 = time.time()
        print("CALL", call(cur, [(b, a)]), f"SP elapsed {time.time() - t0:.1f}s", flush=True)
        h1 = hist_cnt(cur)
        print("HISTORY 행수 변화:", h0, "->", h1, "(0 이어야 함)", "| 사후 참조:", refs(cur, b), refs(cur, a))


def dryupdate(b, a):
    """SP 내부 CHANGE_TABLE 원문(USER_SOURCE)을 그대로 익명 블록에 넣어 38 테이블 실행
       → 같은 트랜잭션에서 BEFORE 잔존 0 · AFTER 증가 = 갱신 건수 · 이력 행 확인 → ROLLBACK (커밋 없음)."""
    import re, time
    with con() as c:
        cur = c.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0005' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        s = body.index("    PROCEDURE CHANGE_TABLE(")
        e = body.index("END CHANGE_TABLE;", s) + len("END CHANGE_TABLE;")
        change_table = body[s:e]                                   # SP 원문 그대로
        before_b, before_a = refs(cur, b), refs(cur, a)
        print("PRE  refs", b, before_b, "|", a, before_a, flush=True)
        calls = "".join(f"    CHANGE_TABLE('{t}', {'TRUE' if f else 'FALSE'});\n" for t, f in TABLES)
        plsql = f"""
DECLARE
    P_USER_ID     VARCHAR2(50) := 'DRYRUN';
    V_TOT_ROWS    NUMBER := 0;
    TYPE T_VC_TAB  IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
    TYPE T_RID_TAB IS TABLE OF UROWID        INDEX BY PLS_INTEGER;
    TYPE T_SEQ_MAP IS TABLE OF NUMBER        INDEX BY VARCHAR2(401);
    TYPE T_STR_MAP IS TABLE OF VARCHAR2(200) INDEX BY VARCHAR2(200);
    TYPE T_CNT_MAP IS TABLE OF NUMBER        INDEX BY VARCHAR2(200);
    V_SEQ T_SEQ_MAP; V_MAP T_STR_MAP;
    V_BEF_LIST SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(:b);
{change_table}
BEGIN
    V_MAP(:b) := :a;
    V_SEQ(:b || CHR(1) || :a) := -1;     -- 드라이런 표식 (ROLLBACK 되므로 실 이력에 남지 않음)
{calls}
    :tot := V_TOT_ROWS;
    SELECT LISTAGG(TABLE_NAME || '=' || ROW_COUNT, ' ') WITHIN GROUP (ORDER BY TABLE_NAME)
      INTO :hist FROM DM_DNM_ITEM_CODE_CHANGE_HISTORY WHERE BEFORE_CODE = :b AND AFTER_CODE = :a AND DATA_SEQ = -1;
END;"""
        tot = cur.var(int); hist = cur.var(str, 32767)
        t0 = time.time()
        try:
            cur.execute(plsql, b=b, a=a, tot=tot, hist=hist)
            elapsed = time.time() - t0
            mid_b, mid_a = refs(cur, b), refs(cur, a)              # 같은 트랜잭션 — 커밋 전 상태
        finally:
            c.rollback()
        exp = sum(before_b.values())
        print(f"CHANGE_TABLE x38 elapsed {elapsed:.1f}s  V_TOT_ROWS={tot.getvalue()} (기대 {exp})")
        print("HISTORY(dry):", hist.getvalue())
        print("MID  BEFORE 잔존:", mid_b, "(빈 dict 여야 함)")
        gained = {t: mid_a.get(t, 0) - before_a.get(t, 0) for t in set(mid_a) | set(before_a)}
        print("MID  AFTER 증가:", {k: v for k, v in gained.items() if v}, "(PRE BEFORE 와 같아야 함)")
        print("CHECK:", "PASS" if not mid_b and {k: v for k, v in gained.items() if v} == before_b and tot.getvalue() == exp else "FAIL")
        print("POST(ROLLBACK) refs", b, refs(cur, b), "(PRE 와 같아야 함)")


if __name__ == "__main__":
    {"candidates": candidates, "validate": validate, "zero": zero, "dryupdate": dryupdate}[sys.argv[1]](*sys.argv[2:])
