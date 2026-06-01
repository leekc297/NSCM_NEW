/*=============================================================================================
 * File         : 04_Package_PKG_DMF0003.sql
 * Description  : Package — PKG_DMF0003
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - $$PLSQL_UNIT 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0003 IS
/*
 * Program ID   : PKG_DMF0003
 * Description  : PKG_DMF0003
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.12   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */

    PROCEDURE P_DMF0003_GET_BUCKET_TYPE_CODE
    (
      O_RC1             OUT SYS_REFCURSOR,
      O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_CAR_FCST_EXCEL_UPLOAD
    (
      P_MODE          IN  PLS_INTEGER,
      P_CREATED_BY    IN  VARCHAR2,
      O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_DM_ANL_CAR_PROPERTY
    (
      P_DIVISION_ID   IN VARCHAR2,
      P_MAKER_NAME    IN VARCHAR2,
      O_RC1           OUT SYS_REFCURSOR,
      O_RC2           OUT SYS_REFCURSOR,
      O_RC3           OUT SYS_REFCURSOR,
      O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_DM_ANL_CAR_REF
    (
        P_FROM_YYYYMMDD IN VARCHAR2,
        P_TO_YYYYMMDD   IN VARCHAR2,
        P_CAR_MAKER     IN VARCHAR2,
        P_CAR_MODEL     IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RC2           OUT SYS_REFCURSOR,
        O_RC3           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_PROJECT_CODE  IN VARCHAR2,
        P_YYYYMM        IN VARCHAR2,
        P_CREATED_BY    IN VARCHAR2,
        P_END_CUSTOMER  IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_PROJECT_CODE  IN VARCHAR2,
        P_YYYYMM        IN VARCHAR2,
        P_CREATED_BY    IN VARCHAR2,
        P_END_CUSTOMER  IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_DIVISION_ID     IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_MKT_FCST_COMPARE_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_SCM_SITE_ID   IN VARCHAR2,
        P_PROJECT_CODE  IN VARCHAR2,
        P_ITEM_ID       IN VARCHAR2,
        --[C20210225-000385] dom_exp, fcst_type, incoterms, yyyymmdd 추가
        P_DOM_EXP       IN VARCHAR2,
        P_FCST_TYPE     IN VARCHAR2,
        P_INCOTERMS     IN VARCHAR2,
        P_YYYYMMDD      IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_QTY_TYPE_CODE
    (
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_REPORT_BUCKET_TYPE_CODE
    (
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_SPREAD_TITLE_CAR
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_DIVISION_ID     IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_SPREAD_TITLE_PSI
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_DIVISION_ID     IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_SPREAD_TITLE_PSI_POPUP
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_DIVISION_ID     IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_MKT_FCST_SALES_PLAN_SYNC
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_CREATED_BY    IN VARCHAR2,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE
    (
         P_DIVISION_ID        IN VARCHAR2
        ,P_PROJECT_CODE       IN VARCHAR2
        ,P_SCM_SITE_ID        IN VARCHAR2
        ,P_ITEM_ID            IN VARCHAR2
        ,P_DOM_EXP            IN VARCHAR2
        ,P_FCST_TYPE          IN VARCHAR2
        ,P_INCOTERMS          IN VARCHAR2
        ,P_PLANT_SITE_ID      IN VARCHAR2
        ,P_DOM_EXP_NEW        IN VARCHAR2
        ,P_FCST_TYPE_NEW      IN VARCHAR2
        ,P_INCOTERMS_NEW      IN VARCHAR2
        ,P_PLANT_SITE_ID_NEW  IN VARCHAR2
        ,P_CREATED_BY         IN VARCHAR2
        ,O_RESULT_CURSOR      OUT SYS_REFCURSOR
    );


    -- ============================================================
    -- 신규 흡수 (2026-05-13 P1-2): standalone SP에서 통합
    -- ============================================================
    PROCEDURE P_DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC (
    		p_division_id			VARCHAR2,
    		p_project_code			VARCHAR2,
    		p_project_name		    VARCHAR2,
    		p_yyyymm_from			VARCHAR2,
    		p_yyyymm_to			VARCHAR2,
    		p_yyyymm_from_simul	VARCHAR2,
    		p_yyyymm_to_simul		VARCHAR2,
    		p_created_by			VARCHAR2,
        	p_end_customer VARCHAR2
    );

    PROCEDURE P_DMF0003_GET_DM_ANL_MKT_PSI_DATA (
    	 p_division_id VARCHAR2
    	,p_project_code VARCHAR2
    	,p_project_name VARCHAR2
    	,p_yyyymm VARCHAR2
    	,p_created_by VARCHAR2
    	,p_end_customer VARCHAR2
    );

    PROCEDURE P_DMF0003_GET_PRPOPUP (
    	p_POPUP_TYPE		VARCHAR2,
        p_division_id		VARCHAR2,
    	p_REQUEST_NO		VARCHAR2,
        p_PROJECT_CODE		VARCHAR2,
        p_SCM_SITE_ID		VARCHAR2,
        p_ITEM_ID	        VARCHAR2,
    	p_DOM_EXP			VARCHAR2,
    	p_FCST_TYPE		VARCHAR2,
    	p_INCOTERMS		VARCHAR2,
    	p_PLANT_SITE_ID	VARCHAR2,
    	p_YYYYMMDD			VARCHAR2, --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
    	P_PLAN_QTY			VARCHAR2,
    	p_CREATED_BY		VARCHAR2
    );

    PROCEDURE P_DMF0003_GET_PR_HISTORY_POPUP (
    	p_POPUP_TYPE		VARCHAR2,
        p_division_id		VARCHAR2,
    	p_REQUEST_NO		VARCHAR2,
        p_PROJECT_CODE		VARCHAR2,
        p_SCM_SITE_ID		VARCHAR2,
        p_ITEM_ID	        VARCHAR2,
    	p_DOM_EXP			VARCHAR2,
    	p_FCST_TYPE		VARCHAR2,
    	p_INCOTERMS		VARCHAR2,
    	p_PLANT_SITE_ID	VARCHAR2,
    	p_YYYYMMDD			VARCHAR2,
    	P_PLAN_QTY			VARCHAR2,
    	p_CREATED_BY		VARCHAR2
    /*
    
    
    */
    );

    PROCEDURE P_DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL (
         p_division_id VARCHAR2
    	,p_project_code VARCHAR2
    	,p_yyyymm VARCHAR2
    	,p_cust_fcst_m VARCHAR2
    	,p_measure VARCHAR2
    	,p_qtycd1 VARCHAR2
    	,p_qtycd2 VARCHAR2
    	,p_qtycd3 VARCHAR2
    	,p_seq VARCHAR2
    	,p_qty VARCHAR2
    	,p_mkt_fcst_m VARCHAR2
    	,p_desc VARCHAR2
    	,p_input_limit VARCHAR2
    	,p_created_by VARCHAR2
    	,p_end_customer VARCHAR2
    );

    PROCEDURE P_DMF0003_SAVE_PRPOPUP (
    	  p_POPUP_TYPE			VARCHAR2
    	, p_ITEM_SEQ			VARCHAR2
    	, p_DIVISION_ID		    VARCHAR2
    	, p_PROJECT_CODE		VARCHAR2
    	, p_SCM_SITE_ID		    VARCHAR2
    	, p_ITEM_ID			    VARCHAR2
    	, p_DOM_EXP			    VARCHAR2
    	, p_FCST_TYPE			VARCHAR2
    	, p_INCOTERMS			VARCHAR2
    	, p_PLANT_SITE_ID		VARCHAR2
    	, p_YYYYMMDD			VARCHAR2
    	, p_UOM				    VARCHAR2
    	, p_PLAN_QTY			VARCHAR2
    	, p_STORAGE_ID			VARCHAR2
    	, p_STORAGE_PLANT_ID	VARCHAR2
    	, p_PUCH_MGR			VARCHAR2
    	, p_PUCH_GROUP			VARCHAR2
    	, p_PR_HEADER			VARCHAR2
    	, p_PR_ITEM_DETAIL		VARCHAR2
    	, p_CREATED_BY			VARCHAR2
    
    );

    END PKG_DMF0003;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0003 IS

PROCEDURE P_DMF0003_GET_BUCKET_TYPE_CODE
(
  O_RC1             OUT SYS_REFCURSOR,
  O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0003_GET_BUCKET_TYPE_CODE                                                       */
/* Description : Procedure 작성 가이드                                                                */
/* Usage       : Procedure 작성 시 참조하세요!                                                         */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트      */
/* 2022/10/24  ROSIA27      [C20221024-000510]DM UI 소스 정리 요청                                    */
/* 2026.03.12  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/****************************************************************************************************/
AS
    $$PLSQL_UNIT VARCHAR2(200) := $$PLSQL_UNIT;
BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

  OPEN O_RC1 FOR
  SELECT L.SEGMENT1  AS CODE
       , L.SEGMENT2  AS NAME
  FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
  WHERE  L.LOOKUP_TYPE = 'BUCKET_TYPE_CODE'
  AND    L.VALID_YN    = 'Y'
  ORDER BY DISPLAY_SEQ
  ;

  --=============================================================================================================================
  -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
  --=============================================================================================================================
  OPEN O_RESULT_CURSOR FOR
  SELECT '0' AS CODE,  'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001,
      '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
      ' / SQLERRM=' || SQLERRM ||
      ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
    );

END P_DMF0003_GET_BUCKET_TYPE_CODE;

PROCEDURE P_DMF0003_CAR_FCST_EXCEL_UPLOAD
(
  P_MODE          IN  PLS_INTEGER,
  P_CREATED_BY    IN  VARCHAR2,
  O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0003_CAR_FCST_EXCEL_UPLOAD
 * Description  : DMF0003_CAR_FCST_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2023. 06. 29   bswon        고객수요증감분석 프로젝트
 * 2024. 01. 03   KJJ            엑셀 업로드 기능개선
 ==>SCM_ADM_EXCEL_UPLOAD시 필드 2개 추가사용 : ATTRIBUTE5, ATTRIBUTE6
 ==>해당값을 DM_ANL_CAR_FCST_REF에 저장시 ATTRIBUTE1, ATTRIBUTE2 사용
 * 2026.03.12     kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

  v_program_id        VARCHAR2(40 CHAR)  := 'DMF0003';
  v_sheet_name        VARCHAR2(40 CHAR)  := 'Car Fcst';
  v_sql_text          CLOB;
  v_creation_date     VARCHAR2(40 CHAR);
  v_count             PLS_INTEGER;
  v_start_yyyymmdd    VARCHAR2(8 CHAR);
  v_end_yyyymmdd      VARCHAR2(8 CHAR);
  v_division          VARCHAR2(10 CHAR); --[E20230227-000456]소형사업부 RPA 업로드 시 GSCM Fail 발생

  -- LOG 용 변수 설정
  $$PLSQL_UNIT      VARCHAR2(200) := $$PLSQL_UNIT;
  v_log_type          VARCHAR2(30 CHAR); -- START/END/ERROR/...
  n_log_count         PLS_INTEGER        := 0;
  v_log_message       VARCHAR2(1000 CHAR);
  v_description       VARCHAR2(500 CHAR);
  d_event_date        DATE;
  V_SQL_CODE          VARCHAR2(100 CHAR);
  V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
  V_PROC_INPUT        VARCHAR2(4000 CHAR);
  V_BACKTRACE         VARCHAR2(4000 CHAR);

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

  v_log_type    := 'START';
  v_log_message := '########## Start of procedure ##########';
  v_description := '';
  d_event_date  := SYSDATE;
  BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


  SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
  INTO   v_creation_date
  FROM   SCM_ADM_EXCEL_UPLOAD T
  WHERE  T.PROGRAM_ID = v_program_id
  AND    T.SHEET_NAME = v_sheet_name
  AND    T.CREATED_BY = P_CREATED_BY;
  --  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';

  IF v_creation_date IS NULL THEN
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'Data Not Found [' || v_creation_date || ']';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check : ' || v_description AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
    RETURN;
  END IF;

  BEGIN
    SELECT ATTRIBUTE1
    INTO   v_division
    FROM   SCM_ADM_EXCEL_UPLOAD
    WHERE  PROGRAM_ID         = v_program_id
    AND    SHEET_NAME         = v_sheet_name
    AND    CREATED_BY         = P_CREATED_BY
    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    --AND    UPPER(ATTRIBUTE1) = 'DIVISION*'
    AND    UPLOAD_STATUS_CODE = 'SUCCESS'
    AND    ROWNUM             = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;

  -- p_mode = 0 이면 Validation
  IF NVL(P_MODE, 0) = 0 THEN

    UPDATE SCM_ADM_EXCEL_UPLOAD
    SET    UPLOAD_STATUS_CODE = 'UPLOAD'
         , MESSAGE_TEXT       = NULL
    WHERE  PROGRAM_ID    = v_program_id
    AND    SHEET_NAME    = v_sheet_name
    AND    CREATED_BY    = P_CREATED_BY
    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    NVL(UPLOAD_STATUS_CODE,'X') != 'UPLOAD';

    ------------------------------------------------------------------------
    --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
    v_log_type    := '1';
    v_log_message := '########## RESET Status = UPLOAD ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    ------------------------------------------------------------------------

    UPDATE SCM_ADM_EXCEL_UPLOAD
    SET    UPLOAD_STATUS_CODE = 'SKIP'
    WHERE  PROGRAM_ID    = v_program_id
    AND    SHEET_NAME    = v_sheet_name
    AND    CREATED_BY    = P_CREATED_BY
    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    (   ATTRIBUTE1  IS NULL
            OR UPPER(ATTRIBUTE1) = 'TOTAL') ;

    ------------------------------------------------------------------------
    --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
    v_log_type    := '2';
    v_log_message := '########## SKIP EMPTY LINE ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    ------------------------------------------------------------------------

    UPDATE SCM_ADM_EXCEL_UPLOAD
    SET    UPLOAD_STATUS_CODE = '@TITLE'
    WHERE  PROGRAM_ID    = v_program_id
    AND    SHEET_NAME    = v_sheet_name
    AND    CREATED_BY    = P_CREATED_BY
    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    UPPER(ATTRIBUTE1) = 'DIVISION*';

    ------------------------------------------------------------------------
    --scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
    v_log_type    := '3';
    v_log_message := '########## TITLE Header Line ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    ------------------------------------------------------------------------

    --WBS
    UPDATE SCM_ADM_EXCEL_UPLOAD
    SET    UPLOAD_STATUS_CODE = 'ERROR'
         , MESSAGE_TEXT       = 'Duplication Key.'
    WHERE  PROGRAM_ID         = v_program_id
    AND    SHEET_NAME         = v_sheet_name
    AND    CREATED_BY         = P_CREATED_BY
    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    UPLOAD_STATUS_CODE = 'UPLOAD'
    AND EXISTS (SELECT 1
                FROM  (SELECT X.ATTRIBUTE1 AS COL1
                            , X.ATTRIBUTE2 AS COL2
                            , X.ATTRIBUTE3 AS COL3
                            , X.ATTRIBUTE4 AS COL4
                       FROM   SCM_ADM_EXCEL_UPLOAD X
                       WHERE  X.PROGRAM_ID    = v_program_id
                       AND    X.SHEET_NAME    = v_sheet_name
                       AND    X.CREATED_BY    = P_CREATED_BY
                       AND    TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                       AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                       GROUP BY X.ATTRIBUTE1
                              , X.ATTRIBUTE2
                              , X.ATTRIBUTE3
                              , X.ATTRIBUTE4
                       HAVING COUNT(*) > 1 ) T
                WHERE 1 = 1
                AND T.COL1 = ATTRIBUTE1
                AND T.COL2 = ATTRIBUTE2
                AND T.COL3 = ATTRIBUTE3
                AND T.COL4 = ATTRIBUTE4
               );

    ------------------------------------------------------------------------
    --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
    v_log_type    := '4';
    v_log_message := '########## ERROR Key Duplication ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    ------------------------------------------------------------------------

    UPDATE SCM_ADM_EXCEL_UPLOAD
    SET    UPLOAD_STATUS_CODE = 'ERROR'
         , MESSAGE_TEXT       = 'Invalid Division.'
    WHERE  PROGRAM_ID         = v_program_id
    AND    SHEET_NAME         = v_sheet_name
    AND    CREATED_BY         = P_CREATED_BY
    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    UPLOAD_STATUS_CODE = 'UPLOAD'
    AND NOT EXISTS (SELECT 1
                    FROM   SCM_MST_DIVISION D
                    WHERE  D.VALID_YN    = 'Y'
                    AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                    UNION
                    SELECT 1
                    FROM   SCM_MST_DIVISION D
                    WHERE  D.VALID_YN    = 'Y'
                    AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                   );

    BEGIN -- Division Validation은 끝났으니 코드로 정보를 치환해줌.
      UPDATE SCM_ADM_EXCEL_UPLOAD
      SET    ATTRIBUTE1 = (
                              SELECT D.DIVISION_ID
                              FROM   SCM_MST_DIVISION D
                              WHERE  D.VALID_YN    = 'Y'
                              AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                           )
      WHERE  PROGRAM_ID         = v_program_id
      AND    SHEET_NAME         = v_sheet_name
      AND    CREATED_BY         = P_CREATED_BY
      AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
      AND    UPLOAD_STATUS_CODE = 'UPLOAD'
      AND NOT EXISTS (SELECT 1
                      FROM   SCM_MST_DIVISION D
                      WHERE  D.VALID_YN    = 'Y'
                      AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                     );
    END;

    ------------------------------------------------------------------------
    --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
    v_log_type    := '5';
    v_log_message := '########## Invalid Division ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    ------------------------------------------------------------------------

    UPDATE SCM_ADM_EXCEL_UPLOAD
    SET    UPLOAD_STATUS_CODE = 'SUCCESS'
    WHERE  PROGRAM_ID         = v_program_id
    AND    SHEET_NAME         = v_sheet_name
    AND    CREATED_BY         = P_CREATED_BY
    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    UPLOAD_STATUS_CODE = 'UPLOAD';

    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
    n_log_count   := SQL%ROWCOUNT;
    v_log_type    := '16';
    v_log_message := '########## SUCCESS ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    ----------------------------------------------------------------------------

  END IF;  --  IF NVL(P_MODE, 0) = 0 THEN

  ----------------------------------------------------------------------------
  --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
  v_log_type    := '17';
  v_log_message := '########## INSERT DATA START ##########';
  v_description := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
  d_event_date  := SYSDATE;
  BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
  ----------------------------------------------------------------------------

  --// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
  --//======================================================================================
  SELECT COUNT(1)
  INTO   v_count
  FROM   SCM_ADM_EXCEL_UPLOAD T
  WHERE  T.PROGRAM_ID         = v_program_id
  AND    T.SHEET_NAME         = v_sheet_name
  AND    T.CREATED_BY         = P_CREATED_BY
  AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
  AND    T.UPLOAD_STATUS_CODE = 'ERROR' ;

  -- Update Mode and No Errors
  IF P_MODE > 0 AND v_count = 0 THEN

    v_start_yyyymmdd := '';
    v_end_yyyymmdd   := '';

    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
    v_log_type    := '18';
    v_log_message := '########## DELETE DATE START ##########';
    v_description := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    ----------------------------------------------------------------------------

    SELECT D.MIN_YYYYQQ
         , D.MAX_YYYYQQ
    INTO   v_start_yyyymmdd
         , v_end_yyyymmdd
    FROM  (
           SELECT MIN(YYYYQQ) AS MIN_YYYYQQ
                , MAX(YYYYQQ) AS MAX_YYYYQQ
           FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                       , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                       , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                       , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                       , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                       , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                       , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                       , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                       , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                       , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                       , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                       , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                       , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                       , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                       , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                       , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                       , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                       , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                       , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                       , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                       , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                       , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                       , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                       , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                       , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                       , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                       , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                       , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                       , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                       , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                       , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                       , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                       , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                       , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                       , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                       , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                       , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                       , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                       , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                       , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                  FROM   SCM_ADM_EXCEL_UPLOAD
                  WHERE  1 = 1
                  AND    PROGRAM_ID    = v_program_id
                  AND    SHEET_NAME    = v_sheet_name
                  AND    CREATED_BY    = P_CREATED_BY
                  AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                  AND    UPLOAD_STATUS_CODE = '@TITLE'
                 ) T
         UNPIVOT (    YYYYQQ
                  FOR COLUMN_NAME
                  IN   (-- ATTRIBUTE5
                       --, ATTRIBUTE6,
                       ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                       , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                       , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                       , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                       , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                       , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                       , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                       , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                       , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                       , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                       , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                       , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                       , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                       , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                       , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                       , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                       , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                       , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                       , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                       , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                       , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                       , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                       , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                       , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                       , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                       , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                       , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                       , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                       , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                       , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                       , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                       , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                       , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                       , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                       , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                       , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                       , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                       , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                       , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                       )
                 ) -- AS X 2026.03.12 kimcd [PJ20264226] NextSCM Pilot 설계 및 개발 alias 주석 처리
    WHERE YYYYQQ IS NOT NULL -- X.YYYYQQ != '' 2026.03.12 kimcd [PJ20264226] NextSCM Pilot 설계 및 개발 빈문자열 조건 수정
    ) D;

    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
    v_log_type    := '19-1';
    v_log_message := '########## DELETE DATE END ##########';
    v_description := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    ----------------------------------------------------------------------------

    SAVEPOINT CAR_FCST;
    BEGIN

      ----------------------------------------------------------------------------
      --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
      v_log_type    := '20-1';
      v_log_message := '########## DELETE DM_ANL_CAR_FCST_REF DATE END ##########';
      v_description := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
      d_event_date  := SYSDATE;
      BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
      ----------------------------------------------------------------------------

      -- delete 주석
      DELETE DM_ANL_CAR_FCST_REF
      WHERE  1 = 1
      -- modified by ytchoi 180305  incoterms, fcst_type, dom_exp 조건 없어서 추가.
      AND    (
                SELECT  COUNT(1)
                FROM    SCM_ADM_EXCEL_UPLOAD T
                WHERE   T.PROGRAM_ID         = v_program_id
                AND     T.SHEET_NAME         = v_sheet_name
                --AND    T.CREATED_BY         = P_CREATED_BY
                AND     TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                AND     T.UPLOAD_STATUS_CODE = 'SUCCESS'
                AND     DM_ANL_CAR_FCST_REF.DIVISION_ID  = T.ATTRIBUTE1
                AND     DM_ANL_CAR_FCST_REF.MAKER_NAME   = T.ATTRIBUTE2
                AND     DM_ANL_CAR_FCST_REF.CAR_MODEL    = T.ATTRIBUTE3
             ) > 0
      AND    YYYYQQ BETWEEN v_start_yyyymmdd AND v_end_yyyymmdd;

      ----------------------------------------------------------------------------
      --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
      v_log_type    := '20';
      v_log_message := '########## DELETE DM_ANL_CAR_FCST_REF DATE END ##########';
      v_description := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
      d_event_date  := SYSDATE;
      BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
      ----------------------------------------------------------------------------

      --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

      INSERT /*+ APPEND PARALLEL(4) */ INTO DM_ANL_CAR_FCST_REF
      (
          DIVISION_ID
        , END_CUSTOMER
        , MAKER_NAME
        , CAR_MODEL
        , YYYYQQ
        , P_QTY
        , S_QTY
        , I_QTY
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        , ATTRIBUTE1 --추가사용 필드 : Data Sourse
        , ATTRIBUTE2 --추가사용 필드 : Basis Date
      )
      SELECT  V.ATTRIBUTE1 AS DIVISION
            , '-' -- 2026.03.12 kimcd [PJ20264226] NextSCM Pilot 설계 및 개발 '' 빈문자열을 '-'으로 변경
            , V.ATTRIBUTE2 AS MAKER_NAME
            , V.ATTRIBUTE3 AS CAR_MODEL
            , C.YYYYQQ     AS YYYYQQ
            , SUM(CASE WHEN V.ATTRIBUTE4 = 'P' THEN TO_NUMBER(V.VALUE) ELSE 0 END) AS P_QTY
            , SUM(CASE WHEN V.ATTRIBUTE4 = 'S' THEN TO_NUMBER(V.VALUE) ELSE 0 END) AS S_QTY
            , SUM(CASE WHEN V.ATTRIBUTE4 = 'I' THEN TO_NUMBER(V.VALUE) ELSE 0 END) AS I_QTY
            , P_CREATED_BY
            , SYSDATE
            , P_CREATED_BY
            , SYSDATE
            , MAX(V.ATTRIBUTE5) ATTRIBUTE5 --추가사용 필드 : 엑셀에서 업로드 한 Data Sourse
            , MAX(V.ATTRIBUTE6) ATTRIBUTE6 --추가사용 필드 : 엑셀에서 업로드 한 Basis Date
      FROM  (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, COLUMN_NAME, YYYYQQ, ATTRIBUTE5, ATTRIBUTE6
             FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                           , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                           , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                           , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                           , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                           , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                           , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                           , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                           , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                           , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                           , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                           , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                           , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                           , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                           , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                           , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                           , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                           , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                           , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                           , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                           , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                           , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                           , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                           , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                           , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                           , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                           , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                           , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                           , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                           , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                           , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                           , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                           , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                           , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                           , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                           , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                           , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                           , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                           , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                           , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                    FROM   SCM_ADM_EXCEL_UPLOAD
                    WHERE  1 = 1
                    AND    PROGRAM_ID    = v_program_id
                    AND    SHEET_NAME    = v_sheet_name
                    AND    CREATED_BY    = P_CREATED_BY
                    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                    AND    UPLOAD_STATUS_CODE = '@TITLE'
                   ) T
             UNPIVOT (    YYYYQQ
                      FOR COLUMN_NAME
                      IN   ( --ATTRIBUTE5
                            --, ATTRIBUTE6,
                            ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                            , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                            , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                            , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                            , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                            , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                            , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                            , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                            , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                            , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                            , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                            , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                            , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                            , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                            , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                            , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                            , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                            , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                            , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                            , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                            , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                            , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                            , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                            , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                            , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                            , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                            , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                            , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                            , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                            , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                            , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                            , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                            , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                            , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                            , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                            , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                            , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                            , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                            , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                            )
                     ) -- AS X 2026.03.12 kimcd [PJ20264226] NextSCM Pilot 설계 및 개발 alias 주석 처리
             ) C
           , (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, COLUMN_NAME, VALUE, ATTRIBUTE5, ATTRIBUTE6
              FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                            , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                            , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                            , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                            , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                            , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                            , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                            , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                            , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                            , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                            , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                            , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                            , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                            , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                            , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                            , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                            , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                            , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                            , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                            , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                            , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                            , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                            , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                            , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                            , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                            , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                            , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                            , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                            , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                            , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                            , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                            , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                            , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                            , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                            , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                            , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                            , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                            , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                            , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                            , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                     FROM   SCM_ADM_EXCEL_UPLOAD
                     WHERE  1 = 1
                     AND    PROGRAM_ID    = v_program_id
                     AND    SHEET_NAME    = v_sheet_name
                     AND    CREATED_BY    = P_CREATED_BY
                     AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                     AND    UPLOAD_STATUS_CODE = 'SUCCESS'
                    ) T
              UNPIVOT (    VALUE
                       FOR COLUMN_NAME
                       IN   ( --ATTRIBUTE5
                             --, ATTRIBUTE6,
                             ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                             , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                             , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                             , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                             , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                             , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                             , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                             , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                             , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                             , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                             , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                             , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                             , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                             , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                             , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                             , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                             , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                             , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                             , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                             , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                             , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                             , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                             , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                             , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                             , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                             , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                             , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                             , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                             , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                             , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                             , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                             , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                             , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                             , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                             , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                             , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                             , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                             , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                             , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                             )
                      ) -- AS X 2026.03.12 kimcd [PJ20264226] NextSCM Pilot 설계 및 개발 alias 주석 처리
              ) V
              /*,(
                  SELECT TOP 1 ATTRIBUTE5, ATTRIBUTE6
                           FROM   SCM_ADM_EXCEL_UPLOAD
                           WHERE  1 = 1
                           AND    PROGRAM_ID    = v_program_id
                           AND    SHEET_NAME    = v_sheet_name
                           AND    CREATED_BY    = P_CREATED_BY
                           AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                           AND    UPLOAD_STATUS_CODE = 'SUCCESS'
              ) Y*/
      WHERE 1 = 1
      AND   C.COLUMN_NAME = V.COLUMN_NAME
      AND   C.YYYYQQ IS NOT NULL -- C.YYYYQQ != '' 2026.03.12 kimcd [PJ20264226] NextSCM Pilot 설계 및 개발 빈문자열 조건 수정
      AND   V.VALUE IS NOT NULL  -- V.VALUE  != '' 2026.03.12 kimcd [PJ20264226] NextSCM Pilot 설계 및 개발 빈문자열 조건 수정
      GROUP BY V.ATTRIBUTE1, V.ATTRIBUTE2, V.ATTRIBUTE3, C.YYYYQQ --    , V.ATTRIBUTE5, V.ATTRIBUTE6
      ORDER BY YYYYQQ;

      --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
      n_log_count   := SQL%ROWCOUNT;
      ----------------------------------------------------------------------------
      --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
      v_log_type    := '21';
      v_log_message := '########## INSERT DM_ANL_CAR_FCST_REF DATE END ##########';
      v_description := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
      d_event_date  := SYSDATE;
      BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
      ----------------------------------------------------------------------------

      COMMIT;

    EXCEPTION
      WHEN OTHERS THEN
        --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        ROLLBACK TO SAVEPOINT CAR_FCST;
        RAISE;
    END;

  END IF; -- IF P_MODE > 0 AND v_count = 0 THEN

  ----------------------------------------------------------------------------
  --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
  v_log_type    := 'END';
  v_log_message := '########## INSERT DATA END ##########';
  v_description := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
  d_event_date  := SYSDATE;
  BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
  ----------------------------------------------------------------------------
  --=============================================================================================================================
  -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
  --=============================================================================================================================
  OPEN O_RESULT_CURSOR FOR
  SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_log_count) AS EVENT FROM DUAL;

EXCEPTION
  WHEN OTHERS THEN
  v_log_type    := 'ERROR';
  v_log_message := '########## ERROR of procedure ##########';
  v_description := '';
  d_event_date  := SYSDATE;
  V_SQL_CODE    := TO_CHAR(SQLCODE);
  V_SQL_ERRMSG  := SQLERRM;
  ROLLBACK;
  V_PROC_INPUT := JSON_OBJECT('P_MODE' VALUE P_MODE, 'P_CREATED_BY' VALUE P_CREATED_BY);
  V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

    RAISE_APPLICATION_ERROR(-20001,
      '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
      ' / SQLERRM=' || V_SQL_ERRMSG ||
      ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
      ' / PARAMS=' || JSON_OBJECT('P_MODE' VALUE P_MODE, 'P_CREATED_BY' VALUE P_CREATED_BY)
    );

END P_DMF0003_CAR_FCST_EXCEL_UPLOAD;

/*
 * Program ID   : P_DMF0003_GET_DM_ANL_CAR_PROPERTY
 * Description  :
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.13     kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
 PROCEDURE P_DMF0003_GET_DM_ANL_CAR_PROPERTY
(
    P_DIVISION_ID   IN VARCHAR2,
    P_MAKER_NAME    IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RC2           OUT SYS_REFCURSOR,
    O_RC3           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR

)
AS

    $$PLSQL_UNIT VARCHAR2(200) := $$PLSQL_UNIT;
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    IF P_MAKER_NAME = '' OR P_MAKER_NAME IS NULL THEN

        OPEN O_RC1 FOR
            SELECT DISTINCT MAKER_NAME AS CODE, MAKER_NAME AS NAME
            FROM DM_ANL_CAR_FCST_REF
            ORDER BY MAKER_NAME;

        OPEN O_RC2 FOR
            SELECT DISTINCT CAR_MODEL AS CODE, CAR_MODEL AS NAME
            FROM DM_ANL_CAR_FCST_REF
            ORDER BY CAR_MODEL;

        OPEN O_RC3 FOR
            SELECT 'CELL'   AS CODE, 'CELL'   AS NAME FROM DUAL
            UNION ALL
            SELECT 'MODULE' AS CODE, 'MODULE' AS NAME FROM DUAL
            UNION ALL
            SELECT 'PACK'   AS CODE, 'PACK'   AS NAME FROM DUAL;

    ELSIF P_MAKER_NAME IS NOT NULL AND P_MAKER_NAME <> ' ' THEN

        OPEN O_RC1 FOR
            SELECT DISTINCT CAR_MODEL AS CODE, CAR_MODEL AS NAME
            FROM DM_ANL_CAR_FCST_REF
            WHERE MAKER_NAME = P_MAKER_NAME
            ORDER BY CAR_MODEL;

        OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
        OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;

    END IF;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_PROC_INPUT :=
            JSON_OBJECT(
                'p_division_id' VALUE P_DIVISION_ID,
                'p_maker_name'  VALUE P_MAKER_NAME
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_DM_ANL_CAR_PROPERTY;


/* ============================================================
   2. DMF0003_GET_DM_ANL_CAR_REF
   ============================================================ */
-- ============================================================
-- GTT DDL (별도 실행)
-- ============================================================
-- CREATE GLOBAL TEMPORARY TABLE GT_CREF_TEMP_DATA
-- (
--     MAKER_NAME   VARCHAR2(30 CHAR) NOT NULL,
--     CAR_MODEL    VARCHAR2(30 CHAR) NOT NULL,
--     YYYYQQ       VARCHAR2(30 CHAR) NOT NULL,
--     P_QTY        NUMBER(10),
--     S_QTY        NUMBER(10),
--     I_QTY        NUMBER(10)
-- )
-- ON COMMIT DELETE ROWS;
-- /
-- ============================================================

PROCEDURE P_DMF0003_GET_DM_ANL_CAR_REF
(
    P_FROM_YYYYMMDD IN VARCHAR2,
    P_TO_YYYYMMDD   IN VARCHAR2,
    P_CAR_MAKER     IN VARCHAR2,
    P_CAR_MODEL     IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RC2           OUT SYS_REFCURSOR,
    O_RC3           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : DMF0003_GET_DM_ANL_CAR_REF
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.01.03     KJJ         엑셀 업로드시에 저장된 부가정보 조회 추가
 * 2026.03.13     kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발


EXEC DMF0003_GET_DM_ANL_CAR_REF '20230701', '20240630', 'FORD', 'Ford Mustang Mach-E BEV'
 */
    V_FROM_YYYYQQ   VARCHAR2(6 CHAR);
    V_TO_YYYYQQ     VARCHAR2(6 CHAR);
    V_COLUMNS       VARCHAR2(32767 CHAR);
    V_SQL           VARCHAR2(32767 CHAR);

    $$PLSQL_UNIT  VARCHAR2(200) := $$PLSQL_UNIT;
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    -- EXEC DMF0003_GET_DM_ANL_CAR_REF '20210301', '20230701', 'BMW', ''

    SELECT CALENDAR_YYYYQQ INTO V_FROM_YYYYQQ FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
    SELECT CALENDAR_YYYYQQ INTO V_TO_YYYYQQ   FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = P_TO_YYYYMMDD;

    -- GTT TRUNCATE
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_CREF_TEMP_DATA';

    --EXECUTE IMMEDIATE 'ALTER SESSION SET GLOBAL_TEMP_TABLE_STATS = SESSION';

    -- 조건별 GTT INSERT
    IF P_CAR_MAKER IS NOT NULL AND P_CAR_MAKER <> ' ' AND P_CAR_MODEL IS NOT NULL AND P_CAR_MODEL <> ' ' THEN

        --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

        INSERT /*+ APPEND PARALLEL(4) */ INTO GT_CREF_TEMP_DATA
        (MAKER_NAME, CAR_MODEL, YYYYQQ, P_QTY, S_QTY, I_QTY)
        SELECT /*+ FULL(A) PARALLEL(A,4) */
               MAKER_NAME, CAR_MODEL, YYYYQQ, P_QTY, S_QTY, I_QTY
        FROM   DM_ANL_CAR_FCST_REF A
        WHERE  YYYYQQ    BETWEEN V_FROM_YYYYQQ AND V_TO_YYYYQQ
        AND    MAKER_NAME = P_CAR_MAKER
        AND    CAR_MODEL  = P_CAR_MODEL;

        --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

    ELSIF P_CAR_MAKER IS NOT NULL AND P_CAR_MAKER <> ' ' AND (P_CAR_MODEL IS NULL OR P_CAR_MODEL = '') THEN

        --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

        INSERT /*+ APPEND PARALLEL(4) */ INTO GT_CREF_TEMP_DATA
        (MAKER_NAME, CAR_MODEL, YYYYQQ, P_QTY, S_QTY, I_QTY)
        SELECT /*+ FULL(A) PARALLEL(A,4) */
               MAKER_NAME, CAR_MODEL, YYYYQQ, P_QTY, S_QTY, I_QTY
        FROM   DM_ANL_CAR_FCST_REF A
        WHERE  YYYYQQ    BETWEEN V_FROM_YYYYQQ AND V_TO_YYYYQQ
        AND    MAKER_NAME = P_CAR_MAKER;

        --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

    END IF;

    COMMIT;

    -- GTT 통계 수집
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_CREF_TEMP_DATA',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1',
        NO_INVALIDATE    => FALSE
    );

    OPEN O_RC1 FOR
    SELECT DISTINCT YYYYQQ FROM DM_ANL_CAR_FCST_REF WHERE YYYYQQ BETWEEN V_FROM_YYYYQQ AND V_TO_YYYYQQ ORDER BY YYYYQQ ASC;

    -- YYYYQQ 컬럼 목록 구성 (동적 PIVOT용)
    V_COLUMNS := ' ';
    FOR R IN (
        SELECT DISTINCT YYYYQQ
        FROM   DM_ANL_CAR_FCST_REF
        WHERE  YYYYQQ BETWEEN V_FROM_YYYYQQ AND V_TO_YYYYQQ
        ORDER BY YYYYQQ
    ) LOOP
        V_COLUMNS := V_COLUMNS || '''' || R.YYYYQQ || ''',';
    END LOOP;
    V_COLUMNS := SUBSTR(V_COLUMNS, 1, LENGTH(V_COLUMNS) - 1);

    -- rc1: 동적 PIVOT 결과 (Oracle PIVOT 구문 사용)
    V_SQL :=
    'SELECT * FROM ( ' ||
    '  SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, P_QTY, ' ||
    '         ''차량대수별''            AS MAJOR_CAT, ' ||
    '         ''P) 차량생산[R+P]''      AS MINOR_CAT ' ||
    '  FROM GT_CREF_TEMP_DATA ' ||
    '  UNION ALL ' ||
    '  SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, S_QTY, ' ||
    '         ''차량대수별''            AS MAJOR_CAT, ' ||
    '         ''S) 차량판매[R+P]''      AS MINOR_CAT ' ||
    '  FROM GT_CREF_TEMP_DATA ' ||
    '  UNION ALL ' ||
    '  SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, I_QTY, ' ||
    '         ''차량대수별''            AS MAJOR_CAT, ' ||
    '         ''I) 누적차량재고[R+P]''  AS MINOR_CAT ' ||
    '  FROM GT_CREF_TEMP_DATA ' ||
    '  UNION ALL ' ||
    '  SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, 0 AS P_QTY, ' ||
    '         ''BIZ단위환산''           AS MAJOR_CAT, ' ||
    '         ''P) 차량생산[R+P]''      AS MINOR_CAT ' ||
    '  FROM GT_CREF_TEMP_DATA ' ||
    '  UNION ALL ' ||
    '  SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, 0 AS S_QTY, ' ||
    '         ''BIZ단위환산''           AS MAJOR_CAT, ' ||
    '         ''S) 차량판매[R+P]''      AS MINOR_CAT ' ||
    '  FROM GT_CREF_TEMP_DATA ' ||
    '  UNION ALL ' ||
    '  SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, 0 AS I_QTY, ' ||
    '         ''BIZ단위환산''           AS MAJOR_CAT, ' ||
    '         ''I) 누적차량재고[R+P]''  AS MINOR_CAT ' ||
    '  FROM GT_CREF_TEMP_DATA ' ||
    ') SRC ' ||
    'PIVOT ( SUM(P_QTY) FOR YYYYQQ IN (' || V_COLUMNS || ') ) ' ||
    'ORDER BY MAKER_NAME, CAR_MODEL';

    OPEN O_RC2 FOR V_SQL;

    -- rc2: 엑셀 추가정보 조회
    --엑셀 추가정보 조회
    OPEN O_RC3 FOR
        SELECT
            MAX(ATTRIBUTE1) AS ATTRIBUTE1  --Data Source
          , MAX(ATTRIBUTE2) AS ATTRIBUTE2  --Basis Date
        FROM DM_ANL_CAR_FCST_REF
        WHERE CREATION_DATE = (
            SELECT MAX(CREATION_DATE)
            FROM   DM_ANL_CAR_FCST_REF
            WHERE  YYYYQQ     BETWEEN V_FROM_YYYYQQ AND V_TO_YYYYQQ
            AND    MAKER_NAME = P_CAR_MAKER
            AND    CAR_MODEL  = P_CAR_MODEL
        )
        AND YYYYQQ     BETWEEN V_FROM_YYYYQQ AND V_TO_YYYYQQ
        AND MAKER_NAME = P_CAR_MAKER
        AND CAR_MODEL  = P_CAR_MODEL;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT :=
            JSON_OBJECT(
                'p_from_yyyymmdd' VALUE P_FROM_YYYYMMDD,
                'p_to_yyyymmdd'   VALUE P_TO_YYYYMMDD,
                'p_car_maker'     VALUE P_CAR_MAKER,
                'p_car_model'     VALUE P_CAR_MODEL
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_DM_ANL_CAR_REF;

 PROCEDURE P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT
(
    P_DIVISION_ID   IN VARCHAR2,
    P_PROJECT_CODE  IN VARCHAR2,
    P_YYYYMM        IN VARCHAR2,
    P_CREATED_BY    IN VARCHAR2,
    P_END_CUSTOMER  IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR

)
AS
/*
 * Program ID  : [DMF0003_GET_DM_ANL_MKT_PSI_DPINIT]
 * Description  : 고객수요증감분석 PSI 팝업 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.10.14      chutoc730        []  고객수요증감분석 PSI 입력창의 관리 단위 변경(END CUSTOMER까지)
 * 공급차질 수량을 구분하기 위한 Category 신규 추가
 * 분석 입력 기간 설정 잠시 Close
 * 2023.11.08 kcw3408     [개발요청] 수요분석시스템_12_End Customer 단위 세분화 필요 (Sales site는 미포함)
 * 2024.01.10    kcw3408        [개발요청] 고객수요증감분석_배치작업 신규(표준리포트/RPA팀 우혜라 요청)으로 데이타 존재여부 확인
 * 2026.03.13     kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발

-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPINIT '81', 'A15BW7001','202308', '','BMW'
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPINIT '81', 'A15BW7001','202308', '','BMW'
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPINIT @p_division_id='81',@p_project_code='A15BW7001',@p_yyyymm='202308',@p_created_by='',@p_end_customer='BMW'

 */
    $$PLSQL_UNIT  VARCHAR2(200) := $$PLSQL_UNIT;
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    --    -- CREATE TABLE #TEMP_DATA(
    --   PROJECT_CODE              NVARCHAR(30) NOT NULL,
    --   YYYYMM          NVARCHAR(6)  NOT NULL,
    --   MKT_FCST          NVARCHAR(30) NOT NULL,
    --   IN_DE_VOL         NVARCHAR(30) NULL,
    --   IMPUTATION_YN         NVARCHAR(30) NULL,
    --   DEMAND_OPERATION         NVARCHAR(30) NULL,
    --   VARIATION_FACTOR        NVARCHAR(30) NULL,
    --   [DESC]          NVARCHAR(MAX) NULL,
    --   IN_DE_DEMAND         NVARCHAR(30) NULL,
    --   IN_DDAY      NVARCHAR(30) NULL,
    --   DE_PL            NVARCHAR(30) NULL,
    --   )

    --DECLARE @CNT INT = 0, @i INT =  1
    --DECLARE @v_yyyymm NVARCHAR(20)
    --SET @i = -12

    --WHILE @i <= 0
        --BEGIN
        --  SELECT @CNT = COUNT(*) FROM DM_ANL_MKT_PSI_DETAIL WHERE 1=1
        --     AND DIVISION_ID = @p_division_id
        --     AND PROJECT_CODE = @p_project_code
        --     AND MEASURE = 'DP_INIT'

        --     AND YYYYMM = CONVERT(CHAR(6), ADD_MONTHS(@p_yyyymm + '01', @i), 112)
        --END

        --IF (@CNT = 0)
        --BEGIN
        --  BEGIN
        --      INSERT INTO #TEMP_DATA
        --      SELECT @p_project_code, CONVERT(CHAR(6), ADD_MONTHS(@p_yyyymm + '01', @i), 112), 0, 0, '고객', '수요', '차량생산', '', 0, '', 0
        --  END
        --  BEGIN
        --      INSERT INTO #TEMP_DATA
        --      SELECT @p_project_code, CONVERT(CHAR(6), ADD_MONTHS(@p_yyyymm + '01', @i), 112), 0, 0, '고객', '수요', '차량판매', '', 0, '', 0
        --  END
        --  BEGIN
        --      INSERT INTO #TEMP_DATA
        --      SELECT @p_project_code, CONVERT(CHAR(6), ADD_MONTHS(@p_yyyymm + '01', @i), 112), 0, 0, '고객', '수요', '물류이슈', '', 0, '', 0
        --  END
        --  BEGIN
        --      INSERT INTO #TEMP_DATA
        --      SELECT @p_project_code, CONVERT(CHAR(6), ADD_MONTHS(@p_yyyymm + '01', @i), 112), 0, 0, '당사', '운영', '시점조정', '', 0, '', 0
        --  END
        --  BEGIN
        --      INSERT INTO #TEMP_DATA
        --      SELECT @p_project_code, CONVERT(CHAR(6), ADD_MONTHS(@p_yyyymm + '01', @i), 112), 0, 0, '당사', '운영', '모델믹스', '', 0, '', 0
        --  END
        --END
        --ELSE

        -- 수요계획 1st 조회 쿼리
        --INSERT INTO #TEMP_DATA
        -- wbs 주석
        /*
        SELECT PROJECT_CODE
             , YYYYMM
             , CONVERT(NUMERIC(30, 2), CUST_FCST_M) AS MKT_FCST
             , CONVERT(NUMERIC(30, 2), QTY) AS IN_DE_VOL
             , CASE QTYCD1 WHEN 'CUSTOMER' THEN '고객'--'100'-- '고객'
                           WHEN 'COMPANY' THEN '당사'--'200' --'당사'
                           END AS IMPUTATION_YN
             , CASE QTYCD2 WHEN 'DEMAND' THEN '수요'--'110'--'수요'
                           WHEN 'OPERATION' THEN '운영'--'210'--'운영'
                           WHEN 'SUPPLY' THEN '공급'--'220'--'공급'
                           END AS DEMAND_OPERATION
             , CASE QTYCD3 WHEN 'PRODUCT' THEN '차량생산'--'111'--'차량생산'
                           WHEN 'SALES' THEN '차량판매'--'112'--'차량판매'
                           WHEN 'INVENTORY' THEN '물류이슈'--'113'--'물류이슈'
                           WHEN 'VPA' THEN '시점조정'--'211'--'시점조정'
                           WHEN 'MODELMIX' THEN '모델믹스' --'212'--'모델믹스'
                           WHEN 'SUPPLYISSUE' THEN '공급차질' --'221'--'공급차질'

                           END AS VARIATION_FACTOR
             , [DESC] AS [DESC]--[DESC] AS [DESC]
             , '' AS IN_DE_DEMAND
             , INPUT_LIMIT AS IN_DDAY
             , CONVERT(NUMERIC(30, 2), MKT_FCST_M) AS DE_PL
          FROM DM_ANL_MKT_PSI_DETAIL WITH(NOLOCK)
         WHERE 1=1
           AND DIVISION_ID = @p_division_id
           AND PROJECT_CODE = @p_project_code
           AND MEASURE = 'DP_INIT'
           --AND YYYYMM BETWEEN CONVERT(CHAR(6), ADD_MONTHS(GETDATE(), -11), 112) AND CONVERT(CHAR(6), GETDATE(), 112);
           AND YYYYMM = @p_yyyymm--CONVERT(CHAR(6), ADD_MONTHS(@p_yyyymm + '01', @i), 112)
        END
           */
        --SET @i = @I + 1

    OPEN O_RC1 FOR
        SELECT PROJECT_CODE
             , END_CUSTOMER
             , YYYYMM
             , NVL(CEIL(CUST_FCST_M), 0)  AS EDI_QTY
             , NVL(CEIL(QTY), 0)           AS IN_DE_VOL
             , CASE QTYCD1
                   WHEN 'CUSTOMER' THEN '고객'--'100'-- '고객'
                   WHEN 'COMPANY'  THEN '당사'--'200' --'당사'
               END AS IMPUTATION_YN
             , CASE QTYCD2
                   WHEN 'DEMAND'    THEN '수요'--'110'--'수요'
                   WHEN 'OPERATION' THEN '운영'--'210'--'운영'
                   WHEN 'SUPPLY'    THEN '공급'--'220'--'공급'
               END AS DEMAND_OPERATION
             , CASE QTYCD3
                   WHEN 'PRODUCT'     THEN '차량생산'--'111'--'차량생산'
                   WHEN 'SALES'       THEN '차량판매'--'112'--'차량판매'
                   WHEN 'INVENTORY'   THEN '물류이슈'--'113'--'물류이슈'
                   WHEN 'VPA'         THEN '시점조정'--'211'--'시점조정'
                   WHEN 'MODELMIX'    THEN '모델믹스' --'212'--'모델믹스'
                   WHEN 'SUPPLYISSUE' THEN '공급차질' --'221'--'공급차질'
               END AS VARIATION_FACTOR
             , A."DESC"                       AS "DESC" --[DESC] AS [DESC]
             --, NVL(CEIL(CUST_FCST_M + QTY), 0) AS RESULT
             --, INPUT_LIMIT AS IN_DDAY
             , NVL(CEIL(MKT_FCST_M), 0)    AS MKT_FCST
        FROM  DM_ANL_MKT_PSI_DETAIL A
        WHERE 1 = 1
          AND DIVISION_ID   = P_DIVISION_ID
          AND END_CUSTOMER  = P_END_CUSTOMER
          AND PROJECT_CODE  = P_PROJECT_CODE
          AND MEASURE       = 'DP_INIT'
          AND QTYCD3       <> ' '
          AND QTYCD3       <> '-'
          --AND YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, -11), 'YYYYMM') AND TO_CHAR(SYSDATE, 'YYYYMM');
          AND YYYYMM        = P_YYYYMM --TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm||'01','YYYYMMDD'), @i), 'YYYYMM')
        ORDER BY SEQ;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT :=
            JSON_OBJECT(
                'p_division_id'  VALUE P_DIVISION_ID,
                'p_project_code' VALUE P_PROJECT_CODE,
                'p_yyyymm'       VALUE P_YYYYMM,
                'p_created_by'   VALUE P_CREATED_BY,
                'p_end_customer' VALUE P_END_CUSTOMER
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT;

/* ============================================================
   4. DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT
   ============================================================ */
PROCEDURE P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT
(
    P_DIVISION_ID   IN VARCHAR2,
    P_PROJECT_CODE  IN VARCHAR2,
    P_YYYYMM        IN VARCHAR2,
    P_CREATED_BY    IN VARCHAR2,
    P_END_CUSTOMER  IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/*
 * Program ID  : [DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT]
 * Author:      <Author,,Name>
 * Create date: <Create Date,,>
 * Description  : 고객수요증감 입력(DMF0003_GET_DM_ANL_MKT_PSI_DATA:고객수요증감분석 PSI 조회 sub)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.11.02 kcw3408     [개발요청] 수요분석시스템_36번  Final 값은 실적 값으로 변경
 * 2023.11.08 kcw3408     [개발요청] 수요분석시스템_12_End Customer 단위 세분화 필요 (Sales site는 미포함)
 * 2024.01.10    kcw3408        [개발요청] 고객수요증감분석_배치작업 신규(표준리포트/RPA팀 우혜라 요청)으로 데이타 존재여부 확인
 * 2026.03.13     kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT @p_division_id='81',@p_project_code='A15BW7003',@p_yyyymm='202308',@p_created_by='',@p_end_customer='BMW'
 */

    --EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT'81','A15AI7001','202307','leetw85'

    $$PLSQL_UNIT  VARCHAR2(200) := $$PLSQL_UNIT;
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    /*
       2023.11.02    kcw3408          ⓓ MKT.FCST (DP) 을 월 MKT FCST[R+P] Measure실적과 동일하게 관리
    */

    -- UPDATE JOIN → 상관 서브쿼리 방식으로 변환 (ORA-01779 방지)
    UPDATE DM_ANL_MKT_PSI_DETAIL T1
    SET    MKT_FCST_M = (
               SELECT NVL(CEIL(X.MKT_FCST_M), 0)
               FROM   DM_ANL_MKT_PSI X
               WHERE  X.DIVISION_ID  = T1.DIVISION_ID
               AND    X.END_CUSTOMER = T1.END_CUSTOMER
               AND    X.PROJECT_CODE = T1.PROJECT_CODE
               AND    X.YYYYMM       = T1.YYYYMM
               AND    X.MEASURE      = 'DP_RESULT'
               AND    X.DIVISION_ID  = P_DIVISION_ID
               AND    X.END_CUSTOMER = P_END_CUSTOMER
               AND    X.PROJECT_CODE = P_PROJECT_CODE
               AND    X.YYYYMM       = P_YYYYMM
           )
    WHERE  T1.MEASURE      = 'DP_RESULT'
    AND    T1.DIVISION_ID  = P_DIVISION_ID
    AND    T1.END_CUSTOMER = P_END_CUSTOMER
    AND    T1.PROJECT_CODE = P_PROJECT_CODE
    AND    T1.YYYYMM       = P_YYYYMM
    AND EXISTS (
               SELECT 1
               FROM   DM_ANL_MKT_PSI X
               WHERE  X.DIVISION_ID  = T1.DIVISION_ID
               AND    X.END_CUSTOMER = T1.END_CUSTOMER
               AND    X.PROJECT_CODE = T1.PROJECT_CODE
               AND    X.YYYYMM       = T1.YYYYMM
               AND    X.MEASURE      = 'DP_RESULT'
               AND    X.DIVISION_ID  = P_DIVISION_ID
               AND    X.END_CUSTOMER = P_END_CUSTOMER
               AND    X.PROJECT_CODE = P_PROJECT_CODE
               AND    X.YYYYMM       = P_YYYYMM
           );

    COMMIT;

    -- 수요계획 Result 조회 쿼리
    OPEN O_RC1 FOR
        SELECT PROJECT_CODE
             , END_CUSTOMER
             , YYYYMM
             , NVL(CEIL(CUST_FCST_M), 0) AS EDI_QTY
             , NVL(CEIL(QTY), 0)          AS IN_DE_VOL
             , CASE QTYCD1
                   WHEN 'CUSTOMER' THEN '고객'
                   WHEN 'COMPANY'  THEN '당사'
               END AS IMPUTATION_YN
             , CASE QTYCD2
                   WHEN 'DEMAND'    THEN '수요'
                   WHEN 'OPERATION' THEN '운영'
                   WHEN 'SUPPLY'    THEN '공급'
               END AS DEMAND_OPERATION
             , CASE QTYCD3
                   WHEN 'PRODUCT'     THEN '차량생산'
                   WHEN 'SALES'       THEN '차량판매'
                   WHEN 'INVENTORY'   THEN '물류이슈'
                   WHEN 'VPA'         THEN '시점조정'
                   WHEN 'MODELMIX'    THEN '모델믹스'
                   WHEN 'SUPPLYISSUE' THEN '공급차질'
               END AS VARIATION_FACTOR
             , A."DESC"                      AS "DESC"
             --, NVL(CEIL(CUST_FCST_M + QTY), 0) AS IN_DE_DEMAND
             --, INPUT_LIMIT AS IN_DDAY
             , NVL(CEIL(MKT_FCST_M), 0)   AS MKT_FCST
        FROM   DM_ANL_MKT_PSI_DETAIL A
        WHERE  1 = 1
          AND  DIVISION_ID   = P_DIVISION_ID
          AND  END_CUSTOMER  = P_END_CUSTOMER
          AND  PROJECT_CODE  = P_PROJECT_CODE
          AND  MEASURE       = 'DP_RESULT'
          AND QTYCD3       <> ' '
          AND QTYCD3       <> '-'
          --AND YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, -11), 'YYYYMM') AND TO_CHAR(SYSDATE, 'YYYYMM');
          AND  YYYYMM        = P_YYYYMM
        ORDER BY SEQ;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT :=
            JSON_OBJECT(
                'p_division_id'  VALUE P_DIVISION_ID,
                'p_project_code' VALUE P_PROJECT_CODE,
                'p_yyyymm'       VALUE P_YYYYMM,
                'p_created_by'   VALUE P_CREATED_BY,
                'p_end_customer' VALUE P_END_CUSTOMER
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT;

PROCEDURE P_DMF0003_GET_SPREAD_TITLE
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : P_DM0003_GET_SPREAD_TITLE                                                          */
/* Description :                                                                                    */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/11/20  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트      */
/* 2021/09/03  rosia27      [C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건         */
/* 2026.03.15  kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발                                    */
/*                                                                                                  */
/****************************************************************************************************/
    V_USER_COL_CNT   PLS_INTEGER := 0;
    V_PROGRAM_ID     VARCHAR2(4000 CHAR);
    V_SHEET_NAME     VARCHAR2(4000 CHAR);

    $$PLSQL_UNIT   VARCHAR2(200) := $$PLSQL_UNIT;
    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    V_PROGRAM_ID     := 'DMF0003';
    V_SHEET_NAME     := 'Mkt Fcst';
    V_USER_COL_CNT   := 0;

    SELECT COUNT(*)
    INTO   V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = V_PROGRAM_ID
    AND    U.SHEET_NAME = V_SHEET_NAME
    AND    U.USER_ID    = P_CREATED_BY;

    IF V_USER_COL_CNT > 0 THEN

        OPEN O_RC1 FOR
            SELECT U.PROGRAM_ID
                 , U.SHEET_NAME
                 , U.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , U.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , ''                     AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
            FROM   SCM_MST_TITLESET_USER  U
                 , SCM_MST_SHEET_COLUMNS   C
            WHERE  1 = 1
            AND    U.PROGRAM_ID  = C.PROGRAM_ID
            AND    U.SHEET_NAME  = C.SHEET_NAME
            AND    U.COLUMN_NAME = C.COLUMN_NAME
            AND    U.PROGRAM_ID  = V_PROGRAM_ID
            AND    U.SHEET_NAME  = V_SHEET_NAME
            AND    U.USER_ID     = P_CREATED_BY
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
            UNION ALL
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , ''                     AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
            FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    C.PROGRAM_ID   = V_PROGRAM_ID
            AND    C.SHEET_NAME   = V_SHEET_NAME
            AND    C.VISIBLE_FLAG = ''
            AND    ( C.DEFAULT_FLAG IS NULL OR C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' ' ) -- 기존 '' 비교 문장
            AND    C.VALID_YN     = 'Y'
            AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
            UNION ALL
            SELECT V_PROGRAM_ID   AS PROGRAM_ID
                 , V_SHEET_NAME   AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , ''             AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''             AS FIXED_FLAG
                 , 50             AS COLUMN_WIDTH
                 , T.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''             AS CELL_COMBO_DATA_TYPE
                 , TO_NUMBER('')  AS DATA_SCALE_NUMBER
                 , TO_NUMBER('')  AS DATA_MAX_LENGTH
                 , 'R'            AS HORIZONTAL_ALIGN_CODE
                 , 'Y'            AS UPPERCASE_APPLY_FLAG
                 , 'Y'            AS VISIBLE_FLAG
                 , ''             AS DEFAULT_FLAG
                 , ''             AS USER_SELECTABLE_FLAG
                 , ''             AS VALID_YN
                 , ''             AS DIVISION_ID
            FROM (
                    SELECT 'D_' || A.BASIS_YYYYMMDD   AS COLUMN_NAME
                         , A.CALENDAR_DAY             AS COLUMN_LABEL_NAME
                         , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME || '+'
                                WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' || A.WEEK_NAME
                                ELSE A.WEEK_NAME END  AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME               AS LARGE_CLASS_LABEL_NAME
                         , A.DAYOFWEEK                AS DAY_CODE
                         , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                         , 'FPNumber'                 AS CELL_CONTROL_OBJECT_TYPE_CODE
                    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
                    --UNION ALL
                    --SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
                    --  , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                    --  , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
                    --      WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
                    --      ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
                    --  , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                    --  , ''                        AS DAY_CODE
                    --  , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 32) AS SORT_ORDER_NO
                    --  , 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
                    --FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                    --WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    UNION ALL
                    SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK  AS COLUMN_NAME
                         , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME || '+'
                                WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' || A.WEEK_NAME
                                ELSE A.WEEK_NAME END             AS COLUMN_LABEL_NAME  -- 20190610
                         , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME || '+'
                                WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' || A.WEEK_NAME
                                ELSE A.WEEK_NAME END             AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME                          AS LARGE_CLASS_LABEL_NAME
                         , ''                                    AS DAY_CODE
                         , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                         , 'FPNumber'                            AS CELL_CONTROL_OBJECT_TYPE_CODE
                    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    GROUP BY A.BASIS_YYYYMM
                           , A.ISO_WEEK
                           , A.WEEK_NAME
                           , PARTIAL_WEEK_NAME  -- 20190610
                           , A.MONTH_NAME
                           , A.BASIS_START_DATE
                    --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
                    --UNION ALL
                    --SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
                    --  , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
                    --      WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
                    --      ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME -- 20190610
                    --  , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
                    --      WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
                    --      ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
                    --  , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                    --  , ''                    AS DAY_CODE
                    --  , A.BASIS_START_DATE + CONVERT(CHAR(2), 22) AS SORT_ORDER_NO
                    --  , 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
                    --FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                    --WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    --GROUP BY A.BASIS_YYYYMM
                    --      , A.ISO_WEEK
                    --      , A.WEEK_NAME
                    --      , PARTIAL_WEEK_NAME   -- 20190610
                    --      , A.MONTH_NAME
                    --      , A.BASIS_START_DATE
                    --UNION ALL
                    UNION ALL
                    SELECT 'M_' || A.BASIS_YYYYMM                AS COLUMN_NAME
                         , A.MONTH_NAME                          AS COLUMN_LABEL_NAME
                         , A.MONTH_NAME                          AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME                          AS LARGE_CLASS_LABEL_NAME
                         , ''                                    AS DAY_CODE
                         , MIN(A.BASIS_START_DATE) || '01'       AS SORT_ORDER_NO
                         , 'FPNumber'                            AS CELL_CONTROL_OBJECT_TYPE_CODE
                    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    GROUP BY A.BASIS_YYYYMM
                           , A.MONTH_NAME
                    --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
                    --UNION ALL
                    --SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
                    --      , A.MONTH_NAME           AS COLUMN_LABEL
                    --      , A.MONTH_NAME           AS SMALL_LABEL_NAME
                    --      , A.MONTH_NAME           AS LARGE_LABEL_NAME
                    --      , ''                     AS DAY_CODE
                    --      , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), 11) AS SORT_ORDER_NO
                    --      , 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
                    --FROM    [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                    --WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    --GROUP BY A.BASIS_YYYYMM
                    --      , A.MONTH_NAME
                    --ORDER BY sort_order_no
                 ) T
            ORDER BY SORT_ORDER_NO;

    ELSE

        OPEN O_RC1 FOR
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , ''                     AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
            FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    C.PROGRAM_ID   = V_PROGRAM_ID
            AND    C.SHEET_NAME   = V_SHEET_NAME
            AND    C.DEFAULT_FLAG = 'Y'
            AND    C.VALID_YN     = 'Y'
            AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
            UNION ALL
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , ''                     AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
            FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    C.PROGRAM_ID   = V_PROGRAM_ID
            AND    C.SHEET_NAME   = V_SHEET_NAME
            AND    C.VISIBLE_FLAG = ''
            AND    ( C.DEFAULT_FLAG IS NULL OR C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' ' ) -- 기존 '' 비교 문장
            AND    C.VALID_YN     = 'Y'
            AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                       SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
            UNION ALL
            SELECT V_PROGRAM_ID   AS PROGRAM_ID
                 , V_SHEET_NAME   AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , ''             AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''             AS FIXED_FLAG
                 , 50             AS COLUMN_WIDTH
                 , 'FPNumber'     AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''             AS CELL_COMBO_DATA_TYPE
                 , TO_NUMBER('')  AS DATA_SCALE_NUMBER
                 , TO_NUMBER('')  AS DATA_MAX_LENGTH
                 , 'R'            AS HORIZONTAL_ALIGN_CODE
                 , 'Y'            AS UPPERCASE_APPLY_FLAG
                 , 'Y'            AS VISIBLE_FLAG
                 , ''             AS DEFAULT_FLAG
                 , ''             AS USER_SELECTABLE_FLAG
                 , ''             AS VALID_YN
                 , ''             AS DIVISION_ID
            FROM (
                    SELECT 'D_' || A.BASIS_YYYYMMDD   AS COLUMN_NAME
                         , A.CALENDAR_DAY             AS COLUMN_LABEL_NAME
                         , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME || '+'
                                WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' || A.WEEK_NAME
                                ELSE A.WEEK_NAME END  AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME               AS LARGE_CLASS_LABEL_NAME
                         , A.DAYOFWEEK                AS DAY_CODE
                         , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
                    --UNION ALL ...
                    --SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
                    --  , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                    --  , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
                    --  WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
                    --  ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
                    --  , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                    --  , ''                        AS DAY_CODE
                    --  , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 32) AS SORT_ORDER_NO
                    --FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                    --WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    UNION ALL
                    SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK  AS COLUMN_NAME
                         , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME || '+'
                                WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' || A.WEEK_NAME
                                ELSE A.WEEK_NAME END             AS COLUMN_LABEL_NAME  -- 20190610
                         , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME || '+'
                                WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' || A.WEEK_NAME
                                ELSE A.WEEK_NAME END             AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME                          AS LARGE_CLASS_LABEL_NAME
                         , ''                                    AS DAY_CODE
                         , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    GROUP BY A.BASIS_YYYYMM
                           , A.ISO_WEEK
                           , A.WEEK_NAME
                           , PARTIAL_WEEK_NAME  -- 20190610
                           , A.MONTH_NAME
                           , A.BASIS_START_DATE
                    --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
                    --UNION ALL
                    --SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
                    --  , CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
                    --  WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
                    --  ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME -- 20190610
                    --, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
                    --  WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
                    --  ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
                    --  , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                    --  , ''                    AS DAY_CODE
                    --  , A.BASIS_START_DATE + CONVERT(CHAR(2), 22) AS SORT_ORDER_NO
                    --FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                    --WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    --GROUP BY A.BASIS_YYYYMM
                    --      , A.ISO_WEEK
                    --      , A.WEEK_NAME
                    --      , PARTIAL_WEEK_NAME   -- 20190610
                    --      , A.MONTH_NAME
                    --      , A.BASIS_START_DATE
                    UNION ALL
                    SELECT 'M_' || A.BASIS_YYYYMM                AS COLUMN_NAME
                         , A.MONTH_NAME                          AS COLUMN_LABEL_NAME
                         , A.MONTH_NAME                          AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME                          AS LARGE_CLASS_LABEL_NAME
                         , ''                                    AS DAY_CODE
                         , MIN(A.BASIS_START_DATE) || '01'       AS SORT_ORDER_NO
                    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
                    WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    GROUP BY A.BASIS_YYYYMM
                           , A.MONTH_NAME
                    --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
                    --UNION ALL
                    --SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
                    --      , A.MONTH_NAME           AS COLUMN_LABEL
                    --      , A.MONTH_NAME           AS SMALL_LABEL_NAME
                    --      , A.MONTH_NAME           AS LARGE_LABEL_NAME
                    --      , ''                     AS DAY_CODE
                    --      , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), 11) AS SORT_ORDER_NO
                    --FROM    [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                    --WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                    --GROUP BY A.BASIS_YYYYMM
                    --      , A.MONTH_NAME
                    --ORDER BY sort_order_no
                 ) T
            ORDER BY SORT_ORDER_NO;

    END IF;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT :=
            JSON_OBJECT(
                'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                'P_CREATED_BY'     VALUE P_CREATED_BY,
                'P_DIVISION_ID'    VALUE P_DIVISION_ID
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_SPREAD_TITLE;



/* ============================================================
   DMF0003_GET_MKT_FCST_COMPARE_POPUP
   ============================================================
   [GTT DDL - 별도 실행]
   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_MFCP_TEMP_DM_SSP
   (
       CATEGORY          VARCHAR2(30  CHAR),
       CONFIRM_ID        VARCHAR2(200 CHAR),
       DIVISION_ID       VARCHAR2(30  CHAR),
       PROJECT_CODE      VARCHAR2(100 CHAR),
       SCM_SITE_ID       VARCHAR2(100 CHAR),
       ITEM_ID           VARCHAR2(100 CHAR),
       INCOTERMS         VARCHAR2(10  CHAR),
       FCST_TYPE         VARCHAR2(20  CHAR),
       DOM_EXP           VARCHAR2(10  CHAR),
       YYYYMMDD          VARCHAR2(8   CHAR),
       MEASURE           VARCHAR2(100 CHAR),
       QTY               NUMBER,
       ATTRIBUTE4        VARCHAR2(4000 CHAR),
       ATTRIBUTE5        VARCHAR2(4000 CHAR)
   )
   ON COMMIT PRESERVE ROWS;
   /
   ============================================================ */
PROCEDURE P_DMF0003_GET_MKT_FCST_COMPARE_POPUP
(
    P_DIVISION_ID   IN VARCHAR2,
    P_SCM_SITE_ID   IN VARCHAR2,
    P_PROJECT_CODE  IN VARCHAR2,
    P_ITEM_ID       IN VARCHAR2,
    --[C20210225-000385] dom_exp, fcst_type, incoterms, yyyymmdd 추가
    P_DOM_EXP       IN VARCHAR2,
    P_FCST_TYPE     IN VARCHAR2,
    P_INCOTERMS     IN VARCHAR2,
    P_YYYYMMDD      IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/**************************************************************************************************
 Program ID  : DMF0003_GET_MKT_FCST_COMPARE_POPUP
 Description : Procedure 작성 가이드
 Usage       : Procedure 작성 시 참조하세요!
 Parameter   :

-------------------------------------------------------------------------------------------------
 Date        In Charge    Description
-------------------------------------------------------------------------------------------------
 2021-01-13   KUNI      [C20210112-000446] 동기화된 수량 내역 보여주는 팝업 창(MKT FCST, SSP수량
 2021-02-22   P.C.I     [C20210225-000385] DM_PLN_MKT_FCST_CONFIRM 기준으로 쿼리 변경
 2022-04-25   HWI1993   GM JV 작업
 2026.03.15   kimcd     [PJ20264226] NextSCM Pilot 설계 및 개발
*************************************************************************************************
*/
    -- LOG 용 변수 설정
    $$PLSQL_UNIT   VARCHAR2(200) := $$PLSQL_UNIT;
    V_LOG_TYPE       VARCHAR2(30  CHAR);  -- START/END/ERROR/...
    N_LOG_COUNT      PLS_INTEGER  := 0;
    V_LOG_MESSAGE    VARCHAR2(1000 CHAR);
    V_DESCRIPTION    VARCHAR2(500 CHAR);
    D_EVENT_DATE     DATE;
    N_DELETE_COUNT   PLS_INTEGER  := 0;
    N_INSERT_COUNT   PLS_INTEGER  := 0;

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- GTT TRUNCATE
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_MFCP_TEMP_DM_SSP';
    --EXECUTE IMMEDIATE 'ALTER SESSION SET GLOBAL_TEMP_TABLE_STATS = SESSION';

    --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    --1. 동기화
    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_MFCP_TEMP_DM_SSP
    (CATEGORY, CONFIRM_ID, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
     INCOTERMS, FCST_TYPE, DOM_EXP, YYYYMMDD, MEASURE, QTY, ATTRIBUTE4, ATTRIBUTE5)
    SELECT /*+ FULL(A) PARALLEL(A,4) */
           'SYNC'                                                        AS CATEGORY
         , TRIM(REGEXP_SUBSTR(A.ATTRIBUTE4, '[^,]+', 1, LEVEL))         AS CONFIRM_ID
         , A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
         , A.MEASURE, A.QTY, A.ATTRIBUTE4, A.ATTRIBUTE5
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    WHERE  REGEXP_SUBSTR(A.ATTRIBUTE4, '[^,]+', 1, LEVEL) IS NOT NULL
    AND    A.MEASURE        = 'MKT_FCST'
    AND    A.DIVISION_ID    = P_DIVISION_ID
    AND    A.PROJECT_CODE   = P_PROJECT_CODE
    AND    A.SCM_SITE_ID    = P_SCM_SITE_ID
    AND    A.ITEM_ID        = P_ITEM_ID
    AND    A.DOM_EXP        = P_DOM_EXP
    AND    A.FCST_TYPE      = P_FCST_TYPE
    AND    A.INCOTERMS      = P_INCOTERMS
    AND    A.YYYYMMDD       = P_YYYYMMDD
    CONNECT BY REGEXP_SUBSTR(A.ATTRIBUTE4, '[^,]+', 1, LEVEL) IS NOT NULL
           AND PRIOR A.ROWID = A.ROWID
           AND PRIOR DBMS_RANDOM.VALUE IS NOT NULL;

    COMMIT;

    --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    --2. 캐리오버
    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_MFCP_TEMP_DM_SSP
    (CATEGORY, CONFIRM_ID, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
     INCOTERMS, FCST_TYPE, DOM_EXP, YYYYMMDD, MEASURE, QTY, ATTRIBUTE4, ATTRIBUTE5)
    SELECT /*+ FULL(A) PARALLEL(A,4) */
           'CARRY_OVER'                                                  AS CATEGORY
         , TRIM(REGEXP_SUBSTR(A.ATTRIBUTE5, '[^,]+', 1, LEVEL))         AS CONFIRM_ID
         , A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
         , A.MEASURE, A.QTY, A.ATTRIBUTE4, A.ATTRIBUTE5
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    WHERE  REGEXP_SUBSTR(A.ATTRIBUTE5, '[^,]+', 1, LEVEL) IS NOT NULL
    AND    A.MEASURE        = 'MKT_FCST'
    AND    A.DIVISION_ID    = P_DIVISION_ID
    AND    A.PROJECT_CODE   = P_PROJECT_CODE
    AND    A.SCM_SITE_ID    = P_SCM_SITE_ID
    AND    A.ITEM_ID        = P_ITEM_ID
    AND    A.DOM_EXP        = P_DOM_EXP
    AND    A.FCST_TYPE      = P_FCST_TYPE
    AND    A.INCOTERMS      = P_INCOTERMS
    AND    A.YYYYMMDD       = P_YYYYMMDD
    AND    A.ATTRIBUTE5 IS NOT NULL
    AND    A.ATTRIBUTE5    <> '-'
    AND    A.ATTRIBUTE5    <> ' ' -- NVL(A.ATTRIBUTE5, '') <> ''
    CONNECT BY REGEXP_SUBSTR(A.ATTRIBUTE5, '[^,]+', 1, LEVEL) IS NOT NULL
           AND PRIOR A.ROWID = A.ROWID
           AND PRIOR DBMS_RANDOM.VALUE IS NOT NULL;

    COMMIT;

    --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    --3. 네팅
    /*select 'NETTING' AS CATEGORY
         , NET.VALUE AS CONFIRM_ID
         , A.*
    from   DM_PLN_MKT_FCST A with(nolock)
    CROSS APPLY (  SELECT ID,VALUE FROM dbo.FN_SplitString(A.ATTRIBUTE6,','))  NET
    where  1=1
    and    measure      = 'MKT_FCST'
    and    division_id  = @p_division_id
    and    project_code   = @p_project_code
    AND    scm_site_id  = @p_scm_site_id
    AND    ITEM_ID      = @p_item_id
    and    dom_exp      = @p_dom_exp
    and    fcst_type    = @p_fcst_type
    and    incoterms    = @p_incoterms
    AND    YYYYMMDD     = @p_yyyymmdd
    AND    ISNULL(A.ATTRIBUTE6, '') <> ''
    */

    --4. MKT Fcst
    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_MFCP_TEMP_DM_SSP
    (CATEGORY, CONFIRM_ID, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
     INCOTERMS, FCST_TYPE, DOM_EXP, YYYYMMDD, MEASURE, QTY, ATTRIBUTE4, ATTRIBUTE5)
    SELECT /*+ FULL(A) PARALLEL(A,4) */
           'MKT_FCST'   AS CATEGORY
         , ''            AS CONFIRM_ID
         , A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
         , A.MEASURE, A.QTY, A.ATTRIBUTE4, A.ATTRIBUTE5
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    WHERE  A.MEASURE        = 'MKT_FCST'
    AND    A.DIVISION_ID    = P_DIVISION_ID
    AND    A.PROJECT_CODE   = P_PROJECT_CODE
    AND    A.SCM_SITE_ID    = P_SCM_SITE_ID
    AND    A.ITEM_ID        = P_ITEM_ID
    AND    A.DOM_EXP        = P_DOM_EXP
    AND    A.FCST_TYPE      = P_FCST_TYPE
    AND    A.INCOTERMS      = P_INCOTERMS
    AND    A.YYYYMMDD       = P_YYYYMMDD;

    COMMIT;

    --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

    -- GTT 통계 수집
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_MFCP_TEMP_DM_SSP',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1',
        NO_INVALIDATE    => FALSE
    );

    --MKT_FCST = Confirm 제외 수량
    OPEN O_RC1 FOR
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
             , A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
             , A.CATEGORY, A.CONFIRM_ID, A.SO_NO, A.PLAN_QTY, A.RESULT_QTY
             , A.SEQ
        FROM  ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
                     , A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
                     , A.CATEGORY, A.CONFIRM_ID
                     , CASE WHEN TO_CHAR(TO_NUMBER(CASE WHEN B.SO_NO = 'X' THEN '' ELSE B.SO_NO END)) = '0'
                                THEN ''
                            ELSE TO_CHAR(TO_NUMBER(CASE WHEN B.SO_NO = 'X' THEN '' ELSE B.SO_NO END))
                       END                                                        AS SO_NO
                     , B.PLAN_QTY
                     , B.SHIP_RESULT_QTY                                          AS RESULT_QTY
                     , CASE WHEN A.CATEGORY = 'MKT_FCST'    THEN 1
                            WHEN A.CATEGORY = 'SYNC'         THEN 2
                            WHEN A.CATEGORY = 'CARRY_OVER'   THEN 3
                            ELSE 4
                       END                                                        AS SEQ
                FROM   SCM_MGR.GT_MFCP_TEMP_DM_SSP A
                INNER JOIN SCM_MGR.DM_PLN_MKT_FCST_CONFIRM B
                    ON  ( A.CONFIRM_ID = B.CONFIRM_ID
                      AND A.ITEM_ID    = B.ITEM_ID )
                UNION ALL
                SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
                     , A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
                     , CASE WHEN A.CATEGORY = 'MKT_FCST'    THEN 'Non-Sync MKT Fcst'
                            WHEN A.CATEGORY = 'SYNC'         THEN 'Sync'
                            WHEN A.CATEGORY = 'CARRY_OVER'   THEN 'Carry Over'
                       END                                                        AS CATEGORY
                     , A.CONFIRM_ID
                     , ''                                                         AS SO_NO
                     , MAX(A.QTY) - NVL(( SELECT SUM(B.PLAN_QTY)
                                          FROM   SCM_MGR.GT_MFCP_TEMP_DM_SSP S
                                          INNER JOIN SCM_MGR.DM_PLN_MKT_FCST_CONFIRM B
                                              ON  ( S.CONFIRM_ID = B.CONFIRM_ID
                                                AND S.ITEM_ID    = B.ITEM_ID )
                                        ), 0)                                     AS PLAN_QTY
                     , NULL                                                       AS SHIP_RESULT_QTY
                     , CASE WHEN A.CATEGORY = 'MKT_FCST'    THEN 1
                            WHEN A.CATEGORY = 'SYNC'         THEN 2
                            WHEN A.CATEGORY = 'CARRY_OVER'   THEN 3
                            ELSE 4
                       END                                                        AS SEQ
                FROM   SCM_MGR.GT_MFCP_TEMP_DM_SSP A
                WHERE  A.CATEGORY = 'MKT_FCST'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
                       , A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
                       , A.CATEGORY, A.CONFIRM_ID ) A
        ORDER BY A.SEQ
               , A.CONFIRM_ID;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END OF PROCEDURE ##########';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT :=
            JSON_OBJECT(
                'P_DIVISION_ID'  VALUE P_DIVISION_ID,
                'P_SCM_SITE_ID'  VALUE P_SCM_SITE_ID,
                'P_PROJECT_CODE' VALUE P_PROJECT_CODE,
                'P_ITEM_ID'      VALUE P_ITEM_ID,
                'P_DOM_EXP'      VALUE P_DOM_EXP,
                'P_FCST_TYPE'    VALUE P_FCST_TYPE,
                'P_INCOTERMS'    VALUE P_INCOTERMS,
                'P_YYYYMMDD'     VALUE P_YYYYMMDD
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_MKT_FCST_COMPARE_POPUP;



/* ============================================================
   DMF0003_GET_QTY_TYPE_CODE
   ============================================================ */
PROCEDURE P_DMF0003_GET_QTY_TYPE_CODE
(
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0003_GET_BUCKET_TYPE_CODE                                                       */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.15  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                                                                                                  */
/****************************************************************************************************/
    $$PLSQL_UNIT  VARCHAR2(200) := $$PLSQL_UNIT;
    V_PROC_INPUT  VARCHAR2(4000 CHAR);
    V_BACKTRACE   VARCHAR2(4000 CHAR);
    V_SQL_CODE    VARCHAR2(100  CHAR);
    V_SQL_ERRMSG  VARCHAR2(1000 CHAR);
    V_LOG_TYPE    VARCHAR2(100  CHAR);
    V_LOG_MESSAGE VARCHAR2(4000 CHAR);
    V_DESCRIPTION VARCHAR2(4000 CHAR);
    N_LOG_COUNT   PLS_INTEGER := 0;
    D_EVENT_DATE  DATE        := SYSDATE;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    OPEN O_RC1 FOR
        SELECT L.SEGMENT1  AS CODE
             , L.SEGMENT2  AS NAME
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
        WHERE  L.LOOKUP_TYPE = 'MKT_FCST_UNIT_QTY'
        AND    L.VALID_YN    = 'Y'
        ORDER BY DISPLAY_SEQ;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  := JSON_OBJECT('NO_PARAM' VALUE 'N/A');
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_QTY_TYPE_CODE;


/* ============================================================
   DMF0003_GET_REPORT_BUCKET_TYPE_CODE
   ============================================================ */
PROCEDURE P_DMF0003_GET_REPORT_BUCKET_TYPE_CODE
(
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DMF0003_GET_REPORT_BUCKET_TYPE_CODE                                                       */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2022.07.26 kdw2819   [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
*  2022.10.24 ROSIA27   [C20221024-000510]DM UI 소스 정리 요청
*  2026.03.15 kimcd     [PJ20264226] NextSCM Pilot 설계 및 개발
*/
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    $$PLSQL_UNIT  VARCHAR2(200) := $$PLSQL_UNIT;
    V_PROC_INPUT  VARCHAR2(4000 CHAR);
    V_BACKTRACE   VARCHAR2(4000 CHAR);
    V_SQL_CODE    VARCHAR2(100  CHAR);
    V_SQL_ERRMSG  VARCHAR2(1000 CHAR);
    V_LOG_TYPE    VARCHAR2(100  CHAR);
    V_LOG_MESSAGE VARCHAR2(4000 CHAR);
    V_DESCRIPTION VARCHAR2(4000 CHAR);
    N_LOG_COUNT   PLS_INTEGER := 0;
    D_EVENT_DATE  DATE        := SYSDATE;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    OPEN O_RC1 FOR
        SELECT L.SEGMENT1  AS CODE
             , L.SEGMENT2  AS NAME
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
        WHERE  L.LOOKUP_TYPE = 'REPORT_BUCKET_TYPE_CODE'
        AND    L.VALID_YN    = 'Y'
        ORDER BY DISPLAY_SEQ;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  := JSON_OBJECT('NO_PARAM' VALUE 'N/A');
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_REPORT_BUCKET_TYPE_CODE;

/* ============================================================
   DMF0003_GET_SPREAD_TITLE_CAR
   ============================================================ */
PROCEDURE P_DMF0003_GET_SPREAD_TITLE_CAR
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0003_GET_SPREAD_TITLE_CAR                                                        */
/* Description : Procedure 작성 가이드                                                                */
/* Usage       : Procedure 작성 시 참조하세요!                                                         */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2023/05/27  chano0612    Init                                                                    */
/* 2026.03.17  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    V_USER_COL_CNT   PLS_INTEGER     := 0;
    V_PROGRAM_ID     VARCHAR2(4000 CHAR);
    V_SHEET_NAME     VARCHAR2(4000 CHAR);

    $$PLSQL_UNIT   VARCHAR2(200) := $$PLSQL_UNIT;
    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100  CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100  CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER     := 0;
    D_EVENT_DATE     DATE            := SYSDATE;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    V_PROGRAM_ID   := 'DMF0003';
    V_SHEET_NAME   := 'Car Fcst';
    V_USER_COL_CNT := 0;

    SELECT COUNT(*)
    INTO   V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = V_PROGRAM_ID
    AND    U.SHEET_NAME = V_SHEET_NAME
    AND    U.USER_ID    = P_CREATED_BY;

    IF V_USER_COL_CNT > 0 THEN

        OPEN O_RC1 FOR
            SELECT *
            FROM (
                SELECT U.PROGRAM_ID
                     , U.SHEET_NAME
                     , U.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , U.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_TITLESET_USER  U
                     , SCM_MGR.SCM_MST_SHEET_COLUMNS   C
                WHERE  1 = 1
                AND    U.PROGRAM_ID  = C.PROGRAM_ID
                AND    U.SHEET_NAME  = C.SHEET_NAME
                AND    U.COLUMN_NAME = C.COLUMN_NAME
                AND    U.PROGRAM_ID  = V_PROGRAM_ID
                AND    U.SHEET_NAME  = V_SHEET_NAME
                AND    U.USER_ID     = P_CREATED_BY
                AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
                UNION ALL
                SELECT C.PROGRAM_ID
                     , C.SHEET_NAME
                     , C.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID   = V_PROGRAM_ID
                AND    C.SHEET_NAME   = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
                AND    C.DEFAULT_FLAG = 'Y' -- '' 기준 정보 NOT NULL 컬럼으로 '-'로 변경
                AND    C.VALID_YN     = 'Y'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
            ) A
            ORDER BY A.SORT_ORDER_NO;

            --UNION ALL
            --SELECT @v_program_id   AS PROGRAM_ID ...
            -- (주석 블록 원본 유지)

    ELSE

        OPEN O_RC1 FOR
            SELECT *
            FROM (
                SELECT C.PROGRAM_ID
                     , C.SHEET_NAME
                     , C.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID   = V_PROGRAM_ID
                AND    C.SHEET_NAME   = V_SHEET_NAME
                AND    C.DEFAULT_FLAG = 'Y'
                AND    C.VALID_YN     = 'Y'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
                UNION ALL
                SELECT C.PROGRAM_ID
                     , C.SHEET_NAME
                     , C.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID   = V_PROGRAM_ID
                AND    C.SHEET_NAME   = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
                AND    C.DEFAULT_FLAG = 'Y' -- '' 기준 정보 NOT NULL 컬럼으로 '-'로 변경
                AND    C.VALID_YN     = 'Y'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
            ) A
            ORDER BY A.SORT_ORDER_NO;

    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT :=
            JSON_OBJECT(
                'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                'P_CREATED_BY'     VALUE P_CREATED_BY,
                'P_DIVISION_ID'    VALUE P_DIVISION_ID
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_SPREAD_TITLE_CAR;

/* ============================================================
   DMF0003_GET_SPREAD_TITLE_PSI
   ============================================================ */
PROCEDURE P_DMF0003_GET_SPREAD_TITLE_PSI
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0003_GET_SPREAD_TITLE_PSI                                                        */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2023/05/27  chano0612    Init                                                                    */
/* 2026.03.17  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    --EXEC DMF0003_GET_SPREAD_TITLE_PSI '20230101', '20231231', 'chano0612', '81'
    V_USER_COL_CNT   PLS_INTEGER     := 0;
    V_PROGRAM_ID     VARCHAR2(4000 CHAR);
    V_SHEET_NAME     VARCHAR2(4000 CHAR);

    $$PLSQL_UNIT   VARCHAR2(200) := $$PLSQL_UNIT;
    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100  CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100  CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER     := 0;
    D_EVENT_DATE     DATE            := SYSDATE;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    V_PROGRAM_ID   := 'DMF0003';
    V_SHEET_NAME   := 'PSI';
    V_USER_COL_CNT := 0;

    SELECT COUNT(*)
    INTO   V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = V_PROGRAM_ID
    AND    U.SHEET_NAME = V_SHEET_NAME
    AND    U.USER_ID    = P_CREATED_BY;

    IF V_USER_COL_CNT > 0 THEN

        OPEN O_RC1 FOR
            SELECT *
            FROM (
                SELECT U.PROGRAM_ID
                     , U.SHEET_NAME
                     , U.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , U.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_TITLESET_USER  U
                     , SCM_MGR.SCM_MST_SHEET_COLUMNS   C
                WHERE  1 = 1
                AND    U.PROGRAM_ID  = C.PROGRAM_ID
                AND    U.SHEET_NAME  = C.SHEET_NAME
                AND    U.COLUMN_NAME = C.COLUMN_NAME
                AND    U.PROGRAM_ID  = V_PROGRAM_ID
                AND    U.SHEET_NAME  = V_SHEET_NAME
                AND    U.USER_ID     = P_CREATED_BY
                AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
                UNION ALL
                SELECT C.PROGRAM_ID
                     , C.SHEET_NAME
                     , C.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID   = V_PROGRAM_ID
                AND    C.SHEET_NAME   = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
                AND    C.DEFAULT_FLAG = 'Y' -- '' 기준 정보 NOT NULL 컬럼으로 '-'로 변경
                AND    C.VALID_YN     = 'Y'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
            ) A
            ORDER BY A.SORT_ORDER_NO;

    ELSE

        OPEN O_RC1 FOR
            SELECT *
            FROM (
                SELECT C.PROGRAM_ID
                     , C.SHEET_NAME
                     , C.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID   = V_PROGRAM_ID
                AND    C.SHEET_NAME   = V_SHEET_NAME
                AND    C.DEFAULT_FLAG = 'Y'
                AND    C.VALID_YN     = 'Y'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
                UNION ALL
                SELECT C.PROGRAM_ID
                     , C.SHEET_NAME
                     , C.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID   = V_PROGRAM_ID
                AND    C.SHEET_NAME   = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
                AND    C.DEFAULT_FLAG = 'Y' -- '' 기준 정보 NOT NULL 컬럼으로 '-'로 변경
                AND    C.VALID_YN     = 'Y'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
            ) A
            ORDER BY A.SORT_ORDER_NO;

    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT :=
            JSON_OBJECT(
                'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                'P_CREATED_BY'     VALUE P_CREATED_BY,
                'P_DIVISION_ID'    VALUE P_DIVISION_ID
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_SPREAD_TITLE_PSI;

/* ============================================================
   DMF0003_GET_SPREAD_TITLE_PSI_POPUP
   ============================================================ */
PROCEDURE P_DMF0003_GET_SPREAD_TITLE_PSI_POPUP
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0003_GET_SPREAD_TITLE_PSI                                                        */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2023/05/27  chano0612    Init                                                                    */
/* 2026.03.17  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    V_USER_COL_CNT   PLS_INTEGER     := 0;
    V_PROGRAM_ID     VARCHAR2(4000 CHAR);
    V_SHEET_NAME     VARCHAR2(4000 CHAR);

    $$PLSQL_UNIT   VARCHAR2(200) := $$PLSQL_UNIT;
    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100  CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100  CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER     := 0;
    D_EVENT_DATE     DATE            := SYSDATE;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    V_PROGRAM_ID   := 'DMF0003';
    V_SHEET_NAME   := 'Customer Demand Analysis';
    V_USER_COL_CNT := 0;

    SELECT COUNT(*)
    INTO   V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = V_PROGRAM_ID
    AND    U.SHEET_NAME = V_SHEET_NAME
    AND    U.USER_ID    = P_CREATED_BY;

    IF V_USER_COL_CNT > 0 THEN

        OPEN O_RC1 FOR
            SELECT *
            FROM (
                SELECT U.PROGRAM_ID
                     , U.SHEET_NAME
                     , U.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , U.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_TITLESET_USER  U
                     , SCM_MGR.SCM_MST_SHEET_COLUMNS   C
                WHERE  1 = 1
                AND    U.PROGRAM_ID  = C.PROGRAM_ID
                AND    U.SHEET_NAME  = C.SHEET_NAME
                AND    U.COLUMN_NAME = C.COLUMN_NAME
                AND    U.PROGRAM_ID  = V_PROGRAM_ID
                AND    U.SHEET_NAME  = V_SHEET_NAME
                AND    U.USER_ID     = P_CREATED_BY
                AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
                UNION ALL
                SELECT C.PROGRAM_ID
                     , C.SHEET_NAME
                     , C.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID   = V_PROGRAM_ID
                AND    C.SHEET_NAME   = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
                AND    C.DEFAULT_FLAG = 'Y' -- '' 기준 정보 NOT NULL 컬럼으로 '-'로 변경
                AND    C.VALID_YN     = 'Y'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
            ) A
            ORDER BY A.SORT_ORDER_NO;

    ELSE

        OPEN O_RC1 FOR
            SELECT *
            FROM (
                SELECT C.PROGRAM_ID
                     , C.SHEET_NAME
                     , C.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID   = V_PROGRAM_ID
                AND    C.SHEET_NAME   = V_SHEET_NAME
                AND    C.DEFAULT_FLAG = 'Y'
                AND    C.VALID_YN     = 'Y'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
                UNION ALL
                SELECT C.PROGRAM_ID
                     , C.SHEET_NAME
                     , C.COLUMN_NAME
                     , C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME
                     , C.LARGE_CLASS_LABEL_NAME
                     , ''                     AS DAY_CODE
                     , C.FIXED_FLAG
                     , C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE
                     , C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER
                     , C.DATA_MAX_LENGTH
                     , C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG
                     , C.VISIBLE_FLAG
                     , C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG
                     , C.VALID_YN
                     , C.DIVISION_ID
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID   = V_PROGRAM_ID
                AND    C.SHEET_NAME   = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
                AND    C.DEFAULT_FLAG = 'Y' -- '' 기준 정보 NOT NULL 컬럼으로 '-'로 변경
                AND    C.VALID_YN     = 'Y'
                AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                           SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
            ) A
            ORDER BY A.SORT_ORDER_NO;

    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT :=
            JSON_OBJECT(
                'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                'P_CREATED_BY'     VALUE P_CREATED_BY,
                'P_DIVISION_ID'    VALUE P_DIVISION_ID
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_SPREAD_TITLE_PSI_POPUP;


/* ============================================================
   4. DMF0003_MKT_FCST_SALES_PLAN_SYNC
   GTT DDL (별도 실행):
   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_FSPS_T_PRICE (
       DIVISION_ID    VARCHAR2(30  CHAR), PROJECT_CODE  VARCHAR2(50  CHAR),
       SCM_SITE_ID    VARCHAR2(30  CHAR), PLANT_SITE_ID VARCHAR2(30  CHAR),
       ITEM_ID        VARCHAR2(50  CHAR), YYYYMMDD      VARCHAR2(8   CHAR),
       CURRENCY       VARCHAR2(10   CHAR), MEASURE       VARCHAR2(50  CHAR),
       DOM_EXP        VARCHAR2(3   CHAR), FCST_TYPE     VARCHAR2(20  CHAR),
       INCOTERMS      VARCHAR2(10  CHAR), PRICE         NUMBER(30,10)
   ) ON COMMIT PRESERVE ROWS;
   /
   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_FSPS_T_MKT_FCST (
       DIVISION_ID    VARCHAR2(30  CHAR), PROJECT_CODE  VARCHAR2(50  CHAR),
       SCM_SITE_ID    VARCHAR2(30  CHAR), ITEM_ID       VARCHAR2(50  CHAR),
       DOM_EXP        VARCHAR2(3   CHAR), FCST_TYPE     VARCHAR2(20  CHAR),
       INCOTERMS      VARCHAR2(10  CHAR), MEASURE       VARCHAR2(50  CHAR),
       YYYYMMDD       VARCHAR2(8   CHAR), PLANT_SITE_ID VARCHAR2(30  CHAR),
       QTY            NUMBER(30,10),      CREATED_BY    VARCHAR2(150 CHAR),
       CREATION_DATE  DATE
   ) ON COMMIT PRESERVE ROWS;
   /
   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_FSPS_SALES_PLAN_TEMP_LOC (
       DIVISION_ID    VARCHAR2(30  CHAR), PROJECT_CODE  VARCHAR2(50  CHAR),
       SCM_SITE_ID    VARCHAR2(30  CHAR), ITEM_ID       VARCHAR2(50  CHAR),
       DOM_EXP        VARCHAR2(3   CHAR), FCST_TYPE     VARCHAR2(20  CHAR),
       INCOTERMS      VARCHAR2(10  CHAR), MEASURE       VARCHAR2(50  CHAR),
       PLANT_SITE_ID  VARCHAR2(30  CHAR), YYYYMMDD      CHAR(8 CHAR),
       CURRENCY       VARCHAR2(3   CHAR), QTY           NUMBER(30,10),
       CREATED_BY     VARCHAR2(150 CHAR), CREATION_DATE DATE
   ) ON COMMIT PRESERVE ROWS;
   /
   ============================================================ */
PROCEDURE P_DMF0003_MKT_FCST_SALES_PLAN_SYNC
(
    P_DIVISION_ID   IN VARCHAR2,
    P_CREATED_BY    IN VARCHAR2,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : DMF0003_MKT_FCST_SALES_PLAN_SYNC
 * Description  : MKT_FCST & SALES_PLAN DATA SYNC
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20230607   chano0612 고희선님 요청으로 MKT_FCST 와 SALES_PLAN 데이터 SYNC
 * 2026.03.17 kimcd     [PJ20264226] NextSCM Pilot 설계 및 개발
  */

    -- 스플릿관련 변수
    RECV_DIVISION_ID    VARCHAR2(4000 CHAR);
    V_DELIMITER         VARCHAR2(1    CHAR);
    MAX_LOOP_CNT        PLS_INTEGER   := 0;
    MST_LOOP_CNT        PLS_INTEGER   := 0;
    V_DIVISION_ID       VARCHAR2(4000 CHAR);
    V_CREATED_BY        VARCHAR2(4000 CHAR);

    -- LOG 용 변수 설정
    $$PLSQL_UNIT      VARCHAR2(200) := $$PLSQL_UNIT;
    V_LOG_TYPE          VARCHAR2(30   CHAR);  -- START/END/ERROR/...
    N_LOG_COUNT         PLS_INTEGER   := 0;
    T_LOG_COUNT         PLS_INTEGER   := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500  CHAR);
    D_EVENT_DATE        DATE;

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100  CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

    -- CUTOFF 변수 설정
    V_NEXT_MON_MINUS7   VARCHAR2(8    CHAR);

BEGIN
    -- SESSION. 병렬 처리 제한
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DDL';
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL QUERY';

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    -- CUTOFF 변수 설정
    RECV_DIVISION_ID := P_DIVISION_ID;
    V_DELIMITER      := '^';  -- 데이터 구분자

    --[2018-03-15][추가][사용자를 매개변수로 받아서 처리]
    --            [있는경우][매개변수로 처리]
    --            [없는경우][ROLLING 에서 처리하므로 'CUTOFF'로 처리]
    IF P_CREATED_BY IS NULL THEN  -- '' 비교 하는 로직을 IS NULL로 변경
        V_CREATED_BY := 'CUTOFF';
    ELSE
        V_CREATED_BY := P_CREATED_BY;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := 'P_DIVISION_ID : ' || P_DIVISION_ID || ' / ' || 'V_CREATED_BY : ' || NVL(V_CREATED_BY, 'NULL');
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    --EXECUTE IMMEDIATE 'ALTER SESSION SET GLOBAL_TEMP_TABLE_STATS = SESSION';

    -- 프로시저 LOOP 길이를 판단
    MAX_LOOP_CNT := SCM_MGR.SCM_ARR_SPL_CNT(P_DIVISION_ID, V_DELIMITER);
    -- SELECT @max_loop_cnt  as '@max_loop_cnt (input된 division값)';  -- 확인용 81^82^83
    -- SELECT Convert(NVARCHAR(10), @max_loop_cnt)  as '@max_loop_cnt (input된 division값)';  -- 확인용 81^82^83
    DBMS_OUTPUT.PUT_LINE('A--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

    /*---------------------------------------------------------------*/
    WHILE LENGTH(RECV_DIVISION_ID) > 0 AND MST_LOOP_CNT < MAX_LOOP_CNT
    LOOP
        -- 각 컬럼들에 대한 스플릿처리로직 스타트
        -- Loop Count +1씩 증가시킴
        MST_LOOP_CNT := MST_LOOP_CNT + 1;
        V_DIVISION_ID := SCM_MGR.SCM_ARR_SPL_VAL(P_DIVISION_ID, V_DELIMITER, MST_LOOP_CNT);

        -- NEXT MON - 7일 기준일자 사전 계산 (함수 반복 호출 방지)
        SELECT TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
        INTO   V_NEXT_MON_MINUS7
        FROM   DUAL;

        /*----------------------------- MULTI & SINGLE ROW START -------------------------------------------------------------*/
        /*-- max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행하도록함 --*/
        IF MST_LOOP_CNT <= MAX_LOOP_CNT THEN

            -- GTT TRUNCATE
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_FSPS_T_PRICE';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_FSPS_T_MKT_FCST';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_FSPS_SALES_PLAN_TEMP_LOC';

           -- EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

            -- 기존 정보 삭제
            -- where yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, (getdate()) + (-1*7) ), 7) , 112)
            DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN
            WHERE  YYYYMMDD    >= V_NEXT_MON_MINUS7
            AND    DIVISION_ID  = V_DIVISION_ID
            -- MKT/금형비처럼 사람이 넣은것 삭제.
            AND    ITEM_ID IN (SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN GROUP BY ITEM_ID)
            -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
            AND    NOT EXISTS (
                       SELECT A.DIVISION_ID
                       FROM   SCM_MGR.SCM_MST_SITE_ITEM A
                            , SCM_MGR.DM_PLN_SALES_PLAN  B
                       WHERE  SALES_PLAN_ADJUST_YN  = ''
                       AND    A.ITEM_ID             = B.ITEM_ID
                       AND    A.DIVISION_ID         = B.DIVISION_ID
                       AND    A.PROJECT_CODE        = B.PROJECT_CODE
                       AND    A.SCM_SITE_ID         = B.SCM_SITE_ID
                       AND    B.LAST_UPDATED_BY NOT IN ('SYSTEM', 'CUTOFF')
                       AND    B.YYYYMMDD           >= V_NEXT_MON_MINUS7
                       AND    A.DIVISION_ID         = DM_PLN_SALES_PLAN.DIVISION_ID
                       AND    A.PROJECT_CODE        = DM_PLN_SALES_PLAN.PROJECT_CODE
                       AND    A.SCM_SITE_ID         = DM_PLN_SALES_PLAN.SCM_SITE_ID
                       AND    A.ITEM_ID             = DM_PLN_SALES_PLAN.ITEM_ID
                   );

            N_LOG_COUNT := SQL%ROWCOUNT;
            DBMS_OUTPUT.PUT_LINE('B--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

            -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산.
            DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN
            WHERE  YYYYMMDD    >= V_NEXT_MON_MINUS7
            AND    DIVISION_ID  = V_DIVISION_ID
            -- MKT/금형비처럼 사람이 넣은것 삭제.
            AND    ITEM_ID IN (SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN GROUP BY ITEM_ID)
            AND    MEASURE IN ('MKT_FCST', 'CUST_FCST', 'RTF', 'RTF_SYS_RP', 'TMM_FCST');  -- 20180417 modify skh  -- 20190709 KHSONG [CSR ID:4034895] 'RTF_SYS_RP' MEASURE 추가 -- 20200309 KHSONG TMM_FCST ADD

            DBMS_OUTPUT.PUT_LINE('C--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

            -- 2021.08.25
            INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_FSPS_T_PRICE
            (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE)
            SELECT /*+ FULL(A) PARALLEL(A,4) */
                   DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
            FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
            WHERE  DIVISION_ID = V_DIVISION_ID
            AND    YYYYMMDD   >= V_NEXT_MON_MINUS7
            AND    A.MEASURE  IN ('KRW', 'LOC', 'USD');

            --COMMIT;
            DBMS_OUTPUT.PUT_LINE('D--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

            --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

            INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_FSPS_T_MKT_FCST
            (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, CREATED_BY, CREATION_DATE)
            SELECT /*+ FULL(A) PARALLEL(A,4) */
                   DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, CREATED_BY, CREATION_DATE
            FROM   SCM_MGR.DM_PLN_MKT_FCST A
            WHERE  A.DIVISION_ID = V_DIVISION_ID
            -- and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, (getdate()) + (-1*7) ), 7) , 112)
            AND    A.YYYYMMDD   >= V_NEXT_MON_MINUS7
            AND    A.MEASURE    IN ('MKT_FCST', 'CUST_FCST', 'TMM_FCST', 'RTF', 'RTF_SYS_RP')
            AND    A.ITEM_ID    IN (SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN GROUP BY ITEM_ID);

            --COMMIT;

            -- GTT 통계 수집
            DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_FSPS_T_PRICE',    ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);
            DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_FSPS_T_MKT_FCST', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

            DBMS_OUTPUT.PUT_LINE('E--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

            --20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가

            --SELECT * FROM GT_FSPS_T_PRICE
            DBMS_OUTPUT.PUT_LINE('F--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
            --PRINT 'EXEC_001                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)

            -- 신규 정보 추가
            -- Temp 테이블에 저장
            --20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
            --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

            INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_FSPS_SALES_PLAN_TEMP_LOC
                (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE)
            -- MKT FCST 값을 update 함.
            SELECT /*+ FULL(W) PARALLEL(W,4) */
                   DISTINCT
                   W.DIVISION_ID
                 , W.PROJECT_CODE
                 , W.SCM_SITE_ID
                 , W.ITEM_ID
                 , W.DOM_EXP
                 , W.FCST_TYPE
                 , W.INCOTERMS
                 , W.MEASURE
                 , W.PLANT_SITE_ID
                 , W.YYYYMMDD
                 , SI.CURRENCY
                 , W.QTY
                 , W.CREATED_BY
                 , W.CREATION_DATE
            FROM   SCM_MGR.GT_FSPS_T_MKT_FCST W
            JOIN   SCM_MGR.SCM_SYS_CALENDAR_M SC
                ON SC.BASIS_YYYYMMDD = W.YYYYMMDD
            LEFT OUTER JOIN SCM_MGR.GT_FSPS_T_PRICE SI
                ON  ( 1 = 1
                  AND W.DIVISION_ID   = SI.DIVISION_ID
                  AND W.PROJECT_CODE  = SI.PROJECT_CODE
                  AND W.SCM_SITE_ID   = SI.SCM_SITE_ID
                  AND W.ITEM_ID       = SI.ITEM_ID
                  AND W.DOM_EXP       = SI.DOM_EXP
                  AND W.FCST_TYPE     = SI.FCST_TYPE
                  AND W.INCOTERMS     = SI.INCOTERMS
                  AND W.PLANT_SITE_ID = SI.PLANT_SITE_ID
                  -- and w.yyyymmdd      = si.yyyymmdd
                  AND SC.BASIS_START_DATE = SI.YYYYMMDD
                )
            WHERE  W.MEASURE IN ('MKT_FCST', 'CUST_FCST', 'TMM_FCST', 'RTF', 'RTF_SYS_RP')  -- 20180417 modify skh  -- 20200309 KHSONG TMM_FCST ADD

            UNION ALL
            -- KRW 값을 계산
            SELECT /*+ FULL(W) PARALLEL(W,4) */
                   W.DIVISION_ID
                 , W.PROJECT_CODE
                 , W.SCM_SITE_ID
                 , W.ITEM_ID
                 , W.DOM_EXP
                 , W.FCST_TYPE
                 , W.INCOTERMS
                 , CASE WHEN FP.MEASURE = 'KRW' THEN 'SalesAmt_KRW'
                        WHEN FP.MEASURE = 'LOC' THEN 'SalesAmt_LOC'
                        WHEN FP.MEASURE = 'USD' THEN 'SalesAmt_USD'
                        ELSE FP.MEASURE
                   END                                                   AS MEASURE
                 , W.PLANT_SITE_ID
                 , W.YYYYMMDD
                 , FP.CURRENCY
                 , CASE WHEN FP.MEASURE = 'KRW' THEN CAST(TO_NUMBER(TO_CHAR(W.QTY * NVL(FP.PRICE, 0), 'FM99999999999999999999.9999999999')) AS NUMBER(30, 10))
                        WHEN FP.MEASURE = 'LOC' THEN CAST(TO_NUMBER(TO_CHAR(W.QTY * NVL(FP.PRICE, 0), 'FM99999999999999999999.9999999999')) AS NUMBER(30, 10))
                        WHEN FP.MEASURE = 'USD' THEN CAST(TO_NUMBER(TO_CHAR(W.QTY * NVL(FP.PRICE, 0), 'FM99999999999999999999.9999999999')) AS NUMBER(30, 10))
                   END                                                   AS QTY
                 , NULL                                                  AS CREATED_BY
                 , NULL                                                  AS CREATION_DATE
            FROM   SCM_MGR.GT_FSPS_T_MKT_FCST W
            JOIN   SCM_MGR.GT_FSPS_T_PRICE     FP
                ON  (    FP.DIVISION_ID   = W.DIVISION_ID
                    AND  FP.PROJECT_CODE  = W.PROJECT_CODE
                    AND  FP.SCM_SITE_ID   = W.SCM_SITE_ID
                    AND  FP.ITEM_ID       = W.ITEM_ID
                    AND  FP.DOM_EXP       = W.DOM_EXP
                    AND  FP.FCST_TYPE     = W.FCST_TYPE
                    AND  FP.INCOTERMS     = W.INCOTERMS
                    AND  FP.PLANT_SITE_ID = W.PLANT_SITE_ID
                    AND  FP.YYYYMMDD      = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
                    --AND FP.MEASURE = 'KRW'
                    )
            WHERE  W.MEASURE = 'RTF_SYS_RP'  --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
            -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
            AND    NOT EXISTS (
                       SELECT A.DIVISION_ID
                       FROM   SCM_MGR.SCM_MST_SITE_ITEM A
                            , SCM_MGR.DM_PLN_SALES_PLAN  B
                       WHERE  SALES_PLAN_ADJUST_YN  = ''
                       AND    A.ITEM_ID             = B.ITEM_ID
                       AND    A.DIVISION_ID         = B.DIVISION_ID
                       AND    A.PROJECT_CODE        = B.PROJECT_CODE
                       AND    A.SCM_SITE_ID         = B.SCM_SITE_ID
                       AND    B.LAST_UPDATED_BY NOT IN ('SYSTEM', 'CUTOFF')
                       AND    B.YYYYMMDD           >= V_NEXT_MON_MINUS7
                       AND    A.DIVISION_ID         = W.DIVISION_ID
                       AND    A.PROJECT_CODE        = W.PROJECT_CODE
                       AND    A.SCM_SITE_ID         = W.SCM_SITE_ID
                       AND    A.ITEM_ID             = W.ITEM_ID
                   )

            ------------------------------------------------------------------------------------------------------------------------
            -- 2020/08/06   hwi1993     [C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
            ------------------------------------------------------------------------------------------------------------------------
            UNION ALL
            -- KRW 값을 계산
            SELECT /*+ FULL(W) PARALLEL(W,4) */
                   W.DIVISION_ID
                 , W.PROJECT_CODE
                 , W.SCM_SITE_ID
                 , W.ITEM_ID
                 , W.DOM_EXP
                 , W.FCST_TYPE
                 , W.INCOTERMS
                 , CASE WHEN FP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                        WHEN FP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
                   END                                                   AS MEASURE
                 , W.PLANT_SITE_ID
                 , W.YYYYMMDD
                 , FP.CURRENCY
                 --,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
                 , CASE WHEN FP.MEASURE = 'KRW' THEN CAST(TO_NUMBER(TO_CHAR(W.QTY * NVL(FP.PRICE, 0), 'FM99999999999999999999.9999999999')) AS NUMBER(30, 10))
                        WHEN FP.MEASURE = 'LOC' THEN CAST(TO_NUMBER(TO_CHAR(W.QTY * NVL(FP.PRICE, 0), 'FM99999999999999999999.9999999999')) AS NUMBER(30, 10))
                   END                                                   AS QTY
                 , NULL                                                  AS CREATED_BY
                 , NULL                                                  AS CREATION_DATE
            FROM   SCM_MGR.GT_FSPS_T_MKT_FCST W
            JOIN   SCM_MGR.GT_FSPS_T_PRICE     FP
                ON  (    FP.DIVISION_ID   = W.DIVISION_ID
                    AND  FP.PROJECT_CODE  = W.PROJECT_CODE
                    AND  FP.SCM_SITE_ID   = W.SCM_SITE_ID
                    AND  FP.ITEM_ID       = W.ITEM_ID
                    AND  FP.DOM_EXP       = W.DOM_EXP
                    AND  FP.FCST_TYPE     = W.FCST_TYPE
                    AND  FP.INCOTERMS     = W.INCOTERMS
                    AND  FP.PLANT_SITE_ID = W.PLANT_SITE_ID
                    AND  FP.YYYYMMDD      = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
                    AND  FP.MEASURE      IN ('KRW', 'LOC')
                    )
            WHERE  W.MEASURE = 'MKT_FCST';

            --COMMIT;
            DBMS_OUTPUT.PUT_LINE('G--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

            -- GTT 통계 수집
            DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_FSPS_SALES_PLAN_TEMP_LOC', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

            -- 확인용
            -- select * from GT_SYNC_SALES_PLAN_TEMP_LOC;
            -- 테이블의 중복제거
            DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN
            WHERE  EXISTS (
                       SELECT B.DIVISION_ID
                       FROM   SCM_MGR.GT_FSPS_SALES_PLAN_TEMP_LOC B
                       WHERE  1 = 1
                       AND    DM_PLN_SALES_PLAN.DIVISION_ID   = B.DIVISION_ID
                       AND    DM_PLN_SALES_PLAN.PROJECT_CODE  = B.PROJECT_CODE
                       AND    DM_PLN_SALES_PLAN.SCM_SITE_ID   = B.SCM_SITE_ID
                       AND    DM_PLN_SALES_PLAN.ITEM_ID       = B.ITEM_ID
                       AND    DM_PLN_SALES_PLAN.DOM_EXP       = B.DOM_EXP
                       AND    DM_PLN_SALES_PLAN.FCST_TYPE     = B.FCST_TYPE
                       AND    DM_PLN_SALES_PLAN.INCOTERMS     = B.INCOTERMS
                       AND    DM_PLN_SALES_PLAN.MEASURE       = B.MEASURE
                       AND    DM_PLN_SALES_PLAN.PLANT_SITE_ID = B.PLANT_SITE_ID
                       AND    DM_PLN_SALES_PLAN.YYYYMMDD      = B.YYYYMMDD
                   );

            DBMS_OUTPUT.PUT_LINE('H--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

            --20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
            --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

            INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.DM_PLN_SALES_PLAN
                (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY,
                 CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
                 ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
            SELECT /*+ FULL(T) PARALLEL(T,4) */
                   DISTINCT
                   DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY
                 , NVL(CREATED_BY, V_CREATED_BY), NVL(CREATION_DATE, SYSDATE)
                 , V_CREATED_BY, SYSDATE AS LAST_UPDATE_DATE
                 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            FROM   SCM_MGR.GT_FSPS_SALES_PLAN_TEMP_LOC T;

            N_LOG_COUNT := SQL%ROWCOUNT;
            T_LOG_COUNT := T_LOG_COUNT + N_LOG_COUNT;
            --COMMIT;
            DBMS_OUTPUT.PUT_LINE('I--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

            --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

        END IF;
        /*----------------------------- MULTI & SINGLE ROW END ---------------------------------------------------------------*/

    END LOOP;
    /*---------------------------------------------------------------*/

    -- IF @@TRANCOUNT > 0
    IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
        COMMIT;
    END IF;

    -- 종료 LOG
    IF V_LOG_MESSAGE IS NULL THEN
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := 'P_DIVISION_ID : ' || P_DIVISION_ID || ' / ' || 'V_CREATED_BY : ' || NVL(V_CREATED_BY, 'NULL');
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, T_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(T_LOG_COUNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        -- ERROR LOG VALUE SAVE
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;
        V_PROC_INPUT :=
            JSON_OBJECT(
                'P_DIVISION_ID' VALUE P_DIVISION_ID,
                'P_CREATED_BY'  VALUE P_CREATED_BY
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_MKT_FCST_SALES_PLAN_SYNC;

/* ============================================================
   DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE
   GTT DDL (별도 실행):

   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_SAVEPK_RESULTS (
       V_DIVISION_ID        VARCHAR2(400 CHAR),
       V_PROJECT_CODE       VARCHAR2(400 CHAR),
       V_SCM_SITE_ID        VARCHAR2(400 CHAR),
       V_ITEM_ID            VARCHAR2(400 CHAR),
       V_DOM_EXP            VARCHAR2(400 CHAR),
       V_FCST_TYPE          VARCHAR2(400 CHAR),
       V_INCOTERMS          VARCHAR2(400 CHAR),
       V_PLANT_SITE_ID      VARCHAR2(400 CHAR),
       V_DOM_EXP_NEW        VARCHAR2(400 CHAR),
       V_FCST_TYPE_NEW      VARCHAR2(400 CHAR),
       V_INCOTERMS_NEW      VARCHAR2(400 CHAR),
       V_PLANT_SITE_ID_NEW  VARCHAR2(400 CHAR),
       V_CREATED_BY         VARCHAR2(400 CHAR)
   ) ON COMMIT PRESERVE ROWS;
   /

   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_SAVEPK_VALID_RESULTS (
       V_DIVISION_ID   VARCHAR2(400 CHAR),
       V_PROJECT_CODE  VARCHAR2(400 CHAR),
       V_SCM_SITE_ID   VARCHAR2(400 CHAR),
       V_ITEM_ID       VARCHAR2(400 CHAR),
       V_DOM_EXP       VARCHAR2(400 CHAR),
       V_FCST_TYPE     VARCHAR2(400 CHAR),
       V_INCOTERMS     VARCHAR2(400 CHAR),
       V_PLANT_SITE_ID VARCHAR2(400 CHAR),
       V_MEASURE       VARCHAR2(400 CHAR)
   ) ON COMMIT PRESERVE ROWS;
   /
   ============================================================ */
PROCEDURE P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE
(
     P_DIVISION_ID        IN VARCHAR2
    ,P_PROJECT_CODE       IN VARCHAR2
    ,P_SCM_SITE_ID        IN VARCHAR2
    ,P_ITEM_ID            IN VARCHAR2
    ,P_DOM_EXP            IN VARCHAR2
    ,P_FCST_TYPE          IN VARCHAR2
    ,P_INCOTERMS          IN VARCHAR2
    ,P_PLANT_SITE_ID      IN VARCHAR2
    ,P_DOM_EXP_NEW        IN VARCHAR2
    ,P_FCST_TYPE_NEW      IN VARCHAR2
    ,P_INCOTERMS_NEW      IN VARCHAR2
    ,P_PLANT_SITE_ID_NEW  IN VARCHAR2
    ,P_CREATED_BY         IN VARCHAR2
    ,O_RESULT_CURSOR      OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE
 * Description  : MKT FCST 화면에서 팝업화면을 띄워서 INCOTERMS등 PK값을 수정할수 있도록 함.
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2018.05.16   KHSONG         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ---------------------------------------------------------------------------------------------------
 * 20180601 pk값 validation KHSONG
 * 20180807
 * 2020/09/09     P.C.I     [C20200909-000203] LOG 표준화 적용
 * 2021/05/04     P.C.I     [C20210504-000051] Sales Plan, Sales Price 적용 기준 변경
 * 2021.07.02 HWI1993   [C20210629-000239] [SCM PI팀] MKT FCST Amt. 추가의 건
 * 2021.08.06   hwi1993     중장기과제 -- 특정 기간동안은 2022년 데이터 수정할 수 없도록
 * 2022.11.04   rosia27     [C20221024-000510]DM UI 소스 정리 요청
 * 2022.12.07   hwi1993     [C20221205-000135] GSCM Master change 인코텀즈 변경 기능 개선
 * 2026.03.19     kimcd     [PJ20264226] NextSCM Pilot 설계 및 개발
 * ---------------------------------------------------------------------------------------------------
 */

    -- 입력 파라미터 작업용 변수 ('^' 구분자 split 처리)
    V_WRK_DIVISION_ID        VARCHAR2(400 CHAR);
    V_WRK_PROJECT_CODE       VARCHAR2(400 CHAR);
    V_WRK_SCM_SITE_ID        VARCHAR2(400 CHAR);
    V_WRK_ITEM_ID            VARCHAR2(400 CHAR);
    V_WRK_DOM_EXP            VARCHAR2(400 CHAR);
    V_WRK_FCST_TYPE          VARCHAR2(400 CHAR);
    V_WRK_INCOTERMS          VARCHAR2(400 CHAR);
    V_WRK_PLANT_SITE_ID      VARCHAR2(400 CHAR);
    V_WRK_DOM_EXP_NEW        VARCHAR2(400 CHAR);
    V_WRK_FCST_TYPE_NEW      VARCHAR2(400 CHAR);
    V_WRK_INCOTERMS_NEW      VARCHAR2(400 CHAR);
    V_WRK_PLANT_SITE_ID_NEW  VARCHAR2(400 CHAR);
    V_WRK_CREATED_BY         VARCHAR2(400 CHAR);

    -- split 처리용 파라미터 잔여 버퍼
    LV_DIVISION_ID        VARCHAR2(32767 CHAR);
    LV_PROJECT_CODE       VARCHAR2(32767 CHAR);
    LV_SCM_SITE_ID        VARCHAR2(32767 CHAR);
    LV_ITEM_ID            VARCHAR2(32767 CHAR);
    LV_DOM_EXP            VARCHAR2(32767 CHAR);
    LV_FCST_TYPE          VARCHAR2(32767 CHAR);
    LV_INCOTERMS          VARCHAR2(32767 CHAR);
    LV_PLANT_SITE_ID      VARCHAR2(32767 CHAR);
    LV_DOM_EXP_NEW        VARCHAR2(32767 CHAR);
    LV_FCST_TYPE_NEW      VARCHAR2(32767 CHAR);
    LV_INCOTERMS_NEW      VARCHAR2(32767 CHAR);
    LV_PLANT_SITE_ID_NEW  VARCHAR2(32767 CHAR);
    LV_CREATED_BY         VARCHAR2(32767 CHAR);

    INDEX_DIV             PLS_INTEGER;

    -- 커서 루프용 변수
    M_DIVISION_ID   VARCHAR2(400 CHAR);
    M_SCM_SITE_ID   VARCHAR2(400 CHAR);
    M_PROJECT_CODE  VARCHAR2(400 CHAR);

    -- SCM_MST_FUTURE_PRICE validation 변수
    S_FUTURE_VALID       VARCHAR2(400 CHAR);
    S_UNIT_PRICE_VALID   VARCHAR2(400 CHAR);

    -- 당주 월요일 - 7일 기준 일자 (반복 계산 방지)
    V_NEXT_MON_MINUS7    VARCHAR2(8 CHAR);

    -- LOG 용 변수 설정
    $$PLSQL_UNIT  VARCHAR2(200) := $$PLSQL_UNIT;
    V_LOG_TYPE      VARCHAR2(30   CHAR);  -- START/END/ERROR/...
    N_LOG_COUNT     PLS_INTEGER   := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500  CHAR);
    D_EVENT_DATE    DATE;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);

    -- Validation 조기 종료 예외
    EX_INVALID      EXCEPTION;
    V_INVALID_MSG   VARCHAR2(4000 CHAR);

    -- 커서 선언: CURSOR1_MST
    CURSOR CURSOR1_MST IS
        SELECT V_DIVISION_ID, V_SCM_SITE_ID, V_PROJECT_CODE
        FROM   SCM_MGR.GT_SAVEPK_RESULTS
        WHERE  1 = 1
        GROUP BY V_DIVISION_ID, V_SCM_SITE_ID, V_PROJECT_CODE;

BEGIN
    -- SESSION 설정
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DDL';
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL QUERY';
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- GTT TRUNCATE
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_SAVEPK_RESULTS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_SAVEPK_VALID_RESULTS';

    -- 당주 월요일 기준 사전 계산
    SELECT TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
    INTO   V_NEXT_MON_MINUS7
    FROM   DUAL;

    -- 마지막 데이터 처리를 위한 구분자 추가
    LV_DIVISION_ID       := RTRIM(P_DIVISION_ID      ) || '^';
    LV_PROJECT_CODE      := RTRIM(P_PROJECT_CODE     ) || '^';
    LV_SCM_SITE_ID       := RTRIM(P_SCM_SITE_ID      ) || '^';
    LV_ITEM_ID           := RTRIM(P_ITEM_ID           ) || '^';
    LV_DOM_EXP           := RTRIM(P_DOM_EXP           ) || '^';
    LV_FCST_TYPE         := RTRIM(P_FCST_TYPE         ) || '^';
    LV_INCOTERMS         := RTRIM(P_INCOTERMS         ) || '^';
    LV_PLANT_SITE_ID     := RTRIM(P_PLANT_SITE_ID     ) || '^';
    LV_DOM_EXP_NEW       := RTRIM(P_DOM_EXP_NEW       ) || '^';
    LV_FCST_TYPE_NEW     := RTRIM(P_FCST_TYPE_NEW     ) || '^';
    LV_INCOTERMS_NEW     := RTRIM(P_INCOTERMS_NEW     ) || '^';
    LV_PLANT_SITE_ID_NEW := RTRIM(P_PLANT_SITE_ID_NEW ) || '^';
    LV_CREATED_BY        := RTRIM(P_CREATED_BY        ) || '^';

    --###############################################  GT_SAVEPK_RESULTS 테이블에 split후 insert (START)
    WHILE LENGTH(LV_DIVISION_ID) > 0
    LOOP
        INDEX_DIV := INSTR(LV_DIVISION_ID, '^');

        IF INDEX_DIV > 0 THEN
            V_WRK_DIVISION_ID       := SUBSTR(LV_DIVISION_ID,       1, INDEX_DIV - 1);
            V_WRK_PROJECT_CODE      := SUBSTR(LV_PROJECT_CODE,      1, INSTR(LV_PROJECT_CODE,      '^') - 1);
            V_WRK_SCM_SITE_ID       := SUBSTR(LV_SCM_SITE_ID,       1, INSTR(LV_SCM_SITE_ID,       '^') - 1);
            V_WRK_ITEM_ID           := SUBSTR(LV_ITEM_ID,           1, INSTR(LV_ITEM_ID,           '^') - 1);
            V_WRK_DOM_EXP           := SUBSTR(LV_DOM_EXP,           1, INSTR(LV_DOM_EXP,           '^') - 1);
            V_WRK_FCST_TYPE         := SUBSTR(LV_FCST_TYPE,         1, INSTR(LV_FCST_TYPE,         '^') - 1);
            V_WRK_INCOTERMS         := SUBSTR(LV_INCOTERMS,         1, INSTR(LV_INCOTERMS,         '^') - 1);
            V_WRK_PLANT_SITE_ID     := SUBSTR(LV_PLANT_SITE_ID,     1, INSTR(LV_PLANT_SITE_ID,     '^') - 1);
            V_WRK_DOM_EXP_NEW       := SUBSTR(LV_DOM_EXP_NEW,       1, INSTR(LV_DOM_EXP_NEW,       '^') - 1);
            V_WRK_FCST_TYPE_NEW     := SUBSTR(LV_FCST_TYPE_NEW,     1, INSTR(LV_FCST_TYPE_NEW,     '^') - 1);
            V_WRK_INCOTERMS_NEW     := SUBSTR(LV_INCOTERMS_NEW,     1, INSTR(LV_INCOTERMS_NEW,     '^') - 1);
            V_WRK_PLANT_SITE_ID_NEW := SUBSTR(LV_PLANT_SITE_ID_NEW, 1, INSTR(LV_PLANT_SITE_ID_NEW, '^') - 1);
            V_WRK_CREATED_BY        := SUBSTR(LV_CREATED_BY,        1, INSTR(LV_CREATED_BY,        '^') - 1);

            LV_DIVISION_ID       := SUBSTR(LV_DIVISION_ID,       LENGTH(V_WRK_DIVISION_ID       || '^') + 1);
            LV_PROJECT_CODE      := SUBSTR(LV_PROJECT_CODE,      LENGTH(V_WRK_PROJECT_CODE      || '^') + 1);
            LV_SCM_SITE_ID       := SUBSTR(LV_SCM_SITE_ID,       LENGTH(V_WRK_SCM_SITE_ID       || '^') + 1);
            LV_ITEM_ID           := SUBSTR(LV_ITEM_ID,           LENGTH(V_WRK_ITEM_ID           || '^') + 1);
            LV_DOM_EXP           := SUBSTR(LV_DOM_EXP,           LENGTH(V_WRK_DOM_EXP           || '^') + 1);
            LV_FCST_TYPE         := SUBSTR(LV_FCST_TYPE,         LENGTH(V_WRK_FCST_TYPE         || '^') + 1);
            LV_INCOTERMS         := SUBSTR(LV_INCOTERMS,         LENGTH(V_WRK_INCOTERMS         || '^') + 1);
            LV_PLANT_SITE_ID     := SUBSTR(LV_PLANT_SITE_ID,     LENGTH(V_WRK_PLANT_SITE_ID     || '^') + 1);
            LV_DOM_EXP_NEW       := SUBSTR(LV_DOM_EXP_NEW,       LENGTH(V_WRK_DOM_EXP_NEW       || '^') + 1);
            LV_FCST_TYPE_NEW     := SUBSTR(LV_FCST_TYPE_NEW,     LENGTH(V_WRK_FCST_TYPE_NEW     || '^') + 1);
            LV_INCOTERMS_NEW     := SUBSTR(LV_INCOTERMS_NEW,     LENGTH(V_WRK_INCOTERMS_NEW     || '^') + 1);
            LV_PLANT_SITE_ID_NEW := SUBSTR(LV_PLANT_SITE_ID_NEW, LENGTH(V_WRK_PLANT_SITE_ID_NEW || '^') + 1);
            LV_CREATED_BY        := SUBSTR(LV_CREATED_BY,        LENGTH(V_WRK_CREATED_BY        || '^') + 1);
        ELSE
            V_WRK_DIVISION_ID := LV_DIVISION_ID;
            LV_DIVISION_ID    := NULL;
        END IF;

        -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (START)
        IF V_WRK_DOM_EXP_NEW       IS NULL OR V_WRK_DOM_EXP_NEW       = '' THEN V_WRK_DOM_EXP_NEW       := V_WRK_DOM_EXP;       END IF;
        IF V_WRK_FCST_TYPE_NEW     IS NULL OR V_WRK_FCST_TYPE_NEW     = '' THEN V_WRK_FCST_TYPE_NEW     := V_WRK_FCST_TYPE;     END IF;
        IF V_WRK_INCOTERMS_NEW     IS NULL OR V_WRK_INCOTERMS_NEW     = '' THEN V_WRK_INCOTERMS_NEW     := V_WRK_INCOTERMS;     END IF;
        IF V_WRK_PLANT_SITE_ID_NEW IS NULL OR V_WRK_PLANT_SITE_ID_NEW = '' THEN V_WRK_PLANT_SITE_ID_NEW := V_WRK_PLANT_SITE_ID; END IF;
        -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (END)

        INSERT INTO SCM_MGR.GT_SAVEPK_RESULTS (
              V_DIVISION_ID
             ,V_PROJECT_CODE
             ,V_SCM_SITE_ID
             ,V_ITEM_ID
             ,V_DOM_EXP
             ,V_FCST_TYPE
             ,V_INCOTERMS
             ,V_PLANT_SITE_ID
             ,V_DOM_EXP_NEW
             ,V_FCST_TYPE_NEW
             ,V_INCOTERMS_NEW
             ,V_PLANT_SITE_ID_NEW
             ,V_CREATED_BY
        ) VALUES (
              V_WRK_DIVISION_ID
             ,V_WRK_PROJECT_CODE
             ,V_WRK_SCM_SITE_ID
             ,V_WRK_ITEM_ID
             ,V_WRK_DOM_EXP
             ,V_WRK_FCST_TYPE
             ,V_WRK_INCOTERMS
             ,V_WRK_PLANT_SITE_ID
             ,V_WRK_DOM_EXP_NEW
             ,V_WRK_FCST_TYPE_NEW
             ,V_WRK_INCOTERMS_NEW
             ,V_WRK_PLANT_SITE_ID_NEW
             ,V_WRK_CREATED_BY
        );

    END LOOP;
    --###############################################  GT_SAVEPK_RESULTS 테이블에 split후 insert (END)

    --COMMIT;

    -- GTT 통계 수집
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SAVEPK_RESULTS', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

    ----------------------------------------------------------------------------------------------- 신규 parameter 값으로 pk validation (start)
    DECLARE
        V_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT NVL(COUNT(1), 0)
        INTO   V_CNT
        FROM   SCM_MGR.DM_PLN_MKT_FCST
        WHERE  DIVISION_ID  = V_WRK_DIVISION_ID
        AND    PROJECT_CODE = V_WRK_PROJECT_CODE;

        IF V_CNT = 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_INVALID_MSG := '[' || V_WRK_PROJECT_CODE || '] Invalid Project Code !';
            RAISE EX_INVALID;
        END IF;
    END;

    -- 22년 데이터가 있고, 소형이고 , 마감이 되었다면 수정내역 취소
    DECLARE
        V_CHK PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1)
        INTO   V_CHK
        FROM   DUAL
        WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_SAVEPK_RESULTS WHERE V_DIVISION_ID = '40')
        AND    EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE  LOOKUP_TYPE = 'DM_LONG_PLAN'
                   AND    SEGMENT1    = '40'
                   AND    ATTRIBUTE1  = 'Y'   -- 마감여부
                   AND    VALID_YN    = 'Y'
               )
        AND    EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_SAVEPK_RESULTS A
                   JOIN   SCM_MGR.DM_PLN_MKT_FCST    B
                       ON  A.V_DIVISION_ID   = B.DIVISION_ID
                       AND A.V_PROJECT_CODE  = B.PROJECT_CODE
                       AND A.V_SCM_SITE_ID   = B.SCM_SITE_ID
                       AND A.V_ITEM_ID       = B.ITEM_ID
                       AND A.V_DOM_EXP       = B.DOM_EXP
                       AND A.V_FCST_TYPE     = B.FCST_TYPE
                       AND A.V_INCOTERMS     = B.INCOTERMS
                       AND A.V_PLANT_SITE_ID = B.PLANT_SITE_ID
                   WHERE  B.YYYYMMDD >= '20220101'
                   AND    B.MEASURE  IN ('MKT_FCST', 'RTF', 'RTF_SYS_RP', 'VMI_IN_REQ')
               );

        IF V_CHK > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_INVALID_MSG := '2022년 데이터가 있는 마스터는 변경할 수 없습니다.';
            RAISE EX_INVALID;
        END IF;
    END;
    ----------------------------------------------------------------------------------------------- 신규 parameter 값으로 pk validation (end)

    -- 속도개선 cursor 구조로 변경
    DELETE FROM SCM_MGR.GT_SAVEPK_VALID_RESULTS;
    -- COMMIT;

    -- CURSOR1_MST LOOP
    FOR REC IN CURSOR1_MST
    LOOP
        M_DIVISION_ID  := REC.V_DIVISION_ID;
        M_SCM_SITE_ID  := REC.V_SCM_SITE_ID;
        M_PROJECT_CODE := REC.V_PROJECT_CODE;

        ---------------------------------------------------------------------------------------- WHILE_1 LOOP START
        ----------------------------------------------------------------------------------------------- 20180601 pk값 validation (start)
        --BEGIN
            --BEGIN TRANSACTION PK_UPDATE_01
            -- 신규 update 할 값이 값이 0 인 것이 있으면 삭제 처리 함. (start)
            DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
            WHERE  EXISTS (
                       SELECT V_DIVISION_ID
                       FROM   SCM_MGR.GT_SAVEPK_RESULTS X
                       WHERE  X.V_DIVISION_ID       = DM_PLN_MKT_FCST.DIVISION_ID
                       AND    X.V_PROJECT_CODE      = DM_PLN_MKT_FCST.PROJECT_CODE
                       AND    X.V_SCM_SITE_ID       = DM_PLN_MKT_FCST.SCM_SITE_ID
                       AND    X.V_ITEM_ID           = DM_PLN_MKT_FCST.ITEM_ID
                       AND    X.V_DOM_EXP_NEW       = DM_PLN_MKT_FCST.DOM_EXP
                       AND    X.V_FCST_TYPE_NEW     = DM_PLN_MKT_FCST.FCST_TYPE
                       AND    X.V_INCOTERMS_NEW     = DM_PLN_MKT_FCST.INCOTERMS
                       AND    X.V_PLANT_SITE_ID_NEW = DM_PLN_MKT_FCST.PLANT_SITE_ID
                   )
            AND    QTY         = 0
            AND    YYYYMMDD   >= V_NEXT_MON_MINUS7   -- 당주월요일 이후 데이터를 대상으로 함
            AND    DIVISION_ID = M_DIVISION_ID
            AND    SCM_SITE_ID = M_SCM_SITE_ID
            AND    PROJECT_CODE = M_PROJECT_CODE;
            -- 신규 update 할 값이 값이 0 인 것이 있으면 삭제 처리 함. (end)
            --COMMIT TRANSACTION PK_UPDATE_01
        --END

            -- 20181108 (start)
            DELETE FROM SCM_MGR.SCM_MST_FUTURE_PRICE
            WHERE  EXISTS (
                       SELECT V_DIVISION_ID
                       FROM   SCM_MGR.GT_SAVEPK_RESULTS X
                       WHERE  X.V_DIVISION_ID       = SCM_MST_FUTURE_PRICE.DIVISION_ID
                       AND    X.V_PROJECT_CODE      = SCM_MST_FUTURE_PRICE.PROJECT_CODE
                       AND    X.V_SCM_SITE_ID       = SCM_MST_FUTURE_PRICE.SCM_SITE_ID
                       AND    X.V_ITEM_ID           = SCM_MST_FUTURE_PRICE.ITEM_ID
                       AND    X.V_DOM_EXP_NEW       = SCM_MST_FUTURE_PRICE.DOM_EXP
                       AND    X.V_FCST_TYPE_NEW     = SCM_MST_FUTURE_PRICE.FCST_TYPE
                       AND    X.V_INCOTERMS_NEW     = SCM_MST_FUTURE_PRICE.INCOTERMS
                       AND    X.V_PLANT_SITE_ID_NEW = SCM_MST_FUTURE_PRICE.PLANT_SITE_ID
                       --[C20210504-000051] 변경 전 fcst type이 유상인 경우에만 변경 후 Sales Price 삭제
                       AND    X.V_FCST_TYPE NOT IN (
                                  SELECT SEGMENT2
                                  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                  WHERE  1 = 1
                                  AND    MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                                  AND    MST.SEGMENT1    = 'FCST_TYPE'
                                  AND    VALID_YN        = 'Y'
                              )
                   )
            --and PRICE = 0 --[C20210504-000051] Sales Price 적용 기준 변경
            AND    YYYYMMDD    >= V_NEXT_MON_MINUS7   -- 당주월요일 이후 데이터를 대상으로 함
            AND    DIVISION_ID  = M_DIVISION_ID
            AND    SCM_SITE_ID  = M_SCM_SITE_ID
            AND    PROJECT_CODE = M_PROJECT_CODE;
            -- 20181108 (END)

            --[C20210504-000051] 변경 후 fcst type이 무상인 경우에 Sales Plan의 SalesAMT 삭제
            DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN
            WHERE  EXISTS (
                       SELECT V_DIVISION_ID
                       FROM   SCM_MGR.GT_SAVEPK_RESULTS X
                       WHERE  X.V_DIVISION_ID   = DM_PLN_SALES_PLAN.DIVISION_ID
                       AND    X.V_PROJECT_CODE  = DM_PLN_SALES_PLAN.PROJECT_CODE
                       AND    X.V_SCM_SITE_ID   = DM_PLN_SALES_PLAN.SCM_SITE_ID
                       AND    X.V_ITEM_ID       = DM_PLN_SALES_PLAN.ITEM_ID
                       AND    X.V_DOM_EXP       = DM_PLN_SALES_PLAN.DOM_EXP
                       AND    X.V_FCST_TYPE     = DM_PLN_SALES_PLAN.FCST_TYPE
                       AND    X.V_INCOTERMS     = DM_PLN_SALES_PLAN.INCOTERMS
                       AND    X.V_PLANT_SITE_ID = DM_PLN_SALES_PLAN.PLANT_SITE_ID
                       --[C20210504-000051] 변경 후 fcst type이 무상인 경우에 Sales Plan의 SalesAMT 삭제
                       AND    X.V_FCST_TYPE_NEW IN (
                                  SELECT SEGMENT2
                                  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                  WHERE  1 = 1
                                  AND    MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                                  AND    MST.SEGMENT1    = 'FCST_TYPE'
                                  AND    VALID_YN        = 'Y'
                              )
                   )
            AND    YYYYMMDD    >= V_NEXT_MON_MINUS7   -- 당주월요일 이후 데이터를 대상으로 함
            AND    DIVISION_ID  = M_DIVISION_ID
            AND    SCM_SITE_ID  = M_SCM_SITE_ID
            AND    PROJECT_CODE = M_PROJECT_CODE
            AND    MEASURE IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'MKT_AMT_KRW', 'MKT_AMT_LOC');

            -- 입력된 MASTER 정보로 MEASURE 추출 (start)
            INSERT INTO SCM_MGR.GT_SAVEPK_VALID_RESULTS
                SELECT   A.DIVISION_ID
                        ,A.PROJECT_CODE
                        ,A.SCM_SITE_ID
                        ,A.ITEM_ID
                        ,A.DOM_EXP
                        ,A.FCST_TYPE
                        ,A.INCOTERMS
                        ,A.PLANT_SITE_ID
                        ,A.MEASURE
                FROM   SCM_MGR.DM_PLN_MKT_FCST A
                     , SCM_MGR.GT_SAVEPK_RESULTS RSLT
                WHERE  A.DIVISION_ID   = RSLT.V_DIVISION_ID
                AND    A.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                AND    A.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                AND    A.ITEM_ID       = RSLT.V_ITEM_ID
                AND    A.DOM_EXP       = RSLT.V_DOM_EXP_NEW
                AND    A.FCST_TYPE     = RSLT.V_FCST_TYPE_NEW
                AND    A.INCOTERMS     = RSLT.V_INCOTERMS_NEW
                AND    A.PLANT_SITE_ID = RSLT.V_PLANT_SITE_ID_NEW
                AND    A.YYYYMMDD     >= V_NEXT_MON_MINUS7   -- 당주월요일 이후 데이터를 대상으로 함
                AND    A.DIVISION_ID   = M_DIVISION_ID
                AND    A.SCM_SITE_ID   = M_SCM_SITE_ID
                AND    A.PROJECT_CODE  = M_PROJECT_CODE
                AND    RSLT.V_DIVISION_ID  = M_DIVISION_ID
                AND    RSLT.V_SCM_SITE_ID  = M_SCM_SITE_ID
                AND    RSLT.V_PROJECT_CODE = M_PROJECT_CODE
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID,
                         A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.MEASURE

                UNION

                SELECT   A.DIVISION_ID
                        ,A.PROJECT_CODE
                        ,A.SCM_SITE_ID
                        ,A.ITEM_ID
                        ,A.DOM_EXP
                        ,A.FCST_TYPE
                        ,A.INCOTERMS
                        ,A.PLANT_SITE_ID
                        ,A.MEASURE
                FROM   SCM_MGR.DM_PLN_MKT_FCST A
                     , SCM_MGR.GT_SAVEPK_RESULTS RSLT
                WHERE  A.DIVISION_ID   = RSLT.V_DIVISION_ID
                AND    A.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                AND    A.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                AND    A.ITEM_ID       = RSLT.V_ITEM_ID
                AND    A.DOM_EXP       = RSLT.V_DOM_EXP
                AND    A.FCST_TYPE     = RSLT.V_FCST_TYPE
                AND    A.INCOTERMS     = RSLT.V_INCOTERMS
                AND    A.PLANT_SITE_ID = RSLT.V_PLANT_SITE_ID
                AND    A.YYYYMMDD     >= V_NEXT_MON_MINUS7   -- 당주월요일 이후 데이터를 대상으로 함
                AND    A.DIVISION_ID   = M_DIVISION_ID
                AND    A.SCM_SITE_ID   = M_SCM_SITE_ID
                AND    A.PROJECT_CODE  = M_PROJECT_CODE
                AND    RSLT.V_DIVISION_ID  = M_DIVISION_ID
                AND    RSLT.V_SCM_SITE_ID  = M_SCM_SITE_ID
                AND    RSLT.V_PROJECT_CODE = M_PROJECT_CODE
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID,
                         A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.MEASURE;
            -- 입력된 MASTER 정보로 MEASURE 추출 (end)

            --COMMIT;
            DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SAVEPK_VALID_RESULTS', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

            -- DM_PLN_MKT_FCST 테이블에서 당주월요일 이후 데이터가 존재하는지 체크 (start)
            DECLARE
                V_DUP_CNT PLS_INTEGER := 0;
            BEGIN
                SELECT COUNT(1)
                INTO   V_DUP_CNT
                FROM   SCM_MGR.DM_PLN_MKT_FCST
                WHERE  EXISTS (
                           SELECT 1
                           FROM   SCM_MGR.GT_SAVEPK_VALID_RESULTS RSLT
                           WHERE  RSLT.V_DIVISION_ID   = DM_PLN_MKT_FCST.DIVISION_ID
                           AND    RSLT.V_PROJECT_CODE  = DM_PLN_MKT_FCST.PROJECT_CODE
                           AND    RSLT.V_SCM_SITE_ID   = DM_PLN_MKT_FCST.SCM_SITE_ID
                           AND    RSLT.V_ITEM_ID       = DM_PLN_MKT_FCST.ITEM_ID
                           AND    RSLT.V_DOM_EXP       = DM_PLN_MKT_FCST.DOM_EXP
                           AND    RSLT.V_FCST_TYPE     = DM_PLN_MKT_FCST.FCST_TYPE
                           AND    RSLT.V_INCOTERMS     = DM_PLN_MKT_FCST.INCOTERMS
                           AND    RSLT.V_PLANT_SITE_ID = DM_PLN_MKT_FCST.PLANT_SITE_ID
                           AND    RSLT.V_MEASURE       = DM_PLN_MKT_FCST.MEASURE
                           AND    DM_PLN_MKT_FCST.YYYYMMDD >= V_NEXT_MON_MINUS7   -- 당주월요일 이후 데이터를 대상으로 함
                           AND    RSLT.V_DIVISION_ID   = M_DIVISION_ID
                           AND    RSLT.V_SCM_SITE_ID   = M_SCM_SITE_ID
                           AND    RSLT.V_PROJECT_CODE  = M_PROJECT_CODE
                           GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID,
                                    V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID
                           HAVING COUNT(*) > 1
                       )
                AND    DIVISION_ID  = M_DIVISION_ID
                AND    SCM_SITE_ID  = M_SCM_SITE_ID
                AND    PROJECT_CODE = M_PROJECT_CODE;

                IF V_DUP_CNT > 0 THEN
                    V_LOG_TYPE    := 'INVALID';
                    V_INVALID_MSG := '이미 존재하는 Project,site,model 정보입니다.';
                    RAISE EX_INVALID;
                END IF;
            END;
            ----------------------------------------------------------------------------------------------- 20180601 pk값 validation (end)

                -- DM_PLN_MKT_FCST UPDATE
                --BEGIN TRANSACTION PK_UPDATE_02
                MERGE INTO SCM_MGR.DM_PLN_MKT_FCST A
                USING (
                        SELECT A.ROWID                  AS RID
                              ,B.V_DOM_EXP_NEW
                              ,B.V_FCST_TYPE_NEW
                              ,B.V_INCOTERMS_NEW
                              ,B.V_PLANT_SITE_ID_NEW
                              ,B.V_CREATED_BY
                        FROM   SCM_MGR.DM_PLN_MKT_FCST       A
                        JOIN   SCM_MGR.GT_SAVEPK_RESULTS      B
                            ON  B.V_DIVISION_ID   = A.DIVISION_ID
                            AND B.V_PROJECT_CODE  = A.PROJECT_CODE
                            AND B.V_SCM_SITE_ID   = A.SCM_SITE_ID
                            AND B.V_ITEM_ID       = A.ITEM_ID
                            AND B.V_DOM_EXP       = A.DOM_EXP
                            AND B.V_FCST_TYPE     = A.FCST_TYPE
                            AND B.V_INCOTERMS     = A.INCOTERMS
                            AND B.V_PLANT_SITE_ID = A.PLANT_SITE_ID
                        WHERE  A.YYYYMMDD        >= V_NEXT_MON_MINUS7   -- 당주월요일 이후 데이터를 대상으로 함
                        AND    A.DIVISION_ID      = M_DIVISION_ID
                        AND    A.SCM_SITE_ID      = M_SCM_SITE_ID
                        AND    A.PROJECT_CODE     = M_PROJECT_CODE
                        AND    B.V_DIVISION_ID    = M_DIVISION_ID
                        AND    B.V_SCM_SITE_ID    = M_SCM_SITE_ID
                        AND    B.V_PROJECT_CODE   = M_PROJECT_CODE
                      ) B
                ON ( A.ROWID = B.RID )
                WHEN MATCHED THEN
                    UPDATE SET A.DOM_EXP          = B.V_DOM_EXP_NEW
                              ,A.FCST_TYPE        = B.V_FCST_TYPE_NEW
                              ,A.INCOTERMS        = B.V_INCOTERMS_NEW
                              ,A.PLANT_SITE_ID    = B.V_PLANT_SITE_ID_NEW
                              ,A.LAST_UPDATED_BY  = B.V_CREATED_BY
                              ,A.LAST_UPDATE_DATE = SYSDATE;

                -- DM_PLN_SALES_PLAN UPDATE
                MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN A
                USING (
                        SELECT A.ROWID                  AS RID
                              ,B.V_DOM_EXP_NEW
                              ,B.V_FCST_TYPE_NEW
                              ,B.V_INCOTERMS_NEW
                              ,B.V_PLANT_SITE_ID_NEW
                              ,B.V_CREATED_BY
                        FROM   SCM_MGR.DM_PLN_SALES_PLAN      A
                        JOIN   SCM_MGR.GT_SAVEPK_RESULTS       B
                            ON  B.V_DIVISION_ID   = A.DIVISION_ID
                            AND B.V_PROJECT_CODE  = A.PROJECT_CODE
                            AND B.V_SCM_SITE_ID   = A.SCM_SITE_ID
                            AND B.V_ITEM_ID       = A.ITEM_ID
                            AND B.V_DOM_EXP       = A.DOM_EXP
                            AND B.V_FCST_TYPE     = A.FCST_TYPE
                            AND B.V_INCOTERMS     = A.INCOTERMS
                            AND B.V_PLANT_SITE_ID = A.PLANT_SITE_ID
                        WHERE  A.YYYYMMDD        >= V_NEXT_MON_MINUS7   -- 당주월요일 이후 데이터를 대상으로 함
                        AND    A.DIVISION_ID      = M_DIVISION_ID
                        AND    A.SCM_SITE_ID      = M_SCM_SITE_ID
                        AND    A.PROJECT_CODE     = M_PROJECT_CODE
                        AND    B.V_DIVISION_ID    = M_DIVISION_ID
                        AND    B.V_SCM_SITE_ID    = M_SCM_SITE_ID
                        AND    B.V_PROJECT_CODE   = M_PROJECT_CODE
                      ) B
                ON ( A.ROWID = B.RID )
                WHEN MATCHED THEN
                    UPDATE SET A.DOM_EXP          = B.V_DOM_EXP_NEW
                              ,A.FCST_TYPE        = B.V_FCST_TYPE_NEW
                              ,A.INCOTERMS        = B.V_INCOTERMS_NEW
                              ,A.PLANT_SITE_ID    = B.V_PLANT_SITE_ID_NEW
                              ,A.LAST_UPDATED_BY  = B.V_CREATED_BY
                              ,A.LAST_UPDATE_DATE = SYSDATE;

                --[C20210504-000051] 변경 전 fcst type이 무상인 경우에 SalesAMT 생성
                INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                    , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
                    , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
                -- KRW 값을 계산
                SELECT   W.DIVISION_ID
                        ,W.PROJECT_CODE
                        ,W.SCM_SITE_ID
                        ,W.ITEM_ID
                        ,W.DOM_EXP
                        ,W.FCST_TYPE
                        ,W.INCOTERMS
                        ,'SalesAmt_KRW'  AS MEASURE
                        ,W.PLANT_SITE_ID
                        ,W.YYYYMMDD
                        ,FP.CURRENCY
                        ,CAST(TO_NUMBER(TO_CHAR(W.QTY * NVL(FP.PRICE, 0), 'FM99999999999999999999.9999999999')) AS NUMBER(30, 10))
                        ,V_WRK_CREATED_BY
                        ,SYSDATE
                        ,'SYSTEM'
                        ,SYSDATE
                        ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL -- ATTRIBUTE1~10
                FROM   SCM_MGR.DM_PLN_MKT_FCST W
                INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M  SC
                    ON      SC.BASIS_YYYYMMDD = W.YYYYMMDD
                LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE FP
                    ON (    FP.DIVISION_ID   = W.DIVISION_ID
                        AND FP.PROJECT_CODE  = W.PROJECT_CODE
                        AND FP.SCM_SITE_ID   = W.SCM_SITE_ID
                        AND FP.ITEM_ID       = W.ITEM_ID
                        AND FP.DOM_EXP       = W.DOM_EXP
                        AND FP.FCST_TYPE     = W.FCST_TYPE
                        AND FP.INCOTERMS     = W.INCOTERMS
                        AND FP.PLANT_SITE_ID = W.PLANT_SITE_ID
                        AND FP.YYYYMMDD      = SC.BASIS_START_DATE
                        AND FP.MEASURE       = 'KRW'
                       )
                WHERE  W.MEASURE      = 'RTF_SYS_RP'
                AND    W.YYYYMMDD    >= V_NEXT_MON_MINUS7
                AND    W.DIVISION_ID  = M_DIVISION_ID
                AND    W.SCM_SITE_ID  = M_SCM_SITE_ID
                AND    W.PROJECT_CODE = M_PROJECT_CODE
                AND    W.ITEM_ID IN (SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN GROUP BY ITEM_ID)
                AND    (
                           SELECT COUNT(1)
                           FROM   SCM_MGR.SCM_MST_SITE_ITEM A
                                , SCM_MGR.DM_PLN_SALES_PLAN  B
                           WHERE  SALES_PLAN_ADJUST_YN = ''
                           AND    A.ITEM_ID       = B.ITEM_ID
                           AND    A.DIVISION_ID   = B.DIVISION_ID
                           AND    A.PROJECT_CODE  = B.PROJECT_CODE
                           AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                           AND    B.LAST_UPDATED_BY NOT IN ('SYSTEM', 'CUTOFF')
                           AND    B.YYYYMMDD      >= V_NEXT_MON_MINUS7
                           AND    A.DIVISION_ID   = W.DIVISION_ID
                           AND    A.PROJECT_CODE  = W.PROJECT_CODE
                           AND    A.SCM_SITE_ID   = W.SCM_SITE_ID
                           AND    A.ITEM_ID       = W.ITEM_ID
                       ) = 0
                AND    EXISTS (
                           SELECT V_DIVISION_ID
                           FROM   SCM_MGR.GT_SAVEPK_RESULTS
                           WHERE  1 = 1
                           AND    W.DIVISION_ID   = V_DIVISION_ID
                           AND    W.PROJECT_CODE  = V_PROJECT_CODE
                           AND    W.SCM_SITE_ID   = V_SCM_SITE_ID
                           AND    W.ITEM_ID       = V_ITEM_ID
                           AND    W.PLANT_SITE_ID = NVL(V_PLANT_SITE_ID, '')
                           AND    W.DOM_EXP       = V_DOM_EXP_NEW
                           AND    W.FCST_TYPE     = V_FCST_TYPE_NEW
                           AND    W.INCOTERMS     = V_INCOTERMS_NEW
                           --[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
                           AND    V_FCST_TYPE IN (
                                      SELECT SEGMENT2
                                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                      WHERE  1 = 1
                                      AND    MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                                      AND    MST.SEGMENT1    = 'FCST_TYPE'
                                      AND    VALID_YN        = 'Y'
                                  )
                           --AND v_fcst_type_new not in (SELECT SEGMENT2
                           --               FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
                           --               WHERE 1=1
                           --               AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                           --               AND MST.SEGMENT1    = 'FCST_TYPE'
                           --               AND VALID_YN        = 'Y'  )
                       )

                UNION ALL
                -- LOC 값을 계산
                SELECT   W.DIVISION_ID
                        ,W.PROJECT_CODE
                        ,W.SCM_SITE_ID
                        ,W.ITEM_ID
                        ,W.DOM_EXP
                        ,W.FCST_TYPE
                        ,W.INCOTERMS
                        ,'SalesAmt_LOC'  AS MEASURE
                        ,W.PLANT_SITE_ID
                        ,W.YYYYMMDD
                        ,FP.CURRENCY
                        ,CAST(TO_NUMBER(TO_CHAR(W.QTY * NVL(FP.PRICE, 0), 'FM99999999999999999999.9999999999')) AS NUMBER(30, 10))
                        ,V_WRK_CREATED_BY
                        ,SYSDATE
                        ,'SYSTEM'
                        ,SYSDATE
                        ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL -- ATTRIBUTE1~10
                FROM   SCM_MGR.DM_PLN_MKT_FCST W
                INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M SC
                    ON     SC.BASIS_YYYYMMDD = W.YYYYMMDD
                LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE FP
                    ON (    FP.DIVISION_ID   = W.DIVISION_ID
                        AND FP.PROJECT_CODE  = W.PROJECT_CODE
                        AND FP.SCM_SITE_ID   = W.SCM_SITE_ID
                        AND FP.ITEM_ID       = W.ITEM_ID
                        AND FP.DOM_EXP       = W.DOM_EXP
                        AND FP.FCST_TYPE     = W.FCST_TYPE
                        AND FP.INCOTERMS     = W.INCOTERMS
                        AND FP.PLANT_SITE_ID = W.PLANT_SITE_ID
                        AND FP.YYYYMMDD      = SC.BASIS_START_DATE
                        AND FP.MEASURE       = 'LOC'
                       )
                WHERE  W.MEASURE      = 'RTF_SYS_RP'
                AND    W.YYYYMMDD    >= V_NEXT_MON_MINUS7
                AND    W.DIVISION_ID  = M_DIVISION_ID
                AND    W.SCM_SITE_ID  = M_SCM_SITE_ID
                AND    W.PROJECT_CODE = M_PROJECT_CODE
                AND    W.ITEM_ID IN (SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN GROUP BY ITEM_ID)
                AND    (
                           SELECT COUNT(1)
                           FROM   SCM_MGR.SCM_MST_SITE_ITEM A
                                , SCM_MGR.DM_PLN_SALES_PLAN  B
                           WHERE  SALES_PLAN_ADJUST_YN = ''
                           AND    A.ITEM_ID       = B.ITEM_ID
                           AND    A.DIVISION_ID   = B.DIVISION_ID
                           AND    A.PROJECT_CODE  = B.PROJECT_CODE
                           AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                           AND    B.LAST_UPDATED_BY NOT IN ('SYSTEM', 'CUTOFF')
                           AND    B.YYYYMMDD      >= V_NEXT_MON_MINUS7
                           AND    A.DIVISION_ID   = W.DIVISION_ID
                           AND    A.PROJECT_CODE  = W.PROJECT_CODE
                           AND    A.SCM_SITE_ID   = W.SCM_SITE_ID
                           AND    A.ITEM_ID       = W.ITEM_ID
                       ) = 0
                AND    EXISTS (
                           SELECT V_DIVISION_ID
                           FROM   SCM_MGR.GT_SAVEPK_RESULTS
                           WHERE  1 = 1
                           AND    W.DIVISION_ID   = V_DIVISION_ID
                           AND    W.PROJECT_CODE  = V_PROJECT_CODE
                           AND    W.SCM_SITE_ID   = V_SCM_SITE_ID
                           AND    W.ITEM_ID       = V_ITEM_ID
                           AND    W.PLANT_SITE_ID = NVL(V_PLANT_SITE_ID, '')
                           AND    W.DOM_EXP       = V_DOM_EXP_NEW
                           AND    W.FCST_TYPE     = V_FCST_TYPE_NEW
                           AND    W.INCOTERMS     = V_INCOTERMS_NEW
                           --[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
                           AND    V_FCST_TYPE IN (
                                      SELECT SEGMENT2
                                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                      WHERE  1 = 1
                                      AND    MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                                      AND    MST.SEGMENT1    = 'FCST_TYPE'
                                      AND    VALID_YN        = 'Y'
                                  )
                            --AND v_fcst_type_new not in (SELECT SEGMENT2
                            --                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
                            --                          WHERE 1=1
                            --                          AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                            --                          AND MST.SEGMENT1    = 'FCST_TYPE'
                            --                          AND VALID_YN        = 'Y'  )
                       )

                UNION ALL
                -- USD 값을 계산
                SELECT   W.DIVISION_ID
                        ,W.PROJECT_CODE
                        ,W.SCM_SITE_ID
                        ,W.ITEM_ID
                        ,W.DOM_EXP
                        ,W.FCST_TYPE
                        ,W.INCOTERMS
                        ,'SalesAmt_USD'  AS MEASURE
                        ,W.PLANT_SITE_ID
                        ,W.YYYYMMDD
                        ,FP.CURRENCY
                        ,CAST(TO_NUMBER(TO_CHAR(W.QTY * NVL(FP.PRICE, 0), 'FM99999999999999999999.9999999999')) AS NUMBER(30, 10))
                        ,V_WRK_CREATED_BY
                        ,SYSDATE
                        ,'SYSTEM'
                        ,SYSDATE
                        ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL -- ATTRIBUTE1~10
                FROM   SCM_MGR.DM_PLN_MKT_FCST W
                INNER  JOIN SCM_MGR.SCM_SYS_CALENDAR_M SC
                    ON      SC.BASIS_YYYYMMDD = W.YYYYMMDD
                LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE FP
                    ON (    FP.DIVISION_ID   = W.DIVISION_ID
                        AND FP.PROJECT_CODE  = W.PROJECT_CODE
                        AND FP.SCM_SITE_ID   = W.SCM_SITE_ID
                        AND FP.ITEM_ID       = W.ITEM_ID
                        AND FP.DOM_EXP       = W.DOM_EXP
                        AND FP.FCST_TYPE     = W.FCST_TYPE
                        AND FP.INCOTERMS     = W.INCOTERMS
                        AND FP.PLANT_SITE_ID = W.PLANT_SITE_ID
                        AND FP.YYYYMMDD      = SC.BASIS_START_DATE
                        AND FP.MEASURE       = 'USD'
                       )
                WHERE  W.MEASURE      = 'RTF_SYS_RP'
                AND    W.YYYYMMDD    >= V_NEXT_MON_MINUS7
                AND    W.DIVISION_ID  = M_DIVISION_ID
                AND    W.SCM_SITE_ID  = M_SCM_SITE_ID
                AND    W.PROJECT_CODE = M_PROJECT_CODE
                AND    W.ITEM_ID IN (SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN GROUP BY ITEM_ID)
                AND    (
                           SELECT COUNT(1)
                           FROM   SCM_MGR.SCM_MST_SITE_ITEM A
                                , SCM_MGR.DM_PLN_SALES_PLAN  B
                           WHERE  SALES_PLAN_ADJUST_YN = ''
                           AND    A.ITEM_ID       = B.ITEM_ID
                           AND    A.DIVISION_ID   = B.DIVISION_ID
                           AND    A.PROJECT_CODE  = B.PROJECT_CODE
                           AND    A.SCM_SITE_ID   = B.SCM_SITE_ID
                           AND    B.LAST_UPDATED_BY NOT IN ('SYSTEM', 'CUTOFF')
                           AND    B.YYYYMMDD      >= V_NEXT_MON_MINUS7
                           AND    A.DIVISION_ID   = W.DIVISION_ID
                           AND    A.PROJECT_CODE  = W.PROJECT_CODE
                           AND    A.SCM_SITE_ID   = W.SCM_SITE_ID
                           AND    A.ITEM_ID       = W.ITEM_ID
                       ) = 0
                AND    EXISTS (
                           SELECT V_DIVISION_ID
                           FROM   SCM_MGR.GT_SAVEPK_RESULTS
                           WHERE  1 = 1
                           AND    W.DIVISION_ID   = V_DIVISION_ID
                           AND    W.PROJECT_CODE  = V_PROJECT_CODE
                           AND    W.SCM_SITE_ID   = V_SCM_SITE_ID
                           AND    W.ITEM_ID       = V_ITEM_ID
                           AND    W.PLANT_SITE_ID = NVL(V_PLANT_SITE_ID, '')
                           AND    W.DOM_EXP       = V_DOM_EXP_NEW
                           AND    W.FCST_TYPE     = V_FCST_TYPE_NEW
                           AND    W.INCOTERMS     = V_INCOTERMS_NEW
                           --[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
                           AND    V_FCST_TYPE IN (
                                      SELECT SEGMENT2
                                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                      WHERE  1 = 1
                                      AND    MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                                      AND    MST.SEGMENT1    = 'FCST_TYPE'
                                      AND    VALID_YN        = 'Y'
                                  )
                            --AND v_fcst_type_new not in (SELECT SEGMENT2
                            --                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
                            --                          WHERE 1=1
                            --                          AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                            --                          AND MST.SEGMENT1    = 'FCST_TYPE'
                            --                          AND VALID_YN        = 'Y'  )
                       )

                UNION ALL
                -- KRW 값을 계산
                SELECT   W.DIVISION_ID
                        ,W.PROJECT_CODE
                        ,W.SCM_SITE_ID
                        ,W.ITEM_ID
                        ,W.DOM_EXP
                        ,W.FCST_TYPE
                        ,W.INCOTERMS
                        ,'MKT_AMT_KRW'  AS MEASURE
                        ,W.PLANT_SITE_ID
                        ,W.YYYYMMDD
                        ,FP.CURRENCY
                        ,CAST(TO_NUMBER(TO_CHAR(W.QTY * NVL(FP.PRICE, 0), 'FM99999999999999999999.9999999999')) AS NUMBER(30, 10))
                        ,V_WRK_CREATED_BY   --[2018-03-15][수정]
                        ,SYSDATE             --[2018-03-15][수정]
                        ,'SYSTEM'            --[2018-03-15][수정]
                        ,SYSDATE             --[2018-03-15][수정]
                        ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL -- ATTRIBUTE1~10
                FROM   SCM_MGR.DM_PLN_MKT_FCST W
                INNER  JOIN SCM_MGR.SCM_SYS_CALENDAR_M SC
                    ON      SC.BASIS_YYYYMMDD = W.YYYYMMDD
                LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE FP
                    ON (    FP.DIVISION_ID   = W.DIVISION_ID
                        AND FP.PROJECT_CODE  = W.PROJECT_CODE
                        AND FP.SCM_SITE_ID   = W.SCM_SITE_ID
                        AND FP.ITEM_ID       = W.ITEM_ID
                        AND FP.DOM_EXP       = W.DOM_EXP
                        AND FP.FCST_TYPE     = W.FCST_TYPE
                        AND FP.INCOTERMS     = W.INCOTERMS
                        AND FP.PLANT_SITE_ID = W.PLANT_SITE_ID
                        AND FP.YYYYMMDD      = SC.BASIS_START_DATE
                        AND FP.MEASURE       = 'KRW'
                       )
                WHERE  W.MEASURE      = 'MKT_FCST'
                --and w.division_id = '40'  -- [C20210629-000239]
                AND    W.DIVISION_ID  = V_WRK_DIVISION_ID
                AND    W.YYYYMMDD    >= V_NEXT_MON_MINUS7
                AND    W.DIVISION_ID  = M_DIVISION_ID
                AND    W.SCM_SITE_ID  = M_SCM_SITE_ID
                AND    W.PROJECT_CODE = M_PROJECT_CODE
                AND    W.ITEM_ID IN (SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN GROUP BY ITEM_ID)
                AND    EXISTS (
                           SELECT V_DIVISION_ID
                           FROM   SCM_MGR.GT_SAVEPK_RESULTS
                           WHERE  1 = 1
                           AND    W.DIVISION_ID   = V_DIVISION_ID
                           AND    W.PROJECT_CODE  = V_PROJECT_CODE
                           AND    W.SCM_SITE_ID   = V_SCM_SITE_ID
                           AND    W.PLANT_SITE_ID = NVL(V_PLANT_SITE_ID, '')
                           AND    W.ITEM_ID       = V_ITEM_ID
                           AND    W.DOM_EXP       = V_DOM_EXP_NEW
                           AND    W.FCST_TYPE     = V_FCST_TYPE_NEW
                           AND    W.INCOTERMS     = V_INCOTERMS_NEW
                           --[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
                           AND    V_FCST_TYPE IN (
                                      SELECT SEGMENT2
                                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                      WHERE  1 = 1
                                      AND    MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                                      AND    MST.SEGMENT1    = 'FCST_TYPE'
                                      AND    VALID_YN        = 'Y'
                                  )
                            --AND v_fcst_type_new not in (SELECT SEGMENT2
                            --                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
                            --                          WHERE 1=1
                            --                          AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                            --                          AND MST.SEGMENT1    = 'FCST_TYPE'
                            --                          AND VALID_YN        = 'Y'  )
                       )

                UNION ALL
                -- LOC 값을 계산
                SELECT   W.DIVISION_ID
                        ,W.PROJECT_CODE
                        ,W.SCM_SITE_ID
                        ,W.ITEM_ID
                        ,W.DOM_EXP
                        ,W.FCST_TYPE
                        ,W.INCOTERMS
                        ,'MKT_AMT_LOC'  AS MEASURE
                        ,W.PLANT_SITE_ID
                        ,W.YYYYMMDD
                        ,FP.CURRENCY
                        ,CAST(TO_NUMBER(TO_CHAR(W.QTY * NVL(FP.PRICE, 0), 'FM99999999999999999999.9999999999')) AS NUMBER(30, 10))
                        ,V_WRK_CREATED_BY   --[2018-03-15][수정]
                        ,SYSDATE             --[2018-03-15][수정]
                        ,'SYSTEM'            --[2018-03-15][수정]
                        ,SYSDATE             --[2018-03-15][수정]
                        ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL -- ATTRIBUTE1~10
                FROM   SCM_MGR.DM_PLN_MKT_FCST W
                INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M SC
                    ON      SC.BASIS_YYYYMMDD = W.YYYYMMDD
                LEFT OUTER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE FP
                    ON (    FP.DIVISION_ID   = W.DIVISION_ID
                        AND FP.PROJECT_CODE  = W.PROJECT_CODE
                        AND FP.SCM_SITE_ID   = W.SCM_SITE_ID
                        AND FP.ITEM_ID       = W.ITEM_ID
                        AND FP.DOM_EXP       = W.DOM_EXP
                        AND FP.FCST_TYPE     = W.FCST_TYPE
                        AND FP.INCOTERMS     = W.INCOTERMS
                        AND FP.PLANT_SITE_ID = W.PLANT_SITE_ID
                        AND FP.YYYYMMDD      = SC.BASIS_START_DATE
                        AND FP.MEASURE       = 'LOC'
                       )
                WHERE  W.MEASURE      = 'MKT_FCST'
                --and w.division_id = '40'  [C20210629-000239]
                AND    W.DIVISION_ID  = V_WRK_DIVISION_ID
                AND    W.YYYYMMDD    >= V_NEXT_MON_MINUS7
                AND    W.DIVISION_ID  = M_DIVISION_ID
                AND    W.SCM_SITE_ID  = M_SCM_SITE_ID
                AND    W.PROJECT_CODE = M_PROJECT_CODE
                AND    W.ITEM_ID IN (SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN GROUP BY ITEM_ID)
                AND    EXISTS (
                           SELECT V_DIVISION_ID
                           FROM   SCM_MGR.GT_SAVEPK_RESULTS
                           WHERE  1 = 1
                           AND    W.DIVISION_ID   = V_DIVISION_ID
                           AND    W.PROJECT_CODE  = V_PROJECT_CODE
                           AND    W.SCM_SITE_ID   = V_SCM_SITE_ID
                           AND    W.ITEM_ID       = V_ITEM_ID
                           AND    W.PLANT_SITE_ID = NVL(V_PLANT_SITE_ID, '')
                           AND    W.DOM_EXP       = V_DOM_EXP_NEW
                           AND    W.FCST_TYPE     = V_FCST_TYPE_NEW
                           AND    W.INCOTERMS     = V_INCOTERMS_NEW
                           --[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
                           AND    V_FCST_TYPE IN (
                                      SELECT SEGMENT2
                                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                      WHERE  1 = 1
                                      AND    MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                                      AND    MST.SEGMENT1    = 'FCST_TYPE'
                                      AND    VALID_YN        = 'Y'
                                  )
                        --AND v_fcst_type_new not in (SELECT SEGMENT2
                        --                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
                        --                          WHERE 1=1
                        --                          AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                        --                          AND MST.SEGMENT1    = 'FCST_TYPE'
                        --                          AND VALID_YN        = 'Y'  )
                       );

                -- SCM_MST_FUTURE_PRICE UPDATE
                ----------------------------------------------------------------------------------------------- 20181108 pk값 validation (START)
                -- DM_PLN_MKT_FCST 테이블에서 당주월요일 이후 데이터가 존재하는지 체크 (start)
                S_FUTURE_VALID := '';

                BEGIN
                    SELECT '[PROJECT_CODE : ' || PROJECT_CODE || ']' || CHR(10)
                        || '[SCM_SITE_ID : '  || SCM_SITE_ID  || ']' || CHR(10)
                        || '[ITEM_ID : '       || ITEM_ID       || ']' || CHR(10)
                        || '[DOM_EXP : '       || DOM_EXP       || ']' || CHR(10)
                        || '[FCST_TYPE : '     || FCST_TYPE     || ']' || CHR(10)
                        || '[INCOTERMS : '     || INCOTERMS     || ']' || CHR(10)
                        || '[PLANT_SITE_ID : ' || PLANT_SITE_ID || ']'
                    INTO   S_FUTURE_VALID
                    FROM   SCM_MGR.SCM_MST_FUTURE_PRICE
                    WHERE  EXISTS (
                               SELECT V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID
                               FROM   SCM_MGR.GT_SAVEPK_RESULTS RSLT
                               WHERE  RSLT.V_DIVISION_ID       = SCM_MST_FUTURE_PRICE.DIVISION_ID
                               AND    RSLT.V_PROJECT_CODE      = SCM_MST_FUTURE_PRICE.PROJECT_CODE
                               AND    RSLT.V_SCM_SITE_ID       = SCM_MST_FUTURE_PRICE.SCM_SITE_ID
                               AND    RSLT.V_ITEM_ID           = SCM_MST_FUTURE_PRICE.ITEM_ID
                               AND    RSLT.V_DOM_EXP_NEW       = SCM_MST_FUTURE_PRICE.DOM_EXP
                               AND    RSLT.V_FCST_TYPE_NEW     = SCM_MST_FUTURE_PRICE.FCST_TYPE
                               AND    RSLT.V_INCOTERMS_NEW     = SCM_MST_FUTURE_PRICE.INCOTERMS
                               AND    RSLT.V_PLANT_SITE_ID_NEW = SCM_MST_FUTURE_PRICE.PLANT_SITE_ID
                               AND    SCM_MST_FUTURE_PRICE.YYYYMMDD >= V_NEXT_MON_MINUS7   -- 당주월요일 이후 데이터를 대상으로 함
                               AND    RSLT.V_DIVISION_ID  = M_DIVISION_ID
                               AND    RSLT.V_SCM_SITE_ID  = M_SCM_SITE_ID
                               AND    RSLT.V_PROJECT_CODE = M_PROJECT_CODE
                               --[C20210504-000051] 변경 전 fcst type이 유상인 경우에만 중복 Check
                               AND    RSLT.V_FCST_TYPE NOT IN (
                                          SELECT SEGMENT2
                                          FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                          WHERE  1 = 1
                                          AND    MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                                          AND    MST.SEGMENT1    = 'FCST_TYPE'
                                          AND    VALID_YN        = 'Y'
                                      )
                               GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID,
                                        V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID
                               HAVING COUNT(*) > 0
                           )
                    AND    DIVISION_ID  = M_DIVISION_ID
                    AND    SCM_SITE_ID  = M_SCM_SITE_ID
                    AND    PROJECT_CODE = M_PROJECT_CODE
                    AND    ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN S_FUTURE_VALID := '';
                END;

                IF S_FUTURE_VALID IS NOT NULL AND S_FUTURE_VALID <> '' THEN
                    V_LOG_TYPE    := 'INVALID';
                    V_INVALID_MSG := 'Sales Price 중복이 발생하였습니다.' || CHR(10) || S_FUTURE_VALID;
                    RAISE EX_INVALID;
                END IF;
                ----------------------------------------------------------------------------------------------- 20181108 pk값 validation (end)

                --[C20210504-000051] Sales Price 적용 기준 변경(변경된 Key 값으로 Update -> 변경된 Key 값으로 Insert, 무상은 제외)
                INSERT INTO SCM_MGR.SCM_MST_FUTURE_PRICE
                SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, V_PLANT_SITE_ID_NEW, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE
                     , V_DOM_EXP_NEW, V_FCST_TYPE_NEW, V_INCOTERMS_NEW, A.PRICE, A.CREATED_BY, A.CREATION_DATE, V_WRK_CREATED_BY, SYSDATE
                     , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
                     , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
                INNER JOIN (
                                SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID,
                                       V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID,
                                       V_DOM_EXP_NEW, V_FCST_TYPE_NEW, V_INCOTERMS_NEW, V_PLANT_SITE_ID_NEW, V_CREATED_BY
                                FROM   SCM_MGR.GT_SAVEPK_RESULTS
                                WHERE  1 = 1
                                AND    V_DIVISION_ID  = M_DIVISION_ID
                                AND    V_SCM_SITE_ID  = M_SCM_SITE_ID
                                AND    V_PROJECT_CODE = M_PROJECT_CODE
                                AND    V_FCST_TYPE_NEW NOT IN (
                                           SELECT SEGMENT2
                                           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                           WHERE  1 = 1
                                           AND    MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                                           AND    MST.SEGMENT1    = 'FCST_TYPE'
                                           AND    VALID_YN        = 'Y'
                                       )  -- 무상은 제외
                            ) B
                ON (
                        A.DIVISION_ID   = B.V_DIVISION_ID
                    AND A.PROJECT_CODE  = B.V_PROJECT_CODE
                    AND A.SCM_SITE_ID   = B.V_SCM_SITE_ID
                    AND A.ITEM_ID       = B.V_ITEM_ID
                    AND A.DOM_EXP       = B.V_DOM_EXP
                    AND A.FCST_TYPE     = B.V_FCST_TYPE
                    AND A.INCOTERMS     = B.V_INCOTERMS
                    AND A.PLANT_SITE_ID = B.V_PLANT_SITE_ID
                    AND A.YYYYMMDD     >= V_NEXT_MON_MINUS7   -- 당주월요일 이후 데이터를 대상으로 함
                    AND A.DIVISION_ID   = M_DIVISION_ID
                    AND A.SCM_SITE_ID   = M_SCM_SITE_ID
                    AND A.PROJECT_CODE  = M_PROJECT_CODE
                );

                --[C20210504-000051] 무상->유상으로 변경된 경우에 유상 Sales Price가 없으면 알림
                /* @s_unit_price_valid 변수내에는 Null이 발생하는 컬럼값이 존재하면 안됨 (변수전체가 Null로 저장됨) */
                S_UNIT_PRICE_VALID := NULL;

                BEGIN
                    SELECT CASE
                               WHEN A.V_DIVISION_ID = '40' THEN
                                   'End Customer________ : ' || NVL(V_PROJECT_CODE, '')
                               ELSE
                                   'Project_________ : ' || NVL(V_PROJECT_CODE, '')
                           END
                        || CHR(10) || 'Sales site_____________ : ' || NVL(V_SCM_SITE_ID, '')
                        || CHR(10) || 'Model________________ : '   || NVL(V_ITEM_ID, '')
                        || CHR(10) || 'Customs Handbook__ : '      || NVL(V_DOM_EXP_NEW, '')
                        || CHR(10) || 'Fcst Type_____________ : '  ||
                                NVL((SELECT SEGMENT2
                                     FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                     WHERE  1 = 1
                                     AND    MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                                     AND    MST.SEGMENT1    = A.V_FCST_TYPE_NEW
                                     AND    ROWNUM          = 1), '')
                        || CHR(10) || 'Incoterms____________ : '   || NVL(V_INCOTERMS_NEW, '')
                        || CHR(10) || 'Plant Site___________ : '   || NVL(V_PLANT_SITE_ID_NEW, '')
                        || CHR(10) || 'YYYYMMDD_________ : '       || NVL(MIN(M.BASIS_START_DATE), '') || ' ~ ' || NVL(MAX(M.BASIS_START_DATE), '')
                        || CHR(10) || CHR(10)
                    INTO   S_UNIT_PRICE_VALID
                    FROM   SCM_MGR.GT_SAVEPK_RESULTS A
                    INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM Z
                        ON  A.V_DIVISION_ID  = Z.DIVISION_ID
                        AND A.V_PROJECT_CODE = Z.PROJECT_CODE
                        AND A.V_SCM_SITE_ID  = Z.SCM_SITE_ID
                        AND A.V_ITEM_ID      = Z.ITEM_ID
                        AND Z.VALID_YN       = 'Y'
                        AND (Z.SALES_PLAN_ADJUST_YN = 'Y' OR Z.SALES_PLAN_ADJUST_YN = '' OR Z.SALES_PLAN_ADJUST_YN IS NULL)
                    LEFT JOIN (
                                   SELECT BASIS_START_DATE
                                   FROM   SCM_MGR.SCM_SYS_CALENDAR_M M
                                   WHERE  M.BASIS_YYYYMMDD BETWEEN V_NEXT_MON_MINUS7   --당주 월요일부터
                                       AND TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 364, 'YYYYMMDD')  -- 52주후 월요일까지
                                   GROUP BY BASIS_START_DATE
                               ) M
                        ON  1 = 1
                    LEFT JOIN SCM_MGR.SCM_MST_FUTURE_PRICE P
                        ON (
                                A.V_DIVISION_ID      = P.DIVISION_ID
                            AND A.V_PROJECT_CODE     = P.PROJECT_CODE
                            AND A.V_SCM_SITE_ID      = P.SCM_SITE_ID
                            AND A.V_ITEM_ID          = P.ITEM_ID
                            AND A.V_DOM_EXP_NEW      = P.DOM_EXP
                            AND A.V_FCST_TYPE_NEW    = P.FCST_TYPE
                            AND A.V_INCOTERMS_NEW    = P.INCOTERMS
                            AND A.V_PLANT_SITE_ID_NEW = CASE WHEN A.V_DIVISION_ID = '81' THEN P.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
                            AND P.YYYYMMDD           = M.BASIS_START_DATE
                            AND P.PRICE              > 0
                           )
                    WHERE  1 = 1
                    AND    P.YYYYMMDD IS NULL  -- PRICE값이 없는경우
                    AND    A.V_FCST_TYPE_NEW NOT IN (
                               SELECT SEGMENT2
                               FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                               WHERE  1 = 1
                               AND    MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                               AND    MST.SEGMENT1    = 'FCST_TYPE'
                               AND    VALID_YN        = 'Y'
                           )
                    AND    A.V_FCST_TYPE IN (
                               SELECT SEGMENT2
                               FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                               WHERE  1 = 1
                               AND    MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                               AND    MST.SEGMENT1    = 'FCST_TYPE'
                               AND    VALID_YN        = 'Y'
                           )
                    GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID,
                             V_DOM_EXP_NEW, V_FCST_TYPE_NEW, V_INCOTERMS_NEW, V_PLANT_SITE_ID_NEW, P.YYYYMMDD
                    ORDER BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID,
                             V_DOM_EXP_NEW, V_FCST_TYPE_NEW, V_INCOTERMS_NEW, V_PLANT_SITE_ID_NEW, P.YYYYMMDD
                    FETCH FIRST 1 ROWS ONLY;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN S_UNIT_PRICE_VALID := NULL;
                END;

                IF S_UNIT_PRICE_VALID IS NOT NULL THEN
                    V_LOG_TYPE    := 'INVALID';
                    V_DESCRIPTION := S_UNIT_PRICE_VALID
                                  || 'Unit Price Not Found !' || CHR(10)
                                  || '해당주차의 Sales Price 값을 입력하시기 바랍니다.' || CHR(10)
                                  || '미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.';
                    V_INVALID_MSG := V_DESCRIPTION;
                    RAISE EX_INVALID;
                END IF;

                /*
                        MERGE INTO dbo.SCM_MST_FUTURE_PRICE A
                        USING (
                                SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
                                      ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
                                      from #results
                                          where 1=1
                                            AND v_DIVISION_ID        =  @m_DIVISION_ID
                                            AND v_SCM_SITE_ID        =  @m_SCM_SITE_ID
                                            AND v_PROJECT_CODE       =  @m_PROJECT_CODE
                              ) B
                        ON(
                                    A.division_id     = B.v_division_id
                                AND A.project_code    = B.v_project_code
                                AND A.scm_site_id     = B.v_scm_site_id
                                AND A.item_id         = B.v_item_id
                                AND A.dom_exp         = B.v_dom_exp
                                AND A.fcst_type       = B.v_fcst_type
                                AND A.incoterms       = B.v_incoterms
                                AND A.plant_site_id   = B.v_plant_site_id
                            and A.yyyymmdd       >= CONVERT(CHAR(8), (dbo.FN_NEXT_DAY(GETDATE(), 'MON') + (-7)), 112)   -- 당주월요일 이후 데이터를 대상으로 함
                                AND A.DIVISION_ID        =  @m_DIVISION_ID
                                AND A.SCM_SITE_ID        =  @m_SCM_SITE_ID
                                AND A.PROJECT_CODE       =  @m_PROJECT_CODE
                          )
                        WHEN MATCHED THEN
                             UPDATE  SET  dom_exp       = v_dom_exp_new
                                         ,fcst_type         = v_fcst_type_new
                                         ,incoterms         = v_incoterms_new
                                         ,plant_site_id     = v_plant_site_id_new
                                        ,last_updated_by    = v_created_by
                                        ,last_update_date = GETDATE()
                */

            --===================================================================================== HISTORY INSERT start
                INSERT INTO SCM_MGR.DM_PLN_MKT_FCST_PK_DATA_UPDATE_H
                SELECT
                       V_DIVISION_ID
                      ,SCM_MGR.SEQ1_DM_PLN_MKT_FCST_PK_DATA_UPDATE_H.NEXTVAL
                      ,V_PROJECT_CODE
                      ,V_SCM_SITE_ID
                      ,V_ITEM_ID
                      ,V_DOM_EXP
                      ,V_FCST_TYPE
                      ,V_INCOTERMS
                      ,V_PLANT_SITE_ID
                      ,V_DOM_EXP_NEW
                      ,V_FCST_TYPE_NEW
                      ,V_INCOTERMS_NEW
                      ,V_PLANT_SITE_ID_NEW
                      ,V_CREATED_BY
                      ,SYSDATE
                      ,V_CREATED_BY
                      ,SYSDATE
                      ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                FROM   SCM_MGR.GT_SAVEPK_RESULTS
                WHERE  1 = 1
                AND    V_DIVISION_ID  = M_DIVISION_ID
                AND    V_SCM_SITE_ID  = M_SCM_SITE_ID
                AND    V_PROJECT_CODE = M_PROJECT_CODE;
            --===================================================================================== HISTORY INSERT end

            --COMMIT TRANSACTION PK_UPDATE_02

        ---------------------------------------------------------------------------------------- WHILE_1 LOOP END

    END LOOP;

    SELECT COUNT(*)
    INTO   N_LOG_COUNT
    FROM   SCM_MGR.GT_SAVEPK_RESULTS;
    -- 트랜잭션 (COMMIT)
    COMMIT;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_INVALID THEN
        -- 트랜잭션 (END) - INVALID
        ROLLBACK;
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := V_INVALID_MSG;
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, V_INVALID_MSG AS MSG, '0' AS EVENT FROM DUAL;
        RETURN;

    WHEN OTHERS THEN
        ROLLBACK;
        -- ERROR LOG VALUE SAVE
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;
        --[C20200909-000203] LOG 표준화 적용
        V_PROC_INPUT :=
            JSON_OBJECT(
                'P_DIVISION_ID'       VALUE P_DIVISION_ID,
                'P_PROJECT_CODE'      VALUE P_PROJECT_CODE,
                'P_SCM_SITE_ID'       VALUE P_SCM_SITE_ID,
                'P_ITEM_ID'           VALUE P_ITEM_ID,
                'P_DOM_EXP'           VALUE P_DOM_EXP,
                'P_FCST_TYPE'         VALUE P_FCST_TYPE,
                'P_INCOTERMS'         VALUE P_INCOTERMS,
                'P_PLANT_SITE_ID'     VALUE P_PLANT_SITE_ID,
                'P_DOM_EXP_NEW'       VALUE P_DOM_EXP_NEW,
                'P_FCST_TYPE_NEW'     VALUE P_FCST_TYPE_NEW,
                'P_INCOTERMS_NEW'     VALUE P_INCOTERMS_NEW,
                'P_PLANT_SITE_ID_NEW' VALUE P_PLANT_SITE_ID_NEW,
                'P_CREATED_BY'        VALUE P_CREATED_BY
            );
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE;


    -- ============================================================
    -- 신규 흡수 (2026-05-13 P1-2): standalone SP 본문 통합
    -- ============================================================
    PROCEDURE P_DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC (
    		p_division_id			VARCHAR2,
    		p_project_code			VARCHAR2,
    		p_project_name		    VARCHAR2,
    		p_yyyymm_from			VARCHAR2,
    		p_yyyymm_to			VARCHAR2,
    		p_yyyymm_from_simul	VARCHAR2,
    		p_yyyymm_to_simul		VARCHAR2,
    		p_created_by			VARCHAR2,
        	p_end_customer VARCHAR2
    )
        IS
    /*
     * ========================================
     * [변환검증] 2026-03-02 20:36:58
     * 파일: dbo.DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC.sql
     * ----------------------------------------
     * ⚠ IF: IF:8  END IF:7  차이:+1
     * ⚠ LOOP: LOOP:1  END LOOP:0  차이:+1
     * ⚠ BEGIN: BEGIN:25  END:21  차이:+4
     * ----------------------------------------
     * BEGIN 위치: L57, L104, L114, L123, L145, L158, L172, L217, L229, L232 ...
     * END;  위치: L111, L140, L152, L169, L209, L211, L227, L383, L388, L393 ...
     * ----------------------------------------
     * 힌트: BEGIN이 4개 더 많음 → END; 누락 가능성
     * 수정 완료 후 이 주석 블록을 삭제하세요.
     * ========================================
     */
    
    
    
    
        V_CNT INTEGER := 0, v_i INTEGER =  1;
        v_yyyymm VARCHAR2(20 CHAR);
        p_yyyymm VARCHAR2(20 CHAR);
        v_CUST_FCST_M VARCHAR2(4000 CHAR);
        v_MKT_FCST_S VARCHAR2(4000 CHAR);
        v_MKT_FCST_R VARCHAR2(4000 CHAR);
        v_0month_tuesday VARCHAR2(08 CHAR);
        v_0month VARCHAR2(6 CHAR);
        v_1month VARCHAR2(6 CHAR);
        v_s INTEGER := 0;
        V_PSI_CNT INTEGER := 1;
        V_YYYYMM_CNT INTEGER := 1;
        V_YYYYMM VARCHAR2(30 CHAR);
        V_YYYYMM_FROM VARCHAR2(30 CHAR);
        V_YYYYMM_TO VARCHAR2(30 CHAR);
        V_MEASURE VARCHAR2(30 CHAR);
        V_P INTEGER := 0;
        V_S INTEGER := 0;
        V_I INTEGER := 0;
        V_V INTEGER := 0;
        V_M INTEGER := 0;
        V_CP INTEGER := 0;
    BEGIN
    
    
    
    
    
    
    
    
    	    v_DP_RESULT_SUM NUMERIC(20,10);
    	    v_DP_RESULT_P NUMERIC(20,10);
    	    v_DP_RESULT_S NUMERIC(20,10);
    	    v_DP_RESULT_I NUMERIC(20,10);
    	    v_DP_RESULT_V NUMERIC(20,10);
    	    v_DP_RESULT_M NUMERIC(20,10);
    	    v_DP_RESULT_CP NUMERIC(20,10);
    	    v_EDI_SUM NUMERIC(20,10);
    
    	    v_DP_ANL_SUM NUMERIC(20,10);
    	    v_DP_ANL_P NUMERIC(20,10);
    	    v_DP_ANL_S NUMERIC(20,10);
    	    v_DP_ANL_I NUMERIC(20,10);
    	    v_DP_ANL_V NUMERIC(20,10);
    	    v_DP_ANL_M NUMERIC(20,10);
    	    v_DP_ANL_CP NUMERIC(20,10);
    	    v_LAST_MONTH_EDI NUMERIC(20,10);
    
    
    
    
    
    
    
    	v_0month := TO_CHAR(SYSDATE, 'YYYYMMDD'); --M0 당월
    	v_1month := TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMMDD')	--M-1 전월
    
    
    
    	SELECT MONTHS_BETWEEN(1, 4, SUBSTR(p_yyyymm_to)  ||  '-'  ||  SUBSTR(p_yyyymm_to, 5, 2)   ||  '-01', SUBSTR(p_yyyymm_from, 1, 4)  ||  '-'  ||  SUBSTR(p_yyyymm_from, 5, 2)   ||  '-01' )
      INTO v_i
    		)
    	FROM DUAL;
    
    	-- 테이블중복제거
    	-- 임시확인용테이블 중복제거
    	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DM_MST_VERSION';
    
    	BEGIN
    
    		-- 테이블중복제거
    		-- 임시확인용테이블 중복제거
    		SELECT * INTO GT_DMF0_PROJECT_CODE
    		FROM (SELECT PROJECT_CODE FROM SCM_MST_PROJECT WHERE DIVISION_ID = p_division_id AND PROJECT_NAME = p_project_name) A;
    
    	END;
    
    
    	BEGIN
    
    		--월의 첫날이 수요일인 경우 전달의 마지막 MKT_FCST Cutoff 일자를 사용한다.
    		IF DATEPART(WEEKDAY, SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)  ||  '01') = '4' THEN
    				v_0month_tuesday := TO_CHAR(/* TODO:(FN_NEXT_DAY(TO_CHAR(SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6) + (-1) * 7 + '01', 'YYYYMMDD'), 'TUE')) */, 'YYYYMMDD');
    		ELSE
    				v_0month_tuesday := TO_CHAR(1 || (/* TODO:DATEDIFF(WK,0,(SYSDATE) + (5-DATEPART(DAY, SYSDATE) */)))*7SYSDATE || (5-DATEPART(DAY, SYSDATE))), 1), 'YYYYMMDD'); --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
    			END IF;
    
    		BEGIN
    			INSERT INTO GT_DMF0_DM_MST_VERSION ( NUM, VERSION_NO, VERSION_TYPE )
    			SELECT ROW_NUMBER() OVER (ORDER BY X.VERSION_NO) AS NUM
    						, X.VERSION_NO
    						, X.VERSION_TYPE
    			FROM (
    						SELECT ROW_NUMBER() OVER (PARTITION BY A.VERSION_TYPE ORDER BY A.VERSION_NO DESC) AS RNK
    									, A.VERSION_NO, A.VERSION_TYPE
    						FROM  DM_MST_VERSION A
    						JOIN SCM_SYS_CALENDAR_M B
    						ON A.YYYYMMDD = B.BASIS_YYYYMMDD
    						WHERE 1=1
    						AND A.DIVISION_ID = p_division_id
    						AND A.VERSION_TYPE = 'MF_W'			--MKT_FCST Weekly Cutoff
    						AND A.YYYYMMDD = v_0month_tuesday
    					) X;
    			WHERE RNK = 1;
    		END;
    
    		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------
    
    
    		BEGIN
    	    	-- 테이블중복제거
    	       	-- 임시확인용테이블 중복제거
    		    SELECT * INTO GT_DMF0_DM_MST_ITEM_SINGLE_V FROM DM_MST_ITEM_SINGLE_V  WHERE DIVISION_ID = p_division_id
    			AND ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_PROJECT_ITEM WHERE PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    			AND VALID_YN = 'Y') AND ITEM_TYPE = 'P' AND ACTIVE_FLAG = 'Y';
    			--AND ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_PROJECT_ITEM WHERE PROJECT_CODE = p_project_code AND VALID_YN = 'Y') AND ITEM_TYPE = 'P' AND ACTIVE_FLAG = 'Y'
    		END;
    		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------
    
    
    
    		--SCM_MST_SITE 대상건만 추출
    		BEGIN
            	-- 테이블중복제거
            	-- 임시확인용테이블 중복제거
            	/* TODO:GTT:GT_DMF0_SCM_MST_SITE-->GT_DMF0_SCM_MST_SITE */
            	INSERT INTO GT_DMF0_SCM_MST_SITE
            	SELECT DIVISION_ID
    			     , SCM_SITE_ID
    				 , END_CUSTOMER
    			FROM SCM_MST_SITE
    			WHERE DIVISION_ID  = p_division_id
    	          AND END_CUSTOMER = p_end_customer;
    		END;
    
    
    		BEGIN
            	-- 테이블중복제거
            	-- 임시확인용테이블 중복제거
            	/* TODO:GTT:GT_DMF0_DM_PLN_MKT_FCST_C-->GT_DMF0_DM_PLN_MKT_FCST_C */
            	INSERT INTO GT_DMF0_DM_PLN_MKT_FCST_C
            	SELECT X.*
    			FROM DM_PLN_MKT_FCST_C X
    			JOIN GT_DMF0_DM_MST_VERSION Y
    			ON X.VERSION_NO = Y.VERSION_NO
    		    JOIN GT_DMF0_SCM_MST_SITE Z
    			ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    			WHERE 1=1
    			AND X.DIVISION_ID = p_division_id
    			AND X.MEASURE IN ('MKT_FCST','CUST_FCST_EDI', 'CUST_FCST')
    			AND X.PROJECT_CODE = p_project_code
    			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    			AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V);
    			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    
            	-- 테이블중복제거
            	-- 임시확인용테이블 중복제거
            	/* TODO:GTT:GT_DMF0_DM_PLN_MKT_FCST_RESULT-->GT_DMF0_DM_PLN_MKT_FCST_RESULT */
            	INSERT INTO GT_DMF0_DM_PLN_MKT_FCST_RESULT
            	SELECT X.*
    			FROM DM_PLN_MKT_FCST_RESULT_C X
    			JOIN GT_DMF0_DM_MST_VERSION Y
    			ON X.VERSION_NO = Y.VERSION_NO
    		    JOIN GT_DMF0_SCM_MST_SITE Z
    			ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    			WHERE 1=1
    			AND X.DIVISION_ID = p_division_id
    			AND X.MEASURE IN ('MKT_FCST','CUST_FCST_EDI', 'CUST_FCST')
    			AND X.PROJECT_CODE = p_project_code
    			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    			AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V);
    			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    
    		END;
    
    	END;
    
    	--SELECT * FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    
    	WHILE v_i <= 0 LOOP
    
    		BEGIN
    			SELECT COUNT(*)
      INTO V_CNT
    			FROM DM_ANL_MKT_PSI
    			WHERE 1=1
    			AND DIVISION_ID = p_division_id
    			AND END_CUSTOMER = p_end_customer
    			--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    			AND PROJECT_CODE = p_project_code
    			AND YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD');
    		END;
    
    		BEGIN
    			IF v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') THEN
    					--고객수요계획
    					BEGIN
    						IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
    								SELECT (A_QTY  ||  B_QTY)
      INTO v_CUST_FCST_M
    								FROM (
    											SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
    											FROM GT_DMF0_DM_PLN_MKT_FCST_C X
    											JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    											WHERE 1=1
    											AND X.DIVISION_ID = p_division_id
    											AND X.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
    											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    											AND X.PROJECT_CODE = p_project_code
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
    											AND X.FCST_TYPE = 'MPS'
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
    											AND X.QTY <> 0
    											) A,
    											(
    											SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
    											FROM GT_DMF0_DM_PLN_MKT_FCST_RESULT X
    											JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    											WHERE 1=1
    											AND X.DIVISION_ID = p_division_id
    											AND X.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
    											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    											AND X.PROJECT_CODE = p_project_code
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
    											AND X.FCST_TYPE = 'MPS'
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
    											) B;
    						ELSE
    							SELECT v_CUST_FCST_M = 0
    					END IF;
    					--마케팅수요계획
    					BEGIN
    						IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
    								SELECT (A_QTY  ||  B_QTY)
      INTO v_MKT_FCST_S
    								FROM (
    											SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
    											FROM GT_DMF0_DM_PLN_MKT_FCST_C X
    											JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    											WHERE 1=1
    											AND X.DIVISION_ID = p_division_id
    											AND X.MEASURE = 'RTF_SYS_RP'
    											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    											AND X.PROJECT_CODE = p_project_code
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
    											AND X.FCST_TYPE = 'MPS'
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
    											AND X.QTY <> 0
    											) A,
    											(
    											SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
    											FROM GT_DMF0_DM_PLN_MKT_FCST_RESULT X
    											JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    											WHERE 1=1
    											AND X.DIVISION_ID = p_division_id
    											AND X.MEASURE = 'RTF_SYS_RP'
    											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    											AND X.PROJECT_CODE = p_project_code
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
    											AND X.FCST_TYPE = 'MPS'
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
    											) B;
    						ELSE
    							SELECT v_MKT_FCST_S = 0
    
    						IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_1month THEN
    					            /* 2023.11.02	   kcw3408		  전월 실적 구하기 ,기존로직 삭제
    								SELECT v_MKT_FCST_R = (A_QTY || B_QTY)
    								FROM (
    											SELECT NVL(CEILING(SUM(QTY)), 0) AS A_QTY
    											FROM GT_DMF0_DM_PLN_MKT_FCST_C X
    											JOIN GT_DMF0_DM_MST_VERSION Y
    											ON X.VERSION_NO = Y.VERSION_NO
    											WHERE 1=1
    											AND DIVISION_ID = p_division_id
    											AND MEASURE = 'RTF_SYS_RP'
    											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    											AND PROJECT_CODE = p_project_code
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
    											AND X.FCST_TYPE = 'MPS'
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND SUBSTR(YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', -1), 'YYYYMMDD')
    											AND QTY <> 0
    											) A,
    											(
    											SELECT NVL(CEILING(SUM(QTY)), 0) AS B_QTY
    											FROM GT_DMF0_DM_PLN_MKT_FCST_RESULT X
    											JOIN GT_DMF0_DM_MST_VERSION Y
    											ON X.VERSION_NO = Y.VERSION_NO
    											WHERE 1=1
    											AND DIVISION_ID = p_division_id
    											AND MEASURE = 'RTF_SYS_RP'
    											--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    											AND PROJECT_CODE = p_project_code
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
    											AND X.FCST_TYPE = 'MPS'
    											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    											AND SUBSTR(YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', -1), 'YYYYMMDD')
    											) B;
    					    */
    				    		SELECT v_MKT_FCST_R = A.A_QTY
    					          FROM (
    								SELECT NVL(CEILING(SUM(QTY)), 0) AS A_QTY
    								FROM DM_PLN_MKT_FCST_RESULT X
    		                        JOIN SCM_MST_SITE_ITEM F
    				                     ON	F.DIVISION_ID    = X.DIVISION_ID
    				                    AND	F.PROJECT_CODE   = X.PROJECT_CODE
    			                        AND	F.scm_site_id    = X.scm_site_id
                                        AND	F.ITEM_ID        = X.ITEM_ID
    			                   JOIN GT_DMF0_SCM_MST_SITE H
    				                    ON	F.DIVISION_ID    = H.DIVISION_ID
    				                   AND	F.SCM_SITE_ID    = H.SCM_SITE_ID
    			                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G
    			                        ON	G.SEGMENT1    = X.FCST_TYPE
    				                   AND	G.LOOKUP_TYPE = 'SALES_TYPE_CODE'
    								WHERE 1 = 1
    									AND X.DIVISION_ID = p_division_id
    									AND X.MEASURE = 'RTF_SYS_RP'
    									AND X.PROJECT_CODE = p_project_code
    									AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', - 1), 'YYYYMMDD')
    							       ) A;
    						ELSE
    							SELECT v_MKT_FCST_R = 0
    					END IF;
    			ELSE
    				SELECT 0,
        0,
        0
      INTO v_CUST_FCST_M, v_MKT_FCST_S, v_MKT_FCST_R
    		END IF;
    
    
    		IF (V_CNT = 0) THEN
    			IF v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
    					BEGIN
    						INSERT INTO GT_DMF0_DATA
    						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), v_CUST_FCST_M, 'Average impact(%)', '0%', '0%', '0%', '0%', '0%', '0%', '0%',NULL, '1'
    					END;
    
    					BEGIN
    						INSERT INTO GT_DMF0_DATA
    						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), v_CUST_FCST_M, 'Simulation (Impact)', 0, 0, 0, 0, 0, 0, 0, 0, '2'
    					END;
    
    					BEGIN
    						INSERT INTO GT_DMF0_DATA
    						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), v_CUST_FCST_M, 'Demand Plan (1st)', 0, 0, 0, 0, 0, 0, 0, CEILING(v_MKT_FCST_S), '3'
    					END;
    
    					BEGIN
    						INSERT INTO GT_DMF0_DATA
    						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), v_CUST_FCST_M, 'Demand Plan (final)', 0, 0, 0, 0, 0, 0, 0, CEILING(v_MKT_FCST_R), '4'
    					END;
    			ELSE
    					BEGIN
    						INSERT INTO GT_DMF0_DATA
    						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), 0, 'Average impact(%)', '0%', '0%', '0%', '0%', '0%', '0%', '0%', NULL, '1'
    					END;
    
    					BEGIN
    						INSERT INTO GT_DMF0_DATA
    						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), 0, 'Simulation (Impact)', 0, 0, 0, 0, 0, 0, 0, 0, '2'
    					END;
    
    					BEGIN
    						INSERT INTO GT_DMF0_DATA
    						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), 0, 'Demand Plan (1st)', 0, 0, 0, 0, 0, 0, 0, CEILING(v_MKT_FCST_S), '3'
    					END;
    
    					BEGIN
    						INSERT INTO GT_DMF0_DATA
    						SELECT p_division_id,p_end_customer, p_project_name,p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'), 0, 'Demand Plan (final)', 0, 0, 0, 0, 0, 0, 0, CEILING(v_MKT_FCST_R), '4'
    					END;
    		ELSE
    				-- 고객수요증감분석 전체조회
    				INSERT INTO GT_DMF0_DATA
    				SELECT  T1.DIVISION_ID AS DIVISION_ID
    				          , p_end_customer
    						  , p_project_name
    						  , p_project_code
    						  , T1.YYYYMM AS YYYYMM
    						  , (CASE WHEN NVL(T1.CUST_FCST_M, 0) = 0 THEN
    											   v_CUST_FCST_M
    									 WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
    											   v_CUST_FCST_M
    									 ELSE CEILING(T1.CUST_FCST_M) END) AS EDI_QTY
    						  , (CASE T1.MEASURE WHEN 'AN_LOGIC' THEN 'Average impact(%)'
    													   WHEN 'AN_RESULT' THEN 'Simulation (Impact)'
    													   WHEN 'DP_INIT' THEN 'Demand Plan (1st)'
    													   WHEN 'DP_RESULT' THEN 'Demand Plan (final)' END) AS MEASURE
    						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T2.VSUM), 2))) || '%')
    								 	 ELSE TO_CHAR(CEILING(T2.VSUM), '#,#') END) AS SUM
    						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR(ROUND(TO_NUMBER(T1.P_VALUE), 2)) || '%')
    									 ELSE TO_CHAR(CEILING(T1.P_VALUE), '#,#') END) AS PRODUCT
    						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T1.S_VALUE), 2))) || '%')
    									 ELSE TO_CHAR(CEILING(T1.S_VALUE), '#,#') END) AS SALE
    						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T1.I_VALUE), 2))) || '%')
    									 ELSE TO_CHAR(CEILING(T1.I_VALUE), '#,#') END) AS INVENTORY
    						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T1.V_VALUE), 2))) || '%')
    									 ELSE TO_CHAR(CEILING(T1.V_VALUE), '#,#') END) AS TIME_ADJUST
    						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T1.M_VALUE), 2))) || '%')
    									 ELSE TO_CHAR(CEILING(T1.M_VALUE), '#,#') END) AS MODEL_MIX
    						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN (TO_CHAR((ROUND(TO_NUMBER(T1.CP_VALUE), 2))) || '%')
    									 ELSE TO_CHAR(CEILING(T1.CP_VALUE), '#,#') END) AS SUPPLY_ISSUE
    						  , (CASE WHEN T1.MEASURE = 'AN_RESULT' THEN
    											  (CASE WHEN NVL(T1.MKT_FCST_M, 0) = 0 THEN 0 ELSE CEILING(T1.MKT_FCST_M) END)
    									 WHEN T1.MEASURE = 'DP_INIT' THEN
    											  (CASE WHEN NVL(T1.MKT_FCST_M, 0) = 0 THEN
    																 CEILING(v_MKT_FCST_S)
    													   WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
    																 CEILING(v_MKT_FCST_S)
    														ELSE CEILING(T1.MKT_FCST_M) END)
    									 WHEN T1.MEASURE = 'DP_RESULT' THEN
    											  (CASE WHEN NVL(T1.MKT_FCST_M, 0) = 0 THEN
    																 CEILING(v_MKT_FCST_R)
    													   WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
    																 CEILING(v_MKT_FCST_R)
    													   ELSE CEILING(T1.MKT_FCST_M) END)
    									 ELSE NULL END)
    						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN '1'
    									 WHEN T1.MEASURE = 'AN_RESULT' THEN '2'
    									 WHEN T1.MEASURE = 'DP_INIT' THEN '3'
    									 ELSE '4' END) RNK
    				FROM DM_ANL_MKT_PSI T1
    				LEFT OUTER JOIN (SELECT PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE, SUM(VVALUE) AS VSUM
    										  FROM DM_ANL_MKT_PSI;
    				UNPIVOT (VVALUE FOR VLIST IN (P_VALUE, S_VALUE, I_VALUE, V_VALUE, M_VALUE, CP_VALUE)) AS UPV_RST
    				GROUP BY PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE) T2
    				ON T1.PROJECT_CODE = T2.PROJECT_CODE AND T1.END_CUSTOMER = T2.END_CUSTOMER AND T1.YYYYMM = T2.YYYYMM AND T1.MEASURE = T2.MEASURE
    				WHERE 1=1
    				AND T1.DIVISION_ID = p_division_id
    				AND T1.END_CUSTOMER = p_end_customer
    				AND T1.PROJECT_CODE = p_project_code
    				AND T1.YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'); --20240112 p_yyyymm_to_simul --> p_yyyymm 로 변경
    
    
    
    				IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') >= TO_CHAR(p_yyyymm_from_simul  ||  '01', 'YYYYMMDD')
    				AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') <= TO_CHAR(p_yyyymm_to_simul  ||  '01', 'YYYYMMDD') THEN
    				--SELECT TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD')
    					--SELECT v_EDI_SUM
    					--SELECT TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD')
    					--SELECT TO_CHAR(p_yyyymm_to_simul + '01', 'YYYYMMDD')
    					--SELECT v_EDI_SUM
    					SELECT
    					 v_EDI_SUM = T1.CUST_FCST_M		 ||  NVL(v_EDI_SUM, 0)
    					 ,T2.VSUM		 ||  NVL(v_DP_RESULT_SUM AS v_DP_RESULT_SUM, 0)
    					,T1.P_VALUE	 ||  NVL(v_DP_RESULT_P AS v_DP_RESULT_P, 0)
    					,T1.S_VALUE	 ||  NVL(v_DP_RESULT_S AS v_DP_RESULT_S, 0)
    					,T1.I_VALUE	 ||  NVL(v_DP_RESULT_I AS v_DP_RESULT_I, 0)
    					,T1.V_VALUE	 ||  NVL(v_DP_RESULT_V AS v_DP_RESULT_V, 0)
    					,T1.M_VALUE	 ||  NVL(v_DP_RESULT_M AS v_DP_RESULT_M, 0)
    					,NVL(T1.CP_VALUE AS v_DP_RESULT_CP, 0)	 ||  NVL(v_DP_RESULT_CP, 0)
    					FROM DM_ANL_MKT_PSI T1
    					LEFT OUTER JOIN (SELECT PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE, SUM(VVALUE) AS VSUM
    											  FROM DM_ANL_MKT_PSI;
    					UNPIVOT (VVALUE FOR VLIST IN (P_VALUE, S_VALUE, I_VALUE, V_VALUE, M_VALUE, CP_VALUE)) AS UPV_RST
    					GROUP BY PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE) T2
    					ON T1.PROJECT_CODE = T2.PROJECT_CODE AND T1.END_CUSTOMER = T2.END_CUSTOMER AND T1.YYYYMM = T2.YYYYMM AND T1.MEASURE = T2.MEASURE
    					WHERE 1=1
    					AND T1.DIVISION_ID = p_division_id
    		     		AND T1.END_CUSTOMER = p_end_customer
    					AND T1.PROJECT_CODE = p_project_code-- IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    					AND T1.YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
    					AND T1.MEASURE = 'DP_RESULT';
    				END IF;
    
    		v_i := v_i || 1;
    
     	END IF;
    
    	-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    	BEGIN
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    	SELECT MONTHS_BETWEEN(1, 4, SUBSTR(p_yyyymm_from_simul)  ||  '-'  ||  SUBSTR(p_yyyymm_from_simul, 5, 2)   ||  '-01', SUBSTR(TO_CHAR(ADD_MONTHS(SYSDATE, 0), 'YYYYMMDD') , 1, 4)  ||  '-'  ||  SUBSTR(TO_CHAR(ADD_MONTHS(SYSDATE, 0), 'YYYYMMDD') , 5, 2)   ||  '-01' ),
        TO_CHAR(SYSDATE, 'YYYYMMDD')
      INTO V_YYYYMM_CNT, V_YYYYMM_TO
    	END;
    
    
    	BEGIN
    			-- 테이블중복제거
    		-- 임시확인용테이블 중복제거
    		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_AN_LOGIC';
    
    	END;
    
    	--PRINT V_YYYYMM_CNT
    
    
    	--SELECT * FROM GT_DMF0_DM_MST_VERSION
    
    		BEGIN
    
    			SELECT NVL(CEILING(SUM(QTY)), 0)
      INTO v_LAST_MONTH_EDI
    			FROM DM_PLN_MKT_FCST_C X
    			JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    		    JOIN GT_DMF0_SCM_MST_SITE Z
    			ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    			WHERE 1=1
    			AND X.DIVISION_ID = p_division_id
    			AND X.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
    			--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    			AND X.PROJECT_CODE = p_project_code
    			AND X.ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
    			AND X.FCST_TYPE = 'MPS'
    			AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm_to_simul  ||  '01', 1), 'YYYYMMDD'); --'202308'
    
    			--SELECT TO_CHAR(ADD_MONTHS('202310' + '01', 1), 'YYYYMMDD')
    
    			--SELECT TO_CHAR(ADD_MONTHS(p_yyyymm_to_simul + '01', 1), 'YYYYMMDD')
    
    			--PRINT v_LAST_MONTH_EDI
    
    			--SELECT v_LAST_MONTH_EDI = CUST_FCST_M FROM DM_ANL_MKT_PSI  WHERE 1=1
    			--AND PROJECT_CODE = p_project_code
    			--AND YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm_to_simul + '01', 1), 'YYYYMMDD') AND MEASURE = 'DP_RESULT'
    		END;
    
    
    		BEGIN
    			--SELECT * FROM GT_DMF0_DATA WHERE YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i-1), 'YYYYMMDD')
    
    
    			v_DP_ANL_SUM := TO_NUMBER(v_DP_RESULT_SUM/v_EDI_SUM);
    			v_DP_ANL_P := TO_NUMBER(v_DP_RESULT_P/v_EDI_SUM);
    			v_DP_ANL_S := TO_NUMBER(v_DP_RESULT_S/v_EDI_SUM);
    			v_DP_ANL_I := TO_NUMBER(v_DP_RESULT_I/v_EDI_SUM);
    			v_DP_ANL_V := TO_NUMBER(v_DP_RESULT_V/v_EDI_SUM);
    			v_DP_ANL_M := TO_NUMBER(v_DP_RESULT_M/v_EDI_SUM);
    			v_DP_ANL_CP := TO_NUMBER(v_DP_RESULT_CP/v_EDI_SUM);
    
    			--SELECT v_DP_ANL_SUM, v_DP_ANL_P
    		END;
    
    		--PRINT TO_NUMBER(NVL(v_DP_ANL_SUM, 0))
    
    		DBMS_OUTPUT.PUT_LINE(v_EDI_SUM);
    
    		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_SUM, 0)) * 100) || '%');
    		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_P, 0))* 100) || '%');
    		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_S, 0))* 100) || '%');
    		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_I, 0))* 100) || '%');
    		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_V, 0))* 100) || '%');
    		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_M, 0))* 100) || '%');
    		DBMS_OUTPUT.PUT_LINE((TO_NUMBER(NVL(v_DP_ANL_CP, 0))* 100) || '%');
    
    		BEGIN
    		    UPDATE GT_DMF0_DATA SET;
    			SUM        = ((TO_NUMBER(NVL(v_DP_ANL_SUM, 0)) * 100) || '%')  --(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_SUM, 0), 3)) * 100) || '%')
    			,((TO_NUMBER(NVL(v_DP_ANL_P AS PRODUCT, 0)) * 100) || '%')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_P, 0), 3)) * 100) || '%')
    			,((TO_NUMBER(NVL(v_DP_ANL_S AS SALE, 0)) * 100) || '%')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_S, 0), 3)) * 100) || '%')
    			,((TO_NUMBER(NVL(v_DP_ANL_I AS INVENTORY, 0)) * 100) || '%')  --(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_I, 0), 3)) * 100) || '%')
    			,((TO_NUMBER(NVL(v_DP_ANL_V AS TIME_ADJUST, 0)) * 100) || '%')  --(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_V, 0), 3)) * 100) || '%')
    			,((TO_NUMBER(NVL(v_DP_ANL_M AS MODEL_MIX, 0)) * 100) || '%')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_M, 0), 3)) * 100) || '%')
    			,((TO_NUMBER(NVL(v_DP_ANL_CP AS SUPPLY_ISSUE, 0)) * 100) || '%')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_CP, 0), 3)) * 100) || '%')
    			--, PRODUCT = v_DP_ANL_P, SALE = v_DP_ANL_S, INVENTORY = v_DP_ANL_I, TIME_ADJUST = v_DP_ANL_V, MODEL_MIX = v_DP_ANL_M
    			WHERE YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm_to_simul  ||  '01', 1), 'YYYYMMDD')    AND MEASURE = 'Average impact(%)';
    		END;
    
    
    		DBMS_OUTPUT.PUT_LINE(v_LAST_MONTH_EDI);
    
    		BEGIN
    		    UPDATE GT_DMF0_DATA SET;
    			SUM        = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_SUM, 0), 3)) * v_LAST_MONTH_EDI), '#,#')
    			,PRODUCT     = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_P, 0), 3)) * v_LAST_MONTH_EDI), '#,#') --(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_P, 0), 2)) * 100) || '%')
    			,SALE        = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_S, 0), 3)) * v_LAST_MONTH_EDI), '#,#')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_S, 0), 2)) * 100) || '%')
    			,INVENTORY   = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_I, 0), 3)) * v_LAST_MONTH_EDI), '#,#')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_I, 0), 2)) * 100) || '%')
    			,TIME_ADJUST = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_V, 0), 3)) * v_LAST_MONTH_EDI), '#,#')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_V, 0), 2)) * 100) || '%')
    			,MODEL_MIX   = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_M, 0), 3)) * v_LAST_MONTH_EDI), '#,#')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_M, 0), 2)) * 100) || '%')
    			,SUPPLY_ISSUE   = TO_CHAR(CEILING(TO_NUMBER(ROUND(NVL(v_DP_ANL_CP, 0), 3)) * v_LAST_MONTH_EDI), '#,#')--(TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_CP, 0), 2)) * 100) || '%')
    			--, PRODUCT = v_DP_ANL_P, SALE = v_DP_ANL_S, INVENTORY = v_DP_ANL_I, TIME_ADJUST = v_DP_ANL_V, MODEL_MIX = v_DP_ANL_M
    			WHERE YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm_to_simul  ||  '01', 1), 'YYYYMMDD')    AND MEASURE = 'Simulation (Impact)';
    		END;
    
    
    
    	SELECT T.DIVISION_ID
    		,T.END_CUSTOMER
    		,T.PROJECT_NAME
    		,T.PROJECT_CODE
    		,(SUBSTR(YYYYMM, 1, 4) || '.' || SUBSTR(YYYYMM, 5, 2)) AS YYYYMM
    		,CEILING(EDI_QTY) AS EDI_QTY
    		,MEASURE
    		,SUM
    		,PRODUCT
    		,SALE
    		,INVENTORY
    		,TIME_ADJUST
    		,MODEL_MIX
    		,MKT_DP
    		,SUPPLY_ISSUE   --2023.11.03 kcw3408 	개발요청 수요분석시스템_35번	Simulation 기능 로직 수정(신규 추가된 '공급차질' 카테고리를 연계하도록)
    	FROM GT_DMF0_DATA T
    	ORDER BY YYYYMM ASC
    		,RNK;
    END IF;

    PROCEDURE P_DMF0003_GET_DM_ANL_MKT_PSI_DATA (
    	 p_division_id VARCHAR2
    	,p_project_code VARCHAR2
    	,p_project_name VARCHAR2
    	,p_yyyymm VARCHAR2
    	,p_created_by VARCHAR2
    	,p_end_customer VARCHAR2
    )
        IS
    /*
     * ========================================
     * [변환검증] 2026-03-02 20:36:59
     * 파일: dbo.DMF0003_GET_DM_ANL_MKT_PSI_DATA.sql
     * ----------------------------------------
     * ⚠ IF: IF:8  END IF:9  차이:-1
     * ⚠ BEGIN: BEGIN:21  END:15  차이:+6
     * ----------------------------------------
     * BEGIN 위치: L38, L77, L91, L99, L127, L152, L171, L216, L230, L233 ...
     * END;  위치: L89, L124, L144, L163, L165, L210, L226, L453, L475, L496 ...
     * ----------------------------------------
     * 힌트: END가 8개 더 많음 → 고아 END; 확인 필요
     * 수정 완료 후 이 주석 블록을 삭제하세요.
     * ========================================
     */
    
    
        V_CNT INTEGER := 0;
        v_yyyymm VARCHAR2(20 CHAR);
        v_CUST_FCST_M VARCHAR2(4000 CHAR);
        v_MKT_FCST_S VARCHAR2(4000 CHAR);
        v_MKT_FCST_R VARCHAR2(4000 CHAR);
        v_0month_tuesday VARCHAR2(08 CHAR);
        v_0month VARCHAR2(6 CHAR);
        v_1month VARCHAR2(6 CHAR);
    BEGIN
    
    		,v_i INTEGER = 1
    
    
    
    
    	    v_DP_RESULT_SUM NUMERIC(20, 10);
    	    v_DP_RESULT_P NUMERIC(20, 10);
    	    v_DP_RESULT_S NUMERIC(20, 10);
    	    v_DP_RESULT_I NUMERIC(20, 10);
    	    v_DP_RESULT_V NUMERIC(20, 10);
    	    v_DP_RESULT_M NUMERIC(20, 10);
    	    v_DP_RESULT_CP NUMERIC(20, 10);
    	    v_EDI_SUM NUMERIC(20, 10);
    	    v_DP_ANL_SUM NUMERIC(20, 10);
    	    v_DP_ANL_P NUMERIC(20, 10);
    	    v_DP_ANL_S NUMERIC(20, 10);
    	    v_DP_ANL_I NUMERIC(20, 10);
    	    v_DP_ANL_V NUMERIC(20, 10);
    	    v_DP_ANL_M NUMERIC(20, 10);
    	    v_DP_ANL_CP NUMERIC(20, 10);
    	    v_DP_ANL_CPI NUMERIC(20, 10);
    
    
    
    
    	v_0month := TO_CHAR(SYSDATE, 'YYYYMMDD'); --M0 당월
    	v_1month := TO_CHAR(ADD_MONTHS(SYSDATE, - 1), 'YYYYMMDD'); --M-1 전월
    	v_i := - 12;
    
    	-- 테이블중복제거
    	-- 임시확인용테이블 중복제거
    	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DATA';
    
    	-- 테이블중복제거
    	-- 임시확인용테이블 중복제거
    	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DM_MST_VERSION';
    
    	BEGIN
    		-- 테이블중복제거
    		-- 임시확인용테이블 중복제거
    		/* TODO:GTT:GT_DMF0_PROJECT_CODE-->GT_DMF0_PROJECT_CODE */
    		INSERT INTO GT_DMF0_PROJECT_CODE
    		SELECT *
    		FROM (
    			SELECT PROJECT_CODE
    			FROM SCM_MST_PROJECT
    			WHERE DIVISION_ID = p_division_id
    				AND PROJECT_NAME = p_project_name
    			) A;
    	END;
    
    	BEGIN
    		--월의 첫날이 수요일인 경우 전달의 마지막 MKT_FCST Cutoff 일자를 사용한다.
    		IF DATEPART(WEEKDAY, SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)  ||  '01') = '4' THEN
    			v_0month_tuesday := TO_CHAR(/* TODO:(FN_NEXT_DAY(TO_CHAR(SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6) + (- 1) * 7 + '01', 'YYYYMMDD'), 'TUE')) */, 'YYYYMMDD');
    		ELSE
    			v_0month_tuesday := TO_CHAR(1 || (/* TODO:DATEDIFF(WK,0,(SYSDATE) + (5 - DATEPART(DAY, SYSDATE) */)))*7SYSDATE || (5 - DATEPART(DAY, SYSDATE))), 1), 'YYYYMMDD'); --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
    		END IF;
    
    		BEGIN
    			INSERT INTO GT_DMF0_DM_MST_VERSION (;
    				NUM
    				,VERSION_NO
    				,VERSION_TYPE
    				)
    			SELECT ROW_NUMBER() OVER (
    					ORDER BY X.VERSION_NO
    					) AS NUM
    				,X.VERSION_NO
    				,X.VERSION_TYPE
    			FROM (
    				SELECT ROW_NUMBER() OVER (
    						PARTITION BY A.VERSION_TYPE ORDER BY A.VERSION_NO DESC
    						) AS RNK
    					,A.VERSION_NO
    					,A.VERSION_TYPE
    				FROM DM_MST_VERSION A
    				JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD
    				WHERE 1 = 1
    					AND A.DIVISION_ID = p_division_id
    					AND A.VERSION_TYPE = 'MF_W' --MKT_FCST Weekly Cutoff
    					AND A.YYYYMMDD = v_0month_tuesday
    				) X;
    			WHERE RNK = 1;
    		END;
    
    		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------
    		BEGIN
    	    	-- 테이블중복제거
    	       	-- 임시확인용테이블 중복제거
    		    /* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
    		    INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
    		    SELECT *
    			FROM DM_MST_ITEM_SINGLE_V
    			WHERE DIVISION_ID = p_division_id
    				AND ITEM_ID IN (
    					SELECT ITEM_ID
    					FROM SCM_MST_PROJECT_ITEM
    					WHERE PROJECT_CODE = p_project_code --PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    						AND VALID_YN = 'Y'
    					)
    				AND ITEM_TYPE = 'P'
    				AND ACTIVE_FLAG = 'Y';
    				--AND ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_PROJECT_ITEM WHERE PROJECT_CODE = p_project_code AND VALID_YN = 'Y') AND ITEM_TYPE = 'P' AND ACTIVE_FLAG = 'Y'
    		END;
    			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------
    
    
    
    
    
    		--SCM_MST_SITE 대상건만 추출
    		BEGIN
            	-- 테이블중복제거
            	-- 임시확인용테이블 중복제거
            	/* TODO:GTT:GT_DMF0_SCM_MST_SITE-->GT_DMF0_SCM_MST_SITE */
            	INSERT INTO GT_DMF0_SCM_MST_SITE
            	SELECT DIVISION_ID
    			     , SCM_SITE_ID
    				 , END_CUSTOMER
    			FROM SCM_MST_SITE
    			WHERE DIVISION_ID  = p_division_id
    	          AND END_CUSTOMER = p_end_customer;
    		END;
    
    	END;
    
    DBMS_OUTPUT.PUT_LINE('A1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    	/*
    	   2023.11.02	   kcw3408		  DP_RESULT(Demand Plan (final)) ⓓMKT.FCST (DP) 에 MKTFCST 화면에 월 MKT FCST[R || P] Measure실적과 동일하게 관리
        */
    	BEGIN
    
    		UPDATE T1
    		SET MKT_FCST_M = T2.A_QTY
    		FROM DM_ANL_MKT_PSI T1
    		JOIN
    		    (SELECT X.DIVISION_ID
    			      , H.END_CUSTOMER
    			      , X.PROJECT_CODE
    				  , SUBSTR(X.YYYYMMDD, 1, 6) AS YYYYMM
    			      , NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
    			   FROM DM_PLN_MKT_FCST_RESULT X
    			   JOIN SCM_MST_SITE_ITEM F
    				    ON	F.DIVISION_ID    = X.DIVISION_ID
    				   AND	F.PROJECT_CODE   = X.PROJECT_CODE
    				   AND	F.SCM_SITE_ID    = X.SCM_SITE_ID
    				   AND	F.ITEM_ID        = X.ITEM_ID
    			   JOIN GT_DMF0_SCM_MST_SITE H
    				    ON	F.DIVISION_ID    = H.DIVISION_ID
    				   AND	F.SCM_SITE_ID    = H.SCM_SITE_ID
    			  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G
    			       ON	G.SEGMENT1    = X.FCST_TYPE
    				  AND	G.LOOKUP_TYPE = 'SALES_TYPE_CODE'
    		      WHERE 1 = 1
    		        AND X.DIVISION_ID = p_division_id
    			    AND X.PROJECT_CODE = p_project_code
    	            AND X.MEASURE = 'RTF_SYS_RP'
    				AND SUBSTR(X.YYYYMMDD, 1, 6) >= TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', -12), 'YYYYMMDD')
    				AND SUBSTR(X.YYYYMMDD, 1, 6) <= TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', -1), 'YYYYMMDD')
    			GROUP BY X.DIVISION_ID
    			      , H.END_CUSTOMER
    			      , X.PROJECT_CODE
    				  , SUBSTR(X.YYYYMMDD, 1, 6)
    		  ) T2;
    		 ON T2.DIVISION_ID = T1.DIVISION_ID
    		AND T2.PROJECT_CODE = T1.PROJECT_CODE
    		AND T2.END_CUSTOMER = T1.END_CUSTOMER
    		AND T2.YYYYMM = T1.YYYYMM
    		AND T1.MEASURE = 'DP_RESULT';
    	END;
    
    
    DBMS_OUTPUT.PUT_LINE('B1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    	--SELECT * FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    	WHILE v_i <= 0 LOOP
    		BEGIN
    			SELECT COUNT(*)
      INTO V_CNT
    			FROM DM_ANL_MKT_PSI
    			WHERE 1 = 1
    				AND DIVISION_ID = p_division_id
    				--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    				AND PROJECT_CODE = p_project_code
    				AND END_CUSTOMER = p_end_customer
    				AND YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD');
    		END;
    
    DBMS_OUTPUT.PUT_LINE('C1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    		BEGIN
    			IF v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') THEN
    				--고객수요계획
    				BEGIN
    					IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
    						SELECT (A_QTY  ||  B_QTY)
      INTO v_CUST_FCST_M
    						FROM (
    							SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
    							FROM DM_PLN_MKT_FCST_C X
    							JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    							JOIN GT_DMF0_SCM_MST_SITE Z
    							ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    							WHERE 1 = 1
    								AND X.DIVISION_ID = p_division_id
    								AND X.MEASURE IN (;
    									'CUST_FCST_EDI'
    									,'CUST_FCST'
    									)
    								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    								AND X.PROJECT_CODE = p_project_code
    								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    								AND X.ITEM_ID IN (
    									SELECT ITEM_ID
    									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    									)
    								AND X.FCST_TYPE = 'MPS'
    								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    								AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
    								AND X.QTY <> 0
    							) A;
    							,(
    								SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
    								FROM DM_PLN_MKT_FCST_RESULT_C X
    								JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    							    JOIN GT_DMF0_SCM_MST_SITE Z
    						     	ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    								WHERE 1 = 1
    									AND X.DIVISION_ID = p_division_id
    									AND X.MEASURE IN (;
    										'CUST_FCST_EDI'
    										,'CUST_FCST'
    										)
    									--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    									AND X.PROJECT_CODE = p_project_code
    									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    									AND X.ITEM_ID IN (
    										SELECT ITEM_ID
    										FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    										)
    									AND X.FCST_TYPE = 'MPS'
    									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    									AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
    								) B;
    DBMS_OUTPUT.PUT_LINE('i : '  ||  TO_CHAR(v_i));
    DBMS_OUTPUT.PUT_LINE('0month_tuesday : '  ||  v_0month_tuesday);
    DBMS_OUTPUT.PUT_LINE('CUST_FCST_M : '  ||  v_CUST_FCST_M);
    					ELSE
    						SELECT 0
      INTO v_CUST_FCST_M
    				END IF;
    
    DBMS_OUTPUT.PUT_LINE('D1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    				--마케팅수요계획
    				BEGIN
    					IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
    						SELECT (A_QTY  ||  B_QTY)
      INTO v_MKT_FCST_S
    						FROM (
    							SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
    							FROM DM_PLN_MKT_FCST_C X
    							JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    							JOIN GT_DMF0_SCM_MST_SITE Z
    							ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    							WHERE 1 = 1
    								AND X.DIVISION_ID = p_division_id
    								AND X.MEASURE = 'RTF_SYS_RP'
    								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    								AND X.PROJECT_CODE = p_project_code
    								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    								AND X.ITEM_ID IN (
    									SELECT ITEM_ID
    									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    									)
    								AND X.FCST_TYPE = 'MPS'
    								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    								AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
    								AND X.QTY <> 0
    							) A;
    							,(
    								SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
    								FROM DM_PLN_MKT_FCST_RESULT_C X
    								JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    						    	JOIN GT_DMF0_SCM_MST_SITE Z
    							    ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    								WHERE 1 = 1
    									AND X.DIVISION_ID = p_division_id
    									AND X.MEASURE = 'RTF_SYS_RP'
    									--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    									AND X.PROJECT_CODE = p_project_code
    									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    									AND X.ITEM_ID IN (
    										SELECT ITEM_ID
    										FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    										)
    									AND X.FCST_TYPE = 'MPS'
    									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    									AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
    								) B;
    					ELSE
    						SELECT v_MKT_FCST_S = 0
    
    DBMS_OUTPUT.PUT_LINE('E1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    					IF TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_1month
    		             OR (V_CNT = 0) THEN
    					    /* 2023.11.02	   kcw3408		  전월 실적 구하기 ,기존로직 삭제
    						SELECT v_MKT_FCST_R = (A_QTY || B_QTY)
    						FROM (
    							SELECT NVL(CEILING(SUM(QTY)), 0) AS A_QTY
    							FROM DM_PLN_MKT_FCST_C X
    							JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    							WHERE 1 = 1
    								AND DIVISION_ID = p_division_id
    								AND MEASURE = 'RTF_SYS_RP'
    								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    								AND PROJECT_CODE = p_project_code
    								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    								AND ITEM_ID IN (
    									SELECT ITEM_ID
    									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    									)
    								AND X.FCST_TYPE = 'MPS'
    								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    								AND SUBSTR(YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', - 1), 'YYYYMMDD')
    								AND QTY <> 0
    							) A;
    							,(
    								SELECT NVL(CEILING(SUM(QTY)), 0) AS B_QTY
    								FROM DM_PLN_MKT_FCST_RESULT_C X
    								JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    								WHERE 1 = 1
    									AND DIVISION_ID = p_division_id
    									AND MEASURE = 'RTF_SYS_RP'
    									--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    									AND PROJECT_CODE = p_project_code
    									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    									AND ITEM_ID IN (
    										SELECT ITEM_ID
    										FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    										)
    									AND X.FCST_TYPE = 'MPS'
    									--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    									AND SUBSTR(YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', - 1), 'YYYYMMDD')
    								) B;
    					    */
    						SELECT v_MKT_FCST_R = A.A_QTY
    						FROM (
    								SELECT NVL(CEILING(SUM(QTY)), 0) AS A_QTY
    								FROM DM_PLN_MKT_FCST_RESULT X
    		                        JOIN SCM_MST_SITE_ITEM F
    				                     ON	F.DIVISION_ID    = X.DIVISION_ID
    				                    AND	F.PROJECT_CODE   = X.PROJECT_CODE
    			                        AND	F.scm_site_id    = X.scm_site_id
                                        AND	F.ITEM_ID        = X.ITEM_ID
    			                   JOIN GT_DMF0_SCM_MST_SITE H
    				                    ON	F.DIVISION_ID    = H.DIVISION_ID
    				                   AND	F.SCM_SITE_ID    = H.SCM_SITE_ID
    			                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G
    			                        ON	G.SEGMENT1    = X.FCST_TYPE
    				                   AND	G.LOOKUP_TYPE = 'SALES_TYPE_CODE'
    								WHERE 1 = 1
    									AND X.DIVISION_ID = p_division_id
    									AND X.MEASURE = 'RTF_SYS_RP'
    									AND X.PROJECT_CODE = p_project_code
    									AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
    							) A;
    					ELSE
    						SELECT v_MKT_FCST_R = 0
    				END IF;
    
    DBMS_OUTPUT.PUT_LINE('F1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    			ELSE
    				SELECT 0,
        0,
        0
      INTO v_CUST_FCST_M, v_MKT_FCST_S, v_MKT_FCST_R
    		END IF;
    
    		DBMS_OUTPUT.PUT_LINE('=================================');
    		DBMS_OUTPUT.PUT_LINE(p_yyyymm);
    		DBMS_OUTPUT.PUT_LINE(v_0month_tuesday);
    		DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYYMMDD'));
    		DBMS_OUTPUT.PUT_LINE(TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD'));
    		DBMS_OUTPUT.PUT_LINE(v_0month);
    		DBMS_OUTPUT.PUT_LINE(V_CNT);
    		DBMS_OUTPUT.PUT_LINE(v_CUST_FCST_M);
    		DBMS_OUTPUT.PUT_LINE('=================================');
    
    DBMS_OUTPUT.PUT_LINE('G1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    		IF (V_CNT = 0) THEN
    			IF v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
    				AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month THEN
    				BEGIN
    					INSERT INTO GT_DMF0_DATA
    					SELECT p_division_id
    						,p_end_customer
    						,p_project_name
    						,p_project_code
    						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
    						,v_CUST_FCST_M
    						,'Average impact(%)'
    						,'0%'
    						,'0%'
    						,'0%'
    						,'0%'
    						,'0%'
    						,'0%'
    						,'0%'
    						,NULL
    						,'1' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    				END;
    
    DBMS_OUTPUT.PUT_LINE('H1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    				BEGIN
    					INSERT INTO GT_DMF0_DATA
    					SELECT p_division_id
    						,p_end_customer
    						,p_project_name
    						,p_project_code
    						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
    						,v_CUST_FCST_M
    						,'Simulation (Impact)'
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,'2' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    				END;
    
    DBMS_OUTPUT.PUT_LINE('I1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    				BEGIN
    					INSERT INTO GT_DMF0_DATA
    					SELECT p_division_id
    						,p_end_customer
    						,p_project_name
    						,p_project_code
    						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
    						,v_CUST_FCST_M
    						,'Demand Plan (1st)'
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,CEILING(v_MKT_FCST_S)
    						,'3' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    				END;
    
    DBMS_OUTPUT.PUT_LINE('J1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    				BEGIN
    					INSERT INTO GT_DMF0_DATA
    					SELECT p_division_id
    						,p_end_customer
    						,p_project_name
    						,p_project_code
    						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
    						,v_CUST_FCST_M
    						,'Demand Plan (final)'
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,CEILING(v_MKT_FCST_R)
    						,'4' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    				END;
    
    DBMS_OUTPUT.PUT_LINE('K1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    			ELSE
    				BEGIN
    					INSERT INTO GT_DMF0_DATA
    					SELECT p_division_id
    						,p_end_customer
    						,p_project_name
    						,p_project_code
    						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
    						,0
    						,'Average impact(%)'
    						,'0%'
    						,'0%'
    						,'0%'
    						,'0%'
    						,'0%'
    						,'0%'
    						,'0%'
    						,NULL
    						,'1' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    				END;
    
    DBMS_OUTPUT.PUT_LINE('L1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    				BEGIN
    					INSERT INTO GT_DMF0_DATA
    					SELECT p_division_id
    						,p_end_customer
    						,p_project_name
    						,p_project_code
    						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
    						,0
    						,'Simulation (Impact)'
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,'2' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    				END;
    DBMS_OUTPUT.PUT_LINE('M1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    				BEGIN
    					INSERT INTO GT_DMF0_DATA
    					SELECT p_division_id
    						,p_end_customer
    						,p_project_name
    						,p_project_code
    						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
    						,0
    						,'Demand Plan (1st)'
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,CEILING(v_MKT_FCST_S)
    						,'3' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    				END;
    
    DBMS_OUTPUT.PUT_LINE('N1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    				BEGIN
    					INSERT INTO GT_DMF0_DATA
    					SELECT p_division_id
    						,p_end_customer
    						,p_project_name
    						,p_project_code
    						,TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
    						,0
    						,'Demand Plan (final)'
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,CEILING(v_MKT_FCST_R)
    						,'4' --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    				END;
    DBMS_OUTPUT.PUT_LINE('O1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    		ELSE
    			-- 고객수요증감분석 전체조회
    			---SELECT v_0month_tuesday, TO_CHAR(SYSDATE, 'YYYYMMDD') , TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD'), v_0month
    			INSERT INTO GT_DMF0_DATA
    			SELECT T1.DIVISION_ID AS DIVISION_ID
    				,p_end_customer
    				,p_project_name
    				,p_project_code
    				,T1.YYYYMM AS YYYYMM
    				,(
    					CASE
    						WHEN NVL(T1.CUST_FCST_M, 0) = 0
    							THEN v_CUST_FCST_M
    						WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
    							AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month;
    							THEN v_CUST_FCST_M
    						ELSE CEILING(T1.CUST_FCST_M)
    						END IF;
    					) AS EDI_QTY
    				,(
    					CASE T1.MEASURE
    						WHEN 'AN_LOGIC'
    							THEN 'Average impact(%)'
    						WHEN 'AN_RESULT'
    							THEN 'Simulation (Impact)'
    						WHEN 'DP_INIT'
    							THEN 'Demand Plan (1st)'
    						WHEN 'DP_RESULT'
    							THEN 'Demand Plan (final)'
    						END IF;
    					) AS MEASURE
    				,(
    					CASE
    						WHEN T1.MEASURE = 'AN_LOGIC'
    							THEN (TO_CHAR((ROUND(TO_NUMBER(T2.VSUM), 2))) || '%')
    						ELSE TO_CHAR(CEILING(T2.VSUM), '#,#')
    						END IF;
    					) AS SUM
    				,(
    					CASE
    						WHEN T1.MEASURE = 'AN_LOGIC'
    							THEN (TO_CHAR(ROUND(TO_NUMBER(T1.P_VALUE), 2)) || '%')
    						ELSE TO_CHAR(CEILING(T1.P_VALUE), '#,#')
    						END;
    					) AS PRODUCT
    				,(
    					CASE
    						WHEN T1.MEASURE = 'AN_LOGIC'
    							THEN (TO_CHAR((ROUND(TO_NUMBER(T1.S_VALUE), 2))) || '%')
    						ELSE TO_CHAR(CEILING(T1.S_VALUE), '#,#')
    						END;
    					) AS SALE
    				,(
    					CASE
    						WHEN T1.MEASURE = 'AN_LOGIC'
    							THEN (TO_CHAR((ROUND(TO_NUMBER(T1.I_VALUE), 2))) || '%')
    						ELSE TO_CHAR(CEILING(T1.I_VALUE), '#,#')
    						END IF;
    					) AS INVENTORY
    				,(
    					CASE
    						WHEN T1.MEASURE = 'AN_LOGIC'
    							THEN (TO_CHAR((ROUND(TO_NUMBER(T1.V_VALUE), 2))) || '%')
    						ELSE TO_CHAR(CEILING(T1.V_VALUE), '#,#')
    						END;
    					) AS TIME_ADJUST
    				,(
    					CASE
    						WHEN T1.MEASURE = 'AN_LOGIC'
    							THEN (TO_CHAR((ROUND(TO_NUMBER(T1.M_VALUE), 2))) || '%')
    						ELSE TO_CHAR(CEILING(T1.M_VALUE), '#,#')
    						END LOOP;
    					) AS MODEL_MIX
    				,(
    					CASE
    						WHEN T1.MEASURE = 'AN_LOGIC'
    							THEN (TO_CHAR((ROUND(TO_NUMBER(NVL(T1.CP_VALUE, 0)), 2))) || '%')
    						ELSE TO_CHAR(CEILING(NVL(T1.CP_VALUE, 0)), '#,#')
    						END;
    					) AS SUPPLY_ISSUE --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    				,(
    					CASE
    						WHEN T1.MEASURE = 'AN_RESULT'
    							THEN (
    									CASE
    										WHEN NVL(T1.MKT_FCST_M, 0) = 0
    											THEN 0
    										ELSE CEILING(T1.MKT_FCST_M)
    										END;
    									)
    						WHEN T1.MEASURE = 'DP_INIT'
    							THEN (
    									CASE
    										WHEN NVL(T1.MKT_FCST_M, 0) = 0
    											THEN CEILING(v_MKT_FCST_S)
    										WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
    											AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month;
    											THEN CEILING(v_MKT_FCST_S)
    										ELSE CEILING(T1.MKT_FCST_M)
    										END;
    									)
    						WHEN T1.MEASURE = 'DP_RESULT'
    							THEN (
    									CASE
    										WHEN NVL(T1.MKT_FCST_M, 0) = 0
    										THEN CEILING(v_MKT_FCST_R)
    												--WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD') = v_1month THEN
    												-- CEILING(v_MKT_FCST_R)
    										WHEN v_0month_tuesday <= TO_CHAR(SYSDATE, 'YYYYMMDD')
    											AND TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD') = v_0month;
    											THEN CEILING(v_MKT_FCST_R)
    										ELSE CEILING(T1.MKT_FCST_M)
    										END;
    									)
    						ELSE NULL
    						END;
    					) MKT_DP;
    				,(
    					CASE
    						WHEN T1.MEASURE = 'AN_LOGIC'
    							THEN '1'
    						WHEN T1.MEASURE = 'AN_RESULT'
    							THEN '2'
    						WHEN T1.MEASURE = 'DP_INIT'
    							THEN '3'
    						ELSE '4'
    						END;
    					) RNK;
    			FROM DM_ANL_MKT_PSI T1
    			LEFT OUTER JOIN (
    				SELECT PROJECT_CODE
    			      	,END_CUSTOMER
    					,YYYYMM
    					,MEASURE
    					,SUM(VVALUE) AS VSUM
    				FROM DM_ANL_MKT_PSI;
    				UNPIVOT(VVALUE FOR VLIST IN (
    							P_VALUE
    							,S_VALUE
    							,I_VALUE
    							,V_VALUE
    							,M_VALUE
    							,CP_VALUE
    							)) AS UPV_RST --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    				GROUP BY PROJECT_CODE,END_CUSTOMER
    					,YYYYMM
    					,MEASURE
    				) T2 ON T1.PROJECT_CODE = T2.PROJECT_CODE
    				AND T1.END_CUSTOMER = T2.END_CUSTOMER
    				AND T1.YYYYMM = T2.YYYYMM
    				AND T1.MEASURE = T2.MEASURE
    			WHERE 1 = 1
    				AND T1.DIVISION_ID = p_division_id
    				AND T1.END_CUSTOMER = p_end_customer
    				AND T1.PROJECT_CODE = p_project_code -- IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    				--AND T1.PROJECT_CODE = p_project_code
    				AND T1.YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD');
    
    DBMS_OUTPUT.PUT_LINE('P1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    
    			IF v_i <= - 1 THEN
    				--SELECT TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD')
    				SELECT T1.CUST_FCST_M  ||  NVL(v_EDI_SUM, 0),
        T2.VSUM  ||  NVL(v_DP_RESULT_SUM, 0),
        T1.P_VALUE  ||  NVL(v_DP_RESULT_P, 0),
        T1.S_VALUE  ||  NVL(v_DP_RESULT_S, 0),
        T1.I_VALUE  ||  NVL(v_DP_RESULT_I, 0),
        T1.V_VALUE  ||  NVL(v_DP_RESULT_V, 0),
        T1.M_VALUE  ||  NVL(v_DP_RESULT_M, 0),
        NVL(T1.CP_VALUE, 0)  ||  NVL(v_DP_RESULT_CP, 0)
      INTO v_EDI_SUM, v_DP_RESULT_SUM, v_DP_RESULT_P, v_DP_RESULT_S, v_DP_RESULT_I, v_DP_RESULT_V, v_DP_RESULT_M, v_DP_RESULT_CP
    				FROM DM_ANL_MKT_PSI T1
    				LEFT OUTER JOIN (
    					SELECT PROJECT_CODE
    						,END_CUSTOMER
    						,YYYYMM
    						,MEASURE
    						,SUM(VVALUE) AS VSUM
    					FROM DM_ANL_MKT_PSI;
    					UNPIVOT(VVALUE FOR VLIST IN (
    								 P_VALUE
    								,S_VALUE
    								,I_VALUE
    								,V_VALUE
    								,M_VALUE
    								,CP_VALUE
    								)) AS UPV_RST --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    					GROUP BY PROJECT_CODE,END_CUSTOMER
    						,YYYYMM
    						,MEASURE
    					) T2 ON T1.PROJECT_CODE = T2.PROJECT_CODE
    					AND T1.YYYYMM = T2.YYYYMM
    					AND T1.END_CUSTOMER = T2.END_CUSTOMER
    					AND T1.MEASURE = T2.MEASURE
    				WHERE 1 = 1
    					AND T1.DIVISION_ID = p_division_id
    		     		AND T1.END_CUSTOMER = p_end_customer
    					AND T1.PROJECT_CODE = p_project_code -- IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    					AND T1.YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i), 'YYYYMMDD')
    					AND T1.MEASURE = 'DP_RESULT';
    			END IF;
    		END;
    
    
    		v_i := v_i || 1;
    			--		v_EDI_SUM
    	END;
    
    DBMS_OUTPUT.PUT_LINE('Q1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    	-- -----------------------------------------------------------------------------------------------------------------------------------------------
    	BEGIN
    
    		--SELECT * FROM GT_DMF0_DATA WHERE YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i-1), 'YYYYMMDD')
    		v_DP_ANL_SUM := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_SUM / v_EDI_SUM) END;
    		v_DP_ANL_P := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_P / v_EDI_SUM) END;
    		v_DP_ANL_S := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_S / v_EDI_SUM) END;
    		v_DP_ANL_I := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_I / v_EDI_SUM) END;
    		v_DP_ANL_V := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_V / v_EDI_SUM) END;
    		v_DP_ANL_M := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_M / v_EDI_SUM) END;
    		v_DP_ANL_CP := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE TO_NUMBER(v_DP_RESULT_CP / v_EDI_SUM) END; --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    			--SELECT v_DP_ANL_SUM
    	END;
    
    DBMS_OUTPUT.PUT_LINE('R1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    	--20240617 화면 조회불가로 임시조치 NUMBERIC(3, 2) -> NUMBERIC(5, 2)로 변경
    	BEGIN
    		UPDATE GT_DMF0_DATA
    		SET SUM = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_SUM, 0), 2)) * 100) || '%')
    			,PRODUCT = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_P, 0), 2)) * 100) || '%')
    			,SALE = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_S, 0), 2)) * 100) || '%')
    			,INVENTORY = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_I, 0), 2)) * 100) || '%')
    			,TIME_ADJUST = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_V, 0), 2)) * 100) || '%')
    			,MODEL_MIX = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_M, 0), 2)) * 100) || '%')
    			,SUPPLY_ISSUE = (TO_CHAR(TO_NUMBER(ROUND(NVL(v_DP_ANL_CP, 0), 2)) * 100) || '%') --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    			--, PRODUCT = v_DP_ANL_P, SALE = v_DP_ANL_S, INVENTORY = v_DP_ANL_I, TIME_ADJUST = v_DP_ANL_V, MODEL_MIX = v_DP_ANL_M
    		WHERE YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm  ||  '01', v_i - 1), 'YYYYMMDD')
    			AND MEASURE = 'Average impact(%)';
    	END;
    		-- -----------------------------------------------------------------------------------------------------------------------------------------------
    
    DBMS_OUTPUT.PUT_LINE('S1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    	SELECT T.DIVISION_ID
    		,T.END_CUSTOMER
    		,T.PROJECT_NAME
    		,T.PROJECT_CODE
    		,(SUBSTR(YYYYMM, 1, 4) || '.' || SUBSTR(YYYYMM, 5, 2)) AS YYYYMM
    		,CEILING(EDI_QTY) AS EDI_QTY
    		,MEASURE
    		,SUM
    		,PRODUCT
    		,SALE
    		,INVENTORY
    		,TIME_ADJUST
    		,MODEL_MIX
    		,MKT_DP
    		,SUPPLY_ISSUE --#2023.10.10	   chutoc730		  []  공급차질 수량을 구분하기 위한 Category 신규 추가#
    	FROM GT_DMF0_DATA T
    	ORDER BY YYYYMM ASC
    		,RNK;
    END P_DMF0003_GET_DM_ANL_MKT_PSI_DATA;

    PROCEDURE P_DMF0003_GET_PRPOPUP (
    	p_POPUP_TYPE		VARCHAR2,
        p_division_id		VARCHAR2,
    	p_REQUEST_NO		VARCHAR2,
        p_PROJECT_CODE		VARCHAR2,
        p_SCM_SITE_ID		VARCHAR2,
        p_ITEM_ID	        VARCHAR2,
    	p_DOM_EXP			VARCHAR2,
    	p_FCST_TYPE		VARCHAR2,
    	p_INCOTERMS		VARCHAR2,
    	p_PLANT_SITE_ID	VARCHAR2,
    	p_YYYYMMDD			VARCHAR2, --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
    	P_PLAN_QTY			VARCHAR2,
    	p_CREATED_BY		VARCHAR2
    )
        IS
    /*
     * ========================================
     * [변환검증] 2026-03-02 20:37:03
     * 파일: dbo.DMF0003_GET_PRPOPUP.sql
     * ----------------------------------------
     * ⚠ IF: IF:9  END IF:6  차이:+3
     * ----------------------------------------
     * BEGIN 위치: L55
     * END;  위치: L300
     * ----------------------------------------
     * 수정 완료 후 이 주석 블록을 삭제하세요.
     * ========================================
     */
    
    
    
        V_PUCH_MGR VARCHAR2(150 CHAR);
        V_DEPT_ID VARCHAR2(50 CHAR);
        v_cnt_1  INTEGER := 0;
    BEGIN
    
    			, V_PUCH_GROUP			VARCHAR2(150 CHAR)
    			, V_STORAGE_PLANT_ID	VARCHAR2(60 CHAR)
    			, V_ERR_MSG			VARCHAR2(1000 CHAR)
    			, v_ERR_CNT			VARCHAR2(10 CHAR)
    			, v_USER_NAME			VARCHAR2(150 CHAR)
    
    	-- 신규 REQUEST 일 경우 기존재하는 REQUEST 가 하나라도 있으면 에러처리한다.
    	IF ( p_POPUP_TYPE = 'Request_PR') THEN
    		/* TODO:GTT:GT_DMF0_-->GT_DMF0_ */
    		INSERT INTO GT_DMF0_
    		SELECT
    			P_DIVISION_ID AS DIVISION_ID
    			, B8.TOKEN AS YYYYMMDD
    			, P_PROJECT_CODE AS PROJECT_CODE
    			, B1.TOKEN AS ITEM_ID, B2.TOKEN AS PLAN_QTY
    			, B3.TOKEN AS DOM_EXP, B4.TOKEN AS FCST_TYPE
    			, B5.TOKEN AS INCOTERMS, B6.TOKEN AS PLANT_SITE_ID
    			, B7.TOKEN AS SCM_SITE_ID
    		FROM UF_FX_String_Split(p_ITEM_ID, '^') B1
    		LEFT OUTER JOIN UF_FX_String_Split(P_PLAN_QTY			, '^') B2  ON B1.NR = B2.NR
    		LEFT OUTER JOIN UF_FX_String_Split(p_DOM_EXP			, '^') B3  ON B1.NR = B3.NR
    		LEFT OUTER JOIN UF_FX_String_Split(p_FCST_TYPE			, '^') B4  ON B1.NR = B4.NR
    		LEFT OUTER JOIN UF_FX_String_Split(p_INCOTERMS				, '^') B5  ON B1.NR = B5.NR
    		LEFT OUTER JOIN UF_FX_String_Split(p_PLANT_SITE_ID			, '^') B6  ON B1.NR = B6.NR
    		LEFT OUTER JOIN UF_FX_String_Split(P_SCM_SITE_ID			, '^') B7  ON B1.NR = B7.NR
    		-- [C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
    		LEFT OUTER JOIN UF_FX_String_Split(p_YYYYMMDD				, '^') B8  ON B1.NR = B8.NR
    		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON B1.TOKEN = C.ITEM_ID
    		WHERE NVL(B1.TOKEN, NULL) IS NOT NULL;
    
    
    		/* TODO:GTT:GT_DMF0_ERR-->GT_DMF0_ERR */
    		INSERT INTO GT_DMF0_ERR
    		SELECT DISTINCT A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.YYYYMMDD
    		FROM GT_DMF0_ A
    		JOIN DM_PLN_PR_DETAIL B ON
    				A.DIVISION_ID	= B.DIVISION_ID
    			AND A.PROJECT_CODE	= B.PROJECT_CODE
    			AND A.SCM_SITE_ID	= B.SCM_SITE_ID
    			AND A.ITEM_ID		= B.ITEM_ID
    			AND A.DOM_EXP		= B.DOM_EXP
    			AND A.FCST_TYPE		= B.FCST_TYPE
    			AND A.INCOTERMS		= B.INCOTERMS
    			AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
    			AND A.YYYYMMDD		= B.YYYYMMDD
    
    		SELECT COUNT(1)
    		INTO v_cnt_1
    		FROM GT_DMF0_ERR;
    		IF v_cnt_1 > 0 THEN
    			SELECT COUNT(*)
      INTO V_ERR_CNT
    			FROM GT_DMF0_ERR
    
    			SELECT /*__INTO_V_ERR_MSG__*/ '[Sales Site:'  ||  RTRIM(SCM_SITE_ID)  ||  ']'
    				 ||  '[Model :'  ||  RTRIM(ITEM_ID)  ||  ']'
    				 ||  '[FCST Type :'  ||  RTRIM(FCST_TYPE)  ||  ']'
    				 ||  '[YYYYMMDd :'  ||  RTRIM(YYYYMMDD)  ||  ']'
    				 ||  '외 '  ||  V_ERR_CNT  ||  '건은 기 Request 가 생성된 건입니다. '
    			FROM GT_DMF0_ERR
    
    			SELECT V_ERR_MSG AS ERR_MSG
    			RETURN;
    
    		END IF;
    
    		IF NOT EXISTS (
    			SELECT DISTINCT A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.YYYYMMDD
    			FROM GT_DMF0_ A
    			JOIN DM_PLN_MKT_FCST B ON
    					A.DIVISION_ID	= B.DIVISION_ID
    				AND A.PROJECT_CODE	= B.PROJECT_CODE
    				AND A.SCM_SITE_ID	= B.SCM_SITE_ID
    				AND A.ITEM_ID		= B.ITEM_ID
    				AND A.DOM_EXP		= B.DOM_EXP
    				AND A.FCST_TYPE		= B.FCST_TYPE
    				AND A.INCOTERMS		= B.INCOTERMS
    				AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
    				AND A.YYYYMMDD		= B.YYYYMMDD
    				AND A.PLAN_QTY		= B.QTY				-- 수량까지 일치해야 한다.
    			WHERE B.DIVISION_ID = P_DIVISION_ID
    				AND B.MEASURE = 'BNPIn'
    				) THEN
    			SELECT 'BNP In 메저의 수량이 아직 등록되지 않았습니다.'  AS ERR_MSG
    			RETURN;
    		END IF;
    
    
    	-- POPUP_TYPE = View_PR 일 경우 MKT FCST 의 값을 이용해서 REQUEST_NO 를 찾아준다.
    	IF ( p_POPUP_TYPE = 'View_PR' AND p_REQUEST_NO IS NULL) THEN
    
    
    		SELECT p_REQUEST_NO = MAX(REQUEST_NO)
    		FROM DM_PLN_PR_DETAIL A
    		WHERE DIVISION_ID = P_DIVISION_ID
    			AND PROJECT_CODE	= P_PROJECT_CODE
    			AND SCM_SITE_ID		= P_SCM_SITE_ID
    			AND ITEM_ID			= P_ITEM_ID
    			AND DOM_EXP			= P_DOM_EXP
    			AND FCST_TYPE		= P_FCST_TYPE
    			AND INCOTERMS		= P_INCOTERMS
    			AND NVL(PLANT_SITE_ID, NULL)	= NVL(P_PLANT_SITE_ID, NULL)
    			AND YYYYMMDD		= P_YYYYMMDD;
    
    		IF NVL(p_REQUEST_NO, NULL) IS NULL THEN
    			SELECT 'PR 이 존재하지 않습니다.' AS ERR_MSG
    			RETURN;
    		END IF;
    
    	IF NVL(P_REQUEST_NO, NULL) IS NOT NULL THEN
    
    		-- DETAIL
    		SELECT A.ITEM_SEQ
    			, A.STORAGE_PLANT_ID
    			, FN_CHAR_TO_DATE(A.YYYYMMDD) AS YYYYMMDD
    			, A.PROJECT_CODE
    			, A.ITEM_ID
    			, B.ITEM_NAME AS ITEM_NAME
    			, B.ITEM_UOM AS ITEM_UOM
    			, A.PLAN_QTY AS QTY
    			, A.DOM_EXP
    			, A.FCST_TYPE
    			, A.INCOTERMS
    			, A.PLANT_SITE_ID
    			, A.SCM_SITE_ID
    			, A.STORAGE_ID AS SLOC
    			, A.PR_ITEM_DETAIL AS ITEM_DETAIL
    		FROM DM_PLN_PR_DETAIL A
    		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID AND A.DIVISION_ID = B.DIVISION_ID
    		WHERE A.DIVISION_ID = P_DIVISION_ID
    			AND A.REQUEST_NO = P_REQUEST_NO
    
    		-- HEADER
    		SELECT A.REQUEST_NO
    			, FN_GET_DIVISION_NAME(A.DIVISION_ID) AS DIVISION_NAME
    			, A.PUCH_MGR
    			, A.PUCH_GROUP
    			, SCM_ARR_SPL_VAL(A.LAST_UPDATED_BY, '^', 1) AS REQUESTED_BY
    			, A.LAST_UPDATE_DATE AS REQUEST_DATE
    			, A.PR_HEADER
    		FROM DM_PLN_PR_DETAIL A
    		WHERE DIVISION_ID = P_DIVISION_ID
    			AND REQUEST_NO = P_REQUEST_NO;
    
    	ELSE  -- 신규 또는 ADD
    
    		-- ADD HISTORY 일 경우 기존 데이터가 없으면 에러처리한다.
    		IF ( p_POPUP_TYPE = 'ADD_HISTORY' ) THEN
    			IF NOT EXISTS (
    				SELECT *
    				FROM DM_PLN_PR_DETAIL A
    				WHERE DIVISION_ID = P_DIVISION_ID
    					AND PROJECT_CODE	= P_PROJECT_CODE
    					AND SCM_SITE_ID		= P_SCM_SITE_ID
    					AND ITEM_ID			= P_ITEM_ID
    					AND DOM_EXP			= P_DOM_EXP
    					AND FCST_TYPE		= P_FCST_TYPE
    					AND INCOTERMS		= P_INCOTERMS
    					AND NVL(PLANT_SITE_ID, NULL)	= NVL(P_PLANT_SITE_ID, NULL)
    					AND YYYYMMDD		= P_YYYYMMDD
    					) THEN
    				SELECT '기존 PR 이 존재하지 않습니다.\r\n Request PR 을 이용해주세요.' AS ERR_MSG
    				RETURN;
    			END IF;
    
    		SELECT /*__INTO_V_PUCH_MGR__*/ SEGMENT1
    				, V_PUCH_GROUP = SEGMENT2
    		FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    		WHERE LOOKUP_TYPE = 'DM_PR_PUCH'
    
    		-- [C20210813-000004] 기본 plant 와 sloc 처리
    
    			, V_DEFAULT_PLANT VARCHAR2(50 CHAR)
    			, V_DEFAULT_SLOC	VARCHAR2(50 CHAR)
    
    		SELECT DEPT_ID,
        UserName
      INTO V_DEPT_ID, v_USER_NAME
    		FROM TB_FX_USER
    		WHERE USERID = p_CREATED_BY
    
    
    
    		-- DEPT 가 걸리면 W/S PLANT, 없으면 일반
    		SELECT /*__INTO_V_DEFAULT_PLANT__*/ SEGMENT1
    			, V_DEFAULT_SLOC = SEGMENT2
    		FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    		WHERE LOOKUP_TYPE = 'DM_PR_SLOC'
    			AND ATTRIBUTE2 LIKE '%'  ||  V_DEPT_ID  ||  '%';
    
    		IF V_DEFAULT_PLANT IS NULL THEN
    			SELECT /*__INTO_V_DEFAULT_PLANT__*/ SEGMENT1
    				, V_DEFAULT_SLOC = SEGMENT2
    			FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    			WHERE LOOKUP_TYPE = 'DM_PR_SLOC'
    				AND ATTRIBUTE2 IS NULL
    			ORDER BY DISPLAY_SEQ;
    
    		END IF;
    
    
    		-- DETAIL
    		SELECT
    			ROW_NUMBER() OVER ( ORDER BY B1.TOKEN ) AS ITEM_SEQ
    			, V_DEFAULT_PLANT AS STORAGE_PLANT_ID
    			-- [C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
    			, FN_CHAR_TO_DATE(B8.TOKEN) AS YYYYMMDD
    			, P_PROJECT_CODE AS PROJECT_CODE
    			, B1.TOKEN AS ITEM_ID
    			, C.ITEM_NAME, C.ITEM_UOM
    			, CASE WHEN p_POPUP_TYPE = 'ADD_HISTORY' THEN '' ELSE B2.TOKEN END AS QTY
    			, B3.TOKEN AS DOM_EXP, B4.TOKEN AS FCST_TYPE
    			, B5.TOKEN AS INCOTERMS, B6.TOKEN AS PLANT_SITE_ID
    			, B7.TOKEN AS SCM_SITE_ID
    			, V_DEFAULT_SLOC AS SLOC
    			, '' AS ITEM_DETAIL
    			, SYSDATE AS CREATION_DATE
    		FROM UF_FX_String_Split(p_ITEM_ID, '^') B1
    		LEFT OUTER JOIN UF_FX_String_Split(P_PLAN_QTY			, '^') B2  ON B1.NR = B2.NR
    		LEFT OUTER JOIN UF_FX_String_Split(p_DOM_EXP			, '^') B3  ON B1.NR = B3.NR
    		LEFT OUTER JOIN UF_FX_String_Split(p_FCST_TYPE			, '^') B4  ON B1.NR = B4.NR
    		LEFT OUTER JOIN UF_FX_String_Split(p_INCOTERMS				, '^') B5  ON B1.NR = B5.NR
    		LEFT OUTER JOIN UF_FX_String_Split(p_PLANT_SITE_ID			, '^') B6  ON B1.NR = B6.NR
    		LEFT OUTER JOIN UF_FX_String_Split(P_SCM_SITE_ID			, '^') B7  ON B1.NR = B7.NR
    		-- [C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
    		LEFT OUTER JOIN UF_FX_String_Split(p_YYYYMMDD				, '^') B8  ON B1.NR = B8.NR
    		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON B1.TOKEN = C.ITEM_ID AND C.DIVISION_ID = P_DIVISION_ID
    		WHERE NVL(B1.TOKEN, NULL) IS NOT NULL
    
    
    
    		-- HEADER
    		SELECT NULL AS REQUEST_NO
    			, FN_GET_DIVISION_NAME(P_DIVISION_ID) AS DIVISION_NAME
    			, V_PUCH_MGR AS PUCH_MGR
    			, V_PUCH_GROUP AS PUCH_GROUP
    			--, p_CREATED_BY AS REQUESTED_BY
    			, v_USER_NAME AS REQUESTED_BY
    			, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS REQUEST_DATE
    			, '' AS PR_HEADER
    
    	END IF;
    
    END P_DMF0003_GET_PRPOPUP;

    PROCEDURE P_DMF0003_GET_PR_HISTORY_POPUP (
    	p_POPUP_TYPE		VARCHAR2,
        p_division_id		VARCHAR2,
    	p_REQUEST_NO		VARCHAR2,
        p_PROJECT_CODE		VARCHAR2,
        p_SCM_SITE_ID		VARCHAR2,
        p_ITEM_ID	        VARCHAR2,
    	p_DOM_EXP			VARCHAR2,
    	p_FCST_TYPE		VARCHAR2,
    	p_INCOTERMS		VARCHAR2,
    	p_PLANT_SITE_ID	VARCHAR2,
    	p_YYYYMMDD			VARCHAR2,
    	P_PLAN_QTY			VARCHAR2,
    	p_CREATED_BY		VARCHAR2
    /*
    
    
    */
    )
        IS
    V_PUCH_MGR VARCHAR2(150 CHAR);
    BEGIN
    
    			, V_PUCH_GROUP			VARCHAR2(150 CHAR)
    			, V_STORAGE_PLANT_ID	VARCHAR2(60 CHAR)
    			, V_ERR_MSG			VARCHAR2(1000 CHAR)
    			, v_ERR_CNT			VARCHAR2(10 CHAR)
    
    
    	-- POPUP_TYPE = View_PR 일 경우 MKT FCST 의 값을 이용해서 REQUEST_NO 를 찾아준다.
    	IF ( p_POPUP_TYPE = 'View_HISTORY') THEN
    
    		-- MKT FCST UI 에서 받은 값을 이용해서 REQUEST NO 들을 찾는다.
    		/* TODO:GTT:GT_DMF0_-->GT_DMF0_ */
    		INSERT INTO GT_DMF0_
    		SELECT DIVISION_ID, REQUEST_NO, ITEM_SEQ
    		FROM DM_PLN_PR_DETAIL A
    		WHERE DIVISION_ID = P_DIVISION_ID
    			AND PROJECT_CODE	= P_PROJECT_CODE
    			AND SCM_SITE_ID		= P_SCM_SITE_ID
    			AND ITEM_ID			= P_ITEM_ID
    			AND DOM_EXP			= P_DOM_EXP
    			AND FCST_TYPE		= P_FCST_TYPE
    			AND INCOTERMS		= P_INCOTERMS
    			AND NVL(PLANT_SITE_ID, NULL)	= NVL(P_PLANT_SITE_ID, NULL)
    			AND YYYYMMDD		= P_YYYYMMDD;
    
    		IF NOT EXISTS ( SELECT * FROM GT_DMF0_ ) THEN
    			SELECT 'HISTORY가 존재하지 않습니다.' AS ERR_MSG
    		END IF;
    
    		-- DETAIL
    		SELECT B.REQUEST_NO, B.CREATION_DATE as REQUEST_DATE
    			, SCM_ARR_SPL_VAL(B.CREATED_BY, '^', 1) AS REQUESTED_BY
    			, B.PLAN_QTY as ITEM_QTY, B.PR_ITEM_DETAIL as ITEM_DETAIL
    			, B.PR_HEADER, B.PROJECT_CODE, B.ITEM_ID, C.ITEM_NAME, B.YYYYMMDD
    		FROM GT_DMF0_ A
    		JOIN DM_PLN_PR_DETAIL B ON A.REQUEST_NO = B.REQUEST_NO AND A.ITEM_SEQ = B.ITEM_SEQ AND A.DIVISION_ID = B.DIVISION_ID
    		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON B.ITEM_ID = C.ITEM_ID AND B.DIVISION_ID = C.DIVISION_ID
    		ORDER BY A.REQUEST_NO DESC;
    
    
    		-- HEADER
    		SELECTB.PR_HEADER, B.PROJECT_CODE, B.ITEM_ID, C.ITEM_NAME, B.YYYYMMDD
    		FROM GT_DMF0_ A
    		JOIN DM_PLN_PR_DETAIL B ON A.REQUEST_NO = B.REQUEST_NO AND A.ITEM_SEQ = B.ITEM_SEQ AND A.DIVISION_ID = B.DIVISION_ID
    		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON B.ITEM_ID = C.ITEM_ID AND B.DIVISION_ID = C.DIVISION_ID
    		ORDER BY A.REQUEST_NO DESC
    
    FETCH FIRST 1 ROWS ONLY
    	END IF;
    
    
    END P_DMF0003_GET_PR_HISTORY_POPUP;

    PROCEDURE P_DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL (
         p_division_id VARCHAR2
    	,p_project_code VARCHAR2
    	,p_yyyymm VARCHAR2
    	,p_cust_fcst_m VARCHAR2
    	,p_measure VARCHAR2
    	,p_qtycd1 VARCHAR2
    	,p_qtycd2 VARCHAR2
    	,p_qtycd3 VARCHAR2
    	,p_seq VARCHAR2
    	,p_qty VARCHAR2
    	,p_mkt_fcst_m VARCHAR2
    	,p_desc VARCHAR2
    	,p_input_limit VARCHAR2
    	,p_created_by VARCHAR2
    	,p_end_customer VARCHAR2
    )
        IS
    /*
     * ========================================
     * [변환검증] 2026-03-02 20:37:04
     * 파일: dbo.DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL.sql
     * ----------------------------------------
     * ⚠ IF: IF:26  END IF:13  차이:+13
     * ⚠ BEGIN: BEGIN:31  END:30  차이:+1
     * ----------------------------------------
     * BEGIN 위치: L86, L201, L213, L225, L237, L249, L263, L274, L297, L442 ...
     * END;  위치: L209, L221, L233, L245, L257, L271, L283, L310, L464, L527 ...
     * ----------------------------------------
     * 힌트: BEGIN이 3개 더 많음 → END; 누락 가능성
     * 수정 완료 후 이 주석 블록을 삭제하세요.
     * ========================================
     */
    
    
        v_DIVISION_ID VARCHAR2(4000 CHAR);
        v_END_CUSTOMER VARCHAR2(4000 CHAR);
        v_PROJECT_CODE VARCHAR2(4000 CHAR);
        v_YYYYMM VARCHAR2(4000 CHAR);
        v_CUST_FCST_M VARCHAR2(4000 CHAR);
        v_CUST_FCST_M_PRE VARCHAR2(4000 CHAR);
        v_MEASURE VARCHAR2(4000 CHAR);
        v_QTYCD1 VARCHAR2(4000 CHAR);
        v_QTYCD2 VARCHAR2(4000 CHAR);
        v_QTYCD3 VARCHAR2(4000 CHAR);
        v_SEQ VARCHAR2(4000 CHAR);
        v_QTY VARCHAR2(4000 CHAR);
        v_MKT_FCST_M VARCHAR2(4000 CHAR);
        v_DESC VARCHAR2(4000 CHAR);
        v_INPUT_LIMIT VARCHAR2(4000 CHAR);
        v_CREATED_BY VARCHAR2(4000 CHAR);
        v_CREATION_DATE VARCHAR2(4000 CHAR);
        v_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
        v_LAST_UPDATE_DATE VARCHAR2(4000 CHAR);
        v_ITEM_CLASS VARCHAR2(30 CHAR);
        v_PACK_CNT INTEGER := 0;
        v_MODULE_CNT INTEGER := 0;
        v_CELL_CNT INTEGER := 0;
        v_0month_tuesday VARCHAR2(08 CHAR);
        v_delimiter VARCHAR2(1 CHAR);
        v_max_loop_cnt INTEGER := 0;
        v_mst_loop_cnt INTEGER := 0;
        v_CNT INTEGER := 0;
        v_CNT_PRE INTEGER := 0;
        -- $$PLSQL_UNIT 제거: $$PLSQL_UNIT 사용 (사내 표준 §11)
        v_log_type VARCHAR2(30 CHAR);
        n_log_count INTEGER := 0;
        v_log_message VARCHAR2(1000 CHAR);
        v_description VARCHAR2(500 CHAR);
        d_event_date DATE;
        v_i INTEGER := 1;
        V_ITEM_CNT INTEGER := 0;
        V_ITEM_ID VARCHAR2(50 CHAR);
    BEGIN
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    	DECLARE v_CELL_PER_PACK NUMERIC(30, 10)
    	DECLARE v_CELL_PER_MODULE NUMERIC(30, 10)
    	DECLARE v_CELL_PER_CELL NUMERIC(30, 10)
    	DECLARE v_TRANSLATOR NUMERIC(30, 10) --환산자
    	DECLARE v_REP_ITEM_ID VARCHAR2(30 CHAR) --대표환산자 ITEM_ID
    	DECLARE v_REP_TRANSLATOR VARCHAR2(30 CHAR) --대표환산자
    	DECLARE v_CUST_FCST_M_CELL NUMERIC(30, 10)
    	DECLARE v_P_VALUE_CELL NUMERIC(30, 10)
    	DECLARE v_S_VALUE_CELL NUMERIC(30, 10)
    	DECLARE v_I_VALUE_CELL NUMERIC(30, 10)
    	DECLARE v_V_VALUE_CELL NUMERIC(30, 10)
    	DECLARE v_M_VALUE_CELL NUMERIC(30, 10)
    	DECLARE v_CP_VALUE_CELL NUMERIC(30, 10)
    	DECLARE v_MKT_FCST_M_CELL NUMERIC(30, 10)
    
    	------------------------------------------------------------------------------------------------------환산자 추가
    	v_DIVISION_ID := NULL;
    	v_END_CUSTOMER := NULL;
    	v_PROJECT_CODE := NULL;
    	v_YYYYMM := NULL;
    	v_CUST_FCST_M := NULL;
    	v_CUST_FCST_M_PRE := NULL;
    	v_MEASURE := NULL;
    	v_QTYCD1 := NULL;
    	v_QTYCD2 := NULL;
    	v_QTYCD3 := NULL;
    	v_SEQ := NULL;
    	v_QTY := NULL;
    	v_MKT_FCST_M := NULL;
    	v_DESC := NULL;
    	v_INPUT_LIMIT := NULL;
    	v_CREATED_BY := NULL;
    	v_CREATION_DATE := NULL;
    	v_LAST_UPDATED_BY := NULL;
    	v_LAST_UPDATE_DATE := NULL;
    	v_ITEM_CLASS := NULL;
    	v_PACK_CNT := NULL;
    	v_MODULE_CNT := NULL;
    	v_CELL_CNT := NULL;
    	v_CELL_PER_PACK := NULL;
    	v_CELL_PER_MODULE := NULL;
    	v_CELL_PER_CELL := NULL;
    	v_TRANSLATOR := NULL;
    	v_CUST_FCST_M_CELL := NULL;
    	v_P_VALUE_CELL := NULL;
    	v_S_VALUE_CELL := NULL;
    	v_I_VALUE_CELL := NULL;
    	v_V_VALUE_CELL := NULL;
    	v_M_VALUE_CELL := NULL;
    	v_CP_VALUE_CELL := NULL;
    	v_MKT_FCST_M_CELL := NULL;
    
    
    
    	v_delimiter := '^';
    
    
    
    
    
    
    
    
    
    
    
    	v_log_type := 'START';
    	v_log_message := '########## Start of procedure ##########';
    	v_description := NULL;
    	d_event_date := SYSTIMESTAMP;
    
    	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT);
    		,v_log_type
    		,n_log_count
    		,v_log_message
    		,v_description
    		,d_event_date;
    
    	-- 테이블중복제거
    	-- 임시확인용테이블 중복제거
    	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DM_ANL_MKT_PSI';
    
    	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_PROJECT_DEPT';
    
    	-- 시작 LOG  (END)
    	v_log_message := NULL /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
    
    
    	BEGIN TRY
    		IF p_division_id IS NULL
    			OR p_division_id IS NULL;
    		BEGIN
    			v_log_type := 'INVALID';
    
    			SELECT 'DIVISION_ID 입력값을 확인하세요.'
    
    			v_description := '필수 입력값을 확인하세요.';
    
    			GOTO err_rtn
    		END
    
    		IF p_end_customer IS NULL
    			OR p_end_customer IS NULL;
    		BEGIN
    			v_log_type := 'INVALID';
    
    			SELECT 'END_CUSTOMER 입력값을 확인하세요.'
    
    			v_description := 'End_Customer 입력값을 확인하세요.';
    
    			GOTO err_rtn
    		END
    
    		IF p_project_code IS NULL
    			OR p_project_code IS NULL;
    		BEGIN
    			v_log_type := 'INVALID';
    
    			SELECT 'PROJECT_CODE 입력값을 확인하세요.'
    
    			v_description := 'Project 입력값을 확인하세요.';
    
    			GOTO err_rtn
    		END
    
    		IF p_yyyymm IS NULL
    			OR p_yyyymm IS NULL;
    		BEGIN
    			v_log_type := 'INVALID';
    
    			SELECT 'YYYYMM 입력값을 확인하세요.'
    
    			v_description := 'YYYYMM 입력값을 확인하세요.';
    
    			GOTO err_rtn
    		END
    
    		IF p_measure IS NULL
    			OR p_measure IS NULL;
    		BEGIN
    			v_log_type := 'INVALID';
    
    			SELECT 'MEASURE 입력값을 확인하세요.'
    
    			v_description := 'MEASURE 입력값을 확인하세요.';
    
    			GOTO err_rtn
    		END
    
    
    		IF p_qtycd3 IS NULL
    			OR p_qtycd3 IS NULL
    			OR LENGTH(p_qtycd3) = 0;
    		BEGIN
    			v_log_type := 'INVALID';
    
    			SELECT '입력값을 확인하세요.'
    
    			v_description := '입력값을 확인하세요.';
    
    			GOTO err_rtn
    		END
    
    
    		BEGIN
    			DELETE
    			FROM DM_ANL_MKT_PSI_DETAIL
    			WHERE 1 = 1
    				AND DIVISION_ID = p_division_id
    				AND END_CUSTOMER = p_end_customer
    				AND PROJECT_CODE = p_project_code
    				AND YYYYMM = p_yyyymm
    				AND MEASURE = p_measure;
    		END
    
    		--BEGIN
    		--	-- 테이블중복제거
    		--	--	-- 임시확인용테이블 중복제거
    		--	--	SELECT * INTO GT_DMF0_PROJECT_CODE
    		--	FROM (SELECT PROJECT_CODE FROM SCM_MST_PROJECT WHERE DIVISION_ID = p_division_id AND PROJECT_NAME = V_project_name) A
    		--END
    		-- 프로시저 LOOP 길이를 판단
    		v_max_loop_cnt := SCM_ARR_SPL_CNT(p_qtycd3, v_delimiter);
    
    		DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_max_loop_cnt)  ||  ' '  ||  '----------------------------------------------------------------------------------------------------------------------------------------------');
    
    		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------START
    		BEGIN
    			/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
    			INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
    			SELECT *
    			FROM DM_MST_ITEM_SINGLE_V
    			WHERE DIVISION_ID = p_division_id
    				AND ITEM_ID IN (
    					SELECT ITEM_ID
    					FROM SCM_MST_PROJECT_ITEM
    					WHERE PROJECT_CODE = p_project_code
    						AND VALID_YN = 'Y'
    					)
    				AND ITEM_TYPE = 'P';
    		END
    
    		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')------------------------------END
    
    		-- 환산자 추출 로직 ======================================================================START
    		-- 테이블중복제거
    		-- 임시확인용테이블 중복제거
    		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
    		DBMS_OUTPUT.PUT_LINE('환산자 추출 START--------------------------------------------------------------------------------------------------------------------------------------');
    
    		-- 신규 로직으로 변경
    		--BEGIN
    		--	-- 1.프로젝트에 있는 ITEM을 CLASS별로 추출하여 임시테이블(GT_DMF0_ITEM_CLASS_IN_PROJECT)에 저장한다.
    		--	SELECT ITEM_ID
    		--		,CASE
    		--			WHEN INSTR(ITEM_CLASS_NAME, 'Pack') > 0
    		--				THEN 'PACK'
    		--			WHEN INSTR(ITEM_CLASS_NAME, 'Module') > 0
    		--				THEN 'MODULE'
    		--			WHEN INSTR(ITEM_CLASS_NAME, 'Cell') > 0
    		--				THEN 'CELL'
    		--			ELSE ''
    		--			END ITEM_CLASS
    		--	INTO GT_DMF0_ITEM_CLASS_IN_PROJECT
    		--	FROM DM_MST_ITEM_SINGLE_V
    		--	WHERE DIVISION_ID = '81'
    		--		AND ITEM_ID IN (
    		--			SELECT ITEM_ID
    		--			FROM SCM_MST_PROJECT_ITEM
    		--			WHERE PROJECT_CODE = p_PROJECT_CODE
    		--				AND VALID_YN = 'Y'
    		--			)
    		--		AND ITEM_TYPE = 'P'
    		--		AND ACTIVE_FLAG = 'Y'
    
    		--	--SELECT * FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
    		--	-- 2. 임시테이블(GT_DMF0_ITEM_CLASS_IN_PROJECT)에서 PACK, MODULE, CELL 별로 수량을 파악한다.
    		--	SELECT v_PACK_CNT = COUNT(1)
    		--	FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
    		--	WHERE ITEM_CLASS = 'PACK'
    		--	GROUP BY ITEM_CLASS
    
    		--	SELECT v_MODULE_CNT = COUNT(1)
    		--	FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
    		--	WHERE ITEM_CLASS = 'MODULE'
    		--	GROUP BY ITEM_CLASS
    
    		--	SELECT v_CELL_CNT = COUNT(1)
    		--	FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
    		--	WHERE ITEM_CLASS = 'CELL'
    		--	GROUP BY ITEM_CLASS
    
    		--	PRINT TO_CHAR(v_PACK_CNT) + ' PACK'
    		--	PRINT TO_CHAR(v_MODULE_CNT) + ' MODULE'
    		--	PRINT TO_CHAR(v_CELL_CNT) + ' CELL'
    
    		--	-- 3. 해당 프로젝트에서(GT_DMF0_ITEM_CLASS_IN_PROJECT)
    		--	IF v_PACK_CNT > 0 -- PACK에 수량이 있으면 PACK 기준을 사용
    		--	BEGIN
    		--		PRINT 'CELL_PER_PACK'
    
    		--		SELECT v_CELL_PER_PACK = CELL_PER_CAR
    		--		FROM SCM_MST_SITE_ITEM
    		--		WHERE PROJECT_CODE = p_PROJECT_CODE
    		--			AND ITEM_ID IN (
    		--				SELECT ITEM_ID
    		--				FROM DM_MST_ITEM_SINGLE_V
    		--				WHERE DIVISION_ID = '81'
    		--					AND ITEM_ID IN (
    		--						SELECT ITEM_ID
    		--						FROM SCM_MST_PROJECT_ITEM
    		--						WHERE PROJECT_CODE = p_PROJECT_CODE
    		--							AND VALID_YN = 'Y'
    		--						)
    		--					AND ITEM_TYPE = 'P'
    		--					AND ACTIVE_FLAG = 'Y'
    		--				)
    		--			AND VALID_YN = 'Y'
    		--			AND CELL_PER_CAR IS NOT NULL
    		--		GROUP BY CELL_PER_CAR
    
    		--		v_TRANSLATOR := v_CELL_PER_PACK;
    		--		v_REP_TRANSLATOR := 'PACK'
    		--	END
    		--	ELSE IF v_PACK_CNT = 0
    		--		AND v_MODULE_CNT > 0 -- PACK에 수량이 없고 MODULE에 수량이 있으면 MODULE 기준을 사용
    		--	BEGIN
    		--		PRINT 'CELL_PER_MODULE'
    
    		--		SELECT v_CELL_PER_MODULE = CELL_PER_MODULE
    		--		FROM SCM_MST_SITE_ITEM
    		--		WHERE PROJECT_CODE = p_PROJECT_CODE
    		--			AND ITEM_ID IN (
    		--				SELECT ITEM_ID
    		--				FROM DM_MST_ITEM_SINGLE_V
    		--				WHERE DIVISION_ID = '81'
    		--					AND ITEM_ID IN (
    		--						SELECT ITEM_ID
    		--						FROM SCM_MST_PROJECT_ITEM
    		--						WHERE PROJECT_CODE = p_PROJECT_CODE
    		--							AND VALID_YN = 'Y'
    		--						)
    		--					AND ITEM_TYPE = 'P'
    		--					AND ACTIVE_FLAG = 'Y'
    		--				)
    		--			AND VALID_YN = 'Y'
    		--			AND CELL_PER_CAR IS NOT NULL
    		--		GROUP BY CELL_PER_MODULE
    
    		--		v_TRANSLATOR := v_CELL_PER_MODULE;
    		--		v_REP_TRANSLATOR := 'MODULE'
    		--	END
    		--	ELSE IF v_PACK_CNT = 0
    		--		AND v_MODULE_CNT = 0
    		--		AND v_CELL_CNT > 0 -- PACK, MODULE에 수량이 없고 CELL에 수량이 있으면 CELL 기준을 사용
    		--	BEGIN
    		--		PRINT 'CELL_PER_CELL'
    
    		--		SELECT v_CELL_PER_CELL = 1
    
    		--		v_TRANSLATOR := v_CELL_PER_CELL;
    		--		v_REP_TRANSLATOR := 'CELL'
    		--	END
    		--END
    		-- 신규 로직으로 변경
    
    		v_DIVISION_ID := p_division_id;
    		v_PROJECT_CODE := p_project_code;
    
    		DBMS_OUTPUT.PUT_LINE(v_DIVISION_ID);
    		DBMS_OUTPUT.PUT_LINE(v_PROJECT_CODE);
    
    		BEGIN
    
    			--SELECT AAAA.PROJECT_CODE, AAAA.ITEM_ID, AAAA.BIZ_TYPE FROM(
    			SELECT AAAA.ITEM_ID,
        AAAA.BIZ_TYPE
      INTO v_REP_ITEM_ID, v_REP_TRANSLATOR
    			FROM(
    			SELECT AAA.PROJECT_CODE, AAA.ITEM_ID
    			, CASE WHEN SUBSTR(AAA.ITEM_ID, 1,2) = 'AP' THEN 'PACK' WHEN SUBSTR(AAA.ITEM_ID, 1,2) = 'AM' THEN 'MODULE' WHEN SUBSTR(AAA.ITEM_ID, 1,2) = 'AC' THEN 'CELL' END BIZ_TYPE
    			,  ROW_NUMBER() OVER (PARTITION BY AAA.PROJECT_CODE ORDER BY AAA.PROJECT_CODE, SUBSTR(AAA.ITEM_ID, 2,1) DESC) AS RNK FROM(
    			SELECT AA.PROJECT_CODE, BB.ITEM_ID
    			, CASE WHEN SUBSTR(BB.ITEM_ID, 1,2) = 'AP' THEN 3 WHEN SUBSTR(BB.ITEM_ID, 1,2) = 'AM' THEN 2 WHEN SUBSTR(BB.ITEM_ID, 1,2) = 'AC' THEN 1 END RNK FROM
    			(SELECT DISTINCT PROJECT_CODE FROM DM_ANL_MKT_PSI_DETAIL WHERE DIVISION_ID = v_DIVISION_ID AND PROJECT_CODE = v_PROJECT_CODE) AA INNER JOIN
    			(SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID
    			FROM SCM_MST_SITE_ITEM A INNER JOIN DM_MST_ITEM_SINGLE_V B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
    			WHERE A.DIVISION_ID = v_DIVISION_ID AND A.VALID_YN = 'Y' AND B.ITEM_TYPE = 'P') BB
    			ON AA.PROJECT_CODE = BB.PROJECT_CODE
    			GROUP BY AA.PROJECT_CODE, BB.ITEM_ID
    			) AAA;
    			) AAAA WHERE AAAA.RNK = 1
    			ORDER BY AAAA.PROJECT_CODE, AAAA.ITEM_ID;
    
    		END
    
    		SELECT v_TRANSLATOR = CELL_CF FROM SCP_MST_FINAL_ITEM WHERE ITEM_ID = v_REP_ITEM_ID
    
    		DBMS_OUTPUT.PUT_LINE(v_TRANSLATOR);
    
    		DBMS_OUTPUT.PUT_LINE('환산자 추출 END--------------------------------------------------------------------------------------------------------------------------------------');
    
    		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
    
    		-- 환산자 추출 로직 ========================================================================END
    
    
    		DBMS_OUTPUT.PUT_LINE('환산자');
    		DBMS_OUTPUT.PUT_LINE('환산자 '  ||  v_REP_TRANSLATOR  ||  ' '  ||  TO_CHAR(v_TRANSLATOR));
    
    
    		WHILE LENGTH(p_qtycd3) > 0
    			AND v_mst_loop_cnt < v_max_loop_cnt;
    		BEGIN
    			-- v_mst_loop_cnt 1증가
    			v_mst_loop_cnt := v_mst_loop_cnt || 1;
    
    			-- 각 컬럼들에 대한 스플릿처리로직 스타트
    			BEGIN
    				v_DIVISION_ID := p_division_id;
    				--SELECT v_DIVISION_ID
    				v_END_CUSTOMER := p_end_customer;
    				--SELECT v_END_CUSTOMER
    				v_PROJECT_CODE := p_project_code;
    				--SELECT v_PROJECT_CODE
    				v_YYYYMM := p_yyyymm;
    				--SELECT v_YYYYMM
    				--v_CUST_FCST_M := SCM_ARR_SPL_VAL(p_qtycd1, v_delimiter , 1);
    				--v_CUST_FCST_M_PRE := SCM_ARR_SPL_VAL(p_qtycd1, v_delimiter , 2);
    				v_CUST_FCST_M := p_cust_fcst_m;
    				--SELECT v_CUST_FCST_M
    				v_MEASURE := p_measure;
    				--SELECT v_MEASURE
    				v_QTYCD1 := SCM_ARR_SPL_VAL(p_qtycd1, v_delimiter, v_mst_loop_cnt);
    				--SELECT v_QTYCD1
    				v_QTYCD2 := SCM_ARR_SPL_VAL(p_qtycd2, v_delimiter, v_mst_loop_cnt);
    				--SELECT v_QTYCD2
    				v_QTYCD3 := SCM_ARR_SPL_VAL(p_qtycd3, v_delimiter, v_mst_loop_cnt);
    				--SELECT v_QTYCD3
    				v_SEQ := SCM_ARR_SPL_VAL(p_seq, v_delimiter, v_mst_loop_cnt);
    				--SELECT v_SEQ
    				v_QTY := SCM_ARR_SPL_VAL(p_qty, v_delimiter, v_mst_loop_cnt);
    				--SELECT v_QTY
    				v_MKT_FCST_M := p_mkt_fcst_m;
    				--SELECT v_MKT_FCST_M
    				v_DESC := SCM_ARR_SPL_VAL(p_desc, v_delimiter, v_mst_loop_cnt);
    				--SELECT v_DESC
    				v_INPUT_LIMIT := p_input_limit;
    				--SELECT v_INPUT_LIMIT
    				v_CREATED_BY := p_created_by;
    				--SELECT v_CREATED_BY
    				v_CREATION_DATE := SYSTIMESTAMP;
    				--SELECT v_CREATION_DATE
    				v_LAST_UPDATED_BY := p_created_by;
    				--SELECT v_LAST_UPDATED_BY
    				v_LAST_UPDATE_DATE := SYSTIMESTAMP;
    					--SELECT v_LAST_UPDATE_DATE
    			END
    
    			-- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 start -----------------------------------------------
    			IF v_DIVISION_ID = ''
    				OR v_DIVISION_ID IS NULL;
    			BEGIN
    				v_log_type := 'INVALID';
    
    				SELECT 'DIVISION_ID 입력값을 확인하세요.'
    
    				v_description := '필수 입력값을 확인하세요.';
    
    				GOTO err_rtn
    			END
    
    		IF v_END_CUSTOMER = ''
    			OR v_END_CUSTOMER IS NULL;
    		BEGIN
    			v_log_type := 'INVALID';
    
    			SELECT 'END_CUSTOMER 입력값을 확인하세요.'
    
    			v_description := 'End_Customer 입력값을 확인하세요.';
    
    			GOTO err_rtn
    		END
    
    			IF v_PROJECT_CODE = ''
    				OR v_PROJECT_CODE IS NULL;
    			BEGIN
    				v_log_type := 'INVALID';
    
    				SELECT 'PROJECT_CODE 입력값을 확인하세요.'
    
    				v_description := 'Div 입력값을 확인하세요.';
    
    				GOTO err_rtn
    			END
    
    			IF v_YYYYMM = ''
    				OR v_YYYYMM IS NULL;
    			BEGIN
    				v_log_type := 'INVALID';
    
    				SELECT 'YYYYMM 입력값을 확인하세요.'
    
    				v_description := 'YYYYMM 입력값을 확인하세요.';
    
    				GOTO err_rtn
    			END
    
    
    
    			/* =================================================
    		   주석유지
    		    =================================================*/
    			/*
    			IF v_CUST_FCST_M = '' OR v_CUST_FCST_M IS NULL
    				BEGIN
    					v_log_type := 'INVALID';
    					SELECT 'Sold-To 입력값을 확인하세요.'
    					v_description := 'Sold-To 입력값을 확인하세요.';
    					goto err_rtn
    				*/
    			/* =================================================*/
    			--IF SCM_ARR_SPL_CNT(p_cust_fcst_m, v_delimiter) = 2
    			--	BEGIN
    			--		v_CUST_FCST_M_PRE := SCM_ARR_SPL_VAL(p_cust_fcst_m, v_delimiter , 1);
    			--		v_CUST_FCST_M := SCM_ARR_SPL_VAL(p_cust_fcst_m, v_delimiter , 2);
    			--	END
    			-- 테이블중복제거
    			-- 임시확인용테이블 중복제거
    			EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DM_MST_VERSION'
    					FROM DUAL;
    
    			--월의 첫날이 수요일인 경우 전달의 마지막 MKT_FCST Cutoff 일자를 사용한다.
    			IF v_MEASURE = 'DP_INIT' THEN
    				IF DATEPART(WEEKDAY, SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6)  ||  '01') = '4' THEN
    					v_0month_tuesday := TO_CHAR(/* TODO:(FN_NEXT_DAY(TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6) + (- 1) * 7 + '01', 'YYYYMMDD'), 'TUE')) */, 'YYYYMMDD');
    				ELSE
    					v_0month_tuesday := TO_CHAR(1 || (/* TODO:DATEDIFF(WK,0,(v_yyyymm  ||  '01') + (5 - DATEPART(DAY, v_yyyymm + '01') */)))*7v_yyyymm  ||  '01' + (5 - DATEPART(DAY, v_yyyymm  ||  '01'))), 1), 'YYYYMMDD'); --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
    			ELSIF DATEPART(WEEKDAY, SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6)  ||  '01') = '4' THEN
    				v_0month_tuesday := TO_CHAR(/* TODO:(FN_NEXT_DAY(DATEADD(MM, 1, TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6) + (- 1) * 7 + '01', 'YYYYMMDD')), 'TUE')) */ADD_MONTHS(TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6)  ||  '01', 'YYYYMMDD'), 1), 'TUE')), 'YYYYMMDD');
    			ELSE
    				v_0month_tuesday := TO_CHAR(1 || (/* TODO:DATEDIFF(WK,0,DATEADD(DD, 5 - DATEPART(DAY, ADD_MONTHS(v_yyyymm + '01', 1) */), ADD_MONTHS(v_yyyymm  ||  '01', 1))))*7DATEADD(MM, 1, v_yyyymm  ||  '01') || (5 - DATEPART(DAY, ADD_MONTHS(v_yyyymm  ||  '01', 1)))ADD_MONTHS(v_yyyymm  ||  '01', 1)), ADD_MONTHS(v_yyyymm  ||  '01', 1))), 1), 'YYYYMMDD'); --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
    			END IF;
    
    			BEGIN
    				INSERT INTO GT_DMF0_DM_MST_VERSION (;
    					NUM
    					,VERSION_NO
    					,VERSION_TYPE
    					)
    				SELECT ROW_NUMBER() OVER (
    						ORDER BY X.VERSION_NO
    						) AS NUM
    					,X.VERSION_NO
    					,X.VERSION_TYPE
    				FROM (
    					SELECT ROW_NUMBER() OVER (
    							PARTITION BY A.VERSION_TYPE ORDER BY A.VERSION_NO DESC
    							) AS RNK
    						,A.VERSION_NO
    						,A.VERSION_TYPE
    					FROM DM_MST_VERSION A
    					JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD
    					WHERE 1 = 1
    						AND A.DIVISION_ID = p_division_id
    						AND A.VERSION_TYPE = 'MF_W' --MKT_FCST Weekly Cutoff
    						AND A.YYYYMMDD = v_0month_tuesday
    					) X;
    				WHERE RNK = 1;
    			END;
    
    			--SCM_MST_SITE 대상건만 추출(end_customer)
    		    BEGIN
    			    /* TODO:GTT:GT_DMF0_SCM_MST_SITE-->GT_DMF0_SCM_MST_SITE */
    			    INSERT INTO GT_DMF0_SCM_MST_SITE
    			    SELECT DIVISION_ID
    			         , SCM_SITE_ID
    			    	 , END_CUSTOMER
    		    	FROM SCM_MST_SITE
    		    	WHERE DIVISION_ID  = p_division_id
    	              AND END_CUSTOMER = p_end_customer;
    	    	END;
    
    
    			--IF v_CUST_FCST_M_PRE = '' OR v_CUST_FCST_M_PRE IS NULL OR v_CUST_FCST_M_PRE = '0'
    			--	BEGIN
    			--		SELECT v_CUST_FCST_M_PRE = (A_QTY + B_QTY)
    			--		FROM (
    			--					SELECT NVL(CEILING(SUM(QTY)), 0) AS A_QTY
    			--					FROM DM_PLN_MKT_FCST_C X
    			--					JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    			--					WHERE 1=1
    			--					AND X.DIVISION_ID = p_division_id
    			--					AND MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
    			--					--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    			--					AND PROJECT_CODE = p_project_code
    			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    			--					AND ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
    			--					AND X.FCST_TYPE = 'MPS'
    			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    			--					AND SUBSTR(YYYYMMDD, 1, 6) = v_yyyymm
    			--					AND QTY <> 0
    			--					) A,
    			--					(
    			--					SELECT NVL(CEILING(SUM(QTY)), 0) AS B_QTY
    			--					FROM DM_PLN_MKT_FCST_RESULT_C X
    			--					JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    			--					WHERE 1=1
    			--					AND X.DIVISION_ID = p_division_id
    			--					AND MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
    			--					--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    			--					AND PROJECT_CODE = p_project_code
    			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    			--					AND ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
    			--					AND X.FCST_TYPE = 'MPS'
    			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    			--					AND SUBSTR(YYYYMMDD, 1, 6) = v_yyyymm
    			--					) B
    			--	END
    			IF v_CUST_FCST_M = ''
    				OR v_CUST_FCST_M IS NULL
    				OR v_CUST_FCST_M = '0' THEN
    				IF v_MEASURE = 'DP_INIT' THEN
    					SELECT (A_QTY  ||  B_QTY)
      INTO v_CUST_FCST_M
    					FROM (
    						SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
    						FROM DM_PLN_MKT_FCST_C X
    						JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    						JOIN GT_DMF0_SCM_MST_SITE Z
    						  	ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    						WHERE 1 = 1
    							AND X.DIVISION_ID = p_division_id
    							AND X.MEASURE IN (;
    								'CUST_FCST_EDI'
    								,'CUST_FCST'
    								)
    							--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    							AND X.PROJECT_CODE = p_project_code
    							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    							AND X.ITEM_ID IN (
    								SELECT ITEM_ID
    								FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    								)
    							AND X.FCST_TYPE = 'MPS'
    							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    							AND SUBSTR(X.YYYYMMDD, 1, 6) = v_yyyymm
    							AND X.QTY <> 0
    						) A;
    						,(
    							SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
    							FROM DM_PLN_MKT_FCST_RESULT_C X
    							JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    						    JOIN GT_DMF0_SCM_MST_SITE Z
    							     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    							WHERE 1 = 1
    								AND X.DIVISION_ID = p_division_id
    								AND X.MEASURE IN (;
    									'CUST_FCST_EDI'
    									,'CUST_FCST'
    									)
    								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    								AND X.PROJECT_CODE = p_project_code
    								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    								AND X.ITEM_ID IN (
    									SELECT ITEM_ID
    									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    									)
    								AND X.FCST_TYPE = 'MPS'
    								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    								AND SUBSTR(X.YYYYMMDD, 1, 6) = v_yyyymm
    							) B;
    				ELSE
    					SELECT v_CUST_FCST_M = (A_QTY  ||  B_QTY)
    					FROM (
    						SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
    						FROM DM_PLN_MKT_FCST_C X
    						JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    					    JOIN GT_DMF0_SCM_MST_SITE Z
    						     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    						WHERE 1 = 1
    							AND X.DIVISION_ID = p_division_id
    							AND X.MEASURE IN (;
    								'CUST_FCST_EDI'
    								,'CUST_FCST'
    								)
    							--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    							AND X.PROJECT_CODE = p_project_code
    							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    							AND X.ITEM_ID IN (
    								SELECT ITEM_ID
    								FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    								)
    							AND X.FCST_TYPE = 'MPS'
    							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    							AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
    							AND X.QTY <> 0
    						) A;
    						,(
    							SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
    							FROM DM_PLN_MKT_FCST_RESULT_C X
    							JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    						    JOIN GT_DMF0_SCM_MST_SITE Z
    							     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    							WHERE 1 = 1
    								AND X.DIVISION_ID = p_division_id
    								AND X.MEASURE IN (;
    									'CUST_FCST_EDI'
    									,'CUST_FCST'
    									)
    								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    								AND X.PROJECT_CODE = p_project_code
    								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    								AND X.ITEM_ID IN (
    									SELECT ITEM_ID
    									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    									)
    								AND X.FCST_TYPE = 'MPS'
    								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    								AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
    							) B;
    				END IF;
    
    			IF v_MEASURE = ''
    				OR v_MEASURE IS NULL THEN
    				v_log_type := 'INVALID';
    
    				SELECT 'MEASURE 입력값을 확인하세요.'
    
    				v_description := 'MEASURE 입력값을 확인하세요.';
    
    				GOTO err_rtn
    			END IF;
    
    			IF v_QTYCD1 = ''
    				OR v_QTYCD1 IS NULL THEN
    				v_log_type := 'INVALID';
    
    				SELECT 'QTYCD1 입력값을 확인하세요.'
    
    				v_description := 'QTYCD1 입력값을 확인하세요.';
    
    				GOTO err_rtn
    			END IF;
    
    			IF v_QTYCD2 = ''
    				OR v_QTYCD2 IS NULL THEN
    				v_log_type := 'INVALID';
    
    				SELECT 'QTYCD2 입력값을 확인하세요.'
    
    				v_description := 'QTYCD2 입력값을 확인하세요.';
    
    				GOTO err_rtn
    			END IF;
    
    			IF v_QTYCD3 = ''
    				OR v_QTYCD3 IS NULL THEN
    				v_log_type := 'INVALID';
    
    				SELECT 'QTYCD3 입력값을 확인하세요.'
    
    				v_description := 'QTYCD3 입력값을 확인하세요.';
    
    				GOTO err_rtn
    			END IF;
    
    			IF v_SEQ = ''
    				OR v_SEQ IS NULL THEN
    				SELECT MAX(SEQ) || 1
      INTO v_SEQ
    				FROM DM_ANL_MKT_PSI_DETAIL
    				WHERE DIVISION_ID = v_DIVISION_ID
    					AND END_CUSTOMER = p_end_customer
    					AND PROJECT_CODE = v_PROJECT_CODE
    					AND YYYYMM = v_YYYYMM
    					--AND CUST_FCST_M = v_CUST_FCST_M
    					AND MEASURE = v_MEASURE
    					AND QTYCD1 = v_QTYCD1
    					AND QTYCD2 = v_QTYCD2
    					AND QTYCD3 = v_QTYCD3;
    			END IF;
    
    			DBMS_OUTPUT.PUT_LINE('INSERT INTO 1------------------------------------------------------------------------------------------------------------------------------------------------------------');
    
    			IF v_mst_loop_cnt > 0 THEN
    				INSERT INTO DM_ANL_MKT_PSI_DETAIL (;
    					DIVISION_ID
    					,END_CUSTOMER
    					,PROJECT_CODE
    					,YYYYMM
    					,CUST_FCST_M
    					,MEASURE
    					,QTYCD1
    					,QTYCD2
    					,QTYCD3
    					,SEQ
    					,QTY
    					,MKT_FCST_M
    					,DESC
    					,INPUT_LIMIT
    					,CUST_FCST_M_CELL
    					,QTY_CELL
    					,MKT_FCST_M_CELL
    					,CREATED_BY
    					,CREATION_DATE
    					,LAST_UPDATED_BY
    					,LAST_UPDATE_DATE
    					)
    				SELECT v_DIVISION_ID
    					,v_END_CUSTOMER
    					,v_PROJECT_CODE
    					,v_YYYYMM
    					,v_CUST_FCST_M AS CUST_FCST_M
    					--, CASE WHEN v_MEASURE = 'DP_INIT' THEN v_CUST_FCST_M
    					--       WHEN v_MEASURE = 'DP_RESULT' THEN v_CUST_FCST_M_PRE END AS CUST_FCST_M
    					,v_MEASURE
    					,v_QTYCD1
    					,v_QTYCD2
    					,v_QTYCD3
    					,v_SEQ
    					,NVL(v_QTY, 0)
    					,NVL(v_MKT_FCST_M, 0)
    					,v_DESC
    					,v_INPUT_LIMIT
    					,TO_NUMBER(NVL(v_CUST_FCST_M, 0)) * v_TRANSLATOR AS CUST_FCST_M_CELL
    					--, CASE WHEN v_MEASURE = 'DP_INIT' THEN TO_NUMBER(NVL(v_CUST_FCST_M, 0)) * v_TRANSLATOR
    					--       WHEN v_MEASURE = 'DP_RESULT' THEN TO_NUMBER(NVL(v_CUST_FCST_M_PRE, 0)) * v_TRANSLATOR END AS CUST_FCST_M_CELL
    					,TO_NUMBER(NVL(v_QTY, 0)) * v_TRANSLATOR AS QTY_CELL
    					,NVL(v_MKT_FCST_M, 0) * v_TRANSLATOR AS MKT_FCST_M_CELL
    					,v_CREATED_BY
    					,SYSTIMESTAMP
    					,v_LAST_UPDATED_BY
    					,SYSTIMESTAMP
    			END IF;
    		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
    
    		--RESULT등록시 신규월 EDI 수량
    		BEGIN
    			SELECT (A_QTY  ||  B_QTY)
      INTO v_CUST_FCST_M_PRE
    			FROM (
    				SELECT NVL(CEILING(SUM(X.QTY)), 0) AS A_QTY
    				FROM DM_PLN_MKT_FCST_C X
    				JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    			    JOIN GT_DMF0_SCM_MST_SITE Z
    				     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    				WHERE 1 = 1
    					AND X.DIVISION_ID = p_division_id
    					AND X.MEASURE IN (;
    						'CUST_FCST_EDI'
    						,'CUST_FCST'
    						)
    					--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    					AND X.PROJECT_CODE = p_project_code
    					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    					AND X.ITEM_ID IN (
    						SELECT ITEM_ID
    						FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    						)
    					AND X.FCST_TYPE = 'MPS'
    					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    					AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
    					AND QTY <> 0
    				) A;
    				,(
    					SELECT NVL(CEILING(SUM(X.QTY)), 0) AS B_QTY
    					FROM DM_PLN_MKT_FCST_RESULT_C X
    					JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
    				    JOIN GT_DMF0_SCM_MST_SITE Z
    					     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
    					WHERE 1 = 1
    						AND X.DIVISION_ID = p_division_id
    						AND X.MEASURE IN (;
    							'CUST_FCST_EDI'
    							,'CUST_FCST'
    							)
    						--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
    						AND X.PROJECT_CODE = p_project_code
    						--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    						AND X.ITEM_ID IN (
    							SELECT ITEM_ID
    							FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
    							)
    						AND X.FCST_TYPE = 'MPS'
    						--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
    						AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
    					) B;
    		END;
    		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
    
    		-- MASTER 테이블(DM_ANL_MKT_PSI) 데이터 입력
    		BEGIN
    			IF v_MEASURE = 'DP_INIT' THEN
    				DBMS_OUTPUT.PUT_LINE('INSERT INTO 2-0------------------------------------------------------------------------------------------------------------------------------------------------------------');
    				DBMS_OUTPUT.PUT_LINE(v_DIVISION_ID  ||  ' /// '  ||  v_PROJECT_CODE  ||  ' /// '  ||  v_YYYYMM  ||  ' /// '  ||  v_MEASURE);
    
    				SELECT COUNT(*)
      INTO v_CNT
    				FROM DM_ANL_MKT_PSI
    				WHERE 1 = 1
    					AND DIVISION_ID = v_DIVISION_ID
    					AND END_CUSTOMER = v_END_CUSTOMER
    					AND PROJECT_CODE = v_PROJECT_CODE
    					AND YYYYMM = v_YYYYMM
    					AND MEASURE = v_MEASURE;
    
    				DBMS_OUTPUT.PUT_LINE(v_CNT);
    
    				IF v_CNT > 0 THEN
    					DBMS_OUTPUT.PUT_LINE('INSERT INTO 2-1[수요계획(1ST) 존재]------------------------------------------------------------------------------------------------------------------------------------------');
    
    					BEGIN
    						DELETE
    						FROM DM_ANL_MKT_PSI
    						WHERE 1 = 1
    							AND DIVISION_ID = v_DIVISION_ID
    							AND END_CUSTOMER = v_END_CUSTOMER
    							AND PROJECT_CODE = v_PROJECT_CODE
    							AND YYYYMM = v_YYYYMM
    							AND MEASURE IN (v_MEASURE);
    					END;
    
    					BEGIN
    						INSERT INTO GT_DMF0_DM_ANL_MKT_PSI (;
    							DIVISION_ID
    							,END_CUSTOMER
    							,PROJECT_CODE
    							,YYYYMM
    							,CUST_FCST_M
    							,MEASURE
    							,P_VALUE
    							,S_VALUE
    							,I_VALUE
    							,V_VALUE
    							,M_VALUE
    							,MKT_FCST_M
    							,CUST_FCST_M_CELL
    							,P_VALUE_CELL
    							,S_VALUE_CELL
    							,I_VALUE_CELL
    							,V_VALUE_CELL
    							,M_VALUE_CELL
    							,MKT_FCST_M_CELL
    							,CREATED_BY
    							,CREATION_DATE
    							,LAST_UPDATED_BY
    							,LAST_UPDATE_DATE
    							,CP_VALUE
    							,CP_VALUE_CELL
    							)
    						SELECT T1.DIVISION_ID
    							,T1.END_CUSTOMER
    							,T1.PROJECT_CODE
    							,T1.YYYYMM
    							,T1.CUST_FCST_M
    							,T1.MEASURE
    							,NVL(CEILING(T1.P_VALUE), 0)
    							,NVL(CEILING(T1.S_VALUE), 0)
    							,NVL(CEILING(T1.I_VALUE), 0)
    							,NVL(CEILING(T1.V_VALUE), 0)
    							,NVL(CEILING(T1.M_VALUE), 0)
    							,NVL(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE)  ||  CEILING(T1.S_VALUE)  ||  CEILING(T1.I_VALUE)  ||  CEILING(T1.V_VALUE)  ||  CEILING(T1.M_VALUE)  ||  CEILING(T1.CP_VALUE))), 0) AS MKT_FCST_M
    							,NVL(CEILING(T1.CUST_FCST_M * v_TRANSLATOR), 0) AS CUST_FCST_M_CELL
    							,NVL(CEILING(T1.P_VALUE * v_TRANSLATOR), 0) AS P_VALUE_CELL
    							,NVL(CEILING(T1.S_VALUE * v_TRANSLATOR), 0) AS S_VALUE_CELL
    							,NVL(CEILING(T1.I_VALUE * v_TRANSLATOR), 0) AS I_VALUE_CELL
    							,NVL(CEILING(T1.V_VALUE * v_TRANSLATOR), 0) AS V_VALUE_CELL
    							,NVL(CEILING(T1.M_VALUE * v_TRANSLATOR), 0) AS M_VALUE_CELL
    							,NVL(CEILING(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE)  ||  CEILING(T1.S_VALUE)  ||  CEILING(T1.I_VALUE)  ||  CEILING(T1.V_VALUE)  ||  CEILING(T1.M_VALUE)  ||  CEILING(T1.CP_VALUE))) * v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
    							,v_CREATED_BY
    							,SYSTIMESTAMP
    							,v_LAST_UPDATED_BY
    							,SYSTIMESTAMP
    							,NVL(CEILING(T1.CP_VALUE), 0)
    							,NVL(CEILING(T1.CP_VALUE * v_TRANSLATOR), 0) AS CP_VALUE_CELL
    						FROM (
    							SELECT DIVISION_ID
    								,END_CUSTOMER
    								,PROJECT_CODE
    								,YYYYMM
    								,CUST_FCST_M
    								,MEASURE
    								,MKT_FCST_M
    								,SUM(PRODUCT) AS P_VALUE
    								,SUM(SALES) AS S_VALUE
    								,SUM(INVENTORY) AS I_VALUE
    								,SUM(VPA) AS V_VALUE
    								,SUM(MODELMIX) AS M_VALUE
    								,SUM(SUPPLYISSUE) AS CP_VALUE
    							FROM DM_ANL_MKT_PSI_DETAIL;
    							PIVOT(SUM(QTY) FOR QTYCD3 IN (
    										PRODUCT
    										,SALES
    										,INVENTORY
    										,VPA
    										,MODELMIX
    										,SUPPLYISSUE
    										)) AS PVT
    							WHERE 1 = 1
    								AND DIVISION_ID = v_DIVISION_ID
    								AND END_CUSTOMER = v_END_CUSTOMER
    								AND PROJECT_CODE = v_PROJECT_CODE
    								AND YYYYMM = v_YYYYMM
    								AND MEASURE = v_MEASURE
    							GROUP BY DIVISION_ID
    								,END_CUSTOMER
    								,PROJECT_CODE
    								,YYYYMM
    								,CUST_FCST_M
    								,MEASURE
    								,MKT_FCST_M
    							) T1;
    
    						SELECT '1'
    							,*
    						FROM GT_DMF0_DM_ANL_MKT_PSI;
    					END;
    				ELSE  -- 수요계획(1st)가 존재하지 않을 시 INSERT ALL(해당월 첫 등록 시 나머지 MEASURE DEFAULT 값 처리)
    					DBMS_OUTPUT.PUT_LINE('INSERT INTO 2-1[수요계획(1ST) 미존재]----------------------------------------------------------------------------------------------------------------------------------------');
    
    					BEGIN -- 수요계획(1ST)가 없으면 나머지 MEASURE 데이터도 의미가 없으므로 삭제
    						DELETE
    						FROM DM_ANL_MKT_PSI
    						WHERE 1 = 1
    							AND DIVISION_ID = v_DIVISION_ID
    							AND END_CUSTOMER = v_END_CUSTOMER
    							AND PROJECT_CODE = v_PROJECT_CODE
    							AND YYYYMM = v_YYYYMM;
    					END;
    
    					BEGIN
    						INSERT INTO GT_DMF0_DM_ANL_MKT_PSI (;
    							DIVISION_ID
    							,END_CUSTOMER
    							,PROJECT_CODE
    							,YYYYMM
    							,CUST_FCST_M
    							,MEASURE
    							,P_VALUE
    							,S_VALUE
    							,I_VALUE
    							,V_VALUE
    							,M_VALUE
    							,MKT_FCST_M
    							,CUST_FCST_M_CELL
    							,P_VALUE_CELL
    							,S_VALUE_CELL
    							,I_VALUE_CELL
    							,V_VALUE_CELL
    							,M_VALUE_CELL
    							,MKT_FCST_M_CELL
    							,CREATED_BY
    							,CREATION_DATE
    							,LAST_UPDATED_BY
    							,LAST_UPDATE_DATE
    							,CP_VALUE
    							,CP_VALUE_CELL
    							)
    						--AN_LOGIC
    						SELECT v_DIVISION_ID
    							,v_END_CUSTOMER
    							,v_PROJECT_CODE
    							,v_YYYYMM
    							,CEILING(v_CUST_FCST_M) --CUST_FCST_M
    							,'AN_LOGIC'
    							,0 --P_VALUE
    							,0 --S_VALUE
    							,0 --I_VALUE
    							,0 --V_VALUE
    							,0 --M_VALUE
    							,0 --MKT_FCST_M
    							,0 --CUST_FCST_M_CELL
    							,0 --P_VALUE_CELL
    							,0 --S_VALUE_CELL
    							,0 --I_VALUE_CELL
    							,0 --V_VALUE_CELL
    							,0 --M_VALUE_CELL
    							,0 --MKT_FCST_M_CELL
    							,v_CREATED_BY
    							,SYSTIMESTAMP
    							,v_LAST_UPDATED_BY
    							,SYSTIMESTAMP
    							,0 --CP_VALUE
    							,0 --CP_VALUE_CELL
    							--AN_RESULT[분석로직(%)*고객수요계획]
    
    						UNION ALL
    
    						SELECT v_DIVISION_ID
    							,v_END_CUSTOMER
    							,v_PROJECT_CODE
    							,v_YYYYMM
    							,CEILING(v_CUST_FCST_M)
    							,'AN_RESULT'
    							,0 --P_VALUE
    							,0 --S_VALUE
    							,0 --I_VALUE
    							,0 --V_VALUE
    							,0 --M_VALUE
    							,0 --MKT_FCST_M
    							,0 --CUST_FCST_M_CELL
    							,0 --P_VALUE_CELL
    							,0 --S_VALUE_CELL
    							,0 --I_VALUE_CELL
    							,0 --V_VALUE_CELL
    							,0 --M_VALUE_CELL
    							,0 --MKT_FCST_M_CELL
    							,v_CREATED_BY
    							,SYSTIMESTAMP
    							,v_LAST_UPDATED_BY
    							,SYSTIMESTAMP
    							,0 --CP_VALUE
    							,0 --CP_VALUE_CELL
    
    						UNION ALL
    
    						--DP_INIT
    						SELECT T1.DIVISION_ID
    							,T1.END_CUSTOMER
    							,T1.PROJECT_CODE
    							,T1.YYYYMM
    							,T1.CUST_FCST_M
    							,T1.MEASURE
    							,NVL(CEILING(T1.P_VALUE), 0)
    							,NVL(CEILING(T1.S_VALUE), 0)
    							,NVL(CEILING(T1.I_VALUE), 0)
    							,NVL(CEILING(T1.V_VALUE), 0)
    							,NVL(CEILING(T1.M_VALUE), 0)
    							,NVL(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE)  ||  CEILING(T1.S_VALUE)  ||  CEILING(T1.I_VALUE)  ||  CEILING(T1.V_VALUE)  ||  CEILING(T1.M_VALUE)  ||  CEILING(T1.CP_VALUE))), 0) AS MKT_FCST_M
    							,NVL(CEILING(T1.CUST_FCST_M * v_TRANSLATOR), 0) AS CUST_FCST_M_CELL
    							,NVL(CEILING(T1.P_VALUE * v_TRANSLATOR), 0) AS P_VALUE_CELL
    							,NVL(CEILING(T1.S_VALUE * v_TRANSLATOR), 0) AS S_VALUE_CELL
    							,NVL(CEILING(T1.I_VALUE * v_TRANSLATOR), 0) AS I_VALUE_CELL
    							,NVL(CEILING(T1.V_VALUE * v_TRANSLATOR), 0) AS V_VALUE_CELL
    							,NVL(CEILING(T1.M_VALUE * v_TRANSLATOR), 0) AS M_VALUE_CELL
    							,NVL(CEILING(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE)  ||  CEILING(T1.S_VALUE)  ||  CEILING(T1.I_VALUE)  ||  CEILING(T1.V_VALUE)  ||  CEILING(T1.M_VALUE)  ||  CEILING(T1.CP_VALUE))) * v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
    							,v_CREATED_BY
    							,SYSTIMESTAMP
    							,v_LAST_UPDATED_BY
    							,SYSTIMESTAMP
    							,NVL(CEILING(T1.CP_VALUE), 0)
    							,NVL(CEILING(T1.CP_VALUE * v_TRANSLATOR), 0) AS CP_VALUE_CELL
    						FROM (
    							SELECT DIVISION_ID
    								,END_CUSTOMER
    								,PROJECT_CODE
    								,YYYYMM
    								,CUST_FCST_M
    								,MEASURE
    								,SUM(PRODUCT) AS P_VALUE
    								,SUM(SALES) AS S_VALUE
    								,SUM(INVENTORY) AS I_VALUE
    								,SUM(VPA) AS V_VALUE
    								,SUM(MODELMIX) AS M_VALUE
    								,SUM(SUPPLYISSUE) AS CP_VALUE
    							FROM DM_ANL_MKT_PSI_DETAIL;
    							PIVOT(SUM(QTY) FOR QTYCD3 IN (
    										PRODUCT
    										,SALES
    										,INVENTORY
    										,VPA
    										,MODELMIX
    										,SUPPLYISSUE
    										)) AS PVT
    							WHERE 1 = 1
    								AND DIVISION_ID = v_DIVISION_ID
    								AND END_CUSTOMER = v_END_CUSTOMER
    								AND PROJECT_CODE = v_PROJECT_CODE
    								AND YYYYMM = v_YYYYMM
    								AND MEASURE = v_MEASURE
    							GROUP BY DIVISION_ID
    								,END_CUSTOMER
    								,PROJECT_CODE
    								,YYYYMM
    								,CUST_FCST_M
    								,MEASURE
    							) T1;
    
    						UNION ALL
    
    						-- DP_RESULT
    						SELECT v_DIVISION_ID
    							,v_END_CUSTOMER
    							,v_PROJECT_CODE
    							,v_YYYYMM
    							,CEILING(v_CUST_FCST_M)
    							,'DP_RESULT'
    							,0 --P_VALUE
    							,0 --S_VALUE
    							,0 --I_VALUE
    							,0 --V_VALUE
    							,0 --M_VALUE
    							,0 --MKT_FCST_M
    							,0 --CUST_FCST_M_CELL
    							,0 --P_VALUE_CELL
    							,0 --S_VALUE_CELL
    							,0 --I_VALUE_CELL
    							,0 --V_VALUE_CELL
    							,0 --M_VALUE_CELL
    							,0 --MKT_FCST_M_CELL
    							,v_CREATED_BY
    							,SYSTIMESTAMP
    							,v_LAST_UPDATED_BY
    							,SYSTIMESTAMP
    							,0 --CP_VALUE
    							,0 --CP_VALUE_CELL
    					END;
    				END IF;
    						--SELECT '2', * FROM GT_DMF0_DM_ANL_MKT_PSI
    			ELSE  -- 수요계획(Result) 저장
    				-- 수요계획(Result) 다음달 데이터 등록여부확인(다음달 데이터 첫등록여부 확인을 위함)
    				SELECT COUNT(*)
      INTO v_CNT
    				FROM DM_ANL_MKT_PSI
    				WHERE 1 = 1
    					AND DIVISION_ID = v_DIVISION_ID
    					AND END_CUSTOMER = v_END_CUSTOMER
    					AND PROJECT_CODE = v_PROJECT_CODE
    					--AND YYYYMM = v_YYYYMM
    					AND YYYYMM = TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
    					AND MEASURE = v_MEASURE
    
    				-- 수요계획(Result) 당월 분석로직/분석결과/DPINIT이 존재하지않을 시
    				SELECT v_CNT_PRE = COUNT(*)
    				FROM DM_ANL_MKT_PSI
    				WHERE 1 = 1
    					AND DIVISION_ID = v_DIVISION_ID
    					AND END_CUSTOMER = v_END_CUSTOMER
    					AND PROJECT_CODE = v_PROJECT_CODE
    					AND YYYYMM = v_YYYYMM;
    
    				IF v_CNT_PRE = 0 THEN
    					DBMS_OUTPUT.PUT_LINE('INSERT INTO 3[수요계획(Result) 저장, 당월 분석로직/분석결과/DPINIT 미존재]----------------------------------------------------------------------------------------------------');
    
    					--AN_LOGIC
    					INSERT INTO DM_ANL_MKT_PSI (;
    						DIVISION_ID
    						,END_CUSTOMER
    						,PROJECT_CODE
    						,YYYYMM
    						,CUST_FCST_M
    						,MEASURE
    						,P_VALUE
    						,S_VALUE
    						,I_VALUE
    						,V_VALUE
    						,M_VALUE
    						,MKT_FCST_M
    						,CUST_FCST_M_CELL
    						,P_VALUE_CELL
    						,S_VALUE_CELL
    						,I_VALUE_CELL
    						,V_VALUE_CELL
    						,M_VALUE_CELL
    						,MKT_FCST_M_CELL
    						,CREATED_BY
    						,CREATION_DATE
    						,LAST_UPDATED_BY
    						,LAST_UPDATE_DATE
    						,CP_VALUE
    						,CP_VALUE_CELL
    						)
    					SELECT v_DIVISION_ID
    						,v_END_CUSTOMER
    						,v_PROJECT_CODE
    						,v_YYYYMM
    						,CEILING(v_CUST_FCST_M)
    						,'AN_LOGIC'
    						,0 --P_VALUE
    						,0 --S_VALUE
    						,0 --I_VALUE
    						,0 --V_VALUE
    						,0 --M_VALUE
    						,0 --MKT_FCST_M
    						,0 --CUST_FCST_M_CELL
    						,0 --P_VALUE_CELL
    						,0 --S_VALUE_CELL
    						,0 --I_VALUE_CELL
    						,0 --V_VALUE_CELL
    						,0 --M_VALUE_CELL
    						,0 --MKT_FCST_M_CELL
    						,v_CREATED_BY
    						,SYSTIMESTAMP
    						,v_LAST_UPDATED_BY
    						,SYSTIMESTAMP
    						,0 --CP_VALUE
    						,0 --CP_VALUE_CELL
    					--AN_RESULT[분석로직(%)*고객수요계획]
    
    					UNION ALL
    
    					SELECT v_DIVISION_ID
    						,v_END_CUSTOMER
    						,v_PROJECT_CODE
    						,v_YYYYMM
    						,CEILING(v_CUST_FCST_M)
    						,'AN_RESULT'
    						,0 --P_VALUE
    						,0 --S_VALUE
    						,0 --I_VALUE
    						,0 --V_VALUE
    						,0 --M_VALUE
    						,0 --MKT_FCST_M
    						,0 --CUST_FCST_M_CELL
    						,0 --P_VALUE_CELL
    						,0 --S_VALUE_CELL
    						,0 --I_VALUE_CELL
    						,0 --V_VALUE_CELL
    						,0 --M_VALUE_CELL
    						,0 --MKT_FCST_M_CELL
    						,v_CREATED_BY
    						,SYSTIMESTAMP
    						,v_LAST_UPDATED_BY
    						,SYSTIMESTAMP
    						,0 --CP_VALUE
    						,0 --CP_VALUE_CELL
    					-- DP_INIT
    
    					UNION ALL
    
    					SELECT v_DIVISION_ID
    						,v_END_CUSTOMER
    						,v_PROJECT_CODE
    						,v_YYYYMM
    						,CEILING(v_CUST_FCST_M)
    						,'DP_INIT'
    						,0 --P_VALUE
    						,0 --S_VALUE
    						,0 --I_VALUE
    						,0 --V_VALUE
    						,0 --M_VALUE
    						,CEILING(v_MKT_FCST_M) --MKT_FCST_M
    						,0 --CUST_FCST_M_CELL
    						,0 --P_VALUE_CELL
    						,0 --S_VALUE_CELL
    						,0 --I_VALUE_CELL
    						,0 --V_VALUE_CELL
    						,0 --M_VALUE_CELL
    						,0 --MKT_FCST_M_CELL
    						,v_CREATED_BY
    						,SYSTIMESTAMP
    						,v_LAST_UPDATED_BY
    						,SYSTIMESTAMP
    						,0 --CP_VALUE
    						,0 --CP_VALUE_CELL
    					FROM DUAL;
    				END IF;
    
    				BEGIN -- 분석로직 임시테이블 저장(BEGIN~END)
    					-- 테이블중복제거
    					-- 임시확인용테이블 중복제거
    					EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_AN_LOGIC';
    
    					-- 해당월의 다음달 데이터 분석로직 데이터 저장
    					INSERT INTO GT_DMF0_AN_LOGIC (;
    						DIVISION_ID
    						,END_CUSTOMER
    						,PROJECT_CODE
    						,YYYYMM
    						,CUST_FCST_M
    						,MEASURE
    						,P_VALUE
    						,S_VALUE
    						,I_VALUE
    						,V_VALUE
    						,M_VALUE
    						,MKT_FCST_M
    						,CUST_FCST_M_CELL
    						,P_VALUE_CELL
    						,S_VALUE_CELL
    						,I_VALUE_CELL
    						,V_VALUE_CELL
    						,M_VALUE_CELL
    						,MKT_FCST_M_CELL
    						,CP_VALUE
    						,CP_VALUE_CELL
    						)
    					SELECT v_DIVISION_ID
    						,v_END_CUSTOMER
    						,v_PROJECT_CODE
    						,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
    						,CEILING(v_CUST_FCST_M)
    						,'AN_LOGIC'
    						,NVL(CEILING(B.P_QTY / A.EDI_QTY), 0) AS P_QTY
    						,NVL(CEILING(B.S_QTY / A.EDI_QTY), 0) AS S_QTY
    						,NVL(CEILING(B.I_QTY / A.EDI_QTY), 0) AS I_QTY
    						,NVL(CEILING(B.V_QTY / A.EDI_QTY), 0) AS V_QTY
    						,NVL(CEILING(B.M_QTY / A.EDI_QTY), 0) AS M_QTY
    						,0
    						,CEILING(v_CUST_FCST_M * v_TRANSLATOR) AS CUST_FCST_M_CELL
    						,NVL(CEILING(B.P_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS P_VALUE_CELL
    						,NVL(CEILING(B.S_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS S_VALUE_CELL
    						,NVL(CEILING(B.I_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS I_VALUE_CELL
    						,NVL(CEILING(B.V_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS V_VALUE_CELL
    						,NVL(CEILING(B.M_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS M_VALUE_CELL
    						,0 AS MKT_FCST_M_CELL
    						,NVL(CEILING(B.CP_QTY / A.EDI_QTY), 0) AS CP_QTY
    						,NVL(CEILING(B.CP_QTY / A.EDI_QTY) * v_TRANSLATOR, 0) AS CP_VALUE_CELL
    					FROM (
    						SELECT SUM(QTY) AS EDI_QTY
    						FROM DM_PLN_MKT_FCST
    						WHERE DIVISION_ID = v_DIVISION_ID
    							AND PROJECT_CODE = v_PROJECT_CODE
    							AND MEASURE IN (;
    								'CUST_FCST'
    								,'CUST_FCST_EDI'
    								)
    							AND YYYYMMDD >= (TO_CHAR(ADD_MONTHS(SYSDATE, (- 1)*12), 'YYYYMMDD') || '01')
    							AND YYYYMMDD <= TO_CHAR(EOMONTH(SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)  ||  '01'), 'YYYYMMDD')
    						) A;
    						,(
    							SELECT SUM(P_VALUE) AS P_QTY
    								,SUM(S_VALUE) AS S_QTY
    								,SUM(I_VALUE) AS I_QTY
    								,SUM(V_VALUE) AS V_QTY
    								,SUM(M_VALUE) AS M_QTY
    								,SUM(CP_VALUE) AS CP_QTY
    							FROM DM_ANL_MKT_PSI
    							WHERE DIVISION_ID = v_DIVISION_ID
    								AND END_CUSTOMER = v_END_CUSTOMER
    								AND PROJECT_CODE = v_PROJECT_CODE
    								AND MEASURE = 'DP_RESULT'
    								AND YYYYMM >= SUBSTR(TO_CHAR(ADD_MONTHS(SYSDATE, (- 1)*12), 'YYYYMMDD'), 1, 6)
    								AND YYYYMM <= SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
    							) B;
    				END;
    
    				IF v_CNT > 0 THEN
    					DBMS_OUTPUT.PUT_LINE('INSERT INTO 3-1[수요계획(Result) 저장, 수요계획(Result)가 존재시 DPINIT 만 나머지 삭제]----------------------------------------------------------------------------------------');
    
    					-- 분석로직, 분석결과는 해당월의 다음달 데이터 삭제, 수요계획(Result)는 해당월 데이터 삭제
    					BEGIN
    						DELETE
    						FROM DM_ANL_MKT_PSI
    						WHERE 1 = 1
    							AND DIVISION_ID = v_DIVISION_ID
    							AND END_CUSTOMER = v_END_CUSTOMER
    							AND PROJECT_CODE = v_PROJECT_CODE
    							AND YYYYMM = TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
    							AND MEASURE IN (;
    								'AN_LOGIC'
    								,'AN_RESULT'
    								)
    
    						DELETE
    						FROM DM_ANL_MKT_PSI
    						WHERE 1 = 1
    							AND DIVISION_ID = v_DIVISION_ID
    							AND END_CUSTOMER = v_END_CUSTOMER
    							AND PROJECT_CODE = v_PROJECT_CODE
    							AND YYYYMM = v_YYYYMM
    							AND MEASURE = 'DP_RESULT';
    					END;
    
    					-- DM_ANL_MKT_PSI 데이터 저장
    					BEGIN
    						INSERT INTO GT_DMF0_DM_ANL_MKT_PSI (;
    							DIVISION_ID
    							,END_CUSTOMER
    							,PROJECT_CODE
    							,YYYYMM
    							,CUST_FCST_M
    							,MEASURE
    							,P_VALUE
    							,S_VALUE
    							,I_VALUE
    							,V_VALUE
    							,M_VALUE
    							,MKT_FCST_M
    							,CUST_FCST_M_CELL
    							,P_VALUE_CELL
    							,S_VALUE_CELL
    							,I_VALUE_CELL
    							,V_VALUE_CELL
    							,M_VALUE_CELL
    							,MKT_FCST_M_CELL
    							,CREATED_BY
    							,CREATION_DATE
    							,LAST_UPDATED_BY
    							,LAST_UPDATE_DATE
    							,CP_VALUE
    							,CP_VALUE_CELL
    							)
    						--AN_LOGIC
    						SELECT DIVISION_ID
    							,END_CUSTOMER
    							,PROJECT_CODE
    							,YYYYMM
    							,v_CUST_FCST_M_PRE
    							,MEASURE
    							,NVL(P_VALUE, 0)
    							,NVL(S_VALUE, 0)
    							,NVL(I_VALUE, 0)
    							,NVL(V_VALUE, 0)
    							,NVL(M_VALUE, 0)
    							,NVL(MKT_FCST_M, 0)
    							,NVL(CUST_FCST_M_CELL, 0)
    							,NVL(P_VALUE_CELL, 0)
    							,NVL(S_VALUE_CELL, 0)
    							,NVL(I_VALUE_CELL, 0)
    							,NVL(V_VALUE_CELL, 0)
    							,NVL(M_VALUE_CELL, 0)
    							,NVL(MKT_FCST_M_CELL, 0)
    							,v_CREATED_BY
    							,SYSTIMESTAMP
    							,v_LAST_UPDATED_BY
    							,SYSTIMESTAMP
    							,NVL(CP_VALUE, 0)
    							,NVL(CP_VALUE_CELL, 0)
    						FROM GT_DMF0_AN_LOGIC
    						--AN_RESULT[분석로직(%)*고객수요계획]
    
    						UNION ALL
    
    						SELECT DIVISION_ID
    							,END_CUSTOMER
    							,PROJECT_CODE
    							,YYYYMM
    							,v_CUST_FCST_M_PRE
    							,'AN_RESULT'
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100), 0)
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100), 0)
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100), 0)
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100), 0)
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100), 0)
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) - (CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100))), 0)
    							,CUST_FCST_M_CELL
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100), 0)
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100), 0)
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100), 0)
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100), 0)
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100), 0)
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) - (CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100))), 0)
    							,v_CREATED_BY
    							,SYSTIMESTAMP
    							,v_LAST_UPDATED_BY
    							,SYSTIMESTAMP
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100), 0)
    							,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100), 0)
    						FROM GT_DMF0_AN_LOGIC
    						-- DP_RESULT
    
    						UNION ALL
    
    						SELECT T1.DIVISION_ID
    							,T1.END_CUSTOMER
    							,T1.PROJECT_CODE
    							,T1.YYYYMM
    							,T1.CUST_FCST_M
    							,T1.MEASURE
    							,NVL(CEILING(T1.P_VALUE), 0)
    							,NVL(CEILING(T1.S_VALUE), 0)
    							,NVL(CEILING(T1.I_VALUE), 0)
    							,NVL(CEILING(T1.V_VALUE), 0)
    							,NVL(CEILING(T1.M_VALUE), 0)
    							,NVL(CEILING(T1.MKT_FCST_M), 0) AS MKT_FCST_M
    							,T1.CUST_FCST_M * v_TRANSLATOR AS CUST_FCST_M_CELL
    							,NVL(CEILING(T1.P_VALUE * v_TRANSLATOR), 0) AS P_VALU_CELL
    							,NVL(CEILING(T1.S_VALUE * v_TRANSLATOR), 0) AS S_VALU_CELL
    							,NVL(CEILING(T1.I_VALUE * v_TRANSLATOR), 0) AS I_VALU_CELL
    							,NVL(CEILING(T1.V_VALUE * v_TRANSLATOR), 0) AS V_VALU_CELL
    							,NVL(CEILING(T1.M_VALUE * v_TRANSLATOR), 0) AS M_VALU_CELL
    							,NVL(CEILING(T1.MKT_FCST_M * v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
    							,v_CREATED_BY
    							,SYSTIMESTAMP
    							,v_LAST_UPDATED_BY
    							,SYSTIMESTAMP
    							,NVL(CEILING(T1.CP_VALUE), 0)
    							,NVL(CEILING(T1.CP_VALUE * v_TRANSLATOR), 0) AS CP_VALU_CELL
    						FROM (
    							SELECT DIVISION_ID
    								,END_CUSTOMER
    								,PROJECT_CODE
    								,YYYYMM
    								,CUST_FCST_M
    								,MEASURE
    								,MKT_FCST_M
    								,SUM(PRODUCT) AS P_VALUE
    								,SUM(SALES) AS S_VALUE
    								,SUM(INVENTORY) AS I_VALUE
    								,SUM(VPA) AS V_VALUE
    								,SUM(MODELMIX) AS M_VALUE
    								,SUM(SUPPLYISSUE) AS CP_VALUE
    							FROM DM_ANL_MKT_PSI_DETAIL;
    							PIVOT(SUM(QTY) FOR QTYCD3 IN (
    										PRODUCT
    										,SALES
    										,INVENTORY
    										,VPA
    										,MODELMIX
    										,SUPPLYISSUE
    										)) AS PVT
    							WHERE 1 = 1
    								AND DIVISION_ID = v_DIVISION_ID
    								AND END_CUSTOMER = v_END_CUSTOMER
    								AND PROJECT_CODE = v_PROJECT_CODE
    								AND YYYYMM = v_YYYYMM
    								AND MEASURE = v_MEASURE
    							GROUP BY DIVISION_ID
    								,END_CUSTOMER
    								,PROJECT_CODE
    								,YYYYMM
    								,CUST_FCST_M
    								,MEASURE
    								,MKT_FCST_M
    							) T1;
    					END;
    
    					SELECT '3'
    						,*
    					FROM GT_DMF0_DM_ANL_MKT_PSI;
    				ELSE  -- 수요계획(Result)가 존재하지 않을 시 INSERT ALL(해당월의 다음달 첫 등록 시 나머지 MEASURE DEFAULT 값 처리)
    					DBMS_OUTPUT.PUT_LINE('INSERT INTO 3-1[수요계획(Result) 미존재]----------------------------------------------------------------------------------------');
    
    					IF v_CNT_PRE > 0 THEN
    						DELETE
    						FROM DM_ANL_MKT_PSI
    						WHERE 1 = 1
    							AND DIVISION_ID = v_DIVISION_ID
    							AND END_CUSTOMER = v_END_CUSTOMER
    							AND PROJECT_CODE = v_PROJECT_CODE
    							AND YYYYMM = v_YYYYMM
    							AND MEASURE = 'DP_RESULT';
    					END IF;
    
    					INSERT INTO GT_DMF0_DM_ANL_MKT_PSI (;
    						DIVISION_ID
    						,END_CUSTOMER
    						,PROJECT_CODE
    						,YYYYMM
    						,CUST_FCST_M
    						,MEASURE
    						,P_VALUE
    						,S_VALUE
    						,I_VALUE
    						,V_VALUE
    						,M_VALUE
    						,MKT_FCST_M
    						,CUST_FCST_M_CELL
    						,P_VALUE_CELL
    						,S_VALUE_CELL
    						,I_VALUE_CELL
    						,V_VALUE_CELL
    						,M_VALUE_CELL
    						,MKT_FCST_M_CELL
    						,CREATED_BY
    						,CREATION_DATE
    						,LAST_UPDATED_BY
    						,LAST_UPDATE_DATE
    						,CP_VALUE
    						,CP_VALUE_CELL
    						)
    					--AN_LOGIC
    					SELECT DIVISION_ID
    						,END_CUSTOMER
    						,PROJECT_CODE
    						--, YYYYMM
    						,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
    						,CEILING(v_CUST_FCST_M_PRE)
    						,MEASURE
    						,NVL(P_VALUE, 0)
    						,NVL(S_VALUE, 0)
    						,NVL(I_VALUE, 0)
    						,NVL(V_VALUE, 0)
    						,NVL(M_VALUE, 0)
    						,NVL(MKT_FCST_M, 0)
    						,CUST_FCST_M_CELL
    						,NVL(P_VALUE_CELL, 0)
    						,NVL(S_VALUE_CELL, 0)
    						,NVL(I_VALUE_CELL, 0)
    						,NVL(V_VALUE_CELL, 0)
    						,NVL(M_VALUE_CELL, 0)
    						,NVL(MKT_FCST_M_CELL, 0)
    						,v_CREATED_BY
    						,SYSTIMESTAMP
    						,v_LAST_UPDATED_BY
    						,SYSTIMESTAMP
    						,NVL(CP_VALUE, 0)
    						,NVL(CP_VALUE_CELL, 0)
    					FROM GT_DMF0_AN_LOGIC
    					--AN_RESULT[분석로직(%)*고객수요계획]
    
    					UNION ALL
    
    					SELECT DIVISION_ID
    						,END_CUSTOMER
    						,PROJECT_CODE
    						--, YYYYMM
    						,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
    						,CEILING(v_CUST_FCST_M_PRE)
    						,'AN_RESULT'
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100), 0)
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100), 0)
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100), 0)
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100), 0)
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100), 0)
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) - (CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100))), 0)
    						,CUST_FCST_M_CELL
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100), 0)
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100), 0)
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100), 0)
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100), 0)
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100), 0)
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) - (CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100)  ||  CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100))), 0)
    						,v_CREATED_BY
    						,SYSTIMESTAMP
    						,v_LAST_UPDATED_BY
    						,SYSTIMESTAMP
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100), 0)
    						,NVL(CEILING(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100), 0)
    					FROM GT_DMF0_AN_LOGIC
    
    					UNION ALL
    
    					SELECT v_DIVISION_ID
    						,v_END_CUSTOMER
    						,v_PROJECT_CODE
    						,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
    						,CEILING(v_CUST_FCST_M_PRE)
    						,'DP_INIT'
    						,0
    						,0
    						,0
    						,0
    						,0
    						,CEILING(v_MKT_FCST_M)
    						,CEILING(v_CUST_FCST_M_CELL)
    						,0
    						,0
    						,0
    						,0
    						,0
    						,CEILING(v_MKT_FCST_M_CELL)
    						,v_CREATED_BY
    						,SYSTIMESTAMP
    						,v_LAST_UPDATED_BY
    						,SYSTIMESTAMP
    						,0
    						,0
    
    					UNION ALL
    
    					SELECT T1.DIVISION_ID
    						,T1.END_CUSTOMER
    						,T1.PROJECT_CODE
    						,T1.YYYYMM
    						,T1.CUST_FCST_M
    						,T1.MEASURE
    						,NVL(CEILING(T1.P_VALUE), 0)
    						,NVL(CEILING(T1.S_VALUE), 0)
    						,NVL(CEILING(T1.I_VALUE), 0)
    						,NVL(CEILING(T1.V_VALUE), 0)
    						,NVL(CEILING(T1.M_VALUE), 0)
    						,NVL(CEILING(T1.MKT_FCST_M), 0) AS MKT_FCST_M
    						,T1.CUST_FCST_M * v_TRANSLATOR AS CUST_FCST_M_CELL
    						,NVL(CEILING(T1.P_VALUE * v_TRANSLATOR), 0) AS P_VALU_CELL
    						,NVL(CEILING(T1.S_VALUE * v_TRANSLATOR), 0) AS S_VALU_CELL
    						,NVL(CEILING(T1.I_VALUE * v_TRANSLATOR), 0) AS I_VALU_CELL
    						,NVL(CEILING(T1.V_VALUE * v_TRANSLATOR), 0) AS V_VALU_CELL
    						,NVL(CEILING(T1.M_VALUE * v_TRANSLATOR), 0) AS M_VALU_CELL
    						,NVL(CEILING(T1.MKT_FCST_M * v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
    						,v_CREATED_BY
    						,SYSTIMESTAMP
    						,v_LAST_UPDATED_BY
    						,SYSTIMESTAMP
    						,NVL(CEILING(T1.CP_VALUE), 0)
    						,NVL(CEILING(T1.CP_VALUE * v_TRANSLATOR), 0) AS CP_VALU_CELL
    					FROM (
    						SELECT DIVISION_ID
    							,END_CUSTOMER
    							,PROJECT_CODE
    							,YYYYMM
    							,CUST_FCST_M
    							,MEASURE
    							,MKT_FCST_M
    							,SUM(PRODUCT) AS P_VALUE
    							,SUM(SALES) AS S_VALUE
    							,SUM(INVENTORY) AS I_VALUE
    							,SUM(VPA) AS V_VALUE
    							,SUM(MODELMIX) AS M_VALUE
    							,SUM(SUPPLYISSUE) AS CP_VALUE
    						FROM DM_ANL_MKT_PSI_DETAIL;
    						PIVOT(SUM(QTY) FOR QTYCD3 IN (
    									PRODUCT
    									,SALES
    									,INVENTORY
    									,VPA
    									,MODELMIX
    									,SUPPLYISSUE
    									)) AS PVT
    						WHERE 1 = 1
    							AND DIVISION_ID = v_DIVISION_ID
    							AND END_CUSTOMER = v_END_CUSTOMER
    							AND PROJECT_CODE = v_PROJECT_CODE
    							AND YYYYMM = v_YYYYMM
    							AND MEASURE = v_MEASURE
    						GROUP BY DIVISION_ID
    							,END_CUSTOMER
    							,PROJECT_CODE
    							,YYYYMM
    							,CUST_FCST_M
    							,MEASURE
    							,MKT_FCST_M
    						) T1;
    
    					UNION ALL
    
    					SELECT v_DIVISION_ID
    						,v_END_CUSTOMER
    						,v_PROJECT_CODE
    						,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
    						,CEILING(v_CUST_FCST_M_PRE)
    						,'DP_RESULT'
    						,0
    						,0
    						,0
    						,0
    						,0
    						,0
    						,CEILING(v_CUST_FCST_M_CELL) AS CUST_FCST_M_CELL
    						,0 AS P_VALU_CELL
    						,0 AS S_VALU_CELL
    						,0 AS I_VALU_CELL
    						,0 AS V_VALU_CELL
    						,0 AS M_VALU_CELL
    						,0 AS MKT_FCST_M_CELL
    						,v_CREATED_BY
    						,SYSTIMESTAMP
    						,v_LAST_UPDATED_BY
    						,SYSTIMESTAMP
    						,0
    						,0 AS CP_VALU_CELL
    
    					SELECT '4'
    						,*
    					FROM GT_DMF0_DM_ANL_MKT_PSI;
    				END IF;
    		END;
    		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
    
    		BEGIN -- 본 테이블 INSERT INTO SELECT '5'
    				,*
    			FROM GT_DMF0_DM_ANL_MKT_PSI;
    
    			INSERT INTO DM_ANL_MKT_PSI (;
    				DIVISION_ID
    				,END_CUSTOMER
    				,PROJECT_CODE
    				,YYYYMM
    				,CUST_FCST_M
    				,MEASURE
    				,P_VALUE
    				,S_VALUE
    				,I_VALUE
    				,V_VALUE
    				,M_VALUE
    				,MKT_FCST_M
    				,DESC
    				,INPUT_LIMIT
    				,CUST_FCST_M_CELL
    				,P_VALUE_CELL
    				,S_VALUE_CELL
    				,I_VALUE_CELL
    				,V_VALUE_CELL
    				,M_VALUE_CELL
    				,MKT_FCST_M_CELL
    				,CREATED_BY
    				,CREATION_DATE
    				,LAST_UPDATED_BY
    				,LAST_UPDATE_DATE
    				,CP_VALUE
    				,CP_VALUE_CELL
    				)
    			SELECT DIVISION_ID
    				,END_CUSTOMER
    				,PROJECT_CODE
    				,YYYYMM
    				,CUST_FCST_M
    				,MEASURE
    				,TO_NUMBER(P_VALUE)
    				,TO_NUMBER(S_VALUE)
    				,TO_NUMBER(I_VALUE)
    				,TO_NUMBER(V_VALUE)
    				,TO_NUMBER(M_VALUE)
    				,TO_NUMBER(MKT_FCST_M)
    				,DESC
    				,INPUT_LIMIT
    				,TO_NUMBER(CUST_FCST_M_CELL)
    				,TO_NUMBER(P_VALUE_CELL)
    				,TO_NUMBER(S_VALUE_CELL)
    				,TO_NUMBER(I_VALUE_CELL)
    				,TO_NUMBER(V_VALUE_CELL)
    				,TO_NUMBER(M_VALUE_CELL)
    				,TO_NUMBER(MKT_FCST_M_CELL)
    				,CREATED_BY
    				,SYSDATE
    				,LAST_UPDATED_BY
    				,SYSDATE
    				,TO_NUMBER(CP_VALUE)
    				,TO_NUMBER(CP_VALUE_CELL)
    			FROM GT_DMF0_DM_ANL_MKT_PSI;
    		END;
    		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
    
    
    		/*
    		2024.01.10    kcw3408        PR_DM_ANL_MKT_PSI_DATA:고객수요증감분석 데이터 기초값 생성 및 인터페이스 전송 배치 작업 신규로  I/F 테이블 INSERT INTO 삭제함
    		*/
    		/*
    		BEGIN -- I/F 테이블 INSERT
    			--SELECT '6', * FROM GT_DMF0_DM_ANL_MKT_PSI
    			--**중요 -> 운영 반영시 DB명 변경 (운영:LGCE_INF, 개발:LGCE_INFDEV)
    			BEGIN -- I/F 테이블 해당 PROJECT 삭제
    				DELETE
    				FROM LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DW_S
    				WHERE DIVISION_ID = v_Division_id
    					AND END_CUSTOMER = p_end_customer
    					AND PROJECT_CODE = p_project_code;
    			END
    
    			INSERT INTO LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DW_S (;
    				DIVISION_ID
    				,END_CUSTOMER
    				,PROJECT_CODE
    				,YYYYMM
    				,CUST_FCST_M
    				,MEASURE
    				,P_VALUE
    				,S_VALUE
    				,I_VALUE
    				,V_VALUE
    				,M_VALUE
    				,MKT_FCST_M
    				,DESC
    				,INPUT_LIMIT
    				,CUST_FCST_M_CELL
    				,P_VALUE_CELL
    				,S_VALUE_CELL
    				,I_VALUE_CELL
    				,V_VALUE_CELL
    				,M_VALUE_CELL
    				,MKT_FCST_M_CELL
    				,CREATED_BY
    				,CREATION_DATE
    				,LAST_UPDATED_BY
    				,LAST_UPDATE_DATE
    				,CP_VALUE
    				,CP_VALUE_CELL
    				)
    			SELECT DIVISION_ID
    				,END_CUSTOMER
    				,PROJECT_CODE
    				,YYYYMM
    				,CUST_FCST_M
    				,MEASURE
    				,TO_NUMBER(P_VALUE)
    				,TO_NUMBER(S_VALUE)
    				,TO_NUMBER(I_VALUE)
    				,TO_NUMBER(V_VALUE)
    				,TO_NUMBER(M_VALUE)
    				,TO_NUMBER(MKT_FCST_M)
    				,DESC
    				,INPUT_LIMIT
    				,TO_NUMBER(CUST_FCST_M_CELL)
    				,TO_NUMBER(P_VALUE_CELL)
    				,TO_NUMBER(S_VALUE_CELL)
    				,TO_NUMBER(I_VALUE_CELL)
    				,TO_NUMBER(V_VALUE_CELL)
    				,TO_NUMBER(M_VALUE_CELL)
    				,TO_NUMBER(MKT_FCST_M_CELL)
    				,CREATED_BY
    				,SYSDATE
    				,LAST_UPDATED_BY
    				,SYSDATE
    				,TO_NUMBER(CP_VALUE)
    				,TO_NUMBER(CP_VALUE_CELL)
    			FROM DM_ANL_MKT_PSI
    			WHERE DIVISION_ID = v_Division_id
    				AND PROJECT_CODE = p_project_code
    				AND END_CUSTOMER = p_end_customer;
    		END
    
    		-- 프로젝트 OWNERSHIP으로 DEPT_ID 정보 추출 START
    			BEGIN
    				INSERT INTO GT_DMF0_PROJECT_DEPT
    				SELECT PRJ.DIVISION_ID,PRJ.PROJECT_CODE, PRJ.PROJECT_NAME, DEPT.DEPT_ID, DEPT.DEPT_NAME_KO FROM SCM_MST_PROJECT PRJ INNER JOIN
    				(
    				SELECT A.USER_ID, A.USER_NAME, A.USER_NAME_EN, A.DEPT_ID, B.DEPT_NAME_KO
    					FROM SCM_MST_SSO_USER_INFO A
    						INNER JOIN SCM_MST_SSO_DEPT_INFO B
    							ON A.DEPT_ID = B.DEPT_ID
    				) DEPT ON DEPT.USER_ID = PRJ.PROJECT_OWNER
    			END
    
    
    		-- 프로젝트 OWNERSHIP으로 DEPT_ID 정보 추출 END
    
    		/* TODO:GTT:GT_DMF0_ITEM_ID-->GT_DMF0_ITEM_ID */
    		INSERT INTO GT_DMF0_ITEM_ID
    		SELECT ROW_NUMBER() OVER(ORDER BY A.ITEM_ID) SEQ, A.ITEM_ID
    		FROM
    		(SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V GROUP BY ITEM_ID) A
    
    
    
    
    		SELECT COUNT(*)
      INTO V_ITEM_CNT
    		FROM GT_DMF0_ITEM_ID;
    
    		--SELECT * FROM GT_DMF0_ITEM_ID
    
    		BEGIN -- I/F 테이블 INSERT
    			--SELECT '6', * FROM GT_DMF0_DM_ANL_MKT_PSI
    			--**중요 -> 운영 반영시 DB명 변경 (운영:LGCE_INF, 개발:LGCE_INFDEV)
    			BEGIN -- I/F 테이블 해당 PROJECT 삭제
    				DELETE
    				FROM LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DETAIL_DW_S
    				WHERE DIVISION_ID = v_Division_id
    					AND PROJECT_CODE = p_project_code
    					AND END_CUSTOMER = p_end_customer;
    			END
    
    			WHILE v_i <= V_ITEM_CNT
    			BEGIN
    				SELECT V_ITEM_ID = ITEM_ID FROM GT_DMF0_ITEM_ID WHERE SEQ = v_i
    				INSERT INTO LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DETAIL_DW_S (;
    							DIVISION_ID
    							,DEPT_ID
    							,DEPT_NAME_KO
    							,PROJECT_NAME
    							,PROJECT_CODE
    							,ITEM_ID --,SCM_SITE_ID
    							,END_CUSTOMER
    							,YYYYMM
    							,CUST_FCST_M
    							,MEASURE
    							,QTYCD1
    							,QTYCD2
    							,QTYCD3
    							,SEQ
    							,QTY
    							,MKT_FCST_M
    							,DESC
    							,INPUT_LIMIT
    							,CUST_FCST_M_CELL
    							,QTY_CELL
    							,MKT_FCST_M_CELL
    							,CREATED_BY
    							,CREATION_DATE
    							,LAST_UPDATED_BY
    							,LAST_UPDATE_DATE
    
    					)
    				SELECT
    					 A.DIVISION_ID
    					,B.DEPT_ID
    					,B.DEPT_NAME_KO
    					,B.PROJECT_NAME
    					,A.PROJECT_CODE
    					,V_ITEM_ID AS ITEM_ID
    					,A.END_CUSTOMER
    					,A.YYYYMM
    					,A.CUST_FCST_M
    					,A.MEASURE
    					,A.QTYCD1
    					,A.QTYCD2
    					,A.QTYCD3
    					,A.SEQ
    					,A.QTY
    					,A.MKT_FCST_M
    					,A.DESC
    					,A.INPUT_LIMIT
    					,A.CUST_FCST_M * v_TRANSLATOR -- A.CUST_FCST_M_CELL
    					,A.QTY * v_TRANSLATOR --A.QTY_CELL
    					,A.MKT_FCST_M * v_TRANSLATOR --A.MKT_FCST_M_CELL
    					,A.CREATED_BY
    					,SYSDATE
    					, p_created_by --,A.LAST_UPDATED_BY
    					,SYSDATE
    
    				FROM DM_ANL_MKT_PSI_DETAIL A
    				INNER JOIN GT_DMF0_PROJECT_DEPT B	ON A.DIVISION_ID = B.DIVISION_ID  AND A.PROJECT_CODE = B.PROJECT_CODE
    				WHERE A.DIVISION_ID = v_Division_id
    					AND A.PROJECT_CODE = p_project_code
    					AND A.END_CUSTOMER = p_end_customer;
    
    				v_i := v_i || 1;
    			END
    		*/
    
    		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
    
    		--DMF0003_GET_DM_ANL_MKT_PSI_DATA v_DIVISION_ID, v_PROJECT_CODE, v_YYYYMM, v_CREATED_BY;
    		COMMIT;
    	-- END TRY
    
    	EXCEPTION
    	    WHEN OTHERS THEN
    
    		-- ERROR LOG
    		v_log_type := 'ERROR';
    		v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
    		v_description := 'ERROR_LINE : '  ||  STR(NULL);
    		d_event_date := SYSTIMESTAMP;
    
    		PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT);
    			,v_log_type
    			,n_log_count
    			,v_log_message
    			,v_description
    			,d_event_date;
    
    		SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;
    	-- END CATCH
    
    	-- 종료 LOG
    	v_log_type := 'END';
    	v_log_message := '########## END of procedure ##########';
    	v_description := NULL;
    	d_event_date := SYSTIMESTAMP;
    
    	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT);
    		,v_log_type
    		,n_log_count
    		,v_log_message
    		,v_description
    		,d_event_date;
            RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
    END;
    
    -- 트랜잭션 (END)
    err_rtn:
    
    IF v_log_type = 'INVALID' THEN
    	SELECT v_description
    
    
    	v_log_message := '########## END of procedure ##########';
    	d_event_date := SYSTIMESTAMP;
    
    	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT);
    		,v_log_type
    		,n_log_count
    		,v_log_message
    		,v_description
    		,d_event_date;
    
    
    	-- 종료 LOG
    	v_log_type := 'END';
    	v_log_message := '########## END of procedure ##########';
    	v_description := NULL;
    	d_event_date := SYSTIMESTAMP;
    
    	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT);
    		,v_log_type
    		,n_log_count
    		,v_log_message
    		,v_description
    		,d_event_date;
    END IF;

    PROCEDURE P_DMF0003_SAVE_PRPOPUP (
    	  p_POPUP_TYPE			VARCHAR2
    	, p_ITEM_SEQ			VARCHAR2
    	, p_DIVISION_ID		    VARCHAR2
    	, p_PROJECT_CODE		VARCHAR2
    	, p_SCM_SITE_ID		    VARCHAR2
    	, p_ITEM_ID			    VARCHAR2
    	, p_DOM_EXP			    VARCHAR2
    	, p_FCST_TYPE			VARCHAR2
    	, p_INCOTERMS			VARCHAR2
    	, p_PLANT_SITE_ID		VARCHAR2
    	, p_YYYYMMDD			VARCHAR2
    	, p_UOM				    VARCHAR2
    	, p_PLAN_QTY			VARCHAR2
    	, p_STORAGE_ID			VARCHAR2
    	, p_STORAGE_PLANT_ID	VARCHAR2
    	, p_PUCH_MGR			VARCHAR2
    	, p_PUCH_GROUP			VARCHAR2
    	, p_PR_HEADER			VARCHAR2
    	, p_PR_ITEM_DETAIL		VARCHAR2
    	, p_CREATED_BY			VARCHAR2
    
    )
        IS
    ;

    END PKG_DMF0003;
/
