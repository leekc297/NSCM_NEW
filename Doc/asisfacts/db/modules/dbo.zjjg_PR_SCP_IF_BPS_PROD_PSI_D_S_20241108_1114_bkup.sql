

/*******************************************************************************************************************                      
 * Program ID   : PR_SCP_IF_BPS_PROD_PSI_D_S                        
 * Description  : [재료비 TASK] BPS Interface
 * OutTable     : XIF_BPS_PROD_PSI_D_S_SN                     
 * Execute      : 전 사업부 일괄 전송
                  EXEC PR_SCP_IF_BPS_PROD_PSI_D_S
                       @p_division_id         = NULL
                     , @p_plan_start_yyyymmdd = '20240527'
                  
 * Program History                      
 *===================================================================================================                      
 *   Date       In Charge      Description                      
 *===================================================================================================                      
 * 2024.05.28   lgjjg          Initial PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 통합 integration BPS로 Interface 
 * 2024.10.28   lgjjg          소형 pack packer별 suffix 추가               
 *******************************************************************************************************************/                    
                    
-- exec PR_SCP_IF_BPS_PROD_PSI_D_S '81', '20240527'
-- exec PR_SCP_IF_BPS_PROD_PSI_D_S '81_UC', '20240527'

create PROCEDURE [dbo].[zjjg_PR_SCP_IF_BPS_PROD_PSI_D_S_20241108_1114_bkup]
(                         
      @p_division_id          NVARCHAR(30)
    , @p_plan_start_yyyymmdd  NVARCHAR(8)
)                         
AS                        
  BEGIN 
  
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;                        
    SET NOCOUNT ON;                        
    SET XACT_ABORT ON;                        
    SET ANSI_WARNINGS OFF;                        
                        
    -- LOG 용 변수 설정                        
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';      
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_IF_BPS_PROD_PSI_D_S';                        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...                        
    DECLARE @n_log_count    INTEGER = 0;                        
    DECLARE @v_log_message  NVARCHAR(1000);                        
    DECLARE @v_description  NVARCHAR(500);            
    DECLARE @v_table_id     NVARCHAR(150) = N'XIF_BPS_PROD_PSI_D_S_SN';                         
    DECLARE @d_event_date   DATETIME;                        

    -- 시작 LOG                        
    SET @v_log_type     = N'START';                        
    SET @v_log_message  = N'########## Start of procedure ##########';
    SET @v_description  = @v_program_name + ':' + @v_table_id + N' INSERT LOGIC';
    SET @d_event_date   = SYSDATETIME();                        
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                        
                              ,@p_log_type      =@v_log_type                        
                              ,@p_log_count     =@n_log_count                         
                              ,@p_log_message   =@v_log_message                         
                              ,@p_description   =@v_description                         
                              ,@p_event_date    =@d_event_date                         
                              ,@p_user_id       =@v_batch_user                        
                              ;                        
    -- 임시 실행시간 확인용                
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();                
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';         

	-- SCP 계힉 참조를 위한 변수
	DECLARE @V_DIVISION_ID		        NVARCHAR(10)	= NULL;  --  전 사업부 일괄 전송 -- ISNULL(@p_division_id, '81');
	DECLARE @V_PLAN_START_YYYYMMDD		NVARCHAR(8)		= ISNULL(@p_plan_start_yyyymmdd, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112));
	
   BEGIN TRY                        
		BEGIN  
		    -- Version용 Seq 정보
			DECLARE @ver NVARCHAR(3)

			SELECT @ver = FORMAT(ISNULL( (SELECT MAX(RIGHT(SCP_VERSION_CD,2))
										  FROM   XIF_BPS_PROD_PSI_D_S_SN
										  WHERE  WORK_YYYYMMDD = @V_PLAN_START_YYYYMMDD),0) +1, '00')


			INSERT INTO XIF_BPS_PROD_PSI_D_S_SN
			(
				PLN_PERIOD_YYYYMM, SCP_VERSION_CD, BKT_WEEK, WORK_YYYYMMDD, SALES_VERSION_CD, DIV_CD, OVSENTT_CD, PLNT_CD, BUILDING, LINE_ID
              , OPERATION_GROUP, VALUATION_TYPE, MODEL, TO_SITE, TO_PRODUCT, INCOTERMS, UNIT, MEASURE, YYYYMM, QTY
              , ATTRIBUTE1_VALUE, ATTRIBUTE2_VALUE, ATTRIBUTE3_VALUE, ATTRIBUTE4_VALUE, ATTRIBUTE5_VALUE
              , CREATION_DATE, TRANSF_DATE, TRANSF_FLAG
              , ETL_LOAD_DATE, VALUE_TBL_INFO, SRC_SYS_CD
			)						
			SELECT 
				 c.iso_yyyymm          AS PLN_PERIOD_YYYYMM
				,SUBSTRING(iso_yyyymm,3,2) + 'RF_SCP_' + SUBSTRING(iso_yyyymm,1,4) + '_' + week_name + '_' + 'V' + @ver AS SCP_VERSION_CD
				,c.iso_week            AS BKT_WEEK
				,a.PLAN_START_YYYYMMDD AS WORK_YYYYMMDD
				,'*'                   AS SALES_VERSION_CD
				,a.DIVISION_ID         AS DIV_CD
				,a.company_id          AS OVSENTT_CD
				,a.PLANT_ID            AS PLNT_CD
				,ISNULL((SELECT TOP 1 FACTORY_ID FROM SCM_MST_LINE_SN LSN WITH(NOLOCK) WHERE LSN.LINE_ID = A.LINE_ID),'') AS BUILDING
				,a.LINE_ID             AS LINE_ID
				,a.OPERATION_GROUP     AS OPERATION_GROUP
				,CASE WHEN ISNULL(VALUE_TYPE, '-') = '-' THEN '*'
				      ELSE a.VALUE_TYPE
				 END                   AS VALUATION_TYPE
--				,a.item_id             AS MODEL
				,MODEL = (case when a.DIVISION_ID = '40' and a.OPERATION_GROUP = 'P' and x.OSP_YN = 'Y' then left(a.ITEM_ID, len(a.item_id) -1) + x.PACKER_ITEM_ID_SUFFIX else a.item_id end )
				,a.TO_SITE             AS TO_SITE
				,CASE WHEN ISNULL(TO_PRODUCT, '-') = '-' THEN '*'
				      ELSE a.TO_PRODUCT
				 END                   AS TO_PRODUCT
				,a.INCOTERMS           AS INCOTERMS
				,ISNULL((SELECT TOP 1 ITEM_UOM FROM SCM_MST_ITEM_SN ISN WITH(NOLOCK) WHERE ISN.item_id = A.item_id),'EA') AS UNIT
				,md.segment2           AS MEASURE
				,a.YYYYMM              AS YYYYMM
				,a.QTY                 AS QTY
				,a.ATTRIBUTE1          AS ATTRIBUTE1_VALUE
				,a.ATTRIBUTE2          AS ATTRIBUTE2_VALUE
				,a.ATTRIBUTE3          AS ATTRIBUTE3_VALUE
				,a.ATTRIBUTE4          AS ATTRIBUTE4_VALUE
				,a.ATTRIBUTE5          AS ATTRIBUTE5_VALUE
				,GETDATE()             AS CREATION_DATE
				,GETDATE()             AS TRANSF_DATE
				,'N'                   AS TRANSF_FLAG   --'N':생성, 'Y':Transfer Success
				,NULL                  AS ETL_LOAD_DATE
				,NULL                  AS VALUE_TBL_INFO
				,NULL                  AS SRC_SYS_CD
			FROM  SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)

			LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
					   ON  md.lookup_type  = 'BPS_MEASURE'
					   AND md.valid_yn     = 'Y'
					   AND md.segment1     = a.measure

			LEFT OUTER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
					   ON c.basis_yyyymmdd = @V_PLAN_START_YYYYMMDD

			LEFT OUTER JOIN scm_mst_site X WITH(NOLOCK)
					   ON x.division_id = ISNULL(@V_DIVISION_ID, a.DIVISION_ID)
					   and x.PLANT_ID = a.PLANT_ID 
					   and x.OPERATION_GROUP = a.OPERATION_GROUP

			WHERE a.DIVISION_ID         = ISNULL(@V_DIVISION_ID, a.DIVISION_ID)
			AND   a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
			AND   a.MEASURE             <> 'MKT_FCST'
			AND	  not (a.MEASURE  = 'INV' and ISNULL(a.PLANT_ID,'') < '0')  
			and   NOT (a.DIVISION_ID = '82' and seq_flag in ('330','360'))
			-- 최초 M0월 기준 BOH
			UNION ALL
								
			SELECT 
				 c.iso_yyyymm          AS PLN_PERIOD_YYYYMM
				,SUBSTRING(iso_yyyymm,3,2) + 'RF_SCP_' + SUBSTRING(iso_yyyymm,1,4) + '_' + week_name + '_' + 'V' + @ver AS SCP_VERSION_CD
				,c.iso_week            AS BKT_WEEK
				,a.PLAN_START_YYYYMMDD AS WORK_YYYYMMDD
				,'*'                   AS SALES_VERSION_CD
				,a.DIVISION_ID         AS DIV_CD
				,a.company_id          AS OVSENTT_CD
				,a.PLANT_ID            AS PLNT_CD
				,ISNULL((SELECT TOP 1 FACTORY_ID FROM SCM_MST_LINE_SN LSN WITH(NOLOCK) WHERE LSN.LINE_ID = A.LINE_ID),'') AS BUILDING
				,a.LINE_ID             AS LINE_ID
				,a.OPERATION_GROUP     AS OPERATION_GROUP
				,CASE WHEN ISNULL(VALUE_TYPE, '-') = '-' THEN '*'
				      ELSE a.VALUE_TYPE
				 END                   AS VALUATION_TYPE
--				,a.item_id             AS MODEL
				,MODEL = (case when a.DIVISION_ID = '40' and a.OPERATION_GROUP = 'P' and x.OSP_YN = 'Y' then left(a.ITEM_ID, len(a.item_id) -1) + x.PACKER_ITEM_ID_SUFFIX else a.item_id end )
				,a.TO_SITE             AS TO_SITE
				,CASE WHEN ISNULL(TO_PRODUCT, '-') = '-' THEN '*'
				      ELSE a.TO_PRODUCT
				 END                   AS TO_PRODUCT
				,a.INCOTERMS           AS INCOTERMS
				,ISNULL((SELECT TOP 1 ITEM_UOM FROM SCM_MST_ITEM_SN ISN WITH(NOLOCK) WHERE ISN.item_id = A.item_id),'EA') AS UNIT
				,'B_INV'               AS MEASURE  -- BOH
				,a.YYYYMM              AS YYYYMM
				,a.BOH_QTY             AS QTY      -- BOH
				,a.ATTRIBUTE1          AS ATTRIBUTE1_VALUE
				,a.ATTRIBUTE2          AS ATTRIBUTE2_VALUE
				,a.ATTRIBUTE3          AS ATTRIBUTE3_VALUE
				,a.ATTRIBUTE4          AS ATTRIBUTE4_VALUE
				,a.ATTRIBUTE5          AS ATTRIBUTE5_VALUE
				,GETDATE()             AS CREATION_DATE
				,GETDATE()             AS TRANSF_DATE
				,'N'                   AS TRANSF_FLAG   --'N':생성, 'Y':Transfer Success
				,NULL                  AS ETL_LOAD_DATE
				,NULL                  AS VALUE_TBL_INFO
				,NULL                  AS SRC_SYS_CD
			FROM  SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)

			LEFT OUTER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
					   ON c.basis_yyyymmdd = @V_PLAN_START_YYYYMMDD

			LEFT OUTER JOIN scm_mst_site X WITH(NOLOCK)
					   ON x.division_id = ISNULL(@V_DIVISION_ID, a.DIVISION_ID)
					   and x.PLANT_ID = a.PLANT_ID 
					   and x.OPERATION_GROUP = a.OPERATION_GROUP

			WHERE a.DIVISION_ID         = ISNULL(@V_DIVISION_ID, a.DIVISION_ID)
			AND   a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
			AND   a.YYYYMM              = SUBSTRING(@V_PLAN_START_YYYYMMDD,1,6)  --최초 BOH 
			AND   a.MEASURE             = 'INV'
			AND	  not (a.MEASURE  = 'INV' and ISNULL(a.PLANT_ID,'') < '0')  
			and   NOT (a.DIVISION_ID = '82' and seq_flag in ('330','360'))

        -- TXN LOG                 
        SET @n_log_count    = @@ROWCOUNT;            
        SET @v_log_type     = N'TXN';                             
        SET @v_log_message  = N'INSERT INTO '+@v_table_id;
        SET @d_event_date   = SYSDATETIME();
        SET @v_description  = N'Process Complete...' + ':' + @V_PLAN_START_YYYYMMDD;
                        
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                        
                                  ,@p_log_type      =@v_log_type                        
                                  ,@p_log_count     =@n_log_count                         
                                  ,@p_log_message   =@v_log_message                         
                                  ,@p_description   =@v_description                         
                                  ,@p_event_date    =@d_event_date                         
                                  ,@p_user_id       =@v_batch_user     

	 END 

   END TRY

   BEGIN CATCH
        
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
   END CATCH;

    -- 임시 운영반영시에 주석처리 할것.                
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
                                    
    -- 종료 LOG                        
    SET @v_log_type     = N'END';                        
    SET @v_log_message  = N'########## END of procedure ##########';                        
    SET @v_description  = N'[' + @V_PLAN_START_YYYYMMDD + '][' + @v_exec_time + ']';                    
    SET @d_event_date   =  SYSDATETIME()  ;                        

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                        
                              ,@p_log_count     =@n_log_count                         
                              ,@p_log_message   =@v_log_message                         
                              ,@p_description   =@v_description                         
                              ,@p_event_date    =@d_event_date                         
                              ,@p_user_id       =@v_batch_user                        
                             ;                        
    return 1  

end  

