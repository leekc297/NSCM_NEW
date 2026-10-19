---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0092_GET_RTF_ARCHEIVEMENT_RATE_SUMMARY
 * Description  : RTF 준수율 Summary 조회
 * Program History
 *===================================================================================================
 *  Date        In Charge       Description
 *===================================================================================================
* 2022/04/29    chaan		V1.7    Initial Release
* 2022.05.30	chaan       V1.91   Weekly 수정후 기준 변경
* 2022.06.08	chaan       V1.92   최대 조회기간을 현재 기준 전주까지로 제한
* 2022.06.09	chaan       V1.94   최신버전 조회 수정
* 2022.06.10	chaan       V1.95   최신버전 조회방식 수정
* 2022/06/17    chaan		V1.98   ISOYYYYMM 기준으로 주 로직 변경
*                                   파라미터 삭제(@p_scm_site_id, @p_plant_site_id)
* 2022/06/20    chaan		V1.99   MM->Cell 컬럼 pivot 수정
*                                   RTF_VS / RTF_GAP 제외
* 2022/06/23    chaan		V1.992  RTF With Result 및 Rate 계산방식 변경
* 2022/07/01    chaan		V1.1.1  Weekly 와 Summary  리포트 합계 수치 이상 수정
* 2022/07/04    chaan		V1.1.2  CATEGORY 대상 테이블 및 컬럼 변경 (SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT3 -> SCP_MST_FINAL_ITEM.GROUP_CODE5)
* 2022/07/15    chaan		V1.1.3  CATEGORY 미입력항목 '기타' 로 표기
                                    소계 정렬용 DISPLAY_SEQ 추가
* 2022/07/20    chaan		V1.1.4  사용자지정컬럼 기본 키 변경
* 2022/08/10    chaan		V1.1.5  DM기준 biz_type => operation_group 으로 변경
                                    RTF실적 -1Week/0Week 옵션화로 인한 파라미터 추가
* 2022/08/24    chaan		V1.1.6  W01 조회시 전년주 마지막주 Target 없으면 전년주 마지막 전전주로 조회
* 2022/08/30    chaan		V1.1.7  공통 - Operation Gorup = 'Cell' 일때, Cell Quantity NULL을 1로 대체
                                    소형 - PROJECT_CODE, PROJECT_NAME 삭제
                                    소형 - RTF 준수율 산출 로직 변경
                                           ~ 소형 : VMI = 'Y' AND Measure = 'VMI in Plan[R+P]'
                                           ~ ESS  : Measure = 'RTF[R+P]'
                                    소형/자동차 - OWNER(PIC) 로직 변경(Group Code Management 테이블로 변경)
* 2022/09/26    chaan		V1.1.8  소형/자동차 - PIC조회 변경
                                                - Owner 필터 수정(PIC)
                                                - Product Group 수정 (FORECAST_INFO_PRODUCT_GROUP -> SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT2, (weekly는 CELL_TYPE))
* 2022/09/26    chaan		V1.1.9  소형        - biz_type 이 opertaion_group 으로 변경되어 'ALL' 선택시 전극까지 조회되는 오류 수정
* 2022/10/24    chaan		V1.1.10 소형        - opertaion_group 에 따른 로직 변경
                                                  ~ Pack 일 때, 대상 데이터를 Shipment Plan FG 기준으로 변경
* 2022/11/09    chaan		V1.1.11 소형        - Weekly 수치와 검증
* 2022/11/24    chaan		V1.1.12 #TEMP_DM_MST_ITEM_SINGLE_V_RTF, #TEMP_DM_MST_ITEM_SINGLE_V_RESULT 오류 수정
* 2022/12/01    chaan		V1.1.13 소형        - 소형 & Pack & Cylinder 이면 Nickname 별로 합산(다음 컬럼 공란 처리)
                                                  ~ Model, Cell Model, Spec & Version, Cell Quantity
* 2022/12/05    chaan		V2.1.1  조회 방식을 집계후 리포트테이블 조회로 변경
* 2022/12/12    chaan		V2.1.2  자동차 - 소계용 Team 을 SCM Team 으로 변경
                                    - Result With RTF 오류 수정
                                    - RATE, RATE_CELL 산출시 소수이하 절삭 오류 수정
* 2022/12/15    chaan		V2.1.3  소형 - Sub1 소계용 PRODUCT_GROUP 을 DEPT_ID->CELL_TYPE 으로 변경
* 2022/12/15    chaan		V2.1.4  필터링 오류 수정

**************************************************************************************************
 */
 
--CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_SUMMARY]
 CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_SUMMARY]
      @p_division_id              NVARCHAR(30)
    , @p_category_code            NVARCHAR(MAX)
    , @p_year                     NVARCHAR(4)
	, @p_dept_id                  NVARCHAR(4000)
    , @p_end_customer             NVARCHAR(4000)
    , @p_project_code             NVARCHAR(4000)
	, @p_item_id                  NVARCHAR(4000)
	, @p_item_type                NVARCHAR(4000)
	, @p_created_by               NVARCHAR(4000)
	, @p_biz_type                 NVARCHAR(4000)
	, @p_fcst_type                NVARCHAR(4000)
	, @p_owner					  NVARCHAR(4000)
	, @p_user_dept_id			  NVARCHAR(50)	-- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
	, @p_group_id				  NVARCHAR(50)	-- JV Planner 일지 확인하기 위해 추가
 	 ,@p_is_pre_week			  NVARCHAR(50)      = N'T'	-- -1Week : 'T', 0Week : 'F'
AS  
BEGIN
    SET NOCOUNT ON;
    SET ANSI_NULLS ON
    SET ANSI_WARNINGS ON; 


 --   --DECLARE @p_division_id              NVARCHAR(30)        = N'';
 --   --DECLARE @p_division_id              NVARCHAR(30)        = N'82';
 --   --DECLARE @p_division_id              NVARCHAR(30)        = N'40';
 --   DECLARE @p_division_id              NVARCHAR(30)        = N'81';
 --   DECLARE @p_category_code            NVARCHAR(MAX)       = N'';
 --   DECLARE @p_year                     NVARCHAR(4)         = N'2022';
 --   DECLARE @p_dept_id                  NVARCHAR(4000)      = N'ALL';
 --   DECLARE @p_end_customer             NVARCHAR(4000)      = N'ALL';
 --   --DECLARE @p_end_customer             NVARCHAR(4000)      = N'HKMC';
 --   DECLARE @p_project_code             NVARCHAR(4000)      = N'';
 --   DECLARE @p_item_id                  NVARCHAR(4000)      = N'';
 --   DECLARE @p_item_type                NVARCHAR(4000)      = N'ALL';
 --   DECLARE @p_created_by               NVARCHAR(4000)      = N'iamarock';
 --   DECLARE @p_biz_type                 NVARCHAR(4000)      = N'ALL';
 --   --DECLARE @p_biz_type                 NVARCHAR(4000)      = N'P';
 --   DECLARE @p_fcst_type                NVARCHAR(4000)      = N'ASF';
 --   --DECLARE @p_fcst_type                NVARCHAR(4000)      = N'MPS';
 --   DECLARE @p_owner					NVARCHAR(4000)      = N'';
 --   DECLARE @p_user_dept_id			    NVARCHAR(50)        = N'ICO';
 --   DECLARE @p_group_id				    NVARCHAR(50)        = N'ADMIN';
	--DECLARE @p_is_pre_week				NVARCHAR(50)	    = N'T';

print N'--버전정보 구함 begin-------------------------------------------------------------'
    DECLARE @p_program_id	            VARCHAR(50)         ='SCP0092'
    DECLARE @p_sheet_name               NVARCHAR(50)        = N'RTF Archeivement Rate Summary Report';

	IF OBJECT_ID(N'tempdb..#TEMP_SCP_RPT_RTF_ARC_RAW', N'U') IS NOT NULL
		DROP TABLE #TEMP_SCP_RPT_RTF_ARC_RAW;
    
    SELECT  *
    INTO    #TEMP_SCP_RPT_RTF_ARC_RAW
    FROM    SCP_RPT_RTF_ARC A
    WHERE   1=1
        AND (( @p_division_id	IS NULL OR @p_division_id	='') OR A.DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id	, ',')))
        AND SUBSTRING(A.ISO_YYYYMMWW, 1, 4) = @p_year
        AND A.IS_PRE_WEEK                   = @p_is_pre_week;
--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;


    
    IF @p_biz_type = 'ALL'
    BEGIN
        SET @p_biz_type = '';

        SELECT  @p_biz_type = @p_biz_type + B.SEGMENT1 + ','
        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
        WHERE   A.LOOKUP_TYPE = 'OPERATION_GROUP'
            AND A.VALID_YN = 'Y'
            AND B.VALID_YN = 'Y'
            AND B.SEGMENT1 IN ('P','A')
    END

    IF (RIGHT(@p_biz_type, 1) = ',')
    BEGIN
        SET @p_biz_type = LEFT(@p_biz_type, LEN(@p_biz_type)-1);
    END
   
    
print N'--버전정보 구함 end-------------------------------------------------------------'


    DECLARE @V_RESULT_VERSION_NO        NVARCHAR(8)         = 'CURRENT';

    DECLARE @V_COLUMNS_RAW		        NVARCHAR(MAX);
    DECLARE @V_COLUMNS_SUM		        NVARCHAR(MAX);
    DECLARE @V_ORDERS_RAW	            NVARCHAR(MAX);

    SET		@V_COLUMNS_RAW		= '';
    SET		@V_COLUMNS_SUM		= '';
    SET		@V_ORDERS_RAW		= '';


    DECLARE	@MEASURE	    INT	= 0;
    DECLARE	@i_count	    int	= 0;
	DECLARE @v_user_mea_cnt int =0;

	
print 'B--' + convert(varchar(30), getdate(), 121)

    /********************************************************************************
    * 임시테이블만들기 - MEASURE
    ********************************************************************************/
    IF Object_id('tempdb..#TBL_SCP0092_MEASURE') IS NOT NULL
	    DROP TABLE #TBL_SCP0092_MEASURE;

    DECLARE     @V_CNT_USR_MEASURE  INT                 = 0;
    DECLARE     @V_CNT_USR_COLUMN   INT                 = 0;


    SET @V_CNT_USR_MEASURE = (  SELECT  Count(1)
                                FROM    SCM_MST_TITLESET_USER WITH(NOLOCK)
                                WHERE   1 = 1
                                    AND PROGRAM_ID = @p_program_id
                                    AND SHEET_NAME = @p_sheet_name
                                    AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                                    AND USER_ID = @p_created_by);
    SET @V_CNT_USR_COLUMN = (   SELECT  Count(1)
                                FROM    SCM_MST_TITLESET_USER WITH(NOLOCK)
                                WHERE   1 = 1
                                    AND PROGRAM_ID = @p_program_id
                                    AND SHEET_NAME = @p_sheet_name
                                    AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                                    AND USER_ID = @p_created_by);

    SELECT  A.COLUMN_NAME AS MEASURE,
            A.COLUMN_LABEL_NAME AS MEASURE_NAME,
            ISNULL(B.SORT_ORDER_NO, A.SORT_ORDER_NO ) AS USER_SORT_ORDER_NO
    INTO    #TBL_SCP0092_MEASURE
    FROM    SCM_MST_SHEET_MEASURE A WITH(NOLOCK)
            LEFT JOIN SCM_MST_TITLESET_USER B WITH(NOLOCK) ON
                B.PROGRAM_ID = A.PROGRAM_ID
            AND B.SHEET_NAME = A.SHEET_NAME
            AND B.COLUMN_NAME = A.COLUMN_NAME
            AND B.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
            AND B.USER_ID = @p_created_by
    WHERE       A.PROGRAM_ID = @p_program_id
            AND A.SHEET_NAME = @p_sheet_name
            AND A.VALID_YN = 'Y'
            AND
                (
                    @V_CNT_USR_MEASURE = 0
                    OR EXISTS
                        (
                            SELECT  1
                            FROM    SCM_MST_TITLESET_USER WITH(NOLOCK)
                            WHERE   PROGRAM_ID = @p_program_id
                                    AND SHEET_NAME = @p_sheet_name
                                    AND COLUMN_NAME = A.COLUMN_NAME
                                    AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                                    AND USER_ID = @p_created_by
                        )
                ) ;

    --select * from #TBL_SCP0092_MEASURE;return;

    IF OBJECT_ID (N'tempdb..#TBL_CATEGORY', N'U') IS NOT NULL 
		DROP TABLE #TBL_CATEGORY


    SELECT DISTINCT
              A.DIVISION_ID
		    , LK2.SEGMENT2
		    , LK2.SEGMENT3
            , LK2.DISPLAY_SEQ
    INTO    #TBL_CATEGORY
    FROM	DM_PLN_MKT_FCST A
		    LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON
				    A.PROJECT_CODE  = LK1.SEGMENT1
			    AND LK1.LOOKUP_TYPE = 'DM_ITEM_USE_EX'
		    LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON
				    A.DIVISION_ID = LK2.SEGMENT1
			    AND ISNULL(LK1.SEGMENT2, LEFT(A.PROJECT_CODE, 1)) = LK2.SEGMENT2
                AND LK2.LOOKUP_TYPE = 'DM_ITEM_USE'
    WHERE	A.MEASURE = 'RTF_SYS_RP'
        AND LK2.VALID_YN = 'Y'
    ORDER BY DISPLAY_SEQ
--select * from #TBL_CATEGORY;return;

    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_CATEGORY', N'U') IS NOT NULL 
		DROP TABLE #TBL_SCP0092_CATEGORY

    SELECT    A.DIVISION_ID
	        , A.ITEM_ID
	        , A.GROUP_CODE5                                                       AS CATEGORY_CODE
	        , ISNULL(B.SEGMENT3, N'기타')                                         AS CATEGORY_NAME
            , IIF(B.SEGMENT3 IS NULL OR B.DISPLAY_SEQ IS NULL, 9, B.DISPLAY_SEQ)  AS DISPLAY_SEQ
    INTO    #TBL_SCP0092_CATEGORY
    FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
            LEFT JOIN #TBL_CATEGORY B ON
                    A.DIVISION_ID = B.DIVISION_ID
                AND A.GROUP_CODE5 = B.SEGMENT3
    WHERE   A.OPERATION_GROUP IN ('A', 'P')
        AND (( @p_division_id	IS NULL OR @p_division_id	='') OR A.DIVISION_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id	, ',')))
        AND (
                   (@p_item_id IS NULL OR @p_item_id = '') 
                OR (A.ITEM_ID   IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id, ',')))
                --OR (A.NICK_NAME IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id, ',')))
            )
--select * from #TBL_SCP0092_CATEGORY;return;

    IF OBJECT_ID (N'tempdb..#T_VERSION', N'U') IS NOT NULL 
		DROP TABLE #T_VERSION

	CREATE TABLE #T_VERSION
    (
		  VERSION_NO	NVARCHAR(50)
		, DIVISION_ID	NVARCHAR(30)
		, THIS_MONDAY	NVARCHAR(8)
    )

	INSERT INTO #T_VERSION 
    (
          VERSION_NO
        , DIVISION_iD
        , THIS_MONDAY
    )
        SELECT    MAX(V.VERSION_NO) AS VERSION_NO
                , V.DIVISION_ID
                , CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(V.YYYYMMDD, 'MON')), 112)
        FROM    DM_MST_VERSION V
                JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON  
                    V.YYYYMMDD = C.BASIS_YYYYMMDD
        WHERE   1=1
                AND V.VERSION_TYPE = 'MF_W'
                AND ((@p_division_id IS NULL OR @p_division_id = '') OR V.DIVISION_ID = @p_division_id)
                AND SUBSTRING(V.YYYYMMDD, 1, 4) = @p_year
        GROUP BY    V.DIVISION_ID
                  , CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(V.YYYYMMDD, 'MON')), 112)
        ORDER BY  V.DIVISION_ID, VERSION_NO;

--select * from #T_VERSION;return;

	SELECT @v_user_mea_cnt = COUNT(*)
		FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
			WHERE  1 = 1
			AND    U.PROGRAM_ID						= @p_program_id
			AND    U.SHEET_NAME						= @p_sheet_name
			AND    U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
			AND    U.USER_ID						= @p_created_by;
--print @v_user_mea_cnt;return;

	IF @v_user_mea_cnt = 0
	BEGIN	    
		INSERT INTO [dbo].[SCM_MST_TITLESET_USER]
		( USER_ID
		, PROGRAM_ID
		, SHEET_NAME
		, USER_INQUIRY_COLUMN_TYPE_CODE
		, COLUMN_NAME
		, SORT_ORDER_NO
		, SUB_TOTAL_FLAG
		, DATA_SORT_METHOD_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE
		)
		SELECT @p_created_by
		     , C.PROGRAM_ID
			 , C.SHEET_NAME
			 , 'M'
			 , C.COLUMN_NAME
			 , C.SORT_ORDER_NO
			 , 'N'
			 , ''
			 , @p_created_by
			 , CONVERT(varchar(19), GETDATE(), 121)
			 , @p_created_by
			 , CONVERT(varchar(19), GETDATE(), 121)
		FROM   [dbo].[SCM_MST_SHEET_MEASURE] C WITH(NOLOCK)
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = @p_sheet_name
		AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'	;
	END;

--select * from #SELECT_MEASURE order by sort_order_no;return;
--TESTING : Raw 데이터


	IF OBJECT_ID (N'tempdb..#WHERE_MEASURE', N'U') IS NOT NULL 
		DROP TABLE #WHERE_MEASURE;

	CREATE TABLE #WHERE_MEASURE
    (
          TOKEN             NVARCHAR(MAX) 
    )

    INSERT INTO #WHERE_MEASURE
        SELECT  TOKEN
        FROM    DBO.STRING_SPLIT('VMI_In_Plan', ',')

    INSERT INTO #WHERE_MEASURE
        SELECT  TOKEN
        FROM    DBO.STRING_SPLIT('RTF_SYS_RP', ',')

	IF OBJECT_ID (N'tempdb..#TEMP_OPERATION_GROUP', N'U') IS NOT NULL
		DROP TABLE #TEMP_OPERATION_GROUP;
    
    SELECT    A.ITEM_ID
            , G.CODE AS GROUP_CODE
            , G.NAME AS GROUP_NAME 
    INTO    #TEMP_OPERATION_GROUP
    FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
            JOIN
                (
                    SELECT   B.SEGMENT1 CODE
                            ,B.SEGMENT2 NAME
                    FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON
                                    A.LOOKUP_TYPE = B.LOOKUP_TYPE
                    WHERE   A.LOOKUP_TYPE = 'OPERATION_GROUP'
                        AND A.VALID_YN = 'Y'
                        AND B.VALID_YN = 'Y'
                        AND B.SEGMENT1 IN ('P','A')
                ) G ON
                    A.OPERATION_GROUP = G.CODE;

	IF OBJECT_ID (N'tempdb..#TEMP_CELL_MODEL', N'U') IS NOT NULL 
		DROP TABLE #TEMP_CELL_MODEL;

    SELECT    A.DIVISION_ID
	        , A.FLOW_ID AS OPERATION_ID
	        , A.ITEM_ID
	        , A.NICK_NAME
	        , CASE 
		        WHEN A.OPERATION_GROUP = 'P' THEN (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)
		        ELSE '' 
              END AS BASIC_MODEL_PACK
	        , CASE 
		        WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)) 
		        ELSE ''
              END AS BASIC_NICKNAME_PACK
	        , CASE 
		        WHEN A.OPERATION_GROUP = 'P' THEN A.ATTRIBUTE1 
		        ELSE ''
              END AS CELL_MODEL
	        , CASE 
		        WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1) 
		        ELSE ''
              END AS CELL_MODEL_NICKNAME
	        , CASE 
		        WHEN A.OPERATION_GROUP = 'P' THEN (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL) 
		        ELSE (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL) 
              END AS BASIC_MODEL_CELL
	        , CASE 
		        WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL)) 
		        ELSE (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)) 
              END AS BASIC_NICKNAME_CELL
	        , A.GROUP_CODE1
	        , A.GROUP_CODE2
	        , A.GROUP_CODE3
	        , A.GROUP_CODE4
	        , A.GROUP_CODE5
	        , ISNULL(A.FCST_YN, 'N') AS FCST_YN
            , A.OPERATION_GROUP
            , G.NAME AS OPERATION_GROUP_NAME
    INTO    #TEMP_CELL_MODEL
    FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
            LEFT JOIN
                        (
                            SELECT   B.SEGMENT1 CODE
                                    ,B.SEGMENT2 NAME
                            FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                                    INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON   
                                            A.LOOKUP_TYPE = B.LOOKUP_TYPE
                            WHERE   A.LOOKUP_TYPE = 'OPERATION_GROUP'
                                AND A.VALID_YN = 'Y'
                                AND B.VALID_YN = 'Y'
                                AND B.SEGMENT1 IN ('P','A')
                        ) G ON
                        A.OPERATION_GROUP = G.CODE
    WHERE   A.OPERATION_GROUP IN ('A', 'P')
        AND (( @p_division_id IS NULL OR @p_division_id	= '') OR A.DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id, ',')))
        AND (
                   (@p_item_id IS NULL OR @p_item_id = '') 
                OR (A.ITEM_ID   IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id, ',')))
                OR (A.NICK_NAME IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id, ',')))
            )

--select * from #TEMP_CELL_MODEL;return;

	IF OBJECT_ID (N'tempdb..#TEMP_MODELS', N'U') IS NOT NULL 
		DROP TABLE #TEMP_MODELS;

    SELECT DISTINCT
              DIVISION_ID
            , ITEM_ID
		    , BASIC_NICKNAME_CELL
            , OPERATION_GROUP
            , OPERATION_GROUP_NAME
            , GROUP_CODE2
    INTO    #TEMP_MODELS
    FROM    #TEMP_CELL_MODEL A


	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V_RTF', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V_RTF;

	SELECT    A.DIVISION_ID
            , A.ITEM_ID
            , A.ITEM_CLASS
			, A.ITEM_NAME
			, A.ITEM_CLASS_NAME
			, A.NICK_NAME
			, A.ITEM_TYPE
			, A.MIN_CAPACITY
			, A.FORECAST_INFO_BIZ_TYPE
			, A.FORECAST_INFO_CELL_PACK_COUNT
			, A.FORECAST_INFO_PRODUCT_GROUP
			, A.FORECAST_INFO_CELL_MODEL
			, A.FORECAST_INFO_SPEC
			, A.FORECAST_INFOR_VERSION
			, A.ENERGE
			, C.CELL_CF AS CELL_QUANTITY
			, A.MDM_PROJECT_NAME
			, A.CELL_TYPE
			, A.SCP_EXTRA_SPEC
	INTO    #TEMP_DM_MST_ITEM_SINGLE_V_RTF
	FROM    DM_MST_ITEM_SINGLE_V A
	        JOIN    (
                        SELECT DISTINCT 
                                  DIVISION_ID
                                , ITEM_ID 
                        FROM    #TEMP_SCP_RPT_RTF_ARC_RAW 
                    ) B ON 
                    A.DIVISION_ID = B.DIVISION_ID 
                AND A.ITEM_ID     = B.ITEM_ID
            LEFT JOIN SCP_MST_ITEM_CELL_CF C ON
                    A.ITEM_ID     = C.ITEM_ID
                AND A.ITEM_TYPE   = C.CELL_TYPE
                AND A.SPEC        = C.ITEM_SPEC
    WHERE   ((@p_division_id IS NULL OR @p_division_id = '') OR A.DIVISION_ID = @p_division_id)
--select * from #TEMP_DM_MST_ITEM_SINGLE_V_RTF;return;
	
		
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM_RTF', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM_RTF;

	SELECT    A.DIVISION_ID
            , A.PROJECT_CODE
            , A.SCM_SITE_ID
            , A.ITEM_ID
	        , A.APPLICATION
            , A.CUST_GROUP
			, A.ROUTE
			, A.CUST_GROUP_DTL
			, A.CELL_PER_CAR
			, A.CELL_PER_MODULE
			, A.SALES_COMPANY
			, A.ATTRIBUTE1
			, A.ATTRIBUTE2
			, A.ATTRIBUTE5
			, A.ATTRIBUTE7
			, A.ATTRIBUTE8
			, A.REPORT_GROUP6
			, IIF(A.DIVISION_ID IN ('40', '81'), O.OWNER,           A.OWNER) AS OWNER
			, IIF(A.DIVISION_ID IN ('40', '81'), O.OWNER_NAME_EN,   DBO.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'EN' )) AS OWNER_NAME
			, IIF(A.DIVISION_ID IN ('40', '81'), O.OWNER_NAME,      DBO.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'KO' )) AS OWNER_NAME_KO
			,(	SELECT SU.DEPT_ID  
				FROM   SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
				WHERE  SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](A.owner, ',')) ) DEPT_ID
			, A.VALID_YN
	INTO    #TEMP_SCM_MST_SITE_ITEM_RTF
	FROM    SCM_MST_SITE_ITEM A WITH(NOLOCK)
	        JOIN ( SELECT DISTINCT 
                            DIVISION_ID
                          , SCM_SITE_ID
                          , PROJECT_CODE
                          , ITEM_ID 
                   FROM     #TEMP_SCP_RPT_RTF_ARC_RAW 
                 ) B ON
                    A.DIVISION_ID  = B.DIVISION_ID 
                AND A.SCM_SITE_ID  = B.SCM_SITE_ID 
                AND A.PROJECT_CODE = B.PROJECT_CODE 
                AND A.ITEM_ID      = B.ITEM_ID
            LEFT JOIN 
                (
                    SELECT    F.DIVISION_ID
                            , F.ITEM_ID
                            , F.ATTRIBUTE6     AS OWNER
                            , U.USER_NAME      AS OWNER_NAME
                            , U.USER_NAME_EN   AS OWNER_NAME_EN
                    FROM    SCP_MST_FINAL_ITEM F
                            LEFT JOIN SCM_MST_SSO_USER_INFO U WITH(NOLOCK) ON
                                    F.ATTRIBUTE6 = U.USER_ID
                ) O ON
                    A.DIVISION_ID = O.DIVISION_ID
                AND A.ITEM_ID     = O.ITEM_ID
    WHERE   ((@p_division_id IS NULL OR @p_division_id = '') OR A.DIVISION_ID = @p_division_id)


	IF OBJECT_ID (N'tempdb..#TEMP_PIC', N'U') IS NOT NULL
		DROP TABLE #TEMP_PIC;

	SELECT DISTINCT
              F.DIVISION_ID
            , F.ITEM_ID
            , U.USER_ID
			, U.USER_NAME
			, U.USER_NAME_EN
			, U.DEPT_ID
			, D.DEPT_NAME_KO
			, U.COMPANY_ID
			, U.WORKING_CODE
			, U.WORKING_NAME
			, U.SSO_LOCATE
    INTO    #TEMP_PIC
	FROM    SCP_MST_FINAL_ITEM F WITH(NOLOCK)
			JOIN SCM_MST_SSO_USER_INFO U WITH(NOLOCK) ON
					F.ATTRIBUTE6 = U.USER_ID
			JOIN SCM_MST_SSO_DEPT_INFO D WITH(NOLOCK) ON
					U.DEPT_ID = D.DEPT_ID
	WHERE	1=1
        AND F.DIVISION_ID = @p_division_id
--TESTING : OK
--select * from #TEMP_PIC;return;

--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;

	--------------------------------------------------------------------------------------------------------------------------------------------
	-- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 )
	--------------------------------------------------------------------------------------------------------------------------------------------
	BEGIN -- 필터링 시작
		IF (@p_project_code <> '') -- 소형은 UI 에서 PROJECT DISABLE 됨
		BEGIN
			DELETE  A
			FROM    #TEMP_SCP_RPT_RTF_ARC_RAW A
			        LEFT JOIN (SELECT DISTINCT token FROM dbo.String_Split(@p_project_code,',')) C	ON 
                            A.PROJECT_CODE LIKE '%' + C.TOKEN + '%'
			        LEFT JOIN (SELECT DISTINCT token FROM dbo.String_Split(@p_project_code,',')) D	ON 
                            A.PROJECT_NAME LIKE '%' + D.TOKEN + '%'
			WHERE   C.TOKEN IS NULL 
                AND D.TOKEN IS NULL
                AND A.ITEM_ID <> ''-- 소형&Pack&Cyl은 NICKNAME 기준으로 합치기위해 ITEM_ID 가 공란처리되어 있으므로 공란 ITEM_ID 는 필터대상에서 제외
		END
--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;

		IF (@p_item_id <> '')
		BEGIN
			DELETE  A
			FROM    #TEMP_SCP_RPT_RTF_ARC_RAW A
			        LEFT JOIN (SELECT DISTINCT token FROM dbo.String_Split(@p_item_id,',')) C ON 
                            A.ITEM_ID LIKE '%' + C.TOKEN + '%'
			        LEFT JOIN (SELECT DISTINCT token FROM dbo.String_Split(@p_item_id,',')) D ON 
                            A.NICK_NAME LIKE '%' + D.TOKEN + '%'
			WHERE   C.TOKEN IS NULL  
                AND D.TOKEN IS NULL
                AND A.ITEM_ID <> ''-- 소형&Pack&Cyl은 NICKNAME 기준으로 합치기위해 ITEM_ID 가 공란처리되어 있으므로 공란 ITEM_ID 는 필터대상에서 제외
		END
--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;

		IF (@p_owner <> '')
		BEGIN
            IF @p_division_id IN ('81', '40')
            BEGIN
				DELETE  A
				FROM    #TEMP_SCP_RPT_RTF_ARC_RAW A
                        LEFT JOIN #TEMP_PIC B WITH(NOLOCK) ON 
                                A.DIVISION_ID = B.DIVISION_ID	AND A.ITEM_ID = B.ITEM_ID
					    LEFT JOIN (	SELECT DISTINCT token
										    FROM dbo.String_Split(@p_owner,',')
									    ) C	ON B.USER_ID LIKE '%' + C.TOKEN + '%'
					    LEFT JOIN (	SELECT DISTINCT token
										    FROM dbo.String_Split(@p_owner,',')
									    ) D	ON B.USER_NAME LIKE '%' + D.TOKEN + '%'
					    LEFT JOIN (	SELECT DISTINCT token
										    FROM dbo.String_Split(@p_owner,',')
									    ) E	ON B.USER_NAME_EN LIKE '%' + E.TOKEN + '%'
				WHERE   C.TOKEN IS NULL  
                    AND D.TOKEN IS NULL  
                    AND E.TOKEN IS NULL
                    AND A.ITEM_ID <> ''-- 소형&Pack&Cyl은 NICKNAME 기준으로 합치기위해 ITEM_ID 가 공란처리되어 있으므로 공란 ITEM_ID 는 필터대상에서 제외
    		END
		END
--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;

		IF (@p_dept_id <> 'ALL')
		BEGIN
				DELETE  A
				FROM    #TEMP_SCP_RPT_RTF_ARC_RAW A
				        LEFT JOIN (SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id,',')) C ON
                                A.DEPT_ID = C.TOKEN
				WHERE   C.TOKEN IS NULL
                    AND A.ITEM_ID <> ''-- 소형&Pack&Cyl은 NICKNAME 기준으로 합치기위해 ITEM_ID 가 공란처리되어 있으므로 공란 ITEM_ID 는 필터대상에서 제외
		END
--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;

		IF (@p_end_customer <> 'ALL')
		BEGIN
			DELETE  A
			FROM    #TEMP_SCP_RPT_RTF_ARC_RAW A
				    LEFT JOIN (SELECT DISTINCT token FROM dbo.String_Split(@p_end_customer,',')) C ON
                            A.END_CUSTOMER = C.TOKEN
			WHERE   C.TOKEN IS NULL
                AND A.ITEM_ID <> ''-- 소형&Pack&Cyl은 NICKNAME 기준으로 합치기위해 ITEM_ID 가 공란처리되어 있으므로 공란 ITEM_ID 는 필터대상에서 제외
		END
--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;

		IF (@p_item_type <> 'ALL')
		BEGIN
			DELETE  A
			FROM    #TEMP_SCP_RPT_RTF_ARC_RAW A
			        LEFT JOIN #TEMP_DM_MST_ITEM_SINGLE_V_RTF B ON 
                            A.ITEM_ID = B.ITEM_ID
			        LEFT JOIN (SELECT DISTINCT token FROM dbo.String_Split(@p_item_type,',')) C ON
                            B.ITEM_TYPE = C.TOKEN
			WHERE   C.TOKEN IS NULL
                AND A.ITEM_ID <> ''-- 소형&Pack&Cyl은 NICKNAME 기준으로 합치기위해 ITEM_ID 가 공란처리되어 있으므로 공란 ITEM_ID 는 필터대상에서 제외
		END
                
--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;

		IF (@p_biz_type <> 'ALL')
		BEGIN
			DELETE  A
			FROM    #TEMP_SCP_RPT_RTF_ARC_RAW A
					LEFT JOIN (SELECT DISTINCT token FROM dbo.String_Split(@p_biz_type,',')) C ON 
                            A.OPERATION_GROUP = C.TOKEN
			WHERE   C.TOKEN IS NULL
                AND A.ITEM_ID <> ''-- 소형&Pack&Cyl은 NICKNAME 기준으로 합치기위해 ITEM_ID 가 공란처리되어 있으므로 공란 ITEM_ID 는 필터대상에서 제외
		END
--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;

		IF (@p_fcst_type <> 'ALL') AND (@p_fcst_type <> '') AND (@p_fcst_type IS NULL)
		BEGIN
			DELETE  A
			FROM    #TEMP_SCP_RPT_RTF_ARC_RAW A
			        LEFT JOIN (SELECT DISTINCT token FROM dbo.String_Split(@p_fcst_type,',')) C ON 
                            A.FCST_TYPE = C.TOKEN
			WHERE   C.TOKEN IS NULL
                AND A.ITEM_ID <> ''-- 소형&Pack&Cyl은 NICKNAME 기준으로 합치기위해 ITEM_ID 가 공란처리되어 있으므로 공란 ITEM_ID 는 필터대상에서 제외
		END
	END -- 필터링 끝
--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;

--=============================================================================================================================================================================
print N'==DEBUG Summary - WW - 시작============================================================================================================================================'
--=============================================================================================================================================================================
    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_WW', N'U') IS NOT NULL 
	    DROP TABLE #TBL_SCP0092_WW

	SELECT    A.DIVISION_ID
		    , A.ITEM_ID
		    , A.ITEM_NAME
            , A.NICK_NAME
		    , A.FCST_TYPE
            , ISNULL(A.OWNER, N'기타')                                                                        AS PIC                      -- 소계용-자동차/소형
            , A.APPLICATION
		    , A.CELL_TYPE
            , ISNULL(A.BASIC_NICKNAME_CELL,N'기타')                                                           AS BASIC_NICKNAME_CELL      -- 소계용-ESS
		    , A.FORECAST_INFO_CELL_MODEL
		    , A.FORECAST_INFO_ALL
            , A.END_CUSTOMER
            , A.PACK_GROUP
            , A.SCM_SITE_ID
		    , A.PROJECT_CODE
		    , A.PROJECT_NAME
            --, ISNULL(A.DEPT_ID, N'기타')                                                                      AS PRODUCT_GROUP            -- 소계용-소형
            , ISNULL(A.CELL_TYPE, N'기타')                                                                    AS PRODUCT_GROUP            -- 소계용-소형
		    --, A.TEAM_NAME_KO
		    , A.UPPER_DEPT_ID
            --, ISNULL(A.DEPT_NAME_KO, N'기타')                                                                 AS SCM_TEAM                 -- 소계용-자동차
            , ISNULL(A.TEAM_NAME_KO, N'기타')                                                                 AS SCM_TEAM                 -- 소계용-자동차
            , A.OPERATION_GROUP
		    , A.OPERATION_GROUP_NAME
            , ISNULL(A.CATEGORY_CODE, N'기타')                                                                AS CATEGORY_CODE            -- 소계용-ESS
            , ISNULL(A.CATEGORY_NAME, N'기타')                                                                AS CATEGORY_NAME            -- 소계용-ESS
            , SUBSTRING(A.ISO_YYYYMMWW, 1, 4)                                                                 AS YYYY
            , SUBSTRING(A.ISO_YYYYMMWW, 5, 2)                                                                 AS MM
            , SUBSTRING(A.ISO_YYYYMMWW, 1, 4) + SUBSTRING(A.ISO_YYYYMMWW, 7, 2)                               AS ISO_YYYYWW
            , Q.WEEK_NAME                                                                                     AS WEEK_NAME
            , A.CELL_QUANTITY
            , A.RTF
            , A.RTF_CELL
            , A.RESULT
            , A.RESULT_CELL
            , A.RESULT_WITH_RTF
            , A.RESULT_WITH_RTF_CELL
            , A.RATE
            , A.RATE_CELL
            , A.RTF_VS
            , A.RTF_GAP
            , IIF(A.DIVISION_ID = '82', ISNULL(T.DISPLAY_SEQ, 9), 1)                                          AS DISPLAY_SEQ              -- 소계정렬용
    INTO    #TBL_SCP0092_WW
	FROM    #TEMP_SCP_RPT_RTF_ARC_RAW A
		    JOIN 
                (
                    SELECT DISTINCT
                              ISO_YYYYWW
                            , ISO_YYYYMM + SUBSTRING(ISO_YYYYWW, 5, 2) AS ISO_YYYYMMWW
                            , WEEK_NAME
                    FROM    SCM_SYS_CALENDAR_M
                ) Q ON
                    A.ISO_YYYYMMWW = Q.ISO_YYYYMMWW
            LEFT JOIN #TBL_SCP0092_CATEGORY T WITH(NOLOCK) ON 
                    A.DIVISION_ID   = T.DIVISION_ID 
                AND A.ITEM_ID       = T.ITEM_ID
--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;
--select * from #TBL_SCP0092_WW where ISO_YYYYWW = '202227'
--order by 
--	          DIVISION_ID
--		    , ITEM_ID
--		    , ITEM_NAME
--            , NICK_NAME
--		    , FCST_TYPE
--            , PIC
--            , APPLICATION
--		    , CELL_TYPE
--            , BASIC_NICKNAME_CELL
--		    , FORECAST_INFO_CELL_MODEL
--		    , FORECAST_INFO_ALL
--            , END_CUSTOMER
--            , PACK_GROUP
--            , SCM_SITE_ID
--		    , PROJECT_CODE
--		    , PROJECT_NAME
--            , PRODUCT_GROUP
--		    , TEAM_NAME_KO
--		    , UPPER_DEPT_ID
--            , SCM_TEAM
--            , OPERATION_GROUP
--		    , OPERATION_GROUP_NAME
--            , CATEGORY_CODE
--            , CATEGORY_NAME
--            , YYYY
--            , MM
--            , ISO_YYYYWW
--            , WEEK_NAME
--            , CELL_QUANTITY
--            , RTF
--            , RTF_CELL
--            , RESULT
--            , RESULT_CELL
--            , RESULT_WITH_RTF
--            , RESULT_WITH_RTF_CELL
--            , RATE
--            , RATE_CELL
--            , RTF_VS
--            , RTF_GAP
--            , DISPLAY_SEQ;return;
    
--여기까지 Weekly & Summary 와 같은 로직 => #TBL_SCP0092_WW : 대상 기간만 다름, Weekly => 한주만, Summary => 1년치 -----------------------------------------------------------------------------------------------------------------------------------------

    IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_WW') IS NOT NULL
        DROP TABLE #TBL_SCP0092_RAW_WW;
    
    SELECT    DIVISION_ID
		    , CATEGORY_CODE           -- 소계용-ESS
		    , CATEGORY_NAME           -- 소계용-ESS
            , BASIC_NICKNAME_CELL     -- 소계용-ESS
            , PRODUCT_GROUP           -- 소계용-소형
            , SCM_TEAM                -- 소계용-자동차
            , PIC                     -- 소계용-자동차/소형
            , YYYY
            , MM
            , ISO_YYYYWW
            , WEEK_NAME
            , DISPLAY_SEQ
		    , SUM(RTF)                      AS RTF
            , SUM(RTF_CELL)                 AS RTF_CELL
		    , SUM(RESULT)                   AS RESULT
            , SUM(RESULT_CELL)              AS RESULT_CELL
            --, IIF(SUM(RTF)      <= SUM(RESULT),      SUM(RTF),      IIF(SUM(RESULT)      < 0, 0, SUM(RESULT)))          AS RESULT_WITH_RTF
            --, IIF(SUM(RTF_CELL) <= SUM(RESULT_CELL), SUM(RTF_CELL), IIF(SUM(RESULT_CELL) < 0, 0, SUM(RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		    , SUM(RESULT_WITH_RTF)          AS RESULT_WITH_RTF
            , SUM(RESULT_WITH_RTF_CELL)     AS RESULT_WITH_RTF_CELL
		    , SUM(RATE)                     AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            , SUM(RATE_CELL)                AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
    INTO	#TBL_SCP0092_RAW_WW
    FROM    #TBL_SCP0092_WW
        GROUP BY  DIVISION_ID
		        , CATEGORY_CODE           -- 소계용-ESS
		        , CATEGORY_NAME           -- 소계용-ESS
                , BASIC_NICKNAME_CELL     -- 소계용-ESS
                , PRODUCT_GROUP           -- 소계용-소형
                , SCM_TEAM                -- 소계용-자동차
                , PIC                     -- 소계용-자동차/소형
                , YYYY
                , MM
                , ISO_YYYYWW
                , WEEK_NAME
                , DISPLAY_SEQ;

--TESTING - OK
--select * from #TBL_SCP0092_RAW_WW where DIVISION_ID = '82' AND ISO_YYYYWW = '202244';return;

--=============================================================================================================================================================================
print N'==DEBUG Summary - 달력헤더 - 시작======================================================================================================================================'
--=============================================================================================================================================================================
    IF OBJECT_ID('tempdb..#TBL_SCP0092_WEEK_MONTH_INFO') IS NOT NULL
        DROP TABLE #TBL_SCP0092_WEEK_MONTH_INFO;

    SELECT    X.YYYY
            , X.MM
            , X.WEEK_NAME
    INTO    #TBL_SCP0092_WEEK_MONTH_INFO
    FROM
            (
                SELECT    SUBSTRING(A.ISO_YYYYMM, 1, 4)  AS YYYY
                        , SUBSTRING(A.ISO_YYYYMM, 5, 2)  AS MM
                        , WEEK_NAME
                        , MIN(A.BASIS_START_DATE) AS BASIS_START_DATE
                        , MAX(A.BASIS_END_DATE) AS BASIS_END_DATE
	            FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
	            --WHERE       A.ISO_YYYYMM >= @V_PRE_YYYYMM
             --           AND A.ISO_YYYYMM <= @V_POST_YYYYMM
	            WHERE     SUBSTRING(A.ISO_YYYYMM, 1, 4) = @p_year
                GROUP BY  SUBSTRING(A.ISO_YYYYMM, 1, 4)
                        , SUBSTRING(A.ISO_YYYYMM, 5, 2)
                        , WEEK_NAME
            ) X
    WHERE   X.YYYY = @p_year -- 전년도에 걸쳐있으면 전년도에 합산되므로 제외
    ORDER BY X.MM, X.WEEK_NAME;

    --select * from #TBL_SCP0092_WEEK_MONTH_INFO;
    --return;
    -- 실제 존재하는 데이터를 기준으로 날짜 목록을 만들경우 데이터가 없으면 오류 발생함!!!! end


    DECLARE @V_YYYY         NVARCHAR(4)  ='';
    DECLARE @V_BEFORE_MM    NVARCHAR(2)  ='';
    DECLARE @V_MM           NVARCHAR(2)  ='';
    DECLARE @V_WEEK_NAME    NVARCHAR(10) ='';
    DECLARE @FINAL_COLS     NVARCHAR(MAX) ='';

    DECLARE CUR_WEEK_MONTH_INFO CURSOR FOR
    SELECT    YYYY
            , MM
            , WEEK_NAME
    FROM    #TBL_SCP0092_WEEK_MONTH_INFO;

    OPEN CUR_WEEK_MONTH_INFO;

    FETCH NEXT FROM CUR_WEEK_MONTH_INFO INTO @V_YYYY, @V_MM, @V_WEEK_NAME

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @V_MM != @V_BEFORE_MM
        BEGIN
            SET @V_BEFORE_MM    = @V_MM
            SET @FINAL_COLS = @FINAL_COLS 
                                  + ', M.[' + @V_MM + '] AS [M_' + @V_YYYY + @V_MM + ']'
                                  + ', M.[' + @V_MM + '_CELL] AS [M_' + @V_YYYY + @V_MM + '_CELL]'
                                  + ', W.[' + @V_WEEK_NAME + '] AS [W_' + @V_YYYY + @V_MM + RIGHT(@V_WEEK_NAME, 2) + ']'
                                  + ', W.[' + @V_WEEK_NAME + '_CELL] AS [W_' + @V_YYYY + @V_MM + RIGHT(@V_WEEK_NAME, 2) + '_CELL]'
        END
        ELSE
        BEGIN
            SET @FINAL_COLS = @FINAL_COLS 
                                  + ', W.[' + @V_WEEK_NAME + '] AS [W_' + @V_YYYY + @V_MM + RIGHT(@V_WEEK_NAME, 2) + ']'
                                  + ', W.[' + @V_WEEK_NAME + '_CELL] AS [W_' + @V_YYYY + @V_MM + RIGHT(@V_WEEK_NAME, 2) + '_CELL]'
        END

        FETCH NEXT FROM CUR_WEEK_MONTH_INFO INTO @V_YYYY, @V_MM, @V_WEEK_NAME
    END;

    CLOSE CUR_WEEK_MONTH_INFO;
    DEALLOCATE CUR_WEEK_MONTH_INFO;
    --select * from #TBL_SCP0092_WEEK_MONTH_INFO;return;

--=============================================================================================================================================================================
print N'==DEBUG Summary TOP(DIVISION)-------------------------------------------------------------------------------------------------'
--=============================================================================================================================================================================
    IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_DIVISION_WW') IS NOT NULL
        DROP TABLE #TBL_SCP0092_RAW_DIVISION_WW;

    SELECT	  A.DIVISION_ID                 
            , A.DIVISION_ID                 AS CATEGORY_CODE
            , D.SEGMENT2                    AS CATEGORY_NAME
            , A.YYYY
            , A.MM
		    , A.ISO_YYYYWW
            , A.WEEK_NAME
		    , SUM(A.RTF)                    AS RTF
            , SUM(A.RTF_CELL)               AS RTF_CELL
		    , SUM(A.RESULT)                 AS RESULT
            , SUM(A.RESULT_CELL)            AS RESULT_CELL
            --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
            --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		    , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
            , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		    , SUM(RATE)                     AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            , SUM(RATE_CELL)                AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
    INTO    #TBL_SCP0092_RAW_DIVISION_WW
    FROM    #TBL_SCP0092_RAW_WW A
            LEFT JOIN
                (
                    SELECT    SEGMENT1
		                    , SEGMENT2
                    FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
                    WHERE LOOKUP_TYPE = 'DIVISION_GROUP'
                ) D ON
                A.DIVISION_ID = D.SEGMENT1
    GROUP BY      A.DIVISION_ID
                , D.SEGMENT2
                , A.YYYY
                , A.MM
                , A.ISO_YYYYWW
			    , A.WEEK_NAME;

    UPDATE #TBL_SCP0092_RAW_DIVISION_WW
    SET
          RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
        , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);



--TESTING - OK
--select * from #TBL_SCP0092_RAW_DIVISION_WW;return;

--=============================================================================================================================================================================
print N'==DEBUG Summary TOP(DIVISION)-MM-------------------------------------------------------------------------------------------------'
--=============================================================================================================================================================================
    IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_DIVISION_MM') IS NOT NULL
        DROP TABLE #TBL_SCP0092_RAW_DIVISION_MM;

    SELECT	  A.DIVISION_ID
            , A.CATEGORY_CODE
            , A.CATEGORY_NAME
            , A.YYYY
            , A.MM
		    , SUM(A.RTF)                    AS RTF
		    , SUM(A.RTF_CELL)               AS RTF_CELL
		    , SUM(A.RESULT)                 AS RESULT
		    , SUM(A.RESULT_CELL)            AS RESULT_CELL
            --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
            --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		    , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
            , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		    , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
    INTO    #TBL_SCP0092_RAW_DIVISION_MM
    FROM    #TBL_SCP0092_RAW_DIVISION_WW A
    GROUP BY      A.DIVISION_ID
                , A.CATEGORY_CODE
                , A.CATEGORY_NAME
                , A.YYYY
                , A.MM;
    
    UPDATE #TBL_SCP0092_RAW_DIVISION_MM
    SET
          RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
        , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);
--select * from #TBL_SCP0092_RAW_DIVISION_MM;return;

--=============================================================================================================================================================================
print N'==DEBUG Summary TOP(DIVISION)-YYYY-------------------------------------------------------------------------------------------------'
--=============================================================================================================================================================================
    IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_DIVISION_YYYY') IS NOT NULL
        DROP TABLE #TBL_SCP0092_RAW_DIVISION_YYYY;

    SELECT	  A.DIVISION_ID
            , A.CATEGORY_CODE
            , A.CATEGORY_NAME
            , A.YYYY
		    , SUM(A.RTF)                    AS RTF
		    , SUM(A.RTF_CELL)               AS RTF_CELL
		    , SUM(A.RESULT)                 AS RESULT
		    , SUM(A.RESULT_CELL)            AS RESULT_CELL
            --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
            --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		    , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
            , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		    , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
    INTO    #TBL_SCP0092_RAW_DIVISION_YYYY
    FROM    #TBL_SCP0092_RAW_DIVISION_MM A
    GROUP BY      A.DIVISION_ID
                , A.CATEGORY_CODE
                , A.CATEGORY_NAME
                , A.YYYY;
    
    UPDATE #TBL_SCP0092_RAW_DIVISION_YYYY
    SET
          RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
        , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);
	--TESTING : OK
--select * from #TBL_SCP0092_RAW_DIVISION_YYYY;
--select * from #TBL_SCP0092_RAW_DIVISION_MM;
--select * from #TBL_SCP0092_RAW_DIVISION_WW;return;

    DECLARE @WW_PIVOT_COLS        NVARCHAR(MAX)    = '';
    DECLARE @MM_PIVOT_COLS        NVARCHAR(MAX)    = '';
    DECLARE @YYYY_PIVOT_COLS      NVARCHAR(MAX)    = '';
                                  
    DECLARE @WW_COLS              NVARCHAR(MAX)    = '';
                                  
    DECLARE @SQL_DIVISION_WW      NVARCHAR(MAX)    = '';
    DECLARE @SQL_DIVISION_MM      NVARCHAR(MAX)    = '';
    DECLARE @SQL_DIVISION_YYYY    NVARCHAR(MAX)    = '';
    DECLARE @SQL_DIVISION_FINAL   NVARCHAR(MAX)    = '';
                                  
    DECLARE @SQL_CAR_SUB1_WW      NVARCHAR(MAX)    = '';
    DECLARE @SQL_CAR_SUB1_MM      NVARCHAR(MAX)    = '';
    DECLARE @SQL_CAR_SUB1_YYYY    NVARCHAR(MAX)    = '';
    DECLARE @SQL_CAR_SUB1_FINAL   NVARCHAR(MAX)    = '';
                                  
    DECLARE @SQL_CAR_SUB2_WW      NVARCHAR(MAX)    = '';
    DECLARE @SQL_CAR_SUB2_MM      NVARCHAR(MAX)    = '';
    DECLARE @SQL_CAR_SUB2_YYYY    NVARCHAR(MAX)    = '';
    DECLARE @SQL_CAR_SUB2_FINAL   NVARCHAR(MAX)    = '';
                                  
    DECLARE @SQL_ESS_SUB1_WW      NVARCHAR(MAX)    = '';
    DECLARE @SQL_ESS_SUB1_MM      NVARCHAR(MAX)    = '';
    DECLARE @SQL_ESS_SUB1_YYYY    NVARCHAR(MAX)    = '';
    DECLARE @SQL_ESS_SUB1_FINAL   NVARCHAR(MAX)    = '';
                                  
    DECLARE @SQL_ESS_SUB2_WW      NVARCHAR(MAX)    = '';
    DECLARE @SQL_ESS_SUB2_MM      NVARCHAR(MAX)    = '';
    DECLARE @SQL_ESS_SUB2_YYYY    NVARCHAR(MAX)    = '';
    DECLARE @SQL_ESS_SUB2_FINAL   NVARCHAR(MAX)    = '';

    DECLARE @SQL_SMALL_SUB1_WW    NVARCHAR(MAX)    = '';
    DECLARE @SQL_SMALL_SUB1_MM    NVARCHAR(MAX)    = '';
    DECLARE @SQL_SMALL_SUB1_YYYY  NVARCHAR(MAX)    = '';
    DECLARE @SQL_SMALL_SUB1_FINAL NVARCHAR(MAX)    = '';

    DECLARE @SQL_SMALL_SUB2_WW    NVARCHAR(MAX)    = '';
    DECLARE @SQL_SMALL_SUB2_MM    NVARCHAR(MAX)    = '';
    DECLARE @SQL_SMALL_SUB2_YYYY  NVARCHAR(MAX)    = '';
    DECLARE @SQL_SMALL_SUB2_FINAL NVARCHAR(MAX)    = '';

    --Get Date Columns--------------------------------------------------------------------------
    --Get Date Columns-WEEK-------------------------------------------------------------------------
    --SELECT  @WW_PIVOT_COLS = @WW_PIVOT_COLS + '[' + A.WEEK_NAME + '],'
    --FROM    (
    --            SELECT DISTINCT TOP 100 WEEK_NAME
    --            FROM    #TBL_SCP0092_RAW_WW A WITH(NOLOCK)
    --            ORDER BY WEEK_NAME
    --        ) A;

    SELECT  @WW_PIVOT_COLS = @WW_PIVOT_COLS + '[' + A.WEEK_NAME + '],'
    FROM    (
                SELECT DISTINCT TOP 100 WEEK_NAME
                FROM    #TBL_SCP0092_WEEK_MONTH_INFO A WITH(NOLOCK)
                ORDER BY WEEK_NAME
            ) A;

    --print '@WW_PIVOT_COLS   : ' + CHAR(10) + @WW_PIVOT_COLS;
    --return;

    IF (@WW_PIVOT_COLS != '')
    BEGIN
        SET @WW_PIVOT_COLS  = LEFT(@WW_PIVOT_COLS, LEN(@WW_PIVOT_COLS) - 1);
    END
    ELSE
    BEGIN
        SET @WW_PIVOT_COLS  =   '[W01],[W02],[W03],[W04],[W05],[W06],[W07],[W08],[W09],[W10],' +
                                '[W11],[W12],[W13],[W14],[W15],[W16],[W17],[W18],[W19],[W20],' +
                                '[W21],[W22],[W23],[W24],[W25],[W26],[W27],[W28],[W29],[W30],' +
                                '[W31],[W32],[W33],[W34],[W35],[W36],[W37],[W38],[W39],[W40],' +
                                '[W41],[W42],[W43],[W44],[W45],[W46],[W47],[W48],[W49],[W50],' +
                                '[W51],[W52],[W53]';
    END;

    --Get Date Columns-MONTH-------------------------------------------------------------------------
    --SELECT  @MM_PIVOT_COLS = @MM_PIVOT_COLS + '[' + A.MM + '],'
    --FROM    (
    --            SELECT DISTINCT MM
    --            FROM    #TBL_SCP0092_RAW_WW A WITH(NOLOCK)
    --        ) A;

    SELECT  @MM_PIVOT_COLS = @MM_PIVOT_COLS + '[' + A.MM + '],'
    FROM    (
                SELECT DISTINCT MM
                FROM    #TBL_SCP0092_WEEK_MONTH_INFO A WITH(NOLOCK)
            ) A;


    --PRINT @MM_PIVOT_COLS;
    IF (@MM_PIVOT_COLS != '')
    BEGIN
        SET @MM_PIVOT_COLS   = LEFT(@MM_PIVOT_COLS, LEN(@MM_PIVOT_COLS) - 1);
    END
    ELSE
    BEGIN
        SET @MM_PIVOT_COLS  =   '[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]';
    END;


    --Get Date Columns-YEAR-------------------------------------------------------------------------
    SET @YYYY_PIVOT_COLS = '[' + @p_year + ']';

    IF OBJECT_ID('tempdb..#TBL_SCP0092_PIVOT_DIVISION_WW') IS NOT NULL
        DROP TABLE #TBL_SCP0092_PIVOT_DIVISION_WW;

    CREATE TABLE #TBL_SCP0092_PIVOT_DIVISION_WW
    (
	    DIVISION_ID             NVARCHAR(50),
        CATEGORY_CODE           NVARCHAR(100),
        CATEGORY_NAME           NVARCHAR(100),
	    RPT_MEASURE             NVARCHAR(50),
	    W01                     NUMERIC(20,10),
	    W02                     NUMERIC(20,10),
	    W03                     NUMERIC(20,10),
	    W04                     NUMERIC(20,10),
	    W05                     NUMERIC(20,10),
	    W06                     NUMERIC(20,10),
	    W07                     NUMERIC(20,10),
	    W08                     NUMERIC(20,10),
	    W09                     NUMERIC(20,10),
	    W10                     NUMERIC(20,10),
	    W11                     NUMERIC(20,10),
	    W12                     NUMERIC(20,10),
	    W13                     NUMERIC(20,10),
	    W14                     NUMERIC(20,10),
	    W15                     NUMERIC(20,10),
	    W16                     NUMERIC(20,10),
	    W17                     NUMERIC(20,10),
	    W18                     NUMERIC(20,10),
	    W19                     NUMERIC(20,10),
	    W20                     NUMERIC(20,10),
	    W21                     NUMERIC(20,10),
	    W22                     NUMERIC(20,10),
	    W23                     NUMERIC(20,10),
	    W24                     NUMERIC(20,10),
	    W25                     NUMERIC(20,10),
	    W26                     NUMERIC(20,10),
	    W27                     NUMERIC(20,10),
	    W28                     NUMERIC(20,10),
	    W29                     NUMERIC(20,10),
	    W30                     NUMERIC(20,10),
	    W31                     NUMERIC(20,10),
	    W32                     NUMERIC(20,10),
	    W33                     NUMERIC(20,10),
	    W34                     NUMERIC(20,10),
	    W35                     NUMERIC(20,10),
	    W36                     NUMERIC(20,10),
	    W37                     NUMERIC(20,10),
	    W38                     NUMERIC(20,10),
	    W39                     NUMERIC(20,10),
	    W40                     NUMERIC(20,10),
	    W41                     NUMERIC(20,10),
	    W42                     NUMERIC(20,10),
	    W43                     NUMERIC(20,10),
	    W44                     NUMERIC(20,10),
	    W45                     NUMERIC(20,10),
	    W46                     NUMERIC(20,10),
	    W47                     NUMERIC(20,10),
	    W48                     NUMERIC(20,10),
	    W49                     NUMERIC(20,10),
	    W50                     NUMERIC(20,10),
	    W51                     NUMERIC(20,10),
	    W52                     NUMERIC(20,10),
	    W53                     NUMERIC(20,10),
	    W01_CELL                NUMERIC(20,10),
	    W02_CELL                NUMERIC(20,10),
	    W03_CELL                NUMERIC(20,10),
	    W04_CELL                NUMERIC(20,10),
	    W05_CELL                NUMERIC(20,10),
	    W06_CELL                NUMERIC(20,10),
	    W07_CELL                NUMERIC(20,10),
	    W08_CELL                NUMERIC(20,10),
	    W09_CELL                NUMERIC(20,10),
	    W10_CELL                NUMERIC(20,10),
	    W11_CELL                NUMERIC(20,10),
	    W12_CELL                NUMERIC(20,10),
	    W13_CELL                NUMERIC(20,10),
	    W14_CELL                NUMERIC(20,10),
	    W15_CELL                NUMERIC(20,10),
	    W16_CELL                NUMERIC(20,10),
	    W17_CELL                NUMERIC(20,10),
	    W18_CELL                NUMERIC(20,10),
	    W19_CELL                NUMERIC(20,10),
	    W20_CELL                NUMERIC(20,10),
	    W21_CELL                NUMERIC(20,10),
	    W22_CELL                NUMERIC(20,10),
	    W23_CELL                NUMERIC(20,10),
	    W24_CELL                NUMERIC(20,10),
	    W25_CELL                NUMERIC(20,10),
	    W26_CELL                NUMERIC(20,10),
	    W27_CELL                NUMERIC(20,10),
	    W28_CELL                NUMERIC(20,10),
	    W29_CELL                NUMERIC(20,10),
	    W30_CELL                NUMERIC(20,10),
	    W31_CELL                NUMERIC(20,10),
	    W32_CELL                NUMERIC(20,10),
	    W33_CELL                NUMERIC(20,10),
	    W34_CELL                NUMERIC(20,10),
	    W35_CELL                NUMERIC(20,10),
	    W36_CELL                NUMERIC(20,10),
	    W37_CELL                NUMERIC(20,10),
	    W38_CELL                NUMERIC(20,10),
	    W39_CELL                NUMERIC(20,10),
	    W40_CELL                NUMERIC(20,10),
	    W41_CELL                NUMERIC(20,10),
	    W42_CELL                NUMERIC(20,10),
	    W43_CELL                NUMERIC(20,10),
	    W44_CELL                NUMERIC(20,10),
	    W45_CELL                NUMERIC(20,10),
	    W46_CELL                NUMERIC(20,10),
	    W47_CELL                NUMERIC(20,10),
	    W48_CELL                NUMERIC(20,10),
	    W49_CELL                NUMERIC(20,10),
	    W50_CELL                NUMERIC(20,10),
	    W51_CELL                NUMERIC(20,10),
	    W52_CELL                NUMERIC(20,10),
	    W53_CELL                NUMERIC(20,10),
        DISPLAY_SEQ             INT,
	    USER_SORT_ORDER_NO      INT
    );


    --MONTH-----------------------------------------------------------------
    IF OBJECT_ID('tempdb..#TBL_SCP0092_PIVOT_DIVISION_MM') IS NOT NULL
        DROP TABLE #TBL_SCP0092_PIVOT_DIVISION_MM;

    CREATE TABLE #TBL_SCP0092_PIVOT_DIVISION_MM
    (
	    DIVISION_ID             NVARCHAR(50),
        CATEGORY_CODE           NVARCHAR(100),
        CATEGORY_NAME           NVARCHAR(100),
	    RPT_MEASURE             NVARCHAR(50),
	    [01]                    NUMERIC(20,10),
	    [02]                    NUMERIC(20,10),
	    [03]                    NUMERIC(20,10),
	    [04]                    NUMERIC(20,10),
	    [05]                    NUMERIC(20,10),
	    [06]                    NUMERIC(20,10),
	    [07]                    NUMERIC(20,10),
	    [08]                    NUMERIC(20,10),
	    [09]                    NUMERIC(20,10),
	    [10]                    NUMERIC(20,10),
	    [11]                    NUMERIC(20,10),
	    [12]                    NUMERIC(20,10),
	    [01_CELL]               NUMERIC(20,10),
	    [02_CELL]               NUMERIC(20,10),
	    [03_CELL]               NUMERIC(20,10),
	    [04_CELL]               NUMERIC(20,10),
	    [05_CELL]               NUMERIC(20,10),
	    [06_CELL]               NUMERIC(20,10),
	    [07_CELL]               NUMERIC(20,10),
	    [08_CELL]               NUMERIC(20,10),
	    [09_CELL]               NUMERIC(20,10),
	    [10_CELL]               NUMERIC(20,10),
	    [11_CELL]               NUMERIC(20,10),
	    [12_CELL]               NUMERIC(20,10),
    );

    --YEAR-----------------------------------------------------------------
    IF OBJECT_ID('tempdb..#TBL_SCP0092_PIVOT_DIVISION_YYYY') IS NOT NULL
        DROP TABLE #TBL_SCP0092_PIVOT_DIVISION_YYYY;

    CREATE TABLE #TBL_SCP0092_PIVOT_DIVISION_YYYY
    (
	    DIVISION_ID             NVARCHAR(50),
        CATEGORY_CODE           NVARCHAR(100),
        CATEGORY_NAME           NVARCHAR(100),
        YYYY                    NVARCHAR(4),
	    RPT_MEASURE             NVARCHAR(50),
	    [YEAR]                  NUMERIC(20,10),
	    [YEAR_CELL]             NUMERIC(20,10),
    );

    -- Pivot 테이블에 데이터가 들어가기 전에 빈테이블 복사------------------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#TBL_SCP0092_PIVOT_SUB1_WW') IS NOT NULL	
	    DROP TABLE #TBL_SCP0092_PIVOT_SUB1_WW;
    SELECT * INTO #TBL_SCP0092_PIVOT_SUB1_WW        FROM #TBL_SCP0092_PIVOT_DIVISION_WW;

    IF OBJECT_ID('tempdb..#TBL_SCP0092_PIVOT_SUB1_MM') IS NOT NULL	
	    DROP TABLE #TBL_SCP0092_PIVOT_SUB1_MM;
    SELECT * INTO #TBL_SCP0092_PIVOT_SUB1_MM        FROM #TBL_SCP0092_PIVOT_DIVISION_MM;

    IF OBJECT_ID('tempdb..#TBL_SCP0092_PIVOT_SUB1_YYYY') IS NOT NULL	
	    DROP TABLE #TBL_SCP0092_PIVOT_SUB1_YYYY;
    SELECT * INTO #TBL_SCP0092_PIVOT_SUB1_YYYY      FROM #TBL_SCP0092_PIVOT_DIVISION_YYYY;

    IF OBJECT_ID('tempdb..#TBL_SCP0092_PIVOT_SUB2_WW') IS NOT NULL	
	    DROP TABLE #TBL_SCP0092_PIVOT_SUB2_WW;
    SELECT * INTO #TBL_SCP0092_PIVOT_SUB2_WW        FROM #TBL_SCP0092_PIVOT_DIVISION_WW;

    IF OBJECT_ID('tempdb..#TBL_SCP0092_PIVOT_SUB2_MM') IS NOT NULL	
	    DROP TABLE #TBL_SCP0092_PIVOT_SUB2_MM;
    SELECT * INTO #TBL_SCP0092_PIVOT_SUB2_MM        FROM #TBL_SCP0092_PIVOT_DIVISION_MM;

    IF OBJECT_ID('tempdb..#TBL_SCP0092_PIVOT_SUB2_YYYY') IS NOT NULL	
	    DROP TABLE #TBL_SCP0092_PIVOT_SUB2_YYYY;
    SELECT * INTO #TBL_SCP0092_PIVOT_SUB2_YYYY      FROM #TBL_SCP0092_PIVOT_DIVISION_YYYY;

    --=============================================================================================================================================================================
    print N'==DEBUG Summary DIVISION TOTAL begin-------------------------------------------------------------------------------------------------'
    --=============================================================================================================================================================================
    EXEC SCP0092_GET_SQL_SUMMARY_PIVOT
              '#TBL_SCP0092_PIVOT_DIVISION'
            , '#TBL_SCP0092_RAW_DIVISION'
            , @WW_PIVOT_COLS
            , @MM_PIVOT_COLS
            , @YYYY_PIVOT_COLS
            , @FINAL_COLS
            , @SQL_DIVISION_WW OUTPUT
            , @SQL_DIVISION_MM OUTPUT  
            , @SQL_DIVISION_YYYY OUTPUT
            , @SQL_DIVISION_FINAL OUTPUT;
--select * from #TBL_SCP0092_RAW_DIVISION_WW;return;
    --EXEC DEBUG_LOG @SQL_DIVISION_WW, 'T';return;
    EXEC(@SQL_DIVISION_WW);

    --EXEC DEBUG_LOG @SQL_DIVISION_MM, 'T';
    EXEC(@SQL_DIVISION_MM)

    --EXEC DEBUG_LOG @SQL_DIVISION_YYYY, 'T';
    EXEC(@SQL_DIVISION_YYYY)

--exec debug_log @SQL_DIVISION_WW, 'T';
--exec debug_log @SQL_DIVISION_MM, 'T';
--exec debug_log @SQL_DIVISION_YYYY, 'T';
--exec debug_log @SQL_DIVISION_FINAL, 'T'; return;

--TESTING : OK
--select * from #TBL_SCP0092_RAW_DIVISION_WW;return;
--select * from #TBL_SCP0092_RAW_DIVISION_MM;


    --EXEC DEBUG_LOG @SQL_DIVISION_FINAL, 'T';return;
--select * from #TBL_SCP0092_PIVOT_DIVISION_WW;return;
    EXEC(@SQL_DIVISION_FINAL);
    --return;
    --=============================================================================================================================================================================
    print N'==DEBUG Summary DIVISION TOTAL end-------------------------------------------------------------------------------------------------'
    --=============================================================================================================================================================================

    IF @p_division_id != ''
    BEGIN
        IF @p_division_id = '81'
        BEGIN
            --=============================================================================================================================================================================
            print N'==DEBUG Summary 자동차-SUB1-WW-----------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_CAR_SUB1_WW') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_CAR_SUB1_WW;

            SELECT	  A.DIVISION_ID
                    , ''                            AS CATEGORY_CODE                   -- 소계용-자동차
                    , A.SCM_TEAM                    AS CATEGORY_NAME                   -- 소계용-자동차
                    , A.YYYY
                    , A.MM
		            , A.ISO_YYYYWW
                    , A.WEEK_NAME
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_CAR_SUB1_WW
            FROM    #TBL_SCP0092_RAW_WW A
            WHERE   ((@p_category_code IS NULL OR @p_category_code = '') OR A.SCM_TEAM = @p_category_code)
                --AND (A.RTF <> 0 OR A.RTF <> 0)
            GROUP BY      A.DIVISION_ID
                        , A.SCM_TEAM			                -- 소계용-자동차
                        , A.YYYY
                        , A.MM
                        , A.ISO_YYYYWW
			            , A.WEEK_NAME
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_CAR_SUB1_WW
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 자동차-SUB1-MM-----------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_CAR_SUB1_MM') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_CAR_SUB1_MM;

            SELECT	  A.DIVISION_ID
                    , A.CATEGORY_CODE                   -- 소계용-자동차
                    , A.CATEGORY_NAME                   -- 소계용-자동차
                    , A.YYYY
                    , A.MM
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_CAR_SUB1_MM
            FROM    #TBL_SCP0092_RAW_CAR_SUB1_WW A
            GROUP BY      A.DIVISION_ID
                        , A.CATEGORY_CODE			                -- 소계용-자동차
                        , A.CATEGORY_NAME			                -- 소계용-자동차
                        , A.YYYY
                        , A.MM
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_CAR_SUB1_MM
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 자동차-SUB1-YYYY-----------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_CAR_SUB1_YYYY') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_CAR_SUB1_YYYY;

            SELECT	  A.DIVISION_ID
                    , A.CATEGORY_CODE                              -- 소계용-자동차
                    , A.CATEGORY_NAME                              -- 소계용-자동차
                    , A.YYYY
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_CAR_SUB1_YYYY
            FROM    #TBL_SCP0092_RAW_CAR_SUB1_MM A
            GROUP BY      A.DIVISION_ID
                        , A.CATEGORY_CODE                           -- 소계용-자동차
                        , A.CATEGORY_NAME                           -- 소계용-자동차
                        , A.YYYY
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_CAR_SUB1_YYYY
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 자동차-SUB1-begin-----------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            EXEC SCP0092_GET_SQL_SUMMARY_PIVOT 
                      '#TBL_SCP0092_PIVOT_SUB1'
                    , '#TBL_SCP0092_RAW_CAR_SUB1'
                    , @WW_PIVOT_COLS
                    , @MM_PIVOT_COLS
                    , @YYYY_PIVOT_COLS
                    , @FINAL_COLS
                    , @SQL_CAR_SUB1_WW OUTPUT
                    , @SQL_CAR_SUB1_MM OUTPUT  
                    , @SQL_CAR_SUB1_YYYY OUTPUT
                    , @SQL_CAR_SUB1_FINAL OUTPUT;

		    --EXEC DEBUG_LOG @SQL_CAR_SUB1_WW, 'T';
            EXEC(@SQL_CAR_SUB1_WW)
            UPDATE #TBL_SCP0092_PIVOT_SUB1_WW SET DISPLAY_SEQ = 99 WHERE CATEGORY_NAME = N'기타';

		    --EXEC DEBUG_LOG @SQL_CAR_SUB1_MM, 'T';
            EXEC(@SQL_CAR_SUB1_MM)

		    --EXEC DEBUG_LOG @SQL_CAR_SUB1_YYYY, 'T';
            EXEC(@SQL_CAR_SUB1_YYYY)

		    --EXEC DEBUG_LOG @SQL_CAR_SUB1_FINAL, 'T';
            EXEC(@SQL_CAR_SUB1_FINAL);
            --=============================================================================================================================================================================
            print N'==DEBUG Summary 자동차-SUB1-end-----------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================


            --=============================================================================================================================================================================
            print N'==DEBUG Summary 자동차-SUB2-WW----------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_CAR_SUB2_WW') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_CAR_SUB2_WW;

            SELECT	  A.DIVISION_ID
                    , ''                                                                                                        AS CATEGORY_CODE                   -- 소계용-자동차
                    , A.PIC                                                                                                     AS CATEGORY_NAME                   -- 소계용-자동차/소형
                    , A.YYYY
                    , A.MM
		            , A.ISO_YYYYWW
                    , A.WEEK_NAME
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_CAR_SUB2_WW
            FROM    #TBL_SCP0092_RAW_WW A
            WHERE   ((@p_category_code IS NULL OR @p_category_code = '') OR A.SCM_TEAM = @p_category_code)
                --AND (A.RTF <> 0 OR A.RTF <> 0)
            GROUP BY      A.DIVISION_ID
                        , A.PIC				                -- 소계용-자동차/소형
                        , A.YYYY
                        , A.MM
		                , A.ISO_YYYYWW
                        , A.WEEK_NAME
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_CAR_SUB2_WW
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 자동차-SUB2-MM----------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_CAR_SUB2_MM') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_CAR_SUB2_MM;

            SELECT	  A.DIVISION_ID
                    , A.CATEGORY_CODE                              -- 소계용-자동차/소형
                    , A.CATEGORY_NAME                              -- 소계용-자동차/소형
                    , A.YYYY
                    , A.MM
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_CAR_SUB2_MM
            FROM    #TBL_SCP0092_RAW_CAR_SUB2_WW A
            GROUP BY      A.DIVISION_ID
                        , A.CATEGORY_CODE                              -- 소계용-자동차/소형
                        , A.CATEGORY_NAME                              -- 소계용-자동차/소형
                        , A.YYYY
                        , A.MM
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_CAR_SUB2_MM
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 자동차-SUB2-YYYY----------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_CAR_SUB2_YYYY') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_CAR_SUB2_YYYY;

            SELECT	  A.DIVISION_ID
                    , A.CATEGORY_CODE                              -- 소계용-자동차/소형
                    , A.CATEGORY_NAME                              -- 소계용-자동차/소형
                    , A.YYYY
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_CAR_SUB2_YYYY
            FROM    #TBL_SCP0092_RAW_CAR_SUB2_MM A
            GROUP BY      A.DIVISION_ID
                        , A.CATEGORY_CODE                              -- 소계용-자동차/소형
                        , A.CATEGORY_NAME                              -- 소계용-자동차/소형
                        , A.YYYY
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_CAR_SUB2_YYYY
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 자동차-SUB2-begin----------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            EXEC SCP0092_GET_SQL_SUMMARY_PIVOT 
                      '#TBL_SCP0092_PIVOT_SUB2'
                    , '#TBL_SCP0092_RAW_CAR_SUB2'
                    , @WW_PIVOT_COLS
                    , @MM_PIVOT_COLS
                    , @YYYY_PIVOT_COLS
                    , @FINAL_COLS
                    , @SQL_CAR_SUB2_WW OUTPUT
                    , @SQL_CAR_SUB2_MM OUTPUT  
                    , @SQL_CAR_SUB2_YYYY OUTPUT
                    , @SQL_CAR_SUB2_FINAL OUTPUT;

			--EXEC DEBUG_LOG @SQL_CAR_SUB2_WW, 'T';
            EXEC(@SQL_CAR_SUB2_WW)
            UPDATE #TBL_SCP0092_PIVOT_SUB2_WW SET DISPLAY_SEQ = 99 WHERE CATEGORY_NAME = N'기타';

            --EXEC DEBUG_LOG @SQL_CAR_SUB2_MM, 'T';
            EXEC(@SQL_CAR_SUB2_MM)

            --EXEC DEBUG_LOG @SQL_CAR_SUB2_YYYY, 'T';
            EXEC(@SQL_CAR_SUB2_YYYY)

            --EXEC DEBUG_LOG @SQL_CAR_SUB2_FINAL, 'T';
            EXEC(@SQL_CAR_SUB2_FINAL);
            --자동차-SUB2-end----------------------------------------------------------------------------------------------
        END

        --ESS-------------------------------------------------------------------------------------------------
        ELSE IF @p_division_id = '82'
        BEGIN
            --=============================================================================================================================================================================
            print N'==DEBUG Summary ESS-SUB1-WW--------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_ESS_SUB1_WW') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_ESS_SUB1_WW;

             SELECT	  A.DIVISION_ID
		            , A.CATEGORY_CODE                          -- 소계용-ESS
		            , A.CATEGORY_NAME                          -- 소계용-ESS
                    , A.YYYY
                    , A.MM
		            , A.ISO_YYYYWW
                    , A.WEEK_NAME
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_ESS_SUB1_WW
            FROM    #TBL_SCP0092_RAW_WW A
            WHERE   ((@p_category_code IS NULL OR @p_category_code = '') OR A.CATEGORY_CODE = @p_category_code)
                --AND (A.RTF <> 0 OR A.RTF <> 0)
            GROUP BY      A.DIVISION_ID
                        , A.CATEGORY_CODE		                -- 소계용-ESS
                        , A.CATEGORY_NAME		                -- 소계용-ESS
                        , A.YYYY
                        , A.MM
                        , A.ISO_YYYYWW
			            , A.WEEK_NAME
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_ESS_SUB1_WW
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);
--TESTING : OK
--select * from #TBL_SCP0092_RAW_WW where DIVISION_ID = '82' AND ISO_YYYYWW = '202245';
--select * from #TBL_SCP0092_RAW_ESS_SUB1_WW where WEEK_NAME = 'W45';return;
            --=============================================================================================================================================================================
            print N'==DEBUG Summary ESS-SUB1-MM--------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_ESS_SUB1_MM') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_ESS_SUB1_MM;

             SELECT	  A.DIVISION_ID
		            , A.CATEGORY_CODE
		            , A.CATEGORY_NAME
                    , A.YYYY
                    , A.MM
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_ESS_SUB1_MM
            FROM    #TBL_SCP0092_RAW_ESS_SUB1_WW A
            GROUP BY      A.DIVISION_ID
		                , A.CATEGORY_CODE
		                , A.CATEGORY_NAME
                        , A.YYYY
                        , A.MM
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_ESS_SUB1_MM
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary ESS-SUB1-YYYY--------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_ESS_SUB1_YYYY') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_ESS_SUB1_YYYY;

            SELECT	  A.DIVISION_ID
		            , A.CATEGORY_CODE
		            , A.CATEGORY_NAME
                    , A.YYYY
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_ESS_SUB1_YYYY
            FROM    #TBL_SCP0092_RAW_ESS_SUB1_MM A
            GROUP BY      A.DIVISION_ID
		                , A.CATEGORY_CODE
		                , A.CATEGORY_NAME
                        , A.YYYY
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_ESS_SUB1_YYYY
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

--select * from  #TBL_SCP0092_RAW_ESS_SUB1_YYYY;
--select * from  #TBL_SCP0092_RAW_ESS_SUB1_MM;
--select * from  #TBL_SCP0092_RAW_ESS_SUB1_WW;return;
            --=============================================================================================================================================================================
            print N'==DEBUG Summary ESS-SUB1-begin--------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            EXEC SCP0092_GET_SQL_SUMMARY_PIVOT 
                      '#TBL_SCP0092_PIVOT_SUB1'
                    , '#TBL_SCP0092_RAW_ESS_SUB1'
                    , @WW_PIVOT_COLS
                    , @MM_PIVOT_COLS
                    , @YYYY_PIVOT_COLS
                    , @FINAL_COLS
                    , @SQL_ESS_SUB1_WW OUTPUT
                    , @SQL_ESS_SUB1_MM OUTPUT  
                    , @SQL_ESS_SUB1_YYYY OUTPUT
                    , @SQL_ESS_SUB1_FINAL OUTPUT;

			--EXEC DEBUG_LOG @SQL_ESS_SUB1_WW, 'T';
            EXEC(@SQL_ESS_SUB1_WW)
            UPDATE #TBL_SCP0092_PIVOT_SUB1_WW SET DISPLAY_SEQ = 99 WHERE CATEGORY_NAME = N'기타';

            --EXEC DEBUG_LOG @SQL_ESS_SUB1_MM, 'T';
            EXEC(@SQL_ESS_SUB1_MM)

            --EXEC DEBUG_LOG @SQL_ESS_SUB1_YYYY, 'T';
            EXEC(@SQL_ESS_SUB1_YYYY)

            --EXEC DEBUG_LOG @SQL_ESS_SUB1_FINAL, 'T';
            EXEC(@SQL_ESS_SUB1_FINAL);--test
            --ESS-SUB1-end----------------------------------------------------------------------------------------------
            --=============================================================================================================================================================================
            print N'==DEBUG Summary ESS-SUB1-end--------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================

            --=============================================================================================================================================================================
            print N'==DEBUG Summary ESS-SUB2-WW--------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_ESS_SUB2_WW') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_ESS_SUB2_WW;

            SELECT	  A.DIVISION_ID
                    , ''                                                                                                                AS CATEGORY_CODE                   -- 소계용-ESS
                    , A.BASIC_NICKNAME_CELL                                                                                             AS CATEGORY_NAME                   -- 소계용-ESS
                    , A.YYYY
                    , A.MM
		            , A.ISO_YYYYWW
                    , A.WEEK_NAME
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_ESS_SUB2_WW
            FROM    #TBL_SCP0092_RAW_WW A
            WHERE   ((@p_category_code IS NULL OR @p_category_code = '') OR A.CATEGORY_CODE = @p_category_code)
                --AND (A.RTF <> 0 OR A.RTF <> 0)
            GROUP BY      A.DIVISION_ID
                        , A.BASIC_NICKNAME_CELL		-- 소계용-ESS
                        , A.YYYY
                        , A.MM
                        , A.ISO_YYYYWW
			            , A.WEEK_NAME
                        , A.DISPLAY_SEQ
--TESTING : OK
--select * from #TBL_SCP0092_RAW_WW where DIVISION_ID = '82' AND ISO_YYYYWW = '202245' AND BASIC_NICKNAME_CELL = 'JH3';return;-- AND ITEM_ID = 'EM048189P3BA';return;
--select * from #TBL_SCP0092_RAW_ESS_SUB2_WW where WEEK_NAME = 'W45' and CATEGORY_NAME = 'JH3';return;



            UPDATE #TBL_SCP0092_RAW_ESS_SUB2_WW
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary ESS-SUB2-MM--------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_ESS_SUB2_MM') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_ESS_SUB2_MM;

            SELECT	  A.DIVISION_ID
                    , A.CATEGORY_CODE                   -- 소계용-ESS
                    , A.CATEGORY_NAME                   -- 소계용-ESS
                    , A.YYYY
                    , A.MM
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_ESS_SUB2_MM
            FROM    #TBL_SCP0092_RAW_ESS_SUB2_WW A
            GROUP BY      A.DIVISION_ID
                        , A.CATEGORY_CODE                   -- 소계용-ESS
                        , A.CATEGORY_NAME                   -- 소계용-ESS
                        , A.YYYY
                        , A.MM
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_ESS_SUB2_MM
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary ESS-SUB2-YYYY--------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_ESS_SUB2_YYYY') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_ESS_SUB2_YYYY;

            SELECT	  A.DIVISION_ID
		            , A.CATEGORY_CODE
		            , A.CATEGORY_NAME
                    , A.YYYY
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_ESS_SUB2_YYYY
            FROM    #TBL_SCP0092_RAW_ESS_SUB2_MM A
            GROUP BY      A.DIVISION_ID
		                , A.CATEGORY_CODE
		                , A.CATEGORY_NAME
                        , A.YYYY
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_ESS_SUB2_YYYY
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary ESS-SUB2-begin--------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================

            PRINT '@WW_PIVOT_COLS : ' + @WW_PIVOT_COLS;
            PRINT '@MM_PIVOT_COLS : ' + @MM_PIVOT_COLS;
            PRINT '@YYYY_PIVOT_COLS : ' + @YYYY_PIVOT_COLS;
            PRINT '@FINAL_COLS : ' + @FINAL_COLS;

            EXEC SCP0092_GET_SQL_SUMMARY_PIVOT 
                      '#TBL_SCP0092_PIVOT_SUB2'
                    , '#TBL_SCP0092_RAW_ESS_SUB2'
                    , @WW_PIVOT_COLS
                    , @MM_PIVOT_COLS
                    , @YYYY_PIVOT_COLS
                    , @FINAL_COLS
                    , @SQL_ESS_SUB2_WW OUTPUT
                    , @SQL_ESS_SUB2_MM OUTPUT  
                    , @SQL_ESS_SUB2_YYYY OUTPUT
                    , @SQL_ESS_SUB2_FINAL OUTPUT;

--TESTING : OK
			--EXEC DEBUG_LOG @SQL_ESS_SUB2_WW, 'T';return;
            EXEC(@SQL_ESS_SUB2_WW)
            UPDATE #TBL_SCP0092_PIVOT_SUB2_WW SET DISPLAY_SEQ = 99 WHERE CATEGORY_NAME = N'기타';
--TESTING : OK
--select * from #TBL_SCP0092_PIVOT_SUB2_WW;return;

            --EXEC DEBUG_LOG @SQL_ESS_SUB2_MM, 'T';
            EXEC(@SQL_ESS_SUB2_MM)

            --EXEC DEBUG_LOG @SQL_ESS_SUB2_YYYY, 'T';
            EXEC(@SQL_ESS_SUB2_YYYY)

            --EXEC DEBUG_LOG @SQL_ESS_SUB2_FINAL, 'T';
            EXEC(@SQL_ESS_SUB2_FINAL);
            --=============================================================================================================================================================================
            print N'==DEBUG Summary ESS-SUB2-end--------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
        END
        --소형-------------------------------------------------------------------------------------------------
        ELSE IF @p_division_id = '40'
        BEGIN
            --=============================================================================================================================================================================
            print N'==DEBUG Summary 소형-SUB1-WW------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_SMALL_SUB1_WW') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB1_WW;

            SELECT	  A.DIVISION_ID
                    , ''                            AS CATEGORY_CODE                   -- 소계용-소형
                    , A.PRODUCT_GROUP               AS CATEGORY_NAME                   -- 소계용-소형
                    , A.PRODUCT_GROUP                       
                    , A.YYYY
                    , A.MM
		            , A.ISO_YYYYWW
                    , A.WEEK_NAME
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_SMALL_SUB1_WW
            FROM    #TBL_SCP0092_RAW_WW A
            WHERE   ((@p_category_code IS NULL OR @p_category_code = '') OR A.PRODUCT_GROUP = @p_category_code)
                --AND (A.RTF <> 0 OR A.RTF <> 0)
            GROUP BY      A.DIVISION_ID
                        , A.PRODUCT_GROUP	                -- 소계용-소형
                        , A.YYYY
                        , A.MM
                        , A.ISO_YYYYWW
			            , A.WEEK_NAME
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_SMALL_SUB1_WW
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 소형-SUB1-MM-------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_SMALL_SUB1_MM') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB1_MM;

            SELECT	  A.DIVISION_ID
                    , A.CATEGORY_CODE                   -- 소계용-소형
                    , A.CATEGORY_NAME                   -- 소계용-소형
                    , A.YYYY
                    , A.MM
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_SMALL_SUB1_MM
            FROM    #TBL_SCP0092_RAW_SMALL_SUB1_WW A
            GROUP BY      A.DIVISION_ID
                        , A.CATEGORY_CODE                   -- 소계용-소형
                        , A.CATEGORY_NAME                   -- 소계용-소형
                        , A.YYYY
                        , A.MM
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_SMALL_SUB1_MM
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 소형-SUB1-YYYY-------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_SMALL_SUB1_YYYY') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB1_YYYY;

            SELECT	  A.DIVISION_ID
		            , A.CATEGORY_CODE                       -- 소계용-소형
		            , A.CATEGORY_NAME                       -- 소계용-소형
                    , A.YYYY
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_SMALL_SUB1_YYYY
            FROM    #TBL_SCP0092_RAW_SMALL_SUB1_MM A
            GROUP BY      A.DIVISION_ID
		                , A.CATEGORY_CODE                       -- 소계용-소형
		                , A.CATEGORY_NAME                       -- 소계용-소형
                        , A.YYYY
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_SMALL_SUB1_YYYY
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 소형-SUB1-begin-------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            EXEC SCP0092_GET_SQL_SUMMARY_PIVOT 
                      '#TBL_SCP0092_PIVOT_SUB1'
                    , '#TBL_SCP0092_RAW_SMALL_SUB1'
                    , @WW_PIVOT_COLS
                    , @MM_PIVOT_COLS
                    , @YYYY_PIVOT_COLS
                    , @FINAL_COLS
                    , @SQL_SMALL_SUB1_WW OUTPUT
                    , @SQL_SMALL_SUB1_MM OUTPUT  
                    , @SQL_SMALL_SUB1_YYYY OUTPUT
                    , @SQL_SMALL_SUB1_FINAL OUTPUT;

			--EXEC DEBUG_LOG @SQL_SMALL_SUB1_WW, 'T';
            EXEC(@SQL_SMALL_SUB1_WW)
            UPDATE #TBL_SCP0092_PIVOT_SUB1_WW SET DISPLAY_SEQ = 99 WHERE CATEGORY_NAME = N'기타';

            --EXEC DEBUG_LOG @SQL_SMALL_SUB1_MM, 'T';
            EXEC(@SQL_SMALL_SUB1_MM)

            --EXEC DEBUG_LOG @SQL_SMALL_SUB1_YYYY, 'T';
            EXEC(@SQL_SMALL_SUB1_YYYY)

            --EXEC DEBUG_LOG @SQL_SMALL_SUB1_FINAL, 'T';
            EXEC(@SQL_SMALL_SUB1_FINAL);
            --=============================================================================================================================================================================
            print N'==DEBUG Summary 소형-SUB1-end-------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 소형-SUB2-WW-----------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_SMALL_SUB2_WW') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB2_WW;

            SELECT	  A.DIVISION_ID
                    , ''                AS CATEGORY_CODE                   -- 소계용-소형
                    , A.PIC             AS CATEGORY_NAME                   -- 소계용-소형
                    , A.YYYY
                    , A.MM
		            , A.ISO_YYYYWW
                    , A.WEEK_NAME
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_SMALL_SUB2_WW
            FROM    #TBL_SCP0092_RAW_WW A
            WHERE   ((@p_category_code IS NULL OR @p_category_code = '') OR A.PRODUCT_GROUP = @p_category_code)
                --AND (A.RTF <> 0 OR A.RTF <> 0)
            GROUP BY      A.DIVISION_ID
                        , A.PIC 				                -- 소계용-자동차/소형
                        , A.YYYY
                        , A.MM
		                , A.ISO_YYYYWW
                        , A.WEEK_NAME
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_SMALL_SUB2_WW
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 소형-SUB2-MM------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_SMALL_SUB2_MM') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB2_MM;

            SELECT	  A.DIVISION_ID
                    , A.CATEGORY_CODE                   -- 소계용-소형
                    , A.CATEGORY_NAME                   -- 소계용-소형
                    , A.YYYY
                    , A.MM
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_SMALL_SUB2_MM
            FROM    #TBL_SCP0092_RAW_SMALL_SUB2_WW A
            GROUP BY      A.DIVISION_ID
                        , A.CATEGORY_CODE                   -- 소계용-소형
                        , A.CATEGORY_NAME                   -- 소계용-소형
                        , A.YYYY
                        , A.MM
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_SMALL_SUB2_MM
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 소형-SUB2-YYYY------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            IF OBJECT_ID('tempdb..#TBL_SCP0092_RAW_SMALL_SUB2_YYYY') IS NOT NULL
                DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB2_YYYY;

            SELECT	  A.DIVISION_ID
		            , A.CATEGORY_CODE                       -- 소계용-소형
		            , A.CATEGORY_NAME                       -- 소계용-소형
                    , A.YYYY
                    , A.DISPLAY_SEQ
		            , SUM(A.RTF)                    AS RTF
		            , SUM(A.RTF_CELL)               AS RTF_CELL
		            , SUM(A.RESULT)                 AS RESULT
		            , SUM(A.RESULT_CELL)            AS RESULT_CELL
                    --, IIF(SUM(A.RTF)      <= SUM(A.RESULT),      SUM(A.RTF),      IIF(SUM(A.RESULT)      < 0, 0, SUM(A.RESULT)))          AS RESULT_WITH_RTF
                    --, IIF(SUM(A.RTF_CELL) <= SUM(A.RESULT_CELL), SUM(A.RTF_CELL), IIF(SUM(A.RESULT_CELL) < 0, 0, SUM(A.RESULT_CELL)))     AS RESULT_WITH_RTF_CELL
		            , SUM(A.RESULT_WITH_RTF)        AS RESULT_WITH_RTF
                    , SUM(A.RESULT_WITH_RTF_CELL)   AS RESULT_WITH_RTF_CELL
		            , SUM(A.RATE)                   AS RATE         -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
                    , SUM(A.RATE_CELL)              AS RATE_CELL    -- 0 으로 초기화하지 마시오!! -> 나중에 Rate 산출시 소수이하 오차 발생 원인
            INTO    #TBL_SCP0092_RAW_SMALL_SUB2_YYYY
            FROM    #TBL_SCP0092_RAW_SMALL_SUB2_MM A
            GROUP BY      A.DIVISION_ID
                        , A.CATEGORY_CODE 		            -- 소계용-자동차/소형
                        , A.CATEGORY_NAME  	            -- 소계용-자동차/소형
                        , A.YYYY
                        , A.DISPLAY_SEQ

            UPDATE #TBL_SCP0092_RAW_SMALL_SUB2_YYYY
            SET
                  RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
                , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            --=============================================================================================================================================================================
            print N'==DEBUG Summary 소형-SUB2-begin------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
            EXEC SCP0092_GET_SQL_SUMMARY_PIVOT 
                      '#TBL_SCP0092_PIVOT_SUB2'
                    , '#TBL_SCP0092_RAW_SMALL_SUB2'
                    , @WW_PIVOT_COLS
                    , @MM_PIVOT_COLS
                    , @YYYY_PIVOT_COLS
                    , @FINAL_COLS
                    , @SQL_SMALL_SUB2_WW OUTPUT
                    , @SQL_SMALL_SUB2_MM OUTPUT  
                    , @SQL_SMALL_SUB2_YYYY OUTPUT
                    , @SQL_SMALL_SUB2_FINAL OUTPUT;

			--EXEC DEBUG_LOG @SQL_SMALL_SUB2_WW, 'T';return;
            EXEC(@SQL_SMALL_SUB2_WW)
            UPDATE #TBL_SCP0092_PIVOT_SUB2_WW SET DISPLAY_SEQ = 99 WHERE CATEGORY_NAME = N'기타';

            --select * from #TBL_SCP0092_PIVOT_SUB2_WW;return;

            --EXEC DEBUG_LOG @SQL_SMALL_SUB2_MM, 'T';
            EXEC(@SQL_SMALL_SUB2_MM)

            --EXEC DEBUG_LOG @SQL_SMALL_SUB2_YYYY, 'T';
            EXEC(@SQL_SMALL_SUB2_YYYY)

            --EXEC DEBUG_LOG @SQL_SMALL_SUB2_FINAL, 'T';return;
    --SELECT  X.*
    --FROM    (
    --            SELECT    W.DIVISION_ID
    --                    , D.DIVISION_NAME
    --                    , W.CATEGORY_CODE
    --                    , W.CATEGORY_NAME
    --                    , W.RPT_MEASURE
    --                    --, M.[01] AS [M_202201], M.[01_CELL] AS [M_202201_CELL], W.[W01] AS [W_20220101], W.[W01_CELL] AS [W_20220101_CELL], W.[W02] AS [W_20220102], W.[W02_CELL] AS [W_20220102_CELL], W.[W03] AS [W_20220103], W.[W03_CELL] AS [W_20220103_CELL], W.[W04] AS [W_20220104], W.[W04_CELL] AS [W_20220104_CELL], M.[02] AS [M_202202], M.[02_CELL] AS [M_202202_CELL], W.[W05] AS [W_20220205], W.[W05_CELL] AS [W_20220205_CELL], W.[W06] AS [W_20220206], W.[W06_CELL] AS [W_20220206_CELL], W.[W07] AS [W_20220207], W.[W07_CELL] AS [W_20220207_CELL], W.[W08] AS [W_20220208], W.[W08_CELL] AS [W_20220208_CELL], M.[03] AS [M_202203], M.[03_CELL] AS [M_202203_CELL], W.[W09] AS [W_20220309], W.[W09_CELL] AS [W_20220309_CELL], W.[W10] AS [W_20220310], W.[W10_CELL] AS [W_20220310_CELL], W.[W11] AS [W_20220311], W.[W11_CELL] AS [W_20220311_CELL], W.[W12] AS [W_20220312], W.[W12_CELL] AS [W_20220312_CELL], W.[W13] AS [W_20220313], W.[W13_CELL] AS [W_20220313_CELL], M.[04] AS [M_202204], M.[04_CELL] AS [M_202204_CELL], W.[W14] AS [W_20220414], W.[W14_CELL] AS [W_20220414_CELL], W.[W15] AS [W_20220415], W.[W15_CELL] AS [W_20220415_CELL], W.[W16] AS [W_20220416], W.[W16_CELL] AS [W_20220416_CELL], W.[W17] AS [W_20220417], W.[W17_CELL] AS [W_20220417_CELL], M.[05] AS [M_202205], M.[05_CELL] AS [M_202205_CELL], W.[W18] AS [W_20220518], W.[W18_CELL] AS [W_20220518_CELL], W.[W19] AS [W_20220519], W.[W19_CELL] AS [W_20220519_CELL], W.[W20] AS [W_20220520], W.[W20_CELL] AS [W_20220520_CELL], W.[W21] AS [W_20220521], W.[W21_CELL] AS [W_20220521_CELL], M.[06] AS [M_202206], M.[06_CELL] AS [M_202206_CELL], W.[W22] AS [W_20220622], W.[W22_CELL] AS [W_20220622_CELL], W.[W23] AS [W_20220623], W.[W23_CELL] AS [W_20220623_CELL], W.[W24] AS [W_20220624], W.[W24_CELL] AS [W_20220624_CELL], W.[W25] AS [W_20220625], W.[W25_CELL] AS [W_20220625_CELL], W.[W26] AS [W_20220626], W.[W26_CELL] AS [W_20220626_CELL], M.[07] AS [M_202207], M.[07_CELL] AS [M_202207_CELL], W.[W27] AS [W_20220727], W.[W27_CELL] AS [W_20220727_CELL], W.[W28] AS [W_20220728], W.[W28_CELL] AS [W_20220728_CELL], W.[W29] AS [W_20220729], W.[W29_CELL] AS [W_20220729_CELL], W.[W30] AS [W_20220730], W.[W30_CELL] AS [W_20220730_CELL], M.[08] AS [M_202208], M.[08_CELL] AS [M_202208_CELL], W.[W31] AS [W_20220831], W.[W31_CELL] AS [W_20220831_CELL], W.[W32] AS [W_20220832], W.[W32_CELL] AS [W_20220832_CELL], W.[W33] AS [W_20220833], W.[W33_CELL] AS [W_20220833_CELL], W.[W34] AS [W_20220834], W.[W34_CELL] AS [W_20220834_CELL], M.[09] AS [M_202209], M.[09_CELL] AS [M_202209_CELL], W.[W35] AS [W_20220935], W.[W35_CELL] AS [W_20220935_CELL], W.[W36] AS [W_20220936], W.[W36_CELL] AS [W_20220936_CELL], W.[W37] AS [W_20220937], W.[W37_CELL] AS [W_20220937_CELL], W.[W38] AS [W_20220938], W.[W38_CELL] AS [W_20220938_CELL], W.[W39] AS [W_20220939], W.[W39_CELL] AS [W_20220939_CELL], M.[10] AS [M_202210], M.[10_CELL] AS [M_202210_CELL], W.[W40] AS [W_20221040], W.[W40_CELL] AS [W_20221040_CELL], W.[W41] AS [W_20221041], W.[W41_CELL] AS [W_20221041_CELL], W.[W42] AS [W_20221042], W.[W42_CELL] AS [W_20221042_CELL], W.[W43] AS [W_20221043], W.[W43_CELL] AS [W_20221043_CELL], M.[11] AS [M_202211], M.[11_CELL] AS [M_202211_CELL], W.[W44] AS [W_20221144], W.[W44_CELL] AS [W_20221144_CELL], W.[W45] AS [W_20221145], W.[W45_CELL] AS [W_20221145_CELL], W.[W46] AS [W_20221146], W.[W46_CELL] AS [W_20221146_CELL], W.[W47] AS [W_20221147], W.[W47_CELL] AS [W_20221147_CELL], M.[12] AS [M_202212], M.[12_CELL] AS [M_202212_CELL], W.[W48] AS [W_20221248], W.[W48_CELL] AS [W_20221248_CELL], W.[W49] AS [W_20221249], W.[W49_CELL] AS [W_20221249_CELL], W.[W50] AS [W_20221250], W.[W50_CELL] AS [W_20221250_CELL], W.[W51] AS [W_20221251], W.[W51_CELL] AS [W_20221251_CELL], W.[W52] AS [W_20221252], W.[W52_CELL] AS [W_20221252_CELL]
    --                    --, W.DISPLAY_SEQ
    --                    , IIF(W.CATEGORY_NAME = N'기타', 99, W.DISPLAY_SEQ) AS DISPLAY_SEQ
    --                    , W.USER_SORT_ORDER_NO
    --                    , Y.[YEAR]
    --                    , Y.[YEAR_CELL]
    --            FROM    #TBL_SCP0092_PIVOT_SUB2_WW W
    --                    LEFT JOIN SCM_MST_DIVISION D ON
    --                            W.DIVISION_ID = D.DIVISION_ID
    --                    LEFT JOIN #TBL_SCP0092_PIVOT_SUB2_YYYY Y ON
    --                            W.DIVISION_ID = Y.DIVISION_ID
    --                        AND W.CATEGORY_CODE  = Y.CATEGORY_CODE
    --                        AND W.CATEGORY_NAME  = Y.CATEGORY_NAME
    --                        AND W.RPT_MEASURE = Y.RPT_MEASURE
    --                    LEFT JOIN #TBL_SCP0092_PIVOT_SUB2_MM M ON
    --                            W.DIVISION_ID = M.DIVISION_ID
    --                        AND W.CATEGORY_CODE  = M.CATEGORY_CODE
    --                        AND W.CATEGORY_NAME  = M.CATEGORY_NAME
    --                        AND W.RPT_MEASURE = M.RPT_MEASURE
    --        ) X
    --ORDER BY      X.DIVISION_ID
    --            , X.DISPLAY_SEQ
    --            , X.CATEGORY_NAME
    --            , X.USER_SORT_ORDER_NO;return;

            EXEC(@SQL_SMALL_SUB2_FINAL);

            
            --=============================================================================================================================================================================
            print N'==DEBUG Summary 소형-SUB2-end------------------------------------------------------------------------------------------'
            --=============================================================================================================================================================================
        END
    END

	------------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (BEGIN)
	------------------------------------------------------------------------------------------
		IF OBJECT_ID (N'tempdb..#RAW_RESULT_DAILY', N'U') IS NOT NULL
			DROP TABLE #RAW_RESULT_DAILY
		IF OBJECT_ID (N'tempdb..#TEMP_SCP_RPT_RTF_ARC_RAW', N'U') IS NOT NULL
			DROP TABLE #TEMP_SCP_RPT_RTF_ARC_RAW
		IF OBJECT_ID (N'tempdb..#WHERE_MEASURE', N'U') IS NOT NULL
			DROP TABLE #WHERE_MEASURE;
		IF OBJECT_ID (N'tempdb..#TBL_CATEGORY', N'U') IS NOT NULL
			DROP TABLE #TBL_CATEGORY
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_CATEGORY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_CATEGORY
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_MEASURE', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_MEASURE;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_PIVOT_DIVISION_MM', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_PIVOT_DIVISION_MM;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_PIVOT_DIVISION_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_PIVOT_DIVISION_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_PIVOT_DIVISION_YYYY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_PIVOT_DIVISION_YYYY;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_PIVOT_SUB1_MM', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_PIVOT_SUB1_MM;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_PIVOT_SUB1_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_PIVOT_SUB1_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_PIVOT_SUB1_YYYY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_PIVOT_SUB1_YYYY;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_PIVOT_SUB2_MM', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_PIVOT_SUB2_MM;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_PIVOT_SUB2_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_PIVOT_SUB2_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_PIVOT_SUB2_YYYY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_PIVOT_SUB2_YYYY;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_CAR_SUB1_MM', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_CAR_SUB1_MM;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_CAR_SUB1_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_CAR_SUB1_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_CAR_SUB1_YYYY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_CAR_SUB1_YYYY;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_CAR_SUB2_MM', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_CAR_SUB2_MM;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_CAR_SUB2_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_CAR_SUB2_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_CAR_SUB2_YYYY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_CAR_SUB2_YYYY;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_DIVISION_MM', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_DIVISION_MM;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_DIVISION_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_DIVISION_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_DIVISION_YYYY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_DIVISION_YYYY;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_ESS_SUB1_MM', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_ESS_SUB1_MM;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_ESS_SUB1_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_ESS_SUB1_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_ESS_SUB1_YYYY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_ESS_SUB1_YYYY;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_ESS_SUB2_MM', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_ESS_SUB2_MM;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_ESS_SUB2_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_ESS_SUB2_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_ESS_SUB2_YYYY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_ESS_SUB2_YYYY;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_SMALL_SUB1_MM', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB1_MM;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_SMALL_SUB1_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB1_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_SMALL_SUB1_YYYY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB1_YYYY;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_SMALL_SUB2_MM', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB2_MM;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_SMALL_SUB2_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB2_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_SMALL_SUB2_YYYY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_SMALL_SUB2_YYYY;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RAW_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RESULT_DAILY', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RESULT_DAILY
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RESULT_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RESULT_WW;
		IF OBJECT_ID (N'tempdb..#TEMP_SCP_RPT_RTF_ARC_SUM', N'U') IS NOT NULL
			DROP TABLE #TEMP_SCP_RPT_RTF_ARC_SUM
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RTF_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_RTF_WW;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_WEEK_MONTH_INFO', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_WEEK_MONTH_INFO;
		IF OBJECT_ID (N'tempdb..#TBL_SCP0092_WHOLE_WW', N'U') IS NOT NULL
			DROP TABLE #TBL_SCP0092_WHOLE_WW;
		IF OBJECT_ID (N'tempdb..#TEMP_CELL_MODEL', N'U') IS NOT NULL
			DROP TABLE #TEMP_CELL_MODEL;
		IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V_RESULT', N'U') IS NOT NULL
			DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V_RESULT;
		IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V_RTF', N'U') IS NOT NULL
			DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V_RTF;
		IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM_RESULT', N'U') IS NOT NULL
			DROP TABLE #TEMP_SCM_MST_SITE_ITEM_RESULT;
		IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM_RTF', N'U') IS NOT NULL
			DROP TABLE #TEMP_SCM_MST_SITE_ITEM_RTF;
		IF OBJECT_ID (N'tempdb..#T_TERMS', N'U') IS NOT NULL
			DROP TABLE #T_TERMS
		IF OBJECT_ID (N'tempdb..#T_VERSION', N'U') IS NOT NULL
			DROP TABLE #T_VERSION
	------------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (END)
	------------------------------------------------------------------------------------------
END

