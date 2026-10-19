"""[파일 분석] '-'→'/' 일괄 변환(DML) 위험 목록 생성 — 보류 51 컬럼 제외
입력: _scan_counts.json(실측) · _scan_stats.json(통계) · _scan_dict.json(제약·인덱스) · _join_pairs.json/_join_half.json(조인 쌍) · 작업대상 xlsx 3_TOBE_변경목록
출력: _risk.json  (xlsx 는 s6 에서)
변환 대상 컬럼 = 모집단 1,797 − 보류 51. '실제 변환 행' = 사내 ZIOUI1 에서 값이 '-' 인 행(실측).
"""
import sys, json, re, pathlib, collections, shutil
import openpyxl
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import s1_data_scan as s

HERE = pathlib.Path(__file__).resolve().parent
pop = s.population()
POP = {(c["table"], c["column"]): c for c in pop}
# 2026-10-07 사용자 지시: 기준 파일 '정제전' 에 있고 DEFAULT '-' 설정된 115컬럼 일괄 추가 (_pop_extra.json, s7) → 변환 대상
EXTRA = json.loads((HERE / "_pop_extra.json").read_text(encoding="utf-8"))["rows"] if (HERE / "_pop_extra.json").exists() else []
HELD_NAMES = {c["column"] for c in pop if c["held"]}
for e in EXTRA:
    k = (e["table"], e["column"])
    if k not in POP:
        new = e.get("kind") == "new_table"
        c = dict(owner=e["owner"], table=e["table"], column=e["column"], dtype=e["dtype"], state="DEFAULT '-' ON NULL" if not new else f"DEFAULT {e.get('file_default')}",
                 use="(추가분 — AS-IS '-' 사용 분류 미실시)" if not new else "(신규 테이블 — AS-IS 없음)",
                 cls="추가분(2026-10-07 사용자 지시) — 일괄 변환" if not new else "신규 테이블 — DEFAULT '/' 만(DML 변환·코드 수정 없음, 사용자 지시 10-07)",
                 held=new, extra=True, new_table=new, held_name=e["column"] in HELD_NAMES)
        pop.append(c); POP[k] = c
# 사용자 지시(10-07): 코드 마스터 성격 → DML 일괄 변환 제외 (DEFAULT 는 1차 목록대로)
EXCLUDE_DML = {"SCM_ADM_LOOKUP_MASTER_DETAIL"}
for c in pop:
    if c["table"] in EXCLUDE_DML: c["held"] = True; c["cls"] = "제외 — 코드 마스터(사용자 지시 10-07, DML 변환 안 함)"
# 조인 상대 컬럼 실측 (s5_partner_scan.py — AS-IS 개발 DB · TO-BE 사내)
PS = json.loads((HERE / "_partner_scan.json").read_text(encoding="utf-8")) if (HERE / "_partner_scan.json").exists() else {}
PSC = {}
for t, e in PS.items():
    for c in set(e.get("asis", {})) | set(e.get("tobe", {})):
        PSC[(t, c)] = dict(asis=e["asis"].get(c), tobe=e["tobe"].get(c))
counts = json.loads((HERE / "_scan_counts.json").read_text(encoding="utf-8"))
stats = {(r["table"], r["column"]): r for r in json.loads((HERE / "_scan_stats.json").read_text(encoding="utf-8"))["rows"]}
D = json.loads((HERE / "_scan_dict.json").read_text(encoding="utf-8"))
pairs = json.loads((HERE / "_join_pairs.json").read_text(encoding="utf-8"))
half = json.loads((HERE / "_join_half.json").read_text(encoding="utf-8"))

CNT = {}; scanned_tabs = set(); scan_err = {}
for k, e in counts.items():
    t = k.split(".", 1)[1]
    if "error" in e: scan_err[t] = e["error"]; continue
    scanned_tabs.add(t)
    for c, v in e["cols"].items(): CNT[(t, c)] = dict(v, rows=e.get("rows"))

# 기존 데이터의 '-' / 빈값 실태 = AS-IS 기준 (사용자 지시 2026-10-07: TO-BE 의 '-' 는 전부 '/' 로 바뀔 값이라 TO-BE 건수 비교는 의미 없음)
#   원천 = 작업대상 xlsx 1_컬럼판정 의 AS-IS 실측 열(다른 세션이 AS-IS DEV 직접 스캔: '-' 10-01 · '' / ' ' 10-07)
TOBE = CNT          # 사내 ZIOUI1 부분 실측(65/252 테이블에서 중단) — 유니크 키 중복·기존 '/' 값 확인에만 참고
_tmp1 = HERE / "_src_copy.xlsx"; shutil.copy2(s.SRC, _tmp1)
_r1 = list(openpyxl.load_workbook(_tmp1, read_only=True, data_only=True)["1_컬럼판정"].iter_rows(values_only=True))
_h1 = [str(c) for c in _r1[0]]
def _num(v):
    try: return int(str(v).replace(",", ""))
    except Exception: return None
ASIS = {}
for r in _r1[1:]:
    if not r or not r[1]: continue
    g = lambda k: r[_h1.index(k)]
    ASIS[(r[1], r[2])] = dict(dash=_num(g("AS-IS '-' 행수(10-01)")), blank=_num(g("AS-IS 빈값 행수(10-01, ''+' ' 합산)")),
                              empty=_num(g("AS-IS '' 행수(10-07)")), space=_num(g("AS-IS 공백만(' ') 행수(10-07)")), trail=_num(g("AS-IS 뒤공백 값 행수(10-07)")))
# 추가분(115) 은 작업대상 xlsx 에 AS-IS 실측이 없다 → 조인 상대 실측(s5) 에 있으면 그 값을 쓴다
for (t, c), v in PSC.items():
    a = v.get("asis")
    if (t, c) in POP and (t, c) not in ASIS and a and "missing" not in a:
        ASIS[(t, c)] = dict(dash=a["dash"], blank=a["null"] + a["empty"] + a["space"], empty=a["empty"], space=a["space"], trail=None)
for k in POP:
    ASIS.setdefault(k, dict(dash=None, blank=None, empty=None, space=None, trail=None))
CNT = {}
for k, a in ASIS.items():
    known = a["dash"] is not None or a["blank"] is not None
    CNT[k] = dict(dash=(a["dash"] or 0) + (a["blank"] or 0), asis_dash=a["dash"], asis_blank=a["blank"], asis_known=known,
                  slash=(TOBE.get(k) or {}).get("slash"), ddash=(TOBE.get(k) or {}).get("ddash"), blank=a["space"] or 0, rows=(TOBE.get(k) or {}).get("rows"))

def kind(t, c):
    """컬럼의 변환 후 상태 — '변환 행' = AS-IS 의 빈값('' · ' ') + '-' 행 (TO-BE 에서 전부 '-' 로 들어와 '/' 로 바뀔 행)"""
    p = POP.get((t, c))
    if p:
        v = CNT.get((t, c))
        if p.get("new_table"): return "신규 테이블(DEFAULT 만 — DML·비교 대상 아님)", None
        if p["held"]: return ("제외(코드 마스터)" if p["table"] in EXCLUDE_DML else "보류51(값 '-' 유지)"), (v or {}).get("asis_dash")
        if v is None or not v["asis_known"]: return "변환대상", None      # AS-IS 테이블 없음(신규)·미스캔 → 변환 행이 있을 수 있다고 본다
        return ("변환대상" if v["dash"] else "변환대상('-' 0행)"), v["dash"]
    ps = PSC.get((t, c))
    if ps and ps.get("tobe"):
        tb, a = ps["tobe"], ps.get("asis") or {}
        if not tb["dash"]: return "모집단 밖 — TO-BE '-' 0행(실측)", tb["dash"]
        if "missing" in a or not a: return "모집단 밖 — AS-IS 에 없음 · TO-BE '-' 보유(실측)", tb["dash"]
        if a["dash"] == 0: return "모집단 밖 — TO-BE '-' 는 이관 생성(AS-IS 빈값, 실측)", tb["dash"]
        if a["empty"] + a["space"] == 0: return "모집단 밖 — AS-IS 실제 '-' 보유(실측)", tb["dash"]
        return "모집단 밖 — AS-IS '-' 와 빈값 공존(실측)", tb["dash"]
    st = stats.get((t, c))
    if st is None: return "모집단 밖(사전에 없음)", None
    if st["temp"] == "Y": return "임시테이블", None
    return {"dash": "모집단 밖 — '-' 보유(통계)", "none": "모집단 밖 — '-' 없음(통계)", "nostat": "모집단 밖 — 통계 없음", "unknown(low<'-')": "모집단 밖 — 판정 불가(최솟값이 '-' 보다 앞)"}[st["flag"]], st.get("num_rows")


def risky_other(k):
    """변환되지 않는데 '-' 가 남을 수 있는 상대 컬럼인가"""
    if k.startswith(("변환대상", "신규 테이블")) or k in ("임시테이블", "모집단 밖(사전에 없음)"): return False
    return not ("'-' 없음" in k or "0행" in k)

R = collections.OrderedDict()

# ── A. 조인: 한쪽만 변환 ─────────────────────────────────────────────
A = collections.OrderedDict(); A_half = []
for p in pairs:
    k1, n1 = kind(p["t1"], p["c1"]); k2, n2 = kind(p["t2"], p["c2"])
    for (ta, ca, ka, na, da), (tb, cb, kb, nb, db) in (((p["t1"], p["c1"], k1, n1, p["nvl1"]), (p["t2"], p["c2"], k2, n2, p["nvl2"])), ((p["t2"], p["c2"], k2, n2, p["nvl2"]), (p["t1"], p["c1"], k1, n1, p["nvl1"]))):
        if ka != "변환대상": continue
        if not risky_other(kb): continue
        if tb in EXCLUDE_DML: continue   # 코드 마스터 상대 → L(코드 NVL) 로 처리
        # 사용자 지시(10-07): '/' 가 되는 행 = AS-IS 에서 NULL·''·' ' 였던 행만. AS-IS 실제 '-' 는 변환 대상도 비교 대상도 아님.
        #   → 변환 쪽: AS-IS 빈값 행이 0 이면 변환되는 행 없음 → 제외
        #   → 상대 쪽: '-' 가 전부 AS-IS 실제 값이면, 현재 TO-BE 에서만 '-'='-' 로 맞던 것이 변환 후 안 맞게 되는 것 = AS-IS 동작 복원 → 제외
        #      상대의 '-' 중 AS-IS 빈값 유래분이 있을 때만 회귀(AS-IS ''='' 로 맞던 행이 '/'≠'-' 로 끊김) 가능 → 검사
        cv = CNT[(ta, ca)]
        if cv["asis_known"]:
            conv_rows, conv_mode = (cv["asis_blank"] or 0), "AS-IS NULL·''·' ' 유래 행만 → '/' (실제 '-' 유지)"
            if conv_rows == 0: continue
        else:
            conv_rows, conv_mode = None, "미확인(AS-IS 실측 없음)"
        # 사용자 지시(10-07): TO-BE 에서 NULL 허용 컬럼은 이번 작업(DEFAULT·DML) 대상 아님 → 상대가 NULL 허용이면 제외
        ot = (PSC.get((tb, cb)) or {}).get("tobe")
        if ot and ot.get("nullable") == "Y": continue
        if not ot and stats.get((tb, cb), {}).get("nullable") == "Y": continue
        oa = (PSC.get((tb, cb)) or {}).get("asis")
        if oa and "missing" not in oa: other_blank = oa["null"] + oa["empty"] + oa["space"]
        elif (tb, cb) in ASIS and ASIS[(tb, cb)]["blank"] is not None: other_blank = ASIS[(tb, cb)]["blank"]
        else: other_blank = None
        if other_blank == 0: continue
        key = (ta, ca, tb, cb)
        e = A.setdefault(key, dict(conv_table=ta, conv_col=ca, conv_dash=na, conv_asis_dash=CNT[(ta, ca)]["asis_dash"], conv_asis_blank=CNT[(ta, ca)]["asis_blank"], conv_cls=POP[(ta, ca)]["cls"],
                                   conv_rows=conv_rows, conv_mode=conv_mode, other_blank=other_blank,
                                   other_table=tb, other_col=cb, other_kind=kb, other_rows=nb, other_tobe_dash=(PSC.get((tb, cb)) or {}).get("tobe", {}) and PSC[(tb, cb)]["tobe"].get("dash"),
                                   other_asis=(PSC.get((tb, cb)) or {}).get("asis"), uses=[]))
        e["uses"].append(f'{p["obj"]} L{p["line"]}')
        e.setdefault("sample", p["text"])
for h in half:
    for t, c, oa, oc in ((h["t1"], h["c1"], h["a2"], h["c2"]), (h["t2"], h["c2"], h["a1"], h["c1"])):
        if t and kind(t, c)[0] == "변환대상":
            A_half.append(dict(conv_table=t, conv_col=c, other_alias=oa, other_col=oc, obj=h["obj"], line=h["line"], text=h["text"]))
R["A_join"] = [dict(v, use_count=len(v["uses"]), objects=", ".join(sorted({u.split(" L")[0] for u in v["uses"]}))[:800], uses=v["uses"][:40]) for v in A.values()]
R["A_join_half_summary"] = dict(count=len(A_half), by_col=collections.Counter(f'{x["conv_table"]}.{x["conv_col"]}' for x in A_half).most_common(60))
R["A_join_half"] = A_half

# ── L. 코드 마스터(SCM_ADM_LOOKUP_MASTER_DETAIL) 와 NOT NULL 변환 컬럼의 조인 — 코드(DML)에서 NVL(x,'/') 처리 (사용자 지시 10-07) ──
L = collections.OrderedDict()
for p in pairs:
    for tl, cl, to, co in ((p["t1"], p["c1"], p["t2"], p["c2"]), (p["t2"], p["c2"], p["t1"], p["c1"])):
        if tl in EXCLUDE_DML and (to, co) in POP and not POP[(to, co)]["held"]:
            k = (p["obj"], p["line"], cl, to, co)
            L.setdefault(k, dict(obj=p["obj"], type=p["type"], line=p["line"], lookup_col=cl, lookup_asis_dash=ASIS.get((tl, cl), {}).get("dash"), lookup_asis_blank=ASIS.get((tl, cl), {}).get("blank"),
                                 other=f"{to}.{co}", other_cls=POP[(to, co)]["cls"], other_asis_blank=CNT.get((to, co), {}).get("asis_blank"), text=p["text"],
                                 proposal=f"{tl} 쪽을 NVL({cl}, '/') 로 감싼다 — 상대 {to}.{co} 는 NOT NULL 이고 빈값 유래 행이 '/' 로 바뀜. 코드 마스터 데이터는 변환하지 않음"))
R["L_lookup_join"] = list(L.values())

# ── B. 유니크 키 ─────────────────────────────────────────────────────
ccols = collections.defaultdict(list)
for r in D["ccols"]: ccols[(r["OWNER"], r["CONSTRAINT_NAME"])].append(r["COLUMN_NAME"])
icols = collections.defaultdict(list)
for r in D["icols"]: icols[(r["INDEX_OWNER"], r["INDEX_NAME"])].append(r["COLUMN_NAME"])
B = []; seen = set()
def add_uk(t, name, typ, cols):
    key = (t, tuple(cols))
    if key in seen: return
    conv = [c for c in cols if (t, c) in POP and not POP[(t, c)]["held"]]
    if not conv: return
    seen.add(key)
    v = [CNT.get((t, c)) for c in conv]
    dash = [c for c, x in zip(conv, v) if x and x["dash"]]
    both = [c for c, x in zip(conv, v) if x and x["dash"] and x["slash"]]
    blank = [c for c, x in zip(conv, v) if x and x["blank"]]
    if not dash and not blank: return
    B.append(dict(table=t, name=name, type=typ, cols=cols, conv_cols=conv, dash_cols=dash, both_cols=both, blank_cols=blank,
                  need_check=bool(both) or bool(blank), rows=(v[0] or {}).get("rows") if v else None,
                  note=("'-' 와 '/' 가 같은 컬럼에 공존 → 변환 후 키 중복 가능 — 실측 필요" if both else "") + (" / 공백만 값 보유 → 공백→'/' 규칙 적용 시 중복 가능 — 실측 필요" if blank else "") or "'/' 값 없음 → '-'→'/' 는 1:1 사상, 중복 불가"))
for r in D["cons"]:
    if r["OWNER"] == "SCM_MGR" and r["CONSTRAINT_TYPE"] in ("P", "U"): add_uk(r["TABLE_NAME"], r["CONSTRAINT_NAME"], "PK" if r["CONSTRAINT_TYPE"] == "P" else "UK", ccols[(r["OWNER"], r["CONSTRAINT_NAME"])])
for r in D["idx"]:
    if r["TABLE_OWNER"] == "SCM_MGR" and r["UNIQUENESS"] == "UNIQUE": add_uk(r["TABLE_NAME"], r["INDEX_NAME"], "UNIQUE INDEX", icols[(r["OWNER"], r["INDEX_NAME"])])
R["B_unique"] = B

# ── C. FK ────────────────────────────────────────────────────────────
cons = {(r["OWNER"], r["CONSTRAINT_NAME"]): r for r in D["cons"]}
Cx = []
for r in D["cons"]:
    if r["CONSTRAINT_TYPE"] != "R": continue
    child = ccols[(r["OWNER"], r["CONSTRAINT_NAME"])]; par = cons.get((r["R_OWNER"], r["R_CONSTRAINT_NAME"]))
    pcols = ccols[(r["R_OWNER"], r["R_CONSTRAINT_NAME"])]; pt = par["TABLE_NAME"] if par else None
    hit = [(c, pc) for c, pc in zip(child, pcols) if (r["TABLE_NAME"], c) in POP or (pt, pc) in POP]
    if hit: Cx.append(dict(child=r["TABLE_NAME"], fk=r["CONSTRAINT_NAME"], status=r["STATUS"], parent=pt, cols=[f"{c}→{pc}: {kind(r['TABLE_NAME'], c)[0]} / {kind(pt, pc)[0]}" for c, pc in hit]))
R["C_fk"] = Cx

# ── D. 파티션 키 ─────────────────────────────────────────────────────
Dx = []
for r in D["pkey"] + D["skey"]:
    if r["OBJECT_TYPE"].strip() != "TABLE": continue
    t, c = r["NAME"], r["COLUMN_NAME"]
    if (t, c) in POP and not POP[(t, c)]["held"]:
        v = CNT.get((t, c)) or {}; st = stats.get((t, c)) or {}
        Dx.append(dict(table=t, col=c, dash=v.get("dash"), row_movement=st.get("row_movement"),
                       note="'-' 행 있음 + ROW MOVEMENT DISABLED → UPDATE 시 ORA-14402" if v.get("dash") and st.get("row_movement") == "DISABLED" else ""))
R["D_partkey"] = Dx

# ── E. CHECK · 함수기반 인덱스 · 가상 컬럼 ───────────────────────────
Ex = []
popcols_by_t = collections.defaultdict(set)
for (t, c), p in POP.items():
    if not p["held"]: popcols_by_t[t].add(c)
for r in D["cons"]:
    if r["CONSTRAINT_TYPE"] == "C" and r["OWNER"] == "SCM_MGR" and r["TABLE_NAME"] in popcols_by_t:
        sc = r.get("SEARCH_CONDITION_VC") or ""
        if re.fullmatch(r'\s*"?\w+"?\s+IS\s+NOT\s+NULL\s*', sc, re.I): continue
        cs = [c for c in popcols_by_t[r["TABLE_NAME"]] if re.search(r'\b%s\b' % re.escape(c), sc, re.I)]
        if cs: Ex.append(dict(kind="CHECK", table=r["TABLE_NAME"], name=r["CONSTRAINT_NAME"], cols=cs, expr=sc[:300], has_dash="'-'" in sc, status=r["STATUS"]))
for r in D["iexp"]:
    if r["TABLE_OWNER"] == "SCM_MGR" and r["TABLE_NAME"] in popcols_by_t:
        cs = [c for c in popcols_by_t[r["TABLE_NAME"]] if re.search(r'\b%s\b' % re.escape(c), r["COLUMN_EXPRESSION"], re.I)]
        if cs: Ex.append(dict(kind="함수기반 인덱스", table=r["TABLE_NAME"], name=r["INDEX_NAME"], cols=cs, expr=r["COLUMN_EXPRESSION"][:300], has_dash="'-'" in r["COLUMN_EXPRESSION"], status=""))
for r in D["vcol"]:
    if r["OWNER"] == "SCM_MGR" and r["TABLE_NAME"] in popcols_by_t:
        cs = [c for c in popcols_by_t[r["TABLE_NAME"]] if re.search(r'\b%s\b' % re.escape(c), r["EXPR"], re.I)]
        if cs: Ex.append(dict(kind="가상 컬럼", table=r["TABLE_NAME"], name=r["COLUMN_NAME"], cols=cs, expr=r["EXPR"][:300], has_dash="'-'" in r["EXPR"], status=""))
R["E_expr"] = Ex

# ── F. 이미 '/' · '--' · 공백만 값을 가진 변환 대상 컬럼 ──────────────
Fx = []
for (t, c), v in CNT.items():
    p = POP.get((t, c))
    if not p or p["held"]: continue
    a = ASIS[(t, c)]
    # AS-IS 에 실제 '-' 값이 있는 변환 대상 = 일괄 변환 시 실제 '-' 도 '/' 가 됨 / 공백만·뒤공백 값 = Oracle 에서 다른 값
    if (a["dash"] or 0) or (a["space"] or 0) or (a["trail"] or 0) or v["slash"] or v["ddash"]:
        Fx.append(dict(table=t, col=c, asis_dash=a["dash"], asis_blank=a["blank"], asis_empty=a["empty"], asis_space=a["space"], asis_trail=a["trail"],
                       tobe_slash=v["slash"], tobe_ddash=v["ddash"], cls=p["cls"], use=p["use"]))
R["F_values"] = Fx

# ── G/H. 코드와 데이터가 어긋나는 자리 (작업대상 xlsx 3_TOBE_변경목록) ──
tmp = HERE / "_src_copy.xlsx"; shutil.copy2(s.SRC, tmp)
ws = openpyxl.load_workbook(tmp, read_only=True, data_only=True)["3_TOBE_변경목록"]
rows = list(ws.iter_rows(values_only=True)); h = [str(c) for c in rows[0]]; I = {k: i for i, k in enumerate(h)}
def parse_cols(sv):
    out = []
    for x in re.split(r"[,;\n]+", str(sv or "")):
        m = re.match(r"\s*([A-Z_][\w$#]*)\.([A-Z_][\w$#]*)(\(([^)]*)\))?", x.strip())
        if m: out.append((m.group(1), m.group(2), m.group(4) or ""))
    return out
G = []; H = []
for r in rows[1:]:
    if not r or not r[I["객체명"]]: continue
    act = str(r[I["액션"]]); tc = parse_cols(r[I["대상 컬럼(확정)"]]); cc = parse_cols(r[I["후보 컬럼(미확정)"]])
    base = dict(obj=r[I["객체명"]], sub=r[I["서브프로그램"]], line=r[I["줄"]], action=act, use=r[I["쓰임"]], text=str(r[I["원문"]])[:300], reason=str(r[I["사유"]])[:200], note=str(r[I["비고"]] or "")[:200])
    if act in ("유지(AS-IS 값)", "미확정(검토)"):
        hitc = [(t, c) for t, c, _ in tc if kind(t, c)[0] == "변환대상"]
        hitk = [(t, c) for t, c, _ in cc if kind(t, c)[0] == "변환대상"]
        if hitc or hitk:
            G.append(dict(base, level="확정" if hitc else "후보",
                          cols=", ".join(f"{t}.{c}(AS-IS '-' {CNT[(t, c)]['asis_dash']} · 빈값 {CNT[(t, c)]['asis_blank']})" for t, c in (hitc or hitk))[:400],
                          asis_dash_max=max((CNT[(t, c)]["asis_dash"] or 0) for t, c in (hitc or hitk))))
    elif act in ("비교→'/'", "리터럴→'/'", "변형정규화→'/'"):
        held = [(t, c) for t, c, _ in tc if (t, c) in POP and POP[(t, c)]["held"]]
        outp = []
        for m in re.finditer(r"([A-Z_][\w$#]*)\.([A-Z_][\w$#]*)\s*:\s*모집단 밖\(([A-Z_][\w$#]*)\)", base["note"]):
            k = kind(m.group(3), m.group(2))[0]
            if risky_other(k): outp.append(f"{m.group(3)}.{m.group(2)} [{k}]")
        if held or outp:
            H.append(dict(base, cols=", ".join([f"{t}.{c} [보류51]" for t, c in held] + outp)[:400]))
R["G_code_keeps_dash"] = G
R["H_code_to_slash_data_stays"] = H
_conv = [(k, v) for k, v in CNT.items() if k in POP and not POP[k]["held"]]
R["meta"] = dict(pop=len(POP), extra=len(EXTRA), held=sum(1 for p in pop if p["held"]), scanned_tables=len(scanned_tabs), scan_err=scan_err, total_tables=len({c["table"] for c in pop}),
                 conv_cols_with_rows=sum(1 for k, v in _conv if v["dash"]),
                 conv_cols_asis_real_dash=sum(1 for k, v in _conv if (v["asis_dash"] or 0)),
                 conv_cols_asis_unknown=sum(1 for k, v in _conv if not v["asis_known"]),
                 missing=[f"{k}:{e['missing_or_nonchar']}" for k, e in counts.items() if e.get("missing_or_nonchar")])
(HERE / "_risk.json").write_text(json.dumps(R, ensure_ascii=False), encoding="utf-8")
print(json.dumps(R["meta"], ensure_ascii=False)[:1500])
for k, v in R.items():
    if isinstance(v, list): print(f"{k}: {len(v)}")
print("A other_kind:", collections.Counter(x["other_kind"] for x in R["A_join"]))
print("B need_check:", sum(1 for x in B if x["need_check"]), "/", len(B))
print("G level:", collections.Counter(x["level"] for x in G), " H:", len(H))
