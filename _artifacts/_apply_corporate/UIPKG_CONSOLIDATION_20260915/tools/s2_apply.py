"""STEP 2-B — SP → PKG 취합 사내 DB 적용 · 검증 (ZIOUI1)

usage:
  python s2_apply.py invalid            # INVALID standalone 3건 재컴파일 (DMF0043 1 · DMF0072 2)
  python s2_apply.py pkg PKG_SYS0017    # PKG 1개 적용 (SPEC → BODY) + 검증 · 실패 시 백업 원문 즉시 복원
  python s2_apply.py pkgs               # 02_apply 의 SPEC/BODY 보유 PKG 전체 순차 (파일럿 제외 없음 · 이미 적용분 SKIP)
  python s2_apply.py callers            # 외부 호출부 12_CALLER_*.sql 적용
  python s2_apply.py grants             # SCMP_APP EXECUTE·시노님 (부재 PKG 만)
  python s2_apply.py verify             # 전 대상 검증 리포트 (02_apply/VERIFY.md)

게이트:
  FRESH-GATE — 적용 직전 DB 원문 == 01_backup 원문(착수 기준본) 이면 적용 / == 적용본이면 SKIP / 둘 다 아니면 ABORT
  적용 후   — SPEC·BODY VALID · ALL_ERRORS 0 · DB 원문 == 적용본 · 멤버 ALL_ARGUMENTS == standalone · 멤버 코드 == standalone 변환본
"""
import datetime, json, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent
AP = ROOT / "02_apply"
sys.path.insert(0, str(HERE)); sys.path.insert(0, str(HERE.parents[2] / "_diagnostics"))
import oracledb  # noqa: E402
import ora  # noqa: E402
import s2_build as B  # noqa: E402

LOG = AP / "APPLY_LOG.md"
INVALID_FIRST = ["DMF0043_GET_CONTRIBUTION_SALES_LIST", "DMF0072_GET_END_CUSTOMER_LIST", "DMF0072_GET_SALES_SITE_LIST"]


def log(line):
    print(line)
    with LOG.open("a", encoding="utf-8") as f:
        f.write(line + "\n")


def connect(user=None):
    u, p, d = ora.conn_info()
    return oracledb.connect(user=user or u, password=p, dsn=d)


def fetch(cur, name, typ):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
    return "".join(r[0] for r in cur.fetchall())


def status(cur, name, typ):
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
    return cur.fetchone()


def errors(cur, name, typ):
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=name, t=typ)
    return cur.fetchall()


def sql_body(f):
    """SOURCE-FRESH·SET 머리 제거 → CREATE OR REPLACE … (종결 '/' 제거)"""
    t = f.read_text(encoding="utf-8")
    t = t[t.index("CREATE OR REPLACE"):]
    return re.sub(r"\n/\s*$", "", t.rstrip())


def as_ddl(cur, name, typ):
    t = fetch(cur, name, typ)
    return B.ddl(t, typ, name).rstrip() if t else None


def invalid_set(cur):
    cur.execute("SELECT OBJECT_NAME||'|'||OBJECT_TYPE FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID'")
    return {r[0] for r in cur.fetchall()}


def apply_obj(cur, name, typ, file):
    """FRESH-GATE 3판정 후 적용. 반환: 'SKIP'|'APPLIED'"""
    backup = ROOT / "01_backup" / "objects" / f"{name}.{typ.replace(' ', '_')}.sql"
    target = sql_body(file)
    now = as_ddl(cur, name, typ)
    if now is not None and now == target.rstrip():
        return "SKIP"
    base = sql_body(backup) if backup.exists() else None
    if base is None:
        assert now is None, f"FRESH-GATE ABORT: {name} {typ} 백업 부재인데 DB 에 존재"
    else:
        assert now is not None and now == base.rstrip(), f"FRESH-GATE ABORT: {name} {typ} 백업 이후 DB 원문 변경 — 전체 교체 금지"
    cur.execute(target)
    return "APPLIED"


def restore(cur, name, typ):
    backup = ROOT / "01_backup" / "objects" / f"{name}.{typ.replace(' ', '_')}.sql"
    if backup.exists():
        cur.execute(sql_body(backup)); return "restored"
    if typ == "PACKAGE":
        cur.execute(f'DROP PACKAGE SCM_MGR."{name}"'); return "dropped(new)"
    return "n/a"


def verify_pkg(cur, pkg, L):
    """멤버별 시그니처·코드 동일성"""
    out = []
    body = fetch(cur, pkg, "PACKAGE BODY")
    for t in [t for t in L["targets"] if t["pkg"] == pkg]:
        sp, mem = t["sp"], t["member"]
        cur.execute("SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME=:p AND OBJECT_NAME=:m AND DATA_LEVEL=0 ORDER BY POSITION", p=pkg, m=mem)
        ma = cur.fetchall()
        cur.execute("SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME IS NULL AND OBJECT_NAME=:m AND DATA_LEVEL=0 ORDER BY POSITION", m=sp)
        sa = cur.fetchall()
        m = B.find_code(body, r"(?m)^[ \t]*PROCEDURE\s+" + re.escape(mem) + r"\b")
        e = B.find_code(body, r"\bEND\s+" + re.escape(mem) + r"\s*;", m.start()) if m else None
        code_same = None
        if m and e:
            exp = B.to_member(fetch(cur, sp, "PROCEDURE"), sp, mem)
            out_map = {x["sp"].upper(): (x["pkg"], x["member"]) for x in L["targets"]}
            names_re = "|".join(sorted((re.escape(k) for k in out_map), key=len, reverse=True))
            pat = rf'(?<![{B.ID}."])(?:"?SCM_MGR"?\s*\.\s*)?"?({names_re})"?(?![{B.ID}"])'
            exp, _ = B.sub_code(exp, pat, lambda g: (lambda pk_mem: pk_mem[1] if pk_mem[0] == pkg else f"{pk_mem[0]}.{pk_mem[1]}")(out_map[g.group(1).upper()]) if g.group(1).upper() != sp.upper() else g.group(0))
            if sp == B.WRAPPER:
                exp, _ = B.sub_code(exp, r"\bPKG_DMF0043\s*\.\s*P_DMF0043_GET_MAIN_SPREAD_TITLE(?:_CORE)?\b", B.CORE)
            code_same = B.code_norm(body[m.start():e.end()]) == B.code_norm(exp.rstrip())
        out.append(dict(sp=sp, member=mem, member_found=bool(m and e), sig_same=ma == sa and len(sa) == len(t["arguments"]), code_same=code_same))
    return out


def main():
    mode = sys.argv[1]
    L = json.loads((ROOT / "LEDGER.json").read_text(encoding="utf-8"))
    con = connect(); cur = con.cursor()
    ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    if mode == "invalid":
        log(f"\n## {ts} INVALID 선처리")
        for n in INVALID_FIRST:
            before = status(cur, n, "PROCEDURE")
            try:
                cur.execute(f'ALTER PROCEDURE SCM_MGR."{n}" COMPILE')
            except Exception as ex:
                log(f"- {n}: compile 예외 {str(ex).splitlines()[0]}")
            after = status(cur, n, "PROCEDURE")
            log(f"- {n}: {before[0]} → {after[0]} · errors={errors(cur, n, 'PROCEDURE') or 0}")

    elif mode in ("pkg", "pkgs"):
        names = [sys.argv[2]] if mode == "pkg" else sorted(p.name for p in AP.iterdir() if p.is_dir() and p.name.startswith("PKG_") and ((p / "10_SPEC.sql").exists() or (p / "11_BODY.sql").exists()))
        for pkg in names:
            d = AP / pkg
            log(f"\n## {datetime.datetime.now():%Y-%m-%d %H:%M:%S} {pkg}")
            inv0 = invalid_set(cur)
            done = []
            try:
                for typ, fn in (("PACKAGE", "10_SPEC.sql"), ("PACKAGE BODY", "11_BODY.sql")):
                    if not (d / fn).exists():
                        continue
                    r = apply_obj(cur, pkg, typ, d / fn); done.append(typ)
                    st, er = status(cur, pkg, typ), errors(cur, pkg, typ)
                    log(f"- {typ}: {r} · {st} · errors={len(er)}")
                    if er or (st and st[0] != "VALID"):
                        for x in er[:15]: log(f"    L{x[0]}:{x[1]} {x[2].strip()[:200]}")
                        raise RuntimeError(f"{pkg} {typ} 컴파일 실패")
                    assert as_ddl(cur, pkg, typ) == sql_body(d / fn).rstrip(), f"{pkg} {typ} DB 원문 != 적용본"
            except Exception as ex:
                log(f"- ❌ {ex} → 백업 복원")
                for typ in ("PACKAGE", "PACKAGE BODY"):
                    try:
                        log(f"    {typ}: {restore(cur, pkg, typ)} · {status(cur, pkg, typ)}")
                    except Exception as ex2:
                        log(f"    {typ}: 복원 예외 {str(ex2).splitlines()[0]}")
                sys.exit(2)
            # 의존 객체 재컴파일(새로 INVALID 된 것)
            new_inv = sorted(invalid_set(cur) - inv0)
            for x in new_inv:
                n, typ = x.split("|")
                try:
                    cur.execute(f'ALTER {"PACKAGE" if typ.startswith("PACKAGE") else typ} SCM_MGR."{n}" COMPILE{" BODY" if typ == "PACKAGE BODY" else ""}')
                except Exception:
                    pass
            still = sorted(invalid_set(cur) - inv0)
            log(f"- 의존 신규 INVALID: {new_inv or 0} → 재컴파일 후 {still or 0}")
            for v in verify_pkg(cur, pkg, L):
                log(f"- 멤버 {v['member']}: found={v['member_found']} sig_same={v['sig_same']} code_same={v['code_same']}")

    elif mode == "callers":
        log(f"\n## {ts} 외부 호출부")
        for f in sorted((AP / "_CALLERS").glob("12_CALLER_*.sql")):
            n = f.stem.replace("12_CALLER_", "")
            r = apply_obj(cur, n, "PROCEDURE", f)
            st, er = status(cur, n, "PROCEDURE"), errors(cur, n, "PROCEDURE")
            log(f"- {n}: {r} · {st} · errors={len(er)} · DB==적용본 {as_ddl(cur, n, 'PROCEDURE') == sql_body(f).rstrip()}")
            if er:
                log(f"    ❌ {er[:5]} → 백업 복원 {restore(cur, n, 'PROCEDURE')}"); sys.exit(2)

    elif mode == "grants":
        log(f"\n## {ts} SCMP_APP 권한·시노님")
        app = connect("SCMP_APP"); acur = app.cursor()
        for pkg in sorted(L["pkgs"]):
            cur.execute("SELECT COUNT(*) FROM ALL_TAB_PRIVS WHERE GRANTEE='SCMP_APP' AND TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME=:p AND PRIVILEGE='EXECUTE'", p=pkg)
            g = cur.fetchone()[0]
            cur.execute("SELECT COUNT(*) FROM ALL_SYNONYMS WHERE OWNER='SCMP_APP' AND SYNONYM_NAME=:p", p=pkg)
            s = cur.fetchone()[0]
            if not g:
                cur.execute(f"GRANT EXECUTE ON SCM_MGR.{pkg} TO SCMP_APP")
            if not s:
                acur.execute(f"CREATE OR REPLACE SYNONYM {pkg} FOR SCM_MGR.{pkg}")
            if not g or not s:
                # 취합 누락 방지 (사용자 2026-09-15 "권한, 시노님도 SQL 취합") — 실행분을 PKG 폴더 SQL 로 기록
                (AP / pkg).mkdir(parents=True, exist_ok=True)
                (AP / pkg / "20_GRANT_SCM_MGR.sql").write_text(f"-- {pkg} — 앱계정 실행 권한 (SCM_MGR · 멱등)\n-- 사내 적용 {ts}\nGRANT EXECUTE ON SCM_MGR.{pkg} TO SCMP_APP;\n", encoding="utf-8")
                (AP / pkg / "21_SYNONYM_SCMP_APP.sql").write_text(f"-- {pkg} — 앱계정 시노님 (SCMP_APP · 멱등)\n-- 사내 적용 {ts}\nCREATE OR REPLACE SYNONYM {pkg} FOR SCM_MGR.{pkg};\n", encoding="utf-8")
                cur.execute("SELECT COUNT(*) FROM ALL_TAB_PRIVS WHERE GRANTEE='SCMP_APP' AND TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME=:p AND PRIVILEGE='EXECUTE'", p=pkg); g2 = cur.fetchone()[0]
                cur.execute("SELECT COUNT(*) FROM ALL_SYNONYMS WHERE OWNER='SCMP_APP' AND SYNONYM_NAME=:p", p=pkg); s2 = cur.fetchone()[0]
                log(f"- {pkg}: EXECUTE {g}→{g2} · SYNONYM {s}→{s2}")

    elif mode == "verify":
        rows = ["# STEP 2 VERIFY", "", f"검증 시각 {ts}", "", "| PKG | SPEC | BODY | 멤버 | 원 SP | found | 시그니처 | 코드 |", "|---|---|---|---|---|---|---|---|"]
        bad = 0
        for pkg in sorted(L["pkgs"]):
            s1, s2 = status(cur, pkg, "PACKAGE"), status(cur, pkg, "PACKAGE BODY")
            for v in verify_pkg(cur, pkg, L):
                ok = v["member_found"] and v["sig_same"] and v["code_same"] and s1 and s1[0] == "VALID" and s2 and s2[0] == "VALID"
                bad += not ok
                rows.append(f"| {pkg} | {s1 and s1[0]} | {s2 and s2[0]} | {v['member']} | {v['sp']} | {v['member_found']} | {v['sig_same']} | {v['code_same']} |")
        inv = sorted(invalid_set(cur))
        rows += ["", f"## 불일치 {bad}건", f"## SCM_MGR INVALID 전체 {len(inv)}: {inv}"]
        (AP / "VERIFY.md").write_text("\n".join(rows) + "\n", encoding="utf-8")
        print("\n".join(rows[-3:]))


if __name__ == "__main__":
    main()
