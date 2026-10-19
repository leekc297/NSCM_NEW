"""UIPKG_CONSOLIDATION — 클라우드 이관 폴더 빌더 (STEP 5)

원천: 사내 ZIOUI1 적용 후 원문(FRESH-GATE: 추출본 == 사내 적용 산출물 02_apply) + 03_meta · 04_drop 산출물
      + 사내 적용 전 원문(01_backup) — PRECHECK 판정 기준
판정(PRECHECK): 객체 원문 줄 해시 SUM(ORA_HASH(RTRIM(TEXT))) (LINE>1)
   = 사내 적용 전  → PRE    : 적용 대상
   = 사내 적용 후  → POST   : 이미 적용 — SKIP
   부재             → ABSENT : 신규면 적용 / 기존 객체면 선행 이관 필요
   그 외            → DIFF   : 클라우드 본문이 사내와 다름 → 전체교체 금지·결과 공유
누락 게이트: 02_apply/APPLIED_OPERATIONS.md 의 모든 SQL 파일이 폴더에 들어갔는지 확인 후 종료
usage: python build_cloud.py
"""
import datetime, json, pathlib, re, shutil, sys

HERE = pathlib.Path(__file__).resolve().parent
CORP = HERE.parents[1] / "_apply_corporate" / "UIPKG_CONSOLIDATION_20260915"
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

CALLER_PKG = {  # 외부 호출부 → 소속 PKG 폴더
    "DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL": "PKG_DMF0020", "DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP": "PKG_DMF0020",
    "PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA": "PKG_DMF0006",
    "SCM_ADM_MAIL_SEND_BATCH": "PKG_DMF0003", "SCM_ADM_MAIL_SEND_DATA": "PKG_DMF0003",
    "DMF0043_GET_MAIN_SPREAD_TITLE": "PKG_DMF0043",
}
ORDER = ["PKG_DMF0000", "PKG_DMF0003", "PKG_DMF0006", "PKG_DMF0007", "PKG_DMF0008", "PKG_DMF0014", "PKG_DMF0020", "PKG_DMF0040",
         "PKG_DMF0043", "PKG_DMF0048", "PKG_DMF0072", "PKG_DMF0082", "PKG_SYS0012", "PKG_SYS0014", "PKG_SYS0017"]
NEW_GRANT = {"PKG_DMF0008", "PKG_SYS0012"}   # 사내에서 이번에 신규 부여


def q(s):
    return "'" + str(s).replace("'", "''") + "'"


def main():
    L = json.loads((CORP / "LEDGER.json").read_text(encoding="utf-8"))
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    LIST = con.gettype("SYS.ODCIVARCHAR2LIST")
    built = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

    def fetch_lines(name, typ):
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
        return [r[0] for r in cur.fetchall()]

    def ldt(name, typ):
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
        return cur.fetchone()

    def hsum(lines):
        if lines is None:
            return None
        cur.execute("SELECT SUM(ORA_HASH(COLUMN_VALUE)) FROM TABLE(:1)", [LIST.newobject([l.rstrip("\n\r \t") or None for l in lines])])
        return cur.fetchone()[0]

    def backup_lines(name, typ):
        f = CORP / "01_backup" / "objects" / f"{name}.{typ.replace(' ', '_')}.sql"
        if not f.exists():
            return None
        t = f.read_text(encoding="utf-8").split("SET DEFINE OFF\n", 1)[1]
        t = re.sub(r"\n/\n?$", "", t.rstrip() + "\n")
        rec = t.split("\n")
        return [x + "\n" for x in rec[1:]]   # LINE>1

    def ddl_file(name, typ, note):
        """FRESH-GATE: 사내 현재 원문 추출(추출 중 LAST_DDL 변동 없음) — 사내 적용 산출물과 동일성은 호출부에서 확인"""
        st0 = ldt(name, typ)
        lines = fetch_lines(name, typ)
        assert st0 == ldt(name, typ) and st0[1] == "VALID", f"FRESH-GATE 실패/INVALID: {name} {typ} {st0}"
        text = "".join(lines)
        head, rest = text.split("\n", 1)
        head = re.sub(r'(?i)^\s*' + typ.replace(" ", r"\s+") + r'\s+(?:"?SCM_MGR"?\s*\.\s*)?"?\w+"?', f'CREATE OR REPLACE {typ} SCM_MGR."{name}"', head, count=1)
        body = f"-- SOURCE-FRESH: SCM_MGR.{name} {typ} LAST_DDL={st0[0]} FETCHED={built} DB=ZIOUI1\n-- {note}\nSET DEFINE OFF\n" + head + "\n" + rest.rstrip() + "\n/\n"
        return body, lines

    # FRESH-GATE 선검사 — 폴더를 지우기 전에 전 객체(사내 현재 == 적용 산출물)부터 확인 (2026-09-15 21:03 부분 삭제 사고 후)
    gate_fail = []
    for pkg in ORDER:
        for typ, fn in (("PACKAGE", "10_SPEC.sql"), ("PACKAGE BODY", "11_BODY.sql")):
            f = CORP / "02_apply" / pkg / fn
            if f.exists():
                body, _ = ddl_file(pkg, typ, "")
                if body.split("SET DEFINE OFF\n", 1)[1].rstrip() != f.read_text(encoding="utf-8").split("SET DEFINE OFF\n", 1)[1].rstrip():
                    gate_fail.append(f"{pkg} {typ}")
    for cn in CALLER_PKG:
        f = CORP / "02_apply" / "_CALLERS" / f"12_CALLER_{cn}.sql"
        body, _ = ddl_file(cn, "PROCEDURE", "")
        if body.split("SET DEFINE OFF\n", 1)[1].rstrip() != f.read_text(encoding="utf-8").split("SET DEFINE OFF\n", 1)[1].rstrip():
            gate_fail.append(cn)
    assert not gate_fail, f"FRESH-GATE 실패(폴더 무변경): 사내 현재 != 적용 산출물 → {gate_fail} — 변경 경위 확인 후 02_apply 갱신·원장 기록"

    if HERE.joinpath("PKG_DMF0000").exists():
        for x in HERE.iterdir():
            if x.is_dir(): shutil.rmtree(x)
    common = HERE / "00_COMMON"; common.mkdir(exist_ok=True)
    for f in ("00_RECOMPILE_INVALID_STANDALONE.sql", "90_RECOMPILE_DEPENDENTS.sql"):
        shutil.copy2(CORP / "02_apply" / "_COMMON" / f, common / f)

    by_pkg = {}
    for t in L["targets"]:
        by_pkg.setdefault(t["pkg"], []).append(t)
    summary = []
    for pkg in ORDER:
        items = by_pkg[pkg]
        dst = HERE / pkg; dst.mkdir(exist_ok=True)
        pre_rows, ver_rows, files = [], [], []
        objs = []   # (name, typ, file, pre_lines)
        ap = CORP / "02_apply" / pkg
        for typ, fn in (("PACKAGE", "10_SPEC.sql"), ("PACKAGE BODY", "11_BODY.sql")):
            if (ap / fn).exists():
                body, lines = ddl_file(pkg, typ, f"{pkg} {typ} — standalone SP 취합본 (사내 적용 2026-09-15)")
                applied = (ap / fn).read_text(encoding="utf-8")
                assert body.split("SET DEFINE OFF\n", 1)[1].rstrip() == applied.split("SET DEFINE OFF\n", 1)[1].rstrip(), f"FRESH-GATE 실패: {pkg} {typ} 사내 현재 != 적용 산출물"
                (dst / fn).write_text(body, encoding="utf-8", newline="\n"); files.append(fn)
                objs.append((pkg, typ, fn, backup_lines(pkg, typ), lines[1:]))
        for cn, cp in CALLER_PKG.items():
            if cp == pkg:
                fn = f"12_CALLER_{cn}.sql"
                body, lines = ddl_file(cn, "PROCEDURE", f"외부 호출부 — 대상 SP 호출을 PKG 멤버로 전환 (사내 적용 2026-09-15)")
                applied = (CORP / "02_apply" / "_CALLERS" / fn).read_text(encoding="utf-8")
                assert body.split("SET DEFINE OFF\n", 1)[1].rstrip() == applied.split("SET DEFINE OFF\n", 1)[1].rstrip(), f"FRESH-GATE 실패: {cn}"
                (dst / fn).write_text(body, encoding="utf-8", newline="\n"); files.append(fn)
                objs.append((cn, "PROCEDURE", fn, backup_lines(cn, "PROCEDURE"), lines[1:]))
        # 권한·시노님 (전 PKG 멱등 · 신규 2 는 필수)
        (dst / "20_GRANT_SCM_MGR.sql").write_text(
            f"-- {pkg} — 앱계정 실행 권한 (SCM_MGR · 멱등){' · ⭐ 사내 이번 신규 부여' if pkg in NEW_GRANT else ' · 사내 기존 보유(클라우드 부재 대비)'}\nGRANT EXECUTE ON SCM_MGR.{pkg} TO SCMP_APP;\n", encoding="utf-8")
        (dst / "21_SYNONYM_SCMP_APP.sql").write_text(
            f"-- {pkg} — 앱계정 시노님 (SCMP_APP 로 실행 · 멱등){' · ⭐ 사내 이번 신규 생성' if pkg in NEW_GRANT else ''}\nCREATE OR REPLACE SYNONYM {pkg} FOR SCM_MGR.{pkg};\n", encoding="utf-8")
        files += ["20_GRANT_SCM_MGR.sql", "21_SYNONYM_SCMP_APP.sql"]
        for f in sorted((CORP / "03_meta" / pkg).glob("*.sql")) if (CORP / "03_meta" / pkg).exists() else []:
            shutil.copy2(f, dst / f.name); files.append(f.name)
        for f in sorted((CORP / "04_drop" / pkg).glob("*.sql")):
            shutil.copy2(f, dst / f.name); files.append(f.name)

        # ── 00_PRECHECK ──
        pre = [f"-- {pkg} — 클라우드 현재 상태 점검 (SCM_MGR · 조회 전용 · 변경 없음)",
               "-- VERDICT: PRE=사내 적용 전과 동일 → 해당 파일 적용 / POST=이미 적용 → SKIP / ABSENT=없음 / DIFF=클라우드 본문이 다름 → 전체교체 금지·결과 공유",
               "SET PAGESIZE 200 LINESIZE 300", "COLUMN OBJ FORMAT A48", "COLUMN VERDICT FORMAT A60", "", "-- [A] 교체 대상 객체"]
        for name, typ, fn, pl, al in objs:
            hp, ha = hsum(pl), hsum(al)
            pre.append(f"""SELECT {q(name)} OBJ, {q(typ)} TYP, {q(fn)} FILE_NM,
       (SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = {q(name)} AND OBJECT_TYPE = {q(typ)}) CLOUD_STATUS,
       CASE WHEN NOT EXISTS (SELECT 1 FROM USER_OBJECTS WHERE OBJECT_NAME = {q(name)} AND OBJECT_TYPE = {q(typ)}) THEN {q('ABSENT → 신규 생성 대상' if pl is None else 'ABSENT → ⚠ 기존 객체 부재: 선행 이관 필요')}
            WHEN H.S = {ha} THEN 'POST → 이미 적용됨(SKIP)'
            WHEN H.S = {hp if hp is not None else -1} THEN 'PRE → 적용 대상'
            ELSE 'DIFF → ⚠ 클라우드 본문이 사내와 다름: 전체교체 금지·결과 공유' END VERDICT
  FROM (SELECT SUM(ORA_HASH(RTRIM(TEXT, CHR(10)||CHR(13)||CHR(32)||CHR(9)))) S FROM USER_SOURCE WHERE NAME = {q(name)} AND TYPE = {q(typ)} AND LINE > 1) H;""")
        pre.append("\n-- [B] DROP 대상 standalone — 멤버 본문 원천. DIFF 면 클라우드에만 있는 수정 → 멤버에 반영 필요(결과 공유)")
        for t in items:
            sl = fetch_lines(t["sp"], "PROCEDURE")
            ha = hsum(sl[1:]); hp = hsum(backup_lines(t["sp"], "PROCEDURE"))
            pre.append(f"""SELECT {q(t['sp'])} OBJ, (SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = {q(t['sp'])} AND OBJECT_TYPE = 'PROCEDURE') CLOUD_STATUS,
       CASE WHEN H.S IS NULL THEN 'ABSENT(이미 삭제됐거나 미이관)' WHEN H.S IN ({hp}, {ha}) THEN 'SAME(사내 원천과 동일)' ELSE 'DIFF → ⚠ 결과 공유' END VERDICT
  FROM (SELECT SUM(ORA_HASH(RTRIM(TEXT, CHR(10)||CHR(13)||CHR(32)||CHR(9)))) S FROM USER_SOURCE WHERE NAME = {q(t['sp'])} AND TYPE = 'PROCEDURE' AND LINE > 1) H;""")
        # 의존 객체
        cur.execute("""SELECT DISTINCT REFERENCED_NAME FROM ALL_DEPENDENCIES WHERE OWNER='SCM_MGR' AND NAME=:p AND REFERENCED_OWNER='SCM_MGR'
                        AND REFERENCED_NAME <> :p AND REFERENCED_TYPE IN ('TABLE','VIEW','PACKAGE','PROCEDURE','FUNCTION','SYNONYM','SEQUENCE','TYPE') ORDER BY 1""", p=pkg)
        deps = [r[0] for r in cur.fetchall()]
        if deps:
            pre.append(f"\n-- [C] {pkg} BODY 의존 객체 — 행이 나오면 MISSING (컴파일 실패 조건)")
            for i in range(0, len(deps), 200):
                pre.append(f"SELECT COLUMN_VALUE MISSING FROM TABLE(SYS.ODCIVARCHAR2LIST({', '.join(q(x) for x in deps[i:i + 200])})) WHERE COLUMN_VALUE NOT IN (SELECT OBJECT_NAME FROM USER_OBJECTS);")
        apis = sorted({a["api_id"] for t in items for a in t["meta"]["api_m"]})
        if apis:
            pre.append("\n-- [D] META 현재값 — API_URL 이 standalone 이면 전환 전, PKG.멤버 면 전환 완료")
            pre.append(f"SELECT API_ID, API_URL FROM SCM_ADM_API_M WHERE API_ID IN ({', '.join(q(a) for a in apis)}) ORDER BY API_ID;")
            pre.append(f"SELECT UPPER(PROC_NM) PROC_NM, COUNT(*) CNT FROM SCM_ADM_PROC_M WHERE UPPER(PROC_NM) IN ({', '.join(q(t['sp'].upper()) for t in items)}) OR PROC_NM IN ({', '.join(q(t['pkg'] + '.' + t['member']) for t in items)}) GROUP BY UPPER(PROC_NM) ORDER BY 1;")
        pre.append(f"\n-- [E] 앱계정\nSELECT GRANTEE, TABLE_NAME, PRIVILEGE FROM USER_TAB_PRIVS WHERE GRANTEE = 'SCMP_APP' AND TABLE_NAME = {q(pkg)};\nSELECT OWNER, SYNONYM_NAME FROM ALL_SYNONYMS WHERE OWNER = 'SCMP_APP' AND SYNONYM_NAME = {q(pkg)};")
        (dst / "00_PRECHECK.sql").write_text("\n".join(pre) + "\n", encoding="utf-8")
        files.append("00_PRECHECK.sql")

        # ── 90_VERIFY ──
        ver = [f"-- {pkg} — 적용 후 확인 (SCM_MGR · 조회 전용)", "SET PAGESIZE 200 LINESIZE 300", ""]
        for name, typ, fn, pl, al in objs:
            ver.append(f"SELECT {q(name)} OBJ, {q(typ)} TYP, (SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = {q(name)} AND OBJECT_TYPE = {q(typ)}) STATUS,"
                       f" CASE WHEN (SELECT SUM(ORA_HASH(RTRIM(TEXT, CHR(10)||CHR(13)||CHR(32)||CHR(9)))) FROM USER_SOURCE WHERE NAME = {q(name)} AND TYPE = {q(typ)} AND LINE > 1) = {hsum(al)} THEN 'SAME(사내 적용본)' ELSE 'CHECK' END SOURCE_CHK FROM DUAL;")
        ver.append(f"SELECT NAME, TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME IN ({', '.join(sorted({q(o[0]) for o in objs}) or [q(pkg)])}) ORDER BY NAME, TYPE, SEQUENCE;")
        ver.append(f"SELECT OBJECT_NAME PKG, PROCEDURE_NAME MEMBER FROM USER_PROCEDURES WHERE OBJECT_NAME = {q(pkg)} AND PROCEDURE_NAME IN ({', '.join(q(t['member']) for t in items)}) ORDER BY 2;  -- 기대 {len(items)}행")
        ver.append("SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS = 'INVALID' AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION') ORDER BY 1;")
        ver.append(f"SELECT GRANTEE, TABLE_NAME, PRIVILEGE FROM USER_TAB_PRIVS WHERE GRANTEE = 'SCMP_APP' AND TABLE_NAME = {q(pkg)};")
        (dst / "90_VERIFY.sql").write_text("\n".join(ver) + "\n", encoding="utf-8")
        files.append("90_VERIFY.sql")
        summary.append(dict(pkg=pkg, targets=[t["sp"] for t in items], files=sorted(files), objs=[(o[0], o[1], o[2]) for o in objs], apis=apis))

    # ── 누락 게이트: APPLIED_OPERATIONS.md 의 SQL 파일 전부 폴더 존재 ──
    ops = (CORP / "02_apply" / "APPLIED_OPERATIONS.md").read_text(encoding="utf-8")
    need = set()
    for m in re.finditer(r"`([^`]+\.sql)`", ops):
        path = m.group(1)
        if path.startswith("_COMMON/"):
            need.add(("00_COMMON", path.split("/", 1)[1]))
        elif path.startswith("_CALLERS/12_CALLER_<"):
            for cn, cp in CALLER_PKG.items():
                if cn != "DMF0043_GET_MAIN_SPREAD_TITLE": need.add((cp, f"12_CALLER_{cn}.sql"))
        elif path.startswith("_CALLERS/"):
            fn = path.split("/", 1)[1]; need.add((CALLER_PKG[fn.replace("12_CALLER_", "").replace(".sql", "")], fn))
        elif path.startswith("03_meta/<PKG>"):
            for s in summary:
                if s["apis"]: need.add((s["pkg"], "30_META_SWITCH.sql"))
        elif path.startswith("PKG_") or path.startswith("03_meta/PKG_"):
            parts = path.replace("03_meta/", "").split("/")
            for fn in re.split(r"\s*·\s*", parts[1]):
                need.add((parts[0], fn.strip()))
    for m in re.finditer(r"\| (PKG_\w+) ?/ ?`?(\d\d_\w+\.sql)", ops):
        need.add((m.group(1), m.group(2)))
    for m in re.finditer(r"`(PKG_\w+)/10_SPEC\.sql · 11_BODY\.sql`", ops):
        need.add((m.group(1), "10_SPEC.sql")); need.add((m.group(1), "11_BODY.sql"))
    missing = sorted(f"{a}/{b}" for a, b in need if not (HERE / a / b).exists())
    assert not missing, f"누락 게이트 실패: {missing}"
    (HERE / "_BUILD.json").write_text(json.dumps(dict(built=built, gate_checked=sorted(f"{a}/{b}" for a, b in need), packages=summary), ensure_ascii=False, indent=1), encoding="utf-8")
    print("built", built, "| packages", len(summary), "| 누락 게이트 대상", len(need), "→ 누락 0")
    for s in summary:
        print(f"  {s['pkg']:12} targets={len(s['targets']):2} files={len(s['files'])} objs={[o[2] for o in s['objs']]}")


if __name__ == "__main__":
    main()
