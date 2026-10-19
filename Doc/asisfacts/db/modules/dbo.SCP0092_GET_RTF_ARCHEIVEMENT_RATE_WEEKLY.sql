---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY
 * Description  : RTF 준수율 Weekly 조회
 * Program History
 *===================================================================================================
 *  Date        In Charge       Description
*===================================================================================================
* 2022.05.20	chaan       V1.3    Inititialize
* 2022.05.30	chaan       V1.4    사용자지정컬럼 적용
* 2022.06.08	chaan       V1.5    최대 조회기간을 현재 기준 전주까지로 제한
* 2022/06/17    chaan		V1.54   ISOYYYYMM 기준으로 주 로직 변경#TBL_SCP0092_RTF_DAILY
*                                   파라미터 삭제(@p_scm_site_id, @p_plant_site_id)
* 2022/06/20    chaan		V1.55   RTF_VS / RTF_GAP(ui로 로직 이전) 수정
* 2022/06/20    chaan		V1.56   MEASURE 제거
* 2022/06/23    chaan		V1.58   RTF With Result 및 Rate 계산방식 변경
* 2022/06/24    chaan		V1.59   사용자지정컬럼 및 소트순서 적용 오류 수정
* 2022/07/01    chaan		V1.1.1  Weekly 와 Summary  리포트 합계 수치 이상 수정
*                                   Cell Model 표시 대상 데이터 수정
* 2022/07/04    chaan		V1.1.2  CATEGORY 대상 테이블 및 컬럼 변경 (SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT3 -> SCP_MST_FINAL_ITEM.GROUP_CODE5)
                                    CATEGORY 대상 컬럼 변경 (BASIC_NICKNAME_CELL -> GROUP_CODE5)
* 2022/07/15    chaan		V1.1.3  CATEGORY 미입력항목 '기타' 로 표기
                                    소계 정렬용 DISPLAY_SEQ 추가
* 2022/07/20    chaan		V1.1.4  사용자지정컬럼 기본 키 변경
* 2022/08/09    chaan		V1.1.6  인터페이스 오류 수정
* 2022/08/09    chaan		V1.1.7  DM기준 biz_type => operation_group 으로 변경
* 2022/08/10    chaan		V1.1.8  RTF실적 -1Week/0Week 옵션화로 인한 파라미터 추가 (+ 버전을 Target된 버전으로 제한)
* 2022/08/30    chaan		V1.1.9  공통 - Operation Gorup = 'Cell' 일때, Cell Quantity NULL을 1로 대체
                                         - Nickname 으로 검색시 Operation Group Name 표시 안되던 부분 보완 (@p_item_id 에 Nickname 이 넘어옴)
                                    소형 - PROJECT_CODE, PROJECT_NAME 삭제
                                    소형 - RTF 준수율 산출 로직 변경
                                           ~ 소형 : VMI = 'Y' AND Measure = 'VMI in Plan[R+P]'
                                           ~ ESS  : Measure = 'RTF[R+P]'
                                    소형/자동차 - OWNER(PIC) 로직 변경(Group Code Management 테이블로 변경)
                                    소형/자동차 - Team 을 SCM Team 으로 변경
* 2022/09/26    chaan		V1.1.10 소형/자동차 - PIC조회 변경
                                                - Owner 필터 수정(PIC)
                                                - Product Group 수정 (FORECAST_INFO_PRODUCT_GROUP -> SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT2, (weekly는 CELL_TYPE))
* 2022/10/11    chaan		V1.1.11 소형        - biz_type 이 opertaion_group 으로 변경되어 'ALL' 선택시 전극까지 조회되는 오류 수정
* 2022/10/24    chaan		V1.1.12 소형        - opertaion_group 에 따른 로직 변경
                                                  ~ Cell 일 때, Pack RTF 항목들(RTF, RESULT, RESULT_WITH_RTF , RATE) 0 처리
                                                  ~ Pack 일 때, 대상 데이터를 Shipment Plan FG 기준으로 변경
* 2022/11/09    chaan		V1.1.13 소형        - Weekly 수치와 검증
* 2022/11/09    chaan		V1.1.14 소형        - Weekly 수치와 검증-Summary 와 공통모듈 적용
* 2022/11/20    chaan		V1.1.15 자동차      - 자동차 사업부 추가
* 2022/11/24    chaan		V1.1.16 소형        - Nickname 로직 변경
* 2022/12/01    chaan		V1.1.17 소형        - 소형 & Pack & Cylinder 이면 Nickname 별로 합산(다음 컬럼 공란 처리)
                                                  ~ Model, Cell Model, Spec & Version, Cell Quantity
* 2022/12/05    chaan		V2.1.1  조회 방식을 집계후 리포트테이블 조회로 변경
* 2022/12/12    chaan		V2.1.2  - @p_yyyymmww 산출 로직 변경
                                    - 필터 오류 수정 - @p_biz_type
                                    - RATE 산출 오류 수정
                                    - Result With RTF 오류 수정
* 2022/12/14    chaan		V2.1.3  - @p_yyyymmww 산출 로직 변경
*                                   - RATE, RATE_CELL 산출시 소수이하 절삭 오류 수정
* 2022/12/14    chaan		V2.1.4  필터링 오류 수정
* 2023/01/02    chaan		V2.1.5  자동차     - Result With RTF 이상 확인
* 2023/01/19    chaan		V2.1.6  조회 오류 수정 - 버전 조회시 사업부별 CUTOFF 날짜가 달라서 발생
                                                   - 정기 CUTOFF 구분 추가
**************************************************************************************************
*/

--CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY]
CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY]
      @p_division_id              NVARCHAR(30)
    , @p_dept_id                  NVARCHAR(4000)
    , @p_end_customer             NVARCHAR(4000)
    , @p_project_code             NVARCHAR(4000)
    , @p_item_id                  NVARCHAR(4000)
    , @p_item_type                NVARCHAR(4000)
    , @p_week                     NVARCHAR(50)
    , @p_created_by               NVARCHAR(4000)
    , @p_biz_type                 NVARCHAR(4000)
    , @p_fcst_type                NVARCHAR(4000)
    , @p_owner					  NVARCHAR(4000)
    , @p_user_dept_id			  NVARCHAR(50)	-- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
    , @p_group_id				  NVARCHAR(50)	-- JV Planner 일지 확인하기 위해 추가
    , @p_is_pre_week			  NVARCHAR(50)	-- -1Week : 'T', 0Week : 'F'
AS
BEGIN
    SET NOCOUNT ON;
    SET ANSI_NULLS ON
    SET ANSI_WARNINGS ON;


 --   DECLARE @p_division_id              NVARCHAR(30)        = N'82';
 --   --DECLARE @p_division_id              NVARCHAR(30)        = N'81';
 --   --DECLARE @p_division_id              NVARCHAR(30)        = N'40';
 --   DECLARE @p_dept_id                  NVARCHAR(4000)      = N'ALL';
 --   --DECLARE @p_dept_id                  NVARCHAR(4000)      = N'58401558';
 --   DECLARE @p_end_customer             NVARCHAR(4000)      = N'ALL';--fg
 --   --DECLARE @p_end_customer             NVARCHAR(4000)      = N'HKMC';--fg
 --   DECLARE @p_project_code             NVARCHAR(4000)      = N'';
 --   DECLARE @p_item_id                  NVARCHAR(4000)      = N'';
 --   --DECLARE @p_item_id                  NVARCHAR(4000)      = N'MCSS20253-A4,MCCM356015A2-D01';
 --   DECLARE @p_item_type                NVARCHAR(4000)      = N'ALL';
 --   DECLARE @p_week                     NVARCHAR(50)        = N'20230103-W01';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20221220-W51';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20221129-W48';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20221122-W47';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20221115-W46';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20221108-W45';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20221101-W44';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20221024-W43';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20221018-W42';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20221004-W40';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20220926-W39';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20220920-W38';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20220913-W37';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20220816-W33';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20220812-W32';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20220727-W30';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20220719-W29';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20220708-W27';
 --   --DECLARE @p_week                     NVARCHAR(50)        = N'20220712-W28';
 --   DECLARE @p_created_by               NVARCHAR(4000)      = N'iamarock';
 --   DECLARE @p_biz_type                 NVARCHAR(4000)      = N'ALL';
 --   --DECLARE @p_fcst_type                NVARCHAR(4000)      = N'MPS';
 --   DECLARE @p_fcst_type                NVARCHAR(4000)      = N'';
 --   --DECLARE @p_fcst_type                NVARCHAR(4000)      = N'ALL';
 --   DECLARE @p_owner					NVARCHAR(4000)      = N'';
 --   DECLARE @p_user_dept_id			    NVARCHAR(50)        = N'ICO';
 --   DECLARE @p_group_id				    NVARCHAR(50)        = N'ADMIN';
	--DECLARE @p_is_pre_week				NVARCHAR(50)	    = N'T';

--여기부터 WEEKLY 쿼리와 ~FOR_IF 쿼리가 동적쿼리 부분 동일------------------------------------------------------------------------------------------------------
    DECLARE @p_year                     NVARCHAR(4)         = SUBSTRING(@p_week, 1, 4);
    --DECLARE @p_yyyymmww                 NVARCHAR(8)         = SUBSTRING(@p_week, 1, 6) + SUBSTRING(@p_week, 11, 2);
    DECLARE @p_yyyymmww                 NVARCHAR(8)         = '';

    SELECT  @p_yyyymmww = A.ISO_YYYYMMWW
    FROM
            (
                SELECT    MAX(A.YYYYMMDD + '-' + B.WEEK_NAME) AS WNAME
                        , MAX(B.ISO_YYYYMM + SUBSTRING(B.ISO_YYYYWW, 5, 2)) AS ISO_YYYYMMWW
                FROM    DM_MST_VERSION A
                        JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON  
                            A.YYYYMMDD = B.BASIS_YYYYMMDD
                WHERE   1=1
                    AND A.DIVISION_ID           = @p_division_id            -- 사업부별 CUTOFF 날짜가 다를 수 있음!!
                    AND A.VERSION_DESCRIPTION   = 'MKT FCST Weekly Cutoff'  -- 정기 CUTOFF 만 해당
                    AND A.VERSION_TYPE          = 'MF_W'
                GROUP BY B.WEEK_NAME
            ) A
    WHERE   A.WNAME = @p_week;

PRINT '@p_week : ' + @p_week;
PRINT '@p_yyyymmww : ' + @p_yyyymmww;

    --DECLARE @p_yyyymmww                 NVARCHAR(8)         = SUBSTRING(@p_week, 1, 6) + SUBSTRING(@p_week, 11, 2);
    DECLARE @p_program_id	            VARCHAR(50)         ='SCP0092'
    DECLARE @p_sheet_name	            VARCHAR(50)         = 'RTF Archeivement Rate Weekly Report - ' + @p_division_id;

print '@@p_division_id : ' + @p_division_id;
print '@p_year : ' + @p_year;
print '@p_yyyymmww : ' + @p_yyyymmww;

	IF OBJECT_ID(N'tempdb..#TEMP_SCP_RPT_RTF_ARC_RAW', N'U') IS NOT NULL
		DROP TABLE #TEMP_SCP_RPT_RTF_ARC_RAW;
    
    SELECT  *
    INTO    #TEMP_SCP_RPT_RTF_ARC_RAW
    FROM    SCP_RPT_RTF_ARC A
    WHERE   1=1
        AND A.DIVISION_ID  = @p_division_id
        AND A.ISO_YYYYMMWW = @p_yyyymmww
        AND A.IS_PRE_WEEK  = @p_is_pre_week;
--TESTING : OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;;

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


	DECLARE @v_user_mea_cnt INT =0;


    IF OBJECT_ID(N'tempdb..#TBL_CATEGORY', N'U') IS NOT NULL
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

    IF OBJECT_ID(N'tempdb..#TBL_SCP0092_CATEGORY', N'U') IS NOT NULL
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
        AND (
                   (@p_item_id IS NULL OR @p_item_id = '') 
                OR (A.ITEM_ID   IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id, ',')))
                --OR (A.NICK_NAME IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id, ',')))
            )
--select * from #TBL_SCP0092_CATEGORY;return;


	SELECT @v_user_mea_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	    AND U.PROGRAM_ID					= @p_program_id
	    AND U.SHEET_NAME					= @p_sheet_name
	    AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
	    AND U.USER_ID						= @p_created_by;

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

	IF OBJECT_ID(N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL
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


	IF OBJECT_ID(N'tempdb..#TEMP_ITEMS', N'U') IS NOT NULL
		DROP TABLE #TEMP_ITEMS;


    SELECT DISTINCT
              DIVISION_ID
            , ITEM_ID
    INTO    #TEMP_ITEMS
    FROM    SCP_RPT_RTF_ARC


	IF OBJECT_ID(N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V_RTF', N'U') IS NOT NULL
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
	        JOIN #TEMP_ITEMS B ON
                    A.DIVISION_ID = B.DIVISION_ID
                AND A.ITEM_ID     = B.ITEM_ID
            LEFT JOIN SCP_MST_ITEM_CELL_CF C ON
                    A.ITEM_ID     = C.ITEM_ID
                AND A.ITEM_TYPE   = C.CELL_TYPE
                AND A.SPEC        = C.ITEM_SPEC
    WHERE   ((@p_division_id IS NULL OR @p_division_id = '') OR A.DIVISION_ID = @p_division_id)



	IF OBJECT_ID(N'tempdb..#TEMP_SCM_MST_SITE_ITEM_RTF', N'U') IS NOT NULL
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
	        JOIN ( SELECT   --DISTINCT
                            DIVISION_ID
                          --, SCM_SITE_ID
                          , PROJECT_CODE
                          , ITEM_ID
                   FROM     SCP_RPT_RTF_ARC 
                 ) B ON
                    A.DIVISION_ID  = B.DIVISION_ID
                --AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                AND A.PROJECT_CODE = B.PROJECT_CODE
                AND A.ITEM_ID      = B.ITEM_ID
	WHERE A.DIVISION_ID = @p_division_id

--select * from #TEMP_SCM_MST_SITE_ITEM_RTF;return;

	IF OBJECT_ID(N'tempdb..#TEMP_PIC', N'U') IS NOT NULL
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

--TESTING : OK
--select * from #TEMP_TEAM_81;return;

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
--TESTING - OK
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

--TESTING - OK
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
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;

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

--TESTING - OK
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;

    IF OBJECT_ID (N'tempdb..#TBL_SCP0092_WW', N'U') IS NOT NULL 
	    DROP TABLE #TBL_SCP0092_WW

	SELECT    A.DIVISION_ID
		    , A.ITEM_ID
		    , A.ITEM_NAME
            , A.NICK_NAME
		    , A.FCST_TYPE
            --, ISNULL(A.OWNER, N'기타')                                                                        AS PIC                      -- 소계용-자동차/소형
            , ISNULL(A.OWNER, N'기타')                                                                        AS OWNER                    -- 소계용-자동차/소형
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
            , ISNULL(A.DEPT_ID, N'기타')                                                                      AS PRODUCT_GROUP            -- 소계용-소형
		    , A.TEAM_NAME_KO
		    , A.UPPER_DEPT_ID
            --, ISNULL(A.DEPT_NAME_KO, N'기타')                                                                 AS SCM_TEAM                 -- 소계용-자동차
            , ISNULL(A.DEPT_NAME_KO, N'기타')                                                                 AS DEPT_NAME_KO             -- 소계용-자동차
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
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;return;
--select * from #TBL_SCP0092_WW;return;
--select * from #TEMP_SCP_RPT_RTF_ARC_RAW;
--select * from #TBL_SCP0092_WW;return;
--order by 
--              DIVISION_ID
--		    , ITEM_ID
--		    , ITEM_NAME
--            , NICK_NAME
--		    , FCST_TYPE
--            , OWNER
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
--            , DEPT_NAME_KO
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


	-- 컬럼리스트 생성------------------------------------------------------------------------------------------------------------
	BEGIN
        DECLARE @V_COLS		                NVARCHAR(MAX)   = '';
        DECLARE @V_COLS_SUM		            NVARCHAR(MAX)   = '';

        -- @V_DEF_* : I/F용 FULL 데이터셋
        DECLARE @V_DEF_COLS		            NVARCHAR(MAX)   = '';
        DECLARE @V_DEF_COLS_SUM		        NVARCHAR(MAX)   = '';
        DECLARE @V_DEF_SUMS	                NVARCHAR(MAX)   = '';

        DECLARE	@i_count	                INT	            = 0;

		DECLARE @V_COLUMN_NAME		        NVARCHAR(100)   = N'';
		DECLARE @V_COLUMN                   NVARCHAR(1000)  = N'';
		DECLARE @V_COLUMN_RTF               NVARCHAR(1000)  = N'';
		DECLARE @V_COLUMN_RESULT            NVARCHAR(1000)  = N'';
		DECLARE @V_ORDERBY                  NVARCHAR(1000)  = N'';
		DECLARE @V_COLUMN_TEXT              NVARCHAR(1000)  = N'';
		DECLARE @V_PV_COLUMN_NAME           NVARCHAR(100)   = N'';
		DECLARE @V_PV_NAME			        NVARCHAR(50)    = N'';
		DECLARE @V_COLUMN_TYPE              NVARCHAR(50)    = N'';
		DECLARE @V_COLUMN_VALUE             NVARCHAR(50)    = N'';
		DECLARE @V_SORT_ORDER_NO            NVARCHAR(50)    = N'';

		-----	일반 컬럼 -----------------------------------------------------------------------------------------------------------
		SELECT   @i_Count = Count(*)
		FROM    [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
		WHERE   1 = 1
			AND U.PROGRAM_ID                    = @p_Program_Id
			AND U.SHEET_NAME                    = @p_sheet_name
			AND U.USER_ID                       = @p_created_by
			AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'

-- Default Columns beigin ----------------------------------------------------------------------------------------------------------
        SET @V_DEF_COLS         = '';
        SET @V_DEF_COLS_SUM     = '';
        SET @V_DEF_SUMS         = '';

		SELECT    @V_DEF_COLS       = @V_DEF_COLS       + '[' + COLUMN_NAME + '],'
                , @V_DEF_COLS_SUM   = @V_DEF_COLS_SUM   + '[' + COLUMN_NAME + '],'
                , @V_DEF_SUMS       = @V_DEF_SUMS       + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
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
		) T
		ORDER BY    SORT_ORDER_NO

		IF @i_Count = 0
		BEGIN
			SET @V_COLS             = @V_DEF_COLS
		END
		ELSE
		BEGIN
			SELECT    @V_COLS       = @V_COLS       + '[' + COLUMN_NAME + '],'
			FROM
				    (
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

		SELECT @V_COLS          = LEFT(@V_COLS,     LEN(@V_COLS)-1)
	END	--	컬럼생성 끝	---------------------------------------------------------------------------------------------------------------------

print '@V_COLS : ' + @V_COLS;
    SET @V_COLS_SUM = @V_COLS;

    -- @V_COLS에서 키컬럼만 선택
    SET @V_COLS_SUM = REPLACE(@V_COLS_SUM, ',[RTF]',                    '');
    SET @V_COLS_SUM = REPLACE(@V_COLS_SUM, ',[RESULT]',                 '');
    SET @V_COLS_SUM = REPLACE(@V_COLS_SUM, ',[RESULT_WITH_RTF]',        '');
    SET @V_COLS_SUM = REPLACE(@V_COLS_SUM, ',[RATE]',                   '');
    SET @V_COLS_SUM = REPLACE(@V_COLS_SUM, ',[RTF_CELL]',               '');
    SET @V_COLS_SUM = REPLACE(@V_COLS_SUM, ',[RESULT_CELL]',            '');
    SET @V_COLS_SUM = REPLACE(@V_COLS_SUM, ',[RESULT_WITH_RTF_CELL]',   '');
    SET @V_COLS_SUM = REPLACE(@V_COLS_SUM, ',[RATE_CELL]',              '');
    SET @V_COLS_SUM = REPLACE(@V_COLS_SUM, ',[RTF_VS]',                 '');
    SET @V_COLS_SUM = REPLACE(@V_COLS_SUM, ',[RTF_GAP]',                '');
    SET @V_COLS_SUM = REPLACE(@V_COLS_SUM, ',[RTF_REASON]',             '');

print '@V_COLS_SUM : ' + @V_COLS_SUM;

	IF OBJECT_ID(N'tempdb..#TBL_SCP0092_RAW_WW', N'U') IS NOT NULL
		DROP TABLE #TBL_SCP0092_RAW_WW;

    DECLARE @V_SQL      NVARCHAR(MAX)       = N'';

    SET @V_SQL = N'
            SELECT    @V_COLS_SUM
                    , SUM(RTF)                                                                                                    AS RTF
                    , SUM(RTF_CELL)                                                                                               AS RTF_CELL
                    , SUM(RESULT)                                                                                                 AS RESULT
                    , SUM(RESULT_CELL)                                                                                            AS RESULT_CELL
                    --, SUM(RESULT_WITH_RTF)                                                      AS RESULT_WITH_RTF
                    --, SUM(RESULT_WITH_RTF_CELL)                                                 AS RESULT_WITH_RTF_CELL
                    --, SUM(RATE)                                                                 AS RATE
                    --, SUM(RATE_CELL)                                                            AS RATE_CELL
                    , IIF(SUM(RTF)      < SUM(RESULT),      SUM(RTF),      IIF(SUM(RESULT)      < 0, 0, SUM(RESULT)))             AS RESULT_WITH_RTF
                    , IIF(SUM(RTF_CELL) < SUM(RESULT_CELL), SUM(RTF_CELL), IIF(SUM(RESULT_CELL) < 0, 0, SUM(RESULT_CELL)))        AS RESULT_WITH_RTF_CELL
                    , IIF(ISNULL(SUM(RTF), 0) = 0, 0, ISNULL(SUM(RESULT_WITH_RTF), 0) / ISNULL(SUM(RTF), 0) * 100)                AS RATE
                    , IIF(ISNULL(SUM(RTF_CELL), 0) = 0, 0, ISNULL(SUM(RESULT_WITH_RTF_CELL), 0) / ISNULL(SUM(RTF_CELL), 0) * 100) AS RATE_CELL
                    , (ISNULL(SUM(RESULT), 0) - ISNULL(SUM(RTF), 0))                            AS RTF_VS
                    , SUM(RTF_GAP)                                                              AS RTF_GAP
                    , ''''                                                                      AS RTF_REASON
                    , ''1''                                                                     AS VERSION_SORT
            INTO    #TBL_SCP0092_RAW_WW
            FROM    #TBL_SCP0092_WW
            GROUP BY  @V_COLS_SUM;
                    
                    
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

            SELECT    SUM(T.RTF)                                                                                                  AS RTF
                    , SUM(T.RTF_CELL)                                                                                             AS RTF_CELL
		            , SUM(T.RESULT)                                                                                               AS RESULT
                    , SUM(T.RESULT_CELL)                                                                                          AS RESULT_CELL
                    , SUM(RESULT_WITH_RTF)                                                                                        AS RESULT_WITH_RTF
                    , SUM(RESULT_WITH_RTF_CELL)                                                                                   AS RESULT_WITH_RTF_CELL
                    --, SUM(RATE)                                                                 AS RATE
                    --, SUM(RATE_CELL)                                                            AS RATE_CELL
                    --, IIF(SUM(RTF)      < SUM(RESULT),      SUM(RTF),      IIF(SUM(RESULT)      < 0, 0, SUM(RESULT)))             AS RESULT_WITH_RTF
                    --, IIF(SUM(RTF_CELL) < SUM(RESULT_CELL), SUM(RTF_CELL), IIF(SUM(RESULT_CELL) < 0, 0, SUM(RESULT_CELL)))        AS RESULT_WITH_RTF_CELL
                    , IIF(ISNULL(SUM(RTF), 0) = 0, 0, ISNULL(SUM(RESULT_WITH_RTF), 0) / ISNULL(SUM(RTF), 0) * 100)                AS RATE
                    , IIF(ISNULL(SUM(RTF_CELL), 0) = 0, 0, ISNULL(SUM(RESULT_WITH_RTF_CELL), 0) / ISNULL(SUM(RTF_CELL), 0) * 100) AS RATE_CELL
                    , SUM(RESULT) - SUM(RTF)                                                                                      AS RTF_VS
            INTO    #TBL_SCP0092_RAW_WW_TOTAL
            FROM    #TBL_SCP0092_RAW_WW T;

            SELECT  @V_TOTAL_RTF_CELL = RTF_CELL
            FROM    #TBL_SCP0092_RAW_WW_TOTAL;

            UPDATE #TBL_SCP0092_RAW_WW
            SET
              RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
            , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            UPDATE #TBL_SCP0092_RAW_WW_TOTAL
            SET
              RATE      = ISNULL(IIF(RTF = 0, 0, RESULT_WITH_RTF / RTF * 100), 0)
            , RATE_CELL = ISNULL(IIF(RTF_CELL = 0, 0, RESULT_WITH_RTF_CELL / RTF_CELL * 100), 0);

            UPDATE #TBL_SCP0092_RAW_WW
            SET
                RTF_GAP = ISNULL(IIF(@V_TOTAL_RTF_CELL = 0, 0, (RESULT_WITH_RTF_CELL - RTF_CELL) / @V_TOTAL_RTF_CELL * 100), 0);
            
            --FIN
            SELECT  *
            FROM    #TBL_SCP0092_RAW_WW;

            --DEF
            SELECT  *
            FROM    #TEMP_SCP_RPT_RTF_ARC_RAW;

            --TOTAL
            SELECT  *
            FROM    #TBL_SCP0092_RAW_WW_TOTAL;';

    SET @V_SQL = REPLACE(@V_SQL, '@V_COLS_SUM', @V_COLS_SUM);

--TESTING : OK
--exec debug_log @V_SQL, 'T';--return;
	EXEC SP_EXECUTESQL @V_SQL;--return;

	SELECT ISO_WEEK, BASIS_DATE
	FROM [dbo].[SCM_SYS_CALENDAR_M]
	WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8),GETDATE(), 112)

	DECLARE @ORDER NVARCHAR(MAX) = ''

    SELECT  @ORDER = @ORDER + U.COLUMN_NAME + ' ' + U.DATA_SORT_METHOD_CODE + ','
    FROM    [dbo].[SCM_MST_TITLESET_USER] U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
            JOIN SCM_MST_SHEET_COLUMNS M ON
                    U.PROGRAM_ID  = M.PROGRAM_ID
                AND U.SHEET_NAME  = M.SHEET_NAME
                AND U.COLUMN_NAME = M.COLUMN_NAME
                AND U.USER_ID     = M.CREATED_BY
    WHERE   1 = 1
	    AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'C'
	    AND U.PROGRAM_ID					= @p_program_id
	    AND U.SHEET_NAME					= @p_sheet_name
	    AND U.USER_ID						= @p_created_by
        AND M.VALID_YN = 'Y'
    ORDER BY U.SORT_ORDER_NO



	SELECT @ORDER + 'VERSION_SORT DESC' AS DATA_ORDER
print '@ORDER   : ' + CHAR(10) + @ORDER;

------------------------------------------------------------------------------------------
--                                                       Temp Table 존재 여부 체크 (BEGIN)
------------------------------------------------------------------------------------------
	IF OBJECT_ID(N'tempdb..#TEMP_SCP_RPT_RTF_ARC_RAW', N'U') IS NOT NULL
		DROP TABLE #TEMP_SCP_RPT_RTF_ARC_RAW
    IF OBJECT_ID(N'tempdb..#TBL_CATEGORY', N'U') IS NOT NULL
		DROP TABLE #TBL_CATEGORY
    IF OBJECT_ID(N'tempdb..#TBL_SCP0092_CATEGORY', N'U') IS NOT NULL
		DROP TABLE #TBL_SCP0092_CATEGORY
	IF OBJECT_ID(N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL
		DROP TABLE #SELECT_MEASURE
	IF OBJECT_ID(N'tempdb..#TEMP_ITEMS', N'U') IS NOT NULL
		DROP TABLE #TEMP_ITEMS
	IF OBJECT_ID(N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V_RTF', N'U') IS NOT NULL
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V_RTF
	IF OBJECT_ID(N'tempdb..#TEMP_SCM_MST_SITE_ITEM_RTF', N'U') IS NOT NULL
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM_RTF
	IF OBJECT_ID(N'tempdb..#TEMP_PIC', N'U') IS NOT NULL
		DROP TABLE #TEMP_PIC
	IF OBJECT_ID(N'tempdb..#TEMP_SCP_RPT_RTF_ARC_RAW', N'U') IS NOT NULL
		DROP TABLE #TEMP_SCP_RPT_RTF_ARC_RAW
	IF OBJECT_ID(N'tempdb..#TBL_SCP0092_RAW_WW', N'U') IS NOT NULL
		DROP TABLE #TBL_SCP0092_RAW_WW
	IF OBJECT_ID(N'tempdb..#TBL_SCP0092_RAW_WW_TOTAL', N'U') IS NOT NULL
		DROP TABLE #TBL_SCP0092_RAW_WW_TOTAL
END
