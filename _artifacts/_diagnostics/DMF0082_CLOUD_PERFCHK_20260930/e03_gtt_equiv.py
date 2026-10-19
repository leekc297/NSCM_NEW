# -*- coding: utf-8 -*-
"""GET_MAIN_DATA 실행 직후 같은 세션에서 GT_DMF0082_TEMP_FCST_N_PRICE 전 행·전 컬럼 SHA (중간 산출 등가 — #129 §12.1).

ONEREAD(판가 원장 1회 읽기) 검증용: 판가 행의 CREATE_DATE·LAST_UPDATED_BY 가 결과 커서에 다 드러나지 않을 수 있어 GTT 로 직접 대조.
매트릭스 = 사용자 2 × division 40·81·82 × Current (40 은 비변경 대조군).
사용: python e03_gtt_equiv.py <tag>  |  python e03_gtt_equiv.py diff <A> <B>
"""
import io, sys, json, time, hashlib, pathlib, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
from ora import conn_info
import oracledb

TAG = sys.argv[1] if len(sys.argv) > 1 else "before"
if TAG == "diff":
    a = json.loads((HERE / f"e03_{sys.argv[2]}.json").read_text(encoding="utf-8"))
    b = json.loads((HERE / f"e03_{sys.argv[3]}.json").read_text(encoding="utf-8"))
    fail = 0
    for k in a:
        for part in ("all", "price", "price_ld"):
            same = a[k][part]["sha"] == b[k][part]["sha"]
            fail += not same
            print(f"{k:16} {part:9} {'PASS' if same else 'FAIL'}  rows {a[k][part]['rows']} → {b[k][part]['rows']}")
        print(f"{k:16} SP {a[k]['sp']:.2f}s → {b[k]['sp']:.2f}s")
    print(f"\nFAIL {fail}")
    sys.exit(0)

today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 1800000
cur = cn.cursor()
cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME='PKG_DMF0082'"
            " AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL=0 ORDER BY POSITION")
ARGS = cur.fetchall()
cur.execute("SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME='GT_DMF0082_TEMP_FCST_N_PRICE' ORDER BY COLUMN_ID")
COLS = [c for (c,) in cur]


def sha(sql):
    cur.execute(sql)
    rows = ["|".join("" if v is None else str(v) for v in r) for r in cur]
    rows.sort()
    return {"rows": len(rows), "sha": hashlib.sha256("\n".join(rows).encode()).hexdigest()[:16]}


out = {}
for user in ("minyonglee1", "k0101"):
    for div in ("40", "81", "82"):
        P = {"P_DIVISION_ID": div, "P_TEAM_ID": "ALL", "P_CUSTOMER": "ALL", "P_BIZ_TYPE": "ALL",
             "P_FROM_YYYYMMDD": frm.strftime("%Y%m%d"), "P_TO_YYYYMMDD": to.strftime("%Y%m%d"), "P_SCM_SITE_ID": "ALL",
             "P_ITEM_ID": None, "P_VERSION_TYPE": "Current", "P_QTY_YN": "N", "P_CREATED_BY": user, "P_USER_GROUP": "ADMIN",
             "P_PLANT_SITE_ID": "ALL", "P_PROJECT_CODE": "ALL", "P_OWNER": "ALL", "P_SENDER_CODE": "ALL"}
        args = [P[a] if io_ == "IN" else cn.cursor() for a, io_ in ARGS]
        t0 = time.time()
        cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", args)
        sp = time.time() - t0
        for a in args:
            if isinstance(a, oracledb.Cursor):
                try:
                    a.fetchall()
                except oracledb.Error:
                    pass
        base = f"SELECT {', '.join(COLS)} FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE"
        k = f"{user}/{div}"
        out[k] = {"sp": sp,
                  "all": sha(base),
                  "price": sha(base + " WHERE NOTATION = 'POINT3'"),
                  "price_ld": sha("SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, "
                                  "YYYYMMDD, PLANT_SITE_ID, CURRENCY, QTY, TO_CHAR(CREATE_DATE,'YYYYMMDDHH24MISS'), LAST_UPDATED_BY "
                                  "FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE WHERE NOTATION = 'POINT3'")}
        cur.execute("SELECT COUNT(*), COUNT(CREATE_DATE), COUNT(LAST_UPDATED_BY) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE WHERE NOTATION='POINT3'")
        n, nc, nl = cur.fetchone()
        print(f"{k:16} SP {sp:6.2f}s  GTT {out[k]['all']['rows']:>7}  판가 {n:>6} (CREATE_DATE 채움 {nc} · LAST_UPDATED_BY 채움 {nl})  sha {out[k]['price_ld']['sha']}")
        cn.rollback()
(HERE / f"e03_{TAG}.json").write_text(json.dumps(out, ensure_ascii=False, indent=1), encoding="utf-8")
cn.close()
