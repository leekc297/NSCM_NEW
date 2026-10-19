


/*
 * Program ID   : PR_SCP_ANL_MAT_SUPPLY_BATCH
 * Description  : 자재 제약 가시화 집계 => SCP_ANL_MAT_SUPPLY 에 저장
 * Program History
 *================================================================================================================================================
 *   Date       In Charge                           Description
 *================================================================================================================================================
 * 2024/01/18	chaan					V1.2.1		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial release - 집계일자를 특정해서 집계하기 위해 프로시저 분리
 * 2025.08.01   hrkim								PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 공정 하드코딩 변경 
 *
 */


CREATE PROCEDURE [dbo].[PR_SCP_ANL_MAT_SUPPLY_BATCH]
	  @p_scp_plan_start_yyyymmdd      VARCHAR(8)
	, @p_mrp_plan_start_yyyymmdd      VARCHAR(8)
AS
BEGIN
    DECLARE @v_test_mode        NVARCHAR(1)     = 'F';
    --DECLARE @v_test_mode        NVARCHAR(1)     = 'T';

	--DECLARE		@p_scp_plan_start_yyyymmdd      VARCHAR(8)	= '';
	--DECLARE		@p_mrp_plan_start_yyyymmdd      VARCHAR(8)	= '';



	-- LOG 용 변수 설정
    DECLARE @v_program_name     NVARCHAR(150)   = 'PR_SCP_ANL_MAT_SUPPLY_BATCH'
    DECLARE @v_log_type         NVARCHAR(30)     -- START/END/ERROR/...
    DECLARE @n_log_count        INTEGER         = 0
    DECLARE @v_log_message      NVARCHAR(1000)  
    DECLARE @v_description      NVARCHAR(500)
    DECLARE @d_event_date       DATETIME    = SYSDATETIME();

    DECLARE @V_ELAPSED_TIME_BEG             DATETIME            = CURRENT_TIMESTAMP;

	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] Cell 완성 공정 하드 코딩 변경 (임시테이블 변수)
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final 공정 정보 - Cell Packaging/Assembly' 
	------------------------------------------------------------------------------------------------------------------
	 DECLARE @SCP_CELL_FINAL_OPERATION TABLE
	 (
		   OPERATION_ID					NVARCHAR(30)	NULL
	 )

	INSERT INTO @SCP_CELL_FINAL_OPERATION
	SELECT DISTINCT SEGMENT1 AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'	 -- 공정그룹 (Cell)
	   AND LK.ATTRIBUTE1  = 'Y'	 -- Final Operation
	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] Cell 계획 공정 하드 코딩 변경 (임시테이블 변수) 
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell 계획 공정 정보 전체' 
	------------------------------------------------------------------------------------------------------------------
	 DECLARE @SCP_CELL_PLAN__OPERATION_ALL TABLE
	 (
		   OPERATION_ID					NVARCHAR(30)	NULL
	 )

	INSERT INTO @SCP_CELL_PLAN__OPERATION_ALL
	SELECT DISTINCT SEGMENT1 AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE	= 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	    = 'A'  -- 공정그룹 (Cell)
	   AND LK.VALID_YN		= 'Y'  -- SCP 계획 공정 여부
	------------------------------------------------------------------------------------------------------------------

	BEGIN TRAN

    BEGIN TRY
		SET @v_log_type         = 'START'
		SET @v_log_message      = '########## Start of procedure ##########'
		SET @v_description      = ''

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END


	    DECLARE		@v_curr_date	                DATETIME	= GETDATE();
	    DECLARE		@v_today    	                VARCHAR(8)	= FORMAT(@v_curr_date,'yyyyMMdd');
	    DECLARE		@v_this_monday	                VARCHAR(8)	= '';
	    DECLARE		@v_last_monday	                VARCHAR(8)	= '';
	    DECLARE		@v_this_thursday	            VARCHAR(8)	= '';
	    DECLARE		@v_scp_plan_start_yyyymmdd      VARCHAR(8)	= '';
	    DECLARE		@v_mrp_plan_start_yyyymmdd      VARCHAR(8)	= '';
	    DECLARE		@v_mrp_plan_start_yyyymmdd_pre  VARCHAR(8)	= '';
	    DECLARE		@v_scp_plan_limit_yyyymmdd      VARCHAR(8)	= '';

	    SELECT @v_this_monday	    = FORMAT(DATEADD(DD, 2 - DATEPART(DW, DATEADD(DD, -1, @v_curr_date)), DATEADD(DD, -1, @v_curr_date)), 'yyyyMMdd');
        SELECT @v_last_monday       = FORMAT(DATEADD(WK, DATEDIFF(WK, 6, CASE DATEPART(dw, @v_curr_date) WHEN 1 THEN DATEADD(d, -1, @v_curr_date) ELSE @v_curr_date END), 0), 'yyyyMMdd');
        SELECT @v_this_thursday     = FORMAT(DATEADD(DD, 5 - DATEPART(dw, @v_curr_date), @v_curr_date),'yyyyMMdd')

        PRINT CONCAT('@v_this_monday : ', @v_this_monday);
        PRINT CONCAT('@v_last_monday : ', @v_last_monday);
        PRINT CONCAT('@v_this_thursday : ', @v_this_thursday);
        --return;

        IF @v_today >= @v_this_thursday --현재일자가 목요일이후면 목요일, 아니면 월요일로 @v_mrp_plan_start_yyyymmdd 설정
        BEGIN
            SET @v_mrp_plan_start_yyyymmdd	=	@v_this_thursday;

            SELECT  TOP 1
					@v_scp_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
			FROM    SCP_PLAN_VERSION_V WITH(NOLOCK)
			WHERE   1=1
				AND PLAN_TYPE		='FN'
				AND CONFIRM_FLAG	='Y'
				AND PLAN_START_YYYYMMDD	<= @v_this_thursday
			GROUP BY PLAN_START_YYYYMMDD
			ORDER BY PLAN_START_YYYYMMDD DESC;
        END
        ELSE
        BEGIN
            SET @v_mrp_plan_start_yyyymmdd	=	@v_this_monday;

            SELECT  TOP 1
					@v_scp_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
			FROM    SCP_PLAN_VERSION_V WITH(NOLOCK)
			WHERE   1=1
				AND PLAN_TYPE		='FN'
				AND CONFIRM_FLAG	='Y'
				AND PLAN_START_YYYYMMDD	<= @v_last_monday
			GROUP BY PLAN_START_YYYYMMDD
			ORDER BY PLAN_START_YYYYMMDD DESC;
        END

        --특정 날짜의 데이터를 집계 할 때는 여기서 @v_mrp_plan_start_yyyymmdd, @v_scp_plan_start_yyyymmdd 를 특정 날짜로 설정한다
        --SET @v_scp_plan_start_yyyymmdd  = '20231030'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231106'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231106'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231109'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231106'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231113'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231113'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231116'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231113'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231120'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231120'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231123'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231120'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231127'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231127'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231130'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231127'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231204'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231204'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231207'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231204'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231211'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231211'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231214'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20231211'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20231218'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20240101'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20240108'; --testing
        --SET @v_scp_plan_start_yyyymmdd  = '20240108'; --testing
        --SET @v_mrp_plan_start_yyyymmdd  = '20240115'; --testing
        --rollback tran;return;
		
		--파라미터가 비었으면 현재 날짜 기준으로 계획일자 구한다
		IF (@p_scp_plan_start_yyyymmdd IS NOT NULL) AND (@p_scp_plan_start_yyyymmdd <> '')
		BEGIN
			SET @v_scp_plan_start_yyyymmdd  = @p_scp_plan_start_yyyymmdd;
		END

		IF (@p_mrp_plan_start_yyyymmdd IS NOT NULL) AND (@p_mrp_plan_start_yyyymmdd <> '')
		BEGIN
			SET @v_mrp_plan_start_yyyymmdd  = @p_mrp_plan_start_yyyymmdd;
		END


        --생산계획 기간을  MRP_PLAN_START_YYYYMMDD + 365일로 제한
        SELECT @v_scp_plan_limit_yyyymmdd = FORMAT(DATEADD(D, 365, @v_scp_plan_start_yyyymmdd), 'yyyyMMdd');
        
        -- mrp 계획 시작 전날(반제품 재고(BOH) 쿼리용)
        SELECT @v_mrp_plan_start_yyyymmdd_pre = FORMAT(DATEADD(D, -1, @v_mrp_plan_start_yyyymmdd), 'yyyyMMdd');
        


        PRINT CONCAT('@v_mrp_plan_start_yyyymmdd : ', @v_mrp_plan_start_yyyymmdd);
        PRINT CONCAT('@v_scp_plan_start_yyyymmdd : ', @v_scp_plan_start_yyyymmdd);
        PRINT CONCAT('@v_scp_plan_limit_yyyymmdd : ', @v_scp_plan_limit_yyyymmdd);
        --rollback tran;return;



        PRINT N'DELETE dbo.SCP_ANL_MAT_SUPPLY - BEGIN';

        DELETE
        FROM    dbo.SCP_ANL_MAT_SUPPLY
        WHERE   1=1
            AND SCP_PLAN_START_YYYYMMDD = @v_scp_plan_start_yyyymmdd
            AND MRP_PLAN_START_YYYYMMDD = @v_mrp_plan_start_yyyymmdd;

        PRINT N'DELETE dbo.SCP_ANL_MAT_SUPPLY - END';
        PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


        PRINT N'#TBL_SCP0103_OPERATION_GROUOP - BEGIN';
        IF OBJECT_ID('tempdb..#TBL_SCP0103_OPERATION_GROUOP') IS NOT NULL
	        DROP TABLE #TBL_SCP0103_OPERATION_GROUOP;

        SELECT    B.SEGMENT1    AS OPERATION_ID
                , B.SEGMENT3    AS OPERATION_GROUP
        INTO    #TBL_SCP0103_OPERATION_GROUOP
        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
        WHERE A.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	        AND A.VALID_YN = 'Y'
	        AND B.VALID_YN = 'Y'
        PRINT N'#TBL_SCP0103_OPERATION_GROUOP - END';



        PRINT N'DIVISION_SITE - BEGIN';

        IF OBJECT_ID('tempdb..#TBL_SCP0103_PLANT_ALL') IS NOT NULL
	        DROP TABLE #TBL_SCP0103_PLANT_ALL;

        SELECT    COMPANY_ID
                , DIVISION_ID
                , SCM_SITE_ID
                , PLANT_ID
                , OPERATION_GROUP
        INTO    #TBL_SCP0103_PLANT_ALL
        FROM    SCM_MST_SITE B WITH(NOLOCK)
        WHERE	1=1
            AND VALID_YN = 'Y'
            AND COMPANY_ID IS NOT NULL
            AND PLANT_ID IS NOT NULL
        GROUP BY  COMPANY_ID
                , DIVISION_ID
                , SCM_SITE_ID
                , PLANT_ID
                , OPERATION_GROUP;

        --IF OBJECT_ID('tempdb..#TBL_SCP0103_DIVISION_SITE') IS NOT NULL
	       -- DROP TABLE #TBL_SCP0103_DIVISION_SITE;

        --SELECT DISTINCT
        --          A.COMPANY_ID
        --        , C.DIVISION_ID
        --        , ISNULL(C.ORIGIN_DIVISION_ID, A.DIVISION_ID)       AS ORIGIN_DIVISION_ID
        --        , C.OPERATION_GROUP
        --        , A.PLANT_ID
        --        , C.SCM_SITE_ID
        --        , ISNULL(C.LINE_ID, '-')                            AS LINE_ID
        --        , C.OPERATION_ID
        --INTO    #TBL_SCP0103_DIVISION_SITE
        --FROM    (
        --                    SELECT    ATTRIBUTE2    AS DIVISION_ID
        --                            , ATTRIBUTE1    AS ORIGIN_DIVISION_ID
        --                            , SEGMENT2      AS OPERATION_GROUP
        --                            , SEGMENT3      AS SCM_SITE_ID
        --                            , SEGMENT4      AS LINE_ID
        --                            , SEGMENT5      AS OPERATION_ID
        --                    FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        --                    WHERE   1=1
        --                        AND LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
        --                        AND SEGMENT1    = 'SCP'
        --                        AND VALID_YN    = 'Y'
        --                    GROUP BY  ATTRIBUTE2
        --                            , ATTRIBUTE1
        --                            , SEGMENT2
        --                            , SEGMENT3
        --                            , SEGMENT4
        --                            , SEGMENT5
        --                    UNION ALL
        --                    SELECT    ATTRIBUTE1    AS DIVISION_ID
        --                            , ATTRIBUTE1    AS ORIGIN_DIVISION_ID
        --                            , SEGMENT2      AS OPERATION_GROUP
        --                            , SEGMENT3      AS SCM_SITE_ID
        --                            , SEGMENT4      AS LINE_ID
        --                            , SEGMENT5      AS OPERATION_ID
        --                    FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        --                    WHERE   1=1
        --                        AND LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
        --                        AND SEGMENT1    = 'SCP'
        --                        AND VALID_YN    = 'Y'
        --                    GROUP BY  ATTRIBUTE2
        --                            , ATTRIBUTE1
        --                            , SEGMENT2
        --                            , SEGMENT3
        --                            , SEGMENT4
        --                            , SEGMENT5
        --        ) C
        --        LEFT JOIN dbo.SCM_MST_SITE A WITH(NOLOCK) ON
        --                C.ORIGIN_DIVISION_ID    = A.DIVISION_ID
        --            AND C.SCM_SITE_ID           = A.SCM_SITE_ID
        --        LEFT JOIN (
        --                        SELECT  PLANT_ID
        --                        FROM    dbo.SCM_DNM_MAT_MRP_SUPPLY
        --                        WHERE   1=1
        --                            AND CUTOFF_DATE = @v_mrp_plan_start_yyyymmdd
        --                        GROUP BY PLANT_ID
        --                   ) B ON
        --                A.PLANT_ID = B.PLANT_ID
        --WHERE   1=1
        --    AND A.VALID_YN = 'Y'
        --    AND ISNULL(A.COMPANY_ID, '') <> ''
        --    AND ISNULL(A.PLANT_ID, '') <> ''
        --    AND ISNULL(C.OPERATION_ID, '') <> '';

        PRINT N'DIVISION_SITE - END';
        PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : OK
--select * from #TBL_SCP0103_DIVISION_SITE;rollback tran;return;


		PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

        PRINT N'PLANT - BEGIN';
        IF OBJECT_ID('tempdb..#TBL_SCP0103_PLANT') IS NOT NULL
	        DROP TABLE #TBL_SCP0103_PLANT;

            SELECT DISTINCT
                    CASE
                        WHEN OPERATION_GROUP =  'E' AND CHARINDEX('_', DIVISION_ID) > 1 THEN CONCAT('EE_', SUBSTRING(DIVISION_ID, 4, 2))
                        WHEN OPERATION_GROUP =  'E' AND CHARINDEX('_', DIVISION_ID) = 0 THEN 'EE'
                        WHEN OPERATION_GROUP <> 'E' THEN DIVISION_ID
                        ELSE ''
                      END AS DIVISION_ID
                    , SUBSTRING(DIVISION_ID, 1, 2)          AS ORIGIN_DIVISION_ID
                    , PLANT_ID
            INTO    #TBL_SCP0103_PLANT
            FROM    [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
            WHERE   1=1
                AND A.DEPT_ID   = 'PLANT'
                AND A.PLANT_ID IS NOT NULL
                AND A.VALID_YN  = 'Y'

--TESTING : OK
--select * from #TBL_SCP0103_PLANT;rollback tran;return;

        PRINT N'PLANT - END';
		PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

        PRINT N'EE PLANT - BEGIN';
        IF OBJECT_ID('tempdb..#TBL_SCP0103_EE_PLANT') IS NOT NULL
	        DROP TABLE #TBL_SCP0103_EE_PLANT;

        SELECT    B.SEGMENT1 AS ASSY_DIVISION_ID
                , B.SEGMENT2 AS ASSY_PLANT_ID
                , B.SEGMENT3 AS ELEC_DIVISION_ID
                , B.SEGMENT4 AS ELEC_PLANT_ID
        INTO    #TBL_SCP0103_EE_PLANT
        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
        WHERE   A.LOOKUP_TYPE   = 'EE_ASSY_PLANT_MAPPING'
            AND A.VALID_YN      = 'Y'
            AND B.VALID_YN      = 'Y'
        PRINT N'EE PLANT - END';

--TESTING : OK
--select * from #TBL_SCP0103_PLANT;return;

        PRINT N'OPERATION - BEGIN';
        IF OBJECT_ID('tempdb..#TBL_SCP0103_OPERATION') IS NOT NULL
	        DROP TABLE #TBL_SCP0103_OPERATION;

        SELECT  SEGMENT4 AS OPERATION_ID
        INTO    #TBL_SCP0103_OPERATION
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE   1=1
            AND LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
            AND VALID_YN    = 'Y'
        GROUP BY SEGMENT4;
        PRINT N'OPERATION - END';
		PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : OK
--select * from #TBL_SCP0103_OPERATION;return;


        PRINT N'ITEM/OPERATION(모든 아이템에 대해 OPERATION 매핑) - BEGIN';
        IF OBJECT_ID('tempdb..#TBL_SCP0103_ITEM_OPERATION') IS NOT NULL
	        DROP TABLE #TBL_SCP0103_ITEM_OPERATION;

        SELECT DISTINCT
                  A.COMPANY_ID
                , A.DIVISION_ID
                , A.ITEM_ID
                , B.SEGMENT4    AS OPERATION_ID
        INTO    #TBL_SCP0103_ITEM_OPERATION
        FROM    SCM_MST_ITEM_SN A WITH(NOLOCK)
                INNER JOIN (
                                SELECT  *
                                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                WHERE   1=1
                                    AND LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                    AND VALID_YN    = 'Y'
                            ) B ON
                                A.SCP_FLOW_ID = B.SEGMENT2
        PRINT N'ITEM/OPERATION(모든 아이템에 대해 OPERATION 매핑) - END';



        PRINT N'#TBL_SCP0103_ITEM_UOM - BEGIN';
        IF OBJECT_ID('tempdb..#TBL_SCP0103_ITEM_UOM') IS NOT NULL
	        DROP TABLE #TBL_SCP0103_ITEM_UOM;

        SELECT    DIVISION_ID
                , ITEM_ID
                , ITEM_UOM  AS UOM
        INTO    #TBL_SCP0103_ITEM_UOM
        FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
        WHERE   1=1
            AND ACTIVE_FLAG    = 'Y'
        GROUP BY  DIVISION_ID
                , ITEM_ID
                , ITEM_UOM;
        PRINT N'#TBL_SCP0103_ITEM_UOM - END';
		PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
--TESTING : OK
--select * from #TBL_SCP0103_ITEM_UOM;return;


        PRINT N'Summary SCP Plan - BEGIN ===============================================================================================================================================================';
        BEGIN
            PRINT  N'생산계획에 적용할 수율 목록 - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_YIELD') IS NOT NULL
                DROP TABLE #TBL_SCP0103_YIELD;

	        SELECT	  A.DIVISION_ID
			        , A.PLANT_SITE_ID
			        , A.ITEM_ID
			        , A.OPERATION_ID
			        , A.TACT_TIME_START_DATE
			        , A.TACT_TIME_END_DATE
			        , AVG(A.YIELD)        AS YIELD
	        INTO    #TBL_SCP0103_YIELD
	        FROM	dbo.SCP_MST_TACT_TIME_EXCEPT A WITH(NOLOCK)
                    INNER JOIN #TBL_SCP0103_OPERATION B ON
                            A.OPERATION_ID = B.OPERATION_ID
	        WHERE	1=1
		        --LINE 무시 AND A.LINE_ID  = '-'
                --유동적이므로 SCM_ADM_LOOKUP_MASTER_DETAIL로 대체 AND A.OPERATION_ID IN ('E2000', 'A3000', 'A9000', 'P5500', 'P9500')
                AND A.YIELD   <> 0
                AND A.USE_YN   = 'Y'
            GROUP BY  A.DIVISION_ID
			        , A.PLANT_SITE_ID
			        , A.ITEM_ID
			        , A.OPERATION_ID
			        , A.TACT_TIME_START_DATE
			        , A.TACT_TIME_END_DATE;
            PRINT  N'생산계획에 적용할 수율 목록 - END';
			PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : OK
--select * from #TBL_SCP0103_YIELD;rollback tran;return;

            PRINT  N'생산계획에 해당하는 최종 PLAN SEQ 구하기 - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_TYPE') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_SCP_PLAN_TYPE;

	        SELECT	  A.DIVISION_ID
				    , A.PLAN_NAME
				    , A.PLAN_ID
				    , A.PLAN_TYPE
				    , A.PLAN_SEQ
            INTO    #TBL_SCP0103_SCP_PLAN_TYPE
	        FROM	(
				        SELECT	  D.DIVISION_ID
						        , P.PLAN_NAME
						        , D.PLAN_ID
						        , D.PLAN_TYPE
						        , MAX(D.PLAN_SEQ) PLAN_SEQ
						        , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID ORDER BY D.PLAN_ID DESC) RN
						        , DENSE_RANK() OVER (ORDER BY D.DIVISION_ID ASC) ROWIDX
				        FROM	dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						        INNER JOIN dbo.SCM_MST_PLAN P WITH(NOLOCK) ON
								        D.DIVISION_ID  = P.DIVISION_ID
							        AND D.PLAN_ID      = P.PLAN_ID
							        AND D.PLAN_STATUS  = '1'
							        AND D.CONFIRM_FLAG = 'Y'
							        AND D.PLAN_TYPE    = 'FN'
				        WHERE	1=1
                            AND P.PLAN_NAME     = @v_scp_plan_start_yyyymmdd
					    GROUP BY D.DIVISION_ID, P.PLAN_NAME, D.PLAN_ID, D.PLAN_TYPE
			        ) A
	        WHERE	1=1
		        AND RN = 1
                --AND LEFT(DIVISION_ID, 2) <> 'EE'; -- EE 사업부는 생산계획에서 제외하고 실 사업부들(81/82/40) 집계가 끝난후 실사업부들의 계획을 MRP->PLANT 로 찾아 취합한다.

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_TYPE;return;
            PRINT  N'생산계획에 해당하는 최종 PLAN SEQ 구하기 - END';
			PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


            PRINT  N'최종 PLAN SEQ 에 해당하는 생산 계획 찾기 - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_FN') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_SCP_FN;

		    SELECT	  A.DIVISION_ID
				    , A.PLAN_START_YYYYMMDD
				    , A.OPERATION_GROUP
				    , A.SCM_SITE_ID
				    , A.ITEM_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.MEASURE
				    , A.YYYYMMDD
				    , A.QTY
				    , A.DIVISION_NAME
				    , A.OPERATION_GROUP_NAME
				    , A.SCM_SITE_DESCRIPTION
				    , A.NICK_NAME
				    , A.ORIGIN_DIVISION_ID
				    , A.ELECTRODE_TYPE
            INTO    #TBL_SCP0103_SCP_FN
		    FROM	SCP_ANL_PRODUCTION_PLAN_C A WITH(NOLOCK)
                    INNER JOIN #TBL_SCP0103_SCP_PLAN_TYPE B ON
			                A.DIVISION_ID           = B.DIVISION_ID
			                --A.ORIGIN_DIVISION_ID    = B.DIVISION_ID
			            AND A.PLAN_START_YYYYMMDD   = B.PLAN_NAME
                        AND A.PLAN_TYPE             = B.PLAN_TYPE
                        AND A.SEQ                   = B.PLAN_SEQ
                    INNER JOIN #TBL_SCP0103_OPERATION C ON
                            A.OPERATION_ID = C.OPERATION_ID
            WHERE   1=1
                AND A.YYYYMMDD <= @v_scp_plan_limit_yyyymmdd --생산계획 기간을  MRP_PLAN_START_YYYYMMDD + 365일로 제한
                AND A.MEASURE IN ('PROD_PLAN_AMEND')
                AND A.LINE_ID <> '-'
			    AND A.QTY	  <> 0
                --AND LEFT(A.DIVISION_ID, 2) <> 'EE'; -- EE 사업부는 생산계획에서 제외하고 실 사업부들(81/82/40) 집계가 끝난후 실사업부들의 계획을 MRP->PLANT 로 찾아 취합한다.

            PRINT  N'최종 PLAN SEQ 에 해당하는 생산 계획 찾기 - END';
			PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
--TESTING : OK
--select * from #TBL_SCP0103_OPERATION;
--select * from #TBL_SCP0103_SCP_PLAN_TYPE;
--select * from #TBL_SCP0103_SCP_FN;rollback tran;return;


            PRINT  N'최종 PLAN SEQ 에 해당하는 생산 계획 찾기 - LINE제거 - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_FN_LINE') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_SCP_FN_LINE;

		    SELECT	  A.DIVISION_ID
				    , A.PLAN_START_YYYYMMDD
				    , A.SCM_SITE_ID
				    , A.ITEM_ID
				    , A.OPERATION_ID
				    , A.MEASURE
				    , A.YYYYMMDD
				    , SUM(A.QTY)                AS QTY
				    , A.DIVISION_NAME
				    , A.OPERATION_GROUP_NAME
				    , A.SCM_SITE_DESCRIPTION
				    , A.NICK_NAME
				    , A.ORIGIN_DIVISION_ID
				    , A.ELECTRODE_TYPE
            INTO    #TBL_SCP0103_SCP_FN_LINE
		    FROM	#TBL_SCP0103_SCP_FN A WITH(NOLOCK)
            WHERE   1=1
		    GROUP BY  A.DIVISION_ID
				    , A.PLAN_START_YYYYMMDD
				    , A.SCM_SITE_ID
				    , A.ITEM_ID
				    , A.OPERATION_ID
				    , A.MEASURE
				    , A.YYYYMMDD
				    , A.DIVISION_NAME
				    , A.OPERATION_GROUP_NAME
				    , A.SCM_SITE_DESCRIPTION
				    , A.NICK_NAME
				    , A.ORIGIN_DIVISION_ID
				    , A.ELECTRODE_TYPE;
            PRINT  N'최종 PLAN SEQ 에 해당하는 생산 계획 찾기 - LINE제거 - END';
			PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
--TESTING : OK
--select * from #TBL_SCP0103_SCP_FN;
--select * from #TBL_SCP0103_SCP_FN_LINE;rollback tran;return;


            PRINT  N'생산계획이 있는 모델 목록만 구하기 - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND;

            SELECT  ITEM_ID
            INTO    #TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND
            FROM    #TBL_SCP0103_SCP_FN_LINE
            GROUP BY ITEM_ID
            PRINT  N'생산계획이 있는 모델 목록만 구하기 - END';
			PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
--TESTING : OK
--select * from #TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND;rollback tran;return;
--select * from #TBL_SCP0103_SCP_PLAN_TYPE;
--select * from #TBL_SCP0103_SCP_FN_LINE;rollback tran;return;
--???????????


            PRINT N'BOM TREE - BEGIN ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++';
            BEGIN
                PRINT N'BASE BOM 참조 데이터 추출 - BEGIN';
                BEGIN
                    IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_RAW') IS NOT NULL
    	                DROP TABLE #TBL_SCP0103_SCP_TREE_RAW;

	                SELECT    B.COMPANY_ID
                            , B.DIVISION_ID
                            , B.SITE_ID
                            , B.PLANT_ID
                            , B.PARENT_ITEM_ID
                            , B.CHILD_ITEM_ID
                            , B.BOM_VERSION_ID
                            , B.KEY_DATE
                            , B.BOM_VERSION_LINE
                            , B.PARENT_QTY
                            , B.PARENT_UOM
                            , B.CHILD_QTY
                            , B.CHILD_UOM
                            , B.ALT_ID
                            , B.ALT_PRIORITY
                            , B.ALT_RATE
                            , B.EFF_START_DATE
                            , B.EFF_END_DATE
                            , B.ECO_CODE
                            , B.PHANTOM
                            , B.STANDARD_FLAG
                            , B.ACTIVE_FLAG
                            , B.DESCRIPTION
			                , CONVERT(NUMERIC(20, 10), ISNULL(B.CHILD_QTY, 0.0) / IIF(ISNULL(B.PARENT_QTY, 1.0) != 0, B.PARENT_QTY , 1.0))  AS ACCUMULATED_CHILD_QTY
			                , FORMAT(CONVERT(NUMERIC(4), ISNULL(B.ALT_PRIORITY, '0')) , '000')	                                            AS ACC_PRIORITY
			                , R.SCP_FLOW_ID														                                            AS PARENT_FLOW_ID
			                , R.SCP_OPERATION_GROUP												                                            AS PARENT_OPERATION_GROUP
			                , R.ACTIVE_FLAG														                                            AS PARENT_ACTIVE_FLAG
			                , I.SCP_FLOW_ID													                                                AS CHILD_FLOW_ID
			                , I.SCP_OPERATION_GROUP											                                                AS CHILD_OPERATION_GROUP
			                , I.ITEM_CLASS														                                            AS CHILD_ITEM_CLASS
			                , I.ACTIVE_FLAG													                                                AS CHILD_ACTIVE_FLAG
			                , CASE
				                WHEN I.ITEM_CLASS = 'ES0301'				THEN 'ANODE'
				                WHEN I.ITEM_CLASS = 'ES0302'				THEN 'CATHODE'
				                WHEN I.ITEM_CLASS IN ('ES0303', 'ES0305')	THEN 'ONESIDE'
				                ELSE											 '-'
			                  END																                                AS CHILD_ELEC_TYPE
			                , ROW_NUMBER() OVER (PARTITION BY B.COMPANY_ID
											                , B.DIVISION_ID
											                , B.SITE_ID
											                , B.PLANT_ID
											                , B.PARENT_ITEM_ID
											                , B.CHILD_ITEM_ID
								                 ORDER BY	  B.BOM_VERSION_ID DESC
											                , B.KEY_DATE       DESC
								                 )												                                AS KEY_DATE_RN
                    INTO    #TBL_SCP0103_SCP_TREE_RAW
	                FROM	SCM_MST_BOM_ENG_SN B WITH(NOLOCK)
			                LEFT JOIN SCM_MST_ITEM_SN R WITH(NOLOCK) ON
					                R.ITEM_ID		= B.PARENT_ITEM_ID
				                AND R.COMPANY_ID	= B.COMPANY_ID
				                AND R.DIVISION_ID	= B.DIVISION_ID
				                AND R.SITE_ID		= B.SITE_ID
				                AND R.ACTIVE_FLAG	= 'Y'
			                LEFT JOIN SCM_MST_ITEM_SN I WITH(NOLOCK) ON
				                I.ITEM_ID		    = B.CHILD_ITEM_ID
			                AND I.COMPANY_ID	    = B.COMPANY_ID
			                AND I.DIVISION_ID	    = B.DIVISION_ID
			                AND I.SITE_ID		    = B.SITE_ID
			                AND I.ACTIVE_FLAG	    = 'Y'
	                WHERE	1=1
		                AND EFF_START_DATE <= @v_mrp_plan_start_yyyymmdd
		                AND (EFF_END_DATE IS NULL OR EFF_END_DATE >= @v_mrp_plan_start_yyyymmdd);
                END
                PRINT  N'BASE BOM 참조 데이터 추출 - DONE';
			    PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
    --TESTING : OK
    --select * from #TBL_SCP0103_SCP_TREE_RAW;rollback tran;return;


                PRINT  N'BASE BOM 참조 데이터 ALT_ID_PRIORITY 정렬 - BEGIN';
                BEGIN
                    IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_RAW_TEMP') IS NOT NULL
    	                DROP TABLE #TBL_SCP0103_SCP_TREE_RAW_TEMP;

	                SELECT	  A.*
			                , FORMAT(DENSE_RANK() OVER (PARTITION BY  DIVISION_ID
													                , PARENT_ITEM_ID
													                , ALT_ID
										                ORDER BY ALT_PRIORITY) - 1, '000')	AS ALT_ID_PRIORITY
	                INTO	#TBL_SCP0103_SCP_TREE_RAW_TEMP
	                FROM	(
				                SELECT	  DIVISION_ID
						                , PLANT_ID
						                , PARENT_ITEM_ID
						                , CHILD_ITEM_ID
						                , PARENT_QTY
						                , CHILD_QTY
						                , ALT_ID
						                , ALT_PRIORITY
						                , ALT_RATE
						                , ACCUMULATED_CHILD_QTY
						                , ACC_PRIORITY
						                , PARENT_FLOW_ID
						                , PARENT_OPERATION_GROUP
						                , KEY_DATE_RN
						                , CHILD_FLOW_ID
						                , CHILD_OPERATION_GROUP
						                , CHILD_ITEM_CLASS
						                , CHILD_ELEC_TYPE
						                , ROW_NUMBER() OVER (PARTITION BY	  DIVISION_ID
															                , PARENT_ITEM_ID
															                , CHILD_ITEM_ID
											                    ORDER BY PLANT_ID ) AS PLANT_PRIORITY
				                FROM	#TBL_SCP0103_SCP_TREE_RAW
				                WHERE	1=1
					                AND KEY_DATE_RN = 1
			                ) A
	                WHERE	1=1
		                --AND PLANT_PRIORITY = 1

                    -- INDEX 생성
                    CREATE NONCLUSTERED INDEX IDX_TblPR_SCP_ANL_MAT_SUPPLY_BATCH_SCP_TREE_TEMP ON #TBL_SCP0103_SCP_TREE_RAW_TEMP(
                                                                          DIVISION_ID
													                    , PARENT_ITEM_ID
													                    , PLANT_ID
													                    , CHILD_ITEM_ID);
                END
                PRINT  N'BASE BOM 참조 데이터 ALT_ID_PRIORITY 정렬 - DONE';
			    PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
    --TESTING : OK
    --select * from #TBL_SCP0103_SCP_TREE_RAW_TEMP;rollback;return;


                PRINT  N'ALT ID 1순위 데이터를 대상으로 전개 - BOM TREE - BEGIN';
                BEGIN
                    IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE') IS NOT NULL
    	                DROP TABLE #TBL_SCP0103_SCP_TREE;

                    WITH TREE_MODEL AS
                    (
	                    SELECT	  CONVERT(INT, 1)															        AS NLEVEL
			                    , C.DIVISION_ID
			                    , C.PLANT_ID
			                    , C.PARENT_ITEM_ID															        AS MODEL_ID
			                    , C.PARENT_ITEM_ID
			                    , C.CHILD_ITEM_ID
			                    , CONVERT(NVARCHAR(4000), CONCAT(C.PARENT_ITEM_ID , '^' , C.CHILD_ITEM_ID))		    AS CONCATENATE_ITEM
			                    , CONVERT(NVARCHAR(1000), CONCAT('1', ISNULL(C.ACC_PRIORITY, '000')))			    AS ACC_PRIORITY
			                    , C.ALT_ID
			                    , C.ALT_PRIORITY
			                    , CONVERT(NUMERIC(23, 10), C.PARENT_QTY)                                            AS PARENT_QTY
			                    , CONVERT(NUMERIC(23, 10), C.CHILD_QTY)                                             AS CHILD_QTY
			                    , CONVERT(NUMERIC(23, 10), C.ACCUMULATED_CHILD_QTY)                                 AS ACCUMULATED_CHILD_QTY
			                    , CONVERT(NUMERIC(23, 10), 0.0)                                                     AS T_ACCUMULATED_CHILD_QTY
			                    , C.PARENT_FLOW_ID
			                    , C.PARENT_OPERATION_GROUP
			                    , C.CHILD_FLOW_ID
			                    , C.CHILD_OPERATION_GROUP
			                    , C.CHILD_ITEM_CLASS
			                    , C.CHILD_ELEC_TYPE
                                --, C.ALT_ID_PRIORITY --TESTING
	                    FROM	#TBL_SCP0103_SCP_TREE_RAW_TEMP C
	                    WHERE	1=1
		                    AND C.ALT_ID_PRIORITY = '000' --- 1순위만
                        UNION ALL
	                    SELECT	  CONVERT(INT, T.NLEVEL + 1)	                                                     AS NLEVEL
			                    , C.DIVISION_ID
			                    , C.PLANT_ID
			                    , T.MODEL_ID
			                    , C.PARENT_ITEM_ID
			                    , C.CHILD_ITEM_ID
			                    , CONVERT(NVARCHAR(4000), CONCAT(T.CONCATENATE_ITEM, '^' , C.CHILD_ITEM_ID))		AS CONCATENATE_ITEM
			                    , CONVERT(NVARCHAR(1000), CONCAT(T.ACC_PRIORITY, ISNULL(C.ACC_PRIORITY, '000')))	AS ACC_PRIORITY
			                    , C.ALT_ID
			                    , C.ALT_PRIORITY
			                    , CONVERT(NUMERIC(23, 10), C.PARENT_QTY)                                            AS PARENT_QTY
			                    , CONVERT(NUMERIC(23, 10), C.CHILD_QTY)                                             AS CHILD_QTY
			                    , CONVERT(NUMERIC(23, 10), T.ACCUMULATED_CHILD_QTY * C.ACCUMULATED_CHILD_QTY)		AS ACCUMULATED_CHILD_QTY
			                    , CONVERT(NUMERIC(23, 10), T.ACCUMULATED_CHILD_QTY)                                 AS T_ACCUMULATED_CHILD_QTY
			                    , C.PARENT_FLOW_ID
			                    , C.PARENT_OPERATION_GROUP
			                    , C.CHILD_FLOW_ID
			                    , C.CHILD_OPERATION_GROUP
			                    , C.CHILD_ITEM_CLASS
			                    , C.CHILD_ELEC_TYPE
                                --, C.ALT_ID_PRIORITY--TESTING
                        FROM	TREE_MODEL T
			                    INNER JOIN #TBL_SCP0103_SCP_TREE_RAW_TEMP C ON
					                    C.DIVISION_ID     = T.DIVISION_ID
				                    AND C.PLANT_ID		  = T.PLANT_ID
				                    AND C.PARENT_ITEM_ID  = T.CHILD_ITEM_ID
				                    AND C.ALT_ID_PRIORITY = '000' --- 1순위만
	                    WHERE	1=1
                    )
	                    SELECT	T.*
                        INTO    #TBL_SCP0103_SCP_TREE
	                    FROM	TREE_MODEL T
	                    WHERE	1=1
	                    OPTION (MAXRECURSION 15);
                END
                PRINT  N'ALT ID 1순위 데이터를 대상으로 전개 - BOM TREE - DONE';
			    PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

    --TESTING : OK
    --select * from #TBL_SCP0103_SCP_TREE;rollback tran;return;

                PRINT N'BOM TREE - SEMI - BEGIN';
                BEGIN
                    IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_KEYS') IS NOT NULL
    	                DROP TABLE #TBL_SCP0103_SCP_TREE_KEYS;

	                    SELECT	  A.DIVISION_ID
			                    , A.PLANT_ID
			                    , A.MODEL_ID
			                    , A.CHILD_ITEM_ID
			                    , SUM(A.ACCUMULATED_CHILD_QTY)  AS ACCUMULATED_CHILD_QTY
                        INTO    #TBL_SCP0103_SCP_TREE_KEYS
                        FROM    #TBL_SCP0103_SCP_TREE A
                        GROUP BY  A.DIVISION_ID
			                    , A.PLANT_ID
			                    , A.MODEL_ID
			                    , A.CHILD_ITEM_ID;
                END
                PRINT N'BOM TREE - SEMI - END';
    --TESTING : OK
    --select * from #TBL_SCP0103_SCP_TREE_KEYS;rollback tran;return;


                PRINT N'MODEL/CHILD(비자재 포함) 소요수량 정보 - BEGIN';
                BEGIN
                    IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_PROD') IS NOT NULL
	                    DROP TABLE #TBL_SCP0103_SCP_TREE_PROD;

                    SELECT	  T.DIVISION_ID
		                    , T.PLANT_ID
		                    , T.MODEL_ID
		                    , I.OPERATION_GROUP			    AS MODEL_OPERATION_GROUP
		                    , I.FLOW_ID					    AS MODEL_FLOW_ID
		                    , T.CHILD_ITEM_ID
		                    , T.CHILD_ITEM_CLASS
		                    , T.CHILD_OPERATION_GROUP
		                    , SUM(T.ACCUMULATED_CHILD_QTY)	AS ACCUMULATED_CHILD_QTY
		                    , COUNT(1)						AS PATH_CNT
                    INTO	#TBL_SCP0103_SCP_TREE_PROD
                    FROM	#TBL_SCP0103_SCP_TREE T WITH(NOLOCK)
		                    LEFT JOIN SCP_MST_FINAL_ITEM I WITH(NOLOCK) ON
				                    I.DIVISION_ID	= T.DIVISION_ID
			                    AND I.ITEM_ID		= T.MODEL_ID
                    WHERE	1=1
                    GROUP BY	  T.DIVISION_ID
			                    , T.PLANT_ID
			                    , T.MODEL_ID
			                    , I.OPERATION_GROUP
			                    , I.FLOW_ID
			                    , T.CHILD_ITEM_ID
			                    , T.CHILD_ITEM_CLASS
			                    , T.CHILD_OPERATION_GROUP
                END
                PRINT N'MODEL/CHILD(비자재 포함) 소요수량 정보 - DONE';
			    PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : OK
--select * from #TBL_SCP0103_SCP_TREE_PROD;rollback tran;return;
--select * from #TBL_SCP0103_SCP_TREE_RAW;return;

                IF OBJECT_ID('tempdb..#TBL_SCP0103_OPERATION_GROUP_PROD') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_OPERATION_GROUP_PROD;

                SELECT    DIVISION_ID
                        , PLANT_ID
                        , MODEL_OPERATION_GROUP     AS OPERATION_GROUP
                        , MODEL_FLOW_ID             AS OPERATION_ID
                        , CHILD_ITEM_ID             AS MATERIAL
                INTO    #TBL_SCP0103_OPERATION_GROUP_PROD
                FROM    #TBL_SCP0103_SCP_TREE_PROD
                WHERE   1=1
                    AND MODEL_OPERATION_GROUP IS NOT NULL
                GROUP BY  DIVISION_ID
                        , PLANT_ID
                        , MODEL_OPERATION_GROUP
                        , MODEL_FLOW_ID
                        , CHILD_ITEM_ID
--TESTING : OK
--select * from #TBL_SCP0103_OPERATION_GROUP_PROD;rollback tran;return;

                PRINT N'생산계획에 해당하는 MODEL/CHILD(비자재 포함) 필터링 - BEGIN';
                BEGIN
                    IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP') IS NOT NULL
	                    DROP TABLE #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP;

                    SELECT	  A.DIVISION_ID
		                    , A.PLANT_ID
		                    , A.MODEL_ID
		                    , A.MODEL_OPERATION_GROUP
		                    , A.MODEL_FLOW_ID
		                    , A.CHILD_ITEM_ID
		                    , A.CHILD_ITEM_CLASS
		                    , A.CHILD_OPERATION_GROUP
		                    , A.ACCUMULATED_CHILD_QTY
		                    , A.PATH_CNT
                    INTO	#TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP
                    FROM	#TBL_SCP0103_SCP_TREE_PROD A
                            INNER JOIN #TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND B ON
					                A.MODEL_ID = B.ITEM_ID;

--TESTING : OK
--select * from #TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND;
--select * from #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP;rollback tran;return;



                    IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND') IS NOT NULL
	                    DROP TABLE #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND;

                    SELECT	  A.DIVISION_ID
		                    , A.PLANT_ID
		                    , A.MODEL_ID
		                    , LEFT(A.MODEL_FLOW_ID, 5) AS MODEL_FLOW_ID
		                    , A.CHILD_ITEM_ID
                            , AVG(A.ACCUMULATED_CHILD_QTY)  AS ACCUMULATED_CHILD_QTY
                    INTO    #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND
                    FROM    #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP A
                    GROUP BY  A.DIVISION_ID
		                    , A.PLANT_ID
		                    , A.MODEL_ID
		                    , LEFT(A.MODEL_FLOW_ID, 5)
                            , A.CHILD_ITEM_ID
                END
                PRINT N'생산계획에 해당하는 MODEL/CHILD(비자재 포함) 필터링 - END';
    		    PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
            END
            PRINT N'BOM TREE - END ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++';
        END
        PRINT N'Summary SCP Plan - END ===============================================================================================================================================================';
	    PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : OK
--select * from #TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND;
--select * from #TBL_SCP0103_SCP_TREE_PROD;
--select * from #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND;rollback tran;return;



        PRINT N'Summary MRP - BEGIN ===============================================================================================================================================================';
        BEGIN
            IF OBJECT_ID('tempdb..#TBL_SCP0103_RAW') IS NOT NULL
                DROP TABLE #TBL_SCP0103_RAW;

            SELECT  *
            INTO    #TBL_SCP0103_RAW
            FROM    dbo.SCM_DNM_MAT_MRP_SUPPLY
            WHERE   1=1
                AND CUTOFF_DATE = @v_mrp_plan_start_yyyymmdd;

--TESTING : OK
--select  * from #TBL_SCP0103_RAW;return;


            PRINT  N'MRP - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_TEMP') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_TEMP;

            SELECT    @v_scp_plan_start_yyyymmdd                                           AS SCP_PLAN_START_YYYYMMDD
                    , @v_mrp_plan_start_yyyymmdd                                           AS MRP_PLAN_START_YYYYMMDD
                    , CASE
                        WHEN A.DATA_TYPE = 'S' THEN 'I'
                        WHEN A.DATA_TYPE = 'M' THEN 'P'
                        ELSE '-'
                      END                                                                   AS PSI
                    , CONVERT(NVARCHAR(100), 
                        CASE
                            WHEN A.DATA_TYPE = 'S' THEN 'BALANCE'
                            WHEN A.DATA_TYPE = 'M' THEN 'SUPPLY_PLAN'
                            ELSE '-'
                        END)                                                                AS MEASURE
                    , G.COMPANY_ID                                                          AS COMPANY
                    , P.DIVISION_ID
                    , P.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.ITEM_ID                                                             AS MATERIAL
                    , O.OPERATION_GROUP
                    , CONVERT(NVARCHAR(20), '-')                                            AS OPERATION_ID
                    , CONVERT(NVARCHAR(100), '-')                                           AS ITEM_ID
                    , A.RTA                                                                 AS YYYYMMDD
				    , C.BASIS_YYYYMM                                                        AS YYYYMM
				    , RIGHT(C.BASIS_YYYYMM, 6) + C.ISO_WEEK                                 AS WEEK
				    , RIGHT(C.ISO_YYYYMM, 6) + C.ISO_WEEK                                   AS ISO_WEEK
                    , A.ATTR_07                                                             AS UOM
					, CONVERT(NVARCHAR(300), '-')                                           AS NICKNAME
                    , CASE
                        -- [PJ20257329] 변경전 WHEN I.FLOW_ID IN ('A3000', 'A9000', 'F6200', 'F7000', 'F7100', 'F7200', 'F7300') THEN I.NICK_NAME
                        WHEN I.FLOW_ID IN (SELECT OPERATION_ID FROM @SCP_CELL_PLAN__OPERATION_ALL) THEN I.NICK_NAME -- [PJ20257329] Cell 계획 공정 하드 코딩 변경 
                        ELSE
			                CASE
			 	            WHEN I.OPERATION_GROUP = 'P' THEN (     
                                                                    SELECT  NICK_NAME 
                                                                    FROM    SCP_MST_FINAL_ITEM B WITH(NOLOCK) 
                                                                    WHERE   1=1
                                                                        AND B.DIVISION_ID   = I.DIVISION_ID 
                                                                        AND B.ITEM_ID       = I.ITEM_ID
                                                                )
			                ELSE ''
		                    END
                        END AS CELL_MODEL_NICKNAME
                    , A.ATTR_01                                                             AS SUPPLIER
                    , A.ATTR_08                                                             AS ITEM_CATEGORY
                    , A.QTY
                    , CONVERT(NUMERIC(20, 10), NULL)                                        AS CELL_CF
                    , CONVERT(NUMERIC(20, 10), NULL)                                        AS YIELD_RATE
                    , CONVERT(NVARCHAR(4000), NULL)                                         AS REMARK
                    , CONVERT(NVARCHAR(200), A.ATTR_06)                                     AS ATTRIBUTE1 -- 반제품코드
                    , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE2 -- '-' : 반제품 제외 수량, 'SUM' : 반제품 포함 수량, 'SEMI' 반제품 수량
                    , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE3
                    , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE4
                    , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE5
                    , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE6
                    , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE7
                    , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE8
                    , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE9
                    , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE10
            INTO    #TBL_SCP0103_MRP_TEMP
            FROM    #TBL_SCP0103_RAW A
                    LEFT JOIN (
                                    SELECT    PLANT_ID
                                            , COMPANY_ID
                                    FROM    #TBL_SCP0103_PLANT_ALL 
                                    GROUP BY  PLANT_ID
                                            , COMPANY_ID
                              ) G ON
			                A.PLANT_ID           = G.PLANT_ID
                    LEFT JOIN (
                                    --SELECT    PLANT_ID
                                    --        , OPERATION_GROUP
                                    --FROM    #TBL_SCP0103_PLANT_ALL 
                                    --GROUP BY  PLANT_ID
                                    --        , OPERATION_GROUP
                                    SELECT    PLANT_ID
                                            , MATERIAL
                                            , OPERATION_GROUP
                                    FROM    (
                                                SELECT    PLANT_ID
                                                        , MATERIAL
                                                        , OPERATION_GROUP
            						                    , ROW_NUMBER() OVER (PARTITION BY PLANT_ID, MATERIAL ORDER BY OPERATION_GROUP) RN
                                                FROM    #TBL_SCP0103_OPERATION_GROUP_PROD
                                                GROUP BY  DIVISION_ID
                                                        , PLANT_ID
                                                        , OPERATION_GROUP
                                                        , MATERIAL
                                            ) A
                                    WHERE   1=1
                                        AND RN = 1
                              ) O ON
                            A.PLANT_ID      = O.PLANT_ID
                        AND A.ITEM_ID       = O.MATERIAL
                    LEFT JOIN #TBL_SCP0103_PLANT P ON
                            A.PLANT_ID      = P.PLANT_ID
					LEFT JOIN SCM_SYS_CALENDAR_M C ON
							A.RTA           = C.BASIS_YYYYMMDD
		            LEFT JOIN SCP_MST_FINAL_ITEM I WITH(NOLOCK) ON
			                A.ITEM_ID       = I.ITEM_ID;

--TESTING : OK
--select  * from #TBL_SCP0103_RAW;
--select  * from #TBL_SCP0103_MRP_TEMP;rollback tran;return;

            IF OBJECT_ID('tempdb..#TBL_SCP0103_SUPPLIER') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_SUPPLIER;

--TESTING : OK
--select  * from #TBL_SCP0103_MRP_TEMP;

            SELECT    MATERIAL
                    , SUPPLIER
            INTO    #TBL_SCP0103_SUPPLIER
            FROM    #TBL_SCP0103_MRP_TEMP
            WHERE   1=1
                AND ISNULL(SUPPLIER, '') <> ''
            GROUP BY  MATERIAL
                    , SUPPLIER;

--TESTING : OK
--select  * from #TBL_SCP0103_SUPPLIER;

            UPDATE   A
            SET
                    A.SUPPLIER = B.SUPPLIER
            FROM    #TBL_SCP0103_MRP_TEMP A
                    JOIN #TBL_SCP0103_SUPPLIER B ON
                            A.MATERIAL = B.MATERIAL
            WHERE   1=1
                AND A.MEASURE = 'BALANCE'
                AND A.SUPPLIER IS NULL;

--TESTING : OK
--select  * from #TBL_SCP0103_SUPPLIER;
--select  * from #TBL_SCP0103_MRP_TEMP;rollback tran;return;

            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_I') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_I;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
                    , A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , A.YYYYMM
				    , A.WEEK
				    , A.ISO_WEEK
                    , A.UOM
					, A.NICKNAME
                    , A.CELL_MODEL_NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , A.QTY
                    , A.CELL_CF
                    , A.YIELD_RATE
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10
            INTO    #TBL_SCP0103_MRP_I
            FROM    #TBL_SCP0103_MRP_TEMP A
            WHERE   1=1
                AND A.PSI = 'I';
--TESTING : OK
--select  * from #TBL_SCP0103_RAW;rollback tran;return;
--select  * from #TBL_SCP0103_EE_PLANT;--rollback tran;return;
--select  * from #TBL_SCP0103_MRP_I;rollback tran;return;

            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_I_MATERIAL') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_I_MATERIAL;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.ITEM_CATEGORY
            INTO    #TBL_SCP0103_MRP_I_MATERIAL
            FROM    #TBL_SCP0103_MRP_I A
            GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.ITEM_CATEGORY
--TESTING : OK
--select * from #TBL_SCP0103_MRP_I_MATERIAL;rollback tran;return;

            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_P;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
                    , A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , YYYYMM
				    , WEEK
				    , ISO_WEEK
                    , A.UOM
					, NICKNAME
                    , A.CELL_MODEL_NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , A.QTY
                    , A.CELL_CF
                    , A.YIELD_RATE
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10
            INTO    #TBL_SCP0103_MRP_P
            FROM    #TBL_SCP0103_MRP_TEMP A
            WHERE   1=1
                AND A.PSI = 'P';

--TESTING : OK
--select  * from #TBL_SCP0103_MRP_P;rollback tran;return;

            --REQUIREMENT UOM 변환용
            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_UOM') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_P_UOM;

            SELECT    A.MATERIAL
                    , A.UOM
            INTO    #TBL_SCP0103_MRP_P_UOM
            FROM    #TBL_SCP0103_MRP_P A
            WHERE   1=1
                AND A.UOM IS NOT NULL
            GROUP BY  A.MATERIAL
                    , A.UOM;

            PRINT  N'MRP - END';


            PRINT N'반제품 재고 - BEGIN';

            PRINT N'반제품 재고 - #TBL_SCP0103_MRP_P_SEMI_TEMP - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_SEMI_TEMP') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_P_SEMI_TEMP;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
                    , A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , CONVERT(NVARCHAR(20), '-')        AS OPERATION_ID
                    , B.PROD_ITEM_ID		            AS ITEM_ID
                    , A.YYYYMMDD
                    , A.YYYYMM
                    , A.WEEK
                    , A.ISO_WEEK
                    , A.UOM
                    , A.NICKNAME
                    , A.CELL_MODEL_NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , CONVERT(NUMERIC(20, 10), NULL)    AS QTY
                    , A.CELL_CF
                    , A.YIELD_RATE
                    , A.REMARK
                    , CONVERT(NVARCHAR(200), NULL)      AS ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10
            INTO    #TBL_SCP0103_MRP_P_SEMI_TEMP
            FROM    #TBL_SCP0103_MRP_P A
                    CROSS APPLY (
                                    SELECT    TOKEN     AS PROD_ITEM_ID
                                    FROM    dbo.String_Split(A.ATTRIBUTE1, '^') 
                                    GROUP BY  TOKEN
                                ) B
                    JOIN #TBL_SCP0103_ITEM_OPERATION C ON
                            A.COMPANY            = C.COMPANY_ID
                        AND A.ORIGIN_DIVISION_ID = C.DIVISION_ID
                        AND B.PROD_ITEM_ID       = C.ITEM_ID
            WHERE   1=1
                AND UPPER(A.ITEM_CATEGORY) IN ('CATHODE ACTIVE MATERIAL', 'ANODE ACTIVE MATERIAL')

            PRINT N'반제품 재고 - #TBL_SCP0103_MRP_P_SEMI_TEMP - END';
--TESTING : OK
--select  * from #TBL_SCP0103_MRP_P_SEMI_TEMP;rollback tran;return;

            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_ITEM_CATEGORY') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_P_ITEM_CATEGORY;
            
            SELECT    A.MATERIAL
                    , A.ITEM_CATEGORY
            INTO    #TBL_SCP0103_MRP_P_ITEM_CATEGORY
            FROM    (
                        SELECT    MATERIAL
                                , ITEM_CATEGORY
                        FROM    #TBL_SCP0103_MRP_P
                        WHERE   1=1
                            AND ITEM_CATEGORY IS NOT NULL
                        UNION ALL
                        SELECT    MATERIAL
                                , ITEM_CATEGORY
                        FROM    #TBL_SCP0103_MRP_I_MATERIAL
                        WHERE   1=1
                            AND ITEM_CATEGORY IS NOT NULL
                    ) A
            GROUP BY  A.MATERIAL
                    , A.ITEM_CATEGORY;
            

            --SCP PLAN 'P' 필터용
            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_PLAN_KEYS') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_P_PLAN_KEYS;

            SELECT    A.COMPANY
                    --, A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
            INTO    #TBL_SCP0103_MRP_P_PLAN_KEYS
            FROM    #TBL_SCP0103_MRP_P A
            GROUP BY  A.COMPANY
                    --, A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
--TESTING : OK
--select  * from #TBL_SCP0103_MRP_P_PLAN_KEYS;rollback tran;return;
            
            --SCP PLAN 반제품추가용(A9000)
            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_MATERIAL') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_P_MATERIAL;

            SELECT  A.MATERIAL
            INTO    #TBL_SCP0103_MRP_P_MATERIAL
            FROM    #TBL_SCP0103_MRP_P A
            GROUP BY A.MATERIAL;

--TESTING : OK
--select  * from #TBL_SCP0103_MRP_P_MATERIAL;rollback tran;return;

            PRINT N'SEMI 에 해당하는 MODEL 목록 - #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL - BEGIN'

            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW;

            SELECT    T.COMPANY_ID
                    , T.DIVISION_ID 
                    , T.PLANT_ID
                    , I.FLOW_ID                    AS OPERATION_ID
                    , T.MODEL_ID                   AS CP_ITEM_ID
                    , M.ITEM_ID_ASSY               AS CA_ITEM_ID
                    , T.CHILD_ITEM_ID              AS MATERIAL
                    , G.ITEM_CATEGORY
                    , T.ACCUMULATED_CHILD_QTY
                    , T.ALT_PRIORITY
            INTO    #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW
            FROM    SCM_MST_BOM_SN T WITH(NOLOCK)
                    INNER JOIN SCP_MST_FINAL_ITEM I WITH(NOLOCK) ON
                            I.DIVISION_ID          = T.DIVISION_ID
                        AND I.ITEM_ID              = T.MODEL_ID
                        AND I.OPERATION_GROUP      = 'A'
                        AND I.ATTRIBUTE8           = 'CP'
                    INNER JOIN SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK) ON
                            M.DIVISION_ID          = T.DIVISION_ID
                        AND M.PLANT_ID             = T.PLANT_ID
                        AND M.ITEM_ID_PROD         = T.MODEL_ID
                        AND M.CELL_TYPE            = 'CA1'
                    INNER JOIN #TBL_SCP0103_MRP_P_MATERIAL C ON
        	                T.CHILD_ITEM_ID        = C.MATERIAL
                    LEFT JOIN #TBL_SCP0103_MRP_P_ITEM_CATEGORY G ON
                            T.CHILD_ITEM_ID        = G.MATERIAL
        WHERE   1=1
            AND T.ALT_PRIORITY = 'Y';


--TESTING : NOK
--select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW;rollback tran;return;

            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP;

            SELECT    A.COMPANY_ID
                    , A.DIVISION_ID 
                    , A.PLANT_ID
                    , A.OPERATION_ID
                    , A.CP_ITEM_ID
                    , A.CA_ITEM_ID
                    , A.MATERIAL
                    , A.ITEM_CATEGORY
                    , SUM(A.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
            INTO    #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP
            FROM    #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW A
            GROUP BY  A.COMPANY_ID
                    , A.DIVISION_ID 
                    , A.PLANT_ID
                    , A.OPERATION_ID
                    , A.CP_ITEM_ID
                    , A.CA_ITEM_ID
                    , A.ITEM_CATEGORY
                    , A.MATERIAL;

--TESTING : OK
--select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW;
--select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP;rollback tran;return;


            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL;

            SELECT    A.COMPANY_ID
                    , A.DIVISION_ID 
                    , A.PLANT_ID
                    , A.OPERATION_ID
                    , A.CP_ITEM_ID
                    , A.CA_ITEM_ID
                    , A.MATERIAL
                    , A.ITEM_CATEGORY
                    , SUM(A.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
            INTO    #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL
            FROM    #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP A
            WHERE   1=1
                AND UPPER(A.ITEM_CATEGORY) IN ('CATHODE ACTIVE MATERIAL', 'ANODE ACTIVE MATERIAL')
            GROUP BY  A.COMPANY_ID
                    , A.DIVISION_ID 
                    , A.PLANT_ID
                    , A.OPERATION_ID
                    , A.CP_ITEM_ID
                    , A.CA_ITEM_ID
                    , A.MATERIAL
                    , A.ITEM_CATEGORY;

--TESTING : OK
--select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP;
--select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL;rollback tran;return;


            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_EE') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_EE;

            SELECT    A.COMPANY_ID
                    , A.DIVISION_ID 
                    , A.PLANT_ID
                    , A.OPERATION_ID
                    , A.CP_ITEM_ID
                    , A.CA_ITEM_ID
                    , A.MATERIAL
                    , A.ITEM_CATEGORY
                    , SUM(A.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
            INTO    #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_EE
            FROM    #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP A
                    INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK) ON
                            A.DIVISION_ID           = B.DIVISION_ID
                        AND A.PLANT_ID              = B.PLANT_ID
                        AND A.CA_ITEM_ID            = B.MODEL_ID
                        AND B.OPERATION_GROUP_ID    = 'E'
            GROUP BY  A.COMPANY_ID
                    , A.DIVISION_ID 
                    , A.PLANT_ID
                    , A.OPERATION_ID
                    , A.CP_ITEM_ID
                    , A.CA_ITEM_ID
                    , A.MATERIAL
                    , A.ITEM_CATEGORY;

            PRINT N'SEMI 에 해당하는 MODEL 목록 - #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL - END'

--TESTING : OK
--select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP;
--select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL;
--select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_EE;rollback tran;return;


            PRINT N'반제품 재고 - #TBL_SCP0103_MRP_P_SEMI - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_SEMI') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_P_SEMI;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
                    , A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.UOM
                    , @v_mrp_plan_start_yyyymmdd        AS  YYYYMMDD
            INTO    #TBL_SCP0103_MRP_P_SEMI
            FROM    #TBL_SCP0103_MRP_P_SEMI_TEMP A
            GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
                    , A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.UOM


            PRINT N'반제품 재고 - #TBL_SCP0103_SCM_DNM_STOCK - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCM_DNM_STOCK') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_SCM_DNM_STOCK;

            SELECT    A.COMPANY_ID
                    , B.ELEC_DIVISION_ID    AS DIVISION_ID
                    , B.ELEC_PLANT_ID       AS PLANT_ID
                    , A.ITEM_ID
                    , A.QTY_UOM
                    , A.CUTOFF_DATE
                    , O.OPERATION_GROUP
                    , SUM(A.SCM_QTY)        AS QTY
            INTO    #TBL_SCP0103_SCM_DNM_STOCK
            FROM    dbo.SCM_DNM_STOCK A WITH(NOLOCK)
					LEFT JOIN (
                                    SELECT    ASSY_DIVISION_ID
                                            , ASSY_PLANT_ID
                                            , ELEC_DIVISION_ID
                                            , ELEC_PLANT_ID
                                    FROM    #TBL_SCP0103_EE_PLANT
                              ) B ON
                            A.DIVISION_ID    = B.ASSY_DIVISION_ID
                        AND A.PLANT_ID       = B.ASSY_PLANT_ID
                    LEFT JOIN (
                                    SELECT    PLANT_ID
                                            , OPERATION_GROUP
                                    FROM    #TBL_SCP0103_PLANT_ALL 
                                    GROUP BY  PLANT_ID
                                            , OPERATION_GROUP
                              ) O ON
			                A.PLANT_ID           = O.PLANT_ID
            WHERE   1=1
                AND SCM_SITE_ID IS NOT NULL
                AND CUTOFF_DATE = @v_mrp_plan_start_yyyymmdd_pre
            GROUP BY  A.COMPANY_ID
                    , B.ELEC_DIVISION_ID
                    , B.ELEC_PLANT_ID
                    , A.ITEM_ID
                    , A.QTY_UOM
                    , A.CUTOFF_DATE
                    , O.OPERATION_GROUP;

            PRINT N'반제품 재고 - #TBL_SCP0103_SCM_DNM_STOCK - END';

--TESTING : OK
--select  * from #TBL_SCP0103_SCM_DNM_STOCK;rollback tran;return;
--select  * 
--from #TBL_SCP0103_SCM_DNM_STOCK
--WHERE 1=1
--    AND CUTOFF_DATE             = '20231108'
--    AND COMPANY_ID              = 'C100'
--    AND DIVISION_ID             = '81'
--    AND PLANT_ID                IN ( 'A040', 'A041')
--    AND ITEM_ID                 = 'APCAN1501A'
--;    
--rollback tran;return;
            

            -- SEMI STOCK 상세내역 - 반제품코드(ITEM_ID) 별로 볼 때 이 테이블 조회
            PRINT N'반제품 재고 - #TBL_SCP0103_MRP_P_SEMI_STOCK - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_SEMI_STOCK') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_P_SEMI_STOCK;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , 'I'                                                           AS PSI
                    , CONVERT(NVARCHAR(100), 'BALANCE')                             AS MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
    				, @v_mrp_plan_start_yyyymmdd_pre                                AS YYYYMMDD
                    , A.UOM
                    , B.QTY_UOM                                                     AS SEMI_UOM
                    , B.QTY                                                         AS SEMI_QTY
                    , T.ACCUMULATED_CHILD_QTY                                       AS CF
                    , ISNULL(B.QTY, 0.0) * ISNULL(T.ACCUMULATED_CHILD_QTY, 0.0)     AS QTY
                    , CONVERT(NVARCHAR(200), 'SEMI')                                AS ATTRIBUTE2
            INTO    #TBL_SCP0103_MRP_P_SEMI_STOCK
            FROM    #TBL_SCP0103_MRP_P_SEMI A
                    LEFT JOIN #TBL_SCP0103_SCM_DNM_STOCK B ON
                            A.COMPANY               = B.COMPANY_ID
                        AND A.ORIGIN_DIVISION_ID    = B.DIVISION_ID
                        AND A.PLANT_ID              = B.PLANT_ID
                        AND A.ITEM_ID               = B.ITEM_ID
                        AND A.OPERATION_GROUP       = B.OPERATION_GROUP
--SEMI STOCK 은 MRP 계획 시작전 일자로 집계                        AND A.YYYYMMDD              = B.CUTOFF_DATE;
                    LEFT JOIN #TBL_SCP0103_SCP_TREE_KEYS T ON
	    			        A.ORIGIN_DIVISION_ID	= T.DIVISION_ID
    			        AND A.PLANT_ID		        = T.PLANT_ID
    			        AND A.ITEM_ID		        = T.MODEL_ID
                        AND A.MATERIAL              = T.CHILD_ITEM_ID

            PRINT N'반제품 재고 - #TBL_SCP0103_MRP_P_SEMI_STOCK - END';
            PRINT N'반제품 재고 - END';

--TESTING : OK
--select * from #TBL_SCP0103_MRP_P_SEMI_STOCK;rollback tran;return;


            PRINT N'반제품 재고 - 자재별 합계 - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_SEMI_STOCK_SUM') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_P_SEMI_STOCK_SUM;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.COMPANY
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.YYYYMMDD
                    , A.UOM
                    , A.OPERATION_GROUP
                    , IIF(ISNULL(SUM(A.QTY), 0) < 0, 0, SUM(A.QTY))         AS QTY
            INTO    #TBL_SCP0103_MRP_P_SEMI_STOCK_SUM
            FROM    #TBL_SCP0103_MRP_P_SEMI_STOCK A
            GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.COMPANY
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.UOM
                    , A.OPERATION_GROUP
                    , A.YYYYMMDD;
            PRINT N'반제품 재고 - 자재별 합계 - END';

--TESTING : OK
--select  * from #TBL_SCP0103_MRP_I;--rollback tran;return;
--select  * from #TBL_SCP0103_MRP_P_SEMI_STOCK_SUM;rollback tran;return;


            PRINT N'재고 + 반제품 합산 - BEGIN'
            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_I_TEMP') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_I_TEMP;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , 'I'                                       AS PSI
                    , A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , A.YYYYMM
                    , A.WEEK
                    , A.ISO_WEEK
                    , A.UOM
                    , A.NICKNAME
                    , A.CELL_MODEL_NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , IIF(ISNULL(A.QTY, 0) < 0, 0, A.QTY)         AS QTY
                    , A.CELL_CF
                    , A.YIELD_RATE
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10
            INTO    #TBL_SCP0103_MRP_I_TEMP
            FROM    #TBL_SCP0103_MRP_I A
            GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , A.YYYYMM
                    , A.WEEK
                    , A.ISO_WEEK
                    , A.UOM
                    , A.NICKNAME
                    , A.CELL_MODEL_NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , A.QTY
                    , A.CELL_CF
                    , A.YIELD_RATE
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10;

--TESTING : OK
--select  * from #TBL_SCP0103_MRP_I_TEMP;--rollback tran;return;


            IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_I_ALL') IS NOT NULL
	            DROP TABLE #TBL_SCP0103_MRP_I_ALL;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , 'I'                                       AS PSI
                    , A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , A.YYYYMM
                    , A.WEEK
                    , A.ISO_WEEK
                    , A.UOM
                    , A.NICKNAME
                    , A.CELL_MODEL_NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , A.QTY                             -- 반제품 제외 수량 (Operation Group 'E' 일때 표시)
                    , A.CELL_CF
                    , A.YIELD_RATE
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10
            INTO    #TBL_SCP0103_MRP_I_ALL
            FROM    #TBL_SCP0103_MRP_I_TEMP A


            INSERT INTO #TBL_SCP0103_MRP_I_ALL
            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , 'I'                                       AS PSI
                    , A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , CONVERT(NVARCHAR(100), 'SUM')             AS ITEM_ID
                    , A.YYYYMMDD
                    , A.YYYYMM
                    , A.WEEK
                    , A.ISO_WEEK
                    , A.UOM
                    , A.NICKNAME
                    , A.CELL_MODEL_NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , (ISNULL(A.QTY, 0.0) + ISNULL(B.QTY, 0.0))      AS QTY -- 반제품 포함 수량 (Operation Group 'A' 일때 표시)
                    , A.CELL_CF
                    , A.YIELD_RATE
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10
            FROM    #TBL_SCP0103_MRP_I_TEMP A
                    LEFT JOIN #TBL_SCP0103_MRP_P_SEMI_STOCK_SUM B ON
                            A.COMPANY               = B.COMPANY
                        AND A.ORIGIN_DIVISION_ID    = B.ORIGIN_DIVISION_ID
                        AND A.PLANT_ID              = B.PLANT_ID
                        AND A.MATERIAL              = B.MATERIAL
                        AND A.OPERATION_GROUP       = B.OPERATION_GROUP
--#TBL_SCP0103_MRP_I 는 계획일자 전날자로 집계                         AND A.YYYYMMDD              = B.YYYYMMDD
                        PRINT N'재고 + 반제품 합산 - BEGIN'
            PRINT N'재고 + 반제품 합산 - END'
--TESTING : OK
--select  * from #TBL_SCP0103_MRP_I_TEMP;
--select  * from #TBL_SCP0103_MRP_P_SEMI_STOCK_SUM;rollback tran;return;
--select  * from #TBL_SCP0103_MRP_I;--rollback tran;return;
--select  * from #TBL_SCP0103_MRP_I_ALL;rollback tran;return;

        END
        PRINT N'Summary MRP - END ===============================================================================================================================================================';
		PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


            PRINT  N'생산계획 취합 - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN;

		    SELECT	  A.DIVISION_ID
				    , A.PLAN_START_YYYYMMDD
				    , A.SCM_SITE_ID
				    , A.ITEM_ID
				    , A.OPERATION_ID
				    , A.MEASURE
				    , A.YYYYMMDD
				    , A.QTY
				    , A.DIVISION_NAME
				    , A.OPERATION_GROUP_NAME
				    , A.SCM_SITE_DESCRIPTION
				    , A.NICK_NAME
				    , A.ORIGIN_DIVISION_ID
				    , A.ELECTRODE_TYPE
                    , B.YIELD AS YIELD_RATE
            INTO    #TBL_SCP0103_SCP_PLAN
            FROM    #TBL_SCP0103_SCP_FN_LINE A
                    LEFT JOIN #TBL_SCP0103_YIELD B ON
--                            A.DIVISION_ID           = B.DIVISION_ID
                            A.ORIGIN_DIVISION_ID    = B.DIVISION_ID
                        AND A.SCM_SITE_ID           = B.PLANT_SITE_ID
                        AND A.ITEM_ID               = B.ITEM_ID
                        AND A.OPERATION_ID          = B.OPERATION_ID
                        AND A.YYYYMMDD BETWEEN B.TACT_TIME_START_DATE AND B.TACT_TIME_END_DATE;
            PRINT  N'생산계획 취합 - END';
			PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
--TESTING : OK
--select * from #TBL_SCP0103_SCP_FN_LINE;
--select * from #TBL_SCP0103_YIELD;
--select * from #TBL_SCP0103_SCP_PLAN;rollback tran;return;


            -- MATERIAL 최초 매핑
            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1;

            SELECT    @v_scp_plan_start_yyyymmdd   											AS SCP_PLAN_START_YYYYMMDD
                    , @v_mrp_plan_start_yyyymmdd                                            AS MRP_PLAN_START_YYYYMMDD
                    , 'S'                                                                   AS PSI
					, 'PROD_PLAN_AMEND'														AS MEASURE
                    , G.COMPANY_ID                                                          AS COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.SCM_SITE_ID 
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , U.UOM
                    , A.QTY
                    , A.YIELD_RATE
            INTO    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1
            FROM    #TBL_SCP0103_SCP_PLAN A
                    INNER JOIN #TBL_SCP0103_OPERATION O ON
                            A.OPERATION_ID          = O.OPERATION_ID
                    LEFT JOIN #TBL_SCP0103_PLANT_ALL G ON
                            A.ORIGIN_DIVISION_ID    = G.DIVISION_ID
			            AND A.SCM_SITE_ID           = G.SCM_SITE_ID
			        LEFT JOIN #TBL_SCP0103_ITEM_UOM U ON
				            A.ORIGIN_DIVISION_ID	= U.DIVISION_ID
					    AND A.ITEM_ID		        = U.ITEM_ID
--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN;
--select * from #TBL_SCP0103_OPERATION;
--select * from #TBL_SCP0103_ITEM_UOM;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1;rollback tran;return;


            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , G.PLANT_ID
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , A.UOM
                    , A.QTY
                    , A.YIELD_RATE
            INTO    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1 A
                    LEFT JOIN #TBL_SCP0103_PLANT_ALL G ON
                            A.COMPANY               = G.COMPANY_ID
                        AND A.ORIGIN_DIVISION_ID    = G.DIVISION_ID
			            AND A.SCM_SITE_ID           = G.SCM_SITE_ID;

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1;
--select * from #TBL_SCP0103_PLANT_ALL;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT;rollback tran;return;

            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , B.CHILD_ITEM_ID                                                       AS MATERIAL
                    , O.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , A.UOM
                    , AVG(A.QTY)                                                            AS QTY
                    , AVG(B.ACCUMULATED_CHILD_QTY)                                          AS CELL_CF
                    , AVG(A.YIELD_RATE)                                                     AS YIELD_RATE
            INTO    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT A
                    INNER JOIN #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND B ON
                            A.ORIGIN_DIVISION_ID    = B.DIVISION_ID
                        AND A.PLANT_ID              = B.PLANT_ID
                        AND A.ITEM_ID               = B.MODEL_ID
                        AND A.OPERATION_ID          = B.MODEL_FLOW_ID
                    LEFT JOIN #TBL_SCP0103_OPERATION_GROUOP O ON
                            A.OPERATION_ID          = O.OPERATION_ID
            GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , O.OPERATION_GROUP
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , B.CHILD_ITEM_ID
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , A.UOM

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT;
--select * from #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE;rollback tran;return;


            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL                                                           AS MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , C.BASIS_YYYYMM                                                        AS YYYYMM
				    , RIGHT(C.BASIS_YYYYMM, 6) + C.ISO_WEEK                                 AS WEEK
				    , RIGHT(C.ISO_YYYYMM, 6) + C.ISO_WEEK                                   AS ISO_WEEK
                    , A.UOM
                    , M.NICK_NAME                                                           AS NICKNAME
                    , S.SUPPLIER
                    , I.ITEM_CATEGORY
                    , AVG(A.QTY)                                                            AS QTY
                    , AVG(A.CELL_CF)                                                        AS CELL_CF
                    , AVG(A.YIELD_RATE)                                                     AS YIELD_RATE
                    , CONVERT(NVARCHAR(4000),	NULL)	                                    AS REMARK
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE1
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE2
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE3
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE4
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE5
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE6
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE7
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE8
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE9
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE10
            INTO    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE A
                    LEFT JOIN #TBL_SCP0103_MRP_P_ITEM_CATEGORY I ON
                            A.MATERIAL              = I.MATERIAL
					LEFT JOIN SCM_SYS_CALENDAR_M C ON
							A.YYYYMMDD              = C.BASIS_YYYYMMDD
		            LEFT JOIN SCM_MST_ITEM_SN M WITH(NOLOCK) ON
				            A.ORIGIN_DIVISION_ID    = M.DIVISION_ID
			            AND A.ITEM_ID               = M.ITEM_ID
                    LEFT JOIN #TBL_SCP0103_SUPPLIER S ON
                            A.MATERIAL              = S.MATERIAL
            GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , C.BASIS_YYYYMM
				    , RIGHT(C.BASIS_YYYYMM, 6) + C.ISO_WEEK
				    , RIGHT(C.ISO_YYYYMM, 6) + C.ISO_WEEK
                    , A.UOM
                    , M.NICK_NAME
                    , S.SUPPLIER
                    , I.ITEM_CATEGORY;


            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD - END';

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL where MATERIAL IN ('RAAGP0006A');rollback tran;return;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL;rollback tran;return;

            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , A.YYYYMM
				    , A.WEEK
				    , A.ISO_WEEK
                    , A.UOM
                    , A.NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , A.QTY
                    , A.CELL_CF
                    , A.YIELD_RATE
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10
            INTO    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL A
--'P' Material로만 Filter x                    INNER JOIN #TBL_SCP0103_MRP_P_MATERIAL B ON
--'P' Material로만 Filter x                            A.MATERIAL          = B.MATERIAL;
                    INNER JOIN #TBL_SCP0103_MRP_P_PLAN_KEYS B ON
                            A.COMPANY				= B.COMPANY
                        --AND A.DIVISION_ID			= B.DIVISION_ID
--전극사업부는 사업부/plant 달라지므로 material 로만 filter                        AND A.ORIGIN_DIVISION_ID	= B.ORIGIN_DIVISION_ID
--전극사업부는 사업부/plant 달라지므로 material 로만 filter                        AND A.PLANT_ID				= B.PLANT_ID
                        AND A.MATERIAL				= B.MATERIAL;

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL;--rollback tran;return;
--select * from #TBL_SCP0103_MRP_P_PLAN_KEYS;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD;rollback tran;return;

            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP;

            SELECT    @v_scp_plan_start_yyyymmdd   											AS SCP_PLAN_START_YYYYMMDD
                    , @v_mrp_plan_start_yyyymmdd                                            AS MRP_PLAN_START_YYYYMMDD
                    , 'S'                                                                   AS PSI
					, 'PROD_PLAN_AMEND'														AS MEASURE
                    , G.COMPANY_ID                                                          AS COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , G.PLANT_ID
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , U.UOM
                    , AVG(A.QTY)                                                            AS QTY
                    , AVG(A.YIELD_RATE)                                                     AS YIELD_RATE
            INTO    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP
            FROM    #TBL_SCP0103_SCP_PLAN A
                    INNER JOIN #TBL_SCP0103_OPERATION O ON
                            A.OPERATION_ID          = O.OPERATION_ID
                    LEFT JOIN #TBL_SCP0103_PLANT_ALL G ON
                            A.DIVISION_ID           = G.DIVISION_ID
			            AND A.SCM_SITE_ID           = G.SCM_SITE_ID
			        LEFT JOIN #TBL_SCP0103_ITEM_UOM U ON
				            A.ORIGIN_DIVISION_ID	= U.DIVISION_ID
					    AND A.ITEM_ID		        = U.ITEM_ID
            GROUP BY  G.COMPANY_ID
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , G.PLANT_ID
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , U.UOM;

            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP - END';

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP;rollback tran;return;
--;rollback tran;return;


            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , B.MATERIAL
					, O.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , A.UOM
                    , AVG(A.QTY)                                                            AS QTY
                    , AVG(B.ACCUMULATED_CHILD_QTY)                                          AS CELL_CF
                    , AVG(A.YIELD_RATE)                                                     AS YIELD_RATE
            INTO    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP A
                    INNER JOIN #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL B ON
                            A.COMPANY               = B.COMPANY_ID
                        AND A.DIVISION_ID           = B.DIVISION_ID
                        AND A.PLANT_ID              = B.PLANT_ID
                        AND A.OPERATION_ID          = B.OPERATION_ID
                        AND A.ITEM_ID               = B.CA_ITEM_ID
                    LEFT JOIN #TBL_SCP0103_OPERATION_GROUOP O ON
                            A.OPERATION_ID          = O.OPERATION_ID
            GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , B.MATERIAL
					, O.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , A.UOM;

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP;
----select * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL;rollback tran;return;


            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , C.BASIS_YYYYMM                                                        AS YYYYMM
				    , RIGHT(C.BASIS_YYYYMM, 6) + C.ISO_WEEK                                 AS WEEK
				    , RIGHT(C.ISO_YYYYMM, 6) + C.ISO_WEEK                                   AS ISO_WEEK
                    , A.UOM
                    , M.NICK_NAME                                                           AS NICKNAME
                    , S.SUPPLIER
                    , I.ITEM_CATEGORY
                    , AVG(A.QTY)                                                            AS QTY
                    , AVG(A.CELL_CF)                                                        AS CELL_CF
                    , AVG(A.YIELD_RATE)                                                     AS YIELD_RATE
                    , CONVERT(NVARCHAR(4000),	NULL)	                                    AS REMARK
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE1
                    , CONVERT(NVARCHAR(200),	'SEMI')	                                    AS ATTRIBUTE2
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE3
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE4
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE5
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE6
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE7
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE8
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE9
                    , CONVERT(NVARCHAR(200),	NULL)	                                    AS ATTRIBUTE10
            INTO    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL A
                    LEFT JOIN #TBL_SCP0103_MRP_P_ITEM_CATEGORY I ON
                            A.MATERIAL              = I.MATERIAL
					LEFT JOIN SCM_SYS_CALENDAR_M C ON
							A.YYYYMMDD              = C.BASIS_YYYYMMDD
		            LEFT JOIN SCM_MST_ITEM_SN M WITH(NOLOCK) ON
				            A.ORIGIN_DIVISION_ID    = M.DIVISION_ID
			            AND A.ITEM_ID               = M.ITEM_ID
                    LEFT JOIN #TBL_SCP0103_SUPPLIER S ON
                            A.MATERIAL              = S.MATERIAL
            GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , C.BASIS_YYYYMM
				    , RIGHT(C.BASIS_YYYYMM, 6) + C.ISO_WEEK
				    , RIGHT(C.ISO_YYYYMM, 6) + C.ISO_WEEK
                    , A.UOM
                    , M.NICK_NAME
                    , S.SUPPLIER
                    , I.ITEM_CATEGORY;

            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL - END';

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL;rollback tran;return;


            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI - BEGIN';

            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , A.YYYYMM
				    , A.WEEK
				    , A.ISO_WEEK
                    , A.UOM
                    , A.NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , A.QTY
                    , A.CELL_CF
                    , A.YIELD_RATE
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10
            INTO    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL A
                    INNER JOIN #TBL_SCP0103_MRP_P_PLAN_KEYS B ON
                            A.COMPANY				= B.COMPANY
                        --AND A.DIVISION_ID			= B.DIVISION_ID
--전극사업부는 사업부/plant 달라지므로 material 로만 filter                        AND A.ORIGIN_DIVISION_ID	= B.ORIGIN_DIVISION_ID
--전극사업부는 사업부/plant 달라지므로 material 로만 filter                        AND A.PLANT_ID				= B.PLANT_ID
                        AND A.MATERIAL				= B.MATERIAL;

            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI - END';

--TESTING : OK
----select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI;rollback tran;return;


            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;
            
            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD - BEGIN';
            --빈테이블 생성
            SELECT  *
            INTO    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD
            WHERE   1<>1;

            INSERT INTO #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND
            SELECT  *
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD;
            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD - END';

            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI - BEGIN';
            INSERT INTO #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND
            SELECT  *
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI;
            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI - END';
-- 전극사업부 & 'A' 취합전
--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;rollback tran;return;


            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , CASE
                        WHEN CHARINDEX('_', DIVISION_ID) > 1 THEN CONCAT('EE_', SUBSTRING(DIVISION_ID, 4, 2))
                        WHEN CHARINDEX('_', DIVISION_ID) = 0 THEN 'EE'
                        ELSE DIVISION_ID
                      END AS DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , A.YYYYMM
				    , A.WEEK
				    , A.ISO_WEEK
                    , A.UOM
                    , A.NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , A.QTY
                    , A.CELL_CF
                    , A.YIELD_RATE
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10
            INTO    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND A
            WHERE   1=1
                    -- 2025.07.2 변경전 AND OPERATION_ID            IN ('A3000', 'A9000');
					AND OPERATION_ID            IN (SELECT OPERATION_ID FROM @SCP_CELL_FINAL_OPERATION); -- [PJ20257329] Cell 완성 공정 하드 코딩 변경 


--TESTING: OK
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;rollback tran;return;

            INSERT INTO #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND
            SELECT  *
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE;

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;--rollback tran;return;

            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE - END';


            PRINT  N'MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND - END';
			PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD;--rollback tran;return;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI;--rollback tran;return;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE;rollback tran;return;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;rollback tran;return;
--ㅋㅋㅋ


            
            PRINT  N'MRP 와 생산계획 취합 - SCP-TEMP-REQUIREMENT - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_TEMP_REQUIREMENT') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_TEMP_REQUIREMENT;

            SELECT    A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, 'REQUIREMENT'									AS MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
                    , A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , A.YYYYMM
				    , A.WEEK
				    , A.ISO_WEEK
                    , B.UOM     -- REQRUIREMENT UOM 은 MRP -> 'P' UOM
                    , A.NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , (ISNULL(A.QTY, 0) * ISNULL(A.CELL_CF, 1) / ISNULL(A.YIELD_RATE, 1))				AS QTY
                    , A.CELL_CF
                    , A.YIELD_RATE
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10
            INTO    #TBL_SCP0103_SCP_PLAN_TEMP_REQUIREMENT
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND A
                    LEFT JOIN #TBL_SCP0103_MRP_P_UOM B ON
                            A.MATERIAL  = B.MATERIAL

            PRINT  N'MRP 와 생산계획 취합 - SCP-TEMP-REQUIREMENT - END';
			PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_TEMP_REQUIREMENT;rollback tran;return;


            PRINT  N'MRP 와 생산계획 취합 - SCP-FINAL - BEGIN';
            IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_FINAL') IS NOT NULL
                DROP TABLE #TBL_SCP0103_SCP_PLAN_FINAL;

			SELECT    CONVERT(NVARCHAR(8),		A.SCP_PLAN_START_YYYYMMDD)	AS SCP_PLAN_START_YYYYMMDD
					, CONVERT(NVARCHAR(8),		A.MRP_PLAN_START_YYYYMMDD)	AS MRP_PLAN_START_YYYYMMDD
					, CONVERT(CHAR(1),			A.PSI)						AS PSI
					, CONVERT(NVARCHAR(100),	A.MEASURE)					AS MEASURE
                    , CONVERT(NVARCHAR(200),	A.COMPANY)					AS COMPANY
					, CONVERT(NVARCHAR(30),		A.DIVISION_ID)				AS DIVISION_ID
					, CONVERT(NVARCHAR(30),		A.ORIGIN_DIVISION_ID)		AS ORIGIN_DIVISION_ID
					, CONVERT(NVARCHAR(50),		A.PLANT_ID)					AS PLANT_ID
					, CONVERT(NVARCHAR(50),		A.MATERIAL)					AS MATERIAL
					, CONVERT(NVARCHAR(20),	    A.OPERATION_GROUP)			AS OPERATION_GROUP
					, CONVERT(NVARCHAR(20),		A.OPERATION_ID)				AS OPERATION_ID
					, CONVERT(NVARCHAR(100),	A.ITEM_ID)					AS ITEM_ID
					, CONVERT(NVARCHAR(8),		A.YYYYMMDD)					AS YYYYMMDD
					, CONVERT(NVARCHAR(6),		A.YYYYMM)					AS YYYYMM
					, CONVERT(NVARCHAR(8),		A.WEEK)						AS WEEK
					, CONVERT(NVARCHAR(8),		A.ISO_WEEK)					AS ISO_WEEK
                    , CONVERT(NVARCHAR(20),		A.UOM)						AS UOM
					, CONVERT(NVARCHAR(300),	A.NICKNAME)					AS NICKNAME
                    , CONVERT(NVARCHAR(200),	A.SUPPLIER)					AS SUPPLIER
                    , CONVERT(NVARCHAR(200),	A.ITEM_CATEGORY)			AS ITEM_CATEGORY
                    , CONVERT(NUMERIC(20, 10),	AVG(A.QTY))					AS QTY
                    , CONVERT(NUMERIC(20, 10),	AVG(A.CELL_CF))				AS CELL_CF
                    , CONVERT(NUMERIC(20, 10),	AVG(A.YIELD_RATE))			AS YIELD_RATE
                    , CONVERT(NVARCHAR(4000),	A.REMARK)					AS REMARK
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE1)				AS ATTRIBUTE1
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE2)				AS ATTRIBUTE2
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE3)				AS ATTRIBUTE3
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE4)				AS ATTRIBUTE4
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE5)				AS ATTRIBUTE5
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE6)				AS ATTRIBUTE6
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE7)				AS ATTRIBUTE7
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE8)				AS ATTRIBUTE8
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE9)				AS ATTRIBUTE9
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE10)				AS ATTRIBUTE10
            INTO    #TBL_SCP0103_SCP_PLAN_FINAL
            FROM    #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND A
            GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
					, A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , A.YYYYMM
				    , A.WEEK
				    , A.ISO_WEEK
                    , A.UOM -- PROD_PLAN_AMEND UOM 은 생산계획 오리지널 UOM
                    , A.NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10;

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_FINAL;rollback tran;return;


            INSERT INTO #TBL_SCP0103_SCP_PLAN_FINAL
			SELECT    CONVERT(NVARCHAR(8),		A.SCP_PLAN_START_YYYYMMDD)
					, CONVERT(NVARCHAR(8),		A.MRP_PLAN_START_YYYYMMDD)
					, CONVERT(CHAR(1),			A.PSI)
					, CONVERT(NVARCHAR(100),	A.MEASURE)
                    , CONVERT(NVARCHAR(200),	A.COMPANY)
					, CONVERT(NVARCHAR(30),		A.DIVISION_ID)
					, CONVERT(NVARCHAR(30),		A.ORIGIN_DIVISION_ID)
					, CONVERT(NVARCHAR(50),		A.PLANT_ID)
					, CONVERT(NVARCHAR(50),		A.MATERIAL)
					, CONVERT(NVARCHAR(20),	    A.OPERATION_GROUP)
					, CONVERT(NVARCHAR(20),		A.OPERATION_ID)
					, CONVERT(NVARCHAR(100),	A.ITEM_ID)
					, CONVERT(NVARCHAR(8),		A.YYYYMMDD)
					, CONVERT(NVARCHAR(6),		A.YYYYMM)
					, CONVERT(NVARCHAR(8),		A.WEEK)
					, CONVERT(NVARCHAR(8),		A.ISO_WEEK)
                    , CONVERT(NVARCHAR(20),		A.UOM) -- REQUIREMENT UOM 은 MRP로 맞춤
					, CONVERT(NVARCHAR(300),	A.NICKNAME)
                    , CONVERT(NVARCHAR(200),	A.SUPPLIER)
                    , CONVERT(NVARCHAR(200),	A.ITEM_CATEGORY)
                    , CONVERT(NUMERIC(20, 10),	AVG(A.QTY))			AS QTY
                    , CONVERT(NUMERIC(20, 10),	AVG(A.CELL_CF))		AS CELL_CF
                    , CONVERT(NUMERIC(20, 10),	AVG(A.YIELD_RATE))	AS YIELD_RATE
                    , CONVERT(NVARCHAR(4000),	A.REMARK)
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE1)
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE2)
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE3)
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE4)
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE5)
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE6)
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE7)
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE8)
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE9)
                    , CONVERT(NVARCHAR(200),	A.ATTRIBUTE10)
            FROM    #TBL_SCP0103_SCP_PLAN_TEMP_REQUIREMENT A
            GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                    , A.MRP_PLAN_START_YYYYMMDD
                    , A.PSI
					, A.MEASURE
                    , A.COMPANY
                    , A.DIVISION_ID
                    , A.ORIGIN_DIVISION_ID
                    , A.PLANT_ID
                    , A.MATERIAL
					, A.OPERATION_GROUP
                    , A.OPERATION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
				    , A.YYYYMM
				    , A.WEEK
				    , A.ISO_WEEK
                    , A.UOM
                    , A.NICKNAME
                    , A.SUPPLIER
                    , A.ITEM_CATEGORY
                    , A.REMARK
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE2
                    , A.ATTRIBUTE3
                    , A.ATTRIBUTE4
                    , A.ATTRIBUTE5
                    , A.ATTRIBUTE6
                    , A.ATTRIBUTE7
                    , A.ATTRIBUTE8
                    , A.ATTRIBUTE9
                    , A.ATTRIBUTE10;

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_FINAL;rollback tran;return;

            --실사업부이면서 전극 ITEM_CATEGORY 전극 제외
            DELETE #TBL_SCP0103_SCP_PLAN_FINAL
            WHERE   1=1
                AND LEFT(DIVISION_ID, 2)      <> 'EE'
                AND OPERATION_GROUP           = 'A'
                AND UPPER(ITEM_CATEGORY)      IN ('ANODE ACTIVE MATERIAL', 'CATHODE ACTIVE MATERIAL');

            --전극사업부이면서 전극 전극 ITEM_CATEGORY 이외 제외
            DELETE #TBL_SCP0103_SCP_PLAN_FINAL
            WHERE   1=1
                AND LEFT(DIVISION_ID, 2)      = 'EE'
                AND OPERATION_GROUP           = 'A'
                AND UPPER(ITEM_CATEGORY) NOT IN ('ANODE ACTIVE MATERIAL', 'CATHODE ACTIVE MATERIAL');

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_FINAL;rollback tran;return;

            PRINT  N'MRP 와 생산계획 취합 - SCP-FINAL - END';
			PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
--TESTING : OK
--select * from #TBL_SCP0103_MRP;--rollback tran;return;
--select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD;--rollback tran;return;
--select * from #TBL_SCP0103_SCP_PLAN_FINAL;rollback tran;return;


        PRINT  N'MRP - 재고 취합 - BEGIN';
        IF OBJECT_ID('tempdb..#TBL_SCP0103_ALL') IS NOT NULL
            DROP TABLE #TBL_SCP0103_ALL;

        PRINT  N'MRP 와 생산계획 취합 - SCP-FINAL- #TBL_SCP0103_MRP_I_ALL - BEGIN';
        SELECT    CONVERT(NVARCHAR(8),		A.SCP_PLAN_START_YYYYMMDD)		AS SCP_PLAN_START_YYYYMMDD
				, CONVERT(NVARCHAR(8),		A.MRP_PLAN_START_YYYYMMDD)		AS MRP_PLAN_START_YYYYMMDD
				, CONVERT(CHAR(1),			A.PSI)							AS PSI
				, CONVERT(NVARCHAR(100),	A.MEASURE)						AS MEASURE
				, CONVERT(NVARCHAR(200),	A.COMPANY)						AS COMPANY
				, CONVERT(NVARCHAR(30),		A.DIVISION_ID)					AS DIVISION_ID
				, CONVERT(NVARCHAR(30),		A.ORIGIN_DIVISION_ID)			AS ORIGIN_DIVISION_ID
				, CONVERT(NVARCHAR(50),		A.PLANT_ID)						AS PLANT_ID
				, CONVERT(NVARCHAR(50),		A.MATERIAL)						AS MATERIAL
				, CONVERT(NVARCHAR(20),	    A.OPERATION_GROUP)			    AS OPERATION_GROUP
				, CONVERT(NVARCHAR(20),		A.OPERATION_ID)					AS OPERATION_ID
				, CONVERT(NVARCHAR(100),	A.ITEM_ID)						AS ITEM_ID
				, CONVERT(NVARCHAR(8),		A.YYYYMMDD)						AS YYYYMMDD
				, CONVERT(NVARCHAR(6),		A.YYYYMM)						AS YYYYMM
				, CONVERT(NVARCHAR(8),		A.WEEK)							AS WEEK
				, CONVERT(NVARCHAR(8),		A.ISO_WEEK)						AS ISO_WEEK
				, CONVERT(NVARCHAR(20),		A.UOM)							AS UOM
				, CONVERT(NVARCHAR(300),	A.NICKNAME)						AS NICKNAME
				, CONVERT(NVARCHAR(200),	A.SUPPLIER)						AS SUPPLIER
				, CONVERT(NVARCHAR(200),	A.ITEM_CATEGORY)				AS ITEM_CATEGORY
	            , CONVERT(NUMERIC(20, 10),	A.QTY)							AS QTY
	            , CONVERT(NUMERIC(20, 10),	A.CELL_CF)						AS CELL_CF
	            , CONVERT(NUMERIC(20, 10),	A.YIELD_RATE)					AS YIELD_RATE
				, CONVERT(NVARCHAR(4000),	A.REMARK)						AS REMARK
				, CONVERT(NVARCHAR(200),	A.ATTRIBUTE1)					AS ATTRIBUTE1
				, CONVERT(NVARCHAR(200),	A.ATTRIBUTE2)					AS ATTRIBUTE2
				, CONVERT(NVARCHAR(200),	A.ATTRIBUTE3)					AS ATTRIBUTE3
				, CONVERT(NVARCHAR(200),	A.ATTRIBUTE4)					AS ATTRIBUTE4
				, CONVERT(NVARCHAR(200),	A.ATTRIBUTE5)					AS ATTRIBUTE5
				, CONVERT(NVARCHAR(200),	A.ATTRIBUTE6)					AS ATTRIBUTE6
				, CONVERT(NVARCHAR(200),	A.ATTRIBUTE7)					AS ATTRIBUTE7
				, CONVERT(NVARCHAR(200),	A.ATTRIBUTE8)					AS ATTRIBUTE8
				, CONVERT(NVARCHAR(200),	A.ATTRIBUTE9)					AS ATTRIBUTE9
				, CONVERT(NVARCHAR(200),	A.ATTRIBUTE10)					AS ATTRIBUTE10
        INTO    #TBL_SCP0103_ALL
        FROM    #TBL_SCP0103_MRP_I_ALL A
        PRINT  N'MRP 와 생산계획 취합 - SCP-FINAL- #TBL_SCP0103_MRP_I_ALL - END';

--TESTINNG : OK
--select * from #TBL_SCP0103_MRP_I_ALL;rollback tran;return;
--select * from #TBL_SCP0103_ALL;rollback tran;return;


        -- 기초재고를 반제품별로 내역을 추적하기 위해 집계 테이블에 MATERIAL/ITEM 별 재고 내역 추가
        PRINT  N'MRP 와 생산계획 취합 - SCP-FINAL- #TBL_SCP0103_MRP_P_SEMI_STOCK - BEGIN';
        INSERT INTO #TBL_SCP0103_ALL
        SELECT    A.SCP_PLAN_START_YYYYMMDD
				, A.MRP_PLAN_START_YYYYMMDD
				, A.PSI
				, A.MEASURE
				, A.COMPANY
				, A.DIVISION_ID
				, A.ORIGIN_DIVISION_ID
				, A.PLANT_ID
				, A.MATERIAL
				, A.OPERATION_GROUP
				, A.OPERATION_ID
				, A.ITEM_ID
				, A.YYYYMMDD
				, C.BASIS_YYYYMM                                                        AS YYYYMM
				, RIGHT(C.BASIS_YYYYMM, 6) + C.ISO_WEEK                                 AS WEEK
				, RIGHT(C.ISO_YYYYMM, 6) + C.ISO_WEEK                                   AS ISO_WEEK
				, A.UOM
				, CONVERT(NVARCHAR(300), '-')                                           AS NICKNAME
                , CONVERT(NVARCHAR(200), B.SUPPLIER)                                    AS SUPPLIER
                --, M.ITEM_CATEGORY
                , I.ITEM_CATEGORY
	            , A.QTY
	            , A.CF                                                                  AS CELL_CF
                , CONVERT(NUMERIC(20, 10), NULL)                                        AS YIELD_RATE
                , CONVERT(NVARCHAR(4000), NULL)                                         AS REMARK
                , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE1
				, A.ATTRIBUTE2
                , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE3
                , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE4
                , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE5
                , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE6
                , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE7
                , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE8
                , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE9
                , CONVERT(NVARCHAR(200), NULL)                                          AS ATTRIBUTE10
        FROM    #TBL_SCP0103_MRP_P_SEMI_STOCK A
                LEFT JOIN #TBL_SCP0103_SUPPLIER B ON
                            A.MATERIAL = B.MATERIAL
				LEFT JOIN SCM_SYS_CALENDAR_M C ON
						A.YYYYMMDD                  = C.BASIS_YYYYMMDD
                    LEFT JOIN #TBL_SCP0103_MRP_P_ITEM_CATEGORY I ON
                            A.MATERIAL              = I.MATERIAL
        PRINT  N'MRP 와 생산계획 취합 - SCP-FINAL- #TBL_SCP0103_MRP_P_SEMI_STOCK - END';
	    PRINT  N'MRP - 재고 취합 - END';

--TESTING : OK
--select * from #TBL_SCP0103_ALL;rollback tran;return;

        PRINT  N'MRP - SUPPLY_PLAN 취합 - BEGIN';
        INSERT INTO #TBL_SCP0103_ALL
        SELECT    A.SCP_PLAN_START_YYYYMMDD
				, A.MRP_PLAN_START_YYYYMMDD
				, A.PSI
				, A.MEASURE
				, A.COMPANY
				, A.DIVISION_ID
				, A.ORIGIN_DIVISION_ID
				, A.PLANT_ID
				, A.MATERIAL
				, A.OPERATION_GROUP
				, A.OPERATION_ID
				, A.ITEM_ID
				, A.YYYYMMDD
				, A.YYYYMM
				, A.WEEK
				, A.ISO_WEEK
				, A.UOM
				, A.NICKNAME
				, A.SUPPLIER
				, A.ITEM_CATEGORY
	            , A.QTY
	            , A.CELL_CF
	            , A.YIELD_RATE
				, A.REMARK
				, A.ATTRIBUTE1
				, A.ATTRIBUTE2
				, A.ATTRIBUTE3
				, A.ATTRIBUTE4
				, A.ATTRIBUTE5
				, A.ATTRIBUTE6
				, A.ATTRIBUTE7
				, A.ATTRIBUTE8
				, A.ATTRIBUTE9
				, A.ATTRIBUTE10
        FROM    #TBL_SCP0103_MRP_P A

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_FINAL_MATERIAL;--rollback tran;return;
--select * from #TBL_SCP0103_MRP;rollback tran;return;
--select * from #TBL_SCP0103_ALL;--rollback tran;return;

        -- 전극사업부 & Operation Group : A  조회를 위해 MRP 재고, SUPPLU_PLAN 데이터중 Operation Group : E 인 데이터를 => A 로 한 셋트 복사한다
        INSERT INTO #TBL_SCP0103_ALL
        SELECT	  A.SCP_PLAN_START_YYYYMMDD
		        , A.MRP_PLAN_START_YYYYMMDD
		        , A.PSI
		        , A.MEASURE
		        , A.COMPANY
		        , A.DIVISION_ID
		        , A.ORIGIN_DIVISION_ID
		        , A.PLANT_ID
		        , A.MATERIAL
				, CONVERT(NVARCHAR(20),	    'A')			AS OPERATION_GROUP
		        , A.OPERATION_ID
		        , A.ITEM_ID
		        , A.YYYYMMDD
		        , A.YYYYMM
		        , A.WEEK
		        , A.ISO_WEEK
		        , A.UOM
		        , A.NICKNAME
		        , A.SUPPLIER
		        , A.ITEM_CATEGORY
		        , A.QTY
		        , A.CELL_CF
		        , A.YIELD_RATE
		        , A.REMARK
		        , A.ATTRIBUTE1
		        , A.ATTRIBUTE2
		        , A.ATTRIBUTE3
		        , A.ATTRIBUTE4
		        , A.ATTRIBUTE5
		        , A.ATTRIBUTE6
		        , A.ATTRIBUTE7
		        , A.ATTRIBUTE8
		        , A.ATTRIBUTE9
		        , A.ATTRIBUTE10
        FROM    #TBL_SCP0103_ALL A
        WHERE   1=1
            AND A.MEASURE                   IN ('BALANCE', 'SUPPLY_PLAN')
            AND LEFT(A.DIVISION_ID, 2)      = 'EE'
            AND A.OPERATION_GROUP           = 'E'
            AND UPPER(A.ITEM_CATEGORY)      IN ('ANODE ACTIVE MATERIAL', 'CATHODE ACTIVE MATERIAL')

        PRINT  N'MRP - SUPPLY_PLAN 취합 - END';
		PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : OK
--select * from #TBL_SCP0103_ALL;rollback tran;return;


        PRINT  N'MRP 와 생산계획 취합 - SCP - BEGIN';
        INSERT INTO #TBL_SCP0103_ALL
        SELECT  *
        FROM    #TBL_SCP0103_SCP_PLAN_FINAL
        PRINT  N'MRP 와 생산계획 취합 - SCP - END';
        PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : OK
--select * from #TBL_SCP0103_SCP_PLAN_FINAL;rollback tran;return;
--select * from #TBL_SCP0103_ALL;rollback tran;return;

        --DELETE #TBL_SCP0103_ALL
        --WHERE   1=1
        --    AND LEFT(DIVISION_ID, 2) = 'EE'
        --    AND  ATTRIBUTE3 = 'A'--OPERATION_GROUP
        --    AND UPPER(ITEM_CATEGORY) NOT IN ('ANODE ACTIVE MATERIAL', 'CATHODE ACTIVE MATERIAL'); --전극사업부 A3000, A9000 은 Anode, Cathode 인 것만 취합

--TESTING : OK
--select * from #TBL_SCP0103_ALL;rollback tran;return;
 
        PRINT N'최종 집계테이블에 추가 - BEGIN';
        INSERT INTO dbo.SCP_ANL_MAT_SUPPLY
        SELECT    A.SCP_PLAN_START_YYYYMMDD
				, A.MRP_PLAN_START_YYYYMMDD
				, A.PSI
				, A.MEASURE
				, A.COMPANY
				, A.DIVISION_ID
				, A.ORIGIN_DIVISION_ID
				, A.PLANT_ID
				, A.MATERIAL
				, iSNULL(A.OPERATION_GROUP, '-')
				, A.OPERATION_ID
				, A.ITEM_ID
				, A.YYYYMMDD
				, A.YYYYMM
				, A.WEEK
				, A.ISO_WEEK
				, A.UOM
				, A.NICKNAME
				, A.SUPPLIER
				, A.ITEM_CATEGORY
	            , A.QTY
	            , A.CELL_CF
	            , A.YIELD_RATE
				, A.REMARK
				, A.ATTRIBUTE1
				, A.ATTRIBUTE2
				, A.ATTRIBUTE3
				, A.ATTRIBUTE4
				, A.ATTRIBUTE5
				, A.ATTRIBUTE6
				, A.ATTRIBUTE7
				, A.ATTRIBUTE8
				, A.ATTRIBUTE9
				, A.ATTRIBUTE10
                , 'scm_batch'   AS CREATED_BY
                , getdate()     AS CREATION_DATE
                , 'scm_batch'   AS LAST_UPDATED_BY  
                , getdate()     AS LAST_UPDATE_DATE
        FROM    #TBL_SCP0103_ALL A
		WHERE   ISNULL(A.COMPANY, '') <> '';
        PRINT N'최종 집계테이블에 추가 - END';
		PRINT CONCAT('ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
--TESTING : OK
--select * from #TBL_SCP0103_ALL;rollback tran;return;
--select * from dbo.SCP_ANL_MAT_SUPPLY;rollback tran;return;
--select * from dbo.SCP_ANL_MAT_SUPPLY where MRP_PLAN_START_YYYYMMDD = @v_mrp_plan_start_yyyymmdd;rollback tran;return;


		SET @v_log_type     = 'END'
		SET @v_log_message  = '########## END of procedure ##########'
		SET @v_description  = ''

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        COMMIT TRAN
	END TRY
	BEGIN CATCH
		BEGIN
			IF (XACT_STATE() <> 0)
				ROLLBACK TRAN;


            --PRINT N'ERROR_PROCEDURE()' select ERROR_PROCEDURE();

            IF @v_test_mode <> 'T'
            BEGIN
			    INSERT INTO SCM_SYS_LOG_BATCH
                (
                      PROGRAM_NAME
                    , LOG_TYPE
                    , LOG_COUNT
                    , LOG_MESSAGE
                    , DESCRIPTION
                    , EVENT_DATE
                    , CREATION_DATE
                    , CREATED_BY
                    , LAST_UPDATE_DATE
                    , LAST_UPDATED_BY
                )
			    VALUES
                (
                      ISNULL(ERROR_PROCEDURE(), @v_program_name)
                    , 'ERROR'
                    , NULL
                    , ERROR_MESSAGE()
                    , NULL
                    , SYSDATETIME()
                    , SYSDATETIME()
                    , ERROR_PROCEDURE()
                    , SYSDATETIME()
                    , ERROR_PROCEDURE()
                );
            END

			-- error코드, errror 메시지 반환
			SELECT  'F' AS result_code

			SELECT    ERROR_LINE()      AS ERRO_LINE
                    , ERROR_NUMBER()    AS ERROR_NO
                    , ERROR_MESSAGE()   AS ERROR_MSG
		END
	END CATCH


	BEGIN -- 임시테이블 및 커서 제거
		IF OBJECT_ID('tempdb..#TBL_SCP0103_ALL') IS NOT NULL
			DROP TABLE #TBL_SCP0103_ALL;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_EE_PLANT') IS NOT NULL
			DROP TABLE #TBL_SCP0103_EE_PLANT;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_ITEM_OPERATION') IS NOT NULL
			DROP TABLE #TBL_SCP0103_ITEM_OPERATION;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_ITEM_UOM') IS NOT NULL
			DROP TABLE #TBL_SCP0103_ITEM_UOM;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_I') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_I;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_I_ALL') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_I_ALL;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_I_MATERIAL') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_I_MATERIAL;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_I_TEMP') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_I_TEMP;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_MODEL_SEMI') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_MODEL_SEMI;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_EE') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_EE;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_MODEL_SEMI_PROD_PLAN_AMEND') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_MODEL_SEMI_PROD_PLAN_AMEND;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_P;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_ITEM_CATEGORY') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_P_ITEM_CATEGORY;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_MATERIAL') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_P_MATERIAL;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_PLAN_KEYS') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_P_PLAN_KEYS;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_SEMI') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_P_SEMI;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_SEMI_STOCK') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_P_SEMI_STOCK;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_SEMI_STOCK_SUM') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_P_SEMI_STOCK_SUM;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_SEMI_TEMP') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_P_SEMI_TEMP;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_P_UOM') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_P_UOM;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_MRP_TEMP') IS NOT NULL
			DROP TABLE #TBL_SCP0103_MRP_TEMP;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_OPERATION') IS NOT NULL
			DROP TABLE #TBL_SCP0103_OPERATION;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_OPERATION_GROUOP') IS NOT NULL
			DROP TABLE #TBL_SCP0103_OPERATION_GROUOP;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_OPERATION_GROUP_PROD') IS NOT NULL
			DROP TABLE #TBL_SCP0103_OPERATION_GROUP_PROD;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_PLANT') IS NOT NULL
			DROP TABLE #TBL_SCP0103_PLANT;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_PLANT_ALL') IS NOT NULL
			DROP TABLE #TBL_SCP0103_PLANT_ALL;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_RAW') IS NOT NULL
			DROP TABLE #TBL_SCP0103_RAW;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCM_DNM_STOCK') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCM_DNM_STOCK;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_FN') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_FN;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_FN_LINE') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_FN_LINE;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_FINAL') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_FINAL;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_TEMP_REQUIREMENT') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_TEMP_REQUIREMENT;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_PLAN_TYPE') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_PLAN_TYPE;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_TREE;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_KEYS') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_TREE_KEYS;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_PROD') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_TREE_PROD;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_RAW') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_TREE_RAW;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SCP_TREE_RAW_TEMP') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SCP_TREE_RAW_TEMP;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_SUPPLIER') IS NOT NULL
			DROP TABLE #TBL_SCP0103_SUPPLIER;
		IF OBJECT_ID('tempdb..#TBL_SCP0103_YIELD') IS NOT NULL
			DROP TABLE #TBL_SCP0103_YIELD;
	END -- 임시테이블 및 커서 제거
END
