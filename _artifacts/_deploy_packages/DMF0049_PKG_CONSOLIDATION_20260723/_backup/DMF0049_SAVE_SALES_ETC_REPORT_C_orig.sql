
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0049_SAVE_SALES_ETC_REPORT_C" 
(
      p_active_flag           IN VARCHAR2
    , p_result_month          IN VARCHAR2
    , p_division_id           IN VARCHAR2
    , p_version_no            IN VARCHAR2
    , p_data_seq              IN VARCHAR2
    , p_department_id         IN VARCHAR2
    , p_department_edit_flag  IN VARCHAR2
    , p_department_name       IN VARCHAR2
    , p_dept_id               IN VARCHAR2
    , p_cust_report           IN VARCHAR2
    , p_end_cust_report       IN VARCHAR2
    , p_soldto_code           IN VARCHAR2
    , p_soldto_cust_report    IN VARCHAR2
    , p_product_group         IN VARCHAR2
    , p_item_id               IN VARCHAR2
    , p_product_details       IN VARCHAR2
    , p_currency              IN VARCHAR2
    , p_company_id            IN VARCHAR2
    , p_biz_type              IN VARCHAR2
    , p_application_gr        IN VARCHAR2
    , p_application           IN VARCHAR2
    , p_country_code          IN VARCHAR2
    , p_project_code          IN VARCHAR2
    , p_scm_site_id           IN VARCHAR2
    , p_fcst_type             IN VARCHAR2
    , p_item_use              IN VARCHAR2
    , p_soldto_country        IN VARCHAR2
    , p_shipto_country        IN VARCHAR2
    , p_end_customer          IN VARCHAR2
    , p_etc_descr             IN VARCHAR2
    , p_cell_model_info       IN VARCHAR2   --[C20210125-000207] 40사업부 CELL_MODEL_INFO 컬럼 추가
    , p_cell_model            IN VARCHAR2   --[C20211112-000213]
    , p_measure               IN VARCHAR2
    , p_yyyymmdd              IN VARCHAR2
    , p_qty                   IN VARCHAR2
    , p_created_by            IN VARCHAR2
    , O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0049_SAVE_SALES_ETC_REPORT_C
 * Description  : 'DM_PLN_SALES_ETC_REPORT_C' TABLE INSERT/UPDATE/DELETE
 * Program History
 *========================================================================================================================
 * 2020/04/08	HWI1993		Initial Release
 * 2020/05/22	hwi1993		Save 이후에 Transfer 처리
 * 2020/09/09   P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/01/26   P.C.I		[C20210125-000207] 40사업부 RTF Measure, CELL_MODEL_INFO 컬럼 추가
 * 2021/08/16	hwi1993		[C20210811-000341] ETC Report - GDW 전송시 누락 컬럼 점검
 * 2022/01/14	rosia27		[C20220105-000064]ETC Report 구버전 조회시 조직 명칭 오류의 건
 * 2022/01/21	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2025/05/09	JSSBAE		[E20250418-001567]_40사업부 Sales Report, ETC Report 개선
 * 2025/07/21	JSSBAE		[E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리
 * 2026/02/03	JSSBAE		[E20260107-001542]_DM_COMPANY 룩업코드 로직 개선
 * 2026/06/05	NextSCM Migration	[PJ202650304] 기존 배포본(미완성 자동변환, INVALID) 전면 재변환. ^구분 WHILE파싱→행생성기 분리 INSERT(빈필드 보존), #temp→GTT(GT_DMF0049_RESULTS_MST/_PRICE/_TEMP_ITEM_SINGLE), GOTO ERR_RTN→구조화 조기 RETURN, UPDATE..FROM/DELETE..JOIN→MERGE/상관서브쿼리/EXISTS, NEXT VALUE FOR SEQ1_DM_PLN_SALES_ETC_REPORT_H 시퀀스 신설, GETDATE→SYSDATE, QTY 문자열↔TO_NUMBER, 로깅(PR_DM_SYS_LOG_BATCH)/EXCEPTION/O_RESULT_CURSOR 표준
 */
IS
    V_PROGRAM_NAME      VARCHAR2(200 CHAR) := 'DMF0049_SAVE_SALES_ETC_REPORT_C';
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_LOG_DESCRIPTION   VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_insert_count      PLS_INTEGER := 0;
    n_input_count       PLS_INTEGER := 0;

    v_log_user          VARCHAR2(150 CHAR);
    v_division_id       VARCHAR2(4000 CHAR);
    v_version_no        VARCHAR2(4000 CHAR);
    v_result_month      VARCHAR2(4000 CHAR);
    v_cutoff_yyyymmdd   VARCHAR2(8 CHAR);
    v_cutoff_type       VARCHAR2(20 CHAR);
    v_max_seq           NUMBER := 0;
    v_etc_department_id   VARCHAR2(30 CHAR);
    v_etc_department_name VARCHAR2(100 CHAR);
    v_chk               PLS_INTEGER := 0;
    v_dup_msg           VARCHAR2(2000 CHAR);

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

    PROCEDURE LOG_END IS
    BEGIN
        V_LOG_TYPE        := 'END';
        V_LOG_MESSAGE     := '########## END of procedure ##########';
        V_LOG_DESCRIPTION := 'input_count: ' || TO_CHAR(n_input_count);
        D_EVENT_DATE      := SYSDATE;
        SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, v_log_user);
    END LOG_END;

BEGIN
    -- 로그 사용자 (p_created_by 의 첫 '^' 토큰)
    IF INSTR(p_created_by, '^') > 1 THEN
        v_log_user := SUBSTR(p_created_by, 1, INSTR(p_created_by, '^') - 1);
    ELSE
        v_log_user := p_created_by;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE        := 'START';
    V_LOG_MESSAGE     := '########## Start of procedure @@@##########';
    V_LOG_DESCRIPTION := '';
    D_EVENT_DATE      := SYSDATE;
    SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, v_log_user);
    V_LOG_MESSAGE := NULL;

    -- GTT 초기화
    DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST;
    DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST_PRICE;
    DELETE FROM SCM_MGR.GT_DMF0049_TEMP_ITEM_SINGLE;

    -----------------------------------------------------------------------------------------------------------------------
    -- ^ 구분 입력 파싱 → #results_MST (원본 WHILE 루프 대체: 행 생성기 + 위치 기반 분리, 빈 필드 보존)
    -----------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0049_RESULTS_MST
        ( ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
        , DEPARTMENT_ID, DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME, DEPT_ID, CUST_REPORT
        , END_CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID
        , PRODUCT_DETAILS, CURRENCY, COMPANY_ID, BIZ_TYPE, APPLICATION_GR
        , APPLICATION, COUNTRY_CODE, PROJECT_CODE, SCM_SITE_ID, CELL_MODEL_INFO
        , CELL_MODEL, FCST_TYPE, MEASURE, YYYYMMDD, QTY
        , CREATED_BY, ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER )
    SELECT TRIM(REGEXP_SUBSTR(RTRIM(p_active_flag)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_result_month)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_division_id)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_version_no)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_data_seq)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_department_id)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_department_edit_flag)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_department_name)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_dept_id)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_cust_report)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_end_cust_report)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_soldto_code)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_soldto_cust_report)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_product_group)||'^','(.*?)\^',1,n,NULL,1))
         , REPLACE(REPLACE(REPLACE(REPLACE(TRIM(REGEXP_SUBSTR(RTRIM(p_item_id)||'^','(.*?)\^',1,n,NULL,1)),CHR(13),''),CHR(10),''),CHR(9),''),' ','')
         , TRIM(REGEXP_SUBSTR(RTRIM(p_product_details)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_currency)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_company_id)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_biz_type)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_application_gr)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_application)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_country_code)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_project_code)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_scm_site_id)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_cell_model_info)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_cell_model)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_fcst_type)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_measure)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_yyyymmdd)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_qty)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_created_by)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_item_use)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_soldto_country)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_shipto_country)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_end_customer)||'^','(.*?)\^',1,n,NULL,1))
    FROM ( SELECT LEVEL AS n FROM DUAL
           CONNECT BY LEVEL <= REGEXP_COUNT(RTRIM(p_division_id)||'^','\^') );

    -----------------------------------------------------------------------------------------------------------------------
    -- [E20260107-001542]_DM_COMPANY 룩업코드 검증 (구코드 COMPANY_ID 저장 불가)
    -----------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_chk FROM SCM_MGR.GT_DMF0049_RESULTS_MST R
     WHERE R.COMPANY_ID IN ( SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'COMPANY_ID' GROUP BY OLD_VALUE1 )
       AND ROWNUM = 1;
    IF v_chk > 0 THEN
        ROLLBACK;
        V_LOG_TYPE := 'INVALID'; V_LOG_MESSAGE := '구코드 COMPANY_ID는 저장할 수 없습니다.'; V_LOG_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE);
        LOG_END;
        OPEN O_RESULT_CURSOR FOR SELECT '구코드 COMPANY_ID는 저장할 수 없습니다.' AS MSG FROM DUAL;
        RETURN;
    END IF;

    -----------------------------------------------------------------------------------------------------------------------
    -- 가공처리
    -----------------------------------------------------------------------------------------------------------------------
    -- 수량 공백 → 0
    UPDATE SCM_MGR.GT_DMF0049_RESULTS_MST SET QTY = '0' WHERE QTY IS NULL;

    --[C20210125-000207] 40사업부 RTF Measure 없으면 Row 삭제
    DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST
    WHERE DIVISION_ID = '40' AND MEASURE = 'RTF_SYS_RP' AND ACTIVE_FLAG = 'I' AND QTY = '0';

    UPDATE SCM_MGR.GT_DMF0049_RESULTS_MST
    SET QTY = TO_CHAR(ROUND(TO_NUMBER(QTY), 3))
    WHERE DIVISION_ID = '40' AND MEASURE = 'RTF_SYS_RP';

    --Start [C20210125-000207] 40사업부 Unit Price Measure 추가
    INSERT INTO SCM_MGR.GT_DMF0049_RESULTS_MST_PRICE
        ( ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
        , DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE
        , SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY
        , COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE
        , PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, CELL_MODEL_INFO, CELL_MODEL
        , MEASURE, YYYYMMDD, SALESAMT_LOC, RTF_SYS_RP, CREATED_BY
        , ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME )
    SELECT ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
         , DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE
         , SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY
         , COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE
         , PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, CELL_MODEL_INFO, CELL_MODEL
         , 'LOC' AS MEASURE, YYYYMMDD
         , SUM(CASE WHEN MEASURE = 'SalesAmt_LOC' THEN ROUND(TO_NUMBER(QTY),3) ELSE 0.0 END) AS SALESAMT_LOC
         , SUM(CASE WHEN MEASURE = 'RTF_SYS_RP' THEN ROUND(TO_NUMBER(QTY),3) ELSE 0.0 END) AS RTF_SYS_RP
         , MAX(CREATED_BY) AS CREATED_BY, ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER
         , DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME
    FROM SCM_MGR.GT_DMF0049_RESULTS_MST
    WHERE MEASURE IN ('SalesAmt_LOC','RTF_SYS_RP')
      AND DIVISION_ID = '40'
    GROUP BY ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
         , DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE
         , SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY
         , COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE
         , PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, CELL_MODEL_INFO, CELL_MODEL
         , YYYYMMDD, ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER
         , DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME;

    INSERT INTO SCM_MGR.GT_DMF0049_RESULTS_MST
        ( ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
        , DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE
        , SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY
        , COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE
        , PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, CELL_MODEL_INFO, CELL_MODEL
        , MEASURE, YYYYMMDD, QTY, CREATED_BY, ITEM_USE
        , SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME )
    SELECT ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
         , DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE
         , SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY
         , COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE
         , PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, CELL_MODEL_INFO, CELL_MODEL
         , MEASURE, YYYYMMDD
         , TO_CHAR(CASE WHEN NVL(RTF_SYS_RP, 0) = 0 THEN 0 ELSE SALESAMT_LOC / RTF_SYS_RP END) AS QTY
         , CREATED_BY, ITEM_USE
         , SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME
    FROM SCM_MGR.GT_DMF0049_RESULTS_MST_PRICE
    WHERE NVL(RTF_SYS_RP, 0) != 0;
    --End [C20210125-000207]

    -- yyyymm 값을 월별 첫 영업일(yyyymmdd)로 변환
    UPDATE SCM_MGR.GT_DMF0049_RESULTS_MST A
    SET A.YYYYMMDD = ( SELECT MIN(BASIS_START_DATE) FROM SCM_SYS_CALENDAR_M C
                       WHERE SUBSTR(C.BASIS_YYYYMMDD,1,6) = SUBSTR(A.YYYYMMDD,1,6)
                       AND C.DAYOFWEEK IN ('MON','TUE','WED','THU','FRI') );

    -- 폼에서 result_month 는 실적 편집 시에만 넘김. division/version/result_month 대표값
    BEGIN
        SELECT DIVISION_ID, VERSION_NO, RESULT_MONTH
          INTO v_division_id, v_version_no, v_result_month
        FROM SCM_MGR.GT_DMF0049_RESULTS_MST WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_division_id := NULL; v_version_no := NULL; v_result_month := NULL;
    END;

    -----------------------------------------------------------------------------------------------------------------------
    --[E20250418-001567]_저장 시 VALIDATION (Sales Report 테이블 기준 중복 검증)
    -----------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_chk FROM (
        SELECT A.VERSION_NO
          FROM DM_PLN_SALES_ETC_REPORT_C A
          INNER JOIN SCM_MGR.GT_DMF0049_RESULTS_MST B
                  ON A.VERSION_NO = B.VERSION_NO
                 AND A.DIVISION_ID = B.DIVISION_ID
                 AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
                 AND A.DEPT_ID = B.DEPT_ID
                 AND A.ITEM_ID = B.ITEM_ID
                 AND A.MEASURE = B.MEASURE
                 AND A.YYYYMMDD = B.YYYYMMDD
                 AND A.CURRENCY = B.CURRENCY
                 AND A.COMPANY_ID = B.COMPANY_ID
                 AND A.END_CUST_REPORT = B.END_CUST_REPORT
                 AND A.CUST_REPORT = B.CUST_REPORT
                 AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                 AND A.COUNTRY_CODE = B.COUNTRY_CODE
         WHERE A.DIVISION_ID = v_division_id
           AND A.VERSION_NO = v_version_no
           AND ( (B.ACTIVE_FLAG != 'D') OR (NVL(TO_NUMBER(B.QTY),0) > 0) )
         GROUP BY A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.ITEM_ID
                , A.MEASURE, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.END_CUST_REPORT
                , A.CUST_REPORT, A.PRODUCT_GROUP, SCM_MGR.FN_GET_COUNTRY_KR_NAME(A.COUNTRY_CODE)
        HAVING COUNT(*) > 1
    );
    IF v_chk > 0 THEN
        ROLLBACK;
        v_dup_msg := 'GDW에 데이터를 전송할때는 Sales Report에 ETC Report가 포함되어 전송됩니다. Sales Report 테이블 기준으로 중복되는 값이 발생했습니다.' || CHR(10)
                  || '데이터 저장 시 중복되지 않아야하는 값은' || CHR(10)
                  || 'Division, Department, Team, Model, Measure, YYYYMM, Currency, Company Id, End Cust.(Report), Cust. (Report), Product Gr.(Report), Country Name' || CHR(10)
                  || '저장하시려는 데이터를 다시 한번 확인하시기 바랍니다.';
        V_LOG_TYPE := 'DUPICATION_INVALID'; V_LOG_MESSAGE := '데이터 저장 시 중복값이 발생했습니다. '; V_LOG_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
        SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, p_created_by);
        LOG_END;
        OPEN O_RESULT_CURSOR FOR SELECT v_dup_msg AS MSG FROM DUAL;
        RETURN;
    END IF;

    -- cutoff 정보
    BEGIN
        SELECT B.YYYYMMDD, A.VERSION_TYPE
          INTO v_cutoff_yyyymmdd, v_cutoff_type
        FROM DM_MDF_VERSION A
        JOIN DM_MST_VERSION B ON A.DIVISION_ID = B.DIVISION_ID AND A.ORI_CUTOFF_VERSION_NO = B.VERSION_NO
        WHERE A.VERSION_NO = v_version_no AND A.DIVISION_ID = v_division_id AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_cutoff_yyyymmdd := NULL; v_cutoff_type := NULL;
    END;

    -- INPUT COUNT 확인
    SELECT COUNT(ACTIVE_FLAG) INTO n_input_count FROM SCM_MGR.GT_DMF0049_RESULTS_MST;

    -----------------------------------------------------------------------------------------------------------------------
    -- DM_PLN_SALES_ETC_REPORT_C 테이블 DELETE (ACTIVE_FLAG='D')
    -----------------------------------------------------------------------------------------------------------------------
    DELETE FROM DM_PLN_SALES_ETC_REPORT_C A
    WHERE EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                   WHERE A.VERSION_NO = B.VERSION_NO
                     AND A.DIVISION_ID = B.DIVISION_ID
                     AND TO_CHAR(A.DATA_SEQ) = B.DATA_SEQ
                     AND A.MEASURE = B.MEASURE
                     AND A.YYYYMMDD = B.YYYYMMDD
                     AND B.ACTIVE_FLAG = 'D' );
    n_delete_count := SQL%ROWCOUNT;

    -- 아래서 다시 ACTIVE_FLAG 를 사용하지 않도록 지운다.
    DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST WHERE ACTIVE_FLAG = 'D';

    -----------------------------------------------------------------------------------------------------------------------
    -- DM_PLN_SALES_ETC_REPORT_C 테이블 UPDATE (수량만)
    -----------------------------------------------------------------------------------------------------------------------
    UPDATE DM_PLN_SALES_ETC_REPORT_C A
    SET A.QTY = ( SELECT MAX(TO_NUMBER(B.QTY)) FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                  WHERE A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID
                    AND TO_CHAR(A.DATA_SEQ) = B.DATA_SEQ AND A.MEASURE = B.MEASURE AND A.YYYYMMDD = B.YYYYMMDD )
    WHERE EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                   WHERE A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID
                     AND TO_CHAR(A.DATA_SEQ) = B.DATA_SEQ AND A.MEASURE = B.MEASURE AND A.YYYYMMDD = B.YYYYMMDD );

    -- 2021.08.28 추가된 컬럼 적용
    INSERT INTO SCM_MGR.GT_DMF0049_TEMP_ITEM_SINGLE
        ( ITEM_ID, ITEM_CLASS_NAME, ENERGY, CELL_QUANTITY, FORECAST_INFO_BIZ_TYPE
        , FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT )
    SELECT DISTINCT ITEM_ID, ITEM_CLASS_NAME
         , CASE WHEN REGEXP_LIKE(ENERGE, '^\d+\.?\d*$') THEN TO_NUMBER(ENERGE) ELSE 0 END AS ENERGY
         , CASE WHEN REGEXP_LIKE(CELL_QUANTITY, '^\d+\.?\d*$') THEN TO_NUMBER(CELL_QUANTITY) ELSE 0 END AS CELL_QUANTITY
         , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
    FROM DM_MST_ITEM_SINGLE_V
    WHERE DIVISION_ID = p_division_id;

    -- 1~3 담당 외 기타 부서코드
    BEGIN
        SELECT SEGMENT1, SEGMENT2 INTO v_etc_department_id, v_etc_department_name
        FROM SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT' AND SEGMENT3 = 'Y' AND ATTRIBUTE1 = 'Y' AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_etc_department_id := NULL; v_etc_department_name := NULL;
    END;

    -- #results_MST 부가정보 갱신 (원본 UPDATE..FROM → 상관 서브쿼리)
    UPDATE SCM_MGR.GT_DMF0049_RESULTS_MST A
    SET A.OWNER_NAME = ( SELECT SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(B.OWNER, ',', 'KO') FROM SCM_MST_SITE_ITEM B
                          WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND ROWNUM = 1 )
      , A.CUST_GROUP_DTL = ( SELECT B.CUST_GROUP_DTL FROM SCM_MST_SITE_ITEM B
                          WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND ROWNUM = 1 )
      , A.ROUTE = ( SELECT B.ROUTE FROM SCM_MST_SITE_ITEM B
                          WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND ROWNUM = 1 )
      , A.FORECAST_INFO_SPEC = ( SELECT C.FORECAST_INFO_SPEC FROM SCM_MGR.GT_DMF0049_TEMP_ITEM_SINGLE C WHERE A.ITEM_ID = C.ITEM_ID AND ROWNUM = 1 )
      , A.NICK_NAME = ( SELECT NVL((SELECT LK3.ATTRIBUTE1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK3
                                     WHERE A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL' AND ROWNUM = 1),
                                    C.NICK_NAME) FROM SCM_MGR.GT_DMF0049_TEMP_ITEM_SINGLE C WHERE A.ITEM_ID = C.ITEM_ID AND ROWNUM = 1 )
      , A.FORECAST_INFO_CELL_PACK_COUNT = ( SELECT NVL((SELECT CASE WHEN REGEXP_LIKE(LK3.ATTRIBUTE2,'^\d+\.?\d*$') THEN LK3.ATTRIBUTE2 ELSE '0' END FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK3
                                     WHERE A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL' AND ROWNUM = 1),
                                    C.FORECAST_INFO_CELL_PACK_COUNT) FROM SCM_MGR.GT_DMF0049_TEMP_ITEM_SINGLE C WHERE A.ITEM_ID = C.ITEM_ID AND ROWNUM = 1 )
      , A.COMPANY_NAME = ( SELECT D.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL D WHERE A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY' AND ROWNUM = 1 )
      , A.COUNTRY_KR_NAME = ( SELECT F.COUNTRY_KR_NAME FROM SCM_MST_COUNTRY F WHERE A.COUNTRY_CODE = F.COUNTRY AND ROWNUM = 1 )
      , A.DEPARTMENT_NAME = CASE WHEN p_division_id = '40' AND NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y') THEN v_etc_department_name
                                 WHEN A.DEPARTMENT_EDIT_FLAG = 'true'  THEN ( SELECT LK1.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y' AND ROWNUM=1 )
                                 WHEN A.DEPARTMENT_EDIT_FLAG = 'false' THEN A.T_DEPARTMENT_NAME
                                 WHEN A.DEPARTMENT_EDIT_FLAG IS NULL OR A.T_DEPARTMENT_NAME IS NULL THEN ''
                            END
      , A.DEPT_NAME = CASE WHEN p_division_id = '40' AND NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y') THEN v_etc_department_name
                           ELSE ( SELECT LK2.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK2 WHERE A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND ROWNUM=1 )
                      END;

    -----------------------------------------------------------------------------------------------------------------------
    -- UPDATE 대상(DATA_SEQ 존재): 동일 년월/메저 삭제 후 인서트
    -----------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_chk FROM SCM_MGR.GT_DMF0049_RESULTS_MST WHERE DATA_SEQ IS NOT NULL AND ROWNUM = 1;
    IF v_chk > 0 THEN
        DELETE FROM DM_PLN_SALES_ETC_REPORT_C A
        WHERE A.DIVISION_ID = v_division_id
          AND A.VERSION_NO = v_version_no
          AND EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                       WHERE TO_CHAR(A.DATA_SEQ) = B.DATA_SEQ
                         AND A.FCST_TYPE = B.FCST_TYPE
                         AND A.MEASURE = B.MEASURE
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD, 1, 6) || '%' );

        INSERT INTO DM_PLN_SALES_ETC_REPORT_C
        ( VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE
        , SOLDTO_CUST_REPORT, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME
        , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, INCOTERMS, MEASURE
        , PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
        , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, OWNER_NAME
        , CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE, DEPARTMENT_NAME, DEPT_NAME )
        SELECT A.VERSION_NO, A.DIVISION_ID, TO_NUMBER(A.DATA_SEQ), v_cutoff_type, v_cutoff_yyyymmdd, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE
        , A.SOLDTO_CUST_REPORT, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, '' AS PROJECT_NAME
        , A.SCM_SITE_ID, A.ITEM_ID, '' AS DOM_EXP, A.FCST_TYPE, A.ITEM_USE, A.SOLDTO_COUNTRY, A.SHIPTO_COUNTRY, A.END_CUSTOMER, '' AS INCOTERMS, A.MEASURE
        , '' AS PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, TO_NUMBER(A.QTY), v_log_user, SYSDATE, v_log_user, SYSDATE, '' AS ATTRIBUTE1
        , '' AS ATTRIBUTE2, NVL(A.CELL_MODEL,'') AS ATTRIBUTE3, '', '', '', '', '', '', '', A.OWNER_NAME
        , A.CUST_GROUP_DTL, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_PACK_COUNT, A.COMPANY_NAME, A.COUNTRY_KR_NAME, A.ROUTE, A.DEPARTMENT_NAME, A.DEPT_NAME
        FROM SCM_MGR.GT_DMF0049_RESULTS_MST A
        WHERE A.DATA_SEQ IS NOT NULL
          AND A.ACTIVE_FLAG <> 'D';
    END IF;

    -----------------------------------------------------------------------------------------------------------------------
    -- INSERT 대상(DATA_SEQ 미존재): DATA_SEQ 채번 후 인서트
    -----------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_chk FROM SCM_MGR.GT_DMF0049_RESULTS_MST WHERE DATA_SEQ IS NULL AND ROWNUM = 1;
    IF v_chk > 0 THEN
        SELECT NVL(MAX(DATA_SEQ), 1) INTO v_max_seq FROM DM_PLN_SALES_ETC_REPORT_C
        WHERE DIVISION_ID = v_division_id AND VERSION_NO = v_version_no;

        INSERT INTO DM_PLN_SALES_ETC_REPORT_C
        ( VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE
        , SOLDTO_CUST_REPORT, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME
        , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, INCOTERMS, MEASURE
        , PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
        , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, OWNER_NAME
        , CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE, DEPARTMENT_NAME, DEPT_NAME )
        SELECT A.VERSION_NO, A.DIVISION_ID
             , DENSE_RANK() OVER ( ORDER BY A.DEPARTMENT_ID, A.DEPT_ID, A.CUST_REPORT, A.END_CUST_REPORT
                                          , A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT, A.PRODUCT_GROUP, A.ITEM_ID, A.PRODUCT_DETAILS, A.CURRENCY
                                          , A.COMPANY_ID, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.ITEM_USE, A.SOLDTO_COUNTRY, A.SHIPTO_COUNTRY, A.END_CUSTOMER ) + v_max_seq AS DATA_SEQ
             , v_cutoff_type, v_cutoff_yyyymmdd, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE
             , A.SOLDTO_CUST_REPORT, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, '' AS PROJECT_NAME
             , A.SCM_SITE_ID, A.ITEM_ID, '' AS DOM_EXP, A.FCST_TYPE, A.ITEM_USE, A.SOLDTO_COUNTRY, A.SHIPTO_COUNTRY, A.END_CUSTOMER, '' AS INCOTERMS, A.MEASURE
             , '' AS PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, TO_NUMBER(A.QTY), v_log_user, SYSDATE, v_log_user, SYSDATE, '' AS ATTRIBUTE1
             , '' AS ATTRIBUTE2, NVL(A.CELL_MODEL,'') AS ATTRIBUTE3, '', '', '', '', '', '', '', A.OWNER_NAME
             , A.CUST_GROUP_DTL, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_PACK_COUNT, A.COMPANY_NAME, A.COUNTRY_KR_NAME, A.ROUTE, A.DEPARTMENT_NAME, A.DEPT_NAME
        FROM SCM_MGR.GT_DMF0049_RESULTS_MST A
        WHERE A.DATA_SEQ IS NULL;
    END IF;

    -----------------------------------------------------------------------------------------------------------------------
    --[E20250418-001567]_HISTORY 데이터 적재
    -----------------------------------------------------------------------------------------------------------------------
    INSERT INTO DM_PLN_SALES_ETC_REPORT_H
    ( VERSION_NO, DIVISION_ID, HISTORY_SEQ, DATA_SEQ, CUTOFF_TYPE
    , CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT
    , SOLDTO_CODE, SOLDTO_CUST_REPORT, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE
    , APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE
    , PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
    , SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, INCOTERMS, MEASURE
    , PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, ITEM_USE
    , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_NAME
    , COUNTRY_KR_NAME, CUST_GROUP_DTL, DEPARTMENT_NAME, DEPT_NAME, FORECAST_INFO_CELL_PACK_COUNT
    , FORECAST_INFO_SPEC, NICK_NAME, OWNER_NAME, ROUTE )
    SELECT A.VERSION_NO, A.DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_SALES_ETC_REPORT_H.NEXTVAL, A.DATA_SEQ, A.CUTOFF_TYPE
         , A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT
         , A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE
         , A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE
         , A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
         , A.SOLDTO_COUNTRY, A.SHIPTO_COUNTRY, A.END_CUSTOMER, A.INCOTERMS, A.MEASURE
         , A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.ITEM_USE
         , A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
         , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
         , A.COMPANY_NAME, A.COUNTRY_KR_NAME, A.CUST_GROUP_DTL, A.DEPARTMENT_NAME, A.DEPT_NAME
         , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.OWNER_NAME, A.ROUTE
    FROM DM_PLN_SALES_ETC_REPORT_C A
    INNER JOIN SCM_MGR.GT_DMF0049_RESULTS_MST B
            ON A.VERSION_NO = B.VERSION_NO
           AND A.DIVISION_ID = B.DIVISION_ID
           AND TO_CHAR(A.DATA_SEQ) = B.DATA_SEQ
           AND A.MEASURE = B.MEASURE
           AND A.YYYYMMDD = B.YYYYMMDD;

    -- UPDATE 후에 전송처리를 다시 한다.
    SELECT COUNT(*) INTO v_chk FROM DM_MDF_VERSION
     WHERE DIVISION_ID = v_division_id AND VERSION_NO = v_version_no AND SEND_YN = 'Y' AND ROWNUM = 1;
    IF v_chk > 0 THEN
        SCM_MGR.DMF0044_MOBILE_REPORT_CREATE(v_division_id, v_version_no, v_cutoff_type, 'T', v_log_user, O_RESULT_CURSOR);
    END IF;

    COMMIT;

    -- 수행결과 성공
    IF O_RESULT_CURSOR IS NULL OR NOT O_RESULT_CURSOR%ISOPEN THEN
        OPEN O_RESULT_CURSOR FOR SELECT 'success' AS MSG FROM DUAL;
    END IF;

    -- 종료 LOG
    LOG_END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE        := 'ERROR';
        V_LOG_MESSAGE     := 'EXCEPTION';
        V_LOG_DESCRIPTION := '';
        D_EVENT_DATE      := SYSDATE;
        V_SQL_CODE        := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG      := SQLERRM;
        V_PROC_INPUT      := JSON_OBJECT(
            'p_division_id' VALUE p_division_id,
            'p_version_no'  VALUE p_version_no,
            'p_created_by'  VALUE p_created_by
        );
        V_BACKTRACE       := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_LOG_DESCRIPTION, D_EVENT_DATE, v_log_user,
                V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END DMF0049_SAVE_SALES_ETC_REPORT_C;
/