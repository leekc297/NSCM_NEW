"""산출 검증 — (1) 제외 근거 전수 출력 (2) 독립 정규식과의 교차 대조(놓친 분기 탐지) (3) 표본 출력.  python verify.py [1|2|3]"""
import sys, os, re, json, random, collections
HERE = os.path.dirname(os.path.abspath(__file__))
R = json.load(open(os.path.join(HERE, "_cache", "result.json"), encoding="utf-8"))
cols, ev, tobe = R["cols"], R["ev"], R["tobe"]
mode = sys.argv[1] if len(sys.argv) > 1 else "1"

if mode == "1":
    exc = [(c["table"], c["column"]) for c in cols if c["auto"] == "제외"]
    for tb, c in exc:
        print("=====", tb, c)
        n = 0
        for e in ev:
            if e["cls"] == "A" and not e["dynamic"] and [tb, c, "확정"] in e["refs"]:
                n += 1
                if n <= 4:
                    print("   ", e["src"], e["object"], "L%d" % e["line"], "|", e["detail"][:90])
                    print("       ", e["snip"][:330])
        print("    확정 분기 근거", n, "건")

if mode == "2":
    mods = json.load(open(os.path.join(HERE, "_cache", "asis_mods.json"), encoding="utf-8"))["mods"]
    popcols = {c["column"] for c in cols}
    eng = collections.defaultdict(set)      # (db, object) → 엔진이 A/A_NULLCHK/B 로 본 줄
    for e in ev:
        if e["src"] == "DB" and e["cls"] in ("A", "A_NULLCHK", "B", "B_NULLCHK"):
            eng[(e["loc"], e["object"])].add(e["line"])
    engA = collections.defaultdict(set)
    for e in ev:
        if e["src"] == "DB" and e["cls"] in ("A", "A_NULLCHK"):
            engA[(e["loc"], e["object"])].add(e["line"])
    # 독립 패턴: 같은 줄에 WHEN/IF 가 있고 [별칭.]컬럼 (=|<>|!=) '-' 또는 IN (..'-'..) — 컬럼명이 모집단 컬럼명
    rx = re.compile(r"(?:\b[\w#@\[\]]+\.)?\[?(\w+)\]?\s*(?:=|<>|!=)\s*N?'-'|N?'-'\s*(?:=|<>|!=)\s*(?:[\w#@\[\]]+\.)?\[?(\w+)\]?|\[?(\w+)\]?\s+(?:NOT\s+)?IN\s*\([^()]*N?'-'", re.I)
    miss = []; tot = 0; both = 0
    for m in mods:
        df = m["definition"]
        if "'-'" not in df:
            continue
        code = re.sub(r"/\*.*?\*/", lambda x: re.sub(r"[^\n]", " ", x.group(0)), df, flags=re.S)
        for i, ln in enumerate(code.split("\n"), 1):
            ln2 = ln.split("--")[0]
            if "'-'" not in ln2 or not re.search(r"\b(WHEN|IF|WHILE|IIF)\b", ln2, re.I):
                continue
            hit = [x for g in rx.findall(ln2) for x in g if x and x.upper() in popcols]
            if not hit:
                continue
            tot += 1
            if i in engA[(m["db"], m["name"])]:
                both += 1
            else:
                miss.append((m["db"], m["name"], i, i in eng[(m["db"], m["name"])], ln2.strip()[:200]))
    print("독립 패턴 분기 줄(모집단 컬럼명)", tot, "/ 엔진도 분기로 본 줄", both, "/ 엔진이 분기로 안 본 줄", len(miss))
    print("  그중 엔진이 조건절(B)로 본 줄", sum(1 for x in miss if x[3]))
    random.seed(7)
    for x in random.sample(miss, min(40, len(miss))):
        print("  ", x[1], "L%d" % x[2], "B" if x[3] else "-", "|", x[4])

if mode == "3":
    random.seed(11)
    tg = [c for c in cols if c["auto"] == "대상" and c["asis_db"]]
    print("== 대상 표본 30 (AS-IS 원문에 그 컬럼의 '-' 비교가 있는지 역확인)")
    mods = json.load(open(os.path.join(HERE, "_cache", "asis_mods.json"), encoding="utf-8"))["mods"]
    for c in random.sample(tg, 30):
        tb, cn = c["table"], c["column"]
        rx = re.compile(r"(?:\b\w+\.)?\[?" + re.escape(cn) + r"\]?\s*(?:=|<>|!=)\s*N?'-'|" + re.escape(cn) + r"\]?\s+(?:NOT\s+)?IN\s*\([^()]*N?'-'", re.I)
        hits = []
        for m in mods:
            df = m["definition"]
            if tb.lower() in df.lower() and "'-'" in df:
                for i, ln in enumerate(df.split("\n"), 1):
                    l2 = ln.split("--")[0]
                    if rx.search(l2):
                        hits.append((m["name"], i, l2.strip()[:150]))
        print(" ", tb, cn, "| 같은 객체 내 비교 줄", len(hits), "| 단순사용 C/D", c["c_cnt"], c["d_cnt"])
        for h in hits[:3]:
            print("       ", h)
