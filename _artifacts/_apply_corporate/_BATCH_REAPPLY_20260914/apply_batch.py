"""2026-09-14 사내 적용분 일괄 재반영 실행기

  python apply_batch.py            # 드라이런(기본) — 접속 대상·게이트 판정·실행 예정 문장만 출력, DB 변경 없음
  python apply_batch.py --apply    # 실제 적용 (01→07 순서, 오류 시 즉시 중단)
  python apply_batch.py --apply --steps=01,02,03   # 지정 단계만

게이트 (PKG BODY 전체 교체 파일 01·02·06):
  현재 본문 == 적용본        → SKIP (이미 반영)
  현재 본문 == 적용 전 백업  → 적용
  둘 다 아님                 → ABORT (그 사이 다른 변경 — 전체 교체 금지, 차이분 병합 필요)
데이터 파일(04·05·07)은 멱등(MERGE / 키 고정 UPDATE)이라 그대로 실행. 03 은 SCMP_APP 로 실행(ORA-00955 무시 블록).
"""
import re, sys, pathlib
import oracledb

D = pathlib.Path(__file__).resolve().parent
DSN = "175.211.29.206:2521/ZIOUI1"
PW = "zionex1!"
APPLY = "--apply" in sys.argv

STEPS = [  # (파일, 계정, 종류, 대상 PKG, 적용 전 백업)
    ("01_DMF0040_PKG_DMF0040_BODY.sql",            "SCM_MGR",  "BODY", "PKG_DMF0040",       "99_ROLLBACK/R01_PKG_DMF0040_BODY_pre_20260914.sql"),
    ("02_DMF0053_PKG_DMF0053_BODY.sql",            "SCM_MGR",  "BODY", "PKG_DMF0053",       "99_ROLLBACK/R02_PKG_DMF0053_BODY_pre_20260914.sql"),
    ("03_DMF0053_SYNONYM_SCMP_APP.sql",            "SCMP_APP", "PLSQL", None, None),
    ("04_SYS0005_LOOKUP_UI_PKG_NM_MERGE.sql",      "SCM_MGR",  "SQL",  None, None),
    ("05_DMF0074_EXCEL_COLUMNS_HEADER_UPDATE.sql", "SCM_MGR",  "SQL",  None, None),
    ("06_DMF0074_PKG_NSCM_UI_EXCEL_BODY.sql",      "SCM_MGR",  "BODY", "PKG_NSCM_UI_EXCEL", "99_ROLLBACK/R06_PKG_NSCM_UI_EXCEL_BODY_pre_20260914.sql"),
    ("07_SYS0006_LOOKUP_API_TP_CD_MERGE.sql",      "SCM_MGR",  "SQL",  None, None),
]

def conn(user):
    return oracledb.connect(user=user, password=PW, dsn=DSN)

def read(p):
    return (D / p).read_text(encoding="utf-8", errors="ignore").replace("\r\n", "\n")

def body_text(sql):
    m = re.search(r"CREATE\s+OR\s+REPLACE\s+(?:EDITIONABLE\s+)?PACKAGE\s+BODY", sql, re.I)
    t = sql[m.end():] if m else sql
    return re.sub(r"\n\s*/\s*$", "", t.rstrip())

def norm(s):
    s = re.sub(r'^\s*"?[A-Z0-9_]+"?\."?', "", s.strip(), flags=re.I).replace('"', "")
    return re.sub(r"\s+", " ", s).strip().upper()

def live_body(cur, name):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:1 AND TYPE='PACKAGE BODY' ORDER BY LINE", [name])
    return re.sub(r"^\s*PACKAGE\s+BODY\s+", "", "".join(r[0] or "" for r in cur), flags=re.I)

def ddl_statement(sql):
    """PKG BODY 파일 → CREATE OR REPLACE ... END; (종결자 '/' 제외) 한 문장"""
    m = re.search(r"CREATE\s+OR\s+REPLACE", sql, re.I)
    return re.sub(r"\n\s*/\s*$", "", sql[m.start():].rstrip())

def sql_statements(sql):
    """';' 단위 분해. 주석 줄만 제거하고 문장은 버리지 않는다(헤더 주석이 붙은 첫 문장 누락 방지). SELECT 는 확인용이라 결과 출력."""
    out = []
    for chunk in re.split(r";[ \t]*(?:--[^\n]*)?\n|;\s*$", sql):
        body = "\n".join(l for l in chunk.split("\n") if not l.strip().startswith("--")).strip()
        if body: out.append(body)
    return out

def main():
    c0 = conn("SCM_MGR"); cur = c0.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVICE_NAME'), SYS_CONTEXT('USERENV','CON_NAME'), SYS_CONTEXT('USERENV','SERVER_HOST'), "
                "(SELECT TO_CHAR(CREATION_TIME,'YYYY-MM-DD HH24:MI') FROM V$PDBS WHERE ROWNUM=1) FROM DUAL")
    print("접속 대상:", cur.fetchone(), "| 모드:", "APPLY" if APPLY else "DRY-RUN")

    only = next((a.split("=", 1)[1].split(",") for a in sys.argv if a.startswith("--steps=")), None)   # 예: --steps=01,02,03
    plan = []
    for f, user, kind, pkg, backup in STEPS:
        if only and f[:2] not in only: continue
        sql = read(f)
        if kind == "BODY":
            live = norm(live_body(cur, pkg)); new = norm(body_text(sql)); old = norm(body_text(read(backup)))
            if live == new:   verdict = "SKIP(이미 반영)"
            elif live == old: verdict = "APPLY(현재=적용 전 백업)"
            else:
                print(f"ABORT {f}: 현재 {pkg} 본문이 적용본·적용 전 백업 어느 쪽과도 다름 → 전체 교체 금지, 차이분 병합 필요"); sys.exit(2)
            plan.append((f, user, kind, verdict, [ddl_statement(sql)]))
        elif kind == "PLSQL":
            stmt = re.sub(r"\n\s*/\s*$", "", "\n".join(l for l in sql.split("\n") if not l.strip().startswith("--")).strip())
            plan.append((f, user, kind, "APPLY(멱등)", [stmt]))
        else:
            plan.append((f, user, kind, "APPLY(멱등)", sql_statements(sql)))

    for f, user, kind, verdict, stmts in plan:
        kinds = [s.split(None, 1)[0].upper() for s in stmts]
        print(f"- {f:<44} {user:<9} {verdict:<24} 문장 {len(stmts)}: {', '.join(kinds)}")
    if not APPLY:
        print("드라이런 종료 — 적용하려면 --apply"); return

    for f, user, kind, verdict, stmts in plan:
        if verdict.startswith("SKIP"): continue
        cn = conn(user); cu = cn.cursor()
        for s in stmts:
            head = s.split(None, 1)[0].upper()
            if head == "COMMIT": cn.commit(); continue
            cu.execute(s)
            if head == "SELECT":
                for r in cu.fetchall(): print("    ", r)
        cn.commit()
        if kind == "BODY":
            pkg = next(x[3] for x in STEPS if x[0] == f)
            cur.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:1 AND OBJECT_TYPE='PACKAGE BODY'", [pkg])
            st = cur.fetchone()[0]
            cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:1", [pkg]); errs = cur.fetchone()[0]
            print(f"  {f}: {pkg} BODY {st} / 오류 {errs}")
            if st != "VALID" or errs: print("  중단 — 컴파일 오류. 99_ROLLBACK 백업으로 원복 검토"); sys.exit(3)
        else:
            print(f"  {f}: 완료")
        cn.close()
    print("적용 완료 — 90_POSTCHECK.sql 실행해 검증")

if __name__ == "__main__":
    main()
