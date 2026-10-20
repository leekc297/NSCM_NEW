-- PKG_SCP0096 — 생성: tools/Harness/gen-pkg.js 2026-10-19 · 화면 SCP0096→SCP0096 Shipment_Working_Day_OSP · As-is SP 3개
-- 이식 규칙: Doc/_dev_rules(DB 변환 규칙) · To-be_v2_converted/06_Packages 선례 · ISNULL→NVL, GETDATE→SYSDATE, TOP n→FETCH FIRST n ROWS ONLY, +(문자열)→||, CONVERT→TO_CHAR/TO_DATE, 임시테이블→GTT/WITH, @@ROWCOUNT→SQL%ROWCOUNT · ⭐ 널 센티널 = '/' (ISNULL(x,'')→NVL(x,'/') · 원래 '-' 데이터 유지 · 과도기 빈값 IN ('-','/') — 사용자 2026-10-15, check-pkg P39/P40, port_pkg.md §센티널)
-- 배포 후: SCP0096_registration.sql 재실행(PROC_M 이 ALL_ARGUMENTS 로 확정) → FE pnpm gen:procedures
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCP0096
AS
    PROCEDURE P_DM0003_GET_BUCKET_TYPE_CODE (
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(60)
        P_PLANT_SITE_ID  IN  VARCHAR2,  -- As-is @p_plant_site_id nvarchar(200)
        P_FROM_YYYYMMDD  IN  VARCHAR2,  -- As-is @p_from_yyyymmdd nvarchar(16)
        P_TO_YYYYMMDD    IN  VARCHAR2,  -- As-is @p_to_yyyymmdd nvarchar(16)
        P_DEBUG_MODE     IN  VARCHAR2,  -- As-is @debug_mode nvarchar(40)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0009_GET_SHEET_CALENDAR_3SPAN (
        P_START_YYYYMMDD IN  VARCHAR2,  -- As-is @p_start_yyyymmdd nvarchar(16)
        P_END_YYYYMMDD   IN  VARCHAR2,  -- As-is @p_end_yyyymmdd nvarchar(16)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );
END PKG_SCP0096;
/

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCP0096
AS
/*
 * Program ID   : P_DM0003_GET_BUCKET_TYPE_CODE
 * Description  : SCP0096 Shipment_Working_Day_OSP — As-is DM0003_GET_BUCKET_TYPE_CODE 이식 (GET, 시트 'Shipment Working Day OSP' / 버튼 SEARCH)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.19   harness        [TobeGen] 골격 생성 — SQL 본문 이식 TODO
 */
PROCEDURE P_DM0003_GET_BUCKET_TYPE_CODE (
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    OPEN O_RC1 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is DM0003_GET_BUCKET_TYPE_CODE 결과셋 1 (컬럼: CODE, NAME)

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_DM0003_GET_BUCKET_TYPE_CODE] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || '-');
END P_DM0003_GET_BUCKET_TYPE_CODE;

/* ===== ASIS DM0003_GET_BUCKET_TYPE_CODE (dbo) — 이식 후 이 블록은 삭제 =====
/**************************************************************************************************** /
/* Program ID  : DM0003_GET_BUCKET_TYPE_CODE                                                       * /
/* Description : Procedure 작성 가이드                                                              * /
/* Usage       : Procedure 작성 시 참조하세요!                                                      * /
/* Parameter   :                                                                                    * /
/*                                                                                                  * /
/*--------------------------------------------------------------------------------------------------* /
/* Date        In Charge    Description                                                             * /
/*--------------------------------------------------------------------------------------------------* /
/* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 * /
/*                                                                                                  * /
/**************************************************************************************************** /

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
****************************************************************************************************** /


CREATE procedure [dbo].[DM0003_GET_BUCKET_TYPE_CODE]  
AS
BEGIN
	
  SET NOCOUNT ON;

  DECLARE @p_end_week       AS NVARCHAR(6);

  SELECT L.SEGMENT1  AS CODE
       , L.SEGMENT2  AS NAME
  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
  WHERE  L.LOOKUP_TYPE = 'BUCKET_TYPE_CODE'
  AND    L.VALID_YN    = 'Y'
  ORDER BY DISPLAY_SEQ
  ;

END
===== END ASIS ===== */

/*
 * Program ID   : P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP
 * Description  : SCP0096 Shipment_Working_Day_OSP — As-is SCP0096_GET_SHIPMENT_WORKING_DAY_OSP 이식 (GET, 시트 'Shipment Working Day OSP' / 버튼 SEARCH)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.19   harness        [TobeGen] 골격 생성 — SQL 본문 이식 TODO
 */
PROCEDURE P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(60)
        P_PLANT_SITE_ID  IN  VARCHAR2,  -- As-is @p_plant_site_id nvarchar(200)
        P_FROM_YYYYMMDD  IN  VARCHAR2,  -- As-is @p_from_yyyymmdd nvarchar(16)
        P_TO_YYYYMMDD    IN  VARCHAR2,  -- As-is @p_to_yyyymmdd nvarchar(16)
        P_DEBUG_MODE     IN  VARCHAR2,  -- As-is @debug_mode nvarchar(40)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사(As-is 에서 NOT NULL 로 쓰이는 파라미터만 남길 것)
    IF P_DIVISION_ID IS NULL THEN RAISE_INVALID('DIVISION_ID IS NULL'); END IF;

    OPEN O_RC1 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0096_GET_SHIPMENT_WORKING_DAY_OSP 결과셋 1

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_DIVISION_ID='||P_DIVISION_ID||','||'P_PLANT_SITE_ID='||P_PLANT_SITE_ID||','||'P_FROM_YYYYMMDD='||P_FROM_YYYYMMDD||','||'P_TO_YYYYMMDD='||P_TO_YYYYMMDD);
END P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP;

/* ===== ASIS SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (dbo) — 이식 후 이 블록은 삭제 =====
/*
 * Program ID   : SCP0096_GET_SHIPMENT_WORKING_DAY_OSP
 * Description  : 출하일 관리
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/01/31   lwy			   Initial Release [] - PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - (외주) 출하일 관리
 * 
 * /
create PROCEDURE [dbo].[SCP0096_GET_SHIPMENT_WORKING_DAY_OSP]
   @p_division_id	NVARCHAR(30)
  ,@p_plant_site_id	NVARCHAR(100)
  ,@p_from_yyyymmdd NVARCHAR(8)
  ,@p_to_yyyymmdd   NVARCHAR(8)
  ,@debug_mode		NVARCHAR(20)  ='F'
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF OBJECT_ID('TEMPDB..#TBLDYNAMICPIVOT_SCP0096') IS NOT NULL
		DROP TABLE #TBLDYNAMICPIVOT_SCP0096;

	SELECT A.DIVISION_ID
		  --,A.DIVISION_NAME
		  ,A.PLANT_SITE_ID
		  --,A.PLANT_SITE_NAME
		  ,C.WORKING_TIME_DEFAULT AS WORKING_TIME_DEFAULT
		  , ( SELECT MAX(YYYYMMDD)
				FROM SCP_MST_SHIPMENT_WORKING_DAY_OSP T
			   WHERE T.DIVISION_ID = A.DIVISION_ID
				AND T.PLANT_SITE_ID = A.PLANT_SITE_ID
				AND T.SHIPMENT_YN IS NOT NULL) AS LAST_INPUT_DATE
		  ,A.MEASURE
		  ,'D_'+A.YYYYMMDD AS YYYYMMDD
		  ,A.YYYYMM AS YYYYMM
		  ,A.ISO_WEEK
		  ,B.SHIPMENT_YN AS SHIPMENT_YN
		  --,A.OSP_YN

	  INTO #TBLDYNAMICPIVOT_SCP0096
	  FROM(
				SELECT   DISTINCT
						 S.DIVISION_ID
						,S.SCM_SITE_ID  AS PLANT_SITE_ID
						,'SHIPMENT WORKING DAY' AS MEASURE
						,P.BASIS_YYYYMMDD AS YYYYMMDD
						,P.BASIS_YYYYMM AS YYYYMM
						,RIGHT(P.BASIS_YYYYMM,2)+P.ISO_WEEK AS ISO_WEEK
						,'VENDOR' AS OPERATION
						,S.OSP_YN
				FROM SCM_MST_SITE S
				CROSS JOIN SCM_SYS_CALENDAR_M P
			    WHERE 1=1
			      AND P.BASIS_YYYYMMDD >=@P_FROM_YYYYMMDD
				  AND P.BASIS_YYYYMMDD <=@P_TO_YYYYMMDD
				  AND S.SITE_TYPE    = 'PLANT'
				  AND S.VALID_YN	 = 'Y'
				  AND S.OSP_YN	     ='Y'
				  AND S.DIVISION_ID  = @P_DIVISION_ID
				  AND ISNULL(S.ATTRIBUTE1,'N') <> 'Y'   -- LINE 등록 외주사 제외
				  AND ( ( @P_PLANT_SITE_ID IS NULL OR  @P_PLANT_SITE_ID = '' ) OR S.SCM_SITE_ID   IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_PLANT_SITE_ID  ,',')) )

				UNION

				SELECT S.DIVISION_ID
					 , S.SCM_SITE_ID AS PLANT_SITE_ID
					 , 'SHIPMENT WORKING DAY' AS MEASURE
					 , P.BASIS_YYYYMMDD    AS YYYYMMDD
					 , P.BASIS_YYYYMM      AS YYYYMM
					 , RIGHT(P.BASIS_YYYYMM,2)+P.ISO_WEEK AS ISO_WEEK
					 , O.OPERATION_ID AS OPERATION
					 ,S.OSP_YN
				  FROM SCM_MST_SITE S
				  JOIN SCM_MST_LINE_OSP O ON S.DIVISION_ID = O.DIVISION_ID AND S.SCM_SITE_ID = O.SCM_SITE_ID
				 CROSS JOIN SCM_SYS_CALENDAR_M P
				 WHERE 1=1
				   AND P.BASIS_YYYYMMDD >= @P_FROM_YYYYMMDD
				   AND P.BASIS_YYYYMMDD <= @P_TO_YYYYMMDD
				   AND S.SITE_TYPE   = 'PLANT'
				   AND S.VALID_YN	 = 'Y'
				   AND S.OSP_YN	     = 'Y'
				   AND S.DIVISION_ID = @P_DIVISION_ID
				   AND ISNULL(S.ATTRIBUTE1,'N') = 'Y'
				   AND ( ( @P_PLANT_SITE_ID IS NULL OR  @P_PLANT_SITE_ID = '' ) OR S.SCM_SITE_ID   IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_PLANT_SITE_ID  ,',')) )
			) A
			LEFT OUTER JOIN SCP_MST_SHIPMENT_WORKING_DAY_OSP B
			  ON A.DIVISION_ID   = B.DIVISION_ID
		     AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
	         AND A.YYYYMMDD      = B.YYYYMMDD

            LEFT OUTER JOIN SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT C
			  ON A.DIVISION_ID  = C.DIVISION_ID
			AND A.PLANT_SITE_ID = C.PLANT_SITE_ID

			LEFT OUTER JOIN SCM_SYS_CALENDAR_M O ON B.YYYYMMDD = O.BASIS_YYYYMMDD
	WHERE 1=1
	;

	/********************************************************************************
		* PIVOIT처리
	******************************************************************************** /
	BEGIN
		DECLARE @MQRY_SUM NVARCHAR(MAX);
		DECLARE @MEXEC NVARCHAR(MAX);

		SET @MQRY_SUM = '';
		SET @MQRY_SUM = '';

		SELECT  @MQRY_SUM = @MQRY_SUM+','+  'MAX(CASE WHEN YYYYMMDD = '''+YYYYMMDD+''' THEN SHIPMENT_YN END ) AS ' + YYYYMMDD  +CHAR(10)
		FROM (
			SELECT TOP 10000 'D_'+A.BASIS_YYYYMMDD   AS YYYYMMDD
					, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
				FROM [DBO].[SCM_SYS_CALENDAR_M] A
				WHERE A.BASIS_YYYYMMDD  BETWEEN @P_FROM_YYYYMMDD AND @P_TO_YYYYMMDD
			GROUP BY A.BASIS_YYYYMMDD
		) AS A
		ORDER BY SORT_ORDER_NO  ;

		PRINT @MQRY_SUM

		SET @MEXEC = '';
		SET @MEXEC = @MEXEC+'	SELECT A.* FROM (  '+CHAR(10);

		SET @MEXEC = @MEXEC+'	SELECT                         '+CHAR(10);
		SET @MEXEC = @MEXEC+'		    DIVISION_ID            '+CHAR(10);
		SET @MEXEC = @MEXEC+'		   ,PLANT_SITE_ID          '+CHAR(10);
		SET @MEXEC = @MEXEC+'		   ,(SELECT MAX(D.SITE_DESCRIPTION) FROM SCM_MST_SITE D WHERE 1=1 AND D.SCM_SITE_ID = PLANT_SITE_ID GROUP BY D.SCM_SITE_ID) AS PLANT_SITE_NAME    '+CHAR(10);
		SET @MEXEC = @MEXEC+'          ,WORKING_TIME_DEFAULT  '+CHAR(10);
		SET @MEXEC = @MEXEC+'          ,LAST_INPUT_DATE       '+CHAR(10);
		SET @MEXEC = @MEXEC+'		   ,MEASURE                '+CHAR(10);

		SET @MEXEC = @MEXEC+'   ' +@MQRY_SUM + CHAR(10);
		SET @MEXEC = @MEXEC+'   FROM #TBLDYNAMICPIVOT_SCP0096 '+CHAR(10);
		SET @MEXEC = @MEXEC+'	GROUP BY  DIVISION_ID, PLANT_SITE_ID, WORKING_TIME_DEFAULT, LAST_INPUT_DATE, MEASURE '+CHAR(10);
		SET @MEXEC = @MEXEC+'	) A '+CHAR(10);
		SET @MEXEC = @MEXEC+'	ORDER BY LAST_INPUT_DATE, DIVISION_ID, PLANT_SITE_ID , MEASURE '+CHAR(10);
		;


		IF ( @DEBUG_MODE ='T')
			PRINT @MEXEC;

		EXEC (@MEXEC);

	END -- PIVOT BEGIN

	IF OBJECT_ID('TEMPDB..#TBLDYNAMICPIVOT_SCP0096') IS NOT NULL
		DROP TABLE #TBLDYNAMICPIVOT_SCP0096

END
===== END ASIS ===== */

/*
 * Program ID   : P_SCP0009_GET_SHEET_CALENDAR_3SPAN
 * Description  : SCP0096 Shipment_Working_Day_OSP — As-is SCP0009_GET_SHEET_CALENDAR_3SPAN 이식 (GET, 시트 'Shipment Working Day OSP' / 버튼 SEARCH)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.19   harness        [TobeGen] 골격 생성 — SQL 본문 이식 TODO
 */
PROCEDURE P_SCP0009_GET_SHEET_CALENDAR_3SPAN (
        P_START_YYYYMMDD IN  VARCHAR2,  -- As-is @p_start_yyyymmdd nvarchar(16)
        P_END_YYYYMMDD   IN  VARCHAR2,  -- As-is @p_end_yyyymmdd nvarchar(16)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사(As-is 에서 NOT NULL 로 쓰이는 파라미터만 남길 것)
    IF P_START_YYYYMMDD IS NULL THEN RAISE_INVALID('START_YYYYMMDD IS NULL'); END IF;

    OPEN O_RC1 FOR
        SELECT NULL AS TODO_COLUMN FROM DUAL WHERE 1 = 0;   -- TODO 이식: As-is SCP0009_GET_SHEET_CALENDAR_3SPAN 결과셋 1 (컬럼: COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, DAY_CODE, SORT_ORDER_NO)

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0009_GET_SHEET_CALENDAR_3SPAN] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_START_YYYYMMDD='||P_START_YYYYMMDD||','||'P_END_YYYYMMDD='||P_END_YYYYMMDD);
END P_SCP0009_GET_SHEET_CALENDAR_3SPAN;

/* ===== ASIS SCP0009_GET_SHEET_CALENDAR_3SPAN (dbo) — 이식 후 이 블록은 삭제 =====
/****************************************************************************************************
* Program ID  : SCP_GET_SHEET_CALENDAR_3SPAN                                                       
* Description : SCP 칼렌더 생성위한 프로시저                                                       
* Usage       : exec SCP_GET_SHEET_CALENDAR_3SPAN													
* Parameter   : @p_start_yyyymmdd='2017-12-25'                                                     
*               @p_end_yyyymmdd='20180130'                                                         
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2018/11/20  KYH			Initial Release  
* ex)
* EXEC SCP0009_GET_SHEET_CALENDAR_3SPAN @p_start_yyyymmdd ='20180122' , @p_end_yyyymmdd='20180220'
**************************************************************************************************** /

CREATE PROCEDURE [dbo].[SCP0009_GET_SHEET_CALENDAR_3SPAN]
	@p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;
    SELECT 'D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
        , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME   
        , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
        , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME 
        , A.DAYOFWEEK               AS DAY_CODE
	    , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.basis_yyyymmdd <= @p_end_yyyymmdd 
    UNION ALL
    SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
        , A.WEEK_NAME          AS COLUMN_LABEL_NAME   
        , A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
        , A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
        , ''                   AS DAY_CODE
	    , A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY A.BASIS_YYYYMM
            , A.ISO_WEEK 
            , A.WEEK_NAME
            , A.MONTH_NAME        
            , A.BASIS_START_DATE
    UNION ALL
    SELECT 'M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
            , A.MONTH_NAME          AS COLUMN_LABEL_NAME
		    , A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
		    , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
		    , ''                    AS DAY_CODE
		    , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
    FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY A.BASIS_YYYYMM
            , A.MONTH_NAME		
    ORDER BY sort_order_no

END
===== END ASIS ===== */

END PKG_SCP0096;
/
-- 컴파일 확인: SELECT NAME, TYPE, LINE, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SCP0096' ORDER BY TYPE, SEQUENCE;
