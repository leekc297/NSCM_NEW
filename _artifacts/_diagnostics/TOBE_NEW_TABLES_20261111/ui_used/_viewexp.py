"""_viewexp.py — VIEW 내부 참조 객체 재귀 전개 (2026-10-15 사용자 요청: VIEW 안에서 사용하는 TABLE 도 목록에 포함)

기준 = ALL_DEPENDENCIES (VIEW/독립 FUNCTION 은 객체 전체가 실행되므로 객체 단위 의존 = 실사용).
  VIEW → TABLE / VIEW / SYNONYM(→실체) / FUNCTION(→그 함수의 TABLE·VIEW·FUNCTION 재귀) / PACKAGE(멤버 미상 → 경고)
SYS 딕셔너리 뷰는 SYS 내부 객체라 전개하지 않는다.
교차검증용으로 VIEW 원문(ALL_VIEWS.TEXT)에서 FROM/JOIN 대상 이름을 별도 추출해 비교한다(view_expand_check.csv).
"""
import csv, json, re, pathlib, collections

D = pathlib.Path(__file__).resolve().parent
_deps = collections.defaultdict(set)
for d in csv.DictReader((D / "dict/dependencies.csv").open(encoding="utf-8-sig")):
    _deps[(d["OWNER"], d["NAME"])].add((d["REFERENCED_OWNER"], d["REFERENCED_NAME"], d["REFERENCED_TYPE"]))
_syn = {}
for s in csv.DictReader((D / "dict/synonyms.csv").open(encoding="utf-8-sig")):
    _syn[(s["OWNER"], s["SYNONYM_NAME"])] = (s["TABLE_OWNER"], s["TABLE_NAME"])
_temp = {(t["OWNER"], t["TABLE_NAME"]) for t in csv.DictReader((D / "dict/tables.csv").open(encoding="utf-8-sig")) if t["TEMPORARY"] == "Y"}
_otype = collections.defaultdict(set)
for o in csv.DictReader((D / "dict/objects.csv").open(encoding="utf-8-sig")):
    _otype[(o["OWNER"], o["OBJECT_NAME"])].add(o["OBJECT_TYPE"])

def _real(ro, rn, rt):
    k = (ro, rn)
    for _ in range(4):
        if rt != "SYNONYM": break
        s = _syn.get(k) or _syn.get(("PUBLIC", k[1]))
        if not s: break
        k = s
        t = _otype.get(k, set()) - {"SYNONYM"}
        rt = "VIEW" if "VIEW" in t else ("TABLE" if "TABLE" in t else ("FUNCTION" if "FUNCTION" in t else ("PACKAGE" if "PACKAGE" in t else "SYNONYM")))
    return k[0], k[1], rt

_cache = {}
def expand_view(owner, name):
    """VIEW (owner,name) → [(owner, name, type, path)] 전개된 TABLE/VIEW(중첩 VIEW 포함) + 경고"""
    key = (owner, name)
    if key in _cache: return _cache[key]
    out, warns, seen = [], [], {key}
    def walk(k, path):
        for ro, rn, rt in sorted(_deps.get(k, ())):
            if ro == "SYS" or (ro == "PUBLIC" and rt != "SYNONYM"): continue
            o2, n2, t2 = _real(ro, rn, rt)
            if (o2, n2) in seen or o2 == "SYS": continue
            seen.add((o2, n2))
            p2 = f"{path} > {n2}"
            if t2 in ("TABLE", "VIEW", "MATERIALIZED VIEW"):
                out.append((o2, n2, "GTT" if (o2, n2) in _temp else ("VIEW" if t2 != "TABLE" else "TABLE"), p2))
                if t2 != "TABLE": walk((o2, n2), p2)
            elif t2 in ("FUNCTION", "PROCEDURE"):
                walk((o2, n2), p2)
            elif t2 == "PACKAGE":
                warns.append(f"{p2} (PACKAGE 참조 — 멤버 미상)")
    walk(key, name)
    _cache[key] = (out, warns)
    return out, warns

def text_check():
    """독립 교차검증: VIEW 원문의 FROM/JOIN 대상(실존 TABLE/VIEW) ⊆ 의존 전개 결과"""
    rows = []
    texts = {}
    for line in (D / "source/views.jsonl").open(encoding="utf-8"):
        o = json.loads(line); texts[(o["OWNER"], o["NAME"])] = o["TEXT"]
    for (o, n), txt in texts.items():
        t = re.sub(r"--[^\n]*|/\*.*?\*/", " ", txt, flags=re.S).upper()
        t = re.sub(r"'[^']*'", "''", t)
        names = set(re.findall(r"\b(?:FROM|JOIN)\s+(?:([A-Z_][A-Z0-9_$#]*)\.)?([A-Z_][A-Z0-9_$#]*)", t))
        exp, _ = expand_view(o, n)
        got = {x[1] for x in exp}
        for own, nm in names:
            k = (own or o, nm)
            ty = _otype.get(k, set()) or _otype.get((o, nm), set())
            if "SYNONYM" in ty:
                r = _real(k[0], nm, "SYNONYM"); nm = r[1]; ty = _otype.get((r[0], r[1]), set())
            if not (ty & {"TABLE", "VIEW"}): continue
            rows.append(dict(VIEW=f"{o}.{n}", NAME=nm, IN_EXPANSION="Y" if nm in got else "N"))
    return rows
