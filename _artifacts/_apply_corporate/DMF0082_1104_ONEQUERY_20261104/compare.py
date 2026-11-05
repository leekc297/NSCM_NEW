# -*- coding: utf-8 -*-
"""[E20261104-DMF0082ONEQUERY] GET_MAIN_DATA 동등성 매트릭스 — 패키지 A(원본) vs B(1104)

  python compare.py <tag> [--users k0101,minyonglee1] [--divs 40,81,82] [--pkgA PKG_DMF0082] [--pkgB PKG_DMF0082_1104]
                    [--scen current,ver,multi,filters] [--gtt] [--only <이름부분문자열>]
  판정 = 6 커서 (행수 · 열수 · 정렬 SHA · 순서 SHA). cur3(TODAY_*) 는 행수·열수만.
  --gtt : 호출 직후 같은 세션의 GT_DMF0082_TEMP_SITE_ITEM / TEMP_FCST_N_PRICE 도 (행수·정렬 SHA) 대조
  0행 시나리오 = PASS 여도 '미실증' 표기. 결과 = _matrix_<tag>.txt / .json
시나리오 표본값(site·item·customer·biz·project·owner·team·plant·sender)은 A 의 Current 호출 직후 세션 GTT 에서 최빈값으로 뽑는다(사전 데이터셋 금지).
"""
import sys, os, json, time, hashlib, datetime, argparse
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
ap = argparse.ArgumentParser(); ap.add_argument('tag'); ap.add_argument('--users', default='k0101,minyonglee1'); ap.add_argument('--divs', default='40,81,82')
ap.add_argument('--pkgA', default='PKG_DMF0082'); ap.add_argument('--pkgB', default='PKG_DMF0082_1104'); ap.add_argument('--scen', default='current,ver,multi,filters')
ap.add_argument('--gtt', action='store_true'); ap.add_argument('--only', default=None)
A = ap.parse_args(); SCEN = A.scen.split(',')
today = datetime.date.today(); frm = today.replace(day=1); m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
FRM, TO = frm.strftime("%Y%m%d"), to.strftime("%Y%m%d")

cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor(); cx.call_timeout = 1800000
log = open(os.path.join(HERE, f"_matrix_{A.tag}.txt"), 'a', encoding='utf-8')
def P(*a):
    s = ' '.join(str(x) for x in a); print(s, flush=True); log.write(s + '\n'); log.flush()
c.execute("SELECT sys_context('USERENV','SERVICE_NAME'), sys_context('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); ENV = list(c.fetchone())
for p in (A.pkgA, A.pkgB):
    c.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:p ORDER BY 1", p=p); P(f"{p}: {c.fetchall()}")
P(f"=== {A.tag} env={ENV} period={FRM}~{TO} A={A.pkgA} B={A.pkgB} users={A.users} divs={A.divs} scen={SCEN} gtt={A.gtt}")

GTTS = {"site_item": ("GT_DMF0082_TEMP_SITE_ITEM", None), "fnp": ("GT_DMF0082_TEMP_FCST_N_PRICE", None)}


SYS_ORD = ['GROUP_ID', 'VERSION_NO', 'BUCKET', 'NEW_FLAG', 'ATTR1', 'VMI_STD_DIO', 'AS_YN']
EXCL_ORD = {'LAST_UPDATE_DATE', 'LAST_UPDATED_BY', 'EDIT_FLAG', 'SORT_KEY', 'MEASURE', 'MEASURE_GROUP'}


def order_cols(user, cols):
    """원문 V_ORDERBY 근사 = SORT_KEY, C_TITLE 열(사용자 'C' + 시스템 열) − 제외 4종 − MEASURE(+MEASURE_GROUP→SORT_ORDER_NO) + SORT_ORDER_NO"""
    c.execute("SELECT COLUMN_NAME FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND USER_ID=:u AND USER_INQUIRY_COLUMN_TYPE_CODE='C' ORDER BY SORT_ORDER_NO", u=user)
    ucols = [r[0] for r in c.fetchall()] + SYS_ORD
    keys = [x for x in ucols if x in cols and x not in EXCL_ORD]
    if 'SORT_ORDER_NO' not in keys: keys.append('SORT_ORDER_NO')
    return [cols.index(x) for x in keys if x in cols]


def sha_rows(rows):
    return (hashlib.sha256("\n".join(sorted(repr(tuple(r)) for r in rows)).encode()).hexdigest()[:16],
            hashlib.sha256("\n".join(repr(tuple(r)) for r in rows).encode()).hexdigest()[:16])


def run(pkg, args, gtt=False, keep=False):
    outs = [c.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
    t0 = time.time(); c.callproc(f"SCM_MGR.{pkg}.P_DMF0082_GET_MAIN_DATA", args + outs); el = round(time.time() - t0, 2)
    res = []
    for v in outs:
        k = v.getvalue(); k.arraysize = 5000; rows = k.fetchall(); cols = [d[0] for d in k.description]
        s, o = sha_rows(rows)
        oi = order_cols(CUR_USER, cols) if cols else []
        ok_ = hashlib.sha256("\n".join(repr(tuple(r[i] for i in oi)) for r in rows).encode()).hexdigest()[:16]
        res.append({"rows": len(rows), "cols": len(cols), "srt": s, "ord": o, "okey": ok_, "colnames": cols})
    g = {}
    if gtt:
        for k, (t, _) in GTTS.items():
            c.execute(f"SELECT * FROM SCM_MGR.{t}"); rows = c.fetchall(); g[k] = {"rows": len(rows), "srt": sha_rows(rows)[0]}
    if not keep: cx.rollback()      # GTT(PRESERVE) 행도 트랜잭션 단위라 ROLLBACK 이면 사라진다 — 표본 추출 시 keep
    return el, res, g


TIE = []
CUR_USER = None


def judge(ra, rb, ga, gb):
    bad = []
    TIE.clear()
    for i, (a, b) in enumerate(zip(ra, rb)):
        if i == 2:
            if (a["rows"], a["cols"]) != (b["rows"], b["cols"]): bad.append(f"cur{i+1} rows/cols {a['rows']}/{a['cols']} vs {b['rows']}/{b['cols']}")
        else:
            if (a["rows"], a["cols"], a["srt"]) != (b["rows"], b["cols"], b["srt"]):
                bad.append(f"cur{i+1} rows {a['rows']}/{b['rows']} cols {a['cols']}/{b['cols']} srt {a['srt'] == b['srt']} ord {a['ord'] == b['ord']}")
            elif a["ord"] != b["ord"]:
                if a["okey"] == b["okey"]: TIE.append(f"cur{i+1}")      # 동률(ORDER 키 동일) 행 간 순서만 다름 — SQL 비결정, 통과 처리
                else: bad.append(f"cur{i+1} ORDER 키 순서 상이 (srt 동일)")
            if a["colnames"] != b["colnames"]: bad.append(f"cur{i+1} colnames differ")
    for k in ga:
        if ga[k] != gb.get(k): bad.append(f"gtt {k} {ga[k]} vs {gb.get(k)}")
    return bad


def latest(div, like):
    """조회 기간 안에 버전 원장(_C 4종) 행이 있는 최신 버전 (11-04 23:30 — 최신 버전은 원장 행 0 → 0행 미실증만 나오던 문제 해소). 없으면 구 방식(최신 버전)."""
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


def base(div, user, **k):
    return [div, k.get("team", "ALL"), k.get("cust", "ALL"), k.get("biz", "ALL"), FRM, TO, k.get("site", "ALL"), k.get("item"), k.get("ver", "Current"),
            k.get("qty", "N"), user, "ADMIN", k.get("plant", "ALL"), k.get("project", "ALL"), k.get("owner", "ALL"), k.get("sender", "ALL")]


out = {"tag": A.tag, "env": ENV, "results": []}; fails = 0; n = 0
for user in A.users.split(','):
    CUR_USER = user
    for div in A.divs.split(','):
        # 표본: A 의 Current 호출 후 세션 GTT 에서
        run(A.pkgA, base(div, user), keep=True)
        smp = {"site": mode("SCM_SITE_ID"), "item_full": mode("ITEM_ID"), "cust": mode("PROJECT_CODE" if div == "40" else "END_CUSTOMER"),
               "biz": mode("FORECAST_INFO_BIZ_TYPE"), "project": mode("PROJECT_CODE"), "owner": mode("OWNER"), "team": mode("DEPT_ID"),
               "plant": mode("PLANT_SITE_ID", where="PLANT_SITE_ID NOT IN ('/','-',' ')"), "sender": mode("SENDER_CODE")}
        smp["item"] = smp["item_full"][2:7] if smp["item_full"] and len(smp["item_full"]) > 7 else smp["item_full"]
        cx.rollback()
        vers = {t: latest(div, t) for t in ("MF_W", "SF_W", "SP_W", "MF_D")}
        P(f"--- {user} div{div} 표본 {smp} 버전 {vers}")
        sc = []
        if 'current' in SCEN: sc.append(("Current", base(div, user)))
        if 'ver' in SCEN:
            for t, v in vers.items():
                if v: sc.append((f"{t} {v}", base(div, user, ver=v)))
        if 'multi' in SCEN:
            if vers["MF_W"]: sc.append((f"Current,{vers['MF_W']}", base(div, user, ver=f"Current,{vers['MF_W']}")))
            if vers["SP_W"]: sc.append((f"Current,{vers['SP_W']}", base(div, user, ver=f"Current,{vers['SP_W']}")))
        if 'filters' in SCEN:
            for key, val in (("site", smp["site"]), ("item", smp["item"]), ("cust", smp["cust"]), ("biz", smp["biz"]), ("project", smp["project"]),
                             ("owner", smp["owner"]), ("team", smp["team"]), ("plant", smp["plant"]), ("sender", smp["sender"] or "NOSUCH")):
                if val: sc.append((f"Current {key}={val}", base(div, user, **{key: val})))
            sc.append(("Current qty=Y", base(div, user, qty="Y")))
        for name, args in sc:
            if A.only and A.only not in name: continue
            n += 1; at = datetime.datetime.now().strftime('%H:%M:%S')
            try:
                ta, ra, ga = run(A.pkgA, args, A.gtt); tb, rb, gb = run(A.pkgB, args, A.gtt)
                bad = judge(ra, rb, ga, gb); ok = not bad; fails += 0 if ok else 1
                note = ("" if ra[0]["rows"] > 0 else "  ⚠ 0행(미실증)") + (f"  (동률 순서 차이: {','.join(TIE)})" if TIE else "")
                P(f"{at} {user} div{div} {name:40} {'PASS' if ok else 'FAIL'} rows={ra[0]['rows']:>6} A {ta:6.2f}s B {tb:6.2f}s{note}")
                for b_ in bad: P("      " + b_)
                out["results"].append({"user": user, "div": div, "scen": name, "ok": ok, "rowsA": ra[0]["rows"], "rowsB": rb[0]["rows"], "tA": ta, "tB": tb, "bad": bad, "A": ra, "B": rb, "gttA": ga, "gttB": gb})
            except Exception as e:
                fails += 1; P(f"{at} {user} div{div} {name:40} ERROR {str(e)[:200]}"); out["results"].append({"user": user, "div": div, "scen": name, "ok": False, "error": str(e)[:300]})
                cx.rollback()
            json.dump(out, open(os.path.join(HERE, f"_matrix_{A.tag}.json"), 'w', encoding='utf-8'), indent=1, ensure_ascii=False)
P(f"\n=== 시나리오 {n} · FAIL {fails} · 미실증 {sum(1 for r in out['results'] if r.get('rowsA') == 0)}")
