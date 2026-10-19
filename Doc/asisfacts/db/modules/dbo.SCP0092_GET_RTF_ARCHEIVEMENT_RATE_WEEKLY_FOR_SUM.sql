---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_FOR_SUM
 * Description  : RTF 준수율 Weekly 조회
 * Program History
 *===================================================================================================
 *  Date        In Charge   Description
*===================================================================================================
* 2022.07.12	chaan       V1.0.0    Inititialize
* 2022/07/15    chaan		V1.0.1    CATEGORY 미입력항목 '기타' 로 표기
* 2022/07/20    chaan		V1.0.2    사용자지정컬럼 기본 키 변경
                                      소계 정렬용 DISPLAY_SEQ 추가
* 2022/08/09    chaan		V1.0.3    인터페이스 오류 수정
* 2022/08/09    chaan		V1.0.4  DM기준 biz_type => operation_group 으로 변경
* 2022/08/10    chaan		V1.0.5  RTF실적 -1Week/0Week 옵션화로 인한 파라미터 추가 (+ 버전을 Target된 버전으로 제한)
* 2022/08/24    chaan		V1.1.1  INSERT, EXEC 중첩에러 회피를 위해 SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY 수정
* 2022/08/30    chaan		V1.1.2  공통 - Operation Gorup = 'Cell' 일때, Cell Quantity NULL을 1로 대체
                                         - Nickname 으로 검색시 Operation Group Name 표시 안되던 부분 보완 (@p_item_id 에 Nickname 이 넘어옴)
                                    소형 - PROJECT_CODE, PROJECT_NAME 삭제
                                    소형 - RTF 준수율 산출 로직 변경
                                           ~ 소형 : VMI = 'Y' AND Measure = 'VMI in Plan[R+P]'
                                           ~ ESS  : Measure = 'RTF[R+P]'
                                    소형/자동차 - OWNER(PIC) 로직 변경(Group Code Management 테이블로 변경)
                                    소형/자동차 - Team 을 SCM Team 으로 변경
* 2022/09/30    chaan       V1.1.3 소형/자동차  - PIC조회 변경
                                                - Owner 필터 수정(PIC)
                                                - ESS 결과셋과 소형 결과셋 분리
                                                - Product Group 수정 (FORECAST_INFO_PRODUCT_GROUP -> SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT2, (weekly는 CELL_TYPE))
* 2022/10/11    chaan		V1.1.4 소형         - biz_type 이 opertaion_group 으로 변경되어 'ALL' 선택시 전극까지 조회되는 오류 수정
* 2022/10/24    chaan		V1.1.5 소형         - opertaion_group 에 따른 로직 변경
                                                  ~ Cell 일 때, Pack RTF 항목들(RTF, RESULT, RESULT_WITH_RTF , RATE) 0 처리
                                                  ~ Pack 일 때, 대상 데이터를 Shipment Plan FG 기준으로 변경
* 2022/11/09    chaan		V1.1.6 소형         - Weekly 수치와 검증
* 2022/11/20    chaan		V1.1.7 자동차       - 자동차 사업부 추가
* 2022/11/24    chaan		V1.1.9 소형         - Nickname 로직 변경
* 2022/12/01    chaan		V1.1.10 소형        - 소형 & Pack & Cylinder 이면 Nickname 별로 합산(다음 컬럼 공란 처리)
                                                  ~ Model, Cell Model, Spec & Version, Cell Quantity
* 2022/12/01    chaan		V1.1.11             - I/F 테이블 전환을 위해 전/당주 구분 파라미터 추가
* 2022/12/08    chaan		V1.1.12             - 필터링 로직 제거
* 2022/12/13    chaan		V1.1.13             - ITEM_TYPE, FCST_TYPE 필터 추가
* 2022/12/13    chaan		V1.1.14             - RATE, RATE_CELL 산출시 소수이하 절삭 오류 수정
* 2022/12/20    chaan		V1.1.15             - 데이터 집계 오류 수정(RTF & 실적 조인시 키값에 ISNULL 처리, 최종 SUM테이블어 INSERT 시에도 NULL 처리)
                                                - HLGP_KR_CHU 로직 원복 (Measure 대상 데이터를 기존 방식으로 변경, VMI_In_Plan -> RTF_SYS_RP)
* 2023/01/19    chaan		V1.1.16 조회 오류 수정 - 버전 조회시 사업부별 CUTOFF 날짜가 달라서 발생
                                                   - 정기 CUTOFF 구분 추가
**************************************************************************************************
*/
 
--CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_FOR_SUM]
CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_FOR_SUM]
      @p_division_id              NVARCHAR(30)
    , @p_week                     NVARCHAR(50)
    , @p_created_by               NVARCHAR(4000)
    , @p_is_pre_week              NVARCHAR(50)
AS
BEGIN
  SET NOCOUNT ON;
  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON; 


    ----DECLARE @p_division_id              NVARCHAR(30)        = N'82';
    --DECLARE @p_division_id              NVARCHAR(30)        = N'81';
    ----DECLARE @p_division_id              NVARCHAR(30)        = N'40';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20221122-W47';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20221115-W46';
    --DECLARE @p_week                     NVARCHAR(50)        = N'20221108-W45';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20221101-W44';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20221024-W43';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20221018-W42';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20221004-W40';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20220926-W39';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20220920-W38';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20220913-W37';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20220816-W33';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20220812-W32';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20220727-W30';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20220719-W29';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20220708-W27';
    ----DECLARE @p_week                     NVARCHAR(50)        = N'20220712-W28';
    --DECLARE @p_created_by               NVARCHAR(4000)      = N'iamarock';
    --DECLARE @p_is_pre_week				NVARCHAR(50)	    = N'T';
   

--여기부터 WEEKLY 쿼리와 ~FOR_IF 쿼리가 동적쿼리 부분 동일------------------------------------------------------------------------------------------------------
print N'--버전정보 구함 begin-------------------------------------------------------------'
    DECLARE @p_from_yyyymmdd            NVARCHAR(8)         = '';
    DECLARE @p_to_yyyymmdd              NVARCHAR(8)         = '';
    DECLARE @V_ISO_YYYYWW               NVARCHAR(8)         = '';
    DECLARE @V_THIS_TO_YYYYMMDD         NVARCHAR(8)         = '';
    DECLARE @V_THIS_MONDAY              NVARCHAR(8)         = '';
    DECLARE @V_LAST_SUNDAY              NVARCHAR(8)         = '';
    DECLARE @V_PRE_FROM_YYYYMMDD        NVARCHAR(8)         = ''; -- RTF 를위해 지정한 기간 전주까지 기간에 포함
    DECLARE @V_PRE_TO_YYYYMMDD          NVARCHAR(8)         = ''; -- RTF 를위해 지정한 기간 전주까지 기간에 포함
    DECLARE @p_pre_iso_yyyyww           NVARCHAR(6)         = '';
    DECLARE @p_this_iso_yyyyww          NVARCHAR(6)         = '';
    DECLARE @V_POST_FROM_YYYYMMDD       NVARCHAR(8)         = ''; -- FG 실적 데이터 조회를 위한 마지막주
    DECLARE @V_POST_TO_YYYYMMDD         NVARCHAR(8)         = ''; -- FG 실적 데이터 조회를 위한 마지막주
    DECLARE @p_post_iso_yyyyww          NVARCHAR(6)         = ''; -- FG 실적 데이터 조회를 위한 마지막주
    DECLARE @V_CURR_PRE_FROM_YYYYMMDD   NVARCHAR(8)         = '';
    DECLARE @V_CURR_PRE_TO_YYYYMMDD     NVARCHAR(8)         = '';
    DECLARE @V_CURR_POST_FROM_YYYYMMDD  NVARCHAR(8)         = '';
    DECLARE @V_CURR_POST_TO_YYYYMMDD    NVARCHAR(8)         = '';
    DECLARE @V_CURR_FG_SEQ_P            BIGINT;
    DECLARE @V_CURR_FG_SEQ_R            BIGINT;

    DECLARE @p_year                     NVARCHAR(4)         = SUBSTRING(@p_week, 1, 4);

    SELECT  @V_ISO_YYYYWW = C.ISO_YYYYWW
    FROM    SCM_SYS_CALENDAR_M C
    WHERE   1=1
        AND C.BASIS_YYYYMMDD + '-' + C.WEEK_NAME = @p_week;


    IF OBJECT_ID (N'tempdb..#T_TERMS', N'U') IS NOT NULL
		DROP TABLE #T_TERMS

	CREATE TABLE #T_TERMS
    (
          ISO_YYYYWW                    NVARCHAR(6)
        , THIS_ISO_YYYYWW               NVARCHAR(6)
        , THIS_FROM_YYYYMMDD            NVARCHAR(8)
        , THIS_TO_YYYYMMDD              NVARCHAR(8)
        , PRE_ISO_YYYYWW                NVARCHAR(6)
        , PRE_FROM_YYYYMMDD             NVARCHAR(8)
        , PRE_TO_YYYYMMDD               NVARCHAR(8)
        , POST_ISO_YYYYWW               NVARCHAR(6)
        , POST_FROM_YYYYMMDD            NVARCHAR(8)
        , POST_TO_YYYYMMDD              NVARCHAR(8)
        , DM_RTF_YN                     NVARCHAR(1)
        , FG_SEQ_P                      BIGINT  --FG
        , FG_SEQ_R                      BIGINT  --FG
        , WHOLE_FROM_YYYYMMDD           NVARCHAR(8)
        , WHOLE_TO_YYYYMMDD             NVARCHAR(8)
        , WHOLE_PRE_FROM_YYYYMMDD       NVARCHAR(8)
        , WHOLE_THIS_MONDAY             NVARCHAR(8)
        , WHOLE_LAST_SUNDAY             NVARCHAR(8)
        , WHOLE_PRE_YYYYMM              NVARCHAR(6)
        , WHOLE_POST_YYYYMM             NVARCHAR(6)
    )

	INSERT INTO #T_TERMS
    (
          ISO_YYYYWW
        , THIS_ISO_YYYYWW
        , THIS_FROM_YYYYMMDD
        , THIS_TO_YYYYMMDD
        , PRE_ISO_YYYYWW
        , PRE_FROM_YYYYMMDD
        , PRE_TO_YYYYMMDD
        , POST_ISO_YYYYWW
        , POST_FROM_YYYYMMDD
        , POST_TO_YYYYMMDD
        , DM_RTF_YN
        , FG_SEQ_P
        , FG_SEQ_R
        , WHOLE_FROM_YYYYMMDD
        , WHOLE_TO_YYYYMMDD
        , WHOLE_PRE_FROM_YYYYMMDD
        , WHOLE_THIS_MONDAY
        , WHOLE_LAST_SUNDAY
        , WHOLE_PRE_YYYYMM
        , WHOLE_POST_YYYYMM
    )
        EXEC SCP0092_GET_RTF_ARCHEIVEMENT_RATE_TERM
               @p_division_id                   
             , @p_year;
    
    SELECT    @p_from_yyyymmdd              = THIS_FROM_YYYYMMDD
	        , @p_to_yyyymmdd                = THIS_TO_YYYYMMDD
	        , @V_THIS_MONDAY                = WHOLE_THIS_MONDAY
	        , @V_LAST_SUNDAY                = WHOLE_LAST_SUNDAY
            , @V_PRE_FROM_YYYYMMDD          = WHOLE_PRE_FROM_YYYYMMDD
            , @p_pre_iso_yyyyww             = PRE_ISO_YYYYWW
            , @p_this_iso_yyyyww            = THIS_ISO_YYYYWW
            , @V_POST_FROM_YYYYMMDD         = POST_FROM_YYYYMMDD
            , @p_post_iso_yyyyww            = POST_ISO_YYYYWW
            , @V_CURR_PRE_FROM_YYYYMMDD     = PRE_FROM_YYYYMMDD  
            , @V_CURR_PRE_TO_YYYYMMDD       = PRE_TO_YYYYMMDD    
            , @V_CURR_POST_FROM_YYYYMMDD    = POST_FROM_YYYYMMDD 
            , @V_CURR_POST_TO_YYYYMMDD      = POST_TO_YYYYMMDD   
            , @V_CURR_FG_SEQ_P              = FG_SEQ_P           
            , @V_CURR_FG_SEQ_R              = FG_SEQ_R           
    FROM    #T_TERMS
    WHERE   ISO_YYYYWW = @V_ISO_YYYYWW;

--TESTRING : OK
--select * from #T_TERMS;return;

PRINT '@p_week : ' + @p_week;
PRINT '@p_from_yyyymmdd : ' + @p_from_yyyymmdd;
PRINT '@p_to_yyyymmdd : ' + @p_to_yyyymmdd;
PRINT '@V_ISO_YYYYWW : ' + @V_ISO_YYYYWW;
PRINT '@V_THIS_MONDAY : ' + @V_THIS_MONDAY;
PRINT '@V_LAST_SUNDAY : ' + @V_LAST_SUNDAY;
PRINT '@V_PRE_FROM_YYYYMMDD : ' + @V_PRE_FROM_YYYYMMDD;
PRINT '@p_pre_iso_yyyyww : ' + @p_pre_iso_yyyyww;
PRINT '@p_this_iso_yyyyww : ' + @p_this_iso_yyyyww;
PRINT '@V_POST_FROM_YYYYMMDD : ' + @V_POST_FROM_YYYYMMDD;
PRINT '@p_post_iso_yyyyww : ' + @p_post_iso_yyyyww;

--return;
print N'--버전정보 구함 end-------------------------------------------------------------'


    DECLARE @V_RESULT_VERSION_NO        NVARCHAR(8)         = 'CURRENT';

    DECLARE @V_COLUMNS_RAW		        NVARCHAR(MAX);
    DECLARE @V_COLUMNS_SUM		        NVARCHAR(MAX);

    -- @V_DEF_* : I/F용 FULL 데이터셋
    DECLARE @V_DEF_COLUMNS_RAW		    NVARCHAR(MAX);
    DECLARE @V_DEF_COLUMNS_SUM		    NVARCHAR(MAX);
    DECLARE @V_DEF_ORDERS_RAW	        NVARCHAR(MAX);

    DECLARE @p_program_id	            VARCHAR(50)         ='SCP0092'
    DECLARE @p_sheet_name	            VARCHAR(50)         = 'RTF Archeivement Rate Weekly Report - ' + @p_division_id;

    SET		@V_COLUMNS_RAW		= '';
    SET		@V_COLUMNS_SUM		= '';


    DECLARE	@MEASURE	    INT	= 0;
    DECLARE	@i_count	    int	= 0;


	DECLARE @v_user_mea_cnt int =0;


print 'B--' + convert(varchar(30), getdate(), 121)


    IF OBJECT_ID (N'tempdb..#RAW_RTF_DAILY', N'U') IS NOT NULL
		DROP TABLE #RAW_RTF_DAILY

    IF OBJECT_ID (N'tempdb..#RAW_RESULT_DAILY', N'U') IS NOT NULL
		DROP TABLE #RAW_RESULT_DAILY


    IF OBJECT_ID (N'tempdb..#TBL_CATEGORY', N'U') IS NOT NULL
		DROP TABLE #TBL_CATEGORY

    --SELECT DISTINCT
    --            A.DIVISION_ID
    --        , LK1.SEGMENT1 AS PROJECT_CODE
		  --  , LK2.SEGMENT2
		  --  , LK2.SEGMENT3
    --        , LK2.DISPLAY_SEQ
    --INTO    #TBL_SCP0092_CATEGORY
    --FROM	DM_PLN_MKT_FCST A
		  --  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON
				--    A.PROJECT_CODE  = LK1.SEGMENT1
			 --   AND LK1.LOOKUP_TYPE = 'DM_ITEM_USE_EX'
		  --  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON
				--    A.DIVISION_ID = LK2.SEGMENT1
			 --   AND ISNULL(LK1.SEGMENT2, LEFT(A.PROJECT_CODE, 1)) = LK2.SEGMENT2
    --            AND LK2.LOOKUP_TYPE = 'DM_ITEM_USE'
    --WHERE	A.MEASURE = 'RTF_SYS_RP'
    --    AND LK2.VALID_YN = 'Y'
    --ORDER BY DISPLAY_SEQ

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
	        , A.GROUP_CODE5                 AS CATEGORY_CODE
	        , ISNULL(B.SEGMENT3, N'기타')   AS CATEGORY_NAME
            , ISNULL(B.DISPLAY_SEQ, 9)      AS DISPLAY_SEQ
    INTO    #TBL_SCP0092_CATEGORY
    FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
            LEFT JOIN #TBL_CATEGORY B ON
                    A.DIVISION_ID = B.DIVISION_ID
                AND A.GROUP_CODE5 = B.SEGMENT3
    WHERE   A.OPERATION_GROUP IN ('A', 'P')
        AND (( @p_division_id	IS NULL OR @p_division_id	='') OR A.DIVISION_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id	, ',')))
--select * from #TBL_SCP0092_CATEGORY;return;



	CREATE TABLE #RAW_RTF_DAILY
    (
		  VERSION_NO		            NVARCHAR(30)
		, CUTOFF_YYYYMMDD	            CHAR(8)
		, DIVISION_ID	                NVARCHAR(30)
		, PROJECT_CODE	                NVARCHAR(50)
		, SCM_SITE_ID	                NVARCHAR(30)
		, PLANT_SITE_ID                 NVARCHAR(30)
		, ITEM_ID		                NVARCHAR(50)
		, INCOTERMS		                NVARCHAR(10)
		, DOM_EXP		                NVARCHAR(3)
		, FCST_TYPE		                NVARCHAR(20)
		, MEASURE		                NVARCHAR(50)
		, YYYYMMDD		                CHAR(8)
		, QTY			                NUMERIC(30,10)
		, CELL_QTY	                    NUMERIC(30,10)
		, VALID_YN		                CHAR(1)
		, PLAN_RESULT	                CHAR(1)
		, GUBUN			                TINYINT
        , CATEGORY_CODE                 NVARCHAR(100)
        , CATEGORY_NAME                 NVARCHAR(100)
        , CELL_TYPE                     NVARCHAR(100)
	)

	CREATE TABLE #RAW_RESULT_DAILY
    (
		  VERSION_NO		            NVARCHAR(30)
		, CUTOFF_YYYYMMDD	            CHAR(8)
		, DIVISION_ID	                NVARCHAR(30)
		, PROJECT_CODE	                NVARCHAR(50)
		, SCM_SITE_ID	                NVARCHAR(30)
		, PLANT_SITE_ID                 NVARCHAR(30)
		, ITEM_ID		                NVARCHAR(50)
		, INCOTERMS		                NVARCHAR(10)
		, DOM_EXP		                NVARCHAR(3)
		, FCST_TYPE		                NVARCHAR(20)
		, MEASURE		                NVARCHAR(50)
		, YYYYMMDD		                CHAR(8)
		, QTY			                NUMERIC(30,10)
		, CELL_QTY	                    NUMERIC(30,10)
		, VALID_YN		                CHAR(1)
		, PLAN_RESULT	                CHAR(1)
		, GUBUN			                TINYINT
        , CATEGORY_CODE                 NVARCHAR(100)
        , CATEGORY_NAME                 NVARCHAR(100)
        , CELL_TYPE                     NVARCHAR(100)
	)


/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
   과거 구간은 전체 Data가 포함되어야 함.
   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
   단위 환산이 되어야 함.
*/

	-------------------------------------------------------------------------
	-- 20200316 KHSONG C20200224-000109 (BEGIN)
	-------------------------------------------------------------------------
	SELECT @v_user_mea_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	    AND U.PROGRAM_ID					= @p_program_id
	    AND U.SHEET_NAME					= @p_sheet_name
	    AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
	    AND U.USER_ID						= @p_created_by;
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
	-------------------------------------------------------------------------
	-- 20200316 KHSONG C20200224-000109 (END)
	-------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL
		DROP TABLE #SELECT_MEASURE;

	CREATE TABLE #SELECT_MEASURE
    (
          PROGRAM_ID        NVARCHAR(100)
        , SHEET_NAME        NVARCHAR(150)
        , USER_ID		    NVARCHAR(150)
        , MEASURE_GROUP     NVARCHAR(200)
        , MEASURE           NVARCHAR(200)
        , SORT_ORDER_NO     NVARCHAR(10)
        , SYSTEM_ADD        NVARCHAR(1)
    )

	INSERT INTO #SELECT_MEASURE
    (
          PROGRAM_ID
        , SHEET_NAME
        , USER_ID
        , MEASURE_GROUP
        , MEASURE
        , SORT_ORDER_NO
        , SYSTEM_ADD
    )
        SELECT    @p_program_id  AS PROGRAM_ID
                , @p_sheet_name  AS SHEET_NAME
                , @p_created_by  AS USER_ID
                , N'RTF_SCP'     AS MEASURE_GROUP
                , N'RTF_SCP'     AS MEASURE
                , N'2.0'         AS SORT_ORDER_NO
                , N'N'           AS SYSTEM_ADD;

	INSERT INTO #SELECT_MEASURE
    (
          PROGRAM_ID
        , SHEET_NAME
        , USER_ID
        , MEASURE_GROUP
        , MEASURE
        , SORT_ORDER_NO
        , SYSTEM_ADD
    )
        SELECT    @p_program_id  AS PROGRAM_ID
                , @p_sheet_name  AS SHEET_NAME
                , @p_created_by  AS USER_ID
                , N'RTF_SYS_RP'  AS MEASURE_GROUP
                , N'RTF_SYS_RP'  AS MEASURE
                , N'3.0'         AS SORT_ORDER_NO
                , N'N'           AS SYSTEM_ADD

	INSERT INTO #SELECT_MEASURE
    (
          PROGRAM_ID
        , SHEET_NAME
        , USER_ID
        , MEASURE_GROUP
        , MEASURE
        , SORT_ORDER_NO
        , SYSTEM_ADD
    )
        SELECT    @p_program_id  AS PROGRAM_ID
                , @p_sheet_name  AS SHEET_NAME
                , @p_created_by  AS USER_ID
                , N'VMI_In_Plan' AS MEASURE_GROUP
                , N'VMI_In_Plan' AS MEASURE
                , N'5.0'         AS SORT_ORDER_NO
                , N'N'           AS SYSTEM_ADD

--select * from #SELECT_MEASURE;return;


		------------------------------------------------------------------------------------------------------------------
		-- 변환 또는 환산이 필요할 경우 해당 본 메저도 추가해준다.
		------------------------------------------------------------------------------------------------------------------
		IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE LIKE 'MKT_FCST_RP%' )
		BEGIN
			INSERT INTO #SELECT_MEASURE
            (
                  PROGRAM_ID
                , SHEET_NAME
                , USER_ID
                , MEASURE_GROUP
                , MEASURE
                , SYSTEM_ADD
            )
			    SELECT    @p_program_id
                        , @p_sheet_name
                        , @p_created_by
                        , A.MEASURE_GROUP
                        , A.MEASURE
                        , 'Y'
			    FROM    (
				            SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE
				            UNION ALL
				            SELECT 'MKT_FCST' AS MEASURE_GROUP, 'MKT_FCST' AS MEASURE
				        ) A
    			        LEFT JOIN #SELECT_MEASURE B ON
                                A.MEASURE = B.MEASURE
			    WHERE B.MEASURE IS NULL
		END

		IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE LIKE 'RTF_SYS_RP%' )
		BEGIN
			INSERT INTO #SELECT_MEASURE
            (
                  PROGRAM_ID
                , SHEET_NAME
                , USER_ID
                , MEASURE_GROUP
                , MEASURE
                , SYSTEM_ADD
            )
			    SELECT    @p_program_id
                        , @p_sheet_name
                        , @p_created_by
                        , A.MEASURE_GROUP
                        , A.MEASURE
                        , 'Y'
			    FROM    (
            				SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE
				        ) A
			            LEFT JOIN #SELECT_MEASURE B ON
                                A.MEASURE = B.MEASURE
			    WHERE B.MEASURE IS NULL
		END

		IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'LOC' )
		BEGIN
			INSERT INTO #SELECT_MEASURE
            (
                  PROGRAM_ID
                , SHEET_NAME
                , USER_ID
                , MEASURE_GROUP
                , MEASURE
                , SYSTEM_ADD
            )
			    SELECT    @p_program_id
                        , @p_sheet_name
                        , @p_created_by
                        , A.MEASURE_GROUP
                        , A.MEASURE
                        , 'Y'
			    FROM    (
                            SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE
                            UNION ALL
                            SELECT 'SALESAMT' AS MEASURE_GROUP,'SalesAmt_LOC' AS MEASURE
                        ) A
                        LEFT JOIN #SELECT_MEASURE B ON
                                A.MEASURE = B.MEASURE
                WHERE   B.MEASURE IS NULL
		END
--select * from #SELECT_MEASURE;return;

--select * from #T_TERMS;

--TESTING : Raw 데이터


	IF OBJECT_ID (N'tempdb..#WHERE_MEASURE', N'U') IS NOT NULL
		DROP TABLE #WHERE_MEASURE;

	CREATE TABLE #WHERE_MEASURE
    (
          TOKEN             NVARCHAR(MAX)
    )

    INSERT INTO #WHERE_MEASURE
        SELECT  TOKEN
        FROM    DBO.STRING_SPLIT('RTF_SYS_RP', ',')

    IF @p_division_id IN ('40', '81')
    BEGIN
        INSERT INTO #WHERE_MEASURE
            SELECT  TOKEN
            FROM    DBO.STRING_SPLIT('VMI_In_Plan', ',')
    END

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


--RAW 데이터 생성==============================================================================================================

--FG 데이터 적용 준비 begin -------------------------------------------------------------------------------------------------------------------------------------------
    -- 빈 테이블 생성
	IF OBJECT_ID (N'tempdb..#TEMP_SCP0092_PLAN_FG', N'U') IS NOT NULL
		DROP TABLE #TEMP_SCP0092_PLAN_FG;
	IF OBJECT_ID (N'tempdb..#TEMP_SCP0092_RESULT_FG', N'U') IS NOT NULL
		DROP TABLE #TEMP_SCP0092_RESULT_FG;

    SELECT * INTO #TEMP_SCP0092_PLAN_FG     FROM #RAW_RTF_DAILY;
    SELECT * INTO #TEMP_SCP0092_RESULT_FG   FROM #RAW_RESULT_DAILY;


    -- Operation Group 이 Pack 일 때 FG 데이터 적용은 소형 사업부만 해당
    IF @p_division_id = '40'
    BEGIN
        --FG계획-----------------------------------------------------------------------------------------------------------------------------------
print '@V_CURR_PRE_FROM_YYYYMMDD : ' + @V_CURR_PRE_FROM_YYYYMMDD;

        INSERT INTO #TEMP_SCP0092_PLAN_FG
            EXEC SCP0009_GET_SHIPMENT_PLAN_FG_RTF_WEEKLY
	                @p_is_plan				= N'T'
	            , @p_division_id			= '40'
	            , @p_from_yyyymmdd		    = @p_from_yyyymmdd
	            , @p_to_yyyymmdd			= @p_to_yyyymmdd
	            , @p_program_id			    = 'SCP0009'
	            , @p_sheet_name			    = 'Shipment Plan FG'
	            , @p_user_id				= @p_created_by
	            , @debug_mode               ='F';

--TESTING : OK
--select * from #TEMP_SCP0092_PLAN_FG;return;

        --FG실적---------------------------------------------------------------------------------------------------------------
print '@V_CURR_POST_FROM_YYYYMMDD : ' + @V_CURR_POST_FROM_YYYYMMDD;

        INSERT INTO #TEMP_SCP0092_RESULT_FG
            EXEC SCP0009_GET_SHIPMENT_PLAN_FG_RTF_WEEKLY
	                @p_is_plan				= N'F'
	            , @p_division_id			= '40'
	            , @p_from_yyyymmdd		    = @p_from_yyyymmdd
	            , @p_to_yyyymmdd			= @p_to_yyyymmdd
	            , @p_program_id			    = 'SCP0009'
	            , @p_sheet_name			    = 'Shipment Plan FG'
	            , @p_user_id				= @p_created_by
	            , @debug_mode               ='F';
    --return;
    --TESTING : OK
    --select * from #TEMP_SCP0092_RESULT_FG;return;
    END

--TESTING : OK
--select * from #TEMP_SCP0092_PLAN_FG;
--select * from #TEMP_SCP0092_RESULT_FG;return;

--FG 데이터 적용 준비 end -------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #RAW_RTF_DAILY
			(
			  	  VERSION_NO
				, CUTOFF_YYYYMMDD
				, DIVISION_ID
				, PROJECT_CODE
				, SCM_SITE_ID
				, PLANT_SITE_ID
				, ITEM_ID
				, INCOTERMS
				, DOM_EXP
				, FCST_TYPE
				, MEASURE
				, YYYYMMDD
				, QTY
                , CELL_QTY
				, PLAN_RESULT
				, GUBUN
			)
                SELECT    A.VERSION_NO
		                , A.CUTOFF_YYYYMMDD
		                , A.DIVISION_ID
		                , A.PROJECT_CODE
		                , A.SCM_SITE_ID
		                , A.PLANT_SITE_ID
		                , A.ITEM_ID
		                , A.INCOTERMS
		                , A.DOM_EXP
		                , A.FCST_TYPE
		                , A.MEASURE
		                , A.YYYYMMDD
		                , A.QTY AS QTY
		                , A.QTY AS CELL_QTY
		                ,'P' AS PLAN_RESULT
                        , 3 AS GUBUN
                FROM
                        (
                            SELECT  F.*
                            FROM    DM_PLN_MKT_FCST_C F
						    WHERE   ((@p_division_id IS NULL OR @p_division_id = '') OR F.DIVISION_ID = @p_division_id)
	                                AND F.MEASURE IN (SELECT TOKEN FROM #WHERE_MEASURE)
	                                AND F.QTY <> 0
                        ) A
                        JOIN
                            (
                                SELECT    V.DIVISION_ID --RTF 는 Result 와 달리 버전과 물리므로 DIVISION_ID + VERSION_NO 로 연결
                                        , C.ISO_YYYYWW
                                        , MAX(V.VERSION_NO) AS VERSION_NO
                                FROM    DM_MST_VERSION V
                                    JOIN SCM_SYS_CALENDAR_M C ON
                                            V.YYYYMMDD = C.BASIS_YYYYMMDD
                                WHERE   VERSION_TYPE = 'MF_W'
                                    AND ((@p_division_id IS NULL OR @p_division_id = '') OR DIVISION_ID = @p_division_id)
                                    AND VERSION_DESCRIPTION   = 'MKT FCST Weekly Cutoff'  -- 정기 CUTOFF 만 해당
                                GROUP BY V.DIVISION_ID, C.ISO_YYYYWW
                            ) V ON
							        A.DIVISION_ID = V.DIVISION_ID --RTF 는 Result 와 달리 버전과 물리므로 DIVISION_ID + VERSION_NO 로 연결
							    AND A.VERSION_NO  = V.VERSION_NO  --RTF 는 Result 와 달리 버전과 물리므로 DIVISION_ID + VERSION_NO 로 연결
                                AND V.ISO_YYYYWW = IIF(@p_is_pre_week = 'T', @p_pre_iso_yyyyww, @p_this_iso_yyyyww)
                        JOIN #T_TERMS T ON
                                    V.ISO_YYYYWW = IIF(@p_is_pre_week = 'T', T.PRE_ISO_YYYYWW, T.THIS_ISO_YYYYWW)
                                AND T.ISO_YYYYWW = @V_ISO_YYYYWW
		                JOIN SCM_MST_SITE S (NOLOCK) ON
				                    A.DIVISION_ID = S.DIVISION_ID
			                    AND A.SCM_SITE_ID = S.SCM_SITE_ID
			                    AND S.VALID_YN = 'Y'
                        JOIN #TEMP_MODELS M ON
                                    A.DIVISION_ID       =  M.DIVISION_ID
                                AND A.ITEM_ID           =  M.ITEM_ID
                                AND CHARINDEX(M.OPERATION_GROUP, IIF(A.DIVISION_ID = '40', 'A', 'P,A')) > 0 -- 소형은 Pack 제외(FG 에서 가져옴)
                WHERE   1=1
                    AND A.YYYYMMDD >= @p_from_yyyymmdd
                    AND A.YYYYMMDD <= @p_to_yyyymmdd
                    AND ((@p_division_id IS NULL OR @p_division_id = '') OR A.DIVISION_ID = @p_division_id)
                UNION ALL
                SELECT	  A.VERSION_NO
		                , A.CUTOFF_YYYYMMDD
		                , A.DIVISION_ID
		                , A.PROJECT_CODE
		                , A.SCM_SITE_ID
		                , A.PLANT_SITE_ID
		                , A.ITEM_ID
		                , A.INCOTERMS
		                , A.DOM_EXP
		                , A.FCST_TYPE
		                , A.MEASURE
		                , A.YYYYMMDD
		                , A.QTY AS QTY
		                , A.QTY AS CELL_QTY
		                ,'R' AS PLAN_RESULT
                        , 4 AS GUBUN
                FROM
                        (
                            SELECT  F.*
                            FROM    DM_PLN_MKT_FCST_RESULT_C F
						    WHERE   ((@p_division_id IS NULL OR @p_division_id = '') OR F.DIVISION_ID = @p_division_id)
	                                AND F.MEASURE IN (SELECT TOKEN FROM #WHERE_MEASURE)
	                                AND F.QTY <> 0
                        ) A
                        JOIN
                            (
                                SELECT    V.DIVISION_ID --RTF 는 Result 와 달리 버전과 물리므로 DIVISION_ID + VERSION_NO 로 연결
                                        , C.ISO_YYYYWW
                                        , MAX(V.VERSION_NO) AS VERSION_NO
                                FROM    DM_MST_VERSION V
                                    JOIN SCM_SYS_CALENDAR_M C ON
                                            V.YYYYMMDD = C.BASIS_YYYYMMDD
                                WHERE   VERSION_TYPE = 'MF_W'
                                    AND ((@p_division_id IS NULL OR @p_division_id = '') OR DIVISION_ID = @p_division_id)
                                    AND VERSION_DESCRIPTION   = 'MKT FCST Weekly Cutoff'  -- 정기 CUTOFF 만 해당
                                GROUP BY V.DIVISION_ID, C.ISO_YYYYWW
                            ) V ON
							        A.DIVISION_ID = V.DIVISION_ID --RTF 는 Result 와 달리 버전과 물리므로 DIVISION_ID + VERSION_NO 로 연결
							    AND A.VERSION_NO  = V.VERSION_NO  --RTF 는 Result 와 달리 버전과 물리므로 DIVISION_ID + VERSION_NO 로 연결
                                AND V.ISO_YYYYWW = IIF(@p_is_pre_week = 'T', @p_pre_iso_yyyyww, @p_this_iso_yyyyww)
                        JOIN #T_TERMS T ON
                                    V.ISO_YYYYWW = IIF(@p_is_pre_week = 'T', T.PRE_ISO_YYYYWW, T.THIS_ISO_YYYYWW)
                                AND T.ISO_YYYYWW = @V_ISO_YYYYWW
                        JOIN #TEMP_MODELS M ON
                                    A.DIVISION_ID       =  M.DIVISION_ID
                                AND A.ITEM_ID           =  M.ITEM_ID
                                AND CHARINDEX(M.OPERATION_GROUP, IIF(A.DIVISION_ID = '40', 'A', 'P,A')) > 0 -- 소형은 Pack 제외(FG 에서 가져옴)
                        /* 'R' 은 SCM_MST_SITE 조인 안함!!! begin
		                --JOIN SCM_MST_SITE S (NOLOCK) ON
				              --  A.DIVISION_ID = S.DIVISION_ID
			               -- AND A.SCM_SITE_ID = S.SCM_SITE_ID
			               -- AND S.VALID_YN = 'Y'
                        'R' 은 SCM_MST_SITE 조인 안함!!! end */
                WHERE   1=1
                    AND A.YYYYMMDD >= @p_from_yyyymmdd
                    AND A.YYYYMMDD <= @p_to_yyyymmdd
                    AND ((@p_division_id IS NULL OR @p_division_id = '') OR A.DIVISION_ID = @p_division_id)
                UNION ALL
                SELECT	  A.VERSION_NO
		                , A.CUTOFF_YYYYMMDD
		                , A.DIVISION_ID
		                , A.PROJECT_CODE
		                , A.SCM_SITE_ID
		                , A.PLANT_SITE_ID
		                , A.ITEM_ID
		                , A.INCOTERMS
		                , A.DOM_EXP
		                , A.FCST_TYPE
		                , A.MEASURE
		                , A.YYYYMMDD
		                , A.QTY AS QTY
		                , A.QTY AS CELL_QTY
		                ,'P' AS PLAN_RESULT
                        , 3 AS GUBUN
                FROM
                        (
                            SELECT  F.*
                            FROM    #TEMP_SCP0092_PLAN_FG F
						    WHERE   ((@p_division_id IS NULL OR @p_division_id = '') OR F.DIVISION_ID = @p_division_id)
	                                AND F.QTY <> 0
                        ) A
		                JOIN SCM_MST_SITE S (NOLOCK) ON
				                A.DIVISION_ID = S.DIVISION_ID
			                AND A.SCM_SITE_ID = S.SCM_SITE_ID
			                AND S.VALID_YN = 'Y'
                WHERE   1=1
                    AND A.YYYYMMDD >= @p_from_yyyymmdd
                    AND A.YYYYMMDD <= @p_to_yyyymmdd
                    AND ((@p_division_id IS NULL OR @p_division_id = '') OR A.DIVISION_ID = @p_division_id)

--TESTING : OK
--select * from #RAW_RTF_DAILY order by yyyymmdd;return;
--select * from #RAW_RTF_DAILY where ITEM_ID = 'MPPLEN077C1N' order by yyyymmdd;return;

            -- 실적은 Current 버전으로 고정
			INSERT INTO #RAW_RESULT_DAILY
			(
				  VERSION_NO
				, CUTOFF_YYYYMMDD
				, DIVISION_ID
				, PROJECT_CODE
				, SCM_SITE_ID
				, PLANT_SITE_ID
				, ITEM_ID
				, INCOTERMS
				, DOM_EXP
				, FCST_TYPE
				, MEASURE
				, YYYYMMDD
				, QTY
                , CELL_QTY
				, PLAN_RESULT
				, GUBUN
			)
/* 실적은 'R' 만 사용 begin
 실적은 'R' 만 사용 end*/
				SELECT    @V_RESULT_VERSION_NO AS VERSION_NO
						, @p_from_yyyymmdd AS CUTOFF_YYYYMMDD
						, A.DIVISION_ID
						, A.PROJECT_CODE
						, A.SCM_SITE_ID
						, A.PLANT_SITE_ID
						, A.ITEM_ID
						, A.INCOTERMS
						, A.DOM_EXP
						, A.FCST_TYPE
						, A.MEASURE
						, A.YYYYMMDD
						, A.QTY
						, A.QTY AS CELL_QTY
						, 'R'
						, 2
                FROM
                        (
                            SELECT  F.*
                            FROM    DM_PLN_MKT_FCST_RESULT F
						    WHERE   ((@p_division_id IS NULL OR @p_division_id = '') OR F.DIVISION_ID = @p_division_id)
	                                AND F.MEASURE IN (SELECT TOKEN FROM #WHERE_MEASURE)
	                                AND F.QTY <> 0
                        ) A
                        JOIN #TEMP_MODELS M ON
                                    A.DIVISION_ID       =  M.DIVISION_ID
                                AND A.ITEM_ID           =  M.ITEM_ID
                                AND CHARINDEX(M.OPERATION_GROUP, IIF(A.DIVISION_ID = '40', 'A', 'P,A')) > 0 -- 소형은 Pack 제외(FG 에서 가져옴)
                        /* 'R' 은 SCM_MST_SITE 조인 안함!!! begin
		                --JOIN SCM_MST_SITE S (NOLOCK) ON
				              --  A.DIVISION_ID = S.DIVISION_ID
			               -- AND A.SCM_SITE_ID = S.SCM_SITE_ID
			               -- AND S.VALID_YN = 'Y'
                        'R' 은 SCM_MST_SITE 조인 안함!!! end */
                WHERE   1=1
                    AND A.YYYYMMDD >= @p_from_yyyymmdd
                    AND A.YYYYMMDD <= @p_to_yyyymmdd
                UNION ALL
				SELECT    @V_RESULT_VERSION_NO AS VERSION_NO
						, @p_from_yyyymmdd AS CUTOFF_YYYYMMDD
						, A.DIVISION_ID
						, A.PROJECT_CODE
						, A.SCM_SITE_ID
						, A.PLANT_SITE_ID
						, A.ITEM_ID
						, A.INCOTERMS
						, A.DOM_EXP
						, A.FCST_TYPE
						, A.MEASURE
						, A.YYYYMMDD
						, A.QTY
						, A.QTY AS CELL_QTY
						, 'R'
						, 2
                FROM
                        (
                            SELECT  F.*
                            FROM    #TEMP_SCP0092_RESULT_FG F
						    WHERE   ((@p_division_id IS NULL OR @p_division_id = '') OR F.DIVISION_ID = @p_division_id)
	                                AND F.QTY <> 0
                        ) A
                WHERE   1=1
                    AND A.YYYYMMDD >= @p_from_yyyymmdd
                    AND A.YYYYMMDD <= @p_to_yyyymmdd


--TESTING : OK
--select * from #RAW_RTF_DAILY;
--select * from #RAW_RESULT_DAILY;return;
--select * from #RAW_RTF_DAILY where SCM_SITE_ID = 'HLGP_KR_CHU';
--select * from #RAW_RESULT_DAILY where SCM_SITE_ID = 'HLGP_KR_CHU';return;

print '@V_THIS_MONDAY : ' + @V_THIS_MONDAY;
print '@p_from_yyyymmdd : ' + @p_from_yyyymmdd;
print '@p_to_yyyymmdd : ' + @p_to_yyyymmdd;


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
                        FROM    #RAW_RTF_DAILY
                    ) B ON
                    A.DIVISION_ID = B.DIVISION_ID
                AND A.ITEM_ID     = B.ITEM_ID
            LEFT JOIN SCP_MST_ITEM_CELL_CF C ON
                    A.ITEM_ID     = C.ITEM_ID
                AND A.ITEM_TYPE   = C.CELL_TYPE
                AND A.SPEC        = C.ITEM_SPEC
    WHERE   ((@p_division_id IS NULL OR @p_division_id = '') OR A.DIVISION_ID = @p_division_id)

-- TETING - OK
--select * from #RAW_RTF_DAILY;

	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V_RESULT', N'U') IS NOT NULL
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V_RESULT;

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
	INTO    #TEMP_DM_MST_ITEM_SINGLE_V_RESULT
	FROM    DM_MST_ITEM_SINGLE_V A
	        JOIN    (
                        SELECT DISTINCT
                                  DIVISION_ID
                                , ITEM_ID
                        FROM    #RAW_RESULT_DAILY
                    ) B ON
                    A.DIVISION_ID = B.DIVISION_ID
                AND A.ITEM_ID     = B.ITEM_ID
            LEFT JOIN SCP_MST_ITEM_CELL_CF C ON
                    A.ITEM_ID     = C.ITEM_ID
                AND A.ITEM_TYPE   = C.CELL_TYPE
                AND A.SPEC        = C.ITEM_SPEC
    WHERE A.DIVISION_ID = @p_division_id
--select * from #TEMP_DM_MST_ITEM_SINGLE_V_RESULT;return;

print 'E3--' + convert(varchar(30), getdate(), 121)

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
			, A.OWNER
			, DBO.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'EN' ) AS OWNER_NAME
			, DBO.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'KO' ) AS OWNER_NAME_KO
			,(	SELECT SU.DEPT_ID
				FROM   SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
				WHERE  SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](A.owner, ',')) ) DEPT_ID
			, A.VALID_YN
	INTO    #TEMP_SCM_MST_SITE_ITEM_RTF
	FROM    SCM_MST_SITE_ITEM A WITH(NOLOCK)
	        JOIN ( SELECT   DISTINCT
                            DIVISION_ID
                          , SCM_SITE_ID
                          , PROJECT_CODE
                          , ITEM_ID
                   FROM     #RAW_RTF_DAILY 
                 ) B ON
                    A.DIVISION_ID  = B.DIVISION_ID
                AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                AND A.PROJECT_CODE = B.PROJECT_CODE
                AND A.ITEM_ID      = B.ITEM_ID
	WHERE A.DIVISION_ID = @p_division_id


	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM_RESULT', N'U') IS NOT NULL
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM_RESULT;

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
			, A.OWNER
			, DBO.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'EN' ) AS OWNER_NAME
			, DBO.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'KO' ) AS OWNER_NAME_KO
			,(	SELECT SU.DEPT_ID
				FROM   SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
				WHERE  SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](A.owner, ',')) ) DEPT_ID
			, A.VALID_YN
	INTO    #TEMP_SCM_MST_SITE_ITEM_RESULT
	FROM    SCM_MST_SITE_ITEM A WITH(NOLOCK)
	        JOIN ( SELECT   DISTINCT
                            DIVISION_ID
                          , SCM_SITE_ID
                          , PROJECT_CODE
                          , ITEM_ID
                   FROM     #RAW_RESULT_DAILY 
                 ) B ON
                    A.DIVISION_ID  = B.DIVISION_ID
                AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                AND A.PROJECT_CODE = B.PROJECT_CODE
                AND A.ITEM_ID      = B.ITEM_ID
	WHERE A.DIVISION_ID = @p_division_id

--select * from #TEMP_SCM_MST_SITE_ITEM_RESULT;return;

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

--select * from #TEMP_PIC;return;

	IF OBJECT_ID(N'tempdb..#TEMP_TEAM_82', N'U') IS NOT NULL
		DROP TABLE #TEMP_TEAM_82;

    SELECT DISTINCT
          A.DIVISION_ID
	    , D.DEPT_ID
	    , D.DEPT_NAME_KO
	    , D.DEPT_NAME_EN
	    , D.DEPT_NAME_CN
    INTO    #TEMP_TEAM_82
    FROM	  SCM_MST_SITE A WITH(NOLOCK)
		    , SCM_MST_SSO_DEPT_INFO D WITH(NOLOCK)
    WHERE	A.SITE_TYPE   = 'SALES'
	    AND A.DEPT_ID     = D.DEPT_ID
	    AND A.DIVISION_ID = '82'

	IF OBJECT_ID(N'tempdb..#TEMP_TEAM_40', N'U') IS NOT NULL
		DROP TABLE #TEMP_TEAM_40;

    SELECT DISTINCT
              A.DIVISION_ID
		    , D.DEPT_ID
		    , D.DEPT_NAME_KO
		    , D.DEPT_NAME_EN
		    , D.DEPT_NAME_CN
    INTO    #TEMP_TEAM_40
    FROM	  SCM_MST_SITE_ITEM A WITH(NOLOCK)
		    , SCM_MST_SSO_USER_INFO B  WITH(NOLOCK)
		    , SCM_MST_SSO_DEPT_INFO D  WITH(NOLOCK)
    WHERE	B.USER_ID       = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,','))
	    AND B.DEPT_ID       = D.DEPT_ID
	    AND A.DIVISION_ID   = '40'

	IF OBJECT_ID(N'tempdb..#TEMP_TEAM_81', N'U') IS NOT NULL
		DROP TABLE #TEMP_TEAM_81;

	SELECT DISTINCT
              F.DIVISION_ID
		    , D.DEPT_ID
		    , D.DEPT_NAME_KO
		    , D.DEPT_NAME_EN
		    , D.DEPT_NAME_CN
    INTO    #TEMP_TEAM_81
	FROM    SCP_MST_FINAL_ITEM F WITH(NOLOCK)
			JOIN SCM_MST_SSO_USER_INFO U WITH(NOLOCK) ON
					F.ATTRIBUTE6 = U.USER_ID
			JOIN SCM_MST_SSO_DEPT_INFO D WITH(NOLOCK) ON
					U.DEPT_ID    = D.DEPT_ID
	WHERE	1=1
        AND F.DIVISION_ID = '81'


	DELETE  A
	FROM    #RAW_RTF_DAILY A
	        LEFT JOIN #TEMP_SCM_MST_SITE_ITEM_RTF B ON 
                    A.DIVISION_ID = B.DIVISION_ID 
                AND A.PROJECT_CODE = B.PROJECT_CODE 
                AND A.SCM_SITE_ID = B.SCM_SITE_ID 
                AND A.ITEM_ID = B.ITEM_ID
	WHERE   (A.VERSION_NO = 'CURRENT' AND A.PLAN_RESULT = 'P' AND ISNULL(B.VALID_YN,'') <> 'Y')
		OR B.DIVISION_ID IS NULL

	DELETE  A
	FROM    #RAW_RESULT_DAILY A
	        LEFT JOIN #TEMP_SCM_MST_SITE_ITEM_RESULT B ON 
                    A.DIVISION_ID = B.DIVISION_ID 
                AND A.PROJECT_CODE = B.PROJECT_CODE 
                AND A.SCM_SITE_ID = B.SCM_SITE_ID 
                AND A.ITEM_ID = B.ITEM_ID
	WHERE   B.DIVISION_ID IS NULL

print 'E4--' + convert(varchar(30), getdate(), 121)

	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_RP')
	BEGIN
		INSERT INTO #RAW_RTF_DAILY (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE, MEASURE,YYYYMMDD,QTY, PLAN_RESULT, GUBUN )
		SELECT   VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE
			,'MKT_FCST_RP' AS MEASURE, YYYYMMDD, QTY, PLAN_RESULT, 5
		FROM #RAW_RTF_DAILY A
		WHERE A.MEASURE = 'MKT_FCST'
			AND A.PLAN_RESULT = 'P'

		INSERT INTO #RAW_RESULT_DAILY (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE, MEASURE,YYYYMMDD,QTY, PLAN_RESULT, GUBUN )
		SELECT   VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE
			,'MKT_FCST_RP' AS MEASURE, YYYYMMDD, QTY, PLAN_RESULT, 5
		FROM #RAW_RESULT_DAILY A
		WHERE A.MEASURE = 'MKT_FCST'
			AND A.PLAN_RESULT = 'P'

		INSERT INTO #RAW_RTF_DAILY (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE, MEASURE,YYYYMMDD,QTY, PLAN_RESULT, GUBUN )
		SELECT   VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE
			,'MKT_FCST_RP' AS MEASURE, YYYYMMDD, QTY, PLAN_RESULT, 6
		FROM #RAW_RTF_DAILY A
		WHERE MEASURE = 'RTF_SYS_RP'
			AND A.PLAN_RESULT= 'R'

		INSERT INTO #RAW_RESULT_DAILY (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE, MEASURE,YYYYMMDD,QTY, PLAN_RESULT, GUBUN )
		SELECT   VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE
			,'MKT_FCST_RP' AS MEASURE, YYYYMMDD, QTY, PLAN_RESULT, 6
		FROM #RAW_RESULT_DAILY A
		WHERE MEASURE = 'RTF_SYS_RP'
			AND A.PLAN_RESULT= 'R'
	END


    CREATE CLUSTERED INDEX IDX_RTF ON #RAW_RTF_DAILY (division_id, project_code, scm_site_id, item_id )

	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_RP')
	BEGIN
		INSERT INTO #RAW_RESULT_DAILY
        (
			  VERSION_NO
			, CUTOFF_YYYYMMDD
			, DIVISION_ID
			, PROJECT_CODE
			, SCM_SITE_ID
			, PLANT_SITE_ID
			, ITEM_ID
			, INCOTERMS
			, DOM_EXP
			, FCST_TYPE
			, MEASURE
			, YYYYMMDD
			, QTY
			, CELL_QTY
			, PLAN_RESULT
			, GUBUN
        )
		    SELECT    A.VERSION_NO
                    , A.CUTOFF_YYYYMMDD
                    , A.DIVISION_ID
                    , A.PROJECT_CODE
                    , A.SCM_SITE_ID
                    , A.PLANT_SITE_ID
                    , A.ITEM_ID
                    , A.INCOTERMS
                    , A.DOM_EXP
                    , A.FCST_TYPE
			        , 'MKT_FCST_RP' AS MEASURE
                    , A.YYYYMMDD
                    , A.QTY
                    , A.QTY AS CELL_QTY
                    , A.PLAN_RESULT
                    , 5
		    FROM    #RAW_RESULT_DAILY A
		    WHERE   A.MEASURE = 'MKT_FCST'
			    AND A.PLAN_RESULT = 'P'

		INSERT INTO #RAW_RESULT_DAILY
        (
			  VERSION_NO
			, CUTOFF_YYYYMMDD
			, DIVISION_ID
			, PROJECT_CODE
			, SCM_SITE_ID
			, PLANT_SITE_ID
			, ITEM_ID
			, INCOTERMS
			, DOM_EXP
			, FCST_TYPE
			, MEASURE
			, YYYYMMDD
			, QTY
			, CELL_QTY
			, PLAN_RESULT
			, GUBUN
        )
		    SELECT    A.VERSION_NO
                    , A.CUTOFF_YYYYMMDD
                    , A.DIVISION_ID
                    , A.PROJECT_CODE
                    , A.SCM_SITE_ID
                    , A.PLANT_SITE_ID
                    , A.ITEM_ID
                    , A.INCOTERMS
                    , A.DOM_EXP
                    , A.FCST_TYPE
			        , 'MKT_FCST_RP' AS MEASURE
                    , A.YYYYMMDD
                    , A.QTY
                    , A.QTY AS CELL_QTY
                    , A.PLAN_RESULT
                    , 6
		    FROM    #RAW_RESULT_DAILY A
		    WHERE   MEASURE = 'RTF_SYS_RP'
			    AND A.PLAN_RESULT= 'R'
	END

    CREATE CLUSTERED INDEX IDX_RESULT ON #RAW_RESULT_DAILY (division_id, project_code, scm_site_id, item_id )

--TESTING : OK
--select * from #RAW_RTF_DAILY;return;
--select * from #RAW_RESULT_DAILY;return;
    
    -- 필터링 begin (나중에 추가된 로직 적용이 쉬우서 이곳에서 필터링으로 처리)
	BEGIN
		--@p_item_type begin
		DELETE A
		FROM #RAW_RTF_DAILY A
		LEFT JOIN #TEMP_DM_MST_ITEM_SINGLE_V_RTF B ON A.ITEM_ID = B.ITEM_ID
		LEFT JOIN (	SELECT DISTINCT token
							FROM dbo.String_Split('H,P',',') --H=Semi product, P=Product (Q=상품, R=부품만 제외)
						) C	ON B.ITEM_TYPE = C.TOKEN
		WHERE C.TOKEN IS NULL

		DELETE A
		FROM #RAW_RESULT_DAILY A
		LEFT JOIN #TEMP_DM_MST_ITEM_SINGLE_V_RESULT B ON A.ITEM_ID = B.ITEM_ID
		LEFT JOIN (	SELECT DISTINCT token
							FROM dbo.String_Split('H,P',',') --H=Semi product, P=Product (Q=상품, R=부품만 제외)
						) C	ON B.ITEM_TYPE = C.TOKEN
		WHERE C.TOKEN IS NULL
        --@p_item_type end

        --자동차사업부는 Product 만 조회한다 begin
		DELETE  A
		FROM    #RAW_RTF_DAILY A
				JOIN #TEMP_DM_MST_ITEM_SINGLE_V_RTF B ON
                        A.ITEM_ID = B.ITEM_ID
                    AND B.ITEM_TYPE <> 'P'
        WHERE   A.DIVISION_ID = '81'

		DELETE  A
		FROM    #RAW_RESULT_DAILY A
				JOIN #TEMP_DM_MST_ITEM_SINGLE_V_RESULT B ON
                        A.ITEM_ID = B.ITEM_ID
                    AND B.ITEM_TYPE <> 'P'
        WHERE   A.DIVISION_ID = '81'
        --자동차사업부는 Product 만 조회한다 end

		--자동차 이외 사업부의 FCST Type 을 MPS 로 제한한다 begin
		DELETE  A
		FROM    #RAW_RTF_DAILY A
		WHERE   A.DIVISION_ID <> '81'
			AND A.FCST_TYPE   <> 'MPS'

		DELETE  A
		FROM    #RAW_RESULT_DAILY A
		WHERE   A.DIVISION_ID <> '81'
			AND A.FCST_TYPE   <> 'MPS'
		--자동차 이외 사업부의 FCST Type 을 MPS 로 제한한다 end
	END
    -- 필터링 end (나중에 추가된 로직 적용이 쉬우서 이곳에서 필터링으로 처리)

--TESTING : OK
--select * from #RAW_RTF_DAILY;return;
--select * from #RAW_RESULT_DAILY where PACK_GROUP = ;return;

	-- 계획구간 PRICE 처리
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'LOC' )
	BEGIN
		INSERT INTO #RAW_RTF_DAILY
        (
				VERSION_NO
			, CUTOFF_YYYYMMDD
			, DIVISION_ID
			, PROJECT_CODE
			, SCM_SITE_ID
			, PLANT_SITE_ID
			, ITEM_ID
			, INCOTERMS
			, DOM_EXP
			, FCST_TYPE
			, MEASURE
			, YYYYMMDD
			, QTY
			, CELL_QTY
			, PLAN_RESULT
			, GUBUN
        )
			SELECT    A.VERSION_NO
                    , A.CUTOFF_YYYYMMDD
					, A.DIVISION_ID
					, A.PROJECT_CODE
					, A.SCM_SITE_ID
					, A.PLANT_SITE_ID
					, A.ITEM_ID
					, A.INCOTERMS
					, A.DOM_EXP
					, A.FCST_TYPE
					, C.MEASURE
					, A.YYYYMMDD
					, C.PRICE
					, C.PRICE
					, 'P'
					, 9
			FROM
                    (
						SELECT   DISTINCT
                                    A.VERSION_NO
								, A.CUTOFF_YYYYMMDD
								, A.DIVISION_ID
								, A.PROJECT_CODE
								, A.SCM_SITE_ID
								, A.PLANT_SITE_ID
								, A.ITEM_ID
								, A.INCOTERMS
								, A.DOM_EXP
								, A.FCST_TYPE
								, A.YYYYMMDD
                        FROM	#RAW_RTF_DAILY A
						WHERE   A.YYYYMMDD >= CONVERT(NCHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( A.CUTOFF_YYYYMMDD, 'MON')), 112)
                            AND A.YYYYMMDD <= @p_to_yyyymmdd
							AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP' )
					) A
				    JOIN SCM_SYS_CALENDAR_M B (NOLOCK) ON
                            A.YYYYMMDD = B.BASIS_YYYYMMDD
				    JOIN SCM_MST_FUTURE_PRICE C (NOLOCK) ON
                            A.DIVISION_ID		= C.DIVISION_ID
						AND A.PROJECT_CODE		= C.PROJECT_CODE
						AND A.SCM_SITE_ID		= C.SCM_SITE_ID
						AND A.PLANT_SITE_ID		= C.PLANT_SITE_ID
						AND A.ITEM_ID			= C.ITEM_ID
						AND A.INCOTERMS			= C.INCOTERMS
						AND A.DOM_EXP			= C.DOM_EXP
						AND A.FCST_TYPE			= C.FCST_TYPE
						AND B.basis_start_date	= C.YYYYMMDD
						AND C.YYYYMMDD			<= @p_to_yyyymmdd
				    JOIN #SELECT_MEASURE D ON
                            C.MEASURE = D.MEASURE

		INSERT INTO #RAW_RESULT_DAILY
        (
				VERSION_NO
			, CUTOFF_YYYYMMDD
			, DIVISION_ID
			, PROJECT_CODE
			, SCM_SITE_ID
			, PLANT_SITE_ID
			, ITEM_ID
			, INCOTERMS
			, DOM_EXP
			, FCST_TYPE
			, MEASURE
			, YYYYMMDD
			, QTY
			, CELL_QTY
			, PLAN_RESULT
			, GUBUN
        )
			SELECT    A.VERSION_NO
                    , A.CUTOFF_YYYYMMDD
					, A.DIVISION_ID
					, A.PROJECT_CODE
					, A.SCM_SITE_ID
					, A.PLANT_SITE_ID
					, A.ITEM_ID
					, A.INCOTERMS
					, A.DOM_EXP
					, A.FCST_TYPE
					, C.MEASURE
					, A.YYYYMMDD
					, C.PRICE
					, C.PRICE
					, 'P'
					, 9
			FROM
                    (
						SELECT   DISTINCT
                                    A.VERSION_NO
								, A.CUTOFF_YYYYMMDD
								, A.DIVISION_ID
								, A.PROJECT_CODE
								, A.SCM_SITE_ID
								, A.PLANT_SITE_ID, A.ITEM_ID
								, A.INCOTERMS
								, A.DOM_EXP
								, A.FCST_TYPE
								, A.YYYYMMDD
                        FROM	#RAW_RESULT_DAILY A
						WHERE   1=1
                            AND A.YYYYMMDD >= @V_THIS_MONDAY
							AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP' )
					) A
				    JOIN SCM_SYS_CALENDAR_M B (NOLOCK) ON
                            A.YYYYMMDD = B.BASIS_YYYYMMDD
				    JOIN SCM_MST_FUTURE_PRICE C (NOLOCK) ON
                            A.DIVISION_ID		= C.DIVISION_ID
						AND A.PROJECT_CODE		= C.PROJECT_CODE
						AND A.SCM_SITE_ID		= C.SCM_SITE_ID
						AND A.PLANT_SITE_ID		= C.PLANT_SITE_ID
						AND A.ITEM_ID			= C.ITEM_ID
						AND A.INCOTERMS			= C.INCOTERMS
						AND A.DOM_EXP			= C.DOM_EXP
						AND A.FCST_TYPE			= C.FCST_TYPE
						AND B.basis_start_date	= C.YYYYMMDD
						AND C.YYYYMMDD			<= @p_to_yyyymmdd
				    JOIN #SELECT_MEASURE D ON
                            C.MEASURE = D.MEASURE
    END
--TESTING : OK
--select * from #RAW_RTF_DAILY;
--select * from #RAW_RESULT_DAILY;return;

    ------------------------------------------------------------------------------------------
    --	필요없는 메저 삭제
    ------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY'))
	BEGIN
		INSERT INTO #RAW_RTF_DAILY
        (
				VERSION_NO
			, CUTOFF_YYYYMMDD
			, DIVISION_ID
			, PROJECT_CODE
			, SCM_SITE_ID
			, PLANT_SITE_ID
			, ITEM_ID
			, INCOTERMS
			, DOM_EXP
			, FCST_TYPE
			, MEASURE
			, YYYYMMDD
			, QTY
			, CELL_QTY
			, PLAN_RESULT
			, GUBUN
		)
		SELECT    A.VERSION_NO
                , A.CUTOFF_YYYYMMDD
                , A.DIVISION_ID
                , A.PROJECT_CODE
                , A.SCM_SITE_ID
                , A.PLANT_SITE_ID
                , A.ITEM_ID
				, A.INCOTERMS
                , A.DOM_EXP
                , A.FCST_TYPE
                , B.MEASURE_CALC
                , A.YYYYMMDD
                , A.QTY
				, CASE	WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
							CASE WHEN CHARINDEX('Cell',   C.ITEM_CLASS_NAME) > 0 AND D.CELL_PER_CAR > 0 THEN QTY / D.CELL_PER_CAR
								WHEN  CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0  AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0 THEN QTY/ ( D.CELL_PER_CAR/ D.CELL_PER_MODULE )
								WHEN  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0  THEN A.QTY
								ELSE 0
							END
						WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%' THEN
							CASE WHEN CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
								WHEN ( CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', C.ITEM_CLASS_NAME) > 0 ) AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
								ELSE 0
							END
						WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82' THEN A.QTY * ISNULL(C.CELL_QUANTITY, 1)
						-- 20211119 ROSIA27 [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
						WHEN B.MEASURE_CALC = 'RTF_ENERGY' THEN
							CASE WHEN ISNUMERIC(C.ENERGE) > 0
								THEN (C.ENERGE * A.QTY)/1000
							END
						ELSE 0
					END
				, A.PLAN_RESULT
                , 7
		FROM	#RAW_RTF_DAILY A WITH(NOLOCK)
			    JOIN ( SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP'
								    ELSE 'RTF_SYS_RP'
								    END AS MEASURE_ORI
						    , A.MEASURE AS MEASURE_CALC
					    FROM #SELECT_MEASURE A
					    WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY')
					    ) B ON A.MEASURE = B.MEASURE_ORI
			    JOIN #TEMP_DM_MST_ITEM_SINGLE_V_RTF C ON
                        A.DIVISION_ID = C.DIVISION_ID
                    AND A.ITEM_ID = C.ITEM_ID
			    LEFT JOIN #TEMP_SCM_MST_SITE_ITEM_RTF D ON
                        A.DIVISION_ID = D.DIVISION_ID
                    AND A.SCM_SITE_ID = D.SCM_SITE_ID
                    AND A.PROJECT_CODE = D.PROJECT_CODE
                    AND A.ITEM_ID = D.ITEM_ID
		WHERE A.MEASURE IN ( 'MKT_FCST_RP', 'RTF_SYS_RP' )

		INSERT INTO #RAW_RESULT_DAILY
        (
				VERSION_NO
			, CUTOFF_YYYYMMDD
			, DIVISION_ID
			, PROJECT_CODE
			, SCM_SITE_ID
			, PLANT_SITE_ID
			, ITEM_ID
			, INCOTERMS
			, DOM_EXP
			, FCST_TYPE
			, MEASURE
			, YYYYMMDD
			, QTY
			, CELL_QTY
			, PLAN_RESULT
			, GUBUN
        )
		SELECT    A.VERSION_NO
                , A.CUTOFF_YYYYMMDD
                , A.DIVISION_ID
                , A.PROJECT_CODE
                , A.SCM_SITE_ID
                , A.PLANT_SITE_ID
                , A.ITEM_ID
				, A.INCOTERMS
                , A.DOM_EXP
                , A.FCST_TYPE
                , B.MEASURE_CALC
                , A.YYYYMMDD
                , A.QTY
				,CASE	WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
							CASE WHEN CHARINDEX('Cell',   C.ITEM_CLASS_NAME) > 0 AND D.CELL_PER_CAR > 0 THEN QTY / D.CELL_PER_CAR
								WHEN  CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0  AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0 THEN QTY/ ( D.CELL_PER_CAR/ D.CELL_PER_MODULE )
								WHEN  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0  THEN A.QTY
								ELSE 0
							END
						WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%' THEN
							CASE WHEN CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
								WHEN ( CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', C.ITEM_CLASS_NAME) > 0 ) AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
								ELSE 0
							END
						WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82' THEN A.QTY * ISNULL(C.CELL_QUANTITY, 1)
						-- 20211119 ROSIA27 [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
						WHEN B.MEASURE_CALC = 'RTF_ENERGY' THEN
							CASE WHEN ISNUMERIC(C.ENERGE) > 0
								THEN (C.ENERGE * A.QTY)/1000
							END
						ELSE 0
				END
				, A.PLAN_RESULT
                , 7
		FROM	#RAW_RESULT_DAILY A WITH(NOLOCK)
			    JOIN ( SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP'
								    ELSE 'RTF_SYS_RP'
								    END AS MEASURE_ORI
						    , A.MEASURE AS MEASURE_CALC
					    FROM #SELECT_MEASURE A
					    WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY')
					    ) B ON A.MEASURE = B.MEASURE_ORI
			    JOIN #TEMP_DM_MST_ITEM_SINGLE_V_RESULT C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
			    LEFT JOIN #TEMP_SCM_MST_SITE_ITEM_RESULT D ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.ITEM_ID = D.ITEM_ID
		WHERE A.MEASURE IN ( 'MKT_FCST_RP', 'RTF_SYS_RP' )
	END

	DELETE A
	FROM #RAW_RTF_DAILY A
	JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
	WHERE B.SYSTEM_ADD = 'Y'

	DELETE A
	FROM #RAW_RESULT_DAILY A
	JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
	WHERE B.SYSTEM_ADD = 'Y'

--TESTING : OK
--select * from #RAW_RTF_DAILY;
--select * from #RAW_RESULT_DAILY;return;

    UPDATE #RAW_RTF_DAILY SET
		  CELL_TYPE  = C.SEGMENT2
    FROM    #RAW_RTF_DAILY A
            LEFT JOIN
                (
                    SELECT DISTINCT
                              D.DIVISION_ID
                            , D.ITEM_ID
                            , E.SEGMENT2
                    FROM    #TEMP_DM_MST_ITEM_SINGLE_V_RTF D
                            JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E WITH(NOLOCK) ON
                                    D.CELL_TYPE = E.SEGMENT1
                                AND E.LOOKUP_TYPE = 'CELL_TYPE'
                ) C ON
					A.DIVISION_ID = C.DIVISION_ID
				AND A.ITEM_ID = C.ITEM_ID

    UPDATE #RAW_RESULT_DAILY SET
		  CELL_TYPE  = C.SEGMENT2
    FROM    #RAW_RESULT_DAILY A
            LEFT JOIN
                (
                    SELECT DISTINCT
                              D.DIVISION_ID
                            , D.ITEM_ID
                            , E.SEGMENT2
                    FROM    #TEMP_DM_MST_ITEM_SINGLE_V_RESULT D
                            JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E WITH(NOLOCK) ON
                                    D.CELL_TYPE = E.SEGMENT1
                                AND E.LOOKUP_TYPE = 'CELL_TYPE'
                ) C ON
					A.DIVISION_ID = C.DIVISION_ID
				AND A.ITEM_ID = C.ITEM_ID

--TESTING : OK
--select * from #RAW_RTF_DAILY;
--select * from #RAW_RESULT_DAILY where SCM_SITE_ID = 'HLGP_KR_CHU';return;

	------------------------------------------------------------------------------------------
	--	컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
	------------------------------------------------------------------------------------------


	-- 컬럼리스트 생성
	BEGIN
		DECLARE @V_SQL_TEXT          AS NVARCHAR(MAX)   = N'';
		DECLARE @V_DEF_SQL_TEXT      AS NVARCHAR(MAX)   = N'';
		DECLARE @V_SQL_TEXT_2        AS NVARCHAR(MAX)   = N'';

		DECLARE @V_COLUMN_NAME		 AS NVARCHAR(100)   = N'';
		DECLARE @V_COLUMN            AS NVARCHAR(1000)  = N'';
		DECLARE @V_COLUMN_RTF        AS NVARCHAR(1000)  = N'';
		DECLARE @V_COLUMN_RESULT     AS NVARCHAR(1000)  = N'';
		DECLARE @V_ORDERBY           AS NVARCHAR(1000)  = N'';
		DECLARE @V_COLUMN_TEXT       AS NVARCHAR(1000)  = N'';
		DECLARE @V_PV_COLUMN_NAME    AS NVARCHAR(100)   = N'';
		DECLARE @V_PV_NAME			 AS NVARCHAR(50)    = N'';
		DECLARE @V_COLUMN_TYPE       AS NVARCHAR(50)    = N'';
		DECLARE @V_COLUMN_VALUE      AS NVARCHAR(50)    = N'';
		DECLARE @V_SORT_ORDER_NO     AS NVARCHAR(50)    = N'';

--print '@p_Program_Id : ' + @p_Program_Id + CHAR(13) + CHAR(10) ;
--print '@p_sheet_name : ' + @p_sheet_name;return;

		-----	일반 컬럼 -----------------------------------------------------------------------------------------------------------
		SET @V_COLUMN_NAME = '';
		SET @V_COLUMN = '';
		SET @V_ORDERBY = '';

		SELECT   @i_Count = Count(*)
		FROM    [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
		WHERE   1 = 1
			AND U.PROGRAM_ID                    = @p_Program_Id
			AND U.SHEET_NAME                    = @p_sheet_name
			AND U.USER_ID                       = @p_created_by
			AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
--print '@i_Count : ' + CONVERT(VARCHAR, @i_Count);return;

-- Default Columns beigin ----------------------------------------------------------------------------------------------------------
        SET @V_DEF_COLUMNS_RAW = '';
        SET @V_DEF_COLUMNS_SUM = '';
        SET @V_DEF_ORDERS_RAW  = '';

		SELECT    @V_DEF_COLUMNS_RAW = @V_DEF_COLUMNS_RAW  + '[' + COLUMN_NAME + '],'
                , @V_DEF_COLUMNS_SUM = @V_DEF_COLUMNS_SUM  + '[' + COLUMN_NAME + '],'
                , @V_DEF_ORDERS_RAW  = @V_DEF_ORDERS_RAW   + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
		FROM
		(
			-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
			SELECT --TOP 100
						C.SORT_ORDER_NO
					, C.COLUMN_NAME
                    , C.DATA_SORT_METHOD_CODE
			FROM    [SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
			WHERE   1 = 1
				AND C.PROGRAM_ID   = @p_Program_Id
				AND C.SHEET_NAME   = @p_sheet_name
				AND C.DEFAULT_FLAG = 'Y'
				AND C.VALID_YN     = 'Y'
		) tbColList
		ORDER BY    SORT_ORDER_NO

--print '@V_DEF_COLUMNS_RAW : ' + @V_DEF_COLUMNS_RAW
--print '@V_DEF_COLUMNS_SUM : ' + @V_DEF_COLUMNS_SUM;return;
-- Default Columns end ----------------------------------------------------------------------------------------------------------
--print '@i_Count : ' + convert(nvarchar, @i_Count);return;
				        --SELECT    U.*
            --                    , C.COLUMN_NAME
				        --FROM    [dbo].[SCM_MST_TITLESET_USER ] U WITH(NOLOCK)
            --                    INNER JOIN [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK) ON
            --                            U.PROGRAM_ID                    = C.PROGRAM_ID
						        --      AND U.SHEET_NAME                    = C.SHEET_NAME
						        --      AND U.COLUMN_NAME                   = C.COLUMN_NAME
						        --      AND C.PROGRAM_ID                    = @p_Program_Id
						        --      AND C.SHEET_NAME                    = @p_sheet_name
						        --      AND U.USER_ID                       = @p_created_by
						        --      AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            --                        AND C.VALID_YN                      = 'Y'
            --                        AND C.VISIBLE_FLAG                  = 'Y';
            --                        return;

		IF @i_Count = 0
		BEGIN
			SET @V_COLUMNS_RAW = @V_DEF_COLUMNS_RAW
            SET @V_COLUMNS_SUM = @V_DEF_COLUMNS_SUM
		END
		ELSE
		BEGIN
			SELECT    @V_COLUMNS_RAW = @V_COLUMNS_RAW   + '[' + COLUMN_NAME + '],'
					, @V_COLUMNS_SUM = @V_COLUMNS_SUM   + '[' + COLUMN_NAME + '],'
			FROM
				    (
					            -- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
				        SELECT    U.SORT_ORDER_NO
                                , C.COLUMN_NAME
                                , U.DATA_SORT_METHOD_CODE
				        FROM    [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
                                INNER JOIN [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK) ON
                                        U.PROGRAM_ID                    = C.PROGRAM_ID
						            AND U.SHEET_NAME                    = C.SHEET_NAME
						            AND U.COLUMN_NAME                   = C.COLUMN_NAME
						            AND C.PROGRAM_ID                    = @p_Program_Id
						            AND C.SHEET_NAME                    = @p_sheet_name
						            AND U.USER_ID                       = @p_created_by
						            AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                                    AND C.VALID_YN                      = 'Y'
                                    AND C.VISIBLE_FLAG                  = 'Y'
				    ) A
			ORDER BY SORT_ORDER_NO
		END

--print '@V_COLUMNS_RAW : ' + @V_COLUMNS_RAW;return;

		SELECT @V_DEF_COLUMNS_RAW   = LEFT(@V_DEF_COLUMNS_RAW,  LEN(@V_DEF_COLUMNS_RAW)-1)
		SELECT @V_DEF_ORDERS_RAW    = LEFT(@V_DEF_ORDERS_RAW,   LEN(@V_DEF_ORDERS_RAW)-1)

		SELECT @V_COLUMNS_RAW       = LEFT(@V_COLUMNS_RAW,      LEN(@V_COLUMNS_RAW)-1)


		SELECT @V_DEF_COLUMNS_RAW   = REPLACE(@V_DEF_COLUMNS_RAW,   '[VERSION_NO]', '[VERSION_SORT],[VERSION_NO]')
		SELECT @V_DEF_COLUMNS_RAW   = REPLACE(@V_DEF_COLUMNS_RAW,   '[MEASURE]',    '[MEASURE_GROUP],[MEASURE],[SORT_ORDER_NO]')

		SELECT @V_COLUMNS_RAW       = REPLACE(@V_COLUMNS_RAW,       '[VERSION_NO]', '[VERSION_SORT],[VERSION_NO]')
		SELECT @V_COLUMNS_RAW       = REPLACE(@V_COLUMNS_RAW,       '[MEASURE]',    '[MEASURE_GROUP],[MEASURE],[SORT_ORDER_NO]')


        SELECT @V_DEF_ORDERS_RAW    = REPLACE(@V_DEF_ORDERS_RAW,    '[VERSION_NO]', '[VERSION_SORT] DESC,[VERSION_NO]')
		SELECT @V_DEF_ORDERS_RAW    = REPLACE(@V_DEF_ORDERS_RAW,    '[MEASURE]',    '[SORT_ORDER_NO]')


		SELECT @V_DEF_COLUMNS_SUM   = LEFT(@V_DEF_COLUMNS_SUM,  LEN(@V_DEF_COLUMNS_SUM)-1)
		SELECT @V_COLUMNS_SUM       = LEFT(@V_COLUMNS_SUM,      LEN(@V_COLUMNS_SUM)-1)


		SELECT @V_DEF_COLUMNS_SUM   = REPLACE(@V_DEF_COLUMNS_SUM,   '[VERSION_NO]', '[VERSION_SORT],[VERSION_NO]')
		SELECT @V_DEF_COLUMNS_SUM   = REPLACE(@V_DEF_COLUMNS_SUM,   '[MEASURE]',    '[MEASURE_GROUP],[MEASURE],[SORT_ORDER_NO]')

		SELECT @V_COLUMNS_SUM       = REPLACE(@V_COLUMNS_SUM,       '[VERSION_NO]', '[VERSION_SORT],[VERSION_NO]')
		SELECT @V_COLUMNS_SUM       = REPLACE(@V_COLUMNS_SUM,       '[MEASURE]',    '[MEASURE_GROUP],[MEASURE],[SORT_ORDER_NO]')
	END	--	컬럼생성 끝	---------------------------------------------------------------------------------------------------------------------
--print '@V_COLUMNS_RAW : ' + @V_COLUMNS_RAW;
--print '@V_COLUMNS_SUM : ' + @V_COLUMNS_SUM;return;

--SELECT * FROM #SELECT_MEASURE
--SELECT @ORDERlIST

	DECLARE @V_SELECT_COLS      NVARCHAR(4000)
	DECLARE @V_SELECT_RAW       NVARCHAR(4000)

	DECLARE @V_DEF_SELECT_COLS  NVARCHAR(4000)
	DECLARE @V_DEF_SELECT_RAW   NVARCHAR(4000)
	DECLARE @V_DEF_GROUPBY_RAW	NVARCHAR(4000)

    IF OBJECT_ID (N'tempdb..#T_COLUMN_SETUP_RAW', N'U') IS NOT NULL
		DROP TABLE #T_COLUMN_SETUP_RAW

	CREATE TABLE #T_COLUMN_SETUP_RAW
    (
		  TBL_ALIAS			NVARCHAR(MAX)
		, COLUMN_NAME		NVARCHAR(MAX)
		, COLUMN_STRING		NVARCHAR(MAX)
		, SORT_KEY			INT
	)

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DIVISION_ID',						N'A.DIVISION_ID')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_ID',							N'CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID WHEN A.DIVISION_ID = ''82'' THEN B.DEPT_ID ELSE CC.DEPT_ID END AS DEPT_ID')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'UPPER_DEPT_ID',					N'CASE WHEN A.DIVISION_ID = ''81'' THEN O.DEPT_ID ELSE '''' END AS UPPER_DEPT_ID')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'END_CUSTOMER',						N'B.END_CUSTOMER')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'COUNTRY_NAME',						N'J.COUNTRY_NAME')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CITY_NAME',						N'H.CITY_NAME')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCM_SITE_ID',						N''''' AS SCM_SITE_ID')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_CODE',						N'CASE WHEN A.DIVISION_ID = ''40'' THEN '''' ELSE A.PROJECT_CODE END AS PROJECT_CODE')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_NAME',						N'CASE WHEN A.DIVISION_ID = ''40'' THEN '''' ELSE G.PROJECT_NAME END AS PROJECT_NAME')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_STATUS',					N'G.PROJECT_STATUS')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_OWNER',					N'G.PROJECT_OWNER')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_ID',							N'A.ITEM_ID')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_NAME',						N'ISNULL(D.ITEM_NAME, '''') AS ITEM_NAME')
	--NICKNAME기준 INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_ID',						    N'ISNULL(CASE WHEN A.DIVISION_ID = ''40'' AND FF.OPERATION_GROUP = ''P'' AND E.SEGMENT2 = ''Cyl'' THEN ''''                   ELSE A.ITEM_ID END,   '''') AS ITEM_ID')
	--NICKNAME기준 INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_NAME',						N'ISNULL(CASE WHEN A.DIVISION_ID = ''40'' AND FF.OPERATION_GROUP = ''P'' AND E.SEGMENT2 = ''Cyl'' THEN ''''                   ELSE D.ITEM_NAME END, '''') AS ITEM_NAME')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'NICK_NAME',						N'ISNULL(CASE WHEN A.DIVISION_ID = ''40'' AND FF.OPERATION_GROUP = ''P'' AND E.SEGMENT2 = ''Cyl'' THEN FF.CELL_MODEL_NICKNAME ELSE D.NICK_NAME END, '''') AS NICK_NAME') --소형&Pack&Cylinder
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'INCOTERMS',						N'A.INCOTERMS')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_TYPE',						N'ISNULL(D.ITEM_TYPE, '''') AS ITEM_TYPE')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FCST_TYPE',						N'A.FCST_TYPE')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DOM_EXP',							N'A.DOM_EXP')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PLANT_SITE_ID',					N'A.PLANT_SITE_ID')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'VERSION_NO',						N'A.VERSION_NO')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_GROUP',						N'C.CUST_GROUP')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_GROUP_DTL',					N'C.CUST_GROUP_DTL')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'OWNER',							N'IIF(A.DIVISION_ID = ''40'' OR A.DIVISION_ID = ''81'', CC.USER_NAME, C.OWNER_NAME) AS OWNER')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ROUTE',							N'C.ROUTE')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MDM_PROJECT_NAME',					N'D.MDM_PROJECT_NAME')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MIN_CAPACITY',						N'D.MIN_CAPACITY')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_PRODUCT_GROUP',		N'D.FORECAST_INFO_PRODUCT_GROUP')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_CELL_MODEL',			N'C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL')
	--NICKNAME기준 INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_CELL_MODEL',			N'ISNULL(CASE WHEN A.DIVISION_ID = ''40'' AND FF.OPERATION_GROUP = ''P'' AND E.SEGMENT2 = ''Cyl'' THEN ''''                   ELSE C.ATTRIBUTE5 END, '''') AS FORECAST_INFO_CELL_MODEL')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_CELL_PACK_COUNT',	N'D.FORECAST_INFO_CELL_PACK_COUNT')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_ALL',				N'D.FORECAST_INFO_SPEC + D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL')
	--NICKNAME기준 INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_ALL',			    N'ISNULL(CASE WHEN A.DIVISION_ID = ''40'' AND FF.OPERATION_GROUP = ''P'' AND E.SEGMENT2 = ''Cyl'' THEN ''''                   ELSE (D.FORECAST_INFO_SPEC + D.FORECAST_INFOR_VERSION) END, '''') AS FORECAST_INFO_ALL')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_SPEC',				N'D.FORECAST_INFO_SPEC')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFOR_VERSION',			N'D.FORECAST_INFOR_VERSION')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BASIC_NICKNAME_CELL',				N'ISNULL(F.BASIC_NICKNAME_CELL,'''') AS BASIC_NICKNAME_CELL')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'VMI_YN',							N'B.VMI_YN')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_TYPE',						N'E.SEGMENT2 AS CELL_TYPE')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_PER_CAR',						N'C.CELL_PER_CAR')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_PER_MODULE',					N'C.CELL_PER_MODULE')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MODULE_PER_CAR',					N'CASE WHEN C.CELL_PER_MODULE  <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ENERGE',							N'D.ENERGE')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_QUANTITY',					N'D.CELL_QUANTITY')
	--NICKNAME기준 INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_QUANTITY',			        N'ISNULL(CASE WHEN A.DIVISION_ID = ''40'' AND FF.OPERATION_GROUP = ''P'' AND E.SEGMENT2 = ''Cyl'' THEN ''''                   ELSE D.CELL_QUANTITY END, '''') AS CELL_QUANTITY')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PRIORITY',							N'C.ATTRIBUTE7 AS PRIORITY')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MEASURE',							N'A.MEASURE')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MEASURE_GROUP',					N'M.MEASURE_GROUP')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DMS_SALES',						N'ISNULL(C.ATTRIBUTE1,'''') AS DMS_SALES')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DMS_CUSTOMER',						N'ISNULL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'REPORT_GROUP6',					N'C.REPORT_GROUP6')
	--INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'TEAM_NAME_KO',						N'N.DEPT_NAME_KO AS TEAM_NAME_KO')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'TEAM_NAME_KO',						N'IIF(A.DIVISION_ID = ''81'', NN.DEPT_NAME_KO, N.DEPT_NAME_KO) AS TEAM_NAME_KO')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_NAME_KO',						N'O.DEPT_NAME_KO')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_BIZ_TYPE',			N'D.FORECAST_INFO_BIZ_TYPE')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'OPERATION_GROUP',					N'F.OPERATION_GROUP')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'OPERATION_GROUP_NAME',				N'F.OPERATION_GROUP_NAME')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PACK_GROUP',				        N'F.GROUP_CODE2 AS PACK_GROUP')--자동차


	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCP_USE_YN',						N'
                                                    , CASE
                                                        WHEN       (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''Y''                 AND A.MEASURE IN (''VMI_In_Plan''))
                                                                OR (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''N''                 AND A.MEASURE IN (''RTF_SYS_RP''))
                                                                OR (A.DIVISION_ID     IN (''40'') AND (F.OPERATION_GROUP = ''P''))     --소형 & Pack 은 FG 데이터에서 가져왔으므로 VMI_YN = ''Y'' 로 적용
                                                                --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID  = ''HLGP_KR_CHU'' AND A.MEASURE IN (''VMI_In_Plan''))
                                                                --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID <> ''HLGP_KR_CHU'' AND A.MEASURE IN (''RTF_SYS_RP''))
                                                                --OR (A.DIVISION_ID NOT IN (''40'', ''81'')                              AND A.MEASURE IN (''RTF_SYS_RP''))
                                                                OR (A.DIVISION_ID NOT IN (''40'')                                        AND A.MEASURE IN (''RTF_SYS_RP''))
                                                        THEN ''Y''
                                                        ELSE ''N''
                                                      END AS SCP_USE_YN')

	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'VERSION_SORT',						N'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCP_EXTRA_SPEC',					N'D.SCP_EXTRA_SPEC')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SALES_COMPANY',					N'C.SALES_COMPANY')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SOLDTO_CODE',						N'K.SOLDTO_CODE')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_CELL',							N'C.ATTRIBUTE8 AS KWH_CELL')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_MODULE',						N'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND ISNULL(C.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(C.CELL_PER_MODULE * C.ATTRIBUTE8)) ELSE NULL END AS KWH_MODULE')
	INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_PACK',							N'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND ISNULL(C.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(C.CELL_PER_CAR * C.ATTRIBUTE8)) ELSE NULL END AS KWH_PACK')
    INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CATEGORY_CODE',					N'T.CATEGORY_CODE')
    INSERT INTO #T_COLUMN_SETUP_RAW ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CATEGORY_NAME',					N'T.CATEGORY_NAME')


    IF OBJECT_ID (N'tempdb..#T_DEF_COL_RAW', N'U') IS NOT NULL
		DROP TABLE #T_DEF_COL_RAW

	SELECT    B.COLUMN_STRING
            , B.COLUMN_NAME
            , ROW_NUMBER() OVER ( ORDER BY B.SORT_KEY ) AS SEQ
	INTO    #T_DEF_COL_RAW
	FROM    DBO.UF_FX_String_Split(@V_DEF_COLUMNS_RAW, ',') A
			JOIN #T_COLUMN_SETUP_RAW B ON
                    replace(replace(A.TOKEN, '[', ''), ']','') = B.COLUMN_NAME

--TESTING : OK
--select * from #T_DEF_COL_RAW;return;

    IF OBJECT_ID (N'tempdb..#T_COL_RAW', N'U') IS NOT NULL
		DROP TABLE #T_COL_RAW

	SELECT    B.COLUMN_STRING
            , B.COLUMN_NAME
            , ROW_NUMBER() OVER ( ORDER BY B.SORT_KEY ) AS SEQ
	INTO    #T_COL_RAW
	FROM    DBO.UF_FX_String_Split(@V_COLUMNS_RAW, ',') A
			JOIN #T_COLUMN_SETUP_RAW B ON
                    replace(replace(A.TOKEN, '[', ''), ']','') = B.COLUMN_NAME


--TESTING : OK
--select * from #T_COL_RAW;return;
--print '@V_COLUMNS_RAW : ' + @V_COLUMNS_RAW;return;


	DECLARE @I     INT, @CNT     INT
	DECLARE @DEF_I INT, @DEF_CNT INT

	SELECT    @I                = 1
            , @CNT              = COUNT(*)
            , @V_SELECT_RAW     = ''
            , @V_SELECT_COLS    = ''
	FROM #T_COL_RAW

	SELECT    @DEF_I                = 1
            , @DEF_CNT              = COUNT(*)
            , @V_DEF_SELECT_RAW     = ''
            , @V_DEF_SELECT_COLS    = ''
            , @V_DEF_GROUPBY_RAW    = ''
	FROM #T_DEF_COL_RAW

	WHILE ( @I <= @CNT )
	BEGIN
		SELECT    @V_SELECT_RAW     = @V_SELECT_RAW
                                        + CASE WHEN @I = 1 THEN '' ELSE ',' END + COLUMN_STRING
                , @V_SELECT_COLS    = @V_SELECT_COLS
                                        + CASE WHEN @I = 1 THEN '' ELSE ',' END + COLUMN_NAME
		FROM    #T_COL_RAW
		WHERE   SEQ = @I

		SET @I += 1
	END

	WHILE ( @DEF_I <= @DEF_CNT )
	BEGIN
		SELECT    @V_DEF_SELECT_RAW     = @V_DEF_SELECT_RAW
                                        + CASE WHEN @DEF_I = 1 THEN '' ELSE ',' END + COLUMN_STRING
                , @V_DEF_SELECT_COLS    = @V_DEF_SELECT_COLS
                                        + CASE WHEN @DEF_I = 1 THEN '' ELSE ',' END + COLUMN_NAME
				, @V_DEF_GROUPBY_RAW    = @V_DEF_GROUPBY_RAW
                                        + CASE WHEN @DEF_I = 1 THEN '' ELSE ',' END
										+ CASE WHEN PATINDEX(N'% AS %', COLUMN_STRING) > 0 THEN LEFT(COLUMN_STRING, PATINDEX(N'% AS %', COLUMN_STRING) -1)  ELSE COLUMN_STRING END
		FROM    #T_DEF_COL_RAW
		WHERE   SEQ = @DEF_I

		SET @DEF_I += 1
	END

--print '@V_COLUMNS_RAW	: ' + CHAR(10) + @V_COLUMNS_RAW;
--print '@V_SELECT_RAW	: ' + CHAR(10) + @V_SELECT_RAW;
print '@V_DEF_SELECT_COLS	: ' + CHAR(10) + @V_DEF_SELECT_COLS;--return;
print '@V_SELECT_COLS	    : ' + CHAR(10) + @V_SELECT_COLS;--return;


    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RTF_DAILY', N'U') IS NOT NULL
	    DROP TABLE #TBL_SCP0092_RTF_DAILY

    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RESULT_DAILY', N'U') IS NOT NULL
	    DROP TABLE #TBL_SCP0092_RESULT_DAILY

--TESTING : OK
--select * from #RAW_RTF_DAILY;
--select * from #RAW_RESULT_DAILY;return;

PRINT '@V_SELECT_RAW : ' + @V_SELECT_RAW;

	SET @V_SQL_TEXT = N'
        SELECT  *
		INTO    #TBL_SCP0092_RTF_DAILY
        FROM    (
		            SELECT    A.DIVISION_ID
                            , CASE
                                WHEN A.DIVISION_ID = ''40'' AND F.OPERATION_GROUP = ''A'' THEN 0 -- 소형 & Cell 타입은 Pack qty 를 지운다
                                ELSE
                                  CASE
                                    WHEN    (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''Y''                 AND A.MEASURE IN (''VMI_In_Plan''))
                                         OR (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''N''                 AND A.MEASURE IN (''RTF_SYS_RP''))
                                         OR (A.DIVISION_ID     IN (''40'') AND (F.OPERATION_GROUP = ''P''))     --소형 & Pack 은 FG 데이터에서 가져왔으므로 VMI_YN = ''Y'' 로 적용
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID  = ''HLGP_KR_CHU'' AND A.MEASURE IN (''VMI_In_Plan''))
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID <> ''HLGP_KR_CHU'' AND A.MEASURE IN (''RTF_SYS_RP''))
                                        --OR (A.DIVISION_ID NOT IN (''40'', ''81'')                              AND A.MEASURE IN (''RTF_SYS_RP''))
                                        OR (A.DIVISION_ID NOT IN (''40'')                                        AND A.MEASURE IN (''RTF_SYS_RP''))
                                    THEN A.QTY
                                    ELSE 0
                                  END
                              END AS QTY
                            , CASE
                                WHEN       (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''Y''                 AND A.MEASURE IN (''VMI_In_Plan''))
                                        OR (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''N''                 AND A.MEASURE IN (''RTF_SYS_RP''))
                                        OR (A.DIVISION_ID     IN (''40'') AND (F.OPERATION_GROUP = ''P''))     --소형 & Pack 은 FG 데이터에서 가져왔으므로 VMI_YN = ''Y'' 로 적용
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID  = ''HLGP_KR_CHU'' AND A.MEASURE IN (''VMI_In_Plan''))
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID <> ''HLGP_KR_CHU'' AND A.MEASURE IN (''RTF_SYS_RP''))
                                        --OR (A.DIVISION_ID NOT IN (''40'', ''81'')                              AND A.MEASURE IN (''RTF_SYS_RP''))
                                        OR (A.DIVISION_ID NOT IN (''40'')                                        AND A.MEASURE IN (''RTF_SYS_RP''))
                                THEN A.QTY * ISNULL(D.CELL_QUANTITY, 1)
                                ELSE 0
                              END AS CELL_QTY
			                , A.YYYYMMDD
			                , Q.ISO_YYYYMM, Q.ISO_WEEK
			                , M.SORT_ORDER_NO
                            , [@V_SELECT_RAW]
                            , A.MEASURE
                            , CASE
                                WHEN       (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''Y''                 AND A.MEASURE IN (''VMI_In_Plan''))
                                        OR (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''N''                 AND A.MEASURE IN (''RTF_SYS_RP''))
                                        OR (A.DIVISION_ID     IN (''40'') AND (F.OPERATION_GROUP = ''P''))     --소형 & Pack 은 FG 데이터에서 가져왔으므로 VMI_YN = ''Y'' 로 적용
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID  = ''HLGP_KR_CHU'' AND A.MEASURE IN (''VMI_In_Plan''))
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID <> ''HLGP_KR_CHU'' AND A.MEASURE IN (''RTF_SYS_RP''))
                                        --OR (A.DIVISION_ID NOT IN (''40'', ''81'')                              AND A.MEASURE IN (''RTF_SYS_RP''))
                                        OR (A.DIVISION_ID NOT IN (''40'')                                        AND A.MEASURE IN (''RTF_SYS_RP''))
                                THEN ''Y''
                                ELSE ''N''
                              END AS SCP_USE_YN
		            FROM    #RAW_RTF_DAILY A
                            LEFT JOIN SCM_MST_SITE                      B  WITH(NOLOCK)  ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID
                            LEFT JOIN #TEMP_SCM_MST_SITE_ITEM_RTF       C  WITH(NOLOCK)  ON A.DIVISION_ID = C.DIVISION_ID	AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                            LEFT JOIN #TEMP_PIC                         CC WITH(NOLOCK)  ON A.DIVISION_ID = CC.DIVISION_ID	AND A.ITEM_ID = CC.ITEM_ID
                            LEFT JOIN #TEMP_DM_MST_ITEM_SINGLE_V_RTF    D  WITH(NOLOCK)  ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
		                    LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL      E  WITH(NOLOCK)  ON D.CELL_TYPE = E.SEGMENT1 AND E.LOOKUP_TYPE = ''CELL_TYPE''
                            LEFT JOIN #TEMP_MODELS                      F  WITH(NOLOCK)  ON A.DIVISION_ID = F.DIVISION_ID AND A.ITEM_ID = F.ITEM_ID
                            LEFT JOIN #TEMP_CELL_MODEL                  FF WITH(NOLOCK)  ON A.DIVISION_ID = FF.DIVISION_ID AND A.ITEM_ID = FF.ITEM_ID
                            LEFT JOIN SCM_MST_PROJECT                   G  WITH(NOLOCK)  ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
		                    LEFT JOIN SCM_MST_CITY                      H  WITH(NOLOCK)  ON B.CITY = H.CITY
		                    LEFT JOIN SCM_MST_COUNTRY                   J  WITH(NOLOCK)  ON B.COUNTRY = J.COUNTRY
		                    LEFT JOIN SCM_MST_SITE_CUSTOMER             K  WITH(NOLOCK)  ON B.DIVISION_ID = K.DIVISION_ID AND B.SCM_SITE_ID = K.SCM_SITE_ID AND K.REP_YN = ''Y''
		                    LEFT JOIN SCM_MST_CUSTOMER                  L  WITH(NOLOCK)  ON K.DIVISION_ID = L.DIVISION_ID AND K.SHIPTO_CODE = L.SHIPTO_CODE AND K.SOLDTO_CODE = L.SOLDTO_CODE
		                    JOIN #SELECT_MEASURE                        M  WITH(NOLOCK)  ON A.MEASURE = M.MEASURE
                            LEFT JOIN SCM_MST_SSO_DEPT_INFO             N  WITH(NOLOCK)  ON CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END = N.DEPT_ID
		                    LEFT JOIN SCM_MST_SSO_DEPT_INFO             O  WITH(NOLOCK)  ON N.UPPER_DEPT_ID = O.DEPT_ID
                            LEFT JOIN #TEMP_TEAM_81                     NN WITH(NOLOCK)  ON CC.DIVISION_ID = NN.DIVISION_ID AND CC.DEPT_ID = NN.DEPT_ID
		                    JOIN      SCM_SYS_CALENDAR_M                Q  WITH(NOLOCK)  ON A.YYYYMMDD = Q.BASIS_YYYYMMDD AND Q.BASIS_DATE BETWEEN CONVERT(DATETIME, ''' + @p_from_yyyymmdd + N''') AND DATEADD(DAY, 1, CONVERT(DATETIME, ''' + @p_to_yyyymmdd + N'''))
                            LEFT JOIN #TBL_SCP0092_CATEGORY             T  WITH(NOLOCK)  ON A.DIVISION_ID = T.DIVISION_ID AND A.ITEM_ID = T.ITEM_ID
                ) X
        WHERE   X.SCP_USE_YN = ''Y''

      
      --TESTING : OK
      --select * from #RAW_RTF_DAILY;
      --select * from #TBL_SCP0092_RTF_DAILY;return;

        SELECT  *
		INTO    #TBL_SCP0092_RESULT_DAILY
        FROM    (
		            SELECT    A.DIVISION_ID
                            , CASE
                                WHEN A.DIVISION_ID = ''40'' AND F.OPERATION_GROUP = ''A'' THEN 0 -- 소형 & Cell 타입은 Pack qty 를 지운다
                                ELSE
                                  CASE
                                    WHEN    (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''Y''                 AND A.MEASURE IN (''VMI_In_Plan''))
                                         OR (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''N''                 AND A.MEASURE IN (''RTF_SYS_RP''))
                                         OR (A.DIVISION_ID     IN (''40'') AND (F.OPERATION_GROUP = ''P''))     --소형 & Pack 은 FG 데이터에서 가져왔으므로 VMI_YN = ''Y'' 로 적용
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID  = ''HLGP_KR_CHU'' AND A.MEASURE IN (''VMI_In_Plan''))
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID <> ''HLGP_KR_CHU'' AND A.MEASURE IN (''RTF_SYS_RP''))
                                        --OR (A.DIVISION_ID NOT IN (''40'', ''81'')                              AND A.MEASURE IN (''RTF_SYS_RP''))
                                        OR (A.DIVISION_ID NOT IN (''40'')                                        AND A.MEASURE IN (''RTF_SYS_RP''))
                                    THEN A.QTY
                                    ELSE 0
                                  END
                              END AS QTY
                            , CASE
                                WHEN       (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''Y''                 AND A.MEASURE IN (''VMI_In_Plan''))
                                        OR (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''N''                 AND A.MEASURE IN (''RTF_SYS_RP''))
                                        OR (A.DIVISION_ID     IN (''40'') AND (F.OPERATION_GROUP = ''P''))     --소형 & Pack 은 FG 데이터에서 가져왔으므로 VMI_YN = ''Y'' 로 적용
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID  = ''HLGP_KR_CHU'' AND A.MEASURE IN (''VMI_In_Plan''))
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID <> ''HLGP_KR_CHU'' AND A.MEASURE IN (''RTF_SYS_RP''))
                                        --OR (A.DIVISION_ID NOT IN (''40'', ''81'')                              AND A.MEASURE IN (''RTF_SYS_RP''))
                                        OR (A.DIVISION_ID NOT IN (''40'')                                        AND A.MEASURE IN (''RTF_SYS_RP''))
                                 THEN A.QTY * ISNULL(D.CELL_QUANTITY, 1)
                                ELSE 0
                              END AS CELL_QTY
			                , A.YYYYMMDD
			                , Q.ISO_YYYYMM, Q.ISO_WEEK
			                , M.SORT_ORDER_NO
                            , [@V_SELECT_RAW]
                            , A.MEASURE
                            , CASE
                                WHEN       (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''Y''                 AND A.MEASURE IN (''VMI_In_Plan''))
                                        OR (A.DIVISION_ID     IN (''40'') AND B.VMI_YN = ''N''                 AND A.MEASURE IN (''RTF_SYS_RP''))
                                        OR (A.DIVISION_ID     IN (''40'') AND (F.OPERATION_GROUP = ''P''))     --소형 & Pack 은 FG 데이터에서 가져왔으므로 VMI_YN = ''Y'' 로 적용
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID  = ''HLGP_KR_CHU'' AND A.MEASURE IN (''VMI_In_Plan''))
                                        --OR (A.DIVISION_ID     IN (''81'') AND A.SCM_SITE_ID <> ''HLGP_KR_CHU'' AND A.MEASURE IN (''RTF_SYS_RP''))
                                        --OR (A.DIVISION_ID NOT IN (''40'', ''81'')                              AND A.MEASURE IN (''RTF_SYS_RP''))
                                        OR (A.DIVISION_ID NOT IN (''40'')                                        AND A.MEASURE IN (''RTF_SYS_RP''))
                                THEN ''Y''
                                ELSE ''N''
                              END AS SCP_USE_YN
		            FROM    #RAW_RESULT_DAILY A
                            LEFT JOIN SCM_MST_SITE                      B  WITH(NOLOCK)  ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID
                            LEFT JOIN #TEMP_SCM_MST_SITE_ITEM_RESULT    C  WITH(NOLOCK)  ON A.DIVISION_ID = C.DIVISION_ID	AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                            LEFT JOIN #TEMP_PIC                         CC WITH(NOLOCK)  ON A.DIVISION_ID = CC.DIVISION_ID	AND A.ITEM_ID = CC.ITEM_ID
                            LEFT JOIN #TEMP_DM_MST_ITEM_SINGLE_V_RESULT D  WITH(NOLOCK)  ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
		                    LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL      E  WITH(NOLOCK)  ON D.CELL_TYPE = E.SEGMENT1 AND E.LOOKUP_TYPE = ''CELL_TYPE''
                            LEFT JOIN #TEMP_MODELS                      F  WITH(NOLOCK)  ON A.DIVISION_ID = F.DIVISION_ID AND A.ITEM_ID = F.ITEM_ID
                            LEFT JOIN #TEMP_CELL_MODEL                  FF WITH(NOLOCK)  ON A.DIVISION_ID = FF.DIVISION_ID AND A.ITEM_ID = FF.ITEM_ID
                            LEFT JOIN SCM_MST_PROJECT                   G  WITH(NOLOCK)  ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
		                    LEFT JOIN SCM_MST_CITY                      H  WITH(NOLOCK)  ON B.CITY = H.CITY
		                    LEFT JOIN SCM_MST_COUNTRY                   J  WITH(NOLOCK)  ON B.COUNTRY = J.COUNTRY
		                    LEFT JOIN SCM_MST_SITE_CUSTOMER             K  WITH(NOLOCK)  ON B.DIVISION_ID = K.DIVISION_ID AND B.SCM_SITE_ID = K.SCM_SITE_ID AND K.REP_YN = ''Y''
		                    LEFT JOIN SCM_MST_CUSTOMER                  L  WITH(NOLOCK)  ON K.DIVISION_ID = L.DIVISION_ID AND K.SHIPTO_CODE = L.SHIPTO_CODE AND K.SOLDTO_CODE = L.SOLDTO_CODE
		                    JOIN #SELECT_MEASURE                        M  WITH(NOLOCK)  ON A.MEASURE = M.MEASURE
                            LEFT JOIN SCM_MST_SSO_DEPT_INFO             N  WITH(NOLOCK)  ON CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END = N.DEPT_ID
		                    LEFT JOIN SCM_MST_SSO_DEPT_INFO             O  WITH(NOLOCK)  ON N.UPPER_DEPT_ID = O.DEPT_ID
                            LEFT JOIN #TEMP_TEAM_81                     NN WITH(NOLOCK)  ON CC.DIVISION_ID = NN.DIVISION_ID AND CC.DEPT_ID = NN.DEPT_ID
		                    JOIN      SCM_SYS_CALENDAR_M                Q  WITH(NOLOCK)  ON A.YYYYMMDD = Q.BASIS_YYYYMMDD AND Q.BASIS_DATE BETWEEN CONVERT(DATETIME, ''' + @p_from_yyyymmdd + N''') AND DATEADD(DAY, 1, CONVERT(DATETIME, ''' + @p_to_yyyymmdd + N'''))
                            LEFT JOIN #TBL_SCP0092_CATEGORY             T  WITH(NOLOCK)  ON A.DIVISION_ID = T.DIVISION_ID AND A.ITEM_ID = T.ITEM_ID
                ) X
        WHERE   X.SCP_USE_YN = ''Y''

      --TESTING : OK
        --select * from #RAW_RESULT_DAILY where SCM_SITE_ID = ''HLGP_KR_CHU'';
        --select * from #TBL_SCP0092_RESULT_DAILY where END_CUSTOMER = ''HKMC'';return;
        ';

        --소형 & Pack & Cylinder => NICKNAME기준시 서브 쿼리 조인후 NICKNAME 제외한 컬럼들 키값에서 제외 begin
        IF @p_division_id = '40'
        BEGIN
	        SET @V_SQL_TEXT = @V_SQL_TEXT + N'

        print ''NICKNAME기준 - RTF''

        UPDATE  #TBL_SCP0092_RTF_DAILY
        SET       ITEM_ID                   = ''''
                , ITEM_NAME                 = ''''
                , FORECAST_INFO_CELL_MODEL  = ''''
                , FORECAST_INFO_ALL         = ''''
                , CELL_QUANTITY             = ''''
        WHERE   DIVISION_ID      = ''40''
            AND OPERATION_GROUP  = ''P''
            AND CELL_TYPE        = ''Cyl'' ;

        print ''NICKNAME기준 - RESULT''

        UPDATE  #TBL_SCP0092_RESULT_DAILY
        SET       ITEM_ID                   = ''''
                , ITEM_NAME                 = ''''
                , FORECAST_INFO_CELL_MODEL  = ''''
                , FORECAST_INFO_ALL         = ''''
                , CELL_QUANTITY             = ''''
        WHERE   DIVISION_ID      = ''40''
            AND OPERATION_GROUP  = ''P''
            AND CELL_TYPE        = ''Cyl'' ;';
    END
        --소형 & Pack & Cylinder => NICKNAME기준시 서브 쿼리 조인후 NICKNAME 제외한 컬럼들 키값에서 제외 end

        --TESTING : OK
        --select * from #TBL_SCP0092_RTF_DAILY where ITEM_ID = '''';
        --select * from #TBL_SCP0092_RESULT_DAILY where ITEM_ID = '''';return;';

	SET @V_DEF_SQL_TEXT     = @V_SQL_TEXT;

	SET @V_SQL_TEXT         = REPLACE(@V_SQL_TEXT,      '[@V_SELECT_RAW]',     @V_SELECT_RAW);
	SET @V_DEF_SQL_TEXT     = REPLACE(@V_DEF_SQL_TEXT,  '[@V_SELECT_RAW]',     @V_DEF_SELECT_RAW);

--TESTING : OK
--exec debug_log @V_SQL_TEXT, 'T';return;
--exec SP_EXECUTESQL @V_SQL_TEXT; return;

	DECLARE @V_SELECT_SUM       NVARCHAR(4000)
	DECLARE @V_DEF_SELECT_SUM   NVARCHAR(4000)
	DECLARE @V_GROUPBY_SUM	    NVARCHAR(4000)
	DECLARE @V_DEF_GROUPBY_SUM	NVARCHAR(4000)


    IF OBJECT_ID (N'tempdb..#T_COLUMN_SETUP_SUM', N'U') IS NOT NULL
		DROP TABLE #T_COLUMN_SETUP_SUM

	CREATE TABLE #T_COLUMN_SETUP_SUM
    (
		  TBL_ALIAS			NVARCHAR(10)
		, COLUMN_NAME		NVARCHAR(100)
		, COLUMN_STRING		NVARCHAR(1000)
		, SORT_KEY			INT
	)

	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DIVISION_ID',						N'A.DIVISION_ID')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_ID',							N'ITEM_ID')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_NAME',						N'ITEM_NAME')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'NICK_NAME',						N'NICK_NAME')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'END_CUSTOMER',						N'END_CUSTOMER')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'TEAM_NAME_KO',						N'TEAM_NAME_KO')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FCST_TYPE',						N'FCST_TYPE')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_NAME',						N'PROJECT_NAME')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_CODE',						N'PROJECT_CODE')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'OPERATION_GROUP',					N'OPERATION_GROUP')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'OPERATION_GROUP_NAME',				N'OPERATION_GROUP_NAME')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CATEGORY_CODE',                    N'ISNULL(CATEGORY_CODE, '''') AS CATEGORY_CODE')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CATEGORY_NAME',					N'ISNULL(CATEGORY_NAME, '''') AS CATEGORY_NAME')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_TYPE',						N'ISNULL(CELL_TYPE, '''') AS CELL_TYPE')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BASIC_NICKNAME_CELL',				N'ISNULL(BASIC_NICKNAME_CELL, '''') AS BASIC_NICKNAME_CELL')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCM_SITE_ID',						N'SCM_SITE_ID')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_QUANTITY',					N'IIF(ISNULL(CELL_QUANTITY, '''') = '''', ''1'', CELL_QUANTITY) AS CELL_QUANTITY')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'QTY',								N'QTY')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_QTY',							N'QTY * ISNULL(CELL_QUANTITY, 1) AS CELL_QTY')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ISO_YYYYMM',						N'ISO_YYYYMM')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ISO_WEEK',						    N'ISO_WEEK')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'YYYYMMDD',						    N'YYYYMMDD')
	INSERT INTO #T_COLUMN_SETUP_SUM ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SORT_ORDER_NO',					N'SORT_ORDER_NO')

    IF OBJECT_ID (N'tempdb..#T_COL_SUM', N'U') IS NOT NULL
		DROP TABLE #T_COL_SUM

	SELECT    B.COLUMN_STRING
            , ROW_NUMBER() OVER ( ORDER BY B.SORT_KEY ) AS SEQ
	INTO    #T_COL_SUM
	FROM    DBO.UF_FX_String_Split(@V_COLUMNS_SUM, ',') A
			JOIN #T_COLUMN_SETUP_SUM B ON
                    replace(replace(A.TOKEN, '[', ''), ']','') = B.COLUMN_NAME

    IF OBJECT_ID (N'tempdb..#T_DEF_COL_SUM', N'U') IS NOT NULL
		DROP TABLE #T_DEF_COL_SUM

	SELECT    B.COLUMN_STRING
            , ROW_NUMBER() OVER ( ORDER BY B.SORT_KEY ) AS SEQ
	INTO    #T_DEF_COL_SUM
	FROM    DBO.UF_FX_String_Split(@V_DEF_COLUMNS_SUM, ',') A
			JOIN #T_COLUMN_SETUP_SUM B ON
                    replace(replace(A.TOKEN, '[', ''), ']','') = B.COLUMN_NAME
--TESTING : OK
--select * from DBO.UF_FX_String_Split(@V_COLUMNS_SUM, ',');return;
--select * from #T_DEF_COL_SUM;return;


	DECLARE @J     INT, @CNT2     INT

	SELECT    @J                = 1
            , @CNT2             = COUNT(*)
            , @V_SELECT_SUM     = ''
            , @V_GROUPBY_SUM    = ''
	FROM #T_COL_SUM

	WHILE ( @J <= @CNT2 )
	BEGIN
		SELECT    @V_SELECT_SUM     = @V_SELECT_SUM
                                        + CASE WHEN @J = 1 THEN '' ELSE ',' END + COLUMN_STRING
				, @V_GROUPBY_SUM    = @V_GROUPBY_SUM
                                        + CASE WHEN @J = 1 THEN '' ELSE ',' END
										+ CASE WHEN PATINDEX(N'% AS %', COLUMN_STRING) > 0 THEN LEFT(COLUMN_STRING, PATINDEX(N'% AS %', COLUMN_STRING) -1)  ELSE COLUMN_STRING END
		FROM    #T_COL_SUM
		WHERE   SEQ = @J

		SET @J += 1
	END

	DECLARE @DEF_J INT, @DEF_CNT2 INT

	SELECT    @DEF_J                = 1
            , @DEF_CNT2             = COUNT(*)
            , @V_DEF_SELECT_SUM     = ''
            , @V_DEF_GROUPBY_SUM    = ''
	FROM #T_DEF_COL_SUM

	WHILE ( @DEF_J <= @DEF_CNT2 )
	BEGIN
		SELECT    @V_DEF_SELECT_SUM     = @V_DEF_SELECT_SUM
                                        + CASE WHEN @DEF_J = 1 THEN '' ELSE ',' END + COLUMN_STRING
				, @V_DEF_GROUPBY_SUM    = @V_DEF_GROUPBY_SUM
                                        + CASE WHEN @DEF_J = 1 THEN '' ELSE ',' END
										+ CASE WHEN PATINDEX(N'% AS %', COLUMN_STRING) > 0 THEN LEFT(COLUMN_STRING, PATINDEX(N'% AS %', COLUMN_STRING) -1)  ELSE COLUMN_STRING END
		FROM    #T_DEF_COL_SUM
		WHERE   SEQ = @DEF_J

		SET @DEF_J += 1
	END



	DECLARE @V_GROUP_COLS	        NVARCHAR(4000)
    DECLARE @V_COLUMNS_FIN          NVARCHAR(4000)
	DECLARE @V_WW_COLS	            NVARCHAR(4000)
    DECLARE @V_SELECT_WW_A          NVARCHAR(4000)
    DECLARE @V_SELECT_WW_P          NVARCHAR(4000)
    DECLARE @V_SELECT_WW_R          NVARCHAR(4000)
	DECLARE @V_JOIN_P_WW            NVARCHAR(4000)
	DECLARE @V_JOIN_R_WW	        NVARCHAR(4000)
	DECLARE @V_FIN_WW	            NVARCHAR(4000)

	DECLARE @V_DEF_GROUP_COLS	    NVARCHAR(4000)
    DECLARE @V_DEF_COLUMNS_FIN      NVARCHAR(4000)
	DECLARE @V_DEF_WW_COLS	        NVARCHAR(4000)
    DECLARE @V_DEF_SELECT_WW_A      NVARCHAR(4000)
    DECLARE @V_DEF_SELECT_WW_P      NVARCHAR(4000)
    DECLARE @V_DEF_SELECT_WW_R      NVARCHAR(4000)
	DECLARE @V_DEF_JOIN_P_WW        NVARCHAR(4000)
	DECLARE @V_DEF_JOIN_R_WW	    NVARCHAR(4000)
	DECLARE @V_DEF_FIN_WW	        NVARCHAR(4000)


    SET @V_COLUMNS_FIN          = REPLACE(REPLACE(@V_GROUPBY_SUM,       'ISNULL(', ''), ', '''')', '') --ISNULL(CATEGORY_NAME, '') 형태를 컬럼명만 추출
    SET @V_DEF_COLUMNS_FIN      = REPLACE(REPLACE(@V_DEF_GROUPBY_SUM,   'ISNULL(', ''), ', '''')', '') --ISNULL(CATEGORY_NAME, '') 형태를 컬럼명만 추출

    SET @V_GROUP_COLS           = ''
    SET @V_WW_COLS              = ''
    SET @V_SELECT_WW_A          = ''
    SET @V_SELECT_WW_P          = ''
    SET @V_SELECT_WW_R          = ''
	SET @V_JOIN_P_WW            = ''
	SET @V_JOIN_R_WW	        = ''
	SET @V_FIN_WW	            = ''

    SET @V_DEF_GROUP_COLS       = ''
    SET @V_DEF_WW_COLS          = ''
    SET @V_DEF_SELECT_WW_A      = ''
    SET @V_DEF_SELECT_WW_P      = ''
    SET @V_DEF_SELECT_WW_R      = ''
	SET @V_DEF_JOIN_P_WW        = ''
	SET @V_DEF_JOIN_R_WW	    = ''
	SET @V_DEF_FIN_WW	        = ''

    SET @V_WW_COLS              = @V_SELECT_COLS        + ',ISO_YYYYMM,ISO_WEEK'
    SET @V_DEF_WW_COLS          = @V_DEF_SELECT_COLS    + ',ISO_YYYYMM,ISO_WEEK'

    SELECT    @V_SELECT_WW_A        = @V_SELECT_WW_A     + 'A.' + A.TOKEN + ','
            , @V_JOIN_P_WW          = @V_JOIN_P_WW       + 'ISNULL(A.' + A.TOKEN + ', '''') = ISNULL(P.'  + A.TOKEN + ', '''') AND '
            , @V_JOIN_R_WW          = @V_JOIN_R_WW       + 'ISNULL(A.' + A.TOKEN + ', '''') = ISNULL(R.'  + A.TOKEN + ', '''') AND '
            --, @V_JOIN_P_WW          = @V_JOIN_P_WW       + 'A.' + A.TOKEN + ' = P.'  + A.TOKEN + ' AND '
            --, @V_JOIN_R_WW          = @V_JOIN_R_WW       + 'A.' + A.TOKEN + ' = R.'  + A.TOKEN + ' AND '
    FROM    DBO.UF_FX_String_Split(@V_WW_COLS, ',') A

    SELECT    @V_DEF_SELECT_WW_A    = @V_DEF_SELECT_WW_A     + 'A.' + A.TOKEN + ','
            , @V_DEF_JOIN_P_WW      = @V_DEF_JOIN_P_WW       + 'ISNULL(A.' + A.TOKEN + ', '''') = ISNULL(P.'  + A.TOKEN + ', '''') AND '
            , @V_DEF_JOIN_R_WW      = @V_DEF_JOIN_R_WW       + 'ISNULL(A.' + A.TOKEN + ', '''') = ISNULL(R.'  + A.TOKEN + ', '''') AND '
            --, @V_DEF_JOIN_P_WW      = @V_DEF_JOIN_P_WW       + 'A.' + A.TOKEN + ' = P.'  + A.TOKEN + ' AND '
            --, @V_DEF_JOIN_R_WW      = @V_DEF_JOIN_R_WW       + 'A.' + A.TOKEN + ' = R.'  + A.TOKEN + ' AND '
    FROM    DBO.UF_FX_String_Split(@V_DEF_WW_COLS, ',') A

    SELECT    @V_FIN_WW   = @V_FIN_WW + 'A.' + A.TOKEN + ','
    FROM    DBO.UF_FX_String_Split(@V_SELECT_COLS, ',') A

    SELECT    @V_DEF_FIN_WW   = @V_DEF_FIN_WW + 'A.' + A.TOKEN + ','
    FROM    DBO.UF_FX_String_Split(@V_DEF_SELECT_COLS, ',') A

    SET @V_SELECT_WW_A      = SUBSTRING(@V_SELECT_WW_A,         1, LEN(@V_SELECT_WW_A) - 1)
    SET @V_SELECT_WW_P      = REPLACE(@V_SELECT_WW_A,           'A.', 'P.')
    SET @V_SELECT_WW_R      = REPLACE(@V_SELECT_WW_A,           'A.', 'R.')
    SET @V_FIN_WW           = SUBSTRING(@V_FIN_WW,              1, LEN(@V_FIN_WW) - 1)
    SET @V_JOIN_P_WW        = SUBSTRING(@V_JOIN_P_WW,           1, LEN(@V_JOIN_P_WW) - 4)
    SET @V_JOIN_R_WW        = SUBSTRING(@V_JOIN_R_WW,           1, LEN(@V_JOIN_R_WW) - 4)

    SET @V_DEF_SELECT_WW_A  = SUBSTRING(@V_DEF_SELECT_WW_A,     1, LEN(@V_DEF_SELECT_WW_A) - 1)
    SET @V_DEF_SELECT_WW_P  = REPLACE(@V_DEF_SELECT_WW_A,       'A.', 'P.')
    SET @V_DEF_SELECT_WW_R  = REPLACE(@V_DEF_SELECT_WW_A,       'A.', 'R.')
    SET @V_DEF_FIN_WW       = SUBSTRING(@V_DEF_FIN_WW,          1, LEN(@V_DEF_FIN_WW) - 1)
    SET @V_DEF_JOIN_P_WW    = SUBSTRING(@V_DEF_JOIN_P_WW,       1, LEN(@V_DEF_JOIN_P_WW) - 4)
    SET @V_DEF_JOIN_R_WW    = SUBSTRING(@V_DEF_JOIN_R_WW,       1, LEN(@V_DEF_JOIN_R_WW) - 4)


--print '@V_COLUMNS_FIN	: ' + CHAR(10) + @V_COLUMNS_FIN;
--print '@V_SELECT_SUM	: ' + CHAR(10) + @V_SELECT_SUM;
--print '@V_JOIN_P_WW	: ' + CHAR(10) + @V_JOIN_P_WW;
--print '@V_GROUPBY_SUM	: ' + CHAR(10) + @V_GROUPBY_SUM;RETURN;

--TESTING : OK
--exec debug_log @V_SQL_TEXT, 'T'; --return;
--exec SP_EXECUTESQL @V_SQL_TEXT; return;



    SET @V_SQL_TEXT_2 = N'
        IF OBJECT_ID(''tempdb..#TBL_SCP0092_RTF_WW'') IS NOT NULL
            DROP TABLE #TBL_SCP0092_RTF_WW;

        SELECT    [@V_WW_COLS]
                , SUM(QTY) AS QTY
                , SUM(CELL_QTY) AS CELL_QTY
        INTO    #TBL_SCP0092_RTF_WW
        FROM    #TBL_SCP0092_RTF_DAILY
        GROUP BY  [@V_WW_COLS]

        IF OBJECT_ID(''tempdb..#TBL_SCP0092_RESULT_WW'') IS NOT NULL
            DROP TABLE #TBL_SCP0092_RESULT_WW;

        SELECT    [@V_WW_COLS]
                , SUM(QTY) AS QTY
                , SUM(CELL_QTY) AS CELL_QTY
        INTO    #TBL_SCP0092_RESULT_WW
        FROM    #TBL_SCP0092_RESULT_DAILY
        GROUP BY  [@V_WW_COLS]

        IF OBJECT_ID(''tempdb..#TBL_SCP0092_WHOLE_WW'') IS NOT NULL
            DROP TABLE #TBL_SCP0092_WHOLE_WW;

        SELECT DISTINCT
                [@V_WW_COLS]
        INTO    #TBL_SCP0092_WHOLE_WW
        FROM
                (
                    SELECT *
                    FROM   #TBL_SCP0092_RTF_WW A
                    UNION ALL
                    SELECT *
                    FROM   #TBL_SCP0092_RESULT_WW B
                ) A

        --TESTING : OK
        --select * from #TBL_SCP0092_RTF_DAILY;
        --select * from #TBL_SCP0092_RESSULT_DAILY;return;
        --select * from #TBL_SCP0092_RTF_WW;return;
        --select * from #TBL_SCP0092_RESULT_WW;return;
        --select * from #TBL_SCP0092_WHOLE_WW;return;

        SELECT    [@V_FIN_WW]
		        , ISNULL(SUM(A.RTF), 0)                    AS RTF
                , ISNULL(SUM(A.RTF_CELL), 0)               AS RTF_CELL
		        , ISNULL(SUM(A.RESULT), 0)                 AS RESULT
                , ISNULL(SUM(A.RESULT_CELL), 0)            AS RESULT_CELL
                , IIF(ISNULL(SUM(A.RTF),      0) < ISNULL(SUM(A.RESULT),      0), ISNULL(SUM(A.RTF),      0), IIF(ISNULL(SUM(A.RESULT),      0) < 0, 0, ISNULL(SUM(A.RESULT),      0))) AS RESULT_WITH_RTF
                , IIF(ISNULL(SUM(A.RTF_CELL), 0) < ISNULL(SUM(A.RESULT_CELL), 0), ISNULL(SUM(A.RTF_CELL), 0), IIF(ISNULL(SUM(A.RESULT_CELL), 0) < 0, 0, ISNULL(SUM(A.RESULT_CELL), 0))) AS RESULT_WITH_RTF_CELL
                , IIF(ISNULL(SUM(A.RTF), 0) = 0, 0, ISNULL(SUM(A.RESULT_WITH_RTF), 0) / ISNULL(SUM(A.RTF), 0) * 100) AS RATE
                , IIF(ISNULL(SUM(A.RTF_CELL), 0) = 0, 0, ISNULL(SUM(A.RESULT_WITH_RTF_CELL), 0) / ISNULL(SUM(A.RTF_CELL), 0) * 100) AS RATE_CELL
                , ISNULL(SUM(RESULT) - SUM(RTF), 0)        AS RTF_VS
                , ISNULL(SUM(A.RTF_GAP), 0)                AS RTF_GAP
			    , VERSION_SORT
			    , RTF_REASON
        INTO	#TBL_SCP0092_RAW_WW
        FROM    (
                    SELECT    [@V_SELECT_WW_A]
                            , P.QTY AS RTF
                            , R.QTY AS RESULT
                            , IIF(ISNULL(P.QTY, 0) < ISNULL(R.QTY, 0), ISNULL(P.QTY, 0), IIF(ISNULL(R.QTY, 0) < 0, 0, ISNULL(R.QTY, 0))) AS RESULT_WITH_RTF
                            , 0.0 AS RATE
                            , P.QTY_CELL AS RTF_CELL
                            , R.QTY_CELL AS RESULT_CELL
                            , IIF(ISNULL(P.QTY_CELL, 0) - ISNULL(R.QTY_CELL, 0) < 0, ISNULL(P.QTY_CELL, 0), IIF(ISNULL(R.QTY_CELL, 0) < 0, 0, ISNULL(R.QTY_CELL, 0))) AS RESULT_WITH_RTF_CELL
                            , 0.0 AS CELL_RATE
                            , (ISNULL(R.QTY, 0) - ISNULL(P.QTY, 0)) AS RTF_VS
                            , 0.0 AS RTF_GAP
			                , '''' AS VERSION_SORT
			                , '''' AS RTF_REASON
                    FROM    #TBL_SCP0092_WHOLE_WW A
                        LEFT JOIN
                            (
                                SELECT    [@V_SELECT_WW_P]
                                        , P.QTY      AS QTY
                                        , P.CELL_QTY AS QTY_CELL
                                FROM    #TBL_SCP0092_RTF_WW P
                            ) P ON
                                [@V_JOIN_P_WW]
                        LEFT JOIN
                            (
                                SELECT    [@V_SELECT_WW_R]
                                        , R.QTY      AS QTY
                                        , R.CELL_QTY AS QTY_CELL
                                FROM    #TBL_SCP0092_RESULT_WW R
                            ) R ON
                                [@V_JOIN_R_WW]
                ) A
        GROUP BY [@V_FIN_WW], VERSION_SORT, RTF_REASON
    	ORDER BY [@V_FIN_WW], VERSION_SORT, RTF_REASON

        --TESTING : OK
        --select * from #TBL_SCP0092_RAW_WW;return;

        -- CELL_QUANTITY 널처리
        UPDATE #TBL_SCP0092_RAW_WW
        SET    CELL_QUANTITY = 1.000000
        WHERE  CELL_QUANTITY IS NULL

        DECLARE @V_TOTAL_RTF						NUMERIC(30,10)
        DECLARE @V_TOTAL_RTF_CELL					NUMERIC(30,10)
        DECLARE @V_TOTAL_RESULT						NUMERIC(30,10)
        DECLARE @V_TOTAL_RESULT_CELL				NUMERIC(30,10)
        DECLARE @V_TOTAL_RESULT_WITH_RTF			NUMERIC(30,10)
        DECLARE @V_TOTAL_RESULT_WITH_RTF_CELL		NUMERIC(30,10)
        DECLARE @V_TOTAL_RATE						NUMERIC(30,10)
        DECLARE @V_TOTAL_RATE_CELL					NUMERIC(30,10)
        DECLARE @V_TOTAL_RTF_VS						NUMERIC(30,10)
        DECLARE @V_TOTAL_RTF_GAP					NUMERIC(30,10)

        IF OBJECT_ID(N''tempdb..#TBL_SCP0092_RAW_WW_TOTAL'', N''U'') IS NOT NULL
        	DROP TABLE #TBL_SCP0092_RAW_WW_TOTAL;

        SELECT    SUM(T.RTF)                                                                                                        AS RTF
                , SUM(T.RTF_CELL)                                                                                                   AS RTF_CELL
		        , SUM(T.RESULT)                                                                                                     AS RESULT
                , SUM(T.RESULT_CELL)                                                                                                AS RESULT_CELL
                , IIF(SUM(T.RTF)      <= SUM(T.RESULT),      SUM(T.RTF),      IIF(SUM(T.RESULT)      < 0, 0, SUM(T.RESULT)))        AS RESULT_WITH_RTF
                , IIF(SUM(T.RTF_CELL) <= SUM(T.RESULT_CELL), SUM(T.RTF_CELL), IIF(SUM(T.RESULT_CELL) < 0, 0, SUM(T.RESULT_CELL)))   AS RESULT_WITH_RTF_CELL
		        , SUM(T.RATE)                                                                                                       AS RATE
                , SUM(T.RATE_CELL)                                                                                                  AS RATE_CELL
                , SUM(RESULT) - SUM(RTF)                                                                                            AS RTF_VS
        INTO    #TBL_SCP0092_RAW_WW_TOTAL
        FROM    #TBL_SCP0092_RAW_WW T;

        SELECT  @V_TOTAL_RTF_CELL = RTF_CELL
        FROM    #TBL_SCP0092_RAW_WW_TOTAL;

        UPDATE #TBL_SCP0092_RAW_WW_TOTAL
        SET
              RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
            , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

        UPDATE #TBL_SCP0092_RAW_WW
        SET
            RTF_GAP = ISNULL(IIF(@V_TOTAL_RTF_CELL = 0, 0, (RESULT_WITH_RTF_CELL - RTF_CELL) / @V_TOTAL_RTF_CELL * 100), 0);';


    SET @V_SQL_TEXT     = @V_SQL_TEXT     + @V_SQL_TEXT_2
    SET @V_DEF_SQL_TEXT = @V_DEF_SQL_TEXT + @V_SQL_TEXT_2

    --exec debug_log @V_SQL_TEXT, 'T';return;
    --exec debug_log @V_DEF_SQL_TEXT, 'T';return;
    SET @V_SQL_TEXT     = REPLACE(@V_SQL_TEXT,      '[@V_SELECT_SUM]',              @V_SELECT_SUM)
    SET @V_SQL_TEXT     = REPLACE(@V_SQL_TEXT,      '[@V_GROUPBY_SUM]',             @V_GROUPBY_SUM)

print '@V_SELECT_SUM : '  + @V_SELECT_SUM
print '@V_GROUPBY_SUM : ' + @V_GROUPBY_SUM
print '@V_DEF_SELECT_SUM : '  + @V_DEF_SELECT_SUM
print '@V_DEF_GROUPBY_SUM : ' + @V_DEF_GROUPBY_SUM

    SET @V_DEF_SQL_TEXT = REPLACE(@V_DEF_SQL_TEXT,  '[@V_SELECT_SUM]',              @V_DEF_SELECT_SUM)
    SET @V_DEF_SQL_TEXT = REPLACE(@V_DEF_SQL_TEXT,  '[@V_GROUPBY_SUM]',             @V_DEF_GROUPBY_SUM)


    SET @V_SQL_TEXT     = REPLACE(@V_SQL_TEXT,      '[@V_WW_COLS]',                 @V_WW_COLS)
    SET @V_SQL_TEXT     = REPLACE(@V_SQL_TEXT,      '[@V_SELECT_WW_A]',             @V_SELECT_WW_A)
    SET @V_SQL_TEXT     = REPLACE(@V_SQL_TEXT,      '[@V_SELECT_WW_P]',             @V_SELECT_WW_P)
    SET @V_SQL_TEXT     = REPLACE(@V_SQL_TEXT,      '[@V_SELECT_WW_R]',             @V_SELECT_WW_R)
    SET @V_SQL_TEXT     = REPLACE(@V_SQL_TEXT,      '[@V_JOIN_P_WW]',               @V_JOIN_P_WW)
    SET @V_SQL_TEXT     = REPLACE(@V_SQL_TEXT,      '[@V_JOIN_R_WW]',               @V_JOIN_R_WW)
    SET @V_SQL_TEXT     = REPLACE(@V_SQL_TEXT,      '[@V_FIN_WW]',                  @V_FIN_WW)

    SET @V_DEF_SQL_TEXT = REPLACE(@V_DEF_SQL_TEXT,  '[@V_WW_COLS]',                 @V_DEF_WW_COLS)
    SET @V_DEF_SQL_TEXT = REPLACE(@V_DEF_SQL_TEXT,  '[@V_SELECT_WW_A]',             @V_DEF_SELECT_WW_A)
    SET @V_DEF_SQL_TEXT = REPLACE(@V_DEF_SQL_TEXT,  '[@V_SELECT_WW_P]',             @V_DEF_SELECT_WW_P)
    SET @V_DEF_SQL_TEXT = REPLACE(@V_DEF_SQL_TEXT,  '[@V_SELECT_WW_R]',             @V_DEF_SELECT_WW_R)
    SET @V_DEF_SQL_TEXT = REPLACE(@V_DEF_SQL_TEXT,  '[@V_JOIN_P_WW]',               @V_DEF_JOIN_P_WW)
    SET @V_DEF_SQL_TEXT = REPLACE(@V_DEF_SQL_TEXT,  '[@V_JOIN_R_WW]',               @V_DEF_JOIN_R_WW)
    SET @V_DEF_SQL_TEXT = REPLACE(@V_DEF_SQL_TEXT,  '[@V_FIN_WW]',                  @V_DEF_FIN_WW)

--TESTING : OK
--exec debug_log @V_SQL_TEXT, 'T';
--exec debug_log @V_DEF_SQL_TEXT, 'T';return;


    DECLARE @V_YYYYMMWW                 NVARCHAR(8)         = '';
    
    SELECT  TOP 1
            @V_YYYYMMWW = C.ISO_YYYYMM + SUBSTRING(C.ISO_YYYYWW, 5, 2)
    FROM    SCM_SYS_CALENDAR_M C
    WHERE   C.ISO_YYYYWW = @V_ISO_YYYYWW

PRINT '@V_YYYYMMWW : ' + @V_YYYYMMWW;

    DELETE FROM SCP_RPT_RTF_ARC
    WHERE   1=1
        AND DIVISION_ID  = @p_division_id
        AND ISO_YYYYMMWW = @V_YYYYMMWW
        AND IS_PRE_WEEK  = @p_is_pre_week;

    
    DECLARE @V_SQL_TEXT_3         VARCHAR(MAX)    = N'
            INSERT INTO SCP_RPT_RTF_ARC
            (
	              RTF_SEQ
	            , DIVISION_ID
	            , ISO_YYYYMMWW
	            , IS_PRE_WEEK
	            , ITEM_ID
	            , ITEM_NAME
	            , NICK_NAME
	            , FCST_TYPE
	            , OWNER
	            , APPLICATION
	            , CELL_TYPE
	            , BASIC_NICKNAME_CELL
	            , FORECAST_INFO_CELL_MODEL
	            , FORECAST_INFO_ALL
	            , END_CUSTOMER
	            , PACK_GROUP
	            , SCM_SITE_ID
	            , PROJECT_CODE
	            , PROJECT_NAME
	            , DEPT_ID
	            , TEAM_NAME_KO
	            , UPPER_DEPT_ID
	            , DEPT_NAME_KO
	            , OPERATION_GROUP
	            , OPERATION_GROUP_NAME
	            , CATEGORY_CODE
	            , CATEGORY_NAME
	            , CELL_QUANTITY
                , RTF
                , RTF_CELL
                , RESULT
                , RESULT_CELL
                , RESULT_WITH_RTF
                , RESULT_WITH_RTF_CELL
                , RATE
                , RATE_CELL
	            , RTF_VS
	            , RTF_GAP
	            , RTF_REASON
	            , VERSION_SORT
	            , ATTRIBUTE1
	            , ATTRIBUTE2
	            , ATTRIBUTE3
	            , ATTRIBUTE4
	            , ATTRIBUTE5
	            , ATTRIBUTE6
	            , ATTRIBUTE7
	            , ATTRIBUTE8
	            , ATTRIBUTE9
	            , ATTRIBUTE10
	            , CREATED_BY
	            , CREATION_DATE
	            , LAST_UPDATED_BY
	            , LAST_UPDATE_DATE
            )'


    IF @p_division_id = '82'
    BEGIN
        SET @V_SQL_TEXT_3   = @V_SQL_TEXT_3 + N'
            SELECT    (NEXT VALUE FOR SEQ1_SCP_RPT_RTF_ARC)			AS RTF_SEQ
	                , ''' + @p_division_id + '''					AS DIVISION_ID
	                , ''' + @V_YYYYMMWW    + '''					AS ISO_YYYYMMWW
	                , ''' + @p_is_pre_week + '''					AS IS_PRE_WEEK
	                , ISNULL(W.ITEM_ID, '''')						AS ITEM_ID
	                , ISNULL(W.ITEM_NAME, '''')						AS ITEM_NAME
	                , ISNULL(W.NICK_NAME, '''')						AS NICK_NAME
	                , ISNULL(W.FCST_TYPE, '''')						AS FCST_TYPE
	                , ''''											AS OWNER
	                , ''''											AS APPLICATION
	                , ''''											AS CELL_TYPE
	                , ISNULL(W.BASIC_NICKNAME_CELL, '''')			AS BASIC_NICKNAME_CELL
	                , ''''											AS FORECAST_INFO_CELL_MODEL
	                , ''''											AS FORECAST_INFO_ALL
	                , ISNULL(W.END_CUSTOMER, '''')					AS END_CUSTOMER
                    , ''''											AS PACK_GROUP
	                , ISNULL(W.SCM_SITE_ID, '''')					AS SCM_SITE_ID
	                , ISNULL(W.PROJECT_CODE, '''')					AS PROJECT_CODE
	                , ISNULL(W.PROJECT_NAME, '''')					AS PROJECT_NAME
	                , ISNULL(W.DEPT_ID, '''')						AS DEPT_ID
	                , ISNULL(W.TEAM_NAME_KO, '''')					AS TEAM_NAME_KO
	                , ''''											AS UPPER_DEPT_ID
	                , ''''											AS DEPT_NAME_KO
	                , ISNULL(W.OPERATION_GROUP, '''')				AS OPERATION_GROUP
	                , W.OPERATION_GROUP_NAME						AS OPERATION_GROUP_NAME
	                , ISNULL(W.CATEGORY_CODE, '''')					AS CATEGORY_CODE
	                , ISNULL(W.CATEGORY_NAME, '''')					AS CATEGORY_NAME
	                , W.CELL_QUANTITY
                    , W.RTF
                    , W.RTF_CELL
                    , W.RESULT
                    , W.RESULT_CELL
                    , W.RESULT_WITH_RTF
                    , W.RESULT_WITH_RTF_CELL
                    , W.RATE
                    , W.RATE_CELL
	                , W.RTF_VS
	                , W.RTF_GAP
	                , W.RTF_REASON
	                , W.VERSION_SORT
	                , ''''											AS ATTRIBUTE1
	                , ''''											AS ATTRIBUTE2
	                , ''''											AS ATTRIBUTE3
	                , ''''											AS ATTRIBUTE4
	                , ''''											AS ATTRIBUTE5
	                , ''''											AS ATTRIBUTE6
	                , ''''											AS ATTRIBUTE7
	                , ''''											AS ATTRIBUTE8
	                , ''''											AS ATTRIBUTE9
	                , ''''											AS ATTRIBUTE10
	                , ''' + @p_created_by + '''						AS CREATED_BY
	                , SYSDATETIME()									AS CREATION_DATE
	                , ''' + @p_created_by + '''						AS LAST_UPDATED_BY
	                , SYSDATETIME()									AS LAST_UPDATE_DATE
            FROM    #TBL_SCP0092_RAW_WW W'
    END
    ELSE IF @p_division_id = '40'
    BEGIN
        SET @V_SQL_TEXT_3   = @V_SQL_TEXT_3 + N'
            SELECT    (NEXT VALUE FOR SEQ1_SCP_RPT_RTF_ARC)			AS RTF_SEQ
	                , ''' + @p_division_id + '''					AS DIVISION_ID
	                , ''' + @V_YYYYMMWW    + '''					AS ISO_YYYYMMWW
	                , ''' + @p_is_pre_week + '''					AS IS_PRE_WEEK
                    , ISNULL(W.ITEM_ID, '''')						AS ITEM_ID
                    , ISNULL(W.ITEM_NAME, '''')						AS ITEM_NAME
                    , ISNULL(W.NICK_NAME, '''')						AS NICK_NAME
                    , ISNULL(W.FCST_TYPE, '''')						AS FCST_TYPE
                    , ISNULL(W.OWNER, '''')							AS OWNER
                    , ''''											AS APPLICATION
                    , ISNULL(W.CELL_TYPE, '''')						AS CELL_TYPE
	                , ''''											AS BASIC_NICKNAME_CELL
                    , ISNULL(W.FORECAST_INFO_CELL_MODEL, '''')		AS FORECAST_INFO_CELL_MODEL
                    , ISNULL(W.FORECAST_INFO_ALL, '''')				AS FORECAST_INFO_ALL
	                , ''''											AS END_CUSTOMER
                    , ''''											AS PACK_GROUP
                    , ISNULL(W.SCM_SITE_ID, '''')					AS SCM_SITE_ID
                    , ISNULL(W.PROJECT_CODE, '''')					AS PROJECT_CODE
                    , ISNULL(W.PROJECT_NAME, '''')					AS PROJECT_NAME
	                , ''''											AS DEPT_ID
                    , ISNULL(W.TEAM_NAME_KO, '''')					AS TEAM_NAME_KO
	                , ''''											AS UPPER_DEPT_ID
	                , ''''											AS DEPT_NAME_KO
                    , ISNULL(W.OPERATION_GROUP, '''')				AS OPERATION_GROUP
                    , ISNULL(W.OPERATION_GROUP_NAME, '''')			AS OPERATION_GROUP_NAME
	                , ''''											AS CATEGORY_CODE
	                , ''''											AS CATEGORY_NAME
                    , W.CELL_QUANTITY
                    , W.RTF
                    , W.RTF_CELL
                    , W.RESULT
                    , W.RESULT_CELL
                    , W.RESULT_WITH_RTF
                    , W.RESULT_WITH_RTF_CELL
                    , W.RATE
                    , W.RATE_CELL
                    , W.RTF_VS
                    , W.RTF_GAP
                    , W.RTF_REASON
                    , W.VERSION_SORT
	                , ''''											AS ATTRIBUTE1
	                , ''''											AS ATTRIBUTE2
	                , ''''											AS ATTRIBUTE3
	                , ''''											AS ATTRIBUTE4
	                , ''''											AS ATTRIBUTE5
	                , ''''											AS ATTRIBUTE6
	                , ''''											AS ATTRIBUTE7
	                , ''''											AS ATTRIBUTE8
	                , ''''											AS ATTRIBUTE9
	                , ''''											AS ATTRIBUTE10
	                , ''' + @p_created_by + '''						AS CREATED_BY
	                , SYSDATETIME()									AS CREATION_DATE
	                , ''' + @p_created_by + '''						AS LAST_UPDATED_BY
	                , SYSDATETIME()									AS LAST_UPDATE_DATE
            FROM    #TBL_SCP0092_RAW_WW W'
    END
    ELSE IF @p_division_id = '81'
    BEGIN
        SET @V_SQL_TEXT_3   = @V_SQL_TEXT_3 + N'
            SELECT    (NEXT VALUE FOR SEQ1_SCP_RPT_RTF_ARC)			AS RTF_SEQ
	                , ''' + @p_division_id + '''					AS DIVISION_ID
	                , ''' + @V_YYYYMMWW    + '''					AS ISO_YYYYMMWW
	                , ''' + @p_is_pre_week + '''					AS IS_PRE_WEEK
                    , ISNULL(W.ITEM_ID, '''')						AS ITEM_ID
                    , ISNULL(W.ITEM_NAME, '''')						AS ITEM_NAME
                    , ISNULL(W.NICK_NAME, '''')						AS NICK_NAME
                    , ISNULL(W.FCST_TYPE, '''')						AS FCST_TYPE
                    , ISNULL(W.OWNER, '''')							AS OWNER
	                , ''''											AS APPLICATION
	                , ''''											AS CELL_TYPE
	                , ''''											AS BASIC_NICKNAME_CELL
	                , ''''											AS FORECAST_INFO_CELL_MODEL
	                , ''''											AS FORECAST_INFO_ALL
                    , ISNULL(W.END_CUSTOMER, '''')					AS END_CUSTOMER
                    , ISNULL(W.PACK_GROUP, '''')					AS PACK_GROUP
                    , ISNULL(W.SCM_SITE_ID, '''')					AS SCM_SITE_ID
                    , ISNULL(W.PROJECT_CODE, '''')					AS PROJECT_CODE
                    , ISNULL(W.PROJECT_NAME, '''')					AS PROJECT_NAME
                    , ISNULL(W.DEPT_ID, '''')						AS DEPT_ID
                    , ISNULL(W.TEAM_NAME_KO, '''')					AS TEAM_NAME_KO
                    , ISNULL(W.UPPER_DEPT_ID, '''')					AS UPPER_DEPT_ID
                    , ISNULL(W.DEPT_NAME_KO, '''')					AS DEPT_NAME_KO
                    , ISNULL(W.OPERATION_GROUP, '''')				AS OPERATION_GROUP
                    , ISNULL(W.OPERATION_GROUP_NAME, '''')			AS OPERATION_GROUP_NAME
                    , ISNULL(W.CATEGORY_CODE, '''')					AS CATEGORY_CODE
                    , ISNULL(W.CATEGORY_NAME, '''')					AS CATEGORY_NAME
                    , W.CELL_QUANTITY
                    , W.RTF
                    , W.RTF_CELL
                    , W.RESULT
                    , W.RESULT_CELL
                    , W.RESULT_WITH_RTF
                    , W.RESULT_WITH_RTF_CELL
                    , W.RATE
                    , W.RATE_CELL
                    , W.RTF_VS
                    , W.RTF_GAP
                    , W.RTF_REASON
                    , W.VERSION_SORT
	                , ''''											AS ATTRIBUTE1
	                , ''''											AS ATTRIBUTE2
	                , ''''											AS ATTRIBUTE3
	                , ''''											AS ATTRIBUTE4
	                , ''''											AS ATTRIBUTE5
	                , ''''											AS ATTRIBUTE6
	                , ''''											AS ATTRIBUTE7
	                , ''''											AS ATTRIBUTE8
	                , ''''											AS ATTRIBUTE9
	                , ''''											AS ATTRIBUTE10
	                , ''' + @p_created_by + '''						AS CREATED_BY
	                , SYSDATETIME()									AS CREATION_DATE
	                , ''' + @p_created_by + '''						AS LAST_UPDATED_BY
	                , SYSDATETIME()									AS LAST_UPDATE_DATE
            FROM    #TBL_SCP0092_RAW_WW W'
    END

    SET @V_SQL_TEXT_3 = REPLACE(@V_SQL_TEXT_3,  '[@p_division_id]',       @p_division_id)

    SET @V_DEF_SQL_TEXT = @V_DEF_SQL_TEXT + CHAR(10) + @V_SQL_TEXT_3

   --exec debug_log @V_DEF_SQL_TEXT, 'T';return;
	EXEC SP_EXECUTESQL @V_DEF_SQL_TEXT;--return;

--TESTING : OK
--select * from SCP_RPT_RTF_ARC where ISO_YYYYMMWW = '20221147';
--select * from SCP_RPT_RTF_ARC where DIVISION_ID = @p_division_id;


	------------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (BEGIN)
	------------------------------------------------------------------------------------------
	    IF OBJECT_ID (N'tempdb..#RAW_RESULT_DAILY', N'U') IS NOT NULL
	    	DROP TABLE #RAW_RESULT_DAILY;
	    IF OBJECT_ID (N'tempdb..#RAW_RTF_DAILY', N'U') IS NOT NULL
	    	DROP TABLE #RAW_RTF_DAILY;
	    IF OBJECT_ID (N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL
	    	DROP TABLE #SELECT_MEASURE;
	    IF OBJECT_ID (N'tempdb..#TBL_CATEGORY', N'U') IS NOT NULL
	    	DROP TABLE #TBL_CATEGORY;
	    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_CATEGORY', N'U') IS NOT NULL
	    	DROP TABLE #TBL_SCP0092_CATEGORY;
	    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_WW', N'U') IS NOT NULL
	    	DROP TABLE #TBL_SCP0092_RAW_WW;
	    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RAW_WW_TOTAL', N'U') IS NOT NULL
	    	DROP TABLE #TBL_SCP0092_RAW_WW_TOTAL;
	    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RESULT_DAILY', N'U') IS NOT NULL
	    	DROP TABLE #TBL_SCP0092_RESULT_DAILY;
	    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RESULT_WW', N'U') IS NOT NULL
	    	DROP TABLE #TBL_SCP0092_RESULT_WW;
	    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RTF_DAILY', N'U') IS NOT NULL
	    	DROP TABLE #TBL_SCP0092_RTF_DAILY;
	    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_RTF_WW', N'U') IS NOT NULL
	    	DROP TABLE #TBL_SCP0092_RTF_WW;
	    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_WHOLE_WW', N'U') IS NOT NULL
	    	DROP TABLE #TBL_SCP0092_WHOLE_WW;
	    IF OBJECT_ID (N'tempdb..#TEMP_CELL_MODEL', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_CELL_MODEL;
	    IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V_RESULT', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V_RESULT;
	    IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V_RTF', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V_RTF;
	    IF OBJECT_ID (N'tempdb..#TEMP_MODELS', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_MODELS;
	    IF OBJECT_ID (N'tempdb..#TEMP_OPERATION_GROUP', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_OPERATION_GROUP;
	    IF OBJECT_ID (N'tempdb..#TEMP_PIC', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_PIC;
	    IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM_RESULT', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_SCM_MST_SITE_ITEM_RESULT;
	    IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM_RTF', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_SCM_MST_SITE_ITEM_RTF;
	    IF OBJECT_ID (N'tempdb..#TEMP_SCP0092_PLAN_FG', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_SCP0092_PLAN_FG;
	    IF OBJECT_ID (N'tempdb..#TEMP_SCP0092_RESULT_FG', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_SCP0092_RESULT_FG;
	    IF OBJECT_ID (N'tempdb..#T_COLUMN_SETUP_RAW', N'U') IS NOT NULL
	    	DROP TABLE #T_COLUMN_SETUP_RAW;
	    IF OBJECT_ID (N'tempdb..#T_COLUMN_SETUP_SUM', N'U') IS NOT NULL
	    	DROP TABLE #T_COLUMN_SETUP_SUM;
	    IF OBJECT_ID (N'tempdb..#T_COL_RAW', N'U') IS NOT NULL
	    	DROP TABLE #T_COL_RAW;
	    IF OBJECT_ID (N'tempdb..#T_COL_SUM', N'U') IS NOT NULL
	    	DROP TABLE #T_COL_SUM;
	    IF OBJECT_ID (N'tempdb..#T_DEF_COL_RAW', N'U') IS NOT NULL
	    	DROP TABLE #T_DEF_COL_RAW;
	    IF OBJECT_ID (N'tempdb..#T_DEF_COL_SUM', N'U') IS NOT NULL
	    	DROP TABLE #T_DEF_COL_SUM;
	    IF OBJECT_ID (N'tempdb..#T_TERMS', N'U') IS NOT NULL
	    	DROP TABLE #T_TERMS;
	    IF OBJECT_ID (N'tempdb..#WHERE_MEASURE', N'U') IS NOT NULL
	    	DROP TABLE #WHERE_MEASURE;
	    
	------------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (END)
	------------------------------------------------------------------------------------------

END
