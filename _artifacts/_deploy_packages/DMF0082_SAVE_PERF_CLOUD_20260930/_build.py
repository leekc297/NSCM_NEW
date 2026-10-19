"""DMF0082_SAVE_PERF_CLOUD_20260930 — 클라우드 이관 패키지 빌더 (DB 전용 · 저장 속도개선 단독 적용본)

  ⚠ DMF0082_SAVE_TXN_CLOUD_20260929 와 내용 동일(같은 사내 상태에서 추출) — 둘 중 하나만 적용. 속도개선(SAVEPERF) BODY 는
    SAVE IN 17종 CLOB 선언(SAVETXN SPEC)·PROC_M CLOB 을 전제로 하므로 SPEC·BODY·PROC_M 을 함께 싣는다.

  회차 [E20260929-DMF0082SAVETXN] (사내 ZIOUI1 적용 2026-09-29 20:54:14)
       [E20260929-DMF0082SAVEPERF] (사내 적용 2026-09-29 22:12:35 — 파싱 루프 선형화, BODY 만)
    화면 저장 P_DMF0082_SAVE_MAIN_DATA : IN 17종 CLOB(32,767B 한도 해제) + 저장 본체 트랜잭션 원자화
    대상 = PKG_DMF0082 SPEC · BODY + SCM_ADM_PROC_M 18행(IN 17 CLOB)

  원문 = 빌드 시점 사내 USER_SOURCE 재조회. FRESH-GATE: 사내 현행 == 사내 적용본(_apply_corporate/DMF0082_SAVE_TXN_20260929/01_APPLY)
  일 때만 생성. 지문 = USER_SOURCE LINE>1 의 (행수, SUM(LENGTH(RTRIM(TEXT, CR||LF)))) — 1행(헤더 표기)은 적용 방식에 따라 달라 제외.
usage: python _build.py
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
ART = HERE.parents[1]
sys.path.insert(0, str(ART / "_diagnostics"))
import ora, oracledb  # noqa: E402

AC = ART / "_apply_corporate"
AP = AC / "DMF0082_SAVE_TXN_20260929"
NOW = datetime.datetime.now()
TAG = "E20260929-DMF0082SAVETXN"
PKG = "PKG_DMF0082"
PROC = "PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA"

# 사내 BODY 상태 이력 (09-21 클라우드 DB 적용분 이후 — 지문 판정표용). 마지막 = 이번 적용 후.
STATES_BODY = [
    ("XLSFORM_ASIS_0921", AC / "DMF0082_XLSFORM_ASIS_20260921/03_PKG_DMF0082_BODY.sql", "09-21 Excel Form AS-IS 파리티 (클라우드 DB 적용 보고분)"),
    ("PRE_TMAINFIX_0922", AC / "DMF0082_TMAIN_GTTFIX_20260922/00_backup/BACKUP_PKG_DMF0082_BODY_pre_tmainfix_20260922.sql", "09-22 TMAINFIX 직전"),
    ("TMAINFIX_0922", AC / "DMF0082_TMAIN_GTTFIX_20260922/01_PKG_DMF0082_BODY.sql", "09-22 TMAINFIX"),
    ("MSGUNDERSCORE_0922", AC / "DMF0082_MSG_UNDERSCORE_20260922/01_PKG_DMF0082_BODY.sql", "09-22 MSG_UNDERSCORE"),
    ("XLSFORM_MEAS_0923", AC / "DMF0082_XLSFORM_MEASURE_20260923/01_APPLY/PKG_DMF0082_BODY.sql", "09-23 XLSFORM measure"),
    ("XLSFORM_CURRENCY_0923", AC / "DMF0082_XLSFORM_MEASURE_20260923/01_APPLY/PKG_DMF0082_BODY.CURRENCY.sql", "09-23 CURRENCY"),
    ("XLSFORM_SORT_0923", AC / "DMF0082_XLSFORM_MEASURE_20260923/01_APPLY/PKG_DMF0082_BODY.SORT.sql", "09-23 SORT"),
    ("XLSFORM_CURCHAIN_0923", AC / "DMF0082_XLSFORM_MEASURE_20260923/01_APPLY/PKG_DMF0082_BODY.CURCHAIN.sql", "09-23 CURCHAIN"),
    ("XLSFORM_MEASUREOFF_0923", AC / "DMF0082_XLSFORM_MEASURE_20260923/01_APPLY/PKG_DMF0082_BODY.MEASUREOFF.sql", "09-23 MEASUREOFF (=XLSFORM_MEASURE_CLOUD 패키지)"),
    ("XLSUPQTY_0923", AC / "DMF0082_XLSUP_QTY_20260923/01_APPLY/PKG_DMF0082_BODY.XLSUPQTY.sql", "09-23 XLSUPQTY (=XLSUP_QTY_CLOUD 패키지 = 이번 직전)"),
    ("SAVETXN_0929", AP / "01_APPLY/PKG_DMF0082_BODY.SAVETXN.sql", "09-29 SAVETXN 만 적용 (SAVEPERF 미적용)"),
    ("AFTER", AC / "DMF0082_SAVE_PERF_20260929/01_APPLY/PKG_DMF0082_BODY.SAVEPERF.sql", "이번 적용 후(SAVETXN+SAVEPERF) → SKIP"),
]
STATES_SPEC = [
    ("BEFORE", AP / "00_BACKUP_ASIS/PKG_DMF0082_SPEC.PRE_SAVETXN.sql", "09-15 UIPKG 이후 = 이번 직전"),
    ("AFTER", AP / "01_APPLY/PKG_DMF0082_SPEC.SAVETXN.sql", "이번 적용 후 → SKIP"),
]


def fetch(cur, typ):
    # FRESH-GATE: 빌드 시점 사내 원문 새로 조회 (USER_SOURCE)
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE=:t ORDER BY LINE", n=PKG, t=typ)
    return [r[0] for r in cur.fetchall()]


def ddl_body(file):
    t = file.read_text(encoding="utf-8", errors="replace").replace("\r\n", "\n")
    m = re.search(r"(?im)^\s*(CREATE OR REPLACE\s+)?PACKAGE\b", t)  # 원문 덤프형(헤더 없는 USER_SOURCE 사본)도 허용
    t = t[m.start():].lstrip()
    t = re.sub(r"\n/\s*(\nSHOW ERRORS[^\n]*)?\s*$", "", t.rstrip())
    return t


def fp_lines(lines2):
    return len(lines2), sum(len(x.rstrip("\r\n")) for x in lines2)


def fp_file(file):
    return fp_lines(ddl_body(file).split("\n")[1:])


def head_ddl(typ, lines):
    kw = "PACKAGE\\s+BODY" if typ == "PACKAGE BODY" else "PACKAGE"
    first = re.sub(rf'(?i)^\s*{kw}\s+"?\w+"?', f'CREATE OR REPLACE {typ} SCM_MGR."{PKG}"', lines[0].rstrip("\n"), count=1)
    return first + "\n" + "".join(lines[1:]).rstrip()


def judge_sql(typ, fps):
    seen, whens = set(), []
    for k, fp, desc in fps:
        if fp in seen:  # 동일 지문(무변경 회차)은 첫 라벨만
            continue
        seen.add(fp)
        whens.append(f"            WHEN COUNT(*)={fp[0]} AND SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13))))={fp[1]} THEN '{k}'")
    return (f"SELECT '{PKG} {typ}' OBJ, COUNT(*) LINES_2N, SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13)))) CHAR_SUM,\n"
            f"       CASE\n" + "\n".join(whens) + "\n            WHEN COUNT(*)=0 THEN 'MISSING'\n"
            f"            ELSE '⚠ UNKNOWN' END JUDGE\n"
            f"  FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='{typ}' AND LINE > 1;\n")


def q(v):
    return "NULL" if v is None else "'" + str(v).replace("'", "''") + "'"


def main():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL"); assert cur.fetchone()[0].upper() == "ZIOUI1"
    out = {}
    for typ, states in (("PACKAGE", STATES_SPEC), ("PACKAGE BODY", STATES_BODY)):
        lines = fetch(cur, typ)
        cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=PKG, t=typ)
        st, last = cur.fetchone(); assert st == "VALID", f"{typ} {st}"
        body = head_ddl(typ, lines)
        applied = states[-1][1]
        assert body == ddl_body(applied), f"FRESH-GATE 실패: {typ} 사내 현행이 적용본과 다름 — 재병합 필요"
        assert fp_lines(lines[1:]) == fp_file(applied), "지문 산출 방식 불일치"
        fps = [(k, fp_file(f), desc) for k, f, desc in states]
        out[typ] = dict(last=last, body=body, fps=fps)
    # PROC_M 현행 (FRESH-GATE: IN 17 CLOB 기대)
    cur.execute("SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M WHERE PROC_NM=:p ORDER BY SORT_ORD", p=PROC)
    procm = cur.fetchall()
    assert len(procm) == 18 and sum(1 for r in procm if r[3] == "IN" and r[2] == "CLOB") == 17, f"PROC_M 사내 상태 이상 {procm}"
    # 의존 객체 (PRECHECK 존재 판정용)
    cur.execute("""SELECT DISTINCT REFERENCED_NAME, REFERENCED_TYPE FROM USER_DEPENDENCIES
                    WHERE NAME=:n AND TYPE='PACKAGE BODY' AND REFERENCED_OWNER='SCM_MGR' AND REFERENCED_NAME<>:n
                    ORDER BY 1""", n=PKG)
    deps = cur.fetchall()
    # GTT (통계 잠금 판정용)
    cur.execute("""SELECT DISTINCT D.REFERENCED_NAME FROM USER_DEPENDENCIES D JOIN USER_TABLES T ON T.TABLE_NAME=D.REFERENCED_NAME
                    WHERE D.NAME=:n AND D.TYPE='PACKAGE BODY' AND T.TEMPORARY='Y' ORDER BY 1""", n=PKG)
    gtts = [r[0] for r in cur.fetchall()]
    # 마커 개수 (적용 후 기대값)
    cur.execute("SELECT TYPE, COUNT(*) FROM USER_SOURCE WHERE NAME=:n AND TEXT LIKE :t GROUP BY TYPE", n=PKG, t="%E20260929-DMF0082SAVE%")
    marks = dict(cur.fetchall())
    return out, procm, deps, gtts, marks


if __name__ == "__main__":
    out, procm, deps, gtts, marks = main()
    A = HERE / "A_DB"; A.mkdir(parents=True, exist_ok=True)
    stamp_t = f"{NOW:%Y-%m-%d %H:%M}"
    sp, bd = out["PACKAGE"], out["PACKAGE BODY"]
    W = lambda fn, txt: (A / fn).write_text(txt, encoding="utf-8", newline="\n")

    # 10 / 11 본문 (SOURCE-FRESH)
    for fn, typ in (("10_PKG_DMF0082_SPEC.sql", "PACKAGE"), ("11_PKG_DMF0082_BODY.sql", "PACKAGE BODY")):
        x = out[typ]
        W(fn, f"-- SOURCE-FRESH: SCM_MGR.{PKG} {typ} LAST_DDL={x['last']} FETCHED={stamp_t} DB=ZIOUI1 STATUS=VALID\n"
              f"-- [{TAG}] 화면 저장 P_DMF0082_SAVE_MAIN_DATA IN 17종 CLOB + 저장 본체 트랜잭션 원자화\n"
              + ("-- [E20260929-DMF0082SAVEPERF] 저장 '^' 파싱 루프 선형화 (32,240행 189s→8s) + 행별 A00E 로그 → 요약 1행\n"
                 "-- 포함 선행 회차(BODY 전체본): 09-22 TMAINFIX·MSG_UNDERSCORE / 09-23 XLSFORM_MEASURE·XLSUPQTY — 클라우드 미적용분이면 함께 반영\n"
                 if typ == "PACKAGE BODY" else "-- SPEC 은 SAVE 선언 1곳(IN VARCHAR2→CLOB)만 변경. 반드시 11_BODY 와 함께 적용\n")
              + "SET DEFINE OFF\nSET SQLBLANKLINES ON\n" + x["body"] + f"\n/\nSHOW ERRORS {typ} SCM_MGR.{PKG}\n")

    # 99 원복 (사내 이번 적용 직전본)
    for fn, typ, f in (("99_ROLLBACK_PKG_DMF0082_SPEC.sql", "PACKAGE", STATES_SPEC[0][1]),
                       ("99_ROLLBACK_PKG_DMF0082_BODY.sql", "PACKAGE BODY", AP / "00_BACKUP_ASIS/PKG_DMF0082_BODY.PRE_SAVETXN.sql")):
        W(fn, f"-- ROLLBACK: SCM_MGR.{PKG} {typ} = 사내 이번 적용 직전본(09-23 XLSUPQTY 상태). 클라우드 고유 원문 복원은 05 백업 + 98 사용\n"
              "-- ⚠ 순서: 99_ROLLBACK_PROC_M → 99_ROLLBACK_PKG_DMF0082_SPEC → 99_ROLLBACK_PKG_DMF0082_BODY\n"
              "SET DEFINE OFF\nSET SQLBLANKLINES ON\n" + ddl_body(f) + f"\n/\nSHOW ERRORS {typ} SCM_MGR.{PKG}\n")

    # 20 PROC_M MERGE (멱등 · 화면 소유 메타 = MERGE)
    rows = "\n  UNION ALL ".join(
        f"SELECT {q(r[0])} PROC_NM, {q(r[1])} COL_NM, {q(r[2])} DATA_TP_CD, {q(r[3])} COL_TP_CD, {r[4]} SORT_ORD FROM DUAL" for r in procm)
    W("20_SCM_ADM_PROC_M.sql",
      f"-- 20_SCM_ADM_PROC_M.sql — [{TAG}] SAVE 파라미터 메타 (사내 현행 18행 · IN 17 = CLOB) · 멱등 MERGE · 빌드 {stamp_t}\n"
      "-- ⚠ 10·11 적용(SP 가 CLOB 선언) 이후에 실행. 순서가 바뀌면 BE 가 CLOB 으로 바인딩하는데 SP 는 VARCHAR2 인 구간이 생긴다.\n"
      "MERGE INTO SCM_MGR.SCM_ADM_PROC_M T\nUSING (\n  " + rows + "\n) S\n"
      "ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD)\n"
      "WHEN MATCHED THEN UPDATE SET T.DATA_TP_CD = S.DATA_TP_CD, T.SORT_ORD = S.SORT_ORD,\n"
      "                             T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE\n"
      "   WHERE T.DATA_TP_CD <> S.DATA_TP_CD OR T.SORT_ORD <> S.SORT_ORD\n"
      "WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n"
      "  VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);\n"
      "COMMIT;\n\n"
      f"SELECT COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = '{PROC}' ORDER BY SORT_ORD;\n"
      "-- 기대: 18행 · IN 17 = CLOB · o_rc1 = CURSOR/OUT\n")

    W("99_ROLLBACK_PROC_M.sql",
      f"-- 99_ROLLBACK_PROC_M.sql — SAVE IN 17 CLOB → VARCHAR 복귀 (롤백 전용 · 반드시 PKG 원복보다 먼저)\n"
      f"UPDATE SCM_MGR.SCM_ADM_PROC_M SET DATA_TP_CD = 'VARCHAR', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE\n"
      f" WHERE PROC_NM = '{PROC}' AND COL_TP_CD = 'IN' AND DATA_TP_CD = 'CLOB';\nCOMMIT;\n")

    # 00 PRECHECK
    dep_list = ",\n    ".join(f"'{n}|{t}'" for n, t in deps)
    gtt_list = ", ".join(f"'{g}'" for g in gtts)
    pre = f"""-- ============================================================================================
-- 00_PRECHECK_CLOUD.sql — READ-ONLY 선판정 (DML/DDL 없음) · 빌드 {stamp_t} · 원천 사내 ZIOUI1
--  [A] MISSING 있으면 중단 (컴파일 불가)
--  [L] LOCKED 있으면 중단 (저장 SP 의 DBMS_STATS 가 ORA-20005 로 실패 — UNLOCK 후 진행)
--  [H1]/[H2] '⚠ UNKNOWN' 이면 10/11 적용 전 클라우드 원문 diff 확인 (클라우드 고유 변경 덮어쓰기 방지)
-- ============================================================================================
SET PAGESIZE 300 LINESIZE 250
COLUMN JUDGE FORMAT A60
COLUMN OBJ FORMAT A60

PROMPT [A] PKG_DMF0082 BODY 의존 객체 {len(deps)}종 중 클라우드 부재 (0행 기대)
SELECT REGEXP_SUBSTR(COLUMN_VALUE, '[^|]+', 1, 1) OBJ, REGEXP_SUBSTR(COLUMN_VALUE, '[^|]+', 1, 2) OBJ_TYPE, 'MISSING' JUDGE
  FROM TABLE(SYS.ODCIVARCHAR2LIST(
    {dep_list}))
 WHERE NOT EXISTS (SELECT 1 FROM USER_OBJECTS O
                    WHERE O.OBJECT_NAME = REGEXP_SUBSTR(COLUMN_VALUE, '[^|]+', 1, 1)
                      AND O.OBJECT_TYPE = REGEXP_SUBSTR(COLUMN_VALUE, '[^|]+', 1, 2));

PROMPT [A2] 의존 객체 중 INVALID (참고 — 11 적용 후 재컴파일 대상)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS
 WHERE STATUS <> 'VALID' AND OBJECT_NAME IN (SELECT REGEXP_SUBSTR(COLUMN_VALUE, '[^|]+', 1, 1) FROM TABLE(SYS.ODCIVARCHAR2LIST(
    {dep_list})));

PROMPT [L] PKG_DMF0082 사용 GTT {len(gtts)}본 통계 잠금 (0행 기대)
SELECT TABLE_NAME, STATTYPE_LOCKED, 'LOCKED → EXEC DBMS_STATS.UNLOCK_TABLE_STATS(''SCM_MGR'',''' || TABLE_NAME || ''')' JUDGE
  FROM USER_TAB_STATISTICS
 WHERE TABLE_NAME IN ({gtt_list})
   AND STATTYPE_LOCKED IS NOT NULL;

PROMPT [H1] PKG_DMF0082 SPEC 지문 (LINE>1) — BEFORE 면 10 적용 / AFTER 면 SKIP
{judge_sql("PACKAGE", sp['fps'])}
PROMPT [H2] PKG_DMF0082 BODY 지문 (LINE>1) — AFTER 외 라벨이면 11 적용 / AFTER 면 SKIP
{judge_sql("PACKAGE BODY", bd['fps'])}
PROMPT [H3] 회차 마커 (적용 전 0 기대 · 적용 후 SPEC {marks.get('PACKAGE', 0)} / BODY {marks.get('PACKAGE BODY', 0)})
-- 마커 = SAVETXN + SAVEPERF 합산
SELECT TYPE, COUNT(*) CNT FROM USER_SOURCE WHERE NAME = '{PKG}' AND TEXT LIKE '%E20260929-DMF0082SAVE%' GROUP BY TYPE;

PROMPT [H4] 저장 SP 파라미터 타입 (적용 전 VARCHAR2 17 기대)
SELECT DATA_TYPE, COUNT(*) CNT FROM USER_ARGUMENTS
 WHERE PACKAGE_NAME = '{PKG}' AND OBJECT_NAME = 'P_DMF0082_SAVE_MAIN_DATA' AND IN_OUT = 'IN' GROUP BY DATA_TYPE;

PROMPT [M] PROC_M 현행 (적용 전 IN 17 = VARCHAR 기대 · 행 수 18)
SELECT COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M WHERE PROC_NM = '{PROC}' ORDER BY SORT_ORD;
"""
    W("00_PRECHECK_CLOUD.sql", pre)

    # 05 클라우드 원문·메타 백업 (비파괴 CTAS · 멱등)
    W("05_BACKUP_CLOUD_SOURCE.sql",
      "-- 05_BACKUP_CLOUD_SOURCE.sql — 적용 직전 클라우드 원문·PROC_M 을 테이블로 보관 (비파괴 · 멱등: 이미 있으면 SKIP)\n"
      "-- 원복 시 98_ROLLBACK_FROM_CLOUD_BACKUP.sql 이 이 테이블로 클라우드 고유 상태를 재생성한다.\n"
      "SET SERVEROUTPUT ON\nDECLARE\n  n NUMBER;\nBEGIN\n"
      "  SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME='BAK_SRC_DMF0082_SAVEPERF';\n"
      "  IF n = 0 THEN\n"
      "    EXECUTE IMMEDIATE q'[CREATE TABLE BAK_SRC_DMF0082_SAVEPERF AS\n"
      f"      SELECT NAME, TYPE, LINE, TEXT, SYSDATE AS BAK_DATE FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE IN ('PACKAGE','PACKAGE BODY')]';\n"
      "    DBMS_OUTPUT.PUT_LINE('SOURCE BACKUP CREATED');\n  ELSE\n    DBMS_OUTPUT.PUT_LINE('SOURCE BACKUP EXISTS - SKIP');\n  END IF;\n"
      "  SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME='BAK_PROCM_DMF0082_SAVEPERF';\n"
      "  IF n = 0 THEN\n"
      "    EXECUTE IMMEDIATE q'[CREATE TABLE BAK_PROCM_DMF0082_SAVEPERF AS\n"
      f"      SELECT T.*, SYSDATE AS BAK_DATE FROM SCM_ADM_PROC_M T WHERE PROC_NM='{PROC}']';\n"
      "    DBMS_OUTPUT.PUT_LINE('PROC_M BACKUP CREATED');\n  ELSE\n    DBMS_OUTPUT.PUT_LINE('PROC_M BACKUP EXISTS - SKIP');\n  END IF;\nEND;\n/\n"
      "SELECT NAME, TYPE, COUNT(*) LINES FROM BAK_SRC_DMF0082_SAVEPERF GROUP BY NAME, TYPE;\n"
      "SELECT COUNT(*) PROCM_ROWS FROM BAK_PROCM_DMF0082_SAVEPERF;\n")

    # 98 클라우드 원문 원복
    W("98_ROLLBACK_FROM_CLOUD_BACKUP.sql",
      "-- 98_ROLLBACK_FROM_CLOUD_BACKUP.sql — 05 에서 보관한 클라우드 고유 상태로 복원 (롤백 전용 · 평소 실행 안 함)\n"
      "-- 순서: PROC_M 복원 → SPEC → BODY\n"
      f"UPDATE SCM_MGR.SCM_ADM_PROC_M T SET (DATA_TP_CD, SORT_ORD) = (SELECT B.DATA_TP_CD, B.SORT_ORD FROM BAK_PROCM_DMF0082_SAVEPERF B\n"
      "                                                              WHERE B.PROC_NM=T.PROC_NM AND B.COL_NM=T.COL_NM AND B.COL_TP_CD=T.COL_TP_CD)\n"
      f" WHERE T.PROC_NM = '{PROC}'\n"
      "   AND EXISTS (SELECT 1 FROM BAK_PROCM_DMF0082_SAVEPERF B WHERE B.PROC_NM=T.PROC_NM AND B.COL_NM=T.COL_NM AND B.COL_TP_CD=T.COL_TP_CD);\n"
      "COMMIT;\n"
      "SET SERVEROUTPUT ON\nDECLARE\n  PROCEDURE rebuild(p_type VARCHAR2) IS\n    v CLOB;\n  BEGIN\n"
      "    DBMS_LOB.CREATETEMPORARY(v, TRUE);\n"
      f"    FOR r IN (SELECT TEXT FROM BAK_SRC_DMF0082_SAVEPERF WHERE NAME='{PKG}' AND TYPE=p_type ORDER BY LINE) LOOP\n"
      "      DBMS_LOB.APPEND(v, r.TEXT);\n    END LOOP;\n"
      "    IF DBMS_LOB.GETLENGTH(v) > 0 THEN\n      EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v;\n"
      "      DBMS_OUTPUT.PUT_LINE('REBUILT ' || p_type);\n    ELSE\n      DBMS_OUTPUT.PUT_LINE('SKIP (no backup) ' || p_type);\n    END IF;\n  END;\n"
      "BEGIN\n  rebuild('PACKAGE');\n  rebuild('PACKAGE BODY');\nEND;\n/\n"
      f"SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}';\n")

    # 90 VERIFY
    a_sp, a_bd = sp["fps"][-1][1], bd["fps"][-1][1]
    W("90_VERIFY.sql", f"""-- 90_VERIFY.sql — 적용 후 값 단언 (조회 전용)
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A40

PROMPT [V1] 상태·컴파일 오류 (VALID / ERR 0 → PASS)
SELECT O.OBJECT_TYPE, O.STATUS,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       CASE WHEN O.STATUS='VALID' AND (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE)=0 THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{PKG}' AND O.OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY');

PROMPT [V2] 지문 = 사내 적용 후 (SPEC {a_sp} / BODY {a_bd})
SELECT TYPE, COUNT(*) LINES_2N, SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13)))) CHAR_SUM,
       CASE WHEN (TYPE='PACKAGE' AND COUNT(*)={a_sp[0]} AND SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13))))={a_sp[1]})
              OR (TYPE='PACKAGE BODY' AND COUNT(*)={a_bd[0]} AND SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13))))={a_bd[1]})
            THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE IN ('PACKAGE','PACKAGE BODY') AND LINE > 1 GROUP BY TYPE;

PROMPT [V3] 저장 SP IN 파라미터 = CLOB 17 (PASS)
SELECT DATA_TYPE, COUNT(*) CNT, CASE WHEN DATA_TYPE='CLOB' AND COUNT(*)=17 THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM USER_ARGUMENTS WHERE PACKAGE_NAME='{PKG}' AND OBJECT_NAME='P_DMF0082_SAVE_MAIN_DATA' AND IN_OUT='IN' GROUP BY DATA_TYPE;

PROMPT [V4] PROC_M IN 17 = CLOB (PASS)
SELECT COUNT(*) IN_CLOB, CASE WHEN COUNT(*)=17 THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM SCM_ADM_PROC_M WHERE PROC_NM='{PROC}' AND COL_TP_CD='IN' AND DATA_TP_CD='CLOB';

PROMPT [V5] 저장 본체 원자성 — 첫 영구 DML ~ 1단계 COMMIT 사이 커밋 요인 0 (FIRST_DML < PHASE1_COMMIT, BETWEEN_CNT=0 → PASS)
WITH S AS (SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY'),
     B AS (SELECT MIN(LINE) L0 FROM S WHERE TEXT LIKE '%PROCEDURE P_DMF0082_SAVE_MAIN_DATA%'),
     D AS (SELECT MIN(LINE) LD FROM S, B WHERE LINE > L0 AND REGEXP_LIKE(TEXT,'^\\s*(DELETE FROM|INSERT INTO|MERGE INTO)\\s+SCM_MGR\\.(DM|SCM)_','i')),
     C AS (SELECT MIN(LINE) LC FROM S, D WHERE LINE > LD AND REGEXP_LIKE(TEXT,'^\\s*COMMIT;'))
SELECT D.LD FIRST_DML, C.LC PHASE1_COMMIT,
       (SELECT COUNT(*) FROM S WHERE LINE > D.LD AND LINE < C.LC
           AND REGEXP_LIKE(TEXT,'^\\s*(COMMIT|DBMS_STATS|EXECUTE IMMEDIATE|TRUNCATE)','i')) BETWEEN_CNT,
       CASE WHEN (SELECT COUNT(*) FROM S WHERE LINE > D.LD AND LINE < C.LC
                     AND REGEXP_LIKE(TEXT,'^\\s*(COMMIT|DBMS_STATS|EXECUTE IMMEDIATE|TRUNCATE)','i')) = 0
                 AND EXISTS (SELECT 1 FROM S WHERE LINE BETWEEN C.LC - 5 AND C.LC AND TEXT LIKE '%{TAG}%')
            THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM D, C;

PROMPT [V6] 앱 계정 실행 권한 유지 (CREATE OR REPLACE 는 GRANT 보존 — 0행이면 기존에도 없던 것, 사내 동일 여부 확인)
SELECT GRANTEE, PRIVILEGE FROM USER_TAB_PRIVS WHERE TABLE_NAME='{PKG}' ORDER BY GRANTEE;
""")

    # 91 대용량 스모크 (데이터 무변경)
    W("91_SMOKE_BIG_PAYLOAD.sql", f"""-- 91_SMOKE_BIG_PAYLOAD.sql — 32,767B 초과 페이로드 수용 확인 (선택 · 데이터 무변경)
--  40 행 2,500개 + 마지막 1행 division 81 → 파싱 완주 후 V81-00 '복수 Division' 검증으로 RESULT_CODE='F' 종료.
--  영구 테이블 DML 이전 종료 · ROLLBACK · 로그(SCM_SYS_LOG_BATCH)만 남음 — 파싱 루프가 행마다 1행(A00E) 기록하므로 약 2,500행.
--  기대 출력: MAX_PARAM_BYTES > 32767 · RESULT_CODE=F · RESULT_MSG=복수 Division ... (적용 전이면 ORA-06502 등 바인드/인자 오류)
--  ⚠ 사내에서도 이 스모크는 아직 실행하지 못했다(도구 권한 차단) — 첫 실행 결과를 공유 요망.
SET SERVEROUTPUT ON
DECLARE
  n_rows CONSTANT PLS_INTEGER := 2500;  -- ITEM 파라미터 약 40KB (> 32,767B)
  c_af CLOB; c_dv CLOB; c_pj CLOB; c_ec CLOB; c_ss CLOB; c_it CLOB; c_de CLOB; c_ft CLOB; c_ic CLOB;
  c_ms CLOB; c_ps CLOB; c_cp CLOB; c_yd CLOB; c_cu CLOB; c_qt CLOB; c_cb CLOB; c_as CLOB;
  rc SYS_REFCURSOR; v1 VARCHAR2(4000); v2 VARCHAR2(4000); v3 VARCHAR2(4000);
  PROCEDURE ap(c IN OUT NOCOPY CLOB, v VARCHAR2, is_first BOOLEAN) IS
  BEGIN
    IF NOT is_first THEN DBMS_LOB.WRITEAPPEND(c, 1, '^'); END IF;
    IF v IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(v), v); END IF;
  END;
BEGIN
  DBMS_LOB.CREATETEMPORARY(c_af, TRUE); DBMS_LOB.CREATETEMPORARY(c_dv, TRUE); DBMS_LOB.CREATETEMPORARY(c_pj, TRUE);
  DBMS_LOB.CREATETEMPORARY(c_ec, TRUE); DBMS_LOB.CREATETEMPORARY(c_ss, TRUE); DBMS_LOB.CREATETEMPORARY(c_it, TRUE);
  DBMS_LOB.CREATETEMPORARY(c_de, TRUE); DBMS_LOB.CREATETEMPORARY(c_ft, TRUE); DBMS_LOB.CREATETEMPORARY(c_ic, TRUE);
  DBMS_LOB.CREATETEMPORARY(c_ms, TRUE); DBMS_LOB.CREATETEMPORARY(c_ps, TRUE); DBMS_LOB.CREATETEMPORARY(c_cp, TRUE);
  DBMS_LOB.CREATETEMPORARY(c_yd, TRUE); DBMS_LOB.CREATETEMPORARY(c_cu, TRUE); DBMS_LOB.CREATETEMPORARY(c_qt, TRUE);
  DBMS_LOB.CREATETEMPORARY(c_cb, TRUE); DBMS_LOB.CREATETEMPORARY(c_as, TRUE);
  FOR i IN 1..n_rows + 1 LOOP
    ap(c_af, 'M', i = 1);
    ap(c_dv, CASE WHEN i <= n_rows THEN '40' ELSE '81' END, i = 1);   -- 마지막 1행 81 → V81-00 복수 Division 'F'
    ap(c_pj, 'SMOKE_PRJ', i = 1);           ap(c_ec, 'SMOKE_EC', i = 1);
    ap(c_ss, 'SMOKE_SITE', i = 1);          ap(c_it, 'SMOKE_ITEM_' || i, i = 1);
    ap(c_de, 'E', i = 1);                   ap(c_ft, 'MPS', i = 1);
    ap(c_ic, 'DDP', i = 1);                 ap(c_ms, 'LOC', i = 1);
    ap(c_ps, '-', i = 1);                   ap(c_cp, 'SMOKE_CP', i = 1);
    ap(c_yd, TO_CHAR(DATE '2027-01-01' + MOD(i, 300), 'YYYYMMDD'), i = 1);
    ap(c_cu, 'USD', i = 1);                 ap(c_qt, '1', i = 1);
    ap(c_cb, 'SMOKE_TEST', i = 1);          ap(c_as, NULL, i = 1);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('ROWS=' || (n_rows + 1) || ' MAX_PARAM_BYTES(ITEM)=' || DBMS_LOB.GETLENGTH(c_it));
  SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA(c_af, c_dv, c_pj, c_ec, c_ss, c_it, c_de, c_ft, c_ic, c_ms, c_ps, c_cp,
                                               c_yd, c_cu, c_qt, c_cb, c_as, rc);
  FETCH rc INTO v1, v2, v3; CLOSE rc;
  DBMS_OUTPUT.PUT_LINE('RESULT_CODE=' || v1 || ' RESULT_MSG=' || v2 || ' EVENT=' || v3);
  DBMS_OUTPUT.PUT_LINE(CASE WHEN v1 = 'F' AND v2 LIKE '%Division%' THEN 'PASS (32K 초과 수용 · 검증 단계 정상 종료)' ELSE '❌ 확인 필요' END);
END;
/
""")
    print("SPEC fps:", sp["fps"]); print("BODY fps:", bd["fps"])
    print("deps", len(deps), "gtts", len(gtts), "marks", marks, "built", stamp_t)
