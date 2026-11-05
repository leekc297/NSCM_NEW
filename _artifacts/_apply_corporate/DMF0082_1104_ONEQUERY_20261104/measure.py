# -*- coding: utf-8 -*-
"""[E20261104-DMF0082ONEQUERY] GET_MAIN_DATA 벽시계·행수·digest 측정 (hook #129 0-b)

  python measure.py <PKG> <tag> [runs=3] [users=k0101,minyonglee1] [divs=40,81,82] [ver=Current]
  → _measure_<tag>.json / .log  (호출마다 proc·fetch 초, 커서별 행수, 정렬 digest, 순서 digest)
  첫 호출 직후 같은 세션에서 게이트 실측: TEMP_SITE_ITEM 4키 유일성 · TEMP_SELECT_MEASURE 중복 · PARAM_TOKEN 빈 토큰 · 59열 중복
  측정 전후 원장 변경 감시(MAX(LAST_UPDATE_DATE)·COUNT) 기록
파라미터 = FE 원문(미선택 'ALL', itemId NULL, userGroup ADMIN, 기간 당월1일~+6개월-1일)
"""
import sys, os, json, time, hashlib, datetime, statistics
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = sys.argv[1]; TAG = sys.argv[2]
RUNS = int(sys.argv[3]) if len(sys.argv) > 3 else 3
USERS = (sys.argv[4] if len(sys.argv) > 4 else "k0101,minyonglee1").split(',')
DIVS = (sys.argv[5] if len(sys.argv) > 5 else "40,81,82").split(',')
VER = sys.argv[6] if len(sys.argv) > 6 else "Current"
today = datetime.date.today(); frm = today.replace(day=1); m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
FRM, TO = frm.strftime("%Y%m%d"), to.strftime("%Y%m%d")

LEDGERS = ["DM_PLN_MKT_FCST", "DM_PLN_CFM_MKT_DEMAND_PLAN", "SCM_MST_FUTURE_PRICE", "DM_PLN_CFM_SELLING_PRICE",
           "DM_PLN_SALES_PLAN", "DM_PLN_SALES_PLAN_RESULT", "DM_PLN_MKT_FCST_RESULT", "SCM_MST_SITE_ITEM", "SCM_MST_TITLESET_USER"]
GATES = {
    "site_item_4key": "SELECT COUNT(*), COUNT(DISTINCT DIVISION_ID||'|'||PROJECT_CODE||'|'||SCM_SITE_ID||'|'||ITEM_ID) FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM",
    "site_item_6key": "SELECT COUNT(*), COUNT(DISTINCT DIVISION_ID||'|'||PROJECT_CODE||'|'||SCM_SITE_ID||'|'||ITEM_ID||'|'||NICK_NAME||'|'||PROJECT_NAME) FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM",
    "sel_measure_dup": "SELECT COUNT(*), COUNT(DISTINCT MEASURE), COUNT(DISTINCT RESULT_MEASURE) FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE",
    "param_token_empty": "SELECT COUNT(*), SUM(CASE WHEN TOKEN IS NULL OR TRIM(TOKEN) IS NULL THEN 1 ELSE 0 END) FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN",
    "fnp_rows": "SELECT COUNT(*), COUNT(DISTINCT MEASURE) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE",
    "mf_sp_rows": "SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_MF_SP",
}


def ledger(c):
    out = {}
    for t in LEDGERS:
        try:
            c.execute(f"SELECT COUNT(*), TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.{t}")
            out[t] = list(c.fetchone())
        except Exception as e:
            out[t] = f"ERR {str(e)[:80]}"
    return out


def digest(rows):
    srt = hashlib.md5(''.join(sorted(hashlib.md5(repr(x).encode()).hexdigest() for x in rows)).encode()).hexdigest()
    ordd = hashlib.md5(''.join(hashlib.md5(repr(x).encode()).hexdigest() for x in rows).encode()).hexdigest()
    return srt, ordd


cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor(); cx.call_timeout = 1800000
c.execute("SELECT sys_context('USERENV','SERVICE_NAME'), sys_context('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
env = list(c.fetchone())
c.execute("SELECT ARGUMENT_NAME, IN_OUT FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME=:p AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL=0 ORDER BY POSITION", p=PKG)
ARGS = c.fetchall()
c.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:p ORDER BY 1", p=PKG)
pkginfo = c.fetchall()
log = open(os.path.join(HERE, f"_measure_{TAG}.log"), 'a', encoding='utf-8')
def P(*a):
    s = ' '.join(str(x) for x in a); print(s, flush=True); log.write(s + '\n'); log.flush()
P(f"=== {TAG} pkg={PKG} env={env} pkg={pkginfo} period={FRM}~{TO} ver={VER} users={USERS} divs={DIVS} runs={RUNS}")
res = {"tag": TAG, "pkg": PKG, "env": env, "pkginfo": pkginfo, "period": [FRM, TO], "ver": VER, "ledger_before": ledger(c), "calls": [], "gates": {}}


def call(user, div):
    Pm = {"P_DIVISION_ID": div, "P_TEAM_ID": "ALL", "P_CUSTOMER": "ALL", "P_BIZ_TYPE": "ALL", "P_FROM_YYYYMMDD": FRM, "P_TO_YYYYMMDD": TO,
          "P_SCM_SITE_ID": "ALL", "P_ITEM_ID": None, "P_VERSION_TYPE": VER, "P_QTY_YN": "N", "P_CREATED_BY": user, "P_USER_GROUP": "ADMIN",
          "P_PLANT_SITE_ID": "ALL", "P_PROJECT_CODE": "ALL", "P_OWNER": "ALL", "P_SENDER_CODE": "ALL"}
    ins, outs = [], []
    for a, io in ARGS:
        ins.append(Pm[a]) if io == "IN" else outs.append(c.var(oracledb.DB_TYPE_CURSOR))
    t0 = time.time(); c.callproc(f"SCM_MGR.{PKG}.P_DMF0082_GET_MAIN_DATA", ins + outs); t1 = time.time()
    curs = []
    for v in outs:
        k = v.getvalue(); k.arraysize = 5000; rows = k.fetchall(); cols = [d[0] for d in k.description]
        srt, ordd = digest(rows); curs.append({"rows": len(rows), "cols": len(cols), "srt": srt, "ord": ordd})
    t2 = time.time()
    return round(t1 - t0, 3), round(t2 - t1, 3), curs


for user in USERS:
    for div in DIVS:
        for i in range(RUNS):
            at = datetime.datetime.now().strftime('%H:%M:%S')
            try:
                proc, fetch, curs = call(user, div)
                rec = {"user": user, "div": div, "run": i + 1, "at": at, "proc": proc, "fetch": fetch, "curs": curs}
                P(f"{at} {user} {div} r{i+1} proc={proc}s fetch={fetch}s rows={[x['rows'] for x in curs]} rc1={curs[0]['srt'][:10]}/{curs[0]['ord'][:10]}")
                if i == 0:
                    g = {}
                    for k, q in GATES.items():
                        try: c.execute(q); g[k] = list(c.fetchone())
                        except Exception as e: g[k] = f"ERR {str(e)[:80]}"
                    res["gates"][f"{user}_{div}"] = g; P("   gates", g)
            except Exception as e:
                rec = {"user": user, "div": div, "run": i + 1, "at": at, "error": str(e)[:300]}; P(f"{at} {user} {div} r{i+1} ERROR {rec['error']}")
            res["calls"].append(rec); cx.rollback()
            json.dump(res, open(os.path.join(HERE, f"_measure_{TAG}.json"), 'w', encoding='utf-8'), indent=1, ensure_ascii=False)
res["ledger_after"] = ledger(c)
chg = {t: (res["ledger_before"][t], res["ledger_after"][t]) for t in LEDGERS if res["ledger_before"][t] != res["ledger_after"][t]}
P("ledger changed:", chg if chg else "none")
P("--- median (proc / fetch / rc1 rows)")
for user in USERS:
    for div in DIVS:
        rr = [x for x in res["calls"] if x["user"] == user and x["div"] == div and "proc" in x]
        if rr:
            P(f"{user} {div}: proc {statistics.median(x['proc'] for x in rr):.2f}s fetch {statistics.median(x['fetch'] for x in rr):.2f}s rows {sorted(set(x['curs'][0]['rows'] for x in rr))} digests {len(set(x['curs'][0]['srt'] for x in rr))}")
json.dump(res, open(os.path.join(HERE, f"_measure_{TAG}.json"), 'w', encoding='utf-8'), indent=1, ensure_ascii=False)
