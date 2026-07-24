-- =====================================================================
-- DMF0042_P0b — DMF0042_SAVE_DM_PLN_BP_FCST (standalone) 재컴파일 패치 (2026-07-15)
-- 결함: ORA-00918 (ALL_ERRORS LINE 764) — 81 CAR_QTY 파생 INSERT 의 SELECT 목록
--       DEPT_ID 가 GT_SDPB2_BP_FCST_4(F) / SCM_MST_SITE_ITEM(SI) 양쪽 존재 → ambiguous.
-- 조치: 해당 1줄 F. 한정 (배선은 PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST — 본 패치는 INVALID 정리 목적)
-- 원본: DMF0042_backup/SAVE_FCST_orig.sql (DBMS_METADATA.GET_DDL 2026-07-15)
-- 원복: 원본 파일 그대로 재배포
-- 잠재결함 기록(본 패치 범위 외): 본문 DBMS_OUTPUT 의 TO_CHAR(SYSDATE,'...FF3') 는
--   실행 시 ORA-01821 가능 (PKG 판에는 해당 패턴 없음 — 2026-07-15 grep 0건)
-- =====================================================================
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0042_SAVE_DM_PLN_BP_FCST" 
(
    -- Add the parameters for the stored procedure here
      p_active_flag       VARCHAR2
  , p_DIVISION_ID       VARCHAR2
  , p_PROJECT_CODE        VARCHAR2
  , p_PROJECT_NAME        VARCHAR2
  , p_SCM_SITE_ID       VARCHAR2
  , p_PLANT_SITE_ID       VARCHAR2
  , p_ITEM_ID         VARCHAR2
  --, p_DOM_EXP         VARCHAR2
  , p_FCST_TYPE         VARCHAR2
  , p_INCOTERMS         VARCHAR2 -- PJ20200138 Incoterms 삭제
  -- -----------------------------------------------------------------------------------------------
  -- PJ20200138 item_use, unit_energy 추가 (START)
  , p_ITEM_USE          VARCHAR2
  , p_UNIT_ENERGY       VARCHAR2
  -- PJ20200138 item_use, unit_energy 추가 (END)
  -- -----------------------------------------------------------------------------------------------
  , p_MEASURE         VARCHAR2
  , p_YYYYMM            VARCHAR2
  , p_QTY           VARCHAR2
  , p_CURRENCY          VARCHAR2
  -- -----------------------------------------------------------------------------------------------
  -- 20190830 파라미터추가 (START)
  , p_DEPT_ID         VARCHAR2
  , p_END_CUSTOMER        VARCHAR2
  , p_BIZ_TYPE          VARCHAR2
  , p_CELL_PROD_SITE        VARCHAR2
    --, p_CELL_PER_PACK            VARCHAR2
    --, p_CELL_PER_MODULE          VARCHAR2
    --, p_MODULE_PER_PACK          VARCHAR2
    -- 20190830 파라미터추가 (END)
  -- -----------------------------------------------------------------------------------------------
  , p_CREATED_BY          VARCHAR2
  , p_LAST_UPDATED_BY     VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
    , O_RC3  OUT  SYS_REFCURSOR
    , O_RC4  OUT  SYS_REFCURSOR
    , O_RC5  OUT  SYS_REFCURSOR
    , O_RC6  OUT  SYS_REFCURSOR
    , O_RC7  OUT  SYS_REFCURSOR
    , O_RC8  OUT  SYS_REFCURSOR
    , O_RC9  OUT  SYS_REFCURSOR
    , O_RC10  OUT  SYS_REFCURSOR
)
/*===============================================================================================================================
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_FCST
 * Description  : Business Plan ('DM_PLN_BP_FCST' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===============================================================================================================================
 *   Date       In Charge      Description
 *===============================================================================================================================
 * 2019-04-11 KHSONG      Initial Release PJ20189106 전지본부 GSCM(DM) 고도화 프로젝트
 * 2019-04-26         DM_PLN_BP_FCST 테이블에 SalesAmt_KRW, SalesAmt_LOC, SalesAmt_USD 값을 계산하여 INSERT INTO 처리
 * 2019-08-30 JSYOUN      81, 82 사업부에 따른 변경
 * 2019-09-16 KHSONG      ADDED COLUMN
 * 2020-01-06 KHSONG      수정
 * 2020-04-08 P.C.I     PJ20200138 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020-06-10 hwi1993     대량데이터 저장시 오류 수정 ( 대량관련 오류는 없고, loc 메저가 저장되지 않는 현상 수정함 )
 * 2020-07-31 hwi1993     NUMBER CONVERT 오류 수정
 * 2020-09-04 hwi1993     [c20200722-000060] biz plan active YN
 * 2021-07-23 hwi1993     incoterms 추가 등 ( 중장기계획 과제 관련 )
 * 2021-08-06 hwi1993     MKT FCST 메저 추가
 * 2022-06-21 rosia27     [C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2024-08-01 JSSBAE      [E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청
 * 2025-07-15 JSSBAE      [E20250522-001188]_ Business Plan UI 데이터 저장 시 Trim 처리
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 ===============================================================================================================================*/
AS

    n_active_flag VARCHAR2(4000 CHAR);
    v_active_flag VARCHAR2(4000 CHAR);
    v_DIVISION_ID VARCHAR2(4000 CHAR);
    v_PROJECT_CODE VARCHAR2(4000 CHAR);
    v_PROJECT_NAME VARCHAR2(4000 CHAR);
    v_SCM_SITE_ID VARCHAR2(4000 CHAR);
    v_PLANT_SITE_ID VARCHAR2(4000 CHAR);
    v_ITEM_ID VARCHAR2(4000 CHAR);
    v_FCST_TYPE VARCHAR2(4000 CHAR);
    v_INCOTERMS VARCHAR2(4000 CHAR);
    v_ITEM_USE VARCHAR2(4000 CHAR);
    v_UNIT_ENERGY VARCHAR2(4000 CHAR);
    v_MEASURE VARCHAR2(4000 CHAR);
    v_YYYYMM VARCHAR2(4000 CHAR);
    v_CURRENCY VARCHAR2(4000 CHAR);
    v_QTY VARCHAR2(4000 CHAR);
    v_DEPT_ID VARCHAR2(4000 CHAR);
    v_END_CUSTOMER VARCHAR2(4000 CHAR);
    v_BIZ_TYPE VARCHAR2(4000 CHAR);
    v_CELL_PROD_SITE VARCHAR2(4000 CHAR);
    v_CREATED_BY VARCHAR2(4000 CHAR);
    v_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_del_count INTEGER := 0;
    n_insert_count INTEGER := 0;
    n_history_seq INTEGER;
    v_index_INCOTERMS INTEGER;
    v_index_active_flag INTEGER;
    v_index_DIVISION_ID INTEGER;
    v_index_PROJECT_CODE INTEGER;
    v_index_PROJECT_NAME INTEGER;
    v_index_SCM_SITE_ID INTEGER;
    v_index_PLANT_SITE_ID INTEGER;
    v_index_ITEM_ID INTEGER;
    v_index_FCST_TYPE INTEGER;
    v_index_ITEM_USE INTEGER;
    v_index_UNIT_ENERGY INTEGER;
    v_index_MEASURE INTEGER;
    v_index_YYYYMM INTEGER;
    v_index_CURRENCY INTEGER;
    v_index_QTY INTEGER;
    v_index_DEPT_ID INTEGER;
    v_index_END_CUSTOMER INTEGER;
    v_index_BIZ_TYPE INTEGER;
    v_index_CELL_PROD_SITE INTEGER;
    v_index_CREATED_BY INTEGER;
    v_index_LAST_UPDATED_BY INTEGER;
    v_cnt_1  INTEGER := 0;
    v_cnt_2  INTEGER := 0;
    v_cnt_3  INTEGER := 0;
    v_cnt_4  INTEGER := 0;
    v_cnt_5  INTEGER := 0;
    v_cnt_6  INTEGER := 0;
    v_in_para_data VARCHAR2(4000);
    -- 선언부에 추가
    v_rc1_sub SYS_REFCURSOR;
    v_rc2_sub SYS_REFCURSOR;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_active_flag' VALUE p_active_flag,
            'p_DIVISION_ID' VALUE p_DIVISION_ID,
            'p_PROJECT_CODE' VALUE p_PROJECT_CODE,
            'p_PROJECT_NAME' VALUE p_PROJECT_NAME,
            'p_SCM_SITE_ID' VALUE p_SCM_SITE_ID,
            'p_PLANT_SITE_ID' VALUE p_PLANT_SITE_ID,
            'p_ITEM_ID' VALUE p_ITEM_ID,
            'p_DOM_EXP' VALUE null,
            'p_FCST_TYPE' VALUE p_FCST_TYPE,
            'p_INCOTERMS' VALUE p_INCOTERMS
          );

  --======================================================
    -- 스플릿관련 변수
  --======================================================
  -- -----------------------------------------------------------------------------------------------
  -- PJ20200138 item_use, unit_energy 추가 (START)
  -- -----------------------------------------------------------------------------------------------
    -- 20190830 변수 추가 (START)
  --    v_CELL_PER_MODULE VARCHAR2(4000 CHAR);
  --    v_MODULE_PER_PACK VARCHAR2(4000 CHAR);
  -- 20190830 변수 추가 (END)
  -- -----------------------------------------------------------------------------------------------
    -- LOG 용 변수 설정
  --======================================================
    -- SEQUENCE
  --======================================================
    -- 마지막 데이터 처리를 위한 구분자 추가
  --======================================================
    n_active_flag := RTRIM(p_active_flag     )  ||  '^';
    v_DIVISION_ID := RTRIM(p_DIVISION_ID     )  ||  '^';
    v_PROJECT_CODE := RTRIM(p_PROJECT_CODE    )  ||  '^';
    v_PROJECT_NAME := RTRIM(p_PROJECT_NAME    )  ||  '^';
    v_SCM_SITE_ID := RTRIM(p_SCM_SITE_ID     )  ||  '^';
    v_PLANT_SITE_ID := RTRIM(p_PLANT_SITE_ID   )  ||  '^';
    v_ITEM_ID := RTRIM(p_ITEM_ID         )  ||  '^';
    --p_DOM_EXP := RTRIM(p_DOM_EXP         ) || '^';
    v_FCST_TYPE := RTRIM(p_FCST_TYPE       )  ||  '^';
    v_INCOTERMS := RTRIM(p_INCOTERMS       )  ||  '^'; -- PJ20200138 Incoterms 삭제
  -- -----------------------------------------------------------------------------------------------
  -- PJ20200138 item_use, unit_energy 추가 (START)
    v_ITEM_USE := RTRIM(p_ITEM_USE        )  ||  '^';
    v_UNIT_ENERGY := RTRIM(p_UNIT_ENERGY     )  ||  '^';
  -- PJ20200138 item_use, unit_energy 추가 (END)
  -- -----------------------------------------------------------------------------------------------
    v_MEASURE := RTRIM(p_MEASURE         )  ||  '^';
    v_YYYYMM := RTRIM(p_YYYYMM          )  ||  '^';
    v_CURRENCY := RTRIM(p_CURRENCY        )  ||  '^';
    v_QTY := RTRIM(p_QTY             )  ||  '^';
  -- -----------------------------------------------------------------------------------------------
    -- 20190830 변수 추가 (START)
    v_DEPT_ID := RTRIM(p_DEPT_ID         )  ||  '^';
    v_END_CUSTOMER := RTRIM(p_END_CUSTOMER    )  ||  '^';
    v_BIZ_TYPE := RTRIM(p_BIZ_TYPE        )  ||  '^';
  v_CELL_PROD_SITE := RTRIM(p_CELL_PROD_SITE  )  ||  '^';
    --p_CELL_PER_PACK := RTRIM(p_CELL_PER_PACK   ) || '^';
    --p_CELL_PER_MODULE := RTRIM(p_CELL_PER_MODULE ) || '^';
    --p_MODULE_PER_PACK := RTRIM(p_MODULE_PER_PACK ) || '^';
  -- 20190830 변수 추가 (END)
  -- -----------------------------------------------------------------------------------------------
    v_CREATED_BY := RTRIM(p_CREATED_BY      )  ||  '^';
    v_LAST_UPDATED_BY := RTRIM(p_LAST_UPDATED_BY )  ||  '^';

  --======================================================
    -- TEMP TABLE DROP
  --======================================================
    -- -----------------------------------------------------------------------------------------------
  -- [E20250522-001188]_속도 개선을 위해 해당 테이블의 원테이블로 조회하여 TEMP로 사용함 (START)
  -- [E20250522-001188]_속도 개선을 위해 해당 테이블의 원테이블로 조회하여 TEMP로 사용함 (END)
  -- -----------------------------------------------------------------------------------------------
  --======================================================
    -- TEMP TABLE CREATE
  --======================================================
  EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPB2_BP_FCST_4';

  EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPB2_DM_PLN_BP_FCST_X_4';

  --======================================================
  -- 시작 LOG  (START)
  --======================================================
    v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
    v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
  --======================================================
  -- 시작 LOG  (END)
  --======================================================
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A001-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
  --======================================================
  -- 트랜잭션 (START)
  --======================================================
      -- -----------------------------------------------------------------------------------------
        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
    -- -----------------------------------------------------------------------------------------
      WHILE LENGTH(p_DIVISION_ID) > 0 LOOP
        DECLARE
    v_index_INCOTERMS_local       INTEGER;  -- PJ20200138 Incoterms 삭제
        BEGIN
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          --    v_index_CELL_PER_MODULE INTEGER;
          --    v_index_MODULE_PER_PACK INTEGER;
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          v_index_active_flag := INSTR(p_active_flag, '^');
          v_index_DIVISION_ID := INSTR(p_DIVISION_ID, '^');
          v_index_PROJECT_CODE := INSTR(p_PROJECT_CODE, '^');
          v_index_PROJECT_NAME := INSTR(p_PROJECT_NAME, '^');
          v_index_SCM_SITE_ID := INSTR(p_SCM_SITE_ID, '^');
          v_index_PLANT_SITE_ID := INSTR(p_PLANT_SITE_ID, '^');
          v_index_ITEM_ID := INSTR(p_ITEM_ID, '^');
          --v_index_DOM_EXP := INSTR(p_DOM_EXP, '^')
          v_index_FCST_TYPE := INSTR(p_FCST_TYPE, '^');
          v_index_INCOTERMS_local := INSTR(p_INCOTERMS, '^'); -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          v_index_ITEM_USE := INSTR(p_ITEM_USE, '^');
          v_index_UNIT_ENERGY := INSTR(p_UNIT_ENERGY, '^');
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          v_index_MEASURE := INSTR(p_MEASURE, '^');
          v_index_YYYYMM := INSTR(p_YYYYMM, '^');
          v_index_CURRENCY := INSTR(p_CURRENCY, '^');
          v_index_QTY := INSTR(p_QTY, '^');
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          v_index_DEPT_ID := INSTR(p_DEPT_ID, '^');
          v_index_END_CUSTOMER := INSTR(p_END_CUSTOMER, '^');
          v_index_BIZ_TYPE := INSTR(p_BIZ_TYPE, '^');
          v_index_CELL_PROD_SITE := INSTR(p_CELL_PROD_SITE, '^');
          --v_index_CELL_PER_PACK := INSTR(p_CELL_PER_PACK, '^')
          --v_index_CELL_PER_MODULE := INSTR(p_CELL_PER_MODULE, '^')
          --v_index_MODULE_PER_PACK := INSTR(p_MODULE_PER_PACK, '^')
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          v_index_CREATED_BY := INSTR(p_CREATED_BY, '^');
          v_index_LAST_UPDATED_BY := INSTR(p_LAST_UPDATED_BY, '^');
        v_index_INCOTERMS := v_index_INCOTERMS_local;
        END;
        IF v_index_DIVISION_ID > 0 THEN
          v_active_flag := SUBSTR(n_active_flag, 0, v_index_active_flag - 1);
          n_active_flag := SUBSTR(n_active_flag, v_index_active_flag + 1);

          v_DIVISION_ID := SUBSTR(v_DIVISION_ID, 0, v_index_DIVISION_ID - 1);
          v_DIVISION_ID := SUBSTR(v_DIVISION_ID, v_index_DIVISION_ID + 1);

          v_PROJECT_CODE := SUBSTR(v_PROJECT_CODE, 0, v_index_PROJECT_CODE - 1);
          v_PROJECT_CODE := SUBSTR(v_PROJECT_CODE, v_index_PROJECT_CODE + 1);

          v_PROJECT_NAME := SUBSTR(v_PROJECT_NAME, 0, v_index_PROJECT_NAME - 1);
          v_PROJECT_NAME := SUBSTR(v_PROJECT_NAME, v_index_PROJECT_NAME + 1);

          v_SCM_SITE_ID := SUBSTR(v_SCM_SITE_ID, 0, v_index_SCM_SITE_ID - 1);
          v_SCM_SITE_ID := SUBSTR(v_SCM_SITE_ID, v_index_SCM_SITE_ID + 1);

          v_PLANT_SITE_ID := SUBSTR(v_PLANT_SITE_ID, 0, v_index_PLANT_SITE_ID - 1);
          v_PLANT_SITE_ID := SUBSTR(v_PLANT_SITE_ID, v_index_PLANT_SITE_ID + 1);

          v_ITEM_ID := SUBSTR(v_ITEM_ID, 0, v_index_ITEM_ID - 1);
          v_ITEM_ID := SUBSTR(v_ITEM_ID, v_index_ITEM_ID + 1);

          --v_DOM_EXP := SUBSTR(p_DOM_EXP , 0, v_index_DOM_EXP )
          --p_DOM_EXP := SUBSTR(p_DOM_EXP , LENGTH(v_DOM_EXP  || '^') + 1, LENGTH(p_DOM_EXP ))
          v_FCST_TYPE := SUBSTR(v_FCST_TYPE , 0, v_index_FCST_TYPE - 1);
          v_FCST_TYPE := SUBSTR(v_FCST_TYPE , v_index_FCST_TYPE + 1);

          v_INCOTERMS := SUBSTR(v_INCOTERMS , 1, v_index_INCOTERMS - 1); -- PJ20200138 Incoterms 삭제
          v_INCOTERMS := SUBSTR(v_INCOTERMS , v_index_INCOTERMS + 1);
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          v_ITEM_USE := SUBSTR(v_ITEM_USE , 0, v_index_ITEM_USE - 1);
          v_ITEM_USE := SUBSTR(v_ITEM_USE , v_index_ITEM_USE + 1);

          v_UNIT_ENERGY := SUBSTR(v_UNIT_ENERGY , 0, v_index_UNIT_ENERGY - 1);
          v_UNIT_ENERGY := SUBSTR(v_UNIT_ENERGY , v_index_UNIT_ENERGY + 1);
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          v_MEASURE := SUBSTR(v_MEASURE , 0, v_index_MEASURE - 1);
          v_MEASURE := SUBSTR(v_MEASURE , v_index_MEASURE + 1);

          v_YYYYMM := SUBSTR(v_YYYYMM , 0, v_index_YYYYMM - 1);
          v_YYYYMM := SUBSTR(v_YYYYMM , v_index_YYYYMM + 1);

          v_CURRENCY := SUBSTR(v_CURRENCY , 0, v_index_CURRENCY - 1);
          v_CURRENCY := SUBSTR(v_CURRENCY , v_index_CURRENCY + 1);
          -- -----------------------------------------------------------------------------------------------
          -- 20180319 skh added (START)
          IF v_CURRENCY is null THEN
            v_CURRENCY := NULL;
          END IF;
          -- 20180319 skh added (END)
          -- -----------------------------------------------------------------------------------------------
          v_QTY := SUBSTR(v_QTY , 0, v_index_QTY - 1);
          v_QTY := SUBSTR(v_QTY , v_index_QTY + 1);
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          v_DEPT_ID := SUBSTR(v_DEPT_ID , 0, v_index_DEPT_ID - 1);
          v_DEPT_ID := SUBSTR(v_DEPT_ID , v_index_DEPT_ID + 1);

          v_END_CUSTOMER := SUBSTR(v_END_CUSTOMER , 0, v_index_END_CUSTOMER - 1);
          v_END_CUSTOMER := SUBSTR(v_END_CUSTOMER , v_index_END_CUSTOMER + 1);

          v_BIZ_TYPE := SUBSTR(v_BIZ_TYPE , 0, v_index_BIZ_TYPE - 1);
          v_BIZ_TYPE := SUBSTR(v_BIZ_TYPE , v_index_BIZ_TYPE + 1);

          v_CELL_PROD_SITE := SUBSTR(v_CELL_PROD_SITE  , 0, v_index_CELL_PROD_SITE - 1);
          v_CELL_PROD_SITE := SUBSTR(v_CELL_PROD_SITE  , v_index_CELL_PROD_SITE + 1);
          -- -----------------------------------------------------------------------------------------------
          --[E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청 (START)
          -- 화면에서 코드를 넘기는 것으로 변경했으므로, 더이상 필요없는 작업이므로 주석처리해서 막음
          /*
          -- 룩업 Code 로 바꿔준다.
          SELECT NVL(SEGMENT1, NULL)
  INTO v_CELL_PROD_SITE
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE lookup_type = 'dm_cell_prod_site'
            AND ATTRIBUTE1 = v_CELL_PROD_SITE;
          */
          --[E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청 (END)
          -- -----------------------------------------------------------------------------------------------
          /*v_CELL_PER_PACK := SUBSTR(p_CELL_PER , 0, v_index_CELL_PER_PACK )
          p_CELL_PER_PACK := SUBSTR(p_CELL_PER_PACK , LENGTH(v_CELL_PER_PACK  || '^') + 1, LENGTH(p_CELL_PER_PACK ));

          v_CELL_PER_MODULE := SUBSTR(p_CELL_PER_MODULE , 0, v_index_CELL_PER_MODULE );
          p_CELL_PER_MODULE := SUBSTR(p_CELL_PER_MODULE , LENGTH(v_CELL_PER_MODULE  || '^') + 1, LENGTH(p_CELL_PER_MODULE ));

          v_MODULE_PER_PACK := SUBSTR(p_MODULE_PER_PACK , 0, v_index_MODULE_PER_PACK );
          p_MODULE_PER_PACK := SUBSTR(p_MODULE_PER_PACK , LENGTH(v_MODULE_PER_PACK  || '^') + 1, LENGTH(p_MODULE_PER_PACK ))*/
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          v_CREATED_BY := SUBSTR(v_CREATED_BY , 0, v_index_CREATED_BY - 1);
          v_CREATED_BY := SUBSTR(v_CREATED_BY , v_index_CREATED_BY + 1);

          v_LAST_UPDATED_BY := SUBSTR(v_LAST_UPDATED_BY , 0, v_index_LAST_UPDATED_BY - 1);
          v_LAST_UPDATED_BY := SUBSTR(v_LAST_UPDATED_BY , v_index_LAST_UPDATED_BY + 1);

          -- -----------------------------------------------------------------------------------------------
          -- [E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리 (START)
          -- ITEM의 경우 중간의 공백이 없으므로 RTRM, LTRM으로 지워지지 않는 건들이 있고, 특수 문자가 안지워지는 건도 있어서 어떻게든 지우겠다는 의지
          v_active_flag := RTRIM(LTRIM(v_active_flag));
          v_DIVISION_ID := RTRIM(LTRIM(v_DIVISION_ID));
          v_PROJECT_CODE := RTRIM(LTRIM(v_PROJECT_CODE));
          v_PROJECT_NAME := RTRIM(LTRIM(v_PROJECT_NAME));
          v_SCM_SITE_ID := RTRIM(LTRIM(v_SCM_SITE_ID));
          v_PLANT_SITE_ID := RTRIM(LTRIM(v_PLANT_SITE_ID));
          --CHAR(13): Carriage return / CHAR(10): Line feed / CHAR(9): TAB
          v_ITEM_ID := REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(v_ITEM_ID)),CHR(13),''),CHR(10),''),CHR(9),''), ' ', '');
          v_FCST_TYPE := RTRIM(LTRIM(v_FCST_TYPE));
          v_INCOTERMS := RTRIM(LTRIM(v_INCOTERMS));
          v_ITEM_USE := RTRIM(LTRIM(v_ITEM_USE));
          v_UNIT_ENERGY := RTRIM(LTRIM(v_UNIT_ENERGY));
          v_MEASURE := RTRIM(LTRIM(v_MEASURE));
          v_YYYYMM := RTRIM(LTRIM(v_YYYYMM));
          v_CURRENCY := RTRIM(LTRIM(v_CURRENCY));
          v_QTY := RTRIM(LTRIM(v_QTY));
          v_DEPT_ID := RTRIM(LTRIM(v_DEPT_ID));
          v_END_CUSTOMER := RTRIM(LTRIM(v_END_CUSTOMER));
          v_BIZ_TYPE := RTRIM(LTRIM(v_BIZ_TYPE));
          v_CELL_PROD_SITE := RTRIM(LTRIM(v_CELL_PROD_SITE));
          v_CREATED_BY := RTRIM(LTRIM(v_CREATED_BY  ));
          v_LAST_UPDATED_BY := RTRIM(LTRIM(v_LAST_UPDATED_BY));
          -- [E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리 (END)
          -- -----------------------------------------------------------------------------------------------
          INSERT INTO GT_SDPB2_BP_FCST_4
          ( active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
          , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          , ITEM_USE, UNIT_ENERGY
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , MEASURE, YYYYMM, CURRENCY, QTY
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          , DEPT_ID
          , END_CUSTOMER
          , BIZ_TYPE
          , CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , CREATED_BY, LAST_UPDATED_BY )
          VALUES
          ( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_PROJECT_NAME, v_SCM_SITE_ID, v_PLANT_SITE_ID ,v_ITEM_ID--,v_DOM_EXP
          , v_FCST_TYPE, v_INCOTERMS -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          , v_ITEM_USE, (CASE WHEN v_UNIT_ENERGY IS NULL THEN 0 ELSE TO_NUMBER(v_UNIT_ENERGY) END)
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , v_MEASURE, v_YYYYMM, v_CURRENCY, v_QTY
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_DEPT_ID END
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_END_CUSTOMER END
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_BIZ_TYPE END
          , v_CELL_PROD_SITE --,v_CELL_PER_PACK--,v_CELL_PER_MODULE--,v_MODULE_PER_PACK
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , v_CREATED_BY, v_LAST_UPDATED_BY );
        -- ----------------------------------------
        ELSE
        -- ----------------------------------------
        BEGIN
          NULL;

          INSERT INTO GT_SDPB2_BP_FCST_4
          ( active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
          , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          , ITEM_USE, UNIT_ENERGY
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , MEASURE, YYYYMM, CURRENCY, QTY
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          , DEPT_ID
          , END_CUSTOMER
          , BIZ_TYPE
          , CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , CREATED_BY, LAST_UPDATED_BY )
          VALUES
          ( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_PROJECT_NAME, v_SCM_SITE_ID, v_PLANT_SITE_ID ,v_ITEM_ID--,v_DOM_EXP
          , v_FCST_TYPE, v_INCOTERMS -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          , v_ITEM_USE, (CASE WHEN v_UNIT_ENERGY IS NULL THEN 0 ELSE TO_NUMBER(v_UNIT_ENERGY) END)
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , v_MEASURE, v_YYYYMM, v_CURRENCY, v_QTY
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_DEPT_ID END
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_END_CUSTOMER END
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_BIZ_TYPE END
          , v_CELL_PROD_SITE --,v_CELL_PER_PACK--,v_CELL_PER_MODULE--,v_MODULE_PER_PACK
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , v_CREATED_BY, v_LAST_UPDATED_BY );
        END;

      END IF;

      END LOOP;

DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A002-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      -- -----------------------------------------------------------------------------------------------
      -- [E20250522-001188]_속도 개선을 위해 DM_MST_ITEM_SINGLE_V를 TEMP로 생성함 (START)
      BEGIN
        --> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
        /* TODO:GTT:GT_SDPB_DM_MST_ITEM_SINGLE_ORI-->GT_SDPB_DM_MST_ITEM_SINGLE_ORI */
        INSERT INTO GT_SDPB_DM_MST_ITEM_SINGLE_ORI
        SELECT *
        FROM SCM_MST_ITEM_SN
        WHERE DIVISION_ID = v_DIVISION_ID
        AND ACTIVE_FLAG = 'Y';

        --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
        /* TODO:GTT:GT_SDPB_DM_MST_ITEM_SINGLE_A_V-->GT_SDPB_DM_MST_ITEM_SINGLE_A_V */
        INSERT INTO GT_SDPB_DM_MST_ITEM_SINGLE_A_V
        SELECT T1.DIVISION_ID, T1.ITEM_ID
           , MAX(T1.ITEM_NAME) ITEM_NAME
           , MAX(T1.ITEM_CLASS) ITEM_CLASS
           , MAX(T1.ITEM_CLASS_NAME) ITEM_CLASS_NAME
           , MAX(T1.NICK_NAME) NICK_NAME
           , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                    WHEN T1.ITEM_TYPE = 'H' THEN 2
                    WHEN T1.ITEM_TYPE = 'Q' THEN 3
                 ELSE 4 END )
                        WHEN 1 THEN 'P'
                        WHEN 2 THEN 'H'
                        WHEN 3 THEN 'Q'
                        ELSE 'R' END  AS ITEM_TYPE
           , MAX(T1.MATERIAL_CLASS_NAME) MATERIAL_CLASS_NAME
           , MAX(T1.ITEM_UOM) ITEM_UOM
           , MAX(T1.SPEC) SPEC
           , MAX(T1.MDM_PROJECT_NAME) MDM_PROJECT_NAME
           , MAX(T1.MIN_CAPACITY) MIN_CAPACITY
           , MAX(T1.ACTIVE_FLAG) ACTIVE_FLAG
           , MAX(T1.ENERGE) ENERGE
           , MAX(T1.CELL_QUANTITY) CELL_QUANTITY
           , MAX(T1.SCP_EXTRA_SPEC) SCP_EXTRA_SPEC
        FROM GT_SDPB_DM_MST_ITEM_SINGLE_ORI T1
        WHERE 1=1
        GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

        --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
        /* TODO:GTT:GT_SDPB_DM_MST_ITEM_SINGLE_B_V-->GT_SDPB_DM_MST_ITEM_SINGLE_B_V */
        INSERT INTO GT_SDPB_DM_MST_ITEM_SINGLE_B_V
        SELECT DIVISION_ID
           , SUBSTR(ITEM_ID, 1, 12) ITEM_ID
           , MAX(FORECAST_INFO_BIZ_TYPE) FORECAST_INFO_BIZ_TYPE
           , MAX(FORECAST_INFO_PRODUCT_GROUP) FORECAST_INFO_PRODUCT_GROUP
           , MAX(FORECAST_INFO_CELL_MODEL) FORECAST_INFO_CELL_MODEL
           , MAX(FORECAST_INFO_CELL_PACK_COUNT) FORECAST_INFO_CELL_PACK_COUNT
           , MAX(FORECAST_INFO_SPEC) FORECAST_INFO_SPEC
           , MAX(FORECAST_INFOR_VERSION) FORECAST_INFOR_VERSION
           , MAX(CELL_TYPE) CELL_TYPE
        FROM GT_SDPB_DM_MST_ITEM_SINGLE_ORI T2
        GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

        --TEMP 테이블에 넣은 데이터를 JOIN 한다.
        /* TODO:GTT:GT_SDPB_DM_MST_ITEM_SINGLE_V-->GT_SDPB_DM_MST_ITEM_SINGLE_V */
        INSERT INTO GT_SDPB_DM_MST_ITEM_SINGLE_V
        SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
           , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
           , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
           , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
        FROM ( SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME
              , T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
              , T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
              , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
             FROM GT_SDPB_DM_MST_ITEM_SINGLE_A_V T1
             INNER JOIN GT_SDPB_DM_MST_ITEM_SINGLE_B_V T2   ON T1.DIVISION_ID = T2.DIVISION_ID AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
             WHERE 1=1 ) T2
        WHERE DIVISION_ID = p_division_id
        GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
             , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
             , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
             , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC;
      END;
      -- [E20250522-001188]_속도 개선을 위해 DM_MST_ITEM_SINGLE_V를 TEMP로 생성함 (END)
      -- -----------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A003-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --======================================================
      --INPUT된 active_flag='D' 인것 삭제수행 (START)
      --======================================================
      BEGIN
        SELECT COUNT(1)
  INTO n_del_count
        FROM GT_SDPB2_BP_FCST_4  WHERE ACTIVE_FLAG = 'D';

        DELETE
        FROM DM_PLN_BP_FCST
        WHERE ( SELECT COUNT(1) FROM GT_SDPB2_BP_FCST_4
            WHERE 1=1
            AND ACTIVE_FLAG  = 'D'
            AND DM_PLN_BP_FCST.DIVISION_ID    = DIVISION_ID
            AND DM_PLN_BP_FCST.PROJECT_CODE   = PROJECT_CODE
            --AND DM_PLN_BP_FCST.PROJECT_NAME = PROJECT_NAME
            AND DM_PLN_BP_FCST.SCM_SITE_ID      = SCM_SITE_ID
            AND DM_PLN_BP_FCST.PLANT_SITE_ID    = PLANT_SITE_ID
            AND DM_PLN_BP_FCST.ITEM_ID          = ITEM_ID
            AND DM_PLN_BP_FCST.CELL_PROD_SITE   = CELL_PROD_SITE
            AND DM_PLN_BP_FCST.FCST_TYPE    = FCST_TYPE
            AND DM_PLN_BP_FCST.INCOTERMS        = INCOTERMS -- PJ20200138 Incoterms 삭제
            -- -----------------------------------------------------------------------------------------------
            -- PJ20200138 item_use, unit_energy 추가 (START)
            AND DM_PLN_BP_FCST.ITEM_USE         = ITEM_USE
            AND DM_PLN_BP_FCST.UNIT_ENERGY      = UNIT_ENERGY
            -- PJ20200138 item_use, unit_energy 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            AND DM_PLN_BP_FCST.MEASURE          = MEASURE
            AND DM_PLN_BP_FCST.YYYYMM           = YYYYMM
            -- -----------------------------------------------------------------------------------------------
            -- 20190830 추가 (START)
            AND DM_PLN_BP_FCST.DEPT_ID          = DEPT_ID
            AND DM_PLN_BP_FCST.END_CUSTOMER     = END_CUSTOMER
            AND DM_PLN_BP_FCST.BIZ_TYPE         = BIZ_TYPE
            AND DM_PLN_BP_FCST.CURRENCY         = CURRENCY
            -- 20190830 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            ) > 0;

        -- -----------------------------------------------------------------------------------------------
        -- 삭제완료건 TEMP TABLE에서 제거
        -- -----------------------------------------------------------------------------------------------
        DELETE FROM GT_SDPB2_BP_FCST_4 WHERE ACTIVE_FLAG  = 'D';
      END;
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A004-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --======================================================
      --INPUT된 active_flag='D' 인것 삭제수행 (END)
      --======================================================
      --======================================================
      -- 2021.7.23 키 업데이트용으로 들어온 데이터 처리 (START)
      --======================================================
      BEGIN
        SELECT COUNT(1)
        INTO v_cnt_1
        FROM DM_PLN_BP_FCST A
        JOIN (  SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
        , CURRENCY, ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE
        FROM GT_SDPB2_BP_FCST_4
        WHERE MEASURE = 'Business_Plan'
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
        , CURRENCY, ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE
        ) B  ON A.DIVISION_ID   = B.DIVISION_ID
        AND A.PROJECT_CODE    = B.PROJECT_CODE
        AND A.SCM_SITE_ID   = B.SCM_SITE_ID
        AND A.ITEM_ID     = B.ITEM_ID
        AND A.DEPT_ID     = B.DEPT_ID
        AND A.END_CUSTOMER    = B.END_CUSTOMER
        AND A.BIZ_TYPE      = B.BIZ_TYPE
        AND A.CURRENCY      = B.CURRENCY
        AND A.ITEM_USE      = B.ITEM_USE
        AND A.UNIT_ENERGY   = B.UNIT_ENERGY
        AND A.CELL_PROD_SITE  = B.CELL_PROD_SITE
        WHERE A.FCST_TYPE IS NULL OR A.INCOTERMS IS NULL;
        IF v_cnt_1 > 0 THEN
          MERGE INTO DM_PLN_BP_FCST A
          USING (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
            , CURRENCY, ITEM_USE, UNIT_ENERGY, MAX(FCST_TYPE) FCST_TYPE--, MAX(DOM_EXP) DOM_EXP
            , MAX(INCOTERMS) INCOTERMS, CELL_PROD_SITE
            FROM GT_SDPB2_BP_FCST_4
            WHERE MEASURE = 'Business_Plan'
            GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
            , CURRENCY, ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE
          ) B
          ON (A.DIVISION_ID   = B.DIVISION_ID AND A.PROJECT_CODE    = B.PROJECT_CODE AND A.SCM_SITE_ID    = B.SCM_SITE_ID AND A.ITEM_ID     = B.ITEM_ID AND A.DEPT_ID     = B.DEPT_ID AND A.END_CUSTOMER    = B.END_CUSTOMER AND A.BIZ_TYPE     = B.BIZ_TYPE AND A.CURRENCY     = B.CURRENCY AND A.ITEM_USE     = B.ITEM_USE AND A.UNIT_ENERGY    = B.UNIT_ENERGY AND A.CELL_PROD_SITE  = B.CELL_PROD_SITE)
          WHEN MATCHED THEN
          UPDATE SET FCST_TYPE = B.FCST_TYPE
            --, DOM_EXP = B.DOM_EXP
            , INCOTERMS = B.INCOTERMS;
          GOTO END_PKUPDATE;
        END IF;
      END;
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A005-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --======================================================
      -- INPUT된 Business_Plan MEASURE INSERT (START)
      --======================================================
      -- INSERT INTO 전 중복값 삭제
      BEGIN
        DELETE FROM DM_PLN_BP_FCST A
        WHERE A.MEASURE IN ( 'Business_Plan', 'LOC', 'CAR_QTY', 'MKT_FCST' )
        AND EXISTS (SELECT 1 FROM GT_SDPB2_BP_FCST_4 B
        WHERE A.DIVISION_ID   = B.DIVISION_ID
         AND A.PROJECT_CODE     = B.PROJECT_CODE
         AND A.SCM_SITE_ID      = B.SCM_SITE_ID
         AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
         AND A.ITEM_ID          = B.ITEM_ID
         AND A.CELL_PROD_SITE   = B.CELL_PROD_SITE
         AND A.FCST_TYPE        = B.FCST_TYPE
         AND A.ITEM_USE         = B.ITEM_USE
         AND A.UNIT_ENERGY      = B.UNIT_ENERGY
         AND A.MEASURE          = B.MEASURE
         AND A.YYYYMM           = B.YYYYMM
         AND A.DEPT_ID          = B.DEPT_ID
         AND A.END_CUSTOMER     = B.END_CUSTOMER
         AND A.BIZ_TYPE         = B.BIZ_TYPE
         AND A.CURRENCY         = B.CURRENCY
         AND A.INCOTERMS        = B.INCOTERMS);
      END;
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A006-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      BEGIN
        INSERT INTO DM_PLN_BP_FCST
        ( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMM, CURRENCY
        , MEASURE, DOM_EXP, FCST_TYPE
        -- -----------------------------------------------------------------------------------------------
        -- PJ20200138 item_use, unit_energy 추가 (START)
        , ITEM_USE, UNIT_ENERGY
        -- PJ20200138 item_use, unit_energy 추가 (END)
        -- -----------------------------------------------------------------------------------------------
        , CELL_PROD_SITE, INCOTERMS, QTY-- PJ20200138 Incoterms 삭제
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        -- -----------------------------------------------------------------------------------------------
        -- 20190830 추가 (START)
        , DEPT_ID, END_CUSTOMER, BIZ_TYPE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
        -- 20190830 추가 (END)
        -- -----------------------------------------------------------------------------------------------
        )
        SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMM, CURRENCY
           , MEASURE, '' AS DOM_EXP, FCST_TYPE
           -- -----------------------------------------------------------------------------------------------
           -- PJ20200138 item_use, unit_energy 추가 (START)
           , ITEM_USE, UNIT_ENERGY
           -- PJ20200138 item_use, unit_energy 추가 (END)
           -- -----------------------------------------------------------------------------------------------
           , CELL_PROD_SITE, INCOTERMS, QTY -- PJ20200138 Incoterms 삭제
           , CREATED_BY, SYSDATE, LAST_UPDATED_BY, SYSDATE
           -- -----------------------------------------------------------------------------------------------
           -- 20190830 추가 (START)
           , DEPT_ID, END_CUSTOMER, BIZ_TYPE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
           -- 20190830 추가 (END)
           -- -----------------------------------------------------------------------------------------------
        FROM GT_SDPB2_BP_FCST_4
        WHERE MEASURE IN ( 'Business_Plan', 'MKT_FCST', 'LOC' );

        -- -----------------------------------------------------------------------------------------------
        -- 20190830 81사업부 CAR_QTY 저장
        -- -----------------------------------------------------------------------------------------------
        INSERT INTO GT_SDPB2_BP_FCST_4
        ( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMM, CURRENCY
        , MEASURE, FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
        -- -----------------------------------------------------------------------------------------------
        -- PJ20200138 item_use, unit_energy 추가 (START)
        , ITEM_USE, UNIT_ENERGY
        -- PJ20200138 item_use, unit_energy 추가 (END)
        -- -----------------------------------------------------------------------------------------------
        , CELL_PROD_SITE
        , QTY
        , CREATED_BY, LAST_UPDATED_BY
        -- -----------------------------------------------------------------------------------------------
        -- 20190830 추가 (START)
        , DEPT_ID, END_CUSTOMER, BIZ_TYPE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
        -- 20190830 추가 (END)
        -- -----------------------------------------------------------------------------------------------
        )
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.PROJECT_NAME, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.YYYYMM, F.CURRENCY
            , 'CAR_QTY' AS MEASURE, FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
            -- -----------------------------------------------------------------------------------------------
            -- PJ20200138 item_use, unit_energy 추가 (START)
            , ITEM_USE, NVL(TO_NUMBER(UNIT_ENERGY),0)
            -- PJ20200138 item_use, unit_energy 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            , CELL_PROD_SITE
            /*,CASE WHEN BIZ_TYPE = 'CELL' THEN NVL(TO_NUMBER(QTY),0) / CASE WHEN TO_NUMBER(CELL_PER_PACK) = 0 THEN 1 END  -- 20190906 ZERO값 발생하는 오류로 CASE문 추가
              WHEN BIZ_TYPE = 'MODULE' THEN NVL(TO_NUMBER(QTY),0) / CASE WHEN TO_NUMBER(MODULE_PER_PACK) = 0 THEN 1 END  -- 20190906 ZERO값 발생하는 오류로 CASE문 추가
              WHEN BIZ_TYPE = 'PACK' THEN QTY
            END AS QTY         */
            , CASE  WHEN INSTR(I.ITEM_CLASS_NAME, 'Cell') > 0  AND NVL(SI.CELL_PER_CAR, 0) > 0   THEN NVL(TO_NUMBER(F.QTY),0) /CASE WHEN SI.CELL_PER_CAR = 0 THEN 1 ELSE SI.CELL_PER_CAR END
                WHEN INSTR(I.ITEM_CLASS_NAME, 'Module') > 0  AND NVL(SI.CELL_PER_CAR/SI.CELL_PER_MODULE, 0) > 0 THEN NVL(TO_NUMBER(F.QTY),0) /CASE WHEN SI.CELL_PER_CAR/SI.CELL_PER_MODULE = 0 THEN 1 ELSE SI.CELL_PER_CAR/SI.CELL_PER_MODULE END
                WHEN INSTR(I.ITEM_CLASS_NAME, 'Pack') > 0  THEN NVL(TO_NUMBER(F.QTY),0)
                ELSE 0
              END AS QTY
            , F.CREATED_BY, F.LAST_UPDATED_BY
            -- -----------------------------------------------------------------------------------------------
            -- 20190830 추가 (START)
            , F.DEPT_ID, F.END_CUSTOMER, F.BIZ_TYPE --,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK  -- [2026-07-15] ORA-00918 수정: DEPT_ID 가 F(GT_SDPB2_BP_FCST_4)/SI(SCM_MST_SITE_ITEM) 양쪽 존재 → F. 한정
            -- 20190830 추가 (END)
            -- -----------------------------------------------------------------------------------------------
        FROM GT_SDPB2_BP_FCST_4 F
        -- -----------------------------------------------------------------------------------------------
        -- [E20250522-001188]_DM_MST_ITEM_SINGLE_V 대신 TEMP로 생성한 테이블을 사용 원소스 주석처리 (START)
        --LEFT JOIN DM_MST_ITEM_SINGLE_V I
        LEFT JOIN GT_SDPB_DM_MST_ITEM_SINGLE_V I
        -- [E20250522-001188]_DM_MST_ITEM_SINGLE_V 대신 TEMP로 생성한 테이블을 사용 원소스 주석처리 (END)
        -- -----------------------------------------------------------------------------------------------
             ON F.DIVISION_ID   = I.DIVISION_ID
            AND F.ITEM_ID     = I.ITEM_ID
        LEFT JOIN SCM_MST_SITE_ITEM SI
             ON F.DIVISION_ID   = SI.DIVISION_ID
            AND F.PROJECT_CODE  = SI.PROJECT_CODE
            AND F.SCM_SITE_ID   = SI.SCM_SITE_ID
            AND F.ITEM_ID     = SI.ITEM_ID
        WHERE MEASURE = 'Business_Plan'
        AND F.DIVISION_ID = '81'
        AND SI.VALID_YN = 'Y';
      END;
      --======================================================
      -- INPUT된 Business_Plan MEASURE INSERT (END)
      --======================================================
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A007-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --======================================================
      -- FUTURE PRICE 계산 Procedure 호출 (START)
      --======================================================
      -- TEMP TABLE 을 전달함 GT_SDPB2_BP_FCST_4
      BEGIN
        DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV('CALL', NULL, v_rc1_sub, v_rc2_sub);
      END;
      --======================================================
      -- FUTURE PRICE 계산 Procedure 호출 (END)
      --======================================================
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A008-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --======================================================
      --GT_SDPB2_BP_FCST_4 테이블에 split후 INSERT (END)
      --======================================================
      BEGIN
        -- -----------------------------------------------------------------------------------------------
        -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (START)
        SELECT COUNT(1)
        INTO v_cnt_2
        FROM GT_SDPB2_BP_FCST_4  WHERE DIVISION_ID <> '40';
        IF v_cnt_2 > 0 THEN
          SELECT COUNT(1)
          INTO v_cnt_3
          FROM GT_SDPB2_BP_FCST_4
          WHERE ( SELECT COUNT(1) FROM SCM_MST_PROJECT
          WHERE PROJECT_CODE = PROJECT_CODE ) = 0
          AND PROJECT_CODE <> 'N'  --20180423 SKH validation 조건에서 제외시킴
          AND DIVISION_ID <> '40'; -- 20180614 KHSOMG 40 DIVISION 조건 추가
          IF v_cnt_3 > 0 THEN
            v_log_type := 'INVALID';
            SELECT '[' || PROJECT_CODE || ']' || ' Invalid Project Code !' INTO v_log_message FROM GT_SDPB2_BP_FCST_4
                          WHERE PROJECT_CODE NOT IN ( SELECT PROJECT_CODE FROM SCM_MST_PROJECT )
                           FETCH FIRST 1 ROWS ONLY;
            OPEN O_RC5 FOR
            SELECT v_log_message FROM DUAL;
            GOTO END_PROC;
          END IF;
        END IF;
        -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (END)
        -- -----------------------------------------------------------------------------------------------
        -- -----------------------------------------------------------------------------------------------
        -- SITE/SITE ITEM 잘못들어왔을때 강제 에러발생시킴 (START) [c20200722-000060]
        SELECT COUNT(1)
        INTO v_cnt_4
        FROM GT_SDPB2_BP_FCST_4  WHERE DIVISION_ID = '40';
        IF v_cnt_4 > 0 THEN
          SELECT COUNT(1)
          INTO v_cnt_5
          FROM GT_SDPB2_BP_FCST_4 A
          LEFT OUTER JOIN SCM_MST_SITE B
          ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VALID_YN = 'Y'
          WHERE B.DIVISION_ID IS NULL;
          IF v_cnt_5 > 0 THEN
            v_log_type := 'INVALID';
            SELECT '[' || A.SCM_SITE_ID || ']' || ' Invalid Sales Site !' INTO v_log_message
                          FROM GT_SDPB2_BP_FCST_4 A
                          LEFT OUTER JOIN SCM_MST_SITE B
                                 ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VALID_YN = 'Y'
                          WHERE B.DIVISION_ID IS NULL
                           FETCH FIRST 1 ROWS ONLY;
            OPEN O_RC6 FOR
            SELECT v_log_message FROM DUAL;
            GOTO END_PROC;
          END IF;

          SELECT COUNT(1)
          INTO v_cnt_6
          FROM GT_SDPB2_BP_FCST_4 A
          LEFT OUTER JOIN SCM_MST_SITE_ITEM B
          ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID AND B.VALID_YN = 'Y'
          WHERE B.DIVISION_ID IS NULL;
          IF v_cnt_6 > 0 THEN
            v_log_type := 'INVALID';
            SELECT '[' || RTRIM(A.SCM_SITE_ID)  ||  '/ '  ||  RTRIM(A.PROJECT_CODE)  ||  '/ '  ||  RTRIM(A.ITEM_ID) || ']' ||  ' Invalid Sales Site/Project Code/Item !' INTO v_log_message
                          FROM GT_SDPB2_BP_FCST_4 A
                          LEFT OUTER JOIN SCM_MST_SITE_ITEM B
                                 ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID AND B.VALID_YN = 'Y'
                          WHERE B.DIVISION_ID IS NULL
                           FETCH FIRST 1 ROWS ONLY;
            OPEN O_RC7 FOR
            SELECT v_log_message FROM DUAL;
            GOTO END_PROC;
          END IF;
        END IF;
        -- SITE/SITE ITEM 잘못들어왔을때 강제 에러발생시킴 (END) [c20200722-000060]
        -- -----------------------------------------------------------------------------------------------
        BEGIN
          --======================================================
          -- LOC INSERT (START)
          --======================================================
          INSERT INTO GT_SDPB2_BP_FCST_4
          SELECT active_flag, TMP.DIVISION_ID, TMP.PROJECT_CODE, TMP.PROJECT_NAME, TMP.SCM_SITE_ID, TMP.PLANT_SITE_ID, TMP.ITEM_ID--,TMP.DOM_EXP
             , TMP.FCST_TYPE, TMP.INCOTERMS -- PJ20200138 Incoterms 삭제
             -- -----------------------------------------------------------------------------------------------
             -- PJ20200138 item_use, unit_energy 추가 (START)
             , TMP.ITEM_USE, TMP.UNIT_ENERGY
             -- PJ20200138 item_use, unit_energy 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , 'SalesAmt_LOC' MEASURE, TMP.YYYYMM, TMP.CURRENCY, NVL(FCST.QTY * TMP.QTY,0)
             --( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
             --  AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6) || '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
             --AS QTY
             --, ( SELECT CASE WHEN TMP.CURRENCY = 'KRW' THEN TMP.QTY
             --       ELSE CASE WHEN TMP.CURRENCY = 'USD' THEN NVL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
             --                                     AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6) || '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE),0)
             --          ELSE CASE WHEN TMP.CURRENCY NOT IN ('KRW','USD') THEN NVL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
             --                                             AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6) || '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
             --           END
             --          END
             --       END )
             -- -----------------------------------------------------------------------------------------------
             -- 20190830 추가 (START)
             , TMP.DEPT_ID, TMP.END_CUSTOMER, TMP.BIZ_TYPE, TMP.CELL_PROD_SITE
             -- 20190830 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , TMP.CREATED_BY, TMP.LAST_UPDATED_BY
          FROM GT_SDPB2_BP_FCST_4 TMP
          INNER JOIN DM_PLN_BP_FCST FCST
              ON TMP.DIVISION_ID    = FCST.DIVISION_ID
               AND TMP.PROJECT_CODE   = FCST.PROJECT_CODE
               -- -----------------------------------------------------------------------------------------------
               -- 20200106 KHSONG 수정 (START)
               --AND TMP.PROJECT_NAME     = FCST.PROJECT_NAME  -- 주석처리
               AND TMP.SCM_SITE_ID    = FCST.SCM_SITE_ID  -- ADDED
               -- 20200106 KHSONG 수정 (END)
               -- -----------------------------------------------------------------------------------------------
               AND TMP.PLANT_SITE_ID  = FCST.PLANT_SITE_ID
               AND TMP.ITEM_ID      = FCST.ITEM_ID
               AND TMP.CELL_PROD_SITE = FCST.CELL_PROD_SITE
               AND TMP.FCST_TYPE    = FCST.FCST_TYPE
               AND TMP.INCOTERMS    = FCST.INCOTERMS -- PJ20200138 Incoterms 삭제
               AND TMP.YYYYMM     = FCST.YYYYMM
               AND TMP.CURRENCY     = FCST.CURRENCY
               AND FCST.MEASURE IN ( 'Business_Plan', 'MKT_FCST' )
               -- -----------------------------------------------------------------------------------------------
               -- 20190830 추가 (START)
               AND TMP.DEPT_ID            = FCST.DEPT_ID
               AND TMP.END_CUSTOMER       = FCST.END_CUSTOMER
               AND TMP.BIZ_TYPE           = FCST.BIZ_TYPE
               -- 20190830 추가 (END)
               -- -----------------------------------------------------------------------------------------------
               -- -----------------------------------------------------------------------------------------------
               -- PJ20200138 item_use, unit_energy 추가 (START)
               AND TMP.ITEM_USE           = FCST.ITEM_USE
               AND TMP.UNIT_ENERGY        = FCST.UNIT_ENERGY
               -- PJ20200138 item_use, unit_energy 추가 (END)
               -- -----------------------------------------------------------------------------------------------
          WHERE 1=1
          AND TMP.MEASURE = 'LOC';
          --======================================================
          -- LOC INSERT (END)
          --======================================================
          --======================================================
          -- KRW INSERT (START)
          --======================================================
          INSERT INTO GT_SDPB2_BP_FCST_4
          SELECT active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
             , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
             -- -----------------------------------------------------------------------------------------------
             -- PJ20200138 item_use, unit_energy 추가 (START)
             , ITEM_USE, UNIT_ENERGY
             -- PJ20200138 item_use, unit_energy 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , 'SalesAmt_KRW' AS MEASURE, YYYYMM, CURRENCY
             , NVL(( SELECT CASE WHEN TMP.CURRENCY = 'KRW' THEN TMP.QTY
                       ELSE CASE WHEN TMP.CURRENCY = 'USD' THEN NVL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
                                                     AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE),0)
                        ELSE CASE WHEN TMP.CURRENCY NOT IN ('KRW', 'USD') THEN NVL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
                                                              AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
                           END
                        END
                       END FROM DUAL),0)
             -- -----------------------------------------------------------------------------------------------
             -- 20190830 추가 (START)
             , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE
             -- 20190830 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , CREATED_BY, LAST_UPDATED_BY
          FROM GT_SDPB2_BP_FCST_4 TMP
          WHERE TMP.MEASURE = 'SalesAmt_LOC';
          --======================================================
          -- KRW INSERT (END)
          --======================================================
          --======================================================
          -- USD INSERT (START)
          --======================================================
          -- 20190906
          INSERT INTO GT_SDPB2_BP_FCST_4
          SELECT active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
             , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
             -- -----------------------------------------------------------------------------------------------
             -- PJ20200138 item_use, unit_energy 추가 (START)
             , ITEM_USE, UNIT_ENERGY
             -- PJ20200138 item_use, unit_energy 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , 'SalesAmt_USD' AS MEASURE, YYYYMM, CURRENCY
             , NVL(( SELECT CASE WHEN TMP.CURRENCY = 'KRW' THEN NVL(TMP.QTY / ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
                                                    AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE),0)
                         ELSE CASE WHEN TMP.CURRENCY = 'USD' THEN TMP.QTY
                            ELSE CASE WHEN TMP.CURRENCY NOT IN ('KRW', 'USD') -- KRW산출후 / USD
                                THEN NVL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
                                            AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
                                            / ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
                                              AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE)
                               END
                            END
                         END FROM DUAL),0)
             -- -----------------------------------------------------------------------------------------------
             -- 20190830 추가 (START)
             , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE
             -- 20190830 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , CREATED_BY, LAST_UPDATED_BY
          FROM GT_SDPB2_BP_FCST_4 TMP
          WHERE TMP.MEASURE = 'SalesAmt_LOC';
        END;
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A008-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        BEGIN
          SELECT COUNT(1) INTO n_insert_count FROM GT_SDPB2_BP_FCST_4  WHERE MEASURE = 'SalesAmt_LOC';
        END;

        BEGIN
          INSERT INTO GT_SDPB2_DM_PLN_BP_FCST_X_4
          ( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
          , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          , ITEM_USE, UNIT_ENERGY
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , MEASURE, YYYYMM, CURRENCY, QTY
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , CREATED_BY, LAST_UPDATED_BY )
          SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
             , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
             -- -----------------------------------------------------------------------------------------------
             -- PJ20200138 item_use, unit_energy 추가 (START)
             , ITEM_USE, UNIT_ENERGY
             -- PJ20200138 item_use, unit_energy 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , MEASURE, YYYYMM, CURRENCY, NVL(QTY,0)
             -- -----------------------------------------------------------------------------------------------
             -- 20190830 추가 (START)
             , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
             -- 20190830 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , CREATED_BY, LAST_UPDATED_BY
          FROM GT_SDPB2_BP_FCST_4
          WHERE 1=1;

          -- ----------------------------------------------------------------
          /* [2018-03-19][CURSOR를 이용해 HISTORY TABLE ADD
            방법1 : PROCEDURE CALL
            방법2 : 바로입력
          */
          -- ----------------------------------------------------------------
          -- 커서를 이용해 DIVISION_ID 만큼 LOOP
          -- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- SAVE_DM_PLN_BP_FCST_CUR CURSOR FAST_FORWARD FOR
          -- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- SAVE_DM_PLN_BP_FCST_CUR CURSOR FAST_FORWARD FOR
          --OPEN O_RC9 FOR
          --SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
          --    , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
          --    -- -----------------------------------------------------------------------------------------------
          --    -- PJ20200138 item_use, unit_energy 추가 (START)
          --    , ITEM_USE, UNIT_ENERGY
          --    -- PJ20200138 item_use, unit_energy 추가 (END)
          --    -- -----------------------------------------------------------------------------------------------
          --    , MEASURE, YYYYMM, CURRENCY, QTY
          --    -- -----------------------------------------------------------------------------------------------
          --    -- 20190830 추가 (START)
          --    , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
          --    -- 20190830 추가 (END)
          --    -- -----------------------------------------------------------------------------------------------
          --    , CREATED_BY, LAST_UPDATED_BY
          --FROM GT_SDPB2_BP_FCST_4
          --WHERE 1=1;

          FOR cur_rec IN (SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
              , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
              -- -----------------------------------------------------------------------------------------------
              -- PJ20200138 item_use, unit_energy 추가 (START)
              , ITEM_USE, UNIT_ENERGY
              -- PJ20200138 item_use, unit_energy 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              , MEASURE, YYYYMM, CURRENCY, QTY
              -- -----------------------------------------------------------------------------------------------
              -- 20190830 추가 (START)
              , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
              -- 20190830 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              , CREATED_BY, LAST_UPDATED_BY
          FROM GT_SDPB2_BP_FCST_4
          WHERE 1=1) LOOP
            v_DIVISION_ID := cur_rec.DIVISION_ID;
            v_PROJECT_CODE := cur_rec.PROJECT_CODE;
            v_PROJECT_NAME := cur_rec.PROJECT_NAME;
            v_SCM_SITE_ID := cur_rec.SCM_SITE_ID;
            v_PLANT_SITE_ID := cur_rec.PLANT_SITE_ID;
            v_ITEM_ID := cur_rec.ITEM_ID;
            v_FCST_TYPE := cur_rec.FCST_TYPE;
            v_INCOTERMS := cur_rec.INCOTERMS;
            v_ITEM_USE := cur_rec.ITEM_USE;
            v_UNIT_ENERGY := cur_rec.UNIT_ENERGY;
            v_MEASURE := cur_rec.MEASURE;
            v_YYYYMM := cur_rec.YYYYMM;
            v_CURRENCY := cur_rec.CURRENCY;
            v_QTY := cur_rec.QTY;
            v_DEPT_ID := cur_rec.DEPT_ID;
            v_END_CUSTOMER := cur_rec.END_CUSTOMER;
            v_BIZ_TYPE := cur_rec.BIZ_TYPE;
            v_CELL_PROD_SITE := cur_rec.CELL_PROD_SITE;
            v_CREATED_BY := cur_rec.CREATED_BY;
            v_LAST_UPDATED_BY := cur_rec.LAST_UPDATED_BY;
            SELECT SEQ1_DM_PLN_BP_FCST_H.NEXTVAL INTO n_history_seq FROM DUAL;
              --======================================================
              -- HISTORY INSERT (START)
              --======================================================
               INSERT INTO DM_PLN_BP_FCST_H
              ( HISTORY_SEQ, ACTIVE_FLAG, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
              -- -----------------------------------------------------------------------------------------------
              -- PJ20200138 item_use, unit_energy 추가 (START)
              , ITEM_USE, UNIT_ENERGY
              -- PJ20200138 item_use, unit_energy 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              , INCOTERMS, MEASURE, YYYYMM, CURRENCY, QTY -- PJ20200138 Incoterms 삭제
              , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
              -- -----------------------------------------------------------------------------------------------
              -- 20190830 추가 (START)
              , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
              -- 20190830 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              )
              VALUES
              ( n_history_seq, v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_PROJECT_NAME, v_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID, '', v_FCST_TYPE
              -- -----------------------------------------------------------------------------------------------
              -- PJ20200138 item_use, unit_energy 추가 (START)
              , v_ITEM_USE, v_UNIT_ENERGY
              -- PJ20200138 item_use, unit_energy 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              , v_INCOTERMS, v_MEASURE, v_YYYYMM, v_CURRENCY, NVL(v_QTY,0) -- PJ20200138 Incoterms 삭제
              , v_CREATED_BY, SYSDATE, v_LAST_UPDATED_BY, SYSDATE
              -- -----------------------------------------------------------------------------------------------
              -- 20190830 추가 (START)
              , v_DEPT_ID, v_END_CUSTOMER, v_BIZ_TYPE, v_CELL_PROD_SITE--,v_CELL_PER_PACK,v_CELL_PER_MODULE,v_MODULE_PER_PACK
              -- 20190830 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              );
              --======================================================
              -- HISTORY INSERT (END)
              --======================================================
              --FETCH SAVE_DM_PLN_BP_FCST_CUR INTO v_DIVISION_ID, v_PROJECT_CODE, v_PROJECT_NAME, v_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID--,v_DOM_EXP
              --                     , v_FCST_TYPE, v_INCOTERMS -- PJ20200138 Incoterms 삭제
              --                     -- -----------------------------------------------------------------------------------------------
              --                     -- PJ20200138 item_use, unit_energy 추가 (START)
              --                     , v_ITEM_USE, v_UNIT_ENERGY
              --                     -- PJ20200138 item_use, unit_energy 추가 (END)
              --                     -- -----------------------------------------------------------------------------------------------
              --                     , v_MEASURE, v_YYYYMM, v_CURRENCY, v_QTY
              --                     -- -----------------------------------------------------------------------------------------------
              --                     -- 20190830 추가 (START)
              --                     , v_DEPT_ID, v_END_CUSTOMER, v_BIZ_TYPE, v_CELL_PROD_SITE--,v_CELL_PER_PACK--,v_CELL_PER_MODULE--,v_MODULE_PER_PACK
              --                     -- 20190830 추가 (END)
              --                     -- -----------------------------------------------------------------------------------------------
              --                     , v_CREATED_BY, v_LAST_UPDATED_BY
          END LOOP;

          --CLOSE SAVE_DM_PLN_BP_FCST_CUR
          --DEALLOCATE SAVE_DM_PLN_BP_FCST_CUR
        END;
        --======================================================
        -- INPUT된 Business_Plan MEASURE INSERT (END)
        --======================================================
      END;
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A009-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

      --======================================================
      -- DELETE (START)
      --======================================================

        DELETE
        FROM DM_PLN_BP_FCST
        WHERE ( SELECT COUNT(1) FROM GT_SDPB2_DM_PLN_BP_FCST_X_4
            WHERE 1=1
            AND DM_PLN_BP_FCST.DIVISION_ID    = DIVISION_ID
            AND DM_PLN_BP_FCST.PROJECT_CODE   = PROJECT_CODE
            --AND DM_PLN_BP_FCST.PROJECT_NAME = PROJECT_NAME
            AND DM_PLN_BP_FCST.SCM_SITE_ID    = SCM_SITE_ID
            AND DM_PLN_BP_FCST.PLANT_SITE_ID  = PLANT_SITE_ID
            AND DM_PLN_BP_FCST.ITEM_ID      = ITEM_ID
            AND DM_PLN_BP_FCST.CELL_PROD_SITE = CELL_PROD_SITE
            AND DM_PLN_BP_FCST.FCST_TYPE    = FCST_TYPE
            AND DM_PLN_BP_FCST.INCOTERMS    = INCOTERMS -- PJ20200138 Incoterms 삭제
            -- -----------------------------------------------------------------------------------------------
            -- PJ20200138 item_use, unit_energy 추가 (START)
            AND DM_PLN_BP_FCST.ITEM_USE     = ITEM_USE
            AND DM_PLN_BP_FCST.UNIT_ENERGY    = UNIT_ENERGY
            -- PJ20200138 item_use, unit_energy 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            AND DM_PLN_BP_FCST.MEASURE      = MEASURE
            AND DM_PLN_BP_FCST.YYYYMM     = YYYYMM
            -- -----------------------------------------------------------------------------------------------
            -- 20190830 추가 (START)
            AND DM_PLN_BP_FCST.DEPT_ID      = DEPT_ID
            AND DM_PLN_BP_FCST.END_CUSTOMER   = END_CUSTOMER
            AND DM_PLN_BP_FCST.BIZ_TYPE     = BIZ_TYPE
            -- 20190830 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            AND DM_PLN_BP_FCST.CURRENCY     = CURRENCY  -- 20190916 KHSONG ADDED
            ) > 0;
      --======================================================
      --======================================================
      -- DELETE (END)
      --======================================================
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A010-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      INSERT INTO DM_PLN_BP_FCST
      ( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP ,FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
      -- -----------------------------------------------------------------------------------------------
      -- PJ20200138 item_use, unit_energy 추가 (START)
      , ITEM_USE, UNIT_ENERGY
      -- PJ20200138 item_use, unit_energy 추가 (END)
      -- -----------------------------------------------------------------------------------------------
      , MEASURE, YYYYMM, CURRENCY, QTY
      -- -----------------------------------------------------------------------------------------------
      -- 20190830 추가 (START)
      , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
      -- 20190830 추가 (END)
      -- -----------------------------------------------------------------------------------------------
      , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
      SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, '' AS DOM_EXP, FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
         -- -----------------------------------------------------------------------------------------------
         -- PJ20200138 item_use, unit_energy 추가 (START)
         , ITEM_USE, UNIT_ENERGY
         -- PJ20200138 item_use, unit_energy 추가 (END)
         -- -----------------------------------------------------------------------------------------------
         , MEASURE ,YYYYMM, CURRENCY, QTY
         -- -----------------------------------------------------------------------------------------------
         -- 20190830 추가 (START)
         , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
         -- 20190830 추가 (END)
         -- -----------------------------------------------------------------------------------------------
         , CREATED_BY, SYSDATE, LAST_UPDATED_BY, SYSDATE
      FROM GT_SDPB2_DM_PLN_BP_FCST_X_4
      WHERE 1=1;

      -- PK UPDATE 를 위해서 들어온경우 UPDATE 처리 후 바로 빠짐
      <<END_PKUPDATE>>
      NULL;

      <<END_PROC>>
      NULL;

DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A011-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    --======================================================
    -- 트랜잭션 (COMMIT)
    --======================================================
        COMMIT;
    -- -----------------------------------------------------------------------------------------
        -- END TRY
  -- -----------------------------------------------------------------------------------------
  -- 수행결과 성공여부 DISPLAY
  IF v_log_type IS NULL OR v_log_type NOT IN ('ERROR','INVALID') THEN
  OPEN O_RC1 FOR
  SELECT 'success' FROM DUAL;

  --======================================================
    -- 종료 LOG (START)
  --======================================================
  v_log_type := 'END';
  v_log_message := '########## END of procedure ##########';
  v_description := 'delete_count= '  ||  TO_CHAR(n_del_count)  ||  ' / insert_count= '  ||  TO_CHAR(n_insert_count)  ;
  d_event_date := SYSTIMESTAMP;
  PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );

  END IF;

  EXCEPTION
      WHEN OTHERS THEN
  -- -----------------------------------------------------------------------------------------
    -- ROLLBACK
    --======================================================
    -- 트랜잭션 (END)
    --======================================================
        -- ERROR LOG VALUE SAVE
    v_log_type := 'ERROR';
    v_log_message := SUBSTR(SQLERRM, 1, 1000);
    v_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
    d_event_date := SYSTIMESTAMP;
    v_log_message := '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data  => v_in_para_data,
        p_sql_err_code  => SQLCODE,
        p_sql_err_msg   => SQLERRM,
        p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );
  -- -----------------------------------------------------------------------------------------
  -- END CATCH
  -- -----------------------------------------------------------------------------------------
    RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || v_in_para_data
    );
END;
/
