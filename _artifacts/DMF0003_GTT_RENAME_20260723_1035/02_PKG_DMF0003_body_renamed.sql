
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SCM_MGR"."PKG_DMF0003" IS
-- [DMF0003 GTT RENAME 20260723] GT_GGET_/GT_MFCP_/GT_SAVEPK_ -> GT_DMF0003_* (39 GTT)

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
    V_PROGRAM_NAME VARCHAR2(200) := $$PLSQL_UNIT;
BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
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
      '[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE ||
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
  v_sheet_name        VARCHAR2(40 CHAR)  := 'carFcst';
  v_sql_text          CLOB;
  v_creation_date     VARCHAR2(40 CHAR);
  v_count             PLS_INTEGER;
  v_start_yyyymmdd    VARCHAR2(8 CHAR);
  v_end_yyyymmdd      VARCHAR2(8 CHAR);
  v_division          VARCHAR2(10 CHAR); --[E20230227-000456]소형사업부 RPA 업로드 시 GSCM Fail 발생

  -- LOG 용 변수 설정
  V_PROGRAM_NAME      VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

  v_log_type    := 'START';
  v_log_message := '########## Start of procedure ##########';
  v_description := '';
  d_event_date  := SYSDATE;
  BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    ----------------------------------------------------------------------------

  END IF;  --  IF NVL(P_MODE, 0) = 0 THEN

  ----------------------------------------------------------------------------
  --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
  v_log_type    := '17';
  v_log_message := '########## INSERT DATA START ##########';
  v_description := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
  d_event_date  := SYSDATE;
  BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    ----------------------------------------------------------------------------

    SAVEPOINT CAR_FCST;
    BEGIN

      ----------------------------------------------------------------------------
      --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
      v_log_type    := '20-1';
      v_log_message := '########## DELETE DM_ANL_CAR_FCST_REF DATE END ##########';
      v_description := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
      d_event_date  := SYSDATE;
      BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
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
      BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
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
      BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
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
  BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
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
  BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

    RAISE_APPLICATION_ERROR(-20001,
      '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
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

    V_PROGRAM_NAME VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
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

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
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

    V_PROGRAM_NAME  VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
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

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
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
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPINIT @p_division_id=N'81',@p_project_code=N'A15BW7001',@p_yyyymm=N'202308',@p_created_by=N'',@p_end_customer=N'BMW'

 */
    V_PROGRAM_NAME  VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
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

        --     AND YYYYMM = CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112)
        --END

        --IF (@CNT = 0)
        --BEGIN
        --  BEGIN
        --      INSERT INTO #TEMP_DATA
        --      SELECT @p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, 0, N'고객', N'수요', N'차량생산', '', 0, '', 0
        --  END
        --  BEGIN
        --      INSERT INTO #TEMP_DATA
        --      SELECT @p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, 0, N'고객', N'수요', N'차량판매', '', 0, '', 0
        --  END
        --  BEGIN
        --      INSERT INTO #TEMP_DATA
        --      SELECT @p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, 0, N'고객', N'수요', N'물류이슈', '', 0, '', 0
        --  END
        --  BEGIN
        --      INSERT INTO #TEMP_DATA
        --      SELECT @p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, 0, N'당사', N'운영', N'시점조정', '', 0, '', 0
        --  END
        --  BEGIN
        --      INSERT INTO #TEMP_DATA
        --      SELECT @p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, 0, N'당사', N'운영', N'모델믹스', '', 0, '', 0
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
             , CASE QTYCD1 WHEN 'CUSTOMER' THEN N'고객'--'100'-- N'고객'
                           WHEN 'COMPANY' THEN N'당사'--'200' --N'당사'
                           END AS IMPUTATION_YN
             , CASE QTYCD2 WHEN 'DEMAND' THEN N'수요'--N'110'--N'수요'
                           WHEN 'OPERATION' THEN N'운영'--N'210'--N'운영'
                           WHEN 'SUPPLY' THEN N'공급'--N'220'--N'공급'
                           END AS DEMAND_OPERATION
             , CASE QTYCD3 WHEN 'PRODUCT' THEN N'차량생산'--N'111'--N'차량생산'
                           WHEN 'SALES' THEN N'차량판매'--N'112'--N'차량판매'
                           WHEN 'INVENTORY' THEN N'물류이슈'--N'113'--N'물류이슈'
                           WHEN 'VPA' THEN N'시점조정'--N'211'--N'시점조정'
                           WHEN 'MODELMIX' THEN N'모델믹스' --N'212'--N'모델믹스'
                           WHEN 'SUPPLYISSUE' THEN N'공급차질' --N'221'--N'공급차질'

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
           --AND YYYYMM BETWEEN CONVERT(CHAR(6), DATEADD(MONTH, -11, GETDATE()), 112) AND CONVERT(CHAR(6), GETDATE(), 112);
           AND YYYYMM = @p_yyyymm--CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112)
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
                   WHEN 'CUSTOMER' THEN '고객'--'100'-- N'고객'
                   WHEN 'COMPANY'  THEN '당사'--'200' --N'당사'
               END AS IMPUTATION_YN
             , CASE QTYCD2
                   WHEN 'DEMAND'    THEN '수요'--N'110'--N'수요'
                   WHEN 'OPERATION' THEN '운영'--N'210'--N'운영'
                   WHEN 'SUPPLY'    THEN '공급'--N'220'--N'공급'
               END AS DEMAND_OPERATION
             , CASE QTYCD3
                   WHEN 'PRODUCT'     THEN '차량생산'--N'111'--N'차량생산'
                   WHEN 'SALES'       THEN '차량판매'--N'112'--N'차량판매'
                   WHEN 'INVENTORY'   THEN '물류이슈'--N'113'--N'물류이슈'
                   WHEN 'VPA'         THEN '시점조정'--N'211'--N'시점조정'
                   WHEN 'MODELMIX'    THEN '모델믹스' --N'212'--N'모델믹스'
                   WHEN 'SUPPLYISSUE' THEN '공급차질' --N'221'--N'공급차질'
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

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
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
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT @p_division_id=N'81',@p_project_code=N'A15BW7003',@p_yyyymm=N'202308',@p_created_by=N'',@p_end_customer=N'BMW'
 */

    --EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT'81','A15AI7001','202307','leetw85'

    V_PROGRAM_NAME  VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
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

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
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

    V_PROGRAM_NAME   VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
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
            AND    C.VISIBLE_FLAG = 'N'
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
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                    --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
                    --UNION ALL
                    --SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
                    --  , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                    --  , CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
                    --      WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
                    --      ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
                    --  , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                    --  , ''                        AS DAY_CODE
                    --  , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 32) AS SORT_ORDER_NO
                    --  , 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
                    --FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                    --WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
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
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                    GROUP BY A.BASIS_YYYYMM
                           , A.ISO_WEEK
                           , A.WEEK_NAME
                           , PARTIAL_WEEK_NAME  -- 20190610
                           , A.MONTH_NAME
                           , A.BASIS_START_DATE
                    --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
                    --UNION ALL
                    --SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
                    --  , CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
                    --      WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
                    --      ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME -- 20190610
                    --  , CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
                    --      WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
                    --      ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
                    --  , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                    --  , ''                    AS DAY_CODE
                    --  , A.BASIS_START_DATE + CONVERT(CHAR(2), 22) AS SORT_ORDER_NO
                    --  , 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
                    --FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                    --WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
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
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
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
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
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
            AND    C.VISIBLE_FLAG = 'N'
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
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                    --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
                    --UNION ALL ...
                    --SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
                    --  , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                    --  , CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
                    --  WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
                    --  ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
                    --  , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                    --  , ''                        AS DAY_CODE
                    --  , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 32) AS SORT_ORDER_NO
                    --FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                    --WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
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
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                    GROUP BY A.BASIS_YYYYMM
                           , A.ISO_WEEK
                           , A.WEEK_NAME
                           , PARTIAL_WEEK_NAME  -- 20190610
                           , A.MONTH_NAME
                           , A.BASIS_START_DATE
                    --[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
                    --UNION ALL
                    --SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
                    --  , CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
                    --  WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
                    --  ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME -- 20190610
                    --, CASE WHEN CHARINDEX('A', PARTIAL_WEEK_NAME) <> 0 THEN A.WEEK_NAME + '+'
                    --  WHEN CHARINDEX('B', PARTIAL_WEEK_NAME) <> 0 THEN '+' + A.WEEK_NAME
                    --  ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
                    --  , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                    --  , ''                    AS DAY_CODE
                    --  , A.BASIS_START_DATE + CONVERT(CHAR(2), 22) AS SORT_ORDER_NO
                    --FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                    --WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
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
                    AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
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
                    --AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
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
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_GET_SPREAD_TITLE;



/* ============================================================
   DMF0003_GET_MKT_FCST_COMPARE_POPUP
   ============================================================
   [GTT DDL - 별도 실행]
   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0003_MFCP_TEMP_DM_SSP
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
   ON COMMIT PRESERVE ROWS; /
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
    V_PROGRAM_NAME   VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- GTT TRUNCATE
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0003_MFCP_TEMP_DM_SSP';
    --EXECUTE IMMEDIATE 'ALTER SESSION SET GLOBAL_TEMP_TABLE_STATS = SESSION';

    --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    --1. 동기화
    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_DMF0003_MFCP_TEMP_DM_SSP
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
    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_DMF0003_MFCP_TEMP_DM_SSP
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
    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_DMF0003_MFCP_TEMP_DM_SSP
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
        TABNAME          => 'GT_DMF0003_MFCP_TEMP_DM_SSP',
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
                FROM   SCM_MGR.GT_DMF0003_MFCP_TEMP_DM_SSP A
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
                                          FROM   SCM_MGR.GT_DMF0003_MFCP_TEMP_DM_SSP S
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
                FROM   SCM_MGR.GT_DMF0003_MFCP_TEMP_DM_SSP A
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

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

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
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
    V_PROGRAM_NAME  VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
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
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
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
    V_PROGRAM_NAME  VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
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
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
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

    V_PROGRAM_NAME   VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    V_PROGRAM_ID   := 'DMF0003';
    V_SHEET_NAME   := 'carFcst';
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
                AND    C.VISIBLE_FLAG = 'N'
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
                AND    C.VISIBLE_FLAG = 'N'
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
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
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

    V_PROGRAM_NAME   VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    V_PROGRAM_ID   := 'DMF0003';
    V_SHEET_NAME   := 'psi';
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
                AND    C.VISIBLE_FLAG = 'N'
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
                AND    C.VISIBLE_FLAG = 'N'
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
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
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

    V_PROGRAM_NAME   VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
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
                AND    C.VISIBLE_FLAG = 'N'
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
                AND    C.VISIBLE_FLAG = 'N'
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
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
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
   ) ON COMMIT PRESERVE ROWS; /
   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_FSPS_T_MKT_FCST (
       DIVISION_ID    VARCHAR2(30  CHAR), PROJECT_CODE  VARCHAR2(50  CHAR),
       SCM_SITE_ID    VARCHAR2(30  CHAR), ITEM_ID       VARCHAR2(50  CHAR),
       DOM_EXP        VARCHAR2(3   CHAR), FCST_TYPE     VARCHAR2(20  CHAR),
       INCOTERMS      VARCHAR2(10  CHAR), MEASURE       VARCHAR2(50  CHAR),
       YYYYMMDD       VARCHAR2(8   CHAR), PLANT_SITE_ID VARCHAR2(30  CHAR),
       QTY            NUMBER(30,10),      CREATED_BY    VARCHAR2(150 CHAR),
       CREATION_DATE  DATE
   ) ON COMMIT PRESERVE ROWS; /
   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_FSPS_SALES_PLAN_TEMP_LOC (
       DIVISION_ID    VARCHAR2(30  CHAR), PROJECT_CODE  VARCHAR2(50  CHAR),
       SCM_SITE_ID    VARCHAR2(30  CHAR), ITEM_ID       VARCHAR2(50  CHAR),
       DOM_EXP        VARCHAR2(3   CHAR), FCST_TYPE     VARCHAR2(20  CHAR),
       INCOTERMS      VARCHAR2(10  CHAR), MEASURE       VARCHAR2(50  CHAR),
       PLANT_SITE_ID  VARCHAR2(30  CHAR), YYYYMMDD      CHAR(8 CHAR),
       CURRENCY       VARCHAR2(3   CHAR), QTY           NUMBER(30,10),
       CREATED_BY     VARCHAR2(150 CHAR), CREATION_DATE DATE
   ) ON COMMIT PRESERVE ROWS; /
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
    V_PROGRAM_NAME      VARCHAR2(200) := $$PLSQL_UNIT;
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
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
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
            -- where yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
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
                       WHERE  SALES_PLAN_ADJUST_YN  = 'N'
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
            -- and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
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
                       WHERE  SALES_PLAN_ADJUST_YN  = 'N'
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
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, T_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
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
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_MKT_FCST_SALES_PLAN_SYNC;

/* ============================================================
   DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE
   GTT DDL (별도 실행):

   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0003_SAVEPK_RESULTS (
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
   ) ON COMMIT PRESERVE ROWS; /

   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0003_SAVEPK_VALID_RESULTS (
       V_DIVISION_ID   VARCHAR2(400 CHAR),
       V_PROJECT_CODE  VARCHAR2(400 CHAR),
       V_SCM_SITE_ID   VARCHAR2(400 CHAR),
       V_ITEM_ID       VARCHAR2(400 CHAR),
       V_DOM_EXP       VARCHAR2(400 CHAR),
       V_FCST_TYPE     VARCHAR2(400 CHAR),
       V_INCOTERMS     VARCHAR2(400 CHAR),
       V_PLANT_SITE_ID VARCHAR2(400 CHAR),
       V_MEASURE       VARCHAR2(400 CHAR)
   ) ON COMMIT PRESERVE ROWS; /
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
    V_PROGRAM_NAME  VARCHAR2(200) := $$PLSQL_UNIT;
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
        FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS
        WHERE  1 = 1
        GROUP BY V_DIVISION_ID, V_SCM_SITE_ID, V_PROJECT_CODE;

BEGIN
    -- SESSION 설정
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DDL';
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL QUERY';
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- GTT TRUNCATE
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0003_SAVEPK_RESULTS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0003_SAVEPK_VALID_RESULTS';

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

    --###############################################  GT_DMF0003_SAVEPK_RESULTS 테이블에 split후 insert (START)
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

        INSERT INTO SCM_MGR.GT_DMF0003_SAVEPK_RESULTS (
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
    --###############################################  GT_DMF0003_SAVEPK_RESULTS 테이블에 split후 insert (END)

    --COMMIT;

    -- GTT 통계 수집
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0003_SAVEPK_RESULTS', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

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
        WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0003_SAVEPK_RESULTS WHERE V_DIVISION_ID = '40')
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
                   FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS A
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
    DELETE FROM SCM_MGR.GT_DMF0003_SAVEPK_VALID_RESULTS;
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
                       FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS X
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
                       FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS X
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
                       FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS X
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
            INSERT INTO SCM_MGR.GT_DMF0003_SAVEPK_VALID_RESULTS
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
                     , SCM_MGR.GT_DMF0003_SAVEPK_RESULTS RSLT
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
                     , SCM_MGR.GT_DMF0003_SAVEPK_RESULTS RSLT
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
            DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0003_SAVEPK_VALID_RESULTS', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

            -- DM_PLN_MKT_FCST 테이블에서 당주월요일 이후 데이터가 존재하는지 체크 (start)
            DECLARE
                V_DUP_CNT PLS_INTEGER := 0;
            BEGIN
                SELECT COUNT(1)
                INTO   V_DUP_CNT
                FROM   SCM_MGR.DM_PLN_MKT_FCST
                WHERE  EXISTS (
                           SELECT 1
                           FROM   SCM_MGR.GT_DMF0003_SAVEPK_VALID_RESULTS RSLT
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
                        JOIN   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS      B
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
                        JOIN   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS       B
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
                           WHERE  SALES_PLAN_ADJUST_YN = 'N'
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
                           FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS
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
                           WHERE  SALES_PLAN_ADJUST_YN = 'N'
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
                           FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS
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
                           WHERE  SALES_PLAN_ADJUST_YN = 'N'
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
                           FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS
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
                           FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS
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
                           FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS
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
                               FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS RSLT
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
                                FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS
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
                    FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS A
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
                            and A.yyyymmdd       >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 이후 데이터를 대상으로 함
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
                FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS
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
    FROM   SCM_MGR.GT_DMF0003_SAVEPK_RESULTS;
    -- 트랜잭션 (COMMIT)
    COMMIT;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_INVALID THEN
        -- 트랜잭션 (END) - INVALID
        ROLLBACK;
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := V_INVALID_MSG;
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

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
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE;


PROCEDURE P_DMF0003_GET_MKT_FCST_DATA
    ( P_DIVISION_ID      IN  VARCHAR2
    , P_SCM_SITE_ID      IN  VARCHAR2
    , P_PLANT_SITE_ID    IN  VARCHAR2
    , P_TEAM_ID          IN  VARCHAR2
    , P_CUSTOMER         IN  VARCHAR2
    , P_BIZ_TYPE         IN  VARCHAR2
    , P_PROJECT_CODE     IN  VARCHAR2
    , P_ITEM_ID          IN  VARCHAR2
    , P_FROM_YYYYMMDD    IN  VARCHAR2
    , P_TO_YYYYMMDD      IN  VARCHAR2
    , P_CREATED_BY       IN  VARCHAR2
    , P_USER_GROUP       IN  VARCHAR2
    , P_ITEM_TYPE        IN  VARCHAR2
    , P_OWNER            IN  VARCHAR2
    , P_QTY_YN           IN  VARCHAR2
    , P_CELL_YN          IN  VARCHAR2
    , P_INVALID_EXEC     IN  VARCHAR2   -- [C20200612-000174] ESS사업부 New Model Flag
    , P_AS_YN            IN  VARCHAR2
    , P_USER_DEPT_ID     IN  VARCHAR2   -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
    , P_SENDER_CODE      IN  VARCHAR2   -- SENDER_CODE 추가
    , P_USER_ID          IN VARCHAR2
    , P_MENU_ID          IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RC2              OUT SYS_REFCURSOR   -- 8주 이내 bucket 정보
    , O_RC3              OUT SYS_REFCURSOR   -- 현재 주차 정보
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR

    )
/*=====================================================================================================================================================
 * Program ID  : DMF0003_GET_MKT_FCST_DATA
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date				In Charge    Description
 *=====================================================================================================================================================
 * 2017.11.24		SongDH		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.14		KHSONG		BALANCE MEASURE 신규추가로 MINUS값까지 보여주기위하여 QTY <> 0 로 수정
 * 2018.05.30		JYE			복수 팀 권한 관련  수정
 * 2018.07.12		KHSONG		속도개선 수정버젼임
 * 2018.07.27		SonYoungSuk 컬럼 정렬 정보
 * 2018.07.30		SonYoungSuk 검색조건 project(코드,네임 라이크 검색), model/item(코드,닉네임 라이크 검색)으로 수정
 * 2018.08.08		KHSONG		실적구간 중복되어 between 에서 수식으로 수정/p_from 변수사용
 * 2018.08.09		ytchoi		조건수정으로 속도개선
 * 2018.08.10		ytchoi		조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
 * 2018.08.09		JYE			멀티 오너 추가
 * 2018.08.13		JYE			Qty '0' 포함 추가
 * 2018.08.16		KHSONG		VALID_YN 조건추가
 * 2018.08.23		JYE			멀티 오너에 대한 수정 권한 수정. 신규 함수 적용.
 * 2018.09.04		JYE			멀티 오너에 대한 수정 권한 변경 수정 -- 주석처리.20180912
 * 2018.09.11		SonYoungSuk 조회 컬럼 CELL_TYPE 추가 #TEMP_DM_MST_ITEM_SINGLE_V.CELL_TYPE 사용 LookUp 테이블로 명칭 조회
 * 2018.09.28		JYE			RTF 수정 불가 처리
 * 2018.10.04		SonYoungSuk MEASURE VMI_IN_Req, VMI_IN_Plan Edit 가능
 * 2018.11.01		khsong		특정기간(20181101-20190531) 조회시 에러발생으로 BUCKET_PER null조건추가
 * 2018.11.02					속도개선을 의해서 추가
 * 2018.11.14		JYE			Cell Qty 환산 추가
 * 2018.11.15		JYE			소형 사업부 8주 이내는 일별로만 입력되도록
 * 2018.12.21		KHSONG		PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS 참조하여 주석처리함
 * 2019.01.18		KHSONG		중복제거위한 DISTINCT추가
 * 2019.01.21		KHSONG		MERGE 추가
 * 2019.01.23		KHSONG		전지재료DIV설정 (''42'',''44'') -> 20190624 모두 제거함
 * 2019.02.13		KHSONG		[CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건
 * 2019.02.14		JYE			정렬 쿼리에 디비전 조건 추가
 * ----------------------------------------------------------------------------------------
 * 20190219 KHSONG JOIN 조건 위로 올려서 속도개선한 버전
 * ----------------------------------------------------------------------------------------
 * 2019.02.19		KHSONG		숫자가 아닌 MEASURE는 FORECAST_INFO_CELL_PACK_COUNT로 곱하지 않도록 수정
 * 2019.03.08		KHSONG		[CSR ID:3940493] MKT FcstUI상 Shipping Plan Measure 추가 (SHIPMENT_PLAN)
 * 2019.03.22		KHSONG		고객군, 판매처 컬럼 NULL처리조건 추가
 * 2019.04.01		KHSONG		81,82인경우 PROJECT_CODE 를 출력하면 GROUP이 묶이지 않으므로 END_CUSTOMER 출력으로 변경함
 * 2019.04.19		KHSONG		[CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
 * 2019.06.24		KHSONG		[CSR_ID:4016234]자동차전지 사업부 RTF(Manual 입력) 메져 추가건 적용
 * 2019.07.04		KHSONG		ITEM_ID = ('MCCM346010A1,MCCM346010A1-D06') 이렇게 조회시 두배로 보이는 현상으로 재 GROUP
 * 2019.07.05		KHSONG		[CSR ID:4023158] Column / Measure 추가 Setting 요청건 (Column 3개 : Cell/Module , Cell/Car , Module/Car) (Measure 4개:MKT_FCST_RP_CAR,MKT_FCST_RP_CELL,RTF_RP_CAR,RTF_RP_CELL)
 * 2019.02.14		JYE			Warranty 용도 권한 추가
 * 2019.08.09		KHSONG		[CSR ID:4059971] VMI-In Request 로직 변경 -> ESS 사업부 별도추가 필요없음
 * 2019.10.02		KHSONG		조회시 DB Lock 현상으로 로직수정
 * 2019.10.29		KYH			Shipment_Plan 관련 MKT_FCST 의 기간조건 제거
 * 2019.11.18		KHSONG		[CSR ID:C20191031-000137] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건
 * 2019.11.19		KHSONG		Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
 * 2020.01.30		KHSONG		[C20200114-000201] ESS사업부 ENERGE, CELL_QUANTITY 컬럼/Measure추가
 * 2020.02.17		KHSONG		C20200103-000586 'SCM PI Admin' ADD
 * 2020.02.18		KHSONG		C20200212-000304 : GSCM 차량대수 환산 오류 개선 요청 건
 * 2020.02.25		KHSONG		C20200221-000056 Sales plan waterfall 차량대수 환산 logic 변경 요청 RTF MEASURE 삭제
 * 2020.03.09		KHSONG		C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가
 * 2020.03.11		KHSONG		C20200103-000586 권한그룹을 LOOKUP관리
 * 2020.06.05		P.C.I		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
 * 2020.06.18		P.C.I		[C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터
 * 2020.07.02		P.C.I		[C20200702-000136] Sales Price check시 currency 제외, new_flag 추가
 * 2020.07.16		HWI1993		[C20200713-000189] [VMI-in Req] VMI Biz의 경우 VMI-in Req 입력을 통한 MKT FCST 자동산출 로직 추가
 * 2020.07.23		P.C.I		[prepare] MKT_FCST_RP 실적 구간 변경(현재 기준 전주 일요일까지)
 * 2020.08.31		hwi1993		[C20200812-000104] [시스템 변경요청]  Active = ‘N’ 인 Model 도 조회되도록 변경
 * 2020.10.15		hwi1993		[C20201015-000200] VMi 원복 (원본은 C20200713-000189 ). 원복하기로 해서 프로시저는 삭제하지 않고, Agent 에서만 제거함.
 * 2020.11.13		hwi1993		개발에서 ssp sync 작업한 버전을 [DMF0003_GET_MKT_FCST_DATA_SSP_SYNC_작업분] 으로 백업하고, 운영에서 새로 내려받음
 * 2020.11.13		hwi1993		[C20201103-000114] [SCM PI팀] ESS 사업부 판매 법인 VMI biz의 MKT FCST 입력 시 VMI in req 자동산출 로직 적용의 건
 * 2020.11.27		hwi1993		[C20201103-000114]. Sales Price 기반으로 데이터 가져오는 부분에서는 VMI 메저 강제추가 제거함.
 * 2020.12.15		hwi1993		[C20201105-000099] 오류 데이터 삭제요청 -- ESS 의 경우 Future Price 를 참조할 때 FCST_TYPE = '' 인 것들 제외
 * 2020.12.28		HWI1993		[C20200804-000123] MKT FCST - SSP 동기화
 * 2021.01.14		HWI1993		[C20210112-000446] [SCM PI팀] 소형사업부 MKT FCST - SSP 동기화 ( ATP 메저 보완 )
 * 2021.02.26		P.C.I		[C20210225-000385] 동기화 기준은 ATTRIBUTE4, ATTRIBUTE5으로 구분
 * 2021.05.12		hwi1993		[PJ20209642R] Digital SCM Level.3 달성을 위한 개선 - ESS 상품 PR
 * 2021.05.17		HWI1993		[PJ20209642R] Digital SCM Level.3 달성을 위한 개선 - 중장기계획
 * 2021.06.18		HWI1993		[PJ20209642R] PR REQUEST 에 원재료 추가
 * 2021.08.10		hwi1993		[C20210810-000268] 메저 순서 변경 시 오류 발생
 * 2021.08.24		HWI1993		[과제]_BOD 유효기간 추가
 * 2021.09.01		SJHAN		[C20210827-000130] GSCM내 VMI inventory값 표시 변경 요청
 * 2021.09.15		SJHAN		[PJ20209643]-속도개선
 * 2021.09.17		hwi1993		[PJ20209643] AS 프로세스
 * 2021.11.02		hwi1993		[PJ20209643] AS 프로세스 - balance 메저 표시방법 변경, 룩업 컬럼 변경
 * 2021.11.17		hwi1993		[PJ20209643] 성능개선 - hash 옵션 추가 등
 * 2021.11.18		kdw2819		[과제]_자동차 사업부 JV Planner 의 조회 권한 추가
 * 2021.11.19		ROSIA27		[C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
 * 2021.11.30		rosia27		[C20211122-000414]
속도개선을 위한 색구현 및 조회조건 변경안
 * 2021.12.07		rosia27		[C20211130-000420][ESS영업관리팀] RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
 * 2021.12.15		kdw2819		[C20211215-000076] 1년 이상 조회기간을 설정하여도 가능하도록 변경 건
 * 2022.01.06		hwi1993		[] sales_type_code 룩업의 as 전용 fcst type 을 사용할수 없게 되어서, as 구분방법 변경
								( 고객향은 attribute10, 플랜트향은 scm_site_id 이용 )
 * 2022.02.07		kdw2819		[C20220125-000192] MKT FSCT 상 From stie 표기 요청의 건
 * 2022.02.24		HWI1993		[C20220218-000409] GSCM-DM AS Inventory 메저 계산 로직 수정 -- INV 메저 표시방법 변경, INTRANSIT 메저의 ATTR10 오류 수정
 * 2022.04.05		rosia27		[과제PJ20216891R]GM_JV
 * 2022.12.14		rosia27		[C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
 * 2023.03.13		rosia27		[E20230308-000315] [시스템 오류] Owner 조회조건 수정 요청 건
 * 2023.05.03		kdmcc14		[EDI과제]
 * 2023.08.25		JSSBAE		[E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청(LOOKUP이용)
 * 2023.10.19		JSSBAE		[E20231018-000776]_[영업/마케팅 PI팀] MKT FCST 화면 SHIPMENT_PLAN 메저 로직 수정 프로그램 화면 내 메져의 VALID가 Y인 대상만 나오도록 수정
 * 2023.11.21		chano0612	[고객수요분석시스템 정비] EDI데이터 중복건 제거
 * 2023.12.07		kcw3408		[개발요청] 수요분석시스템_4_고객수요 Measure 통합
 * 2024.01.15		JSSBAE		[E20240102-000545] [마케팅PI] 82번 사업부 - VMI표기 로직 개선
 * 2024.03.07       kcw3408     DM 프로시저 속도개선(CNS 전정관 책임님이 지원)
 * 2024.05.17       kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
 * 2024.07.18		JSSBAE		[E20240712-001683]_'MKT FCST 미등록제외' 관련 소스 수정
 * 2024.08.02		JSSBAE		[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선
 * 2024.09.05		JSSBAE		[E20240812-000094]_82사업부 MKT FCST 화면 Energy Measure 소수점 자리수 수정 요청
 * 2024.08.27		KJJ			[PJ2024-50461] Team Mapping
 * 2024.09.12		JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024.11.04		JSSBAE		[E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건
 *                              SSPM에 신규 추가 요청드린 'Project(S&OP Report)' 컬럼 MKT FCST Waterfall 사용자 화면에 추가 요청
 * 2024.11.12		JSSBAE		[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건
 * 2024.12.04		JSSBAE		[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정
 * 2025.07.07		KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.01.23		JSSBAE		[E20260123-001715]_E20241015-000415 CSR 원복 요청
 * 2026.02.20		JSSBAE		[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
 * 2026.04.13       kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                                  SCM_MST_SITE_ITEM Table PROJECT_S_OP_REPORT Column 삭제에 따라 컬럼 사용 문장 삭제
 *                                  ORA-01799: a column may not be outer-joined to a subquery 방지용으로 불필요한 outer join 제거
 EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='40', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
 EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='81', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
 EXEC DMF0003_GET_MKT_FCST_DATA @p_division_id='82', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_team_id='ALL', @p_customer='ALL'
	, @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20211101', @p_to_yyyymmdd='20220531', @p_created_by='rosia27'
	, @p_user_group='ADMIN', @p_item_type='ALL', @p_owner='', @p_qty_yn='N', @p_cell_yn='N', @p_invalid_exec='N', @p_as_yn='N', @p_user_dept_id='58235660',@p_sender_code='ALL'
 *===================================================================================================================================================*/
-- 2026-05-11 전병주 컴파일 오류 수정
AS
    -- 프로그램명 (로그용)
    V_PROGRAM_NAME      VARCHAR2(150);

    -- 동적 SQL / PIVOT 관련
    V_SQL_TEXT          CLOB;
    V_PV_LIST           CLOB    := '';
    V_PV_COL_LIST       CLOB    := '';
    V_PV_COLUMN_NAME    VARCHAR2(1000);
    V_PV_NAME           VARCHAR2(200);
    V_SORT_ORDER_NO     VARCHAR2(50);
    V_COLUMN_NAME       VARCHAR2(100);
    V_COLUMN            CLOB    := '';
    V_GROUPBY           CLOB    := '';
    V_ORDERBY           CLOB    := '';

    -- 프로그램 / 시트 고정값
    VA_PROGRAM_ID       VARCHAR2(50)  := 'DMF0003';
    VA_SHEET_NAME       VARCHAR2(50)  := 'Mkt Fcst';

    -- 권한 / 부서
    V_GROUP_ID          VARCHAR2(50)  := '';
    V_DEPT_ID           VARCHAR2(50)  := '';

    -- 조회 구간 날짜 변수
    V_EXP_YYYYMMDD      VARCHAR2(8);
    V_FROM_YYYYMMDD     VARCHAR2(8)   := '';   -- 계획 구간 FROM (당주 월요일 기준)
    V_TO_YYYYMMDD       VARCHAR2(8)   := '';   -- 계획 구간 TO
    V_FROM_RESULT       VARCHAR2(8)   := '';   -- 실적 구간 FROM
    V_TO_RESULT         VARCHAR2(8)   := '';   -- 실적 구간 TO
    V_USER_TIME_ZONE    VARCHAR2(50)  := '';

    -- 사용자 컬럼/메저 카운트
    V_USER_COL_CNT      PLS_INTEGER   := 0;
    V_USER_MEA_CNT      PLS_INTEGER   := 0;

    -- IN 파라미터를 로컬 복사본으로 사용 (IN 파라미터 직접 수정 불가)
    LP_AS_YN            VARCHAR2(1);
    LP_SCM_SITE_ID      VARCHAR2(4000);
    LP_PROJECT_CODE     VARCHAR2(4000);

    -- 팀 WHERE 조건 (동적 SQL에 삽입)
    V_TEAM_WHERE        VARCHAR2(4000);

    -- 예외처리 / 로그 변수
    V_LOG_TYPE          VARCHAR2(30);
    V_LOG_MESSAGE       VARCHAR2(1000);
    V_DESCRIPTION       VARCHAR2(500);
    D_EVENT_DATE        DATE;
    V_SQL_CODE          VARCHAR2(20);
    V_SQL_ERRMSG        VARCHAR2(4000);
    V_BACKTRACE         VARCHAR2(4000);
    V_PROC_INPUT        CLOB;

    -- T_SSP_SYNC 컬렉션용
    T_SCM_SITE_IDS      SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();

BEGIN
    -----------------------------------------------------------------------
    -- 프로그램명 설정
    -----------------------------------------------------------------------
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- IN 파라미터 로컬 복사
    LP_AS_YN        := P_AS_YN;
    LP_SCM_SITE_ID  := P_SCM_SITE_ID;
    LP_PROJECT_CODE := P_PROJECT_CODE;

    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    -----------------------------------------------------------------------
    -- GTT 초기화 (세션 재사용 시 이전 데이터 제거)
    -----------------------------------------------------------------------
    DELETE FROM SCM_MGR.GT_DMF0003_T_SSP_SYNC;
    DELETE FROM SCM_MGR.GT_DMF0003_T_BNP;
    DELETE FROM SCM_MGR.GT_DMF0003_ITEM_SINGLE_ORI;
    DELETE FROM SCM_MGR.GT_DMF0003_ITEM_SINGLE_A;
    DELETE FROM SCM_MGR.GT_DMF0003_ITEM_SINGLE_B;
    DELETE FROM SCM_MGR.GT_DMF0003_ITEM_SINGLE_V;
    DELETE FROM SCM_MGR.GT_DMF0003_SELECT_MEASURE;
    DELETE FROM SCM_MGR.GT_DMF0003_VMI_DIO;
    DELETE FROM SCM_MGR.GT_DMF0003_SITE_ITEM_ALL;
    DELETE FROM SCM_MGR.GT_DMF0003_SITE_ITEM;
    DELETE FROM SCM_MGR.GT_DMF0003_MKT_FCST_DATA;
    DELETE FROM SCM_MGR.GT_DMF0003_MKT_FCST_DST;
    DELETE FROM SCM_MGR.GT_DMF0003_SALES_PRICE;
    DELETE FROM SCM_MGR.GT_DMF0003_EDI_SENDER;
    DELETE FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP;
    DELETE FROM SCM_MGR.GT_DMF0003_EDI_END_CUST;
    DELETE FROM SCM_MGR.GT_DMF0003_RPA_END_CUST;
    DELETE FROM SCM_MGR.GT_DMF0003_MKT_FCST_RESULT;
    DELETE FROM SCM_MGR.GT_DMF0003_MF;
    DELETE FROM SCM_MGR.GT_DMF0003_CAL_MONTH_END;
    DELETE FROM SCM_MGR.GT_DMF0003_CAL_WEEK_END;
    DELETE FROM SCM_MGR.GT_DMF0003_SHIPMENT_PLAN;
    DELETE FROM SCM_MGR.GT_DMF0003_INTRANSIT_DATA;
    DELETE FROM SCM_MGR.GT_DMF0003_VMI_INV;
    DELETE FROM SCM_MGR.GT_DMF0003_VMI_INV_RESULT;
    -- ============================================================
    -- ⭐ Phase 3 (2026-06-16): GT_DMF0003_SPLIT_* 사전 적재 (룰 2+6)
    --   SP body 시작 시점 (GT cleanup 직후) 에 11 SPLIT GT INSERT.
    --   룰 6: 'ALL' / '%' / '' / NULL 시 INSERT skip → 후속 SELECT EXISTS short-circuit.
    --   매개변수 인벤토리 (DMF0003 11개):
    --     P_ITEM_ID, P_PROJECT_CODE (=LP_PROJECT_CODE), P_SCM_SITE_ID (=LP_SCM_SITE_ID),
    --     P_PLANT_SITE_ID, P_TEAM_ID, P_CUSTOMER, P_BIZ_TYPE, P_ITEM_TYPE,
    --     P_OWNER, P_SENDER_CODE
    -- ============================================================

    -- 기존 SPLIT GT 잔존 row cleanup (멱등)
    DELETE FROM SCM_MGR.GT_DMF0003_SPLIT_ITEM_ID;
    DELETE FROM SCM_MGR.GT_DMF0003_SPLIT_PROJECT_CODE;
    DELETE FROM SCM_MGR.GT_DMF0003_SPLIT_SCM_SITE_ID;
    DELETE FROM SCM_MGR.GT_DMF0003_SPLIT_PLANT_SITE_ID;
    DELETE FROM SCM_MGR.GT_DMF0003_SPLIT_TEAM_ID;
    DELETE FROM SCM_MGR.GT_DMF0003_SPLIT_CUSTOMER;
    DELETE FROM SCM_MGR.GT_DMF0003_SPLIT_BIZ_TYPE;
    DELETE FROM SCM_MGR.GT_DMF0003_SPLIT_ITEM_TYPE;
    DELETE FROM SCM_MGR.GT_DMF0003_SPLIT_OWNER;
    DELETE FROM SCM_MGR.GT_DMF0003_SPLIT_SENDER_CODE;
    DELETE FROM SCM_MGR.GT_DMF0003_OWNER_TOKEN;

    -- P_ITEM_ID
    INSERT INTO SCM_MGR.GT_DMF0003_SPLIT_ITEM_ID (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_ITEM_ID IS NOT NULL AND P_ITEM_ID NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL;

    -- LP_PROJECT_CODE (P_PROJECT_CODE 의 사본)
    INSERT INTO SCM_MGR.GT_DMF0003_SPLIT_PROJECT_CODE (TOK)
    SELECT TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  LP_PROJECT_CODE IS NOT NULL AND LP_PROJECT_CODE NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL;

    -- LP_SCM_SITE_ID (P_SCM_SITE_ID 의 사본)
    INSERT INTO SCM_MGR.GT_DMF0003_SPLIT_SCM_SITE_ID (TOK)
    SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  LP_SCM_SITE_ID IS NOT NULL AND LP_SCM_SITE_ID NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_PLANT_SITE_ID
    INSERT INTO SCM_MGR.GT_DMF0003_SPLIT_PLANT_SITE_ID (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_PLANT_SITE_ID IS NOT NULL AND P_PLANT_SITE_ID NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_TEAM_ID
    INSERT INTO SCM_MGR.GT_DMF0003_SPLIT_TEAM_ID (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_TEAM_ID,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_TEAM_ID IS NOT NULL AND P_TEAM_ID NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_TEAM_ID,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_CUSTOMER
    INSERT INTO SCM_MGR.GT_DMF0003_SPLIT_CUSTOMER (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_CUSTOMER IS NOT NULL AND P_CUSTOMER NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_BIZ_TYPE
    INSERT INTO SCM_MGR.GT_DMF0003_SPLIT_BIZ_TYPE (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_BIZ_TYPE IS NOT NULL AND P_BIZ_TYPE NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_ITEM_TYPE
    INSERT INTO SCM_MGR.GT_DMF0003_SPLIT_ITEM_TYPE (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_ITEM_TYPE IS NOT NULL AND P_ITEM_TYPE NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_OWNER
    INSERT INTO SCM_MGR.GT_DMF0003_SPLIT_OWNER (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_OWNER IS NOT NULL AND P_OWNER NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL) IS NOT NULL;

    -- P_SENDER_CODE
    INSERT INTO SCM_MGR.GT_DMF0003_SPLIT_SENDER_CODE (TOK)
    SELECT TRIM(REGEXP_SUBSTR(P_SENDER_CODE,'[^,]+',1,LEVEL))
    FROM   DUAL
    WHERE  P_SENDER_CODE IS NOT NULL AND P_SENDER_CODE NOT IN ('ALL','%','')
    CONNECT BY REGEXP_SUBSTR(P_SENDER_CODE,'[^,]+',1,LEVEL) IS NOT NULL;

    -----------------------------------------------------------------------
    -- 권한그룹 LOOKUP 관리 [20200311 KHSONG C20200103-000586]
    -----------------------------------------------------------------------
    DECLARE
        V_ADMIN_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT NVL(COUNT(1),0) INTO V_ADMIN_CNT
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
          AND  VALID_YN    = 'Y'
          AND  SEGMENT2   IN ('ALL','DMF0003')
          AND  SEGMENT1    = P_USER_GROUP;
        IF V_ADMIN_CNT > 0 THEN
            V_GROUP_ID := 'ADMIN';
        END IF;
    END;

    -----------------------------------------------------------------------
    -- 조회 만료 기준 계산 (from + 40주)
    -- SM임시작업 20240621 화면 장애 오류로 인하여 임시조치
    -----------------------------------------------------------------------
    V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD') + 40*7, 'YYYYMMDD');

    -----------------------------------------------------------------------
    -- 버킷 컬럼 목록 동적 생성 (일별 D_, 주별 W_, 월별 M_)
    -- CURSOR FAST_FORWARD → FOR LOOP
    -----------------------------------------------------------------------
    FOR R IN (
        SELECT 'D_' || A.BASIS_YYYYMMDD || ' AS D_' || A.BASIS_YYYYMMDD     AS COLUMN_NAME
             , '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD AS PV_NAME
             , A.BASIS_YYYYMMDD || '_31'                                    AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
          AND  A.BASIS_YYYYMMDD <= V_EXP_YYYYMMDD
        UNION ALL
        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK
             , '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ''' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK
             , A.BASIS_START_DATE || '_21'
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
          AND  A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
        UNION ALL
        SELECT 'M_' || A.BASIS_YYYYMM || ' AS M_' || A.BASIS_YYYYMM
             , '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM
             , MIN(A.BASIS_START_DATE) || '_01'
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
          AND  A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        GROUP BY A.BASIS_YYYYMM
        ORDER BY 3 -- SORT_ORDER_NO -- 컴파일 오류로 번호로 변경
    )
    LOOP
        IF V_PV_COL_LIST IS NULL OR V_PV_COL_LIST = '' THEN
            V_PV_COL_LIST := R.COLUMN_NAME;
            V_PV_LIST     := R.PV_NAME;
        ELSE
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || R.COLUMN_NAME;
            V_PV_LIST     := V_PV_LIST     || ',' || R.PV_NAME;
        END IF;
    END LOOP;

    -----------------------------------------------------------------------
    -- 사용자 컬럼 초기화 처리
    -----------------------------------------------------------------------
    V_COLUMN_NAME  := '';
    V_COLUMN       := '';
    V_GROUPBY      := '';
    V_USER_COL_CNT := 0;
    V_USER_MEA_CNT := 0;

    -- 사용자 컬럼 존재 여부 확인
    SELECT COUNT(1) INTO V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  U.PROGRAM_ID                    = VA_PROGRAM_ID
      AND  U.SHEET_NAME                    = VA_SHEET_NAME
      AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
      AND  U.USER_ID                       = P_CREATED_BY;

    IF V_USER_COL_CNT = 0 THEN
        -- 사용자 컬럼이 없으면 기본값으로 복사
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'C'
             , C.COLUMN_NAME, C.SORT_ORDER_NO, 'N', ''
             , P_CREATED_BY, SYSDATE
             , P_CREATED_BY, SYSDATE
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
          AND  C.SHEET_NAME   = VA_SHEET_NAME
          AND  C.DEFAULT_FLAG = 'Y'
          AND  C.VALID_YN     = 'Y';

          COMMIT WORK;
    END IF;

    -- 사용자 메저 존재 여부 확인
    SELECT COUNT(1) INTO V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  U.PROGRAM_ID                    = VA_PROGRAM_ID
      AND  U.SHEET_NAME                    = VA_SHEET_NAME
      AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
      AND  U.USER_ID                       = P_CREATED_BY;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'M'
             , C.COLUMN_NAME, C.SORT_ORDER_NO, 'N', ''
             , P_CREATED_BY, SYSDATE
             , P_CREATED_BY, SYSDATE
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
          AND  C.SHEET_NAME   = VA_SHEET_NAME
          AND  C.DEFAULT_FLAG = 'Y'
          AND  C.VALID_YN     = 'Y';

          COMMIT WORK;
    END IF;

    -----------------------------------------------------------------------
    -- 컬럼/정렬 문자열 동적 조립
    -- CURSOR FAST_FORWARD c_title → FOR LOOP
    -----------------------------------------------------------------------
    FOR R IN (
        SELECT U.COLUMN_NAME
             , U.SORT_ORDER_NO
        FROM  ( SELECT U.COLUMN_NAME
                     , CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
                            WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
                            ELSE TO_CHAR(U.SORT_ORDER_NO) END AS SORT_ORDER_NO
                FROM   SCM_MGR.SCM_MST_TITLESET_USER U
                     , SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  U.PROGRAM_ID  = C.PROGRAM_ID
                  AND  U.SHEET_NAME  = C.SHEET_NAME
                  AND  U.COLUMN_NAME = C.COLUMN_NAME
                  AND  U.PROGRAM_ID  = VA_PROGRAM_ID
                  AND  U.SHEET_NAME  = VA_SHEET_NAME
                  AND  U.USER_ID     = P_CREATED_BY
                  AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                UNION ALL
                -- 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID 추가
                SELECT C.COLUMN_NAME
                     , CASE WHEN C.COLUMN_NAME = 'GROUP_ID'
                            THEN TO_CHAR(NVL(U.SORT_ORDER_NO,85) - 0.5)
                            ELSE TO_CHAR(C.SORT_ORDER_NO) END AS SORT_ORDER_NO
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                LEFT   OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
                  ON   U.PROGRAM_ID  = C.PROGRAM_ID
                 AND   U.SHEET_NAME  = C.SHEET_NAME
                 AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                 AND   U.COLUMN_NAME IN ('ITEM_ID')
                 AND   U.USER_ID     = P_CREATED_BY
                WHERE  C.PROGRAM_ID   = VA_PROGRAM_ID
                  AND  C.SHEET_NAME   = VA_SHEET_NAME
                  AND  ( C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' '  OR C.DEFAULT_FLAG = '' )
                  AND  C.VALID_YN     = 'Y' ) U
        ORDER BY TO_NUMBER(U.SORT_ORDER_NO)
    )
    LOOP
        IF V_COLUMN IS NULL OR V_COLUMN = '' THEN
            V_COLUMN  := R.COLUMN_NAME;
            V_GROUPBY := ' GROUP BY ' || R.COLUMN_NAME;
            V_ORDERBY := ' ORDER BY SORT_KEY, '
                      || CASE WHEN R.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG')
                               THEN R.COLUMN_NAME ELSE '' END;
        ELSE
            V_COLUMN  := V_COLUMN  || ', ' || R.COLUMN_NAME;
            V_GROUPBY := V_GROUPBY || ', ' || R.COLUMN_NAME;
            V_ORDERBY := V_ORDERBY
                      || CASE WHEN R.COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG')
                               THEN ', ' || R.COLUMN_NAME ELSE '' END;
        END IF;
    END LOOP;

    -- [E20240812-000094] NOTATION 컬럼 추가
    V_COLUMN  := V_COLUMN  || ',NOTATION';
    V_GROUPBY := V_GROUPBY || ', EDIT_FLAG, SORT_ORDER_NO';
    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');

    -----------------------------------------------------------------------
    -- 사용자 시차(TIMEZONE) 조회
    -----------------------------------------------------------------------
    BEGIN
        SELECT U.TMZ_CD INTO V_USER_TIME_ZONE
        FROM   SCM_MGR.SCM_ADM_USER_M U
        WHERE  U.USER_ID = P_CREATED_BY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_USER_TIME_ZONE := '';
    END;

    -----------------------------------------------------------------------
    -- 계획/실적 기준 날짜 계산
    -----------------------------------------------------------------------
    -- @v_from_yyyymmdd : (User 시차 고려) 당주 월요일
    BEGIN
        SELECT MIN(C.BASIS_YYYYMMDD) INTO V_FROM_YYYYMMDD
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
             , ( SELECT DISTINCT ISO_YYYYWW
                 FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                 WHERE  BASIS_YYYYMMDD =
                        TO_CHAR(SCM_MGR.FN_MULTY_TIME(V_USER_TIME_ZONE),'YYYYMMDD')
               ) T
        WHERE  C.ISO_YYYYWW = T.ISO_YYYYWW;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_YYYYMMDD := TO_CHAR(SYSDATE,'YYYYMMDD');
    END;

    -- From 실적 : From 조회 구간 월요일
    BEGIN
        SELECT C.BASIS_START_DATE INTO V_FROM_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_RESULT := '';
    END;

    -- To 실적 : To 조회 구간 월요일 전까지
    BEGIN
        SELECT C.BASIS_START_DATE INTO V_TO_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = P_TO_YYYYMMDD;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_TO_RESULT := '';
    END;

    IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN
        -- 실적 보여줌
        V_TO_YYYYMMDD := P_TO_YYYYMMDD;
        V_TO_RESULT   := V_FROM_YYYYMMDD;  -- To 실적 : 당주 월요일 전까지
    ELSIF V_FROM_YYYYMMDD <= V_FROM_RESULT THEN
        -- 실적 없음
        V_TO_YYYYMMDD := P_TO_YYYYMMDD;
        V_FROM_RESULT := '19000101';
        V_TO_RESULT   := '19000101';
    ELSIF V_FROM_YYYYMMDD > V_TO_RESULT THEN
        -- 실적만 보여줌
        V_FROM_YYYYMMDD := '19000101';
        V_TO_YYYYMMDD   := '19000101';
        V_FROM_RESULT   := P_FROM_YYYYMMDD;
        V_TO_RESULT     := P_TO_YYYYMMDD;
    ELSIF V_FROM_YYYYMMDD = V_TO_RESULT THEN
        -- 실적 없음
        V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
        V_FROM_RESULT := P_FROM_YYYYMMDD;
        V_TO_RESULT   := P_TO_YYYYMMDD;
    END IF;

    -----------------------------------------------------------------------
    -- [E20260211-001189] 조회 SALES SITE 중 AS용 데이터가 있으면 AS_YN = 'Y'로 처리
    -- TABLE()은 컬렉션 변수만 허용 → 먼저 변수에 COLLECT 후 참조
    -----------------------------------------------------------------------
    DECLARE
        V_AS_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT CAST(
                   COLLECT(DISTINCT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)))
               AS SCM_MGR.T_STR_TAB)
        INTO   T_SCM_SITE_IDS
        FROM   DUAL
        CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL;

        SELECT COUNT(DISTINCT A.COLUMN_VALUE) INTO V_AS_CNT
        FROM   TABLE(T_SCM_SITE_IDS) A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON   A.COLUMN_VALUE = B.SEGMENT1
         AND   B.LOOKUP_TYPE  = 'AS_SITE_PLANT';

        IF V_AS_CNT > 0 THEN
            LP_AS_YN := 'Y';
        END IF;
    END;
    -- [E20260211-001189] END

    -----------------------------------------------------------------------
    -- [C20200804-000123] SSP 동기화 / BNP 데이터 수집
    -----------------------------------------------------------------------
    -- Division 40: DM_PLN_MKT_FCST 기반 PIVOT → GT_DMF0003_T_SSP_SYNC
    IF P_DIVISION_ID = '40' THEN
        INSERT INTO SCM_MGR.GT_DMF0003_T_SSP_SYNC
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1 )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
            || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
            || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
            || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
            || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
            || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
            || '^' || NVL(A31,'') AS ATTR1
        FROM (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, A.FCST_TYPE, INCOTERMS
                 , YYYYMMDD || '/'
                   || CASE
                          WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                           AND A.QTY >
                               CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                                    THEN TO_NUMBER(ATTRIBUTE3) ELSE 0 END
                             + CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE2,'0'),'^[0-9.]+$')
                                    THEN TO_NUMBER(ATTRIBUTE2) ELSE 0 END
                          THEN 'P'
                          ELSE 'A'
                      END AS SYNC_YN
                 , 'A' || TO_CHAR(
                       ROW_NUMBER() OVER (
                           PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                        DOM_EXP, A.FCST_TYPE, INCOTERMS
                           ORDER BY YYYYMMDD
                       )) AS ROW_NUM
            FROM   SCM_MGR.DM_PLN_MKT_FCST A
            -- [E20260211-001189] #T_WS_FCST JOIN 주석처리된 원본 그대로 반영
            WHERE  A.DIVISION_ID = P_DIVISION_ID
              AND  A.MEASURE     = 'MKT_FCST'
              AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
              AND  ( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL OR NVL(A.ATTRIBUTE4,'') <> '' OR NVL(A.ATTRIBUTE5,'') <> '')  -- [C20210225-000385]
              AND  A.QTY <> 0
              AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID
                          ELSE A.SCM_SITE_ID END
                     IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
                         FROM DUAL
                         CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
              AND  ( LP_PROJECT_CODE IS NULL
                     OR CASE WHEN LP_PROJECT_CODE = '' THEN LP_PROJECT_CODE
                          ELSE A.PROJECT_CODE END
                     IN (SELECT TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL))
                         FROM DUAL
                         CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL) )
              AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID
                          ELSE A.PLANT_SITE_ID END
                     IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL))
                         FROM DUAL
                         CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
        ) A
        PIVOT (
            MAX(SYNC_YN) FOR ROW_NUM IN (
                'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                'A31' A31
            )
        );

    -- Division 82: DM_PLN_PR_DETAIL 기반 PIVOT → GT_DMF0003_T_BNP [PJ20209642R]
    ELSIF P_DIVISION_ID = '82' THEN
        INSERT INTO SCM_MGR.GT_DMF0003_T_BNP
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1 )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
            || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
            || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
            || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
            || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
            || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
            || '^' || NVL(A31,'') AS ATTR1
        FROM (
            SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                            DOM_EXP, FCST_TYPE, INCOTERMS
                 , YYYYMMDD || '/A' AS SYNC_YN
                 , 'A' || TO_CHAR(
                       ROW_NUMBER() OVER (
                           PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                        DOM_EXP, FCST_TYPE, INCOTERMS
                           ORDER BY YYYYMMDD
                       )) AS ROW_NUM
            FROM   SCM_MGR.DM_PLN_PR_DETAIL A
            WHERE  A.DIVISION_ID = P_DIVISION_ID
              AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        ) A
        PIVOT (
            MAX(SYNC_YN) FOR ROW_NUM IN (
                'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                'A31' A31
            )
        );
    END IF;
    -- [C20200804-000123] 끝

    -----------------------------------------------------------------------
    -- [E20240920-000300] ITEM_SINGLE_V 속도 개선 - 3단계로 나눠서 INSERT
    -----------------------------------------------------------------------
    -- Step 1: SCM_MST_ITEM_SN 전체를 GT_DMF0003_ITEM_SINGLE_ORI에 적재
    INSERT INTO SCM_MGR.GT_DMF0003_ITEM_SINGLE_ORI
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
    , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
         , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
         , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
         , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
    FROM   SCM_MGR.SCM_MST_ITEM_SN
    WHERE  DIVISION_ID = P_DIVISION_ID
      AND  ACTIVE_FLAG = 'Y';

    -- Step 2A: 기본 컬럼 GROUP BY → GT_DMF0003_ITEM_SINGLE_A
    INSERT INTO SCM_MGR.GT_DMF0003_ITEM_SINGLE_A
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
    , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME)
         , MAX(T1.ITEM_CLASS)
         , MAX(T1.ITEM_CLASS_NAME)
         , MAX(T1.NICK_NAME)
         , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                         WHEN T1.ITEM_TYPE = 'H' THEN 2
                         WHEN T1.ITEM_TYPE = 'Q' THEN 3
                         ELSE 4 END)
               WHEN 1 THEN 'P' WHEN 2 THEN 'H' WHEN 3 THEN 'Q' ELSE 'R' END
         , MAX(T1.MATERIAL_CLASS_NAME)
         , MAX(T1.ITEM_UOM)
         , MAX(T1.SPEC)
         , MAX(T1.MDM_PROJECT_NAME)
         , MAX(T1.MIN_CAPACITY)
         , MAX(T1.ACTIVE_FLAG)
         , MAX(T1.ENERGE)
         , MAX(T1.CELL_QUANTITY)
         , MAX(T1.SCP_EXTRA_SPEC)
    FROM   SCM_MGR.GT_DMF0003_ITEM_SINGLE_ORI T1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

    -- Step 2B: FORECAST_INFO 계열 LEFT(12) 기준 집계 → GT_DMF0003_ITEM_SINGLE_B
    INSERT INTO SCM_MGR.GT_DMF0003_ITEM_SINGLE_B
    ( DIVISION_ID, ITEM_ID
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE)
         , MAX(FORECAST_INFO_PRODUCT_GROUP)
         , MAX(FORECAST_INFO_CELL_MODEL)
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)
         , MAX(FORECAST_INFO_SPEC)
         , MAX(FORECAST_INFOR_VERSION)
         , MAX(CELL_TYPE)
    FROM   SCM_MGR.GT_DMF0003_ITEM_SINGLE_ORI
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

    -- Step 3: A+B JOIN 후 ITEM_ID/NICK_NAME LIKE 필터 적용 → GT_DMF0003_ITEM_SINGLE_V
    INSERT INTO SCM_MGR.GT_DMF0003_ITEM_SINGLE_V
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
    , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT T1.DIVISION_ID, T1.ITEM_ID
         , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
         , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
         , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
         , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
         , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
    FROM   SCM_MGR.GT_DMF0003_ITEM_SINGLE_A T1
    JOIN   SCM_MGR.GT_DMF0003_ITEM_SINGLE_B T2
      ON   T1.DIVISION_ID          = T2.DIVISION_ID
     AND   SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
    WHERE  T1.DIVISION_ID = P_DIVISION_ID
      -- ⭐ Phase 4 (룰 6 적용): 'ALL'/'%'/'' 시 short-circuit, GT_DMF0003_SPLIT_ITEM_ID 사용
      AND  ( P_ITEM_ID IS NULL OR P_ITEM_ID IN ('ALL','%','')
             OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0003_SPLIT_ITEM_ID B
                         WHERE T1.ITEM_ID   LIKE '%' || B.TOK || '%'
                            OR T1.NICK_NAME LIKE '%' || B.TOK || '%') )
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID
           , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
           , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
           , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
           , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
           , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC;

    -- [E20240731-000856] Wh → KWh 환산
    UPDATE SCM_MGR.GT_DMF0003_ITEM_SINGLE_V
    SET    ENERGE = CASE WHEN REGEXP_LIKE(NVL(ENERGE,'X'),'^[0-9.]+$')
                         THEN TO_CHAR(ROUND(TO_NUMBER(ENERGE)/1000, 4))
                         ELSE NULL END;

    -----------------------------------------------------------------------
    -- GT_DMF0003_SELECT_MEASURE 수집
    -- [C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터 제공
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0003_SELECT_MEASURE
    ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO )
    SELECT DISTINCT U.PROGRAM_ID
                  , U.SHEET_NAME
                  , U.USER_ID
                  , CASE WHEN U.COLUMN_NAME IN ('CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO')
                         THEN 'CUST. PSI'
                         WHEN U.COLUMN_NAME IN ('MKT_INV_I','MKT_PRODUCT_S','MKT_WHIN_P','MKT_DIO')
                         THEN 'MKT PSI'
                         ELSE U.COLUMN_NAME END AS MEASURE_GROUP
                  , U.COLUMN_NAME AS MEASURE
                  , CASE WHEN U.COLUMN_NAME IN ('CUST_FCST','CUST_FCST_EDI','CUST_FCST_ORG','CUST_FCST_EDI_ORG')
                         THEN SMSM.SORT_ORDER_NO   -- 20231212 kcw3408 4_고객수요 Measure 통합
                         ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
      ON   U.PROGRAM_ID  = SMSM.PROGRAM_ID
     AND   U.SHEET_NAME  = SMSM.SHEET_NAME
     AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
     AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
     AND   SMSM.VALID_YN = 'Y'
    LEFT   JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
      ON   U.USER_ID    = T.SEGMENT4     -- 20200309 KHSONG TMM MEASURE 권한추가
     AND   P_CREATED_BY = T.SEGMENT4
     AND   T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
     AND   T.VALID_YN    = 'Y'
    WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
      AND  U.PROGRAM_ID = 'DMF0003'
      AND  U.SHEET_NAME = 'Mkt Fcst'
      AND  U.USER_ID    = P_CREATED_BY
      AND  U.USER_ID    = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4
                               ELSE P_CREATED_BY END
    -----------------------------------------------------------------------
    -- [20191118 KHSONG CSR ID:C20191031-000137] CUST_FCST_EDI 계열 sub-measure 추가
    -----------------------------------------------------------------------
    UNION ALL
    SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
         , A.SORT_ORDER_NO + B.SORT_ORDER_NO
    FROM (
        SELECT U.PROGRAM_ID, U.SHEET_NAME, U.USER_ID
             -- [E20241126-000426] CUST_FCST_EDI → CUST_FCST 로 변경
             , 'CUST_FCST' AS MEASURE_GROUP
             , SMSM.SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
        JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
          ON   U.PROGRAM_ID  = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
         AND   U.COLUMN_NAME = SMSM.COLUMN_NAME AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
         AND   SMSM.VALID_YN = 'Y'
        WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
          AND  U.PROGRAM_ID  = 'DMF0003'
          AND  U.SHEET_NAME  = 'Mkt Fcst'
          AND  U.USER_ID     = P_CREATED_BY
          -- [E20241126-000426] CUST_FCST_EDI → CUST_FCST 로 변경
          AND  U.COLUMN_NAME = 'CUST_FCST'
    ) A,
    (
        -- [E20241126-000426] CUST_FCST_EDI 추가 및 순서 변경
        SELECT 'Immidiate'                   AS MEASURE, 0.15 AS SORT_ORDER_NO FROM DUAL UNION ALL
        SELECT 'Planning_Forecast'                      , 0.18 FROM DUAL UNION ALL
        SELECT 'Commercial_Agreement'                   , 0.13 FROM DUAL UNION ALL
        SELECT 'Firm_Temp'                              , 0.14 FROM DUAL UNION ALL
        SELECT 'Manumacturing_Material_Temp'            , 0.16 FROM DUAL UNION ALL
        SELECT 'Material_Temp'                          , 0.17 FROM DUAL UNION ALL
        SELECT 'Backorder'                              , 0.12 FROM DUAL UNION ALL
        SELECT 'CUST_FCST_EDI'                          , 0.11 FROM DUAL
    ) B
    GROUP BY A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
           , A.SORT_ORDER_NO + B.SORT_ORDER_NO
    -----------------------------------------------------------------------
    -- CUST_FCST_2 : DM_MST_CUSTOMER_FCST 기반 동적 Measure
    -----------------------------------------------------------------------
    UNION ALL
    SELECT DISTINCT 'DMF0003'   AS PROGRAM_ID
                  , 'Mkt Fcst'  AS SHEET_NAME
                  , P_CREATED_BY AS USER_ID
                  , 'CUST_FCST_2' AS MEASURE_GROUP
                  , C.MEASURE
                  ,
                      ( SELECT SMSM.SORT_ORDER_NO
                        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
                        JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
                          ON   U.PROGRAM_ID = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
                         AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
                         AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND SMSM.VALID_YN = 'Y'
                        WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                          AND  U.PROGRAM_ID = 'DMF0003' AND U.SHEET_NAME = 'Mkt Fcst'
                          AND  U.USER_ID = P_CREATED_BY AND U.COLUMN_NAME = 'CUST_FCST' )
                      + 0.1
                     AS SORT_ORDER_NO
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
    WHERE  C.MEASURE_GROUP = 'CUST_FCST'
      AND  NVL(C.MEASURE,'-') <> '-'
      AND  C.VALID_YN = 'Y'
      AND  EXISTS (
               SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER X
               WHERE  X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                 AND  X.PROGRAM_ID = 'DMF0003' AND X.SHEET_NAME = 'Mkt Fcst'
                 AND  X.USER_ID    = P_CREATED_BY
                 AND  X.COLUMN_NAME = 'CUST_FCST' AND X.COLUMN_NAME = C.MEASURE_GROUP
           )
    -----------------------------------------------------------------------
    -- CUST_FCST_3 : Customer Fcst[Org.] 고정 Measure
    -----------------------------------------------------------------------
    UNION ALL
    SELECT DISTINCT 'DMF0003', 'Mkt Fcst', P_CREATED_BY
                  , 'CUST_FCST_3', 'Customer Fcst[Org.]'
                  ,
                      ( SELECT SMSM.SORT_ORDER_NO
                        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
                        JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
                          ON   U.PROGRAM_ID = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME
                         AND   U.COLUMN_NAME = SMSM.COLUMN_NAME
                         AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M' AND SMSM.VALID_YN = 'Y'
                        WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                          AND  U.PROGRAM_ID = 'DMF0003' AND U.SHEET_NAME = 'Mkt Fcst'
                          AND  U.USER_ID = P_CREATED_BY AND U.COLUMN_NAME = 'CUST_FCST_ORG' )
                      + 0.1
                     AS SORT_ORDER_NO
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
    WHERE  C.MEASURE_GROUP = 'CUST_FCST'
      AND  NVL(C.MEASURE,'-') <> '-'
      AND  C.VALID_YN = 'Y'
      AND  EXISTS (
               SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER X
               WHERE  X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                 AND  X.PROGRAM_ID = 'DMF0003' AND X.SHEET_NAME = 'Mkt Fcst'
                 AND  X.USER_ID    = P_CREATED_BY AND X.COLUMN_NAME = 'CUST_FCST_ORG'
           );

    -----------------------------------------------------------------------
    -- [C20201103-000114] Division 82: MKT_FCST_RP 선택 시 VMI 관련 메저 강제 추가
    -----------------------------------------------------------------------
    DECLARE
        V_MKT_RP_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_MKT_RP_CNT
        FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
        WHERE  MEASURE = 'MKT_FCST_RP';

        IF V_MKT_RP_CNT > 0 AND P_DIVISION_ID = '82' THEN
            -- 순서 조정을 위해 기존 항목 제거 후 재삽입
            DELETE FROM SCM_MGR.GT_DMF0003_SELECT_MEASURE
            WHERE  MEASURE IN ('RTF_SYS_RP','VMI_IN_PLAN','VMI_IN_REQ','VMI_INV');

            INSERT INTO SCM_MGR.GT_DMF0003_SELECT_MEASURE
            ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO )
            SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID
                 , B.MEASURE_GROUP, B.MEASURE
                 , REPLACE(A.SORT_ORDER_NO, '.0', B.SORTKEY)
            FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE A
            JOIN   (
                       SELECT 'RTF_SYS_RP'  AS MEASURE_GROUP, 'RTF_SYS_RP'  AS MEASURE, '.1' AS SORTKEY FROM DUAL UNION ALL
                       SELECT 'VMI_In_Plan'               , 'VMI_In_Plan'               , '.2' FROM DUAL UNION ALL
                       SELECT 'VMI_In_Req'                , 'VMI_In_Req'                , '.3' FROM DUAL UNION ALL
                       SELECT 'VMI_Inv'                   , 'VMI_Inv'                   , '.4' FROM DUAL
                   ) B ON 1=1
            WHERE  A.MEASURE = 'MKT_FCST_RP';
        END IF;
    END;

    -- MKT FCST 메저 순서 변경
    UPDATE SCM_MGR.GT_DMF0003_SELECT_MEASURE
    SET    SORT_ORDER_NO = REPLACE(SORT_ORDER_NO, '.0', '.9')
    WHERE  MEASURE = 'MKT_FCST_RP';

    -----------------------------------------------------------------------
    -- GT_DMF0003_VMI_DIO 수집
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '40' THEN
        INSERT INTO SCM_MGR.GT_DMF0003_VMI_DIO ( KEY_JOIN, VMI_STD_DIO )
        SELECT A.ITEM_ID, A.VMI_STD_DIO
        FROM   SCM_MGR.SCP_MST_DIO A
        JOIN (
            SELECT DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN, MAX(YYYYMM) AS YYYYMM
            FROM   SCM_MGR.SCP_MST_DIO
            WHERE  DIVISION_ID = '40' AND TOTAL_YN = 'Y' AND PLANT_ID = '*'
            GROUP  BY DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN
        ) B ON A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
           AND A.ITEM_ID     = B.ITEM_ID     AND A.TOTAL_YN = B.TOTAL_YN
           AND A.YYYYMM      = B.YYYYMM
        WHERE  A.DIVISION_ID = '40' AND A.TOTAL_YN = 'Y' AND A.PLANT_ID = '*';

    ELSIF P_DIVISION_ID = '82' THEN   -- [C20201103-000114]
        INSERT INTO SCM_MGR.GT_DMF0003_VMI_DIO ( KEY_JOIN, VMI_VAL )
        SELECT A.SCM_SITE_ID
             , A.VMI_YN || '^' || NVL(TO_CHAR(A.ATTRIBUTE5),'')
        FROM   SCM_MGR.SCM_MST_SITE A
        WHERE  DIVISION_ID = P_DIVISION_ID;
    END IF;

    -----------------------------------------------------------------------
    -- GT_DMF0003_SITE_ITEM_ALL 수집 (81/82 vs 40 분기)
    -----------------------------------------------------------------------
    IF P_DIVISION_ID LIKE '81%' OR P_DIVISION_ID = '82' THEN
        -- ============================================================
        -- ⭐ Phase 1 (2026-06-16): 6 룰 적용 — 99% bottleneck 영역
        --   - 룰 1: LISTAGG correlated subquery → FROM 절 OW LEFT JOIN
        --   - 룰 2: INNER JOIN B/C (LIKE split) 제거 → WHERE EXISTS GT_DMF0003_SPLIT_*
        --   - 룰 5: NVL(T2.FORECAST_INFO_CELL_MODEL,'')=T4.ITEM_ID → 직접 비교 (SARGable)
        --   - 룰 6: 'ALL'/'%'/'' 시 EXISTS skip (P_ITEM_ID / LP_PROJECT_CODE / P_OWNER)
        --
        -- 의미 1:1 보존 검증:
        --   - 'ALL' 시: Before LIKE '%ALL%' 0 row → 전체 제외 (FE 'ALL'=전체 의도 위반)
        --                After OR 분기 → 전체 row 통과 (정합 fix — 이전 사고 root cause)
        --   - 'specific' 시: Before/After 동일 (LIKE 매치 row 만 통과)
        -- ============================================================
        INSERT INTO SCM_MGR.GT_DMF0003_SITE_ITEM_ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
             , T2.NICK_NAME, T3.PROJECT_NAME
             , ''   AS CELL_MODEL      -- 20180809 ytchoi modify
             , T3.BIZ_TYPE
             , S.END_CUSTOMER
             , S.SOLDTO_CUSTOMER
             , I.COUNTRY, I.COUNTRY_NAME
             , H.CITY, H.CITY_NAME
             -- ⭐ 룰 1: FROM 절 OW inline view 의 OWNER_NAME 참조 (correlated 제거)
             , OW.OWNER_NAME  AS OWNER
             , CASE WHEN F.DIVISION_ID NOT IN ('40') THEN T3.PROJECT_OWNER
                    ELSE J.USER_NAME_EN END AS PROJECT_OWNER   -- 20180705
             , J.USER_ID
             , T2.ITEM_NAME, T2.ITEM_TYPE
             , T3.PROJECT_STATUS
             , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
             , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
             , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
             , LOOK.NAME  AS CELL_TYPE   -- 20180911 LookUp TABLE JOIN
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME  -- 20190419 KHSONG (SELECT 절 NVL 은 유지 — SARGable 무관)
             , S.VMI_YN
             , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES    -- 20190213 KHSONG
             , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER -- 20190213 KHSONG
             -- [PJ2024-50461] Team Mapping
             , TEAM.DEPT_ID
             , TEAM_DEPT.DEPT_NAME_KO
             , F.CELL_PER_CAR
             , F.CELL_PER_MODULE  -- [E20260123-001715] 원소스 복원
             , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
                                      ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
             , T2.ITEM_CLASS_NAME
             , T2.ENERGE
             , TO_CHAR(T2.CELL_QUANTITY)
             , F.VALID_YN  AS ITEM_VALID_YN
        FROM   SCM_MGR.SCM_MST_SITE_ITEM F
        JOIN   SCM_MGR.GT_DMF0003_ITEM_SINGLE_V T2
          ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
        JOIN   SCM_MGR.SCM_MST_PROJECT T3
          ON   F.DIVISION_ID = T3.DIVISION_ID AND F.PROJECT_CODE = T3.PROJECT_CODE
        -- ⭐ 룰 2: INNER JOIN B/C (LIKE split cartesian) 제거 → WHERE EXISTS GT_DMF0003_SPLIT_*
        JOIN   SCM_MGR.SCM_MST_SITE S
          ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
         AND   S.SITE_TYPE   = 'SALES' AND S.VALID_YN = 'Y'
        JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
        JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
        -- [PJ2024-50461] Team Mapping
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO TEAM
          ON   TEAM.USER_ID = TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1))
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM_DEPT
          ON   TEAM.DEPT_ID = TEAM_DEPT.DEPT_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
          ON   SUBSTR(F.OWNER, 1,
                      CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
                           ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K ON J.DEPT_ID = K.DEPT_ID
        LEFT   JOIN (
                        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
                    ) LOOK ON LOOK.CODE = T2.CELL_TYPE
        -- ⭐ 룰 5: NVL(T2.X,'')=T4.ITEM_ID → 직접 비교 (T4.ITEM_ID NOT NULL 이라 NULL row 어차피 매치 X)
        LEFT   JOIN SCM_MGR.GT_DMF0003_ITEM_SINGLE_V T4
          ON   T2.DIVISION_ID = T4.DIVISION_ID
         AND   T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID  -- 20190419 KHSONG (NVL 제거)
        -- ⭐ 룰 1: FROM 절 OW inline view — F.OWNER 사전 집계 (correlated 제거)
        LEFT   JOIN (
                        SELECT OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
                             , LISTAGG(ZA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN) AS OWNER_NAME
                        FROM (
                            SELECT FF.DIVISION_ID, FF.PROJECT_CODE, FF.SCM_SITE_ID, FF.ITEM_ID
                                 , TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) AS TOK
                            FROM   SCM_MGR.SCM_MST_SITE_ITEM FF
                            CROSS JOIN ( SELECT LEVEL AS LV
                                         FROM DUAL CONNECT BY LEVEL <= 30 ) HIER
                            WHERE  FF.DIVISION_ID = P_DIVISION_ID
                              AND  FF.OWNER IS NOT NULL
                              AND  TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) IS NOT NULL
                        ) OT
                        JOIN SCM_MGR.SCM_MST_SSO_USER_INFO ZA ON ZA.USER_ID = OT.TOK
                        GROUP BY OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
                    ) OW
          ON   F.DIVISION_ID  = OW.DIVISION_ID
         AND   F.PROJECT_CODE = OW.PROJECT_CODE
         AND   F.SCM_SITE_ID  = OW.SCM_SITE_ID
         AND   F.ITEM_ID      = OW.ITEM_ID
        WHERE  F.DIVISION_ID <> '40'   -- hard coding (20190123 KHSONG)
          AND  F.DIVISION_ID = P_DIVISION_ID
          -- [E20260211-001189] SCM_SITE_ID 조건 주석처리
          AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
                      ELSE S.END_CUSTOMER END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
                      ELSE T2.ITEM_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
                      ELSE T3.BIZ_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          -- ⭐ 룰 6: P_OWNER 'ALL' 분기 추가 + EXISTS GT_DMF0003_SPLIT_OWNER
          AND  ( P_OWNER IS NULL OR P_OWNER IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0003_SPLIT_OWNER O WHERE F.OWNER = O.TOK) )
          -- ⭐ 룰 2+6: P_ITEM_ID — INNER JOIN B 제거 + EXISTS GT_DMF0003_SPLIT_ITEM_ID + 'ALL' short-circuit
          AND  ( P_ITEM_ID IS NULL OR P_ITEM_ID IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0003_SPLIT_ITEM_ID B
                                WHERE F.ITEM_ID    LIKE '%' || B.TOK || '%'
                                   OR T2.NICK_NAME LIKE '%' || B.TOK || '%') )
          -- ⭐ 룰 2+6: LP_PROJECT_CODE — INNER JOIN C 제거 + EXISTS GT_DMF0003_SPLIT_PROJECT_CODE + 'ALL' short-circuit
          AND  ( LP_PROJECT_CODE IS NULL OR LP_PROJECT_CODE IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0003_SPLIT_PROJECT_CODE C
                                WHERE F.PROJECT_CODE  LIKE '%' || C.TOK || '%'
                                   OR T3.PROJECT_NAME LIKE '%' || C.TOK || '%') );

    ELSE
        -- Division 40 (소형) 케이스
        -- ============================================================
        -- ⭐ Phase 2 (2026-06-16): 6 룰 적용 — DIV='40' (소형 사업부) 분기
        --   Phase 1 과 동일 패턴 + DIV=40 전용 컬럼/JOIN 보존 (LOOKA / TEAM inline / DEPT_NAME_KO 등)
        -- ============================================================
        -- Division 40 (소형) 케이스
        INSERT INTO SCM_MGR.GT_DMF0003_SITE_ITEM_ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
             , T2.NICK_NAME, F.PROJECT_CODE  AS PROJECT_NAME
             , F.ATTRIBUTE5  AS CELL_MODEL   -- 20180810 ytchoi 조회속도개선
             , ''  AS BIZ_TYPE
             , S.END_CUSTOMER
             , S.SOLDTO_CUSTOMER
             , I.COUNTRY, I.COUNTRY_NAME
             , H.CITY, H.CITY_NAME
             -- ⭐ 룰 1: FROM 절 OW inline view 의 OWNER_NAME 참조 (correlated 제거)
             , OW.OWNER_NAME  AS OWNER
             , J.USER_NAME_EN  AS PROJECT_OWNER   -- 20180705
             , J.USER_ID
             , T2.ITEM_NAME, T2.ITEM_TYPE
             , ''  AS PROJECT_STATUS
             , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
             , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
             -- [E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청
             , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                    ELSE T2.FORECAST_INFO_BIZ_TYPE END  AS FORECAST_INFO_BIZ_TYPE
             , T2.FORECAST_INFO_PRODUCT_GROUP
             , LOOK.NAME  AS CELL_TYPE
             , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT)
                    ELSE T2.FORECAST_INFO_CELL_PACK_COUNT END  AS FORECAST_INFO_CELL_PACK_COUNT
             , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME
             , S.VMI_YN
             , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES
             , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER
             -- [PJ2024-50461] Team Mapping
             , TEAM.DEPT_ID
             , TEAM.DEPT_NAME_KO
             , F.CELL_PER_CAR
             , F.CELL_PER_MODULE
             , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
                                      ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
             , T2.ITEM_CLASS_NAME
             , T2.ENERGE
             , TO_CHAR(T2.CELL_QUANTITY)
             , F.VALID_YN  AS ITEM_VALID_YN
        FROM   SCM_MGR.SCM_MST_SITE_ITEM F
        JOIN   SCM_MGR.GT_DMF0003_ITEM_SINGLE_V T2
          ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
        -- ⭐ 룰 2: INNER JOIN B/C (LIKE split) 제거 → WHERE EXISTS
        JOIN   SCM_MGR.SCM_MST_SITE S
          ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
         AND   S.SITE_TYPE   = 'SALES'
        JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
        JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
        LEFT   JOIN (
                        SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
                        FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B
                        JOIN   SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
                    ) TEAM
          ON   TEAM.USER_ID = TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1))
                                 -- 원본 IN (SELECT ... FROM DUAL) → 단일 row 비교로 변환 (의미 동등)
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
          ON   SUBSTR(F.OWNER, 1,
                      CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
                           ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
          ON   CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID
                    ELSE F.DEPT_ID END = K.DEPT_ID   -- 20190123 KHSONG
        LEFT   JOIN (
                        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
                    ) LOOK ON LOOK.CODE = T2.CELL_TYPE
        -- ⭐ 룰 5: NVL(T2.X,'')=T4.ITEM_ID → 직접 비교
        LEFT   JOIN SCM_MGR.GT_DMF0003_ITEM_SINGLE_V T4
          ON   T2.DIVISION_ID = T4.DIVISION_ID
         AND   T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID
        -- [E20230720-001573] 40번사업부 AMDMO0001A모델 BIZ_TYPE/CELL_PACK_COUNT LOOKUP 적용
        LEFT   JOIN (
                        SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT
                        FROM (
                            SELECT SEGMENT2 AS MODEL
                                 , SEGMENT3 AS BIZ_TYPE
                                 , SEGMENT4 AS CELL_PACK_COUNT
                                 , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
                            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40' AND SEGMENT1 = '40'
                        ) A WHERE MODEL_RANK = 1
                    ) LOOKA ON LOOKA.MODEL = F.ITEM_ID
        -- ⭐ 룰 1: FROM 절 OW inline view — F.OWNER 사전 집계 (correlated 제거)
        LEFT   JOIN (
                        SELECT OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
                             , LISTAGG(ZA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN) AS OWNER_NAME
                        FROM (
                            SELECT FF.DIVISION_ID, FF.PROJECT_CODE, FF.SCM_SITE_ID, FF.ITEM_ID
                                 , TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) AS TOK
                            FROM   SCM_MGR.SCM_MST_SITE_ITEM FF
                            CROSS JOIN ( SELECT LEVEL AS LV
                                         FROM DUAL CONNECT BY LEVEL <= 30 ) HIER
                            WHERE  FF.DIVISION_ID = '40'
                              AND  FF.OWNER IS NOT NULL
                              AND  TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) IS NOT NULL
                        ) OT
                        JOIN SCM_MGR.SCM_MST_SSO_USER_INFO ZA ON ZA.USER_ID = OT.TOK
                        GROUP BY OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
                    ) OW
          ON   F.DIVISION_ID  = OW.DIVISION_ID
         AND   F.PROJECT_CODE = OW.PROJECT_CODE
         AND   F.SCM_SITE_ID  = OW.SCM_SITE_ID
         AND   F.ITEM_ID      = OW.ITEM_ID
        WHERE  F.DIVISION_ID = '40'
          -- ⭐ 룰 2+6: LP_SCM_SITE_ID — CASE 패턴 유지 (Before 의 의미 1:1) — split 은 일반적인 동작 그대로
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID
                      ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
                      ELSE F.PROJECT_CODE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
                      ELSE T2.ITEM_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          -- [E20230720-001573] BIZ_TYPE LOOKUP 우선 적용
          AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
                      WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                      ELSE T2.FORECAST_INFO_BIZ_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          -- ⭐ 룰 6: P_OWNER 'ALL' 분기 추가 + EXISTS GT_DMF0003_SPLIT_OWNER
          AND  ( P_OWNER IS NULL OR P_OWNER IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0003_SPLIT_OWNER O WHERE F.OWNER = O.TOK) )
          -- ⭐ 룰 2+6: P_ITEM_ID — INNER JOIN B 제거 + EXISTS + 'ALL' short-circuit
          AND  ( P_ITEM_ID IS NULL OR P_ITEM_ID IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0003_SPLIT_ITEM_ID B
                                WHERE F.ITEM_ID    LIKE '%' || B.TOK || '%'
                                   OR T2.NICK_NAME LIKE '%' || B.TOK || '%') )
          -- ⭐ 룰 2+6: LP_PROJECT_CODE — INNER JOIN C 제거 + EXISTS + 'ALL' short-circuit
          --   원본: JOIN C ON F.PROJECT_CODE LIKE C.TST (PROJECT_NAME LIKE 분기 없음 — DIV=40)
          AND  ( LP_PROJECT_CODE IS NULL OR LP_PROJECT_CODE IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0003_SPLIT_PROJECT_CODE C
                                WHERE F.PROJECT_CODE LIKE '%' || C.TOK || '%') );

    END IF;

    -----------------------------------------------------------------------
    -- [20190704 KHSONG] ITEM_ID 중복 현상 방지를 위해 재 GROUP
    -- GT_DMF0003_SITE_ITEM_ALL → GT_DMF0003_SITE_ITEM
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0003_SITE_ITEM
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
         , MAX(CELL_MODEL)
         , MAX(BIZ_TYPE)
         , MAX(END_CUSTOMER)
         , MAX(SOLDTO_CUSTOMER)
         , MAX(COUNTRY)
         , MAX(COUNTRY_NAME)
         , MAX(CITY)
         , MAX(CITY_NAME)
         , MAX(OWNER)
         , MAX(PROJECT_OWNER)
         , MAX(USER_ID)
         , MAX(ITEM_NAME)
         , MAX(ITEM_TYPE)
         , MAX(PROJECT_STATUS)
         , MAX(CUST_GROUP)
         , MAX(CUST_GROUP_DTL)
         , MAX(APPLICATION)
         , MAX(ROUTE)
         , MAX(MDM_PROJECT_NAME)
         , MAX(MIN_CAPACITY)
         , MAX(FORECAST_INFO_BIZ_TYPE)
         , MAX(FORECAST_INFO_PRODUCT_GROUP)
         , MAX(CELL_TYPE)
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)
         , MAX(FORECAST_INFO_ALL)
         , MAX(FORECAST_INFO_SPEC)
         , MAX(FORECAST_INFOR_VERSION)
         , MAX(CELL_MODEL_NICK_NAME)
         , MAX(VMI_YN)
         , MAX(DMS_SALES)
         , MAX(DMS_CUSTOMER)
         , MAX(DEPT_ID)
         , MAX(DEPT_NAME_KO)
         , MAX(CELL_PER_CAR)
         , MAX(CELL_PER_MODULE)
         , MAX(MODULE_PER_CAR)
         , MAX(ITEM_CLASS_NAME)
         , MAX(ENERGE)
         , MAX(CELL_QUANTITY)
         , MAX(ITEM_VALID_YN)
    FROM   SCM_MGR.GT_DMF0003_SITE_ITEM_ALL
    GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;

    -----------------------------------------------------------------------
    -- GT_DMF0003_EDI_SENDER 수집
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0003_EDI_SENDER ( SCM_SITE_ID, SENDER_CODE, SENDER_NAME )
    SELECT A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6
    FROM   SCM_MGR.SCM_MST_SITE A
    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
      ON   A.END_CUSTOMER = B.SEGMENT2
     AND   A.DIVISION_ID  = B.SEGMENT1
     AND   B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
    GROUP  BY A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6;

    -----------------------------------------------------------------------
    -- GT_DMF0003_LAST_DATA_SETUP 수집 (최종 입력일시 및 입력자)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    , CREATE_DATE, LAST_UPDATED_BY )
    SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID
         , X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
         , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
    FROM (
        -- DM_PLN_MKT_FCST (계획 테이블)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , CASE WHEN A.MEASURE IN (
                        'CUST_FCST','CUST_FCST_EDI','Immidiate','Planning_Forecast',
                        'Commercial_Agreement','Firm_Temp','Manumacturing_Material_Temp',
                        'Material_Temp','Backorder','CUST_FCST_EDI_ORG','Immidiate[Org.]',
                        'Planning_Forecast[Org.]','Commercial_Agreement[Org.]',
                        'Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]',
                        'Material_Temp[Org.]','Backorder[Org.]')
                    THEN ( CASE WHEN MAX(A.ATTRIBUTE9) IS NULL OR NVL(MAX(A.ATTRIBUTE9),'') = ''
                                THEN MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
                                ELSE MAX(A.ATTRIBUTE9) END )
                    ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
               END AS LAST_UPDATE_DATE
             , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE B
          ON   A.MEASURE = CASE WHEN B.MEASURE = 'CUST_FCST_ORG'         THEN 'CUST_FCST'
                                WHEN B.MEASURE = 'Customer Fcst[Org.]'   THEN 'Customer FCST'
                                WHEN B.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST'
                                WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR',
                                                   'RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
                                               THEN 'RTF'
                                ELSE B.MEASURE END
        WHERE  A.DIVISION_ID = P_DIVISION_ID
          AND  A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD'),-12),'YYYYMMDD')
          AND  A.YYYYMMDD   <= P_TO_YYYYMMDD
        GROUP  BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
               , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
        UNION ALL
        -- DM_PLN_MKT_FCST_RESULT (실적 테이블)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , CASE WHEN A.MEASURE IN (
                        'CUST_FCST','CUST_FCST_EDI','Immidiate','Planning_Forecast',
                        'Commercial_Agreement','Firm_Temp','Manumacturing_Material_Temp',
                        'Material_Temp','Backorder','CUST_FCST_EDI_ORG','Immidiate[Org.]',
                        'Planning_Forecast[Org.]','Commercial_Agreement[Org.]',
                        'Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]',
                        'Material_Temp[Org.]','Backorder[Org.]')
                    THEN ( CASE WHEN MAX(A.ATTRIBUTE9) IS NULL OR NVL(MAX(A.ATTRIBUTE9),'') = ''
                                THEN MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
                                ELSE MAX(A.ATTRIBUTE9) END )
                    ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE,'YYYYMMDD'))
               END AS LAST_UPDATE_DATE
             , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE B
          ON   A.MEASURE = CASE WHEN B.MEASURE = 'CUST_FCST_ORG'         THEN 'CUST_FCST'
                                WHEN B.MEASURE = 'Customer Fcst[Org.]'   THEN 'Customer FCST'
                                WHEN B.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST'
                                WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR',
                                                   'RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
                                               THEN 'RTF'
                                ELSE B.MEASURE END
        WHERE  A.DIVISION_ID = P_DIVISION_ID
          AND  A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD'),-12),'YYYYMMDD')
          AND  A.YYYYMMDD   <= P_TO_YYYYMMDD
        GROUP  BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
               , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
    ) X
    WHERE  ( X.PROJECT_CODE IS NOT NULL OR NVL(X.PROJECT_CODE,'') <> '' )
      AND  ( X.SCM_SITE_ID IS NOT NULL OR NVL(X.SCM_SITE_ID,'')  <> '' )
      AND  ( X.ITEM_ID IS NOT NULL OR NVL(X.ITEM_ID,'')      <> '' )
    GROUP  BY X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID
           ,  X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE;

    -----------------------------------------------------------------------
    -- GT_DMF0003_EDI_END_CUST 수집 (EDI END_CUSTOMER별 기간 설정)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0003_EDI_END_CUST
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , NVL(B.SEGMENT4, '-')
         , CASE WHEN NVL(B.SEGMENT5,'Off') = 'Off' THEN -52
                ELSE NVL(TO_NUMBER(B.ATTRIBUTE1),-1) END
         , NVL(B.ATTRIBUTE2, 'TUE')
         , NVL(TO_NUMBER(B.ATTRIBUTE3), 0)
         , NVL(B.ATTRIBUTE4, 'MON')
         , NVL(B.SEGMENT5, 'Off')
    FROM   SCM_MGR.SCM_MST_SITE A
    LEFT   OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
      ON   B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
     AND   A.DIVISION_ID  = B.SEGMENT1
     AND   A.END_CUSTOMER = B.SEGMENT2
     AND   B.VALID_YN     = 'Y'
    WHERE  ( A.END_CUSTOMER IS NOT NULL OR NVL(A.END_CUSTOMER,'') <> '' )
    GROUP  BY A.DIVISION_ID, A.END_CUSTOMER
           ,  B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;

    -----------------------------------------------------------------------
    -- GT_DMF0003_RPA_END_CUST 수집 (RPA END_CUSTOMER별 기간 설정)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0003_RPA_END_CUST
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , NVL(B.SEGMENT4, '-')
         , CASE WHEN NVL(B.SEGMENT5,'Off') = 'Off' THEN -52
                ELSE NVL(TO_NUMBER(B.ATTRIBUTE1),-1) END
         , NVL(B.ATTRIBUTE2, 'TUE')
         , NVL(TO_NUMBER(B.ATTRIBUTE3), 0)
         , NVL(B.ATTRIBUTE4, 'MON')
         , NVL(B.SEGMENT5, 'Off')
    FROM   SCM_MGR.SCM_MST_SITE A
    LEFT   OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
      ON   B.LOOKUP_TYPE  = 'RPA_END_CUSTOMER'
     AND   A.DIVISION_ID  = B.SEGMENT1
     AND   A.END_CUSTOMER = B.SEGMENT2
     AND   B.VALID_YN     = 'Y'
    WHERE  ( A.END_CUSTOMER IS NOT NULL OR NVL(A.END_CUSTOMER,'') <> '' )
    GROUP  BY A.DIVISION_ID, A.END_CUSTOMER
           ,  B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;

    -----------------------------------------------------------------------
    -- CAL_MONTH_END / CAL_WEEK_END 수집 (월말일 / 주말일 목록)
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0003_CAL_MONTH_END ( MONTH_END_DATE )
    SELECT TO_CHAR(LAST_DAY(TO_DATE(BASIS_YYYYMM,'YYYYMM')),'YYYYMMDD') AS MONTH_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
    GROUP  BY BASIS_YYYYMM;

    INSERT INTO SCM_MGR.GT_DMF0003_CAL_WEEK_END ( WEEK_END_DATE )
    SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
    GROUP  BY BASIS_YYYYMM, ISO_WEEK;


    -----------------------------------------------------------------------
    -- 계획 구간 INSERT 조건:
    --   V_TO_YYYYMMDD >= 당주 월요일  →  계획구간 데이터 존재
    -- CONVERT(CHAR(8), DATEADD(DD,-7, FN_NEXT_DAY(GETDATE(),'MON')),112)
    --   → TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
    -----------------------------------------------------------------------
    IF V_TO_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') THEN

        -----------------------------------------------------------------------
        -- Block 1-A : MKT_FCST 계열 (CUST_FCST_EDI/Immidiate 등 제외)
        --             AS콤보박스 제거로 T4(AS_SITE_PLANT) LEFT JOIN 추가 [E20260211-001189]
        -----------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DATA
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
        , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
        , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
        , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
        , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
        , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                 WHERE  DIVISION_ID  = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID  = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP      = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS    = F.INCOTERMS    AND MEASURE      = F.MEASURE
                   AND  QTY         <> 0 )
             , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                 WHERE  DIVISION_ID  = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID  = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP      = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS    = F.INCOTERMS    AND MEASURE      = F.MEASURE )
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        -- [E20260211-001189] AS콤보박스 제거 → AS_SITE_PLANT LEFT JOIN으로 AS데이터 포함
        LEFT   OUTER JOIN (
                               SELECT SEGMENT1, SEGMENT2
                               FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE  LOOKUP_TYPE = 'AS_SITE_PLANT'
                                 AND  SEGMENT3    = P_DIVISION_ID
                           ) T4 ON NVL(F.ATTRIBUTE10,'') = T4.SEGMENT2
        WHERE  F.QTY <> 0
          AND  F.MEASURE NOT IN (
                   'CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement',
                   'Firm_Temp','Manumacturing_Material_Temp','Material_Temp','Backorder',
                   'CUST_FCST','Customer FCST' )
          AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
          AND  F.DIVISION_ID = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL)
                 OR
                 CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE T4.SEGMENT1 END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- Block 1-B : CUST_FCST_EDI 계열 (EDI/RPA Sender 기반)
        --             YYYYMMDD 범위: v_to_result ~ p_to_yyyymmdd  [고객수요분석시스템 정비]
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                    'Commercial_Agreement','Firm_Temp',
                                    'Manumacturing_Material_Temp','Material_Temp','Backorder') )
             , CASE WHEN ( F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' ) THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 ) || '_EDI'
                   ELSE F.ATTRIBUTE5 || '_' || F.LAST_UPDATED_BY END  AS LAST_UPDATED_BY
             , CASE WHEN ( F.ATTRIBUTE4 IS NULL OR NVL(F.ATTRIBUTE4,'') = '' ) THEN
                   ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE4 END  AS SENDER_CODE
             , CASE WHEN ( F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' ) THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE5 END  AS SENDER_NAME
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID  = B.DIVISION_ID
         AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   B.SITE_TYPE    = 'SALES'
         AND   B.VALID_YN     = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                         ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                         ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> -9999999999
          AND  F.MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                             'Commercial_Agreement','Firm_Temp',
                             'Manumacturing_Material_Temp','Material_Temp','Backorder')
          -- [고객수요분석시스템 정비] EDI데이터 중복건 제거: v_to_result 이후부터만 조회
          AND  F.YYYYMMDD    BETWEEN GREATEST(V_TO_RESULT, V_FROM_YYYYMMDD) AND P_TO_YYYYMMDD  -- [FIX 2026-07-11] 실적없음 분기(V_TO_RESULT='19000101') 시 옛 EDI 이력 유입 차단 — 자식 하한 = 당주월요일 (AS-IS 배치 purge 환경과 동일 결과)
          AND  F.DIVISION_ID = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END ) = 'ALL'
                      THEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END )
                      ELSE F.ATTRIBUTE4 END
                 IN ( SELECT TRIM(REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL))
                      FROM DUAL
                      CONNECT BY REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL) IS NOT NULL ) )

        -----------------------------------------------------------------------
        -- Block 1-C : Customer FCST (RPA/EXCEL 경로, Cust.FCST_RPA[P+P] / Cust.FCST_EXCEL[P+P] 으로 표시)
        --             [E20241126-000426] Customer FCST 전용 로직
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , CASE WHEN F.MEASURE = 'Customer FCST' THEN
                        CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
                             THEN 'Cust.FCST_RPA[P+P]'
                             ELSE 'Cust.FCST_EXCEL[P+P]' END
                    ELSE F.MEASURE END  AS MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             -- [E20241126-000426] Customer FCST 전용 LAST_DATA_SETUP
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'Customer FCST' )
             , CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
                    THEN F.LAST_UPDATED_BY || '_RPA'
                    ELSE F.LAST_UPDATED_BY || '_EXCEL' END  AS LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID  = B.DIVISION_ID
         AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   B.SITE_TYPE    = 'SALES'
         AND   B.VALID_YN     = 'Y'
         AND   ( ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                   ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          -- [E20241126-000426] Customer FCST 전용
          AND  F.MEASURE      = 'Customer FCST'
          AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- Block 1-D : CUST_FCST 전용  [E20241126-000426]
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD
             , F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER
             , T2.NICK_NAME
             , T2.DMS_SALES
             , T2.DMS_CUSTOMER
             , T2.OWNER
             , T2.DEPT_ID
             , T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , T2.PROJECT_NAME
             , T2.PROJECT_OWNER
             , T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER
             , T2.COUNTRY_NAME
             , T2.CITY_NAME
             , T2.PROJECT_STATUS
             , T2.ITEM_NAME
             , T2.VMI_YN
             , T2.CUST_GROUP
             , T2.CUST_GROUP_DTL
             , T2.APPLICATION
             , T2.ROUTE
             , T2.MDM_PROJECT_NAME
             , T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE
             , T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR
             , T2.CELL_PER_MODULE
             , T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE
             , T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'CUST_FCST' )
             , F.LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.DM_PLN_MKT_FCST F
        JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
         AND   T2.ITEM_VALID_YN = 'Y'
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID  = B.DIVISION_ID
         AND   F.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   B.SITE_TYPE    = 'SALES'
         AND   B.VALID_YN     = 'Y'
         AND  ( ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                        ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
                OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                          ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          AND  F.MEASURE      = 'CUST_FCST'
          AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );

        -----------------------------------------------------------------------
        -- Block 2 : MKT_FCST_RP / MKT_FCST_RP_CAR / MKT_FCST_RP_CELL
        --           (Cell/Car/Module 환산 포함)
        -----------------------------------------------------------------------
        DECLARE
            V_RP_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RP_CNT
            FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
            WHERE  MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL');

            IF V_RP_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                            THEN M.MEASURE ELSE F.MEASURE END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE
                           WHEN M.MEASURE = 'MKT_FCST_RP' THEN F.QTY
                           WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell') > 0   AND NVL(T2.CELL_PER_CAR,0) > 0
                                        THEN F.QTY / T2.CELL_PER_CAR
                                   -- [C20200212-000304] Module: QTY / MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0) > 0
                                    AND NVL(T2.CELL_PER_MODULE,0) > 0
                                        THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack') > 0   THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND F.DIVISION_ID LIKE '81%' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   -- [C20200511-000360] Pack → CELL_PER_CAR 곱
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                           -- [C20200114-000201] ESS(82): CELL_QUANTITY 곱
                           WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND F.DIVISION_ID = '82' THEN
                               F.QTY * T2.CELL_QUANTITY
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST' )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST'
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS   AND MEASURE       = 'MKT_FCST' ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.DM_PLN_MKT_FCST F
                JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
                  ON   F.MEASURE = 'MKT_FCST'
                 AND   M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                 AND   T2.ITEM_VALID_YN = 'Y'
                WHERE  F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                                        THEN 'MKT_FCST' ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- Block 2 END
        END;

        -----------------------------------------------------------------------
        -- Block 3 : RTF_RP_CAR / RTF_SYS_RP_CAR / RTF_RP_CELL / RTF_SYS_RP_CELL / RTF_ENERGY
        --           [CSR ID:4023158] 20190705 KHSONG
        --           [C20211103-000146] 20211119 RTF_ENERGY 추가
        -----------------------------------------------------------------------
        DECLARE
            V_RTF_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RTF_CNT
            FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
            WHERE  MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY');

            IF V_RTF_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     -- Measure명 결정
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CAR'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR'
                                    ELSE '' END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CELL'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL'
                                    ELSE '' END
                           WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_ENERGY'
                       END  AS MEASURE
                     , F.YYYYMMDD
                     -- QTY 환산
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0) > 0
                                        THEN F.QTY / T2.CELL_PER_CAR
                                   -- [C20200212-000304] Module → MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0
                                    AND NVL(T2.CELL_PER_CAR,0) > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0
                                        THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') AND F.DIVISION_ID LIKE '81%' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                           -- [C20200114-000201] ESS(82) RTF_RP_CELL: CELL_QUANTITY 곱
                           WHEN M.MEASURE = 'RTF_RP_CELL' AND F.DIVISION_ID = '82' THEN
                               F.QTY * T2.CELL_QUANTITY
                           -- [C20211103-000146] RTF_ENERGY: ENERGE * QTY / 1000
                           WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE    IN ('RTF','RTF_SYS_RP') )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE    IN ('RTF','RTF_SYS_RP')
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS
                                                  AND  MEASURE    IN ('RTF','RTF_SYS_RP') ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.DM_PLN_MKT_FCST F
                JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
                  ON   F.MEASURE IN ('RTF','RTF_SYS_RP')
                 AND   M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL','RTF_ENERGY')
                JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                 AND   T2.ITEM_VALID_YN = 'Y'
                WHERE  F.MEASURE = CASE
                                       WHEN M.MEASURE IN ('RTF_RP_CAR', 'RTF_RP_CELL')                    THEN 'RTF'
                                       WHEN M.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_ENERGY') THEN 'RTF_SYS_RP'
                                       ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- Block 3 END
        END;


        -----------------------------------------------------------------------
        -- Block 4 : MKT_FCST_ENERGY  [C20221207-000080] 20221214 rosia27
        --           소스: GT_DMF0003_MKT_FCST_DATA 에 이미 들어간 MKT_FCST_RP 행에서 파생
        --           (원본: #TempMktFcstData JOIN #TempSiteItem)
        -----------------------------------------------------------------------
        DECLARE
            V_ENERGY_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_ENERGY_CNT
            FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
            WHERE  MEASURE = 'MKT_FCST_ENERGY';

            IF V_ENERGY_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'MKT_FCST_RP'
                            THEN 'MKT_FCST_ENERGY' END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                            ELSE 0 END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     -- MKT_FCST_ENERGY는 GT_DMF0003_MKT_FCST_DATA의 MKT_FCST_RP 행에서 파생
                     -- CREATE_DATE / LAST_UPDATED_BY / SENDER_* 는 원본 F 행 값 그대로 사용
                     , F.AS_FROM_SITE
                     , F.CREATE_DATE
                     , F.LAST_UPDATED_BY
                     , F.SENDER_CODE
                     , F.SENDER_NAME
                FROM   SCM_MGR.GT_DMF0003_MKT_FCST_DATA F   -- 이미 삽입된 MKT_FCST_RP 행을 소스로 사용
                JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
                  ON   F.MEASURE = 'MKT_FCST_RP'
                 AND   M.MEASURE = 'MKT_FCST_ENERGY'
                JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                 AND   T2.ITEM_VALID_YN = 'Y'
                WHERE  F.QTY <> 0
                  AND  F.YYYYMMDD    BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- Block 4 END
        END;

    END IF;  -- 계획 구간 조건 END (V_TO_YYYYMMDD >= 당주 월요일)


    -----------------------------------------------------------------------
    -- 실적 구간 INSERT 조건:
    --   V_FROM_YYYYMMDD <= 당주 월요일
    -- CONVERT(CHAR(8), DATEADD(DD,-7, FN_NEXT_DAY(GETDATE(),'MON')),112)
    --   → TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
    -----------------------------------------------------------------------
    IF V_FROM_YYYYMMDD <= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD') THEN

        -----------------------------------------------------------------------
        -- [PJ2025-50188] GT_DMF0003_MKT_FCST_RESULT 생성
        --   DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID 컬럼이 추가되어
        --   DUP 방지를 위해 CELL_PROD_SITE_ID 제거 후 GROUP BY로 집계
        -----------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_RESULT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, YYYYMMDD
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        , QTY )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
             , MEASURE, PLANT_SITE_ID, YYYYMMDD
             , MAX(CREATED_BY)        AS CREATED_BY
             , MAX(CREATION_DATE)     AS CREATION_DATE
             , MAX(LAST_UPDATED_BY)   AS LAST_UPDATED_BY
             , MAX(LAST_UPDATE_DATE)  AS LAST_UPDATE_DATE
             , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
             , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
             , SUM(QTY)               AS QTY
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT
        WHERE  DIVISION_ID  = P_DIVISION_ID
          AND  YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  YYYYMMDD     < V_TO_RESULT
        GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
               ,  MEASURE, PLANT_SITE_ID, YYYYMMDD
               ,  ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
               ,  ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10;

        -----------------------------------------------------------------------
        -- Block R-1 ~ R-4: 단일 INSERT … UNION ALL
        --   소스: GT_DMF0003_MKT_FCST_RESULT (= 집계된 실적 테이블)
        -----------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DATA
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
        , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
        , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
        , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
        , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
        , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )

        -----------------------------------------------------------------------
        -- R-1: MKT_FCST 계열 (CUST_FCST_EDI 계열 및 CUST_FCST/Customer FCST 제외)
        -----------------------------------------------------------------------
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END )
             , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END
                   AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                                        WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                          AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                          AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                          AND  INCOTERMS   = F.INCOTERMS
                                          AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END ) )
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.GT_DMF0003_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        WHERE  F.QTY <> 0
          AND  F.MEASURE NOT IN (
                   'CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement',
                   'Firm_Temp','Manumacturing_Material_Temp','Material_Temp','Backorder',
                   'CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]',
                   'Commercial_Agreement[Org.]','Firm_Temp[Org.]',
                   'Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]',
                   'CUST_FCST','Customer FCST' )
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- R-2: CUST_FCST_EDI 계열 (EDI Sender 포함)
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS
                   AND  MEASURE    IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                       'Commercial_Agreement','Firm_Temp',
                                       'Manumacturing_Material_Temp','Material_Temp','Backorder') )
             , CASE WHEN F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 ) || '_EDI'
                   ELSE F.ATTRIBUTE5 || '_' || F.LAST_UPDATED_BY END  AS LAST_UPDATED_BY
             , CASE WHEN F.ATTRIBUTE4 IS NULL OR NVL(F.ATTRIBUTE4,'') = '' THEN
                   ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE4 END  AS SENDER_CODE
             , CASE WHEN F.ATTRIBUTE5 IS NULL OR NVL(F.ATTRIBUTE5,'') = '' THEN
                   ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                     WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                   ELSE F.ATTRIBUTE5 END  AS SENDER_NAME
        FROM   SCM_MGR.GT_DMF0003_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
         AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                      ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> -9999999999
          AND  F.MEASURE IN ('CUST_FCST_EDI','Immidiate','Planning_Forecast',
                             'Commercial_Agreement','Firm_Temp',
                             'Manumacturing_Material_Temp','Material_Temp','Backorder')
          -- [E20241126-000426] EDI 기간 필터 주석처리(배치에서 정리) → 단순 날짜 범위만 적용
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END ) = 'ALL'
                      THEN ( CASE WHEN F.MEASURE IN (
                                      'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                      'Commercial_Agreement','Firm_Temp',
                                      'Manumacturing_Material_Temp','Material_Temp','Backorder')
                                  THEN P_SENDER_CODE ELSE 'ALL' END )
                      ELSE F.ATTRIBUTE4 END
                 IN ( SELECT TRIM(REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL))
                      FROM DUAL
                      CONNECT BY REGEXP_SUBSTR(
                          CASE WHEN F.MEASURE IN (
                                   'CUST_FCST_EDI','Immidiate','Planning_Forecast',
                                   'Commercial_Agreement','Firm_Temp',
                                   'Manumacturing_Material_Temp','Material_Temp','Backorder')
                               THEN P_SENDER_CODE ELSE 'ALL' END,'[^,]+',1,LEVEL) IS NOT NULL ) )

        -----------------------------------------------------------------------
        -- R-3: Customer FCST (RPA/EXCEL → Cust.FCST_RPA/EXCEL[P+P])
        --      [E20241126-000426] Customer FCST 전용; LAST_UPDATED_BY는 CREATED_BY 기반
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , CASE WHEN F.MEASURE = 'Customer FCST' THEN
                        CASE WHEN F.LAST_UPDATED_BY LIKE '%robot'
                             THEN 'Cust.FCST_RPA[P+P]'
                             ELSE 'Cust.FCST_EXCEL[P+P]' END
                    ELSE F.MEASURE END  AS MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             -- [E20241126-000426] Customer FCST 전용 CREATE_DATE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'Customer FCST' )
             -- [PJ2025-50188] 실적은 CREATED_BY 기반으로 _RPA/_EXCEL 결정
             , CASE WHEN F.CREATED_BY LIKE '%robot'
                    THEN F.CREATED_BY || '_RPA'
                    ELSE F.CREATED_BY || '_EXCEL' END  AS LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.GT_DMF0003_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
         AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                      ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          -- [E20241126-000426] Customer FCST 전용
          AND  F.MEASURE      = 'Customer FCST'
          -- [E20241126-000426] 날짜 필터 단순화(배치에서 RPA 기간 정리)
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )

        -----------------------------------------------------------------------
        -- R-4: CUST_FCST 전용  [E20241126-000426]
        -----------------------------------------------------------------------
        UNION ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
             , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
             , F.MEASURE
             , F.YYYYMMDD, F.QTY
             , M.MEASURE_GROUP
             , T2.CELL_MODEL
             , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
             , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
             , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
             , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
             , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
             , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
             , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , T2.CELL_MODEL_NICK_NAME
             , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
             , M.SORT_ORDER_NO
             , T2.ENERGE, T2.CELL_QUANTITY
             , F.ATTRIBUTE10  AS AS_FROM_SITE
             , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                 WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                   AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                   AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                   AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'CUST_FCST' )
             , F.LAST_UPDATED_BY
             , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
             , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                 WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
        FROM   SCM_MGR.GT_DMF0003_MKT_FCST_RESULT F
        JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
          ON   F.MEASURE = M.MEASURE
        JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
          ON   F.DIVISION_ID  = T2.DIVISION_ID
         AND   F.PROJECT_CODE = T2.PROJECT_CODE
         AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
         AND   F.ITEM_ID      = T2.ITEM_ID
        LEFT   OUTER JOIN SCM_MGR.SCM_MST_SITE B
          ON   F.DIVISION_ID = B.DIVISION_ID AND F.SCM_SITE_ID = B.SCM_SITE_ID
         AND   B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y'
         AND   (  ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                    ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) IS NOT NULL
               OR ( CASE WHEN F.DIVISION_ID = '40' THEN NVL(B.END_CUSTOMER,'-')
                      ELSE NVL(REPLACE(B.END_CUSTOMER,'-',''),'') END ) <> '' )
        WHERE  F.QTY <> 0
          AND  F.MEASURE      = 'CUST_FCST'
          AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
          AND  F.YYYYMMDD     < V_TO_RESULT
          AND  F.DIVISION_ID  = P_DIVISION_ID
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                     CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );

        -----------------------------------------------------------------------
        -- Block R-5 : MKT_FCST_RP_CAR / MKT_FCST_RP_CELL
        --   소스: GT_DMF0003_MKT_FCST_RESULT (RTF → 실적 기준)
        --   20190722 KHSONG: MKT_FCST_RESULT에서 RTF 컬럼이 실적값
        -----------------------------------------------------------------------
        DECLARE
            V_RP_RESULT_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RP_RESULT_CNT
            FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
            WHERE  MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL');

            IF V_RP_RESULT_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                            THEN M.MEASURE ELSE F.MEASURE END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE
                           WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY / T2.CELL_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0
                                    AND NVL(T2.CELL_PER_MODULE,0) > 0                                             THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0                                    THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE = 'MKT_FCST_RP_CELL' THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST' )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE      = 'MKT_FCST'
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS   AND MEASURE       = 'MKT_FCST' ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_DMF0003_MKT_FCST_RESULT F
                -- 실적에서 RTF는 MKT_FCST_RP_CAR/CELL 환산 소스 (20190722 KHSONG)
                JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
                  ON   F.MEASURE = 'RTF'
                 AND   M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
                                        THEN 'RTF' ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
                  AND  F.YYYYMMDD     < V_TO_RESULT
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-5 END
        END;

        -----------------------------------------------------------------------
        -- Block R-6: RTF_RP_CAR/CELL/ENERGY + MKT_FCST_ENERGY
        --   소스: GT_DMF0003_MKT_FCST_RESULT (RTF/RTF_SYS_RP)
        --   [CSR ID:4023158] + [C20211103-000146] + [C20221207-000080]
        -----------------------------------------------------------------------
        DECLARE
            V_RTF_RESULT_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_RTF_RESULT_CNT
            FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
            WHERE  MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL',
                               'RTF_ENERGY','MKT_FCST_ENERGY');

            IF V_RTF_RESULT_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CAR'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR'
                                    ELSE '' END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
                               CASE WHEN F.MEASURE = 'RTF'        THEN 'RTF_RP_CELL'
                                    WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL'
                                    ELSE '' END
                           WHEN M.MEASURE = 'RTF_ENERGY'      AND F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_ENERGY'
                           WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN 'MKT_FCST_ENERGY'
                       END  AS MEASURE
                     , F.YYYYMMDD
                     , CASE
                           WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY / T2.CELL_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0
                                    AND NVL(T2.CELL_PER_MODULE,0) > 0                                             THEN F.QTY / T2.MODULE_PER_CAR
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0                                    THEN F.QTY
                                   ELSE 0
                               END
                           WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
                               CASE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(T2.CELL_PER_CAR,0)    > 0 THEN F.QTY
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Module') > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_MODULE
                                   WHEN INSTR(T2.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(T2.CELL_PER_MODULE,0) > 0 THEN F.QTY * T2.CELL_PER_CAR
                                   ELSE 0
                               END
                           -- [C20211103-000146] RTF_ENERGY
                           WHEN M.MEASURE = 'RTF_ENERGY' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                           -- [C20221207-000080] MKT_FCST_ENERGY
                           WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
                               CASE WHEN REGEXP_LIKE(NVL(T2.ENERGE,'X'),'^[0-9.]+$')
                                    THEN ROUND(TO_NUMBER(T2.ENERGE) * F.QTY / 1000, 4)
                               END
                       END  AS QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE    IN ('RTF','RTF_SYS_RP') )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND MEASURE     IN ('RTF','RTF_SYS_RP')
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS
                                                  AND  MEASURE    IN ('RTF','RTF_SYS_RP') ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_DMF0003_MKT_FCST_RESULT F
                JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
                  ON   F.MEASURE IN ('RTF','RTF_SYS_RP')
                 AND   M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL',
                                     'RTF_ENERGY','MKT_FCST_ENERGY')
                JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.MEASURE = CASE
                                       WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_RP_CELL')                        THEN 'RTF'
                                       WHEN M.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL',
                                                          'RTF_ENERGY','MKT_FCST_ENERGY')                   THEN 'RTF_SYS_RP'
                                       ELSE M.MEASURE END
                  AND  F.QTY <> 0
                  AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
                  AND  F.YYYYMMDD     < V_TO_RESULT
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-6 END
        END;

        -----------------------------------------------------------------------
        -- Block R-7: MKT_FCST_RP
        --   소스: GT_DMF0003_MKT_FCST_RESULT (RTF → MKT_FCST_RP 표시)
        -----------------------------------------------------------------------
        DECLARE
            V_MFTRP_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_MFTRP_CNT
            FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
            WHERE  MEASURE = 'MKT_FCST_RP';

            IF V_MFTRP_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , 'MKT_FCST_RP'  AS MEASURE   -- RTF 실적 → MKT_FCST_RP 로 표시
                     , F.YYYYMMDD, F.QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , F.ATTRIBUTE10  AS AS_FROM_SITE
                     , ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS
                           AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END )
                     , ( SELECT MAX(LAST_UPDATED_BY) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                         WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                           AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                           AND  DOM_EXP     = F.DOM_EXP      AND FCST_TYPE    = F.FCST_TYPE
                           AND  INCOTERMS   = F.INCOTERMS    AND QTY         <> 0
                           AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END
                           AND  CREATE_DATE = ( SELECT MAX(CREATE_DATE) FROM SCM_MGR.GT_DMF0003_LAST_DATA_SETUP
                                                WHERE  DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE
                                                  AND  SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID      = F.ITEM_ID
                                                  AND  DOM_EXP     = F.DOM_EXP     AND FCST_TYPE     = F.FCST_TYPE
                                                  AND  INCOTERMS   = F.INCOTERMS
                                                  AND  MEASURE     = CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END ) )
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_DMF0003_MKT_FCST_RESULT F
                JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
                  ON   F.MEASURE  = 'RTF'         -- 실적은 RTF
                 AND   M.MEASURE  = 'MKT_FCST_RP' -- → MKT_FCST_RP 로 표시
                JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.QTY <> 0
                  AND  F.YYYYMMDD    >= P_FROM_YYYYMMDD
                  AND  F.YYYYMMDD     < V_TO_RESULT
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-7 END
        END;

        -----------------------------------------------------------------------
        -- Block R-8: IN_TRANSIT
        --   소스: GT_DMF0003_INTRANSIT_DATA
        --   [E20241126-000426] SHIPMENT_PLAN 주석처리됨; IN_TRANSIT만 사용
        --   주의: YYYYMMDD 범위가 p_from_yyyymmdd ~ v_to_yyyymmdd (계획+실적 모두)
        -----------------------------------------------------------------------
        DECLARE
            V_IT_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_IT_CNT
            FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
            WHERE  MEASURE = 'IN_TRANSIT';

            IF V_IT_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DATA
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
                , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
                , CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL
                , APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
                , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                     , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
                     , F.MEASURE
                     , F.YYYYMMDD, F.QTY
                     , M.MEASURE_GROUP
                     , T2.CELL_MODEL
                     , T2.END_CUSTOMER, T2.NICK_NAME, T2.DMS_SALES, T2.DMS_CUSTOMER
                     , T2.OWNER, T2.DEPT_ID, T2.DEPT_NAME_KO
                     , T2.FORECAST_INFO_CELL_PACK_COUNT
                     , T2.ITEM_TYPE, T2.PROJECT_NAME, T2.PROJECT_OWNER, T2.BIZ_TYPE
                     , T2.SOLDTO_CUSTOMER, T2.COUNTRY_NAME, T2.CITY_NAME
                     , T2.PROJECT_STATUS, T2.ITEM_NAME, T2.VMI_YN
                     , T2.CUST_GROUP, T2.CUST_GROUP_DTL, T2.APPLICATION, T2.ROUTE
                     , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY
                     , T2.FORECAST_INFO_BIZ_TYPE, T2.CELL_TYPE
                     , T2.FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                     , T2.CELL_MODEL_NICK_NAME
                     , T2.CELL_PER_CAR, T2.CELL_PER_MODULE, T2.MODULE_PER_CAR
                     , M.SORT_ORDER_NO
                     , T2.ENERGE, T2.CELL_QUANTITY
                     , ''  AS AS_FROM_SITE
                     , ''  AS CREATE_DATE
                     , ''  AS LAST_UPDATED_BY
                     , ( SELECT SENDER_CODE FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                     , ( SELECT SENDER_NAME FROM SCM_MGR.GT_DMF0003_EDI_SENDER
                         WHERE  SCM_SITE_ID = F.SCM_SITE_ID AND ROWNUM = 1 )
                FROM   SCM_MGR.GT_DMF0003_INTRANSIT_DATA F
                JOIN   SCM_MGR.GT_DMF0003_SELECT_MEASURE M
                  ON   F.MEASURE = 'IN_TRANSIT'
                 AND   F.MEASURE = M.MEASURE
                JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM T2
                  ON   F.DIVISION_ID  = T2.DIVISION_ID
                 AND   F.PROJECT_CODE = T2.PROJECT_CODE
                 AND   F.SCM_SITE_ID  = T2.SCM_SITE_ID
                 AND   F.ITEM_ID      = T2.ITEM_ID
                WHERE  F.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  F.DIVISION_ID  = P_DIVISION_ID
                  AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID ELSE F.SCM_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
                  AND  ( CASE WHEN P_PLANT_SITE_ID = 'ALL' THEN P_PLANT_SITE_ID ELSE F.PLANT_SITE_ID END
                         IN (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL)) FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) );
            END IF;  -- R-8 END
        END;

    END IF;  -- 실적 구간 조건 END (V_FROM_YYYYMMDD <= 당주 월요일)

    -----------------------------------------------------------------------
    -- Step 1: GT_DMF0003_MKT_FCST_DATA → GT_DMF0003_MKT_FCST_DST  집계
    --   [E20240712-001683] YYYYMMDD 포함 GROUP BY
    -----------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
    , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD
    , MEASURE_GROUP, FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
    , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
    , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
    , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
    , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
    , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
    , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
    , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
    SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE
         , F.YYYYMMDD
         , MAX(F.MEASURE_GROUP)             AS MEASURE_GROUP
         , MAX(F.CELL_MODEL)               AS FORECAST_INFO_CELL_MODEL
         , MAX(F.END_CUSTOMER)             AS END_CUSTOMER
         , MAX(F.NICK_NAME)               AS NICK_NAME
         , MAX(F.DMS_SALES)               AS DMS_SALES
         , MAX(F.DMS_CUSTOMER)            AS DMS_CUSTOMER
         , MAX(F.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(F.DEPT_ID)                 AS DEPT_ID
         , MAX(F.DEPT_NAME_KO)            AS DEPT_NAME_KO
         , MAX(F.ITEM_TYPE)               AS ITEM_TYPE
         , MAX(F.PROJECT_NAME)            AS PROJECT_NAME
         , MAX(F.PROJECT_OWNER)           AS PROJECT_OWNER
         , MAX(F.OWNER)                   AS OWNER
         , MAX(F.BIZ_TYPE)               AS BIZ_TYPE
         , MAX(F.SOLDTO_CUSTOMER)         AS SOLDTO_CUSTOMER
         , MAX(F.COUNTRY_NAME)            AS COUNTRY_NAME
         , MAX(F.CITY_NAME)              AS CITY_NAME
         , MAX(F.PROJECT_STATUS)          AS PROJECT_STATUS
         , MAX(F.ITEM_NAME)              AS ITEM_NAME
         , MAX(F.VMI_YN)                 AS VMI_YN
         , MAX(F.CUST_GROUP)             AS CUST_GROUP
         , MAX(F.CUST_GROUP_DTL)         AS CUST_GROUP_DTL
         , MAX(F.APPLICATION)            AS APPLICATION
         , MAX(F.ROUTE)                  AS ROUTE
         , MAX(F.MDM_PROJECT_NAME)       AS MDM_PROJECT_NAME
         , MAX(F.MIN_CAPACITY)           AS MIN_CAPACITY
         , MAX(F.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
         , MAX(F.CELL_TYPE)              AS CELL_TYPE
         , MAX(F.FORECAST_INFO_ALL)      AS FORECAST_INFO_ALL
         , MAX(F.FORECAST_INFO_SPEC)     AS FORECAST_INFO_SPEC
         , MAX(F.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
         , MAX(F.CELL_MODEL_NICK_NAME)   AS CELL_MODEL_NICK_NAME
         , MAX(F.CELL_PER_CAR)           AS CELL_PER_CAR
         , MAX(F.CELL_PER_MODULE)        AS CELL_PER_MODULE
         , MAX(F.MODULE_PER_CAR)         AS MODULE_PER_CAR
         , MAX(F.SORT_ORDER_NO)          AS SORT_ORDER_NO
         , MAX(F.ENERGE)                 AS ENERGE
         , MAX(F.CELL_QUANTITY)          AS CELL_QUANTITY
         , MAX(F.AS_FROM_SITE)           AS AS_FROM_SITE
         , MAX(F.CREATE_DATE)            AS CREATE_DATE
         , MAX(F.LAST_UPDATED_BY)        AS LAST_UPDATED_BY
         , MAX(F.SENDER_CODE)            AS SENDER_CODE
         , MAX(F.SENDER_NAME)            AS SENDER_NAME
    FROM   SCM_MGR.GT_DMF0003_MKT_FCST_DATA F
    GROUP  BY F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
           ,  F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD;

    -----------------------------------------------------------------------
    -- Step 2: Division 82, MKT_FCST_RP 선택 + VMI 사이트 존재 시
    --         빠진 메저(RTF_SYS_RP, VMI_In_Plan/Req, VMI_Inv, MKT_FCST_RP) 행 보완
    --   [C20201103-000114]
    -----------------------------------------------------------------------
    DECLARE
        V_MKT_FCST_RP_VMI_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_MKT_FCST_RP_VMI_CNT
        FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE A
        WHERE  A.MEASURE = 'MKT_FCST_RP'
          AND  P_DIVISION_ID = '82'
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0003_MKT_FCST_DST D
                   JOIN   SCM_MGR.SCM_MST_SITE B
                     ON   D.DIVISION_ID = B.DIVISION_ID
                    AND   D.SCM_SITE_ID = B.SCM_SITE_ID
                    AND   B.VMI_YN      = 'Y'
                   WHERE  D.MEASURE     = 'MKT_FCST_RP'
               );

        IF V_MKT_FCST_RP_VMI_CNT > 0 THEN
            -- VMI 사이트 × 빠진 메저 조합 보완
            INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DST
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
            , DOM_EXP, FCST_TYPE, INCOTERMS
            , MEASURE, MEASURE_GROUP
            , FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
            , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
            , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
            , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
            , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
            , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
            , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
            , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
            , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
            , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                 , A.MEASURE, A.MEASURE_GROUP
                 , A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
                 , A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT
                 , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER
                 , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
                 , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
                 , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
                 , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
                 , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
                 , REPLACE(D.SORT_ORDER_NO, '.0', A.SORTKEY)  AS SORT_ORDER_NO
                 , A.ENERGE, A.CELL_QUANTITY
                 , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
            FROM (
                -- VMI 사이트 기반 DISTINCT 헤더
                SELECT B2.MEASURE    AS MEASURE
                     , B2.MEASURE_GROUP
                     , B2.SORTKEY
                     , A2.*
                FROM (
                    SELECT DISTINCT
                           A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                         , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
                         , A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                         , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
                         , A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
                         , A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
                         , A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
                         , A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
                         , A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                         , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                         , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                         , A2.ENERGE, A2.CELL_QUANTITY
                         , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                    FROM   SCM_MGR.GT_DMF0003_MKT_FCST_DST A2
                    JOIN   SCM_MGR.SCM_MST_SITE S
                      ON   A2.DIVISION_ID = S.DIVISION_ID
                     AND   A2.SCM_SITE_ID = S.SCM_SITE_ID
                     AND   S.VMI_YN       = 'Y'
                ) A2,
                (
                    SELECT 'MKT_FCST_RP' AS MEASURE_GROUP, 'MKT_FCST_RP' AS MEASURE, '.9' AS SORTKEY FROM DUAL UNION ALL
                    SELECT 'RTF_SYS_RP'  AS MEASURE_GROUP, 'RTF_SYS_RP'  AS MEASURE, '.1' FROM DUAL UNION ALL
                    SELECT 'VMI_In_Plan' AS MEASURE_GROUP, 'VMI_In_Plan' AS MEASURE, '.2' FROM DUAL UNION ALL
                    SELECT 'VMI_In_Req'  AS MEASURE_GROUP, 'VMI_In_Req'  AS MEASURE, '.3' FROM DUAL UNION ALL
                    SELECT 'VMI_Inv'     AS MEASURE_GROUP, 'VMI_Inv'     AS MEASURE, '.4' FROM DUAL
                ) B2
            ) A
            -- 이미 GT_DMF0003_MKT_FCST_DST에 존재하는 조합은 제외
            LEFT OUTER JOIN SCM_MGR.GT_DMF0003_MKT_FCST_DST C
              ON  A.DIVISION_ID    = C.DIVISION_ID
             AND  A.PROJECT_CODE   = C.PROJECT_CODE
             AND  A.SCM_SITE_ID    = C.SCM_SITE_ID
             AND  A.PLANT_SITE_ID  = C.PLANT_SITE_ID
             AND  A.ITEM_ID        = C.ITEM_ID
             AND  A.DOM_EXP        = C.DOM_EXP
             AND  A.FCST_TYPE      = C.FCST_TYPE
             AND  A.INCOTERMS      = C.INCOTERMS
             AND  A.MEASURE        = C.MEASURE
             AND  A.MEASURE_GROUP  = C.MEASURE_GROUP
            LEFT OUTER JOIN SCM_MGR.GT_DMF0003_SELECT_MEASURE D
              ON  A.MEASURE = D.MEASURE AND A.MEASURE_GROUP = D.MEASURE_GROUP
            WHERE C.MEASURE IS NULL
            ORDER BY A.INCOTERMS, A.MEASURE;
        END IF;
    END;

    -----------------------------------------------------------------------
    -- Step 3: Division 82 + P_INVALID_EXEC='N'
    --         → GT_DMF0003_SALES_PRICE 수집 (mapping 미등록 Sales Price 제공)
    --   [C20200612-000174]
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' THEN

        -- LOC measure → MKT_FCST_RP, BNPIn(상품/전극) 행 수집
        INSERT INTO SCM_MGR.GT_DMF0003_SALES_PRICE
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS
        , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY, COUNTRY_NAME, CITY, CITY_NAME
        , OWNER, PROJECT_OWNER, USER_ID, ITEM_NAME, ITEM_TYPE
        , PROJECT_STATUS, NICK_NAME, DEPT_ID, DEPT_NAME_KO, VMI_YN
        , PROJECT_NAME, END_CUSTOMER, ENERGE, CELL_QUANTITY
        , MEASURE, MEASURE_GROUP, SORT_ORDER_NO )
        SELECT DISTINCT
               A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY, B.COUNTRY_NAME, B.CITY, B.CITY_NAME
             , B.OWNER, B.PROJECT_OWNER, B.USER_ID, B.ITEM_NAME, B.ITEM_TYPE
             , B.PROJECT_STATUS, B.NICK_NAME, B.DEPT_ID, B.DEPT_NAME_KO, B.VMI_YN
             , B.PROJECT_NAME, B.END_CUSTOMER, B.ENERGE, B.CELL_QUANTITY
             , 'MKT_FCST_RP'  AS MEASURE
             , 'MKT_FCST_RP'  AS MEASURE_GROUP
             , CASE WHEN NVL(B.VMI_YN,'N') <> 'Y' THEN '00.0' ELSE '.9' END  AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM B
          ON   A.DIVISION_ID  = B.DIVISION_ID
         AND   A.PROJECT_CODE = B.PROJECT_CODE
         AND   A.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   A.ITEM_ID      = B.ITEM_ID
         AND   ( A.FCST_TYPE IS NOT NULL OR A.FCST_TYPE   <> '' )
        WHERE  A.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND  A.MEASURE     = 'LOC'
          AND  A.FCST_TYPE  <> 'ETC'    -- [C20200702-000136] ETC 제외

        UNION ALL

        SELECT DISTINCT
               A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY, B.COUNTRY_NAME, B.CITY, B.CITY_NAME
             , B.OWNER, B.PROJECT_OWNER, B.USER_ID, B.ITEM_NAME, B.ITEM_TYPE
             , B.PROJECT_STATUS, B.NICK_NAME, B.DEPT_ID, B.DEPT_NAME_KO, B.VMI_YN
             , B.PROJECT_NAME, B.END_CUSTOMER, B.ENERGE, B.CELL_QUANTITY
             , 'BNPIn'  AS MEASURE
             , 'BNPIn'  AS MEASURE_GROUP
             , '00.0'   AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        JOIN   SCM_MGR.GT_DMF0003_SITE_ITEM B
          ON   A.DIVISION_ID  = B.DIVISION_ID
         AND   A.PROJECT_CODE = B.PROJECT_CODE
         AND   A.SCM_SITE_ID  = B.SCM_SITE_ID
         AND   A.ITEM_ID      = B.ITEM_ID
         AND   ( A.FCST_TYPE IS NOT NULL OR A.FCST_TYPE   <> '' )
         AND   B.ITEM_TYPE   IN ('Q','R')  -- 상품/전극만
        WHERE  A.YYYYMMDD   BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND  A.MEASURE     = 'LOC'
          AND  A.FCST_TYPE  <> 'ETC';

        -- SORT_ORDER_NO: GT_DMF0003_SELECT_MEASURE 기준으로 업데이트
        UPDATE SCM_MGR.GT_DMF0003_SALES_PRICE A
        SET    A.SORT_ORDER_NO = (
                   SELECT B.SORT_ORDER_NO
                   FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE B
                   WHERE  A.MEASURE       = B.MEASURE
                     AND  A.MEASURE_GROUP = B.MEASURE_GROUP
                     AND  ROWNUM          = 1 );

        -- VMI/RTF/MKT_FCST_RP 계열 SORT_ORDER_NO 소수점 자리 조정
        UPDATE SCM_MGR.GT_DMF0003_SALES_PRICE
        SET    SORT_ORDER_NO =
               CASE WHEN MEASURE = 'RTF_SYS_RP'  THEN REPLACE(SORT_ORDER_NO, '.0', '.1')
                    WHEN MEASURE = 'VMI_In_Plan'  THEN REPLACE(SORT_ORDER_NO, '.0', '.2')
                    WHEN MEASURE = 'VMI_In_Req'   THEN REPLACE(SORT_ORDER_NO, '.0', '.3')
                    WHEN MEASURE = 'VMI_Inv'      THEN REPLACE(SORT_ORDER_NO, '.0', '.4')
                    WHEN MEASURE = 'MKT_FCST_RP'  THEN REPLACE(SORT_ORDER_NO, '.0', '.9')
               END
        WHERE  MEASURE IN ('MKT_FCST_RP','RTF_SYS_RP','VMI_In_Plan','VMI_In_Req','VMI_Inv');

    END IF;

    -----------------------------------------------------------------------
    -- Step 4: LP_AS_YN='Y' → AS_IN_REQ/PLAN/INV 빈 행 GT_DMF0003_MKT_FCST_DST에 추가
    --   조건: AS_SITE_PLANT LOOKUP에 있는 SCM_SITE_ID인 데이터 중
    --         아직 GT_DMF0003_MKT_FCST_DATA에 AS 메저가 없는 조합 삽입
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' AND LP_AS_YN = 'Y' THEN
        DECLARE
            V_AS_MEA_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_AS_MEA_CNT
            FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
            WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV');

            IF V_AS_MEA_CNT > 0 THEN
                INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DST
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, MEASURE_GROUP
                , FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME
                , DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT
                , DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
                , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
                , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
                , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
                , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
                , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                     , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                     , C.MEASURE, C.MEASURE_GROUP
                     , A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
                     , A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT
                     , A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER
                     , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
                     , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
                     , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
                     , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
                     , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
                     , C.SORT_ORDER_NO
                     , A.ENERGE, A.CELL_QUANTITY
                     , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
                FROM (
                    -- AS_SITE_PLANT LOOKUP에 있는 SCM_SITE_ID 기반 DST 헤더 (중복 제거)
                    SELECT A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                         , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS, A2.MEASURE, A2.MEASURE_GROUP
                         , A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                         , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
                         , A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
                         , A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
                         , A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
                         , A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
                         , A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                         , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                         , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                         , A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                         , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                    FROM   SCM_MGR.GT_DMF0003_MKT_FCST_DST A2
                    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B2
                      ON   A2.SCM_SITE_ID = B2.SEGMENT1
                     AND   B2.LOOKUP_TYPE = 'AS_SITE_PLANT'
                     AND   B2.SEGMENT3    = P_DIVISION_ID
                    GROUP  BY A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                           ,  A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS, A2.MEASURE, A2.MEASURE_GROUP
                           ,  A2.FORECAST_INFO_CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                           ,  A2.DMS_SALES, A2.DMS_CUSTOMER, A2.FORECAST_INFO_CELL_PACK_COUNT
                           ,  A2.DEPT_ID, A2.DEPT_NAME_KO, A2.ITEM_TYPE, A2.PROJECT_NAME
                           ,  A2.PROJECT_OWNER, A2.OWNER, A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER
                           ,  A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS, A2.ITEM_NAME
                           ,  A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL, A2.APPLICATION, A2.ROUTE
                           ,  A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY, A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                           ,  A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                           ,  A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                           ,  A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                           ,  A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                ) A
                -- AS_IN_REQ/PLAN/INV 메저 목록 (CROSS JOIN)
                JOIN (
                    SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO
                    FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
                    WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV')
                ) C ON 1=1
                -- 이미 GT_DMF0003_MKT_FCST_DATA에 AS 메저가 있는 조합은 제외
                LEFT OUTER JOIN (
                    SELECT DISTINCT
                           D2.DIVISION_ID, D2.PROJECT_CODE, D2.SCM_SITE_ID, D2.ITEM_ID
                         , D2.DOM_EXP, D2.FCST_TYPE, D2.INCOTERMS, D2.MEASURE, D2.PLANT_SITE_ID
                    FROM   SCM_MGR.GT_DMF0003_MKT_FCST_DATA D2
                    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B3
                      ON   D2.SCM_SITE_ID = B3.SEGMENT1
                     AND   B3.LOOKUP_TYPE = 'AS_SITE_PLANT'
                     AND   B3.SEGMENT3    = P_DIVISION_ID
                ) D ON  A.DIVISION_ID   = D.DIVISION_ID
                    AND A.PROJECT_CODE  = D.PROJECT_CODE
                    AND A.SCM_SITE_ID   = D.SCM_SITE_ID
                    AND A.ITEM_ID       = D.ITEM_ID
                    AND A.DOM_EXP       = D.DOM_EXP
                    AND A.FCST_TYPE     = D.FCST_TYPE
                    AND A.INCOTERMS     = D.INCOTERMS
                    AND C.MEASURE       = D.MEASURE
                    AND A.PLANT_SITE_ID = D.PLANT_SITE_ID
                WHERE D.DIVISION_ID IS NULL;
            END IF;
        END;
   END IF;

    -----------------------------------------------------------------------
    -- Step 5: Division 82 VMI 재고계산  [E20240102-000545]
    --   5-1) GT_DMF0003_VMI_INV: RANK=1(최신 일자) 행 추출
    --   5-2) DELETE: VMI_INV 일자 이후에 MKT_FCST/VMI_In_Plan/VMI_In_Req 있는 경우 제거
    --   5-3) DELETE: MKT_FCST/VMI_In_Plan/VMI_In_Req 행 삭제 (VMI_INV만 남김)
    --   5-4) GT_DMF0003_VMI_INV_RESULT: GT_DMF0003_MKT_FCST_DATA와 JOIN → 헤더 정보 붙임
    --   5-5) PERIOD 기간만큼 GT_DMF0003_VMI_INV_RESULT 확장
    --   5-6) 원본 VMI_INV 날짜 행 삭제 (모수 제거)
    --   5-7) GT_DMF0003_MKT_FCST_DATA에 최종 INSERT
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' THEN

        -- 5-1) 최신 날짜 VMI 관련 데이터 추출 (RANK=1)
        DELETE FROM SCM_MGR.GT_DMF0003_VMI_INV;
        DELETE FROM SCM_MGR.GT_DMF0003_VMI_INV_RESULT;

        INSERT INTO SCM_MGR.GT_DMF0003_VMI_INV
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
             , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        FROM (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                 , RANK() OVER (
                       PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                    DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE
                       ORDER BY YYYYMMDD DESC
                   ) AS SEQ
            FROM (
                -- 계획 테이블
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                     , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                FROM   SCM_MGR.DM_PLN_MKT_FCST
                WHERE  DIVISION_ID = P_DIVISION_ID
                  AND  MEASURE    IN ('VMI_INV','MKT_FCST','VMI_In_Plan','VMI_In_Req')
                  AND  QTY        <> 0
                  AND  YYYYMMDD  BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                UNION ALL
                -- 실적 테이블 (RESULT): 당주 월요일 이전까지
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                     , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
                     , SUM(QTY) AS QTY   -- [PJ2025-50188] CELL_PROD_SITE_ID 제거 후 집계
                FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT
                WHERE  DIVISION_ID = P_DIVISION_ID
                  AND  MEASURE    IN ('VMI_INV','MKT_FCST','VMI_In_Plan','VMI_In_Req')
                  AND  QTY        <> 0
                  AND  YYYYMMDD  >= P_FROM_YYYYMMDD
                  AND  YYYYMMDD   < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
                GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                       ,  DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
            ) A
        ) B
        WHERE SEQ = 1;

        -- 5-2) VMI_INV 일자 이후에 MKT_FCST 계열이 있는 경우 → VMI_INV 행 제거
        DELETE FROM SCM_MGR.GT_DMF0003_VMI_INV C
        WHERE EXISTS (
            SELECT 1
            FROM (
                SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
                     , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                FROM   SCM_MGR.GT_DMF0003_VMI_INV A    -- VMI_INV
                JOIN   SCM_MGR.GT_DMF0003_VMI_INV B    -- MKT_FCST 계열
                  ON   A.DIVISION_ID   = B.DIVISION_ID
                 AND   A.PROJECT_CODE  = B.PROJECT_CODE
                 AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
                 AND   A.ITEM_ID       = B.ITEM_ID
                 AND   A.DOM_EXP       = B.DOM_EXP
                 AND   A.FCST_TYPE     = B.FCST_TYPE
                 AND   A.INCOTERMS     = B.INCOTERMS
                 AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
                 AND   A.MEASURE       = 'VMI_INV'
                 AND   B.MEASURE      IN ('MKT_FCST','VMI_In_Plan','VMI_In_Req')
                 AND   B.YYYYMMDD     >= A.YYYYMMDD + 1
            ) T
            WHERE C.DIVISION_ID   = T.DIVISION_ID
              AND C.PROJECT_CODE  = T.PROJECT_CODE
              AND C.SCM_SITE_ID   = T.SCM_SITE_ID
              AND C.ITEM_ID       = T.ITEM_ID
              AND C.DOM_EXP       = T.DOM_EXP
              AND C.FCST_TYPE     = T.FCST_TYPE
              AND C.INCOTERMS     = T.INCOTERMS
              AND C.PLANT_SITE_ID = T.PLANT_SITE_ID
        );

        -- 5-3) MKT_FCST/VMI_In_Plan/VMI_In_Req 행 삭제 → VMI_INV만 남김
        DELETE FROM SCM_MGR.GT_DMF0003_VMI_INV
        WHERE  MEASURE IN ('MKT_FCST','VMI_In_Plan','VMI_In_Req');

        -- 5-4) GT_DMF0003_MKT_FCST_DATA와 JOIN하여 헤더 정보 포함 → GT_DMF0003_VMI_INV_RESULT
        INSERT INTO SCM_MGR.GT_DMF0003_VMI_INV_RESULT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
        , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
        , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID, A.QTY
             , B.MEASURE_GROUP, B.CELL_MODEL, B.END_CUSTOMER, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER
             , B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT
             , B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER
             , B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN
             , B.CUST_GROUP, B.CUST_GROUP_DTL, B.MDM_PROJECT_NAME, B.MIN_CAPACITY
             , B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC
             , B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE
             , B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY
             , B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME
        FROM   SCM_MGR.GT_DMF0003_VMI_INV A
        JOIN   SCM_MGR.GT_DMF0003_MKT_FCST_DATA B
          ON   A.DIVISION_ID   = B.DIVISION_ID
         AND   A.PROJECT_CODE  = B.PROJECT_CODE
         AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
         AND   A.ITEM_ID       = B.ITEM_ID
         AND   A.DOM_EXP       = B.DOM_EXP
         AND   A.FCST_TYPE     = B.FCST_TYPE
         AND   A.INCOTERMS     = B.INCOTERMS
         AND   A.MEASURE       = B.MEASURE
         AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
         AND   A.YYYYMMDD      = B.YYYYMMDD;

        -- 5-5) PERIOD 기간만큼 GT_DMF0003_VMI_INV_RESULT 행 확장
        --       (원본 날짜 이후의 모든 날짜에 동일 QTY 행 생성)
        INSERT INTO SCM_MGR.GT_DMF0003_VMI_INV_RESULT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
        , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
        , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT DISTINCT
               B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID
             , B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE
             , A.BASIS_YYYYMMDD  AS YYYYMMDD   -- 캘린더 날짜로 확장
             , B.PLANT_SITE_ID, B.QTY
             , B.MEASURE_GROUP, B.CELL_MODEL, B.END_CUSTOMER, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER
             , B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT
             , B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER
             , B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN
             , B.CUST_GROUP, B.CUST_GROUP_DTL, B.MDM_PROJECT_NAME, B.MIN_CAPACITY
             , B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC
             , B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE
             , B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY
             , B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        LEFT   OUTER JOIN SCM_MGR.GT_DMF0003_VMI_INV_RESULT B
          ON   A.BASIS_YYYYMMDD > B.YYYYMMDD   -- 원본 날짜 이후 모든 날짜
        WHERE  A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND  A.BASIS_YYYYMMDD > B.YYYYMMDD;

        -- 5-6) 원본 VMI_INV 날짜 행 삭제 (모수 제거)
        DELETE FROM SCM_MGR.GT_DMF0003_VMI_INV_RESULT A
        WHERE  DIVISION_ID = '82'
          AND  MEASURE     = 'VMI_INV'
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0003_VMI_INV Z
                   WHERE  A.DIVISION_ID   = Z.DIVISION_ID
                     AND  A.PROJECT_CODE  = Z.PROJECT_CODE
                     AND  A.SCM_SITE_ID   = Z.SCM_SITE_ID
                     AND  A.ITEM_ID       = Z.ITEM_ID
                     AND  A.DOM_EXP       = Z.DOM_EXP
                     AND  A.FCST_TYPE     = Z.FCST_TYPE
                     AND  A.INCOTERMS     = Z.INCOTERMS
                     AND  A.PLANT_SITE_ID = Z.PLANT_SITE_ID
                     AND  A.YYYYMMDD      = Z.YYYYMMDD
               );

        -- 5-7) GT_DMF0003_MKT_FCST_DATA에 VMI_INV 보완 행 INSERT
        INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DATA
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
        , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
        , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
        , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
        , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
        , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
        , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
        , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
        , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
        , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
             , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
             , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
             , OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
             , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
             , COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
             , CUST_GROUP, CUST_GROUP_DTL
             , NULL  AS APPLICATION   -- GT_DMF0003_VMI_INV_RESULT에 APPLICATION/ROUTE 없음
             , NULL  AS ROUTE
             , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
             , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
             , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
             , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
             , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
        FROM   SCM_MGR.GT_DMF0003_VMI_INV_RESULT;

    END IF;  -- Division 82 VMI 재고계산 END

    -----------------------------------------------------------------------
    -- Step 6: NOTATION 컬럼 업데이트  [E20240812-000094]
    --   DM_MEASURE_POSITIONAL_NOTATION LOOKUP → MEASURE별 소수점 표기형태 설정
    -----------------------------------------------------------------------
    UPDATE SCM_MGR.GT_DMF0003_MKT_FCST_DATA A
    SET    A.NOTATION = NVL(
               ( SELECT C.SEGMENT3
                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
                 WHERE  C.LOOKUP_TYPE = 'DM_MEASURE_POSITIONAL_NOTATION'
                   AND  A.MEASURE     = C.SEGMENT2
                   AND  A.DIVISION_ID = C.SEGMENT1
                   AND  ROWNUM        = 1 ),
               'DEFAULT' );

    -----------------------------------------------------------------------
    -- 팀 WHERE 조건 생성 (FN_SCM_GET_WHERE_SQL → 인라인 변환)
    -----------------------------------------------------------------------
    IF P_TEAM_ID = 'ALL' THEN
        V_TEAM_WHERE := '1=1';
    ELSE
        -- P_TEAM_ID 가 콤마 구분 목록일 경우 IN 절 생성
        V_TEAM_WHERE := 'A.DEPT_ID IN ('''
                     || REPLACE(P_TEAM_ID, ',', ''',''')
                     || ''')';
    END IF;

    -----------------------------------------------------------------------
    -- 분기: Division 82 + P_INVALID_EXEC='N'  → PIVOT SQL #1 (AS용)
    --        그 외                             → AS_IN_REQ 보완 + PIVOT SQL #2
    -----------------------------------------------------------------------
    IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' THEN

        -- -----------------------------------------------------------------------
        -- PIVOT SQL #1 (AS용)
        --   소스: GT_DMF0003_SALES_PRICE  FULL OUTER JOIN  GT_DMF0003_MKT_FCST_DST
        --         → GT_DMF0003_MF (임시 조인 결과)
        --         → PIVOT + EXECUTE IMMEDIATE → O_RC
        -- -----------------------------------------------------------------------
        V_SQL_TEXT :=
        'WITH MF_BASE AS (' || CHR(10) ||
        'SELECT' || CHR(10) ||
        '      A.DIVISION_ID' || CHR(10) ||
        '    , A.DIVISION_ID                                         AS DIVISION_ID40' || CHR(10) ||
        '    , CASE WHEN ''' || LP_AS_YN || ''' = ''Y'' THEN NVL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY' || CHR(10) ||
        '    , A.SCM_SITE_ID' || CHR(10) ||
        '    , A.SCM_SITE_ID                                         AS SCM_SITE_ID40' || CHR(10) ||
        '    , A.PLANT_SITE_ID' || CHR(10) ||
        '    , A.PROJECT_CODE' || CHR(10) ||
        '    , NVL(I.GROUP_ID,'''')                                  AS GROUP_ID' || CHR(10) ||
        '    , A.ITEM_ID' || CHR(10) ||
        '    , A.ITEM_ID                                             AS ITEM_ID40' || CHR(10) ||
        '    , A.INCOTERMS' || CHR(10) ||
        '    , A.FCST_TYPE' || CHR(10) ||
        '    , A.DOM_EXP' || CHR(10) ||
        '    , A.MEASURE' || CHR(10) ||
        '    , A.END_CUSTOMER' || CHR(10) ||
        '    , CASE WHEN (A.DIVISION_ID LIKE ''81%'' OR A.DIVISION_ID = ''82'')' || CHR(10) ||
        '           THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END      AS END_CUSTOMER40' || CHR(10) ||
        '    , A.NICK_NAME' || CHR(10) ||
        '    , A.DMS_SALES' || CHR(10) ||
        '    , A.DMS_CUSTOMER' || CHR(10) ||
        '    , C.BASIS_YYYYMM                                        AS YYYYMM' || CHR(10) ||
        '    , C.BASIS_YYYYMM || C.ISO_WEEK                          AS YYYYMMWW' || CHR(10) ||
        '    , C.BASIS_YYYYMMDD                                      AS YYYYMMDD' || CHR(10) ||
        '    , C.DAYOFWEEK' || CHR(10) ||
        '    , A.FORECAST_INFO_CELL_MODEL' || CHR(10) ||
        '    , A.DEPT_ID                                             AS TEAM_ID' || CHR(10) ||
        '    , A.DEPT_NAME_KO                                        AS TEAM_NAME_KO' || CHR(10) ||
        '    , A.ITEM_TYPE' || CHR(10) ||
        '    , A.PROJECT_NAME' || CHR(10) ||
        '    , A.PROJECT_OWNER' || CHR(10) ||
        '    , A.OWNER' || CHR(10) ||
        '    , A.BIZ_TYPE' || CHR(10) ||
        '    , A.SOLDTO_CUSTOMER' || CHR(10) ||
        '    , A.COUNTRY_NAME' || CHR(10) ||
        '    , A.CITY_NAME' || CHR(10) ||
        '    , A.PROJECT_STATUS' || CHR(10) ||
        '    , A.ITEM_NAME' || CHR(10) ||
        '    , A.VMI_YN' || CHR(10) ||
        '    , A.CUST_GROUP' || CHR(10) ||
        '    , A.CUST_GROUP_DTL' || CHR(10) ||
        '    , A.APPLICATION' || CHR(10) ||
        '    , A.ROUTE' || CHR(10) ||
        '    , A.MDM_PROJECT_NAME' || CHR(10) ||
        '    , A.MIN_CAPACITY' || CHR(10) ||
        '    , A.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '    , A.CELL_TYPE' || CHR(10) ||
        '    , A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '    , A.FORECAST_INFO_ALL' || CHR(10) ||
        '    , A.FORECAST_INFO_SPEC' || CHR(10) ||
        '    , A.FORECAST_INFOR_VERSION' || CHR(10) ||
        '    , A.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '    , CAST(CASE WHEN ''Y'' = ''[@CellQtyYN]''' || CHR(10) ||
        '                 AND A.MEASURE_GROUP NOT IN (''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'')' || CHR(10) ||
        '                 AND NVL(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1' || CHR(10) ||
        '                THEN D.QTY * A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '                ELSE D.QTY END AS NUMBER(10)) AS QTY' || CHR(10) ||
        '    , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN' || CHR(10) ||
        '    , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN' || CHR(10) ||
        '    , CASE' || CHR(10) ||
        '          WHEN MA.DEPT_ID IS NOT NULL' || CHR(10) ||
        '               AND A.MEASURE_GROUP NOT IN (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'')' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN ''[@v_group_id]'' = ''ADMIN''' || CHR(10) ||
        '               AND A.MEASURE_GROUP <> ''TMM_FCST''' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN A.MEASURE_GROUP = ''TMM_FCST''' || CHR(10) ||
        '               AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          ELSE ''N''' || CHR(10) ||
        '      END AS EDIT_FLAG' || CHR(10) ||
        '    , A.CELL_PER_CAR' || CHR(10) ||
        '    , A.CELL_PER_MODULE' || CHR(10) ||
        '    , A.MODULE_PER_CAR' || CHR(10) ||
        '    , A.SORT_ORDER_NO' || CHR(10) ||
        '    , A.MEASURE_GROUP' || CHR(10) ||
        '    , A.ENERGE' || CHR(10) ||
        '    , A.CELL_QUANTITY' || CHR(10) ||
        '    , A.NEW_FLAG' || CHR(10) ||
        '    , NVL(VM.VMI_VAL,'''')                                  AS VMI_STD_DIO' || CHR(10) ||
        '    , NVL(B1.ATTR1, B2.ATTR1)                              AS ATTR1' || CHR(10) ||
        '    , NVL(BK.BUCKET,''0000000'')                           AS BUCKET' || CHR(10) ||
        '    , A.AS_YN' || CHR(10) ||
        '    , A.AS_FROM_SITE' || CHR(10) ||
        '    , CASE WHEN A.CREATE_DATE IS NULL OR NVL(A.CREATE_DATE,'''')    = '''' THEN '' '' ELSE A.CREATE_DATE    END AS LAST_UPDATE_DATE' || CHR(10) ||
        '    , CASE WHEN A.LAST_UPDATED_BY IS NULL OR NVL(A.LAST_UPDATED_BY,'''')= '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY' || CHR(10) ||
        '    , CASE WHEN A.SENDER_CODE IS NULL OR NVL(A.SENDER_CODE,'''')    = '''' THEN '' '' ELSE A.SENDER_CODE    END AS SENDER_CODE' || CHR(10) ||
        '    , CASE WHEN A.SENDER_NAME IS NULL OR NVL(A.SENDER_NAME,'''')    = '''' THEN '' '' ELSE A.SENDER_NAME    END AS SENDER_NAME' || CHR(10) ||
        '    , CASE WHEN 1 = 2 THEN '' '' END AS NOTATION' || CHR(10) ||
        'FROM (' || CHR(10) ||
        '    SELECT' || CHR(10) ||
        '          NVL(M.DIVISION_ID,  P.DIVISION_ID)                AS DIVISION_ID' || CHR(10) ||
        '        , NVL(M.PROJECT_CODE, P.PROJECT_CODE)               AS PROJECT_CODE' || CHR(10) ||
        '        , NVL(M.SCM_SITE_ID,  P.SCM_SITE_ID)                AS SCM_SITE_ID' || CHR(10) ||
        '        , NVL(M.PLANT_SITE_ID,P.PLANT_SITE_ID)              AS PLANT_SITE_ID' || CHR(10) ||
        '        , NVL(M.ITEM_ID,      P.ITEM_ID)                    AS ITEM_ID' || CHR(10) ||
        '        , NVL(M.DOM_EXP,      P.DOM_EXP)                    AS DOM_EXP' || CHR(10) ||
        '        , NVL(M.FCST_TYPE,    P.FCST_TYPE)                  AS FCST_TYPE' || CHR(10) ||
        '        , NVL(M.INCOTERMS,    P.INCOTERMS)                  AS INCOTERMS' || CHR(10) ||
        '        , CASE WHEN P.MEASURE IS NOT NULL OR NVL(P.MEASURE,'''') <> '''' THEN P.MEASURE' || CHR(10) ||
        '               WHEN M.MEASURE IS NULL THEN ''MKT_FCST_RP''' || CHR(10) ||
        '               ELSE M.MEASURE END                           AS MEASURE' || CHR(10) ||
        '        , CASE WHEN P.MEASURE_GROUP IS NOT NULL OR NVL(P.MEASURE_GROUP,'''') <> '''' THEN P.MEASURE_GROUP' || CHR(10) ||
        '               WHEN M.MEASURE_GROUP IS NULL THEN ''MKT_FCST_RP''' || CHR(10) ||
        '               ELSE M.MEASURE_GROUP END                     AS MEASURE_GROUP' || CHR(10) ||
        '        , M.FORECAST_INFO_CELL_MODEL' || CHR(10) ||
        '        , NVL(M.END_CUSTOMER,   P.END_CUSTOMER)             AS END_CUSTOMER' || CHR(10) ||
        '        , NVL(M.NICK_NAME,      P.NICK_NAME)                AS NICK_NAME' || CHR(10) ||
        '        , M.DMS_SALES' || CHR(10) ||
        '        , M.DMS_CUSTOMER' || CHR(10) ||
        '        , M.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '        , NVL(M.DEPT_ID,        P.DEPT_ID)                  AS DEPT_ID' || CHR(10) ||
        '        , NVL(M.DEPT_NAME_KO,   P.DEPT_NAME_KO)             AS DEPT_NAME_KO' || CHR(10) ||
        '        , NVL(M.ITEM_TYPE,      P.ITEM_TYPE)                AS ITEM_TYPE' || CHR(10) ||
        '        , NVL(M.PROJECT_NAME,   P.PROJECT_NAME)             AS PROJECT_NAME' || CHR(10) ||
        '        , NVL(M.PROJECT_OWNER,  P.PROJECT_OWNER)            AS PROJECT_OWNER' || CHR(10) ||
        '        , NVL(M.OWNER,          P.OWNER)                    AS OWNER' || CHR(10) ||
        '        , NVL(M.BIZ_TYPE,       P.BIZ_TYPE)                 AS BIZ_TYPE' || CHR(10) ||
        '        , NVL(M.SOLDTO_CUSTOMER,P.SOLDTO_CUSTOMER)          AS SOLDTO_CUSTOMER' || CHR(10) ||
        '        , NVL(M.COUNTRY_NAME,   P.COUNTRY_NAME)             AS COUNTRY_NAME' || CHR(10) ||
        '        , NVL(M.CITY_NAME,      P.CITY_NAME)                AS CITY_NAME' || CHR(10) ||
        '        , NVL(M.PROJECT_STATUS, P.PROJECT_STATUS)           AS PROJECT_STATUS' || CHR(10) ||
        '        , NVL(M.ITEM_NAME,      P.ITEM_NAME)                AS ITEM_NAME' || CHR(10) ||
        '        , NVL(M.VMI_YN,         P.VMI_YN)                   AS VMI_YN' || CHR(10) ||
        '        , M.CUST_GROUP' || CHR(10) ||
        '        , M.CUST_GROUP_DTL' || CHR(10) ||
        '        , M.APPLICATION' || CHR(10) ||
        '        , M.ROUTE' || CHR(10) ||
        '        , M.MDM_PROJECT_NAME' || CHR(10) ||
        '        , M.MIN_CAPACITY' || CHR(10) ||
        '        , M.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '        , M.CELL_TYPE' || CHR(10) ||
        '        , M.FORECAST_INFO_ALL' || CHR(10) ||
        '        , M.FORECAST_INFO_SPEC' || CHR(10) ||
        '        , M.FORECAST_INFOR_VERSION' || CHR(10) ||
        '        , M.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '        , M.CELL_PER_CAR' || CHR(10) ||
        '        , M.CELL_PER_MODULE' || CHR(10) ||
        '        , M.MODULE_PER_CAR' || CHR(10) ||
        '        , NVL(P.SORT_ORDER_NO, M.SORT_ORDER_NO)             AS SORT_ORDER_NO' || CHR(10) ||
        '        , NVL(M.ENERGE,         P.ENERGE)                   AS ENERGE' || CHR(10) ||
        '        , NVL(M.CELL_QUANTITY,  P.CELL_QUANTITY)            AS CELL_QUANTITY' || CHR(10) ||
        '        , CASE WHEN M.DIVISION_ID IS NULL THEN ''Y'' ELSE ''N'' END AS NEW_FLAG' || CHR(10) ||
        '        , ''' || LP_AS_YN || '''                             AS AS_YN' || CHR(10) ||
        '        , M.AS_FROM_SITE' || CHR(10) ||
        '        , M.CREATE_DATE' || CHR(10) ||
        '        , M.LAST_UPDATED_BY' || CHR(10) ||
        '        , M.SENDER_CODE' || CHR(10) ||
        '        , M.SENDER_NAME' || CHR(10) ||
        '        , M.YYYYMMDD' || CHR(10) ||
        '    FROM SCM_MGR.GT_DMF0003_SALES_PRICE P' || CHR(10) ||
        '    FULL OUTER JOIN SCM_MGR.GT_DMF0003_MKT_FCST_DST M' || CHR(10) ||
        '      ON  P.DIVISION_ID   = M.DIVISION_ID' || CHR(10) ||
        '      AND P.PROJECT_CODE  = M.PROJECT_CODE' || CHR(10) ||
        '      AND P.SCM_SITE_ID   = M.SCM_SITE_ID' || CHR(10) ||
        '      AND P.PLANT_SITE_ID = M.PLANT_SITE_ID' || CHR(10) ||
        '      AND P.ITEM_ID       = M.ITEM_ID' || CHR(10) ||
        '      AND P.FCST_TYPE     = M.FCST_TYPE' || CHR(10) ||
        '      AND P.INCOTERMS     = M.INCOTERMS' || CHR(10) ||
        '      AND P.DOM_EXP       = M.DOM_EXP' || CHR(10) ||
        '      AND P.MEASURE       = M.MEASURE' || CHR(10) ||
        ') A' || CHR(10) ||
        'LEFT JOIN SCM_MGR.GT_DMF0003_MKT_FCST_DATA D' || CHR(10) ||
        '  ON  A.DIVISION_ID   = D.DIVISION_ID' || CHR(10) ||
        '  AND A.PROJECT_CODE  = D.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID   = D.SCM_SITE_ID' || CHR(10) ||
        '  AND A.PLANT_SITE_ID = D.PLANT_SITE_ID' || CHR(10) ||
        '  AND A.ITEM_ID       = D.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP       = D.DOM_EXP' || CHR(10) ||
        '  AND A.FCST_TYPE     = D.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS     = D.INCOTERMS' || CHR(10) ||
        '  AND A.MEASURE       = D.MEASURE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
        '  ON  C.BASIS_YYYYMMDD = D.YYYYMMDD' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I' || CHR(10) ||
        '  ON  A.DIVISION_ID = I.DIVISION_ID' || CHR(10) ||
        '  AND A.PROJECT_CODE = I.PROJECT_CODE' || CHR(10) ||
        '  AND A.ITEM_ID      = I.ITEM_ID' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_DMF0003_CAL_MONTH_END C2' || CHR(10) ||
        '  ON  A.YYYYMMDD = C2.MONTH_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_DMF0003_CAL_WEEK_END C3' || CHR(10) ||
        '  ON  A.YYYYMMDD = C3.WEEK_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X' || CHR(10) ||
        '  ON  A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1' || CHR(10) ||
        '  ON  A.DIVISION_ID = M1.SEGMENT1' || CHR(10) ||
        '  AND A.MEASURE     = M1.SEGMENT2' || CHR(10) ||
        '  AND M1.LOOKUP_TYPE = ''MKT_FCST_MEASURE''' || CHR(10) ||
        '  AND M1.SEGMENT5    = ''Y''' || CHR(10) ||
        '  AND M1.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = M2.SEGMENT1' || CHR(10) ||
        '  AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '  AND ''[@p_created_by]'' = M2.SEGMENT4' || CHR(10) ||
        '  AND M2.LOOKUP_TYPE = ''TMM_MEASURE_ADMIN''' || CHR(10) ||
        '  AND M2.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.GT_DMF0003_VMI_DIO VM' || CHR(10) ||
        '  ON  A.SCM_SITE_ID = VM.KEY_JOIN' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_DMF0003_T_SSP_SYNC B1' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B1.DIVISION_ID AND A.PROJECT_CODE = B1.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B1.SCM_SITE_ID  AND A.ITEM_ID     = B1.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B1.DOM_EXP       AND A.FCST_TYPE   = B1.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B1.INCOTERMS     AND A.MEASURE     = ''MKT_FCST_RP''' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_DMF0003_T_BNP B2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B2.DIVISION_ID AND A.PROJECT_CODE = B2.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B2.SCM_SITE_ID  AND A.ITEM_ID     = B2.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B2.DOM_EXP       AND A.FCST_TYPE   = B2.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B2.INCOTERMS     AND A.MEASURE     = ''BNPIn''' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS' || CHR(10) ||
        '         , NVL(V_SUN,0)||NVL(V_MON,0)||NVL(V_TUE,0)||NVL(V_WED,0)' || CHR(10) ||
        '           ||NVL(V_THU,0)||NVL(V_FRI,0)||NVL(V_SAT,0)              AS BUCKET' || CHR(10) ||
        '    FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD' || CHR(10) ||
        '                , CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER' || CHR(10) ||
        '           FROM  SCM_MGR.DM_MST_BUCKET_CONVERSION' || CHR(10) ||
        '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || ''') A' || CHR(10) ||
        '    PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD' || CHR(10) ||
        '           IN (''SUN'' AS V_SUN,''MON'' AS V_MON,''TUE'' AS V_TUE,''WED'' AS V_WED,' || CHR(10) ||
        '               ''THU'' AS V_THU,''FRI'' AS V_FRI,''SAT'' AS V_SAT))' || CHR(10) ||
        ') BK ON A.DIVISION_ID = BK.DIVISION_ID' || CHR(10) ||
        '     AND A.SCM_SITE_ID = BK.SCM_SITE_ID' || CHR(10) ||
        '     AND A.INCOTERMS   = BK.INCOTERMS' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT LOOK.SEGMENT3 AS DEPT_ID' || CHR(10) ||
        '    FROM   SCM_MGR.SCM_ADM_USER_M USR' || CHR(10) ||
        '    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK' || CHR(10) ||
        '      ON   USR.DEPT_ID = LOOK.SEGMENT1' || CHR(10) ||
        '     AND   LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING''' || CHR(10) ||
        '     AND   LOOK.VALID_YN    = ''Y''' || CHR(10) ||
        '    WHERE  USR.USER_ID = ''[@p_created_by]''' || CHR(10) ||
        '    UNION' || CHR(10) ||
        '    SELECT DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID = ''[@p_created_by]''' || CHR(10) ||
        ') MA ON A.DEPT_ID = MA.DEPT_ID' || CHR(10) ||
        'WHERE 1=1 AND [@v_team_id]' || CHR(10) ||
        ')' || CHR(10) ||
        -- ── PIVOT WRAPPER (일별/주별/월별 UNION ALL + PIVOT) ──────────────────────
        'SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]' || CHR(10) ||
        'FROM (' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN' || CHR(10) ||
        ') F' || CHR(10) ||
        'PIVOT (SUM(QTY) FOR YYYYMMDD IN ([@V_PV_LIST])) PVT' || CHR(10) ||
        '[@V_ORDERBY]';


    ELSE

        -- -----------------------------------------------------------------------
        -- 비AS 경로 보완 처리: LP_AS_YN='Y' → AS_IN_REQ/PLAN/INV 빈 행 추가
        -- -----------------------------------------------------------------------
		-- IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'N' AND AND LP_AS_YN = 'Y' THEN
        IF LP_AS_YN = 'Y' THEN
            DECLARE
                V_AS_CNT2 PLS_INTEGER := 0;
            BEGIN
                SELECT COUNT(1) INTO V_AS_CNT2
                FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
                WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV');

                IF V_AS_CNT2 > 0 THEN
                    -- AS 사이트에 해당하는 조합 중 AS 메저가 없는 날짜에 QTY=0 행 삽입
                    INSERT INTO SCM_MGR.GT_DMF0003_MKT_FCST_DATA
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                    , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY
                    , MEASURE_GROUP, CELL_MODEL, END_CUSTOMER, NICK_NAME
                    , DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
                    , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER
                    , BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
                    , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
                    , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
                    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
                    , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
                    , SORT_ORDER_NO, ENERGE, CELL_QUANTITY
                    , AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                         , C.MEASURE
                         , A.YYYYMMDD   -- MAX(YYYYMMDD) 기준 날짜 사용
                         , 0  AS QTY
                         , C.MEASURE_GROUP
                         , A.CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME
                         , A.DMS_SALES, A.DMS_CUSTOMER, A.OWNER, A.DEPT_ID, A.DEPT_NAME_KO
                         , A.FORECAST_INFO_CELL_PACK_COUNT, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER
                         , A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
                         , A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
                         , A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
                         , A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
                         , A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
                         , C.SORT_ORDER_NO
                         , A.ENERGE, A.CELL_QUANTITY
                         , A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
                    FROM (
                        -- AS 사이트 기반 헤더 (최신 YYYYMMDD)
                        SELECT A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                             , A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
                             , MAX(A2.YYYYMMDD) AS YYYYMMDD
                             , 0 AS QTY
                             , A2.CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                             , A2.DMS_SALES, A2.DMS_CUSTOMER, A2.OWNER, A2.DEPT_ID, A2.DEPT_NAME_KO
                             , A2.FORECAST_INFO_CELL_PACK_COUNT, A2.ITEM_TYPE, A2.PROJECT_NAME, A2.PROJECT_OWNER
                             , A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER, A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS
                             , A2.ITEM_NAME, A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL
                             , A2.APPLICATION, A2.ROUTE, A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY
                             , A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                             , A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                             , A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                             , A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                             , A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                        FROM   SCM_MGR.GT_DMF0003_MKT_FCST_DATA A2
                        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B2
                          ON   A2.SCM_SITE_ID = B2.SEGMENT1
                         AND   B2.LOOKUP_TYPE = 'AS_SITE_PLANT'
                         AND   B2.SEGMENT3    = P_DIVISION_ID
                        GROUP  BY A2.DIVISION_ID, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.PLANT_SITE_ID, A2.ITEM_ID
                               ,  A2.DOM_EXP, A2.FCST_TYPE, A2.INCOTERMS
                               ,  A2.CELL_MODEL, A2.END_CUSTOMER, A2.NICK_NAME
                               ,  A2.DMS_SALES, A2.DMS_CUSTOMER, A2.OWNER, A2.DEPT_ID, A2.DEPT_NAME_KO
                               ,  A2.FORECAST_INFO_CELL_PACK_COUNT, A2.ITEM_TYPE, A2.PROJECT_NAME, A2.PROJECT_OWNER
                               ,  A2.BIZ_TYPE, A2.SOLDTO_CUSTOMER, A2.COUNTRY_NAME, A2.CITY_NAME, A2.PROJECT_STATUS
                               ,  A2.ITEM_NAME, A2.VMI_YN, A2.CUST_GROUP, A2.CUST_GROUP_DTL
                               ,  A2.APPLICATION, A2.ROUTE, A2.MDM_PROJECT_NAME, A2.MIN_CAPACITY
                               ,  A2.FORECAST_INFO_BIZ_TYPE, A2.CELL_TYPE
                               ,  A2.FORECAST_INFO_ALL, A2.FORECAST_INFO_SPEC, A2.FORECAST_INFOR_VERSION
                               ,  A2.CELL_MODEL_NICK_NAME, A2.CELL_PER_CAR, A2.CELL_PER_MODULE, A2.MODULE_PER_CAR
                               ,  A2.SORT_ORDER_NO, A2.ENERGE, A2.CELL_QUANTITY
                               ,  A2.AS_FROM_SITE, A2.CREATE_DATE, A2.LAST_UPDATED_BY, A2.SENDER_CODE, A2.SENDER_NAME
                    ) A
                    -- AS_IN_REQ/PLAN/INV 메저 CROSS JOIN
                    JOIN (
                        SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO
                        FROM   SCM_MGR.GT_DMF0003_SELECT_MEASURE
                        WHERE  MEASURE IN ('AS_IN_REQ','AS_IN_PLAN','AS_INV')
                    ) C ON 1=1
                    -- 이미 존재하는 조합 제외
                    LEFT OUTER JOIN (
                        SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                                      , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                        FROM   SCM_MGR.GT_DMF0003_MKT_FCST_DATA D2
                        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B3
                          ON   D2.SCM_SITE_ID = B3.SEGMENT1
                         AND   B3.LOOKUP_TYPE = 'AS_SITE_PLANT'
                         AND   B3.SEGMENT3    = P_DIVISION_ID
                    ) D ON  A.DIVISION_ID   = D.DIVISION_ID
                        AND A.PROJECT_CODE  = D.PROJECT_CODE
                        AND A.SCM_SITE_ID   = D.SCM_SITE_ID
                        AND A.ITEM_ID       = D.ITEM_ID
                        AND A.DOM_EXP       = D.DOM_EXP
                        AND A.FCST_TYPE     = D.FCST_TYPE
                        AND A.INCOTERMS     = D.INCOTERMS
                        AND C.MEASURE       = D.MEASURE
                        AND A.PLANT_SITE_ID = D.PLANT_SITE_ID
                    WHERE D.DIVISION_ID IS NULL;
                END IF;
            END;
        END IF;

        -- -----------------------------------------------------------------------
        -- PIVOT SQL #2 (비AS용, 일반 경로)
        --   소스: GT_DMF0003_MKT_FCST_DATA  → #MF (임시)
        --         → PIVOT + EXECUTE IMMEDIATE
        -- -----------------------------------------------------------------------
        V_SQL_TEXT :=
        'WITH MF_BASE AS (' || CHR(10) ||
        'SELECT' || CHR(10) ||
        '      A.DIVISION_ID' || CHR(10) ||
        '    , A.DIVISION_ID                                         AS DIVISION_ID40' || CHR(10) ||
        '    , A.SCM_SITE_ID' || CHR(10) ||
        '    , A.SCM_SITE_ID                                         AS SCM_SITE_ID40' || CHR(10) ||
        '    , A.PLANT_SITE_ID' || CHR(10) ||
        '    , A.PROJECT_CODE' || CHR(10) ||
        '    , NVL(I.GROUP_ID,'''')                                  AS GROUP_ID' || CHR(10) ||
        '    , A.ITEM_ID' || CHR(10) ||
        '    , A.ITEM_ID                                             AS ITEM_ID40' || CHR(10) ||
        '    , A.INCOTERMS' || CHR(10) ||
        '    , A.FCST_TYPE' || CHR(10) ||
        '    , A.DOM_EXP' || CHR(10) ||
        '    , A.MEASURE' || CHR(10) ||
        '    , A.END_CUSTOMER' || CHR(10) ||
        '    , CASE WHEN (A.DIVISION_ID LIKE ''81%'' OR A.DIVISION_ID = ''82'')' || CHR(10) ||
        '           THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END      AS END_CUSTOMER40' || CHR(10) ||
        '    , A.NICK_NAME' || CHR(10) ||
        '    , A.DMS_SALES' || CHR(10) ||
        '    , A.DMS_CUSTOMER' || CHR(10) ||
        '    , C.BASIS_YYYYMM                                        AS YYYYMM' || CHR(10) ||
        '    , C.BASIS_YYYYMM || C.ISO_WEEK                          AS YYYYMMWW' || CHR(10) ||
        '    , C.BASIS_YYYYMMDD                                      AS YYYYMMDD' || CHR(10) ||
        '    , C.DAYOFWEEK' || CHR(10) ||
        '    , A.CELL_MODEL                                          AS FORECAST_INFO_CELL_MODEL' || CHR(10) ||
        '    , A.DEPT_ID                                             AS TEAM_ID' || CHR(10) ||
        '    , A.DEPT_NAME_KO                                        AS TEAM_NAME_KO' || CHR(10) ||
        '    , A.ITEM_TYPE' || CHR(10) ||
        '    , A.PROJECT_NAME' || CHR(10) ||
        '    , A.PROJECT_OWNER' || CHR(10) ||
        '    , A.OWNER' || CHR(10) ||
        '    , A.BIZ_TYPE' || CHR(10) ||
        '    , A.SOLDTO_CUSTOMER' || CHR(10) ||
        '    , A.COUNTRY_NAME' || CHR(10) ||
        '    , A.CITY_NAME' || CHR(10) ||
        '    , A.PROJECT_STATUS' || CHR(10) ||
        '    , A.ITEM_NAME' || CHR(10) ||
        '    , A.VMI_YN' || CHR(10) ||
        '    , A.CUST_GROUP' || CHR(10) ||
        '    , A.CUST_GROUP_DTL' || CHR(10) ||
        '    , A.APPLICATION' || CHR(10) ||
        '    , A.ROUTE' || CHR(10) ||
        '    , A.MDM_PROJECT_NAME' || CHR(10) ||
        '    , A.MIN_CAPACITY' || CHR(10) ||
        '    , A.FORECAST_INFO_BIZ_TYPE' || CHR(10) ||
        '    , A.CELL_TYPE' || CHR(10) ||
        '    , A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '    , A.FORECAST_INFO_ALL' || CHR(10) ||
        '    , A.FORECAST_INFO_SPEC' || CHR(10) ||
        '    , A.FORECAST_INFOR_VERSION' || CHR(10) ||
        '    , A.CELL_MODEL_NICK_NAME' || CHR(10) ||
        '    , CAST(CASE WHEN ''Y'' = ''[@CellQtyYN]''' || CHR(10) ||
        '                 AND A.MEASURE_GROUP NOT IN (''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'')' || CHR(10) ||
        '                 AND NVL(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1' || CHR(10) ||
        '                THEN A.QTY * A.FORECAST_INFO_CELL_PACK_COUNT' || CHR(10) ||
        '                ELSE A.QTY END AS NUMBER(36,10)) AS QTY' || CHR(10) ||
        '    , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN' || CHR(10) ||
        '    , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN' || CHR(10) ||
        '    , CASE' || CHR(10) ||
        '          WHEN MA.DEPT_ID IS NOT NULL' || CHR(10) ||
        '               AND A.MEASURE_GROUP NOT IN (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'')' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN ''[@v_group_id]'' = ''ADMIN''' || CHR(10) ||
        '               AND A.MEASURE_GROUP <> ''TMM_FCST''' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          WHEN A.MEASURE_GROUP = ''TMM_FCST''' || CHR(10) ||
        '               AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '               AND A.MEASURE = M1.SEGMENT2 THEN ''Y''' || CHR(10) ||
        '          ELSE ''N''' || CHR(10) ||
        '      END AS EDIT_FLAG' || CHR(10) ||
        '    , A.CELL_PER_CAR' || CHR(10) ||
        '    , A.CELL_PER_MODULE' || CHR(10) ||
        '    , A.MODULE_PER_CAR' || CHR(10) ||
        '    , A.SORT_ORDER_NO' || CHR(10) ||
        '    , A.MEASURE_GROUP' || CHR(10) ||
        '    , A.ENERGE' || CHR(10) ||
        '    , A.CELL_QUANTITY' || CHR(10) ||
        '    , ''N''                                                 AS NEW_FLAG' || CHR(10) ||
        '    , CASE WHEN A.DIVISION_ID = ''40''' || CHR(10) ||
        '           THEN TO_CHAR(CAST(VM.VMI_STD_DIO AS NUMBER))' || CHR(10) ||
        '           ELSE VM.VMI_VAL END                              AS VMI_STD_DIO' || CHR(10) ||
        '    , NVL(B1.ATTR1, B2.ATTR1)                              AS ATTR1' || CHR(10) ||
        '    , NVL(BK.BUCKET,''0000000'')                           AS BUCKET' || CHR(10) ||
        '    , ''' || LP_AS_YN || '''                                AS AS_YN' || CHR(10) ||
        '    , CASE WHEN ''' || LP_AS_YN || ''' = ''Y'' THEN NVL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY' || CHR(10) ||
        '    , NVL(A.AS_FROM_SITE,'''')                             AS AS_FROM_SITE' || CHR(10) ||
        '    , CASE WHEN A.CREATE_DATE IS NULL OR NVL(A.CREATE_DATE,'''')    = '''' THEN '' '' ELSE A.CREATE_DATE    END AS LAST_UPDATE_DATE' || CHR(10) ||
        '    , CASE WHEN A.LAST_UPDATED_BY IS NULL OR NVL(A.LAST_UPDATED_BY,'''')= '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY' || CHR(10) ||
        '    , CASE WHEN A.SENDER_CODE IS NULL OR NVL(A.SENDER_CODE,'''')    = '''' THEN '' '' ELSE A.SENDER_CODE    END AS SENDER_CODE' || CHR(10) ||
        '    , CASE WHEN A.SENDER_NAME IS NULL OR NVL(A.SENDER_NAME,'''')    = '''' THEN '' '' ELSE A.SENDER_NAME    END AS SENDER_NAME' || CHR(10) ||
        '    , A.NOTATION' || CHR(10) ||
        'FROM SCM_MGR.GT_DMF0003_MKT_FCST_DATA A' || CHR(10) ||
        'INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C' || CHR(10) ||
        '  ON  C.BASIS_YYYYMMDD = A.YYYYMMDD' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I' || CHR(10) ||
        '  ON  A.DIVISION_ID = I.DIVISION_ID' || CHR(10) ||
        '  AND A.PROJECT_CODE = I.PROJECT_CODE' || CHR(10) ||
        '  AND A.ITEM_ID      = I.ITEM_ID' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_DMF0003_CAL_MONTH_END C2' || CHR(10) ||
        '  ON  A.YYYYMMDD = C2.MONTH_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_DMF0003_CAL_WEEK_END C3' || CHR(10) ||
        '  ON  A.YYYYMMDD = C3.WEEK_END_DATE' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X' || CHR(10) ||
        '  ON  A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1' || CHR(10) ||
        '  ON  A.DIVISION_ID = M1.SEGMENT1' || CHR(10) ||
        '  AND A.MEASURE     = M1.SEGMENT2' || CHR(10) ||
        '  AND M1.LOOKUP_TYPE = ''MKT_FCST_MEASURE''' || CHR(10) ||
        '  AND M1.SEGMENT5    = ''Y''' || CHR(10) ||
        '  AND M1.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = M2.SEGMENT1' || CHR(10) ||
        '  AND A.PROJECT_CODE = M2.SEGMENT2' || CHR(10) ||
        '  AND ''[@p_created_by]'' = M2.SEGMENT4' || CHR(10) ||
        '  AND M2.LOOKUP_TYPE = ''TMM_MEASURE_ADMIN''' || CHR(10) ||
        '  AND M2.VALID_YN    = ''Y''' || CHR(10) ||
        'LEFT JOIN SCM_MGR.GT_DMF0003_VMI_DIO VM' || CHR(10) ||
        '  ON  A.ITEM_ID     = CASE WHEN ''' || P_DIVISION_ID || ''' = ''40'' THEN VM.KEY_JOIN ELSE A.ITEM_ID END' || CHR(10) ||
        '  AND ( ''' || P_DIVISION_ID || ''' = ''40''  ' || CHR(10) ||
        '        OR A.SCM_SITE_ID = VM.KEY_JOIN )' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_DMF0003_T_SSP_SYNC B1' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B1.DIVISION_ID AND A.PROJECT_CODE = B1.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B1.SCM_SITE_ID  AND A.ITEM_ID     = B1.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B1.DOM_EXP       AND A.FCST_TYPE   = B1.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B1.INCOTERMS     AND A.MEASURE     = ''MKT_FCST_RP''' || CHR(10) ||
        'LEFT OUTER JOIN SCM_MGR.GT_DMF0003_T_BNP B2' || CHR(10) ||
        '  ON  A.DIVISION_ID  = B2.DIVISION_ID AND A.PROJECT_CODE = B2.PROJECT_CODE' || CHR(10) ||
        '  AND A.SCM_SITE_ID  = B2.SCM_SITE_ID  AND A.ITEM_ID     = B2.ITEM_ID' || CHR(10) ||
        '  AND A.DOM_EXP      = B2.DOM_EXP       AND A.FCST_TYPE   = B2.FCST_TYPE' || CHR(10) ||
        '  AND A.INCOTERMS    = B2.INCOTERMS     AND A.MEASURE     = ''BNPIn''' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS' || CHR(10) ||
        '         , NVL(V_SUN,0)||NVL(V_MON,0)||NVL(V_TUE,0)||NVL(V_WED,0)' || CHR(10) ||
        '           ||NVL(V_THU,0)||NVL(V_FRI,0)||NVL(V_SAT,0)              AS BUCKET' || CHR(10) ||
        '    FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD' || CHR(10) ||
        '                , CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER' || CHR(10) ||
        '           FROM  SCM_MGR.DM_MST_BUCKET_CONVERSION' || CHR(10) ||
        '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || ''') A' || CHR(10) ||
        '    PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD' || CHR(10) ||
        '           IN (''SUN'' AS V_SUN,''MON'' AS V_MON,''TUE'' AS V_TUE,''WED'' AS V_WED,' || CHR(10) ||
        '               ''THU'' AS V_THU,''FRI'' AS V_FRI,''SAT'' AS V_SAT))' || CHR(10) ||
        ') BK ON A.DIVISION_ID = BK.DIVISION_ID' || CHR(10) ||
        '     AND A.SCM_SITE_ID = BK.SCM_SITE_ID' || CHR(10) ||
        '     AND A.INCOTERMS   = BK.INCOTERMS' || CHR(10) ||
        'LEFT OUTER JOIN (' || CHR(10) ||
        '    SELECT LOOK.SEGMENT3 AS DEPT_ID' || CHR(10) ||
        '    FROM   SCM_MGR.SCM_ADM_USER_M USR' || CHR(10) ||
        '    JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK' || CHR(10) ||
        '      ON   USR.DEPT_ID = LOOK.SEGMENT1' || CHR(10) ||
        '     AND   LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING''' || CHR(10) ||
        '     AND   LOOK.VALID_YN    = ''Y''' || CHR(10) ||
        '    WHERE  USR.USER_ID = ''[@p_created_by]''' || CHR(10) ||
        '    UNION' || CHR(10) ||
        '    SELECT DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID = ''[@p_created_by]''' || CHR(10) ||
        ') MA ON A.DEPT_ID = MA.DEPT_ID' || CHR(10) ||
        'WHERE 1=1 AND [@v_team_id]' || CHR(10) ||
        ')' || CHR(10) ||
        -- ── PIVOT WRAPPER (동일) ──────────────────────────────────────────────────
        'SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]' || CHR(10) ||
        'FROM (' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN' || CHR(10) ||
        '    UNION ALL' || CHR(10) ||
        '    SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD' || CHR(10) ||
        '         , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')' || CHR(10) ||
        '                THEN CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END' || CHR(10) ||
        '                ELSE SUM(F.QTY) END AS QTY' || CHR(10) ||
        '    FROM   MF_BASE F' || CHR(10) ||
        '    WHERE  F.QTY <> (CASE WHEN F.MEASURE IN' || CHR(10) ||
        '                    (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',' || CHR(10) ||
        '                     ''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',' || CHR(10) ||
        '                     ''Material_Temp'',''Backorder'',''CUST_FCST_EDI_ORG'',' || CHR(10) ||
        '                     ''Immidiate[Org.]'',''Planning_Forecast[Org.]'',' || CHR(10) ||
        '                     ''Commercial_Agreement[Org.]'',''Firm_Temp[Org.]'',' || CHR(10) ||
        '                     ''Manumacturing_Material_Temp[Org.]'',''Material_Temp[Org.]'',' || CHR(10) ||
        '                     ''Backorder[Org.]'') THEN -9999999999 ELSE 0 END)' || CHR(10) ||
        '    GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN' || CHR(10) ||
        ') F' || CHR(10) ||
        'PIVOT (SUM(QTY) FOR YYYYMMDD IN ([@V_PV_LIST])) PVT' || CHR(10) ||
        '[@V_ORDERBY]';

    END IF;



    -----------------------------------------------------------------------
    -- 플레이스홀더 치환
    -----------------------------------------------------------------------
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_COL_LIST]',  V_PV_COL_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_LIST]',      V_PV_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_COLUMN]',       V_COLUMN);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_groupby]',      V_GROUPBY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_team_id]',      V_TEAM_WHERE);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_created_by]',   P_CREATED_BY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_group_id]',     V_GROUP_ID);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_orderby]',      V_ORDERBY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_ORDERBY]',      V_ORDERBY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_from_yyyymmdd]',P_FROM_YYYYMMDD);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@p_to_yyyymmdd]',  P_TO_YYYYMMDD);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@CellQtyYN]',      P_CELL_YN);
    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -----------------------------------------------------------------------
    -- EXECUTE IMMEDIATE → O_RC 반환
    -----------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(V_SQL_TEXT);
    OPEN O_RC1 FOR V_SQL_TEXT;

    -----------------------------------------------------------------------
    -- O_RC2: 8주 이내 버킷 정보 (20181115 소형 사업부 일별 입력 전용)
    -- 원본: SELECT TOP 1 * FROM SCM_SYS_CALENDAR_M
    --       WHERE ISO_WEEK = DATEPART(ISO_WEEK, DATEADD(WEEK,7,GETDATE()))
    --         AND CALENDAR_YYYY = DATEPART(YEAR, DATEADD(WEEK,7,GETDATE()))
    --       ORDER BY BASIS_YYYYMMDD
    -----------------------------------------------------------------------
    OPEN O_RC2 FOR
        SELECT *
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M
        WHERE  ISO_YYYYWW  = TO_CHAR(SYSDATE + (7*7), 'IYYY') ||
                             TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE + (7*7), 'IW')), 'FM00')
        ORDER  BY BASIS_YYYYMMDD
        FETCH  FIRST 1 ROW ONLY;

    -----------------------------------------------------------------------
    -- O_RC3: 현재 주차 정보 (20211130)
    -- 원본: SELECT 'M_'+THIS_YYYYMM, 'W_'+THIS_YYYYMMWW, ...
    --                현재주 + 전주 정보
    -----------------------------------------------------------------------
    OPEN O_RC3 FOR
        SELECT 'M_' || A.BASIS_YYYYMM                         AS THIS_YYYYMM
             , 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK           AS THIS_YYYYMMWW
             , A.BASIS_DATE
             , 'M_' || B.BASIS_YYYYMM                         AS PRE_YYYYMM
             , 'W_' || B.BASIS_YYYYMM || B.ISO_WEEK           AS PRE_YYYYMMWW
             , A.BASIS_YYYYMM, A.ISO_WEEK
        FROM   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
                FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')) A
        JOIN   (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
                FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')) B ON 1=1;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;

        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID'   VALUE P_DIVISION_ID,
            'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
            'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
            'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
            'P_TO_YYYYMMDD'   VALUE P_TO_YYYYMMDD,
            'P_CREATED_BY'    VALUE P_CREATED_BY,
            'P_USER_GROUP'    VALUE P_USER_GROUP,
            'P_ITEM_ID'       VALUE P_ITEM_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE
         || ' / SQLERRM='   || V_SQL_ERRMSG
         || ' / BACKTRACE=' || V_BACKTRACE
         || ' / PARAMS='    || V_PROC_INPUT
        );

END P_DMF0003_GET_MKT_FCST_DATA;

  -- ============================================================================
  -- [2026-07-20] standalone DMF0003_SAVE_MKT_FCST → PKG 병합 (UI별 PKG 원칙).
  --   본문 로직 무수정 이관(헤더만 패키지 멤버화). p_authority(16번째) 반영본.
  -- ============================================================================
  PROCEDURE P_DMF0003_SAVE_MKT_FCST
  ( P_ACTIVE_FLAG      IN  VARCHAR2
      , P_DIVISION_ID      IN  VARCHAR2
      , P_PROJECT_CODE     IN  VARCHAR2
      , P_SCM_SITE_ID      IN  VARCHAR2
      , P_ITEM_ID          IN  VARCHAR2
      , P_DOM_EXP          IN  VARCHAR2
      , P_FCST_TYPE        IN  VARCHAR2
      , P_INCOTERMS        IN  VARCHAR2
      , P_MEASURE          IN  VARCHAR2
      , P_PLANT_SITE_ID    IN  VARCHAR2
      , P_YYYYMMDD         IN  VARCHAR2
      , P_QTY              IN  VARCHAR2
      , P_CREATED_BY       IN  VARCHAR2
      , P_AS_FROM_SITE     IN  VARCHAR2
      , P_BUCKET           IN  VARCHAR2  --[E20250313-001251]_화면의 bucket 정보 받음
      , P_AUTHORITY        IN  VARCHAR2 DEFAULT NULL  --[E20260604-000994]_저장 시 로그인 권한 그룹 수신 (저장 시간창 게이트 본문은 AS-IS SP 원문 확보 후 이식 예정 — 2026-07-20)
      , O_RC1              OUT SYS_REFCURSOR
      , O_RESULT_CURSOR    OUT SYS_REFCURSOR
      )
  AS
    -- 내부 변수
    V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
    V_DIVISION_ID           VARCHAR2(4000 CHAR);
    V_PROJECT_CODE          VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID           VARCHAR2(4000 CHAR);
    V_ITEM_ID               VARCHAR2(4000 CHAR);
    V_DOM_EXP               VARCHAR2(4000 CHAR);
    V_FCST_TYPE             VARCHAR2(4000 CHAR);
    V_INCOTERMS             VARCHAR2(4000 CHAR);
    V_MEASURE               VARCHAR2(4000 CHAR);
    V_PLANT_SITE_ID         VARCHAR2(4000 CHAR);
    V_YYYYMMDD              VARCHAR2(4000 CHAR);
    V_QTY                   VARCHAR2(4000 CHAR);
    V_CREATED_BY            VARCHAR2(4000 CHAR);
    V_AS_FROM_SITE          VARCHAR2(4000 CHAR);
    V_AS_FROM_PLANT         VARCHAR2(4000 CHAR);
    V_MAX_INV_DAYS          PLS_INTEGER;         -- [C20210817-000420]
    PLAN_START_YYYYMMDD     VARCHAR2(4000 CHAR); -- 20180611 KHSONG ADDED
    V_BUCKET                VARCHAR2(4000 CHAR); -- [E20250313-001251]_화면의 bucket 정보 받음

    -- 작업용 복사본 파라미터 (IN 파라미터 직접 조작 불가이므로 로컬 복사)
    LP_ACTIVE_FLAG          VARCHAR2(32767 CHAR);
    LP_DIVISION_ID          VARCHAR2(32767 CHAR);
    LP_PROJECT_CODE         VARCHAR2(32767 CHAR);
    LP_SCM_SITE_ID          VARCHAR2(32767 CHAR);
    LP_ITEM_ID              VARCHAR2(32767 CHAR);
    LP_DOM_EXP              VARCHAR2(32767 CHAR);
    LP_FCST_TYPE            VARCHAR2(32767 CHAR);
    LP_INCOTERMS            VARCHAR2(32767 CHAR);
    LP_MEASURE              VARCHAR2(32767 CHAR);
    LP_PLANT_SITE_ID        VARCHAR2(32767 CHAR);
    LP_YYYYMMDD             VARCHAR2(32767 CHAR);
    LP_QTY                  VARCHAR2(32767 CHAR);
    LP_CREATED_BY           VARCHAR2(32767 CHAR);
    LP_AS_FROM_SITE         VARCHAR2(32767 CHAR);

    -- 인덱스 변수
    N_INDEX_ACTIVE_FLAG     PLS_INTEGER;
    N_INDEX_DIVISION_ID     PLS_INTEGER;
    N_INDEX_PROJECT_CODE    PLS_INTEGER;
    N_INDEX_SCM_SITE_ID     PLS_INTEGER;
    N_INDEX_ITEM_ID         PLS_INTEGER;
    N_INDEX_DOM_EXP         PLS_INTEGER;
    N_INDEX_FCST_TYPE       PLS_INTEGER;
    N_INDEX_INCOTERMS       PLS_INTEGER;
    N_INDEX_MEASURE         PLS_INTEGER;
    N_INDEX_PLANT_SITE_ID   PLS_INTEGER;
    N_INDEX_YYYYMMDD        PLS_INTEGER;
    N_INDEX_QTY             PLS_INTEGER;
    N_INDEX_CREATED_BY      PLS_INTEGER;
    N_INDEX_AS_FROM_SITE    PLS_INTEGER; -- [E20260211-001189]

    READ_CNT                PLS_INTEGER := 0;
    READ_1000_CNT           PLS_INTEGER := 0;

    -- LOG 용 변수
    V_PROGRAM_NAME          VARCHAR2(150 CHAR);
    V_LOG_TYPE              VARCHAR2(30 CHAR);
    N_LOG_COUNT             NUMBER(10) := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    D_EVENT_DATE            DATE;
    V_PROC_INPUT            CLOB;
    V_SQL_CODE              VARCHAR2(20 CHAR);
    V_SQL_ERRMSG            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);

    -- 검증용 변수
    V_CHECK_CNT             NUMBER(10);
    V_VALID_PROJECT_CODE    VARCHAR2(4000 CHAR);
    V_VALID_ITEM_ID         VARCHAR2(4000 CHAR);
    V_VALID_ITEM_ID_2       VARCHAR2(4000 CHAR);
    V_VALID_TYPE            VARCHAR2(100 CHAR);
    V_VALID_BOM             VARCHAR2(4000 CHAR);
    V_VALID_SHIPTO          VARCHAR2(4000 CHAR);
    V_S_BLOCK_MODEL         VARCHAR2(4000 CHAR);
    V_S_UNIT_PRICE_VALID    VARCHAR2(4000 CHAR);
    V_ERR_CNT               PLS_INTEGER;

    -- INVENTORY/DATE 변수
    V_MIN_DATE              CHAR(8 CHAR);
    V_MAX_DATE              CHAR(8 CHAR);
    V_FROM_DATE             CHAR(8 CHAR);
    V_TO_DATE               CHAR(8 CHAR);

    -- 중장기 계획 DIVISION 변수
    V_C_DIVISION_ID         VARCHAR2(4000 CHAR);

    -- TYPE 변수 (#mshychu1, #mshychu2, #ess_price_except_model 대체)
    T_MSHYCHU1              SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();
    T_MSHYCHU2              SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();
    T_ESS_PRICE_EXCEPT      SCM_MGR.T_STR_TAB := SCM_MGR.T_STR_TAB();

    -- ESS VMI 커서용 변수
    EV_DIVISION_ID          VARCHAR2(30 CHAR);
    EV_SCM_SITE_ID          VARCHAR2(50 CHAR);
    EV_PROJECT_CODE         VARCHAR2(50 CHAR);
    EV_ITEM_ID              VARCHAR2(50 CHAR);
    EV_DOM_EXP              VARCHAR2(3 CHAR);
    EV_FCST_TYPE            VARCHAR2(20 CHAR);
    EV_INCOTERMS            VARCHAR2(10 CHAR);
    EV_PLANT_SITE_ID        VARCHAR2(30 CHAR);
    EV_DIO                  PLS_INTEGER;
    EV_BINV                 PLS_INTEGER;

    -- ESS VMI 커서
    CURSOR CURSOR_ESSVMI1 IS
        --[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건으로 기존 SCM_MST_SITE ATTRIBUTE5에서 SSPM INVENTORY DAYS 컬럼으로 변경 [START]
        -- 2026.04.06 SCM_MST_SITE_ITEM 칼럼 삭제에 따른 조회 컬럼 제거
        SELECT DISTINCT A.V_DIVISION_ID, A.V_SCM_SITE_ID, A.V_PROJECT_CODE, A.V_ITEM_ID, A.V_DOM_EXP
                      , A.V_FCST_TYPE, A.V_INCOTERMS, A.V_PLANT_SITE_ID
        FROM  SCM_MGR.GT_DMF3_RESULTS A
        JOIN  SCM_MGR.SCM_MST_SITE_ITEM B
          ON  A.V_DIVISION_ID   = B.DIVISION_ID
         AND  A.V_SCM_SITE_ID   = B.SCM_SITE_ID
         AND  A.V_ITEM_ID       = B.ITEM_ID
         AND  A.V_PROJECT_CODE  = B.PROJECT_CODE
        WHERE A.V_MEASURE       = 'MKT_FCST'
          AND A.V_VMI_YN        = 'Y'
          AND A.V_DIVISION_ID   = '82';
        --[E20230619-000273] [END]

    -- INVALID 플래그
    V_INVALID               BOOLEAN := FALSE;
    V_R_CURSOR              SYS_REFCURSOR;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- GTT 초기화 (프로시저 시작 시 이전에 일반 테이블 DML 없으므로 DELETE 사용)
    -- ※ TRUNCATE는 DDL로 자동 COMMIT 발생 위험이 있으므로 DELETE 사용
    DELETE FROM SCM_MGR.GT_DMF3_RESULTS;
    DELETE FROM SCM_MGR.GT_DMF3_T_PRICE;
    DELETE FROM SCM_MGR.GT_DMF3_TMP_MKT_FCST;
    DELETE FROM SCM_MGR.GT_DMF3_SEND_TARGET_DATA;
    --DELETE FROM SCM_MGR.GT_DMF3_INVENTORY_SITE; 2026.04.06 SCM_MST_SITE_ITEM 미사용으로 제거
    DELETE FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_V;
    DELETE FROM SCM_MGR.GT_DMF3_T_ERR;
    DELETE FROM SCM_MGR.GT_DMF3_T_ERR2;
    DELETE FROM SCM_MGR.GT_DMF3_SITE_CUSTOMER_MAP;

    -- 로컬 복사
    LP_ACTIVE_FLAG   := RTRIM(P_ACTIVE_FLAG)  || '^';
    LP_DIVISION_ID   := RTRIM(P_DIVISION_ID)  || '^';
    LP_PROJECT_CODE  := RTRIM(P_PROJECT_CODE) || '^';
    LP_SCM_SITE_ID   := RTRIM(P_SCM_SITE_ID)  || '^';
    LP_ITEM_ID       := RTRIM(P_ITEM_ID)       || '^';
    LP_DOM_EXP       := RTRIM(P_DOM_EXP)       || '^';
    LP_FCST_TYPE     := RTRIM(P_FCST_TYPE)     || '^';
    LP_INCOTERMS     := RTRIM(P_INCOTERMS)     || '^';
    LP_MEASURE       := RTRIM(P_MEASURE)       || '^';
    LP_PLANT_SITE_ID := RTRIM(P_PLANT_SITE_ID) || '^';
    LP_YYYYMMDD      := RTRIM(P_YYYYMMDD)      || '^';
    LP_QTY           := RTRIM(P_QTY)           || '^';
    LP_CREATED_BY    := RTRIM(P_CREATED_BY)    || '^';
    LP_AS_FROM_SITE  := P_AS_FROM_SITE;

    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    V_CREATED_BY  := SUBSTR(LP_CREATED_BY, 1,
                        CASE WHEN INSTR(LP_CREATED_BY, '^') > 1 THEN INSTR(LP_CREATED_BY, '^') - 1
                             ELSE 100 END);
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    V_CREATED_BY  := NULL;
    -- 시작 LOG (END)

    ------------------------------------------------------------------------------------------------------
    -- [E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
    /*
    -- AS_FROM_SITE 를 뽑는다.
    IF P_AS_FROM_SITE <> 'ALL'
    THEN
        -- as from site 세팅
        SELECT A.TOKEN INTO V_AS_FROM_SITE
        FROM (
            SELECT TRIM(REGEXP_SUBSTR(P_AS_FROM_SITE, '[^' || CHR(94) || ']+', 1, LEVEL)) AS TOKEN
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_AS_FROM_SITE, '[^' || CHR(94) || ']+', 1, LEVEL) IS NOT NULL
        ) A
        JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON A.TOKEN    = B.SEGMENT2
         AND B.LOOKUP_TYPE = 'AS_SITE_PLANT'
         AND B.SEGMENT2 <> '-'
         AND B.SEGMENT3 = SUBSTR(LP_DIVISION_ID, 1, INSTR(LP_DIVISION_ID, '^') - 1)
        WHERE ROWNUM = 1;
    END IF;
    */
    --[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선

    --[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건의 속도저하문제로 SSPM 테이블을 임시테이블로 생성 [START]
    -- 2026.04.06 SCM_MST_SITE_ITEM 미사용으로 제거
    /*IF SUBSTR(LP_DIVISION_ID, 1, INSTR(LP_DIVISION_ID, '^') - 1) = '82' THEN
        INSERT INTO SCM_MGR.GT_DMF3_INVENTORY_SITE
        ( DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID )
        SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
        FROM   SCM_MGR.SCM_MST_SITE_ITEM
        WHERE  DIVISION_ID = SUBSTR(LP_DIVISION_ID, 1, INSTR(LP_DIVISION_ID, '^') - 1)
          AND  SCM_SITE_ID IN (SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'INVENTORY_DAYS_SETUP_SITE');
    END IF;*/
    --[E20230619-000273] [END]

    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    -- 1. 화면에서 전달받은 데이터 -> GTT로 insert
    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

    WHILE LENGTH(LP_DIVISION_ID) > 0
    LOOP
        N_INDEX_ACTIVE_FLAG   := INSTR(LP_ACTIVE_FLAG,   '^');
        N_INDEX_DIVISION_ID   := INSTR(LP_DIVISION_ID,   '^');
        N_INDEX_PROJECT_CODE  := INSTR(LP_PROJECT_CODE,  '^');
        N_INDEX_SCM_SITE_ID   := INSTR(LP_SCM_SITE_ID,   '^');
        N_INDEX_ITEM_ID       := INSTR(LP_ITEM_ID,        '^');
        N_INDEX_DOM_EXP       := INSTR(LP_DOM_EXP,        '^');
        N_INDEX_FCST_TYPE     := INSTR(LP_FCST_TYPE,      '^');
        N_INDEX_INCOTERMS     := INSTR(LP_INCOTERMS,      '^');
        N_INDEX_MEASURE       := INSTR(LP_MEASURE,        '^');
        N_INDEX_PLANT_SITE_ID := INSTR(LP_PLANT_SITE_ID,  '^');
        N_INDEX_YYYYMMDD      := INSTR(LP_YYYYMMDD,       '^');
        N_INDEX_QTY           := INSTR(LP_QTY,            '^');
        N_INDEX_CREATED_BY    := INSTR(LP_CREATED_BY,     '^');
        --[E20260211-001189]_index_as_from_site추가
        N_INDEX_AS_FROM_SITE  := INSTR(LP_AS_FROM_SITE || '^', '^');

        IF N_INDEX_DIVISION_ID > 0 THEN
            V_ACTIVE_FLAG   := SUBSTR(LP_ACTIVE_FLAG,   1, N_INDEX_ACTIVE_FLAG   - 1);
            V_DIVISION_ID   := SUBSTR(LP_DIVISION_ID,   1, N_INDEX_DIVISION_ID   - 1);
            V_PROJECT_CODE  := SUBSTR(LP_PROJECT_CODE,  1, N_INDEX_PROJECT_CODE  - 1);
            V_SCM_SITE_ID   := SUBSTR(LP_SCM_SITE_ID,   1, N_INDEX_SCM_SITE_ID   - 1);
            V_ITEM_ID       := SUBSTR(LP_ITEM_ID,        1, N_INDEX_ITEM_ID       - 1);
            V_DOM_EXP       := SUBSTR(LP_DOM_EXP,        1, N_INDEX_DOM_EXP       - 1);
            V_FCST_TYPE     := SUBSTR(LP_FCST_TYPE,      1, N_INDEX_FCST_TYPE     - 1);
            V_INCOTERMS     := SUBSTR(LP_INCOTERMS,      1, N_INDEX_INCOTERMS     - 1);
            V_MEASURE       := SUBSTR(LP_MEASURE,        1, N_INDEX_MEASURE       - 1);
            V_PLANT_SITE_ID := SUBSTR(LP_PLANT_SITE_ID,  1, N_INDEX_PLANT_SITE_ID - 1);
            V_YYYYMMDD      := SUBSTR(LP_YYYYMMDD,       1, N_INDEX_YYYYMMDD      - 1);
            V_QTY           := SUBSTR(LP_QTY,            1, N_INDEX_QTY           - 1);
            V_CREATED_BY    := SUBSTR(LP_CREATED_BY,     1, N_INDEX_CREATED_BY    - 1);
            --[E20260211-001189]_index_as_from_site추가
            V_AS_FROM_SITE  := SUBSTR(LP_AS_FROM_SITE || '^', 1, N_INDEX_AS_FROM_SITE - 1);

            LP_ACTIVE_FLAG   := SUBSTR(LP_ACTIVE_FLAG,   LENGTH(V_ACTIVE_FLAG   || '^') + 1);
            LP_DIVISION_ID   := SUBSTR(LP_DIVISION_ID,   LENGTH(V_DIVISION_ID   || '^') + 1);
            LP_PROJECT_CODE  := SUBSTR(LP_PROJECT_CODE,  LENGTH(V_PROJECT_CODE  || '^') + 1);
            LP_SCM_SITE_ID   := SUBSTR(LP_SCM_SITE_ID,   LENGTH(V_SCM_SITE_ID   || '^') + 1);
            LP_ITEM_ID       := SUBSTR(LP_ITEM_ID,        LENGTH(V_ITEM_ID       || '^') + 1);
            LP_DOM_EXP       := SUBSTR(LP_DOM_EXP,        LENGTH(V_DOM_EXP       || '^') + 1);
            LP_FCST_TYPE     := SUBSTR(LP_FCST_TYPE,      LENGTH(V_FCST_TYPE     || '^') + 1);
            LP_INCOTERMS     := SUBSTR(LP_INCOTERMS,      LENGTH(V_INCOTERMS     || '^') + 1);
            LP_MEASURE       := SUBSTR(LP_MEASURE,        LENGTH(V_MEASURE       || '^') + 1);

            IF V_MEASURE = 'MKT_FCST_RP' THEN
                V_MEASURE := 'MKT_FCST';
            END IF;

            LP_PLANT_SITE_ID := SUBSTR(LP_PLANT_SITE_ID, LENGTH(V_PLANT_SITE_ID || '^') + 1);
            LP_YYYYMMDD      := SUBSTR(LP_YYYYMMDD,      LENGTH(V_YYYYMMDD      || '^') + 1);
            LP_QTY           := SUBSTR(LP_QTY,           LENGTH(V_QTY           || '^') + 1);
            LP_CREATED_BY    := SUBSTR(LP_CREATED_BY,    LENGTH(V_CREATED_BY    || '^') + 1);
            --[E20260211-001189]_index_as_from_site추가
            IF N_INDEX_AS_FROM_SITE > 0 AND LENGTH(LP_AS_FROM_SITE) >= N_INDEX_AS_FROM_SITE THEN
                LP_AS_FROM_SITE := SUBSTR(LP_AS_FROM_SITE, LENGTH(V_AS_FROM_SITE || '^') + 1);
            ELSE
                LP_AS_FROM_SITE := NULL;
            END IF;

            --20181005 khsong 공백제거로직추가 (START)
            V_ACTIVE_FLAG   := TRIM(V_ACTIVE_FLAG);
            V_DIVISION_ID   := TRIM(V_DIVISION_ID);
            V_PROJECT_CODE  := TRIM(V_PROJECT_CODE);
            V_SCM_SITE_ID   := TRIM(V_SCM_SITE_ID);
            --[E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (START)
            --1).RTRIM / 2).LTRIM / 3).CHAR(13): Carriage return / 4).CHAR(10): Line feed / 5).CHAR(9): TAB / 6).' '공백을 ''
            V_ITEM_ID       := REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_ITEM_ID), CHR(13),''), CHR(10),''), CHR(9),''), ' ','');
            --[E20250522-001188] (END)
            V_DOM_EXP       := TRIM(V_DOM_EXP);
            V_FCST_TYPE     := TRIM(V_FCST_TYPE);
            V_INCOTERMS     := TRIM(V_INCOTERMS);
            V_MEASURE       := TRIM(V_MEASURE);
            V_PLANT_SITE_ID := TRIM(V_PLANT_SITE_ID);
            V_YYYYMMDD      := TRIM(V_YYYYMMDD);
            V_QTY           := TRIM(V_QTY);
            V_CREATED_BY    := TRIM(V_CREATED_BY);
            --[E20260211-001189]_index_as_from_site추가
            V_AS_FROM_SITE  := TRIM(V_AS_FROM_SITE);
            --20181005 khsong 공백제거로직추가 (END)

            -- 20180813 KHSONG 당주 월요일이후 데이터만 대상으로 하도록 로직보완
            IF V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND REGEXP_LIKE(V_YYYYMMDD, '^[0-9]+$')  -- 2021.09.27
            THEN
                -- 2021.12.15
                DECLARE
                    V_EXISTS_W PLS_INTEGER := 0;
                BEGIN
                    SELECT 1 INTO V_EXISTS_W FROM DUAL
                    WHERE EXISTS (
                        SELECT 1 FROM SCM_MGR.SCM_MST_SITE
                        WHERE DIVISION_ID    = V_DIVISION_ID
                          AND SCM_SITE_ID    = V_SCM_SITE_ID
                          AND SITE_TYPE      = 'SALES'
                          AND OPERATION_GROUP = 'W'
                    );
                    -- SITE_TYPE=SALES, OPERATION_GROUP=W 인 AS PLANT 이면 ATTRIBUTE10 비움
                    V_AS_FROM_PLANT := '-';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- AS PLANT 가 아닌 일반 Sales Site
                        BEGIN
                            SELECT SEGMENT2 INTO V_AS_FROM_PLANT
                            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE  LOOKUP_TYPE = 'AS_SITE_PLANT'
                              AND  SEGMENT2    = V_AS_FROM_SITE
                              AND  SEGMENT3    = V_DIVISION_ID
                              AND  SEGMENT1   <> V_SCM_SITE_ID
                              AND  ROWNUM      = 1;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                V_AS_FROM_PLANT := '-';
                        END;
                END;

                INSERT INTO SCM_MGR.GT_DMF3_RESULTS
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10 )
                VALUES
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, TO_NUMBER(V_QTY), V_CREATED_BY
                --[E20260211-001189]_index_as_from_site 원소스 주석처리 (START)
                --, NVL(V_AS_FROM_PLANT,'-')
                , NVL(V_AS_FROM_SITE, '-')  --[E20260211-001189]_변경
                --[E20260211-001189]_index_as_from_site 원소스 주석처리 (END)
                );
            ELSE
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := ' Check date values (only future dates can be entered after this week) !';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;

        ELSE
            -- 마지막 토큰 처리
            V_DIVISION_ID   := LP_DIVISION_ID;
            LP_DIVISION_ID  := NULL;

            --20181005 khsong 공백제거로직추가 (START)
            V_ACTIVE_FLAG   := TRIM(V_ACTIVE_FLAG);
            V_DIVISION_ID   := TRIM(V_DIVISION_ID);
            V_PROJECT_CODE  := TRIM(V_PROJECT_CODE);
            V_SCM_SITE_ID   := TRIM(V_SCM_SITE_ID);
            V_ITEM_ID       := REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_ITEM_ID), CHR(13),''), CHR(10),''), CHR(9),''), ' ','');
            V_DOM_EXP       := TRIM(V_DOM_EXP);
            V_FCST_TYPE     := TRIM(V_FCST_TYPE);
            V_INCOTERMS     := TRIM(V_INCOTERMS);
            V_MEASURE       := TRIM(V_MEASURE);
            V_PLANT_SITE_ID := TRIM(V_PLANT_SITE_ID);
            V_YYYYMMDD      := TRIM(V_YYYYMMDD);
            V_QTY           := TRIM(V_QTY);
            V_CREATED_BY    := TRIM(V_CREATED_BY);
            --[E20260211-001189]_v_as_from_site 추가
            V_AS_FROM_SITE  := TRIM(V_AS_FROM_SITE);
            --20181005 khsong 공백제거로직추가 (END)

            -- 20180813 KHSONG 당주 월요일이후 데이터만 대상으로 하도록 로직보완
            IF V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND REGEXP_LIKE(V_YYYYMMDD, '^[0-9]+$')
            THEN
                DECLARE
                    V_EXISTS_W2 PLS_INTEGER := 0;
                BEGIN
                    SELECT 1 INTO V_EXISTS_W2 FROM DUAL
                    WHERE EXISTS (
                        SELECT 1 FROM SCM_MGR.SCM_MST_SITE
                        WHERE DIVISION_ID     = V_DIVISION_ID
                          AND SCM_SITE_ID     = V_SCM_SITE_ID
                          AND SITE_TYPE       = 'SALES'
                          AND OPERATION_GROUP = 'W'
                    );
                    V_AS_FROM_PLANT := '-';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        BEGIN
                            SELECT SEGMENT2 INTO V_AS_FROM_PLANT
                            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE  LOOKUP_TYPE = 'AS_SITE_PLANT'
                              AND  SEGMENT2    = V_AS_FROM_SITE
                              AND  SEGMENT3    = V_DIVISION_ID
                              AND  SEGMENT1   <> V_SCM_SITE_ID
                              AND  ROWNUM      = 1;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                V_AS_FROM_PLANT := '-';
                        END;
                END;

                INSERT INTO SCM_MGR.GT_DMF3_RESULTS
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10 )
                VALUES
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
                , V_YYYYMMDD, TO_NUMBER(V_QTY), V_CREATED_BY
                --[E20260211-001189]_v_as_from_site 원소스 주석처리 (START)
                --, NVL(V_AS_FROM_PLANT,'-')
                , NVL(V_AS_FROM_SITE, '-')  --변경
                --[E20260211-001189]_v_as_from_site 원소스 주석처리 (END)
                );
            ELSE
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := ' Check date values (only future dates can be entered after this week) !';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;

            EXIT; -- WHILE 종료
        END IF;

        --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        -- 2. 데이터 정합성 Validation
        --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        ----------- 20180810 KHSONG NULL VALIDATION ADDED
        IF    NVL(V_DIVISION_ID,  '-') = '-'  OR V_DIVISION_ID  = ''
           OR NVL(V_PROJECT_CODE, '-') = '-'  OR V_PROJECT_CODE = ''
           OR NVL(V_SCM_SITE_ID,  '-') = '-'  OR V_SCM_SITE_ID  = ''
           OR NVL(V_ITEM_ID,      '-') = '-'  OR V_ITEM_ID      = ''
           OR NVL(V_DOM_EXP,      '-') = '-'  OR V_DOM_EXP      = ''
           OR NVL(V_FCST_TYPE,    '-') = '-'  OR V_FCST_TYPE    = ''
           OR NVL(V_INCOTERMS,    '-') = '-'  OR V_INCOTERMS    = ''
           OR NVL(V_MEASURE,      '-') = '-'  OR V_MEASURE      = ''
        THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := ' Check Mandatory Columns ( Fcst type or Incoterms or Customs Handbook ) !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
        -----------
    END LOOP;

    -- [C20220328-000205] MKT FCST 입력, 저장 간 오류 확인 요청
    DECLARE
        V_DUP_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_DUP_CNT
        FROM (
            SELECT COUNT(V_DIVISION_ID) AS CNT
            FROM   SCM_MGR.GT_DMF3_RESULTS
            GROUP BY V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
                   , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
            HAVING COUNT(V_DIVISION_ID) > 1
        );
        IF V_DUP_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '동일한 일자에 AS From Site 만 다른 DP 를 입력할 수 없습니다.';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;

    -- ----------------------- SALES PRICE 미리 수집 --------------------------------
    SELECT MIN(BASIS_START_DATE), MAX(BASIS_END_DATE)
    INTO   V_MIN_DATE, V_MAX_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M M
    -----------------------------------------------------------------------------------------------------------------------------------
    -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
    /*
    WHERE M.BASIS_YYYYMMDD BETWEEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7,'YYYYMMDD')  --당주 월요일부터
                                AND TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7 + 52*7,'YYYYMMDD')  -- 52주후 월요일까지
    */
    -----------------------------------------------------------------------------------------------------------------------------------
    WHERE  M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7,'YYYYMMDD')   --당주 월요일부터
      AND  M.BASIS_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7 + 52*7,'YYYYMMDD');  -- 52주후 월요일까지
    -- [E20250825-000297] (END)
    -----------------------------------------------------------------------------------------------------------------------------------

    INSERT INTO SCM_MGR.GT_DMF3_T_PRICE
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
    , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
    SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID
                  , B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE
    FROM   SCM_MGR.GT_DMF3_RESULTS A
    JOIN   SCM_MGR.SCM_MST_FUTURE_PRICE B
      ON   A.V_DIVISION_ID    = B.DIVISION_ID
     AND   A.V_PROJECT_CODE   = B.PROJECT_CODE
     AND   A.V_SCM_SITE_ID    = B.SCM_SITE_ID
     AND   A.V_PLANT_SITE_ID  = CASE WHEN A.V_DIVISION_ID LIKE '81%' THEN B.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
     AND   A.V_ITEM_ID        = B.ITEM_ID
     AND   A.V_DOM_EXP        = B.DOM_EXP
     AND   A.V_FCST_TYPE      = B.FCST_TYPE
     AND   A.V_INCOTERMS      = B.INCOTERMS
    WHERE  B.DIVISION_ID      = V_DIVISION_ID
      AND  B.YYYYMMDD        BETWEEN V_MIN_DATE AND V_MAX_DATE
      AND  B.PRICE           <> 0;

    ---------------------------------------------------------------------------------------------------------

    -- GT_DMF3_RESULTS 테이블의 VMI_YN UPDATE
    UPDATE SCM_MGR.GT_DMF3_RESULTS A
    SET    V_VMI_YN = (
               SELECT CASE WHEN NVL(B.VMI_YN, '-') = 'Y' THEN 'Y' ELSE 'N' END
               FROM   SCM_MGR.SCM_MST_SITE B
               WHERE  B.DIVISION_ID = A.V_DIVISION_ID
                 AND  B.SCM_SITE_ID = A.V_SCM_SITE_ID
           );

    -- AS 이더라도 AS Plant 에는 Attribute10 을 지워준다.
    UPDATE SCM_MGR.GT_DMF3_RESULTS A
    SET    V_ATTRIBUTE10 = '-'
    WHERE  V_SCM_SITE_ID = V_ATTRIBUTE10;

    /*
    [E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선 사용하지 않아도 됨 (START)
    -- AS 인데, FROM Site 가 없는 건들은 오류처리한다. ( WS, 20211103 )
	-- FCST Type 에 WS, WSF가 포함되어있는데, From Site 가 없는 경우 에러처리
	IF EXISTS ( SELECT *
				FROM #results A
				JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON A.v_division_id = B.DIVISION_ID
					AND A.v_scm_site_id = B.SCM_SITE_ID
					AND ISNULL(B.OPERATION_GROUP,'') <> 'W'
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
					ON A.v_fcst_type = C.SEGMENT1
					AND C.LOOKUP_TYPE = 'SALES_TYPE_CODE'
					AND C.ATTRIBUTE2 = 'Y'
				)
		AND NOT EXISTS ( SELECT *
							FROM SCM_MST_SITE WITH(NOLOCK)
							WHERE DIVISION_ID = @v_division_id
							AND SCM_SITE_ID = @v_as_from_site
						)
		BEGIN
			SET @v_log_type = 'INVALID';
			--[E20260211-001189]_내용변경 (START)
			--SELECT N'AS 관련 FCST TYPE 을 사용할 경우 상단 Sales Site 에 AS Plant 가 선택되어있어야 합니다.'
			SELECT N'AS 관련 FCST TYPE 을 사용할 경우 AS FROM SITE를 선택해야 합니다.'
			--SET @v_description =  N'AS 관련 FCST TYPE 을 사용할 경우 상단 Sales Site 에 AS Plant 가 선택되어있어야 합니다.'
			SET @v_description =  N'AS 관련 FCST TYPE 을 사용할 경우 AS FROM SITE를 선택해야 합니다.'
			--[E20260211-001189]_내용변경 (END)
			GOTO ERR_RTN
		END

	-- AS 유효성 체크
	-- AS FROM SITE 가 여러개 있거나 없는 경우
	IF NOT EXISTS (	SELECT COUNT(*)
					FROM DBO.UF_FX_String_Split(@p_as_from_site, '^') A
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
						ON A.TOKEN = B.SEGMENT1
						AND B.LOOKUP_TYPE = 'AS_SITE_PLANT'
						AND B.SEGMENT2 <> '-' AND B.SEGMENT3 = @v_division_id
						HAVING COUNT(*) = 1
					)
		-- 고객향이 포함된 경우 ( AS PLANT 로 가는 데이터만 있을 경우 FROM SITE 필요 없음 )
		AND EXISTS ( SELECT *
						FROM #results A
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
									ON A.v_scm_site_id = B.SEGMENT1
									AND B.LOOKUP_TYPE = 'AS_SITE_PLANT'
									AND B.SEGMENT2 <> '-' AND B.SEGMENT3 = @v_division_id
						WHERE B.SEGMENT1 IS NULL
					) -- AS FCST TYPE 이 있을 경우
		AND EXISTS ( SELECT *
						FROM #results A
						JOIN SCM_MST_SITE B WITH(NOLOCK)
						ON A.v_division_id = B.DIVISION_ID
						AND A.v_scm_site_id = B.SCM_SITE_ID
						AND ISNULL(B.OPERATION_GROUP,'') <> 'W'
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
						ON A.v_fcst_type = C.SEGMENT1
						AND C.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND C.ATTRIBUTE2 = 'Y'
					)
		BEGIN
			SET @v_log_type = 'INVALID';
			--[E20260211-001189]_내용변경 (START)
			--SELECT N'AS 가 체크되었을 때에는 한 개의 AS PLANT 가 Sales Site 에 선택이 되어야 합니다.'
			SELECT N'AS 관련 FCST TYPE을 선택했을 때에는 한 개의 AS FROM SITE가 선택이 되어야 합니다.'
			--SET @v_description =  N'AS 가 체크되었을 때에는 한 개의 AS PLANT 가 Sales Site 에 선택이 되어야 합니다.!'
			SET @v_description =  N'AS 관련 FCST TYPE을 선택했을 때에는 한 개의 AS FROM SITE가 선택이 되어야 합니다.!'
			--[E20260211-001189]_내용변경 (END)
			goto err_rtn
		END
    [E20260211-001189] (END)
    */

    -- AS PLANT 로 가는 DP의 INCOTERMS 를 제한한다.
    DECLARE
        V_INCO_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_INCO_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON   A.V_DIVISION_ID = B.SEGMENT3
         AND   A.V_SCM_SITE_ID = B.SEGMENT1
         AND   B.LOOKUP_TYPE   = 'AS_SITE_PLANT'
         AND   B.VALID_YN      = 'Y'
        LEFT   JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
          ON   A.V_DIVISION_ID = C.SEGMENT1
         AND   A.V_INCOTERMS   = C.SEGMENT2
         AND   C.VALID_YN      = 'Y'
        WHERE  C.SEGMENT1 IS NULL;

        IF V_INCO_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'AS In Request 메저는 지정된 Incoterms 만 사용가능합니다.';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;

    --==========================================================================================================================
    -- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (START)
    --==========================================================================================================================
    DECLARE
        V_OLD_INCO_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(1) INTO V_OLD_INCO_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        WHERE  A.V_INCOTERMS IN (
                   SELECT OLD_VALUE1
                   FROM   SCM_MGR.NERP_CONV_MASTER
                   WHERE  CODETYPE = 'INCOTERMS_ID'
                   GROUP BY OLD_VALUE1
               );
        IF V_OLD_INCO_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '구코드 INCOTERMS는 저장할 수 없습니다.';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    --==========================================================================================================================
    -- [E20250919-001699] (END)
    --==========================================================================================================================

    -- 중장기계획 기간 조회
    SELECT MIN(C.BASIS_YYYYMMDD), MAX(C.BASIS_YYYYMMDD)
    INTO   V_FROM_DATE, V_TO_DATE
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
    JOIN   SCM_MGR.SCM_SYS_CALENDAR_M C
      ON   C.BASIS_YYYYMM = L.ATTRIBUTE1 OR C.BASIS_YYYYMM = L.ATTRIBUTE2
    WHERE  L.LOOKUP_TYPE = 'DM_LONG_PLAN'
      AND  L.SEGMENT1    = '40'
      AND  L.SEGMENT2    = 'MKT FCST'
      AND  L.VALID_YN    = 'Y';

    -- 소형일 경우 중장기계획 관련 기간 확인
    IF V_DIVISION_ID = '40' THEN
        DECLARE
            V_OOB_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_OOB_CNT
            FROM   SCM_MGR.GT_DMF3_RESULTS R
            WHERE  R.V_YYYYMMDD < V_FROM_DATE OR R.V_YYYYMMDD > V_TO_DATE;
            IF V_OOB_CNT > 0 THEN
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := V_FROM_DATE || ' ~ ' || V_TO_DATE || ' 구간 내의 데이터만 수정할 수 있습니다.';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181012 BLOCK Model (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    V_S_BLOCK_MODEL := '-';
    BEGIN
        SELECT V_ITEM_ID INTO V_S_BLOCK_MODEL
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE  LOOKUP_TYPE = 'FCST_EXCEPT_MODEL'
                     AND  SEGMENT1   = '40'
                     AND  VALID_YN   = 'Y'
                     AND  SEGMENT2   = A.V_ITEM_ID
               )
          AND  A.V_QTY <> 0
          AND  ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_S_BLOCK_MODEL := '-';
    END;

    IF V_S_BLOCK_MODEL <> '-' THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := 'Model : ' || V_S_BLOCK_MODEL || CHR(10) || 'FCST INPUT BLOCK Model. contact 영업관리팀';
        V_INVALID     := TRUE;
        GOTO ERR_RTN;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181012 BLOCK Model (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- PROJECT_CODE,ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 저장전 변수 초기화
    V_CHECK_CNT          := 0;
    V_VALID_PROJECT_CODE := NULL;
    V_VALID_ITEM_ID      := NULL;
    V_VALID_ITEM_ID_2    := NULL;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID <> '40';

    IF V_CHECK_CNT > 0 THEN
        BEGIN
            SELECT A.V_PROJECT_CODE INTO V_VALID_PROJECT_CODE
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            WHERE  NOT EXISTS (
                       SELECT C.DIVISION_ID
                       FROM   SCM_MGR.SCM_MST_PROJECT C
                       WHERE  A.V_DIVISION_ID  = C.DIVISION_ID
                         AND  A.V_PROJECT_CODE = C.PROJECT_CODE
                         AND  C.DIVISION_ID   <> '40'
                   )
              AND  A.V_DIVISION_ID <> '40'
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_PROJECT_CODE := NULL;
        END;
        IF V_VALID_PROJECT_CODE IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_PROJECT_CODE || '] Invalid Project Code !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END IF;

    BEGIN
        SELECT A.V_ITEM_ID INTO V_VALID_ITEM_ID
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        WHERE  NOT EXISTS (
                   SELECT ITEM.DIVISION_ID
                   FROM   SCM_MGR.SCM_MST_SITE_ITEM ITEM
                   JOIN   SCM_MGR.SCM_MST_ITEM_SN   SN
                     ON   ITEM.DIVISION_ID = SN.DIVISION_ID
                    AND   ITEM.ITEM_ID     = SN.ITEM_ID
                   WHERE  ITEM.DIVISION_ID  = A.V_DIVISION_ID
                     AND  ITEM.PROJECT_CODE = A.V_PROJECT_CODE
                     AND  ITEM.SCM_SITE_ID  = A.V_SCM_SITE_ID
                     AND  ITEM.ITEM_ID      = A.V_ITEM_ID
                     AND  SN.ACTIVE_FLAG    = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                     AND  ITEM.VALID_YN     = 'Y'  -- [C20200812-000104]
               )
          AND  ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_VALID_ITEM_ID := NULL;
    END;
    IF V_VALID_ITEM_ID IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '[' || V_VALID_ITEM_ID || '] Invalid Site Item ID !';
        V_INVALID     := TRUE;
        GOTO ERR_RTN;
    END IF;

    -- [C20200717-000157] ESS사업부 Sales Site Project Model Sales Company, Sales Plant Validation 추가
    V_CHECK_CNT          := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '82';

    IF V_CHECK_CNT > 0 THEN
        BEGIN
            SELECT A.V_ITEM_ID INTO V_VALID_ITEM_ID
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            WHERE  EXISTS (
                       SELECT ITEM.DIVISION_ID
                       FROM   SCM_MGR.SCM_MST_SITE_ITEM ITEM
                       JOIN   SCM_MGR.SCM_MST_ITEM_SN   SN
                         ON   ITEM.DIVISION_ID = SN.DIVISION_ID
                        AND   ITEM.ITEM_ID     = SN.ITEM_ID
                       WHERE  ITEM.DIVISION_ID  = A.V_DIVISION_ID
                         AND  ITEM.PROJECT_CODE = A.V_PROJECT_CODE
                         AND  ITEM.SCM_SITE_ID  = A.V_SCM_SITE_ID
                         AND  ITEM.ITEM_ID      = A.V_ITEM_ID
                         AND  SN.ACTIVE_FLAG    = 'Y'
                         AND  ( (ITEM.SALES_COMPANY IS NULL OR ITEM.SALES_COMPANY = '-')
                              OR (ITEM.SALES_PLANT   IS NULL OR ITEM.SALES_PLANT   = '-') )
                   )
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_ITEM_ID := NULL;
        END;
        IF V_VALID_ITEM_ID IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_ITEM_ID || '] Sales Company/Plant does not exist !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- PROJECT_CODE,ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    --  20200529 KHSONG C20200424-000010 (Sales Price 필수 입력 구간 관련의 건) Unit Price 유무 Validation (START)
    -------------------------------------------------------------------------------------◎◎◎◎

    -- #mshychu1 → T_MSHYCHU1 (단일 컬럼 Type)
    SELECT SEGMENT2
    BULK COLLECT INTO T_MSHYCHU1
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
      AND  MST.SEGMENT1    = 'MEASURE'
      AND  MST.VALID_YN    = 'Y';

    -- #mshychu2 → T_MSHYCHU2
    SELECT SEGMENT2
    BULK COLLECT INTO T_MSHYCHU2
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
      AND  MST.SEGMENT1    = 'FCST_TYPE'
      AND  MST.VALID_YN    = 'Y';

    -- [E20231020-001565] 현장설치품 예외 모델 로드
    SELECT SEGMENT2
    BULK COLLECT INTO T_ESS_PRICE_EXCEPT
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'ESS_PRICE_EXCEPT_MODEL'
      AND  MST.SEGMENT1    = V_DIVISION_ID   -- 82번사업부만해당
      AND  MST.VALID_YN    = 'Y';

    V_S_UNIT_PRICE_VALID := NULL;
    BEGIN
        SELECT
            CASE WHEN A.V_DIVISION_ID = '40'
                 THEN 'End Customer________ : ' || NVL(V_PROJECT_CODE, '-')
                 ELSE 'Project_________ : '     || NVL(V_PROJECT_CODE, '-') END
            || CHR(10) || 'Sales site_____________ : '   || NVL(V_SCM_SITE_ID,   '-')
            || CHR(10) || 'Model________________ : '     || NVL(V_ITEM_ID,        '-')
            || CHR(10) || 'Customs Handbook__ : '        || NVL(V_DOM_EXP,        '-')
            || CHR(10) || 'Fcst Type_____________ : '    ||
                NVL(( SELECT SEGMENT2
                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                      WHERE  MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND  MST.SEGMENT1    = A.V_FCST_TYPE
                        AND  ROWNUM = 1 ), '-')  -- 20180917 KHSONG fcst_type LOOKUP참조하여 출력으로 변경
            || CHR(10) || 'Incoterms____________ : '     || NVL(V_INCOTERMS,      '-')
            || CHR(10) || 'Plant Site___________ : '     || NVL(V_PLANT_SITE_ID,  '-')  -- [C20200525-000296]
            || CHR(10) || 'YYYYMMDD_________ : '         || NVL(MIN(M.BASIS_START_DATE),'-') || ' ~ ' || NVL(MAX(M.BASIS_START_DATE),'-')  -- [C20210203-000427]
            || CHR(10) || CHR(10)
        INTO V_S_UNIT_PRICE_VALID
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        --  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
        JOIN   SCM_MGR.SCM_MST_SITE_ITEM Z
          ON   A.V_DIVISION_ID   = Z.DIVISION_ID
         AND   A.V_PROJECT_CODE  = Z.PROJECT_CODE
         AND   A.V_SCM_SITE_ID   = Z.SCM_SITE_ID
         AND   A.V_ITEM_ID       = Z.ITEM_ID
         AND   Z.VALID_YN        = 'Y'
         AND   ( Z.SALES_PLAN_ADJUST_YN = 'Y' OR NVL(Z.SALES_PLAN_ADJUST_YN,'-') = '-' )  -- 20181023 보완
        --  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
        LEFT   JOIN (  -- [C20210203-000427]
                       SELECT BASIS_START_DATE
                       FROM   SCM_MGR.SCM_SYS_CALENDAR_M M
                       -----------------------------------------------------------------------------------------------------------------------------------
                       -- [E20250825-000297] (START)
                       /*
                       WHERE M.BASIS_YYYYMMDD BETWEEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
                                               AND TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')
                       */
                       WHERE  M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')   --당주 월요일부터
                         AND  M.BASIS_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')  -- 52주후 월요일까지
                       -- [E20250825-000297] (END)
                       -----------------------------------------------------------------------------------------------------------------------------------
                       GROUP BY BASIS_START_DATE
                   ) M
          ON   1=1
        LEFT   JOIN SCM_MGR.GT_DMF3_T_PRICE P
          ON   A.V_DIVISION_ID   = P.DIVISION_ID
         AND   A.V_PROJECT_CODE  = P.PROJECT_CODE
         AND   A.V_SCM_SITE_ID   = P.SCM_SITE_ID
         AND   A.V_ITEM_ID       = P.ITEM_ID
         AND   A.V_DOM_EXP       = P.DOM_EXP
         AND   A.V_FCST_TYPE     = P.FCST_TYPE
         AND   A.V_INCOTERMS     = P.INCOTERMS
         AND   A.V_PLANT_SITE_ID = CASE WHEN A.V_DIVISION_ID LIKE '81%' THEN P.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END  -- [C20200525-000296]
         AND   P.YYYYMMDD        = M.BASIS_START_DATE
         AND   P.PRICE > 0
        WHERE  P.YYYYMMDD IS NULL  -- PRICE값이 없는경우
          AND  A.V_MEASURE IN (SELECT COLUMN_VALUE FROM TABLE(T_MSHYCHU1))
          AND  A.V_QTY     <> 0
          AND  A.V_FCST_TYPE NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_MSHYCHU2))
          AND  A.V_ITEM_ID NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_ESS_PRICE_EXCEPT))  -- [E20231020-001565]
        GROUP  BY A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID
                , A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_MEASURE, A.V_PLANT_SITE_ID, P.YYYYMMDD
        ORDER  BY A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID
                , A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_MEASURE, A.V_PLANT_SITE_ID, P.YYYYMMDD
        FETCH FIRST 1 ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_S_UNIT_PRICE_VALID := NULL;
    END;

    IF V_S_UNIT_PRICE_VALID IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := V_S_UNIT_PRICE_VALID || 'Unit Price Not Found !' || CHR(10)
                      || '해당주차의 Sales Price 값을 입력하시기 바랍니다.' || CHR(10)
                      || '미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.';
        V_INVALID     := TRUE;
        GOTO ERR_RTN;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    --  20200529 KHSONG C20200424-000010 Unit Price 유무 Validation (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 RMA FCST_TYPE 음수값 validation (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    DECLARE
        V_RMA_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT NVL(COUNT(*),0) INTO V_RMA_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS
        WHERE  V_FCST_TYPE = 'RMA'
          AND  V_QTY > 0;
        IF V_RMA_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '반품수량(RMA)은 음수값만 입력가능합니다 !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 RMA FCST_TYPE 음수값 validation (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181108 RMA FCST_TYPE 이외의 MEASURE 정수값 validation (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    DECLARE
        V_NEG_CNT PLS_INTEGER := 0;
    BEGIN
        SELECT NVL(COUNT(*),0) INTO V_NEG_CNT
        FROM   SCM_MGR.GT_DMF3_RESULTS
        WHERE  V_FCST_TYPE <> 'RMA'
          AND  V_QTY < 0;
        IF V_NEG_CNT > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '정수값만 입력가능합니다 !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181108 RMA FCST_TYPE 이외의 MEASURE 정수값 validation (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -- Start [C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
    V_VALID_TYPE := NULL;
    V_CHECK_CNT          := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID LIKE '81%';


    IF V_CHECK_CNT > 0 THEN

        INSERT INTO SCM_MGR.GT_DMF3_ITEM_SINGLE_V
        ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
        , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
        , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
        , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE, ENERGE
        , CELL_QUANTITY )
        SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
             , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
             , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
             , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE, ENERGE
             , CELL_QUANTITY
        FROM (
            SELECT T2.DIVISION_ID, T2.ITEM_ID, T2.ITEM_NAME, T2.ITEM_CLASS, T2.ITEM_CLASS_NAME
                 , T2.NICK_NAME, T2.ITEM_TYPE, T2.MATERIAL_CLASS_NAME, T2.ITEM_UOM, T2.SPEC
                 , T2.MDM_PROJECT_NAME, T2.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
                 , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION, T2.ACTIVE_FLAG, T2.CELL_TYPE, T2.ENERGE
                 , T2.CELL_QUANTITY
            FROM  SCM_MGR.DM_MST_ITEM_SINGLE_V T2
            JOIN  SCM_MGR.GT_DMF3_RESULTS A
              ON  A.V_DIVISION_ID = T2.DIVISION_ID
             AND  A.V_ITEM_ID     = T2.ITEM_ID
        ) G
        GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
               , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
               , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
               , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE, ENERGE
               , CELL_QUANTITY;

        BEGIN
            SELECT A.V_ITEM_ID INTO V_VALID_ITEM_ID
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            LEFT   JOIN SCM_MGR.SCM_MST_SITE_ITEM F
              ON   A.V_DIVISION_ID   = F.DIVISION_ID
             AND   A.V_ITEM_ID       = F.ITEM_ID
             AND   A.V_PROJECT_CODE  = F.PROJECT_CODE
             AND   A.V_SCM_SITE_ID   = F.SCM_SITE_ID
            JOIN   SCM_MGR.GT_DMF3_ITEM_SINGLE_V X
              ON   A.V_DIVISION_ID = X.DIVISION_ID
             AND   A.V_ITEM_ID     = X.ITEM_ID
            WHERE  CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Cell') > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Pack') > 0  AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        ELSE 0
                   END = 1
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_ITEM_ID := NULL;
        END;

        IF V_VALID_ITEM_ID IS NOT NULL THEN
            BEGIN
                SELECT CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 THEN 'Cell/Car or Cell/Module'
                            ELSE 'Cell/Car' END
                INTO   V_VALID_TYPE
                FROM   SCM_MGR.GT_DMF3_ITEM_SINGLE_V X
                WHERE  X.ITEM_ID = V_VALID_ITEM_ID
                  AND  ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN V_VALID_TYPE := '-';
            END;
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_ITEM_ID || '] ' || V_VALID_TYPE || ' does not exist !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END IF;
    -- END [C20200511-000360]

    -- START [C20220713-000194]
    V_CHECK_CNT  := 0;
    SELECT CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF3_RESULTS A WHERE A.V_DIVISION_ID LIKE '81%')
           THEN 1 ELSE 0 END
    INTO V_CHECK_CNT
    FROM DUAL;

    IF V_CHECK_CNT > 0 THEN -- Case 28 변환
        DECLARE
            V_DESC_81 VARCHAR2(4000 CHAR);
        BEGIN
            SELECT V_DESCRIPTION INTO V_DESC_81
            FROM (
                SELECT '[' || RTRIM(A.V_ITEM_ID) || '] '
                    || CASE WHEN (NOT REGEXP_LIKE(B.ATTRIBUTE8, '^[0-9.]+$') OR NVL(TO_NUMBER(B.ATTRIBUTE8),0) <= 0)
                            THEN 'Kwh/Cell does not exist !'
                            WHEN B.ATTRIBUTE10 NOT IN (
                                     SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND SEGMENT1 LIKE '81%' AND VALID_YN = 'Y'
                                 )
                            THEN 'CELL_TYPE does not exist !'
                            WHEN NVL(B.CELL_PER_CAR,0) <= 0
                            THEN 'Cell/Car does not exist !'
                       END
                    || CHR(10) || 'Sales Site Project Model 에서 해당 항목을 채워주세요.' AS V_DESCRIPTION
                FROM SCM_MGR.GT_DMF3_RESULTS A
                JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                  ON A.V_DIVISION_ID  = B.DIVISION_ID
                 AND A.V_PROJECT_CODE = B.PROJECT_CODE
                 AND A.V_SCM_SITE_ID  = B.SCM_SITE_ID
                 AND A.V_ITEM_ID      = B.ITEM_ID
                JOIN SCM_MGR.GT_DMF3_ITEM_SINGLE_V C
                  ON A.V_DIVISION_ID  = C.DIVISION_ID
                 AND A.V_ITEM_ID      = C.ITEM_ID
                 AND C.ITEM_TYPE      = 'P'
                WHERE A.V_DIVISION_ID LIKE '81%'
                  AND (
                        ( NOT REGEXP_LIKE(NVL(B.ATTRIBUTE8,'-'), '^[0-9.]+$')
                          OR TO_NUMBER(CASE WHEN REGEXP_LIKE(NVL(B.ATTRIBUTE8,'0'), '^[0-9.]+$') THEN B.ATTRIBUTE8 ELSE '0' END) <= 0 )
                        OR B.ATTRIBUTE10 NOT IN (
                               SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND SEGMENT1 LIKE '81%' AND VALID_YN = 'Y'
                           )
                        OR NVL(B.CELL_PER_CAR,0) <= 0
                      )
                ORDER BY A.V_ITEM_ID
                FETCH FIRST 1 ROW ONLY
            );
            IF V_DESC_81 IS NOT NULL THEN
                V_DESCRIPTION := V_DESC_81;
                V_LOG_TYPE    := 'INVALID';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
    END IF;
    -- END [C20220713-000194]

    -- [C20200804-000123] SSP 동기화 수량보다 작은 수량으로 수정 불가 ( 소형 & MKT FCST 메저 ) ------------ START
    V_CHECK_CNT  := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '40' AND V_MEASURE = 'MKT_FCST';

    IF V_CHECK_CNT > 0 THEN

        -- 아래에서 I/O 처리시 DELETE 후 INSERT 이므로 ATTRIBUTE를 보존하기 위해 업데이트
        UPDATE SCM_MGR.GT_DMF3_RESULTS A
        SET    ( V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5 ) =
               ( SELECT B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.ATTRIBUTE5
                 FROM   SCM_MGR.DM_PLN_MKT_FCST B
                 WHERE  B.DIVISION_ID  = A.V_DIVISION_ID
                   AND  B.PROJECT_CODE = A.V_PROJECT_CODE
                   AND  B.SCM_SITE_ID  = A.V_SCM_SITE_ID
                   AND  B.ITEM_ID      = A.V_ITEM_ID
                   AND  B.DOM_EXP      = A.V_DOM_EXP
                   AND  B.FCST_TYPE    = A.V_FCST_TYPE
                   AND  B.INCOTERMS    = A.V_INCOTERMS
                   AND  B.MEASURE      = A.V_MEASURE
                   AND  B.YYYYMMDD     = A.V_YYYYMMDD
                   AND  B.MEASURE      = 'MKT_FCST'
                   AND  REGEXP_LIKE(NVL(B.ATTRIBUTE1,'-'), '^[0-9.]+$')
                   AND  B.DIVISION_ID  = V_DIVISION_ID
                   AND  EXISTS ( SELECT 1 FROM SCM_MGR.SCM_MST_SITE C
                                 WHERE B.DIVISION_ID = C.DIVISION_ID
                                   AND B.SCM_SITE_ID = C.SCM_SITE_ID
                                   AND C.VMI_YN <> 'Y' )
               );

        -- [C20210225-000385] 동기화 수량보다 작은 수량은 입력 불가(원복)
        INSERT INTO SCM_MGR.GT_DMF3_T_ERR
        ( PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, SYNC_QTY, QTY )
        SELECT A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS
             , A.V_MEASURE, A.V_YYYYMMDD
             , CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE2,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE2) ELSE 0 END
             + CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE3,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE3) ELSE 0 END
               AS SYNC_QTY
             , A.V_QTY
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_MST_SITE C
          ON   A.V_DIVISION_ID = C.DIVISION_ID
         AND   A.V_SCM_SITE_ID = C.SCM_SITE_ID
         AND   C.VMI_YN <> 'Y'
        WHERE  A.V_DIVISION_ID = V_DIVISION_ID
          AND  REGEXP_LIKE(NVL(A.V_ATTRIBUTE1,'-'), '^[0-9.]+$')
          AND  A.V_MEASURE     = 'MKT_FCST'
          AND  CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE2,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE2) ELSE 0 END
             + CASE WHEN REGEXP_LIKE(NVL(A.V_ATTRIBUTE3,'-'), '^[0-9.]+$') THEN TO_NUMBER(A.V_ATTRIBUTE3) ELSE 0 END
               > A.V_QTY
          AND  A.V_YYYYMMDD <> TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');

        DECLARE
            V_T_ERR_CNT PLS_INTEGER := 0;
        BEGIN
            SELECT COUNT(1) INTO V_T_ERR_CNT FROM SCM_MGR.GT_DMF3_T_ERR;
            IF V_T_ERR_CNT > 0 THEN
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := 'SSP 동기화 수량보다 작은 수량으로 수정된 건이 있습니다.';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;
    -- [C20200804-000123] END ------------

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG BOM 검증 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    --IF (SELECT count(1) FROM GT_DMF3_RESULTS where V_DIVISION_ID = '40') = 0  -- 20180914-1 주석처리
    BEGIN
        UPDATE SCM_MGR.GT_DMF3_RESULTS A
        SET    V_BOM_YN = 'N'
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
                   WHERE  B.LOOKUP_TYPE    = 'AS_SITE_PLANT'
                     AND  B.SEGMENT3       = V_DIVISION_ID
                     AND  B.VALID_YN       = 'Y'
                     AND  A.V_ATTRIBUTE10  = B.SEGMENT2
               )
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_MST_ITEM_SN C
                   WHERE  C.DIVISION_ID = A.V_DIVISION_ID
                     AND  C.ITEM_ID     = A.V_ITEM_ID
               )
          AND  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
                   JOIN   SCM_MGR.SCM_MST_ITEM_SN CC
                     ON   CC.DIVISION_ID = A.V_DIVISION_ID
                    AND   CC.ITEM_ID     = A.V_ITEM_ID
                    AND   CC.EVAL_CLASS  = D.SEGMENT1
                   WHERE  D.LOOKUP_TYPE = 'DM_BOM_EXCEPT_CLASS'
                     AND  D.VALID_YN    = 'Y'
               )
          AND  A.V_DIVISION_ID = V_DIVISION_ID
          AND  A.V_MEASURE     = 'MKT_FCST';

        V_CHECK_CNT  := 0;
        SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_BOM_YN IS NULL;

        IF V_CHECK_CNT > 0 THEN
            V_VALID_BOM   := NULL;
            V_VALID_SHIPTO := NULL;

            BEGIN
                SELECT A.V_ITEM_ID INTO V_VALID_BOM
                FROM   SCM_MGR.GT_DMF3_RESULTS A
                JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V C
                  ON   A.V_ITEM_ID     = C.ITEM_ID
                 AND   A.V_DIVISION_ID = C.DIVISION_ID
                 AND   C.ITEM_TYPE     IN ('P','H')
                 AND   C.ACTIVE_FLAG   = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                LEFT   JOIN SCM_MGR.SCM_MST_BOM_ENG_SN X
                  ON   A.V_DIVISION_ID    = X.DIVISION_ID
                 AND   A.V_ITEM_ID        = X.PARENT_ITEM_ID
                LEFT   JOIN (
                                SELECT DIVISION_ID
                                     , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END AS FROM_SITE  -- 20180914 소형도 FROM_SITE 조건에 추가
                                     , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                                FROM  SCM_MGR.SCP_MST_BOD_V
                                WHERE PRIORITY = 1
                                GROUP BY DIVISION_ID
                                       , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END
                                       , TO_SITE, INCOTERMS  -- 20180914 소형도 FROM_SITE 조건에 추가
                            ) BOD
                  ON   A.V_DIVISION_ID   = BOD.DIVISION_ID
                 AND   A.V_PLANT_SITE_ID = BOD.FROM_SITE
                 AND   A.V_SCM_SITE_ID   = BOD.TO_SITE
                 AND   A.V_INCOTERMS     = BOD.INCOTERMS
                WHERE  A.V_MEASURE  IN ('MKT_FCST','Vmi_In_Req')
                  AND  A.V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')   -- 당주 월요일부터
                  AND  A.V_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') + NVL(BOD.LT_TOTAL,0) + 70, 'YYYYMMDD')  -- 당주 월요일 + 11주 까지
                  AND  A.V_QTY      > 0
                  AND  X.PARENT_ITEM_ID IS NULL  -- 존재하지 않는대상
                  AND  A.V_ITEM_ID NOT IN ('ECE0074N5-01')  -- 20190614 김성은 책임 요청으로 'ECE0074N5-01' item bom 검증 조건에서 임시 해제시킴
                  AND  A.V_ITEM_ID NOT IN ('MCCH120022B2-K','MCCH120022B2-GD')  -- 20190708 김성은 책임 요청으로 item bom 검증 조건에서 임시 해제시킴
                  AND  A.V_BOM_YN IS NULL
                  AND  ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN V_VALID_BOM := NULL;
            END;

            IF V_VALID_BOM IS NOT NULL THEN
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := '[' || V_VALID_BOM || '] BOM does not exist !';
                V_INVALID     := TRUE;
                GOTO ERR_RTN;
            END IF;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG BOM 검증 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG SHIPTO 검증 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    -- IF (SELECT count(1) FROM GT_DMF3_RESULTS where V_DIVISION_ID = '40') = 0  -- 20180914-2 주석처리
    BEGIN
        BEGIN
            SELECT A.V_SCM_SITE_ID INTO V_VALID_SHIPTO
            FROM   SCM_MGR.GT_DMF3_RESULTS A
            LEFT   JOIN SCM_MGR.SCM_MST_SITE_CUSTOMER X
              ON   A.V_DIVISION_ID = X.DIVISION_ID
             AND   A.V_SCM_SITE_ID = X.SCM_SITE_ID
             AND   X.VALID_YN      = 'Y'
             AND   X.REP_YN        = 'Y'
            LEFT   JOIN (
                            SELECT DIVISION_ID
                                 , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END AS FROM_SITE  -- 20180914 소형도 FROM_SITE 조건에 추가
                                 , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                            FROM  SCM_MGR.SCP_MST_BOD_V
                            WHERE PRIORITY = 1
                            GROUP BY DIVISION_ID
                                   , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END
                                   , TO_SITE, INCOTERMS  -- 20180914 소형도 FROM_SITE 조건에 추가
                        ) BOD
              ON   A.V_DIVISION_ID   = BOD.DIVISION_ID
             AND   A.V_PLANT_SITE_ID = BOD.FROM_SITE
             AND   A.V_SCM_SITE_ID   = BOD.TO_SITE
             AND   A.V_INCOTERMS     = BOD.INCOTERMS
            WHERE  A.V_MEASURE  IN ('MKT_FCST','Vmi_In_Req')
              AND  A.V_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')   -- 당주 월요일부터
              AND  A.V_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') + NVL(BOD.LT_TOTAL,0) + 21, 'YYYYMMDD')   -- BOD LT + 4W
              AND  A.V_QTY      > 0
              AND  X.SHIPTO_CODE IS NULL
              AND  ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_VALID_SHIPTO := NULL;
        END;

        IF V_VALID_SHIPTO IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_SHIPTO || '] SITE SHIP-TO does not exist !';
            V_INVALID     := TRUE;
            GOTO ERR_RTN;
        END IF;
    END;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180703 KHSONG SHIPTO 검증 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 2021.4.20 hwi1993 [PJ20209642R]과제 - PR Request 가 존재하는 건들은 수정 못하도록 함. (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    V_CHECK_CNT  := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '82' AND V_MEASURE = 'BNPIn';

    IF V_CHECK_CNT > 0 THEN

        INSERT INTO SCM_MGR.GT_DMF3_T_ERR2
        ( SCM_SITE_ID, ITEM_ID, FCST_TYPE, YYYYMMDD )
        SELECT DISTINCT B.SCM_SITE_ID, B.ITEM_ID, B.FCST_TYPE, B.YYYYMMDD
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.DM_PLN_PR_DETAIL B
          ON   A.V_DIVISION_ID   = B.DIVISION_ID
         AND   A.V_PROJECT_CODE  = B.PROJECT_CODE
         AND   A.V_SCM_SITE_ID   = B.SCM_SITE_ID
         AND   A.V_ITEM_ID       = B.ITEM_ID
         AND   A.V_DOM_EXP       = B.DOM_EXP
         AND   A.V_FCST_TYPE     = B.FCST_TYPE
         AND   A.V_INCOTERMS     = B.INCOTERMS
         AND   A.V_PLANT_SITE_ID = B.PLANT_SITE_ID
         AND   A.V_YYYYMMDD      = B.YYYYMMDD;

        DECLARE
            V_T_ERR2_CNT PLS_INTEGER := 0;
            V_ERR2_SCM   VARCHAR2(30 CHAR);
            V_ERR2_ITEM  VARCHAR2(50 CHAR);
            V_ERR2_FCST  VARCHAR2(20 CHAR);
            V_ERR2_YYYY  VARCHAR2(8 CHAR);
        BEGIN
            SELECT COUNT(1) INTO V_T_ERR2_CNT FROM SCM_MGR.GT_DMF3_T_ERR2;
            IF V_T_ERR2_CNT > 0 THEN
                SELECT SCM_SITE_ID, ITEM_ID, FCST_TYPE, YYYYMMDD
                INTO   V_ERR2_SCM, V_ERR2_ITEM, V_ERR2_FCST, V_ERR2_YYYY
                FROM   SCM_MGR.GT_DMF3_T_ERR2
                WHERE  ROWNUM = 1;
                V_ERR_CNT := V_T_ERR2_CNT;
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := '[Sales Site:' || RTRIM(V_ERR2_SCM)  || ']'
                              || '[Model :' || RTRIM(V_ERR2_ITEM) || ']'
                              || '[FCST Type :' || RTRIM(V_ERR2_FCST) || ']'
                              || '[YYYYMMDd :' || RTRIM(V_ERR2_YYYY) || ']'
                              || CASE WHEN V_ERR_CNT > 1 THEN '외 ' || TO_CHAR(V_ERR_CNT-1) || '건' ELSE ' ' END
                              || '은 기 Request 가 생성된 건입니다. 
 ADD History 팝업을 이용해서 수정해주세요';
                V_INVALID := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;

    -- ATTRIBUTE9 가 '' 이 아닌 경우 수정불가 ( ESS )
    V_CHECK_CNT  := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '82' AND V_MEASURE = 'BNPIn';

    IF V_CHECK_CNT > 0 THEN
        UPDATE SCM_MGR.GT_DMF3_RESULTS A
        SET    V_ATTRIBUTE9 = (
                   SELECT B.ATTRIBUTE9
                   FROM   SCM_MGR.DM_PLN_MKT_FCST B
                   WHERE  B.DIVISION_ID  = A.V_DIVISION_ID
                     AND  B.PROJECT_CODE = A.V_PROJECT_CODE
                     AND  B.SCM_SITE_ID  = A.V_SCM_SITE_ID
                     AND  B.ITEM_ID      = A.V_ITEM_ID
                     AND  B.DOM_EXP      = A.V_DOM_EXP
                     AND  B.FCST_TYPE    = A.V_FCST_TYPE
                     AND  B.INCOTERMS    = A.V_INCOTERMS
                     AND  B.MEASURE      = A.V_MEASURE
                     AND  B.YYYYMMDD     = A.V_YYYYMMDD
                     AND  B.MEASURE      = 'BNPIn'
                     AND  B.DIVISION_ID  = V_DIVISION_ID
               );

        DECLARE
            V_ATTR9_CNT PLS_INTEGER := 0;
            V_ATTR9_SCM VARCHAR2(30 CHAR);
            V_ATTR9_ITM VARCHAR2(50 CHAR);
            V_ATTR9_FCT VARCHAR2(20 CHAR);
            V_ATTR9_YYY VARCHAR2(8 CHAR);
        BEGIN
            SELECT COUNT(1) INTO V_ATTR9_CNT
            FROM   SCM_MGR.GT_DMF3_RESULTS
            WHERE  NVL(V_ATTRIBUTE9,'-') <> '-';

            IF V_ATTR9_CNT > 0 THEN
                SELECT V_SCM_SITE_ID, V_ITEM_ID, V_FCST_TYPE, V_YYYYMMDD
                INTO   V_ATTR9_SCM, V_ATTR9_ITM, V_ATTR9_FCT, V_ATTR9_YYY
                FROM   SCM_MGR.GT_DMF3_RESULTS
                WHERE  NVL(V_ATTRIBUTE9,'-') <> '-'
                  AND  ROWNUM = 1;
                V_ERR_CNT     := V_ATTR9_CNT;
                V_LOG_TYPE    := 'INVALID';
                V_DESCRIPTION := '[Sales Site:' || RTRIM(V_ATTR9_SCM) || ']'
                              || '[Model :' || RTRIM(V_ATTR9_ITM) || ']'
                              || '[FCST Type :' || RTRIM(V_ATTR9_FCT) || ']'
                              || '[YYYYMMDd :' || RTRIM(V_ATTR9_YYY) || ']'
                              || CASE WHEN V_ERR_CNT > 1 THEN '외 ' || TO_CHAR(V_ERR_CNT-1) || '건' ELSE ' ' END
                              || '은 기 Confirm ID 가 생성된 건입니다. 
 ADD History 팝업을 이용해서 수정해주세요';
                V_INVALID := TRUE;
                GOTO ERR_RTN;
            END IF;
        END;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 2021.4.20 hwi1993 [PJ20209642R] (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    --  INPUT MEASURE 중복값 delete후 INSERT (START)
    -------------------------------------------------------------------------------------◎◎◎◎

    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    -- 3. MKT FCST 테이블 INSERT
    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

    --[E20250313-001251]_bucket = 'Monthly' or 'Weekly'인 경우 우선 데이터를 0으로 UPDATE를 한뒤 데이터 작업을 시작한다. START
    IF P_BUCKET = 'MONTHLY' THEN
        UPDATE SCM_MGR.DM_PLN_MKT_FCST A
        SET    A.QTY = 0
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF3_RESULTS R
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BR
                     ON   R.V_YYYYMMDD = BR.BASIS_YYYYMMDD
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BA
                     ON   A.YYYYMMDD = BA.BASIS_YYYYMMDD
                   WHERE  A.DIVISION_ID    = R.V_DIVISION_ID
                     AND  A.PROJECT_CODE   = R.V_PROJECT_CODE
                     AND  A.SCM_SITE_ID    = R.V_SCM_SITE_ID
                     AND  A.ITEM_ID        = R.V_ITEM_ID
                     AND  A.DOM_EXP        = R.V_DOM_EXP
                     AND  A.FCST_TYPE      = R.V_FCST_TYPE
                     AND  A.INCOTERMS      = R.V_INCOTERMS
                     AND  A.MEASURE        = R.V_MEASURE
                     AND  A.PLANT_SITE_ID  = R.V_PLANT_SITE_ID
                     AND  BA.BASIS_YYYYMM  = BR.BASIS_YYYYMM
               );
    ELSIF P_BUCKET = 'WEEKLY' THEN
        UPDATE SCM_MGR.DM_PLN_MKT_FCST A
        SET    A.QTY = 0
        WHERE  EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF3_RESULTS R
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BR
                     ON   R.V_YYYYMMDD = BR.BASIS_YYYYMMDD
                   JOIN   SCM_MGR.SCM_SYS_CALENDAR_M BA
                     ON   A.YYYYMMDD = BA.BASIS_YYYYMMDD
                   WHERE  A.DIVISION_ID    = R.V_DIVISION_ID
                     AND  A.PROJECT_CODE   = R.V_PROJECT_CODE
                     AND  A.SCM_SITE_ID    = R.V_SCM_SITE_ID
                     AND  A.ITEM_ID        = R.V_ITEM_ID
                     AND  A.DOM_EXP        = R.V_DOM_EXP
                     AND  A.FCST_TYPE      = R.V_FCST_TYPE
                     AND  A.INCOTERMS      = R.V_INCOTERMS
                     AND  A.MEASURE        = R.V_MEASURE
                     AND  A.PLANT_SITE_ID  = R.V_PLANT_SITE_ID
                     AND  BA.BASIS_YYYYMM  = BR.BASIS_YYYYMM
                     AND  BA.ISO_YYYYWW    = BR.ISO_YYYYWW
               );
    END IF;
    --[E20250313-001251] END

    -- [] 81 -VMI 에 MKT FCST 가 있으면 VMI IN REQ 메저도 동일하게 생성/삭제한다.
    V_CHECK_CNT  := 0;
    SELECT COUNT(1)
    INTO   V_CHECK_CNT
    FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_MST_SITE B
          ON   A.V_SCM_SITE_ID = B.SCM_SITE_ID AND A.V_DIVISION_ID = B.DIVISION_ID AND B.VMI_YN = 'Y'
        WHERE  A.V_DIVISION_ID LIKE '81%'
          AND  A.V_MEASURE = 'MKT_FCST';

    IF V_CHECK_CNT > 0
    THEN
        INSERT INTO SCM_MGR.GT_DMF3_RESULTS
        ( V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
        , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
        , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10 )
        SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
             , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'VMI_In_Req' AS V_MEASURE, V_PLANT_SITE_ID
             , V_YYYYMMDD, V_QTY, V_CREATED_BY, V_ATTRIBUTE10
        FROM   SCM_MGR.GT_DMF3_RESULTS A
        JOIN   SCM_MGR.SCM_MST_SITE B
          ON   A.V_SCM_SITE_ID = B.SCM_SITE_ID
         AND   A.V_DIVISION_ID = B.DIVISION_ID
         AND   B.VMI_YN        = 'Y'
        WHERE  A.V_DIVISION_ID LIKE '81%'
          AND  A.V_MEASURE     = 'MKT_FCST';
    END IF;

    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS R
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = R.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = R.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = R.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = R.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = R.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = R.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = R.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.MEASURE        = R.V_MEASURE
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = R.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       = R.V_YYYYMMDD
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
    , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
         , V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
         , V_QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
         , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5  -- [C20210225-000385]
         , NULL, NULL, NULL, NULL, V_ATTRIBUTE10
    FROM   SCM_MGR.GT_DMF3_RESULTS;

    -----------------------------------------------------------------------
    -- [C20201103-000114] ESS 법인 MKT_FCST 메저에 따라 VMI_IN_REQ 자동 계산
    -----------------------------------------------------------------------
    FOR R_VMI IN CURSOR_ESSVMI1
    LOOP
        EV_DIVISION_ID   := R_VMI.V_DIVISION_ID;
        EV_SCM_SITE_ID   := R_VMI.V_SCM_SITE_ID;
        EV_PROJECT_CODE  := R_VMI.V_PROJECT_CODE;
        EV_ITEM_ID       := R_VMI.V_ITEM_ID;
        EV_DOM_EXP       := R_VMI.V_DOM_EXP;
        EV_FCST_TYPE     := R_VMI.V_FCST_TYPE;
        EV_INCOTERMS     := R_VMI.V_INCOTERMS;
        EV_PLANT_SITE_ID := R_VMI.V_PLANT_SITE_ID;

        -- 기초재고를 가져온다.
        EV_BINV := 0;
        BEGIN
            SELECT NVL(QTY,0) INTO EV_BINV
            FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
            WHERE  A.DIVISION_ID       = '82'
              AND  A.MEASURE           = 'VMI_Inv'
              AND  A.YYYYMMDD          = TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 8, 'YYYYMMDD')   -- 실적구간 마지막일자
              AND  A.SCM_SITE_ID       = EV_SCM_SITE_ID
              AND  A.PROJECT_CODE      = EV_PROJECT_CODE
              AND  A.ITEM_ID           = EV_ITEM_ID
              AND  A.DOM_EXP           = EV_DOM_EXP
              AND  A.FCST_TYPE         = EV_FCST_TYPE
              AND  A.INCOTERMS         = EV_INCOTERMS
              AND  A.PLANT_SITE_ID     = EV_PLANT_SITE_ID
              AND  A.CELL_PROD_SITE_ID = '-';  -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
        EXCEPTION
            WHEN NO_DATA_FOUND THEN EV_BINV := 0;
        END;

        -- 해당 SITE 의 미래구간의 VMI_IN_REQ 를 모두 지운다.
        DELETE FROM SCM_MGR.DM_PLN_MKT_FCST A
        WHERE  A.DIVISION_ID  = '82'
          AND  A.MEASURE       = 'VMI_In_Req'
          AND  A.YYYYMMDD     >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')  -- 계획구간만
          AND  A.SCM_SITE_ID   = EV_SCM_SITE_ID
          AND  A.PROJECT_CODE  = EV_PROJECT_CODE
          AND  A.ITEM_ID       = EV_ITEM_ID
          AND  A.DOM_EXP       = EV_DOM_EXP
          AND  A.FCST_TYPE     = EV_FCST_TYPE
          AND  A.INCOTERMS     = EV_INCOTERMS
          AND  A.PLANT_SITE_ID = EV_PLANT_SITE_ID;

        -- 계산 및 INSERT
        INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
        , INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE
             , X.INCOTERMS, 'VMI_In_Req' AS MEASURE
             , TO_CHAR(TO_DATE(X.YYYYMMDD,'YYYYMMDD') - 0, 'YYYYMMDD')  -- MKT FCST 의 일자를 기준으로 집계했으므로 재고일수만큼 앞으로 밀어준다.
             , X.PLANT_SITE_ID
             , CASE WHEN ROW_NUM <= 0 THEN 0
                    WHEN ROW_NUM = 0 + 1 THEN CASE WHEN SUM_QTY > EV_BINV THEN SUM_QTY - EV_BINV ELSE 0 END
                    WHEN SUM_QTY > EV_BINV AND BF_SUM <= EV_BINV THEN SUM_QTY - EV_BINV
                    WHEN BF_SUM  > EV_BINV THEN QTY
                    ELSE 0
               END AS QTY
             , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
        FROM (
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
                 , A.INCOTERMS, A.YYYYMMDD, A.PLANT_SITE_ID
                 , SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD )                                              AS SUM_QTY
                 , SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) AS BF_SUM
                 , QTY
                 , ROW_NUMBER() OVER ( ORDER BY A.YYYYMMDD )                                            AS ROW_NUM
            FROM (
                SELECT A.BASIS_YYYYMMDD AS YYYYMMDD, 'MKT_FCST' AS MEASURE
                     , NVL(B.QTY, 0) AS QTY
                     , EV_DIVISION_ID  AS DIVISION_ID
                     , EV_SCM_SITE_ID  AS SCM_SITE_ID
                     , EV_PROJECT_CODE AS PROJECT_CODE
                     , EV_ITEM_ID      AS ITEM_ID
                     , EV_DOM_EXP      AS DOM_EXP
                     , EV_FCST_TYPE    AS FCST_TYPE
                     , EV_INCOTERMS    AS INCOTERMS
                     , EV_PLANT_SITE_ID AS PLANT_SITE_ID
                FROM  SCM_MGR.SCM_SYS_CALENDAR_M A
                LEFT  JOIN SCM_MGR.DM_PLN_MKT_FCST B
                  ON  A.BASIS_YYYYMMDD  = B.YYYYMMDD
                 AND  B.MEASURE         = 'MKT_FCST'
                 AND  B.DIVISION_ID     = '82'
                 AND  B.SCM_SITE_ID     = EV_SCM_SITE_ID
                 AND  B.PROJECT_CODE    = EV_PROJECT_CODE
                 AND  B.ITEM_ID         = EV_ITEM_ID
                 AND  B.DOM_EXP         = EV_DOM_EXP
                 AND  B.FCST_TYPE       = EV_FCST_TYPE
                 AND  B.INCOTERMS       = EV_INCOTERMS
                 AND  B.PLANT_SITE_ID   = EV_PLANT_SITE_ID
                WHERE A.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')  -- 계획구간만
                  AND A.BASIS_YYYYMMDD <= TO_CHAR(
                          TO_DATE(TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7,'YYYYMMDD'),'YYYYMMDD')
                          + CASE WHEN 0 > 0 THEN 0 + 1 ELSE 0 + 10 END + 7*84
                        , 'YYYYMMDD')
                -- [C20201217-000126], [C20210811-000230] 62주에서 92주로 확장(MKT FCST 메저 기준), [C20210817-000420]
            ) A
        ) X
        WHERE CASE WHEN ROW_NUM <= 0 THEN 0
                   WHEN ROW_NUM = 0 + 1 THEN CASE WHEN SUM_QTY > EV_BINV THEN SUM_QTY - EV_BINV ELSE 0 END
                   WHEN SUM_QTY > EV_BINV AND BF_SUM <= EV_BINV THEN SUM_QTY - EV_BINV
                   WHEN BF_SUM  > EV_BINV  THEN QTY
                   ELSE 0
              END > 0;

    END LOOP;

    -------------------------------------------------------------------------------------◎◎◎◎
    -- HISTORY INSERT (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST_H
    ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
    , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
    , LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT V_DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_MKT_FCST_H.NEXTVAL, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID
         , V_YYYYMMDD, V_QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY
         , SYSDATE, NULL, NULL, NULL, NULL, NULL
         , NULL, NULL, NULL, NULL, V_ATTRIBUTE10
    FROM   SCM_MGR.GT_DMF3_RESULTS;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- HISTORY INSERT (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_MST_CUSTOMER_FCST map create (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.GT_DMF3_SITE_CUSTOMER_MAP
    ( DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY )
    SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.MEASURE
         , A.SUMMARY_BUCKET_VALUE AS START_DAY
         , CASE WHEN SUMMARY_BUCKET_TYPE = 'WEEKLY'
                THEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.SUMMARY_BUCKET_VALUE,'YYYYMMDD'),'SUN'),'YYYYMMDD')
                ELSE A.SUMMARY_BUCKET_VALUE
           END AS END_DAY
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST A
    JOIN ( SELECT DISTINCT V_DIVISION_ID, V_SCM_SITE_ID
           FROM   SCM_MGR.GT_DMF3_RESULTS
           WHERE  V_MEASURE NOT IN ('MKT_FCST','RTF')  -- 20181121 KHSONG MKT_FCST 수정시 CUST_FCST값이 수정되지 않도록 보완
         ) RSLT
      ON  A.DIVISION_ID = RSLT.V_DIVISION_ID
     AND  A.SCM_SITE_ID = RSLT.V_SCM_SITE_ID
    WHERE A.VALID_YN           = 'Y'
      AND A.MEASURE_GROUP      = 'CUST_FCST'
      AND A.PLAN_WEEK          = (SELECT MAX(PLAN_WEEK) FROM SCM_MGR.DM_MST_CUSTOMER_FCST)
      AND A.SUMMARY_BUCKET_VALUE >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')  -- 당주 월요일 이후데이터만
      AND A.SUMMARY_BUCKET_TYPE IN ('DAILY','WEEKLY')
    UNION ALL
    SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.MEASURE
         , CASE WHEN A.SUMMARY_BUCKET_VALUE = TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE,-1))+1,'YYYYMMDD')
                THEN TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
                ELSE A.SUMMARY_BUCKET_VALUE
           END AS START_DAY
         , TO_CHAR(LAST_DAY(TO_DATE(A.SUMMARY_BUCKET_VALUE,'YYYYMMDD')),'YYYYMMDD') AS END_DAY
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST A
    JOIN ( SELECT DISTINCT V_DIVISION_ID, V_SCM_SITE_ID
           FROM   SCM_MGR.GT_DMF3_RESULTS
           WHERE  V_MEASURE NOT IN ('MKT_FCST','RTF')
         ) RSLT
      ON  A.DIVISION_ID = RSLT.V_DIVISION_ID
     AND  A.SCM_SITE_ID = RSLT.V_SCM_SITE_ID
    WHERE A.VALID_YN           = 'Y'
      AND A.MEASURE_GROUP      = 'CUST_FCST'
      AND A.PLAN_WEEK          = (SELECT MAX(PLAN_WEEK) FROM SCM_MGR.DM_MST_CUSTOMER_FCST)
      AND A.SUMMARY_BUCKET_VALUE >= TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD')
      AND A.SUMMARY_BUCKET_TYPE IN ('MONTHLY');
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_MST_CUSTOMER_FCST map create (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST CUST_FCST MEASURE insert (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.GT_DMF3_TMP_MKT_FCST
    ( V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
    , V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
    , V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY )
    SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                  , A.FCST_TYPE, A.INCOTERMS, 'CUST_FCST', A.PLANT_SITE_ID, A.YYYYMMDD
                  , A.QTY, A.CREATED_BY, A.LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    JOIN ( SELECT DISTINCT V_DIVISION_ID, V_SCM_SITE_ID, V_ITEM_ID, V_INCOTERMS
                         , V_PLANT_SITE_ID, V_PROJECT_CODE, V_DOM_EXP, V_FCST_TYPE, V_ATTRIBUTE10
           FROM  SCM_MGR.GT_DMF3_RESULTS
         ) RSLT
      ON  A.DIVISION_ID   = RSLT.V_DIVISION_ID
     AND  A.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
     AND  A.ITEM_ID        = RSLT.V_ITEM_ID
     AND  A.INCOTERMS      = RSLT.V_INCOTERMS
     AND  A.PLANT_SITE_ID  = RSLT.V_PLANT_SITE_ID
     AND  A.PROJECT_CODE   = RSLT.V_PROJECT_CODE
     AND  A.DOM_EXP        = RSLT.V_DOM_EXP
     AND  A.FCST_TYPE      = RSLT.V_FCST_TYPE
    JOIN (
        SELECT DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY
        FROM   SCM_MGR.GT_DMF3_SITE_CUSTOMER_MAP
        GROUP  BY DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY
    ) MAP
      ON  A.DIVISION_ID = MAP.DIVISION_ID
     AND  A.SCM_SITE_ID = MAP.SCM_SITE_ID
     AND  A.MEASURE     = MAP.MEASURE
    WHERE A.YYYYMMDD BETWEEN MAP.START_DAY AND MAP.END_DAY
      AND A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST CUST_FCST MEASURE insert (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST insert전 중복값 delete 후 INSERT (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_TMP_MKT_FCST T
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = T.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = T.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = T.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = T.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = T.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = T.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = T.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.MEASURE        = T.V_MEASURE
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = T.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
    , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE10 )
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
         , V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD
         , V_QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
         , V_ATTRIBUTE10
    FROM   SCM_MGR.GT_DMF3_TMP_MKT_FCST;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180409 DM_PLN_MKT_FCST insert전 중복값 delete 후 INSERT (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180614 KHSONG 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    PLAN_START_YYYYMMDD := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');  -- 월요일 변수설정

    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  MEASURE  = 'RTF_SYS_RP'  -- 20200427 변경
      AND  YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      -- modified by ytchoi 20180813
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = RSLT.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = RSLT.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = RSLT.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = RSLT.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = RSLT.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       >= PLAN_START_YYYYMMDD
                 AND  ITEM.ACTIVE_FLAG = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↓상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 AND  ( ITEM.ITEM_TYPE IN ('Q','R')
                     OR RSLT.V_ITEM_ID IN (
                            SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                            WHERE K.DIVISION_ID = RSLT.V_DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                        )
                      )  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↑상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
                 --AND DM_PLN_MKT_FCST.DIVISION_ID IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895]
                 AND  DM_PLN_MKT_FCST.DIVISION_ID IN ('82')  -- 20190709 KHSONG [CSR ID:4034895]
                 --[E20241211-000856] END
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
    , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
         , A.INCOTERMS
         --, 'RTF'
         , 'RTF_SYS_RP'  -- 20200427 변경
         , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY
         , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
         , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    WHERE  A.MEASURE   = 'MKT_FCST'
      AND  A.YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      -- modified by ytchoi 20180813
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  A.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  A.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  A.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  A.ITEM_ID       = RSLT.V_ITEM_ID
                 AND  A.DOM_EXP       = RSLT.V_DOM_EXP
                 AND  A.FCST_TYPE     = RSLT.V_FCST_TYPE
                 AND  A.INCOTERMS     = RSLT.V_INCOTERMS
                 AND  A.PLANT_SITE_ID = RSLT.V_PLANT_SITE_ID
                 AND  ITEM.ACTIVE_FLAG = 'Y'  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↓상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 AND  ( ITEM.ITEM_TYPE IN ('Q','R')
                     OR RSLT.V_ITEM_ID IN (
                            SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                            WHERE K.DIVISION_ID = RSLT.V_DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                        )
                      )  -- 20180720 ACTIVE_FLAG 조건추가
                 -- ↑상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                 --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
                 --AND a.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895]
                 AND  A.DIVISION_ID IN ('82')  -- 20190709 KHSONG [CSR ID:4034895]
                 --[E20241211-000856] END
           );
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180614 KHSONG 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 KHSONG 소형 반품예정수량(RMA) fcst_type인 경우에 RTF를 MKT_FCST와 동일하게 생성 조건추가 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    PLAN_START_YYYYMMDD := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD');  -- 월요일 변수설정

    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST
    WHERE  MEASURE  = 'RTF_SYS_RP'  -- 20200507 변경
      AND  YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  DM_PLN_MKT_FCST.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  DM_PLN_MKT_FCST.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  DM_PLN_MKT_FCST.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  DM_PLN_MKT_FCST.ITEM_ID        = RSLT.V_ITEM_ID
                 AND  DM_PLN_MKT_FCST.DOM_EXP        = RSLT.V_DOM_EXP
                 AND  DM_PLN_MKT_FCST.FCST_TYPE      = RSLT.V_FCST_TYPE
                 AND  DM_PLN_MKT_FCST.INCOTERMS      = RSLT.V_INCOTERMS
                 AND  DM_PLN_MKT_FCST.PLANT_SITE_ID  = RSLT.V_PLANT_SITE_ID
                 AND  DM_PLN_MKT_FCST.YYYYMMDD       >= PLAN_START_YYYYMMDD
                 AND  ITEM.ACTIVE_FLAG  = 'Y'
                 AND  RSLT.V_FCST_TYPE  = 'RMA'
           );

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
    , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
    , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
         , A.INCOTERMS
         --, 'RTF'
         , 'RTF_SYS_RP'  -- 20200507 변경
         , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY
         , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
         , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    WHERE  A.MEASURE   = 'MKT_FCST'
      AND  A.YYYYMMDD >= PLAN_START_YYYYMMDD  -- 당주 월요일이후
      AND  EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF3_RESULTS RSLT
               JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                 ON   RSLT.V_DIVISION_ID = ITEM.DIVISION_ID
                AND   RSLT.V_ITEM_ID     = ITEM.ITEM_ID
               WHERE  A.DIVISION_ID   = RSLT.V_DIVISION_ID
                 AND  A.PROJECT_CODE  = RSLT.V_PROJECT_CODE
                 AND  A.SCM_SITE_ID   = RSLT.V_SCM_SITE_ID
                 AND  A.ITEM_ID       = RSLT.V_ITEM_ID
                 AND  A.DOM_EXP       = RSLT.V_DOM_EXP
                 AND  A.FCST_TYPE     = RSLT.V_FCST_TYPE
                 AND  A.INCOTERMS     = RSLT.V_INCOTERMS
                 AND  A.PLANT_SITE_ID = RSLT.V_PLANT_SITE_ID
                 AND  ITEM.ACTIVE_FLAG = 'Y'
                 AND  RSLT.V_FCST_TYPE = 'RMA'
           );
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20181107 KHSONG 소형 반품예정수량(RMA) (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -------------------------------------------------------------------------------------◎◎◎◎
    -- BALANCE_CREATE 호출 로직 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    INSERT INTO SCM_MGR.GT_DMF3_SEND_TARGET_DATA
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, PLANT_SITE_ID
    , CELL_PROD_SITE_ID  -- [PJ2025-00188]
    , VMI_YN )
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
         , V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID
         , '-' AS CELL_PROD_SITE_ID  -- [PJ2025-00188] 그외는 - 로 처리
         , 'N' AS VMI_YN             -- vmi_yn 초기값
    FROM   SCM_MGR.GT_DMF3_RESULTS
    GROUP  BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP
            , V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID;

    SELECT DIVISION_ID INTO V_C_DIVISION_ID
    FROM   SCM_MGR.GT_DMF3_SEND_TARGET_DATA
    WHERE  ROWNUM = 1;

    -- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출 (START)
    -- 2026.04.06   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
    -- 2026.04.06 POC 테스트를 위해 임시 막음. PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE이 참조 작업이 너무 많아 일단 막음
    -- SCM_MGR.PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(V_C_DIVISION_ID, P_PLAN_ID => 'CALL');
    -- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출 (END)

    -------------------------------------------------------------------------------------◎◎◎◎
    -- BALANCE_CREATE 호출 로직 (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    --[E20230608-000891]MKT FCST, Sales Plan 동일 Measure 실시간 연동건 [START]
    IF V_DIVISION_ID = '82' THEN
        PKG_DMF0003.P_DMF0003_MKT_FCST_SALES_PLAN_SYNC(V_DIVISION_ID, V_CREATED_BY, V_R_CURSOR);
        IF V_R_CURSOR%ISOPEN THEN
            CLOSE V_R_CURSOR;
        END IF;
    END IF;
    --[E20230608-000891] [END]

    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180816 KHSONG DIVISION_ID = '40' PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 호출 (START)
    -------------------------------------------------------------------------------------◎◎◎◎
    -- SCP가 Open 했기 때문에 RTF 값을 MKT FCST에서 수정하지 않음.
    V_CHECK_CNT := 0;
    SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '40';

    IF V_CHECK_CNT > 0 THEN
        SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE;
    END IF;
    -------------------------------------------------------------------------------------◎◎◎◎
    -- 20180816 KHSONG DIVISION_ID = '40' (END)
    -------------------------------------------------------------------------------------◎◎◎◎

    -----------------------------------------------------------------------
    -- DMF0070_SAVE_QTY_PR_DETAIL_AUTO 호출
    -----------------------------------------------------------------------
    -- MKT FCST 수정시 PR_DETAIL_AUTO 수량도 업데이트--KJJ 2024.02.05
    /*
    EXEC dbo.DMF0070_SAVE_QTY_PR_DETAIL_AUTO
        */
    /* 2026.04.06   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
       DMF0070 기능 미사용 DMF0070_SAVE_QTY_PR_DETAIL_AUTO 작업 호출 안 함
    SCM_MGR.DMF0070_SAVE_QTY_PR_DETAIL_AUTO(
        V_DIVISION_ID,
        V_PROJECT_CODE,
        V_SCM_SITE_ID,
        V_ITEM_ID,
        V_DOM_EXP,
        V_FCST_TYPE,
        V_INCOTERMS,
        V_PLANT_SITE_ID,
        V_YYYYMMDD,
        V_QTY
    ); */

    -- COMMIT은 프로시저 종료 직전 1회만 수행
    COMMIT;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '-';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    RETURN;

    -- 트랜잭션 (END)
    <<ERR_RTN>>
    IF V_LOG_TYPE = 'INVALID' THEN

        V_LOG_MESSAGE := '########## END of procedure ##########';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[C20200804-000123]
        V_CHECK_CNT := 0;
        SELECT COUNT(1) INTO V_CHECK_CNT FROM SCM_MGR.GT_DMF3_RESULTS WHERE V_DIVISION_ID = '40';

        IF V_CHECK_CNT > 0 THEN
            OPEN O_RC1 FOR
            SELECT A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD
                , A.SYNC_QTY, A.QTY
            FROM SCM_MGR.GT_DMF3_T_ERR A
            ORDER BY A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD;

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check : ' || V_DESCRIPTION AS MSG , '0' AS EVENT FROM DUAL;
        ELSE
            OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check : ' || V_DESCRIPTION AS MSG , '0' AS EVENT FROM DUAL;
        END IF;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        IF V_R_CURSOR%ISOPEN THEN
            CLOSE V_R_CURSOR;
        END IF;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_ACTIVE_FLAG'   VALUE P_ACTIVE_FLAG,
            'P_DIVISION_ID'   VALUE P_DIVISION_ID,
            'P_PROJECT_CODE'  VALUE P_PROJECT_CODE,
            'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
            'P_ITEM_ID'       VALUE P_ITEM_ID,
            'P_DOM_EXP'       VALUE P_DOM_EXP,
            'P_FCST_TYPE'     VALUE P_FCST_TYPE,
            'P_INCOTERMS'     VALUE P_INCOTERMS,
            'P_MEASURE'       VALUE P_MEASURE,
            'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
            'P_YYYYMMDD'      VALUE P_YYYYMMDD,
            'P_QTY'           VALUE P_QTY,
            'P_CREATED_BY'    VALUE P_CREATED_BY,
            'P_AS_FROM_SITE'  VALUE P_AS_FROM_SITE,
            'P_BUCKET'        VALUE P_BUCKET
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_CREATED_BY, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0003_SAVE_MKT_FCST;


END PKG_DMF0003;