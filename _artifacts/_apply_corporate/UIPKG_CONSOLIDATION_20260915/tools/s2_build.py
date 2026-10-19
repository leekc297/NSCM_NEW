"""STEP 2-A — SP → PKG 취합 SQL 생성 (DB 무변경 · 생성만)

입력: LEDGER.json · 사내 DB 현재 원문(착수 시점 재조회 = 기준본, 01_backup 과 동일해야 함 — FRESH-GATE)
규칙(사용자 확정 2026-09-15):
  - standalone 본문 무수정 → 멤버명 `P_…`(이미 P_ 면 그대로), SPEC 공개 선언 추가
  - 동일명 기존 멤버: 코드(주석·공백 제외) 동일 → 무변경(재배선만) / 다르면 META 실사용(standalone) 본문·시그니처로 블록 교체
      (PKG_DMF0008 AJS 7건 포함 — 사용자 "전부 standalone 본문으로 교체")
  - 래퍼 DMF0043_GET_MAIN_SPREAD_TITLE: 기존 멤버 → P_DMF0043_GET_MAIN_SPREAD_TITLE_CORE, 공개 멤버 = 래퍼 로직(내부 호출만 _CORE)
  - DMF0000_GET_UPDATE_HISTORY → 기존 PKG_DMF0000.P_DMF0000_GET_UPDATE_HISTORY (코드 동일 — PKG_DMF0000 무변경)
  - 호출부 전환: 대상 SP 호출(주석·문자열 제외 코드 토큰, `SCM_MGR.` 접두 포함) → 같은 PKG 면 멤버명, 아니면 `PKG.멤버`
산출: 02_apply/<PKG>/10_SPEC.sql · 11_BODY.sql · 12_CALLER_<OBJ>.sql · _DIFF.md · BUILD.json
"""
import datetime, difflib, json, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent
OUT = ROOT / "02_apply"
sys.path.insert(0, str(HERE.parents[2] / "_diagnostics"))
import ora, oracledb  # noqa: E402

WRAPPER = "DMF0043_GET_MAIN_SPREAD_TITLE"
CORE = "P_DMF0043_GET_MAIN_SPREAD_TITLE_CORE"
ID = r"A-Za-z0-9_$#"


# ── 코드/주석/문자열 구간 분리 ─────────────────────────────────────────────
def segments(t):
    """[(start, end, is_code)] — '--' 주석 · '/* */' · '…'(''이스케이프) · q'x…x' 를 비코드로 분리"""
    out, i, n, cs = [], 0, len(t), 0
    while i < n:
        c = t[i]
        if c == "-" and t.startswith("--", i):
            j = t.find("\n", i); j = n if j < 0 else j
        elif c == "/" and t.startswith("/*", i):
            j = t.find("*/", i + 2); j = n if j < 0 else j + 2
        elif c in "qQ" and i + 2 < n and t[i + 1] == "'" and (i == 0 or not re.match(f"[{ID}]", t[i - 1])):
            close = {"[": "]", "{": "}", "(": ")", "<": ">"}.get(t[i + 2], t[i + 2])
            j = t.find(close + "'", i + 3); j = n if j < 0 else j + 2
        elif c == "'":
            j = i + 1
            while j < n:
                if t[j] == "'" and j + 1 < n and t[j + 1] == "'": j += 2; continue
                if t[j] == "'": j += 1; break
                j += 1
        else:
            i += 1; continue
        if cs < i: out.append((cs, i, True))
        out.append((i, j, False)); i = cs = j
    if cs < n: out.append((cs, n, True))
    return out


def sub_code(t, pattern, repl, flags=re.I):
    cnt = 0; parts = []
    for s, e, code in segments(t):
        seg = t[s:e]
        if code:
            seg, k = re.subn(pattern, repl, seg, flags=flags); cnt += k
        parts.append(seg)
    return "".join(parts), cnt


def find_code(t, pattern, start=0, flags=re.I):
    for s, e, code in segments(t):
        if not code or e <= start: continue
        m = re.compile(pattern, flags).search(t, max(s, start), e)
        if m: return m
    return None


def code_norm(t):
    """주석 제거 · 문자열 유지 · 공백 정규화 · 대문자 — 코드 동일성 비교용"""
    return re.sub(r"\s+", " ", "".join((t[s:e] if code or t[s] in "'qQ" else " ") for s, e, code in segments(t))).upper().strip()


# ── 변환 ───────────────────────────────────────────────────────────────────
def to_member(sp_text, sp, member):
    t = sp_text.rstrip()
    t, k1 = re.subn(r'(?i)^\s*PROCEDURE\s+(?:"?SCM_MGR"?\s*\.\s*)?"?' + re.escape(sp) + r'"?', "PROCEDURE " + member, t, count=1)
    t, k2 = re.subn(r'(?i)\bEND\s*(?:"?' + re.escape(sp) + r'"?)?\s*;\s*$', "END " + member + ";", t, count=1)
    assert k1 == 1 and k2 == 1, (sp, k1, k2)
    return t + "\n"


def spec_decl(member_text, member):
    m = find_code(member_text, r"\bPROCEDURE\s+" + re.escape(member) + r"\b")
    pos = m.end()
    nxt = find_code(member_text, r"\S", pos)
    if nxt and nxt.group(0) == "(":
        depth = 0
        for s, e, code in segments(member_text):
            if e <= nxt.start() or not code: continue
            for k in range(max(s, nxt.start()), e):
                ch = member_text[k]
                if ch == "(": depth += 1
                elif ch == ")":
                    depth -= 1
                    if depth == 0:
                        return member_text[m.start():k + 1] + ";"
        raise AssertionError(("unbalanced", member))
    return f"PROCEDURE {member};"


def replace_member_block(body, member, new_text):
    m = find_code(body, r"(?m)^[ \t]*PROCEDURE\s+" + re.escape(member) + r"\b")
    e = find_code(body, r"\bEND\s+" + re.escape(member) + r"\s*;[^\n]*\n?", m.start())
    assert m and e, member
    return body[:m.start()] + new_text + body[e.end():]


def replace_spec_decl(spec, member, new_decl):
    m = find_code(spec, r"\bPROCEDURE\s+" + re.escape(member) + r"\b")
    semi = find_code(spec, r";", m.start())
    assert m and semi, member
    return spec[:m.start()] + new_decl + spec[semi.end():]


def append_before_end(text, pkg, block):
    m = re.search(r'(?is)\bEND\s+"?' + re.escape(pkg) + r'"?\s*;\s*$', text)
    assert m, (pkg, text[-80:])
    return text[:m.start()] + block.rstrip() + "\n\n" + text[m.start():]


def ddl(text, typ, name):
    head, rest = text.split("\n", 1) if "\n" in text else (text, "")
    head2, k = re.subn(r'(?i)^\s*' + typ.replace(" ", r"\s+") + r'\s+(?:"?SCM_MGR"?\s*\.\s*)?"?' + re.escape(name) + r'"?', f'CREATE OR REPLACE {typ} SCM_MGR."{name}"', head, count=1)
    assert k == 1, (name, typ, head[:80])
    return head2 + "\n" + rest


def main():
    L = json.loads((ROOT / "LEDGER.json").read_text(encoding="utf-8"))
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()

    def fetch(name, typ):
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
        return "".join(r[0] for r in cur.fetchall())

    def ldt(name, typ):
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
        r = cur.fetchone(); return r[0] if r else None

    def backup_text(name, typ):
        f = ROOT / "01_backup" / "objects" / f"{name}.{typ.replace(' ', '_')}.sql"
        if not f.exists(): return None
        body = f.read_text(encoding="utf-8").split("SET DEFINE OFF\n", 1)[1].rstrip()
        assert body.endswith("\n/"), f
        return body[:-2]

    def fresh(name, typ):
        """FRESH-GATE: 현재 DB 원문 == STEP 1 백업 (CREATE OR REPLACE 머리 정규화 후 비교)"""
        cur_t = fetch(name, typ)
        if not cur_t:
            assert backup_text(name, typ) is None, f"FRESH-GATE 실패: {name} {typ} 백업 이후 삭제됨"
            return ""
        b = backup_text(name, typ)
        assert b is not None and ddl(cur_t, typ, name).rstrip() == b.rstrip(), f"FRESH-GATE 실패: {name} {typ} 백업 이후 DB 원문 변경 — 중단·재백업"
        return cur_t

    targets = L["targets"]
    mapping = {t["sp"].upper(): (t["pkg"], t["member"]) for t in targets}
    names_re = "|".join(sorted((re.escape(k) for k in mapping), key=len, reverse=True))
    call_pat = rf'(?<![{ID}."])(?:"?SCM_MGR"?\s*\.\s*)?"?({names_re})"?(?![{ID}"])'

    def rewire(text, own_pkg, skip=None):
        counts = {}
        def repl(m):
            nm = m.group(1).upper()
            if nm == skip: return m.group(0)
            pk, mem = mapping[nm]
            counts[nm] = counts.get(nm, 0) + 1
            return mem if pk == own_pkg else f"{pk}.{mem}"
        new, _ = sub_code(text, call_pat, repl)
        return new, counts

    OUT.mkdir(exist_ok=True)
    build = dict(built=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), pkgs={}, callers={}, string_refs=[])
    by_pkg = {}
    for t in targets:
        by_pkg.setdefault(t["pkg"], []).append(t)
    for v in by_pkg.values():   # 래퍼 먼저 — 기존 멤버 _CORE 개명이 뒤에 추가될 호출(P_DMF0043_GET_MAIN_SPREAD_TITLE)을 건드리지 않게
        v.sort(key=lambda t: (t["sp"] != WRAPPER, t["sp"]))
    fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

    for pkg in sorted(L["pkgs"]):
        spec0, body0 = fresh(pkg, "PACKAGE"), fresh(pkg, "PACKAGE BODY")
        new_pkg = not spec0
        spec = spec0 or f"PACKAGE {pkg} AS\n    /* 2026-09-15 UIPKG_CONSOLIDATION — standalone SP 취합 신규 PKG */\n\nEND {pkg};"
        body = body0 or f"PACKAGE BODY {pkg} AS\n\nEND {pkg};"
        rec = dict(new_pkg=new_pkg, members=[], rewired={})
        for t in by_pkg.get(pkg, []):
            sp, mem = t["sp"], t["member"]
            sp_text = fresh(sp, "PROCEDURE")
            mtext = to_member(sp_text, sp, mem)
            mtext, _ = rewire(mtext, pkg, skip=sp.upper())          # 멤버 본문 안의 다른 대상 SP 호출
            if sp == WRAPPER:
                # standalone 래퍼는 적용 후 `PKG_DMF0043.…_CORE` 를 호출하도록 보정됨(12_CALLER) — 양쪽 모두 허용
                mtext, k = sub_code(mtext, r"\bPKG_DMF0043\s*\.\s*P_DMF0043_GET_MAIN_SPREAD_TITLE(?:_CORE)?\b", CORE)
                assert k == 1, ("wrapper core call", k)
            action = "add"
            if t["same_name_member"]["exists"]:
                if sp == WRAPPER:
                    body, k1 = sub_code(body, r"\bP_DMF0043_GET_MAIN_SPREAD_TITLE\b", CORE)
                    spec, k2 = sub_code(spec, r"\bP_DMF0043_GET_MAIN_SPREAD_TITLE\b", CORE)
                    assert k1 == 2 and k2 == 1, ("core rename", k1, k2)
                    action = "wrapper(add + existing→_CORE)"
                else:
                    m = find_code(body, r"(?m)^[ \t]*PROCEDURE\s+" + re.escape(mem) + r"\b")
                    e = find_code(body, r"\bEND\s+" + re.escape(mem) + r"\s*;", m.start())
                    old = body[m.start():e.end()]
                    if code_norm(old) == code_norm(mtext.rstrip()):
                        action = "identical(no change)"
                    else:
                        body = replace_member_block(body, mem, mtext)
                        spec = replace_spec_decl(spec, mem, spec_decl(mtext, mem))
                        action = "replace(standalone body)"
            if action in ("add", "wrapper(add + existing→_CORE)"):
                body = append_before_end(body, pkg, "    -- [2026-09-15 UIPKG] standalone " + sp + " 취합\n" + mtext)
                spec = append_before_end(spec, pkg, "    -- [2026-09-15 UIPKG] standalone " + sp + "\n    " + spec_decl(mtext, mem))
            rec["members"].append(dict(sp=sp, member=mem, action=action))
        # 기존 PKG 본문 안의 대상 SP 호출(외부 PKG 포함) 재배선 — 방금 넣은 멤버 본문은 이미 처리됨(멤버명 = P_ 라 재매칭 안 됨)
        body, cnt = rewire(body, pkg)
        rec["rewired"] = cnt
        changed_spec = spec != (spec0 or None)
        changed_body = body != (body0 or None)
        d = OUT / pkg; d.mkdir(parents=True, exist_ok=True)
        stamp = lambda typ: f"-- SOURCE-FRESH: SCM_MGR.{pkg} {typ} LAST_DDL={ldt(pkg, typ) or 'NEW-OBJECT'} FETCHED={fetched} DB=ZIOUI1\n"
        if changed_spec or new_pkg:
            (d / "10_SPEC.sql").write_text(stamp("PACKAGE") + "SET DEFINE OFF\n" + ddl(spec, "PACKAGE", pkg).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        if changed_body or new_pkg:
            (d / "11_BODY.sql").write_text(stamp("PACKAGE BODY") + "SET DEFINE OFF\n" + ddl(body, "PACKAGE BODY", pkg).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        diff = list(difflib.unified_diff((spec0 or "").splitlines(), spec.splitlines(), "SPEC(before)", "SPEC(after)", lineterm="", n=1)) + \
               list(difflib.unified_diff((body0 or "").splitlines(), body.splitlines(), "BODY(before)", "BODY(after)", lineterm="", n=1))
        (d / "_DIFF.md").write_text(f"# {pkg} 변경 diff\n\n```diff\n" + "\n".join(diff) + "\n```\n", encoding="utf-8")
        rec.update(spec_changed=changed_spec, body_changed=changed_body, diff_lines=len(diff))
        build["pkgs"][pkg] = rec

    # 외부 호출부 (대상 SP·대상 PKG 이외)
    targets_set = {t["sp"] for t in targets}
    ext = sorted({c.split("|")[0] for t in targets for c in t["callers"]["source_text"]} - targets_set - set(L["pkgs"]))
    for name in ext:
        typ = "PROCEDURE"
        t0 = fresh(name, typ)
        t1, cnt = rewire(t0, None)
        build["callers"][name] = cnt
        if t1 != t0:
            dst = OUT / "_CALLERS"; dst.mkdir(exist_ok=True)
            (dst / f"12_CALLER_{name}.sql").write_text(
                f"-- SOURCE-FRESH: SCM_MGR.{name} {typ} LAST_DDL={ldt(name, typ)} FETCHED={fetched} DB=ZIOUI1\nSET DEFINE OFF\n" + ddl(t1, typ, name).rstrip() + "\n/\n", encoding="utf-8", newline="\n")

    # 래퍼 standalone 보정 — 기존 멤버가 _CORE 로 개명되므로 standalone 이 호출하던 PKG 멤버를 _CORE 로 (META 전환 전 화면 유지)
    #   2026-09-15 18:58 사내 적용 시 누락 → DMF0043_GET_MAIN_SPREAD_TITLE·GET_CONTRIBUTE_MAIN_DATA INVALID 발생, 18:59 보정
    w0 = fresh(WRAPPER, "PROCEDURE")
    w1, k = sub_code(w0, r"\bPKG_DMF0043\s*\.\s*P_DMF0043_GET_MAIN_SPREAD_TITLE\b", "PKG_DMF0043." + CORE)
    if k:
        dst = OUT / "_CALLERS"; dst.mkdir(exist_ok=True)
        (dst / f"12_CALLER_{WRAPPER}.sql").write_text(
            f"-- SOURCE-FRESH: SCM_MGR.{WRAPPER} PROCEDURE LAST_DDL={ldt(WRAPPER, 'PROCEDURE')} FETCHED={fetched} DB=ZIOUI1\n"
            "-- [2026-09-15 UIPKG] 래퍼 standalone 이 호출하던 기존 PKG 멤버가 _CORE 로 개명됨 → 호출만 _CORE 로 (META 전환 전 화면 유지)\nSET DEFINE OFF\n"
            + ddl(w1, "PROCEDURE", WRAPPER).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        build["callers"][WRAPPER] = {"PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE→_CORE": k}

    # 문자열 리터럴 안 참조(치환 제외 — 보고)
    for pkg in L["pkgs"]:
        for typ in ("PACKAGE BODY",):
            txt = fetch(pkg, typ)
            for s, e, code in segments(txt):
                if code: continue
                for m in re.finditer(rf'(?<![{ID}])({names_re})(?![{ID}])', txt[s:e], re.I):
                    build["string_refs"].append(f"{pkg}|{typ}|{m.group(1)}|{txt[s:e][:80]!r}")
    (ROOT / "02_apply" / "BUILD.json").write_text(json.dumps(build, ensure_ascii=False, indent=1), encoding="utf-8")
    for pkg, r in build["pkgs"].items():
        print(f"{pkg:13} new={r['new_pkg']} spec_chg={r['spec_changed']} body_chg={r['body_changed']} diff={r['diff_lines']} rewired={r['rewired']}")
        for m in r["members"]: print(f"     {m['action']:28} {m['member']}")
    print("callers", build["callers"])
    print("string/comment refs (not rewired):", len(build["string_refs"]))
    for s in build["string_refs"][:40]: print("   ", s)


if __name__ == "__main__":
    main()
