"""[E20261012-DMF0082MANDCOL] 전/후 비교 — P_DMF0082_GET_MAIN_DATA 그리드 결과(O_RC1) 스냅샷 (읽기 전용 · 세션 GTT 만)

  python test_mandcol.py snap before   # 적용 전
  python test_mandcol.py snap after    # 적용 후
  python test_mandcol.py diff          # 비교 — 기대: 저장 내역에 필수 컬럼이 없는 사용자만 행이 늘고(합쳐졌던 줄 분리), 나머지는 완전 동일

대상 케이스는 실행 시점 DB 에서 고른다 (사용자·division 고정 가정 금지):
  A  division 40 · 컬럼 저장 내역에 CELL_PROD_SITE_ID 없는 사용자  → 변경 대상
  B  division 40 · 컬럼 저장 내역에 CELL_PROD_SITE_ID 있는 사용자  → 불변이어야 함
  C  division 81 · 컬럼 저장 내역에 PLANT_SITE_ID 없는 사용자      → 81 은 PLANT_SITE_ID 가 필수 컬럼 (변경 대상)
  D  division 40 · 컬럼 저장 내역에 PLANT_SITE_ID 없는 사용자      → 40 은 PLANT_SITE_ID 가 필수 아님 (그 축은 불변)
"""
import sys, os, json, hashlib, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
KEYS = ["DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP", "FCST_TYPE", "INCOTERMS", "MEASURE"]


def connect():
    u, p, d = conn_info()
    cn = oracledb.connect(user=u, password=p, dsn=d)
    cn.call_timeout = 1800000
    return cn


def pick_cases(cur):
    def users(col, has):
        cur.execute(f"""SELECT U.USER_ID FROM SCM_MST_TITLESET_USER U
                         WHERE U.PROGRAM_ID='DMF0082' AND U.SHEET_NAME='FcstNPrice' AND U.USER_INQUIRY_COLUMN_TYPE_CODE='C'
                         GROUP BY U.USER_ID
                        HAVING MAX(CASE WHEN U.COLUMN_NAME=:c THEN 1 ELSE 0 END) = :h
                         ORDER BY CASE U.USER_ID WHEN 'k0101' THEN 0 WHEN 'minyonglee1' THEN 1 ELSE 2 END, U.USER_ID""", c=col, h=has)
        return [r[0] for r in cur]
    no_cell, has_cell, no_plant = users("CELL_PROD_SITE_ID", 0), users("CELL_PROD_SITE_ID", 1), users("PLANT_SITE_ID", 0)
    print("CELL_PROD 미보유", len(no_cell), no_cell[:6], "/ 보유", len(has_cell), has_cell[:6], "/ PLANT 미보유", len(no_plant), no_plant[:6])
    cases = []
    if no_cell: cases.append(("A", "40", no_cell[0]))
    if has_cell: cases.append(("B", "40", has_cell[0]))
    if no_plant: cases.append(("C", "81", no_plant[0])); cases.append(("D", "40", no_plant[0]))
    return cases


def run(cur, div, user):
    rc = [cur.connection.cursor() for _ in range(6)]
    cur.execute("SELECT TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'), TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),6)-1,'YYYYMMDD') FROM dual")
    d_from, d_to = cur.fetchone()
    cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
                 [div, "ALL", "ALL", "ALL", d_from, d_to, "ALL", None, "Current", "N", user, "ADMIN", "ALL", "ALL", "ALL", "ALL"] + rc)
    c1 = rc[0]
    cols = [d[0] for d in c1.description]
    rows = c1.fetchall()
    idx = {c: i for i, c in enumerate(cols)}
    by_meas, split = {}, {}
    for r in rows:
        m = r[idx["MEASURE"]]
        by_meas[m] = by_meas.get(m, 0) + 1
        k = tuple(r[idx[c]] for c in KEYS if c in idx)
        split.setdefault(k, {"cell": set(), "plant": set()})
        split[k]["cell"].add(r[idx["CELL_PROD_SITE_ID"]])
        split[k]["plant"].add(r[idx["PLANT_SITE_ID"]])
    digest = hashlib.md5("\n".join(sorted(repr(tuple(str(v) for v in r)) for r in rows)).encode("utf-8")).hexdigest()
    cur.connection.rollback()
    return {"div": div, "user": user, "period": f"{d_from}~{d_to}", "cols": len(cols), "rows": len(rows), "by_measure": by_meas,
            "keys_multi_cell": sum(1 for v in split.values() if len(v["cell"]) > 1),
            "keys_multi_plant": sum(1 for v in split.values() if len(v["plant"]) > 1),
            "md5": digest}


def snap(tag):
    with connect() as con:
        cur = con.cursor()
        cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
        print("BODY", cur.fetchone())
        cur.execute("SELECT COUNT(*) FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' AND text LIKE '%[E20261012-DMF0082MANDCOL]%'")
        print("marker lines", cur.fetchone()[0])
        out = {}
        for case, div, user in pick_cases(cur):
            r = run(cur, div, user)
            out[case] = r
            print(case, r)
        json.dump(out, open(os.path.join(HERE, f"_snap_{tag}.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)


def diff():
    b = json.load(open(os.path.join(HERE, "_snap_before.json"), encoding="utf-8"))
    a = json.load(open(os.path.join(HERE, "_snap_after.json"), encoding="utf-8"))
    for case in sorted(set(b) | set(a)):
        x, y = b.get(case), a.get(case)
        if not x or not y:
            print(case, "ERROR — 한쪽 스냅샷 없음"); continue
        same = x["md5"] == y["md5"]
        print(f"{case} div {x['div']} user {x['user']}: rows {x['rows']} -> {y['rows']} · 같은 키에 Cell Prod 2개↑ {x['keys_multi_cell']} -> {y['keys_multi_cell']}"
              f" · Plant 2개↑ {x['keys_multi_plant']} -> {y['keys_multi_plant']} · {'동일' if same else '변경'}")
        if not same:
            for m in sorted(set(x["by_measure"]) | set(y["by_measure"])):
                if x["by_measure"].get(m, 0) != y["by_measure"].get(m, 0):
                    print(f"     {m}: {x['by_measure'].get(m, 0)} -> {y['by_measure'].get(m, 0)}")


if __name__ == "__main__":
    if sys.argv[1] == "snap":
        snap(sys.argv[2])
    else:
        diff()
