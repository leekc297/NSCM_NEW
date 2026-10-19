
/*
 * Program ID   : PR_SCM_LGTM_INV_ALLOCATION_CAL 
 * Description  : 장기재고 관련 EOH 정보 형성
 * OutTable     : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.05.19   KIMCD          PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *                             E20250513-000772 [공급/생산 SCM PI팀] LONGTERM STOCK MGMT 활성화 단가 수정요청의 건        
 * 2025.11.10   park.choyi		[E20250310-000014] 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기')                       
 */
CREATE PROCEDURE [dbo].[PR_SCM_LGTM_INV_ALLOCATION_CAL]
     @p_plan_tp_cd              NVARCHAR(20)
    ,@p_division_id             NVARCHAR(30)
    ,@p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_basis_yyyymm            NVARCHAR(6)
AS

BEGIN
-- select getdate()

/*  jjg
-- exec PR_SCM_LGTM_INV_ALLOCATION_CAL_OIJ_jjg 'FERT', '40', '20250303', '202503'
select 'jjg1'
return
select 'jjg2'
jjg */
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION_CAL';
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
    DECLARE @v_plan_tp_cd           NVARCHAR(20)    = @p_plan_tp_cd;            -- 'FERT';
    DECLARE @v_division_id          NVARCHAR(20)    = @p_division_id            -- '82';
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8)     = @p_plan_start_yyyymmdd    -- '20240701';
    DECLARE @v_basis_yyyymm         NVARCHAR(6)     = @p_basis_yyyymm           -- '202407';
    DECLARE @v_gr_cd                NVARCHAR(20)    = CONCAT(@p_plan_tp_cd, '_GC');            -- 'FERT';
    ------------------------------------------------------------------------  

    ------------------------------------------------------------------------  	
	-- Transaction 2nd Step. (START)
    -- 월별 PSI를 찾아와 Allocation 하는 Loop.
    /*
    1. Calendar 기준으로 시작월부터 월 조건 찾아옴.
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
            FROM    SCM_LGTM_INV_PSI_SUMMARY
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DATA_TP_CD         IN ('EOH')
            AND     ORIGIN_DIVISION_ID         = @v_division_id
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  
        
        ------------------------------------------------------------------------
		-- Step 1-1. Delete BOH after start month. [SCM_LGTM_INV_PSI_SUMMARY]
		------------------------------------------------------------------------   
        BEGIN
            DELETE 
            FROM    SCM_LGTM_INV_PSI_SUMMARY
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     PLAN_YYYYMM         > @v_basis_yyyymm
            AND     DATA_TP_CD         IN ('BOH')
            AND     ORIGIN_DIVISION_ID         = @v_division_id
		------------------------------------------------------------------------  
        END
		------------------------------------------------------------------------  

		------------------------------------------------------------------------  
        BEGIN
		------------------------------------------------------------------------
		-- Step 1-2. Delete [SCM_LGTM_INV_PSI_DETAIL]
		------------------------------------------------------------------------   
            DELETE 
            FROM    SCM_LGTM_INV_PSI_DETAIL
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     ORIGIN_DIVISION_ID         = @v_division_id
		------------------------------------------------------------------------  
		END
        --PRINT 'START PSI ALLOCATION';



        DECLARE     @v_Counter          INT;
        DECLARE     @v_plan_yyyymmdd    NVARCHAR(8) = CONCAT(@v_basis_yyyymm, '01');
        DECLARE     @v_plan_yyyymm      NVARCHAR(6);
        DECLARE     @v_cnt              INT;
        DECLARE     @v_item_id          NVARCHAR(30);
        
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
        DECLARE     @V_origin_division_id NVARCHAR(30);  

		DECLARE     @v_company_id		NVARCHAR(10);
		DECLARE     @v_plant_id			NVARCHAR(30);

		 DECLARE    @v_division_id_c       NVARCHAR(20) 
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

        INSERT INTO SCM_LGTM_INV_PSI_DETAIL
        ( PLAN_TP_CD
        , PLAN_START_YYYYMMDD
        , DATA_TP_CD
        , SRCE_TP_CD
        , DIVISION_ID
        , ORIGIN_DIVISION_ID
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
		, COMPANY_ID
		, PLANT_ID)
        SELECT    PLAN_TP_CD
                , PLAN_START_YYYYMMDD
                , 'EOH'
                , SRCE_TP_CD
                , DIVISION_ID
                , ORIGIN_DIVISION_ID
                , GROUP_CODE1
                , ITEM_ID
                , ORIGIN_ITEM_ID
                , SRCE_YYYYMM
                , PLAN_YYYYMM
                , SUM(QTY)				AS QTY
                , NULL					AS DECREASE_QTY
                , 'X'                   AS REASON_CD
                , SUM(QTY)                   AS REMAIN_QTY
                , MAX(SCM_SITE_ID)			AS SCM_SITE_ID
                , MAX(OPERATION_GROUP)		AS OPERATION_GROUP
                , MAX(OPERATION_ID)			AS OPERATION_ID
                , MAX(DEVALUATION_AGE)		AS DEVALUATION_AGE
                , MAX(LONG_TERM_TYPE_CODE)	AS LONG_TERM_TYPE_CODE
                , MAX(LONG_TERM_TYPE)		AS LONG_TERM_TYPE
                , MAX(VERSION_NO)			AS VERSION_NO
				, ISNULL(COMPANY_ID, '*')				AS COMPANY_ID
				, '*'						AS PLANT_ID
        FROM    SCM_LGTM_INV_PSI_SUMMARY S WITH(NOLOCK)
        WHERE   1=1
        AND     S.PLAN_TP_CD          = @v_plan_tp_cd
        AND     S.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
        AND     S.ORIGIN_DIVISION_ID         = @v_division_id
        AND     S.PLAN_YYYYMM         = @v_plan_yyyymm
        AND     S.DATA_TP_CD         IN ('BOH', 'P')
        AND     S.QTY                 > 0   -- 음수 BOH는 S 잔량에서 반영되기 때문에 EOH 반영 불필요.
		GROUP BY  PLAN_TP_CD
		,ORIGIN_DIVISION_ID
                    , PLAN_START_YYYYMMDD
                    , SRCE_TP_CD
                    , DIVISION_ID
                   -- , PLANT_ID
                    , GROUP_CODE1
                    , ITEM_ID
                    , ORIGIN_ITEM_ID
                    , SRCE_YYYYMM
                    , PLAN_YYYYMM
					, COMPANY_ID
					
            
        ;
        
        -- --PRINT  'Sales Count: '+CAST(@v_cnt AS NVARCHAR(10));

        IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CURRENT_MONTH_SALES_CUR')
        BEGIN
            CLOSE CURRENT_MONTH_SALES_CUR
            DEALLOCATE CURRENT_MONTH_SALES_CUR
        END;
        DECLARE CURRENT_MONTH_SALES_CUR CURSOR FAST_FORWARD FOR
                                SELECT    S.DIVISION_ID     AS DIVISION_ID
                                        , S.ORIGIN_DIVISION_ID AS ORIGIN_DIVISION_ID
                                        , S.SRCE_TP_CD      AS REASON_CD
                                        , S.GROUP_CODE1     AS GROUP_CODE1
                                        , S.ITEM_ID         AS ITEM_ID
                                        , S.ORIGIN_ITEM_ID  AS ORIGIN_ITEM_ID
                                        , SUM(CASE WHEN S.QTY < 0 THEN S.QTY*(-1) ELSE S.QTY END)            AS SALE_QTY
                                        , MAX(S.VERSION_NO)      AS VERSION_NO
										, S.COMPANY_ID
                                FROM    SCM_LGTM_INV_PSI_SUMMARY S WITH(NOLOCK)
                                WHERE   1=1
                                AND     S.PLAN_TP_CD          = @v_plan_tp_cd
                                AND     S.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
                                AND     S.ORIGIN_DIVISION_ID         = @v_division_id
                                AND     S.PLAN_YYYYMM         = @v_plan_yyyymm
                                AND     S.DATA_TP_CD         IN ('S','BOH')
                                AND     S.SRCE_TP_CD       LIKE 'S%'
                                GROUP BY  S.DIVISION_ID
                                        , S.ORIGIN_DIVISION_ID
                                        , S.SRCE_TP_CD
                                        , S.GROUP_CODE1
                                        , S.ITEM_ID
                                        , S.ORIGIN_ITEM_ID
										, S.COMPANY_ID
                                ORDER BY SRCE_TP_CD DESC

        OPEN CURRENT_MONTH_SALES_CUR
            -- key 정보는 상위 cursor에서 정의된 값을 같이 쓰면됨.
            FETCH NEXT FROM CURRENT_MONTH_SALES_CUR INTO  @v_division_id_c
                                                        , @V_origin_division_id
                                                        , @v_reason_cd
                                                        , @v_s_group_code1
                                                        , @v_item_id
                                                        , @v_s_org_item_id
                                                        , @v_sale_qty
                                                        , @v_s_version_no
														, @v_company_id

            WHILE @@FETCH_STATUS = 0
            BEGIN

            --PRINT 'Fetch Test: '+@v_item_id+' '+CAST(@v_sale_qty as NVARCHAR(100));

                IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CURRENT_MONTH_PROD_CUR')
                BEGIN
                    CLOSE CURRENT_MONTH_PROD_CUR
                    DEALLOCATE CURRENT_MONTH_PROD_CUR
                END;
                
                DECLARE CURRENT_MONTH_PROD_CUR CURSOR FOR
                                            SELECT  S.DATA_TP_CD        AS DATA_TP_CD
                                                    , S.SRCE_TP_CD      AS SRCE_TP_CD
                                                    , S.GROUP_CODE1     AS GROUP_CODE1
                                                    , S.ORIGIN_ITEM_ID  AS ORIGIN_ITEM_ID
                                                    , S.SRCE_YYYYMM     AS SRCE_YYYYMM
                                                    , S.REMAIN_QTY      AS REMAIN_QTY
                                                    , CASE WHEN s.srce_tp_cd = 'BOH_FERT' THEN 1
                                                           WHEN s.srce_tp_cd = 'BOH_SPRD' THEN 2
                                                           WHEN s.srce_tp_cd = 'BOH_INTS' THEN 3
                                                           WHEN s.srce_tp_cd = 'BOH_DEVL' THEN 4
                                                           ELSE 5 END AS SORT_ORDER
													, S.COMPANY_ID
                                            FROM    SCM_LGTM_INV_PSI_DETAIL S
                                            WHERE   1=1
                                            AND     S.PLAN_TP_CD            = @v_plan_tp_cd
                                            AND     S.PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd
                                            AND     s.data_tp_cd            = 'EOH'
                                            and     s.srce_tp_cd           IN ('BOH_FERT', 'BOH_SPRD', 'BOH_INTS', 'BOH_DEVL', 'P', 'P_SEMI_WHIN')
                                            AND     s.ORIGIN_DIVISION_ID           = @V_origin_division_id
                                            AND     S.ITEM_ID		        = @v_item_id
                                            AND     s.PLAN_YYYYMM           = @v_plan_yyyymm
                                            AND     S.REMAIN_QTY            > 0
											AND     S.COMPANY_ID            = @v_company_id
                                            ORDER BY SRCE_YYYYMM, SORT_ORDER, SRCE_TP_CD
                        FOR UPDATE

                OPEN CURRENT_MONTH_PROD_CUR
                    FETCH NEXT FROM CURRENT_MONTH_PROD_CUR INTO  @v_prod_data_tp_cd
                                                                , @v_srce_tp_cd
                                                                , @v_group_code1
                                                                , @v_org_item_id
                                                                , @v_srce_yyyymm
                                                                , @v_prod_qty
                                                                , @v_sort_order
																, @v_company_id
																
                    WHILE @@FETCH_STATUS = 0
                    BEGIN

                        --PRINT @@FETCH_STATUS;
                        --PRINT 'P type: '+@v_srce_tp_cd+' P YYYYMM: '+@v_srce_yyyymm+' Qty: '+CAST(@v_prod_qty as NVARCHAR(10));
                        IF ( @v_sale_qty > 0) AND (@v_prod_qty <=  @v_sale_qty )-- Demand ID가 전체 다 Full Pegging 되는 case
                            BEGIN
                                
                                --PRINT 'Fetch 2: Prod qty '+CAST(@v_prod_qty as NVARCHAR(10))+' < Sale Qty is: '+CAST(@v_sale_qty as NVARCHAR(10));
                                
                                -- Detail Update.
                                UPDATE  SCM_LGTM_INV_PSI_DETAIL
                                SET       DECREASE_QTY = @V_PROD_QTY
                                        , REASON_CD  = @V_REASON_CD
                                        , REMAIN_QTY = 0
                                        , LAST_UPDATE_DATE  = GETDATE()
                                        , LAST_UPDATED_BY   = CONCAT(@V_REASON_CD, '_enough')
                                WHERE   CURRENT OF CURRENT_MONTH_PROD_CUR
                                ;
                                
                                SET @v_sale_Qty = @v_sale_Qty - @v_prod_Qty;

                                --PRINT   'Remain Sale Qty: '+CAST(@v_sale_qty as NVARCHAR(10));
                                
                                --SET @v_qty = 0
                            END
                        ELSE IF ( @v_sale_qty > 0) AND (@v_prod_qty >  @v_sale_qty )-- Demand ID가 전체 다 Full Pegging 되는 case
                            BEGIN
                                --PRINT 'Fetch 2: Prod qty '+CAST(@v_prod_qty as NVARCHAR(10))+' > Sale Qty is: '+CAST(@v_sale_qty as NVARCHAR(10));
                                -- Detail Update.
                                UPDATE  SCM_LGTM_INV_PSI_DETAIL
                                SET       DECREASE_QTY = @v_sale_qty
                                        , REASON_CD  = @V_REASON_CD
                                        , REMAIN_QTY = REMAIN_QTY - @v_sale_qty
                                        , LAST_UPDATE_DATE  = GETDATE()
                                        , LAST_UPDATED_BY   = CONCAT(@V_REASON_CD, '_shortage')
                                WHERE   CURRENT OF CURRENT_MONTH_PROD_CUR;
                                ;
                                
                                SET @v_sale_Qty = 0;

                                --PRINT   '222Remain Sale Qty: '+CAST(@v_sale_qty as NVARCHAR(10));
                                
                            END
                        

                    FETCH NEXT FROM CURRENT_MONTH_PROD_CUR INTO   @v_prod_data_tp_cd
                                                                , @v_srce_tp_cd
                                                                , @v_group_code1
                                                                , @v_org_item_id
                                                                , @v_srce_yyyymm
                                                                , @v_prod_qty
                                                                , @v_sort_order
																, @v_company_id
                    END
                CLOSE CURRENT_MONTH_PROD_CUR
                DEALLOCATE CURRENT_MONTH_PROD_CUR

            IF (@v_sale_qty > 0)
                BEGIN
                    --PRINT 'Minus EOH Insert: '+CAST(@v_sale_qty as NVARCHAR(10));

                    INSERT INTO SCM_LGTM_INV_PSI_DETAIL
                        ( PLAN_TP_CD 
                        , PLAN_START_YYYYMMDD
                        , DATA_TP_CD
                        , SRCE_TP_CD
                        , DIVISION_ID
                        , ORIGIN_DIVISION_ID
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
						, COMPANY_ID
						, PLANT_ID)
                    SELECT @v_plan_tp_cd
                         , @v_plan_start_yyyymmdd
                         , 'EOH'
                         , @v_reason_cd
                         , @v_division_id_c
                         , @v_origin_division_id
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
						 , @v_company_id
						 , '*'
                    ;
                         

                END

            FETCH NEXT FROM CURRENT_MONTH_SALES_CUR INTO  @v_division_id_c
                                                        , @v_origin_division_id    
                                                        , @v_reason_cd
                                                        , @v_s_group_code1
                                                        , @v_item_id
                                                        , @v_s_org_item_id
                                                        , @v_sale_qty
                                                        , @v_s_version_no
														, @v_company_id   -- jjg추가
            END
        CLOSE CURRENT_MONTH_SALES_CUR
        DEALLOCATE CURRENT_MONTH_SALES_CUR

--jjg 여기까지 0초


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
            INSERT INTO SCM_LGTM_INV_PSI_SUMMARY
                    (PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,DATA_TP_CD
                    ,SRCE_TP_CD
                    ,DIVISION_ID
                    ,ORIGIN_DIVISION_ID
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
					,COMPANY_ID
					,PLANT_ID)
            SELECT   PLAN_TP_CD
                    ,PLAN_START_YYYYMMDD
                    ,CASE WHEN SEQ.LV = 1 THEN EOH.DATA_TP_CD ELSE 'BOH' END AS DATA_TP_CD
                    ,SRCE_TP_CD
                    ,DIVISION_ID
                    ,ORIGIN_DIVISION_ID
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
					,ISNULL(COMPANY_ID, '*') AS COMPANY_ID
					,ISNULL(PLANT_ID, '*') AS PLANT_ID
            FROM    SCM_LGTM_INV_PSI_DETAIL EOH WITH(NOLOCK)
                  , SEQ
            WHERE   1=1
            AND     EOH.PLAN_TP_CD          = @v_plan_tp_cd
            AND     EOH.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
            AND     EOH.DATA_TP_CD          = 'EOH'
            --AND     EOH.SRCE_TP_CD         IN ('BOH', 'P')
            AND     EOH.ORIGIN_DIVISION_ID         = @v_division_id
            AND     EOH.PLAN_YYYYMM         = @V_PLAN_YYYYMM
            AND     EOH.REMAIN_QTY         <> 0
            
        END;



        SET @v_Counter = @v_Counter + 1;

        END;


        ------------------------------------------------------------------------
		-- Step 4-1 재고 월령 일괄 업데이트
		------------------------------------------------------------------------
        BEGIN
            -- [E20250310-000014] #TMP_LONG_TERM_TYPE 룩업 사용하여 LONG_TERM_TYPE 업데이트. 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기') Start            
            UPDATE A
            SET    LONG_TERM_TYPE       = B.LONG_TERM_TYPE
                 , LONG_TERM_TYPE_CODE  = B.LONG_TERM_TYPE_CODE
                 , DEVALUATION_AGE      = CONCAT('GRM',RIGHT(REPLICATE('0', 2)+CAST(DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) AS VARCHAR), 2))
            FROM   SCM_LGTM_INV_PSI_SUMMARY A
            LEFT JOIN #TMP_LONG_TERM_TYPE   B
                 ON  DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) >= B.GRM_MM_FROM 
                 AND DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) <= B.GRM_MM_TO
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     ORIGIN_DIVISION_ID  = @v_division_id

            
            --UPDATE  SCM_LGTM_INV_PSI_SUMMARY
            --SET     LONG_TERM_TYPE          = case when DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 3 THEN N'비대상'
            --                                    when DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 6 THEN N'부실 징후'
            --                                    when DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) >= 6 THEN N'부실'
            --                                    ELSE NULL END
            --        , LONG_TERM_TYPE_CODE   = case when DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 3 THEN N'CODE_2'
            --                                    when DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) < 6 THEN N'CODE_5'
            --                                    when DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) >= 6 THEN N'CODE_6'
            --                                    ELSE NULL END  
            --        , DEVALUATION_AGE       = CONCAT('GRM',RIGHT(REPLICATE('0', 2)+CAST(DATEDIFF(MM, CONVERT(DATE, CONCAT(SRCE_YYYYMM,'01'), 112), CONVERT(DATE, CONCAT(PLAN_YYYYMM,'01'), 112)) AS VARCHAR), 2) )
            --WHERE   1=1 
            --AND     PLAN_TP_CD          = @v_plan_tp_cd
            --AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            --AND     ORIGIN_DIVISION_ID         = @v_division_id
            -- [E20250310-000014] #TMP_LONG_TERM_TYPE 룩업 사용하여 LONG_TERM_TYPE 업데이트. 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기') End        
        END
        ------------------------------------------------------------------------
        PRINT 'Step 4-1 End';
-- jjg 여기까지 7초
 
select 'here good'

        ------------------------------------------------------------------------
		-- Step 4-2 Group_Code1 값 Update.
        -- 1. ITEM_ID -> Applied_Model -> DOE(Basic Model) 기준의 NICK_NAME
        -- 2. ITEM_ID -> DOE 기준의 NICK_NAME
        -- 3. ITEM_ID 기준의 NICK_NAME
        -- 2024.09.10 Philsu Park: 소형사업부는 GROUP_CODE9, 그 외는 GROUP_CODE1 을 적용.
		------------------------------------------------------------------------
        BEGIN
            WITH ITEM_M AS (
                            SELECT    I.DIVISION_ID
                                    , I.ITEM_ID
                                    , MAX(CASE WHEN ISNULL(F1.GROUP_CODE1, '') != '' THEN F1.GROUP_CODE1
                                                WHEN ISNULL(F3.GROUP_CODE1, '') != '' THEN F3.GROUP_CODE1
                                                WHEN ISNULL(F2.GROUP_CODE1, '') != '' THEN F2.GROUP_CODE1
                                                WHEN ISNULL(I.DOE, '') = '' THEN ISNULL(I3.NICK_NAME, I.NICK_NAME)
                                                ELSE ISNULL(I2.NICK_NAME, I.NICK_NAME) END
                                                ) AS GROUP_CODE1
                                    , MAX(CASE WHEN ISNULL(F1.GROUP_CODE9, '') != '' THEN F1.GROUP_CODE9
                                                WHEN ISNULL(F3.GROUP_CODE9, '') != '' THEN F3.GROUP_CODE9
                                                WHEN ISNULL(F2.GROUP_CODE9, '') != '' THEN F2.GROUP_CODE9
                                                WHEN ISNULL(I.DOE, '') = '' THEN ISNULL(I3.NICK_NAME, I.NICK_NAME)
                                                ELSE ISNULL(I2.NICK_NAME, I.NICK_NAME) END
                                                ) AS GROUP_CODE9
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
            UPDATE  SUM
            SET     GROUP_CODE1     = ISNULL((  SELECT  IIF(@v_division_id = '40', M.GROUP_CODE9, M.GROUP_CODE1)
                                                FROM    ITEM_M  M WITH(NOLOCK)
                                                --WHERE   M.DIVISION_ID = SCM_LGTM_INV_PSI_SUMMARY.DIVISION_ID
                                                WHERE   M.DIVISION_ID = SUM.ORIGIN_DIVISION_ID
                                                AND     M.ITEM_ID     = SUM.ITEM_ID
                                                ), REPLACE(GROUP_CODE1, '*', ITEM_ID))
            FROM    SCM_LGTM_INV_PSI_SUMMARY SUM
            WHERE   1=1
            AND     SUM.PLAN_TP_CD          = @v_plan_tp_cd
            AND     SUM.ORIGIN_DIVISION_ID         = @v_division_id
            AND     SUM.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
        END


		------------------------------------------------------------------------
		-- Step 4-2-1 81*인것에 대하여 GROUP CODE값을 SCP_MST_FINAL_ITEM.LEVEL2_CODE의 값을 활용하도록 함 -- OIJ
		------------------------------------------------------------------------
		IF LEFT(@v_division_id, 2) = '81'
        BEGIN
          
        UPDATE	SCM_LGTM_INV_PSI_SUMMARY
		   SET	SCM_LGTM_INV_PSI_SUMMARY.GROUP_CODE1 = M.LEVEL2_CODE
		  FROM	SCM_LGTM_INV_PSI_SUMMARY SUM, SCP_MST_FINAL_ITEM M
		 WHERE	SUM.ORIGIN_DIVISION_ID = M.DIVISION_ID
		   AND	SUM.ITEM_ID = M.ITEM_ID
		   AND	M.LEVEL2_CODE IS NOT NULL AND M.LEVEL2_CODE <> ''
		   AND	SUM.ORIGIN_DIVISION_ID  = @v_division_id
		   AND	SUM.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
		   AND  SUM.PLAN_TP_CD          = @v_plan_tp_cd
		   
		--UPDATE SCM_LGTM_INV_PSI_SUMMARY
		--SET SCM_LGTM_INV_PSI_SUMMARY.GROUP_CODE1 = M.LEVEL2_CODE
		--FROM SCM_LGTM_INV_PSI_SUMMARY SUM, SCP_MST_FINAL_ITEM M
		--WHERE SUM.ORIGIN_DIVISION_ID = M.DIVISION_ID
		--AND SUM.ITEM_ID = M.ITEM_ID
		--AND SUM.ORIGIN_DIVISION_ID LIKE '81%'
		--AND SUM.PLAN_START_YYYYMMDD = '20250303'

        END


        ------------------------------------------------------------------------
		-- Step 4-2 소형사업부의 경우 Group_Code9 값을 사용. 나머지 순위 RULE은 동일
        -- 1. ITEM_ID -> Applied_Model -> DOE(Basic Model) 기준의 NICK_NAME
        -- 2. ITEM_ID -> DOE 기준의 NICK_NAME
        -- 3. ITEM_ID 기준의 NICK_NAME
		------------------------------------------------------------------------
        /* BEGIN
            WITH ITEM_M2 AS (
                            SELECT    I.DIVISION_ID
                                    , I.ITEM_ID
                                    , MAX(CASE  WHEN ISNULL(F1.GROUP_CODE9, '') != '' THEN F1.GROUP_CODE9
                                                WHEN ISNULL(F3.GROUP_CODE9, '') != '' THEN F3.GROUP_CODE9
                                                WHEN ISNULL(F2.GROUP_CODE9, '') != '' THEN F2.GROUP_CODE9
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
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY
            SET     GROUP_CODE1     = ISNULL((  SELECT  M.GROUP_CODE1 
                                                FROM    ITEM_M2  M WITH(NOLOCK)
                                                WHERE   M.DIVISION_ID = SCM_LGTM_INV_PSI_SUMMARY.ORIGIN_DIVISION_ID
                                                AND     M.ITEM_ID     = SCM_LGTM_INV_PSI_SUMMARY.ITEM_ID
                                                ), REPLACE(GROUP_CODE1, '*', ITEM_ID))
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = '40'
        END */

        ------------------------------------------------------------------------
		-- Step 4-2 마감재고 기반 단가정보 추출. 0값 포함 필요(실적구간 0인 경우 0으로 반영)
        -- 2024.09.10 Philsu Park:  AMDAU_CELL 추가해서 ACCUM_QTY 미리 찾아주고 
        --                          AMDAU -> Cell 로 전개한 경우, AMDAU의 마감재고 단가를 Cell ACCUM_Qty 로 나눠서 사용.
        ------------------------------------------------------------------------
        BEGIN 
            WITH AMDAU_CELL AS (SELECT COMPANY_ID, PARENT_ITEM_ID, AVG(CHILD_QTY/PARENT_QTY) ACCUM_QTY
                                FROM (
                                        SELECT  COMPANY_ID, PARENT_ITEM_ID, CHILD_ITEM_ID, PARENT_QTY, CHILD_QTY
                                        FROM    SCM_MST_BOM_ENG_SN BOM WITH(NOLOCK)
                                        INNER JOIN (    SELECT ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                        FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                                        GROUP BY ITEM_ID
                                                    ) ITM1
                                            ON ITM1.ITEM_ID      = BOM.PARENT_ITEM_ID
                                        INNER JOIN (    SELECT ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                        FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                                        GROUP BY ITEM_ID
                                                    ) ITM
                                            ON ITM.ITEM_ID      = BOM.CHILD_ITEM_ID
                                        WHERE   ITM1.ITEM_CLASS = 'ES0901'
                                        AND     BOM.EFF_END_DATE     >= GETDATE()
                                        AND     ITM.ITEM_CLASS = 'EM0201'
                                        GROUP BY COMPANY_ID, PARENT_ITEM_ID, CHILD_ITEM_ID, PARENT_QTY, CHILD_QTY
                                        ) MM
                                GROUP BY COMPANY_ID, PARENT_ITEM_ID
                                )
            SELECT MM.COMPANY_ID, MM.DATA_TYPE, MM.DIVISION_ID, MM.ITEM_ID, MM.YYYYMM, MM.COST, MM.ACCUM_QTY
            INTO   #TEMP_END_INV_COST
            FROM (
                    SELECT INV.COMPANY_ID, 'NON_MAPPING' AS DATA_TYPE, INV.DIVISION_ID, INV.ITEM_ID, INV.YYYYMM
                           , IIF(SUM(INV.QUANTITY)=0, 0, SUM(INV.AMOUNT_KRW)/SUM(INV.QUANTITY)) AS COST
                           , MAX(ISNULL(AMD.ACCUM_QTY, 1)) AS ACCUM_QTY
                    FROM   SCP_ANL_MONTH_END_STOCK_R INV WITH(NOLOCK)
                    INNER JOIN (    SELECT COMPANY_ID, ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY COMPANY_ID, ITEM_ID
                                ) C
                        ON  C.ITEM_ID = INV.ITEM_ID
						AND C.COMPANY_ID = INV.COMPANY_ID
                    INNER JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    LEFT OUTER JOIN AMDAU_CELL AMD WITH(NOLOCK)
                        ON AMD.PARENT_ITEM_ID = INV.ITEM_ID
						AND AMD.COMPANY_ID   = INV.COMPANY_ID
                    WHERE   1=1
                    --and     INV.DIVISION_ID      LIKE CONCAT(SUBSTRING(@v_division_id, 1, 2), '%')
                    AND     INV.YYYYMM              > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    AND     INV.YYYYMM             <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND     (CASE WHEN INV.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                  WHEN INV.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                  ELSE D.ITEM_TYPE        
                                  END               = N'제품'
                        OR  ( CASE WHEN INV.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                  WHEN INV.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                  ELSE D.ITEM_TYPE        
                                  END               = N'반제품'
                            AND D.PROCESS_GROUP     = 'CELL')
                            )
                    --and    ISNULL(INV.QUANTITY, 0) != 0
                    GROUP BY INV.COMPANY_ID, INV.DIVISION_ID, INV.ITEM_ID, INV.YYYYMM
                    HAVING SUM(INV.QUANTITY) != 0
                    UNION ALL
                    SELECT INV.COMPANY_ID, 'MAPPING' AS DATA_TYPE, INV.DIVISION_ID, ISNULL(BOM.PARENT_ITEM_ID, INV.ITEM_ID) AS ITEM_ID, INV.YYYYMM
                           , IIF(SUM(INV.QUANTITY)=0, 0, SUM(INV.AMOUNT_KRW)/SUM(INV.QUANTITY)) AS COST
                           , 1 AS ACCUM_QTY
                    FROM   SCP_ANL_MONTH_END_STOCK_R INV WITH(NOLOCK)
                    INNER JOIN (    SELECT COMPANY_ID, ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
                                    FROM SCM_MST_ITEM_SN WITH(NOLOCK)
                                    GROUP BY COMPANY_ID, ITEM_ID
                                ) C
                        ON  C.ITEM_ID = INV.ITEM_ID
						AND C.COMPANY_ID = INV.COMPANY_ID
                    INNER JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON  C.ITEM_CLASS = D.CLASS_ID
                    LEFT OUTER JOIN (   SELECT    COMPANY_ID, DIVISION_ID, CHILD_ITEM_ID, MAX(PARENT_ITEM_ID) AS PARENT_ITEM_ID
                                        FROM      SCM_MST_BOM_SN WITH(NOLOCK)
                                        WHERE     1=1 
                                        --AND       DIVISION_ID     LIKE CONCAT(@v_division_id, '%')
                                        AND       PARENT_ITEM_ID != '*'
                                        GROUP BY COMPANY_ID, DIVISION_ID, CHILD_ITEM_ID
                                        ) BOM
                        ON  BOM.DIVISION_ID     = INV.DIVISION_ID
                        AND BOM.CHILD_ITEM_ID   = INV.ITEM_ID
						AND BOM.COMPANY_ID      = INV.COMPANY_ID
                    WHERE   1=1
                    --and     INV.DIVISION_ID      LIKE CONCAT(SUBSTRING(@v_division_id, 1, 2), '%')
                    AND     INV.YYYYMM              > CONCAT(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,4), '12')
                    --AND     INV.YYYYMM              > SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND     INV.YYYYMM             <= SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                    AND     CASE WHEN INV.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
                                  WHEN INV.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
                                  ELSE D.ITEM_TYPE        
                                  END               = N'반제품'
                            AND D.PROCESS_GROUP     = 'CELL'
                    --and    ISNULL(INV.QUANTITY, 0) != 0
                    GROUP BY INV.COMPANY_ID, INV.DIVISION_ID, ISNULL(BOM.PARENT_ITEM_ID, INV.ITEM_ID), INV.YYYYMM
                    HAVING SUM(INV.QUANTITY) != 0
                    ) MM
            --WHERE ISNULL(MM.COST, 0) != 0
        END
        ------------------------------------------------------------------------
        PRINT 'Step 4-2 End';
        
        ------------------------------------------------------------------------
		-- Step 4-3.1 가중평균 단가 업데이트. ORIGIN_ITEM_ID 기준으로 전월 마감재고의 단가 참조.
        -- 2024.09.10 Philsu Park: AMDAU -> Cell 로 전개한 경우, AMDAU의 마감재고 단가를 Cell ACCUM_Qty 로 나눠서 사용.
		------------------------------------------------------------------------
        BEGIN
            WITH ITEM_INFO AS ( SELECT  COMPANY_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM    SCM_ITEM_M_SN
                                GROUP BY COMPANY_ID, ITEM_ID
                                )
            UPDATE  S
            SET     S.CURRENCY        = 'KRW'
                    ,S.STANDARD_COST  = ( SELECT IIF((S.DATA_TP_CD = 'RESULT' OR S.SRCE_TP_CD LIKE 'BOH%')
                                                    , B.COST/(CASE WHEN (ITM.ITEM_CLASS = 'ES0901' AND ITM2.ITEM_CLASS = 'EM0201') THEN B.ACCUM_QTY ELSE 1 END)
                                                    , IIF(B.COST = 0, NULL, B.COST/(CASE WHEN (ITM.ITEM_CLASS = 'ES0901' AND ITM2.ITEM_CLASS = 'EM0201') THEN B.ACCUM_QTY ELSE 1 END)))
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND     B.DATA_TYPE     = 'NON_MAPPING'
                                        AND     B.YYYYMM        = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM
                                                                       ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                                                        END
                                        --AND    B.DIVISION_ID        = S.DIVISION_ID
                                        AND    B.DIVISION_ID    = S.ORIGIN_DIVISION_ID
										AND    B.COMPANY_ID     = S.COMPANY_ID
                                        AND    B.ITEM_ID        = CASE WHEN ITM.ITEM_CLASS IN ('ES0901','ES1901','ES2001','ES2002','ES2003','ES2004' ) THEN S.ORIGIN_ITEM_ID  -- 2025.05.19 kimcd    PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
                                                                                                                                                                              --                     E20250513-000772 [공급/생산 SCM PI팀] LONGTERM STOCK MGMT 활성화 단가 수정요청의 건
                                                                       WHEN S.DATA_TP_CD = 'RESULT' THEN S.ORIGIN_ITEM_ID
                                                                       ELSE S.ITEM_ID END
                                        --AND    B.STORAGE_LOCATION  != N'미착' 
                                        )
                    ,CST_CTN        = N'1st 마감재고 가중평균 단가_by_ITEM(Non-Mapping)'
            FROM    SCM_LGTM_INV_PSI_SUMMARY S
            INNER JOIN ITEM_INFO ITM
                ON ITM.ITEM_ID      = S.ORIGIN_ITEM_ID
				AND ITM.COMPANY_ID   = S.COMPANY_ID
                --AND ITM.ITEM_CLASS  = 'ES0901'
            INNER JOIN ITEM_INFO ITM2
                ON ITM2.ITEM_ID = S.ITEM_ID
				AND ITM2.COMPANY_ID = S.COMPANY_ID
            WHERE   1=1 
            AND     S.PLAN_TP_CD          = @v_plan_tp_cd
            AND     S.ORIGIN_DIVISION_ID         = @v_division_id
            AND     S.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
        END
        

        ------------------------------------------------------------------------
		-- Step 4-3.2 가중평균 단가 업데이트. ORIGIN_ITEM_ID 기준으로 전월 마감재고의 단가 참조.
		------------------------------------------------------------------------
        BEGIN
            UPDATE  S
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT IIF((S.DATA_TP_CD = 'RESULT' OR S.SRCE_TP_CD LIKE 'BOH%'), B.COST, IIF(B.COST = 0, NULL, B.COST))--COST --SUM(AMOUNT_KRW)/SUM(QUANTITY)
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND     B.DATA_TYPE         = 'MAPPING'
                                        AND     B.YYYYMM             = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM
                                                                           ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                                                            END
                                        --AND    B.DIVISION_ID        = S.DIVISION_ID
                                        AND    B.DIVISION_ID        = S.ORIGIN_DIVISION_ID
										AND    B.COMPANY_ID			= S.COMPANY_ID
                                        AND    B.ITEM_ID            = S.ITEM_ID
                                        --AND    B.STORAGE_LOCATION  != N'미착' 
                                        )
                    ,CST_CTN        = N'1st 마감재고 가중평균 단가_by_ITEM(Mapping)'
            FROM    SCM_LGTM_INV_PSI_SUMMARY S
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     ORIGIN_DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     STANDARD_COST      IS NULL
        END


		--2025-02-14 OIJ
		PRINT N'START DIVISION_ID를 제외하고 ITEM 기준: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 114);
		------------------------------------------------------------------------
		-- Step 4-3.1.1 가중평균 단가 업데이트. DIVISION_ID를 제외하고 ITEM 기준으로 전월 마감재고의 단가 참조.
		------------------------------------------------------------------------
        BEGIN
            UPDATE  S
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT IIF((S.DATA_TP_CD = 'RESULT' OR S.SRCE_TP_CD LIKE 'BOH%'), B.COST, IIF(B.COST = 0, NULL, B.COST))--COST --SUM(AMOUNT_KRW)/SUM(QUANTITY)
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND     B.DATA_TYPE         = 'MAPPING'
                                        AND     B.YYYYMM             = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM
                                                                           ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                                                            END
                                       --AND    B.DIVISION_ID        = S.ORIGIN_DIVISION_ID
									    AND    B.COMPANY_ID			= S.COMPANY_ID
                                        AND    B.ITEM_ID            = S.ITEM_ID
                                        )
                    ,CST_CTN        = N'1st 마감재고 가중평균 단가_by_ITEM(Mapping)_2'
            FROM    SCM_LGTM_INV_PSI_SUMMARY S
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     ORIGIN_DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     STANDARD_COST      IS NULL
        END
        
        ------------------------------------------------------------------------
		-- Step 4-3.1 가중평균 단가 업데이트. ORIGIN_ITEM_ID 기준으로 가장 최근 마감재고의 단가 참조.
		------------------------------------------------------------------------
        BEGIN
            WITH ITEM_INFO AS ( SELECT  COMPANY_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                FROM    SCM_ITEM_M_SN
                                GROUP BY COMPANY_ID, ITEM_ID
                                )
            UPDATE  S
            SET     S.CURRENCY        = 'KRW'
                    ,S.STANDARD_COST  = ( SELECT TOP 1 IIF((S.DATA_TP_CD = 'RESULT' OR S.SRCE_TP_CD LIKE 'BOH%')
                                                            , B.COST/(CASE WHEN (ITM.ITEM_CLASS = 'ES0901' AND ITM2.ITEM_CLASS = 'EM0201') THEN B.ACCUM_QTY ELSE 1 END)
                                                            , IIF(B.COST = 0, NULL, B.COST/(CASE WHEN (ITM.ITEM_CLASS = 'ES0901' AND ITM2.ITEM_CLASS = 'EM0201') THEN B.ACCUM_QTY ELSE 1 END)))
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND    B.DATA_TYPE      = 'NON_MAPPING'
                                        AND    B.YYYYMM         = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM ELSE B.YYYYMM END
                                        AND    B.DIVISION_ID    = S.ORIGIN_DIVISION_ID
										AND    B.COMPANY_ID     = S.COMPANY_ID
                                        AND    B.ITEM_ID        = CASE WHEN ITM.ITEM_CLASS IN ('ES0901','ES1901','ES2001','ES2002','ES2003','ES2004' ) THEN S.ORIGIN_ITEM_ID  -- 2025.05.19 kimcd    PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
                                                                                                                                                                              --                     E20250513-000772 [공급/생산 SCM PI팀] LONGTERM STOCK MGMT 활성화 단가 수정요청의 건
                                                                       ELSE S.ITEM_ID END
                                        AND    B.COST           > 0
                                        ORDER BY B.YYYYMM DESC
                                        )
                    ,CST_CTN        = ( SELECT TOP 1 N'1st-2 과거 마감재고 가중평균 단가_by_ITEM(Non-Mapping) : '+B.YYYYMM
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND     B.DATA_TYPE     = 'NON_MAPPING'
                                        AND     B.YYYYMM        = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM ELSE B.YYYYMM END
                                        AND    B.DIVISION_ID    = S.ORIGIN_DIVISION_ID
										AND    B.COMPANY_ID     = S.COMPANY_ID
                                        AND    B.ITEM_ID        = CASE WHEN ITM.ITEM_CLASS IN ('ES0901','ES1901','ES2001','ES2002','ES2003','ES2004' ) THEN S.ORIGIN_ITEM_ID  -- 2025.05.19 kimcd    PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
                                                                                                                                                                              --                     E20250513-000772 [공급/생산 SCM PI팀] LONGTERM STOCK MGMT 활성화 단가 수정요청의 건
                                                                    ELSE  S.ITEM_ID END
                                        AND    B.COST > 0
                                        ORDER BY B.YYYYMM DESC
                                        )
            FROM    SCM_LGTM_INV_PSI_SUMMARY S
            INNER JOIN ITEM_INFO ITM
                ON ITM.ITEM_ID      = S.ORIGIN_ITEM_ID
				AND ITM.COMPANY_ID	 = S.COMPANY_ID
            INNER JOIN ITEM_INFO ITM2
                ON ITM2.ITEM_ID = S.ITEM_ID
				AND ITM2.COMPANY_ID   = S.COMPANY_ID
            WHERE   1=1 
            AND     S.PLAN_TP_CD          = @v_plan_tp_cd
            AND     S.ORIGIN_DIVISION_ID         = @v_division_id
            AND     S.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     STANDARD_COST           IS NULL
        END
       

        ------------------------------------------------------------------------
		-- Step 4-3.2 가중평균 단가 업데이트. ORIGIN_ITEM_ID 기준으로 최근 마감재고의 단가 참조.
		------------------------------------------------------------------------
        BEGIN
            UPDATE  S
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT TOP 1 IIF((S.DATA_TP_CD = 'RESULT' OR S.SRCE_TP_CD LIKE 'BOH%'), B.COST, IIF(B.COST = 0, NULL, B.COST))
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND    B.DATA_TYPE          = 'MAPPING'
                                        AND    B.YYYYMM             = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM ELSE B.YYYYMM END
                                        AND    B.DIVISION_ID        = S.ORIGIN_DIVISION_ID
                                        AND    B.ITEM_ID            = S.ITEM_ID
										AND    B.COMPANY_ID         = S.COMPANY_ID
                                        AND    B.COST               > 0
                                        ORDER BY B.YYYYMM DESC
                                        )
                    ,CST_CTN        = ( SELECT TOP 1 N'1st-3 과거 마감재고 가중평균 단가_by_ITEM(Mapping) : '+B.YYYYMM
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND    B.DATA_TYPE         = 'MAPPING'
                                        AND    B.YYYYMM             = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM ELSE B.YYYYMM END
                                        AND    B.DIVISION_ID        = S.ORIGIN_DIVISION_ID
                                        AND    B.ITEM_ID            = S.ITEM_ID
										AND    B.COMPANY_ID         = S.COMPANY_ID
                                        AND    B.COST               > 0
                                        ORDER BY B.YYYYMM DESC
                                        )
            FROM    SCM_LGTM_INV_PSI_SUMMARY S
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     ORIGIN_DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     STANDARD_COST      IS NULL
        END
       

        ------------------------------------------------------------------------
		-- Step 4-3.2 완제품 중 반제품 Cell 가져와서 사용하는 대상, Parent Item으로 한번 더 찾음.
		------------------------------------------------------------------------
        /* BEGIN
            WITH INVENTORY_COST AS  (
                                        SELECT    S.DIVISION_ID
                                                , ISNULL(BOM.PARENT_ITEM_ID, S.ITEM_ID) AS ITEM_ID
                                                , IIF(SUM(ISNULL(S.QUANTITY, 0)) = 0, 0, SUM(ISNULL(AMOUNT_KRW, 0))/SUM(ISNULL(S.QUANTITY, 0))) AS COST
                                        FROM    SCP_ANL_MONTH_END_STOCK_R S WITH(NOLOCK)
                                        INNER JOIN (SELECT  ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS
                                                    FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
                                                    GROUP BY ITEM_ID
                                                    ) ITM
                                            ON  ITM.ITEM_ID     = S.ITEM_ID
                                        INNER JOIN SCM_MST_ITEM_CLASS_M CLS WITH(NOLOCK)
                                            ON  CLS.CLASS_ID    = ITM.ITEM_CLASS
                                        LEFT OUTER JOIN (   SELECT    DIVISION_ID, CHILD_ITEM_ID, MAX(PARENT_ITEM_ID) AS PARENT_ITEM_ID
                                                            FROM      SCM_MST_BOM_SN WITH(NOLOCK)
                                                            WHERE     1=1 
                                                            AND       DIVISION_ID     LIKE CONCAT(@v_division_id, '%')
                                                            AND       PARENT_ITEM_ID != '*'
                                                            GROUP BY DIVISION_ID, CHILD_ITEM_ID
                                                            ) BOM
                                            ON  BOM.DIVISION_ID     = S.DIVISION_ID
                                            AND BOM.CHILD_ITEM_ID   = S.ITEM_ID
                                        WHERE   S.YYYYMM            = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                        AND     CLS.PROCESS_GROUP   = 'Cell'
                                        AND     CLS.ITEM_TYPE       = N'반제품'
                                        GROUP BY S.DIVISION_ID, ISNULL(BOM.PARENT_ITEM_ID, S.ITEM_ID)
                                    )
            UPDATE  S
            SET     CURRENCY = 'KRW'
                    ,STANDARD_COST  = ( SELECT B.COST
                                        FROM   INVENTORY_COST B WITH(NOLOCK)
                                        WHERE  1=1
                                        AND    B.DIVISION_ID        = S.ORIGIN_DIVISION_ID
                                        AND    B.ITEM_ID            = S.ITEM_ID
                                        --AND    B.STORAGE_LOCATION  != N'미착' 
                                        )
            FROM    SCM_LGTM_INV_PSI_SUMMARY S
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     ISNULL(STANDARD_COST, 0)    = 0
            and     DATA_TP_CD                 != 'RESULT'
            ;
        END */
        
        ------------------------------------------------------------------------
		-- Step 4-3.2 가중평균 단가 업데이트. ITEM_ID 기준으로 한번 더.
		------------------------------------------------------------------------
        /* BEGIN
            UPDATE  S
            SET     CURRENCY        = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST
                                        FROM   #TEMP_END_INV_COST B WITH(NOLOCK)
                                        WHERE  B.YYYYMM             = CASE WHEN S.DATA_TP_CD = 'RESULT' THEN S.PLAN_YYYYMM
                                                                           ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                                                            END
                                        AND    B.DIVISION_ID        = S.ORIGIN_DIVISION_ID
                                        and    B.ITEM_ID            = S.ORIGIN_ITEM_ID
                                        --AND    B.STORAGE_LOCATION  != N'미착'
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||2nd 마감재고 가중평균 단가_by_Origin_ITEM')
            FROM    SCM_LGTM_INV_PSI_SUMMARY S
            WHERE   1=1 
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     ISNULL(STANDARD_COST, 0)    = 0
        END */

  

        IF @v_division_id != '40' --소형 아닌 경우에만 적용
        ------------------------------------------------------------------------
		-- Step 4-3.2 가중평균 단가 업데이트. DOE 기준으로 전월 마감재고의 단가 참조.
		------------------------------------------------------------------------
        BEGIN
            BEGIN
                WITH   ITEM_M AS    (SELECT   IM.COMPANY_ID, IM.DIVISION_ID, Im.ITEM_ID, IM.DOE
                                                            FROM     SCM_ITEM_M_SN IM WITH(NOLOCK)
                                                            WHERE    1=1
                                                            AND      ISNULL(IM.DOE, '') != ''
                                                            GROUP BY IM.COMPANY_ID, IM.DIVISION_ID, IM.ITEM_ID, IM.DOE )
                            , INVENTORY AS (SELECT S.COMPANY_ID, S.DIVISION_ID, S.ITEM_ID, ITM.DOE
                                                                , S.QTY, S.COST
                                                                , ROW_NUMBER()OVER(PARTITION BY S.DIVISION_ID, ITM.DOE ORDER BY S.QTY DESC) AS RNK
                                                            FROM (  SELECT   S.COMPANY_ID, S.DIVISION_ID, S.ITEM_ID
                                                                            ,SUM(S.QUANTITY) AS QTY
                                                                            ,SUM(S.AMOUNT_KRW) / SUM(S.QUANTITY) AS COST
                                                                    FROM     SCP_ANL_MONTH_END_STOCK_R S WITH(NOLOCK)
                                                                    WHERE    S.YYYYMM       = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)
                                                                    AND      S.AMOUNT_KRW  <> 0
                                                                    GROUP BY S.COMPANY_ID, S.DIVISION_ID, S.ITEM_ID
                                                                ) S
                                                            INNER JOIN ITEM_M ITM
                                                                ON  ITM.DIVISION_ID  = S.DIVISION_ID
                                                                AND ITM.ITEM_ID      = S.ITEM_ID
																AND ITM.COMPANY_ID   = S.COMPANY_ID)                                  
                            ,COST AS ( SELECT   DISTINCT 
												S.COMPANY_ID
                                                ,S.ORIGIN_DIVISION_ID
                                                ,INV.ITEM_ID      AS INV_ITEM_ID
                                                ,S.ITEM_ID        AS ITEM_ID
                                                ,S.ORIGIN_ITEM_ID AS ORIGIN_ITEM_ID
                                                ,INV.COST         AS DOE_COST
                                        FROM    SCM_LGTM_INV_PSI_SUMMARY S WITH(NOLOCK)
                                                INNER JOIN ITEM_M ITM
                                                    ON  ITM.DIVISION_ID  = S.DIVISION_ID
                                                    AND ITM.ITEM_ID      = S.ITEM_ID
													AND ITM.COMPANY_ID   = S.COMPANY_ID
                                                LEFT OUTER JOIN INVENTORY INV
                                                    ON  S.ORIGIN_DIVISION_ID = INV.DIVISION_ID
                                                    and ITM.DOE              = INV.DOE
													AND ITM.COMPANY_ID		 = INV.COMPANY_ID
                                                    and INV.RNK              = 1
                                        WHERE   1=1
                                        AND     S.PLAN_START_YYYYMMDD      = @v_plan_start_yyyymmdd
                                        AND     S.PLAN_TP_CD               = @v_plan_tp_cd
                                        AND     S.DIVISION_ID              = @v_division_id
                                        AND     INV.ITEM_ID IS NOT NULL
                                        AND     S.STANDARD_COST IS NULL
                                        
                                    )
                    UPDATE  SCM_LGTM_INV_PSI_SUMMARY
                    SET      CURRENCY       = 'KRW'
                            ,STANDARD_COST  = ( SELECT COST.DOE_COST
                                                FROM   COST
                                                WHERE  COST.ORIGIN_DIVISION_ID  = SCM_LGTM_INV_PSI_SUMMARY.ORIGIN_DIVISION_ID
                                                AND    COST.ITEM_ID             = SCM_LGTM_INV_PSI_SUMMARY.ITEM_ID
                                                AND    COST.ORIGIN_ITEM_ID      = SCM_LGTM_INV_PSI_SUMMARY.ORIGIN_ITEM_ID
												AND    COST.COMPANY_ID			= SCM_LGTM_INV_PSI_SUMMARY.COMPANY_ID
                                                )
                            ,CST_CTN        = CONCAT(CST_CTN, N'||2nd DOE 단가')
                    WHERE   1=1
                    AND     PLAN_START_YYYYMMDD      = @v_plan_start_yyyymmdd
                    AND     PLAN_TP_CD               = @v_plan_tp_cd
                    AND     ORIGIN_DIVISION_ID              = @v_division_id
                    AND     STANDARD_COST              IS NULL
                    AND     DATA_TP_CD                 != 'RESULT'
                END    
        END
        ------------------------------------------------------------------------
		-- Step 4-3.3 Item Master의 Standard Cost 사용. 동일 Company 기준.
		------------------------------------------------------------------------
        BEGIN
            --Cost.
            WITH COST AS (SELECT NOCOST.ORIGIN_DIVISION_ID
                                ,NOCOST.ITEM_ID
                                ,NOCOST.ORIGIN_ITEM_ID
                                ,NOCOST.SCM_SITE_ID
                                ,SMS.COMPANY_ID
                                ,SIM.CURRENCY
                                ,SIM.STANDARD_COST
                                ,CUR.EX_TO_BAMT
                                ,SIM.STANDARD_COST * (CASE WHEN SIM.CURRENCY = 'KRW' THEN 1 ELSE CUR.EX_TO_BAMT END) AS KRW_STANDARD_COST
                        FROM   (SELECT COMPANY_ID, ORIGIN_DIVISION_ID, ITEM_ID, ORIGIN_ITEM_ID, MAX(SCM_SITE_ID) SCM_SITE_ID
                                FROM   SCM_LGTM_INV_PSI_SUMMARY SUM WITH(NOLOCK)
                                WHERE  SUM.PLAN_START_YYYYMMDD      = @v_plan_start_yyyymmdd
                                AND    SUM.PLAN_TP_CD               = @v_plan_tp_cd
                                AND    SUM.ORIGIN_DIVISION_ID              = @v_division_id
                                AND    ISNULL(SUM.STANDARD_COST, 0) = 0
                                GROUP BY COMPANY_ID, ORIGIN_DIVISION_ID, ITEM_ID, ORIGIN_ITEM_ID) NOCOST
                                LEFT OUTER JOIN SCM_MST_SITE SMS WITH(NOLOCK)
                                    ON  SMS.DIVISION_ID = NOCOST.ORIGIN_DIVISION_ID
                                    AND SMS.SCM_SITE_ID = NOCOST.SCM_SITE_ID
									AND SMS.COMPANY_ID  = NOCOST.COMPANY_ID
                                LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
                                    ON  SIM.DIVISION_ID = NOCOST.ORIGIN_DIVISION_ID
                                    AND SIM.COMPANY_ID  = SMS.COMPANY_ID
                                    AND SIM.ITEM_ID     = NOCOST.ITEM_ID
                                LEFT OUTER JOIN (SELECT DISTINCT WAERS, EX_TO_BAMT
                                                FROM   SCP_ANL_LONG_TERM_STOCK WITH(NOLOCK)
                                                WHERE  YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)) CUR
                                    ON CUR.WAERS = SIM.CURRENCY
                        WHERE   1=1
                        AND     ISNULL(NOCOST.SCM_SITE_ID, '')  != ''
                        AND     ISNULL(SIM.STANDARD_COST, 0)    != 0
                            )
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY
            SET      CURRENCY       = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST.KRW_STANDARD_COST
                                        FROM   COST
                                        --WHERE  COST.DIVISION_ID     = SCM_LGTM_INV_PSI_SUMMARY.DIVISION_ID
                                        WHERE  COST.ORIGIN_DIVISION_ID  = SCM_LGTM_INV_PSI_SUMMARY.ORIGIN_DIVISION_ID
                                        AND    COST.ITEM_ID             = SCM_LGTM_INV_PSI_SUMMARY.ITEM_ID
                                        AND    COST.ORIGIN_ITEM_ID      = SCM_LGTM_INV_PSI_SUMMARY.ORIGIN_ITEM_ID
										AND    COST.COMPANY_ID			= SCM_LGTM_INV_PSI_SUMMARY.COMPANY_ID
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||3rd 표준단가')
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     ORIGIN_DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     STANDARD_COST              IS NULL
            --AND     ISNULL(STANDARD_COST, 0)    = 0
            AND     DATA_TP_CD                 != 'RESULT'
        END


        


        ------------------------------------------------------------------------------------------
		-- Step 4-3.4 Item Master의 Standard Cost 사용. Company 조건 제외하고 KRW 반영 기준 최저단가.
		------------------------------------------------------------------------------------------
        BEGIN
            --Cost.
            WITH COST AS (  --SELECT  SUM.DIVISION_ID, SUM.ITEM_ID, SUM.ORIGIN_ITEM_ID
                            SELECT  SUM.COMPANY_ID, SUM.ORIGIN_DIVISION_ID, SUM.ITEM_ID, SUM.ORIGIN_ITEM_ID
                                    ,   (   SELECT TOP 1 M.STANDARD_COST * (CASE WHEN M.CURRENCY = 'KRW' THEN 1 ELSE CUR.EX_TO_BAMT END)
                                            FROM   SCM_ITEM_M_SN M WITH(NOLOCK)
                                            LEFT OUTER JOIN (   SELECT DISTINCT WAERS, EX_TO_BAMT
                                                                FROM   SCP_ANL_LONG_TERM_STOCK WITH(NOLOCK)
                                                                WHERE  YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(@v_basis_yyyymm, '01'))),112),1,6)) CUR
                                                ON  CUR.WAERS = M.CURRENCY
                                            --WHERE   M.DIVISION_ID               = SUM.DIVISION_ID
                                            WHERE   M.DIVISION_ID               = SUM.ORIGIN_DIVISION_ID
                                            AND     M.ITEM_ID                   = SUM.ITEM_ID
                                            and     ISNULL(M.STANDARD_COST, 0) <> 0
                                            ORDER BY 1 ASC
                                        ) AS KRW_STANDARD_COST
                            FROM    SCM_LGTM_INV_PSI_SUMMARY SUM WITH(NOLOCK)
                            WHERE   1=1 
                            AND     SUM.PLAN_TP_CD                  = @v_plan_tp_cd
                            AND     SUM.PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
                            AND     SUM.ORIGIN_DIVISION_ID                 = @v_division_id
                            --AND     ISNULL(SUM.STANDARD_COST, 0)    = 0
                            AND     SUM.STANDARD_COST               IS NULL
                            --GROUP BY SUM.DIVISION_ID, SUM.ITEM_ID, SUM.ORIGIN_ITEM_ID
                            GROUP BY SUM.COMPANY_ID, SUM.ORIGIN_DIVISION_ID, SUM.ITEM_ID, SUM.ORIGIN_ITEM_ID
                            )
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY
            SET      CURRENCY       = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST.KRW_STANDARD_COST
                                        FROM   COST
                                        --WHERE  COST.DIVISION_ID     = SCM_LGTM_INV_PSI_SUMMARY.DIVISION_ID
                                        WHERE  COST.ORIGIN_DIVISION_ID  = SCM_LGTM_INV_PSI_SUMMARY.ORIGIN_DIVISION_ID
                                        AND    COST.ITEM_ID             = SCM_LGTM_INV_PSI_SUMMARY.ITEM_ID
                                        AND    COST.ORIGIN_ITEM_ID      = SCM_LGTM_INV_PSI_SUMMARY.ORIGIN_ITEM_ID
										AND    COST.COMPANY_ID			= SCM_LGTM_INV_PSI_SUMMARY.COMPANY_ID
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||4th MIN_표준단가')
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     ORIGIN_DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     STANDARD_COST              IS NULL
            --AND     ISNULL(STANDARD_COST, 0)    = 0
            --AND     DATA_TP_CD                 != 'RESULT'
        END
        
        ------------------------------------------------------------------------------------------
		-- Step 4-3.5 최저판가 기준으로 한번 더 업데이트.
		------------------------------------------------------------------------------------------
        BEGIN
            WITH VER AS (
                           SELECT   MAX(VERSION_NO) AS VERSION_NO
                            FROM    DM_MST_VERSION V WITH(NOLOCK)
                                    ,(  SELECT    CAL2.BASIS_YYYYMMDD
                                        FROM      SCM_SYS_CALENDAR_M CAL1  WITH(NOLOCK) 
                                                , SCM_SYS_CALENDAR_M CAL2  WITH(NOLOCK) 
                                        WHERE   1=1
                                        AND     CAL1.ISO_YYYYWW      = CAL2.ISO_YYYYWW
                                        AND     CAL1.BASIS_YYYYMMDD  = @v_plan_start_yyyymmdd
                                    ) CAL
                            WHERE  1=1
                            AND    V.YYYYMMDD       = CAL.BASIS_YYYYMMDD 
                            AND    V.VERSION_TYPE   = 'SP_W' -- SALES PRICE는 SP_W에서 CONFIRM.
                            AND    V.DIVISION_ID LIKE CONCAT(@v_division_id, '%')
                        )
            , COST AS (
                        SELECT   NOCOST.COMPANY_ID, NOCOST.ORIGIN_DIVISION_ID, NOCOST.ITEM_ID, NOCOST.ORIGIN_ITEM_ID
                                , MIN(T.PRICE) AS KRW_SALES_COST
                        FROM    (   SELECT COMPANY_ID, ORIGIN_DIVISION_ID, ITEM_ID, ORIGIN_ITEM_ID
                                    FROM   SCM_LGTM_INV_PSI_SUMMARY SUM WITH(NOLOCK)
                                    WHERE  1=1 
                                    AND    SUM.PLAN_TP_CD               = @v_plan_tp_cd
                                    AND    SUM.ORIGIN_DIVISION_ID              = @v_division_id
                                    AND    SUM.PLAN_START_YYYYMMDD      = @v_plan_start_yyyymmdd
                                    --AND    ISNULL(SUM.STANDARD_COST, 0) = 0
                                    AND    SUM.STANDARD_COST IS NULL
                                    GROUP BY COMPANY_ID, ORIGIN_DIVISION_ID, ITEM_ID, ORIGIN_ITEM_ID) NOCOST
                        INNER JOIN SCM_MST_FUTURE_PRICE_C T WITH(NOLOCK)
                            ON  T.DIVISION_ID   = NOCOST.ORIGIN_DIVISION_ID
                            AND T.ITEM_ID       = NOCOST.ITEM_ID
                            AND T.MEASURE       = 'KRW'
                        INNER JOIN VER V
                            ON  V.VERSION_NO    = T.VERSION_NO
                        WHERE   1=1
                        GROUP BY NOCOST.COMPANY_ID, NOCOST.ORIGIN_DIVISION_ID, NOCOST.ITEM_ID, NOCOST.ORIGIN_ITEM_ID
                        )
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY
            SET     CURRENCY       = 'KRW'
                    ,STANDARD_COST  = ( SELECT COST.KRW_SALES_COST
                                        FROM   COST
                                        --WHERE  COST.DIVISION_ID     = SCM_LGTM_INV_PSI_SUMMARY.DIVISION_ID
                                        WHERE  COST.ORIGIN_DIVISION_ID  = SCM_LGTM_INV_PSI_SUMMARY.ORIGIN_DIVISION_ID
                                        AND    COST.ITEM_ID             = SCM_LGTM_INV_PSI_SUMMARY.ITEM_ID
                                        AND    COST.ORIGIN_ITEM_ID      = SCM_LGTM_INV_PSI_SUMMARY.ORIGIN_ITEM_ID
										AND    COST.COMPANY_ID			= SCM_LGTM_INV_PSI_SUMMARY.COMPANY_ID
                                        )
                    ,CST_CTN        = CONCAT(CST_CTN, N'||5th MIN_판가')
            WHERE   1=1
            AND     PLAN_TP_CD                  = @v_plan_tp_cd
            AND     ORIGIN_DIVISION_ID                 = @v_division_id
            AND     PLAN_START_YYYYMMDD         = @v_plan_start_yyyymmdd
            AND     STANDARD_COST              IS NULL
            --AND     ISNULL(STANDARD_COST, 0)    = 0
            AND     DATA_TP_CD                 != 'RESULT'
        END

        ------------------------------------------------------------------------
		-- Exception Logic
        -- Group_Code1 = 'N32S' 면 지정단가로 업데이트.
		------------------------------------------------------------------------
        BEGIN
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY
            SET     STANDARD_COST = 95091
                    ,CST_CTN        = N'N32S||지정단가 업데이트'
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     ORIGIN_DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DATA_TP_CD         != 'RESULT'
            AND     GROUP_CODE1         = 'N32S'
        END

        ------------------------------------------------------------------------
		-- Step 4-4 Amount 업데이트. 4-3에서 적용한 단가 기준.
		------------------------------------------------------------------------
        BEGIN
            UPDATE  SCM_LGTM_INV_PSI_SUMMARY
            SET     AMT     = STANDARD_COST * QTY
            WHERE   1=1 
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     ORIGIN_DIVISION_ID         = @v_division_id
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
        END

        IF OBJECT_ID (N'tempdb..#TEMP_END_INV_COST', N'U') IS NOT NULL 		DROP TABLE #TEMP_END_INV_COST;
                
        -- [E20250310-000014] #LONG_TERM_TYPE 임시테이블 삭제
        IF OBJECT_ID('tempdb..#TMP_LONG_TERM_TYPE') IS NOT NULL
            DROP TABLE #TMP_LONG_TERM_TYPE;

        IF LEFT(@v_division_id, 2) = '81' 
		BEGIN
		 SET @v_division_id = '81'
		END


        EXEC PR_SCM_LGTM_INV_ALLOCATION_IGR @v_gr_cd, @v_plan_tp_cd, @v_division_id, @v_plan_start_yyyymmdd, @v_basis_yyyymm;  -- jjg
--JJG임시로막음        EXEC PR_SCM_LGTM_INV_ALLOCATION_IGR @v_gr_cd, @v_plan_tp_cd, @v_division_id, @v_plan_start_yyyymmdd, @v_basis_yyyymm;

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
     -- exec PR_SCM_LGTM_INV_ALLOCATION_CAL_OIJ_jjg 'FERT', '40', '20250303', '202503'
--select 'jjgAA111'
--return
--select 'jjgBB122'  

  END;
