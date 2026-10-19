

CREATE PROCEDURE [dbo].[PR_SCM_LGTM_INV_ALLOCATION_RMTL_CAL_YMH_20250812]
     @p_plan_tp_cd              NVARCHAR(20)
    ,@p_division_id             NVARCHAR(30)
    ,@p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_basis_yyyymm            NVARCHAR(6)
	,@p_mrp_version_id             NVARCHAR(30)
AS

BEGIN

-- exec PR_SCM_LGTM_INV_ALLOCATION_RMTL_CAL_OIJ 'RMTL_INIT', '81_ST', '20250303', '202503', 'MRP-SCP-20250311-001'
-- exec PR_SCM_LGTM_INV_ALLOCATION_RMTL_CAL_OIJ 'RMTL_INIT', '81', '20250303', '202503', 'MRP-SCP-20250311-001'
-- exec PR_SCM_LGTM_INV_ALLOCATION_RMTL_CAL_OIJ 'RMTL_INIT', '81_HD', '20250303', '202503', 'MRP-SCP-20250311-001'
-- exec PR_SCM_LGTM_INV_ALLOCATION_RMTL_CAL_OIJ 'RMTL_INIT', '82', '20250303', '202503', 'MRP-SCP-20250311-001'
-- exec PR_SCM_LGTM_INV_ALLOCATION_RMTL_CAL_OIJ 'RMTL_INIT', '40', '20250303', '202503', 'MRP-SCP-20250311-001'
-- exec PR_SCM_LGTM_INV_ALLOCATION_RMTL_CAL_OIJ 'RMTL_INIT', '81_UC', '20250303', '202503', 'MRP-SCP-20250311-001'
-- exec PR_SCM_LGTM_INV_ALLOCATION_RMTL_CAL_OIJ 'RMTL_INIT', '81_HM', '20250303', '202503', 'MRP-SCP-20250311-001'

	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
--jjg	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION_RMTL_CAL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	------------------------------------------------------------------------  

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = @p_plan_tp_cd + '=>'+@p_division_id;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  

    ------------------------------------------------------------------------
	-- Parameter 대신 변수 할당(임시)
	------------------------------------------------------------------------
    DECLARE @v_plan_tp_cd           NVARCHAR(20)    = @p_plan_tp_cd;            -- 'RMTL';
    DECLARE @v_division_id          NVARCHAR(10)    = @p_division_id            -- '82';
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8)     = @p_plan_start_yyyymmdd    -- '20240701';
    DECLARE @v_basis_yyyymm         NVARCHAR(6)     = @p_basis_yyyymm           -- '202407';
    DECLARE @v_vrsn_no              NVARCHAR(50);
    DECLARE @v_add_days             NUMERIC         = 8;
	DECLARE @v_mrp_version_id           NVARCHAR(30)    = @p_mrp_version_id;            -- 
    --DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    --DECLARE @n_log_count    INTEGER = 0;
    --DECLARE @d_event_date   DATETIME;
	------------------------------------------------------------------------  

    ------------------------------------------------------------------------  	
	-- Transaction 2nd Step. (START)
    -- 월별 PSI를 찾아와 Allocation 하는 Loop.
    /*
    1. Calendar 기준으로 시작월부터 월 조건 찾아옴.
    2. Sample: AMFMCC727-B1 기준으로 LOOP 태워보자.
    */

    ------------------------------------------------------------------------  
--jjg	BEGIN TRANSACTION PSI_ALLOCATION;
	------------------------------------------------------------------------  
    BEGIN TRY

        ------------------------------------------------------------------------
		-- Step 1. Initialize Data
		------------------------------------------------------------------------
        
		------------------------------------------------------------------------
		-- Step 1-1. Delete All EOH.
		------------------------------------------------------------------------   
        BEGIN

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '1-1', @d_event_date;
			/*****************************************/

            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd    -- Parameter 처리 필요.
            AND     DATA_TP_CD         IN ('EOH')
            AND     DIVISION_ID         = @v_division_id

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '1-2', @d_event_date;
			/*****************************************/
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  
        
        ------------------------------------------------------------------------
		-- Step 1-1. Delete BOH after start month. [SCM_LGTM_INV_PSI_SUMMARY_RMTL]
		------------------------------------------------------------------------   
        BEGIN

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '2-1', @d_event_date;
			/*****************************************/

            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd    -- Parameter 처리 필요.
            AND     PLAN_YYYYMM         > @v_basis_yyyymm
            AND     DATA_TP_CD         IN ('BOH')
            AND     DIVISION_ID         = @v_division_id

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '2-2', @d_event_date;
			/*****************************************/

		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  

		------------------------------------------------------------------------  
        BEGIN
		------------------------------------------------------------------------
		-- Step 1-2. Delete [SCM_LGTM_INV_PSI_DETAIL_RMTL]
		------------------------------------------------------------------------   

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '3-1', @d_event_date;
			/*****************************************/

            DELETE 
            FROM    SCM_LGTM_INV_PSI_DETAIL_RMTL
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd    -- Parameter 처리 필요.
            AND     DIVISION_ID         = @v_division_id

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '3-2', @d_event_date;
			/*****************************************/

		------------------------------------------------------------------------  
		END
        --PRINT 'START PSI ALLOCATION';

        DECLARE     @v_Counter          INT;
        DECLARE     @v_plan_yyyymmdd    NVARCHAR(8) = CONCAT(@v_basis_yyyymm, '01');
        DECLARE     @v_plan_yyyymm      NVARCHAR(6);
        DECLARE     @v_cnt              INT;
        DECLARE     @v_item_id          NVARCHAR(30);
        
        --Sales
        DECLARE     @v_sale_qty         NUMERIC(30, 6);
        DECLARE     @v_reason_cd        NVARCHAR(10);
        DECLARE     @v_s_plant_id       NVARCHAR(30);
        DECLARE     @v_s_group_code1    NVARCHAR(30);
        DECLARE     @v_s_org_item_id    NVARCHAR(30);
        DECLARE     @v_s_version_no     NVARCHAR(30);
        DECLARE     @v_s_process_group  NVARCHAR(50);
        DECLARE     @v_s_process_detail NVARCHAR(50);
        DECLARE     @v_s_srce_yyyymm    NVARCHAR(6);


        --Prod
        DECLARE     @v_prod_data_tp_cd  NVARCHAR(10);
        DECLARE     @v_srce_tp_cd       NVARCHAR(10);
        DECLARE     @v_plant_id         NVARCHAR(30);
        DECLARE     @v_group_code1      NVARCHAR(30);
        DECLARE     @v_org_item_id      NVARCHAR(30);
        DECLARE     @v_srce_yyyymm      NVARCHAR(6);
        DECLARE     @v_prod_qty         NUMERIC(30, 6);



        IF OBJECT_ID (N'tempdb..#TEMP_END_INV_COST', N'U') IS NOT NULL 		DROP TABLE #TEMP_END_INV_COST;

        SET @v_Counter = 1;
        
        WHILE (@v_Counter <= 13)

            BEGIN

            ----PRINT @v_Counter;
            SET @v_plan_yyyymm = LEFT(CONVERT(NVARCHAR(6), dateadd(month, @v_Counter - 1, convert(date, @v_plan_yyyymmdd, 112)), 112), 6);
            --PRINT @v_plan_yyyymm;


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '4-1', @d_event_date;
			/*****************************************/


            --1. EOH 생성. BOH, P 그대로 EOH에 반영.
            
            INSERT INTO SCM_LGTM_INV_PSI_DETAIL_RMTL
            ( PLAN_TP_CD
            , PLAN_START_YYYYMMDD
            , DATA_TP_CD
            , SRCE_TP_CD
            , DIVISION_ID
            , PLANT_ID
            , GROUP_CODE1
            , ITEM_ID
            , ORIGIN_ITEM_ID
            , SRCE_YYYYMM
            , PLAN_YYYYMM
            , QTY
            , DECREASE_QTY
            , REASON_CD
            , REMAIN_QTY
            , SCM_SITE_ID
            , OPERATION_GROUP
            , OPERATION_ID
            , DEVALUATION_AGE
            , LONG_TERM_TYPE_CODE
            , LONG_TERM_TYPE
            , VERSION_NO
            , PROCESS_GROUP
            , PROCESS_DETAIL
			,company_id   -- jjg 20250323
            )
            SELECT    PLAN_TP_CD
                    , PLAN_START_YYYYMMDD
                    , 'EOH'
                    , SRCE_TP_CD
                    , DIVISION_ID
                    , PLANT_ID
                    , GROUP_CODE1
                    , ITEM_ID
                    , ORIGIN_ITEM_ID
                    , SRCE_YYYYMM
                    , PLAN_YYYYMM
                    , SUM(QTY)                  AS QTY
                    , NULL                      AS DECREASE_QTY
                    , 'X'                       AS REASON_CD
                    , SUM(QTY)                  AS REMAIN_QTY
                    , MAX(SCM_SITE_ID)          AS SCM_SITE_ID
                    , MAX(OPERATION_GROUP)      AS OPERATION_GROUP
                    , MAX(OPERATION_ID)         AS OPERATION_ID
                    , MAX(DEVALUATION_AGE)      AS DEVALUATION_AGE
                    , MAX(LONG_TERM_TYPE_CODE)  AS LONG_TERM_TYPE_CODE
                    , MAX(LONG_TERM_TYPE)       AS LONG_TERM_TYPE
                    , MAX(VERSION_NO)           AS VERSION_NO
                    , MAX(PROCESS_GROUP)        AS PROCESS_GROUP
                    , MAX(PROCESS_DETAIL)       AS PROCESS_DETAIL
					,'*'						as company_id --jjg 20250323
            FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL S WITH(NOLOCK)
            WHERE   1=1
            AND     S.PLAN_TP_CD          = @v_plan_tp_cd
            AND     S.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     S.DIVISION_ID         = @v_division_id
            AND     S.PLAN_YYYYMM         = @v_plan_yyyymm
            AND     S.DATA_TP_CD         IN ('BOH', 'P')
            AND     S.QTY                 > 0   -- 음수 BOH는 S 잔량에서 반영되기 때문에 EOH 반영 불필요.
            --and     S.ITEM_ID             = 'AMFMCC727-B1'
            GROUP BY  PLAN_TP_CD
                    , PLAN_START_YYYYMMDD
                    , SRCE_TP_CD
                    , DIVISION_ID
                    , PLANT_ID
                    , GROUP_CODE1
                    , ITEM_ID
                    , ORIGIN_ITEM_ID
                    , SRCE_YYYYMM
                    , PLAN_YYYYMM
            ;
            
			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '4-2', @d_event_date;
			/*****************************************/

            --2. Sales Count Check. 존재여부 확인.
            -- select  @v_cnt = count(*)
            -- FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL S WITH(NOLOCK)
            -- WHERE   S.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            -- AND     S.DIVISION_ID         = @v_division_id
            -- AND     S.PLAN_YYYYMM         = @v_plan_yyyymm
            -- AND     S.DATA_TP_CD         IN ('S')
            -- and     S.ITEM_ID             = 'AMFMCC727-B1'
            -- ;

            -- --PRINT  'Sales Count: '+CAST(@v_cnt AS NVARCHAR(10));

            IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CURRENT_MONTH_SALES_CUR')
            BEGIN
                CLOSE CURRENT_MONTH_SALES_CUR
                DEALLOCATE CURRENT_MONTH_SALES_CUR
            END;
            DECLARE CURRENT_MONTH_SALES_CUR CURSOR FAST_FORWARD FOR
                                    SELECT    S.DIVISION_ID     AS DIVISION_ID
                                            , S.SRCE_TP_CD      AS REASON_CD
                                            , S.PLANT_ID        AS PLANT_ID
                                            , S.GROUP_CODE1     AS GROUP_CODE1
                                            , S.ITEM_ID         AS ITEM_ID
                                            , S.ORIGIN_ITEM_ID  AS ORIGIN_ITEM_ID
                                            , S.SRCE_YYYYMM     AS SRCE_YYYYMM
                                            , SUM(CASE WHEN S.QTY < 0 then S.QTY*(-1) ELSE S.QTY END)            AS SALE_QTY
                                            , MAX(S.VERSION_NO)     AS VERSION_NO
                                            , MAX(S.PROCESS_GROUP)  AS PROCESS_GROUP
                                            , MAX(S.PROCESS_DETAIL) AS PROCESS_DETAIL
                                    FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL S WITH(NOLOCK)
                                    WHERE   1=1
                                    AND     S.PLAN_TP_CD          = @v_plan_tp_cd
                                    AND     S.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
                                    AND     S.DIVISION_ID         = @v_division_id
                                    AND     S.PLAN_YYYYMM         = @v_plan_yyyymm
                                    AND     S.DATA_TP_CD         IN ('S','BOH')
                                    AND     S.SRCE_TP_CD       LIKE 'S%'
                                    --and     S.ITEM_ID             = 'AMFMCC727-B1'
                                    GROUP BY S.DIVISION_ID
                                            , S.SRCE_TP_CD
                                            , S.PLANT_ID
                                            , S.GROUP_CODE1
                                            , S.ITEM_ID
                                            , S.ORIGIN_ITEM_ID
                                            , S.SRCE_YYYYMM
                                    ORDER BY SRCE_TP_CD DESC

            OPEN CURRENT_MONTH_SALES_CUR
                -- key 정보는 상위 cursor에서 정의된 값을 같이 쓰면됨.
                FETCH NEXT FROM CURRENT_MONTH_SALES_CUR INTO @v_division_id
                                                            , @v_reason_cd
                                                            , @v_s_plant_id
                                                            , @v_s_group_code1
                                                            , @v_item_id
                                                            , @v_s_org_item_id
                                                            , @v_s_srce_yyyymm
                                                            , @v_sale_qty
                                                            , @v_s_version_no
                                                            , @v_s_process_group
                                                            , @v_s_process_detail

                WHILE @@FETCH_STATUS = 0
                BEGIN

                --PRINT 'Fetch Test: '+@v_item_id+' '+CAST(@v_sale_qty as NVARCHAR(100));


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '5-1', @d_event_date;
			/*****************************************/

                    IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CURRENT_MONTH_PROD_CUR')
                    BEGIN
                        CLOSE CURRENT_MONTH_PROD_CUR
                        DEALLOCATE CURRENT_MONTH_PROD_CUR


						/*****************************************/
						SET @v_log_type = 'START';
						SET @v_log_message = 'TEST';
						SET @d_event_date = SYSDATETIME();
						EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '5-2', @d_event_date;
						/*****************************************/

                    END;
                    /*
                    PLAN_START_YYYYMMDD
                    , DATA_TP_CD
                    , SRCE_TP_CD
                    , DIVISION_ID
                    , GROUP_CODE1
                    , ITEM_ID
                    , ORIGIN_ITEM_ID
                    , SRCE_YYYYMM
                    , PLAN_YYYYMM
                    , QTY
                    , DECREASE_QTY
                    , REASON_CD
                    , REMAIN_QTY

                    DECLARE     @v_prod_data_tp_cd  NVARCHAR(10);
                    DECLARE     @v_srce_tp_cd       NVARCHAR(10);
                    DECLARE     @v_group_code1      NVARCHAR(30);
                    DECLARE     @v_org_item_id      NVARCHAR(30);
                    DECLARE     @v_prod_qty         INT;
                    */
                    DECLARE CURRENT_MONTH_PROD_CUR CURSOR FOR
                                                SELECT  S.DATA_TP_CD        AS DATA_TP_CD
                                                        , S.SRCE_TP_CD      AS SRCE_TP_CD
                                                        , S.PLANT_ID        AS PLANT_ID
                                                        , S.GROUP_CODE1     AS GROUP_CODE1
                                                        , S.ORIGIN_ITEM_ID  AS ORIGIN_ITEM_ID
                                                        , S.SRCE_YYYYMM     AS SRCE_YYYYMM
                                                        , S.REMAIN_QTY      AS REMAIN_QTY
                                                FROM    SCM_LGTM_INV_PSI_DETAIL_RMTL S
                                                WHERE   1=1
                                                AND     S.PLAN_TP_CD            = @v_plan_tp_cd
                                                AND     S.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd
                                                AND     S.DATA_TP_CD            = 'EOH'
                                                AND     S.SRCE_TP_CD           IN ('BOH_RMTL', 'BOH_INTS', 'BOH_DEVL', 'P', 'P_MRP_PO','P_MRP_RESULT','P_PINV')
                                                AND     s.DIVISION_ID           = @v_division_id
                                                AND     S.PLANT_ID              = @v_s_plant_id
                                                AND     S.ITEM_ID		        = @v_item_id
                                                AND     s.PLAN_YYYYMM           = @v_plan_yyyymm
                                                AND     S.REMAIN_QTY            > 0
                                                ORDER BY SRCE_YYYYMM, SRCE_TP_CD
                            FOR UPDATE

                    OPEN CURRENT_MONTH_PROD_CUR
                        FETCH NEXT FROM CURRENT_MONTH_PROD_CUR INTO @v_prod_data_tp_cd
                                                                    , @v_srce_tp_cd
                                                                    , @v_plant_id
                                                                    , @v_group_code1
                                                                    , @v_org_item_id
                                                                    , @v_srce_yyyymm
                                                                    , @v_prod_qty
                        WHILE @@FETCH_STATUS = 0
                        BEGIN

                            --PRINT @@FETCH_STATUS;
                            --PRINT 'P type: '+@v_srce_tp_cd+' P YYYYMM: '+@v_srce_yyyymm+' Qty: '+CAST(@v_prod_qty as NVARCHAR(10));
                            IF ( @v_sale_qty > 0) AND (@v_prod_qty <=  @v_sale_qty )-- Demand ID가 전체 다 Full Pegging 되는 case
                                BEGIN
                                    
                                    --PRINT 'Fetch 2: Prod qty '+CAST(@v_prod_qty as NVARCHAR(10))+' < Sale Qty is: '+CAST(@v_sale_qty as NVARCHAR(10));
                                    
			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '5-3', @d_event_date;
			/*****************************************/

                                    -- RMTL Update.
                                    UPDATE  SCM_LGTM_INV_PSI_DETAIL_RMTL
                                    SET       DECREASE_QTY      = @V_PROD_QTY
                                            , REASON_CD         = @V_REASON_CD
                                            , REMAIN_QTY        = 0
                                            , LAST_UPDATE_DATE  = GETDATE()
                                            , LAST_UPDATED_BY   = CONCAT(@V_REASON_CD, '_enough')
                                    WHERE   CURRENT OF CURRENT_MONTH_PROD_CUR
                                    -- AND     PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
                                    -- AND     DATA_TP_CD          = @v_prod_data_tp_cd
                                    -- AND     SRCE_TP_CD          = @V_PROD_DATA_TP_CD
                                    -- AND     GROUP_CODE1         = @V_GROUP_CODE1
                                    -- AND     DIVISION_ID         = @V_DIVISION_ID
                                    -- AND     ITEM_ID		        = @V_ITEM_ID
                                    -- AND     ORIGIN_ITEM_ID      = @V_ORG_ITEM_ID
                                    -- AND     SRCE_YYYYMM         = @V_SRCE_YYYYMM
                                    -- AND     PLAN_YYYYMM         = @V_PLAN_YYYYMM
                                    ;

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '5-4', @d_event_date;
			/*****************************************/
                                    
                                    SET @v_sale_Qty = @v_sale_Qty - @v_prod_Qty;

                                    --PRINT   'Remain Sale Qty: '+CAST(@v_sale_qty as NVARCHAR(10));
                                    
                                    --SET @v_qty = 0
                                END
                            ELSE IF ( @v_sale_qty > 0) AND (@v_prod_qty >  @v_sale_qty )-- Demand ID가 전체 다 Full Pegging 되는 case
                                BEGIN
                                    --PRINT 'Fetch 2: Prod qty '+CAST(@v_prod_qty as NVARCHAR(10))+' > Sale Qty is: '+CAST(@v_sale_qty as NVARCHAR(10));
                                    -- RMTL Update.


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '6-1', @d_event_date;
			/*****************************************/

                                    UPDATE  SCM_LGTM_INV_PSI_DETAIL_RMTL
                                    SET       DECREASE_QTY      = @v_sale_qty
                                            , REASON_CD         = @V_REASON_CD
                                            , REMAIN_QTY        = REMAIN_QTY - @v_sale_qty
                                            , LAST_UPDATE_DATE  = GETDATE()
                                            , LAST_UPDATED_BY   = CONCAT(@V_REASON_CD, '_shortage')
                                    WHERE   CURRENT OF CURRENT_MONTH_PROD_CUR;
                                    -- AND     PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
                                    -- AND     DATA_TP_CD          = @v_prod_data_tp_cd
                                    -- AND     SRCE_TP_CD          = @V_PROD_DATA_TP_CD
                                    -- AND     GROUP_CODE1         = @V_GROUP_CODE1
                                    -- AND     DIVISION_ID         = @V_DIVISION_ID
                                    -- AND     ITEM_ID		        = @V_ITEM_ID
                                    -- AND     ORIGIN_ITEM_ID      = @V_ORG_ITEM_ID
                                    -- AND     SRCE_YYYYMM         = @V_SRCE_YYYYMM
                                    -- AND     PLAN_YYYYMM         = @V_PLAN_YYYYMM
                                    ;
                                    
			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '6-2', @d_event_date;
			/*****************************************/

                                    SET @v_sale_Qty = 0;

                                    --PRINT   '222Remain Sale Qty: '+CAST(@v_sale_qty as NVARCHAR(10));
                                    
                                END
                            

                        FETCH NEXT FROM CURRENT_MONTH_PROD_CUR INTO @v_prod_data_tp_cd
                                                                    , @v_srce_tp_cd
                                                                    , @v_plant_id
                                                                    , @v_group_code1
                                                                    , @v_org_item_id
                                                                    , @v_srce_yyyymm
                                                                    , @v_prod_qty
                        END
                    CLOSE CURRENT_MONTH_PROD_CUR
                    DEALLOCATE CURRENT_MONTH_PROD_CUR

                IF (@v_sale_qty > 0)
                    BEGIN
                        --PRINT 'Minus EOH Insert: '+CAST(@v_sale_qty as NVARCHAR(10));


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '7-1', @d_event_date;
			/*****************************************/

                        INSERT INTO SCM_LGTM_INV_PSI_DETAIL_RMTL
                            ( PLAN_TP_CD 
                            , PLAN_START_YYYYMMDD
                            , DATA_TP_CD
                            , SRCE_TP_CD
                            , DIVISION_ID
                            , PLANT_ID
                            , GROUP_CODE1
                            , ITEM_ID
                            , ORIGIN_ITEM_ID
                            , SRCE_YYYYMM
                            , PLAN_YYYYMM
                            , QTY
                            , DECREASE_QTY
                            , REASON_CD
                            , REMAIN_QTY
                            , VERSION_NO         
                            , PROCESS_GROUP
                            , PROCESS_DETAIL
							,company_id   -- jjg 20250323
                            )
                        SELECT @v_plan_tp_cd
                            , @v_plan_start_yyyymmdd
                            , 'EOH'
                            , @v_reason_cd
                            , @v_division_id
                            , @v_s_plant_id
                            , @v_s_group_code1
                            , @v_item_id
                            , @v_s_org_item_id
                            , @v_s_srce_yyyymm
                            , @v_plan_yyyymm
                            , 0
                            , @v_sale_qty
                            , @v_reason_cd
                            , @v_sale_qty*(-1)
                            , @v_s_version_no
                            , @v_s_process_group
                            , @v_s_process_detail
							,'*'  -- company_id --jjg 20250323
                        ;
                            
			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '7-2', @d_event_date;
			/*****************************************/


                    END

                FETCH NEXT FROM CURRENT_MONTH_SALES_CUR INTO @v_division_id
                                                            , @v_reason_cd
                                                            , @v_s_plant_id
                                                            , @v_s_group_code1
                                                            , @v_item_id
                                                            , @v_s_org_item_id
                                                            , @v_s_srce_yyyymm
                                                            , @v_sale_qty
                                                            , @v_s_version_no
                                                            , @v_s_process_group
                                                            , @v_s_process_detail
                END
            CLOSE CURRENT_MONTH_SALES_CUR
            DEALLOCATE CURRENT_MONTH_SALES_CUR




            ------------------------------------------------------------------------
            -- 당월 Loop 전부 처리한 뒤, 당월 EOH를 차월 BOH로 반영.
            ------------------------------------------------------------------------  
            BEGIN 

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '8-1', @d_event_date;
			/*****************************************/

                WITH SEQ AS 
                    (
                        SELECT  1 LV 
                        UNION ALL
                        SELECT  LV+1 LV FROM SEQ WHERE LV+1 < 3
                    )
                INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_RMTL
                        (PLAN_TP_CD
                        ,PLAN_START_YYYYMMDD
                        ,DATA_TP_CD
                        ,SRCE_TP_CD
                        ,DIVISION_ID
                        ,PLANT_ID
                        ,GROUP_CODE1
                        ,ITEM_ID
                        ,ORIGIN_ITEM_ID
                        ,SRCE_YYYYMM
                        ,PLAN_YYYYMM
                        ,QTY
                        ,SCM_SITE_ID
                        ,OPERATION_GROUP
                        ,OPERATION_ID
                        ,DEVALUATION_AGE
                        ,LONG_TERM_TYPE_CODE
                        ,LONG_TERM_TYPE
                        ,VERSION_NO
                        ,PROCESS_GROUP
                        ,PROCESS_DETAIL
						,company_id   -- jjg 20250323
                        )
                SELECT   PLAN_TP_CD
                        ,PLAN_START_YYYYMMDD
                        ,CASE WHEN SEQ.LV = 1 THEN EOH.DATA_TP_CD ELSE 'BOH' END AS DATA_TP_CD
                        ,SRCE_TP_CD
                        ,DIVISION_ID
                        ,PLANT_ID
                        ,GROUP_CODE1
                        ,ITEM_ID
                        ,ORIGIN_ITEM_ID
                        ,SRCE_YYYYMM
                        ,CASE   WHEN SEQ.LV = 1 THEN EOH.PLAN_YYYYMM 
                                ELSE LEFT(CONVERT(NVARCHAR(6), dateadd(month, @v_Counter, convert(date, @v_plan_yyyymmdd, 112)), 112), 6) 
                                END AS PLAN_YYYYMM
                        ,REMAIN_QTY             AS QTY
                        ,SCM_SITE_ID
                        ,OPERATION_GROUP
                        ,OPERATION_ID
                        ,DEVALUATION_AGE
                        ,LONG_TERM_TYPE_CODE
                        ,LONG_TERM_TYPE
                        ,VERSION_NO
                        ,PROCESS_GROUP
                        ,PROCESS_DETAIL
						,'*'	as company_id --jjg 20250323
                FROM    SCM_LGTM_INV_PSI_DETAIL_RMTL EOH WITH(NOLOCK)
                    , SEQ
                WHERE   1=1
                AND     EOH.PLAN_TP_CD          = @v_plan_tp_cd
                AND     EOH.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
                AND     EOH.DATA_TP_CD          = 'EOH'
                --AND     EOH.SRCE_TP_CD         IN ('BOH', 'P')
                AND     EOH.DIVISION_ID         = @V_DIVISION_ID
                AND     EOH.PLAN_YYYYMM         = @V_PLAN_YYYYMM
                AND     EOH.REMAIN_QTY         <> 0
                ;


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '8-2', @d_event_date;
			/*****************************************/

            END;



            SET @v_Counter = @v_Counter + 1;

            END;

        ------------------------------------------------------------------------
		-- Step 3. 재고 월령 업데이트 [SCM_LGTM_INV_PSI_DETAIL_RMTL]
        -- 2024.10.23 Philsu Park: 월령 값 음수 보완 처리.
		------------------------------------------------------------------------   
        BEGIN


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '9-1', @d_event_date;
			/*****************************************/

            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_RMTL
            SET     LONG_TERM_TYPE          = CASE  WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 3 THEN N'비대상'
                                                    WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 6 THEN N'부실 징후'
                                                    WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) >= 6 THEN N'부실'
                                                    ELSE NULL END
                    , LONG_TERM_TYPE_CODE   = CASE  WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 3 THEN N'CODE_2'
                                                    WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 6 THEN N'CODE_5'
                                                    WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) >= 6 THEN N'CODE_6'
                                                    ELSE NULL END  
                    , DEVALUATION_AGE       = CONCAT('GRM',RIGHT(REPLICATE('0', 2)+CAST(IIF(DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112))<0, 0
                                                                                           ,DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)))  AS VARCHAR), 2) )
                    --, DEVALUATION_AGE       = CONCAT('GRM',RIGHT(REPLICATE('0', 2)+CAST(DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) AS VARCHAR), 2) )
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = @v_division_id


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '9-2', @d_event_date;
			/*****************************************/

        END

-- here 1m 1s

        ------------------------------------------------------------------------
		-- Step 4-2 Group_Code1 값이 ITEM_ID와 동일한 경우 한번 더 찾아줌.
        -- 1. ITEM_ID -> Applied_Model -> DOE(Basic Model) 기준의 NICK_NAME
        -- 2. ITEM_ID -> DOE 기준의 NICK_NAME
        -- 3. ITEM_ID 기준의 NICK_NAME
        -- RMTL은 Item Class 사용하기 때문에 Group_Code1 업데이트 불필요.
		------------------------------------------------------------------------
        /* BEGIN
            WITH ITEM_M AS (
                            SELECT    I.DIVISION_ID
                                    , I.ITEM_ID
                                    , MAX(CASE WHEN ISNULL(F1.GROUP_CODE1, '') != '' THEN F1.GROUP_CODE1
                                                WHEN ISNULL(F3.GROUP_CODE1, '') != '' THEN F3.GROUP_CODE1
                                                WHEN ISNULL(F2.GROUP_CODE1, '') != '' THEN F2.GROUP_CODE1
                                                WHEN ISNULL(I.DOE, '') = '' THEN ISNULL(I3.NICK_NAME, I.NICK_NAME)
                                                ELSE ISNULL(I2.NICK_NAME, I.NICK_NAME) END
                                                ) AS GROUP_CODE1
                            FROM    SCM_ITEM_M_SN I WITH(NOLOCK)
                            LEFT OUTER JOIN SCM_ITEM_M_SN I2 WITH(NOLOCK)
                            ON      I2.ITEM_ID      = CASE WHEN ISNULL(I.DOE, '') = '' THEN I.APPLIED_MODEL ELSE ISNULL(I.DOE, '') END
                            AND     I2.DIVISION_ID  = I.DIVISION_ID
                            LEFT OUTER JOIN SCM_ITEM_M_SN I3 WITH(NOLOCK)
                            ON      I3.ITEM_ID      = I2.DOE
                            AND     I3.DIVISION_ID  = I2.DIVISION_ID
                            LEFT OUTER JOIN SCP_MST_FINAL_ITEM F1 WITH(NOLOCK)
                            ON      F1.ITEM_ID      = I.ITEM_ID
                            AND     F1.DIVISION_ID  = I.DIVISION_ID
                            LEFT OUTER JOIN SCP_MST_FINAL_ITEM F2 WITH(NOLOCK)
                            ON      F2.ITEM_ID      = CASE WHEN ISNULL(I.DOE, '') = '' THEN I.APPLIED_MODEL ELSE ISNULL(I.DOE, '') END
                            AND     F2.DIVISION_ID  = I.DIVISION_ID
                            LEFT OUTER JOIN SCP_MST_FINAL_ITEM F3 WITH(NOLOCK)
                            ON      F3.ITEM_ID      = I2.DOE
                            AND     F3.DIVISION_ID  = I2.DIVISION_ID
                            WHERE   1=1
                            GROUP BY I.DIVISION_ID
                                    , I.ITEM_ID
                            )
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_RMTL
            SET     GROUP_CODE1     = ISNULL((  SELECT  M.GROUP_CODE1 
                                                FROM    ITEM_M  M WITH(NOLOCK) 
                                                WHERE   M.DIVISION_ID = SCM_LGTM_INV_PSI_SUMMARY_RMTL.DIVISION_ID
                                                AND     M.ITEM_ID     = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ORIGIN_ITEM_ID
                                                ), GROUP_CODE1)
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     (GROUP_CODE1         = ITEM_ID 
                  OR GROUP_CODE1         = ORIGIN_ITEM_ID
                  OR ISNULL(GROUP_CODE1, '') = ''
                  )
        END */

		------------------------------------------------------------------------
		-- Step 4-2-1 81*인것에 대하여 GROUP CODE값을 SCP_MST_FINAL_ITEM.LEVEL2_CODE의 값을 활용하도록 함 -- OIJ
		------------------------------------------------------------------------
		IF LEFT(@v_division_id, 2) = '81'
        BEGIN
          
			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '10-1', @d_event_date;
			/*****************************************/

        UPDATE	SCM_LGTM_INV_PSI_SUMMARY
		   SET	SCM_LGTM_INV_PSI_SUMMARY.GROUP_CODE1 = M.LEVEL2_CODE
		  FROM	SCM_LGTM_INV_PSI_SUMMARY SUM, SCP_MST_FINAL_ITEM M
		 WHERE	SUM.ORIGIN_DIVISION_ID = M.DIVISION_ID
		   AND	SUM.ITEM_ID = M.ITEM_ID
		   AND	M.LEVEL2_CODE IS NOT NULL AND M.LEVEL2_CODE <> ''
		   AND	SUM.DIVISION_ID  = @v_division_id
		   AND	SUM.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
		   AND  SUM.PLAN_TP_CD          = @v_plan_tp_cd

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '10-2', @d_event_date;
			/*****************************************/
		   
		--UPDATE SCM_LGTM_INV_PSI_SUMMARY
		--SET SCM_LGTM_INV_PSI_SUMMARY.GROUP_CODE1 = M.LEVEL2_CODE
		--FROM SCM_LGTM_INV_PSI_SUMMARY SUM, SCP_MST_FINAL_ITEM M
		--WHERE SUM.ORIGIN_DIVISION_ID = M.DIVISION_ID
		--AND SUM.ITEM_ID = M.ITEM_ID
		--AND SUM.ORIGIN_DIVISION_ID LIKE '81%'
		--AND SUM.PLAN_START_YYYYMMDD = '20250303'

        END

        ------------------------------------------------------------------------
		-- Step 4-2 마감재고 기반 단가정보 추출. 0값 포함 필요(실적구간 0인 경우 0으로 반영)
        ------------------------------------------------------------------------
        BEGIN 



			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '11-1', @d_event_date;
			/*****************************************/

            SELECT MM.DIVISION_ID, MM.PLANT_ID, MM.ITEM_ID, MM.YYYYMM, MM.COST
            INTO   #TEMP_END_INV_COST
            FROM (
                    SELECT INV.DIVISION_ID, INV.PLANT_ID, INV.ITEM_ID, INV.YYYYMM
                            , IIF(SUM(INV.QUANTITY)=0, 0, SUM(INV.AMOUNT_KRW)/SUM(INV.QUANTITY)) AS COST
                    FROM   SCP_ANL_MONTH_END_STOCK_R INV WITH(NOLOCK)
                    INNER JOIN (    SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                ) C
                        ON  C.ITEM_ID = INV.ITEM_ID
                    INNER JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE   1=1
                    --and     INV.DIVISION_ID    = @v_division_id --  LIKE CONCAT(SUBSTRING(@v_division_id, 1, 2), '%')
                    AND     INV.YYYYMM              > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -13, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND     INV.YYYYMM             <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND     CASE WHEN INV.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                WHEN INV.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                ELSE D.ITEM_TYPE
                                END               = N'원부자재'
                    --and    ISNULL(INV.QUANTITY, 0) != 0
                    GROUP BY INV.DIVISION_ID, INV.PLANT_ID, INV.ITEM_ID, INV.YYYYMM
                    HAVING SUM(INV.QUANTITY) != 0
                    ) MM
            --WHERE ISNULL(COST, 0) != 0


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '11-1', @d_event_date;
			/*****************************************/

        END
        



        ------------------------------------------------------------------------
		-- Step 4-3.1 가중평균 단가 업데이트. ORIGIN_ITEM_ID 기준으로 전월 마감재고의 단가 참조.
        -- 실적구간인 경우, Cost가 0일 때 0값 그대로 반영하고 계획구간은 추가로 단가 탐색 처리.
		------------------------------------------------------------------------
        BEGIN


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '12-1', @d_event_date;
			/*****************************************/

            UPDATE  RM
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT IIF((RM.DATA_TP_CD = 'RESULT' OR RM.SRCE_TP_CD LIKE 'BOH%'), B.COST, IIF(B.COST = 0, NULL, B.COST))--COST --SUM(AMOUNT_KRW)/SUM(QUANTITY)
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  B.YYYYMM             = CASE WHEN RM.DATA_TP_CD = 'RESULT' THEN RM.PLAN_YYYYMM
                                                                           ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                                                            END
                                        AND    B.DIVISION_ID        = RM.DIVISION_ID
                                        AND    B.PLANT_ID           = RM.PLANT_ID
                                        and    B.ITEM_ID            = RM.ITEM_ID
                                        --AND    B.STORAGE_LOCATION  != N'미착' 
                                        )
                                        /* ( SELECT SUM(AMOUNT_KRW)/SUM(QUANTITY)
                                        FROM   SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                                        WHERE  B.YYYYMM             = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                        AND    B.DIVISION_ID        = SCM_LGTM_INV_PSI_SUMMARY_RMTL.DIVISION_ID
                                        and    B.ITEM_ID            = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ORIGIN_ITEM_ID
                                        --AND    B.STORAGE_LOCATION  != N'미착' 
                                        ) */
                    ,CST_CTN        = N'1st 마감재고 가중평균 단가_ITEM'
            FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL RM
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '12-2', @d_event_date;
			/*****************************************/

        END

		--2025-02-14 OIJ
		PRINT N'START DIVISION_ID를 제외하고 ITEM 기준: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
		------------------------------------------------------------------------
		-- Step 4-3.1.1 가중평균 단가 업데이트. DIVISION_ID를 제외하고 ITEM 기준으로 전월 마감재고의 단가 참조.
		------------------------------------------------------------------------
		
        BEGIN

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '13-1', @d_event_date;
			/*****************************************/

            UPDATE  S
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT IIF((S.DATA_TP_CD = 'RESULT' OR S.SRCE_TP_CD LIKE 'BOH%'), B.COST, IIF(B.COST = 0, NULL, B.COST))--COST --SUM(AMOUNT_KRW)/SUM(QUANTITY)
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  B.YYYYMM             = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM
                                                                           ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                                                            END
                                        --AND    B.DIVISION_ID        = S.DIVISION_ID
                                        AND    B.ITEM_ID            = S.ITEM_ID
										AND    B.PLANT_ID			= S.PLANT_ID
                                        --AND    B.STORAGE_LOCATION  != N'미착' 
                                        )
                    ,CST_CTN        = N'1st 마감재고 가중평균 단가_by_ITEM_2'
            FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL S
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND     STANDARD_COST      IS NULL

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '13-2', @d_event_date;
			/*****************************************/


        END

        PRINT N'START 가중평균 단가 ORIGIN ITEM 기준 과거구간 탐색: '  + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        ------------------------------------------------------------------------
		-- Step 4-3.2 가중평균 단가 업데이트. ORIGIN_ITEM_ID 기준으로 최근 마감재고의 단가 참조.
		------------------------------------------------------------------------
        BEGIN


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '14-1', @d_event_date;
			/*****************************************/

            UPDATE  S
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT TOP 1 IIF((S.DATA_TP_CD = 'RESULT' OR S.SRCE_TP_CD LIKE 'BOH%'), B.COST, IIF(B.COST = 0, NULL, B.COST))
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND    B.YYYYMM             = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM ELSE B.YYYYMM END
                                        AND    B.DIVISION_ID        = S.DIVISION_ID
                                        AND    B.PLANT_ID           = S.PLANT_ID
                                        AND    B.ITEM_ID            = S.ITEM_ID
                                        AND    B.COST               > 0
                                        ORDER BY B.YYYYMM DESC
                                        )
                    ,CST_CTN        = ( SELECT TOP 1 N'2nd 과거 마감재고 가중평균 단가_by_ITEM(Mapping) : '+B.YYYYMM
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND    B.YYYYMM             = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM ELSE B.YYYYMM END
                                        AND    B.DIVISION_ID        = S.DIVISION_ID
                                        AND    B.PLANT_ID           = S.PLANT_ID
                                        AND    B.ITEM_ID            = S.ITEM_ID
                                        AND    B.COST               > 0
                                        ORDER BY B.YYYYMM DESC
                                        )
            FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL S
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     STANDARD_COST      IS NULL


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '14-2', @d_event_date;
			/*****************************************/

        END

        

        ------------------------------------------------------------------------
		-- Step 4-3.2 가중평균 단가 업데이트. ITEM_ID 기준으로 한번 더.
		------------------------------------------------------------------------
        /* BEGIN
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_RMTL
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT SUM(AMOUNT_KRW)/SUM(QUANTITY)
                                        FROM   SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                                        WHERE  B.YYYYMM             = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                        AND    B.DIVISION_ID        = SCM_LGTM_INV_PSI_SUMMARY_RMTL.DIVISION_ID
                                        and    B.ITEM_ID            = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ITEM_ID
                                        AND    B.STORAGE_LOCATION  != N'미착' )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||2nd 마감재고 가중평균 단가_ITEM')
            WHERE   1=1 
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     ISNULL(STANDARD_COST, 0)    = 0
        END */


        ------------------------------------------------------------------------
		-- Step 4-3.3 MRP 소진계획 기준 단가
        -- 2024.09.23 Philsu Park: Plant 조건 걸어주고, Version 하드코딩(임시) 필요.
		------------------------------------------------------------------------
        BEGIN


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '15-1', @d_event_date;
			/*****************************************/

            WITH COST AS (SELECT  SUM.DIVISION_ID, SUM.PLANT_ID, SUM.ITEM_ID, SUM.ORIGIN_ITEM_ID
                            ,   (   SELECT TOP 1 R.UNIT_PRICE * (CASE WHEN R.CUR_CD = 'KRW' THEN 1 ELSE CUR.EX_TO_BAMT END)
                                    FROM    XIF_MRP_TB_RS_ITEM_CONSUM_R_SN R with(nolock)
                                            LEFT OUTER JOIN (   SELECT  PLANT_ID, MAX(COMPANY_ID) AS COMPANY_ID, MAX(DIVISION_ID) AS DIVISION_ID
                                                                FROM    SCM_MST_SITE SM WITH(NOLOCK)
                                                                WHERE   1=1
                                                                AND     SM.SITE_TYPE   = 'PLANT'  
                                                                GROUP BY PLANT_ID ) SMS  
                                                ON  SMS.PLANT_ID    = R.PLANT_CD
                                            LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
                                                ON  SIM.DIVISION_ID = SMS.DIVISION_ID
                                                AND SIM.COMPANY_ID  = SMS.COMPANY_ID
                                                AND SIM.ITEM_ID     = R.ITEM_CD
                                            LEFT OUTER JOIN (   SELECT DISTINCT WAERS, EX_TO_BAMT
                                                                FROM   SCP_ANL_LONG_TERM_STOCK WITH(NOLOCK)
                                                                WHERE  YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)) CUR
                                                ON  CUR.WAERS = R.CUR_CD
                                    WHERE 1=1
                                    AND   R.PLAN_TYP        = 'SCP'
                                    AND   R.BUCKET_TYP      = 'BUCKET_TYP_006'
                                    AND   R.ATTRBT_4_VAL    = 'P'
                                    AND   R.PLAN_SRC_TYP    <> '*'
                                    AND   R.VRSN_ID			 = @v_mrp_version_id
														--IN (    ---SELECT  MAX(VRSN_ID)
              --                                              ---FROM    XIF_MRP_TB_RS_ITEM_CONSUM_R_SN R with(nolock)
              --                                              ---WHERE   IF_RCV_DATE >= DATEADD(DAY, -30, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)) 
              --                                              ---AND     IF_RCV_DATE < DATEADD(DAY, @v_add_days, CONVERT(DATE, @v_plan_start_yyyymmdd, 112))
              --                                              --AND     VRSN_ID = 'MRP-SCP-20240906-001'
              --                                             'MRP-SCP-20250101-001'
              --                                              )
                                    AND  R.PLANT_CD      =  SUM.PLANT_ID
                                    AND  R.ITEM_CD       =  SUM.ITEM_ID
                                    AND  SMS.DIVISION_ID =  SUM.DIVISION_ID
                                    ORDER BY 1 ASC
                                ) AS KRW_STANDARD_COST
                        FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL SUM WITH(NOLOCK)
                        WHERE   1=1 
                        AND     SUM.PLAN_TP_CD                  = @v_plan_tp_cd
                        AND     SUM.PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
                        AND     SUM.STANDARD_COST              IS NULL
						AND     SUM.DIVISION_ID				    = @v_division_id
                        GROUP BY SUM.DIVISION_ID, SUM.PLANT_ID, SUM.ITEM_ID, SUM.ORIGIN_ITEM_ID
                        )
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_RMTL
            SET      CURRENCY       = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST.KRW_STANDARD_COST
                                        FROM   COST
                                        WHERE  COST.DIVISION_ID     = SCM_LGTM_INV_PSI_SUMMARY_RMTL.DIVISION_ID
                                        AND    COST.PLANT_ID        = SCM_LGTM_INV_PSI_SUMMARY_RMTL.PLANT_ID
                                        AND    COST.ITEM_ID         = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ITEM_ID
                                        AND    COST.ORIGIN_ITEM_ID  = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ORIGIN_ITEM_ID
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||3rd MRP 단가')
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     STANDARD_COST              IS NULL
            AND     DATA_TP_CD                 != 'RESULT'

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '15-2', @d_event_date;
			/*****************************************/


        END



        ------------------------------------------------------------------------
		-- Step 4-3.4 Item Master의 Standard Cost 사용. 동일 Company 기준.
		------------------------------------------------------------------------
        BEGIN


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '16-1', @d_event_date;
			/*****************************************/

            --Cost.
            WITH COST AS (SELECT NOCOST.DIVISION_ID
                                ,NOCOST.ITEM_ID
                                ,NOCOST.ORIGIN_ITEM_ID
                                ,NOCOST.SCM_SITE_ID
                                ,SMS.COMPANY_ID
                                ,SIM.CURRENCY
                                ,SIM.STANDARD_COST
                                ,CUR.EX_TO_BAMT
                                ,SIM.STANDARD_COST * (CASE WHEN SIM.CURRENCY = 'KRW' THEN 1 ELSE CUR.EX_TO_BAMT END) AS KRW_STANDARD_COST
                        FROM   (SELECT DIVISION_ID, ITEM_ID, ORIGIN_ITEM_ID, MAX(SCM_SITE_ID) SCM_SITE_ID
                                FROM   SCM_LGTM_INV_PSI_SUMMARY_RMTL SUM WITH(NOLOCK)
                                WHERE  SUM.PLAN_START_YYYYMMDD      = @v_plan_start_yyyymmdd
                                AND    SUM.STANDARD_COST           IS NULL
                                GROUP BY DIVISION_ID, ITEM_ID, ORIGIN_ITEM_ID) NOCOST
                                LEFT OUTER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
                                    ON  SMS.DIVISION_ID = NOCOST.DIVISION_ID
                                    AND SMS.SCM_SITE_ID = NOCOST.SCM_SITE_ID
                                LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
                                    ON  SIM.DIVISION_ID = NOCOST.DIVISION_ID
                                    AND SIM.COMPANY_ID  = SMS.COMPANY_ID
                                    AND SIM.ITEM_ID     = NOCOST.ORIGIN_ITEM_ID
                                LEFT OUTER JOIN (SELECT DISTINCT WAERS, EX_TO_BAMT
                                                FROM   SCP_ANL_LONG_TERM_STOCK WITH(NOLOCK)
                                                WHERE  YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)) CUR
                                    ON CUR.WAERS = SIM.CURRENCY
                        WHERE   1=1
                        AND     ISNULL(NOCOST.SCM_SITE_ID, '')  != ''
                        AND     ISNULL(SIM.STANDARD_COST, 0)    != 0
                            )
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_RMTL
            SET      CURRENCY       = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST.KRW_STANDARD_COST
                                        FROM   COST
                                        WHERE  COST.DIVISION_ID     = SCM_LGTM_INV_PSI_SUMMARY_RMTL.DIVISION_ID
                                        AND    COST.ITEM_ID         = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ITEM_ID
                                        AND    COST.ORIGIN_ITEM_ID  = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ORIGIN_ITEM_ID
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||4th 표준단가')
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     STANDARD_COST              IS NULL
            AND     DATA_TP_CD                 != 'RESULT'


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '16-2', @d_event_date;
			/*****************************************/

        END

        ------------------------------------------------------------------------------------------
		-- Step 4-3.5 Item Master의 Standard Cost 사용. Company 조건 제외하고 KRW 반영 기준 최저단가.
		------------------------------------------------------------------------------------------
        BEGIN


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '17-1', @d_event_date;
			/*****************************************/

            --Cost.
            WITH COST AS (  SELECT  SUM.DIVISION_ID, SUM.ITEM_ID, SUM.ORIGIN_ITEM_ID
                                    ,   (   SELECT TOP 1 M.STANDARD_COST * (CASE WHEN M.CURRENCY = 'KRW' THEN 1 ELSE CUR.EX_TO_BAMT END)
                                            FROM   SCM_ITEM_M_SN M WITH(NOLOCK)
                                            LEFT OUTER JOIN (   SELECT DISTINCT WAERS, EX_TO_BAMT
                                                                FROM   SCP_ANL_LONG_TERM_STOCK WITH(NOLOCK)
                                                                WHERE  YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)) CUR
                                                ON  CUR.WAERS = M.CURRENCY
                                            WHERE   M.DIVISION_ID               = SUM.DIVISION_ID
                                            AND     M.ITEM_ID                   = SUM.ORIGIN_ITEM_ID
                                            and     ISNULL(M.STANDARD_COST, 0) <> 0
                                            ORDER BY 1 ASC
                                        ) AS KRW_STANDARD_COST
                            FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL SUM WITH(NOLOCK)
                            WHERE   1=1 
                            AND     SUM.PLAN_TP_CD                  = @v_plan_tp_cd
                            AND     SUM.PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
                            AND     SUM.STANDARD_COST              IS NULL
                            GROUP BY SUM.DIVISION_ID, SUM.ITEM_ID, SUM.ORIGIN_ITEM_ID
                            )
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_RMTL
            SET      CURRENCY       = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST.KRW_STANDARD_COST
                                        FROM   COST
                                        WHERE  COST.DIVISION_ID     = SCM_LGTM_INV_PSI_SUMMARY_RMTL.DIVISION_ID
                                        AND    COST.ITEM_ID         = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ITEM_ID
                                        AND    COST.ORIGIN_ITEM_ID  = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ORIGIN_ITEM_ID
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||5th MIN_표준단가')
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     STANDARD_COST              IS NULL
            --AND     DATA_TP_CD                 != 'RESULT'


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '17-2', @d_event_date;
			/*****************************************/

        END
        
        ------------------------------------------------------------------------------------------
		-- Step 4-3.6 최저판가 기준으로 한번 더 업데이트.
		------------------------------------------------------------------------------------------
        BEGIN


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '18-1', @d_event_date;
			/*****************************************/

            WITH VER AS (
                           SELECT   MAX(VERSION_NO) AS VERSION_NO
                            FROM    DM_MST_VERSION V WITH(NOLOCK)
                                    ,(  SELECT    CAL2.BASIS_YYYYMMDD
                                        FROM     SCM_SYS_CALENDAR_M CAL1  WITH(NOLOCK) 
                                                ,SCM_SYS_CALENDAR_M CAL2  WITH(NOLOCK) 
                                        WHERE   1=1
                                        AND     CAL1.ISO_YYYYWW      = CAL2.ISO_YYYYWW
                                        AND     CAL1.BASIS_YYYYMMDD  = @v_plan_start_yyyymmdd
                                    ) CAL
                            WHERE  1=1
                            AND    V.YYYYMMDD       = CAL.BASIS_YYYYMMDD 
                            AND    V.VERSION_TYPE   = 'SP_W' -- SALES PRICE는 SP_W에서 CONFIRM.
                            AND    V.DIVISION_ID    = @v_division_id
                        )
            , COST AS (
                        SELECT  NOCOST.DIVISION_ID, NOCOST.ITEM_ID, NOCOST.ORIGIN_ITEM_ID
                                , MIN(T.PRICE) AS KRW_SALES_COST
                        FROM    (   SELECT DIVISION_ID, ITEM_ID, ORIGIN_ITEM_ID
                                    FROM   SCM_LGTM_INV_PSI_SUMMARY_RMTL SUM WITH(NOLOCK)
                                    WHERE  1=1 
                                    AND    SUM.PLAN_TP_CD               = @v_plan_tp_cd
                                    AND    SUM.DIVISION_ID              = @v_division_id
                                    AND    SUM.PLAN_START_YYYYMMDD      = @v_plan_start_yyyymmdd
                                    AND    SUM.STANDARD_COST           IS NULL
                                    GROUP BY DIVISION_ID, ITEM_ID, ORIGIN_ITEM_ID) NOCOST
                        INNER JOIN SCM_MST_FUTURE_PRICE_C T WITH(NOLOCK)
                            ON  T.DIVISION_ID   = NOCOST.DIVISION_ID
                            AND T.ITEM_ID       = NOCOST.ORIGIN_ITEM_ID
                            AND T.MEASURE       = 'KRW'
                        INNER JOIN VER V
                            ON  V.VERSION_NO    = T.VERSION_NO
                        WHERE   1=1
                        GROUP BY NOCOST.DIVISION_ID, NOCOST.ITEM_ID, NOCOST.ORIGIN_ITEM_ID
                        )
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_RMTL
            SET     CURRENCY       = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST.KRW_SALES_COST
                                        FROM   COST
                                        WHERE  COST.DIVISION_ID     = SCM_LGTM_INV_PSI_SUMMARY_RMTL.DIVISION_ID
                                        AND    COST.ITEM_ID         = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ITEM_ID
                                        AND    COST.ORIGIN_ITEM_ID  = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ORIGIN_ITEM_ID
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||6th MIN_판가')
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     STANDARD_COST              IS NULL
            AND     DATA_TP_CD                 != 'RESULT'


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '18-2', @d_event_date;
			/*****************************************/

        END


		 ------------------------------------------------------------------------------------------
		-- Step 4-3-1.5 Item Master의 Standard Cost 사용. ITEM기준으로 최종 적용
		------------------------------------------------------------------------------------------
   --     BEGIN
   --         --Cost.
   --        BEGIN
   --         UPDATE  S
   --         SET     CURRENCY        = 'KRW'
   --                 ,STANDARD_COST  = ( SELECT IIF((S.DATA_TP_CD = 'RESULT' OR S.SRCE_TP_CD LIKE 'BOH%'), B.COST, IIF(B.COST = 0, NULL, B.COST))--COST --SUM(AMOUNT_KRW)/SUM(QUANTITY)
   --                                     FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
   --                                     WHERE  B.YYYYMM             = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM
   --                                                                        ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
   --                                                                         END
   --                                     --AND    B.DIVISION_ID        = S.DIVISION_ID
   --                                     AND    B.ITEM_ID            = S.ITEM_ID
			--							AND    B.PLANT_ID			= S.PLANT_ID
   --                                     --AND    B.STORAGE_LOCATION  != N'미착' 
   --                                     )
   --                 ,CST_CTN        = CONCAT(CST_CTN, N'||7th 가중평균 단가_by_ITEM_3')
   --         FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL S
   --         WHERE   1=1 
   --         AND     PLAN_TP_CD          = @v_plan_tp_cd
   --         --AND     DIVISION_ID         = @v_division_id
   --         AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			--AND     STANDARD_COST      IS NULL
   --     END

   --     END

        ------------------------------------------------------------------------
		-- Step 4-4 Amount 업데이트. 4-3에서 적용한 단가 기준.
		------------------------------------------------------------------------
        BEGIN

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '19-1', @d_event_date;
			/*****************************************/

            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_RMTL
            SET     AMT     = STANDARD_COST * QTY
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '19-2', @d_event_date;
			/*****************************************/


        END

        ------------------------------------------------------------------------
		-- Step 4-5 음수 0 처리.
		------------------------------------------------------------------------
        /* BEGIN
            UPDATE  SUM
            SET       SUM.QTY               = 0
                    , SUM.AMT               = 0
                    , SUM.LAST_UPDATE_DATE  = GETDATE()
                    , SUM.LAST_UPDATED_BY   = 'Minus_to_Zero'
            FROM    SCM_LGTM_INV_PSI_SUMMARY_RMTL SUM
            WHERE   1=1
            AND     SUM.PLAN_TP_CD          = @v_plan_tp_cd
            AND     SUM.DIVISION_ID         = @v_division_id
            AND     SUM.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     SUM.DATA_TP_CD         IN ('BOH','EOH')
            AND     SUM.QTY                 < 0
        END */

        ------------------------------------------------------------------------
		-- Step 4-6. 재고 월령 초기화 by lookup item
		------------------------------------------------------------------------   
        BEGIN


			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '20-1', @d_event_date;
			/*****************************************/


            UPDATE   SCM_LGTM_INV_PSI_SUMMARY_RMTL      
            SET       LONG_TERM_TYPE        =  N'비대상'
                    , LONG_TERM_TYPE_CODE   =  N'CODE_2'
                    , DEVALUATION_AGE       = 'GRM00'
                    , LAST_UPDATED_BY       = LAST_UPDATED_BY+' DEVAL Init'
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = @v_division_id
            AND     DATA_TP_CD          <> 'RESULT'
            AND     ITEM_ID IN ( SELECT SEGMENT2
                                 FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                                 WHERE  L.LOOKUP_TYPE   = 'SCM_LGTM_DEVALUDATION_EXC_ITEM_CD'
                                 AND    L.SEGMENT1      = 'RMTL_INIT'
                                 AND    L.VALID_YN      = 'Y' )

			/*****************************************/
			SET @v_log_type = 'START';
			SET @v_log_message = 'TEST';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '20-2', @d_event_date;
			/*****************************************/


        END
        ------------------------------------------------------------------------

        IF OBJECT_ID (N'tempdb..#TEMP_END_INV_COST', N'U') IS NOT NULL 		DROP TABLE #TEMP_END_INV_COST;
        

--jjg        COMMIT TRANSACTION;
    END TRY
    
    ------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
--jjg	ROLLBACK TRANSACTION PSI_ALLOCATION;
	------------------------------------------------------------------------

	/*****************************************/
	SET @v_log_type = 'START';
	SET @v_log_message = 'TEST';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '21-1', @d_event_date;
	/*****************************************/


      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	------------------------------------------------------------------------  
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	


	/*****************************************/
	SET @v_log_type = 'START';
	SET @v_log_message = 'TEST';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '21-2', @d_event_date;
	/*****************************************/

	------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------

	/*****************************************/
	SET @v_log_type = 'START';
	SET @v_log_message = 'TEST';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '22-1', @d_event_date;
	/*****************************************/
	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------
	/*****************************************/
	SET @v_log_type = 'START';
	SET @v_log_message = 'TEST';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, '22-2', @d_event_date;
	/*****************************************/
	

  END;
