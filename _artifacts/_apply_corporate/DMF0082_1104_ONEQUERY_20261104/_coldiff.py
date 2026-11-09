# -*- coding: utf-8 -*-
"""[E20261104-DMF0082ONEQUERY] 원본 vs 1104 — 6개 커서 전 행·전 열 값 직접 대조 (2026-11-06 사용자 요청 "모든 COLUMN 값 비교")

  python -I _coldiff.py <tag> [--pkgA PKG_DMF0082] [--pkgB PKG_DMF0082_1104] [--users k0101,minyonglee1] [--divs 40,81,82]
                        [--teams "81:70000342;81:70084589;82:30385415,70021414,71067318"] [--auto-teams]
  → _coldiff_<tag>.out / .json
  시나리오 = Current(ALL) + (--auto-teams: _team_sets.json 의 team1/team3) + (--teams: 실제 사용자 호출 팀 목록)
  판정(커서별): ① 열 이름·순서 동일 ② 행수 동일 ③ 행 다중집합(전 열 값) 동일 → 다르면 키열(버킷/수치 외) 기준으로 열별 차이·행 표본을 출력.
  값 정규화 없음(oracledb 반환값 그대로 repr 비교) — 숫자형(Decimal/float)·NULL·공백 차이도 전부 '차이'로 잡힌다.
파라미터 = FE 원문(미선택 ALL · itemId NULL · ADMIN · 당월1일~+6개월-1일 · Current). 호출 뒤 ROLLBACK(원장 변경 없음).
"""
import sys, os, json, time, datetime, argparse, re
from collections import Counter
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
ap = argparse.ArgumentParser(); ap.add_argument('tag'); ap.add_argument('--pkgA', default='PKG_DMF0082'); ap.add_argument('--pkgB', default='PKG_DMF0082_1104')
ap.add_argument('--users', default='k0101,minyonglee1'); ap.add_argument('--divs', default='40,81,82'); ap.add_argument('--teams', default='')
ap.add_argument('--auto-teams', action='store_true'); ap.add_argument('--sample', type=int, default=15)
A = ap.parse_args()
today = datetime.date.today(); frm = today.replace(day=1); m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
FRM, TO = frm.strftime("%Y%m%d"), to.strftime("%Y%m%d")
SETS_PATH = os.path.join(HERE, "_team_sets.json")
SETS = json.load(open(SETS_PATH, encoding='utf-8')) if (A.auto_teams and os.path.exists(SETS_PATH)) else {}
BUCKET = re.compile(r'^([DWM]_?)?\d{6,8}$')

cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor(); cx.call_timeout = 1800000
c.execute("SELECT sys_context('USERENV','SERVICE_NAME'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); ENV = list(c.fetchone())
PKGINFO = {}
for p in (A.pkgA, A.pkgB):
    c.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:p ORDER BY 1", p=p); PKGINFO[p] = c.fetchall()
log = open(os.path.join(HERE, f"_coldiff_{A.tag}.out"), 'a', encoding='utf-8')
def P(*a):
    s = ' '.join(str(x) for x in a); print(s, flush=True); log.write(s + '\n'); log.flush()
P(f"=== {A.tag} env={ENV} period={FRM}~{TO} A={A.pkgA} {PKGINFO[A.pkgA]} B={A.pkgB} {PKGINFO[A.pkgB]} users={A.users} divs={A.divs}")


def base(div, user, team="ALL"):
    return [div, team, "ALL", "ALL", FRM, TO, "ALL", None, "Current", "N", user, "ADMIN", "ALL", "ALL", "ALL", "ALL"]


def run(pkg, args):
    outs = [c.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
    t0 = time.time(); c.callproc(f"SCM_MGR.{pkg}.P_DMF0082_GET_MAIN_DATA", args + outs); t1 = time.time()
    res = []
    for v in outs:
        k = v.getvalue(); k.arraysize = 5000; rows = k.fetchall(); cols = [d[0] for d in k.description]
        res.append((cols, [tuple(r) for r in rows]))
    t2 = time.time(); cx.rollback()
    return round(t1 - t0, 2), round(t2 - t1, 2), res


def key_idx(cols, rows):
    """키열 = 버킷(D_/W_/M_yyyymmdd)·QTY 가 아닌 열. 값 비교 시 행 정렬·매칭에 사용."""
    return [i for i, n in enumerate(cols) if not BUCKET.match(n) and n not in ('QTY',)]


def diff_cursor(ci, ca, ra, cb, rb):
    out = {"cursor": ci, "colsA": len(ca), "colsB": len(cb), "rowsA": len(ra), "rowsB": len(rb), "cols_equal": ca == cb, "rows_equal": False, "only_a": 0, "only_b": 0, "col_diff": {}, "samples": []}
    if ca != cb:
        out["col_detail"] = {"onlyA": [x for x in ca if x not in cb], "onlyB": [x for x in cb if x not in ca], "order_diff": (sorted(ca) == sorted(cb))}
    cnta, cntb = Counter(ra), Counter(rb)
    only_a = cnta - cntb; only_b = cntb - cnta
    out["only_a"] = sum(only_a.values()); out["only_b"] = sum(only_b.values())
    out["rows_equal"] = (out["only_a"] == 0 and out["only_b"] == 0 and len(ra) == len(rb))
    if out["rows_equal"] or ca != cb:
        return out
    ki = key_idx(ca, ra)
    ga, gb = {}, {}
    for r, n in only_a.items(): ga.setdefault(tuple(r[i] for i in ki), []).append(r)
    for r, n in only_b.items(): gb.setdefault(tuple(r[i] for i in ki), []).append(r)
    keys_both = [k for k in ga if k in gb]
    out["keys_onlyA"] = len([k for k in ga if k not in gb]); out["keys_onlyB"] = len([k for k in gb if k not in ga]); out["keys_both"] = len(keys_both)
    coldiff = Counter(); samples = []
    for k in keys_both:
        for x in ga[k]:
            y = gb[k][0]
            for i, (va, vb) in enumerate(zip(x, y)):
                if va != vb:
                    coldiff[ca[i]] += 1
                    if len(samples) < A.sample: samples.append({"key": [str(v) for v in k][:8], "col": ca[i], "A": repr(va), "B": repr(vb)})
    out["col_diff"] = dict(coldiff.most_common()); out["samples"] = samples
    out["sample_onlyA"] = [dict(zip(ca, [str(v) for v in r])) for r in list(only_a)[:3]]
    out["sample_onlyB"] = [dict(zip(cb, [str(v) for v in r])) for r in list(only_b)[:3]]
    return out


RES = {"tag": A.tag, "env": ENV, "pkginfo": PKGINFO, "period": [FRM, TO], "results": []}
tot = {"scen": 0, "pass": 0, "fail": 0, "cursors": 0, "cursors_equal": 0}
for user in A.users.split(','):
    for div in A.divs.split(','):
        scen = [("Current", "ALL")]
        key = f"{user}_{div}"
        if key in SETS:
            t = SETS[key]["teams"]
            if len(t) >= 1: scen.append(("team1", t[0]))
            if len(t) >= 3: scen.append(("team3", ",".join(t[:3])))
        for spec in [s for s in A.teams.split(';') if s]:
            d, v = spec.split(':', 1)
            if d == div: scen.append((f"real_{v.replace(',', '+')}", v))
        for name, team in scen:
            at = datetime.datetime.now().strftime('%H:%M:%S')
            try:
                ta, fa, ra = run(A.pkgA, base(div, user, team)); tb, fb, rb = run(A.pkgB, base(div, user, team))
                curs = [diff_cursor(i + 1, ra[i][0], ra[i][1], rb[i][0], rb[i][1]) for i in range(6)]
                ok = all(x["cols_equal"] and x["rows_equal"] for x in curs)
                tot["scen"] += 1; tot["pass" if ok else "fail"] += 1; tot["cursors"] += 6; tot["cursors_equal"] += sum(1 for x in curs if x["cols_equal"] and x["rows_equal"])
                P(f"{at} {user} div{div} {name:32} {'PASS' if ok else 'FAIL'}  A={ta}+{fa}s B={tb}+{fb}s  rows " + " ".join(f"rc{x['cursor']}:{x['rowsA']}/{x['rowsB']}" for x in curs) + "  cols " + " ".join(f"{x['colsA']}/{x['colsB']}" for x in curs))
                for x in curs:
                    if not (x["cols_equal"] and x["rows_equal"]):
                        P(f"    rc{x['cursor']} cols_equal={x['cols_equal']} {x.get('col_detail','')} onlyA={x['only_a']} onlyB={x['only_b']} keys(onlyA/onlyB/both)={x.get('keys_onlyA')}/{x.get('keys_onlyB')}/{x.get('keys_both')} col_diff={x['col_diff']}")
                        for s in x["samples"][:8]: P(f"      key={s['key']} col={s['col']} A={s['A']} B={s['B']}")
                        for s in x.get("sample_onlyA", [])[:1]: P(f"      onlyA 행 예: {json.dumps(s, ensure_ascii=False)[:600]}")
                        for s in x.get("sample_onlyB", [])[:1]: P(f"      onlyB 행 예: {json.dumps(s, ensure_ascii=False)[:600]}")
                RES["results"].append({"user": user, "div": div, "scen": name, "team": team, "at": at, "ok": ok, "tA": [ta, fa], "tB": [tb, fb], "cursors": curs})
            except Exception as e:
                tot["scen"] += 1; tot["fail"] += 1
                P(f"{at} {user} div{div} {name:32} ERROR {str(e)[:300]}"); RES["results"].append({"user": user, "div": div, "scen": name, "team": team, "at": at, "ok": False, "error": str(e)[:300]})
                try: cx.rollback()
                except Exception: pass
            json.dump(RES, open(os.path.join(HERE, f"_coldiff_{A.tag}.json"), 'w', encoding='utf-8'), indent=1, ensure_ascii=False, default=str)
RES["total"] = tot
P(f"=== 합계: 시나리오 {tot['scen']} PASS {tot['pass']} FAIL {tot['fail']} · 커서 {tot['cursors']} 중 전 행·전 열 동일 {tot['cursors_equal']}  ({datetime.datetime.now().strftime('%H:%M:%S')})")
json.dump(RES, open(os.path.join(HERE, f"_coldiff_{A.tag}.json"), 'w', encoding='utf-8'), indent=1, ensure_ascii=False, default=str)
