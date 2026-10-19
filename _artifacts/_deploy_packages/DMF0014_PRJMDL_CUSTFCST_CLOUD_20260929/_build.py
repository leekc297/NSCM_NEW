"""DMF0014_PRJMDL_CUSTFCST_CLOUD_20260929 — 클라우드 이관 패키지 빌더 (DB 전용)

  회차 2건 (사내 ZIOUI1 적용 2026-09-29):
    [E20260929-DMF0014PRJMDL] Excel Upload Project/Model 존재 검증 보정       — PKG_DMF0014 BODY
    [E20260929-DMF0014CFSEQ]  Excel Upload 후 CUST_FCST(P+P) 메저 미생성 수정 — PKG_DMF0014 BODY + PR_DM_PLN_CUST_FCST_TO_MKT_FCST

  원문 = 빌드 시점 사내 USER_SOURCE 재조회. FRESH-GATE: 사내 현행 == 사내 적용본(_apply_corporate/*/01_APPLY) 일 때만 생성.
  지문 = USER_SOURCE LINE>1 의 (행수, SUM(LENGTH(RTRIM(TEXT, CR||LF)))) — 1행(헤더 표기)은 적용 방식에 따라 달라 제외.
usage: python _build.py
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
ART = HERE.parents[1]
sys.path.insert(0, str(ART / "_diagnostics"))
import ora, oracledb  # noqa: E402

AC = ART / "_apply_corporate"
NOW = datetime.datetime.now()
PKG, PR = ("PKG_DMF0014", "PACKAGE BODY"), ("PR_DM_PLN_CUST_FCST_TO_MKT_FCST", "PROCEDURE")
MK = ("PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST", "PROCEDURE")   # rev2 [E20260929-MAKECFCASE]

# 사내 상태 이력 파일 (지문 산출용)
STATES_PKG = [
    ("PRE_VALMSG",  AC / "DMF0014_VALIDATION_MSG_20260923/00_BACKUP_ASIS/PKG_DMF0014_BODY.ASIS.sql", "09-23 VALMSG 이전"),
    ("VALMSG",      AC / "DMF0014_PERIOD_BLANK_20260923/00_BACKUP_ASIS/PKG_DMF0014_BODY.PRE_BLANK.sql", "09-23 VALMSG 적용"),
    ("BLANK",       AC / "DMF0014_PRJMDL_CHK_20260929/00_BACKUP_ASIS/PKG_DMF0014_BODY.PRE_PRJMDL.sql", "09-24 BLANK 적용 = 이번 적용 직전"),
    ("PRJMDL_ONLY", AC / "DMF0014_PRJMDL_CHK_20260929/01_APPLY/PKG_DMF0014_BODY.PRJMDL.sql", "PRJMDL 만 적용(CFSEQ 미적용)"),
    ("AFTER",       AC / "DMF0014_CUSTFCST_SEQ_20260929/01_APPLY/PKG_DMF0014.CFSEQ.sql", "이번 2건 적용 후"),
]
STATES_PR = [
    ("BEFORE", AC / "DMF0014_CUSTFCST_SEQ_20260929/00_BACKUP_ASIS/PR_DM_PLN_CUST_FCST_TO_MKT_FCST.PRE_CFSEQ.sql", "이번 적용 직전"),
    ("AFTER",  AC / "DMF0014_CUSTFCST_SEQ_20260929/01_APPLY/PR_DM_PLN_CUST_FCST_TO_MKT_FCST.CFSEQ.sql", "이번 적용 후"),
]
STATES_MK = [
    ("BEFORE", AC / "DMF0014_MAKECF_CASE_20260929/00_BACKUP_ASIS/PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST.PRE_MAKECF.sql", "rev2 적용 직전"),
    ("AFTER",  AC / "DMF0014_MAKECF_CASE_20260929/01_APPLY/PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST.MAKECF.sql", "rev2 적용 후"),
]


def fetch(cur, name, typ):
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
    return [r[0] for r in cur.fetchall()]


def ddl_body(file):
    t = file.read_text(encoding="utf-8")
    t = t[t.index("CREATE OR REPLACE"):]
    t = re.sub(r"\n/\s*(\nSHOW ERRORS[^\n]*)?\s*$", "", t.rstrip())
    return t


def fp_lines(lines2):  # lines 2..N
    return len(lines2), sum(len(x.rstrip("\r\n")) for x in lines2)


def fp_file(file):
    return fp_lines(ddl_body(file).split("\n")[1:])


def head_ddl(name, typ, lines):
    kw = "PACKAGE\\s+BODY" if typ == "PACKAGE BODY" else "PROCEDURE"
    first = re.sub(rf'(?i)^\s*{kw}\s+"?\w+"?', f'CREATE OR REPLACE {typ} SCM_MGR."{name}"', lines[0].rstrip("\n"), count=1)
    return first + "\n" + "".join(lines[1:]).rstrip()


def main():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL"); assert cur.fetchone()[0].upper() == "ZIOUI1"
    out = {}
    for (name, typ), states in ((PKG, STATES_PKG), (PR, STATES_PR), (MK, STATES_MK)):
        lines = fetch(cur, name, typ)
        cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
        st, last = cur.fetchone(); assert st == "VALID", f"{name} {st}"
        body = head_ddl(name, typ, lines)
        # FRESH-GATE: 사내 현행 원문 == 사내 적용본 (적용 이후 타 작업자 변경 없음)
        applied = states[-1][1]
        assert body == ddl_body(applied), f"FRESH-GATE 실패: {name} 사내 현행이 적용본과 다름 — 재병합 필요"
        fp_db = fp_lines(lines[1:])
        assert fp_db == fp_file(applied), f"지문 산출 방식 불일치 {fp_db} vs {fp_file(applied)}"
        fps = [(k, fp_file(f), desc) for k, f, desc in states]
        out[name] = dict(typ=typ, last=last, body=body, fps=fps, before_file=states[-2][1] if name == PKG[0] else states[0][1])
    return cur, out


def judge_sql(name, typ, fps):
    whens = "\n".join(f"            WHEN COUNT(*)={n} AND SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13))))={c} THEN '{k} ({desc})'" for k, (n, c), desc in fps)
    return (f"SELECT '{name}' OBJ, COUNT(*) LINES_2N, SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13)))) CHAR_SUM,\n"
            f"       CASE\n{whens}\n            WHEN COUNT(*)=0 THEN 'MISSING'\n"
            f"            ELSE '⚠ UNKNOWN → 클라우드 고유 변경 가능 · 적용 전 diff 확인' END JUDGE\n"
            f"  FROM USER_SOURCE WHERE NAME='{name}' AND TYPE='{typ}' AND LINE > 1;\n")


if __name__ == "__main__":
    cur, o = main()
    A = HERE / "A_DB"; A.mkdir(parents=True, exist_ok=True)
    stamp_t = f"{NOW:%Y-%m-%d %H:%M}"
    pk, pr, mk = o[PKG[0]], o[PR[0]], o[MK[0]]

    # 10 / 11 본문
    for fn, name in (("10_PKG_DMF0014_BODY.sql", PKG[0]), ("11_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql", PR[0]), ("12_PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST.sql", MK[0])):
        x = o[name]
        hdr = (f"-- SOURCE-FRESH: SCM_MGR.{name} {x['typ']} LAST_DDL={x['last']} FETCHED={stamp_t} DB=ZIOUI1 STATUS=VALID\n"
               + ("-- [E20260929-DMF0014PRJMDL] Excel Upload Customer Project/Model 품목경로 구제 제거 + [Project]/[Model] SITE_ITEM 존재 검증 신설\n"
                  "-- [E20260929-DMF0014CFSEQ]  GT_DPCF_CUST_FCST_DIVISION.SEQ 0-base 채번 → MAKE_CUST_FCST(CUST_FCST 메저) 루프 복구\n"
                  "-- 포함 선행 회차: [E20260923-DMF0014VALMSG] [E20260923-DMF0014BLANK] (클라우드 미적용분이면 이 파일로 함께 반영)\n"
                  if name == PKG[0] else
                  "-- [E20260929-DMF0014CFSEQ] standalone 동일 결함 동일 수정 (현 호출자 0 — 정합 유지 목적)\n"
                  if name == PR[0] else
                  "-- [E20260929-MAKECFCASE] rev2 — 원천 메저 UPPER 비교: Excel 업로드분('Customer FCST')이 CUST_FCST 합산에서 누락되던 결함 (AS-IS MSSQL CI 파리티)\n")
               + "SET DEFINE OFF\nSET SQLBLANKLINES ON\n")
        (A / fn).write_text(hdr + x["body"] + "\n/\nSHOW ERRORS " + x["typ"] + " SCM_MGR." + name + "\n", encoding="utf-8", newline="\n")

    # 99 원복 (사내 적용 직전본)
    for fn, name, f in (("99_ROLLBACK_PKG_DMF0014_BODY.sql", PKG[0], AC / "DMF0014_PRJMDL_CHK_20260929/00_BACKUP_ASIS/PKG_DMF0014_BODY.PRE_PRJMDL.sql"),
                        ("99_ROLLBACK_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql", PR[0], STATES_PR[0][1]),
                        ("99_ROLLBACK_PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST.sql", MK[0], STATES_MK[0][1])):
        typ = o[name]["typ"]
        (A / fn).write_text(f"-- ROLLBACK: SCM_MGR.{name} {typ} = 사내 이번 적용 직전본 (09-24 BLANK 상태). 클라우드 고유 원문 복원은 05 백업 + 98 사용\n"
                            "SET DEFINE OFF\nSET SQLBLANKLINES ON\n" + ddl_body(f) + "\n/\nSHOW ERRORS " + typ + " SCM_MGR." + name + "\n",
                            encoding="utf-8", newline="\n")

    # 00 PRECHECK
    pre = f"""-- ============================================================================================
-- 00_PRECHECK_CLOUD.sql — READ-ONLY 선판정 (DML/DDL 없음) · 빌드 {stamp_t} · 원천 사내 ZIOUI1
-- 판정: [H1]/[H2] 가 '⚠ UNKNOWN' 이면 10/11 적용 전 클라우드 원문 diff 확인 (클라우드 고유 변경 덮어쓰기 방지)
--       [A]/[B] 에 MISSING 이 있으면 적용 중단 (컴파일 불가)
-- ============================================================================================
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A70

PROMPT [A] 의존 객체 존재·상태 (전부 존재·VALID 기대)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') LAST_DDL
  FROM USER_OBJECTS
 WHERE OBJECT_NAME IN ('PKG_DMF0014','PR_DM_PLN_CUST_FCST_TO_MKT_FCST','PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST',
                       'GT_DPCF_CUST_FCST_DIVISION','GT_DPCF_DM_PLN_CUSTOMER_PSI_2','SCM_MST_SITE_ITEM','DM_MST_CUSTOMER_MODEL',
                       'SCM_MST_ITEM_SN','SCM_MST_SITE','SCM_MST_DIVISION','SCM_ADM_EXCEL_UPLOAD','PR_SCM_SYS_LOG_BATCH')
 ORDER BY OBJECT_NAME, OBJECT_TYPE;

PROMPT [B] GTT GT_DPCF_CUST_FCST_DIVISION 컬럼 (DIVISION_ID + SEQ 2행 기대 — CFSEQ 가 SEQ 에 직접 INSERT)
SELECT COLUMN_NAME, DATA_TYPE, IDENTITY_COLUMN FROM USER_TAB_COLUMNS WHERE TABLE_NAME='GT_DPCF_CUST_FCST_DIVISION' ORDER BY COLUMN_ID;

PROMPT [H1] PKG_DMF0014 BODY 지문 (LINE>1) — 클라우드 현 상태 판정
{judge_sql(PKG[0], PKG[1], pk['fps'])}
PROMPT [H1-M] PKG_DMF0014 BODY 회차 마커 개수 (참고 — 사내 적용 후: VALMSG 31↑ / BLANK 2↑ / PRJMDL·CFSEQ 존재)
SELECT SUM(CASE WHEN TEXT LIKE '%E20260915-DMF0014MSTCHK%' THEN 1 ELSE 0 END) MSTCHK,
       SUM(CASE WHEN TEXT LIKE '%E20260923-DMF0014VALMSG%' THEN 1 ELSE 0 END) VALMSG,
       SUM(CASE WHEN TEXT LIKE '%E20260923-DMF0014BLANK%'  THEN 1 ELSE 0 END) BLANK,
       SUM(CASE WHEN TEXT LIKE '%E20260929-DMF0014PRJMDL%' THEN 1 ELSE 0 END) PRJMDL,
       SUM(CASE WHEN TEXT LIKE '%E20260929-DMF0014CFSEQ%'  THEN 1 ELSE 0 END) CFSEQ
  FROM USER_SOURCE WHERE NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY';

PROMPT [H2] PR_DM_PLN_CUST_FCST_TO_MKT_FCST 지문 (LINE>1)
{judge_sql(PR[0], PR[1], pr['fps'])}
PROMPT [H3] PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST 지문 (LINE>1) — rev2
{judge_sql(MK[0], MK[1], mk['fps'])}
PROMPT [C] CUST_FCST(P+P) 메저 최근 생성 (적용 전 기준값 — 적용 후 업로드 저장 시 갱신돼야 함)
SELECT DIVISION_ID, COUNT(*) CNT, TO_CHAR(MAX(CREATION_DATE),'YYYY-MM-DD HH24:MI:SS') LAST_MAKE
  FROM DM_PLN_MKT_FCST WHERE MEASURE='CUST_FCST' AND CREATED_BY='MAKE_CUST_FCST' GROUP BY DIVISION_ID ORDER BY 1;
"""
    (A / "00_PRECHECK_CLOUD.sql").write_text(pre, encoding="utf-8", newline="\n")

    # 05 클라우드 원문 백업 (비파괴 CTAS)
    (A / "05_BACKUP_CLOUD_SOURCE.sql").write_text(
        "-- 05_BACKUP_CLOUD_SOURCE.sql — 적용 직전 클라우드 원문을 테이블로 보관 (비파괴 · 멱등: 이미 있으면 SKIP)\n"
        "-- 원복 시 98_ROLLBACK_FROM_CLOUD_BACKUP.sql 이 이 테이블로 클라우드 고유 원문을 재생성한다.\n"
        "SET SERVEROUTPUT ON\nDECLARE\n  n NUMBER;\nBEGIN\n"
        "  SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME='BAK_SRC_DMF0014_20260929';\n"
        "  IF n = 0 THEN\n"
        "    EXECUTE IMMEDIATE q'[CREATE TABLE BAK_SRC_DMF0014_20260929 AS\n"
        "      SELECT NAME, TYPE, LINE, TEXT, SYSDATE AS BAK_DATE FROM USER_SOURCE\n"
        "       WHERE (NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY') OR (NAME IN ('PR_DM_PLN_CUST_FCST_TO_MKT_FCST','PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST') AND TYPE='PROCEDURE')]';\n"
        "    DBMS_OUTPUT.PUT_LINE('BACKUP CREATED');\n  ELSE\n"
        "    -- rev2: 1차 적용 때 이미 만든 테이블이면 아직 백업 안 된 객체(MAKE_CUST_FCST)만 추가 — 기존 백업 행은 건드리지 않음\n"
        "    EXECUTE IMMEDIATE q'[INSERT INTO BAK_SRC_DMF0014_20260929 (NAME, TYPE, LINE, TEXT, BAK_DATE)\n"
        "      SELECT S.NAME, S.TYPE, S.LINE, S.TEXT, SYSDATE FROM USER_SOURCE S\n"
        "       WHERE ((S.NAME='PKG_DMF0014' AND S.TYPE='PACKAGE BODY') OR (S.NAME IN ('PR_DM_PLN_CUST_FCST_TO_MKT_FCST','PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST') AND S.TYPE='PROCEDURE'))\n"
        "         AND NOT EXISTS (SELECT 1 FROM BAK_SRC_DMF0014_20260929 B WHERE B.NAME=S.NAME AND B.TYPE=S.TYPE)]';\n"
        "    DBMS_OUTPUT.PUT_LINE('TABLE EXISTS — added rows for missing objects: ' || SQL%ROWCOUNT);\n    COMMIT;\n  END IF;\nEND;\n/\n"
        "SELECT NAME, TYPE, COUNT(*) LINES FROM BAK_SRC_DMF0014_20260929 GROUP BY NAME, TYPE;\n",
        encoding="utf-8", newline="\n")

    # 98 클라우드 원문 원복
    (A / "98_ROLLBACK_FROM_CLOUD_BACKUP.sql").write_text(
        "-- 98_ROLLBACK_FROM_CLOUD_BACKUP.sql — 05 에서 보관한 클라우드 고유 원문으로 재생성 (롤백 전용 · 평소 실행 안 함)\n"
        "SET SERVEROUTPUT ON\nDECLARE\n  PROCEDURE rebuild(p_name VARCHAR2, p_type VARCHAR2) IS\n    v CLOB;\n  BEGIN\n"
        "    DBMS_LOB.CREATETEMPORARY(v, TRUE);\n"
        "    FOR r IN (SELECT TEXT FROM BAK_SRC_DMF0014_20260929 WHERE NAME=p_name AND TYPE=p_type ORDER BY LINE) LOOP\n"
        "      DBMS_LOB.APPEND(v, r.TEXT);\n    END LOOP;\n"
        "    IF DBMS_LOB.GETLENGTH(v) > 0 THEN\n      EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v;\n"
        "      DBMS_OUTPUT.PUT_LINE('REBUILT ' || p_name);\n    ELSE\n      DBMS_OUTPUT.PUT_LINE('SKIP (no backup) ' || p_name);\n    END IF;\n  END;\n"
        "BEGIN\n  rebuild('PKG_DMF0014', 'PACKAGE BODY');\n  rebuild('PR_DM_PLN_CUST_FCST_TO_MKT_FCST', 'PROCEDURE');\n"
        "  rebuild('PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST', 'PROCEDURE');\nEND;\n/\n"
        "SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME IN ('PKG_DMF0014','PR_DM_PLN_CUST_FCST_TO_MKT_FCST','PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST');\n",
        encoding="utf-8", newline="\n")

    # 90 VERIFY
    a_pk, a_pr, a_mk = pk["fps"][-1][1], pr["fps"][-1][1], mk["fps"][-1][1]
    ver = f"""-- 90_VERIFY.sql — 적용 후 값 단언 (조회 전용)
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A40

PROMPT [V1] 상태·컴파일 오류 (VALID / ERR 0 기대)
SELECT O.OBJECT_NAME, O.OBJECT_TYPE, O.STATUS,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       CASE WHEN O.STATUS='VALID' AND (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE)=0 THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM USER_OBJECTS O
 WHERE (O.OBJECT_NAME='PKG_DMF0014' AND O.OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY'))
    OR (O.OBJECT_NAME IN ('PR_DM_PLN_CUST_FCST_TO_MKT_FCST','PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST','PR_DM_DNM_EDI_CALLOFF_MKT_FCST') AND O.OBJECT_TYPE='PROCEDURE');

PROMPT [V2] 지문 = 사내 적용 후 (PKG {a_pk} / PR {a_pr} / MAKE {a_mk})
SELECT NAME, COUNT(*) LINES_2N, SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13)))) CHAR_SUM,
       CASE WHEN (NAME='PKG_DMF0014' AND COUNT(*)={a_pk[0]} AND SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13))))={a_pk[1]})
              OR (NAME='PR_DM_PLN_CUST_FCST_TO_MKT_FCST' AND COUNT(*)={a_pr[0]} AND SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13))))={a_pr[1]})
              OR (NAME='PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST' AND COUNT(*)={a_mk[0]} AND SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13))))={a_mk[1]})
            THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM USER_SOURCE
 WHERE LINE > 1 AND ((NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY') OR (NAME IN ('PR_DM_PLN_CUST_FCST_TO_MKT_FCST','PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST') AND TYPE='PROCEDURE'))
 GROUP BY NAME;

PROMPT [V3] 회차 마커·신규 구문 개수 (기대값 = 사내 적용 후 실측 — 빌드 시 기입)
SELECT NAME,
       SUM(CASE WHEN TEXT LIKE '%E20260929-DMF0014PRJMDL%' THEN 1 ELSE 0 END) PRJMDL,
       SUM(CASE WHEN TEXT LIKE '%E20260929-DMF0014CFSEQ%'  THEN 1 ELSE 0 END) CFSEQ,
       SUM(CASE WHEN TEXT LIKE '%NVL(MAX(T.SEQ), -1)%' THEN 1 ELSE 0 END) SEQ_NVL,
       SUM(CASE WHEN TEXT LIKE '%''Invalid Project [''%' THEN 1 ELSE 0 END) INVALID_PROJECT
  FROM USER_SOURCE
 WHERE (NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY') OR (NAME='PR_DM_PLN_CUST_FCST_TO_MKT_FCST' AND TYPE='PROCEDURE')
 GROUP BY NAME;
-- 기대: {{V3EXP}}

PROMPT [V3-M] MAKE_CUST_FCST 대소문자 무시 비교 반영 (UPPER_CMP 1 / OLD_CMP 0 기대)
SELECT SUM(CASE WHEN TEXT LIKE '%UPPER(MEASURE) IN (''CUSTOMER FCST'', ''CUST_FCST_EDI'')%' THEN 1 ELSE 0 END) UPPER_CMP,
       SUM(CASE WHEN TEXT LIKE '%AND MEASURE IN (''Customer Fcst'', ''CUST_FCST_EDI'')%' THEN 1 ELSE 0 END) OLD_CMP
  FROM USER_SOURCE WHERE NAME='PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST' AND TYPE='PROCEDURE';

PROMPT [V4] 화면 확인 후 — CUST_FCST 메저 재생성 (division 81 등 업로드 [OK] 저장 직후 LAST_MAKE 가 저장 시각으로 갱신돼야 함)
SELECT DIVISION_ID, COUNT(*) CNT, TO_CHAR(MAX(CREATION_DATE),'YYYY-MM-DD HH24:MI:SS') LAST_MAKE
  FROM DM_PLN_MKT_FCST WHERE MEASURE='CUST_FCST' AND CREATED_BY='MAKE_CUST_FCST' GROUP BY DIVISION_ID ORDER BY 1;
"""
    def cnt(name, typ):
        cur.execute("""SELECT SUM(CASE WHEN TEXT LIKE '%E20260929-DMF0014PRJMDL%' THEN 1 ELSE 0 END), SUM(CASE WHEN TEXT LIKE '%E20260929-DMF0014CFSEQ%' THEN 1 ELSE 0 END),
                              SUM(CASE WHEN TEXT LIKE '%NVL(MAX(T.SEQ), -1)%' THEN 1 ELSE 0 END), SUM(CASE WHEN TEXT LIKE '%''Invalid Project [''%' THEN 1 ELSE 0 END)
                         FROM USER_SOURCE WHERE NAME=:n AND TYPE=:t""", n=name, t=typ)
        return "/".join(str(v) for v in cur.fetchone())
    ver = ver.replace("{V3EXP}", f"PKG_DMF0014 → {cnt(*PKG)} · PR_DM_PLN_CUST_FCST_TO_MKT_FCST → {cnt(*PR)}  (PRJMDL/CFSEQ/SEQ_NVL/INVALID_PROJECT)")
    (A / "90_VERIFY.sql").write_text(ver, encoding="utf-8", newline="\n")
    print("PKG fps:", pk["fps"]); print("PR fps:", pr["fps"]); print("built", stamp_t)
