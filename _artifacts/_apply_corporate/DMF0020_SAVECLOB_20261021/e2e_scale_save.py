"""[E20261021-DMF0020SAVECLOB] 사내 ZIOUI1 정상 저장 전 구간 규모 측정 (메인 Save · Batch Price Input 공통 SP)
- 격리 키(82 · 원장/이력/Sales Plan/MKT_FCST 에 없는 site-item, _test_out/isolated_keys_82.json) × 주차 × LOC/KRW/USD 로 실제 저장.
- 페이로드는 DB 안에서 CLOB 으로 조립(BE jdbcType=CLOB 바인드와 같은 IN CLOB 경로) → P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 호출.
- 실행 중 0.5초마다 세션 표본(현재 SQL) → 병목 문장 집계.
- 끝나면 결과 확인(CODE · 원장/이력 행수 · Sales Plan 0) 후 테스트 행 삭제(COMMIT). 사전 행수가 0 이 아니면 중단.
사용: python e2e_scale_save.py <키 수> <주 수> <타임아웃초>
"""
import sys, json, time, threading, collections, pathlib, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = pathlib.Path(__file__).resolve().parent
n_keys, n_weeks, limit = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
keys = json.load(open(HERE / "_test_out" / "isolated_keys_82.json"))[:n_keys]
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME'), SYS_CONTEXT('USERENV','SID') FROM DUAL"); cn, my_sid = cur.fetchone()
assert cn == "ZIOUI1"
L = con.gettype("SYS.ODCIVARCHAR2LIST")
lp, ls, li = L.newobject([k[0] for k in keys]), L.newobject([k[1] for k in keys]), L.newobject([k[2] for k in keys])
cur.execute("DELETE FROM SCM_MGR.GT_DMF0020_RESULTS")  # 세션 GTT 정리 (SP 도 시작 시 비움)



def counts():
    r = {}
    for t in ("SCM_MST_FUTURE_PRICE", "SCM_MST_FUTURE_PRICE_H", "DM_PLN_SALES_PLAN"):
        cur.execute(f"""SELECT COUNT(*) FROM SCM_MGR.{t} T
                         WHERE T.DIVISION_ID = '82'
                           AND (T.PROJECT_CODE, T.SCM_SITE_ID, T.ITEM_ID) IN
                               (SELECT P.COLUMN_VALUE, S.COLUMN_VALUE, I.COLUMN_VALUE
                                  FROM (SELECT ROWNUM RN, COLUMN_VALUE FROM TABLE(:lp)) P
                                  JOIN (SELECT ROWNUM RN, COLUMN_VALUE FROM TABLE(:ls)) S ON S.RN = P.RN
                                  JOIN (SELECT ROWNUM RN, COLUMN_VALUE FROM TABLE(:li)) I ON I.RN = P.RN)""", lp=lp, ls=ls, li=li)
        r[t] = cur.fetchone()[0]
    return r


def cleanup():
    n = {}
    for t in ("SCM_MST_FUTURE_PRICE_H", "SCM_MST_FUTURE_PRICE", "DM_PLN_SALES_PLAN"):
        cur.execute(f"""DELETE FROM SCM_MGR.{t} T
                         WHERE T.DIVISION_ID = '82'
                           AND (T.PROJECT_CODE, T.SCM_SITE_ID, T.ITEM_ID) IN
                               (SELECT P.COLUMN_VALUE, S.COLUMN_VALUE, I.COLUMN_VALUE
                                  FROM (SELECT ROWNUM RN, COLUMN_VALUE FROM TABLE(:lp)) P
                                  JOIN (SELECT ROWNUM RN, COLUMN_VALUE FROM TABLE(:ls)) S ON S.RN = P.RN
                                  JOIN (SELECT ROWNUM RN, COLUMN_VALUE FROM TABLE(:li)) I ON I.RN = P.RN)""", lp=lp, ls=ls, li=li)
        n[t] = cur.rowcount
    con.commit()
    return n


BLOCK = """
DECLARE
    TYPE t_c IS TABLE OF CLOB INDEX BY PLS_INTEGER;
    TYPE t_b IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    c t_c; b t_b; v_first BOOLEAN := TRUE; rn PLS_INTEGER := 0;
    rc1 SYS_REFCURSOR; rc SYS_REFCURSOR; v_code VARCHAR2(100); v_msg VARCHAR2(4000); v_evt VARCHAR2(4000);
    t0 TIMESTAMP; t1 TIMESTAMP; m VARCHAR2(3); w VARCHAR2(8);
    v_p SYS.ODCIVARCHAR2LIST := :lp; v_s SYS.ODCIVARCHAR2LIST := :ls; v_i SYS.ODCIVARCHAR2LIST := :li;
    v_over PLS_INTEGER := 0;
    PROCEDURE ap(i PLS_INTEGER, s VARCHAR2) IS
    BEGIN
        IF LENGTHB(b(i)) + LENGTHB(s) + 1 > 30000 THEN DBMS_LOB.WRITEAPPEND(c(i), LENGTH(b(i)), b(i)); b(i) := NULL; END IF;
        b(i) := b(i) || CASE WHEN NOT v_first THEN '^' END || s;
    END;
BEGIN
    FOR i IN 1..17 LOOP c(i) := NULL; DBMS_LOB.CREATETEMPORARY(c(i), TRUE); b(i) := NULL; END LOOP;
    FOR k IN 1..v_p.COUNT LOOP
        FOR wk IN 0..:nw-1 LOOP
            w := TO_CHAR(DATE '2027-01-04' + 7*wk, 'YYYYMMDD');
            FOR mi IN 1..3 LOOP
                m := CASE mi WHEN 1 THEN 'LOC' WHEN 2 THEN 'KRW' ELSE 'USD' END; rn := rn + 1;
                ap(1,'M'); ap(2,'82'); ap(3,v_p(k)); ap(4,v_s(k)); ap(5,'-'); ap(6,v_i(k));
                ap(7,w); ap(8,'USD'); ap(9,m); ap(10,'E'); ap(11,'MPS'); ap(12,'DDP');
                ap(13, CASE m WHEN 'KRW' THEN '130000' ELSE '100' END); ap(14,'saveclob_e2e'); ap(15,'20261021'); ap(16,'saveclob_e2e'); ap(17,TO_CHAR(k));
                v_first := FALSE;
            END LOOP;
        END LOOP;
    END LOOP;
    FOR i IN 1..17 LOOP IF b(i) IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c(i), LENGTH(b(i)), b(i)); END IF; END LOOP;
    :rows := rn; :maxlen := DBMS_LOB.GETLENGTH(c(6));
    t0 := SYSTIMESTAMP;
    SCM_MGR.PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL(c(1),c(2),c(3),c(4),c(5),c(6),c(7),c(8),c(9),c(10),c(11),c(12),c(13),c(14),c(15),c(16),c(17), rc1, rc);
    t1 := SYSTIMESTAMP;
    FETCH rc INTO v_code, v_msg, v_evt; CLOSE rc;
    LOOP FETCH rc1 INTO v_msg; EXIT WHEN rc1%NOTFOUND; v_over := v_over + 1; END LOOP;
    :res := v_code || ' / ' || v_msg || ' / ' || v_evt; :over := v_over;
    :sec := EXTRACT(SECOND FROM (t1 - t0)) + 60*EXTRACT(MINUTE FROM (t1 - t0)) + 3600*EXTRACT(HOUR FROM (t1 - t0));
END;"""
# rc1 은 여러 컬럼 — 행수만 세기 위해 단일 FETCH 대신 아래 대체
BLOCK = BLOCK.replace("    LOOP FETCH rc1 INTO v_msg; EXIT WHEN rc1%NOTFOUND; v_over := v_over + 1; END LOOP;\n",
                      "    DECLARE n PLS_INTEGER := 0; BEGIN LOOP EXIT WHEN rc1%NOTFOUND OR rc1%NOTFOUND IS NULL; n := n; EXIT; END LOOP; END; CLOSE rc1;\n")

out = []
def log(*a):
    s = " ".join(map(str, a)); print(s, flush=True); out.append(s)

before = counts(); log(f"== e2e keys={len(keys)} weeks={n_weeks} rows={len(keys)*n_weeks*3:,} {datetime.datetime.now():%H:%M:%S} before={before}")
assert all(v == 0 for v in before.values()), "격리 키가 아님 — 중단"

samples = collections.Counter(); stop = False
def sampler():
    c2 = oracledb.connect(user=u, password=p, dsn=d); k2 = c2.cursor()
    while not stop:
        k2.execute("""SELECT (SELECT SUBSTR(REPLACE(Q.SQL_TEXT,CHR(10),' '),1,110) FROM V$SQL Q WHERE Q.SQL_ID = S.SQL_ID AND ROWNUM = 1), S.EVENT
                        FROM V$SESSION S WHERE S.SID = :s AND S.STATUS = 'ACTIVE'""", s=int(my_sid))
        r = k2.fetchone()
        if r: samples[(r[0] or '-')] += 1
        time.sleep(0.5)
th = threading.Thread(target=sampler, daemon=True); th.start()

con.call_timeout = limit * 1000
v = {k: cur.var(t) for k, t in (("rows", int), ("maxlen", int), ("res", str), ("sec", float), ("over", int))}
t0 = time.time(); err = None
try:
    cur.execute(BLOCK, lp=lp, ls=ls, li=li, nw=n_weeks, **v)
except Exception as e:
    err = str(e).splitlines()[0]
stop = True; th.join(timeout=3)
total = time.time() - t0
con.call_timeout = 0
if err:
    log(f"ERROR after {total:.1f}s : {err}")
    try: con.rollback()
    except Exception: con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
else:
    log(f"rows={v['rows'].getvalue():,} itemId len={v['maxlen'].getvalue():,} → SP {v['sec'].getvalue():.1f}s (block total {total:.1f}s) result={v['res'].getvalue()}")
after = counts(); log("after", after)
exp = len(keys) * n_weeks * 3
log("judge", "PASS" if (not err and v['res'].getvalue().startswith("0 /") and after["SCM_MST_FUTURE_PRICE"] == exp and after["SCM_MST_FUTURE_PRICE_H"] == exp) else "CHECK",
    f"(ledger {after['SCM_MST_FUTURE_PRICE']}/{exp} · history {after['SCM_MST_FUTURE_PRICE_H']}/{exp} · sales plan {after['DM_PLN_SALES_PLAN']})")
log("hot statements (0.5s samples):")
for k, n in samples.most_common(8): log(f"  {n:4} {k}")
log("cleanup deleted", cleanup(), "→", counts())
(HERE / "_test_out" / f"e2e_{len(keys)}x{n_weeks}_{datetime.datetime.now():%Y%m%d_%H%M%S}.log").write_text("\n".join(out) + "\n", encoding="utf-8")
