-- [E20261008-SLASHOBJ] 01_CLOUD_BACKUP_TABLE — 현재 클라우드 원문 일괄 백업 → SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 · 생성 2026-10-08 18:40 · 대상 96객체(사내 현재 원문 스냅샷 2026-10-08T17:26) · SCM_MGR 접속 후 파일 전체 실행(F5)
--   · 테이블이 없으면 생성(있으면 재사용) → 이번 실행 회차(BAK_RUN = 실행시각 14자리)로 96객체 원문(ALL_SOURCE 줄, VIEW 는 DBMS_METADATA DDL 줄)과 상태·LAST_DDL 적재
--   · 스키마 INVALID 기준선(OBJ_TYPE='#INVALID_BASELINE') 도 같은 회차에 적재 → 03b 재컴파일·04 검증의 '새로 INVALID' 판정 기준
--   · 여러 번 실행해도 회차만 늘어남(기존 회차 보존). 03 적용 직전에 실행할 것.

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
-- (1) 백업 테이블 생성 — 이미 있으면 재사용 (별도 블록: 뒤 블록의 정적 SQL 이 이 테이블을 참조하므로 먼저 존재해야 함)
BEGIN
    -- TEXT 는 VARCHAR2(4000)(ALL_SOURCE.TEXT 와 동일 한도) → INSERT…SELECT 한 번에 적재(수 초). 4,000 바이트를 넘는 VIEW DDL 줄만 PIECE 1..n 으로 분할(1,000자 단위) 저장.
    EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 (BAK_RUN VARCHAR2(14) NOT NULL, OBJ_TYPE VARCHAR2(30) NOT NULL, OBJ_NAME VARCHAR2(200) NOT NULL, LINE NUMBER NOT NULL, PIECE NUMBER DEFAULT 1 NOT NULL, TEXT VARCHAR2(4000), STATUS VARCHAR2(10), LAST_DDL DATE, SRC_KIND VARCHAR2(6), BAK_AT DATE DEFAULT SYSDATE)';
    EXECUTE IMMEDIATE 'CREATE INDEX SCM_MGR.ZZ_SLASHOBJ_BAK_20261008_IX ON SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, PIECE)';
    DBMS_OUTPUT.PUT_LINE('BACKUP TABLE CREATED: SCM_MGR.ZZ_SLASHOBJ_BAK_20261008');
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE <> -955 THEN RAISE; END IF;   -- ORA-00955 이미 존재 → 재사용
    DBMS_OUTPUT.PUT_LINE('BACKUP TABLE EXISTS: SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 (reuse)');
END;
/
-- (2) 이번 회차 백업 적재
DECLARE
    TYPE t_list IS TABLE OF VARCHAR2(200);
    v_list   t_list := t_list(
        'PROCEDURE|DMF0020_GET_SCM_MST_FUTURE_PRICE',
        'PROCEDURE|DMF0043_GET_CONTRIBUTION_SALES_LIST',
        'PROCEDURE|P_SYS0012_APPROVE',
        'PROCEDURE|P_SYS0012_REJECT',
        'PROCEDURE|P_SYS0014_SAVE_GROUP_USER_M',
        'PACKAGE BODY|PKG_COM0000',
        'PACKAGE BODY|PKG_DMF0004',
        'PACKAGE BODY|PKG_DMF0014',
        'PACKAGE BODY|PKG_DMF0020',
        'PACKAGE BODY|PKG_DMF0021',
        'PACKAGE BODY|PKG_DMF0022',
        'PACKAGE BODY|PKG_DMF0035',
        'PACKAGE BODY|PKG_DMF0042',
        'PACKAGE BODY|PKG_DMF0043',
        'PACKAGE BODY|PKG_DMF0044',
        'PACKAGE BODY|PKG_DMF0045',
        'PACKAGE BODY|PKG_DMF0049',
        'PACKAGE BODY|PKG_DMF0051',
        'PACKAGE BODY|PKG_DMF0072',
        'PACKAGE BODY|PKG_DMF0074',
        'PACKAGE BODY|PKG_DMF0082',
        'PACKAGE BODY|PKG_NSCM_UI_COM_LOOKUP',
        'PACKAGE BODY|PKG_S39V2',
        'PACKAGE BODY|PKG_S39V3',
        'PACKAGE BODY|PKG_S39V4',
        'PACKAGE BODY|PKG_S39V5',
        'PACKAGE BODY|PKG_S39V6',
        'PACKAGE BODY|PKG_S39V7',
        'PACKAGE BODY|PKG_SCM0002',
        'PACKAGE BODY|PKG_SCP0005',
        'PACKAGE BODY|PKG_SCP0007',
        'PACKAGE BODY|PKG_SCP0009',
        'PACKAGE BODY|PKG_SCP0010',
        'PACKAGE BODY|PKG_SCP0011',
        'PACKAGE BODY|PKG_SCP0013',
        'PACKAGE BODY|PKG_SCP0017',
        'PACKAGE BODY|PKG_SCP0018',
        'PACKAGE BODY|PKG_SCP0020',
        'PACKAGE BODY|PKG_SCP0025',
        'PACKAGE BODY|PKG_SCP0027',
        'PACKAGE BODY|PKG_SCP0030',
        'PACKAGE BODY|PKG_SCP0031',
        'PACKAGE BODY|PKG_SCP0039',
        'PACKAGE BODY|PKG_SCP0039_VF',
        'PACKAGE BODY|PKG_SCP0048',
        'PACKAGE BODY|PKG_SCP0049',
        'PACKAGE BODY|PKG_SCP0055',
        'PACKAGE BODY|PKG_SCP0098',
        'PACKAGE BODY|PKG_SCP0100',
        'PACKAGE BODY|PKG_SCP0105',
        'PACKAGE BODY|PKG_SDM1010',
        'PACKAGE BODY|PKG_SSP0012',
        'PACKAGE BODY|PKG_SSP0015',
        'PACKAGE BODY|PKG_SSP0019',
        'PACKAGE BODY|PKG_SSP0021',
        'PACKAGE BODY|PKG_SSP0023_CHK',
        'PACKAGE BODY|PKG_SSP0045',
        'PACKAGE BODY|PKG_SSP0060',
        'PACKAGE BODY|PKG_SSP0200',
        'PACKAGE BODY|PKG_SYS0010',
        'PACKAGE BODY|PKG_SYS0012',
        'PACKAGE BODY|PKG_SYS0013',
        'PACKAGE BODY|PKG_SYS0014',
        'PACKAGE BODY|PKG_ZTMP_S015J',
        'PACKAGE BODY|PKG_ZTMP_S015K',
        'PACKAGE BODY|PKG_ZTMP_S200B',
        'PROCEDURE|PR_DM_ANL_KPI_SALES_ACCURACY',
        'PROCEDURE|PR_DM_ANL_KPI_SUMMARY',
        'PROCEDURE|PR_DM_ANL_MKT_PSI_DATA',
        'PROCEDURE|PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE',
        'PROCEDURE|PR_DM_CUST_ITEM_MAPPING',
        'PROCEDURE|PR_DM_DNM_CREATE_C_WS_RTF',
        'PROCEDURE|PR_DM_DNM_CREATE_WS_RTF',
        'PROCEDURE|PR_DM_DNM_EDI_CALLOFF_DATA',
        'PROCEDURE|PR_DM_DNM_EDI_CALLOFF_MKT_FCST',
        'PROCEDURE|PR_DM_PLN_CUST_FCST_RECORD',
        'PROCEDURE|PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE',
        'PROCEDURE|PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING',
        'PROCEDURE|PR_DM_PLN_MKT_FCST_TO_NET_DEMAND',
        'PROCEDURE|PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE',
        'PROCEDURE|PR_DM_PLN_SALES_PLAN_RESULT_MOVE',
        'PROCEDURE|PR_SCM_ADM_DEPT_CHANGED_AUTH_SYNC',
        'PROCEDURE|PR_SCM_MST_PROJECT_SCHEDULE',
        'PROCEDURE|PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL',
        'PROCEDURE|PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_EE',
        'PROCEDURE|PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_ESS',
        'PROCEDURE|PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL',
        'PROCEDURE|PR_SSP_ANL_SHIP_UPDATE_BOH_VAL',
        'PROCEDURE|PR_SSP_ANL_SHIPMENT_PLAN_FG',
        'VIEW|SCM_DNM_PRODUCT_RESULT_V',
        'VIEW|SCP_XLS_PSI_GLOBAL_ELECTRODE_LOAD_RATIO_V',
        'VIEW|SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_CELL_V',
        'VIEW|SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_BP_V',
        'VIEW|SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_V',
        'VIEW|SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_V2',
        'VIEW|SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_V'
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
            INSERT INTO SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, PIECE, TEXT, STATUS, LAST_DDL, SRC_KIND) VALUES (v_run, p_t, p_n, p_line, 1, NULL, p_st, p_ddl, 'ddl');
            RETURN;
        END IF;
        v_off := 0; v_pn := 0;
        WHILE v_off < p_amt LOOP
            v_pn := v_pn + 1;
            v_piece := DBMS_LOB.SUBSTR(v_clob, LEAST(1000, p_amt - v_off), p_from + v_off);
            INSERT INTO SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, PIECE, TEXT, STATUS, LAST_DDL, SRC_KIND) VALUES (v_run, p_t, p_n, p_line, v_pn, v_piece, p_st, p_ddl, 'ddl');
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
            INSERT INTO SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, TEXT, STATUS, SRC_KIND) VALUES (v_run, v_t, v_n, 0, NULL, 'MISSING', 'meta');
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
            INSERT INTO SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, PIECE, TEXT, STATUS, LAST_DDL, SRC_KIND)
            SELECT v_run, v_t, v_n, line, 1, text, v_st, v_ddl_t, 'source' FROM all_source WHERE owner = 'SCM_MGR' AND name = v_n AND type = v_t;
            v_lines := v_lines + SQL%ROWCOUNT;
        END IF;
    END LOOP;
    INSERT INTO SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 (BAK_RUN, OBJ_TYPE, OBJ_NAME, LINE, PIECE, TEXT, STATUS, SRC_KIND)
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
  FROM SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 GROUP BY bak_run ORDER BY bak_run;
