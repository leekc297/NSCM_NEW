# -*- coding: utf-8 -*-
"""저장 시나리오 정의 초안 — 저장 SP 원문과 DB 키, 화면 그리드에서 근거를 모아 초안을 만든다 (2026-11-13, 플랜 P6-2)

  python tools/AsisLive/asis_live_save_draft.py [ID ...]     (ID 생략 = 저장 호출이 있는 전 화면 + 요약)
입력  Doc/asislive/<ID>/scenarios_cov.csv(저장 유형 분기의 서버 호출) · GSCM/_asis_local/04.WSL/FoxQuery/*.foxml(호출 이름 → SP)
      AS-IS 개발 DB(조회만): SP 원문(sys.sql_modules), 테이블 키(sys.indexes), 컬럼 형식 · Doc/asislive/<ID>/run_*/grids.json(화면 그리드 열 Tag)
방법  저장 호출마다 ① foxml 에서 SP 이름 ② SP 원문에서 쓰는 테이블(MERGE INTO, UPDATE, INSERT INTO, DELETE FROM · 임시표, 테이블 변수, 로그 표 제외)
      ③ SP 가 EXEC 로 부르는 프로시저 1단계까지 쓰는 테이블 ④ 주 테이블 = MERGE 가 있거나 쓰기 문이 가장 많은 테이블(이력 표 이름 _H, _HIST 제외), 나머지는 덧붙는 표(side)
      ⑤ 주 테이블 키 컬럼 ↔ 그리드 열 Tag 이름 대응(같은 이름 · 이름이 다르면 SP 원문의 '컬럼 = @인자' 와 화면 소스의 '인자 ← GetColumnIndex(열)' 두 고리가 모두 있을 때만 · 추정 대응 없음 · 근거는 match_basis) ⑥ 고칠 열 후보 = 키가 아닌 숫자 컬럼 중 그리드 열 Tag 와 이름이 같은 첫 컬럼
산출  Doc/asislive/<ID>/save_scenario.draft.json   초안(사람이 확인하고 save_scenario.json 으로 옮겨야 실행된다 · 이 도구는 save_scenario.json 을 만들거나 고치지 않는다)
      Doc/asislive/_save_draft_summary.csv         화면·SP 별 상태
상태  키 대응 완료(키 전부 그리드 열과 대응, 고칠 열 후보 있음) / 키 일부 미대응(대응 못 한 키 컬럼 표시) / 고칠 열 후보 없음 / 주 테이블 미확정 / SP 원문 없음 / 그리드 덤프 없음
한계  이름이 같은 것만 대응한다(FROM_SITE ↔ FROM_SITE 같은 경우). 화면이 값을 가공해 넘기는 인자, 팝업으로 저장하는 경로, 여러 시트 저장은 사람이 소스를 보고 채워야 한다.
      초안은 실행 근거가 아니다. 연습 실행(asis_live_save.py --dry)으로 셀 입력과 변경 표시를 확인한 뒤에 실제 저장을 돌린다.
"""
import csv, glob, json, os, re, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
csv.field_size_limit(10 ** 8)
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass
sys.path.insert(0, P("tools", "DbConn"))
SAVE = re.compile(r"save|delete|insert|upload|confirm|copy|create|apply|release|approve|reject|import|update|merge|set_", re.I)
DML = re.compile(r"\b(MERGE\s+INTO|MERGE|UPDATE|INSERT\s+INTO|INSERT|DELETE\s+FROM|DELETE)\s+(?:\[?dbo\]?\.)?\[?([A-Za-z_][A-Za-z0-9_]*)\]?", re.I)
EXEC = re.compile(r"\bEXEC(?:UTE)?\s+(?:\[?dbo\]?\.)?\[?([A-Za-z_][A-Za-z0-9_]*)\]?", re.I)
LOGT = re.compile(r"^(scm_sys_log|sys_log|tb_fx_|#)|_log(_|$)|_batch$", re.I)
HIST = re.compile(r"(_H|_HIST|_HISTORY)$", re.I)
NUM = {"int", "bigint", "smallint", "tinyint", "decimal", "numeric", "float", "real", "money"}


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding="utf-8-sig", newline="") as f: return list(csv.DictReader(f))


def foxmap():
    m = {}
    for f in glob.glob(P("GSCM", "_asis_local", "04.WSL", "FoxQuery", "*.foxml")):
        try: t = open(f, encoding="utf-8", errors="replace").read()
        except Exception: continue
        for x in re.finditer(r'<procedure\s+id="([^"]+)"[^>]*>\s*<text>\s*<!\[CDATA\[(.*?)\]\]>', t, re.S):
            body = re.sub(r"--[^\n]*", "", x.group(2)).strip(); w = re.match(r"(?:EXEC(?:UTE)?\s+)?(?:\[?dbo\]?\.)?\[?([A-Za-z_][A-Za-z0-9_]*)\]?", body, re.I)
            if w: m.setdefault(x.group(1), w.group(1))
    return m


class Db:
    def __init__(self):
        import dbconn
        self.cur = dbconn.connect("asis").cursor(); self.c = {}

    def text(self, name):
        k = ("t", name.lower())
        if k not in self.c:
            self.cur.execute("select m.definition from sys.objects o join sys.sql_modules m on m.object_id = o.object_id where o.name = ?", name); r = self.cur.fetchone(); self.c[k] = r[0] if r else None
        return self.c[k]

    def table(self, name):
        k = ("b", name.lower())
        if k not in self.c:
            self.cur.execute("select c.name, t.name from sys.tables b join sys.columns c on c.object_id = b.object_id join sys.types t on t.user_type_id = c.user_type_id where b.name = ? order by c.column_id", name)
            cols = [(r[0], r[1]) for r in self.cur.fetchall()]
            if not cols: self.c[k] = None
            else:
                self.cur.execute("""select c.name from sys.indexes i join sys.index_columns ic on ic.object_id = i.object_id and ic.index_id = i.index_id join sys.columns c on c.object_id = ic.object_id and c.column_id = ic.column_id
where i.object_id = object_id(?) and i.is_primary_key = 1 order by ic.key_ordinal""", name)
                self.c[k] = {"cols": cols, "pk": [r[0] for r in self.cur.fetchall()]}
        return self.c[k]


def writes(txt):
    """SP 원문이 쓰는 테이블 {이름: [문 종류]} 과 EXEC 로 부르는 프로시저 이름"""
    t = re.sub(r"/\*.*?\*/", " ", txt or "", flags=re.S); t = re.sub(r"--[^\n]*", " ", t)
    w = collections.defaultdict(list)
    for m in DML.finditer(t):
        op = re.sub(r"\s+", " ", m.group(1).upper()); name = m.group(2)
        if name.upper() in ("INTO", "FROM", "SET", "TOP", "A", "B", "T", "S") or name.startswith("@") or LOGT.search(name): continue
        w[name].append(op)
    return w, sorted({m.group(1) for m in EXEC.finditer(t)})


def grid_tags(mid):
    out = {}
    for f in sorted(glob.glob(P("Doc", "asislive", mid, "run_*", "grids.json")), reverse=True):
        try: g = json.load(open(f, encoding="utf-8"))
        except Exception: continue
        for gr in g.get("grids") or []:
            for sh in gr.get("sheets") or []:
                tags = [str(c.get("tag") or c.get("data_field") or "") for c in sh.get("columns") or []]
                if tags: out["%s/%s" % (gr.get("name"), sh.get("name"))] = [x for x in tags if x]
        if out: break
    return out


def param_of(txt, col):
    """SP 원문에서 테이블 컬럼 col 에 대입·비교되는 저장 인자 이름들 — 'col = @v_x' 와 '@v_x = …(@p_x' 두 줄을 이어 @p_x 를 찾는다(근거 줄 번호 포함)"""
    t = re.sub(r"/\*.*?\*/", lambda m: re.sub(r"[^\n]", " ", m.group(0)), txt or "", flags=re.S); lines = [re.sub(r"--.*", "", x) for x in t.split("\n")]
    v2p = {}
    for i, ln in enumerate(lines):
        m = re.search(r"SET\s+@(\w+)\s*=\s*[^@\n]*@(p_\w+)", ln, re.I)
        if m and m.group(1).lower() not in v2p: v2p[m.group(1).lower()] = (m.group(2), i + 1)
    out = []
    for i, ln in enumerate(lines):
        for m in re.finditer(r"(?<![@\w])(?:\w+\.)?\[?%s\]?\s*=\s*(?:UPPER\s*\(\s*|LTRIM\s*\(\s*|RTRIM\s*\(\s*)*@(\w+)" % re.escape(col), ln, re.I):
            v = m.group(1).lower()
            if v.startswith("p_"): out.append((m.group(1), "SP %d줄" % (i + 1)))
            elif v in v2p: out.append((v2p[v][0], "SP %d줄(@%s) ← %d줄" % (i + 1, m.group(1), v2p[v][1])))
        for m in re.finditer(r"@(\w+)\s+AS\s+\[?%s\]?(?!\w)" % re.escape(col), ln, re.I):      # MERGE USING (SELECT @v_x AS col …) 꼴
            v = m.group(1).lower()
            if v.startswith("p_"): out.append((m.group(1), "SP %d줄(AS %s)" % (i + 1, col)))
            elif v in v2p: out.append((v2p[v][0], "SP %d줄(@%s AS %s) ← %d줄" % (i + 1, m.group(1), col, v2p[v][1])))
    seen = []; res = []
    for pn, b in out:
        if pn.lower() not in seen: seen.append(pn.lower()); res.append((pn, b))
    return res


def grid_col_of(mid, param):
    """화면 소스 사실(actions.csv)에서 저장 인자 param 에 넣는 그리드 열 이름 — 같은 줄에 인자 이름과 GetColumnIndex(열) 이 함께 있는 줄만(근거 파일:줄)"""
    out = []
    for r in rd(P("Doc", "asisfacts", "screens", mid, "actions.csv")):
        txt = " ".join(str(v) for v in r.values())
        if not re.search(r"(?<!\w)%s(?!\w)" % re.escape(param), txt, re.I) or "GetColumnIndex" not in txt: continue
        for m in re.finditer(r'GetColumnIndex\(\s*(?:"+(\w+)"+|(?:\w+\.)*(\w+))\s*\)', txt):
            c = m.group(1) or m.group(2)
            if c and c not in [x[0] for x in out]: out.append((c, "%s:%s" % (os.path.basename(str(r.get("file") or "").replace("\\", "/")), r.get("line") or "")))
    return out


def grid_col_via_var(mid, param, save_sp):
    """인자에 지역 변수를 넣는 화면(11-14): request.Parameters["인자"] = 변수 줄과, 같은 메서드의 '변수 = …GetColumnIndex(열)…' 또는 '변수 = dr[DefColumns.열]' 줄을 잇는다.
    반환 [(열, 근거)] — 분기마다 다른 열을 넣으면 여러 개가 나온다(부르는 쪽이 그리드에 있는 열이 1개일 때만 쓴다). 저장 SP 를 부르는 메서드 안의 줄만 본다."""
    rows = rd(P("Doc", "asisfacts", "screens", mid, "actions.csv"))
    meths = {r.get("method") for r in rows if save_sp.lower() in " ".join(str(v) for v in r.values()).lower()}
    vars_ = []
    for r in rows:
        if r.get("method") in meths and r.get("kind") == "DATA_OP" and re.search(r'Parameters\["%s"\]' % re.escape(param), r.get("target") or "", re.I):
            v = (r.get("value") or "").strip()
            if re.fullmatch(r"\w+", v) and v not in vars_: vars_.append(v)
    out = []
    for v in vars_:
        for r in rows:
            if r.get("method") not in meths: continue
            m = re.search(r"(?<![\w.])%s\s*\+?=(?!=)\s*([^;]{1,300})" % re.escape(v), r.get("raw") or r.get("target") or "")
            if not m: continue
            rhs = m.group(1)
            for k in list(re.finditer(r'GetColumnIndex\(\s*(?:"+(\w+)"+|(?:\w+\.)*(\w+))\s*\)', rhs)) + list(re.finditer(r'\b(?:dr|row|drv|dataRow)\[\s*(?:"+(\w+)"+|(?:\w+\.)*(\w+))\s*\]', rhs)):
                c = k.group(1) or k.group(2)
                if c and c not in [x[0] for x in out]:
                    out.append((c, "변수 %s ← %s:%s" % (v, os.path.basename(str(r.get("file") or "").replace("\\", "/")), r.get("line") or "")))
    return out


def one(mid, fm, db):
    eps = []
    for r in rd(P("Doc", "asislive", mid, "scenarios_cov.csv")) or rd(P("Doc", "asislive", mid, "scenarios_src.csv")):
        if r.get("type") != "저장": continue
        for e in [x.strip() for x in (r.get("endpoints") or "").split(";") if x.strip()]:
            if SAVE.search(e.split(".")[-1]) and e not in eps: eps.append(e)
    if not eps: return []
    gt = grid_tags(mid); res = []
    for e in eps:
        fid = e.split(".")[-1]; sp = fm.get(fid) or fid; txt = db.text(sp)
        d = {"endpoint": e, "save_sp": sp, "status": "", "table": "", "pk": [], "match": {}, "unmatched_pk": [], "edit": None, "side": [], "sheet": "", "writes": {}, "basis": "foxml %s → SP %s 원문(sys.sql_modules) · 키 = sys.indexes PK" % (fid, sp)}
        if not txt: d["status"] = "SP 원문 없음"; res.append(d); continue
        w, ex = writes(txt); sub = collections.defaultdict(list)
        for p in ex:
            t2 = db.text(p)
            if t2 and p.lower() != sp.lower():
                for k, v in writes(t2)[0].items(): sub[k] += v
        d["writes"] = {k: sorted(set(v)) for k, v in w.items()}; d["writes_via_exec"] = {k: sorted(set(v)) for k, v in sub.items() if k not in w}
        cand = [(k, v) for k, v in w.items() if db.table(k) and not HIST.search(k)]
        if not cand: d["status"] = "주 테이블 미확정"; d["side"] = [{"table": k, "pk": (db.table(k) or {}).get("pk") or []} for k in list(w) + list(sub) if db.table(k)]; res.append(d); continue
        cand.sort(key=lambda kv: (-int(any(o.startswith("MERGE") for o in kv[1])), -len(kv[1]), kv[0]))
        main = cand[0][0]; tb = db.table(main); d["table"] = main; d["pk"] = tb["pk"]; d["other_tables"] = [k for k, _v in cand[1:]]
        d["side"] = [{"table": k, "pk": db.table(k)["pk"]} for k in list(w) + list(sub) if k != main and db.table(k) and HIST.search(k) and db.table(k)["pk"]]
        if not gt: d["status"] = "그리드 덤프 없음"; res.append(d); continue
        colnames = [c for c, _t in tb["cols"]]
        sheet, tags = max(gt.items(), key=lambda kv: len({x.upper() for x in kv[1]} & {c.upper() for c in colnames})); d["sheet"] = sheet; up = {x.upper(): x for x in tags}
        for k in tb["pk"]:
            if k.upper() in up: d["match"][k] = up[k.upper()]
            else:
                # 이름이 다른 키: SP 원문(컬럼 ← 인자)과 화면 소스(인자 ← 그리드 열)를 이어 대응시킨다. 두 고리가 모두 원문에 있고 그 열이 그리드에 있을 때만.
                hit = None; tried = []
                for pn, b1 in param_of(txt, k):
                    gcs = grid_col_of(mid, pn)
                    for gc, b2 in gcs:
                        tried.append("%s←%s" % (pn, gc))
                        if gc.upper() in up: hit = (up[gc.upper()], "%s ← @%s(%s) ← 그리드 열 %s(%s)" % (k, pn, b1, gc, b2)); break
                    if hit: break
                    if not gcs:
                        vcs = grid_col_via_var(mid, pn, d["save_sp"]); ex = []
                        for gc, b2 in vcs:
                            tried.append("%s←%s(%s)" % (pn, gc, "변수"))
                            if gc.upper() in up and up[gc.upper()] not in [e[0] for e in ex]: ex.append((up[gc.upper()], gc, b2))
                        if len(ex) == 1: hit = (ex[0][0], "%s ← @%s(%s) ← %s ← 그리드 열 %s%s" % (k, pn, b1, ex[0][2], ex[0][1], (" · 소스의 다른 분기는 열 %s 를 넣음(그리드 덤프에 없음 — 사람이 확인)" % ",".join(g for g, _b in vcs if g != ex[0][1])) if len(vcs) > 1 else "")); break
                        if len(ex) > 1: tried.append("%s←분기마다 다른 열(%s) — 사람이 확인" % (pn, ",".join(e[0] for e in ex)))
                        if not vcs: tried.append("%s←(그리드 열에서 오지 않음)" % pn)
                if hit: d["match"][k] = hit[0]; d.setdefault("match_basis", {})[k] = hit[1]
                else: d["unmatched_pk"].append(k); d.setdefault("unmatched_why", {})[k] = "; ".join(tried[:4]) or "SP 원문에 '컬럼 = @인자' 꼴이 없음"
        ed = next(((c, t) for c, t in tb["cols"] if c not in tb["pk"] and t in NUM and c.upper() in up), None)
        if ed: d["edit"] = {"col": up[ed[0].upper()], "db_col": ed[0], "rule": "plus1"}
        d["edit_candidates"] = [{"col": up[c.upper()], "db_col": c, "rule": "plus1"} for c, t in tb["cols"] if c not in tb["pk"] and t in NUM and c.upper() in up]   # 첫 후보가 잠긴 열이면 연습 실행이 다음 후보를 써 본다
        d["status"] = ("키가 없는 테이블" if not tb["pk"] else "키 일부 미대응" if d["unmatched_pk"] else "고칠 열 후보 없음" if not ed else "키 대응 완료")
        res.append(d)
    try: old = {x.get("save_sp"): x for x in json.load(open(P("Doc", "asislive", mid, "save_scenario.draft.json"), encoding="utf-8")).get("drafts") or []}
    except Exception: old = {}
    for d in res:                                               # 앞서 한 연습 실행 결과는 정의가 같을 때만 남긴다
        o = old.get(d["save_sp"])
        if o and o.get("dry") and o.get("table") == d["table"] and o.get("match") == d["match"]: d["dry"] = o["dry"]
    out = {"id": mid, "note": "초안 — 사람이 소스와 SP 원문을 확인한 뒤 save_scenario.json 으로 옮겨야 실행된다", "drafts": res}
    with open(P("Doc", "asislive", mid, "save_scenario.draft.json"), "w", encoding="utf-8") as f: json.dump(out, f, ensure_ascii=False, indent=1)
    return res


def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith("-")]; ALL = not ids
    if not ids: ids = sorted(os.path.basename(os.path.dirname(f)) for f in glob.glob(P("Doc", "asislive", "*", "scenarios_cov.csv")))
    fm = foxmap(); db = Db(); rows = []; c = collections.Counter(); scr = collections.Counter()
    for mid in ids:
        ds = one(mid, fm, db)
        if not ds: continue
        best = "키 대응 완료" if any(d["status"] == "키 대응 완료" for d in ds) else ds[0]["status"]; scr[best] += 1
        for d in ds:
            c[d["status"]] += 1
            rows.append({"id": mid, "endpoint": d["endpoint"], "save_sp": d["save_sp"], "status": d["status"], "table": d["table"], "pk": ",".join(d["pk"]), "matched": ",".join(d["match"]), "unmatched_pk": ",".join(d["unmatched_pk"]),
                         "edit_col": (d["edit"] or {}).get("col") or "", "side": ",".join(x["table"] for x in d["side"]), "other_tables": ",".join(d.get("other_tables") or []), "sheet": d["sheet"]})
        if not ALL:
            for d in ds: print("[%s] %s → %s · %s · 테이블 %s · 키 %s · 미대응 %s · 고칠 열 %s · 덧붙는 표 %s" % (mid, d["endpoint"], d["save_sp"], d["status"], d["table"] or "-", ",".join(d["pk"]) or "-", ",".join(d["unmatched_pk"]) or "없음", (d["edit"] or {}).get("col") or "-", ",".join(x["table"] for x in d["side"]) or "-"))
    if ALL and rows:
        with open(P("Doc", "asislive", "_save_draft_summary.csv"), "w", encoding="utf-8-sig", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
        print("foxml 호출 정의 %d개 · 저장 호출이 있는 화면 %d · 저장 호출 %d" % (len(fm), sum(scr.values()), len(rows)))
        print("저장 호출 상태: " + ", ".join("%s %d" % kv for kv in c.most_common()))
        print("화면 상태(키 대응 완료가 1개 이상이면 완료로 셈): " + ", ".join("%s %d" % kv for kv in scr.most_common()))
        print("@@LINK 📄 저장 정의 초안 요약|Doc/asislive/_save_draft_summary.csv")
    return 0


if __name__ == "__main__":
    sys.exit(main())
