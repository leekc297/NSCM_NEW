# -*- coding: utf-8 -*-
"""RTF 최근 단가 클라우드 패키지 생성기 — 패치형. 이 DB 의 USER_SOURCE 를 읽어 앵커 위치에 블록만 넣는다(사내 전체본 복사 안 함).
블록 원천 = _apply_corporate/RTF_LATEST_PRICE_20261102/patch_def.py. 앵커·블록은 ASCII(주석만 영문으로 바꿈)."""
import os, re, sys, time
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
SRC = r'C:\Projects\NSCM\_artifacts\_apply_corporate\RTF_LATEST_PRICE_20261102'
sys.path.insert(0, SRC)
import dbconn
import patch_def as P

HERE = os.path.dirname(os.path.abspath(__file__))
TOKEN = 'E20261102-RTFLATESTPRICE'
BK = 'ZB_RTFLP_SRC_20261102'
NOTE = f'/* [{TOKEN}] RTF week without price: use latest earlier price for SalesAmt */'


def ascii_block(b):
    out = re.sub(r'/\*.*?\*/', lambda m: NOTE if not m.group(0).isascii() else m.group(0), b, flags=re.S)
    assert out.isascii(), out[:200]
    return out


AN_SINGLE = ('        BEGIN\n            DELETE\n              FROM DM_PLN_SALES_PLAN A\n             WHERE EXISTS ( SELECT 1\n'
             '                              FROM GT_PRDM_SALES_PLAN_TEMP_SINGLE B')
# (객체, 유형, [(범위 시작, 범위 끝, 앵커, 'L'=앵커 줄 다음 | 'B'=앵커 앞, 블록)])
OBJS = [
    ('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PROCEDURE', [(None, None, "' : A007--'", 'L', ascii_block(P.BATCH_BLOCK))]),
    ('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE', 'PROCEDURE', [
        (None, None, "' : A006--'", 'L', ascii_block(P.SAVE_DELETE)),  # 뒤 위치부터 넣어 앞 위치가 밀리지 않게 한다
        (None, None, "' : A003--'", 'L', ascii_block(P.SAVE_BLOCK))]),
]
# 2026-11-02 사용자 지시로 대상 제외. 이미 적용된 DB 에서 블록만 지운다(백업표 불필요).
REMOVED = [('PKG_DMF0020', 'PACKAGE BODY', ascii_block(P.SINGLE_BLOCK)), ('PKG_DMF0003', 'PACKAGE BODY', ascii_block(P.SYNC_BLOCK))]


def lit(text, indent='        '):
    parts = text.split('\n')
    out = []
    for i, p in enumerate(parts):
        q = "'" + p.replace("'", "''") + "'"
        if i < len(parts) - 1:
            out.append(q + ' || CHR(10)')
        elif p:
            out.append(q)
    return (' ||\n' + indent).join(out) if out else "''"


def expected(asis, items):
    """파이썬으로 같은 치환을 재현 — 사내 앵커 1건 검증 + 결과 원문 대조용."""
    out = asis
    for beg, end, tok, mode, block in items:
        lo = out.index(beg) if beg else 0
        hi = out.index(end, lo) if end else len(out)
        assert out.count(tok, lo, hi) == 1, (tok[:40], out.count(tok, lo, hi))
        pos = out.index(tok, lo, hi)
        pos = out.index('\n', pos + len(tok) - 1) + 1 if mode == 'L' else pos
        if mode == 'L' and tok.endswith('\n'):
            pos = out.index(tok, lo, hi) + len(tok)
        out = out[:pos] + block + out[pos:]
    return out


COMMON = f"""    c_mark CONSTANT VARCHAR2(40) := '{TOKEN}';
    FUNCTION src(p_n VARCHAR2, p_t VARCHAR2) RETURN CLOB IS
        v CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v, TRUE);
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = p_n AND TYPE = p_t ORDER BY LINE) LOOP
            DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
        END LOOP;
        RETURN v;
    END;
    PROCEDURE compile_src(p_sql CLOB) IS   -- ORA-24344(컴파일 오류)만 아래 STATUS 로 판정, 그 외 오류는 그대로 올린다
    BEGIN
        EXECUTE IMMEDIATE TO_CLOB('CREATE OR REPLACE ') || p_sql;
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE <> -24344 THEN RAISE; END IF;
    END;
    FUNCTION st(p_n VARCHAR2, p_t VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(30);
    BEGIN
        SELECT STATUS INTO v FROM USER_OBJECTS WHERE OBJECT_NAME = p_n AND OBJECT_TYPE = p_t;
        RETURN v;
    END;
"""


def gen_apply(stamps):
    h = ''.join(f'-- SOURCE-FRESH: SCM_MGR.{n} {t} LAST_DDL={d} FETCHED={f} DB=ZIOUI1\n' for n, t, d, f in stamps)
    txt = h + f"""-- 10_APPLY [{TOKEN}] (SCM_MGR, whole-file F5, no input, idempotent)
-- RTF week without a price row: SalesAmt uses the latest earlier price (>0). UI input validation is unchanged. Price ledgers are not written.
-- Reads this DB's USER_SOURCE and inserts blocks at anchors only. Marker present = SKIP. Anchor count != 1 = stop with source unchanged.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = '{BK}';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE {BK} (OBJ_NAME VARCHAR2(128) NOT NULL, OBJ_TYPE VARCHAR2(30) NOT NULL, SRC CLOB NOT NULL, SAVED_AT DATE NOT NULL, CONSTRAINT PK_{BK[:20]} PRIMARY KEY (OBJ_NAME, OBJ_TYPE))';
    END IF;
END;
/
"""
    for n, t, items in OBJS:
        decl = []
        for i, (beg, end, tok, mode, block) in enumerate(items, 1):
            decl.append(f"""    -- patch {i}
    lo := 1; hi := DBMS_LOB.GETLENGTH(v_new) + 1;
    {"lo := DBMS_LOB.INSTR(v_new, " + repr(beg) + "); hi := DBMS_LOB.INSTR(v_new, " + repr(end) + ", lo);" if beg else ""}
    v_tok := {lit(tok)};
    pos := DBMS_LOB.INSTR(v_new, v_tok, lo);
    IF lo = 0 OR hi = 0 OR pos = 0 OR pos >= hi OR (DBMS_LOB.INSTR(v_new, v_tok, pos + 1) BETWEEN 1 AND hi - 1) THEN
        RAISE_APPLICATION_ERROR(-20001, '{n} anchor {i} not exactly 1 - source unchanged. Send this result.');
    END IF;
    {"pos := DBMS_LOB.INSTR(v_new, CHR(10), pos + LENGTH(v_tok) - 1) + 1;" if mode == 'L' and not tok.endswith(chr(10)) else ("pos := pos + LENGTH(v_tok);" if mode == 'L' else "")}
    v_blk := {lit(block)};
    v_new := SUBSTR(v_new, 1, pos - 1) || v_blk || SUBSTR(v_new, pos);""")
        txt += f"""DECLARE
    c_n CONSTANT VARCHAR2(128) := '{n}';
    c_t CONSTANT VARCHAR2(30)  := '{t}';
    v_src CLOB; v_new CLOB; lo PLS_INTEGER; hi PLS_INTEGER; pos PLS_INTEGER;
    v_tok VARCHAR2(4000); v_blk VARCHAR2(32767); n PLS_INTEGER;
{COMMON}BEGIN
    v_src := src(c_n, c_t);
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - already applied: ' || c_n);
        RETURN;
    END IF;
    v_new := v_src;
{chr(10).join(decl)}
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM {BK} WHERE OBJ_NAME = :1 AND OBJ_TYPE = :2' INTO n USING c_n, c_t;
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'INSERT INTO {BK} VALUES (:1, :2, :3, SYSDATE)' USING c_n, c_t, v_src;
        COMMIT;
    END IF;
    compile_src(v_new);
    IF st(c_n, c_t) <> 'VALID' THEN
        compile_src(v_src);
        RAISE_APPLICATION_ERROR(-20002, c_n || ' compile failed - source restored (status now ' || st(c_n, c_t) || ')');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED - ' || c_n || ' VALID');
END;
/
"""
    return txt


def gen_remove():
    txt = f"""-- 97_REMOVE [{TOKEN}] (SCM_MGR, whole-file F5, no input, idempotent) removes the block from PKG_DMF0020 and PKG_DMF0003: both are now out of scope.
-- No marker = SKIP. Marker present but block text differs = stop with source unchanged. Needs no backup table.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
"""
    for n, t, block in REMOVED:
        txt += f"""DECLARE
    c_n CONSTANT VARCHAR2(128) := '{n}';
    c_t CONSTANT VARCHAR2(30)  := '{t}';
    v_src CLOB; v_new CLOB; v_blk VARCHAR2(32767);
{COMMON}BEGIN
    v_src := src(c_n, c_t);
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - no block: ' || c_n);
        RETURN;
    END IF;
    v_blk := {lit(block)};
    v_new := REPLACE(v_src, v_blk, '');
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 OR DBMS_LOB.GETLENGTH(v_src) - DBMS_LOB.GETLENGTH(v_new) <> LENGTH(v_blk) THEN
        RAISE_APPLICATION_ERROR(-20003, c_n || ' block text differs - source unchanged. Send this result.');
    END IF;
    compile_src(v_new);
    IF st(c_n, c_t) <> 'VALID' THEN
        compile_src(v_src);
        RAISE_APPLICATION_ERROR(-20002, c_n || ' compile failed - source restored (status now ' || st(c_n, c_t) || ')');
    END IF;
    DBMS_OUTPUT.PUT_LINE('REMOVED - ' || c_n || ' VALID');
END;
/
"""
    return txt


def gen_rollback():
    txt = f"""-- 99_ROLLBACK [{TOKEN}] (SCM_MGR, whole-file F5, idempotent) restores the source saved by 10_APPLY. No marker = SKIP.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
"""
    for n, t, _ in OBJS:
        txt += f"""DECLARE
    c_n CONSTANT VARCHAR2(128) := '{n}';
    c_t CONSTANT VARCHAR2(30)  := '{t}';
    v_src CLOB;
{COMMON}BEGIN
    IF DBMS_LOB.INSTR(src(c_n, c_t), c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - not applied: ' || c_n);
        RETURN;
    END IF;
    EXECUTE IMMEDIATE 'SELECT SRC FROM {BK} WHERE OBJ_NAME = :1 AND OBJ_TYPE = :2' INTO v_src USING c_n, c_t;
    compile_src(v_src);
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK - ' || c_n || ' ' || st(c_n, c_t));
END;
/
"""
    return txt


NAMES = ','.join(f"'{n}'" for n, _, _ in OBJS)
PRE = f"""-- 00_PRECHECK (read only, whole-file F5). P1 = 2 VALID objects. P2 = no row for the two procedures before applying. P3 = 6 rows, each ANCHOR_LINES 1.
SELECT 'P1' AS CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME IN ({NAMES}) AND OBJECT_TYPE IN ('PROCEDURE', 'PACKAGE BODY') ORDER BY 2, 3;
SELECT 'P2' AS CHK, NAME, TYPE, COUNT(*) AS MARKER_LINES FROM USER_SOURCE WHERE TEXT LIKE '%{TOKEN}%' GROUP BY NAME, TYPE ORDER BY 2;
SELECT 'P3' AS CHK, NAME, COUNT(*) AS ANCHOR_LINES, SUBSTR(MIN(TEXT), 1, 60) AS SAMPLE
  FROM USER_SOURCE WHERE TYPE = 'PROCEDURE' AND NAME IN ('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE')
   AND (TEXT LIKE '%'' : A007--''%' OR TEXT LIKE '%'' : A006--''%' OR TEXT LIKE '%'' : A003--''%') GROUP BY NAME, SUBSTR(TEXT, INSTR(TEXT, ' : A0'), 8) ORDER BY 2, 4;
"""
VERIFY = f"""-- 90_VERIFY (read only). V1 = 2 rows: LOCAL_KRW 1, SAVE 2. PKG_DMF0020 and PKG_DMF0003 must not appear. V2 = VALID. V3 = 0 rows.
SELECT 'V1' AS CHK, NAME, TYPE, COUNT(*) AS MARKER_LINES FROM USER_SOURCE WHERE TEXT LIKE '%{TOKEN}%' GROUP BY NAME, TYPE ORDER BY 2;
SELECT 'V2' AS CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME IN ({NAMES}) AND OBJECT_TYPE IN ('PROCEDURE', 'PACKAGE BODY') ORDER BY 2, 3;
SELECT 'V3' AS CHK, NAME, TYPE, LINE, SUBSTR(TEXT, 1, 200) AS ERR FROM USER_ERRORS WHERE NAME IN ({NAMES}) ORDER BY 2, 3, SEQUENCE;
"""
VERIFY_RB = f"""-- 99_VERIFY_ROLLED_BACK (read only). R1 = 0 rows. R2 = VALID.
SELECT 'R1' AS CHK, NAME, TYPE, COUNT(*) AS MARKER_LINES FROM USER_SOURCE WHERE TEXT LIKE '%{TOKEN}%' GROUP BY NAME, TYPE;
SELECT 'R2' AS CHK, OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME IN ({NAMES}) AND OBJECT_TYPE IN ('PROCEDURE', 'PACKAGE BODY') ORDER BY 2, 3;
"""
CLEAN = f"""-- 98_CLEANUP (after deciding to keep or after rollback) drops the source backup table. Rollback is impossible afterwards.
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = '{BK}';
    IF n = 1 THEN
        EXECUTE IMMEDIATE 'DROP TABLE {BK} PURGE';
        DBMS_OUTPUT.PUT_LINE('DROPPED {BK}');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SKIP - no {BK}');
    END IF;
END;
/
"""
TARGET = """-- 95_TARGET_ROWS (read only). RTF_SYS_RP rows from this week with no LOC price row at their bucket but an earlier price (>0): these get the new amount at the next batch.
WITH W AS (
  SELECT D.DIVISION_ID, D.PROJECT_CODE, D.SCM_SITE_ID, D.ITEM_ID, D.DOM_EXP, D.FCST_TYPE, D.INCOTERMS, D.PLANT_SITE_ID, D.CELL_PROD_SITE_ID, D.YYYYMMDD, C.BASIS_START_DATE AS BK, D.QTY
    FROM DM_PLN_CFM_MKT_DEMAND_PLAN D JOIN SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD = D.YYYYMMDD
   WHERE D.MEASURE = 'RTF_SYS_RP' AND D.QTY <> 0 AND D.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
)
SELECT W.DIVISION_ID, W.PROJECT_CODE, W.ITEM_ID, W.YYYYMMDD, W.BK, W.QTY
     , (SELECT MAX(P.YYYYMMDD) FROM DM_PLN_CFM_SELLING_PRICE P WHERE W.DIVISION_ID = '40' AND P.DIVISION_ID = W.DIVISION_ID AND P.END_CUSTOMER = W.PROJECT_CODE AND P.SCM_SITE_ID = W.SCM_SITE_ID AND P.ITEM_ID = W.ITEM_ID AND P.DOM_EXP = W.DOM_EXP AND P.FCST_TYPE = W.FCST_TYPE AND P.INCOTERMS = W.INCOTERMS AND P.PLANT_SITE_ID = W.PLANT_SITE_ID AND P.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID AND P.MEASURE = 'LOC' AND P.PRICE > 0 AND P.YYYYMMDD < W.BK) AS PREV_40
     , (SELECT MAX(P.YYYYMMDD) FROM SCM_MST_FUTURE_PRICE P WHERE W.DIVISION_ID <> '40' AND P.DIVISION_ID = W.DIVISION_ID AND P.PROJECT_CODE = W.PROJECT_CODE AND P.SCM_SITE_ID = W.SCM_SITE_ID AND P.ITEM_ID = W.ITEM_ID AND P.DOM_EXP = W.DOM_EXP AND P.FCST_TYPE = W.FCST_TYPE AND P.INCOTERMS = W.INCOTERMS AND P.PLANT_SITE_ID = W.PLANT_SITE_ID AND P.MEASURE = 'LOC' AND P.PRICE > 0 AND P.YYYYMMDD < W.BK) AS PREV_OTHER
  FROM W
 WHERE NOT EXISTS (SELECT 1 FROM DM_PLN_CFM_SELLING_PRICE X WHERE W.DIVISION_ID = '40' AND X.DIVISION_ID = W.DIVISION_ID AND X.END_CUSTOMER = W.PROJECT_CODE AND X.SCM_SITE_ID = W.SCM_SITE_ID AND X.ITEM_ID = W.ITEM_ID AND X.DOM_EXP = W.DOM_EXP AND X.FCST_TYPE = W.FCST_TYPE AND X.INCOTERMS = W.INCOTERMS AND X.PLANT_SITE_ID = W.PLANT_SITE_ID AND X.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID AND X.MEASURE = 'LOC' AND X.YYYYMMDD = W.BK)
   AND NOT EXISTS (SELECT 1 FROM SCM_MST_FUTURE_PRICE X WHERE W.DIVISION_ID <> '40' AND X.DIVISION_ID = W.DIVISION_ID AND X.PROJECT_CODE = W.PROJECT_CODE AND X.SCM_SITE_ID = W.SCM_SITE_ID AND X.ITEM_ID = W.ITEM_ID AND X.DOM_EXP = W.DOM_EXP AND X.FCST_TYPE = W.FCST_TYPE AND X.INCOTERMS = W.INCOTERMS AND X.PLANT_SITE_ID = W.PLANT_SITE_ID AND X.MEASURE = 'LOC' AND X.YYYYMMDD = W.BK)
 ORDER BY 1, 2, 3, 4;
"""


def main():
    cx = dbconn.connect('tobe', dbconn.load_cfg()); c = cx.cursor()
    c.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); now = c.fetchone()[0]
    stamps = []
    for n, t, items in OBJS:
        c.execute("select to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') from all_objects where owner='SCM_MGR' and object_name=:n and object_type=:t", n=n, t=t)
        stamps.append((n, t, c.fetchone()[0], now))
        asis = open(os.path.join(SRC, f'{n}.ASIS.txt'), encoding='utf-8', newline='').read()
        exp = expected(asis, items)
        # FRESH-GATE: 생성 직전 DB 원문을 다시 읽어 기준본(ASIS) 또는 적용 결과(기대값)와 같은지 확인. 다르면 타 작업 변경이므로 중단.
        c.execute("select text from all_source where owner='SCM_MGR' and name=:n and type=:t order by line", n=n, t=t)
        live = ''.join(r[0] for r in c.fetchall())
        bare = lambda s: re.sub(r'[\s"]+', ' ', s.partition('\n')[0]).strip() + '\n' + s.partition('\n')[2].rstrip()
        marked = TOKEN in live
        assert marked or bare(live) == bare(asis), f'FRESH-GATE 실패: {n} 기준본 후 원문 변경'
        open(os.path.join(HERE, f'_expected_{n}.txt'), 'w', encoding='utf-8', newline='').write(exp)
    d = os.path.join(HERE, 'A_DB'); os.makedirs(d, exist_ok=True)
    for name, text in (('00_PRECHECK_CLOUD.sql', PRE), ('10_APPLY_PATCH.sql', gen_apply(stamps)), ('90_VERIFY_KEEP.sql', VERIFY), ('95_TARGET_ROWS.sql', TARGET),
                       ('98_CLEANUP_BACKUP.sql', CLEAN), ('99_ROLLBACK_PATCH.sql', gen_rollback()), ('99_VERIFY_ROLLED_BACK.sql', VERIFY_RB), ('97_REMOVE_PKG_DMF0020_DMF0003.sql', gen_remove())):
        open(os.path.join(d, name), 'w', encoding='utf-8', newline='\n').write(text)
        print(name, len(text))


main()
