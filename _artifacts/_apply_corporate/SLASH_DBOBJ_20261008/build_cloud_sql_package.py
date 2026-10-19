# -*- coding: utf-8 -*-
"""[E20261008-SLASHOBJ] 클라우드 SQL-only 패키지 생성 (python 없이 SQL Developer / SQLcl / SQL*Plus 에서 파일 전체 실행)
   페이로드 = 05_CLOUD_PAYLOAD_corp/ (build_payload.py 가 만든 '지금 사내에 적용된 원문' 스냅샷) + payload_manifest.json
   생성:
     01_CLOUD_BACKUP_TABLE.sql          현재 클라우드 원문을 SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 (실행 회차 BAK_RUN) 에 일괄 백업 + INVALID 기준선
     01b_CLOUD_BACKUP_EXPORT_JSONL.sql  백업 테이블 최신 회차 → JSON Lines 파일로 spool (00_CLOUD_BACKUP_CLOUD.jsonl)
     03_CLOUD_APPLY_sqlplus/*.sql · 03_CLOUD_APPLY_ALL.sql · 03_CLOUD_APPLY_ONEFILE.sql   사내 적용본 CREATE OR REPLACE 일괄 적용
     03b_CLOUD_RECOMPILE_INVALID.sql    적용 뒤 새로 INVALID 된 객체(기준선 밖) 재컴파일 2회
     04_CLOUD_VERIFY.sql                상태·에러·줄수·'-' 줄수 = 사내 적용본과 같은지 + 기준선 밖 INVALID
     99_CLOUD_ROLLBACK_FROM_BAKTABLE.sql           백업 테이블 최신 회차로 전체 원복
     99b_CLOUD_ROLLBACK_SELECTED_FROM_BAKTABLE.sql 지정 객체만 원복 (파일 안 목록에 이름 기입)
   FRESH-GATE: 01 백업은 03 적용 '직전' 같은 세션에서 실행하는 것이 원칙 (03 실패 객체 원복 기준 = 그 회차).
"""
import pathlib, json, datetime
HERE = pathlib.Path(__file__).resolve().parent
PAY = HERE / "05_CLOUD_PAYLOAD_corp"
BAK_TABLE = "SCM_MGR.ZZ_SLASHOBJ_BAK_20261008"
MARK = "[E20261008-SLASHOBJ]"
man = json.loads((HERE / "payload_manifest.json").read_text(encoding="utf-8"))
rows = man["objects"]
now = f"{datetime.datetime.now():%Y-%m-%d %H:%M}"
hdr = lambda title, extra="": f"-- {MARK} {title} · 생성 {now} · 대상 {len(rows)}객체(사내 현재 원문 스냅샷 {man['at'][:16]}) · SCM_MGR 접속 후 파일 전체 실행(F5)\n{extra}".rstrip() + "\n"
obj_list_sql = ",\n".join(f"        '{r['otype']}|{r['name']}'" for r in rows)

# ---------- 01 백업 테이블 ----------
backup_sql = hdr("01_CLOUD_BACKUP_TABLE — 현재 클라우드 원문 일괄 백업 → " + BAK_TABLE,
"""--   · 테이블이 없으면 생성(있으면 재사용) → 이번 실행 회차(BAK_RUN = 실행시각 14자리)로 96객체 원문(ALL_SOURCE 줄, VIEW 는 DBMS_METADATA DDL 줄)과 상태·LAST_DDL 적재
--   · 스키마 INVALID 기준선(OBJ_TYPE='#INVALID_BASELINE') 도 같은 회차에 적재 → 03b 재컴파일·04 검증의 '새로 INVALID' 판정 기준
--   · 여러 번 실행해도 회차만 늘어남(기존 회차 보존). 03 적용 직전에 실행할 것.""") + f"""
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
-- (1) 백업 테이블 생성 — 이미 있으면 재사용 (별도 블록: 뒤 블록의 정적 SQL 이 이 테이블을 참조하므로 먼저 존재해야 함)
BEGIN
    -- TEXT 는 VARCHAR2(4000)(ALL_SOURCE.TEXT 와 동일 한도) → INSERT…SELECT 한 번에 적재(수 초). 4,000 바이트를 넘는 VIEW DDL 줄만 PIECE 1..n 으로 분할(1,000자 단위) 저장.
    EXECUTE IMMEDIATE 'CREATE TABLE {BAK_TABLE} (BAK_RUN VARCHAR2(14) NOT NULL, OBJ_TYPE VARCHAR2(30) NOT NULL, OBJ_NAME VARCHAR2(200) NOT NULL, LINE NUMBER NOT NULL, PIECE NUMBER DEFAULT 1 NOT NULL, TEXT VARCHAR2(4000), STATUS VARCHAR2(10), LAST_DDL DATE, SRC_KIND VARCHAR2(6), BAK_AT DATE DEFAULT SYSDATE)';
    EXECUTE IMMEDIATE 'CREATE INDEX {BAK_TABLE}_IX ON {BAK_TABLE} (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, PIECE)';
    DBMS_OUTPUT.PUT_LINE('BACKUP TABLE CREATED: {BAK_TABLE}');
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE <> -955 THEN RAISE; END IF;   -- ORA-00955 이미 존재 → 재사용
    DBMS_OUTPUT.PUT_LINE('BACKUP TABLE EXISTS: {BAK_TABLE} (reuse)');
END;
/
-- (2) 이번 회차 백업 적재
DECLARE
    TYPE t_list IS TABLE OF VARCHAR2(200);
    v_list   t_list := t_list(
{obj_list_sql}
    );
    v_run    VARCHAR2(14) := TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS');
    v_t      VARCHAR2(30); v_n VARCHAR2(128); v_cnt NUMBER; v_st VARCHAR2(10); v_ddl_t DATE;
    v_clob   CLOB; v_pos NUMBER; v_next NUMBER; v_line NUMBER; v_len NUMBER;
    v_objs   NUMBER := 0; v_missing NUMBER := 0; v_lines NUMBER := 0;
    v_piece  VARCHAR2(4000); v_off NUMBER; v_pn NUMBER;
    -- VIEW DDL 의 한 줄(p_from 부터 p_amt 자)을 1,000자 조각(PIECE 1..n, ≤4,000 바이트)으로 INSERT. 빈 줄은 PIECE 1 에 NULL.
    PROCEDURE ins_ddl_line(p_t VARCHAR2, p_n VARCHAR2, p_line NUMBER, p_from NUMBER, p_amt NUMBER, p_st VARCHAR2, p_ddl DATE) IS
    BEGIN
        IF p_amt <= 0 THEN
            INSERT INTO {BAK_TABLE} (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, PIECE, TEXT, STATUS, LAST_DDL, SRC_KIND) VALUES (v_run, p_t, p_n, p_line, 1, NULL, p_st, p_ddl, 'ddl');
            RETURN;
        END IF;
        v_off := 0; v_pn := 0;
        WHILE v_off < p_amt LOOP
            v_pn := v_pn + 1;
            v_piece := DBMS_LOB.SUBSTR(v_clob, LEAST(1000, p_amt - v_off), p_from + v_off);
            INSERT INTO {BAK_TABLE} (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, PIECE, TEXT, STATUS, LAST_DDL, SRC_KIND) VALUES (v_run, p_t, p_n, p_line, v_pn, v_piece, p_st, p_ddl, 'ddl');
            v_off := v_off + 1000;
        END LOOP;
    END;
BEGIN
    FOR i IN 1 .. v_list.COUNT LOOP
        v_t := SUBSTR(v_list(i), 1, INSTR(v_list(i), '|') - 1);
        v_n := SUBSTR(v_list(i), INSTR(v_list(i), '|') + 1);
        SELECT COUNT(*) INTO v_cnt FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = v_n AND object_type = v_t;
        IF v_cnt = 0 THEN
            v_missing := v_missing + 1;
            INSERT INTO {BAK_TABLE} (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, TEXT, STATUS, SRC_KIND) VALUES (v_run, v_t, v_n, 0, NULL, 'MISSING', 'meta');
            CONTINUE;
        END IF;
        SELECT status, last_ddl_time INTO v_st, v_ddl_t FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = v_n AND object_type = v_t;
        v_objs := v_objs + 1;
        IF v_t = 'VIEW' THEN
            v_clob := DBMS_METADATA.GET_DDL('VIEW', v_n, 'SCM_MGR');
            v_len := DBMS_LOB.GETLENGTH(v_clob); v_pos := 1; v_line := 0;
            WHILE v_pos <= v_len LOOP
                v_next := DBMS_LOB.INSTR(v_clob, CHR(10), v_pos);
                v_line := v_line + 1;
                IF v_next = 0 THEN
                    ins_ddl_line(v_t, v_n, v_line, v_pos, v_len - v_pos + 1, v_st, v_ddl_t);
                    v_pos := v_len + 1;
                ELSE
                    ins_ddl_line(v_t, v_n, v_line, v_pos, v_next - v_pos, v_st, v_ddl_t);
                    v_pos := v_next + 1;
                END IF;
            END LOOP;
            v_lines := v_lines + v_line;
        ELSE
            INSERT INTO {BAK_TABLE} (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, PIECE, TEXT, STATUS, LAST_DDL, SRC_KIND)
            SELECT v_run, v_t, v_n, line, 1, text, v_st, v_ddl_t, 'source' FROM all_source WHERE owner = 'SCM_MGR' AND name = v_n AND type = v_t;
            v_lines := v_lines + SQL%ROWCOUNT;
        END IF;
    END LOOP;
    INSERT INTO {BAK_TABLE} (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, PIECE, TEXT, STATUS, SRC_KIND)
    SELECT v_run, '#INVALID_BASELINE', object_type || '|' || object_name, 0, 1, NULL, 'INVALID', 'meta' FROM all_objects WHERE owner = 'SCM_MGR' AND status = 'INVALID';
    v_cnt := SQL%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('BACKUP RUN=' || v_run || ' | objects=' || v_objs || ' | missing=' || v_missing || ' | lines=' || v_lines || ' | invalid_baseline=' || v_cnt);
END;
/
-- 회차별 요약 (가장 아래가 이번 회차)
SELECT 'BACKUP | run ' || bak_run || ' | at ' || TO_CHAR(MIN(bak_at), 'YYYY-MM-DD HH24:MI:SS') || ' | objects ' || COUNT(DISTINCT CASE WHEN obj_type NOT LIKE '#%' AND line > 0 THEN obj_type || '|' || obj_name END)
    || ' | missing ' || COUNT(DISTINCT CASE WHEN status = 'MISSING' THEN obj_name END) || ' | lines ' || SUM(CASE WHEN line > 0 AND piece = 1 THEN 1 ELSE 0 END)
    || ' | invalid_baseline ' || SUM(CASE WHEN obj_type = '#INVALID_BASELINE' THEN 1 ELSE 0 END) AS line
  FROM {BAK_TABLE} GROUP BY bak_run ORDER BY bak_run;
"""
(HERE / "01_CLOUD_BACKUP_TABLE.sql").write_text(backup_sql, encoding="utf-8")

# ---------- 01b JSONL export ----------
export_sql = hdr("01b_CLOUD_BACKUP_EXPORT_JSONL — 백업 테이블 최신 회차를 JSON Lines 파일로 내보내기(선택)",
"""--   · 한 줄 = 원문 한 줄 {"t":객체유형,"n":객체명,"l":줄,"p":조각(보통 1),"s":텍스트,"run":회차}. 결과가 수십만 줄이므로 SQLcl / SQL*Plus 권장.
--   · SQL Developer 는 [도구 > 환경설정 > 데이터베이스 > 워크시트 > 스크립트에서 출력할 최대 행수] 를 1,000,000 으로 올린 뒤 실행. 파일은 실행 디렉터리의 00_CLOUD_BACKUP_CLOUD.jsonl 로 생성(환경명으로 바꿔 보관).
--   · 이 파일은 cloud_tool.py rollback --from x.jsonl 로도 복원 가능. SQL 만 쓸 때의 원복은 99_*.sql(백업 테이블) 사용.""") + f"""
SET PAGESIZE 0 LINESIZE 32767 TRIMSPOOL ON TRIMOUT ON FEEDBACK OFF HEADING OFF VERIFY OFF
SET LONG 2000000 LONGCHUNKSIZE 2000000
SET DEFINE OFF
SPOOL 00_CLOUD_BACKUP_CLOUD.jsonl
SELECT JSON_OBJECT('t' VALUE obj_type, 'n' VALUE obj_name, 'l' VALUE line, 'p' VALUE piece, 's' VALUE RTRIM(text, CHR(10) || CHR(13)), 'run' VALUE bak_run RETURNING CLOB)
  FROM {BAK_TABLE}
 WHERE bak_run = (SELECT MAX(bak_run) FROM {BAK_TABLE})
   AND line > 0
 ORDER BY obj_type, obj_name, line, piece;
SPOOL OFF
"""
(HERE / "01b_CLOUD_BACKUP_EXPORT_JSONL.sql").write_text(export_sql, encoding="utf-8")

# ---------- 03 적용 (페이로드) ----------
out_apply = HERE / "03_CLOUD_APPLY_sqlplus"; out_apply.mkdir(exist_ok=True)
for f in out_apply.glob("*.sql"):
    if f.name not in {r["file"] for r in rows}: f.unlink()   # 페이로드 밖 객체의 옛 파일 제거(PKG_SSP0201 등)
def wrap(otype, text):
    if otype == "VIEW": return text.rstrip().rstrip(";") + "\n/\n"
    return "CREATE OR REPLACE " + text.lstrip() + "\n/\n"
blocks = []
for r in rows:
    text = (PAY / r["file"]).read_text(encoding="utf-8")
    body = wrap(r["otype"], text) + f"SHOW ERRORS {r['otype']} {r['name']}\n"
    (out_apply / r["file"]).write_text(f"-- {MARK} {r['otype']} {r['name']} — 사내 현재 원문(적용본, 사내 LAST_DDL {r['last_ddl']}, {r['lines']}줄)\n" + body, encoding="utf-8")
    blocks.append((r, body))
drv = [hdr("03_CLOUD_APPLY_ALL — 사내 적용본 일괄 적용(객체별 파일 호출)", "--   · 01 백업 직후 같은 세션에서 실행. 이 폴더를 작업 디렉터리로 하거나 워크시트에서 @<절대경로>\\03_CLOUD_APPLY_ALL.sql · 결과는 03_CLOUD_APPLY_ALL.log 에 spool\n--   · 특정 객체를 빼려면 해당 @@ 줄 삭제. 적용 뒤 03b(재컴파일) → 04(검증)."),
       "SET DEFINE OFF", "SPOOL 03_CLOUD_APPLY_ALL.log"] + [f"@@03_CLOUD_APPLY_sqlplus/{r['file']}" for r in rows] + ["SPOOL OFF", ""]
(HERE / "03_CLOUD_APPLY_ALL.sql").write_text("\n".join(drv), encoding="utf-8")
one = [hdr("03_CLOUD_APPLY_ONEFILE — 사내 적용본 일괄 적용(단일 파일판, @@ 인클루드가 안 되는 도구용)", "--   · 특정 객체를 빼려면 '-- ##### START <객체>' ~ '-- ##### END <객체>' 블록 통째 삭제. 파일이 크므로 워크시트에 열지 말고 @<절대경로> 로 실행 권장."), "SET DEFINE OFF", ""]
for r, body in blocks: one += [f"-- ##### START {r['otype']} {r['name']}", body.rstrip("\n"), f"-- ##### END {r['otype']} {r['name']}", ""]
(HERE / "03_CLOUD_APPLY_ONEFILE.sql").write_text("\n".join(one) + "\n", encoding="utf-8")

# ---------- 03b 재컴파일 ----------
recompile_sql = hdr("03b_CLOUD_RECOMPILE_INVALID — 03 적용 뒤 새로 INVALID 된 객체(01 백업 회차의 기준선 밖) 재컴파일 2회", "--   · 기준선(원래 INVALID 였던 객체)은 건드리지 않음. 남는 객체는 마지막 SELECT 로 출력.") + f"""
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_run  VARCHAR2(14); v_stmt VARCHAR2(400); v_done NUMBER := 0; v_err NUMBER := 0;
BEGIN
    SELECT MAX(bak_run) INTO v_run FROM {BAK_TABLE};
    IF v_run IS NULL THEN DBMS_OUTPUT.PUT_LINE('NOTE | no backup run in {BAK_TABLE} — run 01 first (baseline empty → every INVALID counts as new)'); END IF;
    FOR pass IN 1 .. 2 LOOP
        FOR o IN (SELECT object_type, object_name FROM all_objects
                   WHERE owner = 'SCM_MGR' AND status = 'INVALID'
                     AND object_type || '|' || object_name NOT IN (SELECT obj_name FROM {BAK_TABLE} WHERE bak_run = v_run AND obj_type = '#INVALID_BASELINE')
                   ORDER BY CASE object_type WHEN 'PACKAGE' THEN 1 WHEN 'TYPE' THEN 1 WHEN 'VIEW' THEN 2 WHEN 'FUNCTION' THEN 3 WHEN 'PROCEDURE' THEN 3 WHEN 'PACKAGE BODY' THEN 4 ELSE 5 END, object_name) LOOP
            v_stmt := CASE o.object_type
                        WHEN 'PACKAGE BODY' THEN 'ALTER PACKAGE SCM_MGR.' || o.object_name || ' COMPILE BODY'
                        WHEN 'PACKAGE'      THEN 'ALTER PACKAGE SCM_MGR.' || o.object_name || ' COMPILE SPECIFICATION'
                        WHEN 'TYPE BODY'    THEN 'ALTER TYPE SCM_MGR.' || o.object_name || ' COMPILE BODY'
                        WHEN 'TYPE'         THEN 'ALTER TYPE SCM_MGR.' || o.object_name || ' COMPILE SPECIFICATION'
                        WHEN 'SYNONYM'      THEN NULL
                        ELSE 'ALTER ' || o.object_type || ' SCM_MGR.' || o.object_name || ' COMPILE' END;
            IF v_stmt IS NOT NULL THEN
                BEGIN EXECUTE IMMEDIATE v_stmt; v_done := v_done + 1;
                EXCEPTION WHEN OTHERS THEN v_err := v_err + 1; DBMS_OUTPUT.PUT_LINE('COMPILE ERR ' || o.object_type || ' ' || o.object_name || ' : ' || SUBSTR(SQLERRM, 1, 150)); END;
            END IF;
        END LOOP;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('RECOMPILE baseline_run=' || v_run || ' | compiled=' || v_done || ' | errors=' || v_err);
END;
/
-- 기준선 밖에 남은 INVALID (0행이 정상)
SELECT 'STILL INVALID (new) | ' || object_type || ' ' || object_name AS line FROM all_objects
 WHERE owner = 'SCM_MGR' AND status = 'INVALID'
   AND object_type || '|' || object_name NOT IN (SELECT obj_name FROM {BAK_TABLE} WHERE bak_run = (SELECT MAX(bak_run) FROM {BAK_TABLE}) AND obj_type = '#INVALID_BASELINE')
 ORDER BY 1;
"""
(HERE / "03b_CLOUD_RECOMPILE_INVALID.sql").write_text(recompile_sql, encoding="utf-8")

# ---------- 04 검증 (페이로드 기대값) ----------
exp = []
for r in rows:
    lines = (PAY / r["file"]).read_text(encoding="utf-8").split("\n")
    exp.append((r, len(lines), sum(1 for l in lines if "'-'" in l), sum(len(l) for l in lines)))
views = [r for r in rows if r["otype"] == "VIEW"]
verify_sql = hdr("04_CLOUD_VERIFY — 적용 후 검증(조회 전용): 객체별 VALID/errors=0 · 줄수·총길이·'-' 줄수가 사내 적용본과 같은지(SAME_AS_CORP) · 기준선 밖 INVALID") + f"""
SET PAGESIZE 0 LINESIZE 300 HEADING OFF FEEDBACK OFF
SET DEFINE OFF
WITH exp AS (
""" + "\n UNION ALL\n".join(f"    SELECT '{r['otype']}' AS t, '{r['name']}' AS n, {ln} AS exp_lines, {le} AS exp_len, {dl} AS exp_dash FROM dual" for r, ln, dl, le in exp if r["otype"] != "VIEW") + f"""
)
, act AS (SELECT type AS t, name AS n, COUNT(*) AS act_lines, SUM(LENGTH(RTRIM(text, CHR(10) || CHR(13)))) AS act_len, SUM(CASE WHEN text LIKE '%''-''%' THEN 1 ELSE 0 END) AS act_dash FROM all_source WHERE owner = 'SCM_MGR' GROUP BY type, name)
SELECT 'VERIFY | ' || RPAD(e.t, 13) || ' | ' || RPAD(e.n, 55) || ' | ' || NVL((SELECT o.status FROM all_objects o WHERE o.owner = 'SCM_MGR' AND o.object_name = e.n AND o.object_type = e.t), 'MISSING')
    || ' | ' || CASE WHEN a.n IS NULL THEN 'MISSING' WHEN a.act_lines = e.exp_lines AND a.act_len = e.exp_len AND a.act_dash = e.exp_dash THEN 'SAME_AS_CORP' ELSE 'DIFF' END
    || ' | errors=' || (SELECT COUNT(*) FROM all_errors x WHERE x.owner = 'SCM_MGR' AND x.name = e.n AND x.type = e.t AND x.attribute = 'ERROR')
    || ' | lines ' || e.exp_lines || '/' || NVL(TO_CHAR(a.act_lines), '-') || ' | dash ' || e.exp_dash || '/' || NVL(TO_CHAR(a.act_dash), '-') AS line
  FROM exp e LEFT JOIN act a ON a.t = e.t AND a.n = e.n
 ORDER BY CASE WHEN a.n IS NULL THEN 2 WHEN a.act_lines = e.exp_lines AND a.act_len = e.exp_len AND a.act_dash = e.exp_dash THEN 1 ELSE 0 END, e.t, e.n;
-- 요약 1줄
WITH exp AS (
""" + "\n UNION ALL\n".join(f"    SELECT '{r['otype']}' AS t, '{r['name']}' AS n, {ln} AS exp_lines, {le} AS exp_len, {dl} AS exp_dash FROM dual" for r, ln, dl, le in exp if r["otype"] != "VIEW") + f"""
)
, act AS (SELECT type AS t, name AS n, COUNT(*) AS act_lines, SUM(LENGTH(RTRIM(text, CHR(10) || CHR(13)))) AS act_len, SUM(CASE WHEN text LIKE '%''-''%' THEN 1 ELSE 0 END) AS act_dash FROM all_source WHERE owner = 'SCM_MGR' GROUP BY type, name)
SELECT 'SUMMARY | same_as_corp=' || SUM(CASE WHEN a.act_lines = e.exp_lines AND a.act_len = e.exp_len AND a.act_dash = e.exp_dash THEN 1 ELSE 0 END)
    || ' diff=' || SUM(CASE WHEN a.n IS NOT NULL AND NOT (a.act_lines = e.exp_lines AND a.act_len = e.exp_len AND a.act_dash = e.exp_dash) THEN 1 ELSE 0 END)
    || ' missing=' || SUM(CASE WHEN a.n IS NULL THEN 1 ELSE 0 END) || ' of ' || COUNT(*) || ' PL/SQL objects (expected same_as_corp=' || COUNT(*) || ')' AS line
  FROM exp e LEFT JOIN act a ON a.t = e.t AND a.n = e.n;
-- VIEW {len(views)}건: 상태만 (DDL 은 DBMS_METADATA 기준이라 줄수 비교 생략). 사내 적용본 DDL 줄수 = {", ".join(f"{r['name']}={ln}" for r, ln, dl, le in exp if r["otype"] == "VIEW")}
SELECT 'VERIFY-VIEW | ' || view_name || ' | status=' || (SELECT status FROM all_objects o WHERE o.owner = v.owner AND o.object_name = v.view_name AND o.object_type = 'VIEW') || ' | text_length=' || text_length AS line
  FROM all_views v WHERE owner = 'SCM_MGR' AND view_name IN ({", ".join(f"'{r['name']}'" for r in views)}) ORDER BY 1;
-- 기준선(01 백업 최신 회차) 밖 INVALID — 'INVALID (new)' 0건이 정상. 백업 테이블이 없는 환경(01 미실행)이면 스키마 INVALID 전체를 출력
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    v_cnt NUMBER := 0; v_has NUMBER;
    TYPE t_cur IS REF CURSOR; c t_cur; v_line VARCHAR2(400);
BEGIN
    SELECT COUNT(*) INTO v_has FROM all_tables WHERE owner = 'SCM_MGR' AND table_name = '{BAK_TABLE.split('.')[1]}';
    IF v_has = 0 THEN
        DBMS_OUTPUT.PUT_LINE('NOTE | backup table {BAK_TABLE} not found (01 not run) — listing ALL schema INVALID objects instead');
        OPEN c FOR 'SELECT ''INVALID (all) | '' || object_type || '' '' || object_name FROM all_objects WHERE owner = ''SCM_MGR'' AND status = ''INVALID'' ORDER BY 1';
    ELSE
        OPEN c FOR 'SELECT ''INVALID (new) | '' || object_type || '' '' || object_name FROM all_objects WHERE owner = ''SCM_MGR'' AND status = ''INVALID'''
                || ' AND object_type || ''|'' || object_name NOT IN (SELECT obj_name FROM {BAK_TABLE} WHERE bak_run = (SELECT MAX(bak_run) FROM {BAK_TABLE}) AND obj_type = ''#INVALID_BASELINE'') ORDER BY 1';
    END IF;
    LOOP FETCH c INTO v_line; EXIT WHEN c%NOTFOUND; v_cnt := v_cnt + 1; DBMS_OUTPUT.PUT_LINE(v_line); END LOOP;
    CLOSE c;
    DBMS_OUTPUT.PUT_LINE('INVALID COUNT | ' || v_cnt || CASE WHEN v_has = 0 THEN ' (all)' ELSE ' (new beyond baseline; expected 0)' END);
END;
/
"""
(HERE / "04_CLOUD_VERIFY.sql").write_text(verify_sql, encoding="utf-8")

# ---------- 99 원복 (백업 테이블) ----------
def rollback_block(selected: bool):
    sel_decl = """    -- ▼ 원복할 객체명을 콤마로 기입 (예: 'PKG_SCP0025,PKG_DMF0003'). 아래 자리표시자는 어떤 객체와도 일치하지 않아 그대로 실행하면 0건 원복(안전).
    v_selected VARCHAR2(4000) := 'OBJECT_NAME_1,OBJECT_NAME_2';
""" if selected else ""
    sel_where = "AND INSTR(',' || UPPER(v_selected) || ',', ',' || obj_name || ',') > 0" if selected else ""
    return f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_run   VARCHAR2(14);
{sel_decl}    v_sql   CLOB; v_ok NUMBER := 0; v_fail NUMBER := 0; v_inv NUMBER := 0; v_errs NUMBER; v_st VARCHAR2(10);
BEGIN
    SELECT MAX(bak_run) INTO v_run FROM {BAK_TABLE};   -- 최신 회차. 특정 회차로 원복하려면 아래 한 줄을 주석 해제하고 14자리 회차 기입
    -- v_run := 'YYYYMMDDHH24MISS';
    DBMS_OUTPUT.PUT_LINE('ROLLBACK FROM RUN=' || v_run);
    FOR o IN (SELECT obj_type, obj_name, MAX(src_kind) AS src_kind FROM {BAK_TABLE}
               WHERE bak_run = v_run AND obj_type NOT LIKE '#%' AND line > 0 {sel_where}
               GROUP BY obj_type, obj_name ORDER BY CASE obj_type WHEN 'VIEW' THEN 1 WHEN 'FUNCTION' THEN 2 WHEN 'PROCEDURE' THEN 2 ELSE 3 END, obj_name) LOOP
        DBMS_LOB.CREATETEMPORARY(v_sql, TRUE);
        IF o.src_kind = 'source' THEN DBMS_LOB.APPEND(v_sql, TO_CLOB('CREATE OR REPLACE ')); END IF;
        FOR l IN (SELECT line, piece, text, MAX(piece) OVER (PARTITION BY line) AS last_piece
                    FROM {BAK_TABLE} WHERE bak_run = v_run AND obj_type = o.obj_type AND obj_name = o.obj_name AND line > 0 ORDER BY line, piece) LOOP
            IF l.text IS NOT NULL THEN DBMS_LOB.APPEND(v_sql, TO_CLOB(l.text)); END IF;              -- 조각(PIECE)은 그대로 이어 붙임
            IF o.src_kind = 'ddl' AND l.piece = l.last_piece THEN DBMS_LOB.APPEND(v_sql, TO_CLOB(CHR(10))); END IF;   -- DDL 은 줄 끝에 개행(ALL_SOURCE 원문은 개행 포함)
        END LOOP;
        IF o.src_kind = 'ddl' THEN v_sql := RTRIM(v_sql, ';' || CHR(10) || CHR(13) || ' '); END IF;
        BEGIN
            EXECUTE IMMEDIATE v_sql;
            SELECT COUNT(*) INTO v_errs FROM all_errors WHERE owner = 'SCM_MGR' AND name = o.obj_name AND type = o.obj_type AND attribute = 'ERROR';
            SELECT MAX(status) INTO v_st FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = o.obj_name AND object_type = o.obj_type;
            IF v_errs = 0 AND v_st = 'VALID' THEN v_ok := v_ok + 1;
            ELSE v_inv := v_inv + 1; DBMS_OUTPUT.PUT_LINE('RESTORED BUT ' || NVL(v_st, '?') || ' errors=' || v_errs || ' : ' || o.obj_type || ' ' || o.obj_name); END IF;
        EXCEPTION WHEN OTHERS THEN
            v_fail := v_fail + 1; DBMS_OUTPUT.PUT_LINE('FAIL ' || o.obj_type || ' ' || o.obj_name || ' : ' || SUBSTR(SQLERRM, 1, 200));
        END;
        DBMS_LOB.FREETEMPORARY(v_sql);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('ROLLBACK run=' || v_run || ' | ok=' || v_ok || ' | restored_but_invalid=' || v_inv || ' | fail=' || v_fail);
END;
/
"""
(HERE / "99_CLOUD_ROLLBACK_FROM_BAKTABLE.sql").write_text(hdr("99_CLOUD_ROLLBACK_FROM_BAKTABLE — 01 백업 테이블 최신 회차 원문으로 96객체 전체 원복", "--   ⚠ 실행 즉시 전체 원복됨(의도적 실행 전용). 일부만 원복하려면 99b 사용.") + rollback_block(False), encoding="utf-8")
(HERE / "99b_CLOUD_ROLLBACK_SELECTED_FROM_BAKTABLE.sql").write_text(hdr("99b_CLOUD_ROLLBACK_SELECTED_FROM_BAKTABLE — 지정 객체만 백업 테이블 최신 회차로 원복", "--   · 파일 안 v_selected 에 객체명을 기입 후 실행. 기입 전 그대로 실행하면 0건(안전).") + rollback_block(True), encoding="utf-8")
print("objects:", len(rows), "| 03 files:", len(list(out_apply.glob('*.sql'))), "| generated: 01, 01b, 03(ALL/ONEFILE), 03b, 04, 99, 99b")
