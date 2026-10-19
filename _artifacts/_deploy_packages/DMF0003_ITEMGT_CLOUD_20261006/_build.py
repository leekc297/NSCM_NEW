# -*- coding: utf-8 -*-
"""DMF0003_ITEMGT_CLOUD_20261006 — 클라우드 이관 패키지 빌더 [E20261006-ITEMGT].

원천 = 사내 ZIOUI1 PKG_DMF0003 BODY 를 지금 새로 읽은 원문 (hook #152). FRESH-GATE: 추출 전후 동일 + 마커 assert.
BEFORE 지문 = 사내 적용 때 확인한 10-02 20:31:56 원문(_apply_corporate/DMF0003_ITEMGT_20261006/_unguarded_base_body.txt · md5 고정)에서 같은 산식으로 계산.
임시테이블 DDL = 사내 ALL_TAB_COLUMNS 를 지금 읽어 생성(사내 적용 DDL 과 컬럼·타입 일치 assert).
사용: python _build.py
"""
import datetime, difflib, hashlib, io, pathlib, re, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

TAG = "E20261006-ITEMGT"
OLD_TAG = "E20261006-ASISPARITY"
PKG = "PKG_DMF0003"
SRC = HERE.parents[1] / "_apply_corporate" / "DMF0003_ITEMGT_20261006"
BASE_MD5 = "869b25fc452af7d9df4d2c73d675794d"      # 사내 10-02 20:31:56 원문 (ASISPARITY · ITEMGT 적용 전)
BAK = "BAK_SRC_DMF0003_ITEMGT"
GTS = ["GT_DMF3_ITEM_SINGLE_ORI", "GT_DMF3_ITEM_SINGLE_A", "GT_DMF3_ITEM_SINGLE_B", "GT_DMF3_ITEM_SINGLE_V_ALL"]
IDX = "IDX1_GT_DMF3_ITEM_SINGLE_V_ALL"
MIRROR = "GT_DMF3_ITEM_SINGLE_V"                   # 권한·시노님 기준(저장 멤버가 이미 쓰는 임시테이블)
GT_ALL = "SCM_MGR.GT_DMF3_ITEM_SINGLE_V_ALL"
VIEW_RE = re.compile(r"\bSCM_MGR\.DM_MST_ITEM_SINGLE_V\b")
MARKS = 9


def fp_sql(typ):
    return (f"SELECT COUNT(*) LN, SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13)))) CH FROM USER_SOURCE "
            f"WHERE NAME='{PKG}' AND TYPE='{typ}' AND LINE > 1")


def fp_of(src):
    body = src.split("\n")[1:]
    if body and body[-1] == "":
        body.pop()
    return len(body), sum(len(l.rstrip("\r")) for l in body)


def mark_sql(tag):
    return f"(SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%[{tag}]%')"


u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()


def state(typ):
    cur.execute(f"SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' AND OBJECT_TYPE='{typ}'")
    ddl, st = cur.fetchone()
    cur.execute(fp_sql(typ))
    return ddl, st, tuple(cur.fetchone())


def source(typ):
    cur.execute(f"SELECT TEXT FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='{typ}' ORDER BY LINE")
    return "".join(t or "" for (t,) in cur)


now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
A = HERE / "A_DB"
A.mkdir(exist_ok=True)

# ---- 원천 추출 (FRESH-GATE: 추출 전후 상태 동일)
s_body, s_spec = state("PACKAGE BODY"), state("PACKAGE")
body, spec = source("PACKAGE BODY"), source("PACKAGE")
cur.execute(f"SELECT NAME, TYPE FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='{PKG}' AND REFERENCED_TYPE='PACKAGE' AND NOT (NAME='{PKG}' AND TYPE='PACKAGE BODY') ORDER BY 2,1")
deps = cur.fetchall()
cur.execute(f"SELECT GRANTEE, PRIVILEGE FROM USER_TAB_PRIVS WHERE TABLE_NAME='{PKG}' ORDER BY 1")
grants = cur.fetchall()
assert state("PACKAGE BODY") == s_body and state("PACKAGE") == s_spec, "FRESH-GATE: 추출 도중 변경"
assert s_body[1] == "VALID" and s_spec[1] == "VALID"
assert body.count("[" + TAG + "]") == MARKS and body.count("[" + OLD_TAG + "]") == 0, (body.count("[" + TAG + "]"), body.count("[" + OLD_TAG + "]"))
base = (SRC / "_unguarded_base_body.txt").read_text(encoding="utf-8")
assert hashlib.md5(base.encode("utf-8")).hexdigest() == BASE_MD5
before, after, spec_fp = fp_of(base), s_body[2], s_spec[2]
assert fp_of(body) == after and fp_of(spec) == spec_fp, "지문 산식 불일치"
assert before != after
n_gt_all = sum(1 for l in body.split("\n") if GT_ALL in l)
n_view_live = sum(1 for l in body.split("\n") if VIEW_RE.search(l) and not l.lstrip().startswith("--"))
n_view_base = sum(1 for l in base.split("\n") if VIEW_RE.search(l) and not l.lstrip().startswith("--"))
assert n_gt_all == 8 and n_view_base - n_view_live == 6, (n_gt_all, n_view_base, n_view_live)

# ---- 임시테이블 DDL (사내 딕셔너리에서 생성)
def col_def(r):
    name, typ, clen, prec, scale = r
    if typ == "VARCHAR2":
        t = f"VARCHAR2({clen} CHAR)"
    elif typ == "NUMBER":
        t = "NUMBER" if prec is None else f"NUMBER({prec},{scale})"
    else:
        raise AssertionError(("미지원 타입", name, typ))
    return f"{name:<30}{t}"


ddl_blocks, gt_cols = [], {}
for g in GTS:
    cur.execute("SELECT TEMPORARY, DURATION FROM USER_TABLES WHERE TABLE_NAME=:t", t=g)
    assert cur.fetchone() == ("Y", "SYS$SESSION"), g
    cur.execute("SELECT COLUMN_NAME, DATA_TYPE, CHAR_LENGTH, DATA_PRECISION, DATA_SCALE FROM USER_TAB_COLUMNS WHERE TABLE_NAME=:t ORDER BY COLUMN_ID", t=g)
    cols = cur.fetchall()
    gt_cols[g] = len(cols)
    lines = "\n".join(("( " if i == 0 else ", ") + col_def(c) for i, c in enumerate(cols))
    ddl_blocks.append(f"    MK('{g}', q'[\nCREATE GLOBAL TEMPORARY TABLE {g}\n{lines}\n) ON COMMIT PRESERVE ROWS]');")
cur.execute("SELECT LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY COLUMN_POSITION) FROM USER_IND_COLUMNS WHERE INDEX_NAME=:i", i=IDX)
idx_cols = cur.fetchone()[0]
assert idx_cols == "DIVISION_ID, ITEM_ID", idx_cols
cur.execute("SELECT GRANTEE, LISTAGG(PRIVILEGE, ',') WITHIN GROUP (ORDER BY PRIVILEGE) FROM USER_TAB_PRIVS WHERE TABLE_NAME=:t GROUP BY GRANTEE", t=MIRROR)
mirror_grants = cur.fetchall()
cur.execute("SELECT OWNER FROM ALL_SYNONYMS WHERE TABLE_OWNER='SCM_MGR' AND TABLE_NAME=:t ORDER BY 1", t=MIRROR)
mirror_syn = [r[0] for r in cur.fetchall()]
gt_in = ", ".join(f"'{g}'" for g in GTS)

(A / "00_PRECHECK_CLOUD.sql").write_text(f"""-- 00_PRECHECK_CLOUD.sql — READ-ONLY 선판정 [{TAG}] · 빌드 {now} · 원천 사내 ZIOUI1
--  ⚠ QA · DEV 두 DB 모두 · [H-BODY] JUDGE 가 '적용'/'SKIP' 이 아니면 11 BODY 전체본을 적용하지 말고 12 수동 반영(README §4)
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A120
PROMPT [E0] 접속 DB
SELECT USER USR, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','SERVER_HOST') HOST FROM DUAL;
PROMPT [H0] SPEC/BODY 상태 (SPEC 은 이번 건에서 변경 없음)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS
 WHERE OBJECT_NAME = '{PKG}' ORDER BY 1, 2;
PROMPT [H-SPEC] {PKG} SPEC 지문 — 사내 {spec_fp[0]}/{spec_fp[1]} (사내 SPEC LAST_DDL {s_spec[0]} — 저장 인자 CLOB 판)
SELECT LN || '/' || CH SPEC_FP,
       CASE WHEN LN = {spec_fp[0]} AND CH = {spec_fp[1]} THEN 'OK — 사내와 같은 SPEC'
            ELSE '⚠ SPEC 이 사내와 다름 — 11 BODY 전체본 적용 금지(컴파일 불일치 위험). 12 를 수동 반영 (README §4)' END JUDGE
  FROM ({fp_sql('PACKAGE')});
PROMPT [H-BODY] {PKG} BODY 지문 — 전 {before[0]}/{before[1]} (사내 10-02 20:31:56 판) · 후 {after[0]}/{after[1]}
SELECT LN || '/' || CH BODY_FP, {mark_sql(TAG)} ITEMGT_MARK_LINES, {mark_sql(OLD_TAG)} ASISPARITY_MARK_LINES,
       CASE WHEN LN = {after[0]} AND CH = {after[1]} THEN 'SKIP — 이미 적용됨'
            WHEN LN = {before[0]} AND CH = {before[1]} THEN '적용 — 05 → 10 → 11 → 13 → 90'
            WHEN {mark_sql(TAG)} = {MARKS} THEN 'SKIP? — 변경분은 전부 있으나 지문 상이(타 변경 병존). 90 으로 확인'
            WHEN {mark_sql(OLD_TAG)} > 0 THEN '⚠ ASISPARITY 가드(비활성 8곳)가 들어 있음 — 가드를 먼저 걷어낸 뒤 12 를 수동 반영 (README §4)'
            ELSE '⚠ BODY 전체본 적용 금지 — 지문 상이(사내 누적본 미적용 또는 클라우드 전용 변경). 10 실행 후 12 를 수동 반영 (README §4)' END JUDGE
  FROM ({fp_sql('PACKAGE BODY')});
PROMPT [G1] 임시테이블 4종 · 인덱스 — 없으면 10 이 만든다 (있으면 건너뜀)
SELECT T.COLUMN_VALUE OBJ, NVL((SELECT 'EXISTS' FROM USER_OBJECTS O WHERE O.OBJECT_NAME = T.COLUMN_VALUE AND ROWNUM = 1), '없음') ST
  FROM TABLE(SYS.ODCIVARCHAR2LIST({gt_in}, '{IDX}')) T;
PROMPT [G2] 권한·시노님 기준 = 기존 {MIRROR} (10 이 같은 대상에게 같은 권한을 준다) — 사내: 권한 {mirror_grants} · 시노님 소유자 {mirror_syn}
SELECT 'GRANT' KIND, GRANTEE WHO, LISTAGG(PRIVILEGE, ',') WITHIN GROUP (ORDER BY PRIVILEGE) WHAT FROM USER_TAB_PRIVS WHERE TABLE_NAME = '{MIRROR}' GROUP BY GRANTEE
UNION ALL
SELECT 'SYNONYM', OWNER, SYNONYM_NAME FROM ALL_SYNONYMS WHERE TABLE_OWNER = USER AND TABLE_NAME = '{MIRROR}';
PROMPT [G3] 품목 원천 SCM_MST_ITEM_SN — 82 사업부 활성 행수 (사내 {'{:,}'.format(76492)}행 · 0 이면 임시테이블이 비어 검증·RTF_SYS_RP 가 동작하지 않는다)
SELECT DIVISION_ID, COUNT(*) ACTIVE_ROWS, COUNT(DISTINCT ITEM_ID) ACTIVE_ITEMS FROM SCM_MST_ITEM_SN WHERE ACTIVE_FLAG = 'Y' AND DIVISION_ID = '82' GROUP BY DIVISION_ID;
""", encoding="utf-8")

(A / "05_BACKUP_CLOUD_SOURCE.sql").write_text(f"""-- 05_BACKUP_CLOUD_SOURCE.sql — 적용 직전 클라우드 SPEC+BODY 원문 보관 (비파괴 · 멱등) [{TAG}]
SET SERVEROUTPUT ON
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME='{BAK}';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[CREATE TABLE {BAK} AS
      SELECT NAME, TYPE, LINE, TEXT, SYSDATE AS BAK_DATE FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE IN ('PACKAGE','PACKAGE BODY')]';
    DBMS_OUTPUT.PUT_LINE('{PKG} SOURCE BACKUP CREATED');
  ELSE
    DBMS_OUTPUT.PUT_LINE('{PKG} SOURCE BACKUP EXISTS - SKIP');
  END IF;
END;
/
SELECT TYPE, COUNT(*) LINES FROM {BAK} GROUP BY TYPE;
""", encoding="utf-8")

(A / "10_DDL_GT_DMF3_ITEM_SINGLE.sql").write_text(f"""-- 10_DDL_GT_DMF3_ITEM_SINGLE.sql — 저장 멤버 품목 원천 임시테이블 4종 + 인덱스 + 권한·시노님 (멱등 — 있으면 건너뜀) [{TAG}]
--  AS-IS [E20260720-000270] #TEMP_DM_MST_ITEM_SINGLE_ORI_V / _A_V / _B_V / _V_ALL 대응. 컬럼 = 사내 ZIOUI1 딕셔너리 {now} 조회.
--  권한·시노님은 접속 DB 의 기존 {MIRROR} 것을 그대로 따른다 (앱 계정 이름이 환경마다 달라도 됨).
--  ⚠ 11 BODY 보다 먼저 실행 — 테이블이 없으면 BODY 가 컴파일되지 않는다.
SET SERVEROUTPUT ON
DECLARE
    PROCEDURE MK ( P_NAME VARCHAR2, P_DDL VARCHAR2 ) IS
        N PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO N FROM USER_TABLES WHERE TABLE_NAME = P_NAME;
        IF N = 0 THEN
            EXECUTE IMMEDIATE P_DDL;
            DBMS_OUTPUT.PUT_LINE('CREATED ' || P_NAME);
        ELSE
            DBMS_OUTPUT.PUT_LINE('EXISTS  ' || P_NAME || ' - SKIP');
        END IF;
    END;
BEGIN
""" + "\n\n".join(ddl_blocks) + f"""
END;
/
DECLARE
    N PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO N FROM USER_INDEXES WHERE INDEX_NAME = '{IDX}';
    IF N = 0 THEN
        EXECUTE IMMEDIATE 'CREATE INDEX {IDX} ON GT_DMF3_ITEM_SINGLE_V_ALL ( {idx_cols} )';
        DBMS_OUTPUT.PUT_LINE('CREATED {IDX}');
    ELSE
        DBMS_OUTPUT.PUT_LINE('EXISTS  {IDX} - SKIP');
    END IF;
END;
/
DECLARE
    N PLS_INTEGER;
BEGIN
    FOR T IN ( SELECT COLUMN_VALUE AS NM FROM TABLE(SYS.ODCIVARCHAR2LIST({gt_in})) ) LOOP
        FOR G IN ( SELECT GRANTEE, PRIVILEGE FROM USER_TAB_PRIVS WHERE TABLE_NAME = '{MIRROR}' ) LOOP
            EXECUTE IMMEDIATE 'GRANT ' || G.PRIVILEGE || ' ON ' || T.NM || ' TO ' || G.GRANTEE;
        END LOOP;
        FOR S IN ( SELECT OWNER FROM ALL_SYNONYMS WHERE TABLE_OWNER = USER AND TABLE_NAME = '{MIRROR}' AND OWNER <> 'PUBLIC' ) LOOP
            SELECT COUNT(*) INTO N FROM ALL_SYNONYMS WHERE OWNER = S.OWNER AND SYNONYM_NAME = T.NM;
            IF N = 0 THEN
                EXECUTE IMMEDIATE 'CREATE SYNONYM ' || S.OWNER || '.' || T.NM || ' FOR ' || USER || '.' || T.NM;
            END IF;
        END LOOP;
    END LOOP;
END;
/
PROMPT [10-V] 임시테이블 4종 (전부 Y / SYS$SESSION) · 컬럼 수 사내 {gt_cols}
SELECT T.TABLE_NAME, T.TEMPORARY, T.DURATION, (SELECT COUNT(*) FROM USER_TAB_COLUMNS C WHERE C.TABLE_NAME = T.TABLE_NAME) COLS
  FROM USER_TABLES T WHERE T.TABLE_NAME IN ({gt_in}) ORDER BY 1;
""", encoding="utf-8")

(A / "11_PKG_DMF0003_BODY.sql").write_text(
    f"-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE BODY LAST_DDL={s_body[0]} FETCHED={now} DB=ZIOUI1 STATUS=VALID\n"
    f"-- [{TAG}] {PKG} BODY 전체본 (사내 누적본) — P_DMF0003_SAVE_MKT_FCST 품목 원천 뷰 → 임시테이블 (초기화 5줄 · 3단 적재 87줄 · 참조 6곳)\n"
    "SET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + body.rstrip() + f"\n/\nSHOW ERRORS PACKAGE BODY {PKG}\n",
    encoding="utf-8")

diff = ["-- ===== PKG_DMF0003 BODY — P_DMF0003_SAVE_MKT_FCST 품목 원천 뷰 → 임시테이블",
        "--   '-' 줄 = 현재(변경 전) 원문 / '+' 줄 = 바꿀 내용 / 공백 시작 줄 = 위치 확인용 앞뒤 원문. @@ 의 줄 번호는 사내 기준(10-02 20:31:56 판)."]
diff += [l.rstrip("\n") for l in difflib.unified_diff(base.split("\n"), body.split("\n"), "변경 전", "변경 후", n=3, lineterm="")]
(A / "12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt").write_text(
    f"-- 12_CHANGE_BLOCK_FOR_MANUAL_MERGE — 지문이 다를 때 클라우드 BODY 에 손으로 옮길 변경분 전문 [{TAG}] (실행 파일 아님)\n" + "\n".join(diff) + "\n", encoding="utf-8")
n_hunks = sum(1 for l in diff if l.startswith("@@"))

(A / "13_RECOMPILE_DEPENDENTS.sql").write_text(f"""-- 13_RECOMPILE_DEPENDENTS.sql — 패키지 본체·의존 INVALID 객체 재컴파일 (멱등 · 안전망) [{TAG}]
--  사내 의존 목록: {deps or '(없음)'}
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  v_sql VARCHAR2(400);
BEGIN
  FOR r IN (SELECT O.OBJECT_NAME NAME, O.OBJECT_TYPE TYPE FROM USER_OBJECTS O
             WHERE O.STATUS <> 'VALID'
               AND (O.OBJECT_NAME = '{PKG}'
                    OR EXISTS (SELECT 1 FROM USER_DEPENDENCIES D WHERE D.NAME = O.OBJECT_NAME AND D.TYPE = O.OBJECT_TYPE
                                AND D.REFERENCED_NAME = '{PKG}' AND D.REFERENCED_TYPE = 'PACKAGE'))
             ORDER BY CASE O.OBJECT_TYPE WHEN 'PACKAGE' THEN 1 WHEN 'PACKAGE BODY' THEN 2 ELSE 3 END, O.OBJECT_NAME) LOOP
    v_sql := CASE r.TYPE WHEN 'PACKAGE BODY' THEN 'ALTER PACKAGE ' || r.NAME || ' COMPILE BODY'
                         WHEN 'PACKAGE'      THEN 'ALTER PACKAGE ' || r.NAME || ' COMPILE'
                         ELSE 'ALTER ' || r.TYPE || ' ' || r.NAME || ' COMPILE' END;
    BEGIN
      EXECUTE IMMEDIATE v_sql;
      DBMS_OUTPUT.PUT_LINE('OK   ' || v_sql);
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAIL ' || v_sql || ' : ' || SQLERRM);
    END;
  END LOOP;
END;
/
PROMPT [13-V] 패키지 상태 (전부 VALID 이어야 함)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = '{PKG}' ORDER BY 1, 2;
""", encoding="utf-8")

(A / "90_VERIFY.sql").write_text(f"""-- 90_VERIFY.sql — 적용 후 단언 (조회 전용) [{TAG}]
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A60
PROMPT [V1] VALID · 오류 0
SELECT O.OBJECT_NAME, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       CASE WHEN O.STATUS='VALID' AND (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE)=0
            THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME = '{PKG}' ORDER BY 1, 2;
PROMPT [V2] BODY — ITEMGT 표시 {MARKS}줄 · 임시테이블 참조 {n_gt_all}줄 · ASISPARITY 표시 0 · 실행 코드의 SCM_MGR.DM_MST_ITEM_SINGLE_V 참조 {n_view_live}줄 (전체본 적용 시 지문 {after[0]}/{after[1]})
SELECT LN || '/' || CH BODY_FP, M ITEMGT_MARK, G GT_ALL_REF, A ASISPARITY_MARK, V VIEW_REF_LIVE,
       CASE WHEN M = {MARKS} AND G = {n_gt_all} AND A = 0 AND V = {n_view_live} THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM ({fp_sql('PACKAGE BODY')}),
       (SELECT SUM(CASE WHEN TEXT LIKE '%[{TAG}]%' THEN 1 ELSE 0 END) M,
               SUM(CASE WHEN TEXT LIKE '%{GT_ALL}%' THEN 1 ELSE 0 END) G,
               SUM(CASE WHEN TEXT LIKE '%[{OLD_TAG}]%' THEN 1 ELSE 0 END) A,
               SUM(CASE WHEN REGEXP_LIKE(TEXT, 'SCM_MGR\\.DM_MST_ITEM_SINGLE_V([^_A-Z0-9]|$)') AND LTRIM(TEXT) NOT LIKE '--%' THEN 1 ELSE 0 END) V
          FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY');
PROMPT [V3] 임시테이블 4종 (세션 유지형) · 인덱스
SELECT T.GT_CNT, T.SESSION_GT_CNT, I.IDX_CNT,
       CASE WHEN T.GT_CNT = 4 AND T.SESSION_GT_CNT = 4 AND I.IDX_CNT = 1 THEN 'PASS' ELSE '❌ FAIL — 10 실행' END JUDGE
  FROM (SELECT COUNT(*) GT_CNT, NVL(SUM(CASE WHEN TEMPORARY = 'Y' AND DURATION = 'SYS$SESSION' THEN 1 ELSE 0 END), 0) SESSION_GT_CNT
          FROM USER_TABLES WHERE TABLE_NAME IN ({gt_in})) T,
       (SELECT COUNT(*) IDX_CNT FROM USER_INDEXES WHERE INDEX_NAME = '{IDX}') I;
PROMPT [V4] 임시테이블 권한·시노님 = 기존 {MIRROR} 과 같은 대상·같은 수 (차이 0행이어야 함)
SELECT T.COLUMN_VALUE GT, R.GRANTEE, R.PRIVILEGE, '❌ 권한 누락 — 10 재실행' JUDGE
  FROM TABLE(SYS.ODCIVARCHAR2LIST({gt_in})) T CROSS JOIN (SELECT GRANTEE, PRIVILEGE FROM USER_TAB_PRIVS WHERE TABLE_NAME = '{MIRROR}') R
 WHERE NOT EXISTS (SELECT 1 FROM USER_TAB_PRIVS P WHERE P.TABLE_NAME = T.COLUMN_VALUE AND P.GRANTEE = R.GRANTEE AND P.PRIVILEGE = R.PRIVILEGE)
UNION ALL
SELECT T.COLUMN_VALUE, S.OWNER, 'SYNONYM', '❌ 시노님 누락 — 10 재실행'
  FROM TABLE(SYS.ODCIVARCHAR2LIST({gt_in})) T CROSS JOIN (SELECT OWNER FROM ALL_SYNONYMS WHERE TABLE_OWNER = USER AND TABLE_NAME = '{MIRROR}' AND OWNER <> 'PUBLIC') S
 WHERE NOT EXISTS (SELECT 1 FROM ALL_SYNONYMS X WHERE X.OWNER = S.OWNER AND X.SYNONYM_NAME = T.COLUMN_VALUE);
PROMPT [V5] 앱 계정 패키지 실행 권한 유지 (사내: {grants})
SELECT TABLE_NAME, GRANTEE, PRIVILEGE FROM USER_TAB_PRIVS WHERE TABLE_NAME = '{PKG}' ORDER BY 1, 2;
PROMPT [V6] 의존 객체 INVALID 0
SELECT COUNT(*) INVALID_DEPENDENTS, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE '❌ FAIL — 13 실행' END JUDGE
  FROM USER_DEPENDENCIES D JOIN USER_OBJECTS O ON O.OBJECT_NAME=D.NAME AND O.OBJECT_TYPE=D.TYPE
 WHERE D.REFERENCED_NAME = '{PKG}' AND D.REFERENCED_TYPE='PACKAGE' AND O.STATUS<>'VALID';
PROMPT [V7] 82 사업부 품목 — 임시테이블 방식 품목 수 = 뷰의 활성 품목 수 (사내 38,677 = 38,677 · 조회 전용)
SELECT G.CNT GT_WAY_ITEMS, V.CNT VIEW_ACTIVE_ITEMS, CASE WHEN G.CNT = V.CNT AND G.CNT > 0 THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM (SELECT COUNT(*) CNT FROM (SELECT DIVISION_ID, ITEM_ID FROM SCM_MST_ITEM_SN WHERE DIVISION_ID = '82' AND ACTIVE_FLAG = 'Y' GROUP BY DIVISION_ID, ITEM_ID)) G,
       (SELECT COUNT(*) CNT FROM DM_MST_ITEM_SINGLE_V WHERE DIVISION_ID = '82' AND ACTIVE_FLAG = 'Y') V;
""", encoding="utf-8")

(A / "98_ROLLBACK_FROM_CLOUD_BACKUP.sql").write_text(f"""-- 98_ROLLBACK_FROM_CLOUD_BACKUP.sql — 05 보관본으로 SPEC→BODY 복원 (롤백 전용) [{TAG}]
--  임시테이블 4종은 남겨 둔다 (복원된 BODY 가 참조하지 않으며 비어 있음).
SET SERVEROUTPUT ON
DECLARE
  v CLOB;
BEGIN
  FOR t IN (SELECT 'PACKAGE' TYP FROM DUAL UNION ALL SELECT 'PACKAGE BODY' FROM DUAL) LOOP
    DBMS_LOB.CREATETEMPORARY(v, TRUE);
    FOR r IN (SELECT TEXT FROM {BAK} WHERE NAME='{PKG}' AND TYPE=t.TYP ORDER BY LINE) LOOP
      DBMS_LOB.APPEND(v, r.TEXT);
    END LOOP;
    IF DBMS_LOB.GETLENGTH(v) > 0 THEN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v;
      DBMS_OUTPUT.PUT_LINE('REBUILT {PKG} ' || t.TYP);
    ELSE
      DBMS_OUTPUT.PUT_LINE('SKIP {PKG} ' || t.TYP || ' (no backup)');
    END IF;
    DBMS_LOB.FREETEMPORARY(v);
  END LOOP;
END;
/
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = '{PKG}' ORDER BY 1, 2;
""", encoding="utf-8")

print(f"{PKG} BODY 원천 LAST_DDL={s_body[0]} 지문 BEFORE={before} AFTER={after} | SPEC LAST_DDL={s_spec[0]} 지문={spec_fp}")
print(f"의존={deps} 권한={grants} | 임시테이블 컬럼수={gt_cols} 인덱스=({idx_cols}) | 기준 {MIRROR} 권한={mirror_grants} 시노님={mirror_syn}")
print(f"BODY 줄수={len(body.split(chr(10)))} 크기={len(body.encode('utf-8')):,}B | 임시테이블 참조={n_gt_all} 뷰 참조(실행) 전/후={n_view_base}/{n_view_live} | 변경 블록={n_hunks}")
cn.close()
