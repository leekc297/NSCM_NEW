# -*- coding: utf-8 -*-
"""진입 경로 없는 분기 분류 — 그 메서드를 부르는 곳을 현행 소스 원문에서 다시 찾는다 (2026-11-13, 플랜 P6-1)

  python tools/AsisLive/asis_live_scen_unreached.py [ID ...]     (ID 생략 = scenarios_cov.csv 가 있는 전 화면 + 요약)
입력  Doc/asislive/<ID>/scenarios_cov.csv 의 status = UNREACHED 분기(method, src) · Doc/asisfacts/screens/<ID>/files.csv(현행 파일 = legacy 제외) · GSCM/<파일> 원문
방법  메서드 이름이 나오는 줄을 현행 파일 전부에서 찾는다(정의 줄 제외). 주석(// 와 /* */)을 지운 글과 지우지 않은 글을 따로 본다.
분류  호출 없음              현행 파일 어디에도 그 이름이 없다(정의뿐) — 미사용 코드 후보
      주석 안에서만 호출      주석을 지우면 호출이 없다 — 실행되지 않는 코드
      재정의 메서드           정의에 override 가 있다 — 프레임워크(BaseForm 등)가 부른다. 부르는 시점은 프레임워크 소스가 기준
      이벤트·대리자 연결       '+= 이름', 'new …Handler(이름)', '(이름)' 인자 전달 꼴로만 나온다 — 연결은 있으나 사실 추출이 진입점으로 잇지 못함
      같은 파일에서 호출      본체 파일 안에 호출 줄이 있다 — 부르는 메서드도 경로가 없거나 사실 추출이 잇지 못함(부르는 메서드 이름을 적는다)
      다른 파일에서 호출      팝업·다른 클래스 파일에 호출 줄이 있다
      소스 파일 없음          files.csv 의 현행 파일을 읽지 못했다
산출  Doc/asislive/<ID>/scenarios_unreached.csv   scenario_id, type, method, src, class, callers(파일:줄 최대 5), caller_methods
      Doc/asislive/_unreached_summary.csv         화면별 분류 수
한계  이름으로 찾는다. 같은 이름의 다른 메서드(오버로드, 다른 클래스의 동명 메서드) 호출도 호출로 센다. 리플렉션·문자열로 부르는 경우는 찾지 못한다.
"""
import csv, glob, os, re, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
sys.path.insert(0, P("tools", "Harness", "verify"))
import asis_variant as V
csv.field_size_limit(10 ** 8)
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass
CLS = ["호출 없음", "주석 안에서만 호출", "재정의 메서드", "이벤트·대리자 연결", "같은 파일에서 호출", "다른 파일에서 호출", "소스 파일 없음"]
MDEF = re.compile(r"^\s*(?:\[[^\]]*\]\s*)*(?:(?:public|private|protected|internal|static|virtual|override|async|new|sealed|partial)\s+)+[\w<>\[\],.? ]+?\s+(\w+)\s*\(")


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding="utf-8-sig", newline="") as f: return list(csv.DictReader(f))


def read(path):
    for enc in ("utf-8-sig", "cp949"):
        try: return open(path, encoding=enc).read()
        except Exception: continue
    return None


def strip_comments(t):
    """주석을 같은 길이의 빈칸으로 바꾼다(줄 번호 유지). 문자열 안의 // 는 건드리지 않는다."""
    out = []; i = 0; n = len(t)
    while i < n:
        c = t[i]
        if c == '"':
            j = i + 1
            while j < n and t[j] != '"' and t[j] != "\n": j += 2 if t[j] == "\\" else 1
            out.append(t[i:j + 1]); i = j + 1
        elif t.startswith("//", i):
            j = t.find("\n", i); j = n if j < 0 else j; out.append(" " * (j - i)); i = j
        elif t.startswith("/*", i):
            j = t.find("*/", i); j = n if j < 0 else j + 2; out.append(re.sub(r"[^\n]", " ", t[i:j])); i = j
        else: out.append(c); i += 1
    return "".join(out)


def one(mid):
    un = [r for r in rd(P("Doc", "asislive", mid, "scenarios_cov.csv")) if r.get("status") == "UNREACHED"]
    if not un: return None
    files = [r["file"] for r in rd(P("Doc", "asisfacts", "screens", mid, "files.csv")) if V.is_cur(r) and r["file"].lower().endswith(".cs") and not r["file"].lower().endswith("assemblyinfo.cs")]
    src = {}
    for f in files:
        t = read(P("GSCM", *re.split(r"[\\/]", f)))
        if t is not None: src[f] = (t.split("\n"), strip_comments(t).split("\n"))
    rows = []
    for r in un:
        m = r.get("method") or ""; sfile = (r.get("src") or "").split(":")[0]
        d = {"scenario_id": r["scenario_id"], "type": r.get("type"), "method": m, "src": r.get("src"), "class": "", "callers": "", "caller_methods": ""}
        if not src or not m: d["class"] = "소스 파일 없음"; rows.append(d); continue
        rx = re.compile(r"(?<![\w.])(?:this\.)?%s(?!\w)" % re.escape(m)); raw_hits = []; code_hits = []; override = False; deleg = []
        for f, (raw, code) in src.items():
            cur_m = ""
            for i, ln in enumerate(code):
                md = MDEF.match(ln)
                if md: cur_m = md.group(1)
                if md and md.group(1) == m:
                    if re.search(r"\boverride\b", ln): override = True
                    continue
                if rx.search(ln) or re.search(r"\.%s\s*\(" % re.escape(m), ln):
                    code_hits.append((f, i + 1, cur_m, ln.strip()))
                    if re.search(r"\+=\s*(?:new\s+[\w.]+\s*\(\s*)?(?:this\.)?%s\s*\)?\s*;" % re.escape(m), ln) or re.search(r"[(,]\s*(?:this\.)?%s\s*[,)]" % re.escape(m), ln): deleg.append((f, i + 1))
            for i, ln in enumerate(raw):
                if rx.search(ln) and not (MDEF.match(ln) and MDEF.match(ln).group(1) == m): raw_hits.append((f, i + 1))
        base = lambda f: os.path.basename(f.replace("\\", "/"))
        if override: d["class"] = "재정의 메서드"
        elif not raw_hits: d["class"] = "호출 없음"
        elif not code_hits: d["class"] = "주석 안에서만 호출"; d["callers"] = "; ".join("%s:%d" % (base(f), n) for f, n in raw_hits[:5])
        elif len(deleg) == len(code_hits): d["class"] = "이벤트·대리자 연결"
        elif any(base(f) == sfile for f, _n, _c, _l in code_hits): d["class"] = "같은 파일에서 호출"
        else: d["class"] = "다른 파일에서 호출"
        if code_hits:
            d["callers"] = "; ".join("%s:%d" % (base(f), n) for f, n, _c, _l in code_hits[:5]); d["caller_methods"] = ",".join(sorted({c for _f, _n, c, _l in code_hits if c})[:6])
        rows.append(d)
    with open(P("Doc", "asislive", mid, "scenarios_unreached.csv"), "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
    c = collections.Counter(x["class"] for x in rows)
    return dict({"id": mid, "unreached": len(rows), "files_read": len(src)}, **{k: c.get(k, 0) for k in CLS})


def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith("-")]; ALL = not ids
    if not ids: ids = sorted(os.path.basename(os.path.dirname(f)) for f in glob.glob(P("Doc", "asislive", "*", "scenarios_cov.csv")))
    out = [s for s in (one(m) for m in ids) if s]
    for s in out:
        if not ALL: print("[%s] 진입 경로 없는 분기 %d(읽은 파일 %d) = %s" % (s["id"], s["unreached"], s["files_read"], " · ".join("%s %d" % (k, s[k]) for k in CLS if s[k])))
    if ALL and out:
        with open(P("Doc", "asislive", "_unreached_summary.csv"), "w", encoding="utf-8-sig", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(out[0].keys())); w.writeheader(); w.writerows(out)
        t = collections.Counter()
        for s in out:
            for k in ["unreached"] + CLS: t[k] += s[k]
        print("화면 %d · 진입 경로 없는 분기 %d = %s" % (len(out), t["unreached"], " · ".join("%s %d" % (k, t[k]) for k in CLS if t[k])))
        print("@@LINK 📄 진입 경로 없는 분기 분류|Doc/asislive/_unreached_summary.csv")
    return 0


if __name__ == "__main__":
    sys.exit(main())
