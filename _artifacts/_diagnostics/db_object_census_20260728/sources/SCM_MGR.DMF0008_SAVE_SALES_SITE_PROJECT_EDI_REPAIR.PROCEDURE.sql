PROCEDURE           "DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR"
(
    p_division_id         VARCHAR2,
    p_project_code          VARCHAR2,
    p_scm_site_id         VARCHAR2,
    p_item_id             VARCHAR2,
    p_currency            VARCHAR2,
    p_kwh               VARCHAR2, --ATTRIBUTE8
    p_cell_per_car          VARCHAR2,
    p_cell_per_module       VARCHAR2,
    p_liability_period        VARCHAR2,
    p_valid_yn            VARCHAR2,
    p_bpms_exist          VARCHAR2,
    p_sales_company       VARCHAR2,
    p_sales_plant         VARCHAR2,
    p_module_variant        VARCHAR2, --ATTRIBUTE2
    p_incoterms           VARCHAR2, --ATTRIBUTE6
    p_created_by          VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
    , O_RC3  OUT  SYS_REFCURSOR
    , O_RC4  OUT  SYS_REFCURSOR
    , O_RC5  OUT  SYS_REFCURSOR
    , O_RC6  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID  : DMF0008_SAVE_EDI_MST_REPAIR
 * Description  : EDI GSCM MASTER DATA 정비
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.04.05    kdmcc14      []  EDI GSCM MASTER DATA 정비
 2026.03.15    김준규      [PJ20264226] NextSCM Pilot 설계 및 개발
 */
 /*
  DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR(p_division_id='81', p_project_code='A15PA7001');
    , p_scm_site_id='PSA_FR_VSL', p_item_id='APPSAPHEV-B1-D02', p_currency='EUR'
    , p_kwh = NULL, p_cell_per_car='84', p_cell_per_module='14', p_liability_period='0'
    , p_valid_yn='Y', p_bpms_exist='Y', p_sales_company='G480', p_sales_plant='G481'
    , p_module_variant = NULL, p_incoterms='FCA', p_created_by='kdmcc14'

*/
-- -------------------------------------------------------------------------------------------------------------------------------
AS

    v_DIVISION_ID VARCHAR2(4000 CHAR);
    v_PROJECT_CODE VARCHAR2(4000 CHAR);
    v_SCM_SITE_ID VARCHAR2(4000 CHAR);
    v_ITEM_ID VARCHAR2(4000 CHAR);
    v_CURRENCY VARCHAR2(4000 CHAR);
    v_KWH VARCHAR2(4000 CHAR);
    v_CELL_PER_CAR VARCHAR2(4000 CHAR);
    v_CELL_PER_MODULE VARCHAR2(4000 CHAR);
    v_LIABILITY_PERIOD VARCHAR2(4000 CHAR);
    v_VALID_YN VARCHAR2(4000 CHAR);
    v_BPMS_EXIST VARCHAR2(4000 CHAR);
    v_SALES_COMPANY VARCHAR2(4000 CHAR);
    v_SALES_PLANT VARCHAR2(4000 CHAR);
    v_MODULE_VARIANT VARCHAR2(4000 CHAR);
    v_INCOTERMS VARCHAR2(4000 CHAR);
    v_CREATED_BY VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_in_para_data VARCHAR2(4000);
    v_err_msg VARCHAR2(4000);
    v_err_code NUMBER;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_division_id' VALUE p_division_id,
            'p_project_code' VALUE p_project_code,
            'p_scm_site_id' VALUE p_scm_site_id,
            'p_item_id' VALUE p_item_id,
            'p_currency' VALUE p_currency,
            'p_kwh' VALUE p_kwh,
            'p_cell_per_car' VALUE p_cell_per_car,
            'p_cell_per_module' VALUE p_cell_per_module,
            'p_liability_period' VALUE p_liability_period,
            'p_valid_yn' VALUE p_valid_yn,
            'p_bpms_exist' VALUE p_bpms_exist,
            'p_sales_company' VALUE p_sales_company,
            'p_sales_plant' VALUE p_sales_plant,
            'p_module_variant' VALUE p_module_variant,
            'p_incoterms' VALUE p_incoterms,
            'p_created_by' VALUE p_created_by
          );

  v_DIVISION_ID := NULL;
  v_PROJECT_CODE := NULL;
  v_SCM_SITE_ID := NULL;
  v_ITEM_ID := NULL;
  v_CURRENCY := NULL;
  v_KWH := NULL;
  v_CELL_PER_CAR := NULL;
  v_CELL_PER_MODULE := NULL;
  v_LIABILITY_PERIOD := NULL;
  v_VALID_YN := NULL;
  v_BPMS_EXIST := NULL;
  v_SALES_COMPANY := NULL;
  v_SALES_PLANT := NULL;
  v_MODULE_VARIANT := NULL;
  v_INCOTERMS := NULL;
  v_CREATED_BY := NULL;

  v_delimiter := '^';

  v_log_type := 'START';
  v_log_message := '########## Start of procedure ##########';
  v_description := NULL;
  d_event_date := SYSTIMESTAMP;
  PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );

  -- 시작 LOG  (END)
  v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

  -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

    -- 프로시저 LOOP 길이를 판단
    v_max_loop_cnt := SCM_ARR_SPL_CNT(p_division_id, v_delimiter);
    WHILE LENGTH(p_division_id) > 0 AND v_mst_loop_cnt < v_max_loop_cnt LOOP

      -- v_mst_loop_cnt 1증가
      v_mst_loop_cnt := v_mst_loop_cnt + 1;

      -- 각 컬럼들에 대한 스플릿처리로직 스타트
      BEGIN

        v_DIVISION_ID := SCM_ARR_SPL_VAL(p_division_id, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_DIVISION_ID
        v_PROJECT_CODE := SCM_ARR_SPL_VAL(p_project_code, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_PROJECT_CODE
        v_SCM_SITE_ID := SCM_ARR_SPL_VAL(p_scm_site_id, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_SCM_SITE_ID
        v_ITEM_ID := SCM_ARR_SPL_VAL(p_item_id, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_ITEM_ID
        v_CURRENCY := SCM_ARR_SPL_VAL(p_currency, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_CURRENCY
        v_KWH := SCM_ARR_SPL_VAL(p_kwh, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_KWH
        v_CELL_PER_CAR := SCM_ARR_SPL_VAL(p_cell_per_car, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_CELL_PER_CAR
        v_CELL_PER_MODULE := SCM_ARR_SPL_VAL(p_cell_per_module, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_CELL_PER_MODULE
        v_LIABILITY_PERIOD := SCM_ARR_SPL_VAL(p_liability_period, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_LIABILITY_PERIOD
        v_VALID_YN := SCM_ARR_SPL_VAL(p_valid_yn, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_VALID_YN
        v_BPMS_EXIST := SCM_ARR_SPL_VAL(p_bpms_exist, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_BPMS_EXIST
        v_SALES_COMPANY := SCM_ARR_SPL_VAL(p_sales_company, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_SALES_COMPANY
        v_SALES_PLANT := SCM_ARR_SPL_VAL(p_sales_plant, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_SALES_PLANT
        v_MODULE_VARIANT := SCM_ARR_SPL_VAL(p_module_variant, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_MODULE_VARIANT
        v_INCOTERMS := SCM_ARR_SPL_VAL(p_incoterms, v_delimiter , v_mst_loop_cnt) ;
        --SELECT v_INCOTERMS
        v_created_by := p_created_by;

      END;

      -- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 start -----------------------------------------------
      IF v_VALID_YN IS NULL OR v_VALID_YN IS NULL THEN
          v_log_type := 'INVALID';
          OPEN O_RC1 FOR
          SELECT '필수 입력값을 확인하세요.'
          FROM DUAL;
          v_description := '필수 입력값을 확인하세요.';
          goto err_rtn;
        END IF;

      IF v_DIVISION_ID IS NULL OR v_DIVISION_ID IS NULL THEN
          v_log_type := 'INVALID';
          OPEN O_RC2 FOR
          SELECT 'Div 입력값을 확인하세요.'
          FROM DUAL;
          v_description := 'Div 입력값을 확인하세요.';
          goto err_rtn;
        END IF;

      IF v_PROJECT_CODE IS NULL OR v_PROJECT_CODE IS NULL THEN
          v_log_type := 'INVALID';
          OPEN O_RC3 FOR
          SELECT 'Project Code 입력값을 확인하세요.'
          FROM DUAL;
          v_description := 'Project Code 입력값을 확인하세요.';
          goto err_rtn;
        END IF;

      IF v_SCM_SITE_ID IS NULL OR v_SCM_SITE_ID IS NULL THEN
          v_log_type := 'INVALID';
          OPEN O_RC4 FOR
          SELECT 'Sales Site 입력값을 확인하세요.'
          FROM DUAL;
          v_description := 'Sales Site 입력값을 확인하세요.';
          goto err_rtn;
        END IF;

      IF v_ITEM_ID IS NULL OR v_ITEM_ID IS NULL THEN
          v_log_type := 'INVALID';
          OPEN O_RC5 FOR
          SELECT 'Model 입력값을 확인하세요.'
          FROM DUAL;
          v_description := 'Model 입력값을 확인하세요.';
          goto err_rtn;
        END IF;

      -- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 end -----------------------------------------------
      --SCM_MST_SITE_ITEM_H History 생성
      BEGIN
        INSERT INTO SCM_MST_SITE_ITEM_H
            ( DIVISION_ID ,HISTORY_SEQ, PROJECT_CODE ,SCM_SITE_ID, ITEM_ID
            , CURRENCY, CELL_PER_CAR, CELL_PER_MODULE, LIABILITY_PERIOD
            , SALES_PLAN_ADJUST_YN, ITEM_HRCY_ID, VALID_YN, BPMS_EXIST
            , CUST_GROUP, CUST_GROUP_DTL, OWNER, APPLICATION, ROUTE  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
            , SALES_COMPANY, SALES_PLANT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
            , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
--            , REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4
--            , REPORT_GROUP5, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8
            , EDI_LT, SCP_VMI_LT, PARTIAL_PLAN_YN )
        SELECT DIVISION_ID, SEQ1_SCM_MST_SITE_ITEM_H.NEXTVAL, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
            , v_CURRENCY, v_CELL_PER_CAR, v_CELL_PER_MODULE, v_LIABILITY_PERIOD
            , SALES_PLAN_ADJUST_YN, ITEM_HRCY_ID, v_VALID_YN, v_BPMS_EXIST
            , CUST_GROUP, CUST_GROUP_DTL, OWNER, APPLICATION, ROUTE  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
            , v_SALES_COMPANY, v_SALES_PLANT, v_CREATED_BY, SYSTIMESTAMP, v_CREATED_BY, SYSTIMESTAMP
            , ATTRIBUTE1, v_MODULE_VARIANT, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
            , v_INCOTERMS, ATTRIBUTE7, v_KWH, ATTRIBUTE9, ATTRIBUTE10
--            , REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4
--            , REPORT_GROUP5, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8
            , EDI_LT, SCP_VMI_LT, PARTIAL_PLAN_YN
        FROM SCM_MST_SITE_ITEM
        WHERE DIVISION_ID = v_DIVISION_ID
        AND PROJECT_CODE = v_PROJECT_CODE
        AND SCM_SITE_ID = v_SCM_SITE_ID
        AND ITEM_ID = v_ITEM_ID;
      END;

      IF v_mst_loop_cnt > 0 THEN

          --SCM_MST_SITE_ITEM
          MERGE INTO SCM_MST_SITE_ITEM A
          USING (
              SELECT
                v_DIVISION_ID DIVISION_ID,
                v_PROJECT_CODE PROJECT_CODE,
                v_SCM_SITE_ID SCM_SITE_ID,
                v_ITEM_ID ITEM_ID
              FROM DUAL
              ) B
          ON(
                A.DIVISION_ID  = B.DIVISION_ID
              AND A.PROJECT_CODE = B.PROJECT_CODE
              AND A.SCM_SITE_ID  = B.SCM_SITE_ID
              AND A.ITEM_ID = B.ITEM_ID

            )
          WHEN MATCHED THEN
            UPDATE SET
                  CURRENCY = v_CURRENCY
                  , CELL_PER_CAR = (CASE WHEN v_CELL_PER_CAR = 0 THEN NULL WHEN v_CELL_PER_CAR IS NULL THEN NULL ELSE v_CELL_PER_CAR END)
                  , CELL_PER_MODULE = (CASE WHEN v_CELL_PER_MODULE = 0 THEN NULL WHEN v_CELL_PER_MODULE IS NULL THEN NULL ELSE v_CELL_PER_MODULE END)
                  , LIABILITY_PERIOD = v_LIABILITY_PERIOD
                  , VALID_YN = v_VALID_YN
                  , BPMS_EXIST = v_BPMS_EXIST
                  , SALES_COMPANY = v_SALES_COMPANY
                  , SALES_PLANT = v_SALES_PLANT
                  , ATTRIBUTE2 = v_MODULE_VARIANT
                  , ATTRIBUTE6 = v_INCOTERMS
                  , ATTRIBUTE8 = v_KWH
                  , LAST_UPDATED_BY = v_CREATED_BY
                  , LAST_UPDATE_DATE  = SYSTIMESTAMP

          WHEN NOT MATCHED THEN
            INSERT (
                     DIVISION_ID
                   , PROJECT_CODE
                   , SCM_SITE_ID
                   , ITEM_ID
                   , CURRENCY
                   , CELL_PER_CAR
                   , CELL_PER_MODULE
                   , LIABILITY_PERIOD
                   , VALID_YN
                   , BPMS_EXIST
                   , SALES_COMPANY
                   , SALES_PLANT
                   , CREATED_BY
                   , CREATION_DATE
                   , LAST_UPDATED_BY
                   , LAST_UPDATE_DATE
                   , ATTRIBUTE2
                   , ATTRIBUTE6
                   , ATTRIBUTE8
                   )
            VALUES (
                   v_DIVISION_ID
                   , v_PROJECT_CODE
                   , v_SCM_SITE_ID
                   , v_ITEM_ID
                   , v_CURRENCY
                   , (CASE WHEN v_CELL_PER_CAR = 0 THEN NULL WHEN v_CELL_PER_CAR IS NULL THEN NULL ELSE v_CELL_PER_CAR END)
                   , (CASE WHEN v_CELL_PER_MODULE = 0 THEN NULL WHEN v_CELL_PER_MODULE IS NULL THEN NULL ELSE v_CELL_PER_MODULE END)
                   , v_LIABILITY_PERIOD
                   , v_VALID_YN
                   , v_BPMS_EXIST
                   , v_SALES_COMPANY
                   , v_SALES_PLANT
                   , v_CREATED_BY
                   , SYSTIMESTAMP
                   , v_CREATED_BY
                   , SYSTIMESTAMP
                   , v_MODULE_VARIANT
                   , v_INCOTERMS
                   , v_KWH
                   );

        END IF;

    END LOOP;

/*
  DMF0008_SAVE_SALES_SITE_EDI_REPAIR(p_division_id='81', p_end_customer='BMW', p_soldto_customer='BMW');
  , p_company_id='G480', p_scm_site_id='BMW_AT_GRZ', p_soldto_code='AT000003A', p_shipto_code='AT000003A'
  , p_vmi_yn='N', p_valid_yn='Y', p_cust_valid_yn='Y', p_rep_yn='Y'
  , p_country='AT', p_city='ATGRZ', p_ship_plan_auto='Y', p_dept_id='58665472', p_created_by='kdmcc14'

  DMF0008_SAVE_SALES_SITE_EDI_REPAIR(p_division_id='81^81', p_end_customer='BMW^BMW', p_soldto_customer='BMW^BMW');
  , p_company_id='G480^G480', p_scm_site_id='BMW_AT_GRZ^BMW_AT_SER', p_soldto_code='AT000003A^DE000272', p_shipto_code='AT000003A^ATH000024'
  , p_vmi_yn='N^', p_valid_yn='Y^Y', p_cust_valid_yn='Y^Y', p_rep_yn='Y^Y'
  , p_country='AT^AT', p_city='ATGRZ^ATSER', p_ship_plan_auto='Y^Y', p_dept_id='58665472^58665472', p_created_by='kdmcc14'

 */
    COMMIT;

  -- END TRY

  -- 트랜잭션 (END)
  <<err_rtn>>
  IF v_log_type = 'INVALID' THEN
            v_log_type := 'END';
      v_log_message := '########## END of procedure ##########';
      d_event_date := SYSTIMESTAMP;
      PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
  END IF;

  RETURN;

    OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
  EXCEPTION
      WHEN OTHERS THEN

    -- ERROR LOG
    v_err_code := SQLCODE;
    v_err_msg := SQLERRM;
    v_log_type := 'ERROR';
    v_log_message := SUBSTR(v_err_msg, 1, 1000);
    v_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
    d_event_date := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data  => v_in_para_data,
        p_sql_err_code  => v_err_code,
        p_sql_err_msg   => v_err_msg,
        p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );

    OPEN O_RC6 FOR
    SELECT '['  ||  TO_CHAR(v_err_code)  ||  ']'  ||  v_err_msg
    FROM DUAL;

    -- END CATCH

  -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
    RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || v_in_para_data
    );
END;