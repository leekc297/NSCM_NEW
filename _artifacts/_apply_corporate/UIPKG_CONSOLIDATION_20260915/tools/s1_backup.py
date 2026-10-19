"""STEP 1 — BACKUP (사내 ZIOUI1 조회 전용, DB 무변경)

대상 = LEDGER.json (12 PKG · standalone 34 · 외부 호출부 객체)
산출 = 01_backup/
  objects/<NAME>.<TYPE>.sql   CREATE OR REPLACE 원문 (머리 SOURCE-FRESH 스탬프)
  scmp_app/GRANT_SYNONYM_RESTORE.sql  (SCM_MGR 실행분 GRANT + SCMP_APP 실행분 CREATE SYNONYM)
  meta/*.csv + meta/META_RESTORE.sql  (API_M · PROC_M · BTN_MPG — 멱등 MERGE)
  MANIFEST.md                 객체·LAST_DDL·줄수·sha1
FRESH-GATE: 파일 기록 직전 ALL_SOURCE·LAST_DDL 재조회 — 추출 중 변경되면 중단
"""
import csv, datetime, hashlib, json, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent
OUT = ROOT / "01_backup"
sys.path.insert(0, str(HERE.parents[2] / "_diagnostics"))
import ora, oracledb  # noqa: E402


def main():
    L = json.loads((ROOT / "LEDGER.json").read_text(encoding="utf-8"))
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    q = lambda s, **k: (cur.execute(s, k), cur.fetchall())[1]
    targets = {t["sp"] for t in L["targets"]}
    pkgs = sorted(L["pkgs"])
    # 외부 호출부 = 대상 SP 를 참조하는 객체 중 (대상 SP·대상 PKG 이외)
    ext = set()
    for t in L["targets"]:
        for c in t["callers"]["source_text"]:
            n, ty, _ = c.split("|")
            if n not in targets and n not in pkgs:
                ext.add((n, ty))
    objs = [(pk, ty) for pk in pkgs for ty in ("PACKAGE", "PACKAGE BODY")] + [(s, "PROCEDURE") for s in sorted(targets)] + sorted(ext)

    (OUT / "objects").mkdir(parents=True, exist_ok=True)
    man = ["# STEP 1 BACKUP MANIFEST", "", f"조회 DB: {L['db']} · 원장 {L['fetched']}", "",
           "| 구분 | 객체 | 타입 | 상태 | LAST_DDL | 줄 | sha1 | 파일 |", "|---|---|---|---|---|---:|---|---|"]
    absent = []
    for name, typ in objs:
        cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
        row = cur.fetchone()
        kind = "PKG" if name in pkgs else ("standalone" if name in targets else "외부호출부")
        if not row:
            absent.append((name, typ)); man.append(f"| {kind} | {name} | {typ} | (부재) | - | - | - | - |"); continue
        st, ldt = row
        text = "".join(r[0] for r in q("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ))
        # FRESH-GATE
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
        assert cur.fetchone()[0] == ldt, f"FRESH-GATE 실패: {name} {typ} 추출 중 변경"
        head, rest = text.split("\n", 1)
        head = re.sub(r'(?i)^\s*' + typ.replace(" ", r"\s+") + r'\s+"?\w+"?', f'CREATE OR REPLACE {typ} SCM_MGR."{name}"', head, count=1)
        assert head.startswith("CREATE OR REPLACE"), (name, typ, head[:80])
        fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        fn = f"{name}.{typ.replace(' ', '_')}.sql"
        (OUT / "objects" / fn).write_text(
            f"-- SOURCE-FRESH: SCM_MGR.{name} {typ} LAST_DDL={ldt} FETCHED={fetched} DB=ZIOUI1\n-- STEP 1 BACKUP (원복용 원문 · STATUS={st})\nSET DEFINE OFF\n"
            + head + "\n" + rest.rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        sha = hashlib.sha1(text.encode("utf-8")).hexdigest()[:12]
        man.append(f"| {kind} | {name} | {typ} | {st} | {ldt} | {text.count(chr(10))} | {sha} | objects/{fn} |")

    # SCMP_APP 권한·시노님
    names = [n for n, _ in objs]
    (OUT / "scmp_app").mkdir(exist_ok=True)
    grants = q("SELECT TABLE_NAME, PRIVILEGE FROM ALL_TAB_PRIVS WHERE GRANTEE='SCMP_APP' AND TABLE_SCHEMA='SCM_MGR'")
    syns = q("SELECT SYNONYM_NAME, TABLE_NAME FROM ALL_SYNONYMS WHERE OWNER='SCMP_APP' AND TABLE_OWNER='SCM_MGR'")
    g = sorted(f"GRANT {pv} ON SCM_MGR.{tn} TO SCMP_APP;" for tn, pv in grants if tn in names)
    s = sorted(f"CREATE OR REPLACE SYNONYM SCMP_APP.{sn} FOR SCM_MGR.{tn};" for sn, tn in syns if tn in names)
    (OUT / "scmp_app" / "GRANT_SYNONYM_RESTORE.sql").write_text(
        "-- STEP 1 BACKUP — SCMP_APP 실행 경로 복원\n-- [A] SCM_MGR 로 실행\n" + "\n".join(g) + "\n\n-- [B] SCMP_APP 로 실행\n" + "\n".join(s) + "\n", encoding="utf-8")

    # META
    (OUT / "meta").mkdir(exist_ok=True)
    api_ids = sorted({a["api_id"] for t in L["targets"] for a in t["meta"]["api_m"]})
    proc_nms = sorted(targets)
    def dump(fname, sql, binds):
        cur.execute(sql, binds); cols = [c[0] for c in cur.description]; rows = cur.fetchall()
        with (OUT / "meta" / fname).open("w", encoding="utf-8-sig", newline="") as f:
            w = csv.writer(f); w.writerow(cols); [w.writerow(["" if v is None else v for v in r]) for r in rows]
        return cols, rows
    inl = lambda xs: ",".join(f"'{x}'" for x in xs) or "'-'"
    api_c, api_r = dump("SCM_ADM_API_M.csv", f"SELECT * FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID IN ({inl(api_ids)}) ORDER BY API_ID", {})
    pm_c, pm_r = dump("SCM_ADM_PROC_M.csv", f"SELECT * FROM SCM_MGR.SCM_ADM_PROC_M WHERE UPPER(PROC_NM) IN ({inl(proc_nms)}) ORDER BY PROC_NM, SORT_ORD", {})
    bt_c, bt_r = dump("SCM_ADM_MNU_BTN_MPG_M.csv", f"SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE API_ID IN ({inl(api_ids)}) ORDER BY MNU_ID, SHT_NM, MNU_BTN_CD", {})

    def lit(v):
        if v is None: return "NULL"
        if isinstance(v, datetime.datetime): return f"TO_DATE('{v:%Y-%m-%d %H:%M:%S}','YYYY-MM-DD HH24:MI:SS')"
        if isinstance(v, (int, float)): return str(v)
        return "'" + str(v).replace("'", "''") + "'"
    def merge(table, cols, rows, keys):
        out = []
        for r in rows:
            src = ", ".join(f"{lit(v)} {c}" for c, v in zip(cols, r))
            on = " AND ".join(f"T.{k} = S.{k}" for k in keys)
            upd = ", ".join(f"T.{c} = S.{c}" for c in cols if c not in keys)
            out.append(f"MERGE INTO SCM_MGR.{table} T USING (SELECT {src} FROM DUAL) S ON ({on})\n"
                       f"WHEN MATCHED THEN UPDATE SET {upd}\nWHEN NOT MATCHED THEN INSERT ({', '.join(cols)}) VALUES ({', '.join('S.' + c for c in cols)});")
        return out
    body = ["-- STEP 1 BACKUP — META 복원 (멱등 MERGE · 백업 시점 값으로 되돌림)", "SET DEFINE OFF"]
    body += merge("SCM_ADM_API_M", api_c, api_r, ["API_ID"])
    body += merge("SCM_ADM_PROC_M", pm_c, pm_r, ["PROC_NM", "COL_NM", "COL_TP_CD"])
    body += merge("SCM_ADM_MNU_BTN_MPG_M", bt_c, bt_r, ["MNU_ID", "SHT_NM", "MNU_BTN_CD"])
    body.append("COMMIT;")
    (OUT / "meta" / "META_RESTORE.sql").write_text("\n".join(body) + "\n", encoding="utf-8")

    man += ["", f"## SCMP_APP — GRANT {len(g)} · SYNONYM {len(s)} (scmp_app/GRANT_SYNONYM_RESTORE.sql)",
            f"## META — API_M {len(api_r)} · PROC_M {len(pm_r)} · BTN_MPG {len(bt_r)} (meta/*.csv · META_RESTORE.sql)",
            f"## 부재 객체 {len(absent)}: {absent}", f"## 외부 호출부 {len(ext)}: {sorted(ext)}"]
    (OUT / "MANIFEST.md").write_text("\n".join(man) + "\n", encoding="utf-8")
    print("\n".join(man[-4:]))
    print("object files", len(list((OUT / "objects").glob("*.sql"))), "of", len(objs) - len(absent))


if __name__ == "__main__":
    main()
