"""02_fe_scan.py — nscm-fe 정적 스캔: 화면별 실제 호출 (MENU, SHEET, BTN) / excel-upload / comboId 수집 (2026-10-14)

정규식 1개 금지 — 아래 다중 패턴 + 상수/import/barrel 해석 + 래퍼 함수 인자 역추적.
  P1 useTabProcQuery / useProcMutation  ({menuId, sheetName, procedureAction=SEARCH|SAVE})
  P2 apiClient.callProc / callMutationProc (positional)
  P3 'call-proc' 를 포함하는 문자열·템플릿 리터럴 (경로 세그먼트 해석)
  P4 'excel-upload' 문자열·템플릿 리터럴
  P5 comboId 리터럴 (CMBO_SQL_M.SQL_ID 와 일치하는 문자열 리터럴 + 문맥 표기)
래퍼: 호출 인자가 매개변수면 그 함수의 호출부를 찾아 인자를 대입한다(최대 6단).
화면 귀속: 페이지 폴더 파일에서 시작하는 import 폐포(심볼 단위로 barrel 재수출을 따라 정의 파일까지).
출력: fe_calls.csv, fe_unresolved.csv, fe_combos.csv, fe_screen_files.json
"""
import re, csv, json, pathlib, collections

FE = pathlib.Path(r"C:\Projects\NSCM\nscm-fe")
OUT = pathlib.Path(__file__).resolve().parent
META = OUT / "meta"

# ───────────────────── 파일 적재 ─────────────────────
def strip_ts_comments(src):
    out, i, n, q = [], 0, len(src), None
    tmpl_depth = []
    while i < n:
        c = src[i]
        if q:
            out.append(c)
            if c == "\\" and i + 1 < n: out.append(src[i + 1]); i += 2; continue
            if q == "`" and src.startswith("${", i):
                out.append("{"); i += 2; tmpl_depth.append(0); q = None; continue
            if c == q: q = None
            i += 1; continue
        if tmpl_depth:
            if c == "{": tmpl_depth[-1] += 1
            elif c == "}":
                if tmpl_depth[-1] == 0:
                    tmpl_depth.pop(); out.append(c); q = "`"; i += 1; continue
                tmpl_depth[-1] -= 1
        if c in "'\"`": q = c; out.append(c); i += 1; continue
        if src.startswith("//", i):
            j = src.find("\n", i); i = n if j < 0 else j; continue
        if src.startswith("/*", i):
            j = src.find("*/", i + 2); seg = src[i:(n if j < 0 else j + 2)]
            out.append("\n" * seg.count("\n")); i = n if j < 0 else j + 2; continue
        out.append(c); i += 1
    return "".join(out)

ROOTS = [FE / "features", FE / "packages" / "shared" / "src", FE / "packages" / "foundation" / "src", FE / "apps" / "web" / "src"]
def excluded(p):
    s = str(p).replace("\\", "/")
    return ("/node_modules/" in s or p.name.endswith(".d.ts") or ".test." in p.name or ".spec." in p.name
            or "/__tests__/" in s or "/__mocks__/" in s or ".stories." in p.name)
FILES = {}
for r in ROOTS:
    for p in r.rglob("*"):
        if p.suffix in (".ts", ".tsx") and not excluded(p):
            try: FILES[p.resolve()] = strip_ts_comments(p.read_text(encoding="utf-8", errors="ignore"))
            except Exception as e: print("READ-FAIL", p, e)
print("FE files", len(FILES))
def rel(p): return str(p.relative_to(FE)).replace("\\", "/")
def lineno(txt, off): return txt.count("\n", 0, off) + 1

# ───────────────────── import 해석 ─────────────────────
ALIASES = [  # (prefix, [candidate templates with *])
    ("@admin/", ["features/admin/src/pages/*/index.ts"]), ("@authority/", ["features/authority/src/pages/*/index.ts"]),
    ("@master/", ["features/master/src/pages/*/index.ts"]), ("@demand/", ["features/demand/src/pages/*/index.ts"]),
    ("@supply/", ["features/supply/src/pages/*/index.ts"]), ("@shipping/", ["features/shipping/src/pages/*/index.ts"]),
    ("@report/", ["features/report/src/pages/*/index.ts"]), ("@sdm/", ["features/sdm/src/pages/*/index.ts"]),
    ("@factory/", ["features/factory/src/pages/*/index.ts"]),
    ("@foundation/", ["packages/foundation/src/*/index.ts", "packages/foundation/src/lib/*.ts", "packages/foundation/src/*.ts", "packages/foundation/src/*.tsx", "packages/foundation/src/*"]),
    ("@shared/", ["packages/shared/src/*/index.ts", "packages/shared/src/lib/*.ts", "packages/shared/src/*.ts", "packages/shared/src/*.tsx", "packages/shared/src/*"]),
]
def try_file(base):
    # ⚠ Windows 대소문자 무시 + with_suffix 는 'x.constants' 의 '.constants' 를 갈아끼운다 → 금지.
    #   후보는 '원문+확장자' 만, 실제 파일명과 대소문자까지 일치해야 채택.
    base = pathlib.Path(base)
    for cand in (pathlib.Path(str(base) + ".ts"), pathlib.Path(str(base) + ".tsx"), base / "index.ts", base / "index.tsx", base):
        if cand.is_file():
            c = cand.resolve()
            if c in FILES and c.name == cand.name: return c
    return None
def resolve_module(frm, spec):
    if spec.startswith("."):
        return try_file(frm.parent / spec)
    for pre, tmpls in ALIASES:
        if spec.startswith(pre):
            rest = spec[len(pre):]
            for t in tmpls:
                f = try_file(FE / t.replace("*", rest))
                if f: return f
            return None
    if spec in ("@shared", "@foundation"):
        return try_file(FE / "packages" / spec[1:] / "src" / "index.ts")
    if spec.startswith("features/") or spec.startswith("packages/"):
        return try_file(FE / spec)
    return None   # 외부 패키지

IMP_RE = re.compile(r"\bimport\s+(type\s+)?(?:([A-Za-z_$][\w$]*)\s*,?\s*)?(?:\{([^}]*)\}|\*\s+as\s+([A-Za-z_$][\w$]*))?\s*from\s*['\"]([^'\"]+)['\"]", re.S)
REEXP_RE = re.compile(r"\bexport\s+(type\s+)?(?:\*(?:\s+as\s+([\w$]+))?|\{([^}]*)\})\s*from\s*['\"]([^'\"]+)['\"]", re.S)
imports = {}    # file -> {local: (target_file, exported_name)}  exported_name '*' namespace / 'default'
reexports = {}  # file -> list of (kind, names_map or None, target)
side_imports = collections.defaultdict(set)
for f, t in FILES.items():
    m_ = {}
    for m in IMP_RE.finditer(t):
        tgt = resolve_module(f, m.group(5))
        if not tgt: continue
        if m.group(2): m_[m.group(2)] = (tgt, "default")
        if m.group(3):
            for part in m.group(3).split(","):
                part = part.strip().replace("type ", "")
                if not part: continue
                if " as " in part:
                    a, b = [x.strip() for x in part.split(" as ")]
                    m_[b] = (tgt, a)
                else: m_[part] = (tgt, part)
        if m.group(4): m_[m.group(4)] = (tgt, "*")
    for m in re.finditer(r"\bimport\s*['\"]([^'\"]+)['\"]", t):
        tgt = resolve_module(f, m.group(1))
        if tgt: side_imports[f].add(tgt)
    # 동적 import('...')
    for m in re.finditer(r"\bimport\(\s*['\"]([^'\"]+)['\"]\s*\)", t):
        tgt = resolve_module(f, m.group(1))
        if tgt: side_imports[f].add(tgt)
    imports[f] = m_
    rx = []
    for m in REEXP_RE.finditer(t):
        tgt = resolve_module(f, m.group(4))
        if not tgt: continue
        if m.group(3) is not None:
            mp = {}
            for part in m.group(3).split(","):
                part = part.strip().replace("type ", "")
                if not part: continue
                if " as " in part:
                    a, b = [x.strip() for x in part.split(" as ")]; mp[b] = a
                else: mp[part] = part
            rx.append(("named", mp, tgt))
        else:
            rx.append(("star", m.group(2), tgt))
    reexports[f] = rx

DECL_RE_T = r"(?:export\s+)?(?:default\s+)?(?:declare\s+)?(?:const|let|var|function|class|enum|interface|type|async\s+function)\s+{}\b"
_def_cache = {}
def defines(f, name):
    k = (f, name)
    if k not in _def_cache:
        _def_cache[k] = bool(re.search(DECL_RE_T.format(re.escape(name)), FILES[f]))
    return _def_cache[k]
_fx_cache = {}
def find_export(f, name, depth=0):
    """파일 f 에서 export 된 name 의 정의 파일과 원래 이름. barrel 재수출 추적."""
    k = (f, name)
    if k in _fx_cache: return _fx_cache[k]
    res = None
    if depth > 12: return None
    if name == "default":
        # export default X; / export default function X / export default class X → 그 최상위 선언
        dm = re.search(r"\bexport\s+default\s+(?:async\s+)?(?:function\s*\*?\s*|class\s+)?([A-Za-z_$][\w$]*)", FILES[f])
        res = (f, dm.group(1)) if dm and dm.group(1) not in ("function", "class") else (f, "<module>")
        _fx_cache[k] = res
        return res
    if defines(f, name):
        res = (f, name)
    else:
        for kind, mp, tgt in reexports.get(f, []):
            if kind == "named" and name in mp:
                res = find_export(tgt, mp[name], depth + 1)
            elif kind == "star" and mp is None:
                res = find_export(tgt, name, depth + 1)
            elif kind == "star" and mp == name:
                res = (tgt, "*")
            if res: break
        if not res and name in imports.get(f, {}):   # import 후 export { x }
            if re.search(r"\bexport\s*\{[^}]*\b" + re.escape(name) + r"\b[^}]*\}", FILES[f]):
                tf, tn = imports[f][name]
                res = find_export(tf, tn, depth + 1) if tn not in ("*", "default") else (tf, tn)
    _fx_cache[k] = res
    return res
def resolve_symbol(f, name):
    """file f 문맥에서 식별자 name 이 정의된 (파일, 이름)."""
    if defines(f, name): return (f, name)
    if name in imports.get(f, {}):
        tf, tn = imports[f][name]
        if tn in ("*", "default"): return (tf, tn)
        return find_export(tf, tn) or (tf, tn)
    return None

# ───────────────────── 문자열 상수 테이블 ─────────────────────
STR = r"""(?:'([^'\\\n]*)'|"([^"\\\n]*)"|`([^`$\\]*)`)"""
def lit(m, base=1): return next((g for g in m.groups()[base - 1:base + 2] if g is not None), None)
_const_cache = {}
def consts_of(f):
    if f in _const_cache: return _const_cache[f]
    t = FILES[f]; d = {}
    for m in re.finditer(r"(?:export\s+)?(?:const|let|var)\s+([A-Za-z_$][\w$]*)\s*(?::\s*[\w$.<>\[\]| ]+)?=\s*" + STR + r"\s*(?:as\s+const)?", t):
        d[m.group(1)] = lit(m, 2)
    for m in re.finditer(r"(?:export\s+)?(?:const\s+)?enum\s+([A-Za-z_$][\w$]*)\s*\{([^}]*)\}", t):
        for e in re.finditer(r"([A-Za-z_$][\w$]*)\s*=\s*" + STR, m.group(2)):
            d[f"{m.group(1)}.{e.group(1)}"] = lit(e, 2)
    # const X = { A: 'a', B: { C: 'c' } } as const  (중첩 2단)
    for m in re.finditer(r"(?:export\s+)?const\s+([A-Za-z_$][\w$]*)\s*(?::\s*[^=]+)?=\s*\{", t):
        start = m.end() - 1; depth = 0; i = start
        while i < len(t):
            if t[i] == "{": depth += 1
            elif t[i] == "}":
                depth -= 1
                if depth == 0: break
            i += 1
        body = t[start + 1:i]
        if len(body) > 20000: continue
        stack = [m.group(1)]; j = 0; key_re = re.compile(r"\s*(?:([A-Za-z_$][\w$]*)|'([^']*)'|\"([^\"]*)\")\s*:\s*")
        # 단순 토크나이저: key: 'v' | key: { ... }
        while j < len(body):
            km = key_re.match(body, j)
            if km:
                key = km.group(1) or km.group(2) or km.group(3); j = km.end()
                vm = re.match(STR, body[j:])
                if vm:
                    d[".".join(stack + [key])] = lit(vm, 1); j += vm.end(); continue
                if j < len(body) and body[j] == "{":
                    stack.append(key); j += 1; continue
                continue
            if body[j] == "}":
                if len(stack) > 1: stack.pop()
            j += 1
    _const_cache[f] = d
    return d
def const_value(f, expr, depth=0):
    """식별자/멤버식 expr 의 문자열 상수값. 없으면 None."""
    expr = expr.strip()
    if depth > 10: return None
    head, _, tail = expr.partition(".")
    sym = resolve_symbol(f, head)
    if not sym: return None
    df, dn = sym
    if dn == "*":   # namespace import
        if not tail: return None
        h2, _, t2 = tail.partition(".")
        s2 = find_export(df, h2)
        if not s2: return None
        return const_value_in(s2[0], s2[1] + ("." + t2 if t2 else ""), depth + 1)
    return const_value_in(df, dn + ("." + tail if tail else ""), depth + 1)
def const_value_in(df, key, depth):
    c = consts_of(df)
    if key in c: return c[key]
    # alias: const A = B.C  / const A = OTHER
    head, _, tail = key.partition(".")
    m = re.search(r"(?:export\s+)?const\s+" + re.escape(head) + r"\s*(?::\s*[\w$.<>\[\]| ]+)?=\s*([A-Za-z_$][\w$.]*)\s*(?:as\s+const)?\s*[;\n]", FILES[df])
    if m and depth < 10:
        return const_value(df, m.group(1) + ("." + tail if tail else ""), depth + 1)
    return None

# ───────────────────── 표현식 평가 ─────────────────────
class P(str):
    """매개변수 참조 표식"""
def split_args(s):
    out, depth, cur, q = [], 0, [], None
    i = 0
    while i < len(s):
        c = s[i]
        if q:
            cur.append(c)
            if c == "\\": cur.append(s[i + 1]); i += 2; continue
            if c == q: q = None
            i += 1; continue
        if c in "'\"`": q = c
        elif c in "([{": depth += 1
        elif c in ")]}": depth -= 1
        elif c == "," and depth == 0:
            out.append("".join(cur)); cur = []; i += 1; continue
        cur.append(c); i += 1
    if "".join(cur).strip(): out.append("".join(cur))
    return [x.strip() for x in out]
def matching(t, i, o="(", c=")"):
    depth, q = 0, None
    j = i
    while j < len(t):
        ch = t[j]
        if q:
            if ch == "\\": j += 2; continue
            if ch == q: q = None
        elif ch in "'\"`": q = ch
        elif ch == o: depth += 1
        elif ch == c:
            depth -= 1
            if depth == 0: return j
        j += 1
    return -1

LOCALS = {}   # 호출 지점 평가 중 지역 상수 {name: expr}
def eval_expr(f, e, params, _d=0):
    """반환: list of values (str | P(param) ) — 삼항 등은 다중값"""
    if _d > 8: return [None]
    e = e.strip().rstrip(",")
    e = re.sub(r"\s+as\s+[\w$.<>\[\]| ]+$", "", e).strip()
    if not e: return [None]
    if e[0] in "'\"" and e[-1] == e[0]: return [e[1:-1]]
    if e[0] == "`" and e[-1] == "`":
        return eval_template(f, e[1:-1], params)
    m = re.match(r"^(.+?)\s*\?\s*(.+?)\s*:\s*(.+)$", e, re.S)
    if m and not e.startswith("("):
        return eval_expr(f, m.group(2), params, _d + 1) + eval_expr(f, m.group(3), params, _d + 1)
    if e.startswith("(") and e.endswith(")"): return eval_expr(f, e[1:-1], params, _d + 1)
    m = re.match(r"^([A-Za-z_$][\w$]*(?:\??\.[A-Za-z_$][\w$]*)*)$", e)
    if m:
        name = e.replace("?.", ".")
        head = name.split(".")[0]
        if head in LOCALS and head not in params:
            tail = name[len(head):]
            sub = eval_expr(f, LOCALS[head], params, _d + 1)
            if tail:
                return [None]   # 지역 객체의 멤버 접근은 미해석으로 남긴다(수동 검토)
            return sub
        if head in params: return [P(name)]
        v = const_value(f, name)
        if v is not None: return [v]
        return [None]
    return [None]
def eval_template(f, body, params):
    parts, i, res = [], 0, [""]
    while i < len(body):
        if body.startswith("${", i):
            j = matching(body, i + 1, "{", "}")
            vals = eval_expr(f, body[i + 2:j], params)
            res = [r + (v if isinstance(v, str) and not isinstance(v, P) else ("{%s}" % v if isinstance(v, P) else "{?}")) for r in res for v in vals]
            i = j + 1
        else:
            k = body.find("${", i); k = len(body) if k < 0 else k
            res = [r + body[i:k] for r in res]; i = k
    return res

# ───────────────────── 함수 정의(래퍼) 탐색 ─────────────────────
FUNC_RES = [
    re.compile(r"(?:export\s+)?(?:const|let)\s+([A-Za-z_$][\w$]*)\s*(?::[^=]{0,200})?=\s*(?:async\s*)?(?:<(?:[^<>]|<(?:[^<>]|<[^<>]*>)*>)*>\s*)?\(", re.S),
    re.compile(r"(?:export\s+)?(?:default\s+)?(?:async\s+)?function\s*\*?\s*([A-Za-z_$][\w$]*)\s*(?:<[^>]*>)?\s*\(", re.S),
    re.compile(r"(?<![\w$.])([A-Za-z_$][\w$]*)\s*:\s*(?:async\s*)?\(", re.S),   # 객체 메서드 (zustand store 등)
    re.compile(r"^\s*(?:async\s+)?([A-Za-z_$][\w$]*)\s*\([^)]*\)\s*(?::[^{]{0,100})?\{", re.M),  # 메서드 단축문법
]
_fn_cache = {}
def functions_of(f):
    if f in _fn_cache: return _fn_cache[f]
    t = FILES[f]; out = []
    for rx in FUNC_RES:
        for m in rx.finditer(t):
            name = m.group(1)
            if name in ("if", "for", "while", "switch", "catch", "return", "function"): continue
            ps = t.find("(", m.start(1) + len(name)) if rx is not FUNC_RES[0] else m.end() - 1
            if ps < 0: continue
            pe = matching(t, ps)
            if pe < 0: continue
            after = t[pe + 1:pe + 400]
            am = re.match(r"\s*(?::\s*[^={]{0,300}?)?\s*(=>)?\s*", after, re.S)
            k = pe + 1 + (am.end() if am else 0)
            if k < len(t) and t[k] == "{":
                be = matching(t, k, "{", "}")
            else:   # 식 본문 화살표 → 다음 문장 끝까지
                be = k
                depth = 0
                while be < len(t):
                    ch = t[be]
                    if ch in "([{": depth += 1
                    elif ch in ")]}":
                        if depth == 0: break
                        depth -= 1
                    elif ch in ";\n" and depth == 0 and ch == ";": break
                    be += 1
            if be < 0: continue
            raw = t[ps + 1:pe]
            params = parse_params(raw)
            out.append(dict(name=name, start=m.start(), body_start=pe, end=be, params=params, raw=raw))
    _fn_cache[f] = out
    return out
def split_params(raw):
    out, depth, cur, q = [], 0, [], None
    for i, c in enumerate(raw):
        if q:
            cur.append(c)
            if c == q: q = None
            continue
        if c in "'\"`": q = c
        elif c in "([{<": depth += 1
        elif c in ")]}" or (c == ">" and raw[i - 1:i] != "="): depth -= 1
        elif c == "," and depth == 0:
            out.append("".join(cur)); cur = []; continue
        cur.append(c)
    if "".join(cur).strip(): out.append("".join(cur))
    return [x.strip() for x in out]
def parse_params(raw):
    """[(kind, name_or_keys)] kind='pos' name / kind='obj' [keys] (구조분해)"""
    res = []
    for a in split_params(raw):
        a = re.sub(r"\s*=\s*.*$", "", a, flags=re.S) if not a.startswith("{") else a
        if a.startswith("{"):
            j = matching(a, 0, "{", "}")
            inner = a[1:j]
            keys = []
            for k in split_args(inner):
                k = re.sub(r"\s*=\s*.*$", "", k, flags=re.S)
                if ":" in k:
                    src, dst = [x.strip() for x in k.split(":", 1)]
                    keys.append((src, dst))
                else:
                    k = k.strip().lstrip(".")
                    if k: keys.append((k, k))
            res.append(("obj", keys))
        else:
            nm = re.match(r"\s*\.{0,3}([A-Za-z_$][\w$]*)", a)
            res.append(("pos", nm.group(1) if nm else "?"))
    return res
def enclosing(f, off):
    best = None
    for fn in functions_of(f):
        if fn["body_start"] <= off <= fn["end"]:
            if best is None or fn["body_start"] > best["body_start"]: best = fn
    return best
def param_names(fn):
    names = set()
    for k, v in fn["params"]:
        if k == "pos": names.add(v)
        else: names.update(d for _, d in v)
    return names
def all_param_names(f, off):
    """중첩 함수까지 포함한 매개변수 집합 + 소속 함수 체인"""
    names, chain = set(), []
    for fn in sorted(functions_of(f), key=lambda x: x["body_start"]):
        if fn["body_start"] <= off <= fn["end"]:
            names |= param_names(fn); chain.append(fn)
    return names, chain

# ───────────────────── 호출 지점 추출 ─────────────────────
CALLS = []   # dict(file, line, pattern, menu, sheet, btn, ctx)
def obj_props(s):
    """객체 리터럴 문자열(중괄호 포함) → {key: expr}"""
    s = s.strip()
    if not s.startswith("{"): return None
    inner = s[1:matching(s, 0, "{", "}")]
    d = {}
    for p in split_args(inner):
        if p.startswith("..."): d.setdefault("__spread__", []).append(p[3:]); continue
        m = re.match(r"([A-Za-z_$][\w$]*)\s*:\s*(.+)$", p, re.S)
        if m: d[m.group(1)] = m.group(2)
        elif re.match(r"^[A-Za-z_$][\w$]*$", p): d[p] = p
    return d

def locals_of(f, chain, off):
    """체인 함수 본문에서 off 이전의 const/let NAME = expr (문장 단위)"""
    t = FILES[f]; d = {}
    for fn in chain:
        body = t[fn["body_start"]:off]
        for m in re.finditer(r"\b(?:const|let)\s+([A-Za-z_$][\w$]*)\s*(?::\s*[\w$.<>\[\]| ]+)?=\s*", body):
            st = m.end(); depth = 0; j = st; q = None
            while j < len(body):
                ch = body[j]
                if q:
                    if ch == q: q = None
                elif ch in "'\"`": q = ch
                elif ch in "([{": depth += 1
                elif ch in ")]}":
                    if depth == 0: break
                    depth -= 1
                elif ch == ";" and depth == 0: break   # prettier = 문장 끝 ';' 보장 (여러 줄 삼항 포함)
                j += 1
                if j - st > 600: break
            d[m.group(1)] = body[st:j].strip()
    return d

def add(f, off, pat, menu_e, sheet_e, btn_e, default_btn=None, extra=""):
    t = FILES[f]
    params, chain = all_param_names(f, off)
    LOCALS.clear(); LOCALS.update(locals_of(f, chain, off))
    params = params - set(LOCALS)
    def ev(e, dflt=None):
        if e is None: return [dflt]
        return eval_expr(f, e, params)
    for mv in ev(menu_e):
        for sv in ev(sheet_e):
            for bv in ev(btn_e, default_btn):
                CALLS.append(dict(file=f, line=lineno(t, off), pattern=pat, menu=mv, sheet=sv, btn=bv,
                                  fn=chain[-1]["name"] if chain else "", extra=extra))

for f, t in FILES.items():
    # P1 hooks
    for m in re.finditer(r"\b(useTabProcQuery|useProcMutation)\s*(?:<[^()]*?>)?\s*\(", t):
        ps = m.end() - 1; pe = matching(t, ps)
        args = split_args(t[ps + 1:pe])
        if not args: continue
        d = obj_props(args[0])
        if d is None:
            add(f, m.start(), m.group(1) + "(nonliteral)", None, None, None); continue
        dflt = "SEARCH" if m.group(1) == "useTabProcQuery" else "SAVE"
        add(f, m.start(), m.group(1), d.get("menuId"), d.get("sheetName"), d.get("procedureAction"), dflt,
            extra="spread:" + ",".join(d.get("__spread__", [])) if d.get("__spread__") else "")
    # P2 apiClient.callProc / callMutationProc
    for m in re.finditer(r"\.\s*(callProc|callMutationProc)\s*(?:<[^()]*?>)?\s*\(", t):
        if "async callProc" in t[max(0, m.start() - 10):m.start() + 20]: continue
        ps = m.end() - 1; pe = matching(t, ps)
        args = split_args(t[ps + 1:pe])
        if len(args) < 3: continue
        add(f, m.start(), "apiClient." + m.group(1), args[0], args[1], args[2])
    # P3/P4 문자열·템플릿 경로
    for m in re.finditer(r"(`[^`]*?(?:call-proc|excel-upload)[^`]*`|'[^'\n]*?(?:call-proc|excel-upload)[^'\n]*'|\"[^\"\n]*?(?:call-proc|excel-upload)[^\"\n]*\")", t):
        s = m.group(1)
        params, chain = all_param_names(f, m.start())
        LOCALS.clear(); LOCALS.update(locals_of(f, chain, m.start())); params = params - set(LOCALS)
        vals = eval_template(f, s[1:-1], params) if s[0] == "`" else [s[1:-1]]
        kind = "call-proc" if "call-proc" in s else "excel-upload"
        for v in vals:
            segs = [x for x in v.split("/") if x]
            if kind not in segs: continue
            k = segs.index(kind)
            if k < 3:
                CALLS.append(dict(file=f, line=lineno(t, m.start()), pattern="path-" + kind, menu=None, sheet=None, btn=None,
                                  fn=chain[-1]["name"] if chain else "", extra="segs<3:" + v)); continue
            def pv(x):
                mm = re.fullmatch(r"\{(.+)\}", x)
                if mm: return None if mm.group(1) == "?" else P(mm.group(1))
                return x
            CALLS.append(dict(file=f, line=lineno(t, m.start()), pattern="path-" + kind,
                              menu=pv(segs[k - 3]), sheet=pv(segs[k - 2]), btn=pv(segs[k - 1]),
                              fn=chain[-1]["name"] if chain else "", extra=""))
    # P6 컬럼/메저 메타 요청: `/admin/menu/${M}/column|measure`, { sheetNm|sheetName: X }  → 그리드 셀 콤보 원천 시트 판정용
    for m in re.finditer(r"(`[^`]*?/admin/menu/[^`]*?/(?:column|measure)`|'[^'\n]*?/admin/menu/[^'\n]*?/(?:column|measure)')", t):
        s = m.group(1)
        params, chain = all_param_names(f, m.start())
        LOCALS.clear(); LOCALS.update(locals_of(f, chain, m.start())); params = params - set(LOCALS)
        kind = "column" if s.rstrip("`'").endswith("column") else "measure"
        menus = eval_template(f, s[1:-1], params) if s[0] == "`" else [s[1:-1]]
        rest = t[m.end():m.end() + 600]
        sm = re.match(r"\s*,\s*\{", rest)
        sheet_exprs = [None]
        if sm:
            st = m.end() + sm.end() - 1; en = matching(t, st, "{", "}")
            d = obj_props(t[st:en + 1]) or {}
            e = d.get("sheetNm") or d.get("sheetName") or d.get("shtNm")
            sheet_exprs = eval_expr(f, e, params) if e else [None]
        for mv in menus:
            mm = re.search(r"/admin/menu/([^/]+)/", mv)
            menu = mm.group(1) if mm else None
            if menu and re.fullmatch(r"\{(.+)\}", menu):
                inner = menu[1:-1]; menu = None if inner == "?" else P(inner)
            for sv in sheet_exprs:
                CALLS.append(dict(file=f, line=lineno(t, m.start()), pattern="meta-" + kind, menu=menu, sheet=sv, btn=kind.upper(),
                                  fn=chain[-1]["name"] if chain else "", extra=""))
print("raw call sites", len(CALLS))

# ───────────────────── 래퍼 역추적 ─────────────────────
def importers_of(f, name):
    """name(정의 f) 을 import 하는 (파일, 로컬이름)"""
    res = [(f, name)]
    for g, imp in imports.items():
        for local, (tf, tn) in imp.items():
            if tn in ("*", "default"): continue
            if tf == f and tn == name: res.append((g, local))
            elif tf != f:
                fx = find_export(tf, tn)
                if fx and fx[0] == f and fx[1] == name: res.append((g, local))
    return res

def invocations(f, fn):
    """함수 fn(파일 f) 의 호출부: (파일, offset, 인자식목록 or props dict, 'call'|'jsx')"""
    name = fn["name"]; out = []
    users = importers_of(f, name)
    # 객체 메서드(스토어 등): 같은 feature 안 어디서든 name( 또는 .name( 으로 호출 / selector 로 꺼내 쓰기
    is_method = bool(re.search(r"(?<![\w$.])" + re.escape(name) + r"\s*:\s*(?:async\s*)?\(", FILES[f][fn["start"]:fn["start"] + len(name) + 40]))
    if is_method:
        feat = str(f).split("src")[0]
        users = [(g, name) for g in FILES if str(g).startswith(feat)]
    for g, local in set(users):
        t = FILES[g]
        for m in re.finditer(r"(?<![\w$])" + re.escape(local) + r"\s*(?:<[^()]*?>)?\s*\(", t):
            if g == f and fn["start"] <= m.start() <= fn["body_start"]: continue
            pre = t[max(0, m.start() - 12):m.start()]
            if re.search(r"(function|const|let)\s*$", pre): continue
            ps = m.end() - 1; pe = matching(t, ps)
            if pe < 0: continue
            out.append((g, m.start(), split_args(t[ps + 1:pe]), "call"))
        for m in re.finditer(r"<\s*" + re.escape(local) + r"(?=[\s/>])", t):
            # 태그 끝 '>' 를 {} 깊이·따옴표 추적으로 찾는다 (prop 안 '=>' 의 '>' 오인 방지)
            j, depth, q = m.end(), 0, None
            while j < len(t):
                ch = t[j]
                if q:
                    if ch == q: q = None
                elif ch in "'\"`" and depth == 0: q = ch
                elif ch == "{": depth += 1
                elif ch == "}": depth -= 1
                elif ch == ">" and depth == 0: break
                j += 1
            seg = t[m.end():j]
            props, k = {}, 0
            while k < len(seg):
                pm = re.compile(r"([A-Za-z_$][\w$]*)\s*=\s*(\{|'[^']*'|\"[^\"]*\")").search(seg, k)
                if not pm: break
                if pm.group(2) == "{":
                    st = m.end() + pm.end() - 1
                    en = matching(t, st, "{", "}")
                    props[pm.group(1)] = t[st + 1:en]
                    k = en - m.end() + 1
                else:
                    props[pm.group(1)] = pm.group(2); k = pm.end()
            out.append((g, m.start(), props, "jsx"))
    return out

def bind_args(fn, inv):
    """호출부 인자 → {param_name: expr}"""
    g, off, args, kind = inv
    b = {}
    if kind == "jsx":
        for k, v in fn["params"]:
            if k == "obj":
                for src, dst in v:
                    if src in args: b[dst] = args[src]
            elif k == "pos":   # props 통째 → props.x 접근
                for pk, pv in args.items(): b[f"{v}.{pk}"] = pv
        return b
    for i, (k, v) in enumerate(fn["params"]):
        if i >= len(args): break
        if k == "pos": b[v] = args[i]
        else:
            d = obj_props(args[i])
            if d:
                for src, dst in v:
                    if src in d: b[dst] = d[src]
    return b

def find_fn_by_name(f, name):
    for fn in functions_of(f):
        if fn["name"] == name: return fn
    return None

RESOLVED, UNRESOLVED = [], []
def is_p(v): return isinstance(v, P)
def resolve_call(c, depth=0, trail=""):
    vals = (c["menu"], c["sheet"], c["btn"])
    if all(isinstance(v, str) and not is_p(v) for v in vals):
        RESOLVED.append(dict(c, trail=trail)); return
    if any(v is None for v in vals) or depth > 6:
        UNRESOLVED.append(dict(c, trail=trail, reason="unknown-expr" if depth <= 6 else "depth")); return
    f = c["file"]
    # 매개변수가 있는 가장 안쪽 함수 → 그 함수 호출부
    params, chain = all_param_names(f, FILES[f].count("\n", 0, 0))  # placeholder
    fn = None
    for cand in reversed([x for x in functions_of(f) if x["name"] == c["fn"]]):
        fn = cand; break
    # 매개변수를 실제로 가진 체인 함수 찾기
    off = sum(len(l) + 1 for l in FILES[f].split("\n")[:c["line"] - 1])
    _, chain = all_param_names(f, off)
    owner = None
    for x in reversed(chain):
        pn = param_names(x)
        if any(is_p(v) and v.split(".")[0] in pn for v in vals): owner = x; break
    if not owner:
        UNRESOLVED.append(dict(c, trail=trail, reason="param-owner-not-found")); return
    invs = invocations(f, owner)
    if not invs:
        UNRESOLVED.append(dict(c, trail=trail, reason=f"no-invocation:{owner['name']}")); return
    for inv in invs:
        b = bind_args(owner, inv)
        g, ioff = inv[0], inv[1]
        gp, gchain = all_param_names(g, ioff)
        LOCALS.clear(); LOCALS.update(locals_of(g, gchain, ioff)); gp = gp - set(LOCALS)   # 호출부 지역 상수
        new = {}
        ok = True
        for key, v in zip(("menu", "sheet", "btn"), vals):
            if is_p(v):
                expr = b.get(v) or b.get(v.split(".")[0])
                if expr is None and "." in v:
                    base, rest = v.split(".", 1)
                    if base in b: expr = b[base] + "." + rest
                if expr is None:
                    dm = re.search(r"\b" + re.escape(v.split(".")[0]) + r"\s*=\s*(" + STR[3:-1] + r"|[A-Za-z_$][\w$.]*)", owner["raw"])
                    if dm: expr = dm.group(1)   # 기본값
                if expr is None: new[key] = [None]; ok = False; continue
                new[key] = eval_expr(g, expr, gp)
            else:
                new[key] = [v]
        for mv in new["menu"]:
            for sv in new["sheet"]:
                for bv in new["btn"]:
                    nc = dict(c, menu=mv, sheet=sv, btn=bv, file=g, line=lineno(FILES[g], ioff),
                              fn=gchain[-1]["name"] if gchain else "")
                    nc["origin"] = c.get("origin") or f"{rel(c['file'])}:{c['line']}"
                    resolve_call(nc, depth + 1, trail + f" <- {owner['name']}@{rel(g)}:{lineno(FILES[g], ioff)}")

# 프레임워크 정의부(axios.callProc 본체, useTabProcQuery/useProcMutation 본체)는 P1 이 호출부에서 직접 해석하므로 제외
FRAMEWORK_DEF = {(FE / "packages/foundation/src/apis/axios.ts").resolve(), (FE / "packages/shared/src/hooks/useCustomQueryClient.ts").resolve()}
CALLS = [c for c in CALLS if c["file"] not in FRAMEWORK_DEF]
for c in CALLS: resolve_call(c)
print("resolved", len(RESOLVED), "unresolved", len(UNRESOLVED))

# ───────────────────── 화면 귀속 (import 폐포) ─────────────────────
deps = collections.defaultdict(set)
for f, imp in imports.items():
    for local, (tf, tn) in imp.items():
        if tn in ("*", "default"): deps[f].add(tf); continue
        fx = find_export(tf, tn)
        deps[f].add(fx[0] if fx else tf)
    for kind, mp, tgt in reexports.get(f, []):
        pass   # barrel 재수출 자체는 사용 아님 — 심볼 import 에서 정의 파일로 직접 연결
    deps[f] |= side_imports[f]
# namespace import (import * as X) → 사용된 멤버만: X.member 를 찾아 정의 파일 연결
for f, imp in imports.items():
    for local, (tf, tn) in imp.items():
        if tn == "*":
            for m in re.finditer(r"(?<![\w$])" + re.escape(local) + r"\.([A-Za-z_$][\w$]*)", FILES[f]):
                fx = find_export(tf, m.group(1))
                if fx: deps[f].add(fx[0])

mnu = list(csv.DictReader((META / "mnu_m.csv").open(encoding="utf-8-sig")))
page_dirs = {}
for p in FE.glob("features/*/src/pages/*"):
    if p.is_dir(): page_dirs[p.name] = p.resolve()
ALIAS = {"ui-category": "ui-catrgory-setup", "customer-fcst-master": "customer-forecast-master"}
def page_of_menu(r):
    for cand in [(r.get("ROUTE_PATH") or "").split("/")[-1], r.get("MNU_URL") or ""]:
        cand = ALIAS.get(cand, cand)
        if cand and cand in page_dirs: return page_dirs[cand]
    return None
screen_files = {}
for r in mnu:
    if r["MNU_TP_CD"] != "SCREEN": continue
    pd = page_of_menu(r)
    if not pd: continue
    seeds = {f for f in FILES if pd in f.parents}
    seen, stack = set(seeds), list(seeds)
    while stack:
        x = stack.pop()
        for y in deps.get(x, ()):
            if y not in seen: seen.add(y); stack.append(y)
    screen_files[r["MNU_ID"]] = dict(page=rel(pd), seeds=len(seeds), files=sorted(rel(x) for x in seen))

# ───────────────────── 심볼 단위 도달성 (정밀 귀속) ─────────────────────
#   노드 = (파일, 최상위 선언명). 최상위 선언 = 줄 시작(들여쓰기 0)의 const/let/function/class/enum.
#   본문에서 참조하는 식별자 → (import 해석 / 같은 파일 최상위 선언) 으로 간선. 파일의 모듈 레벨 코드는 '<module>' 노드.
TOP_RE = re.compile(r"^(?:export\s+)?(?:default\s+)?(?:declare\s+)?(?:async\s+)?(?:const|let|var|function\*?|class|enum|abstract\s+class)\s+([A-Za-z_$][\w$]*)", re.M)
_top_cache = {}
def top_decls(f):
    if f in _top_cache: return _top_cache[f]
    t = FILES[f]; ms = list(TOP_RE.finditer(t))
    out = []
    for i, m in enumerate(ms):
        end = ms[i + 1].start() if i + 1 < len(ms) else len(t)
        out.append((m.group(1), m.start(), end))
    # export default <expr>  (이름 없는 default)
    _top_cache[f] = out
    return out
def node_at(f, off):
    for n, s, e in top_decls(f):
        if s <= off < e: return (f, n)
    return (f, "<module>")
IDENT = re.compile(r"(?<![\w$.'\"`])([A-Za-z_$][\w$]*)(?:\s*\.\s*([A-Za-z_$][\w$]*))?")
_edges = {}
def node_edges(node):
    if node in _edges: return _edges[node]
    f, n = node; t = FILES[f]
    if n == "<module>":
        spans = top_decls(f); txt = []; last = 0
        for _, s, e in spans: txt.append(t[last:s]); last = e
        txt.append(t[last:]); body = "\n".join(txt)
        # import 문 자체는 간선이 아니다
        body = IMP_RE.sub("", body); body = REEXP_RE.sub("", body)
    else:
        sp = next(((s, e) for nn, s, e in top_decls(f) if nn == n), None)
        body = t[sp[0]:sp[1]] if sp else ""
    tops = {nn for nn, _, _ in top_decls(f)}
    imp = imports.get(f, {})
    out = {(f, "<module>")}
    for m in IDENT.finditer(body):
        a, b = m.group(1), m.group(2)
        if a in imp:
            tf, tn = imp[a]
            if tn == "*":
                if b:
                    fx = find_export(tf, b)
                    if fx and fx[1] != "*": out.add(fx)
                continue
            if tn == "default":
                # default export → 그 파일의 default 선언(이름 무관) 전부
                for nn, _, _ in top_decls(tf):
                    if re.search(r"export\s+default\s+(?:async\s+)?(?:function|class|const)?\s*" + re.escape(nn), FILES[tf]): out.add((tf, nn))
                out.add((tf, "<module>")); continue
            fx = find_export(tf, tn)
            if fx and fx[1] not in ("*", "default"): out.add(fx)
            else: out.add((tf, "<module>"))
        elif a in tops and a != n:
            out.add((f, a))
    _edges[node] = out
    return out
def page_seed_nodes(pd):
    seeds = set()
    for f in FILES:
        if pd in f.parents and f.name in ("index.ts", "index.tsx") and f.parent == pd:
            seeds.add((f, "<module>"))
            for kind, mp, tgt in reexports.get(f, []):
                if kind == "named":
                    for b, a in mp.items():
                        fx = find_export(tgt, a)
                        if fx: seeds.add(fx)
                else:
                    for nn, _, _ in top_decls(tgt):
                        if re.search(r"^export\s", FILES[tgt][[s for x, s, e in top_decls(tgt) if x == nn][0]:][:20]): seeds.add((tgt, nn))
                    seeds.add((tgt, "<module>"))
            for nn, s, e in top_decls(f): seeds.add((f, nn))
    if not seeds:   # index 없음 → 폴더 전체
        for f in FILES:
            if pd in f.parents:
                seeds |= {(f, nn) for nn, _, _ in top_decls(f)} | {(f, "<module>")}
    return seeds
screen_nodes = {}
for r in mnu:
    if r["MNU_TP_CD"] != "SCREEN": continue
    pd = page_of_menu(r)
    if not pd: continue
    seen = set(page_seed_nodes(pd)); stack = list(seen)
    while stack:
        x = stack.pop()
        for y in node_edges(x):
            if y not in seen: seen.add(y); stack.append(y)
    screen_nodes[r["MNU_ID"]] = seen
# apps/web 공통(로그인·홈·레이아웃) 노드 — COMMON 귀속용: apps/web/src 의 모든 노드에서 도달
app_seed = {(f, nn) for f in FILES if "apps" in f.parts for nn, _, _ in top_decls(f)} | {(f, "<module>") for f in FILES if "apps" in f.parts}
seen = set(app_seed); stack = list(seen)
while stack:
    x = stack.pop()
    for y in node_edges(x):
        if y not in seen: seen.add(y); stack.append(y)
APP_NODES = seen
def users_of_loc(file_rel, line):
    f = (FE / file_rel).resolve(); t = FILES[f]
    off = sum(len(l) + 1 for l in t.split("\n")[:int(line) - 1])
    nd = node_at(f, off)
    return sorted(s for s, ns in screen_nodes.items() if nd in ns), nd in APP_NODES, nd[1]

# ───────────────────── 콤보 리터럴 (규칙 기반 판정) ─────────────────────
#  DIRECT   : 리터럴 위치 자체가 콤보 문맥 (comboId:/= · 콤보 훅 filters:[ ] · getCombo( · _comboKey: · cellCboDataTp:)
#  INDIRECT : 리터럴이 상수(객체 속성 X.K / 변수 X / 배열 X)의 값 → 그 이름의 참조 지점 중 콤보 문맥인 곳이 있어야 사용
#  LOOKUP   : lookupType 문맥 (콤보 아님 — PR_GET_LOOKUP_INFO_LIST, COMMON)
#  NONE     : 콤보 문맥 아님 (컬럼키·라벨·시트명 등 우연 일치 = 오탐)
#  화면 귀속 = 콤보 문맥 지점(DIRECT=리터럴 지점, INDIRECT=참조 지점)이 속한 노드의 도달 화면
cmbo_ids = {r["SQL_ID"] for r in csv.DictReader((META / "cmbo_sql.csv").open(encoding="utf-8-sig"))}
HOOK_RE = re.compile(r"\b(useTabComboQueries|useTabComboQuery|useTabComboQueryResults|useComboQueryResults|useTabLookupQueries|useTabLookupQuery|getCombo|getLookup)\b")
def combo_ctx(t, off):
    """off 위치(값 시작)가 콤보 문맥인가 → 'combo' | 'lookup' | None"""
    pre = t[max(0, off - 900):off]
    tail = pre[-400:]   # 여러 줄 삼항(comboId={ cond ? 'A' : 'B' }) 포괄
    if re.search(r"lookupType\s*[:=]\s*\{?\s*[^,;{}]*$", tail): return "lookup"
    if re.search(r"\b(comboId|cellCboDataTp|_comboKey|comboKey|insComboId)\s*[:=]\s*\{?\s*(?:[^,;{}]*?[?:|&]{1,2}\s*)?$", tail): return "combo"
    if re.search(r"\b(comboId|comboIds)\s*\??\s*\??\s*$", tail): return "combo"
    # 콤보 훅/메서드 인자 안 (괄호·대괄호 미닫힘)
    hooks = list(HOOK_RE.finditer(pre))
    if hooks:
        h = hooks[-1]; seg = pre[h.end():]
        depth = 0
        for ch in seg:
            if ch in "([{": depth += 1
            elif ch in ")]}": depth -= 1
        if depth > 0:
            if "Lookup" in h.group(1): return "lookup"
            # filters 배열 / 첫 인자(getCombo) 안
            return "combo"
    return None

def const_binding(t, off):
    """리터럴이 상수 값이면 그 참조 이름 목록: 'X.K' / 'X' / 'X'(배열 원소)"""
    pre = t[max(0, off - 3000):off]
    # 1) 객체 속성:  NAME = { ... K: 'v'
    km = re.search(r"([A-Za-z_$][\w$]*|\[[^\]]+\]|'[^']*')\s*:\s*$", pre)
    # 2) 단순 변수:  const X = 'v'
    vm = re.search(r"\b(?:const|let|var)\s+([A-Za-z_$][\w$]*)\s*(?::\s*[^=]+)?=\s*$", pre)
    if vm: return [vm.group(1)]
    # 가장 가까운 미닫힘 '{' 또는 '[' 을 연 const 이름
    depth = 0; i = len(pre) - 1; opener = None
    while i >= 0:
        ch = pre[i]
        if ch in ")]}": depth += 1
        elif ch in "([{":
            if depth == 0: opener = (ch, i); break
            depth -= 1
        i -= 1
    if not opener: return []
    head = pre[:opener[1]]
    cm = re.search(r"\b(?:const|let|var)\s+([A-Za-z_$][\w$]*)\s*(?::\s*[^=]+)?=\s*$", head)
    em = re.search(r"\benum\s+([A-Za-z_$][\w$]*)\s*$", head)
    pm = re.search(r"([A-Za-z_$][\w$]*)\s*:\s*$", head)   # 중첩 객체 속성
    if opener[0] == "{" and em:
        ek = re.search(r"([A-Za-z_$][\w$]*)\s*=\s*$", pre)
        return [f"{em.group(1)}.{ek.group(1)}"] if ek else []
    if opener[0] == "{" and km:
        key = km.group(1).strip("'[]")
        # ⚠ 객체명 단독(X) 참조는 모든 속성을 사용으로 오판 → 금지. X.K 정확 참조 + X[ 동적 인덱스(별도 표기)만
        if cm: return [f"{cm.group(1)}.{key}", f"{cm.group(1)}["]
        if pm:
            # 중첩: OUTER = { P: { K: 'v' } } → P.K (OUTER.P.K 는 ref_sites 가 접미 일치로 포괄)
            return [f"{pm.group(1)}.{key}"]
        return []
    if opener[0] == "[" and cm:
        return [cm.group(1)]
    return []
def simple_const_binding(t, off):
    """다단 추적: off 가 속한 문장의 바인딩 이름 — `const NAME = <식…off…>;` 또는 `function NAME(..){ return <off> }`
    (useMemo(() => [X.K]) · 반환값 · 배열 원소 등 값이 NAME 으로 흘러드는 경우). 객체 리터럴 키 값(k: X.K)은 제외."""
    pre = t[max(0, off - 4000):off]
    # 직전이 객체 키 'k:' 이면 값이 객체 속성으로 들어감 → 별도 흐름(추적 안 함)
    if re.search(r"[A-Za-z_$][\w$]*\s*:\s*$", pre[-80:]) and not re.search(r"\?\s*[^:]*:\s*$", pre[-80:]): return []
    depth = 0; i = len(pre) - 1
    while i >= 0:
        ch = pre[i]
        if ch in ")]}": depth += 1
        elif ch in "([{":
            depth -= 1
            if depth < 0 and ch == "{":
                before = pre[:i].rstrip()
                if before.endswith("=>") or before.endswith(")"):
                    # 함수 본문 진입 — return 식 / 표현식 본문에서만 계속
                    inner = pre[i + 1:].lstrip()
                    if not inner.startswith("return"): return []
                else:
                    return []      # 객체 리터럴 안 → 속성 값 (흐름 추적 안 함)
                depth = 0
        elif ch == ";" and depth <= 0: break
        i -= 1
    stmt = pre[i + 1:]
    m = re.match(r"\s*(?:export\s+)?(?:const|let|var)\s+([A-Za-z_$][\w$]*)\s*(?::\s*[^=]+)?=", stmt)
    if m: return [m.group(1)]
    m = re.match(r"\s*(?:export\s+)?(?:async\s+)?function\s+([A-Za-z_$][\w$]*)", stmt)
    if m: return [m.group(1)]
    return []

_sref_cache = {}
def scoped_ref_sites(def_file, name):
    """def_file 에 정의된 name(X / X.K / X[) 의 참조 지점 — 정의 파일 + 그 심볼을 import 한 파일만 (이름 우연 일치 배제)"""
    k = (def_file, name)
    if k in _sref_cache: return _sref_cache[k]
    dyn = name.endswith("[")
    base = name[:-1] if dyn else name
    head, _, rest = base.partition(".")
    targets = [(def_file, head)]
    for g, imp in imports.items():
        for local, (tf, tn) in imp.items():
            if tn in ("*", "default"): continue
            if (tf == def_file and tn == head) or (tf != def_file and find_export(tf, tn) == (def_file, head)):
                targets.append((g, local))
    out = []
    for g, local in targets:
        t = FILES[g]
        if dyn:
            pat = re.compile(r"(?<![\w$.])" + re.escape(local) + r"\s*\[")
        else:
            parts = [local] + ([x for x in rest.split(".")] if rest else [])
            pat = re.compile(r"(?<![\w$.])" + r"\s*\??\.\s*".join(re.escape(x) for x in parts) + r"(?![\w$])")
        for m in pat.finditer(t):
            pre = t[max(0, m.start() - 40):m.start()]
            if re.search(r"\b(const|let|var|enum|type|interface|function)\s+$", pre): continue
            out.append((g, m.start()))
    _sref_cache[k] = out
    return out

_ref_cache = {}
def ref_sites(name):
    """name (X / X.K / X[) 참조 지점 (file, off) — 선언 자신 제외"""
    if name in _ref_cache: return _ref_cache[name]
    out = []
    if name.endswith("["):
        pat = re.compile(r"(?<![\w$.])" + re.escape(name[:-1]) + r"\s*\[")
    else:
        parts = name.split(".")
        pat = re.compile(r"(?<![\w$.])" + r"\s*\??\.\s*".join(re.escape(x) for x in parts) + r"(?![\w$])")
    for f, t in FILES.items():
        if name.split(".")[0].rstrip("[") not in t: continue
        for m in pat.finditer(t):
            pre = t[max(0, m.start() - 40):m.start()]
            if re.search(r"\b(const|let|var|enum|type|interface)\s+$", pre): continue
            out.append((f, m.start()))
    _ref_cache[name] = out
    return out
_ctx_cache = {}
_combo_ctx_raw = combo_ctx
def combo_ctx(t, off, _f=None):
    k = (id(t), off)
    if k not in _ctx_cache: _ctx_cache[k] = _combo_ctx_raw(t, off)
    return _ctx_cache[k]

COMBOS = []
for f, t in FILES.items():
    for m in re.finditer(r"(['\"`])([A-Za-z0-9_\-]+)\1", t):
        v = m.group(2)
        if v not in cmbo_ids: continue
        ctx = re.sub(r"\s+", " ", t[max(0, m.start() - 80):m.end() + 20])
        dm = re.search(r"([A-Za-z_$][\w$.]*)\s*\?\?\s*$", t[max(0, m.start() - 60):m.start()])
        kind = combo_ctx(t, m.start())
        base = dict(combo=v, lit_file=rel(f), lit_line=lineno(t, m.start()), ctx=ctx, default_of=dm.group(1) if dm else "")
        if kind == "combo":
            COMBOS.append(dict(base, kind="DIRECT", via="", file=rel(f), line=lineno(t, m.start())))
            continue
        if kind == "lookup":
            COMBOS.append(dict(base, kind="LOOKUP", via="", file=rel(f), line=lineno(t, m.start())))
            continue
        names = const_binding(t, m.start())
        hit = False
        for nm in names:
            for g, off in scoped_ref_sites(f, nm):
                tt = FILES[g]
                # 참조식 끝 위치 기준으로 문맥 판정 (X.K 전체 앞)
                k2 = combo_ctx(tt, off)
                if k2 == "combo":
                    COMBOS.append(dict(base, kind="INDIRECT_DYNIDX" if nm.endswith("[") else "INDIRECT", via=nm, file=rel(g), line=lineno(tt, off))); hit = True
                elif k2 is None and not nm.endswith("["):
                    # 2단: 참조가 다시 const 에 담기는 경우만 (const ids = [X.K, ...] / const c = X.K)
                    frontier = [(nm, g, off)]
                    for hop in range(3):   # 최대 3홉 (값 → 변수/함수 → 변수/함수 …), 각 홉 스코프 한정
                        nxt = []
                        for chain, f1, o1 in frontier:
                            for nm2 in simple_const_binding(FILES[f1], o1):
                                if nm2 in chain.split(">"): continue
                                for g2, off2 in scoped_ref_sites(f1, nm2):
                                    k3 = combo_ctx(FILES[g2], off2)
                                    if k3 == "combo":
                                        COMBOS.append(dict(base, kind=f"INDIRECT{hop + 2}", via=f"{chain}>{nm2}", file=rel(g2), line=lineno(FILES[g2], off2))); hit = True
                                    elif k3 is None:
                                        nxt.append((f"{chain}>{nm2}", g2, off2))
                        frontier = nxt[:200]
                        if not frontier: break
            if hit: break
        if not hit:
            COMBOS.append(dict(base, kind="NONE", via="|".join(names), file=rel(f), line=lineno(t, m.start())))

# ───────────────────── 출력 ─────────────────────
def w(name, rows, cols):
    with (OUT / name).open("w", encoding="utf-8-sig", newline="") as fh:
        wr = csv.DictWriter(fh, fieldnames=cols, extrasaction="ignore"); wr.writeheader()
        for r in rows: wr.writerow(r)
for r in RESOLVED + UNRESOLVED:
    r["file"] = rel(r["file"]) if isinstance(r["file"], pathlib.Path) else r["file"]
    for k in ("menu", "sheet", "btn"):
        if is_p(r[k]): r[k] = "{" + r[k] + "}"
for r in RESOLVED + UNRESOLVED + COMBOS:
    us, app, nd = users_of_loc(r["file"], r["line"])
    r["screens"] = " ".join(us); r["app"] = "Y" if app else "N"; r["node"] = nd
w("fe_calls.csv", RESOLVED, ["menu", "sheet", "btn", "pattern", "file", "line", "fn", "node", "screens", "app", "origin", "trail", "extra"])
w("fe_unresolved.csv", UNRESOLVED, ["reason", "menu", "sheet", "btn", "pattern", "file", "line", "fn", "node", "screens", "app", "origin", "trail", "extra"])
w("fe_combos.csv", COMBOS, ["combo", "kind", "via", "default_of", "file", "line", "node", "screens", "app", "lit_file", "lit_line", "ctx"])
(OUT / "fe_screen_files.json").write_text(json.dumps(screen_files, ensure_ascii=False, indent=1), encoding="utf-8")
print("combos", len(COMBOS), "screens", len(screen_files))
