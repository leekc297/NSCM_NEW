# -*- coding: utf-8 -*-
"""[E20261104-DMF0082ONEQUERY] Team(p_team_id) 단일/복수 선택 속도 비교 프로브 (2026-11-06 사용자 요청 "team 멀티 선택 시 속도 저하")

  python -I _team_probe.py <PKG> <tag> [runs=2] [users=k0101,minyonglee1] [divs=40,81,82]
  → _team_probe_<tag>.json / .out
  팀 집합은 첫 호출(team=ALL) 직후 같은 세션의 GT_DMF0082_TEMP_FCST_N_PRICE DEPT_ID 분포(행수 상위)로 뽑아 _team_sets.json 에 저장하고
  이후 패키지(원본/1104) 측정에서 같은 집합을 재사용한다 (사전 데이터셋 금지 — 실데이터 기준).
  시나리오: ALL / 1팀 / 2팀 / 3팀 / 5팀 / 전체 팀 나열(N팀). 각 proc·fetch·행수 기록. 끝은 ROLLBACK.
파라미터 = measure.py 와 동일(FE 원문 · 당월1일~+6개월-1일 · Current · ADMIN).
"""
import sys, os, json, time, datetime, statistics
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = sys.argv[1]; TAG = sys.argv[2]
RUNS = int(sys.argv[3]) if len(sys.argv) > 3 else 2
USERS = (sys.argv[4] if len(sys.argv) > 4 else "k0101,minyonglee1").split(',')
DIVS = (sys.argv[5] if len(sys.argv) > 5 else "40,81,82").split(',')
today = datetime.date.today(); frm = today.replace(day=1); m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
FRM, TO = frm.strftime("%Y%m%d"), to.strftime("%Y%m%d")
SETS_PATH = os.path.join(HERE, "_team_sets.json")
SETS = json.load(open(SETS_PATH, encoding='utf-8')) if os.path.exists(SETS_PATH) else {}

cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor(); cx.call_timeout = 1800000
c.execute("SELECT sys_context('USERENV','SERVICE_NAME'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); env = list(c.fetchone())
c.execute("SELECT ARGUMENT_NAME, IN_OUT FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME=:p AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL=0 ORDER BY POSITION", p=PKG)
ARGS = c.fetchall()
c.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:p ORDER BY 1", p=PKG)
pkginfo = c.fetchall()
log = open(os.path.join(HERE, f"_team_probe_{TAG}.out"), 'a', encoding='utf-8')
def P(*a):
    s = ' '.join(str(x) for x in a); print(s, flush=True); log.write(s + '\n'); log.flush()
P(f"=== {TAG} pkg={PKG} env={env} pkg={pkginfo} period={FRM}~{TO} users={USERS} divs={DIVS} runs={RUNS}")
res = {"tag": TAG, "pkg": PKG, "env": env, "pkginfo": pkginfo, "period": [FRM, TO], "calls": [], "team_sets": {}}


def call(user, div, team):
    Pm = {"P_DIVISION_ID": div, "P_TEAM_ID": team, "P_CUSTOMER": "ALL", "P_BIZ_TYPE": "ALL", "P_FROM_YYYYMMDD": FRM, "P_TO_YYYYMMDD": TO,
          "P_SCM_SITE_ID": "ALL", "P_ITEM_ID": None, "P_VERSION_TYPE": "Current", "P_QTY_YN": "N", "P_CREATED_BY": user, "P_USER_GROUP": "ADMIN",
          "P_PLANT_SITE_ID": "ALL", "P_PROJECT_CODE": "ALL", "P_OWNER": "ALL", "P_SENDER_CODE": "ALL"}
    ins, outs = [], []
    for a, io in ARGS:
        ins.append(Pm[a]) if io == "IN" else outs.append(c.var(oracledb.DB_TYPE_CURSOR))
    t0 = time.time(); c.callproc(f"SCM_MGR.{PKG}.P_DMF0082_GET_MAIN_DATA", ins + outs); t1 = time.time()
    rows = None
    for i, v in enumerate(outs):
        k = v.getvalue(); k.arraysize = 5000; r = k.fetchall()
        if i == 0: rows = len(r)
    t2 = time.time()
    return round(t1 - t0, 3), round(t2 - t1, 3), rows


def team_dist():
    c.execute("SELECT DEPT_ID, COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE WHERE DEPT_ID IS NOT NULL GROUP BY DEPT_ID ORDER BY 2 DESC, 1")
    return c.fetchall()


for user in USERS:
    for div in DIVS:
        key = f"{user}_{div}"
        # 1) ALL 호출 → 팀 분포 표본 (ROLLBACK 전)
        proc, fetch, rows = call(user, div, "ALL")
        dist = team_dist()
        if key not in SETS:
            teams = [d for d, _ in dist]
            SETS[key] = {"dist": [[d, n] for d, n in dist], "teams": teams}
            json.dump(SETS, open(SETS_PATH, 'w', encoding='utf-8'), indent=1, ensure_ascii=False)
        teams = SETS[key]["teams"]
        res["team_sets"][key] = SETS[key]
        P(f"{datetime.datetime.now().strftime('%H:%M:%S')} {key} ALL(warm) proc={proc}s fetch={fetch}s rows={rows} teams(n={len(teams)}) top={SETS[key]['dist'][:5]}")
        cx.rollback()
        scen = [("ALL", "ALL")]
        for n in (1, 2, 3, 5):
            if len(teams) >= n: scen.append((f"team{n}", ",".join(teams[:n])))
        if len(teams) > 5: scen.append((f"teamN{len(teams)}", ",".join(teams)))
        # 실제 사용자 호출 재현(env TEAM_EXTRA="81:70000342;81:70084589;82:30385415,70021414,71067318" — SCM_SYS_LOG_BATCH 11-06 실례)
        for spec in [s for s in os.environ.get("TEAM_EXTRA", "").split(';') if s]:
            d, v = spec.split(':', 1)
            if d == div: scen.append((f"real_{v.replace(',', '+')}", v))
        for name, val in scen:
            for i in range(RUNS):
                at = datetime.datetime.now().strftime('%H:%M:%S')
                try:
                    proc, fetch, rows = call(user, div, val)
                    rec = {"user": user, "div": div, "scen": name, "ntok": (0 if val == "ALL" else val.count(',') + 1), "run": i + 1, "at": at, "proc": proc, "fetch": fetch, "rows": rows}
                    P(f"{at} {key} {name} r{i+1} proc={proc}s fetch={fetch}s rows={rows}")
                except Exception as e:
                    rec = {"user": user, "div": div, "scen": name, "run": i + 1, "at": at, "error": str(e)[:300]}; P(f"{at} {key} {name} r{i+1} ERROR {rec['error']}")
                res["calls"].append(rec); cx.rollback()
                json.dump(res, open(os.path.join(HERE, f"_team_probe_{TAG}.json"), 'w', encoding='utf-8'), indent=1, ensure_ascii=False)

P("--- median (proc / fetch / rows) by user,div,scen")
for user in USERS:
    for div in DIVS:
        for name in ["ALL", "team1", "team2", "team3", "team5"] + [k for k in sorted({x["scen"] for x in res["calls"]}) if k.startswith("teamN")]:
            rr = [x for x in res["calls"] if x["user"] == user and x["div"] == div and x["scen"] == name and "proc" in x]
            if rr:
                P(f"{user} {div} {name}(ntok={rr[0]['ntok']}): proc {statistics.median(x['proc'] for x in rr):.2f}s fetch {statistics.median(x['fetch'] for x in rr):.2f}s total {statistics.median(x['proc']+x['fetch'] for x in rr):.2f}s rows {sorted(set(x['rows'] for x in rr))}")
json.dump(res, open(os.path.join(HERE, f"_team_probe_{TAG}.json"), 'w', encoding='utf-8'), indent=1, ensure_ascii=False)
