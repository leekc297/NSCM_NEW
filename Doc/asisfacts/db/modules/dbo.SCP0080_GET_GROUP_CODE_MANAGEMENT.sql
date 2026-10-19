

/*
 * Program ID   : SCP0080_GET_GROUP_CODE_MANAGEMENT
 * Description  : 전진검사용 GROUP CODE 관리 ITEM 조회
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 * 2021/08/17   kmj			    V1.0.0    [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - initial release
 * 2022/09/06   LWY                       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - PIC 컬럼(모델별 담당자) ID, NAME 추가
 * 2022/09/21   chaan		    V1.1.1    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Sales Model Master 추가
 * 2022/10/04   chaan		    V1.1.2    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 소형사업부 -> Level2 -> Cell Type Gr 로 사용
 * 2022/10/27   jahn1501		          PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - p_check_active 조건 추가
 * 2023/01/25   jahn1501		          PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - column 추가 (Level1 Group, Level2 Code, Status_Prototype, Status_Mass, Status_New)
 * 2023/02/20   jahn1501		          PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - column 추가 (Application, Cell type, Cell capacity, Total Capacity, End Customer, Finished product)
 * 2023/03/14   chaan		    V1.1.3    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - column 추가 (Biz type, Remark, Active)
                                                                                                             ~ Application full name 으로 수정
                                                                                                             ~ Cell capacity 로직 변경
                                                                                                             ~ UI->BOM 표시 로직 변경
                                                                                                             ~ Cell Capacity를 int로 변경
                                                                                                             ~ Total Capacity 산식 추가
 * 2023/03/23   chaan		    V1.1.4    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 소형사업부 -> Operation 'F' 추가
 * 2023/03/29   chaan		    V1.1.5    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 자동차 - 컬럼명 수정 및 로직 변경
 * 2023/03/29   chaan		    V1.1.6    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 자동차 - STATUS_PROTOTYPE 조회 로직 수정
 * 2023/04/12   chaan		    V1.1.7    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS 사업부 추가(추가 컬럼 : PLANT_ID, PLANT_NAME, CATHODE, CELL_CAPACITY, TOTAL_CAPACITY)
                                                                                                           ~ 최종 데이터 정렬기준 변경(데이터 수정때마다 새로 정렬되어 찾기 어려움)
 * 2023/04/19   chaan		    V1.1.8    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 모델 중복 에러 수정 (#TblGroupCode_SP0080_MASS 미사용)
 *                                                                                                          ~ 소형 사업부 수정안 적용
 *                                                                                                          ~ ESS CELL_TYPE_GROUP 조인 오류 수정
 * 2023/04/24   chaan		    V1.1.9    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS Model Type 추가
 * 2023/05/04   chaan		    V1.1.10   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 소형 -> Product level1 누락 수정
 * 2023/05/10   chaan		    V1.1.11   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 소형 -> ITEM_ID 중복 조회 수정(SCP_EXTRA_SPEC NULL 배제)
                                                                                                           소형 -> CELL_CF 로직 수정(A3000 추가)
                                                                                                           자동차 -> ITEM_ID 중복 조회 수정(#TblGroupCode_SP0080_PLANT 첫번째행 선택으로 중복 배제)
 * 2023/06/01   chaan		    V1.1.12   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 소형 -> Product Level1(CELL_TYPE_GROUP_NAME) 로직 변경
                                                                                                                -> Product Level2(SCP_EXTRA_SPEC) 로직 변경
                                                                                                                -> Product Level3(BASIC_NICKNAME_CELL) 로직 변경
                                                                                                                -> Product Level4(NICKNAME_40) 로직 변경
 * 2023/06/14   chaan  		    V1.1.13   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 활성화 코드 분리
 * 2023/06/14   chaan	  	    V1.1.14   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CELL_MODEL, CELL_MODEL_NICKNAME 로직 81,82 동일하게 전개
 * 2023/06/22   chaan	  	    V1.1.16   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 82 ~ BASIC_CELL_CAPACITY, BASIC_TOTAL_CAPACITY 로직 수정
 * 2023/06/23   chaan	  	    V1.1.17   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 82 ~ n개의 ENERGE 조회시 선정 기준 적용(1순위 : comapny = 'C100', 2순위 : comapny = 'C100' & top 1)
 * 2023/07/03   chaan		    V1.1.18   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - [LGCE_FP_TR].[dbo].SCM_ITEM_M 시노님으로 변경(dbo.SCM_MST_ITEM_SN)
 * 2023/07/12   chaan		    V1.1.19   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 전체 컬럼 조회 부분을 공통 함수로 추출->동일한 로직을 Mailing 에서 사용함
 *                                                                                                          자동차 - 'Replacement Y/N' 컬럼추가
 * 2023/09/12   chaan		    V1.1.20   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - JV Division에 대해서 81과 동일 컬럼/로직으로 수정(81_UC, 81_HM, 81_ST 에 대해서 81과 동일 기준)
 * 2024-01-08   chaan           V1.1.21   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
 * 2024-01-19   chaan           V1.1.22   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - 2차 튜닝
 */

CREATE PROCEDURE [dbo].[SCP0080_GET_GROUP_CODE_MANAGEMENT]
--CREATE PROCEDURE [dbo].[SCP0080_GET_GROUP_CODE_MANAGEMENT]
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
AS
BEGIN
    SET NOCOUNT ON;
    SET ANSI_NULLS ON;
    SET ANSI_WARNINGS ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


    --DECLARE @p_division_id			NVARCHAR(1000)			= '81_HM';
    --DECLARE @p_operation_id			NVARCHAR(1000)			= '';
    --DECLARE @p_model_id				NVARCHAR(1000)			= '';
    --DECLARE @p_nickname				NVARCHAR(1000)			= '';
    --DECLARE @p_check_fcst			NVARCHAR(1000)			= 'N';
    --DECLARE @p_check_production		NVARCHAR(1000)			= 'N';
    --DECLARE @p_check_active			NVARCHAR(1)				= 'N';
    --DECLARE @p_check_bom			NVARCHAR(1)				= 'N';
    --DECLARE @p_user_id				NVARCHAR(1000)			= 'iamarock';
    --DECLARE @debug_mode				NVARCHAR(1)				= 'F'


    DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;


    IF OBJECT_ID (N'tempdb..#TblGroupCode_SP0080', N'U') IS NOT NULL
		DROP TABLE #TblGroupCode_SP0080

    SELECT  *
    INTO    #TblGroupCode_SP0080
    FROM    dbo.FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
            (
                  @p_division_id
                , @p_operation_id
                , @p_model_id
                , @p_nickname
                , @p_check_fcst
                , @p_check_production
                , @p_check_active
                , @p_check_bom
                , @p_user_id
                , @debug_mode
            )

--TESTING : OK
--select * from #TblGroupCode_SP0080;return;


	IF OBJECT_ID('tempdb..#TblUserColumns_SP0080') IS NOT NULL
		DROP TABLE  #TblUserColumns_SP0080;

    DECLARE @V_PROGRAM_ID		 AS NVARCHAR(MAX)   = N'SCP0080';
    DECLARE @V_SHEET_NAME		 AS NVARCHAR(MAX)   = N'Group Code Management';

    SET     @V_SHEET_NAME		                    = @V_SHEET_NAME + IIF(@p_division_id IN ('81', '82', '40') OR SUBSTRING(@p_division_id, 1, 2) = '81', ' - ' + @p_division_id, '');

    DECLARE @V_COLUMNS	    	 AS NVARCHAR(MAX)   = N'';
    DECLARE @V_ORDERS		     AS NVARCHAR(MAX)   = N'';

    SELECT    @V_COLUMNS = @V_COLUMNS + '[' + COLUMN_NAME + '],'
            , @V_ORDERS  = @V_ORDERS  + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
    FROM
            (
                SELECT    SORT_ORDER_NO
                        , COLUMN_NAME
                        , DATA_SORT_METHOD_CODE
                FROM    [dbo].[SCM_MST_SHEET_COLUMNS] WITH(NOLOCK)
                WHERE   1=1
                    AND PROGRAM_ID      = @V_PROGRAM_ID
                    AND SHEET_NAME      = @V_SHEET_NAME
                    AND VALID_YN        = 'Y'
                    AND VISIBLE_FLAG    = 'Y'
            ) A
    ORDER BY SORT_ORDER_NO

    IF (RIGHT(@V_COLUMNS, 1) = ',')
    BEGIN
        SET @V_COLUMNS  = LEFT(@V_COLUMNS, LEN(@V_COLUMNS)-1)
    END

    IF (RIGHT(@V_ORDERS, 1) = ',')
    BEGIN
        SET @V_ORDERS  = LEFT(@V_ORDERS, LEN(@V_ORDERS)-1)
    END

    --최종 데이터 정렬기준 변경(데이터 수정때마다 새로 정렬되어 찾기 어려움)
    SET @V_ORDERS  = '[DIVISION_ID] ,[OPERATION_ID] ,[BIZ_TYPE] ,[ITEM_ID]'

    DECLARE @V_SQL		     AS NVARCHAR(MAX)   = N'';

    SET @V_SQL = N'
                    SELECT      ' + @V_COLUMNS + '
                    FROM        #TblGroupCode_SP0080
                    ORDER BY    ' + @V_ORDERS

	IF @debug_mode ='T'
	BEGIN
		--PRINT '@V_COLUMNS : ' + @V_COLUMNS;
		--PRINT '@V_ORDERS : ' + @V_ORDERS;
		PRINT '@V_SQL : ' + @V_SQL;

		--TESTING : NOK
		--select * from #TblGroupCode_SP0080;return;

		PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

		--SELECT * FROM #TblGroupCode_SP0080;
	END;

	EXEC(@V_SQL)

	IF @debug_mode ='T'
	BEGIN
		PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
	END;

	IF OBJECT_ID('tempdb..#TblUserColumns_SP0080') IS NOT NULL
		DROP TABLE  #TblUserColumns_SP0080;
END
