/*
 **************************************************************************************************
 * Program ID  : [DMF0051_1_BIZPLAN_TO_BPS]
 * Description : Procedure 작성 가이드                                                              
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                    
 *                                                                                                  
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description                                                             
 *--------------------------------------------------------------------------------------------------
 * 2023/07/19	CHANO0612	사업계획 프로젝트
 * 2023/09/23	chano0612	사업계획3차 수정[VERSION_NO Naming Rule]
 * 2023.09.23	chano0612	사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP1 ==> ATTRIBUTE5 추가, APPLICATION_GROUP 컬럼생성
 * 2023.09.24	chano0612	사업계획3차 수정[Product Gr.(Report)] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP3 ==> ATTRIBUTE6 추가
 * 2023.09.24	chano0612	사업계획3차 수정[Product Details.(Report)] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP4 ==> ATTRIBUTE7 추가
 * 2024.04.17	KJJ			METAL_LINK_YN 컬럼 ISNULL 처리
 **************************************************************************************************
*/
CREATE PROCEDURE [dbo].[DMF0051_1_BIZPLAN_TO_BPS]
--DECLARE
    @p_division_id              NVARCHAR(30),
	@p_version_no               NVARCHAR(30)
AS
/*
  EXEC DMF0051_1_BIZPLAN_TO_BPS @p_division_id=N'81', @p_version_no = N'25BP_DM_2024_W16_V04' 
*/

BEGIN

	SET @p_version_no = SUBSTRING(@p_version_no, 1, 20)
	PRINT @p_version_no
	DECLARE @V_PERIOD_YYYYMM NVARCHAR(6);
	DECLARE @V_PLAN_ID       NVARCHAR(30);
	DECLARE @V_WORK_YYYYMMDD NVARCHAR(30);

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch';
    DECLARE @v_program_name NVARCHAR(150) = N'DMF0051_1_BIZPLAN_TO_BPS';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_KPI_SUMMARY/DETAIL'; 
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @p_division_id + ':' + @p_version_no + ':' +  N' XIF_DM_PLN_BIZPLAN_S_SN';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;

 BEGIN TRY

     print 'A_01--' + convert(varchar(30), getdate(), 121)

	SET @V_WORK_YYYYMMDD = convert(char(8), getdate(), 112);
	
     print 'A_01_01--' + convert(varchar(30), getdate(), 121)

	SELECT @V_PLAN_ID = MAX(PLAN_ID) FROM SCP_ANL_BUSINESS_PLAN_RTF_DM WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id;

	
     print 'A_01_02--' + convert(varchar(30), getdate(), 121)

	SELECT @V_PERIOD_YYYYMM = PLAN_START_DATE FROM SCP_ANL_BUSINESS_PLAN_INFO WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND PLAN_ID = SUBSTRING(@v_PLAN_ID, 1, LEN(@v_PLAN_ID)-4) --SUBSTRING(@v_PLAN_ID, 1, 12);
	
     print 'A_01_03--' + convert(varchar(30), getdate(), 121)

	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V

	SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP
		,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,CELL_TYPE,ENERGE, CELL_QUANTITY 
	INTO #TEMP_DM_MST_ITEM_SINGLE_V
	FROM DM_MST_ITEM_SINGLE_V T2 WITH(NOLOCK)
	INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split('',',') ) b
							ON	T2.ITEM_ID		like  b.tst 
							OR	T2.NICK_NAME	like  b.tst 						
	WHERE DIVISION_ID = @p_division_id					
	GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP
			,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,CELL_TYPE,ENERGE, CELL_QUANTITY

     print 'A_02--' + convert(varchar(30), getdate(), 121)

	BEGIN
		DELETE FROM XIF_DM_PLN_BIZPLAN_S_SN WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @p_version_no
		
     print 'A_02_01--' + convert(varchar(30), getdate(), 121)+@p_division_id +@p_version_no
  
		INSERT INTO  XIF_DM_PLN_BIZPLAN_S_SN
			(DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPT_ID
			,DEPT_NAME_KO
			,SCM_SITE_ID,CUSTOMER_CODE
			,END_CUSTOMER,END_CUSTOMER_NAME
			,SOLDTO_CODE,SOLDTO_NAME,SHIPTO_CODE,SHIPTO_NAME,CITY,COUNTRY
			,PROJECT_CODE,PROJECT_NAME,BIZ_TYPE,BIZ_TYPE_NAME,ITEM_ID,ITEM_NICK_NAME,ITEM_TYPE,CELL_CODE
			,CELL_NICK_NAME,CELL_CAPA,CELL_PER_MODULE,MODULE_PER_PACK,CELL_PER_PACK,PRODUCT_GROUP,PRODUCT_GROUP_NAME
			,COMPANY_NAME,ALT_SIM_YN,P_BOM,CURRENCY,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID,EXT_INT,MEASURE,YYYYMM,QTY,PERIOD_YYYYMM
			,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,OTHER_PRICE,TOTAL_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,PLANT_CODE,OSP_YN,PRODUCT_CORP_ID,APPLICATION_GROUP
			,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
			)   
		SELECT 
				DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPT_ID
				, (SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE DEPT_ID = A.DEPT_ID) DEPT_NAME_KO
				,SCM_SITE_ID
				,SOLDTO_CODE SOLDTO_CUSTOMER
				,END_CUSTOMER,END_CUSTOMER
				,SOLDTO_CODE
				,(SELECT TOP 1 SOLDTO_DESCRIPTION FROM SCM_MST_CUSTOMER WITH(NOLOCK) WHERE DIVISION_ID = A.DIVISION_ID AND SOLDTO_CODE = A.SOLDTO_CODE AND VALID_YN = 'Y') SOLDTO_NAME
				,SHIPTO_CODE
				,(SELECT TOP 1 SHIPTO_DESCRIPTION FROM SCM_MST_CUSTOMER WITH(NOLOCK) WHERE DIVISION_ID = A.DIVISION_ID AND SHIPTO_CODE = A.SHIPTO_CODE AND VALID_YN = 'Y') SHIPTO_NAME
				,(SELECT CITY FROM SCM_MST_SITE WITH(NOLOCK) WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = A.SCM_SITE_ID AND SITE_TYPE = 'SALES' AND VALID_YN = 'Y') CITY
				,(SELECT COUNTRY FROM SCM_MST_SITE WITH(NOLOCK) WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = A.SCM_SITE_ID AND SITE_TYPE = 'SALES' AND VALID_YN = 'Y') COUNTRY
				,PROJECT_CODE,PROJECT_NAME,BIZ_TYPE,BIZ_TYPE_NAME,ITEM_ID
				,(SELECT ITEM_NAME FROM #TEMP_DM_MST_ITEM_SINGLE_V WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND ITEM_ID = A.ITEM_ID) ITEM_NICK_NAME
				,(SELECT ITEM_TYPE FROM #TEMP_DM_MST_ITEM_SINGLE_V WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND ITEM_ID = A.ITEM_ID) ITEM_TYPE
				,CELL_CODE
				,(SELECT ISNULL(NICK_NAME,'') FROM #TEMP_DM_MST_ITEM_SINGLE_V WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND ITEM_ID = A.ITEM_ID) CELL_NICK_NAME
				--,CONVERT(NUMERIC(20, 10), (SELECT ISNULL(MIN_CAPACITY,0) FROM #TEMP_DM_MST_ITEM_SINGLE_V WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND ITEM_ID = A.ITEM_ID)) CELL_CAPA
				,0 CELL_CAPA
				,CONVERT(NUMERIC(20, 10), ISNULL(CELL_PER_MODULE, 0)) 
				,CONVERT(NUMERIC(30, 10), ISNULL(MODULE_PER_PACK, 0)) 
				,CONVERT(NUMERIC(30, 10), ISNULL(CELL_PER_PACK, 0)) 
				,PRODUCT_GROUP
				,PRODUCT_GROUP_NAME --(SELECT ISNULL(PRODUCT_GROUP,'') FROM #TEMP_DM_MST_ITEM_SINGLE_V WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND ITEM_ID = A.ITEM_ID) PRODUCT_GROUP_NAME
				,(SELECT TOP 1 sales_company FROM SCM_MST_SITE_ITEM WITH(NOLOCK) 
				  WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID AND VALID_YN = 'Y' AND PROJECT_CODE = A.PROJECT_CODE
				 ) COMPANY_NAME
				,ALT_SIM_YN,'' AS P_BOM,CURRENCY,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID,EXT_INT,MEASURE,YYYYMM
				,CONVERT(NUMERIC(30, 10), ISNULL(QTY, 0)) QTY,@V_PERIOD_YYYYMM AS PERIOD_YYYYMM
				,SCENARIO_TYPE
				,CONVERT(NUMERIC(30, 10), ISNULL(BASE_PRICE, 0)) BASE_PRICE
				,CONVERT(NUMERIC(30, 10), ISNULL(METAL_LINK_PRICE, 0)) METAL_LINK_PRICE
				,CONVERT(NUMERIC(30, 10), ISNULL(OTHER_PRICE, 0)) OTHER_PRICE
				,CONVERT(NUMERIC(30, 10), ISNULL(TOTAL_PRICE, 0)) TOTAL_PRICE
				,ISNULL(METAL_LINK_YN, 'N')
				,WORK_YYYYMMDD
				,PLANT_CODE
				,OSP_YN
				,PRODUCT_CORP_ID
				,APPLICATION_GROUP
				,'SYSTEM', GETDATE(),'SYSTEM', GETDATE()
		FROM 
		  (SELECT 
				VERSION_NO
				,CUTOFF_TYPE
				,CUTOFF_YYYYMMDD
				,DIVISION_ID
				,DEPT_ID
				,PROJECT_CODE		   
				,SCM_SITE_ID		   
				,ITEM_ID			   
				,END_CUSTOMER
				,(SELECT TOP 1 SOLDTO_CODE FROM SCM_MST_SITE_CUSTOMER WITH(NOLOCK) WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = A.SCM_SITE_ID AND VALID_YN = 'Y' AND REP_YN = 'Y') SOLDTO_CODE
				,(SELECT TOP 1 SHIPTO_CODE FROM SCM_MST_SITE_CUSTOMER WITH(NOLOCK) WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = A.SCM_SITE_ID AND VALID_YN = 'Y' AND REP_YN = 'Y') SHIPTO_CODE
				,BIZ_TYPE
				,ISNULL((SELECT TOP 1 BIZ_TYPE_NAME FROM SCM_MST_PROJECT WITH(NOLOCK) WHERE DIVISION_ID = A.DIVISION_ID AND BIZ_TYPE = A.BIZ_TYPE)
					   , BIZ_TYPE) AS BIZ_TYPE_NAME
				,PLANT_SITE_ID
				,FCST_TYPE
				,DOM_EXP
				,INCOTERMS
				,ITEM_USE
				,UNIT_ENERGY
				,CURRENCY
				,MEASURE
				,YYYYMM
				,QTY
				,PROJECT_NAME
				,CELL_PROD_SITE
				,EE_CORP_ID
				,CELL_CORP_ID
				,PACK_CORP_ID
				,EXT_INT
--사업계획3차 수정[Product Gr.(Report)] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP3 ==> ATTRIBUTE6 추가[START]
				,ATTRIBUTE6 PRODUCT_GROUP
--사업계획3차 수정[Product Gr.(Report)] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP3 ==> ATTRIBUTE6 추가[END]
--사업계획3차 수정[Product Details.(Report)] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP4 ==> ATTRIBUTE7 추가[START]
				,ATTRIBUTE7 PRODUCT_GROUP_NAME
--사업계획3차 수정[Product Details.(Report)] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP4 ==> ATTRIBUTE7 추가[END]
				,ALT_SIM_YN
				,CELL_CODE
				,CELL_PER_MODULE
				,MODULE_PER_PACK
				,CELL_PER_PACK--CASE WHEN DIVISION_ID = '40' THEN ATTRIBUTE8 ELSE CELL_PER_PACK END CELL_PER_PACK				
				,PERIOD_YYMM
				,SCENARIO_TYPE
				,BASE_PRICE
				,METAL_LINK_PRICE
				,OTHER_PRICE
				,CASE WHEN DIVISION_ID LIKE '81%' THEN ROUND(TOTAL_PRICE, 2) WHEN DIVISION_ID = '82' THEN ROUND(TOTAL_PRICE, 3) ELSE TOTAL_PRICE END TOTAL_PRICE
				,METAL_LINK_YN
				,@V_WORK_YYYYMMDD AS WORK_YYYYMMDD
				,OSP_YN
				, ATTRIBUTE1 PLANT_CODE
				, ATTRIBUTE2 PRODUCT_CORP_ID
--사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP1 ==> ATTRIBUTE5 추가, APPLICATION_GROUP 컬럼생성[START]
				, ATTRIBUTE5 APPLICATION_GROUP
--사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP1 ==> ATTRIBUTE5 추가, APPLICATION_GROUP 컬럼생성[END]
			FROM  DM_PLN_BIZPLAN_C A WITH(NOLOCK)
			WHERE DIVISION_ID = @p_division_id 
			AND   VERSION_NO  = @p_version_no
			AND   MEASURE     = 'Business_Plan_Conf'
			) A

        SET @n_log_count = @@ROWCOUNT;
     print 'A_03--' + convert(varchar(30), getdate(), 121)+ CONVERT(VARCHAR, @n_log_count)
	END

	
     print 'A_03--' + convert(varchar(30), getdate(), 121)

	BEGIN
		UPDATE XIF_DM_PLN_BIZPLAN_S_SN SET APPLICATION_GROUP = A.REPORT_GROUP1, PRODUCT_GROUP = A.REPORT_GROUP3, PRODUCT_GROUP_NAME = A.REPORT_GROUP4
		FROM SCM_MST_SITE_ITEM A
		WHERE XIF_DM_PLN_BIZPLAN_S_SN.DIVISION_ID = A.DIVISION_ID
		AND XIF_DM_PLN_BIZPLAN_S_SN.PROJECT_CODE = A.PROJECT_CODE
		AND XIF_DM_PLN_BIZPLAN_S_SN.SCM_SITE_ID = A.SCM_SITE_ID
		AND XIF_DM_PLN_BIZPLAN_S_SN.ITEM_ID = A.ITEM_ID
		AND XIF_DM_PLN_BIZPLAN_S_SN.DIVISION_ID = @p_division_id
		AND XIF_DM_PLN_BIZPLAN_S_SN.VERSION_NO = @p_version_no
	END

	BEGIN
		UPDATE DM_PLN_BIZPLAN_C SET TRANSFER_FLAG = 'Y' 
		WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @p_version_no
	END
	
	SELECT 'SUCCESS'

    -----------------------------------------------------------
    -- 실행 Logic END --
    -----------------------------------------------------------
    -- TXN LOG
    SET @v_log_type = N'TXN';    
    SET @v_log_message = N'INSERT INTO '+@v_table_id;
    SET @v_description = @p_division_id + N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

END TRY

    BEGIN CATCH        
      
      -- ERROR LOG
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

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = @p_division_id;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    return 1 

    _RETURN_ERR_CODE:          
        BEGIN          
             RETURN -1          
        END;  
END
