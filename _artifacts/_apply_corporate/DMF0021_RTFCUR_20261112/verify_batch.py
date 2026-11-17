# -*- coding: utf-8 -*-
"""[E20261112-RTFCUR] 검증 — 환율 적용 배치(40)를 화면과 같은 인자로 1회 실행하고 원장 전후를 행 단위로 대조.
사용: python verify_batch.py snap <이름> | run | diff <전> <후>"""
import sys, json, pathlib, time, oracledb
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
HERE = pathlib.Path(__file__).resolve().parent
KEYS = "PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, MEASURE, YYYYMMDD"
u, p, d = conn_info()
cmd = sys.argv[1]
if cmd == "diff":
    a = json.loads((HERE / f"snap_{sys.argv[2]}.json").read_text(encoding="utf-8"))["rows"]
    b = json.loads((HERE / f"snap_{sys.argv[3]}.json").read_text(encoding="utf-8"))["rows"]
    ka, kb = set(a), set(b)
    print("행 수 전", len(a), "후", len(b), "전에만", len(ka - kb), "후에만", len(kb - ka))
    qd = [k for k in ka & kb if a[k][0] != b[k][0]]; cd = [k for k in ka & kb if a[k][1] != b[k][1]]
    print("수량 달라진 행", len(qd), "통화 달라진 행", len(cd))
    from collections import Counter
    print("통화 변화 유형(전→후 · 메저)", Counter((str(a[k][1]), str(b[k][1]), k.split("|")[8]) for k in cd).most_common(20))
    for k in sorted(qd)[:10]: print(" 수량", k, a[k], "→", b[k])
    for k in sorted(ka - kb)[:10]: print(" 전에만", k, a[k])
    for k in sorted(kb - ka)[:10]: print(" 후에만", k, b[k])
    tgt = [k for k in sorted(kb) if "|SpaceX_US_XLC|MCCM348015A1-000|" in k and k.split("|")[8].startswith("RTF") and k.split("|")[9] >= "20261201"]
    for k in tgt: print(" 대상", k.split("|")[8], k.split("|")[9], "전", a.get(k), "후", b[k])
    sys.exit(0)
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); now = cur.fetchone()[0]; print("DB 시각", now)
    if cmd == "snap":
        cur.execute(f"SELECT {KEYS}, QTY, CURRENCY FROM SCM_MGR.DM_PLN_SALES_PLAN WHERE DIVISION_ID='40' AND YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')")
        rows = {"|".join("" if v is None else str(v) for v in r[:10]): [r[10], r[11]] for r in cur}
        (HERE / f"snap_{sys.argv[2]}.json").write_text(json.dumps({"at": now, "rows": rows}, ensure_ascii=False), encoding="utf-8")
        print("스냅샷", sys.argv[2], len(rows), "행 · 통화 NULL", sum(1 for v in rows.values() if v[1] is None))
    elif cmd == "run":
        t = time.time()
        cur.callproc("SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW", ["40", "EXCHANGE_RATE_UI"])
        con.commit(); print("배치 실행 완료 · 소요(초)", round(time.time() - t, 1))
