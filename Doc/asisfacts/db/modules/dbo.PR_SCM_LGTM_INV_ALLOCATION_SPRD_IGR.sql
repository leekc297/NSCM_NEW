
/*
 * Program ID   : PR_SCM_LGTM_INV_ALLOCATION_SPRD_IGR
 * Description  : 장기재고 관련 반제품 PSI Group EOH 정보 형성
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 *                              최초 생성
 * 2025.11.11   park.choyi		[E20250310-000014] 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기')
 ----------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_SCM_LGTM_INV_ALLOCATION_SPRD_IGR]
     @p_plan_tp_cd              NVARCHAR(20)
    ,@p_srce_plan_tp_cd         NVARCHAR(20)
    ,@p_division_id             NVARCHAR(30)
    ,@p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_basis_yyyymm            NVARCHAR(6)
AS 
BEGIN

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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION_S_IGR';
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
	-- Set Prameter
	------------------------------------------------------------------------
    
    DECLARE @v_plan_tp_cd           NVARCHAR(20)    = @p_plan_tp_cd;            -- 'SPRD_GC';
    DECLARE @v_srce_plan_tp_cd      NVARCHAR(20)    = @p_srce_plan_tp_cd;       -- 'SPRD';
    DECLARE @v_division_id          NVARCHAR(20)    = @p_division_id            -- '81';
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8)     = @p_plan_start_yyyymmdd    -- '20240701';
    DECLARE @v_basis_yyyymm         NVARCHAR(6)     = @p_basis_yyyymm           -- '202407';
    ------------------------------------------------------------------------  
		
	------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
--jjg	BEGIN TRANSACTION PR_SCM_LGTM_INV_ALLOCATION_S_IGR;
	------------------------------------------------------------------------  

	------------------------------------------------------------------------  
	BEGIN TRY
        ------------------------------------------------------------------------
		-- Step 1. Initialize SUMMARY
		------------------------------------------------------------------------
        BEGIN
		------------------------------------------------------------------------
		-- Step 1-1. Delete [SCM_LGTM_INV_PSI_SUMMARY]
		------------------------------------------------------------------------   
            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = @v_division_id          
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  
        PRINT 'Step 1-1 End';
        ------------------------------------------------------------------------  

		------------------------------------------------------------------------
		-- Step 1-2. Create From Item SUMMARY
		------------------------------------------------------------------------
        BEGIN
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR
            (PLAN_TP_CD
            ,PLAN_START_YYYYMMDD
            ,DATA_TP_CD
            ,SRCE_TP_CD
            ,DIVISION_ID
            ,GROUP_CODE1
            ,ITEM_CLASS
            ,SRCE_YYYYMM
            ,PLAN_YYYYMM
            ,QTY
            ,CURRENCY
            ,STANDARD_COST
            ,AMT
            ,DEVALUATION_AGE
            ,LONG_TERM_TYPE_CODE
            ,LONG_TERM_TYPE
            ,CLASS_NAME
			, COMPANY_ID   -- jjg추가 2025.03.22
			, PLANT_ID   -- jjg추가 2025.03.22
            )
            SELECT   @v_plan_tp_cd AS PLAN_TP_CD
                    ,SUM.PLAN_START_YYYYMMDD
                    ,SUM.DATA_TP_CD
                    ,SUM.SRCE_TP_CD
                    ,SUM.DIVISION_ID
                    ,SUM.GROUP_CODE1
                    ,CASE WHEN ISNULL(L.ATTRIBUTE2,'') <> '' THEN L.ATTRIBUTE2 ELSE '*' END AS ITEM_CLASS
                    ,SUM.SRCE_YYYYMM
                    ,SUM.PLAN_YYYYMM
                    ,SUM(QTY) AS QTY
                    ,'' AS CURRENCY
                    ,0  AS STANDARD_COST
                    ,0  AS AMT
                    ,SUM.DEVALUATION_AGE 
                    ,SUM.LONG_TERM_TYPE_CODE
                    ,SUM.LONG_TERM_TYPE
                    ,CASE WHEN ISNULL(L.ATTRIBUTE2,'') <> '' THEN L.ATTRIBUTE2 ELSE '*' END
					,sum.COMPANY_ID				AS COMPANY_ID   -- jjg추가 2025.03.22
					, '*'						AS PLANT_ID   -- jjg추가 2025.03.22

            FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD SUM WITH(NOLOCK)
                    LEFT OUTER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
                        ON  SMS.DIVISION_ID = SUM.DIVISION_ID
                        AND SMS.SCM_SITE_ID = SUM.SCM_SITE_ID
                    LEFT OUTER JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, ITEM_CLASS
                                    FROM   SCM_ITEM_M_SN WITH(NOLOCK) ) SIM 
                        ON  SIM.DIVISION_ID = SUM.DIVISION_ID
                        AND SIM.ITEM_ID     = SUM.ITEM_ID
                    LEFT OUTER JOIN SCM_MST_ITEM_CLASS_M CLS WITH(NOLOCK)
                        ON SIM.ITEM_CLASS = CLS.CLASS_ID
                    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L with(nolock)
                        ON      L.LOOKUP_TYPE   = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
                        AND     L.VALID_YN      = 'Y'
                        AND     L.SEGMENT1      = SIM.ITEM_CLASS
            WHERE  1=1
            AND    SUM.PLAN_TP_CD           = @p_srce_plan_tp_cd
            AND    SUM.PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd
            AND    (    ( SUM.DATA_TP_CD = 'BOH' AND SUM.PLAN_YYYYMM = @p_basis_yyyymm )
                    OR  ( SUM.DATA_TP_CD NOT IN ( 'BOH','EOH' ) )
                    )
            AND    SUM.DIVISION_ID          = @v_division_id
            GROUP BY SUM.PLAN_TP_CD
                    ,SUM.PLAN_START_YYYYMMDD
                    ,SUM.DATA_TP_CD
                    ,SUM.SRCE_TP_CD
                    ,SUM.DIVISION_ID
                    ,SUM.GROUP_CODE1
                    ,CASE WHEN ISNULL(L.ATTRIBUTE2,'') <> '' THEN L.ATTRIBUTE2 ELSE '*' END
                    ,SUM.SRCE_YYYYMM
                    ,SUM.PLAN_YYYYMM
                    ,SUM.DEVALUATION_AGE 
                    ,SUM.LONG_TERM_TYPE_CODE
                    ,SUM.LONG_TERM_TYPE
                    ,CASE WHEN ISNULL(L.ATTRIBUTE2,'') <> '' THEN L.ATTRIBUTE2 ELSE '*' END
					,SUM.COMPANY_ID   -- jjg추가 2025.03.22
        ;           
		------------------------------------------------------------------------  
		END
		------------------------------------------------------------------------  
        PRINT 'Step 1-2 End';
        ------------------------------------------------------------------------  

        ------------------------------------------------------------------------
		-- Step 2. Initialize DETAIL
		------------------------------------------------------------------------
        -- Step 2-1. Delete All EOH.
		------------------------------------------------------------------------   
        BEGIN
            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DATA_TP_CD         IN ('EOH')
            AND     DIVISION_ID         = @v_division_id
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  
        
        ------------------------------------------------------------------------
		-- Step 2-1. Delete BOH after start month
		------------------------------------------------------------------------   
        BEGIN
            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     PLAN_YYYYMM         > @v_basis_yyyymm
            AND     DATA_TP_CD         IN ('BOH')
            AND     DIVISION_ID         = @v_division_id
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  

		------------------------------------------------------------------------  
        BEGIN
		------------------------------------------------------------------------
		-- Step 2-2. Delete DETAIL
		------------------------------------------------------------------------   
            DELETE 
            FROM    SCM_LGTM_INV_PSI_DETAIL_SPRD_IGR
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = @v_division_id
		------------------------------------------------------------------------  
		END
        ------------------------------------------------------------------------ 
        PRINT 'Step 2 End';
        ------------------------------------------------------------------------  


        ------------------------------------------------------------------------
		-- Step 3-1. Declare Parameters
		------------------------------------------------------------------------
        -- Calculation
        DECLARE     @v_Counter          INT;
        DECLARE     @v_plan_yyyymmdd    NVARCHAR(8) = CONCAT(@v_basis_yyyymm, '01');
        DECLARE     @v_plan_yyyymm      NVARCHAR(6);
        DECLARE     @v_cnt              INT;
        DECLARE     @v_item_class       NVARCHAR(50);
        
        --Sales
        DECLARE     @v_sale_qty         BIGINT;
        DECLARE     @v_reason_cd        NVARCHAR(20);
        DECLARE     @v_s_group_code1    NVARCHAR(30);
        DECLARE     @v_s_org_item_id    NVARCHAR(30);
        DECLARE     @v_s_version_no     NVARCHAR(30);

        --Prod
        DECLARE     @v_prod_data_tp_cd  NVARCHAR(20);
        DECLARE     @v_srce_tp_cd       NVARCHAR(20);
        DECLARE     @v_group_code1      NVARCHAR(30);
        DECLARE     @v_org_item_id      NVARCHAR(30);
        DECLARE     @v_srce_yyyymm      NVARCHAR(6);
        DECLARE     @v_prod_qty         BIGINT;
        DECLARE     @v_sort_order       INT;
        DECLARE     @v_class_name       NVARCHAR(50);

        DECLARE     @v_company_id       NVARCHAR(10);   -- jjg추가 2025.03.22
        DECLARE     @v_plant_id         NVARCHAR(30);   -- jjg추가 2025.03.22

        
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
        

        ------------------------------------------------------------------------
        WHILE (@v_Counter <= 13)
        ------------------------------------------------------------------------
        BEGIN
        ------------------------------------------------------------------------
        SET @v_plan_yyyymm = LEFT(CONVERT(NVARCHAR(6), dateadd(month, @v_Counter - 1, convert(date, @v_plan_yyyymmdd, 112)), 112), 6);
        ------------------------------------------------------------------------
		-- Step 3-2. EOH 생성. BOH, P 그대로 EOH에 반영.
		------------------------------------------------------------------------
        INSERT INTO SCM_LGTM_INV_PSI_DETAIL_SPRD_IGR
        ( PLAN_TP_CD
        , PLAN_START_YYYYMMDD
        , DATA_TP_CD
        , SRCE_TP_CD
        , DIVISION_ID
        , GROUP_CODE1
        , ITEM_CLASS
        , SRCE_YYYYMM
        , PLAN_YYYYMM
        , QTY
        , DECREASE_QTY
        , REASON_CD
        , REMAIN_QTY
        , DEVALUATION_AGE
        , LONG_TERM_TYPE_CODE
        , LONG_TERM_TYPE    
        , CLASS_NAME
		, COMPANY_ID   -- jjg추가 2025.03.22
		, PLANT_ID)    -- jjg추가 2025.03.22
        SELECT    PLAN_TP_CD
                , PLAN_START_YYYYMMDD
                , 'EOH'
                , SRCE_TP_CD
                , DIVISION_ID
                , GROUP_CODE1
                , ITEM_CLASS
                , SRCE_YYYYMM
                , PLAN_YYYYMM
                , QTY
                , NULL
                , 'X'                   AS REASON_CD
                , QTY                   AS REMAIN_QTY
                , DEVALUATION_AGE
                , LONG_TERM_TYPE_CODE
                , LONG_TERM_TYPE
                , CLASS_NAME
				, COMPANY_ID				AS COMPANY_ID    -- jjg추가 2025.03.22
				, '*'						AS PLANT_ID    -- jjg추가 2025.03.22
        FROM    SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR S WITH(NOLOCK)
        WHERE   1=1
        AND     S.PLAN_TP_CD          = @v_plan_tp_cd
        AND     S.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
        AND     S.DIVISION_ID         = @v_division_id
        AND     S.PLAN_YYYYMM         = @v_plan_yyyymm
        AND     S.DATA_TP_CD         IN ('BOH', 'P')
        AND     S.QTY                 > 0  
        ;
        

        ------------------------------------------------------------------------
        IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CURRENT_MONTH_SALES_CUR')
        ------------------------------------------------------------------------
        BEGIN
        ------------------------------------------------------------------------
            CLOSE CURRENT_MONTH_SALES_CUR
            DEALLOCATE CURRENT_MONTH_SALES_CUR
        ------------------------------------------------------------------------    
        END;

        ------------------------------------------------------------------------
        DECLARE CURRENT_MONTH_SALES_CUR CURSOR FAST_FORWARD FOR
        ------------------------------------------------------------------------
            SELECT    S.DIVISION_ID     AS DIVISION_ID
                    , S.SRCE_TP_CD      AS REASON_CD
                    , S.GROUP_CODE1     AS GROUP_CODE1
                    , S.ITEM_CLASS      AS ITEM_CLASS
                    , SUM(CASE WHEN S.QTY < 0 then S.QTY*(-1) ELSE S.QTY END)            AS SALE_QTY
                    , S.CLASS_NAME      AS CLASS_NAME
					, S.COMPANY_ID		AS COMPANY_ID    -- jjg추가 2025.03.22
					, '*'				AS PLANT_ID    -- jjg추가 2025.03.22
            FROM    SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR S WITH(NOLOCK)
            WHERE   1=1
            AND     S.PLAN_TP_CD          = @v_plan_tp_cd
            AND     S.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     S.DIVISION_ID         = @v_division_id
            AND     S.PLAN_YYYYMM         = @v_plan_yyyymm
            AND     S.DATA_TP_CD         IN ('S','BOH')
            AND     S.SRCE_TP_CD       LIKE 'S%'
            GROUP BY  S.DIVISION_ID
                    , S.SRCE_TP_CD
                    , S.GROUP_CODE1
                    , S.ITEM_CLASS
                    , S.CLASS_NAME
					, S.COMPANY_ID
            ORDER BY SRCE_TP_CD DESC
        
        ------------------------------------------------------------------------
        OPEN CURRENT_MONTH_SALES_CUR
        ------------------------------------------------------------------------
            FETCH NEXT FROM CURRENT_MONTH_SALES_CUR INTO  @v_division_id
                                                        , @v_reason_cd
                                                        , @v_s_group_code1
                                                        , @v_item_class
                                                        , @v_sale_qty
                                                        , @v_class_name
                                                        , @v_company_id   -- jjg추가 2025.03.22
                                                        , @v_plant_id   -- jjg추가 2025.03.22
        ------------------------------------------------------------------------
            WHILE @@FETCH_STATUS = 0
        ------------------------------------------------------------------------   
            BEGIN
            ------------------------------------------------------------------------   
                IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CURRENT_MONTH_PROD_CUR')
                ------------------------------------------------------------------------   
                BEGIN
                ------------------------------------------------------------------------   
                    CLOSE CURRENT_MONTH_PROD_CUR
                    DEALLOCATE CURRENT_MONTH_PROD_CUR
                ------------------------------------------------------------------------       
                END;
                ------------------------------------------------------------------------   

                ------------------------------------------------------------------------   
                DECLARE CURRENT_MONTH_PROD_CUR CURSOR FOR
                ------------------------------------------------------------------------   
                    SELECT    S.DATA_TP_CD      AS DATA_TP_CD
                            , S.SRCE_TP_CD      AS SRCE_TP_CD
                            , S.GROUP_CODE1     AS GROUP_CODE1
                            , S.ITEM_CLASS      AS ITEM_CLASS
                            , S.SRCE_YYYYMM     AS SRCE_YYYYMM
                            , S.REMAIN_QTY      AS REMAIN_QTY
                            , CASE  WHEN s.srce_tp_cd = 'BOH_FERT' THEN 1
                                    WHEN s.srce_tp_cd = 'BOH_SPRD' THEN 2
                                    WHEN s.srce_tp_cd = 'BOH_INTS' THEN 3
                                    WHEN s.srce_tp_cd = 'BOH_DEVL' THEN 4
                                    ELSE 5 END AS SORT_ORDER
                            , S.CLASS_NAME      AS CLASS_NAME        
							, S.COMPANY_ID		AS COMPANY_ID
							, '*'				AS PLANT_ID							
                    FROM    SCM_LGTM_INV_PSI_DETAIL_SPRD_IGR S
                    WHERE   1=1
                    AND     S.PLAN_TP_CD            = @v_plan_tp_cd
                    AND     S.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd
                    AND     s.data_tp_cd            = 'EOH'
                    and     s.srce_tp_cd           IN ('BOH_FERT', 'BOH_SPRD', 'BOH_INTS', 'BOH_DEVL', 'P', 'P_SEMI_WHIN')
                    AND     s.DIVISION_ID           = @v_division_id
                    AND     s.PLAN_YYYYMM           = @v_plan_yyyymm
                    AND     s.GROUP_CODE1           = @v_s_group_code1
                    AND     s.ITEM_CLASS            = @v_item_class
                    AND     S.REMAIN_QTY            > 0
					and		s.company_id = @v_company_id  -- jjg추가 2025.03.22
					and		s.plant_id = @v_plant_id      -- jjg추가 2025.03.22
                    ORDER BY SRCE_YYYYMM, SORT_ORDER, SRCE_TP_CD
                    ------------------------------------------------------------------------   
                    FOR UPDATE

                ------------------------------------------------------------------------   
                OPEN CURRENT_MONTH_PROD_CUR
                ------------------------------------------------------------------------   
                    FETCH NEXT FROM CURRENT_MONTH_PROD_CUR INTO @v_prod_data_tp_cd
                                                                , @v_srce_tp_cd
                                                                , @v_group_code1
                                                                , @v_item_class
                                                                , @v_srce_yyyymm
                                                                , @v_prod_qty
                                                                , @v_sort_order
                                                                , @v_class_name
																, @v_company_id
																, @v_plant_id

                    ------------------------------------------------------------------------                                               
                    WHILE @@FETCH_STATUS = 0
                    ------------------------------------------------------------------------   
                    BEGIN
                    ------------------------------------------------------------------------   
                        IF ( @v_sale_qty > 0) AND (@v_prod_qty <=  @v_sale_qty )-- Demand ID가 전체 다 Full Pegging 되는 case
                        ------------------------------------------------------------------------       
                            BEGIN
                            ------------------------------------------------------------------------       
                                -- Detail Update.
                                UPDATE  SCM_LGTM_INV_PSI_DETAIL_SPRD_IGR
                                SET       DECREASE_QTY      = @V_PROD_QTY
                                        , REASON_CD         = @V_REASON_CD
                                        , REMAIN_QTY        = 0
                                        , LAST_UPDATE_DATE  = GETDATE()
                                        , LAST_UPDATED_BY   = CONCAT(@V_REASON_CD, '_enough')
                                WHERE   CURRENT OF CURRENT_MONTH_PROD_CUR
                                ;
                                ------------------------------------------------------------------------ 
                                SET @v_sale_Qty = @v_sale_Qty - @v_prod_Qty;
                                ------------------------------------------------------------------------ 
                            END
                        ------------------------------------------------------------------------ 
                        ELSE IF ( @v_sale_qty > 0) AND (@v_prod_qty >  @v_sale_qty )-- Demand ID가 전체 다 Full Pegging 되는 case
                        ------------------------------------------------------------------------ 
                            BEGIN
                            ------------------------------------------------------------------------ 
                                -- Detail Update.
                                UPDATE  SCM_LGTM_INV_PSI_DETAIL_SPRD_IGR
                                SET     DECREASE_QTY      = @v_sale_qty
                                       ,REASON_CD         = @V_REASON_CD
                                       ,REMAIN_QTY        = REMAIN_QTY - @v_sale_qty
                                       ,LAST_UPDATE_DATE  = GETDATE()
                                       ,LAST_UPDATED_BY   = CONCAT(@V_REASON_CD, '_shortage')
                                WHERE   CURRENT OF CURRENT_MONTH_PROD_CUR;
                                ------------------------------------------------------------------------ 
                                SET @v_sale_Qty = 0;
                            ------------------------------------------------------------------------ 
                            END
                            ------------------------------------------------------------------------ 
                        
                    ------------------------------------------------------------------------ 
                    FETCH NEXT FROM CURRENT_MONTH_PROD_CUR INTO @v_prod_data_tp_cd
                                                                , @v_srce_tp_cd
                                                                , @v_group_code1
                                                                , @v_item_class
                                                                , @v_srce_yyyymm
                                                                , @v_prod_qty
                                                                , @v_sort_order
                                                                , @v_class_name
																, @v_company_id
																, @v_plant_id

                    ------------------------------------------------------------------------                                             
                    END
                ------------------------------------------------------------------------ 
                CLOSE CURRENT_MONTH_PROD_CUR
                DEALLOCATE CURRENT_MONTH_PROD_CUR
                ------------------------------------------------------------------------ 

            ------------------------------------------------------------------------     
            IF (@v_sale_qty > 0)
            ------------------------------------------------------------------------ 
                BEGIN
                ------------------------------------------------------------------------ 
                    INSERT INTO SCM_LGTM_INV_PSI_DETAIL_SPRD_IGR
                        ( PLAN_TP_CD 
                        , PLAN_START_YYYYMMDD
                        , DATA_TP_CD
                        , SRCE_TP_CD
                        , DIVISION_ID
                        , GROUP_CODE1
                        , ITEM_CLASS
                        , SRCE_YYYYMM
                        , PLAN_YYYYMM
                        , QTY
                        , DECREASE_QTY
                        , REASON_CD
                        , REMAIN_QTY       
                        , CLASS_NAME
						, COMPANY_ID   -- jjg추가 2025.03.22
						, PLANT_ID   -- jjg추가 2025.03.22
                        )
                    SELECT @v_plan_tp_cd
                         , @v_plan_start_yyyymmdd
                         , 'EOH'
                         , @v_reason_cd
                         , @v_division_id
                         , @v_s_group_code1
                         , @v_item_class
                         , @v_plan_yyyymm
                         , @v_plan_yyyymm
                         , 0
                         , @v_sale_qty
                         , @v_reason_cd
                         , @v_sale_qty*(-1)
                         , @v_class_name
						 , @v_company_id   -- jjg추가 2025.03.22
						 , @v_plant_id   -- jjg추가 2025.03.22
                    ;
            ------------------------------------------------------------------------             
            END
            ------------------------------------------------------------------------ 
            
            ------------------------------------------------------------------------ 
            FETCH NEXT FROM CURRENT_MONTH_SALES_CUR INTO  @v_division_id
                                                        , @v_reason_cd
                                                        , @v_s_group_code1
                                                        , @v_item_class
                                                        , @v_sale_qty
                                                        , @v_class_name
														, @v_company_id
														, @v_plant_id

            END
            ------------------------------------------------------------------------ 
            CLOSE CURRENT_MONTH_SALES_CUR
            DEALLOCATE CURRENT_MONTH_SALES_CUR
            ------------------------------------------------------------------------ 


        ------------------------------------------------------------------------
		-- 당월 Loop 전부 처리한 뒤, 당월 EOH를 차월 BOH로 반영.
		------------------------------------------------------------------------  
        BEGIN 
        ------------------------------------------------------------------------ 
            WITH SEQ AS 
                (
                    SELECT  1 LV 
                    UNION ALL
                    SELECT  LV+1 LV FROM SEQ WHERE LV+1 < 3
                )
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR
                    (PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,DATA_TP_CD
                    ,SRCE_TP_CD
                    ,DIVISION_ID
                    ,GROUP_CODE1
                    ,ITEM_CLASS
                    ,SRCE_YYYYMM
                    ,PLAN_YYYYMM
                    ,QTY
                    ,DEVALUATION_AGE
                    ,LONG_TERM_TYPE_CODE
                    ,LONG_TERM_TYPE
                    ,CLASS_NAME
					,COMPANY_ID    -- jjg추가 2025.03.22
					,PLANT_ID    -- jjg추가 2025.03.22
                    )
            SELECT   PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,CASE WHEN SEQ.LV = 1 THEN EOH.DATA_TP_CD ELSE 'BOH' END AS DATA_TP_CD
                    ,SRCE_TP_CD
                    ,DIVISION_ID
                    ,GROUP_CODE1
                    ,ITEM_CLASS
                    ,SRCE_YYYYMM
                    ,CASE   WHEN SEQ.LV = 1 THEN EOH.PLAN_YYYYMM 
                            ELSE LEFT(CONVERT(NVARCHAR(6), dateadd(month, @v_Counter, convert(date, @v_plan_yyyymmdd, 112)), 112), 6) 
                            END AS PLAN_YYYYMM
                    ,REMAIN_QTY             AS QTY
                    ,DEVALUATION_AGE
                    ,LONG_TERM_TYPE_CODE
                    ,LONG_TERM_TYPE
                    ,CLASS_NAME
					,COMPANY_ID   -- jjg추가 2025.03.22
					,PLANT_ID   -- jjg추가 2025.03.22
            FROM    SCM_LGTM_INV_PSI_DETAIL_SPRD_IGR EOH WITH(NOLOCK)
                  , SEQ
            WHERE   1=1
            AND     EOH.PLAN_TP_CD          = @v_plan_tp_cd
            AND     EOH.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
            AND     EOH.DATA_TP_CD          = 'EOH'
            AND     EOH.DIVISION_ID         = @V_DIVISION_ID
            AND     EOH.PLAN_YYYYMM         = @V_PLAN_YYYYMM
            AND     EOH.REMAIN_QTY         <> 0
            ;
        ------------------------------------------------------------------------     
        END;
        ------------------------------------------------------------------------ 

        ------------------------------------------------------------------------ 
        SET @v_Counter = @v_Counter + 1;
        ------------------------------------------------------------------------ 
        END;
        ------------------------------------------------------------------------ 
        PRINT 'Step 3 End';
        ------------------------------------------------------------------------  


        ------------------------------------------------------------------------
		-- Step 4-1 재고 월령 일괄 업데이트
		------------------------------------------------------------------------
        BEGIN

            -- [E20250310-000014] #TMP_LONG_TERM_TYPE 룩업 사용하여 LONG_TERM_TYPE 업데이트. 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기') Start  
            UPDATE A
            SET    LONG_TERM_TYPE       = B.LONG_TERM_TYPE
                 , LONG_TERM_TYPE_CODE  = B.LONG_TERM_TYPE_CODE
                 , DEVALUATION_AGE      = CONCAT('GRM',RIGHT(REPLICATE('0', 2)+CAST(DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) AS VARCHAR), 2))
            FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR A
            LEFT JOIN #TMP_LONG_TERM_TYPE   B
                 ON  DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) >= B.GRM_MM_FROM 
                 AND DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) <= B.GRM_MM_TO
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = @v_division_id

            
            --UPDATE  SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR
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
        ------------------------------------------------------------------------    
        END
        ------------------------------------------------------------------------ 
        PRINT 'Step 4 End';
        ------------------------------------------------------------------------  



        ------------------------------------------------------------------------
		-- Step 5-1 Update RESULT Amount from Item Summary.
		------------------------------------------------------------------------
        BEGIN
        ------------------------------------------------------------------------   
            WITH AMOUNT AS ( SELECT  SUM.COMPANY_ID							AS COMPANY_ID
									,SUM.DIVISION_ID                        AS DIVISION_ID
                                    ,SUM.GROUP_CODE1                        AS GROUP_CODE1
                                    ,CASE WHEN ISNULL(L.ATTRIBUTE2,'') <> '' THEN L.ATTRIBUTE2 
                                          ELSE '*' END                      AS ITEM_CLASS
                                    ,SUM.DATA_TP_CD                         AS DATA_TP_CD
                                    ,SUM.SRCE_TP_CD                         AS SRCE_TP_CD
                                    ,SUM.SRCE_YYYYMM                        AS SRCE_YYYYMM
                                    ,SUM.PLAN_YYYYMM                        AS PLAN_YYYYMM
                                    ,SUM(ISNULL(SUM.AMT, 0))                AS AMT
                            FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD SUM WITH(NOLOCK)
                            LEFT OUTER JOIN (   SELECT DISTINCT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) ITEM_CLASS
                                                FROM   SCM_ITEM_M_SN WITH(NOLOCK) 
                                                GROUP BY DIVISION_ID, ITEM_ID) SIM 
                                ON  SIM.DIVISION_ID = SUM.DIVISION_ID
                                AND SIM.ITEM_ID     = SUM.ITEM_ID
                            LEFT OUTER JOIN SCM_MST_ITEM_CLASS_M CLS WITH(NOLOCK)
                                ON SIM.ITEM_CLASS = CLS.CLASS_ID
                            LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L with(nolock)
                                ON      L.LOOKUP_TYPE   = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
                                AND     L.VALID_YN      = 'Y'
                                AND     L.SEGMENT1      = SIM.ITEM_CLASS
                            WHERE  1=1
                            AND     SUM.PLAN_TP_CD              = @v_srce_plan_tp_cd
                            AND     SUM.PLAN_START_YYYYMMDD     = @v_plan_start_yyyymmdd
                            AND     SUM.DIVISION_ID             = @v_division_id
                            AND     SUM.DATA_TP_CD              = 'RESULT'
                            GROUP BY SUM.DIVISION_ID
                                    ,SUM.GROUP_CODE1
                                    ,CASE WHEN ISNULL(L.ATTRIBUTE2,'') <> '' THEN L.ATTRIBUTE2 ELSE '*' END
                                    ,SUM.DATA_TP_CD
                                    ,SUM.SRCE_TP_CD
                                    ,SUM.SRCE_YYYYMM
                                    ,SUM.PLAN_YYYYMM
									,SUM.COMPANY_ID)
            UPDATE  GR
            SET      CURRENCY       = 'KRW'
                    ,STANDARD_COST  = 1
                    ,AMT            = ( SELECT AM.AMT
                                        FROM   AMOUNT AM
                                        WHERE  1=1
                                        -- AND    AM.PLAN_TP_CD            = GR.PLAN_TP_CD
                                        -- AND    AM.PLAN_START_YYYYMMDD   = GR.PLAN_START_YYYYMMDD
                                        AND    AM.DATA_TP_CD            = GR.DATA_TP_CD
                                        AND    AM.SRCE_TP_CD            = GR.SRCE_TP_CD
                                        AND    AM.DIVISION_ID           = GR.DIVISION_ID
                                        AND    AM.GROUP_CODE1           = GR.GROUP_CODE1
                                        AND    AM.ITEM_CLASS            = GR.ITEM_CLASS
                                        AND    AM.SRCE_YYYYMM           = GR.SRCE_YYYYMM
                                        AND    AM.PLAN_YYYYMM           = GR.PLAN_YYYYMM
										AND    AM.COMPANY_ID            = GR.COMPANY_ID
                                        )
            FROM    SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR GR
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     DIVISION_ID                 = @v_division_id
            AND     DATA_TP_CD                  = 'RESULT'
        ------------------------------------------------------------------------
        END

        ------------------------------------------------------------------------
		-- Step 5-2 Update Standard Cost by AVG for each item except RESULT
		------------------------------------------------------------------------
        BEGIN
        ------------------------------------------------------------------------   
        WITH COST AS (  SELECT   SUM.COMPANY_ID
								,SUM.DIVISION_ID
                                ,SUM.GROUP_CODE1
                                ,CASE WHEN ISNULL(L.ATTRIBUTE2,'') <> '' THEN L.ATTRIBUTE2 ELSE '*' END AS ITEM_CLASS
                                ,SUM.DATA_TP_CD
                                ,SUM.PLAN_YYYYMM
                                ,IIF(SUM(ABS(SUM.QTY))=0, 0, SUM(ABS(SUM.AMT)) / SUM(ABS(SUM.QTY)))            AS STANDARD_COST
                        FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD SUM WITH(NOLOCK)
                        LEFT OUTER JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, ITEM_CLASS
                                        FROM   SCM_ITEM_M_SN WITH(NOLOCK) ) SIM 
                            ON  SIM.DIVISION_ID = SUM.DIVISION_ID
                            AND SIM.ITEM_ID     = SUM.ITEM_ID
                        LEFT OUTER JOIN SCM_MST_ITEM_CLASS_M CLS WITH(NOLOCK)
                            ON SIM.ITEM_CLASS = CLS.CLASS_ID
                        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
                            ON      L.LOOKUP_TYPE   = 'SCM_LGTM_ELTR_ITEM_CLASS_CD'
                            AND     L.VALID_YN      = 'Y'
                            AND     L.SEGMENT1      = SIM.ITEM_CLASS
                        WHERE  1=1
                        AND    SUM.PLAN_TP_CD           = @v_srce_plan_tp_cd
                        AND    SUM.PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd
                        AND    SUM.DIVISION_ID          = @v_division_id
                        AND    SUM.DATA_TP_CD          != 'RESULT'
                        --AND    SUM.AMT                  > 0
                        GROUP BY SUM.DIVISION_ID
                                ,SUM.GROUP_CODE1
                                ,CASE WHEN ISNULL(L.ATTRIBUTE2,'') <> '' THEN L.ATTRIBUTE2 ELSE '*' END
                                ,SUM.DATA_TP_CD
                                ,SUM.PLAN_YYYYMM
								,SUM.COMPANY_ID
                        )
        UPDATE  IGR
        SET      CURRENCY       = 'KRW'
                ,STANDARD_COST  = ( SELECT COST.STANDARD_COST
                                    FROM   COST
                                    WHERE  COST.DIVISION_ID     = IGR.DIVISION_ID
                                    AND    COST.GROUP_CODE1     = IGR.GROUP_CODE1
                                    AND    COST.ITEM_CLASS      = IGR.ITEM_CLASS
                                    AND    COST.DATA_TP_CD      = IGR.DATA_TP_CD
                                    AND    COST.PLAN_YYYYMM     = IGR.PLAN_YYYYMM
									AND    COST.COMPANY_ID      = IGR.COMPANY_ID
                                    )
        FROM    SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR IGR
        WHERE   1=1
        AND     PLAN_TP_CD                  = @v_plan_tp_cd
        AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
        AND     DIVISION_ID                 = @v_division_id
        AND     DATA_TP_CD                 != 'RESULT'
        ------------------------------------------------------------------------
        END


        ------------------------------------------------------------------------ 
		-- Step 5-2 Update AMOUNT
		------------------------------------------------------------------------
        BEGIN
        ------------------------------------------------------------------------
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR
            SET     AMT     = STANDARD_COST * QTY
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = @v_division_id
            AND     DATA_TP_CD         != 'RESULT'
        ------------------------------------------------------------------------    
        END
        ------------------------------------------------------------------------ 
        
        ------------------------------------------------------------------------ 
		-- Step 5-3 Clear Non-ELTR BOH/EOH
		------------------------------------------------------------------------
        UPDATE  SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR
        SET     QTY                 = 0
              , AMT                 = 0
              , LAST_UPDATE_DATE    = GETDATE()
              , LAST_UPDATED_BY     = 'MINUS_TO_ZERO'
        WHERE   1=1 
        AND     PLAN_TP_CD          = @v_plan_tp_cd
        AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
        AND     DIVISION_ID         = @v_division_id
        AND     ITEM_CLASS          <> 'ELTR'
        AND     DATA_TP_CD          IN ( 'BOH','EOH')
        AND     QTY                 < 0    
        ------------------------------------------------------------------------ 
        PRINT 'Step 5 End';
        ------------------------------------------------------------------------  
		
        
        -- [E20250310-000014] #LONG_TERM_TYPE 임시테이블 삭제
        IF OBJECT_ID('tempdb..#TMP_LONG_TERM_TYPE') IS NOT NULL
            DROP TABLE #TMP_LONG_TERM_TYPE;


--jjg		COMMIT TRANSACTION;
	END TRY

	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
--jjg	ROLLBACK TRANSACTION PR_SCM_LGTM_INV_ALLOCATION_S_IGR;
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
