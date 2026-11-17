# -*- coding: utf-8 -*-
"""사내(ZIOUI1) 시험용 — DM_PLN_CFM_SELLING_PRICE 의 한 키에서 2027-01 이후 판가 삭제 (사용자 요청 2026-11-12).
목적: DMF0021 에서 단가 없는 구간에 RTF 입력 시 최근 단가를 가져오는지 확인.
삭제 전 전체 행을 backup_rows.json 에 남긴다. 되돌리기: python delete_price.py --restore"""
import sys, json, pathlib, datetime, oracledb
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
HERE = pathlib.Path(__file__).resolve().parent; BK = HERE / "backup_rows.json"
T = "SCM_MGR.DM_PLN_CFM_SELLING_PRICE"
KEY = dict(d='40', s='SpaceX_US_XLC', i='MCCM348015A1-000', p='SpaceX', c='HQ06-A', f='MPS', n='FCA', e='E')
W = ("DIVISION_ID=:d AND SCM_SITE_ID=:s AND ITEM_ID=:i AND PROJECT_CODE=:p AND CELL_PROD_SITE_ID=:c "
     "AND FCST_TYPE=:f AND INCOTERMS=:n AND DOM_EXP=:e")
u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST')||'/'||SYS_CONTEXT('USERENV','SERVICE_NAME')||' '||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print("DB", cur.fetchone()[0])
    def cnt():
        cur.execute(f"SELECT MEASURE, COUNT(*), SUM(CASE WHEN YYYYMMDD>='20270101' THEN 1 ELSE 0 END), MAX(YYYYMMDD) FROM {T} WHERE {W} GROUP BY MEASURE ORDER BY 1", KEY); return cur.fetchall()
    if "--restore" in sys.argv:
        rows = json.loads(BK.read_text(encoding="utf-8")); cols = rows["cols"]
        dts = [n for n, c in enumerate(cols) if c in ("CREATION_DATE", "LAST_UPDATE_DATE")]
        data = [[(datetime.datetime.strptime(v, "%Y-%m-%d %H:%M:%S") if (n in dts and v) else v) for n, v in enumerate(r)] for r in rows["rows"]]
        cur.execute(f"SELECT COUNT(*) FROM {T} WHERE {W} AND YYYYMMDD >= '20270101'", KEY)
        assert cur.fetchone()[0] == 0, "2027-01 이후 판가가 이미 있음 — 겹칠 수 있어 복원 중단"
        sql = f"INSERT INTO {T} ({','.join(cols)}) VALUES ({','.join(':' + str(n + 1) for n in range(len(cols)))})"
        cur.executemany(sql, data); print("복원 행", cur.rowcount); con.commit(); print("복원 후", cnt()); sys.exit(0)
    print("삭제 전 (메저, 전체, 2027-01 이후, 최종일)", cnt())
    cur.execute(f"SELECT * FROM {T} WHERE {W} AND YYYYMMDD >= '20270101' ORDER BY MEASURE, YYYYMMDD", KEY)
    cols = [x[0] for x in cur.description]
    rows = [[v.strftime("%Y-%m-%d %H:%M:%S") if isinstance(v, datetime.datetime) else v for v in r] for r in cur.fetchall()]
    assert not BK.exists(), "backup_rows.json 이 이미 있음 — 덮어쓰지 않는다"
    BK.write_text(json.dumps({"table": T, "key": KEY, "cols": cols, "rows": rows}, ensure_ascii=False, indent=0, default=str), encoding="utf-8")
    print("백업", len(rows), "행 →", BK.name)
    cur.execute(f"DELETE FROM {T} WHERE {W} AND YYYYMMDD >= '20270101'", KEY)
    n = cur.rowcount; assert n == len(rows), (n, len(rows))
    con.commit(); print("삭제", n, "행 · COMMIT")
    print("삭제 후 (메저, 전체, 2027-01 이후, 최종일)", cnt())
    cur.execute(f"SELECT MEASURE, YYYYMMDD, PRICE, CURRENCY FROM {T} WHERE {W} AND YYYYMMDD >= '20261201' ORDER BY MEASURE, YYYYMMDD", KEY)
    print("남은 2026-12 판가", cur.fetchall())
