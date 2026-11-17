# -*- coding: utf-8 -*-
"""AS-IS 실측 ↔ TO-BE 검증의 조회 조건 대조 (2026-11-13 · 플랜 P5 조건 시나리오 1단계)

  python tools/AsisLive/asis_live_cond.py [ID ...] [--repin]   (ID 생략 = TO-BE 호출 기록이 있는 전 화면 · FP 제외)
입력  TO-BE: Doc/verify/<ID>/calls/*.json  (E2E 가 실제로 보낸 요청 — menu·sheet·btn·postData·rows · 파일 1개 = 시험 1건)
      AS-IS: Doc/asislive/<ID>/latest.json → calls.json (런처가 실제로 보낸 SP·인자·건수)
방법  TO-BE 조회 요청(btn=SEARCH)의 인자 이름(camelCase)을 snake 로 바꾸고, AS-IS SP 인자(p_ 접두 제거)와 이름으로 짝짓는다.
      같은 화면의 AS-IS 호출 중 인자 이름이 가장 많이 겹치는 SP 를 그 TO-BE 시트의 짝으로 본다(겹침이 부족하면 짝 없음).
      대표 TO-BE 조건 = **시험 1건(파일 1개)의 시트별 마지막 조회 묶음**. 시트마다 따로 고르지 않는다
        (11-13 결함 보정: 시트별로 따로 고르면 서로 다른 시험의 조건이 섞여 한 번의 조회로 맞출 수 없다).
        고르는 기준 = 짝이 있는 시트를 가장 많이 덮고, AS-IS 와 다른 인자가 가장 적은 시험.
        한 번 고르면 cond_target.json 에 고정한다(시나리오로 AS-IS 값을 바꾼 뒤에도 같은 조건과 비교 · 다시 고르려면 --repin).
산출  Doc/asislive/<ID>/cond_compare.csv   짝·인자별 AS-IS 값/TO-BE 값/같음 여부
      Doc/asislive/<ID>/cond_target.json   고정한 대표 조건 {file, sheets:{sheet:{params, rows}}}
      Doc/asislive/_cond_summary.csv       화면별 요약 (ID 를 주지 않았을 때만 갱신)
한계  이름으로만 짝짓는다(이름이 다른 인자는 "한쪽에만 있음"으로 남는다). 값은 문자열 그대로 비교한다.
      사용자 ID 인자는 비교에서 뺀다(계정이 다르다).
"""
import csv, glob, json, os, re, sys, collections

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass
USERKEY = re.compile(r"(^|_)(user_id|created_by|updated_by|login_id)$|^user$")
FRAME = re.compile(r"^(UP_FX_|SCM_SYS_GET_SPREAD_TITLE$|SCP0009_GET_SHEET_CALENDAR|UI_FP_COMMON$)", re.I)


def snake(k):
    k = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", k).lower()
    return re.sub(r"^p_", "", k)


def tobe_tests(mid):
    """시험(파일)별 시트의 마지막 조회 — {file: {sheet: {"params":…, "rows":…, "at":…}}} · 시트별 조건 종 수"""
    tests = collections.OrderedDict(); kinds = collections.defaultdict(set)
    for f in sorted(glob.glob(P("Doc", "verify", mid, "calls", "*.json"))):
        try: js = json.load(open(f, encoding="utf-8"))
        except Exception: continue
        for c in js if isinstance(js, list) else []:
            if not isinstance(c, dict) or c.get("menu") != mid or c.get("btn") != "SEARCH" or c.get("status") != 200: continue
            try: pd = json.loads(c.get("postData") or "{}")
            except Exception: continue
            if not isinstance(pd, dict): continue
            ps = {snake(k): ("" if v is None else str(v)) for k, v in pd.items()}
            tests.setdefault(os.path.basename(f), collections.OrderedDict())[c.get("sheet")] = {"params": ps, "rows": c.get("rows"), "at": c.get("at")}
            kinds[c.get("sheet")].add(json.dumps(ps, ensure_ascii=False, sort_keys=True))
    return tests, kinds


def asis_calls(mid):
    lt = P("Doc", "asislive", mid, "latest.json")
    try: run_dir = json.load(open(lt, encoding="utf-8")).get("run_dir")
    except Exception: return None, []
    rd = run_dir if os.path.isabs(run_dir) else P(run_dir)
    try: cs = json.load(open(os.path.join(rd, "calls.json"), encoding="utf-8"))
    except Exception: return run_dir, []
    cs = cs.get("calls", cs) if isinstance(cs, dict) else cs
    out = []
    for c in cs:
        sp = str(c.get("sp") or "")
        if FRAME.match(sp) or " " in sp or not isinstance(c.get("params"), dict): continue
        out.append({"sp": sp, "phase": c.get("phase"), "rows": c.get("rows"),
                    "params": {snake(k): ("" if v is None else str(v)) for k, v in c["params"].items()},
                    "error": "EXCEPTION" in str(c.get("inline") or "")})
    return run_dir, out


ALLV = {"", "ALL"}


def equiv(a, t):
    """값이 달라도 같은 조건으로 보는 경우 — 반환 "" (다름) | "ORDER_SAME" | "ALL_SAME"
    ALL_SAME (사용자 결정 2026-11-13): AS-IS 의 전체 목록(쉼표 목록)·빈값·ALL ↔ TO-BE 의 ALL·빈값 = "전체"의 표현 차이 → 같은 조건.
      AS-IS 가 값 1개(예: 81)이고 TO-BE 가 빈값이면 전체 목록이 아니므로 다름으로 둔다. TO-BE 가 목록이면 적용하지 않는다."""
    sa, st = sorted(x.strip() for x in a.split(",") if x.strip()), sorted(x.strip() for x in t.split(",") if x.strip())
    if sa and sa == st: return "ORDER_SAME"
    if t.strip().upper() in ALLV and (a.strip().upper() in ALLV or "," in a): return "ALL_SAME"
    return ""


def diff_rows(mid):
    """차등 검증(diff_summary.csv)이 같은 TO-BE 인자로 잰 실제 결과 행 수 — {(sheet, 정규화 인자 json): (tobe_rows, asis_rows, verdict)}
    (11-13 실측: TO-BE 호출 기록의 rows 는 결과 행 수가 아니다 — 화면마다 일정한 수가 더해져 있다(대부분 +1 · SCP0037 +3017 · SCP0033 +56). 건수 비교에 쓰지 않는다.)"""
    out = {}; p = P("Doc", "verify", mid, "diff", "diff_summary.csv")
    if not os.path.exists(p): return out
    with open(p, encoding="utf-8-sig", newline="") as f:
        for r in csv.DictReader(f):
            try: ps = {snake(k): ("" if v is None else str(v)) for k, v in json.loads(r.get("params_tobe") or "{}").items()}
            except Exception: continue
            out[(r.get("sheet"), json.dumps(ps, ensure_ascii=False, sort_keys=True))] = (r.get("tobe_rows"), r.get("asis_rows"), r.get("verdict"))
    return out


def ndiff(ps, ap):
    return sum(1 for k in set(ps) & set(ap) if not USERKEY.search(k) and ps[k] != ap[k] and not equiv(ap[k], ps[k]))


def one(mid, repin):
    tests, kinds = tobe_tests(mid); run_dir, ac = asis_calls(mid); rows = []; pairs = []; dr = diff_rows(mid)
    # 1) 시트 ↔ AS-IS SP 짝 (시트의 모든 조건에 나온 인자 이름 합집합 기준 · 마지막 호출 우선)
    pair = {}
    for sheet in kinds:
        names = set()
        for t in tests.values():
            if sheet in t: names |= set(t[sheet]["params"])
        best = None
        for c in ac:
            ov = len(names & set(c["params"])); sc = (ov, 1 if c["phase"] == "find" else 0)
            if ov and (best is None or sc >= best[0]): best = (sc, c)
        if best is not None and best[0][0] >= max(1, min(2, len(names))): pair[sheet] = best[1]
    # 2) 대표 시험 고정
    pin_path = P("Doc", "asislive", mid, "cond_target.json"); pin = None
    if not repin:
        try: pin = json.load(open(pin_path, encoding="utf-8"))
        except Exception: pin = None
        if pin and (not isinstance(pin.get("sheets"), dict) or pin.get("file") not in tests): pin = None
    if pin is None and pair:
        def score(item):
            f, t = item; cov = [s for s in t if s in pair]
            return (-len(cov), sum(ndiff(t[s]["params"], pair[s]["params"]) for s in cov), f)
        cand = [it for it in tests.items() if any(s in pair for s in it[1])]
        if cand:
            f, t = min(cand, key=score); pin = {"file": f, "sheets": {s: t[s] for s in t}}
            with open(pin_path, "w", encoding="utf-8") as fo: json.dump(pin, fo, ensure_ascii=False, indent=1)
    # 3) 대조
    for sheet in kinds:
        if sheet not in pair:
            rows.append({"sheet": sheet, "asis_sp": "", "param": "", "asis": "", "tobe": "", "verdict": "NO_PAIR", "note": "AS-IS 호출 중 인자 이름이 겹치는 SP 없음 · TO-BE 조건 %d종" % len(kinds[sheet])}); continue
        if not pin or sheet not in pin["sheets"]:
            rows.append({"sheet": sheet, "asis_sp": pair[sheet]["sp"], "param": "", "asis": "", "tobe": "", "verdict": "NOT_IN_TARGET", "note": "대표 시험(%s)에 이 시트 조회가 없음" % (pin and pin["file"])}); continue
        c = pair[sheet]; ps = pin["sheets"][sheet]["params"]; diff = same = only = 0
        for k in sorted(set(ps) | set(c["params"])):
            a, t = c["params"].get(k), ps.get(k)
            if USERKEY.search(k): v = "USER(비교 제외)"
            elif a is None: v = "TOBE_ONLY"; only += 1
            elif t is None: v = "ASIS_ONLY"; only += 1
            elif a == t: v = "SAME"; same += 1
            elif equiv(a, t): v = equiv(a, t); same += 1
            else: v = "DIFF"; diff += 1
            rows.append({"sheet": sheet, "asis_sp": c["sp"], "param": k, "asis": a, "tobe": t, "verdict": v, "note": ""})
        pairs.append({"sheet": sheet, "asis_sp": c["sp"], "phase": c["phase"], "same": same, "diff": diff, "only": only, "variants": len(kinds[sheet]),
                      "asis_rows": c["rows"], "tobe_trace_rows": pin["sheets"][sheet].get("rows"),
                      "tobe_rows": (dr.get((sheet, json.dumps(ps, ensure_ascii=False, sort_keys=True))) or ("", "", ""))[0],
                      "diff_verdict": (dr.get((sheet, json.dumps(ps, ensure_ascii=False, sort_keys=True))) or ("", "", ""))[2]})
    with open(P("Doc", "asislive", mid, "cond_compare.csv"), "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["sheet", "asis_sp", "param", "asis", "tobe", "verdict", "note"]); w.writeheader(); w.writerows(rows)
    tdiff = sum(p["diff"] for p in pairs); tonly = sum(p["only"] for p in pairs); tsame = sum(p["same"] for p in pairs)
    main_p = [p for p in pairs if p["phase"] == "find"] or pairs
    mp = max(main_p, key=lambda p: p["same"] + p["diff"]) if main_p else None
    dp = " ; ".join("[%s] %s: AS-IS=%s / TO-BE=%s" % (r["sheet"], r["param"], r["asis"][:60], r["tobe"][:60]) for r in rows if r["verdict"] == "DIFF")[:600]
    return {"id": mid, "tobe_sheets": len(kinds), "paired": len(pairs), "no_pair": sum(1 for r in rows if r["verdict"] in ("NO_PAIR", "NOT_IN_TARGET")),
            "target_test": pin and pin["file"], "same": tsame, "diff": tdiff, "only": tonly,
            "main_sheet": mp and mp["sheet"], "main_asis_sp": mp and mp["asis_sp"], "asis_rows": mp and mp["asis_rows"], "tobe_rows": mp and mp["tobe_rows"], "tobe_trace_rows": mp and mp["tobe_trace_rows"], "diff_verdict": mp and mp["diff_verdict"],
            "main_diff": mp and mp["diff"],
            "rows_cmp": ("" if not mp or mp["diff"] else "TO-BE 행 수 없음(차등 검증에 같은 조건 없음)" if mp["tobe_rows"] in ("", None) else "같음" if str(mp["asis_rows"]) == str(mp["tobe_rows"]) else "판정필요(조건은 같으나 건수 다름 — AS-IS·TO-BE DB 가 달라 데이터 차이 가능 · 사용자 결정 2026-11-13 · CR-101)"),
            "cond": ("짝 없음" if not pairs else "같은 조건" if tdiff == 0 and tonly == 0 else "이름 다른 인자 있음" if tdiff == 0 else "조건 다름"),
            "diff_params": dp, "asis_run": run_dir}


def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith("-")]; repin = "--repin" in sys.argv; ALL = not ids
    if not ids:
        ids = sorted({os.path.basename(os.path.dirname(os.path.dirname(f))) for f in glob.glob(P("Doc", "verify", "*", "calls", "*.json"))})
        ids = [i for i in ids if not i.startswith("FP") and i != "SSP0060" and os.path.exists(P("Doc", "asislive", i, "latest.json"))]
    summ = []
    for mid in ids:
        s = one(mid, repin); summ.append(s)
        print("[%s] %s · 짝 %s/%s · 같음 %s 다름 %s 한쪽 %s · 건수 AS-IS %s / TO-BE %s · %s" % (mid, s["cond"], s["paired"], s["tobe_sheets"], s["same"], s["diff"], s["only"], s["asis_rows"], s["tobe_rows"], s["diff_params"][:170]))
    if ALL and summ:
        with open(P("Doc", "asislive", "_cond_summary.csv"), "w", encoding="utf-8-sig", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(summ[0].keys())); w.writeheader(); w.writerows(summ)
        print("요약", dict(collections.Counter(s["cond"] for s in summ)))
        print("@@LINK 📄 조건 대조 요약|Doc/asislive/_cond_summary.csv")


if __name__ == "__main__":
    main()
