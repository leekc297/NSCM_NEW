

/*
 * Program ID   : PR_SCM_LGTM_INV_ALLOCATION_GODS_CAL
 * Description  : 장기재고 관련 상품 PSI EOH 정보 형성
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 *                              최초 생성
 * 2025.11.11   park.choyi		[E20250310-000014] 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기')
 * 2026/02/26   YMH				[E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경.
 ----------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_SCM_LGTM_INV_ALLOCATION_GODS_CAL]
     @p_plan_tp_cd              NVARCHAR(20)
    ,@p_division_id             NVARCHAR(30)
    ,@p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_basis_yyyymm            NVARCHAR(6)
	,@p_mrp_version_id          NVARCHAR(30)
AS

BEGIN

-- exec PR_SCM_LGTM_INV_ALLOCATION_GODS_CAL_OIJ 'GODS', '40', '20250303', '202503', 'MRP-SCP-20250304-001'



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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION_GODS_CAL';
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
	DECLARE @v_mrp_version_id	    NVARCHAR(30)     = @p_mrp_version_id    
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
            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd    -- Parameter 처리 필요.
            AND     DATA_TP_CD         IN ('EOH')
            AND     DIVISION_ID         = @v_division_id
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  
        
        ------------------------------------------------------------------------
		-- Step 1-1. Delete BOH after start month. [SCM_LGTM_INV_PSI_SUMMARY_GODS]
		------------------------------------------------------------------------   
        BEGIN
            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd    -- Parameter 처리 필요.
            AND     PLAN_YYYYMM         > @v_basis_yyyymm
            AND     DATA_TP_CD         IN ('BOH')
            AND     DIVISION_ID         = @v_division_id
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  

		------------------------------------------------------------------------  
        BEGIN
		------------------------------------------------------------------------
		-- Step 1-2. Delete [SCM_LGTM_INV_PSI_DETAIL_GODS]
		------------------------------------------------------------------------   
            DELETE 
            FROM    SCM_LGTM_INV_PSI_DETAIL_GODS
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd    -- Parameter 처리 필요.
            AND     DIVISION_ID         = @v_division_id
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
        DECLARE     @v_reason_cd        NVARCHAR(20);
        DECLARE     @v_s_group_code1    NVARCHAR(30);
        DECLARE     @v_s_org_item_id    NVARCHAR(30);
        DECLARE     @v_s_version_no     NVARCHAR(30);
        DECLARE     @v_s_process_group  NVARCHAR(50);
        DECLARE     @v_s_process_detail NVARCHAR(50);

        --Prod
        DECLARE     @v_prod_data_tp_cd  NVARCHAR(20);
        DECLARE     @v_srce_tp_cd       NVARCHAR(20);
        DECLARE     @v_group_code1      NVARCHAR(30);
        DECLARE     @v_org_item_id      NVARCHAR(30);
        DECLARE     @v_srce_yyyymm      NVARCHAR(6);
        DECLARE     @v_prod_qty         NUMERIC(30, 6);

        IF OBJECT_ID (N'tempdb..#TEMP_END_INV_COST', N'U') IS NOT NULL 		DROP TABLE #TEMP_END_INV_COST;
        
        -- [E20250310-000014] #LONG_TERM_TYPE 임시테이블 삭제
        IF OBJECT_ID('tempdb..#TMP_LONG_TERM_TYPE') IS NOT NULL
            DROP TABLE #TMP_LONG_TERM_TYPE;

        -- [E20250310-000014] #LONG_TERM_TYPE 임시테이블 데이터 생성
        SELECT LMD.SEGMENT1 AS LONG_TERM_TYPE_CODE
             , LMD.SEGMENT2 AS LONG_TERM_TYPE
             , LMD.SEGMENT3 AS GRM_MM_FROM
             , LMD.SEGMENT4 AS GRM_MM_TO
        INTO   #TMP_LONG_TERM_TYPE
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LMD WITH(NOLOCK)
        JOIN   SCM_ADM_LOOKUP_MASTER ALM WITH(NOLOCK)
        ON     ALM.LOOKUP_TYPE = LMD.LOOKUP_TYPE
        AND    ALM.LOOKUP_TYPE = 'SCM_LGTM_TYPE'
        WHERE  ALM.VALID_YN = 'Y'
        AND    LMD.VALID_YN = 'Y';

        SET @v_Counter = 1;
        
        WHILE (@v_Counter <= 13)

            BEGIN

            ----PRINT @v_Counter;
            SET @v_plan_yyyymm = LEFT(CONVERT(NVARCHAR(6), dateadd(month, @v_Counter - 1, convert(date, @v_plan_yyyymmdd, 112)), 112), 6);
            --PRINT @v_plan_yyyymm;

            --1. EOH 생성. BOH, P 그대로 EOH에 반영.
            
            INSERT INTO SCM_LGTM_INV_PSI_DETAIL_GODS
            ( PLAN_TP_CD
            , PLAN_START_YYYYMMDD
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
            , SCM_SITE_ID
            , OPERATION_GROUP
            , OPERATION_ID
            , DEVALUATION_AGE
            , LONG_TERM_TYPE_CODE
            , LONG_TERM_TYPE
            , VERSION_NO
            , PROCESS_GROUP
            , PROCESS_DETAIL
			, COMPANY_ID
			, PLANT_ID
            )
            SELECT    PLAN_TP_CD
                    , PLAN_START_YYYYMMDD
                    , 'EOH'
                    , SRCE_TP_CD
                    , DIVISION_ID
                    , GROUP_CODE1
                    , ITEM_ID
                    , ORIGIN_ITEM_ID
                    , SRCE_YYYYMM
                    , PLAN_YYYYMM
                    , QTY
                    , NULL
                    , 'X'                   AS REASON_CD
                    , QTY                   AS REMAIN_QTY
                    , SCM_SITE_ID
                    , OPERATION_GROUP
                    , OPERATION_ID
                    , DEVALUATION_AGE
                    , LONG_TERM_TYPE_CODE
                    , LONG_TERM_TYPE
                    , VERSION_NO
                    , PROCESS_GROUP
                    , PROCESS_DETAIL
					,'*'					AS COMPANY_ID
					,'*'					AS PLANT_ID
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS S WITH(NOLOCK)
            WHERE   1=1
            AND     S.PLAN_TP_CD          = @v_plan_tp_cd
            AND     S.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     S.DIVISION_ID         = @v_division_id
            AND     S.PLAN_YYYYMM         = @v_plan_yyyymm
            AND     S.DATA_TP_CD         IN ('BOH', 'P')
            AND     S.QTY                 > 0   -- 음수 BOH는 S 잔량에서 반영되기 때문에 EOH 반영 불필요.
            --and     S.ITEM_ID             = 'AMFMCC727-B1'
            ;




            --2. Sales Count Check. 존재여부 확인.
            -- select  @v_cnt = count(*)
            -- FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS S WITH(NOLOCK)
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
                                            , S.GROUP_CODE1     AS GROUP_CODE1
                                            , S.ITEM_ID         AS ITEM_ID
                                            , S.ORIGIN_ITEM_ID  AS ORIGIN_ITEM_ID
                                            , SUM(CASE WHEN S.QTY < 0 then S.QTY*(-1) ELSE S.QTY END)            AS SALE_QTY
                                            , MAX(S.VERSION_NO)     AS VERSION_NO
                                            , MAX(S.PROCESS_GROUP)  AS PROCESS_GROUP
                                            , MAX(S.PROCESS_DETAIL) AS PROCESS_DETAIL
                                    FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS S WITH(NOLOCK)
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
                                            , S.GROUP_CODE1
                                            , S.ITEM_ID
                                            , S.ORIGIN_ITEM_ID
                                    ORDER BY SRCE_TP_CD DESC

            OPEN CURRENT_MONTH_SALES_CUR
                -- key 정보는 상위 cursor에서 정의된 값을 같이 쓰면됨.
                FETCH NEXT FROM CURRENT_MONTH_SALES_CUR INTO @v_division_id
                                                            , @v_reason_cd
                                                            , @v_s_group_code1
                                                            , @v_item_id
                                                            , @v_s_org_item_id
                                                            , @v_sale_qty
                                                            , @v_s_version_no
                                                            , @v_s_process_group
                                                            , @v_s_process_detail

                WHILE @@FETCH_STATUS = 0
                BEGIN

                --PRINT 'Fetch Test: '+@v_item_id+' '+CAST(@v_sale_qty as NVARCHAR(100));

                    IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CURRENT_MONTH_PROD_CUR')
                    BEGIN
                        CLOSE CURRENT_MONTH_PROD_CUR
                        DEALLOCATE CURRENT_MONTH_PROD_CUR
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
                                                        , S.GROUP_CODE1     AS GROUP_CODE1
                                                        , S.ORIGIN_ITEM_ID  AS ORIGIN_ITEM_ID
                                                        , S.SRCE_YYYYMM     AS SRCE_YYYYMM
                                                        , S.REMAIN_QTY      AS REMAIN_QTY
                                                FROM    SCM_LGTM_INV_PSI_DETAIL_GODS S
                                                WHERE   1=1
                                                AND     S.PLAN_TP_CD            = @v_plan_tp_cd
                                                AND     S.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd
                                                AND     s.data_tp_cd            = 'EOH'
                                                and     s.srce_tp_cd           IN ('BOH_GODS', 'BOH_INTS', 'BOH_DEVL', 'P', 'P_MRP_PO')
                                                AND     s.DIVISION_ID           = @v_division_id
                                                AND     S.ITEM_ID		        = @v_item_id
                                                AND     s.PLAN_YYYYMM           = @v_plan_yyyymm
                                                AND     S.REMAIN_QTY            > 0
                                                ORDER BY SRCE_YYYYMM, SRCE_TP_CD
                            FOR UPDATE

                    OPEN CURRENT_MONTH_PROD_CUR
                        FETCH NEXT FROM CURRENT_MONTH_PROD_CUR INTO @v_prod_data_tp_cd
                                                                    , @v_srce_tp_cd
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
                                    
                                    -- RMTL Update.
                                    UPDATE  SCM_LGTM_INV_PSI_DETAIL_GODS
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
                                    
                                    SET @v_sale_Qty = @v_sale_Qty - @v_prod_Qty;

                                    --PRINT   'Remain Sale Qty: '+CAST(@v_sale_qty as NVARCHAR(10));
                                    
                                    --SET @v_qty = 0
                                END
                            ELSE IF ( @v_sale_qty > 0) AND (@v_prod_qty >  @v_sale_qty )-- Demand ID가 전체 다 Full Pegging 되는 case
                                BEGIN
                                    --PRINT 'Fetch 2: Prod qty '+CAST(@v_prod_qty as NVARCHAR(10))+' > Sale Qty is: '+CAST(@v_sale_qty as NVARCHAR(10));
                                    -- RMTL Update.
                                    UPDATE  SCM_LGTM_INV_PSI_DETAIL_GODS
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
                                    
                                    SET @v_sale_Qty = 0;

                                    --PRINT   '222Remain Sale Qty: '+CAST(@v_sale_qty as NVARCHAR(10));
                                    
                                END
                            

                        FETCH NEXT FROM CURRENT_MONTH_PROD_CUR INTO @v_prod_data_tp_cd
                                                                    , @v_srce_tp_cd
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

                        INSERT INTO SCM_LGTM_INV_PSI_DETAIL_GODS
                            ( PLAN_TP_CD 
                            , PLAN_START_YYYYMMDD
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
                            , VERSION_NO         
                            , PROCESS_GROUP
                            , PROCESS_DETAIL
							, COMPANY_ID
							, PLANT_ID
                            )
                        SELECT @v_plan_tp_cd
                            , @v_plan_start_yyyymmdd
                            , 'EOH'
                            , @v_reason_cd
                            , @v_division_id
                            , @v_s_group_code1
                            , @v_item_id
                            , @v_s_org_item_id
                            , @v_plan_yyyymm
                            , @v_plan_yyyymm
                            , 0
                            , @v_sale_qty
                            , @v_reason_cd
                            , @v_sale_qty*(-1)
                            , @v_s_version_no
                            , @v_s_process_group
                            , @v_s_process_detail
							, '*'    
							, '*'  

                    END;

                FETCH NEXT FROM CURRENT_MONTH_SALES_CUR INTO @v_division_id
                                                            , @v_reason_cd
                                                            , @v_s_group_code1
                                                            , @v_item_id
                                                            , @v_s_org_item_id
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
                WITH SEQ AS 
                    (
                        SELECT  1 LV 
                        UNION ALL
                        SELECT  LV+1 LV FROM SEQ WHERE LV+1 < 3
                    )
                INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_GODS
                        (PLAN_TP_CD
                        ,PLAN_START_YYYYMMDD
                        ,DATA_TP_CD
                        ,SRCE_TP_CD
                        ,DIVISION_ID
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
						,COMPANY_ID
						,PLANT_ID
                        )
                SELECT   PLAN_TP_CD
                        ,PLAN_START_YYYYMMDD
                        ,CASE WHEN SEQ.LV = 1 THEN EOH.DATA_TP_CD ELSE 'BOH' END AS DATA_TP_CD
                        ,SRCE_TP_CD
                        ,DIVISION_ID
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
						,'*'						AS COMPANY_ID
						,'*'						AS PLANT_ID
                FROM    SCM_LGTM_INV_PSI_DETAIL_GODS EOH WITH(NOLOCK)
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
            END;



            SET @v_Counter = @v_Counter + 1;

            END;

        ------------------------------------------------------------------------
		-- Step 3. 재고 월령 업데이트 [SCM_LGTM_INV_PSI_DETAIL_GODS]
		------------------------------------------------------------------------   
        BEGIN
            -- [E20250310-000014] #TMP_LONG_TERM_TYPE 룩업 사용하여 LONG_TERM_TYPE 업데이트. 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기') Start            
            UPDATE A
            SET    LONG_TERM_TYPE       = B.LONG_TERM_TYPE
                 , LONG_TERM_TYPE_CODE  = B.LONG_TERM_TYPE_CODE
                 , DEVALUATION_AGE      = CONCAT('GRM',RIGHT(REPLICATE('0', 2)+CAST(DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) AS VARCHAR), 2) )
            FROM   SCM_LGTM_INV_PSI_SUMMARY_GODS A
            LEFT JOIN #TMP_LONG_TERM_TYPE   B
                 ON  DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) >= B.GRM_MM_FROM 
                 AND DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) <= B.GRM_MM_TO
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = @v_division_id

            --UPDATE  SCM_LGTM_INV_PSI_SUMMARY_GODS
            --SET     LONG_TERM_TYPE          = CASE  WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 3 THEN N'비대상'
            --                                        WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 6 THEN N'부실 징후'
            --                                        WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) >= 6 THEN N'부실'
            --                                        ELSE NULL END
            --        , LONG_TERM_TYPE_CODE   = CASE  WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 3 THEN N'CODE_2'
            --                                        WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 6 THEN N'CODE_5'
            --                                        WHEN DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) >= 6 THEN N'CODE_6'
            --                                        ELSE NULL END  
            --        , DEVALUATION_AGE       = CONCAT('GRM',RIGHT(REPLICATE('0', 2)+CAST(DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) AS VARCHAR), 2) )
            --WHERE   1=1 
            --AND     PLAN_TP_CD          = @v_plan_tp_cd
            --AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            --AND     DIVISION_ID         = @v_division_id
            -- [E20250310-000014] #TMP_LONG_TERM_TYPE 룩업 사용하여 LONG_TERM_TYPE 업데이트. 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기') End
        END


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
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_GODS
            SET     GROUP_CODE1     = ISNULL((  SELECT  M.GROUP_CODE1 
                                                FROM    ITEM_M  M WITH(NOLOCK) 
                                                WHERE   M.DIVISION_ID = SCM_LGTM_INV_PSI_SUMMARY_GODS.DIVISION_ID
                                                AND     M.ITEM_ID     = SCM_LGTM_INV_PSI_SUMMARY_GODS.ORIGIN_ITEM_ID
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
		-- Step 4-2 마감재고 기반 단가정보 추출. 0값 포함 필요(실적구간 0인 경우 0으로 반영)
        ------------------------------------------------------------------------
        BEGIN 
            SELECT MM.DIVISION_ID, MM.ITEM_ID, MM.YYYYMM, MM.COST
            INTO   #TEMP_END_INV_COST
            FROM (
                    SELECT INV.DIVISION_ID, INV.ITEM_ID, INV.YYYYMM
                            , IIF(SUM(INV.QUANTITY)=0, 0, SUM(INV.AMOUNT_KRW)/SUM(INV.QUANTITY)) AS COST
                    FROM   SCP_ANL_MONTH_END_STOCK_R INV WITH(NOLOCK)
                    LEFT OUTER JOIN (    SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY ITEM_ID
                                ) C
                        ON  C.ITEM_ID = INV.ITEM_ID
                    LEFT OUTER JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    WHERE   1=1
                    --and     INV.DIVISION_ID      LIKE CONCAT(SUBSTRING(@v_division_id, 1, 2), '%')
                    AND     INV.YYYYMM              > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -13, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND     INV.YYYYMM             <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND     (CASE WHEN INV.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                  WHEN INV.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                  WHEN D.PROCESS_DETAIL = 'Metal' THEN N'상품'
                                   WHEN ISNULL(C.ITEM_ID, '') = '' THEN N'상품'
                                  ELSE D.ITEM_TYPE        
                                  END           = N'상품'
                        OR  C.ITEM_CLASS        = N'EM0306')
                    --and    ISNULL(INV.QUANTITY, 0) != 0
                    GROUP BY INV.DIVISION_ID, INV.ITEM_ID, INV.YYYYMM
                    HAVING SUM(INV.QUANTITY) != 0
                    ) MM
            --WHERE ISNULL(COST, 0) != 0
        END
        



        ------------------------------------------------------------------------
		-- Step 4-3.1 가중평균 단가 업데이트. ORIGIN_ITEM_ID 기준으로 전월 마감재고의 단가 참조.
        -- 실적구간인 경우, Cost가 0일 때 0값 그대로 반영하고 계획구간은 추가로 단가 탐색 처리.
		------------------------------------------------------------------------
        BEGIN
            UPDATE  RM
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT IIF((RM.DATA_TP_CD = 'RESULT' OR RM.SRCE_TP_CD LIKE 'BOH%'), B.COST, IIF(B.COST = 0, NULL, B.COST))--COST --SUM(AMOUNT_KRW)/SUM(QUANTITY)
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  B.YYYYMM             = CASE WHEN RM.DATA_TP_CD = 'RESULT' THEN RM.PLAN_YYYYMM
                                                                           ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                                                            END
                                        AND    B.DIVISION_ID        = RM.DIVISION_ID
                                        and    B.ITEM_ID            = RM.ITEM_ID
                                        --AND    B.STORAGE_LOCATION  != N'미착' 
                                        )
                                        /* ( SELECT SUM(AMOUNT_KRW)/SUM(QUANTITY)
                                        FROM   SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                                        WHERE  B.YYYYMM             = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                        AND    B.DIVISION_ID        = SCM_LGTM_INV_PSI_SUMMARY_GODS.DIVISION_ID
                                        and    B.ITEM_ID            = SCM_LGTM_INV_PSI_SUMMARY_GODS.ORIGIN_ITEM_ID
                                        --AND    B.STORAGE_LOCATION  != N'미착' 
                                        ) */
                    ,CST_CTN        = N'1st 마감재고 가중평균 단가_ORG_ITEM'
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS RM
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
        END

		--2025-02-14 OIJ
		PRINT N'START DIVISION_ID를 제외하고 ITEM 기준: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
		------------------------------------------------------------------------
		-- Step 4-3.1.1 가중평균 단가 업데이트. DIVISION_ID를 제외하고 ITEM 기준으로 전월 마감재고의 단가 참조.
		------------------------------------------------------------------------
        BEGIN
             UPDATE  RM
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT IIF((RM.DATA_TP_CD = 'RESULT' OR RM.SRCE_TP_CD LIKE 'BOH%'), B.COST, IIF(B.COST = 0, NULL, B.COST))--COST --SUM(AMOUNT_KRW)/SUM(QUANTITY)
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  B.YYYYMM             = CASE WHEN RM.DATA_TP_CD = 'RESULT' THEN RM.PLAN_YYYYMM
                                                                           ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                                                            END
                                        --AND    B.DIVISION_ID        = RM.DIVISION_ID
                                        and    B.ITEM_ID            = RM.ITEM_ID
                                        --AND    B.STORAGE_LOCATION  != N'미착' 
                                        )
                    ,CST_CTN        = N'1st 마감재고 가중평균 단가_ORG_ITEM'
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS RM
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND     STANDARD_COST      IS NULL
        END



        PRINT N'START 가중평균 단가 ORIGIN ITEM 기준 과거구간 탐색: '  + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
        ------------------------------------------------------------------------
		-- Step 4-3.2 가중평균 단가 업데이트. ORIGIN_ITEM_ID 기준으로 최근 마감재고의 단가 참조.
		------------------------------------------------------------------------
        BEGIN
            UPDATE  S
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT TOP 1 IIF((S.DATA_TP_CD = 'RESULT' OR S.SRCE_TP_CD LIKE 'BOH%'), B.COST, IIF(B.COST = 0, NULL, B.COST))
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND    B.YYYYMM             = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM ELSE B.YYYYMM END
                                        AND    B.DIVISION_ID        = S.DIVISION_ID
                                        AND    B.ITEM_ID            = S.ITEM_ID
                                        AND    B.COST               > 0
                                        ORDER BY B.YYYYMM DESC
                                        )
                    ,CST_CTN        = ( SELECT TOP 1 N'1st-3 과거 마감재고 가중평균 단가_by_ITEM(Mapping) : '+B.YYYYMM
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND    B.YYYYMM             = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM ELSE B.YYYYMM END
                                        AND    B.DIVISION_ID        = S.DIVISION_ID
                                        AND    B.ITEM_ID            = S.ITEM_ID
                                        AND    B.COST               > 0
                                        ORDER BY B.YYYYMM DESC
                                        )
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS S
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     STANDARD_COST      IS NULL
        END

        ------------------------------------------------------------------------
		-- Step 4-3.2 가중평균 단가 업데이트. ITEM_ID 기준으로 한번 더.
		------------------------------------------------------------------------
        /* BEGIN
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_GODS
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT SUM(AMOUNT_KRW)/SUM(QUANTITY)
                                        FROM   SCP_ANL_MONTH_END_STOCK_R B with(nolock)
                                        WHERE  B.YYYYMM             = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                        AND    B.DIVISION_ID        = SCM_LGTM_INV_PSI_SUMMARY_GODS.DIVISION_ID
                                        and    B.ITEM_ID            = SCM_LGTM_INV_PSI_SUMMARY_GODS.ITEM_ID
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
		------------------------------------------------------------------------
        BEGIN
            WITH COST AS (SELECT  SUM.DIVISION_ID, SUM.ITEM_ID, SUM.ORIGIN_ITEM_ID
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
                                    AND     R.ATTRBT_4_VAL  = 'S'
                                    -- E20260211-001073 [E20260211-001073] MRP 수신정보 버전체계 변경관련 주석처리.
                                    -- AND     R.BUCKET_TYP    = 'BUCKET_TYP_006'
                                    AND     R.BASE_UOM     <> 'CELL'
                                    -- E20260211-001073 [E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경관련 기존로직 주석처리.
                                    --AND   R.VRSN_ID			= @v_mrp_version_id
                                    -- E20260211-001073 [E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경
                                    -- _001(오전) _002(오후) 모두 같이 처리한다.
                                    AND   R.VRSN_ID			LIKE @v_mrp_version_id + '%'

														--IN (    ---SELECT  MAX(VRSN_ID)
              --                                              ---FROM    XIF_MRP_TB_RS_ITEM_CONSUM_R_SN R with(nolock)
              --                                              ---WHERE   IF_RCV_DATE >= DATEADD(DAY, -30, CONVERT(DATE, @v_plan_start_yyyymmdd, 112)) 
              --                                              ---AND     IF_RCV_DATE < DATEADD(DAY, @v_add_days, CONVERT(DATE, @v_plan_start_yyyymmdd, 112))
              --                                              'MRP-SCP-20250101-001'
              --                                              )
                                    AND  R.ITEM_CD       =  SUM.ITEM_ID
                                    AND  SMS.DIVISION_ID =  SUM.DIVISION_ID
                                    /* AND   R.PLAN_TYP        = 'SCP'
                                    AND   R.BUCKET_TYP      = 'BUCKET_TYP_006'
                                    AND   R.ATTRBT_4_VAL    = 'P'
                                    AND   R.PLAN_SRC_TYP    <> '*' */
                                    ORDER BY 1 ASC
                                ) AS KRW_STANDARD_COST
                        FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS SUM WITH(NOLOCK)
                        WHERE   1=1 
                        AND     SUM.PLAN_TP_CD                  = @v_plan_tp_cd
                        AND     SUM.PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
                        AND     SUM.STANDARD_COST              IS NULL
                        GROUP BY SUM.DIVISION_ID, SUM.ITEM_ID, SUM.ORIGIN_ITEM_ID
                        )
            UPDATE  GODS
            SET      CURRENCY       = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST.KRW_STANDARD_COST
                                        FROM   COST
                                        WHERE  COST.DIVISION_ID     = GODS.DIVISION_ID
                                        AND    COST.ITEM_ID         = GODS.ITEM_ID
                                        AND    COST.ORIGIN_ITEM_ID  = GODS.ORIGIN_ITEM_ID
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||3rd MRP 단가')
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS GODS
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     STANDARD_COST              IS NULL
            AND     DATA_TP_CD                 != 'RESULT'
        END



        ------------------------------------------------------------------------
		-- Step 4-3.4 Item Master의 Standard Cost 사용. 동일 Company 기준.
		------------------------------------------------------------------------
        BEGIN
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
                                FROM   SCM_LGTM_INV_PSI_SUMMARY_GODS SUM WITH(NOLOCK)
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
            UPDATE  GODS
            SET      CURRENCY       = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST.KRW_STANDARD_COST
                                        FROM   COST
                                        WHERE  COST.DIVISION_ID     = GODS.DIVISION_ID
                                        AND    COST.ITEM_ID         = GODS.ITEM_ID
                                        AND    COST.ORIGIN_ITEM_ID  = GODS.ORIGIN_ITEM_ID
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||4th 표준단가')
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS GODS
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     STANDARD_COST              IS NULL
            AND     DATA_TP_CD                 != 'RESULT'
        END

        ------------------------------------------------------------------------------------------
		-- Step 4-3.5 Item Master의 Standard Cost 사용. Company 조건 제외하고 KRW 반영 기준 최저단가.
		------------------------------------------------------------------------------------------
        BEGIN
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
                            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS SUM WITH(NOLOCK)
                            WHERE   1=1 
                            AND     SUM.PLAN_TP_CD                  = @v_plan_tp_cd
                            AND     SUM.PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
                            AND     SUM.STANDARD_COST              IS NULL
                            GROUP BY SUM.DIVISION_ID, SUM.ITEM_ID, SUM.ORIGIN_ITEM_ID
                            )
            UPDATE  GODS
            SET      CURRENCY       = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST.KRW_STANDARD_COST
                                        FROM   COST
                                        WHERE  COST.DIVISION_ID     = GODS.DIVISION_ID
                                        AND    COST.ITEM_ID         = GODS.ITEM_ID
                                        AND    COST.ORIGIN_ITEM_ID  = GODS.ORIGIN_ITEM_ID
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||5th MIN_표준단가')
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS GODS
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     STANDARD_COST              IS NULL
            --AND     DATA_TP_CD                 != 'RESULT'
        END
        
        ------------------------------------------------------------------------------------------
		-- Step 4-3.6 최저판가 기준으로 한번 더 업데이트.
		------------------------------------------------------------------------------------------
        BEGIN
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
                                    FROM   SCM_LGTM_INV_PSI_SUMMARY_GODS SUM WITH(NOLOCK)
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
            UPDATE  GODS
            SET     CURRENCY       = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST.KRW_SALES_COST
                                        FROM   COST
                                        WHERE  COST.DIVISION_ID     = GODS.DIVISION_ID
                                        AND    COST.ITEM_ID         = GODS.ITEM_ID
                                        AND    COST.ORIGIN_ITEM_ID  = GODS.ORIGIN_ITEM_ID
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||6th MIN_판가')
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS GODS
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     STANDARD_COST              IS NULL
            AND     DATA_TP_CD                 != 'RESULT'
        END

        ------------------------------------------------------------------------
		-- Step 4-4 Amount 업데이트. 4-3에서 적용한 단가 기준.
		------------------------------------------------------------------------
        BEGIN
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_GODS
            SET     AMT     = STANDARD_COST * QTY
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
        END

        ------------------------------------------------------------------------
		-- Step 4-5 음수 0 처리.
		------------------------------------------------------------------------
        BEGIN
            UPDATE  SUM
            SET       SUM.QTY               = 0
                    , SUM.AMT               = 0
                    , SUM.LAST_UPDATE_DATE  = GETDATE()
                    , SUM.LAST_UPDATED_BY   = 'Minus_to_Zero'
            FROM    SCM_LGTM_INV_PSI_SUMMARY_GODS SUM
            WHERE   1=1
            AND     SUM.PLAN_TP_CD          = @v_plan_tp_cd
            AND     SUM.DIVISION_ID         = @v_division_id
            AND     SUM.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     SUM.DATA_TP_CD         IN ('BOH','EOH')
            AND     SUM.QTY                 < 0
        END

        IF OBJECT_ID (N'tempdb..#TEMP_END_INV_COST', N'U') IS NOT NULL 		DROP TABLE #TEMP_END_INV_COST;
        
        -- [E20250310-000014] #LONG_TERM_TYPE 임시테이블 삭제
        IF OBJECT_ID('tempdb..#TMP_LONG_TERM_TYPE') IS NOT NULL
            DROP TABLE #TMP_LONG_TERM_TYPE;

--jjg        COMMIT TRANSACTION;
    END TRY
    
    ------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
--jjg	ROLLBACK TRANSACTION PSI_ALLOCATION;
	------------------------------------------------------------------------
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	------------------------------------------------------------------------  
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
	------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------

	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------


  END;
