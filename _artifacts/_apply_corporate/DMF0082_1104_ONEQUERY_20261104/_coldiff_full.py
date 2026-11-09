# -*- coding: utf-8 -*-
"""[E20261104-DMF0082ONEQUERY] 원본 PKG_DMF0082 vs PKG_DMF0082_1104 — 직접 대조 · 6개 커서 전 행·전 열 값 (2026-11-09 사용자 재확인 요청)

  python -I _coldiff_full.py <tag> [--pkgA PKG_DMF0082] [--pkgB PKG_DMF0082_1104] [--users k0101,minyonglee1] [--divs 40,81,82]
                             [--scen current,teams,ver,multi,filters] [--only <이름부분문자열>]
  → _coldiff_full_<tag>.out / .json

시나리오(사용자 × 사업부): Current · 팀(team1/team3 = _team_sets.json · 실사용 팀) · 버전 단일 MF_W/SF_W/SP_W/MF_D(조회기간 데이터 있는 최신)
                           · 복수 Current,MF_W / Current,SP_W · 필터 9종(site·item·cust·biz·project·owner·team·plant·sender) · qty=Y
  표본 값 = A(원본) Current 호출 직후 세션 GTT 최빈값 (compare.py 와 동일 · 사전 데이터셋 없음)
판정(커서 6개 모두, 커서3 포함):
  ① 열 이름·순서 동일  ② 행수 동일  ③ 행 다중집합(전 열 값, oracledb 반환값 repr 그대로 · 정규화 없음) 동일
  ④ 출력 순서: 행 순서 완전 동일 = ORDER_SAME / 다르면 ORDER BY 키열 순서 동일 여부(동률 행끼리 순서만 다름 = ORDER_TIE)
  불일치 시: A 를 한 번 더 호출(A2)해 A↔A2 가 다르면 운영 데이터 변동(DRIFT), A2↔B 동일이면 DRIFT_RESOLVED 로 별도 표기.
파라미터 = FE 원문(미선택 ALL · itemId NULL · ADMIN · 당월1일~+6개월-1일). 호출 뒤 ROLLBACK(원장 변경 없음).
"""
import sys, os, json, time, datetime, argparse, re, hashlib
from collections import Counter
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
ap = argparse.ArgumentParser(); ap.add_argument('tag')
ap.add_argument('--pkgA', default='PKG_DMF0082'); ap.add_argument('--pkgB', default='PKG_DMF0082_1104')
ap.add_argument('--users', default='k0101,minyonglee1'); ap.add_argument('--divs', default='40,81,82')
ap.add_argument('--scen', default='current,teams,ver,multi,filters'); ap.add_argument('--only', default='')
ap.add_argument('--real-teams', default='81:70000342;81:70084589;82:30385415,70021414,71067318')
ap.add_argument('--sample', type=int, default=10)
A = ap.parse_args(); SCEN = A.scen.split(',')
today = datetime.date.today(); frm = today.replace(day=1); m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
FRM, TO = frm.strftime("%Y%m%d"), to.strftime("%Y%m%d")
SETS_PATH = os.path.join(HERE, "_team_sets.json")
SETS = json.load(open(SETS_PATH, encoding='utf-8')) if os.path.exists(SETS_PATH) else {}
BUCKET = re.compile(r'^([DWM]_?)?\d{6,8}$')

cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor(); cx.call_timeout = 3600000
c.execute("SELECT sys_context('USERENV','SERVICE_NAME'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); ENV = list(c.fetchone())
PKGINFO = {}
for p in (A.pkgA, A.pkgB):
    c.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:p ORDER BY 1", p=p)
    PKGINFO[p] = c.fetchall()
log = open(os.path.join(HERE, f"_coldiff_full_{A.tag}.out"), 'a', encoding='utf-8')


def P(*a):
    s = ' '.join(str(x) for x in a); print(s, flush=True); log.write(s + '\n'); log.flush()


P(f"=== {A.tag} env={ENV} period={FRM}~{TO} A={A.pkgA} {PKGINFO[A.pkgA]} B={A.pkgB} {PKGINFO[A.pkgB]} users={A.users} divs={A.divs} scen={SCEN}")

SYS_ORD = ['GROUP_ID', 'VERSION_NO', 'BUCKET', 'NEW_FLAG', 'ATTR1', 'VMI_STD_DIO', 'AS_YN']
EXCL_ORD = {'LAST_UPDATE_DATE', 'LAST_UPDATED_BY', 'EDIT_FLAG', 'SORT_KEY', 'MEASURE', 'MEASURE_GROUP'}


def order_idx(user, cols):
    """compare.py order_cols 와 동일 — 원문 V_ORDERBY 근사(SORT_KEY + 사용자 C 열 + 시스템 열 − 제외 + SORT_ORDER_NO)"""
    c.execute("SELECT COLUMN_NAME FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND USER_ID=:u AND USER_INQUIRY_COLUMN_TYPE_CODE='C' ORDER BY SORT_ORDER_NO", u=user)
    ucols = [r[0] for r in c.fetchall()] + SYS_ORD
    keys = [x for x in ucols if x in cols and x not in EXCL_ORD]
    if 'SORT_ORDER_NO' not in keys: keys.append('SORT_ORDER_NO')
    return [cols.index(x) for x in keys if x in cols]


def base(div, user, **k):
    return [div, k.get("team", "ALL"), k.get("cust", "ALL"), k.get("biz", "ALL"), FRM, TO, k.get("site", "ALL"), k.get("item"), k.get("ver", "Current"),
            k.get("qty", "N"), user, "ADMIN", k.get("plant", "ALL"), k.get("project", "ALL"), k.get("owner", "ALL"), k.get("sender", "ALL")]


CLOCK_COLS = {'TODAY_TIME'}   # 커서3 SUBSTR(REPLACE(TO_CHAR(SYSDATE,'HH24:MI:SS'),':',''),1,4) — 원본 L5372 · 1104 L16271 동일식 = 호출 시각(HHMI)


def dbclock():
    c.execute("SELECT TO_CHAR(SYSDATE,'HH24MI') FROM DUAL"); return c.fetchone()[0]


def run(pkg, args, keep=False):
    """반환 res 의 각 커서 = (cols, rows) · 커서3 시각열은 호출 직전/직후 DB 시각 범위 검사 후 '<CLOCK_OK>'/'<CLOCK_BAD:v>' 로 치환(나머지 열은 원값)"""
    outs = [c.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
    k0 = dbclock()
    t0 = time.time(); c.callproc(f"SCM_MGR.{pkg}.P_DMF0082_GET_MAIN_DATA", args + outs); t1 = time.time()
    k1 = dbclock()
    res = []
    for v in outs:
        k = v.getvalue(); k.arraysize = 5000; rows = k.fetchall(); cols = [d[0] for d in k.description]
        ci = [i for i, n in enumerate(cols) if n in CLOCK_COLS]
        if ci:
            def fix(r):
                r = list(r)
                for i in ci:
                    val = r[i]; ok = isinstance(val, str) and len(val) == 4 and (k0 <= val <= k1 if k0 <= k1 else (val >= k0 or val <= k1))
                    r[i] = '<CLOCK_OK>' if ok else f'<CLOCK_BAD:{val!r} 범위 {k0}~{k1}>'
                return tuple(r)
            rows = [fix(r) for r in rows]
        res.append((cols, [tuple(r) for r in rows]))
    t2 = time.time()
    if not keep: cx.rollback()
    return round(t1 - t0, 2), round(t2 - t1, 2), res


def key_idx(cols):
    return [i for i, n in enumerate(cols) if not BUCKET.match(n) and n not in ('QTY',)]


def diff_cursor(ci, user, ca, ra, cb, rb):
    out = {"cursor": ci, "colsA": len(ca), "colsB": len(cb), "rowsA": len(ra), "rowsB": len(rb), "cols_equal": ca == cb,
           "rows_equal": False, "only_a": 0, "only_b": 0, "order": None, "col_diff": {}, "samples": [],
           "shaA": hashlib.sha256("\n".join(sorted(repr(r) for r in ra)).encode()).hexdigest()[:16],
           "shaB": hashlib.sha256("\n".join(sorted(repr(r) for r in rb)).encode()).hexdigest()[:16],
           "cells": len(ra) * len(ca)}
    if ca != cb:
        out["col_detail"] = {"onlyA": [x for x in ca if x not in cb], "onlyB": [x for x in cb if x not in ca], "same_set": sorted(ca) == sorted(cb)}
        return out
    cnta, cntb = Counter(ra), Counter(rb)
    only_a = cnta - cntb; only_b = cntb - cnta
    out["only_a"] = sum(only_a.values()); out["only_b"] = sum(only_b.values())
    out["rows_equal"] = (out["only_a"] == 0 and out["only_b"] == 0 and len(ra) == len(rb))
    if out["rows_equal"]:
        if ra == rb: out["order"] = "ORDER_SAME"
        else:
            oi = order_idx(user, ca) if ca else []
            out["order"] = "ORDER_TIE" if [tuple(r[i] for i in oi) for r in ra] == [tuple(r[i] for i in oi) for r in rb] else "ORDER_DIFF"
            if out["order"] == "ORDER_TIE":
                out["order_keys"] = [ca[i] for i in oi]
        return out
    ki = key_idx(ca)
    ga, gb = {}, {}
    for r in only_a.elements(): ga.setdefault(tuple(r[i] for i in ki), []).append(r)
    for r in only_b.elements(): gb.setdefault(tuple(r[i] for i in ki), []).append(r)
    both = [k for k in ga if k in gb]
    out["keys_onlyA"] = len([k for k in ga if k not in gb]); out["keys_onlyB"] = len([k for k in gb if k not in ga]); out["keys_both"] = len(both)
    cd = Counter(); sm = []
    for k in both:
        for x in ga[k]:
            y = gb[k][0]
            for i, (va, vb) in enumerate(zip(x, y)):
                if va != vb:
                    cd[ca[i]] += 1
                    if len(sm) < A.sample: sm.append({"key": [str(v) for v in k][:8], "col": ca[i], "A": repr(va), "B": repr(vb)})
    out["col_diff"] = dict(cd.most_common(30)); out["samples"] = sm
    out["sample_onlyA"] = [dict(zip(ca, [str(v) for v in r])) for r in list(only_a)[:2]]
    out["sample_onlyB"] = [dict(zip(cb, [str(v) for v in r])) for r in list(only_b)[:2]]
    return out


def same(ra, rb):
    return all(ra[i][0] == rb[i][0] and Counter(ra[i][1]) == Counter(rb[i][1]) for i in range(6))


def latest(div, like):
    c.execute("""SELECT MAX(V.VERSION_NO) KEEP (DENSE_RANK LAST ORDER BY V.YYYYMMDD) FROM SCM_MGR.DM_MST_VERSION V
                 WHERE V.DIVISION_ID=:d AND V.VERSION_NO LIKE :l
                 AND ( EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST_C X WHERE X.DIVISION_ID=V.DIVISION_ID AND X.VERSION_NO=V.VERSION_NO AND X.YYYYMMDD BETWEEN :f AND :t AND X.QTY<>0)
                    OR EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C X WHERE X.DIVISION_ID=V.DIVISION_ID AND X.VERSION_NO=V.VERSION_NO AND X.YYYYMMDD BETWEEN :f AND :t AND X.QTY<>0)
                    OR EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_FUTURE_PRICE_C X WHERE X.DIVISION_ID=V.DIVISION_ID AND X.VERSION_NO=V.VERSION_NO AND X.YYYYMMDD BETWEEN :f AND :t)
                    OR EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C X WHERE X.DIVISION_ID=V.DIVISION_ID AND X.VERSION_NO=V.VERSION_NO AND X.YYYYMMDD BETWEEN :f AND :t))""",
              d=div, l=like + '%', f=FRM, t=TO)
    r = c.fetchone()[0]
    if r: return r
    c.execute("SELECT MAX(VERSION_NO) KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) FROM SCM_MGR.DM_MST_VERSION WHERE DIVISION_ID=:d AND VERSION_NO LIKE :l", d=div, l=like + '%')
    return c.fetchone()[0]


def mode(col, tbl="GT_DMF0082_TEMP_FCST_N_PRICE", where="1=1"):
    c.execute(f"SELECT {col} FROM (SELECT {col}, COUNT(*) N FROM SCM_MGR.{tbl} WHERE {col} IS NOT NULL AND TRIM({col}) IS NOT NULL AND {where} GROUP BY {col} ORDER BY N DESC) WHERE ROWNUM=1")
    r = c.fetchone(); return r[0] if r else None


RES = {"tag": A.tag, "env": ENV, "pkginfo": PKGINFO, "period": [FRM, TO], "results": []}
tot = Counter()
for user in A.users.split(','):
    for div in A.divs.split(','):
        # 표본: A Current 호출 직후 세션 GTT (ROLLBACK 전) — 이 호출 결과를 Current 의 A 로 재사용
        ta0, fa0, ra0 = run(A.pkgA, base(div, user), keep=True)
        smp = {"site": mode("SCM_SITE_ID"), "item_full": mode("ITEM_ID"), "cust": mode("PROJECT_CODE" if div == "40" else "END_CUSTOMER"),
               "biz": mode("FORECAST_INFO_BIZ_TYPE"), "project": mode("PROJECT_CODE"), "owner": mode("OWNER"), "team": mode("DEPT_ID"),
               "plant": mode("PLANT_SITE_ID", where="PLANT_SITE_ID NOT IN ('/','-',' ')"), "sender": mode("SENDER_CODE")}
        smp["item"] = smp["item_full"][2:7] if smp["item_full"] and len(smp["item_full"]) > 7 else smp["item_full"]
        cx.rollback()
        vers = {t: latest(div, t) for t in ("MF_W", "SF_W", "SP_W", "MF_D")}
        P(f"--- {user} div{div} 표본 {smp} 버전 {vers}")
        sc = []
        if 'current' in SCEN: sc.append(("Current", base(div, user), (ta0, fa0, ra0)))
        if 'teams' in SCEN:
            t = SETS.get(f"{user}_{div}", {}).get("teams", [])
            if len(t) >= 1: sc.append((f"team1={t[0]}", base(div, user, team=t[0]), None))
            if len(t) >= 3: sc.append((f"team3={','.join(t[:3])}", base(div, user, team=",".join(t[:3])), None))
            for spec in [s for s in A.real_teams.split(';') if s]:
                d, v = spec.split(':', 1)
                if d == div: sc.append((f"real_team={v}", base(div, user, team=v), None))
        if 'ver' in SCEN:
            for tp, v in vers.items():
                if v: sc.append((f"{tp} {v}", base(div, user, ver=v), None))
        if 'multi' in SCEN:
            if vers["MF_W"]: sc.append((f"Current,{vers['MF_W']}", base(div, user, ver=f"Current,{vers['MF_W']}"), None))
            if vers["SP_W"]: sc.append((f"Current,{vers['SP_W']}", base(div, user, ver=f"Current,{vers['SP_W']}"), None))
        if 'filters' in SCEN:
            for key, val in (("site", smp["site"]), ("item", smp["item"]), ("cust", smp["cust"]), ("biz", smp["biz"]), ("project", smp["project"]),
                             ("owner", smp["owner"]), ("team", smp["team"]), ("plant", smp["plant"]), ("sender", smp["sender"] or "NOSUCH")):
                if val: sc.append((f"Current {key}={val}", base(div, user, **{key: val}), None))
            sc.append(("Current qty=Y", base(div, user, qty="Y"), None))
        for name, args, pre in sc:
            if A.only and A.only not in name: continue
            at = datetime.datetime.now().strftime('%H:%M:%S')
            try:
                ta, fa, ra = pre if pre else run(A.pkgA, args)
                tb, fb, rb = run(A.pkgB, args)
                curs = [diff_cursor(i + 1, user, ra[i][0], ra[i][1], rb[i][0], rb[i][1]) for i in range(6)]
                ok = all(x["cols_equal"] and x["rows_equal"] for x in curs)
                verdict = "PASS" if ok else "FAIL"
                drift = None
                if not ok:      # 운영 데이터 변동 판별: A 재호출
                    ta2, fa2, ra2 = run(A.pkgA, args)
                    aa = same(ra, ra2); ab2 = same(ra2, rb)
                    drift = {"A_eq_A2": aa, "A2_eq_B": ab2}
                    if not aa and ab2: verdict = "DRIFT_RESOLVED"   # 원본 자체가 재호출에서 바뀌었고 재호출본은 1104 와 일치
                    elif not aa: verdict = "DRIFT_FAIL"
                tot["scen"] += 1; tot[verdict] += 1; tot["cursors"] += 6
                tot["cursors_equal"] += sum(1 for x in curs if x["cols_equal"] and x["rows_equal"])
                tot["cells"] += sum(x["cells"] for x in curs if x["cols_equal"] and x["rows_equal"])
                zero = all(x["rowsA"] == 0 for x in curs[:1])
                if ok and zero: tot["zero_main"] += 1
                orders = ",".join(f"rc{x['cursor']}:{x['order']}" for x in curs if x["order"] and x["order"] != "ORDER_SAME")
                P(f"{at} {user} div{div} {name:44} {verdict:5} A={ta}+{fa}s B={tb}+{fb}s rows " + " ".join(f"{x['rowsA']}/{x['rowsB']}" for x in curs)
                  + " cols " + " ".join(f"{x['colsA']}/{x['colsB']}" for x in curs) + (f" ⚠0행(rc1)" if zero else "") + (f" [{orders}]" if orders else "")
                  + (f" drift={drift}" if drift else ""))
                for x in curs:
                    if not (x["cols_equal"] and x["rows_equal"]):
                        P(f"    rc{x['cursor']} cols_equal={x['cols_equal']} {x.get('col_detail', '')} onlyA={x['only_a']} onlyB={x['only_b']} keys(onlyA/onlyB/both)={x.get('keys_onlyA')}/{x.get('keys_onlyB')}/{x.get('keys_both')} col_diff={x['col_diff']}")
                        for s in x["samples"][:8]: P(f"      key={s['key']} col={s['col']} A={s['A']} B={s['B']}")
                        for s in x.get("sample_onlyA", [])[:1]: P(f"      onlyA 행 예: {json.dumps(s, ensure_ascii=False)[:600]}")
                        for s in x.get("sample_onlyB", [])[:1]: P(f"      onlyB 행 예: {json.dumps(s, ensure_ascii=False)[:600]}")
                RES["results"].append({"user": user, "div": div, "scen": name, "at": at, "verdict": verdict, "drift": drift,
                                       "tA": [ta, fa], "tB": [tb, fb], "cursors": curs})
            except Exception as e:
                tot["scen"] += 1; tot["ERROR"] += 1
                P(f"{at} {user} div{div} {name:44} ERROR {str(e)[:300]}")
                RES["results"].append({"user": user, "div": div, "scen": name, "at": at, "verdict": "ERROR", "error": str(e)[:300]})
                try: cx.rollback()
                except Exception: pass
            json.dump(RES, open(os.path.join(HERE, f"_coldiff_full_{A.tag}.json"), 'w', encoding='utf-8'), indent=1, ensure_ascii=False, default=str)
RES["total"] = dict(tot)
P(f"=== 합계({datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}): 시나리오 {tot['scen']} · PASS {tot['PASS']} · FAIL {tot['FAIL']} · DRIFT_RESOLVED {tot['DRIFT_RESOLVED']} · DRIFT_FAIL {tot['DRIFT_FAIL']} · ERROR {tot['ERROR']} "
  f"· 커서 {tot['cursors']} 중 전 행·전 열 동일 {tot['cursors_equal']} · 비교 셀 {tot['cells']:,} · 주 커서 0행(미실증) {tot['zero_main']}")
json.dump(RES, open(os.path.join(HERE, f"_coldiff_full_{A.tag}.json"), 'w', encoding='utf-8'), indent=1, ensure_ascii=False, default=str)
