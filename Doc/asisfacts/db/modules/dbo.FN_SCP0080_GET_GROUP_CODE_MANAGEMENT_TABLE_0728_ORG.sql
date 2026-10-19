



/*
* Program ID   : SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
* Description  : Model Code Management 조회용 테이블 리턴
* Program History
*===================================================================================================
*   Date       In Charge      Description
*===================================================================================================
* 2023/07/03   chaan		  V1.1.1    Initilaize
*                                       전체 컬럼 조회 부분을 공통 함수로 추출->동일한 로직을 Mailing 에서 사용함
*                                       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 자동차 - 'Replacement Y/N' 컬럼추가
*                                       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CELL_CF 정수형으로 변경
* 2023/08/01   chaan		  V1.1.2    PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2          - 조회속도 개선
* 2023/09/12   chaan		  V1.1.3    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - JV Division에 대해서 81과 동일 컬럼/로직으로 수정(81_UC, 81_HM, 81_ST 에 대해서 81과 동일 기준)
* 2023/10/11   chaan		  V1.1.4    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Total Capacity 소수점 4자리까지로 수정
* 2023/11/20   chaan		  V1.1.5    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 평가감(-K, -D) 모델 CELL_CF 로직 수정
* 2024/04/01   chaan		  V1.1.6    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - 조회 로직 중 데이터 양이 많은 임시 테이블 (20만건)인덱스 생성 부분을 CLUSTER Index 로 변경
* 2024/06/09   vadabi3		  V1.1.5    NERP - 특정 Company 별도 처리 -> 개선 
* 2024/11/19   jahn1502		            40 cell 총용량 추가
-----------------------------------------------------------------------------------------------------
SELECT * FROM      FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE('82','P5000','EM015135PXB1','','N','N','N','N','vadabi3','F')
SELECT * FROM NERP_FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE('82','P5000','EM015135PXB1','','N','N','N','N','vadabi3','F')

*/
--DROP FUNCTION [dbo].[FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE]
--CREATE FUNCTION [dbo].[FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE]
CREATE FUNCTION [dbo].[FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE_0728_ORG]
(
      @p_division_id			NVARCHAR(1000)
    , @p_operation_id			NVARCHAR(1000)
    , @p_model_id				NVARCHAR(1000)
    , @p_nickname				NVARCHAR(1000)
    , @p_check_fcst				NVARCHAR(1000)
    , @p_check_production		NVARCHAR(1000)
    , @p_check_active			NVARCHAR(1)
    , @p_check_bom				NVARCHAR(1)
    , @p_user_id				NVARCHAR(1000)
    , @debug_mode				NVARCHAR(1)         = 'F'
)
RETURNS @TBL_RES TABLE
--DECLARE @TBL_RES TABLE
(
      DIVISION_ID					NVARCHAR(30)	    NULL
    , OPERATION_ID					NVARCHAR(10)	    NULL
    , ITEM_ID						NVARCHAR(50)	    NULL
    , NICK_NAME						NVARCHAR(150)	    NULL
    , BASIC_MODEL_PACK				NVARCHAR(100)	    NULL
    , BASIC_NICKNAME_PACK			NVARCHAR(150)	    NULL
    , CELL_MODEL					NVARCHAR(150)	    NULL
    , CELL_MODEL_NICKNAME			NVARCHAR(150)	    NULL
    , BASIC_MODEL_CELL				NVARCHAR(150)	    NULL
    , BASIC_NICKNAME_CELL			NVARCHAR(150)	    NULL
    , GROUP_CODE1					NVARCHAR(150)	    NULL
    , GROUP_CODE2					NVARCHAR(150)	    NULL
    , GROUP_CODE3					NVARCHAR(150)	    NULL
    , GROUP_CODE4					NVARCHAR(150)	    NULL
    , GROUP_CODE5					NVARCHAR(150)	    NULL
    , GROUP_CODE6					NVARCHAR(150)	    NULL
    , GROUP_CODE7					NVARCHAR(150)	    NULL
    , GROUP_CODE8					NVARCHAR(150)	    NULL
    , GROUP_CODE9					NVARCHAR(150)	    NULL
    , GROUP_CODE10					NVARCHAR(150)	    NULL
    , FCST_YN						NVARCHAR(1)		    NULL
    , PIC_ID						NVARCHAR(150)	    NULL
    , PIC_NAME						NVARCHAR(300)	    NULL
    , ATTRIBUTE7					NVARCHAR(150)	    NULL
    , ATTRIBUTE8					NVARCHAR(150)	    NULL
    , ATTRIBUTE9					NVARCHAR(150)	    NULL
    , ATTRIBUTE10					NVARCHAR(150)	    NULL
    , ATTRIBUTE11					NVARCHAR(150)	    NULL
    , ATTRIBUTE12					NVARCHAR(150)	    NULL
    , ATTRIBUTE13					NVARCHAR(150)	    NULL
    , ATTRIBUTE14					NVARCHAR(150)	    NULL
    , ATTRIBUTE15					NVARCHAR(150)	    NULL
    , SALES_MODEL					NVARCHAR(100)	    NULL
    , SALES_VALID_YN				NVARCHAR(1)		    NULL
    , SALES_PRIORITY				INT				    NULL
    , SALES_FROM_YYYYMMDD			NVARCHAR(100)	    NULL
    , SALES_TO_YYYYMMDD				NVARCHAR(100)	    NULL
    , LEVEL1_GROUP					NVARCHAR(150)	    NULL
    , LEVEL2_CODE					NVARCHAR(150)	    NULL
    , STATUS_PROTOTYPE				NVARCHAR(1)		    NULL
    , STATUS_NEW					NVARCHAR(1)		    NULL
    , CELL_CF						NVARCHAR(100)	    NULL
    , BASIC_END_CUSTOMER			NVARCHAR(150)	    NULL
    , BASIC_FINISHED_PRODUCT		NVARCHAR(150)	    NULL
    , OPERATION_GROUP				NVARCHAR(10)	    NULL
    , BIZ_TYPE						NVARCHAR(100)	    NULL
    , MODEL_TYPE_CODE				NVARCHAR(1)		    NULL
    , LEVEL_EXCEPT					NVARCHAR(2)		    NULL
    , MKT_DEPT						NVARCHAR(150)	    NULL
    , REMARK						NVARCHAR(3000)	    NULL
    , PLANT_ID						NVARCHAR(30)	    NULL
    , PLANT_NAME					NVARCHAR(50)	    NULL
    , ENERGE						NVARCHAR(30)	    NULL
    , FLOW_TYPE						NVARCHAR(1)		    NULL
    , ITEM_ID_ASSY					NVARCHAR(50)	    NULL
    , REPLACEMENT					NVARCHAR(1)		    NULL
    --, SCP_EXTRA_SPEC				NVARCHAR(150)	    NULL
    , CATHODE_CODE					NVARCHAR(2)		    NULL
    , BASIC_APPLICATION				NVARCHAR(1)		    NULL
    , BASIC_CELL_TYPE				NVARCHAR(2)		    NULL
    , BASIC_CELL_CAPACITY_CHAR		NVARCHAR(10)	    NULL
    , CATHODE_NAME					NVARCHAR(200)	    NULL
    , CELL_TYPE_CODE				NVARCHAR(200)	    NULL
    , NICKNAME_40					NVARCHAR(150)	    NULL
    , MODEL_TYPE_NAME_82			NVARCHAR(200)	    NULL
    , MODEL_TYPE_NAME_40			NVARCHAR(200)	    NULL
	, SCP_EXTRA_SPEC				NVARCHAR(150)	    NULL
    , BASIC_NICKNAME_CELL40			NVARCHAR(150)	    NULL
    , APPLICATION_NAME				NVARCHAR(50)	    NULL
    , BASIC_CELL_CAPACITY_81		NUMERIC(20, 10) 	NULL
    , CELL_TYPE_GROUP_NAME			NVARCHAR(200)	    NULL
    , BASIC_TOTAL_CAPACITY			NUMERIC(20, 10)	    NULL
    , BASIC_CELL_CAPACITY			NUMERIC(20, 10)	    NULL
    --, ACTIVE_FLAG_Y					NVARCHAR(1)		NULL
    --, ACTIVE_FLAG_N					NVARCHAR(1)		NULL
    , PRODUCTION_YN					NVARCHAR(1)		    NULL
    , STATUS_MASS					NVARCHAR(1)		    NULL
    , STATUS_ACTIVE					NVARCHAR(1)		    NULL
)
AS
BEGIN
    --DECLARE @p_division_id			NVARCHAR(1000)			= '40';
    --DECLARE @p_operation_id			NVARCHAR(1000)			= '';
    --DECLARE @p_model_id				NVARCHAR(1000)			= '';
    --DECLARE @p_nickname				NVARCHAR(1000)			= '';
    --DECLARE @p_check_fcst			NVARCHAR(1000)			= 'N';
    --DECLARE @p_check_production		NVARCHAR(1000)			= 'N';
    --DECLARE @p_check_active			NVARCHAR(1)				= 'N';
    --DECLARE @p_check_bom			NVARCHAR(1)				= 'N';
    --DECLARE @p_user_id				NVARCHAR(1000)			= 'iamarock';
    --DECLARE @debug_mode				NVARCHAR(1)				= 'F'
	
	--NERP 매핑코드 [HQ00] = C100
    DECLARE @v_ESOC NVARCHAR(8);
	SELECT @v_ESOC = dbo.FN_GET_LOOKUP_VALUE('FN_SCP0080_GET_GROUP_CODE_MANAGEMENT','ESOC')


    DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;

	--과거 3개월 판매이력

    DECLARE @TblGroupCode_SP0080_MASS TABLE
    (
          DIVISION_ID					NVARCHAR(30)	NULL
        , ITEM_ID						NVARCHAR(50)	NULL
    )

	INSERT INTO	@TblGroupCode_SP0080_MASS
	SELECT DISTINCT
			  DIVISION_ID
			, ITEM_ID
			--, FCST_TYPE
			--, MEASURE
			--, YYYYMMDD
			--, 'Y' AS MOTH
	FROM	DM_PLN_MKT_FCST_RESULT
	WHERE	1=1
        AND DIVISION_ID = @p_division_id
		AND MEASURE   = 'RTF_SYS_RP'
		AND FCST_TYPE = 'MPS' --Mass
		AND YYYYMMDD  > DATEADD(DAY,-90,GETDATE())

	DECLARE @TblGroupCode_SP0080_ITEM_ALL TABLE
	(
          DIVISION_ID					NVARCHAR(30)	NULL
        , ITEM_ID						NVARCHAR(50)	NULL
	    , STATUS_NEW					NVARCHAR(1)		NULL
	    , ACTIVE_FLAG					NVARCHAR(1)		NULL
		, INSERT_TIME					DATETIME		NOT NULL
	    , SCP_EXTRA_SPEC				NVARCHAR(150)	NULL
	)

	INSERT INTO	@TblGroupCode_SP0080_ITEM_ALL
	SELECT DISTINCT
			  DIVISION_ID
			, ITEM_ID
			, 'Y' AS STATUS_NEW
            , ACTIVE_FLAG
            , INSERT_TIME
            , SCP_EXTRA_SPEC -- 40 : Product level2
	FROM	SCM_MST_ITEM_SN
    WHERE   1=1
        AND DIVISION_ID = @p_division_id

--TESTING : NOK
--select * from @TblGroupCode_SP0080_ITEM_ALL;return;

	--신규 Item ID 발번되어 I/F된지 3주 이내 아이템
	DECLARE @TblGroupCode_SP0080_ITEM TABLE
	(
          DIVISION_ID					NVARCHAR(30)	NULL
        , ITEM_ID						NVARCHAR(50)	NULL
	    , STATUS_NEW					NVARCHAR(1)		NULL
	)

	INSERT INTO	@TblGroupCode_SP0080_ITEM
	SELECT DISTINCT
			  DIVISION_ID
			, ITEM_ID
			, STATUS_NEW
	FROM	@TblGroupCode_SP0080_ITEM_ALL
	WHERE	1=1
        AND INSERT_TIME > DATEADD(DAY,-21,GETDATE())


	DECLARE @TblGroupCode_SP0080_ITEM_ACTIVE TABLE
	(
          DIVISION_ID					NVARCHAR(30)	NULL
        , ITEM_ID						NVARCHAR(50)	NULL
	    , ACTIVE_FLAG					NVARCHAR(1)		NULL

	      --INDEX IDX_TblGroupCode_SP0080_ITEM_ACTIVE NONCLUSTERED(DIVISION_ID, ITEM_ID)
	      INDEX IDX_TblGroupCode_SP0080_ITEM_ACTIVE CLUSTERED(DIVISION_ID, ITEM_ID)
    )

    INSERT INTO    @TblGroupCode_SP0080_ITEM_ACTIVE
    SELECT    A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG
    FROM    (
                SELECT    A.DIVISION_ID
                        , A.ITEM_ID
                        , A.ACTIVE_FLAG
                FROM    (
	                        SELECT    DIVISION_ID
                                    , ITEM_ID
                                    , ACTIVE_FLAG
                                    , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, ITEM_ID ORDER BY IIF(ACTIVE_FLAG = 'Y', 1, 2) ASC) RN
	                        FROM    @TblGroupCode_SP0080_ITEM_ALL
                        ) A
                WHERE   1=1
                    AND A.RN = 1
            ) A
    GROUP BY  A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG;

--TESTING : OK
--select * from @TblGroupCode_SP0080_ITEM_ACTIVE;return;


	DECLARE @TblGroupCode_SP0080_ITEM_EXTRA_SPEC TABLE
	(
          DIVISION_ID					NVARCHAR(30)	NULL
        , ITEM_ID						NVARCHAR(50)	NULL
	    , SCP_EXTRA_SPEC				NVARCHAR(150)	NULL
	)

	INSERT INTO	@TblGroupCode_SP0080_ITEM_EXTRA_SPEC
	SELECT DISTINCT
			  DIVISION_ID
			, ITEM_ID
            , SCP_EXTRA_SPEC -- 40 : Product level2
	FROM    @TblGroupCode_SP0080_ITEM_ALL
    WHERE   1=1
        AND SCP_EXTRA_SPEC IS NOT NULL

--TESTING : NOK
--select  *
--from    @TblGroupCode_SP0080_ITEM_EXTRA_SPEC
--where   1=1
--    AND ITEM_ID IN ('MCMM725075A1')
--ORDER BY ITEM_ID
--return;

	DECLARE @TblGroupCode_SP0080_PLANT TABLE
	(
          DIVISION_ID					NVARCHAR(30)	NULL
        , ITEM_ID						NVARCHAR(50)	NULL
	    , OPERATION_GROUP				NVARCHAR(10)	NULL
	    , PLANT_ID						NVARCHAR(30)	NULL
	    , PLANT_NAME					NVARCHAR(50)	NULL
		, RN							BIGINT			NULL
	)

    INSERT INTO    @TblGroupCode_SP0080_PLANT
    SELECT  *
    FROM
            (
                SELECT --DISTINCT
                          P.DIVISION_ID
                        , P.ITEM_ID
                        , S.OPERATION_GROUP
                        , S.PLANT_ID
			            , CASE
                            WHEN S.OPERATION_GROUP = 'W' THEN S.PLANT_ID
				            WHEN N.PLANT_NAME IS NULL    THEN V.VENDOR_NAME
                            ELSE N.PLANT_NAME
                          END AS PLANT_NAME
                        , ROW_NUMBER() OVER(PARTITION BY   P.DIVISION_ID, P.ITEM_ID, S.OPERATION_GROUP ORDER BY (S.PLANT_ID)) AS RN
			            --, CASE
               --             WHEN S.OSP_YN = 'Y' THEN
               --                 CASE
               --                     WHEN V.ATTRIBUTE1 IS NULL THEN
               --                         CASE
               --                             WHEN S.OPERATION_GROUP = 'W'    THEN S.PLANT_ID
               --                             WHEN N.PLANT_NAME IS NULL       THEN V.VENDOR_NAME
               --                             ELSE N.PLANT_NAME
               --                         END
               --                     ELSE V.ATTRIBUTE1
               --                 END
			            --	WHEN S.OSP_YN = 'N' THEN
               --                 CASE
               --                     WHEN SN.DESCRIPTION IS NULL THEN
               --                         CASE
               --                             WHEN S.OPERATION_GROUP = 'W'    THEN S.PLANT_ID
               --                             WHEN N.PLANT_NAME IS NULL       THEN V.VENDOR_NAME
               --                             ELSE N.PLANT_NAME
               --                         END
               --                     ELSE SN.DESCRIPTION
               --                 END
               --           END AS PLANT_NAME
                FROM    SCM_MST_SITE_ITEM_PRIORITY P WITH(NOLOCK)
                        JOIN SCM_MST_SITE S (NOLOCK) ON
                                P.DIVISION_ID   = S.DIVISION_ID
                            AND P.PLANT_SITE_ID = S.SCM_SITE_ID
			            LEFT OUTER JOIN SCM_MST_PLANT_SN N (NOLOCK) ON
                                S.COMPANY_ID    = N.COMPANY_ID
                            AND S.DIVISION_ID   = P.DIVISION_ID
                            AND S.PLANT_ID      = N.PLANT_ID
			            LEFT OUTER JOIN SCM_MST_VENDOR V WITH(NOLOCK) ON
                                V.VENDOR_CODE   = S.PLANT_ID
                            AND S.COMPANY_ID    = V.COMPANY_ID
			            LEFT OUTER JOIN SCM_PLANT_M_SN SN WITH(NOLOCK) ON
                                S.DIVISION_ID   = SN.DIVISION_ID
                            AND S.PLANT_ID =SN.PLANT_ID
                WHERE   1=1
                    AND P.PRIORITY    = '1'
                    AND P.VALID_YN    = 'Y'
                    AND S.SITE_TYPE   = 'PLANT'
                    AND S.VALID_YN    = 'Y'
                    AND CONVERT(VARCHAR(8), GETDATE(), 112) BETWEEN P.FROM_YYYYMMDD AND P.TO_YYYYMMDD
            ) A
    WHERE   A.RN = 1

--TESTING : OK
--select * from @TblGroupCode_SP0080_PLANT;return;
--select  *
--from    @TblGroupCode_SP0080_PLANT
--WHERE   1=1
--    AND ITEM_ID = 'ACEH1085I-A1-000'
--return;

	DECLARE @TblGroupCode_SP0080_ESS_MODEL_TYPE TABLE
	(
	      CODE					NVARCHAR(200)	NULL
	    , NAME					NVARCHAR(200)	NULL
	)

    INSERT INTO    @TblGroupCode_SP0080_ESS_MODEL_TYPE
    SELECT    B.SEGMENT1 CODE
		    , B.SEGMENT2 NAME
    FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON
                    A.LOOKUP_TYPE = B.LOOKUP_TYPE
    WHERE   A.LOOKUP_TYPE = 'ITEM_MODEL_TYPE'
	    AND A.VALID_YN = 'Y'
	    AND B.VALID_YN = 'Y'
	    AND B.SEGMENT3 = '82'
    ORDER BY B.DISPLAY_SEQ;

	DECLARE @TblGroupCode_SP0080_SMALL_MODEL_TYPE TABLE
	(
	      CODE					NVARCHAR(200)	NULL
	    , NAME					NVARCHAR(200)	NULL
	)

    INSERT INTO    @TblGroupCode_SP0080_SMALL_MODEL_TYPE
    SELECT    B.SEGMENT1 CODE
		    , B.SEGMENT2 NAME
    FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON
                    A.LOOKUP_TYPE = B.LOOKUP_TYPE
    WHERE   A.LOOKUP_TYPE = 'ITEM_MODEL_TYPE'
	    AND A.VALID_YN = 'Y'
	    AND B.VALID_YN = 'Y'
	    AND B.SEGMENT3 = '40'
    ORDER BY B.DISPLAY_SEQ;

	DECLARE @TblGroupCode_SP0080_CATHODE TABLE
	(
	      CODE					NVARCHAR(200)	NULL
	    , NAME					NVARCHAR(200)	NULL
	)

    INSERT INTO    @TblGroupCode_SP0080_CATHODE
    SELECT    B.SEGMENT1 CODE
		    , B.SEGMENT2 NAME
    FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON
                    A.LOOKUP_TYPE = B.LOOKUP_TYPE
    WHERE   A.LOOKUP_TYPE = 'CATHODE'
	    AND A.VALID_YN = 'Y'
	    AND B.VALID_YN = 'Y'
    ORDER BY B.DISPLAY_SEQ;


	DECLARE @TblGroupCode_SP0080_CELL_TYPE_GROUP TABLE
	(
	      CELL_TYPE_CODE				NVARCHAR(200)	NULL
	    , FLOW_TYPE						NVARCHAR(1)		NULL
	    , CELL_TYPE_GROUP_CODE			NVARCHAR(200)	NULL
	    , CELL_TYPE_GROUP_NAME			NVARCHAR(200)	NULL
        , DISPLAY_SEQ                   INT             NULL
	)

    INSERT INTO    @TblGroupCode_SP0080_CELL_TYPE_GROUP
    SELECT    A.CODE                    AS CELL_TYPE_CODE
            , SUBSTRING(A.NAME, 1, 1)   AS FLOW_TYPE
            , A.GROUP_CODE              AS CELL_TYPE_GROUP_CODE
            , G.NAME                    AS CELL_TYPE_GROUP_NAME
            , A.DISPLAY_SEQ
    FROM    (
                SELECT    B.SEGMENT1 CODE
                        , B.SEGMENT2 NAME
                        , B.SEGMENT3 GROUP_CODE
                        , B.DISPLAY_SEQ
                FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                        JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON
                                A.LOOKUP_TYPE = B.LOOKUP_TYPE
        	                AND B.VALID_YN = 'Y'
                WHERE   1=1
                    AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_CODE'
	                AND A.VALID_YN      = 'Y'
            ) A
            JOIN
                (
                    SELECT    B.SEGMENT1 CODE
                            , B.SEGMENT2 NAME
                    FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                            JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON
                                    A.LOOKUP_TYPE = B.LOOKUP_TYPE
        	                    AND B.VALID_YN = 'Y'
                    WHERE   1=1
                        AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_GROUP'
	                    AND A.VALID_YN      = 'Y'
                 ) G ON
                    A.GROUP_CODE = G.CODE
    ORDER BY A.DISPLAY_SEQ

	DECLARE @TblGroupCode_SP0080_ENERGE TABLE
	(
          DIVISION_ID					NVARCHAR(30)	NULL
        , SITE_ID						NVARCHAR(30)	NULL
        , ITEM_ID						NVARCHAR(50)	NULL
	    , ENERGE						NVARCHAR(30)	NULL
	)

    INSERT INTO    @TblGroupCode_SP0080_ENERGE
    SELECT    DIVISION_ID
            , SITE_ID
            , ITEM_ID
            , ENERGE
    FROM    dbo.SCM_MST_ITEM_SN
    WHERE   1=1
        AND DIVISION_ID in ('82','40')
        AND COMPANY_ID = @v_ESOC
        AND ENERGE IS NOT NULL
        AND ENERGE <> ''

--TESTING : OK
--select  *
--from    @TblGroupCode_SP0080_ENERGE
--where   1=1
--    AND ITEM_ID = 'ECE0710N7-02'
--return;

--PRINT CONCAT('ELAPSED_TIME-Temp Codes : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
    
    --평가감 CELL_CF
	DECLARE @TblDynamicPivot_SCP0080_CELL_CF_KD TABLE
	(
          ITEM_ID						NVARCHAR(50)	NULL
        , CELL_CF						NVARCHAR(100)	NULL
    )

    INSERT INTO @TblDynamicPivot_SCP0080_CELL_CF_KD
    SELECT    A.ITEM_ID
            , CONVERT(NVARCHAR(100), CONVERT(NUMERIC(20, 10), ISNULL(B.CELL_CF, '1.0')))     AS CELL_CF
    FROM
            (
                SELECT    DIVISION_ID
                        , ITEM_ID
                        , CASE 
                            WHEN RIGHT(A.ITEM_ID, 2) IN ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R')  THEN SUBSTRING(ITEM_ID, 1, LEN(ITEM_ID) - 2)
                            WHEN RIGHT(A.ITEM_ID, 3) IN ('-GG','-GK')                                                   THEN SUBSTRING(ITEM_ID, 1, LEN(ITEM_ID) - 3)
                          END AS BASIC_ITEM_ID
                FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
                WHERE   1=1
                    AND (RIGHT(A.ITEM_ID, 2) IN ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R') OR
                         RIGHT(A.ITEM_ID, 3) IN ('-GG','-GK'))
            ) A
            LEFT JOIN (
                        SELECT  *
                        FROM    SCP_MST_ITEM_CELL_CF WITH(NOLOCK)
                        WHERE   1=1
                        ) B ON
                    A.BASIC_ITEM_ID = B.ITEM_ID;

--TESTING : OK
--select  * from #TblDynamicPivot_SCP0080_CELL_CF_KD;


	DECLARE @TblGroupCode_SP0080_Temp TABLE
	(
          DIVISION_ID					NVARCHAR(30)	NULL
        , OPERATION_ID					NVARCHAR(150)	NULL
        , ITEM_ID						NVARCHAR(50)	NULL
	    , NICK_NAME						NVARCHAR(150)	NULL
	    , BASIC_MODEL_PACK				NVARCHAR(100)	NULL
	    , BASIC_NICKNAME_PACK			NVARCHAR(150)	NULL
	    , CELL_MODEL					NVARCHAR(150)	NULL
	    , CELL_MODEL_NICKNAME			NVARCHAR(150)	NULL
	    , BASIC_MODEL_CELL				NVARCHAR(150)	NULL
	    , BASIC_NICKNAME_CELL			NVARCHAR(150)	NULL
	    , GROUP_CODE1					NVARCHAR(150)	NULL
	    , GROUP_CODE2					NVARCHAR(150)	NULL
	    , GROUP_CODE3					NVARCHAR(150)	NULL
	    , GROUP_CODE4					NVARCHAR(150)	NULL
	    , GROUP_CODE5					NVARCHAR(150)	NULL
	    , GROUP_CODE6					NVARCHAR(150)	NULL
	    , GROUP_CODE7					NVARCHAR(150)	NULL
	    , GROUP_CODE8					NVARCHAR(150)	NULL
	    , GROUP_CODE9					NVARCHAR(150)	NULL
	    , GROUP_CODE10					NVARCHAR(150)	NULL
	    , FCST_YN						NVARCHAR(1)		NULL
	    , PIC_ID						NVARCHAR(150)	NULL
	    , PIC_NAME						NVARCHAR(300)	NULL
	    , ATTRIBUTE7					NVARCHAR(150)	NULL
	    , ATTRIBUTE8					NVARCHAR(150)	NULL
	    , ATTRIBUTE9					NVARCHAR(150)	NULL
	    , ATTRIBUTE10					NVARCHAR(150)	NULL
	    , ATTRIBUTE11					NVARCHAR(150)	NULL
	    , ATTRIBUTE12					NVARCHAR(150)	NULL
	    , ATTRIBUTE13					NVARCHAR(150)	NULL
	    , ATTRIBUTE14					NVARCHAR(150)	NULL
	    , ATTRIBUTE15					NVARCHAR(150)	NULL
	    , SALES_MODEL					NVARCHAR(100)	NULL
	    , SALES_VALID_YN				NVARCHAR(1)		NULL
	    , SALES_PRIORITY				INT				NULL
	    , SALES_FROM_YYYYMMDD			NVARCHAR(100)	NULL
	    , SALES_TO_YYYYMMDD				NVARCHAR(100)	NULL
	    , LEVEL1_GROUP					NVARCHAR(150)	NULL
	    , LEVEL2_CODE					NVARCHAR(150)	NULL
	    , STATUS_PROTOTYPE				NVARCHAR(1)		NULL
	    , STATUS_NEW					NVARCHAR(1)		NULL
	    , CELL_CF						NVARCHAR(100)	NULL
	    , BASIC_END_CUSTOMER			NVARCHAR(150)	NULL
	    , BASIC_FINISHED_PRODUCT		NVARCHAR(150)	NULL
	    , OPERATION_GROUP				NVARCHAR(10)	NULL
	    , BIZ_TYPE						NVARCHAR(100)	NULL
	    , MODEL_TYPE_CODE				NVARCHAR(1)		NULL
	    , LEVEL_EXCEPT					NVARCHAR(2)		NULL
	    , MKT_DEPT						NVARCHAR(150)	NULL
	    , REMARK						NVARCHAR(3000)	NULL
	    , PLANT_ID						NVARCHAR(30)	NULL
	    , PLANT_NAME					NVARCHAR(50)	NULL
	    , ENERGE						NVARCHAR(30)	NULL
	    , FLOW_TYPE						NVARCHAR(1)		NULL
	    , ITEM_ID_ASSY					NVARCHAR(50)	NULL
        , REPLACEMENT					NVARCHAR(1)		NULL
	    --, SCP_EXTRA_SPEC				NVARCHAR(150)	NULL
	    , CATHODE_CODE					NVARCHAR(2)		NULL
	)

--TESTING : OK
--SELECT  A.*
--FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
--		LEFT JOIN @TblGroupCode_SP0080_PLANT D ON
--                A.DIVISION_ID       = D.DIVISION_ID
--            AND A.OPERATION_GROUP   = D.OPERATION_GROUP
--            AND A.ITEM_ID           = D.ITEM_ID
--WHERE   1=1
--	AND A.OPERATION_GROUP IN ('A', 'P')
--	AND A.DIVISION_ID = '82'
--	AND A.ITEM_ID = 'ECE0668N5-01'
--return;

    INSERT INTO    @TblGroupCode_SP0080_Temp
    SELECT    A.*
            , SUBSTRING(A.BASIC_MODEL_CELL, 8, 2)   AS CATHODE_CODE
    FROM    (
                SELECT --DISTINCT
                          A.DIVISION_ID
			            , A.FLOW_ID         AS OPERATION_ID
			            , A.ITEM_ID
			            , A.NICK_NAME
			            , CASE
			                WHEN A.OPERATION_GROUP = 'P' THEN (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)
			                ELSE ''
			                END                       AS BASIC_MODEL_PACK
			            , CASE
			                WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL))
			                ELSE ''
			                END                       AS BASIC_NICKNAME_PACK

                        , CASE
                            WHEN A.FLOW_ID IN ('A3000', 'A9000', 'F6200', 'F7000', 'F7100', 'F7200', 'F7300') THEN A.ITEM_ID
                            ELSE
			                  CASE
			                    WHEN A.OPERATION_GROUP = 'P' THEN A.ATTRIBUTE1
			                    ELSE ''
		                      END
                          END AS CELL_MODEL
                        , CASE
                            WHEN A.FLOW_ID IN ('A3000', 'A9000', 'F6200', 'F7000', 'F7100', 'F7200', 'F7300') THEN A.NICK_NAME
                            ELSE
			                  CASE
			 	                WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1)
			                    ELSE ''
		                      END
                          END AS CELL_MODEL_NICKNAME
			            , CASE
			                WHEN A.OPERATION_GROUP = 'P' THEN (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL)
			                ELSE (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)
			                END                       AS BASIC_MODEL_CELL
			            , CASE
			                WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL))
			                ELSE (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL))
			                END                       AS BASIC_NICKNAME_CELL
			            , A.GROUP_CODE1
			            , A.GROUP_CODE2
			            , A.GROUP_CODE3
			            , A.GROUP_CODE4
			            , A.GROUP_CODE5
			            , A.GROUP_CODE6
			            , A.GROUP_CODE7
			            , A.GROUP_CODE8
			            , A.GROUP_CODE9
			            , A.GROUP_CODE10
			            , ISNULL(A.FCST_YN, 'N')    AS FCST_YN
			            , A.ATTRIBUTE6              AS PIC_ID
                        , UI.USER_NAME              AS PIC_NAME
			            , A.ATTRIBUTE7
			            , A.ATTRIBUTE8
			            , A.ATTRIBUTE9
			            , A.ATTRIBUTE10
			            , A.ATTRIBUTE11
			            , A.ATTRIBUTE12
			            , A.ATTRIBUTE13
			            , A.ATTRIBUTE14
			            , A.ATTRIBUTE15
			            , A.SALES_MODEL
			            , A.SALES_VALID_YN
			            , A.SALES_PRIORITY
			            , A.SALES_FROM_YYYYMMDD
			            , A.SALES_TO_YYYYMMDD
			            , CASE
                            WHEN A.FLOW_ID = 'A9000' THEN A.GROUP_CODE1
                            WHEN A.FLOW_ID = 'P5000' OR A.FLOW_ID = 'P5500' OR A.FLOW_ID = 'P9500' THEN A.GROUP_CODE2
                            END                       AS LEVEL1_GROUP
			            , A.LEVEL2_CODE
			            , IIF(C.STATUS_NEW = 'Y' AND ISNULL(A.STATUS_PROTOTYPE, '') <> '', 'Y', A.STATUS_PROTOTYPE) AS STATUS_PROTOTYPE
			            --, CASE
               --             WHEN ISNULL(A.FCST_YN, '') = '' AND ISNULL(B.MOTH, '') = '' THEN ''
               --             ELSE 'Y'
               --           END                        AS STATUS_MASS
			            , C.STATUS_NEW
                        --, ROUND(CONVERT(NUMERIC(20, 10),
                        , ROUND(CONVERT(NUMERIC(20),
                              CASE
                                WHEN RIGHT(A.ITEM_ID, 2) IN ('-D', '-K') THEN F.CELL_CF
                                ELSE
			                        CASE
                                    WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN
                                        CASE
                                            WHEN ISNULL(A.CELL_CF, '0') = '0' THEN '1'
                                            ELSE A.CELL_CF
                                        END
                                    ELSE A.CELL_CF
                                    END
                              END
                          ), 0)                     AS CELL_CF
			            , A.END_CUSTOMER            AS BASIC_END_CUSTOMER
			            , A.FINISHED_PRODUCT        AS BASIC_FINISHED_PRODUCT
                        , A.OPERATION_GROUP
                        , CASE
                            WHEN A.FLOW_ID = 'A9000'    THEN 'Cell'
                            WHEN A.FLOW_ID = 'P5500'    THEN 'Module'
                            WHEN A.FLOW_ID = 'P9500'    THEN 'Pack'
                            ELSE                             ''--P5000
                          END AS BIZ_TYPE
                        , SUBSTRING(A.ITEM_ID, 2, 1) AS MODEL_TYPE_CODE
                        , SUBSTRING(A.ITEM_ID, 1, 2) AS LEVEL_EXCEPT -- 예외적용
                        , A.MKT_DEPT
                        , A.REMARK
                        , D.PLANT_ID
                        , D.PLANT_NAME
                        , E.ENERGE
                        , CASE
                            WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN 'C'
                            ELSE 'E'
                          END AS FLOW_TYPE
                        , M.ITEM_ID_ASSY
                        , A.REPLACEMENT
                        --, A.SCP_EXTRA_SPEC
	            FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
			            --LEFT JOIN @TblGroupCode_SP0080_MASS B ON
               --                 A.DIVISION_ID       = B.DIVISION_ID
               --             AND A.ITEM_ID           = B.ITEM_ID
			            LEFT JOIN @TblGroupCode_SP0080_ITEM C ON
                                A.DIVISION_ID       = C.DIVISION_ID
                            AND A.ITEM_ID           = C.ITEM_ID
			            LEFT JOIN @TblGroupCode_SP0080_PLANT D ON
                                A.DIVISION_ID       = D.DIVISION_ID
                            --AND A.OPERATION_GROUP   = D.OPERATION_GROUP
                            AND A.ITEM_ID           = D.ITEM_ID
                        LEFT JOIN @TblGroupCode_SP0080_ENERGE E ON
                                A.DIVISION_ID       = E.DIVISION_ID
                            AND A.ITEM_ID           = E.ITEM_ID
                        LEFT JOIN @TblDynamicPivot_SCP0080_CELL_CF_KD F ON
                                A.ITEM_ID           = F.ITEM_ID
                        LEFT JOIN SCM_MST_SSO_USER_INFO UI WITH(NOLOCK) ON
                                A.ATTRIBUTE6        = UI.USER_ID
                        LEFT JOIN
                            (
                                SELECT    DIVISION_ID
                                        , ITEM_ID_PROD
                                        , MIN(ITEM_ID_ASSY) AS ITEM_ID_ASSY
                                FROM    SCP_MST_CELL_PROD_ASSY_MAP WITH(NOLOCK)
                                WHERE   1=1
                                    AND VALID_YN = 'Y'
                                    AND CELL_TYPE = 'CA1'
                                GROUP BY  DIVISION_ID
                                        , ITEM_ID_PROD
                            ) M ON
                                A.DIVISION_ID = M.DIVISION_ID
                            AND A.ITEM_ID     = M.ITEM_ID_PROD
	            WHERE   1=1
                    AND (SUBSTRING(A.ATTRIBUTE8, 1, 2) <> 'CA' OR A.ATTRIBUTE8 = '' OR A.ATTRIBUTE8 IS NULL) --활성화코드 분리
		            AND A.OPERATION_GROUP IN ('A', 'P')
		            AND A.DIVISION_ID = @p_division_id
		            AND (( @p_operation_id	IS NULL OR @p_operation_id	='') OR A.FLOW_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_operation_id	, ',')))
		            AND (( @p_model_id		IS NULL OR @p_model_id		='') OR A.ITEM_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_model_id		, ',')))
		            AND (( @p_nickname		IS NULL OR @p_nickname		='') OR A.NICK_NAME				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_nickname		, ',')))
        ) A

--TESTING : OK
--select *  from @TblGroupCode_SP0080_Temp;return;

--select *
--from    @TblGroupCode_SP0080_Temp
--WHERE   1=1
--    AND ITEM_ID = 'ACEH1085I-A1-000'
--return;

--PRINT CONCAT('ELAPSED_TIME-@TblGroupCode_SP0080_Temp : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

    DECLARE @TblGroupCode_SP0080_Pre TABLE
	(
          DIVISION_ID					NVARCHAR(30)	NULL
        , OPERATION_ID					NVARCHAR(150)	NULL
        , ITEM_ID						NVARCHAR(50)	NULL
	    , NICK_NAME						NVARCHAR(150)	NULL
	    , BASIC_MODEL_PACK				NVARCHAR(100)	NULL
	    , BASIC_NICKNAME_PACK			NVARCHAR(150)	NULL
	    , CELL_MODEL					NVARCHAR(150)	NULL
	    , CELL_MODEL_NICKNAME			NVARCHAR(150)	NULL
	    , BASIC_MODEL_CELL				NVARCHAR(150)	NULL
	    , BASIC_NICKNAME_CELL			NVARCHAR(150)	NULL
	    , GROUP_CODE1					NVARCHAR(150)	NULL
	    , GROUP_CODE2					NVARCHAR(150)	NULL
	    , GROUP_CODE3					NVARCHAR(150)	NULL
	    , GROUP_CODE4					NVARCHAR(150)	NULL
	    , GROUP_CODE5					NVARCHAR(150)	NULL
	    , GROUP_CODE6					NVARCHAR(150)	NULL
	    , GROUP_CODE7					NVARCHAR(150)	NULL
	    , GROUP_CODE8					NVARCHAR(150)	NULL
	    , GROUP_CODE9					NVARCHAR(150)	NULL
	    , GROUP_CODE10					NVARCHAR(150)	NULL
	    , FCST_YN						NVARCHAR(1)		NULL
	    , PIC_ID						NVARCHAR(150)	NULL
	    , PIC_NAME						NVARCHAR(300)	NULL
	    , ATTRIBUTE7					NVARCHAR(150)	NULL
	    , ATTRIBUTE8					NVARCHAR(150)	NULL
	    , ATTRIBUTE9					NVARCHAR(150)	NULL
	    , ATTRIBUTE10					NVARCHAR(150)	NULL
	    , ATTRIBUTE11					NVARCHAR(150)	NULL
	    , ATTRIBUTE12					NVARCHAR(150)	NULL
	    , ATTRIBUTE13					NVARCHAR(150)	NULL
	    , ATTRIBUTE14					NVARCHAR(150)	NULL
	    , ATTRIBUTE15					NVARCHAR(150)	NULL
	    , SALES_MODEL					NVARCHAR(100)	NULL
	    , SALES_VALID_YN				NVARCHAR(1)		NULL
	    , SALES_PRIORITY				INT				NULL
	    , SALES_FROM_YYYYMMDD			NVARCHAR(100)	NULL
	    , SALES_TO_YYYYMMDD				NVARCHAR(100)	NULL
	    , LEVEL1_GROUP					NVARCHAR(150)	NULL
	    , LEVEL2_CODE					NVARCHAR(150)	NULL
	    , STATUS_PROTOTYPE				NVARCHAR(1)		NULL
	    , STATUS_NEW					NVARCHAR(1)		NULL
	    , CELL_CF						NVARCHAR(100)	NULL
	    , BASIC_END_CUSTOMER			NVARCHAR(150)	NULL
	    , BASIC_FINISHED_PRODUCT		NVARCHAR(150)	NULL
	    , OPERATION_GROUP				NVARCHAR(10)	NULL
	    , BIZ_TYPE						NVARCHAR(100)	NULL
	    , MODEL_TYPE_CODE				NVARCHAR(1)		NULL
	    , LEVEL_EXCEPT					NVARCHAR(2)		NULL
	    , MKT_DEPT						NVARCHAR(150)	NULL
	    , REMARK						NVARCHAR(3000)	NULL
	    , PLANT_ID						NVARCHAR(30)	NULL
	    , PLANT_NAME					NVARCHAR(50)	NULL
	    , ENERGE						NVARCHAR(30)	NULL
	    , FLOW_TYPE						NVARCHAR(1)		NULL
	    , ITEM_ID_ASSY					NVARCHAR(50)	NULL
        , REPLACEMENT					NVARCHAR(1)		NULL
	    --, SCP_EXTRA_SPEC				NVARCHAR(150)	NULL
	    , CATHODE_CODE					NVARCHAR(2)		NULL
	    , BASIC_APPLICATION				NVARCHAR(1)		NULL
	    , BASIC_CELL_TYPE				NVARCHAR(2)		NULL
	    , BASIC_CELL_CAPACITY_CHAR		NVARCHAR(10)	NULL
	    , CATHODE_NAME					NVARCHAR(200)	NULL
	    , CELL_TYPE_CODE				NVARCHAR(200)	NULL
	    , NICKNAME_40					NVARCHAR(150)	NULL
	    , MODEL_TYPE_NAME_82			NVARCHAR(200)	NULL
	    , MODEL_TYPE_NAME_40			NVARCHAR(200)	NULL
	    , SCP_EXTRA_SPEC				NVARCHAR(150)	NULL
	    , BASIC_NICKNAME_CELL40			NVARCHAR(150)	NULL
	)

    INSERT INTO    @TblGroupCode_SP0080_Pre
    SELECT    T.*
            , CASE
                WHEN T.BASIC_MODEL_CELL IS NOT NULL AND T.BASIC_MODEL_CELL <> '' THEN SUBSTRING(T.BASIC_MODEL_CELL, 3, 1)
                ELSE T.BASIC_MODEL_CELL
              END AS BASIC_APPLICATION
            , CASE
                WHEN T.BASIC_MODEL_CELL IS NOT NULL AND T.BASIC_MODEL_CELL <> '' THEN SUBSTRING(T.BASIC_MODEL_CELL, 4, 2)
                ELSE T.BASIC_MODEL_CELL
              END AS BASIC_CELL_TYPE
            --, IIF(SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) IS NULL, 0, IIF(SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) LIKE '%[^0-9]%', ROUND(CONVERT(NUMERIC(30), SUBSTRING(T.BASIC_MODEL_CELL, 6, 3)), 0), 0)) AS BASIC_CELL_CAPACITY_81
            --, IIF(SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) LIKE '%[^0-9]%' AND SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) IS NOT NULL, ROUND(CONVERT(NUMERIC(30), SUBSTRING(T.BASIC_MODEL_CELL, 6, 3)), 0), 0)  AS BASIC_CELL_CAPACITY_81
            --, IIF(SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) LIKE '%[^0-9]%', 'X', 'O') AS BASIC_CELL_CAPACITY_N
            , CASE
                WHEN SUBSTRING(T.BASIC_MODEL_CELL, 1, 2) = 'EC' THEN SUBSTRING(T.BASIC_MODEL_CELL, 4, 4)
                ELSE                                                 SUBSTRING(T.BASIC_MODEL_CELL, 6, 3)
              END AS BASIC_CELL_CAPACITY_CHAR
            --, SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) AS BASIC_MODEL_CELL_ORI
            --, SUBSTRING(T.BASIC_MODEL_CELL, 8, 1) AS BASIC_MODEL_CELL_LAST
            , H.NAME AS CATHODE_NAME
            , SUBSTRING(T.ITEM_ID, 3, 1) AS CELL_TYPE_CODE
            --, CASE
            --    WHEN T.FLOW_TYPE = 'C' THEN BASIC_NICKNAME_CELL
            --    ELSE T.NICK_NAME
            --  END AS NICKNAME_40
            , T.NICK_NAME AS NICKNAME_40
            , E.NAME AS MODEL_TYPE_NAME_82
            , S.NAME AS MODEL_TYPE_NAME_40
            , CASE
                WHEN LEVEL_EXCEPT = 'EC' THEN 'ESS'
                WHEN LEVEL_EXCEPT = 'AM' THEN '21700'
                ELSE X.SCP_EXTRA_SPEC
              END AS SCP_EXTRA_SPEC
            , CASE
                WHEN LEVEL_EXCEPT = 'EC' THEN 'ESS'
                WHEN LEVEL_EXCEPT = 'AM' THEN 'M50L'
                ELSE T.BASIC_NICKNAME_CELL
              END AS BASIC_NICKNAME_CELL40
    FROM    @TblGroupCode_SP0080_Temp T
            LEFT JOIN @TblGroupCode_SP0080_CATHODE H ON
                    T.CATHODE_CODE = H.CODE
            LEFT JOIN @TblGroupCode_SP0080_ESS_MODEL_TYPE E ON
                    T.MODEL_TYPE_CODE = E.CODE
            LEFT JOIN @TblGroupCode_SP0080_SMALL_MODEL_TYPE S ON
                    T.OPERATION_ID = S.CODE
            LEFT JOIN @TblGroupCode_SP0080_ITEM_EXTRA_SPEC X ON
                    T.DIVISION_ID       = X.DIVISION_ID
                AND T.ITEM_ID           = X.ITEM_ID
--TESTING : OK
--select * from @TblGroupCode_SP0080_Temp;
--select * from @TblGroupCode_SP0080_Pre;return;
--PRINT CONCAT('ELAPSED_TIME-@TblGroupCode_SP0080_Pre : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


    DECLARE @TblGroupCode_SP0080_All TABLE
	(
          DIVISION_ID					NVARCHAR(30)	    NULL
        , OPERATION_ID					NVARCHAR(150)	    NULL
        , ITEM_ID						NVARCHAR(50)	    NULL
	    , NICK_NAME						NVARCHAR(150)	    NULL
	    , BASIC_MODEL_PACK				NVARCHAR(100)	    NULL
	    , BASIC_NICKNAME_PACK			NVARCHAR(150)	    NULL
	    , CELL_MODEL					NVARCHAR(150)	    NULL
	    , CELL_MODEL_NICKNAME			NVARCHAR(150)	    NULL
	    , BASIC_MODEL_CELL				NVARCHAR(150)	    NULL
	    , BASIC_NICKNAME_CELL			NVARCHAR(150)	    NULL
	    , GROUP_CODE1					NVARCHAR(150)	    NULL
	    , GROUP_CODE2					NVARCHAR(150)	    NULL
	    , GROUP_CODE3					NVARCHAR(150)	    NULL
	    , GROUP_CODE4					NVARCHAR(150)	    NULL
	    , GROUP_CODE5					NVARCHAR(150)	    NULL
	    , GROUP_CODE6					NVARCHAR(150)	    NULL
	    , GROUP_CODE7					NVARCHAR(150)	    NULL
	    , GROUP_CODE8					NVARCHAR(150)	    NULL
	    , GROUP_CODE9					NVARCHAR(150)	    NULL
	    , GROUP_CODE10					NVARCHAR(150)	    NULL
	    , FCST_YN						NVARCHAR(1)		    NULL
	    , PIC_ID						NVARCHAR(150)	    NULL
	    , PIC_NAME						NVARCHAR(300)	    NULL
	    , ATTRIBUTE7					NVARCHAR(150)	    NULL
	    , ATTRIBUTE8					NVARCHAR(150)	    NULL
	    , ATTRIBUTE9					NVARCHAR(150)	    NULL
	    , ATTRIBUTE10					NVARCHAR(150)	    NULL
	    , ATTRIBUTE11					NVARCHAR(150)	    NULL
	    , ATTRIBUTE12					NVARCHAR(150)	    NULL
	    , ATTRIBUTE13					NVARCHAR(150)	    NULL
	    , ATTRIBUTE14					NVARCHAR(150)	    NULL
	    , ATTRIBUTE15					NVARCHAR(150)	    NULL
	    , SALES_MODEL					NVARCHAR(100)	    NULL
	    , SALES_VALID_YN				NVARCHAR(1)		    NULL
	    , SALES_PRIORITY				INT				    NULL
	    , SALES_FROM_YYYYMMDD			NVARCHAR(100)	    NULL
	    , SALES_TO_YYYYMMDD				NVARCHAR(100)	    NULL
	    , LEVEL1_GROUP					NVARCHAR(150)	    NULL
	    , LEVEL2_CODE					NVARCHAR(150)	    NULL
	    , STATUS_PROTOTYPE				NVARCHAR(1)		    NULL
	    , STATUS_NEW					NVARCHAR(1)		    NULL
	    , CELL_CF						NVARCHAR(100)	    NULL
	    , BASIC_END_CUSTOMER			NVARCHAR(150)	    NULL
	    , BASIC_FINISHED_PRODUCT		NVARCHAR(150)	    NULL
	    , OPERATION_GROUP				NVARCHAR(10)	    NULL
	    , BIZ_TYPE						NVARCHAR(100)	    NULL
	    , MODEL_TYPE_CODE				NVARCHAR(1)		    NULL
	    , LEVEL_EXCEPT					NVARCHAR(2)		    NULL
	    , MKT_DEPT						NVARCHAR(150)	    NULL
	    , REMARK						NVARCHAR(3000)	    NULL
	    , PLANT_ID						NVARCHAR(30)	    NULL
	    , PLANT_NAME					NVARCHAR(50)	    NULL
	    , ENERGE						NVARCHAR(30)	    NULL
	    , FLOW_TYPE						NVARCHAR(1)		    NULL
	    , ITEM_ID_ASSY					NVARCHAR(50)	    NULL
        , REPLACEMENT					NVARCHAR(1)		    NULL
	    --, SCP_EXTRA_SPEC				NVARCHAR(150)	    NULL
	    , CATHODE_CODE					NVARCHAR(2)		    NULL
	    , BASIC_APPLICATION				NVARCHAR(1)		    NULL
	    , BASIC_CELL_TYPE				NVARCHAR(2)		    NULL
	    , BASIC_CELL_CAPACITY_CHAR		NVARCHAR(10)	    NULL
	    , CATHODE_NAME					NVARCHAR(200)	    NULL
	    , CELL_TYPE_CODE				NVARCHAR(200)	    NULL
	    , NICKNAME_40					NVARCHAR(150)	    NULL
	    , MODEL_TYPE_NAME_82			NVARCHAR(200)	    NULL
	    , MODEL_TYPE_NAME_40			NVARCHAR(200)	    NULL
    	, SCP_EXTRA_SPEC				NVARCHAR(150)	    NULL
	    , BASIC_NICKNAME_CELL40			NVARCHAR(150)	    NULL
	    , APPLICATION_NAME				NVARCHAR(50)	    NULL
        , BASIC_CELL_CAPACITY_81		NUMERIC(20, 10) 	NULL
	    , CELL_TYPE_GROUP_NAME			NVARCHAR(200)	    NULL

          INDEX IDX_TblGroupCode_SP0080_All1 NONCLUSTERED(DIVISION_ID, ITEM_ID)
        , INDEX IDX_TblGroupCode_SP0080_All2 CLUSTERED(ITEM_ID)
        , INDEX IDX_TblGroupCode_SP0080_All3 NONCLUSTERED(FCST_YN)
        , INDEX IDX_TblGroupCode_SP0080_All4 NONCLUSTERED(OPERATION_GROUP)
	)
--select *
--from    @TblGroupCode_SP0080_Pre
--WHERE   1=1
--    AND ITEM_ID = 'ACEH1085I-A1-000'
--return;

    INSERT INTO    @TblGroupCode_SP0080_All
    SELECT    P.*
            , CASE
                WHEN P.BASIC_APPLICATION = 'E' THEN 'Battery EV(BEV)'
                WHEN P.BASIC_APPLICATION = 'H' THEN 'Hybrid(HEV)'
                WHEN P.BASIC_APPLICATION = 'L' THEN 'Low Voltage(LV)'
                WHEN P.BASIC_APPLICATION = 'P' THEN 'Plug-in HEV(PHEV)'
                ELSE            ''
              END AS APPLICATION_NAME
            , IIF(P.BASIC_CELL_CAPACITY_CHAR IS NULL OR (P.BASIC_CELL_CAPACITY_CHAR LIKE '%[^0-9]%'), NULL, CONVERT(NUMERIC(20, 10), P.BASIC_CELL_CAPACITY_CHAR)) AS BASIC_CELL_CAPACITY_81
            , CASE
                WHEN P.LEVEL_EXCEPT = 'EC' THEN 'Pouch'
                WHEN P.LEVEL_EXCEPT = 'AM' THEN 'Cylindrical'
                WHEN SUBSTRING(P.ITEM_ID, 3, 1) = 'M' AND P.OPERATION_ID = 'P9500' THEN 'Pouch'
                ELSE G.CELL_TYPE_GROUP_NAME
              END AS CELL_TYPE_GROUP_NAME
    FROM    @TblGroupCode_SP0080_Pre P
            LEFT JOIN @TblGroupCode_SP0080_CELL_TYPE_GROUP G ON
                    P.FLOW_TYPE = G.FLOW_TYPE
                AND P.CELL_TYPE_CODE = G.CELL_TYPE_CODE

	--CREATE CLUSTERED INDEX IDX_TblGroupCode_SP0080_All ON [dbo].[@TblGroupCode_SP0080_All] ([DIVISION_ID], [ITEM_ID]);


--PRINT CONCAT('ELAPSED_TIME-@TblGroupCode_SP0080_All : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


--TESTING : OK
--select * from @TblGroupCode_SP0080_CELL_TYPE_GROUP;
--select * from @TblGroupCode_SP0080_All;return;
--SELECT  *
--FROM    @TblGroupCode_SP0080_All
--WHERE   1=1
--    AND DIVISION_ID = '82'
--    AND ITEM_ID = 'ECE0710N7-02';
--return;


    DECLARE @TblGroupCode_SP0080_BOM_PACK TABLE
	(
	      ITEM_ID						NVARCHAR(50)	NULL
		, OPERATION_GROUP_ID			NVARCHAR(10)	NULL

          INDEX IDX_TblGroupCode_SP0080_BOM_PACK CLUSTERED(ITEM_ID)
	)

    INSERT INTO    @TblGroupCode_SP0080_BOM_PACK
	SELECT DISTINCT
              MODEL_ID AS ITEM_ID
            , OPERATION_GROUP_ID
	FROM    SCM_MST_MODEL_FINAL_ITEM_BOM_V WITH(NOLOCK)
	WHERE   DIVISION_ID = @p_division_id
        AND OPERATION_GROUP_ID = 'A'

    DECLARE @TblGroupCode_SP0080_BOM_CELL TABLE
	(
	      ITEM_ID						NVARCHAR(50)	NULL
		, OPERATION_GROUP_ID			NVARCHAR(10)	NULL

          INDEX IDX_TblGroupCode_SP0080_BOM_CELL CLUSTERED(ITEM_ID)
	)

    INSERT INTO    @TblGroupCode_SP0080_BOM_CELL
	SELECT DISTINCT
              MODEL_ID AS ITEM_ID
            , OPERATION_GROUP_ID
	FROM    SCM_MST_MODEL_FINAL_ITEM_BOM_V WITH(NOLOCK)
	WHERE   DIVISION_ID = @p_division_id
        AND OPERATION_GROUP_ID = 'E'

--TESTING : OK
--select * from @TblGroupCode_SP0080_BOM;return;

--PRINT CONCAT('ELAPSED_TIME-@TblGroupCode_SP0080_BOM_CELL : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


    DECLARE @v_basis_start_date NVARCHAR(16)    = '';

    SELECT  @v_basis_start_date = BASIS_START_DATE
    FROM    SCM_SYS_CALENDAR_M
    WHERE   BASIS_YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE(), 112)


    INSERT INTO @TBL_RES
    SELECT    A.*
            , CASE
                WHEN SUBSTRING(A.DIVISION_ID, 1, 2) = '81'  THEN IIF(A.BASIC_CELL_CAPACITY_81 IS NULL OR A.CELL_CF IS NULL, NULL, CONVERT(NUMERIC(20, 10), A.BASIC_CELL_CAPACITY_81 * A.CELL_CF))
                WHEN A.DIVISION_ID = '82'                   THEN IIF(A.CELL_CF IS NULL, NULL, CONVERT(NUMERIC(20, 10), A.ENERGE))
				WHEN A.DIVISION_ID = '40'                   THEN IIF(A.CELL_CF IS NULL, NULL, CONVERT(NUMERIC(20, 10), A.ENERGE))
                ELSE NULL
              END AS BASIC_TOTAL_CAPACITY
            , CASE
                WHEN SUBSTRING(A.DIVISION_ID, 1, 2) = '81'  THEN A.BASIC_CELL_CAPACITY_81
                WHEN A.DIVISION_ID = '82'                   THEN CONVERT(NUMERIC(20, 10), A.ENERGE) / A.CELL_CF
                ELSE NULL
              END AS BASIC_CELL_CAPACITY
              --ITEM 별 Plant가 n 개이면 Active 가 Plant 별로 Y, N 두개 이상 존재하므로 Y만 필터링(최종 row 가 ITEM 별 1개만 존재하도록)
            , IIF(P.ITEM_ID IS NOT NULL, 'Y', '')                                                               AS PRODUCTION_YN
            , IIF((P.ITEM_ID IS NOT NULL) OR A.FCST_YN = 'Y', 'Y', '')                                          AS STATUS_MASS
            , IIF(IA.ACTIVE_FLAG IS NULL, 'N', IA.ACTIVE_FLAG)                                                  AS STATUS_ACTIVE
    FROM    @TblGroupCode_SP0080_All A
		    LEFT JOIN (
                        SELECT    DISTINCT
                                  N.DIVISION_ID
                                , N.ITEM_ID
                        FROM    SCP_ANL_PRODUCTION_PLAN_N N WITH(NOLOCK)
                        WHERE   1=1
                            AND N.YYYYMMDD >= @v_basis_start_date
                      ) P ON
                    A.DIVISION_ID = P.DIVISION_ID
                AND A.ITEM_ID = P.ITEM_ID
            LEFT JOIN @TblGroupCode_SP0080_ITEM_ACTIVE IA ON
                    A.DIVISION_ID = IA.DIVISION_ID
                AND A.ITEM_ID     = IA.ITEM_ID
		    LEFT JOIN @TblGroupCode_SP0080_BOM_PACK BP ON
                    A.ITEM_ID = BP.ITEM_ID
		    LEFT JOIN @TblGroupCode_SP0080_BOM_CELL BC ON
                    A.ITEM_ID = BC.ITEM_ID
    WHERE   1=1
        AND ((@p_check_fcst ='N')           OR A.FCST_YN = @p_check_fcst)
        AND ((@p_check_production = 'N')    OR (@p_check_production = 'Y'   AND P.ITEM_ID IS NOT NULL))
        AND ((@p_check_bom = 'N')           OR (@p_check_bom = 'Y'          AND A.OPERATION_GROUP = 'P' AND BP.ITEM_ID IS NOT NULL)
                                            OR (@p_check_bom = 'Y'          AND A.OPERATION_GROUP = 'A' AND BC.ITEM_ID IS NOT NULL))
        AND ((@p_check_active = 'N')        OR (@p_check_active = 'Y'       AND IIF(IA.ACTIVE_FLAG IS NULL, 'N', IA.ACTIVE_FLAG) = 'Y'))
    ORDER BY      DIVISION_ID
				, OPERATION_ID
				, ITEM_ID
				, NICK_NAME

--PRINT CONCAT('ELAPSED_TIME-@TBL_RES : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
--return;


----TESTING  : NOK
--select * from @TBL_RES;

    RETURN;
END
