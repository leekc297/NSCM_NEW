"""[E20261021-DMF0020SAVECLOB] 2차 — _ALL 분할 뒤 O(N^2) 4문장(상관 UPDATE 2 · DECODE NOT EXISTS 보충 INSERT 2) 집합 기반 치환 동치 검증.
같은 GTT 데이터에 원문 4문장 / 새 4문장을 차례로 실행해 단계마다 전 행(multiset)을 비교한다. GTT 만 사용 · 마지막 ROLLBACK."""
import sys, random, re, time, json, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb
HERE = pathlib.Path(__file__).resolve().parent
src = (HERE / "00_BACKUP_ASIS" / "PKG_DMF0020_BODY.PRE_SAVECLOB.src.sql").read_text(encoding="utf-8")
a = src.index("PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL"); b = src.index("END P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL;", a); seg = src[a:b]
def stmt(start, end):
    i = seg.index(start); j = seg.index(end, i) + len(end); return seg[i:j]
O_A5 = stmt("    UPDATE SCM_MGR.GT_FCSV_RESULTS_MST A\n       SET A.V_CURRENCY", "A.V_CURRENCY) <> A.V_CURRENCY;")
O_A6 = stmt("    UPDATE SCM_MGR.GT_FCSV_RESULTS_MST A\n       SET A.V_ACTIVE_FLAG", "A.V_ACTIVE_FLAG) <> A.V_ACTIVE_FLAG;")
END_NE = "AND DECODE(K.V_INCOTERMS, L.V_INCOTERMS, 1, 0) = 1 );"
ki = seg.index("WHERE K.V_MEASURE = 'KRW'"); O_A7 = seg[seg.rindex("        INSERT INTO SCM_MGR.GT_FCSV_RESULTS_MST", 0, ki):seg.index(END_NE, ki) + len(END_NE)]
ui = seg.index("WHERE K.V_MEASURE = 'USD'"); O_A8 = seg[seg.rindex("        INSERT INTO SCM_MGR.GT_FCSV_RESULTS_MST", 0, ui):seg.index(END_NE, ui) + len(END_NE)]
K9 = ["V_DIVISION_ID", "V_PROJECT_CODE", "V_SCM_SITE_ID", "V_PLANT_SITE_ID", "V_ITEM_ID", "V_YYYYMMDD", "V_DOM_EXP", "V_FCST_TYPE", "V_INCOTERMS"]
def merge(col, keys):
    on = "\n          AND ".join(f"B.{k} = A.{k}" for k in keys)
    return (f"    MERGE INTO SCM_MGR.GT_FCSV_RESULTS_MST A\n    USING ( SELECT {', '.join(keys)}, MAX({col}) AS MAX_VAL\n"
            f"              FROM SCM_MGR.GT_FCSV_RESULTS_MST\n             WHERE V_MEASURE = 'LOC'\n             GROUP BY {', '.join(keys)} ) B\n"
            f"       ON ( {on}\n          AND A.V_MEASURE <> 'LOC' )\n     WHEN MATCHED THEN UPDATE SET A.{col} = B.MAX_VAL\n      WHERE B.MAX_VAL <> A.{col};")
N_A5 = merge("V_CURRENCY", K9)
N_A6 = merge("V_ACTIVE_FLAG", K9[:6] + ["V_CURRENCY"] + K9[6:])
def ne_new(o):
    return re.sub(r"DECODE\(K\.(\w+), L\.(\w+), 1, 0\) = 1", r"NVL(K.\1, CHR(0)) = NVL(L.\2, CHR(0))", o)
N_A7, N_A8 = ne_new(O_A7), ne_new(O_A8)
assert O_A7.count("DECODE(") == 10 and N_A7.count("DECODE(") == 0 and O_A8.count("DECODE(") == 10
json.dump({"N_A5": N_A5, "N_A6": N_A6, "O_A7": O_A7, "N_A7": N_A7, "O_A8": O_A8, "N_A8": N_A8}, open(HERE / "_test_out" / "setbased_sql.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)

COLS = ["V_ACTIVE_FLAG"] + K9[:6] + ["V_CURRENCY", "V_MEASURE"] + K9[6:] + ["V_PRICE", "V_CREATED_BY", "V_CREATION_DATE", "V_LAST_UPDATED_BY", "V_ROWNUM"]
def dataset(n, seed):
    r = random.Random(seed); rows = []
    for i in range(n):
        key = [r.choice(["82", "40", None]) if r.random() < 0.05 else r.choice(["82", "40"]), r.choice(["P1", "P2"]), "S1", r.choice(["-", "/"]),
               f"I{r.randint(1, max(2, n // 30))}", r.choice(["20270104", "20270111"])]
        cur = r.choice(["USD", "KRW", "EUR", "/"]) if r.random() > 0.03 else None
        meas = r.choice(["LOC", "LOC", "KRW", "USD"])
        tail = ["E", "MPS", r.choice(["DDP", "/", None]) if r.random() < 0.1 else "DDP"]
        flag = r.choice(["M", "M", "D", None])
        rows.append([flag] + key + [cur, meas] + tail + [r.choice([0, 1.5, 130000]), "eq_test", None, "eq_test", i + 1])
    return rows
def load(cur, rows):
    cur.execute("DELETE FROM SCM_MGR.GT_FCSV_RESULTS_MST")
    cur.executemany(f"INSERT INTO SCM_MGR.GT_FCSV_RESULTS_MST ({', '.join(COLS)}) VALUES ({', '.join(':' + str(i + 1) for i in range(len(COLS)))})", rows)
def snap(cur):
    cur.execute(f"SELECT {', '.join(COLS)} FROM SCM_MGR.GT_FCSV_RESULTS_MST ORDER BY {', '.join(f'{c} NULLS FIRST' for c in COLS)}")
    return cur.fetchall()
def run(cur, sql):
    s = sql.strip().rstrip(";"); t0 = time.time(); cur.execute(s); return cur.rowcount, time.time() - t0

u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL"); assert cur.fetchone()[0] == "ZIOUI1"
ok_all = True
for seed, n in ((1, 300), (2, 2000), (3, 5000)):
    rows = dataset(n, seed)
    load(cur, rows); res_o = []
    for nm, q in (("A5", O_A5), ("A6", O_A6), ("A7", O_A7), ("A8", O_A8)):
        rc, t = run(cur, q); res_o.append((nm, rc, round(t, 2), snap(cur)))
    load(cur, rows); res_n = []
    for nm, q in (("A5", N_A5), ("A6", N_A6), ("A7", N_A7), ("A8", N_A8)):
        rc, t = run(cur, q); res_n.append((nm, rc, round(t, 2), snap(cur)))
    for (nm, rco, to, so), (_, rcn, tn, sn) in zip(res_o, res_n):
        same = so == sn; ok_all &= same
        print(f"seed={seed} n={n:5} {nm}: rows changed orig={rco} new={rcn} · {to}s → {tn}s · state {'SAME' if same else 'DIFF'} ({len(so)} rows)")
con.rollback()
print("EQUIVALENCE", "PASS" if ok_all else "FAIL")
