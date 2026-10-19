"""STEP 4 — 전환 후 미사용 standalone 삭제 SQL 생성 (미적용 · 담당자 수행) + 판정 전용 실행

usage: python s4_drop.py build | judge

생성 (04_drop/<PKG>/):
  40_DROP_STANDALONE_SCM_MGR.sql  SP 별 가드 블록 → 통과 시 기존 PROC_M 행 삭제 + DROP PROCEDURE
       가드(하나라도 걸리면 SKIP·사유 출력): PKG BODY VALID · PKG 멤버 존재 · API_M.API_URL 참조 0 · EXCEL STORAGE_SQL_ID 0 ·
             CMBO SQL 참조 0 · 스케줄러 JOB 참조 0 · USER_DEPENDENCIES 참조 0 (이번 DROP 대상끼리 참조는 제외)
       파일 머리 `c_execute CONSTANT BOOLEAN := TRUE;` — FALSE 면 판정만
  41_DROP_SYNONYM_SCMP_APP.sql    (SCMP_APP) SCM_MGR 원 SP 가 사라진 경우에만 해당 시노님 DROP
  49_RESTORE.sql                  STEP 1 백업 원문으로 standalone · GRANT · (SCMP_APP 시노님은 주석 안내) · PROC_M 복원
judge: 40 파일을 c_execute=FALSE 로 사내에서 실행 → 04_drop/JUDGE.md (DB 무변경)
"""
import csv, datetime, json, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent
OUT = ROOT / "04_drop"
sys.path.insert(0, str(HERE.parents[2] / "_diagnostics"))
import ora, oracledb  # noqa: E402


def q(s):
    return "'" + str(s).replace("'", "''") + "'"


def build(L):
    u, p, d = ora.conn_info()
    cur = oracledb.connect(user=u, password=p, dsn=d).cursor()
    all_targets = sorted(t["sp"].upper() for t in L["targets"])
    tlist = ",\n    ".join(", ".join(q(x) for x in all_targets[i:i + 4]) for i in range(0, len(all_targets), 4))
    grants = (ROOT / "01_backup/scmp_app/GRANT_SYNONYM_RESTORE.sql").read_text(encoding="utf-8")
    pm_rows = list(csv.DictReader((ROOT / "01_backup/meta/SCM_ADM_PROC_M.csv").open(encoding="utf-8-sig")))
    by_pkg = {}
    for t in L["targets"]:
        by_pkg.setdefault(t["pkg"], []).append(t)
    for pkg, items in sorted(by_pkg.items()):
        d = OUT / pkg; d.mkdir(parents=True, exist_ok=True)
        blocks = []
        for t in items:
            sp, mem = t["sp"].upper(), t["member"]
            blocks.append(f"""  chk({q(sp)}, {q(pkg)}, {q(mem)});""")
        body = f"""-- {pkg} — 미사용 standalone 삭제 (SCM_MGR 로 실행 · 미적용 산출물 · 담당자 수행)
-- 선행: STEP 2 (PKG 멤버 VALID) · STEP 3 META 전환 적용 · 화면 실측 완료
-- 가드 통과 SP 만 기존 PROC_M 행 삭제 → DROP PROCEDURE. 판정만 하려면 c_execute 를 FALSE 로.
-- 복원: 49_RESTORE.sql
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  c_execute CONSTANT BOOLEAN := TRUE;
  TYPE t_names IS TABLE OF VARCHAR2(128);
  v_all t_names := t_names(
    {tlist});   -- 이번 취합 DROP 대상 전체 43 (서로 간 참조는 차단 사유에서 제외)
  n_ok PLS_INTEGER := 0; n_skip PLS_INTEGER := 0;

  FUNCTION in_all(p VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    FOR i IN 1 .. v_all.COUNT LOOP IF v_all(i) = UPPER(p) THEN RETURN TRUE; END IF; END LOOP;
    RETURN FALSE;
  END;

  PROCEDURE chk(p_sp VARCHAR2, p_pkg VARCHAR2, p_member VARCHAR2) IS
    v_why VARCHAR2(32767); n NUMBER; n_dep PLS_INTEGER := 0; v_dep VARCHAR2(1000);
    v_pat VARCHAR2(400) := '(^|[^A-Z0-9_$#.])' || p_sp || '([^A-Z0-9_$#]|$)';
  BEGIN
    SELECT COUNT(*) INTO n FROM USER_OBJECTS WHERE OBJECT_NAME = p_sp AND OBJECT_TYPE = 'PROCEDURE';
    IF n = 0 THEN DBMS_OUTPUT.PUT_LINE('ALREADY  ' || p_sp || ' (standalone 없음)'); RETURN; END IF;
    SELECT COUNT(*) INTO n FROM USER_OBJECTS WHERE OBJECT_NAME = p_pkg AND OBJECT_TYPE = 'PACKAGE BODY' AND STATUS = 'VALID';
    IF n = 0 THEN v_why := v_why || ' [PKG BODY 없음/INVALID]'; END IF;
    SELECT COUNT(*) INTO n FROM USER_PROCEDURES WHERE OBJECT_NAME = p_pkg AND PROCEDURE_NAME = p_member;
    IF n = 0 THEN v_why := v_why || ' [PKG 멤버 없음 ' || p_member || ']'; END IF;
    SELECT COUNT(*) INTO n FROM SCM_ADM_API_M WHERE UPPER(API_URL) IN (p_sp, 'SCM_MGR.' || p_sp);
    IF n > 0 THEN v_why := v_why || ' [API_M 참조 ' || n || ' — META 미전환]'; END IF;
    SELECT COUNT(*) INTO n FROM SCM_ADM_EXCEL_COLUMNS WHERE UPPER(STORAGE_SQL_ID) IN (p_sp, 'SCM_MGR.' || p_sp);
    IF n > 0 THEN v_why := v_why || ' [EXCEL 참조 ' || n || ']'; END IF;
    SELECT COUNT(*) INTO n FROM SCM_ADM_CMBO_SQL_M WHERE REGEXP_LIKE(UPPER(SQL_DTL_CTN), v_pat);
    IF n > 0 THEN v_why := v_why || ' [CMBO SQL 참조 ' || n || ']'; END IF;
    SELECT COUNT(*) INTO n FROM USER_SCHEDULER_JOBS WHERE REGEXP_LIKE(UPPER(JOB_ACTION), v_pat);
    IF n > 0 THEN v_why := v_why || ' [스케줄러 JOB 참조 ' || n || ']'; END IF;
    FOR r IN (SELECT DISTINCT NAME, TYPE FROM USER_DEPENDENCIES WHERE REFERENCED_NAME = p_sp AND REFERENCED_TYPE = 'PROCEDURE' AND NAME <> p_sp) LOOP
      IF NOT in_all(r.NAME) THEN
        n_dep := n_dep + 1;
        IF n_dep <= 5 THEN v_dep := v_dep || ' ' || r.NAME || '(' || r.TYPE || ')'; END IF;
      END IF;
    END LOOP;
    IF n_dep > 0 THEN v_why := v_why || ' [의존 ' || n_dep || '건:' || v_dep || CASE WHEN n_dep > 5 THEN ' …' END || ']'; END IF;
    IF v_why IS NOT NULL THEN
      n_skip := n_skip + 1; DBMS_OUTPUT.PUT_LINE('SKIP     ' || p_sp || v_why); RETURN;
    END IF;
    IF c_execute THEN
      DELETE FROM SCM_ADM_PROC_M WHERE UPPER(PROC_NM) = p_sp;
      DBMS_OUTPUT.PUT_LINE('PROC_M   ' || p_sp || ' 삭제 ' || SQL%ROWCOUNT || '행');
      EXECUTE IMMEDIATE 'DROP PROCEDURE "' || p_sp || '"';
      DBMS_OUTPUT.PUT_LINE('DROPPED  ' || p_sp);
    ELSE
      DBMS_OUTPUT.PUT_LINE('PASS     ' || p_sp || ' (판정만 — c_execute=FALSE)');
    END IF;
    n_ok := n_ok + 1;
  END;
BEGIN
{chr(10).join(blocks)}
  IF c_execute THEN COMMIT; END IF;
  DBMS_OUTPUT.PUT_LINE('=== {pkg}: PASS/DROP ' || n_ok || ' · SKIP ' || n_skip);
END;
/
"""
        (d / "40_DROP_STANDALONE_SCM_MGR.sql").write_text(body, encoding="utf-8")
        syn = [f"-- {pkg} — SCMP_APP 시노님 정리 (SCMP_APP 로 실행 · 40 실행 후 · 원 SP 가 사라진 경우에만)",
               "SET SERVEROUTPUT ON SIZE UNLIMITED", "DECLARE n NUMBER;", "BEGIN"]
        for t in items:
            sp = t["sp"].upper()
            syn += [f"  SELECT COUNT(*) INTO n FROM USER_SYNONYMS WHERE SYNONYM_NAME = {q(sp)} AND TABLE_OWNER = 'SCM_MGR';",
                    f"  IF n > 0 THEN",
                    f"    SELECT COUNT(*) INTO n FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = {q(sp)} AND OBJECT_TYPE = 'PROCEDURE';",
                    f"    IF n = 0 THEN EXECUTE IMMEDIATE 'DROP SYNONYM \"{sp}\"'; DBMS_OUTPUT.PUT_LINE('DROPPED SYNONYM {sp}');",
                    f"    ELSE DBMS_OUTPUT.PUT_LINE('SKIP {sp} (SCM_MGR 원 SP 존재)'); END IF;",
                    f"  END IF;"]
        syn += ["END;", "/"]
        (d / "41_DROP_SYNONYM_SCMP_APP.sql").write_text("\n".join(syn) + "\n", encoding="utf-8")
        # 복원
        rs = [f"-- {pkg} — standalone 복원 (DROP 직전 원문 = 생성 시점 DB 재조회본 · SCM_MGR 로 실행)",
              "-- ⚠ STEP 1 백업이 아니라 현재 원문을 쓴다: STEP 2 에서 바뀐 standalone(예: DMF0043_GET_MAIN_SPREAD_TITLE → _CORE 호출)을 옛 본문으로 되돌리면 INVALID",
              "SET DEFINE OFF"]
        names = {t["sp"].upper() for t in items}
        for t in items:
            # FRESH-GATE: 복원 원문은 지금 DB 의 ALL_SOURCE 에서 읽는다(백업 파일 사용 금지) · 읽는 동안 LAST_DDL 변동 없음 확인
            cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=t["sp"])
            ldt = cur.fetchone()[0]
            cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=t["sp"])
            src = "".join(r[0] for r in cur.fetchall())
            cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=t["sp"])
            assert cur.fetchone()[0] == ldt, f"FRESH-GATE 실패: {t['sp']} 읽는 중 변경"
            head, rest = src.split("\n", 1)
            head = re.sub(r'(?i)^\s*PROCEDURE\s+"?\w+"?', f'CREATE OR REPLACE PROCEDURE SCM_MGR."{t["sp"]}"', head, count=1)
            rs.append(f"-- SOURCE-FRESH: SCM_MGR.{t['sp']} PROCEDURE LAST_DDL={ldt} FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1")
            rs.append(head + "\n" + rest.rstrip() + "\n/")
        rs.append("-- 권한 (SCM_MGR)")
        rs += [l for l in grants.splitlines() if l.startswith("GRANT") and re.search(r"SCM_MGR\.(\w+) TO", l) and re.search(r"SCM_MGR\.(\w+) TO", l).group(1).upper() in names]
        rs.append("-- 시노님 (SCMP_APP 로 실행할 것)")
        rs += ["-- " + l for l in grants.splitlines() if l.startswith("CREATE OR REPLACE SYNONYM") and re.search(r"FOR SCM_MGR\.(\w+);", l).group(1).upper() in names]
        rs.append("-- PROC_M (standalone PROC_NM · 멱등 MERGE)")
        for r in pm_rows:
            if r["PROC_NM"].upper() in names:
                rs.append(f"MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT {q(r['PROC_NM'])} PROC_NM, {q(r['COL_NM'])} COL_NM, {q(r['DATA_TP_CD'])} DATA_TP_CD, {q(r['COL_TP_CD'])} COL_TP_CD, {r['SORT_ORD']} SORT_ORD FROM DUAL) S "
                          "ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) "
                          "VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);")
        rs.append("COMMIT;")
        (d / "49_RESTORE.sql").write_text("\n".join(rs) + "\n", encoding="utf-8")
    print({k: len(v) for k, v in by_pkg.items()}, "total", sum(len(v) for v in by_pkg.values()))


def judge():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.callproc("DBMS_OUTPUT.ENABLE", [None])
    lines = ["# STEP 4 DROP 가드 판정 (사내 · c_execute=FALSE · DB 무변경)", ""]
    for f in sorted(OUT.glob("PKG_*/40_DROP_STANDALONE_SCM_MGR.sql")):
        sql = f.read_text(encoding="utf-8")
        blk = sql[sql.index("DECLARE"): sql.rindex("END;") + 4].replace("c_execute CONSTANT BOOLEAN := TRUE;", "c_execute CONSTANT BOOLEAN := FALSE;")
        cur.execute(blk)
        line, status = cur.var(str), cur.var(int)
        while True:
            cur.callproc("DBMS_OUTPUT.GET_LINE", (line, status))
            if status.getvalue() != 0: break
            lines.append("    " + line.getvalue())
        con.rollback()
    (OUT / "JUDGE.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("\n".join(lines))


if __name__ == "__main__":
    L = json.loads((ROOT / "LEDGER.json").read_text(encoding="utf-8"))
    OUT.mkdir(exist_ok=True)
    build(L) if sys.argv[1] == "build" else judge()
