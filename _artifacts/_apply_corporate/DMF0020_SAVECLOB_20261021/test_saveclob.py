"""[E20261021-DMF0020SAVECLOB] 사내 ZIOUI1 검증 — 적용 전(pre) 스냅샷 / 적용 후(post) 동등성·한도·성능·정상 저장 경로

pre  : (T4a) 수정 전 _ALL SP 에 300행 페이로드(경계값 포함) → 검증 단계에서 멈춘 뒤 세션 GTT GT_FCSV_RESULTS_MST 행 스냅샷
       (T4b) 수정 전 _POPUP 분할 구간(선언부+P3+P4 원문)을 익명 블록으로 실행 → GT_DMF0020_RESULTS_MST 행 스냅샷
post : (T4a/T4b) 같은 입력으로 적용본 실행 → 스냅샷 완전 일치
       (T2) _ALL 3,000행(57KB)·15,000행(285KB) 잘못된 Project → '-1 Invalid Project Code' 즉시 반환(소요 초) — 수정 전엔 바인드 오류/10분+
       (T3) _POPUP 3,000행 → 'Invalid Project Code !' 반환
       (T5) 정상 저장: 원장·이력·Sales Plan 에 없는 82 키 3개 × 300주 × 3메저 = 2,700행(p_SCM_SITE_ID 40KB) → CODE 0 · 원장 2,700 · _H 2,700 · DM_PLN_SALES_PLAN 0 → 테스트 행 삭제
FRESH-GATE: 원문은 DB(ALL_SOURCE)에서 새로 읽는다. 원장 변경은 T5 의 격리 키만(원장에 없는 키·기간, 사후 삭제).
"""
import sys, os, json, time, datetime, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = pathlib.Path(__file__).resolve().parent
SNAP = HERE / "_test_out"
MARK = "[E20261021-DMF0020SAVECLOB]"
PROC_ALL = "SCM_MGR.PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL"
PROC_POP = "SCM_MGR.PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP"
TEST_KEYS = [("82", "C-18-004", "Socomec_US_LAX", "EABB00252AA"), ("82", "C-18-004", "Socomec_US_LAX", "EABB00254AA"), ("82", "C-18-004", "Socomec_US_LAX", "EABS00272AA")]
LOG = []
CLOB_BIND = False


def out(*a):
    s = " ".join(str(x) for x in a); print(s); LOG.append(s)


def edge_payload(n_keys=100, numeric_price=False):
    """82 · 잘못된 Project(ZZPRJ_REPRO) · 경계값: 탭/공백 ITEM, 빈 INCOTERMS, 'abc'/빈 PRICE, 끝 공백, LOC 만 있는 키 5개(환율 보충 경로)"""
    rows = []
    rn = 0
    for k in range(n_keys):
        item = f"ZZITEM{k:05d}"
        if k % 10 == 0: item = f" ZZITEM{k:05d}\t"          # TRIM + 제어문자 제거
        inco = "" if k % 7 == 0 else "FOB"                   # 빈값 → '/'
        meas = ["LOC"] if k < 5 else ["LOC", "KRW", "USD"]   # LOC 만 → KRW/USD 보충
        for m in meas:
            rn += 1
            price = {"LOC": "12.5", "KRW": "abc" if k % 11 == 0 else "16250", "USD": "" if k % 13 == 0 else "12.5"}[m]
            if numeric_price: price = {"LOC": "12.5", "KRW": "16250", "USD": "12.5"}[m]
            rows.append(("M", "82", "ZZPRJ_REPRO", "ZZSITE ", "-", item, "20270104", "USD", m, "E", "MPS", inco, price, "repro", "", "repro", str(rn)))
    cols = list(zip(*rows))
    return ["^".join(c) for c in cols], len(rows)


def bulk_payload(n, project="ZZPRJ_REPRO"):
    rows = [("M", "82", project, "ZZSITE", "-", f"ZZITEM{i:012d}", "20270104", "USD", ("LOC", "KRW", "USD")[i % 3], "E", "MPS", "FOB", "1.5", "repro", "", "repro", str(i + 1)) for i in range(n)]
    cols = list(zip(*rows)); return ["^".join(c) for c in cols]


def as_clobs(cur, p):
    """적용 후 IN CLOB 파라미터 — 값을 임시 CLOB 으로 바인드 (BE 의 jdbcType=CLOB 경로와 동일). 적용 전(VARCHAR2)엔 str 그대로."""
    if not CLOB_BIND: return list(p)
    out = []
    for v in p:
        lob = cur.connection.createlob(oracledb.DB_TYPE_CLOB); lob.write(v); out.append(lob)
    return out


def call_all(cur, p, timeout_note=""):
    rc1 = cur.var(oracledb.DB_TYPE_CURSOR); rc = cur.var(oracledb.DB_TYPE_CURSOR)
    t0 = time.time()
    try:
        cur.callproc(PROC_ALL, as_clobs(cur, p) + [rc1, rc])
        res = rc.getvalue().fetchall(); r1 = rc1.getvalue().fetchall()
        return res, len(r1), time.time() - t0, None
    except Exception as e:
        return None, None, time.time() - t0, str(e).splitlines()[0]


def call_pop(cur, p16):
    rc = cur.var(oracledb.DB_TYPE_CURSOR); t0 = time.time()
    try:
        cur.callproc(PROC_POP, as_clobs(cur, p16) + [rc]); return rc.getvalue().fetchall(), time.time() - t0, None
    except Exception as e:
        return None, time.time() - t0, str(e).splitlines()[0]


def snap_gtt(cur, table):
    cur.execute(f"SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='{table}' AND COLUMN_NAME <> 'V_CREATION_DATE' ORDER BY COLUMN_ID")
    cols = [r[0] for r in cur.fetchall()]
    cur.execute(f"SELECT {', '.join(cols)} FROM SCM_MGR.{table} ORDER BY {', '.join(cols)}")
    return [[None if v is None else str(v) for v in r] for r in cur.fetchall()]


def fetch_body(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0020' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    return "".join(r[0] for r in cur.fetchall()).replace("\r\n", "\n")


def popup_region_block(body, params16, applied):
    """_POPUP 선언부 + 분할 구간(P3·P4)만 떼어 익명 블록으로 — GT_DMF0020_RESULTS_MST 적재 결과를 비교한다."""
    a = body.index("PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP"); b = body.index("END P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP;", a)
    seg = body[a:b]
    decl = seg[seg.index("    IS\n") + len("    IS\n"):seg.index("\nBEGIN\n")]
    if applied:
        p3 = seg[seg.index(f"\t--{MARK} BEGIN-NEW P3"):seg.index(f"\t{MARK} END-ORIG P3 */\n") + len(f"\t{MARK} END-ORIG P3 */\n")]
        p4 = seg[seg.index(f"--{MARK} BEGIN-NEW P4"):seg.index(f"{MARK} END-ORIG P4 */\n") + len(f"{MARK} END-ORIG P4 */\n")]
    else:
        p3 = seg[seg.index("\tl_active_flag      := RTRIM(p_active_flag     ) || '^';\n"):seg.index("\tl_LAST_UPDATED_BY  := RTRIM(p_LAST_UPDATED_BY ) || '^';\n") + len("\tl_LAST_UPDATED_BY  := RTRIM(p_LAST_UPDATED_BY ) || '^';\n")]
        p4 = seg[seg.index("WHILE LENGTH(l_DIVISION_ID) > 0\nLOOP\n"):seg.index("    END IF;\nEND LOOP;\n") + len("    END IF;\nEND LOOP;\n")]
    names = ["p_active_flag", "p_DIVISION_ID", "p_PROJECT_CODE", "p_SCM_SITE_ID", "p_PLANT_SITE_ID", "p_ITEM_ID", "p_YYYYMMDD", "p_CURRENCY",
             "p_MEASURE", "p_DOM_EXP", "p_FCST_TYPE", "p_INCOTERMS", "p_PRICE", "p_CREATED_BY", "p_CREATION_DATE", "p_LAST_UPDATED_BY"]
    lits = "".join(f"    {n} VARCHAR2(32767) := '{v.replace(chr(39), chr(39) * 2)}';\n" for n, v in zip(names, params16))
    return "DECLARE\n" + lits + decl + "\nBEGIN\n    DELETE FROM SCM_MGR.GT_DMF0020_RESULTS_MST;\n    v_delimiter := '^';\n" + p3 + "\n" + p4 + "END;"


def main():
    mode = sys.argv[1]
    SNAP.mkdir(exist_ok=True)
    u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL"); assert cur.fetchone()[0].upper() == "ZIOUI1"
    global CLOB_BIND
    body = fetch_body(cur); applied = MARK in body; CLOB_BIND = applied
    out(f"== {mode} == DB=ZIOUI1 applied={applied} {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")
    if mode == "pre-t4b":   # T4a 스냅샷은 pre 에서 이미 확보 · T4b 원문 블록을 백업 원문(00_BACKUP_ASIS)으로 재구성해 실행
        body = (HERE / "00_BACKUP_ASIS" / "PKG_DMF0020_BODY.PRE_SAVECLOB.src.sql").read_text(encoding="utf-8"); applied = False
        assert MARK not in body
    else:
        assert (mode == "post") == applied, "모드와 DB 상태 불일치"

    # T4a _ALL 300행 경계값 스냅샷
    p17, n = edge_payload()
    if mode == "pre-t4b":
        res, n1, sec, err, rows = None, None, 0, "skip", []
    else:
        res, n1, sec, err = call_all(cur, p17)
    out(f"T4a _ALL edge {n}행 → result={res} rc1={n1} {sec:.2f}s err={err}")
    if mode != "pre-t4b": rows = snap_gtt(cur, "GT_FCSV_RESULTS_MST")
    out(f"T4a GT_FCSV_RESULTS_MST rows={len(rows)} sample={rows[0] if rows else None}")
    f = SNAP / "T4a_all_gtt_snapshot.json"
    if mode == "pre-t4b":
        pass
    elif mode == "pre":
        f.write_text(json.dumps({"result": [list(map(str, r)) for r in res] if res else None, "rows": rows}, ensure_ascii=False), encoding="utf-8")
    else:
        pre = json.loads(f.read_text(encoding="utf-8"))
        same = pre["rows"] == rows and pre["result"] == ([list(map(str, r)) for r in res] if res else None)
        out(f"T4a 동등성 pre rows={len(pre['rows'])} post rows={len(rows)} → {'PASS 완전 일치' if same else 'FAIL 불일치'}")
        if not same:
            diff = [(a, b) for a, b in zip(pre["rows"], rows) if a != b][:5]; out("  diff sample", diff)
    con.rollback()

    # T4b _POPUP 분할 구간 블록 스냅샷
    p16 = edge_payload(numeric_price=True)[0][:16]
    blk = popup_region_block(body, p16, applied)
    (SNAP / f"T4b_popup_block_{mode}.sql").write_text(blk, encoding="utf-8")
    t0 = time.time(); cur.execute(blk); sec = time.time() - t0
    rows = snap_gtt(cur, "GT_DMF0020_RESULTS_MST")
    out(f"T4b _POPUP 분할구간 블록({'적용본' if applied else '원문'}) {sec:.2f}s rows={len(rows)} sample={rows[0] if rows else None}")
    f = SNAP / "T4b_popup_gtt_snapshot.json"
    if mode in ("pre", "pre-t4b"):
        f.write_text(json.dumps(rows, ensure_ascii=False), encoding="utf-8")
    else:
        pre = json.loads(f.read_text(encoding="utf-8"))
        out(f"T4b 동등성 pre rows={len(pre)} post rows={len(rows)} → {'PASS 완전 일치' if pre == rows else 'FAIL 불일치'}")
        if pre != rows:
            diff = [(a, b) for a, b in zip(pre, rows) if a != b][:5]; out("  diff sample", diff)
    con.rollback()

    if mode == "post":
        # T2 _ALL 대량 (잘못된 Project → 검증에서 반환, 원장 무변경)
        for n in (3000, 15000):
            p = bulk_payload(n); mx = max(len(x) for x in p)
            res, n1, sec, err = call_all(cur, p)
            out(f"T2 _ALL {n}행 max param {mx:,}자 → result={res} {sec:.2f}s err={err}")
            con.rollback()
        # T3 _POPUP 대량
        p = bulk_payload(3000); res, sec, err = call_pop(cur, p[:16])
        out(f"T3 _POPUP 3000행 max param {max(len(x) for x in p[:16]):,}자 → result={res} {sec:.2f}s err={err}")
        con.rollback()
        # T5 정상 저장 경로 (격리 키 · 원장/이력/Sales Plan 에 없는 키)
        keys_sql = " OR ".join(f"(DIVISION_ID='{a}' AND PROJECT_CODE='{b}' AND SCM_SITE_ID='{c}' AND ITEM_ID='{dd}')" for a, b, c, dd in TEST_KEYS)
        def counts():
            r = {}
            for t in ("SCM_MST_FUTURE_PRICE", "SCM_MST_FUTURE_PRICE_H", "DM_PLN_SALES_PLAN"):
                cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE {keys_sql}"); r[t] = cur.fetchone()[0]
            return r
        before = counts(); out("T5 before", before)
        assert all(v == 0 for v in before.values()), "격리 키가 아님 — 중단"
        monday = datetime.date(2027, 1, 4); weeks = [(monday + datetime.timedelta(days=7 * i)).strftime("%Y%m%d") for i in range(300)]
        rows = []; rn = 0
        for (dv, pj, st, it) in TEST_KEYS:
            for w in weeks:
                for m, price in (("LOC", "100"), ("KRW", "130000"), ("USD", "100")):
                    rn += 1; rows.append(("M", dv, pj, st, "-", it, w, "USD", m, "E", "MPS", "DDP", price, "saveclob_test", "", "saveclob_test", str(rn)))
        p = ["^".join(c) for c in zip(*rows)]
        out(f"T5 payload rows={len(rows)} max param {max(len(x) for x in p):,}자 (p_SCM_SITE_ID {len(p[3]):,}자)")
        res, n1, sec, err = call_all(cur, p)
        out(f"T5 _ALL 정상 저장 → result={res} rc1(range over)={n1} {sec:.2f}s err={err}")
        after = counts(); out("T5 after", after)
        ok = res and str(res[0][0]) == "0" and after["SCM_MST_FUTURE_PRICE"] == len(rows) and after["SCM_MST_FUTURE_PRICE_H"] == len(rows) and after["DM_PLN_SALES_PLAN"] == 0
        out(f"T5 판정 → {'PASS' if ok else 'FAIL'} (원장 {after['SCM_MST_FUTURE_PRICE']}/{len(rows)} · 이력 {after['SCM_MST_FUTURE_PRICE_H']}/{len(rows)} · Sales Plan {after['DM_PLN_SALES_PLAN']}/0)")
        cur.execute(f"SELECT YYYYMMDD, MEASURE, CURRENCY, PRICE, CREATED_BY FROM SCM_MGR.SCM_MST_FUTURE_PRICE WHERE {keys_sql} ORDER BY ITEM_ID, YYYYMMDD, MEASURE FETCH FIRST 3 ROWS ONLY")
        out("T5 ledger sample", cur.fetchall())
        # 정리 (SP 내부 COMMIT 됨 → 테스트 행 삭제 + COMMIT)
        cur.execute(f"DELETE FROM SCM_MGR.SCM_MST_FUTURE_PRICE_H WHERE {keys_sql}"); d1 = cur.rowcount
        cur.execute(f"DELETE FROM SCM_MGR.SCM_MST_FUTURE_PRICE WHERE {keys_sql}"); d2 = cur.rowcount
        con.commit(); out(f"T5 cleanup deleted _H={d1} ledger={d2} → after", counts())
    (SNAP / f"test_{mode}_{datetime.datetime.now():%Y%m%d_%H%M%S}.log").write_text("\n".join(LOG) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
