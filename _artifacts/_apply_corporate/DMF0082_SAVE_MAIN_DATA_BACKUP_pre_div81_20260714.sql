CREATE OR REPLACE PROCEDURE           "DMF0082_SAVE_MAIN_DATA"
(   p_active_flag         IN VARCHAR2
  , p_division_id         IN VARCHAR2
  , p_project_code        IN VARCHAR2
  , p_end_customer        IN VARCHAR2
  , p_scm_site_id         IN VARCHAR2
  , p_item_id             IN VARCHAR2
  , p_dom_exp             IN VARCHAR2
  , p_fcst_type           IN VARCHAR2
  , p_incoterms           IN VARCHAR2
  , p_measure             IN VARCHAR2
  , p_plant_site_id       IN VARCHAR2
  , p_cell_prod_site_id   IN VARCHAR2
  , p_yyyymmdd            IN VARCHAR2
  , p_currency            IN VARCHAR2
  , p_qty                 IN VARCHAR2
  , p_created_by          IN VARCHAR2
  , O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
/****** 개체: StoredProcedure [dbo].[DMF0082_SAVE_MAIN_DATA] 스크립트 날짜: 2026-04-22 오전 10:58:18 ******/

/*============================================================================================================================
 * Program ID  : [DMF0082_SAVE_MAIN_DATA]
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=============================================================================================================================
 * Date        In Charge    Description
 *=============================================================================================================================
 * 2025.01.23	dsiol		Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2025.04.15	dsiol		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST - MEASURE 추가
 * 2025.04.26	dsiol		[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : BIZ_TYPE 이 없어서 저장을 할 수 없습니다.
 * 2025.05.21	dsiol		[PJ2025-50188]LGES SCM DM 소형사업부 매출계획 동기화 개선 : ITEM_ID가 CELL인 경우 CELL_PROD_SITE_ID를 Common으로 등록 할 수 없습니다.
 * 2025.06.19	kjiyoon		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : CELL_PROD_SITE_ID 검증 로직 보완
 * 2025.06.19	kjiyoon		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : BIZ TYPE 검증 로직 보완
 * 2025.07.15	JSSBAE		[E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리
 * 2025.07.18	JSSBAE		[E20250714-000331]_[공급생산 SCM PI팀] FCSTPrice MGMT화면 전극(AP) Item id 입력 시 Biz Type Validation 제외 요청
 * 2025.07.22	kjiyoon		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 저장 속도 개선
 * 2025.08.26	JSSBAE		[E20250825-000297]_SCM_DM 매출계획 BPS 전송 로직 개선
 * 2025.09.12	JSSBAE		[E20250912-001720]_40사업부 MKT FCST 입력제한 기능 보완
 * 2025.09.15	JSSBAE		[E20250915-000105]_GSCM 시스템 DP 입력 오류
 * 2025.09.30	JSSBAE		[E20250919-001699]_Incoterms 데이터 처리 VALID 처리
 * 2025.10.27	JSSBAE		[E20251021-000634]_FCST&PRICE MGMT SALES PLAN 데이터 동기화 속도개선
 * 2025.12.09	JSSBAE		[E20251208-000309]_FCST&PRICE MGMT MKT FCST AMT 메저 로직 개선
 * 2025.12.10	JSSBAE		[E20251209-000712]_40사업부 RTF 간편조정 후 CUTOFF 데이터 미반영 현상 확인 요청
 * 2026.01.21	JSSBAE		[E20260107-001651]_BPS 전송 데이터 From_Site_ID 생성 로직 개선
 * 2026.03.10	JSSBAE		[E20260309-000271]_DMF0082 UI Sales Price 저장 로직 개선
 *============================================================================================================================*/
IS
    --=================================================================================================================================
    -- LOG 용 변수 설정
    --=================================================================================================================================
    e_validation_error  EXCEPTION;
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         NUMBER          := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE;
    V_SQL_CODE          VARCHAR2(20 CHAR);
    V_SQL_ERRMSG        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    -----------------------------------------------------------------------------------------------------------------------------------
    -- [E20250915-000105]_변수 추가 (START)
    -----------------------------------------------------------------------------------------------------------------------------------
    v_created_by        VARCHAR2(500 CHAR);  --로그저장시 사용자ID
    n_update_cnt        NUMBER          := 0;  --변경이 발생하는 Row Count
    -----------------------------------------------------------------------------------------------------------------------------------
    -- [E20250915-000105]_변수 추가 (END)
    -----------------------------------------------------------------------------------------------------------------------------------
    --=================================================================================================================================
    -- 예외처리 변수 설정
    --=================================================================================================================================
    v_err_code          NUMBER;
    v_err_message       VARCHAR2(4000 CHAR) := '';

    V_DIVISION_ID       VARCHAR2(10 CHAR)   := '40';
    v_valid_item_id     VARCHAR2(4000 CHAR);
    v_plan_start_yyyymmdd VARCHAR2(8 CHAR);  -- 20180611 KHSONG ADDED
    v_valid_shipto      VARCHAR2(4000 CHAR);
    V_EDIT_CNT          NUMBER;

    -- 파라미터 파싱용 로컬 변수
    v_p_active_flag     VARCHAR2(4000 CHAR);
    v_p_division_id     VARCHAR2(4000 CHAR);
    v_p_project_code    VARCHAR2(4000 CHAR);
    v_p_end_customer    VARCHAR2(4000 CHAR);
    v_p_scm_site_id     VARCHAR2(4000 CHAR);
    v_p_item_id         VARCHAR2(4000 CHAR);
    v_p_dom_exp         VARCHAR2(4000 CHAR);
    v_p_fcst_type       VARCHAR2(4000 CHAR);
    v_p_incoterms       VARCHAR2(4000 CHAR);
    v_p_measure         VARCHAR2(4000 CHAR);
    v_p_plant_site_id   VARCHAR2(4000 CHAR);
    v_p_cell_prod_site_id VARCHAR2(4000 CHAR);
    v_p_yyyymmdd        VARCHAR2(4000 CHAR);
    v_p_currency        VARCHAR2(4000 CHAR);
    v_p_qty             VARCHAR2(4000 CHAR);
    v_p_created_by_raw  VARCHAR2(4000 CHAR);

    -- 루프용 행별 변수
    v_active_flag       VARCHAR2(4000 CHAR);
    v_p_division_id_val VARCHAR2(4000 CHAR);
    v_project_code      VARCHAR2(4000 CHAR);
    v_end_customer      VARCHAR2(4000 CHAR);
    v_scm_site_id       VARCHAR2(4000 CHAR);
    v_item_id           VARCHAR2(4000 CHAR);
    v_dom_exp           VARCHAR2(4000 CHAR);
    v_fcst_type         VARCHAR2(4000 CHAR);
    v_incoterms         VARCHAR2(4000 CHAR);
    v_measure           VARCHAR2(4000 CHAR);
    v_plant_site_id     VARCHAR2(4000 CHAR);
    v_cell_prod_site_id VARCHAR2(4000 CHAR);
    v_yyyymmdd          VARCHAR2(4000 CHAR);
    v_currency          VARCHAR2(4000 CHAR);
    v_qty_str           VARCHAR2(4000 CHAR);
    v_p_created_by_val  VARCHAR2(4000 CHAR);

    -- 내부 프로시저 호출용 커서 변수
    v_inner_result_cursor   SYS_REFCURSOR;

    -- 인덱스 변수
    v_index_active_flag     NUMBER;
    v_index_division_id     NUMBER;
    v_index_project_code    NUMBER;
    v_index_end_customer    NUMBER;
    v_index_scm_site_id     NUMBER;
    v_index_item_id         NUMBER;
    v_index_dom_exp         NUMBER;
    v_index_fcst_type       NUMBER;
    v_index_incoterms       NUMBER;
    v_index_measure         NUMBER;
    v_index_plant_site_id   NUMBER;
    v_index_cell_prod_site_id NUMBER;
    v_index_yyyymmdd        NUMBER;
    v_index_currency        NUMBER;
    v_index_qty             NUMBER;
    v_index_created_by      NUMBER;

    i_count             NUMBER  := 0;
    v_idx               NUMBER  := 1;

    --==========================================================================================================================
    -- 각종 validation 변수
    --==========================================================================================================================
    V_TARGET_DATE       VARCHAR2(10 CHAR);
    V_MEASURE_VAR       VARCHAR2(100 CHAR);
    V_FROM_TIME         VARCHAR2(4 CHAR);
    V_TO_TIME           VARCHAR2(4 CHAR);
    V_MIN_DATE          CHAR(8 CHAR);
    V_MAX_DATE          CHAR(8 CHAR);
    V_FROM_DATE         CHAR(8 CHAR);
    V_TO_DATE           CHAR(8 CHAR);
    s_BLOCK_Model       VARCHAR2(4000 CHAR);
    v_BIZ_TYPE_CHECK    VARCHAR2(500 CHAR);
    V_ROWCNT            NUMBER;
    V_I                 NUMBER;
    V_CNT               NUMBER;
    V_EXCEPTION_DIVISION_ID VARCHAR2(8 CHAR);
    V_EXCEPTION_ITEM_ID     VARCHAR2(50 CHAR);
    V_EXCEPTION_ITEM_TYPE   VARCHAR2(8 CHAR);
    V_EXCEPTION_COUNT       NUMBER  := 0;
    v_CELL_TYPE_CHECK   VARCHAR2(500 CHAR);
    s_cell_prod_valid   VARCHAR2(1000 CHAR);
    s_unit_price_valid  VARCHAR2(4000 CHAR);
    v_valid_bom         VARCHAR2(4000 CHAR);
    v_invalid_Site      VARCHAR2(200 CHAR);
    n_Dflag_chk         NUMBER  := 0;
    n_EE_chk            NUMBER  := 0;
    V_GETDATE           DATE;

    -- validation용 카운트
    v_cnt_check         NUMBER;

BEGIN
    --=================================================================================================================================
    -- PROC_INPUT 설정
    --=================================================================================================================================
    V_PROC_INPUT := JSON_OBJECT(
        'p_active_flag'       VALUE p_active_flag,
        'p_division_id'       VALUE p_division_id,
        'p_project_code'      VALUE p_project_code,
        'p_end_customer'      VALUE p_end_customer,
        'p_scm_site_id'       VALUE p_scm_site_id,
        'p_item_id'           VALUE p_item_id,
        'p_dom_exp'           VALUE p_dom_exp,
        'p_fcst_type'         VALUE p_fcst_type,
        'p_incoterms'         VALUE p_incoterms,
        'p_measure'           VALUE p_measure,
        'p_plant_site_id'     VALUE p_plant_site_id,
        'p_cell_prod_site_id' VALUE p_cell_prod_site_id,
        'p_yyyymmdd'          VALUE p_yyyymmdd,
        'p_currency'          VALUE p_currency,
        'p_qty'               VALUE p_qty,
        'p_created_by'        VALUE p_created_by
    );

    --=================================================================================================================================
    -- LOG 용 변수 설정
    --=================================================================================================================================
    -- [E20250915-000105]_변수 추가 (START)
    v_created_by := SUBSTR(p_created_by, 1,
                        CASE WHEN INSTR(p_created_by, '^') > 1
                             THEN INSTR(p_created_by, '^') - 1
                             ELSE 100 END);
    -- [E20250915-000105]_변수 추가 (END)

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'START', N_LOG_COUNT,
        '########## Start of procedure ##########', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A001--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --=============================================================================================================================
    -- [E20251021-000634]_TEMP TABLE DROP -> CREATE (START) 가장 상단에서 진행하도록 수정 (START)
    --=============================================================================================================================
    -- GTT 초기화 (TRUNCATE로 기존 데이터 제거)
    DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;
    DELETE FROM SCM_MGR.GT_PRDM1_T_PRICE;
    DELETE FROM SCM_MGR.GT_PRDM1_T_FCST;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_DAYINFO;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_EXCH;
    DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU1;
    DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU2;
    --=============================================================================================================================
    -- [E20251021-000634]_TEMP TABLE DROP -> CREATE (START) 가장 사단에서 진행하도록 수정 (END)
    --=============================================================================================================================

    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    --1. 화면에서 전달받은 데이터 -> temp 테이블로 insert
    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A00B--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    -- 마지막 데이터 처리를 위한 구분자 추가
    v_p_active_flag       := RTRIM(p_active_flag)       || '^';
    v_p_division_id       := RTRIM(p_division_id)       || '^';
    v_p_project_code      := RTRIM(p_project_code)      || '^';
    v_p_end_customer      := RTRIM(p_end_customer)      || '^';
    v_p_scm_site_id       := RTRIM(p_scm_site_id)       || '^';
    v_p_item_id           := RTRIM(p_item_id)           || '^';
    v_p_dom_exp           := RTRIM(p_dom_exp)           || '^';
    v_p_fcst_type         := RTRIM(p_fcst_type)         || '^';
    v_p_incoterms         := RTRIM(p_incoterms)         || '^';
    v_p_measure           := RTRIM(p_measure)           || '^';
    v_p_plant_site_id     := RTRIM(p_plant_site_id)     || '^';
    v_p_cell_prod_site_id := RTRIM(p_cell_prod_site_id) || '^';
    v_p_yyyymmdd          := RTRIM(p_yyyymmdd)          || '^';
    v_p_currency          := RTRIM(p_currency)          || '^';
    v_p_qty               := RTRIM(p_qty)               || '^';
    v_p_created_by_raw    := RTRIM(p_created_by)        || '^';

    -- COUNT를 구한다. 하나라도 들어오면 수치가 1이 된다.
    i_count := LENGTH(RTRIM(v_p_division_id)) - LENGTH(REPLACE(RTRIM(v_p_division_id), '^', ''));

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A00C--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || TO_CHAR(i_count), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    IF i_count > 0 THEN

        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
            '■ : A00D--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || TO_CHAR(i_count), '', SYSDATE,
            v_created_by,
            V_PROC_INPUT, NULL, NULL, NULL); END;

        WHILE v_idx <= i_count LOOP
            v_idx := v_idx + 1;

            v_index_active_flag       := INSTR(v_p_active_flag,       '^');
            v_index_division_id       := INSTR(v_p_division_id,       '^');
            v_index_project_code      := INSTR(v_p_project_code,      '^');
            v_index_end_customer      := INSTR(v_p_end_customer,      '^');
            v_index_scm_site_id       := INSTR(v_p_scm_site_id,       '^');
            v_index_item_id           := INSTR(v_p_item_id,           '^');
            v_index_dom_exp           := INSTR(v_p_dom_exp,           '^');
            v_index_fcst_type         := INSTR(v_p_fcst_type,         '^');
            v_index_incoterms         := INSTR(v_p_incoterms,         '^');
            v_index_measure           := INSTR(v_p_measure,           '^');
            v_index_plant_site_id     := INSTR(v_p_plant_site_id,     '^');
            v_index_cell_prod_site_id := INSTR(v_p_cell_prod_site_id, '^');
            v_index_yyyymmdd          := INSTR(v_p_yyyymmdd,          '^');
            v_index_currency          := INSTR(v_p_currency,          '^');
            v_index_qty               := INSTR(v_p_qty,               '^');
            v_index_created_by        := INSTR(v_p_created_by_raw,    '^');

            v_active_flag       := SUBSTR(v_p_active_flag,       1, v_index_active_flag       - 1);
            v_p_division_id_val := SUBSTR(v_p_division_id,       1, v_index_division_id       - 1);
            v_project_code      := SUBSTR(v_p_project_code,      1, v_index_project_code      - 1);
            v_end_customer      := SUBSTR(v_p_end_customer,      1, v_index_end_customer      - 1);
            v_scm_site_id       := SUBSTR(v_p_scm_site_id,       1, v_index_scm_site_id       - 1);
            v_item_id           := SUBSTR(v_p_item_id,           1, v_index_item_id           - 1);
            v_dom_exp           := SUBSTR(v_p_dom_exp,           1, v_index_dom_exp           - 1);
            v_fcst_type         := SUBSTR(v_p_fcst_type,         1, v_index_fcst_type         - 1);
            v_incoterms         := SUBSTR(v_p_incoterms,         1, v_index_incoterms         - 1);
            v_measure           := SUBSTR(v_p_measure,           1, v_index_measure           - 1);
            v_plant_site_id     := SUBSTR(v_p_plant_site_id,     1, v_index_plant_site_id     - 1);
            v_cell_prod_site_id := SUBSTR(v_p_cell_prod_site_id, 1, v_index_cell_prod_site_id - 1);
            v_yyyymmdd          := SUBSTR(v_p_yyyymmdd,          1, v_index_yyyymmdd          - 1);
            v_currency          := SUBSTR(v_p_currency,          1, v_index_currency          - 1);
            v_qty_str           := SUBSTR(v_p_qty,               1, v_index_qty               - 1);
            v_p_created_by_val  := SUBSTR(v_p_created_by_raw,   1, v_index_created_by        - 1);

            -- 나머지 문자열 갱신
            v_p_active_flag       := SUBSTR(v_p_active_flag,       LENGTH(RTRIM(v_active_flag)             || '^') + 1, LENGTH(RTRIM(v_p_active_flag)));
            v_p_division_id       := SUBSTR(v_p_division_id,       LENGTH(RTRIM(v_p_division_id_val)       || '^') + 1, LENGTH(RTRIM(v_p_division_id)));
            v_p_project_code      := SUBSTR(v_p_project_code,      LENGTH(RTRIM(v_project_code)            || '^') + 1, LENGTH(RTRIM(v_p_project_code)));
            v_p_end_customer      := SUBSTR(v_p_end_customer,      LENGTH(RTRIM(v_end_customer)            || '^') + 1, LENGTH(RTRIM(v_p_end_customer)));
            v_p_scm_site_id       := SUBSTR(v_p_scm_site_id,       LENGTH(RTRIM(v_scm_site_id)             || '^') + 1, LENGTH(RTRIM(v_p_scm_site_id)));
            v_p_item_id           := SUBSTR(v_p_item_id,           LENGTH(RTRIM(v_item_id)                 || '^') + 1, LENGTH(RTRIM(v_p_item_id)));
            v_p_dom_exp           := SUBSTR(v_p_dom_exp,           LENGTH(RTRIM(v_dom_exp)                 || '^') + 1, LENGTH(RTRIM(v_p_dom_exp)));
            v_p_fcst_type         := SUBSTR(v_p_fcst_type,         LENGTH(RTRIM(v_fcst_type)               || '^') + 1, LENGTH(RTRIM(v_p_fcst_type)));
            v_p_incoterms         := SUBSTR(v_p_incoterms,         LENGTH(RTRIM(v_incoterms)               || '^') + 1, LENGTH(RTRIM(v_p_incoterms)));
            v_p_measure           := SUBSTR(v_p_measure,           LENGTH(RTRIM(v_measure)                 || '^') + 1, LENGTH(RTRIM(v_p_measure)));
            v_p_plant_site_id     := SUBSTR(v_p_plant_site_id,     LENGTH(RTRIM(v_plant_site_id)           || '^') + 1, LENGTH(RTRIM(v_p_plant_site_id)));
            v_p_cell_prod_site_id := SUBSTR(v_p_cell_prod_site_id, LENGTH(RTRIM(v_cell_prod_site_id)       || '^') + 1, LENGTH(RTRIM(v_p_cell_prod_site_id)));
            v_p_yyyymmdd          := SUBSTR(v_p_yyyymmdd,          LENGTH(RTRIM(v_yyyymmdd)                || '^') + 1, LENGTH(RTRIM(v_p_yyyymmdd)));
            v_p_currency          := SUBSTR(v_p_currency,          LENGTH(RTRIM(v_currency)                || '^') + 1, LENGTH(RTRIM(v_p_currency)));
            v_p_qty               := SUBSTR(v_p_qty,               LENGTH(RTRIM(v_qty_str)                 || '^') + 1, LENGTH(RTRIM(v_p_qty)));
            v_p_created_by_raw    := SUBSTR(v_p_created_by_raw,    LENGTH(RTRIM(v_p_created_by_val)        || '^') + 1, LENGTH(RTRIM(v_p_created_by_raw)));

            -- [E20250522-001188]_해당 화면에서도 TRIM처리가 전혀 안되어 있어서 TRIM 처리 (START)
            v_active_flag       := TRIM(v_active_flag);
            v_p_division_id_val := TRIM(v_p_division_id_val);
            v_project_code      := TRIM(v_project_code);
            v_end_customer      := TRIM(v_end_customer);
            v_scm_site_id       := TRIM(v_scm_site_id);
            --1).CHAR(13): Carriage return / 2).CHAR(10): Line feed / 3).CHAR(9): TAB / 4).' ' 공백 '' 처리
            v_item_id           := REPLACE(REPLACE(REPLACE(REPLACE(TRIM(v_item_id), CHR(13), ''), CHR(10), ''), CHR(9), ''), ' ', '');
            v_dom_exp           := TRIM(v_dom_exp);
            v_fcst_type         := TRIM(v_fcst_type);
            v_incoterms         := TRIM(v_incoterms);
            v_measure           := TRIM(v_measure);
            v_plant_site_id     := TRIM(v_plant_site_id);
            v_cell_prod_site_id := TRIM(v_cell_prod_site_id);
            v_yyyymmdd          := TRIM(v_yyyymmdd);
            v_qty_str           := TRIM(v_qty_str);
            v_currency          := TRIM(v_currency);
            v_p_created_by_val  := TRIM(v_p_created_by_val);
            -- [E20250522-001188]_TRIM 처리 (END)

            BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
                '■ : A00E--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || TO_CHAR(v_idx), '', SYSDATE,
                v_created_by,
                V_PROC_INPUT, NULL, NULL, NULL); END;

            INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
            ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            , PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
            , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
            , V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
            VALUES
            ( v_active_flag, v_p_division_id_val, v_project_code, v_end_customer, v_scm_site_id, v_item_id
            , v_dom_exp, v_fcst_type, v_incoterms, v_measure
            , v_plant_site_id, v_cell_prod_site_id, v_yyyymmdd, v_currency
            , TO_NUMBER(NVL(v_qty_str, '0') DEFAULT 0 ON CONVERSION ERROR)
            , v_p_created_by_val
            , '', '', '', '', '', '', '', '', '', '', '', '' );

        END LOOP;

    END IF;

    BEGIN
        SELECT COUNT(1) INTO V_EDIT_CNT FROM SCM_MGR.GT_PRDM1_T_MAIN;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_EDIT_CNT := 0;
    END;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_MAIN');

    --=============================================================================================================================
    -- PARAMETER => TABLE 적재 LOG (START)
    --=============================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 1. PARAMETER TO #T_MAIN IMPORT';
    N_LOG_COUNT   := i_count;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --=============================================================================================================================
    -- PARAMETER => TABLE 적재 LOG (END)
    --=============================================================================================================================

    n_update_cnt := 0; -- [E20250915-000105]_ROW_COUNT 확인
    --==========================================================================================================================
    -- VALIDATION 시작 (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 2. VALIDATION CHECK START';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- VALIDATION 시작 (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- Validaion Check (START)
    --==========================================================================================================================
    --==========================================================================================================================
    -- 1. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (START)
    --==========================================================================================================================
    ----------------------------------------------------------------------------------------------------------------------------
    -- [E20250912-001720]_수정 저장 VALIDATION 추가 (START)
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_TEMP_DAYINFO (DAYOFWEEKS)
    SELECT DAYOFWEEK
    FROM SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_DAYINFO');

    BEGIN
        SELECT A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
        INTO   V_TARGET_DATE, V_FROM_TIME, V_TO_TIME, V_MEASURE_VAR
        FROM (
            SELECT B.SEGMENT3, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, ATTRIBUTE4
            FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
            WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
            AND B.VALID_YN = 'Y'
            AND B.SEGMENT2 = 'DMF0082'
            AND B.ATTRIBUTE4 IS NOT NULL
            AND (B.ATTRIBUTE1 = 'ALL' OR B.ATTRIBUTE1 IN (SELECT DAYOFWEEKS FROM SCM_MGR.GT_PRDM1_TEMP_DAYINFO))
            AND TRUNC(TO_NUMBER(REPLACE(SUBSTR(TO_CHAR(SYSDATE, 'HH24:MI:SS'), 1, 5), ':', '')))
                BETWEEN TRUNC(TO_NUMBER(B.ATTRIBUTE2 DEFAULT NULL ON CONVERSION ERROR))
                    AND TRUNC(TO_NUMBER(B.ATTRIBUTE3 DEFAULT NULL ON CONVERSION ERROR))
            AND B.SEGMENT3 = V_DIVISION_ID
        ) A
        GROUP BY A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, ATTRIBUTE4;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_TARGET_DATE := NULL; V_FROM_TIME := NULL; V_TO_TIME := NULL; V_MEASURE_VAR := NULL;
        WHEN TOO_MANY_ROWS THEN
            V_TARGET_DATE := NULL; V_FROM_TIME := NULL; V_TO_TIME := NULL; V_MEASURE_VAR := NULL;
    END;

    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN A
    INNER JOIN (
        SELECT A.SEGMENT3 AS DIVISION_ID, A.ATTRIBUTE1 AS TARGET_DATE, A.ATTRIBUTE2 AS FROM_TIME, A.ATTRIBUTE3 AS TO_TIME
             , REGEXP_SUBSTR(A.ATTRIBUTE4, '[^,]+', 1, LEVEL) AS MEASURE
        FROM (
            SELECT B.SEGMENT3, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4
            FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
            WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
            AND B.VALID_YN = 'Y'
            AND B.SEGMENT2 = 'DMF0082'
            AND B.ATTRIBUTE4 IS NOT NULL
        ) A
        CONNECT BY LEVEL <= REGEXP_COUNT(A.ATTRIBUTE4, ',') + 1
             AND PRIOR A.SEGMENT3 = A.SEGMENT3 AND PRIOR A.ATTRIBUTE1 = A.ATTRIBUTE1
             AND PRIOR SYS_GUID() IS NOT NULL
    ) C ON A.DIVISION_ID = C.DIVISION_ID
          AND A.MEASURE  = C.MEASURE
    WHERE A.QTY_PRICE <> 0
    AND (C.TARGET_DATE = 'ALL' OR C.TARGET_DATE IN (SELECT DAYOFWEEKS FROM SCM_MGR.GT_PRDM1_TEMP_DAYINFO))
    AND TRUNC(TO_NUMBER(REPLACE(SUBSTR(TO_CHAR(SYSDATE, 'HH24:MI:SS'), 1, 5), ':', '')))
        BETWEEN TRUNC(TO_NUMBER(C.FROM_TIME DEFAULT NULL ON CONVERSION ERROR))
            AND TRUNC(TO_NUMBER(C.TO_TIME   DEFAULT NULL ON CONVERSION ERROR));

    IF v_cnt_check > 1 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := V_MEASURE_VAR || ' 메져는 "' || V_TARGET_DATE || '" 요일의 '
                      || SUBSTR(V_FROM_TIME, 1, 2) || ':' || SUBSTR(V_FROM_TIME, 3, 2)
                      || ' ~ ' || SUBSTR(V_TO_TIME, 1, 2) || ':' || SUBSTR(V_TO_TIME, 3, 2)
                      || ' 시간에는 수정 불가능합니다.';
        RAISE e_validation_error;
    END IF;
    ----------------------------------------------------------------------------------------------------------------------------
    -- [E20250912-001720]_수정 저장 VALIDATION 추가 (END)
    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------
    -- 1.1). SALES PRICE 미리 수집
    ----------------------------------------------------------------------------------------------------------------------------
    BEGIN
        SELECT MIN(BASIS_START_DATE), MAX(BASIS_END_DATE)
        INTO   V_MIN_DATE, V_MAX_DATE
        FROM SCM_MGR.SCM_SYS_CALENDAR_M M
        -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
        WHERE M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')  --당주 월요일부터
        AND   M.BASIS_YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD');  -- 52주후 월요일까지
        -- [E20250825-000297]_52주구간 (END)
    EXCEPTION WHEN NO_DATA_FOUND THEN V_MIN_DATE := NULL; V_MAX_DATE := NULL;
    END;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A003--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    ----------------------------------------------------------------------------------------------------------------------------
    -- 1.2). Sales Price 52주 구간 데이터 TEMP 테이블 INSERT (START)
    -- Sales Price 52주 구간 확인을 할 때는 UI에서 입력한 값이든, 이미 DB에 있던 값이든 상관없이 데이터가 있다면 상관없다.
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
    , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
         , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
    FROM (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
             , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, SUM(PRICE) AS PRICE
        FROM (
            -- DB에 있는 원래 데이터
            SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.ITEM_ID
                          , B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            JOIN SCM_MGR.DM_PLN_CFM_SELLING_PRICE B
              ON A.DIVISION_ID       = B.DIVISION_ID
             AND A.PROJECT_CODE      = B.PROJECT_CODE
             AND A.END_CUSTOMER      = B.END_CUSTOMER
             AND A.SCM_SITE_ID       = B.SCM_SITE_ID
             AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
             AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
             AND A.ITEM_ID           = B.ITEM_ID
             AND A.DOM_EXP           = B.DOM_EXP
             AND A.FCST_TYPE         = B.FCST_TYPE
             AND A.INCOTERMS         = B.INCOTERMS
            WHERE B.DIVISION_ID  = A.DIVISION_ID
              AND B.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND B.PRICE <> 0
              AND B.MEASURE = 'LOC'
            UNION
            ----------------------------------------------------------------------------------------------------------------------------
            -- UI에서 입력한 신규 데이터 혹은 기존 DB 값을 UI에서 수정한 데이터
            -- MKT Fcst 와 같이 입력되는 Price의 경우 Validation에 포함 (UI에서 MKT_FCST MEASURE랑 LOC MEASURE를 동시에 입력하는 경우를 말함)
            ----------------------------------------------------------------------------------------------------------------------------
            SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ITEM_ID
                          , A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.QTY_PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE A.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND A.QTY_PRICE <> 0
              AND A.MEASURE = 'LOC'
        ) A
        GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
               , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
    ) AA;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_PRICE');
    ----------------------------------------------------------------------------------------------------------------------------
    -- 1.2). Sales Price 52주 구간 데이터 TEMP 테이블 INSERT (END)
    ----------------------------------------------------------------------------------------------------------------------------

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A004--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    ----------------------------------------------------------------------------------------------------------------------------
    -- 1.3). 입력된 데이터의 기존 셀 생산지 데이터 수집 (START)
    -- 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_T_FCST
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID
    , ITEM_ID, YYYYMMDD, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS )
    SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID
                  , B.ITEM_ID, B.YYYYMMDD, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS
    FROM SCM_MGR.GT_PRDM1_T_MAIN A
    JOIN SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN B
      ON A.DIVISION_ID  = B.DIVISION_ID
     AND A.PROJECT_CODE = B.PROJECT_CODE
     AND A.END_CUSTOMER = B.END_CUSTOMER
     AND A.SCM_SITE_ID  = B.SCM_SITE_ID
     AND A.PLANT_SITE_ID= B.PLANT_SITE_ID
     --AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
     AND A.ITEM_ID      = B.ITEM_ID
     AND A.DOM_EXP      = B.DOM_EXP
     AND A.FCST_TYPE    = B.FCST_TYPE
     AND A.INCOTERMS    = B.INCOTERMS
     AND A.YYYYMMDD     = B.YYYYMMDD
     AND A.MEASURE      = B.MEASURE
    WHERE B.DIVISION_ID = A.DIVISION_ID
      AND B.QTY <> 0
      --AND B.CELL_PROD_SITE_ID = '-'
      AND A.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'SCM_FCST'); --[PJ2025-50188] SCM_FCST - MEASURE 추가

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_FCST');
    ----------------------------------------------------------------------------------------------------------------------------
    -- 1.3). 입력된 데이터의 기존 셀 생산지 데이터 수집 (END)
    --==========================================================================================================================
    -- 1. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A005--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 2. 40 Validation 필요 대상 : VMI Site 여부 확인 (START)
    --==========================================================================================================================
    ----------------------------------------------------------------------------------------------------------------------------
    -- 2.1). #T_MAIN 테이블의 VMI_YN UPDATE
    ----------------------------------------------------------------------------------------------------------------------------
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET A.V_VMI_YN = (SELECT CASE WHEN B.VMI_YN = 'Y' THEN 'Y' ELSE 'N' END
                      FROM SCM_MGR.SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID AND B.SCM_SITE_ID = A.SCM_SITE_ID
                      FETCH FIRST 1 ROWS ONLY)
    WHERE EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE B
                  WHERE B.DIVISION_ID = A.DIVISION_ID AND B.SCM_SITE_ID = A.SCM_SITE_ID);

    ----------------------------------------------------------------------------------------------------------------------------
    -- 2.2).AS 이더라도 AS Plant 에는 Attribute10 을 지워준다.
    ----------------------------------------------------------------------------------------------------------------------------
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET V_ATTRIBUTE10 = NULL
    WHERE SCM_SITE_ID = V_ATTRIBUTE10;

    --==========================================================================================================================
    -- 2. 40 Validation 필요 대상 : VMI Site 여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A006--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 3. 40 Validation 필요 대상 : 중장기 구간 확인 (START)
    --==========================================================================================================================
    BEGIN
        SELECT MIN(C.BASIS_YYYYMMDD), MAX(C.BASIS_YYYYMMDD)
        INTO   V_FROM_DATE, V_TO_DATE
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M C
          ON C.BASIS_YYYYMM = L.ATTRIBUTE1 OR C.BASIS_YYYYMM = L.ATTRIBUTE2
        WHERE L.LOOKUP_TYPE = 'DM_LONG_PLAN' AND L.SEGMENT1 = '40' AND L.SEGMENT2 = 'MKT FCST' AND L.VALID_YN = 'Y';
    EXCEPTION WHEN NO_DATA_FOUND THEN V_FROM_DATE := NULL; V_TO_DATE := NULL;
    END;

    ---------------------------------------------------------------------------------------------------------------------------
    -- 소형일 경우 중장기계획 관련 2022년 입력 마감여부 확인
    -- 소형이고 2022년이 마감되어있는데, 2022년 데이터가 들어있으면 에러처리
    ---------------------------------------------------------------------------------------------------------------------------
    IF V_DIVISION_ID = '40' THEN
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE R.YYYYMMDD < V_FROM_DATE OR R.YYYYMMDD > V_TO_DATE;

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := V_FROM_DATE || ' ~ ' || V_TO_DATE || ' 구간 내의 데이터만 수정할 수 있습니다.';
            RAISE e_validation_error;
        END IF;
    END IF;
    --==========================================================================================================================
    -- 3. 40 Validation 필요 대상 : 중장기 구간 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A007--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 3-1. [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (START)
    --==========================================================================================================================
    IF V_DIVISION_ID = '40' THEN
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE R.INCOTERMS IN (
            SELECT OLD_VALUE1 FROM SCM_MGR.NERP_CONV_MASTER
            WHERE CODETYPE = 'INCOTERMS_ID'
            GROUP BY OLD_VALUE1
        );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '구코드 INCOTERMS는 저장할 수 없습니다.';
            RAISE e_validation_error;
        END IF;
    END IF;
    --==========================================================================================================================
    -- 3-1. [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- 4. 40 Validation 필요 대상 : MKT Fcst Exception Model 대상 확인 (START)
    --==========================================================================================================================
    s_BLOCK_Model := '';
    BEGIN
        SELECT ITEM_ID INTO s_BLOCK_Model
        FROM (
            SELECT A.ITEM_ID
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE (
                SELECT COUNT(1) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE LOOKUP_TYPE = 'FCST_EXCEPT_MODEL' AND SEGMENT1 = '40' AND VALID_YN = 'Y' AND SEGMENT2 = A.ITEM_ID
            ) > 0
            AND A.QTY_PRICE <> 0
            FETCH FIRST 1 ROWS ONLY
        );
    EXCEPTION WHEN NO_DATA_FOUND THEN s_BLOCK_Model := '';
    END;

    IF s_BLOCK_Model IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := 'Model : ' || s_BLOCK_Model || CHR(10) || 'FCST INPUT BLOCK Model. contact 영업관리팀';
        RAISE e_validation_error;
    END IF;
    --==========================================================================================================================
    -- 4. 40 Validation 필요 대상 : MKT Fcst Exception Model 대상 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A008--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 5. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (START)
    --==========================================================================================================================
    BEGIN
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE NOT EXISTS (
                SELECT ITEM.DIVISION_ID
                FROM SCM_MGR.SCM_MST_SITE_ITEM ITEM
                   , SCM_MGR.SCM_MST_ITEM_SN SN
                WHERE ITEM.DIVISION_ID = A.DIVISION_ID
                  AND ITEM.SCM_SITE_ID = A.SCM_SITE_ID
                  AND ITEM.ITEM_ID     = A.ITEM_ID
                  AND ITEM.DIVISION_ID = SN.DIVISION_ID
                  AND ITEM.ITEM_ID     = SN.ITEM_ID
                  AND SN.ACTIVE_FLAG   = 'Y'
                  AND ITEM.VALID_YN    = 'Y'
            )
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] Invalid Site Item ID !';
            RAISE e_validation_error;
        END IF;
    END;
    --==========================================================================================================================
    -- 5. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A009--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 6. 40 Validation 필요 대상 : BIZ_TYPE 존재여부 확인 (START)
    --==========================================================================================================================
    v_BIZ_TYPE_CHECK := NULL;
    --[E20250714-000331]_[공급생산 SCM PI팀] FCSTPrice MGMT화면 전극(AP) Item id 입력 시 Biz Type Validation 제외 요청 (STRAT)

    ----------------------------------------------------------------------------------------------------------------------------
    -- 6.1). 룩업: EXCEPTION_BIZ_TYPE 데이터를 #TEMP_EXCEPTION_BIZ_TYPE에 담는다.
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE
    ( DIVISION_ID, ITEM_ID, ITEM_TYPE, SEQ )
    SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS ITEM_ID, SEGMENT3 AS ITEM_TYPE
         , ROW_NUMBER() OVER (ORDER BY ROWNUM) AS SEQ
    FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE LOOKUP_TYPE = 'EXCEPTION_BIZ_TYPE'
    AND VALID_YN = 'Y'
    AND SEGMENT1 = V_DIVISION_ID;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE');

    ----------------------------------------------------------------------------------------------------------------------------
    -- 6.2). 룩업에 저장된 데이터가 1건 이상인 경우가 존재할 수 있으므로, LOOP 실행하여,
    --       한건씩 매핑된 데이터로 #TEMP_EXCEPTION_ITEM_LIST에 데이터 적재
    --       ITEM_ID 일부로 시작하는 것으로 요청했으므로 뒷쪽만 LIKE 처리하여 데이터 처리
    ----------------------------------------------------------------------------------------------------------------------------
    V_ROWCNT := SQL%ROWCOUNT;

    BEGIN
        SELECT 1, COUNT(*) INTO V_I, V_CNT
        FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_I := 1; V_CNT := 0;
    END;

    V_EXCEPTION_COUNT := 0;

    WHILE V_I <= V_CNT LOOP
        BEGIN
            SELECT A.DIVISION_ID, A.ITEM_ID, A.ITEM_TYPE
            INTO V_EXCEPTION_DIVISION_ID, V_EXCEPTION_ITEM_ID, V_EXCEPTION_ITEM_TYPE
            FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE A
            WHERE SEQ = V_I;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;

        INSERT INTO SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST
        ( DIVISION_ID, ITEM_ID, ITEM_TYPE )
        SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, V_EXCEPTION_ITEM_TYPE AS ITEM_TYPE
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        WHERE A.DIVISION_ID = V_EXCEPTION_DIVISION_ID
        AND   A.ITEM_ID LIKE '' || V_EXCEPTION_ITEM_ID || '%';

        V_I := V_I + 1;
    END LOOP;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST');

    ----------------------------------------------------------------------------------------------------------------------------
    -- 6.3).  #TEMP_EXCEPTION_ITEM_LIST에 존재하는 데이터는 NOT EXISTS 체크하여 VALIDATION 체크한다.
    ----------------------------------------------------------------------------------------------------------------------------
    BEGIN
        v_BIZ_TYPE_CHECK := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_BIZ_TYPE_CHECK
            FROM (
                SELECT T1.DIVISION_ID, T1.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE
                FROM SCM_MGR.GT_PRDM1_T_MAIN T1
                LEFT JOIN LATERAL (
                    SELECT T2.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE
                    FROM SCM_MGR.SCM_ITEM_M_SN T2
                    WHERE T1.DIVISION_ID = T2.DIVISION_ID
                      AND T1.ITEM_ID     = T2.ITEM_ID
                      AND T2.ACTIVE_FLAG = 'Y'
                ) T2 ON 1=1
                WHERE T1.ACTION = 'I'
                AND T2.FORECAST_INFO_BIZ_TYPE IS NULL
                GROUP BY T1.DIVISION_ID, T1.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE
            ) A
            WHERE NOT EXISTS (
                SELECT B.ITEM_ID
                FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST B
                WHERE A.DIVISION_ID = B.DIVISION_ID
                  AND A.ITEM_ID     = B.ITEM_ID
                  AND A.ITEM_TYPE   = B.ITEM_TYPE
            )
            GROUP BY A.ITEM_ID
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_BIZ_TYPE_CHECK := NULL;
        END;

        --[E20250714-000331]_[공급생산 SCM PI팀] FCSTPrice MGMT화면 전극(AP) Item id 입력 시 Biz Type Validation 제외 요청 (END)
        IF v_BIZ_TYPE_CHECK IS NOT NULL THEN
            --BIZ_TYPE 이 없어서 저장을 할 수 없습니다.
            V_DESCRIPTION := 'Model*: ' || v_BIZ_TYPE_CHECK || '는 BIZ_TYPE 이 없어서 저장을 할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    --==========================================================================================================================
    -- 6. 40 Validation 필요 대상 : BIZ_TYPE 존재여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A010--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 7. 40 Validation 필요 대상 : ITEM_ID가 CELL인 경우 CELL_PROD_SITE_ID를 Common으로 등록 할 수 없습니다 (START)
    --==========================================================================================================================
    v_CELL_TYPE_CHECK := NULL;

    BEGIN
        v_CELL_TYPE_CHECK := NULL;
        BEGIN
            SELECT LISTAGG(A.ITEM_ID, ',') WITHIN GROUP (ORDER BY A.ITEM_ID)
            INTO v_CELL_TYPE_CHECK
            FROM (
                SELECT T1.ITEM_ID
                FROM SCM_MGR.GT_PRDM1_T_MAIN T1
                LEFT JOIN SCM_MGR.SCM_ITEM_M_SN T2
                  ON T1.DIVISION_ID = T2.DIVISION_ID AND T1.ITEM_ID = T2.ITEM_ID
                WHERE (T2.FORECAST_INFO_BIZ_TYPE = 'CELL' OR T1.ITEM_ID LIKE 'MC%')
                  AND T1.CELL_PROD_SITE_ID = '-'
                  AND T2.ACTIVE_FLAG = 'Y'
                  AND NVL(T1.QTY_PRICE, 0) <> 0
                  AND (T1.ACTION = 'I'
                    OR NOT EXISTS (
                        SELECT 1 FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN X
                        WHERE T1.DIVISION_ID       = X.DIVISION_ID
                          AND T1.PROJECT_CODE      = X.PROJECT_CODE
                          AND T1.END_CUSTOMER      = X.END_CUSTOMER
                          AND T1.SCM_SITE_ID       = X.SCM_SITE_ID
                          AND T1.PLANT_SITE_ID     = X.PLANT_SITE_ID
                          AND T1.CELL_PROD_SITE_ID = X.CELL_PROD_SITE_ID
                          AND T1.ITEM_ID           = X.ITEM_ID
                          AND T1.DOM_EXP           = X.DOM_EXP
                          AND T1.FCST_TYPE         = X.FCST_TYPE
                          AND T1.INCOTERMS         = X.INCOTERMS
                          AND X.MEASURE            = 'MKT_FCST'
                          AND X.YYYYMMDD           >= v_plan_start_yyyymmdd
                          AND X.QTY                <> 0
                    ))
                GROUP BY T1.ITEM_ID
                FETCH FIRST 10 ROWS ONLY
            ) A;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_CELL_TYPE_CHECK := NULL;
        END;

        IF v_CELL_TYPE_CHECK IS NOT NULL THEN
            V_DESCRIPTION := 'Model*: ' || v_CELL_TYPE_CHECK || '는 Cell Prod Site* 를 Common으로 등록 할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    --==========================================================================================================================
    -- 7. 40 Validation 필요 대상 : ITEM_ID가 CELL인 경우 CELL_PROD_SITE_ID를 Common으로 등록 할 수 없습니다 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A011--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 8. 40 Validation 필요 대상 : 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가 (START)
    --==========================================================================================================================
    s_cell_prod_valid := NULL;

    BEGIN
        BEGIN
            SELECT A.ITEM_ID INTO s_cell_prod_valid
            FROM (
                SELECT P.DIVISION_ID, P.PROJECT_CODE, P.END_CUSTOMER, P.SCM_SITE_ID, P.PLANT_SITE_ID, P.ITEM_ID, P.YYYYMMDD
                     , P.MEASURE, P.DOM_EXP, P.FCST_TYPE, P.INCOTERMS, P.CELL_PROD_SITE_ID AS CELL_PROD_SITE_FCST, T.CELL_PROD_SITE_ID AS CELL_PROD_SITE_MAIN
                FROM SCM_MGR.GT_PRDM1_T_FCST P
                INNER JOIN SCM_MGR.GT_PRDM1_T_MAIN T
                  ON T.DIVISION_ID      = P.DIVISION_ID
                 AND T.PROJECT_CODE     = P.PROJECT_CODE
                 AND T.END_CUSTOMER     = P.END_CUSTOMER
                 AND T.SCM_SITE_ID      = P.SCM_SITE_ID
                 AND T.PLANT_SITE_ID    = P.PLANT_SITE_ID
                 AND T.ITEM_ID          = P.ITEM_ID
                 AND T.YYYYMMDD         = P.YYYYMMDD
                 AND T.MEASURE          = P.MEASURE
                 AND T.DOM_EXP          = P.DOM_EXP
                 AND T.FCST_TYPE        = P.FCST_TYPE
                 AND T.INCOTERMS        = P.INCOTERMS
                 AND T.CELL_PROD_SITE_ID <> P.CELL_PROD_SITE_ID
                WHERE T.ACTION = 'I'
                GROUP BY P.DIVISION_ID, P.PROJECT_CODE, P.END_CUSTOMER, P.SCM_SITE_ID, P.PLANT_SITE_ID
                       , P.ITEM_ID, P.YYYYMMDD, P.MEASURE, P.DOM_EXP, P.FCST_TYPE, P.INCOTERMS, P.CELL_PROD_SITE_ID, T.CELL_PROD_SITE_ID
                HAVING P.CELL_PROD_SITE_ID = '-' OR T.CELL_PROD_SITE_ID = '-'
            ) A
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN s_cell_prod_valid := NULL;
        END;

        IF s_cell_prod_valid IS NOT NULL THEN
            V_DESCRIPTION := 'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    --==========================================================================================================================
    -- 8. 40 Validation 필요 대상 : 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A012--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 9. 40 Validation 필요 대상 : #T_MAIN 에 들어온 Site가 Common을 포함 두 건 이상인 경우 Invalid 처리 (START)
    -- Common 식별을 위해 Common의 Dash 값은 XX로 치환하고 XX 를 포함 두개 이상의 Cell Prod Site가 입력되었는지를 확인.
    --==========================================================================================================================
    s_cell_prod_valid := NULL;

    BEGIN
        BEGIN
            SELECT 'N' INTO s_cell_prod_valid
            FROM (
                SELECT T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.PLANT_SITE_ID
                     , T.ITEM_ID, T.YYYYMMDD, T.MEASURE, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
                     , LISTAGG(CASE WHEN T.CELL_PROD_SITE_ID = '-' THEN 'XX' ELSE T.CELL_PROD_SITE_ID END, ', ')
                        WITHIN GROUP (ORDER BY T.CELL_PROD_SITE_ID) AS CELL_PROD_ALL
                FROM SCM_MGR.GT_PRDM1_T_MAIN T
                WHERE T.ACTION = 'I'
                GROUP BY T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.PLANT_SITE_ID
                       , T.ITEM_ID, T.YYYYMMDD, T.MEASURE, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
                HAVING COUNT(*) > 1
            ) A
            WHERE INSTR(A.CELL_PROD_ALL, 'XX') > 0
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN s_cell_prod_valid := NULL;
        END;

        IF s_cell_prod_valid IS NOT NULL THEN
            V_DESCRIPTION := 'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;

    --==========================================================================================================================
    -- 9. 40 Validation 필요 대상 : #T_MAIN 에 들어온 Site가 Common을 포함 두 건 이상인 경우 Invalid 처리 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A013--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 10. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (START)
    --==========================================================================================================================
    /* @s_unit_price_valid 변수내에는 Null이 발생하는 컬럼값이 존재하면 안됨 (변수전체가 Null로 저장됨)  */
    INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU1 (SEGMENT2)
    SELECT MST.SEGMENT2
    FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST  -- SCM_FCST - MEASURE 추가, 아래의 룩업에 SCM_FCST 정보를 추가했습니다.
    WHERE MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
    AND MST.SEGMENT1      = 'MEASURE'
    AND MST.VALID_YN      = 'Y';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_MSHYCHU1');

    INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU2 (SEGMENT2)
    SELECT MST.SEGMENT2
    FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
    AND MST.SEGMENT1      = 'FCST_TYPE'
    AND MST.VALID_YN      = 'Y';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_MSHYCHU2');

    s_unit_price_valid := NULL;
    BEGIN
        SELECT 'End Customer________ : '   || NVL(A.END_CUSTOMER,  '')
            || CHR(10) || 'Sales site_____________ : ' || NVL(A.SCM_SITE_ID,   '')
            || CHR(10) || 'Model________________ : '   || NVL(A.ITEM_ID,       '')
            || CHR(10) || 'Customs Handbook__ : '      || NVL(A.DOM_EXP,       '')
            || CHR(10) || 'Fcst Type_____________ : '  || NVL((
                SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT1 = A.FCST_TYPE
                FETCH FIRST 1 ROWS ONLY), '')
            || CHR(10) || 'Incoterms____________ : '   || NVL(A.INCOTERMS,     '')
            || CHR(10) || 'Plant Site___________ : '   || NVL(A.PLANT_SITE_ID, '')
            || CHR(10) || 'Cell Prod Site___________ : '|| NVL(A.CELL_PROD_SITE_ID, '')
            || CHR(10) || 'YYYYMMDD_________ : '       || NVL(MIN(M.BASIS_START_DATE), '') || ' ~ ' || NVL(MAX(M.BASIS_START_DATE), '')
            || CHR(10) || CHR(10)
        INTO s_unit_price_valid
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM Z
                ON A.DIVISION_ID = Z.DIVISION_ID
               AND A.PROJECT_CODE          = Z.PROJECT_CODE
               AND A.SCM_SITE_ID           = Z.SCM_SITE_ID
               AND A.ITEM_ID               = Z.ITEM_ID
               AND Z.VALID_YN              = 'Y'
               AND (Z.SALES_PLAN_ADJUST_YN = 'Y' OR Z.SALES_PLAN_ADJUST_YN IS NULL)
        LEFT JOIN (
            SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M M
            -----------------------------------------------------------------------------------------------------------------------------------
            -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
            WHERE M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')  --당주 월요일부터
            AND   M.BASIS_YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')  -- 52주후 월요일까지
            -- [E20250825-000297]_52주구간 (END)
            -----------------------------------------------------------------------------------------------------------------------------------
            GROUP BY BASIS_START_DATE
        ) M ON 1=1
        LEFT JOIN SCM_MGR.GT_PRDM1_T_PRICE P
               ON A.DIVISION_ID       = P.DIVISION_ID
              AND A.PROJECT_CODE      = P.PROJECT_CODE
              AND A.END_CUSTOMER      = P.END_CUSTOMER
              AND A.SCM_SITE_ID       = P.SCM_SITE_ID
              AND A.PLANT_SITE_ID     = P.PLANT_SITE_ID
              AND A.CELL_PROD_SITE_ID = P.CELL_PROD_SITE_ID
              AND A.ITEM_ID           = P.ITEM_ID
              AND A.DOM_EXP           = P.DOM_EXP
              AND A.FCST_TYPE         = P.FCST_TYPE
              AND A.INCOTERMS         = P.INCOTERMS
              AND P.YYYYMMDD          = M.BASIS_START_DATE
              AND P.PRICE             > 0
        WHERE P.YYYYMMDD IS NULL  -- PRICE값이 없는경우
          AND A.MEASURE IN (SELECT SEGMENT2 FROM SCM_MGR.GT_PRDM1_MSHYCHU1)
          AND A.QTY_PRICE <> 0
          AND A.FCST_TYPE NOT IN (SELECT SEGMENT2 FROM SCM_MGR.GT_PRDM1_MSHYCHU2)
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
               , A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, P.YYYYMMDD
        ORDER BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
               , A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, P.YYYYMMDD
        FETCH FIRST 1 ROWS ONLY;
    EXCEPTION WHEN NO_DATA_FOUND THEN s_unit_price_valid := NULL;
    END;

    IF s_unit_price_valid IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := s_unit_price_valid || 'Unit Price Not Found !' || CHR(10)
                      || '해당주차의 Sales Price 값을 입력하시기 바랍니다.' || CHR(10)
                      || '미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.';
        RAISE e_validation_error;
    END IF;

    --==========================================================================================================================
    -- 10. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A014--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 11. 40 Validation 필요 대상 : RMA 음수 Validation은 MKT_FCST, SCM_FCST Measure에 한정 필요 (START)
    --==========================================================================================================================
    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE FCST_TYPE = 'RMA'
      AND MEASURE IN ('MKT_FCST', 'SCM_FCST')
      AND NVL(CAST(QTY_PRICE AS NUMBER(30,10)), 0) > 0;

    IF v_cnt_check > 0 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '반품수량(RMA)은 음수값만 입력가능합니다 !';
        RAISE e_validation_error;
    END IF;
    --==========================================================================================================================
    -- 11. 40 Validation 필요 대상 : RMA 음수 Validation은 MKT_FCST, SCM_FCST Measure에 한정 필요 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A015--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 12. 40 Validation 필요 대상 : RMA 이외 정수값 확인 (START)
    --==========================================================================================================================
    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE FCST_TYPE <> 'RMA'
      AND NVL(CAST(QTY_PRICE AS NUMBER(30,10)), 0) < 0;

    IF v_cnt_check > 0 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '정수값만 입력가능합니다 !';
        RAISE e_validation_error;
    END IF;
    --==========================================================================================================================
    -- 12. 40 Validation 필요 대상 : RMA 이외 정수값 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A016--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 13. 40 Validation 필요 대상 :  BOM Valid 여부 확인 (START)
    -- 저장하려는 ITEM의 11주 구간에 BOM이 없으면 값을 저장하지 못하도록 함
    --==========================================================================================================================
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET V_BOM_YN = 'N'
    WHERE EXISTS (
        SELECT 1
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
        JOIN SCM_MGR.SCM_MST_ITEM_SN C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
        JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D ON D.LOOKUP_TYPE = 'DM_BOM_EXCEPT_CLASS' AND D.VALID_YN = 'Y' AND C.EVAL_CLASS = D.SEGMENT1
        WHERE B.LOOKUP_TYPE = 'AS_SITE_PLANT'
          AND B.SEGMENT3    = V_DIVISION_ID
          AND B.VALID_YN    = 'Y'
          AND A.V_ATTRIBUTE10 = B.SEGMENT2
    )
    AND A.DIVISION_ID = V_DIVISION_ID
    AND A.MEASURE IN ('MKT_FCST', 'SCM_FCST'); --SCM_FCST - MEASURE 추가

    SELECT COUNT(*) INTO v_cnt_check FROM SCM_MGR.GT_PRDM1_T_MAIN WHERE V_BOM_YN IS NULL;

    IF v_cnt_check > 0 THEN
        -- 저장전 변수 초기화
        v_valid_bom  := NULL;
        v_valid_shipto := NULL;

        BEGIN
            SELECT A.ITEM_ID INTO v_valid_bom
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            INNER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V C
                    ON A.ITEM_ID       = C.ITEM_ID
                   AND A.DIVISION_ID   = C.DIVISION_ID
                   AND C.ITEM_TYPE IN ('P', 'H')
                   AND C.ACTIVE_FLAG   = 'Y'
            LEFT JOIN SCM_MGR.SCM_MST_BOM_ENG_SN X
                   ON A.DIVISION_ID = X.DIVISION_ID AND A.ITEM_ID = X.PARENT_ITEM_ID
            LEFT JOIN (
                SELECT DIVISION_ID
                     , CASE WHEN DIVISION_ID IN ('82', '40') THEN '' ELSE FROM_SITE END FROM_SITE
                     , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                FROM SCM_MGR.SCP_MST_BOD_V
                WHERE PRIORITY = 1
                GROUP BY DIVISION_ID
                       , CASE WHEN DIVISION_ID IN ('82', '40') THEN '' ELSE FROM_SITE END
                       , TO_SITE, INCOTERMS
            ) BOD ON A.DIVISION_ID  = BOD.DIVISION_ID
                 AND A.PLANT_SITE_ID = BOD.FROM_SITE
                 AND A.SCM_SITE_ID   = BOD.TO_SITE
                 AND A.INCOTERMS     = BOD.INCOTERMS
            WHERE A.MEASURE IN ('MKT_FCST', 'Vmi_In_Req', 'SCM_FCST') --SCM_FCST - MEASURE 추가
              AND A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')   -- 당주 월요일부터
              AND A.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') + NVL(BOD.LT_TOTAL, 0) + 7 * 10, 'YYYYMMDD')   -- 당주 월요일 + 11주 까지
              AND A.QTY_PRICE > 0
              AND X.PARENT_ITEM_ID IS NULL  -- 존재하지 않는대상
              AND A.ITEM_ID NOT IN ('ECE0074N5-01')
              AND A.ITEM_ID NOT IN ('MCCH120022B2-K', 'MCCH120022B2-GD')
              AND A.V_BOM_YN IS NULL
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_bom := NULL;
        END;

        IF v_valid_bom IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_bom || '] BOM does not exist !';
            RAISE e_validation_error;
        END IF;
    END IF;

    --==========================================================================================================================
    -- 14. 40 Validation 필요 대상 :  BOM Valid 여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A017--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 15. 40 Validation 필요 대상 :  ShipTo Valid 여부 확인 (START)
    -- 저장하려는 SITE의 11주 구간에 SHIPTO 연결 없으면 값을 저장하지 못하도록 함
    --==========================================================================================================================
    BEGIN
        v_valid_shipto := NULL;
        BEGIN
            SELECT A.SCM_SITE_ID INTO v_valid_shipto
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            LEFT JOIN SCM_MGR.SCM_MST_SITE_CUSTOMER X
                   ON A.DIVISION_ID = X.DIVISION_ID
                  AND A.SCM_SITE_ID = X.SCM_SITE_ID
                  AND X.VALID_YN    = 'Y'
                  AND X.REP_YN      = 'Y'
            LEFT JOIN (
                SELECT DIVISION_ID
                     , CASE WHEN DIVISION_ID IN ('82', '40') THEN '' ELSE FROM_SITE END FROM_SITE
                     , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                FROM SCM_MGR.SCP_MST_BOD_V
                WHERE PRIORITY = 1
                GROUP BY DIVISION_ID
                       , CASE WHEN DIVISION_ID IN ('82', '40') THEN '' ELSE FROM_SITE END
                       , TO_SITE, INCOTERMS
            ) BOD ON A.DIVISION_ID  = BOD.DIVISION_ID
                 AND A.PLANT_SITE_ID = BOD.FROM_SITE
                 AND A.SCM_SITE_ID   = BOD.TO_SITE
                 AND A.INCOTERMS     = BOD.INCOTERMS
            WHERE A.MEASURE IN ('MKT_FCST', 'Vmi_In_Req', 'SCM_FCST') --[PJ2025-50188] SCM_FCST - MEASURE 추가
              AND A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')   -- 당주 월요일부터
              AND A.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') + NVL(BOD.LT_TOTAL, 0) + 7 * 3, 'YYYYMMDD')   -- BOD LT + 4W
              AND A.QTY_PRICE > 0
              AND X.SHIPTO_CODE IS NULL
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_shipto := NULL;
        END;

        IF v_valid_shipto IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_shipto || '] SITE SHIP-TO does not exist !';
            RAISE e_validation_error;
        END IF;
    END;
    --==========================================================================================================================
    -- 15. 40 Validation 필요 대상 :  ShipTo Valid 여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A018--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 16. 40 Validation 필요 대상 :  RMA 인 경우에 RTF를 MKT_FCST와 동일하게 생성 (START)
    --==========================================================================================================================
    v_plan_start_yyyymmdd := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');  -- 월요일 변수설정

    DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    WHERE A.MEASURE = 'RTF_SYS_RP'
      AND A.YYYYMMDD >= v_plan_start_yyyymmdd -- 당주 월요일이후
      AND EXISTS (
            SELECT RSLT.DIVISION_ID
            FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
               , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
            WHERE RSLT.DIVISION_ID         = ITEM.DIVISION_ID
              AND RSLT.ITEM_ID             = ITEM.ITEM_ID
              AND A.DIVISION_ID            = RSLT.DIVISION_ID
              AND A.PROJECT_CODE           = RSLT.PROJECT_CODE
              AND A.END_CUSTOMER           = RSLT.END_CUSTOMER
              AND A.SCM_SITE_ID            = RSLT.SCM_SITE_ID
              AND A.ITEM_ID                = RSLT.ITEM_ID
              AND A.DOM_EXP                = RSLT.DOM_EXP
              AND A.FCST_TYPE              = RSLT.FCST_TYPE
              AND A.INCOTERMS              = RSLT.INCOTERMS
              AND A.PLANT_SITE_ID          = RSLT.PLANT_SITE_ID
              AND A.CELL_PROD_SITE_ID      = RSLT.CELL_PROD_SITE_ID
              AND ITEM.ACTIVE_FLAG         = 'Y'
              AND RSLT.FCST_TYPE           = 'RMA'
      );

    INSERT INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    , PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
    , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID )
    SELECT RSLT.DIVISION_ID, RSLT.PROJECT_CODE, RSLT.END_CUSTOMER, RSLT.SCM_SITE_ID, RSLT.ITEM_ID
         , RSLT.DOM_EXP, RSLT.FCST_TYPE, RSLT.INCOTERMS, 'RTF_SYS_RP' AS MEASURE
         , RSLT.PLANT_SITE_ID, RSLT.YYYYMMDD
         --[E20260309-000271]_ISNULL처리 추가 (START)
         , NVL(RSLT.QTY_PRICE, 0) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
         --[E20260309-000271]_ISNULL처리 추가 (END)
         , 'SYSTEM' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'SYSTEM' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
         , RSLT.V_ATTRIBUTE1, RSLT.V_ATTRIBUTE2, RSLT.V_ATTRIBUTE3, RSLT.V_ATTRIBUTE4, RSLT.V_ATTRIBUTE5
         , RSLT.V_ATTRIBUTE6, RSLT.V_ATTRIBUTE7, RSLT.V_ATTRIBUTE8, RSLT.V_ATTRIBUTE9, RSLT.V_ATTRIBUTE10
         , RSLT.CELL_PROD_SITE_ID
    FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
    INNER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
            ON RSLT.DIVISION_ID  = ITEM.DIVISION_ID
           AND RSLT.ITEM_ID      = ITEM.ITEM_ID
           AND ITEM.ACTIVE_FLAG  = 'Y'
           AND RSLT.FCST_TYPE    = 'RMA'
    WHERE RSLT.MEASURE IN ('MKT_FCST', 'SCM_FCST') -- SCM_FCST - MEASURE 추가
      AND RSLT.YYYYMMDD >= v_plan_start_yyyymmdd; -- 당주 월요일이후

    --==========================================================================================================================
    -- 16. 40 Validation 필요 대상 :  RMA 인 경우에 RTF를 MKT_FCST와 동일하게 생성 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A018_cont--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 17. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (START)
    -- DM_PLN_CFM_SELLING_PRICE Validation Check
    --==========================================================================================================================
    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE (DIVISION_ID LIKE '81%' OR DIVISION_ID = '40');

    IF v_cnt_check > 0 THEN
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM ITEM
                         ON ITEM.DIVISION_ID = A.DIVISION_ID
                        AND ITEM.SCM_SITE_ID = A.SCM_SITE_ID
                        AND ITEM.ITEM_ID     = A.ITEM_ID
                        AND ITEM.VALID_YN    = 'Y'
            LEFT OUTER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V SN
                         ON ITEM.DIVISION_ID = SN.DIVISION_ID
                        AND ITEM.ITEM_ID     = SN.ITEM_ID
                        AND SN.ACTIVE_FLAG   = 'Y'
            WHERE A.QTY_PRICE <> 0
              AND (ITEM.ITEM_ID IS NULL OR SN.ITEM_ID IS NULL)
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] Invalid Site Item ID !';
            RAISE e_validation_error;
        END IF;
    END IF;

    --==========================================================================================================================
    -- 17. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A019--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- Measure가 LOC이면서 , 같은 월의 같은 주차의 합이 0이라면 D로 업데이트 한다. 그 외는 M으로 업데이트 한다. (START)
    --==========================================================================================================================
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET ACTION = (
        SELECT CASE WHEN SUM(B.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW || D.PARTIAL_WEEK_NAME) = 0 THEN 'D' ELSE 'M' END
        FROM SCM_MGR.GT_PRDM1_T_MAIN B
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON B.YYYYMMDD = D.BASIS_YYYYMMDD
        WHERE B.MEASURE = 'LOC' AND B.ACTION <> 'I'
          AND B.YYYYMMDD = A.YYYYMMDD
        FETCH FIRST 1 ROWS ONLY
    )
    WHERE A.MEASURE = 'LOC' AND A.ACTION <> 'I';
    --==========================================================================================================================
    -- Measure가 LOC이면서 , 같은 월의 같은 주차의 합이 0이라면 D로 업데이트 한다. 그 외는 M으로 업데이트 한다.(END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A020--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 18. 40 Validation 필요 대상 : SALES PRICE를 삭제하는 경우 52주간 MKT FCST or RTF 데이터 확인 (START)
    --==========================================================================================================================
    v_invalid_Site := NULL;
    n_Dflag_chk    := 0;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- ACTIVE_FLAG가 한건이라도 D인경우에만 처리한다.
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO n_Dflag_chk
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE = 'LOC' AND ACTION = 'D';  -- Delete 가능 - UI에서 MKT_FCST를 D로 보내는 경우가 있어서 작성함.

    IF n_Dflag_chk > 0 THEN
        -----------------------------------------------------------------------------------------------------------------------------------
        -- 52주 이후의 데이터의 FLAG를 0으로 변경하여 삭제하려고 하는 경우는 아래 로직으로 데이터를 확인한다.
        -----------------------------------------------------------------------------------------------------------------------------------
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F
                JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON A.YYYYMMDD = D.BASIS_YYYYMMDD
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND A.MEASURE        = 'LOC'
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req', 'SCM_FCST') -- SCM_FCST - MEASURE 추가
                      AND F.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
                      -----------------------------------------------------------------------------------------------------------------------------------
                      -- [E20250825-000297]_52주구간은 당주월요일 기준으로 52주구간을 구한다 원소스 주석처리 (START)
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      -- [E20250825-000297]_(END)
                      -----------------------------------------------------------------------------------------------------------------------------------
                      AND B.ISO_YYYYWW = D.ISO_YYYYWW
                      AND F.QTY <> 0  -- 제로값은 제외함
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )  -- 무상제공인경우는 Validation 에서 제외
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이후 동일 주차에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;

        -----------------------------------------------------------------------------------------------------------------------------------
        -- 52주 이내의 데이터의 FLAG를 0으로 변경하여 삭제하려고 하는 경우는 아래 로직으로 데이터를 확인한다.
        -----------------------------------------------------------------------------------------------------------------------------------
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req', 'SCM_FCST')  -- SCM_FCST - MEASURE 추가
                      AND F.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
                      -----------------------------------------------------------------------------------------------------------------------------------
                      -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') -- 당주 월요일 이후건만 확인
                      AND F.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD') -- 52주후 월요일까지
                      -- [E20250825-000297]_(END)
                      -----------------------------------------------------------------------------------------------------------------------------------
                      AND F.QTY <> 0  -- 제로값은 제외함
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )  -- 무상제공인경우는 Validation 에서 제외
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;
    END IF;

    --==========================================================================================================================
    -- 18. 40 Validation 필요 대상 : SALES PRICE를 삭제하는 경우 52주간 MKT FCST or RTF 데이터 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A021--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- Validaion Check (END)
    --==========================================================================================================================
    --==========================================================================================================================
    -- VALIDATION 종료 (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 3. VALIDATION CHECK END';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- VALIDATION 종료 (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- #T_MAIN 테이블에 메져를 추가한다. (START)
    -- DM_PLN_CFM_SELLING_PRICE 테이블 기준 MEASURE
    -- 'KRW','USD','LOC'
    --  KRW , USD 2개를 만드는 로직 추가해야함
    --==========================================================================================================================
    ----------------------------------------------------------------------------------------------------------------------------
    -- 1. 환율정보 가져옴.
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_TEMP_EXCH
    ( DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE )
    SELECT DISTINCT A.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, A.UNIT_CURRENCY, A.EXCHANGE_PRICE
    FROM SCM_MGR.DM_MST_EXCHANGE_RATE A
    JOIN SCM_MGR.GT_PRDM1_T_MAIN B
      ON A.DIVISION_ID = B.DIVISION_ID
     AND A.YYYYMMDD   = SUBSTR(B.YYYYMMDD, 1, 6) || '01'
     AND A.CURRENCY   = 'KRW'
    WHERE B.MEASURE = 'LOC';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_EXCH');

    ----------------------------------------------------------------------------------------------------------------------------
    -- 2. KRW, USD 메져 환율정보로 계산하여 추가
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
    ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY
    , QTY_PRICE, CREATED_BY
    , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5, V_ATTRIBUTE6
    , V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
    SELECT T.ACTION, T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
         , 'KRW' AS MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY
         --[E20260309-000271]_ISNULL처리 추가 (START)
         , ROUND(NVL(T.QTY_PRICE, 0) * CASE WHEN T.CURRENCY = 'KRW' THEN 1 ELSE EX.EXCHANGE_PRICE END, 3) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
         --[E20260309-000271]_ISNULL처리 추가 (END)
         , T.CREATED_BY, '', '', '', '', '', '', '', '', '', '', '', ''
    FROM SCM_MGR.GT_PRDM1_T_MAIN T
    LEFT OUTER JOIN SCM_MGR.GT_PRDM1_TEMP_EXCH EX
                 ON EX.DIVISION_ID   = T.DIVISION_ID
                AND EX.UNIT_CURRENCY = T.CURRENCY
                AND EX.YYYYMMDD     LIKE SUBSTR(T.YYYYMMDD, 1, 6) || '%'
                AND EX.CURRENCY      = 'KRW'
    WHERE T.MEASURE = 'LOC'
    UNION ALL
    SELECT T.ACTION, T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
         , 'USD' AS MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY
         --[E20260309-000271]_ISNULL처리 추가 (START)
         , ROUND(ROUND((NVL(T.QTY_PRICE, 0) * CASE WHEN T.CURRENCY = 'KRW' THEN 1 ELSE EX.EXCHANGE_PRICE END), 3) / USD.EXCHANGE_PRICE, 3) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
         --[E20260309-000271]_ISNULL처리 추가 (END)
         , T.CREATED_BY, '', '', '', '', '', '', '', '', '', '', '', ''
    FROM SCM_MGR.GT_PRDM1_T_MAIN T
    LEFT OUTER JOIN SCM_MGR.GT_PRDM1_TEMP_EXCH EX
                 ON EX.DIVISION_ID   = T.DIVISION_ID
                AND EX.UNIT_CURRENCY = T.CURRENCY
                AND EX.YYYYMMDD     LIKE SUBSTR(T.YYYYMMDD, 1, 6) || '%'
    LEFT OUTER JOIN SCM_MGR.GT_PRDM1_TEMP_EXCH USD
                 ON USD.DIVISION_ID   = T.DIVISION_ID
                AND USD.YYYYMMDD     LIKE SUBSTR(T.YYYYMMDD, 1, 6) || '%'
                AND USD.CURRENCY      = 'KRW'
                AND USD.UNIT_CURRENCY = 'USD'
    WHERE T.MEASURE = 'LOC';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_MAIN');

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A022--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    ----------------------------------------------------------------------------------------------------------------------------
    -- 3. MKT_AMT_KRW, MKT_AMT_LOC 메져 환율정보로 계산하여 추가
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
    ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY
    , QTY_PRICE, CREATED_BY
    , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5, V_ATTRIBUTE6
    , V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
    SELECT AMT.ACT, AMT.DIVISION_ID, AMT.PROJECT_CODE, AMT.END_CUSTOMER, AMT.SCM_SITE_ID, AMT.ITEM_ID, AMT.DOM_EXP, AMT.FCST_TYPE
         , AMT.INCOTERMS, AMT.MEASURE, AMT.PLANT_SITE_ID, AMT.CELL_PROD_SITE_ID, AMT.YYYYMMDD, MAX(AMT.CURRENCY) AS CURRENCY
         , SUM(AMT.QTY) AS QTY
         , MAX(AMT.CREATED_BY) AS CREATED_BY, MAX(AMT.V_ATTRIBUTE1) AS V_ATTRIBUTE1, MAX(AMT.V_ATTRIBUTE2) AS V_ATTRIBUTE2
         , MAX(AMT.V_ATTRIBUTE3) AS V_ATTRIBUTE3, MAX(AMT.V_ATTRIBUTE4) AS V_ATTRIBUTE4, MAX(AMT.V_ATTRIBUTE5) AS V_ATTRIBUTE5
         , MAX(AMT.V_ATTRIBUTE6) AS V_ATTRIBUTE6, MAX(AMT.V_ATTRIBUTE7) AS V_ATTRIBUTE7, MAX(AMT.V_ATTRIBUTE8) AS V_ATTRIBUTE8
         , MAX(AMT.V_ATTRIBUTE9) AS V_ATTRIBUTE9, MAX(AMT.V_ATTRIBUTE10) AS V_ATTRIBUTE10
         , MAX(AMT.V_BOM_YN) AS V_BOM_YN, MAX(AMT.V_VMI_YN) AS V_VMI_YN
    FROM (
        SELECT W.ACTION AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID
             , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
             , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                    WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
               END AS MEASURE
             , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD, '' AS CURRENCY
             --[E20260309-000271]_ISNULL처리 추가 (START)
             , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
                    WHEN SP.MEASURE = 'LOC' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
               END AS QTY
             --[E20260309-000271]_ISNULL처리 추가 (END)
             , W.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM SCM_MGR.GT_PRDM1_T_MAIN W
        INNER JOIN SCM_MGR.GT_PRDM1_T_MAIN SP
                ON SP.DIVISION_ID       = W.DIVISION_ID
               AND SP.PROJECT_CODE      = W.PROJECT_CODE
               AND SP.END_CUSTOMER      = W.END_CUSTOMER
               AND SP.SCM_SITE_ID       = W.SCM_SITE_ID
               AND SP.ITEM_ID           = W.ITEM_ID
               AND SP.DOM_EXP           = W.DOM_EXP
               AND SP.FCST_TYPE         = W.FCST_TYPE
               AND SP.INCOTERMS         = W.INCOTERMS
               AND SP.PLANT_SITE_ID     = W.PLANT_SITE_ID
               AND SP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
               AND SP.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
               AND SP.MEASURE IN ('LOC', 'KRW')
        WHERE W.MEASURE = 'MKT_FCST'
        UNION ALL
        SELECT W.ACTION AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID
             , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
             , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                    WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
               END AS MEASURE
             , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD, '' AS CURRENCY
             --[E20260309-000271]_ISNULL처리 추가 (START)
             , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
                    WHEN SP.MEASURE = 'LOC' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
               END AS QTY
             --[E20260309-000271]_ISNULL처리 추가 (END)
             , W.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM SCM_MGR.GT_PRDM1_T_MAIN W
        INNER JOIN SCM_MGR.DM_PLN_CFM_SELLING_PRICE SP
                ON SP.DIVISION_ID       = W.DIVISION_ID
               AND SP.PROJECT_CODE      = W.PROJECT_CODE
               AND SP.END_CUSTOMER      = W.END_CUSTOMER
               AND SP.SCM_SITE_ID       = W.SCM_SITE_ID
               AND SP.ITEM_ID           = W.ITEM_ID
               AND SP.DOM_EXP           = W.DOM_EXP
               AND SP.FCST_TYPE         = W.FCST_TYPE
               AND SP.INCOTERMS         = W.INCOTERMS
               AND SP.PLANT_SITE_ID     = W.PLANT_SITE_ID
               AND SP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
               AND SP.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
               AND SP.MEASURE IN ('LOC', 'KRW')
        WHERE W.MEASURE = 'MKT_FCST'
          AND NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN W2
                          WHERE W2.DIVISION_ID       = W.DIVISION_ID
                            AND W2.PROJECT_CODE      = W.PROJECT_CODE
                            AND W2.END_CUSTOMER      = W.END_CUSTOMER
                            AND W2.SCM_SITE_ID       = W.SCM_SITE_ID
                            AND W2.ITEM_ID           = W.ITEM_ID
                            AND W2.DOM_EXP           = W.DOM_EXP
                            AND W2.FCST_TYPE         = W.FCST_TYPE
                            AND W2.INCOTERMS         = W.INCOTERMS
                            AND W2.PLANT_SITE_ID     = W.PLANT_SITE_ID
                            AND W2.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
                            AND W2.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
                            AND W2.MEASURE IN ('LOC', 'KRW'))
        UNION ALL
        SELECT SP.ACTION AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID
             , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
             , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                    WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
               END AS MEASURE
             , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD, '' AS CURRENCY
             --[E20260309-000271]_ISNULL처리 추가 (START)
             , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(TO_CHAR(NVL(W.QTY, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
                    WHEN SP.MEASURE = 'LOC' THEN CAST(TO_CHAR(NVL(W.QTY, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
               END AS QTY
             --[E20260309-000271]_ISNULL처리 추가 (END)
             , SP.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN W
        INNER JOIN SCM_MGR.GT_PRDM1_T_MAIN SP
                ON SP.DIVISION_ID       = W.DIVISION_ID
               AND SP.PROJECT_CODE      = W.PROJECT_CODE
               AND SP.END_CUSTOMER      = W.END_CUSTOMER
               AND SP.SCM_SITE_ID       = W.SCM_SITE_ID
               AND SP.ITEM_ID           = W.ITEM_ID
               AND SP.DOM_EXP           = W.DOM_EXP
               AND SP.FCST_TYPE         = W.FCST_TYPE
               AND SP.INCOTERMS         = W.INCOTERMS
               AND SP.PLANT_SITE_ID     = W.PLANT_SITE_ID
               AND SP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
               AND SP.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
               AND SP.MEASURE IN ('LOC', 'KRW')
        WHERE W.MEASURE = 'MKT_FCST'
          AND NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN W2
                          WHERE W2.DIVISION_ID       = W.DIVISION_ID
                            AND W2.PROJECT_CODE      = W.PROJECT_CODE
                            AND W2.END_CUSTOMER      = W.END_CUSTOMER
                            AND W2.SCM_SITE_ID       = W.SCM_SITE_ID
                            AND W2.ITEM_ID           = W.ITEM_ID
                            AND W2.DOM_EXP           = W.DOM_EXP
                            AND W2.FCST_TYPE         = W.FCST_TYPE
                            AND W2.INCOTERMS         = W.INCOTERMS
                            AND W2.PLANT_SITE_ID     = W.PLANT_SITE_ID
                            AND W2.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
                            AND W2.YYYYMMDD          = W.YYYYMMDD
                            AND W2.MEASURE           = W.MEASURE)
        --[E20251208-000309]_0인 경우를 처리하는 로직이 존재하지 않아서, 0인 경우에 MKT FCST AMT 생성하도록 추가 (START)
        UNION ALL
        SELECT T.ACTION AS ACT, T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID
             , T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, B.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY
             --[E20260309-000271]_ISNULL처리 추가 (START)
             , NVL(T.QTY_PRICE, 0) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
             --[E20260309-000271]_ISNULL처리 추가 (END)
             , T.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM (SELECT * FROM SCM_MGR.GT_PRDM1_T_MAIN WHERE QTY_PRICE = 0 AND MEASURE = 'MKT_FCST') T,
        (SELECT 'MKT_AMT_KRW' MEASURE FROM DUAL
         UNION
         SELECT 'MKT_AMT_LOC' MEASURE FROM DUAL
        ) B
        --[E20251208-000309]_0인 경우를 처리하는 로직이 존재하지 않아서, 0인 경우에 MKT FCST AMT 생성하도록 추가 (END)
    ) AMT
    GROUP BY AMT.ACT, AMT.DIVISION_ID, AMT.PROJECT_CODE, AMT.END_CUSTOMER, AMT.SCM_SITE_ID, AMT.ITEM_ID
           , AMT.DOM_EXP, AMT.FCST_TYPE, AMT.INCOTERMS, AMT.MEASURE, AMT.PLANT_SITE_ID, AMT.CELL_PROD_SITE_ID, AMT.YYYYMMDD;

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_MAIN');

    --==========================================================================================================================
    -- #T_MAIN 테이블에 메져를 추가한다. (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A023--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 환율정보로 계산 (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 4. MKT_AMT_KRW, MKT_AMT_LOC, LOC, KRW #T_MAIN IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- 환율정보로 계산 (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE 데이터 작업 시작 (START)
    --==========================================================================================================================
    V_GETDATE := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_SELLING_PRICE START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    -- Phase 1: DELETE existing rows where new QTY_PRICE = 0
    DELETE FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
    WHERE EXISTS (
        SELECT 1 FROM (
            SELECT M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER, M.SCM_SITE_ID, M.PLANT_SITE_ID
                 , M.CELL_PROD_SITE_ID, M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP, M.FCST_TYPE, M.INCOTERMS, M.QTY_PRICE
                 , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                  , M.SCM_SITE_ID, M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID
                                                  , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                  , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('KRW', 'USD', 'LOC')
        ) B
        WHERE RN = 1
          AND B.QTY_PRICE = 0
          AND B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.END_CUSTOMER = A.END_CUSTOMER
          AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.PLANT_SITE_ID = A.PLANT_SITE_ID AND B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
          AND B.ITEM_ID = A.ITEM_ID AND B.YYYYMMDD = A.YYYYMMDD AND B.MEASURE = A.MEASURE
          AND B.DOM_EXP = A.DOM_EXP AND B.FCST_TYPE = A.FCST_TYPE AND B.INCOTERMS = A.INCOTERMS
    );

    -- Phase 2: MERGE non-zero rows (UPDATE matched / INSERT unmatched)
    MERGE INTO SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
    USING (SELECT * FROM (
               SELECT M.*
                    , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                     , M.SCM_SITE_ID, M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID
                                                     , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                     , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
               FROM SCM_MGR.GT_PRDM1_T_MAIN M
               WHERE M.MEASURE IN ('KRW', 'USD', 'LOC') AND M.QTY_PRICE <> 0)
           WHERE RN = 1) B
    ON (A.DIVISION_ID       = B.DIVISION_ID
    AND A.PROJECT_CODE      = B.PROJECT_CODE
    AND A.END_CUSTOMER      = B.END_CUSTOMER
    AND A.SCM_SITE_ID       = B.SCM_SITE_ID
    AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
    AND A.ITEM_ID           = B.ITEM_ID
    AND A.YYYYMMDD          = B.YYYYMMDD
    AND A.MEASURE           = B.MEASURE
    AND A.DOM_EXP           = B.DOM_EXP
    AND A.FCST_TYPE         = B.FCST_TYPE
    AND A.INCOTERMS         = B.INCOTERMS)
    WHEN MATCHED THEN
    UPDATE
    SET A.CURRENCY         = B.CURRENCY
      , A.PRICE            = B.QTY_PRICE
      , A.LAST_UPDATED_BY  = B.CREATED_BY
      , A.LAST_UPDATE_DATE = V_GETDATE
    WHEN NOT MATCHED THEN
    INSERT
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
    VALUES
    ( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.CURRENCY, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_SELLING_PRICE END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE 데이터 작업 시작 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A024--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE 테이블 IMPORT (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 5. DM_PLN_CFM_SELLING_PRICE IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE 테이블 IMPORT (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN 데이터 작업 시작 (START)
    /* DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 기준 MEASURE */
    -- 수정 및 INSERT가 가능한 'MKT_FCST','VMI_In_Req'만 해당 된다.
    -- SCM_FCST 는 수정만 된다. ( INSERT 불가능 , UI에서 막음. )
    --==========================================================================================================================
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_MKT_DEMAND_PLAN START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    -- 행 Delete 가능 - 편집 가능, 삭제 불가 행의 경우 값 일괄 업데이트 - D로 들어올 경우도 존재 한다.
    -- Phase 1: DELETE MKT_AMT rows where new QTY = 0
    DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    WHERE A.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
      AND EXISTS (
        SELECT 1 FROM (
            SELECT M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER, M.SCM_SITE_ID
                 , M.ITEM_ID, M.DOM_EXP, M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                 , M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID, M.YYYYMMDD, M.QTY_PRICE
                 , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                  , M.SCM_SITE_ID, M.ITEM_ID, M.DOM_EXP
                                                  , M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                                                  , M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID, M.YYYYMMDD ORDER BY ROWNUM) AS RN
            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
        ) B
        WHERE RN = 1
          AND B.QTY_PRICE = 0
          AND B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.END_CUSTOMER = A.END_CUSTOMER
          AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOM_EXP = A.DOM_EXP
          AND B.FCST_TYPE = A.FCST_TYPE AND B.INCOTERMS = A.INCOTERMS AND B.MEASURE = A.MEASURE
          AND B.PLANT_SITE_ID = A.PLANT_SITE_ID AND B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID AND B.YYYYMMDD = A.YYYYMMDD
    );

    -- Phase 2: MERGE non-zero rows (UPDATE matched / INSERT unmatched for MKT_FCST,VMI_In_Req only)
    -- SCM_FCST 는 수정만 된다. ( INSERT 불가능 )
    MERGE INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    USING (SELECT * FROM (
               SELECT M.*
                    , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                     , M.SCM_SITE_ID, M.ITEM_ID, M.DOM_EXP
                                                     , M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                                                     , M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID, M.YYYYMMDD ORDER BY ROWNUM) AS RN
               FROM SCM_MGR.GT_PRDM1_T_MAIN M
               WHERE M.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'MKT_AMT_KRW', 'MKT_AMT_LOC', 'SCM_FCST') -- SCM_FCST - MEASURE 추가
                 AND M.QTY_PRICE <> 0)
           WHERE RN = 1) B
    ON (A.DIVISION_ID       = B.DIVISION_ID
    AND A.PROJECT_CODE      = B.PROJECT_CODE
    AND A.END_CUSTOMER      = B.END_CUSTOMER
    AND A.SCM_SITE_ID       = B.SCM_SITE_ID
    AND A.ITEM_ID           = B.ITEM_ID
    AND A.DOM_EXP           = B.DOM_EXP
    AND A.FCST_TYPE         = B.FCST_TYPE
    AND A.INCOTERMS         = B.INCOTERMS
    AND A.MEASURE           = B.MEASURE
    AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
    AND A.YYYYMMDD          = B.YYYYMMDD)
    WHEN MATCHED THEN
    UPDATE
    SET A.QTY              = B.QTY_PRICE
      , A.LAST_UPDATED_BY  = B.CREATED_BY
      , A.LAST_UPDATE_DATE = V_GETDATE
    WHEN NOT MATCHED THEN
    INSERT
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
    VALUES
    ( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_MKT_DEMAND_PLAN END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN 데이터 작업 시작 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A025--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 IMPORT (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 6. DM_PLN_CFM_MKT_DEMAND_PLAN IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 IMPORT (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A025_EE--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --[E20251209-000712]_전극의 경우 SCP RTF를 받아오지 않도록 처리했기때문에, MKT FCST 수정시 -> MKT FCST 메져로 RTF 생성 / SCM FCST 수정시 -> SCM FCST 메져로 RTF 생성하도록 수정 (START)
    --==========================================================================================================================
    -- 전극인 경우에는 RTF를 생성해준다 (SCP RTF를 반영하지 않기때문에) (START)
    --==========================================================================================================================
    n_EE_chk := 0;
    SELECT COUNT(*) INTO n_EE_chk
    FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
       , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
    WHERE RSLT.DIVISION_ID = ITEM.DIVISION_ID
      AND RSLT.ITEM_ID     = ITEM.ITEM_ID
      AND ITEM.ACTIVE_FLAG = 'Y'
      --↓전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
      AND RSLT.ITEM_ID IN (
            SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
            WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
      );

    IF n_EE_chk > 0 THEN
        DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        WHERE A.MEASURE  = 'RTF_SYS_RP'
          AND A.YYYYMMDD >= v_plan_start_yyyymmdd -- 당주 월요일이후
          AND EXISTS (
                SELECT RSLT.DIVISION_ID
                FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
                   , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                WHERE RSLT.DIVISION_ID         = ITEM.DIVISION_ID
                  AND RSLT.ITEM_ID             = ITEM.ITEM_ID
                  AND A.DIVISION_ID            = RSLT.DIVISION_ID
                  AND A.PROJECT_CODE           = RSLT.PROJECT_CODE
                  AND A.END_CUSTOMER           = RSLT.END_CUSTOMER
                  AND A.SCM_SITE_ID            = RSLT.SCM_SITE_ID
                  AND A.ITEM_ID                = RSLT.ITEM_ID
                  AND A.DOM_EXP                = RSLT.DOM_EXP
                  AND A.FCST_TYPE              = RSLT.FCST_TYPE
                  AND A.INCOTERMS              = RSLT.INCOTERMS
                  AND A.PLANT_SITE_ID          = RSLT.PLANT_SITE_ID
                  AND A.CELL_PROD_SITE_ID      = RSLT.CELL_PROD_SITE_ID
                  AND ITEM.ACTIVE_FLAG         = 'Y'
                  --↓전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                  AND RSLT.ITEM_ID IN (
                        SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                        WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                  )  --20180720 ACTIVE_FLAG 조건추가
          );

        INSERT INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
        , PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
        , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , 'RTF_SYS_RP' AS MEASURE
             , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY, 'DMF0082_SYSTEM' AS CREATED_BY, SYSDATE AS CREATION_DATE
             , 'DMF0082_SYSTEM' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
             , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.CELL_PROD_SITE_ID
        FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        WHERE A.MEASURE = (SELECT MEASURE FROM SCM_MGR.GT_PRDM1_T_MAIN WHERE MEASURE IN ('SCM_FCST', 'MKT_FCST') GROUP BY MEASURE FETCH FIRST 1 ROWS ONLY)
          AND A.YYYYMMDD >= v_plan_start_yyyymmdd -- 당주 월요일이후
          AND EXISTS (
                SELECT RSLT.DIVISION_ID
                FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
                   , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                WHERE RSLT.DIVISION_ID    = ITEM.DIVISION_ID
                  AND RSLT.ITEM_ID        = ITEM.ITEM_ID
                  AND A.DIVISION_ID       = RSLT.DIVISION_ID
                  AND A.PROJECT_CODE      = RSLT.PROJECT_CODE
                  AND A.END_CUSTOMER      = RSLT.END_CUSTOMER
                  AND A.SCM_SITE_ID       = RSLT.SCM_SITE_ID
                  AND A.ITEM_ID           = RSLT.ITEM_ID
                  AND A.DOM_EXP           = RSLT.DOM_EXP
                  AND A.FCST_TYPE         = RSLT.FCST_TYPE
                  AND A.INCOTERMS         = RSLT.INCOTERMS
                  AND A.PLANT_SITE_ID     = RSLT.PLANT_SITE_ID
                  AND A.CELL_PROD_SITE_ID = RSLT.CELL_PROD_SITE_ID
                  AND ITEM.ACTIVE_FLAG    = 'Y'
                  --↓전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                  AND RSLT.ITEM_ID IN (
                        SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                        WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                  )  --20180720 ACTIVE_FLAG 조건추가
          );

        --[E20260107-001651]_룩업에 설정된 값으로 ATTRIBUTE2 UPDATE (BPS I/F시 FROM_SITE_ID 전송하기 위함) START
        UPDATE SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        SET A.ATTRIBUTE2 = (SELECT LOOK.SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
                             WHERE LOOK.LOOKUP_TYPE = 'DM_ELECTROD_FROM_SITE_ID' AND LOOK.VALID_YN = 'Y'
                               AND A.DIVISION_ID = LOOK.SEGMENT1 AND ROWNUM = 1)
        WHERE A.MEASURE  = 'RTF_SYS_RP'
          AND A.YYYYMMDD >= v_plan_start_yyyymmdd
          AND EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
                WHERE LOOK.LOOKUP_TYPE = 'DM_ELECTROD_FROM_SITE_ID' AND LOOK.VALID_YN = 'Y'
                  AND A.DIVISION_ID = LOOK.SEGMENT1
                  AND A.ITEM_ID LIKE '' || NVL(LOOK.ATTRIBUTE1, A.ITEM_ID) || '%'
                  AND A.ITEM_ID IN (
                        SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                        WHERE K.DIVISION_ID = A.DIVISION_ID AND K.SCP_OPERATION_GROUP = LOOK.SEGMENT2 AND K.ACTIVE_FLAG = 'Y'
                  )
          );
        --[E20260107-001651]_룩업에 설정된 값으로 ATTRIBUTE2 UPDATE (BPS I/F시 FROM_SITE_ID 전송하기 위함) END

        n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인

        --==========================================================================================================================
        -- DM_PLN_CFM_MKT_DEMAND_PLAN_EE 테이블 IMPORT (START)
        --==========================================================================================================================
        V_LOG_TYPE    := 'ING';
        V_LOG_MESSAGE := '■ 6_EE. DM_PLN_CFM_MKT_DEMAND_PLAN_EE IMPORT';
        N_LOG_COUNT   := n_update_cnt;
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;

        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
            D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
        --==========================================================================================================================
        -- DM_PLN_CFM_MKT_DEMAND_PLAN_EE 테이블 IMPORT (END)
        --==========================================================================================================================
    END IF;
    --==========================================================================================================================
    -- 전극인 경우에는 RTF를 생성해준다 (SCP RTF를 반영하지 않기때문에) (END)
    --==========================================================================================================================
    --[E20251209-000712]_전극의 경우 SCP RTF를 받아오지 않도록 처리했기때문에, MKT FCST 수정시 -> MKT FCST 메져로 RTF 생성 / SCM FCST 수정시 -> SCM FCST 메져로 RTF 생성하도록 수정 (END)
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE_H 데이터 작업 시작 (START)
    --==========================================================================================================================
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_SELLING_PRICE_H START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    INSERT INTO SCM_MGR.DM_PLN_CFM_SELLING_PRICE_H
    ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, PRICE, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE )
    SELECT DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_CFM_SELLING_PRICE_H.NEXTVAL, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
         , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, NVL(QTY_PRICE, 0), CREATED_BY, V_GETDATE
         , CREATED_BY, V_GETDATE, SYSDATE
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE IN ('KRW', 'USD', 'LOC');
    --AND QTY_PRICE <> 0 --[E20251208-000309]_0으로 저장하는 경우에도 이력이 남도록 수정

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_SELLING_PRICE_H END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE_H 데이터 작업 시작 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A026--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE_H 테이블 IMPORT (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 7. DM_PLN_CFM_SELLING_PRICE_H IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 IMPORT (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN_H 데이터 작업 시작 (START)
    --==========================================================================================================================
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_H START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    INSERT INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_H
    ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE )
    SELECT DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_CFM_MKT_DEMAND_PLAN_H.NEXTVAL, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
         , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY_PRICE, CREATED_BY, V_GETDATE
         , CREATED_BY, V_GETDATE
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'MKT_AMT_KRW', 'MKT_AMT_LOC', 'SCM_FCST');
    --AND QTY_PRICE <> 0 --[E20251208-000309]_0으로 저장하는 경우에도 이력이 남도록 수정

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_H END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN_H 데이터 작업 시작 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A027--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN_H 테이블 IMPORT (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 8. DM_PLN_CFM_MKT_DEMAND_PLAN_H IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN_H 테이블 IMPORT (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 START (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 9. PR_DM_PLN_CFM_TO_MKT_FCST START';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 START (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- MKT FCST 데이터 생성 프로시저 호출 시작 (START)
    --==========================================================================================================================
    SCM_MGR.PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);
    --==========================================================================================================================
    -- MKT FCST 데이터 생성 프로시저 호출 시작 (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 END (END)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 10. PR_DM_PLN_CFM_TO_MKT_FCST END';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 END (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A028--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --=============================================================================================================================
    -- 종료 LOG (START)
    --=============================================================================================================================
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## SUCCESS END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    -- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (START)
    --EXEC PR_SCM_SYS_LOG_BATCH $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    -- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (END)
    --=============================================================================================================================
    -- 종료 LOG (END)
    --=============================================================================================================================

    --=============================================================================================================================
    -- 결과코드, 결과 카운트 반환
    --=============================================================================================================================
    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN e_validation_error THEN
        ROLLBACK;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'END', N_LOG_COUNT,
            '########## FAIL-2 END of procedure ##########', V_DESCRIPTION,
            SYSDATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;

        -- 결과코드, 결과 카운트 반환
        OPEN O_RESULT_CURSOR FOR
            SELECT 'F' AS RESULT_CODE, V_DESCRIPTION AS RESULT_MSG, 'Validation Check' AS ERR_EVENT FROM DUAL;

    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := '########## FAIL-1 END of procedure ##########';
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE   := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
            D_EVENT_DATE, v_created_by, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
        ); END;
        RAISE_APPLICATION_ERROR(-20001, V_SQL_ERRMSG || ' ' || V_BACKTRACE);

END DMF0082_SAVE_MAIN_DATA;
/
