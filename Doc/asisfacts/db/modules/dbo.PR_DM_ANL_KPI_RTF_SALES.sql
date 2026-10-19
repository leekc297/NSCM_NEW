


/*
 * Program ID   : PR_DM_ANL_KPI_RTF_SALES
 * Description  : KPI_RTF_SALES (RTF 준수율, 사업계획 달성율 정보)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021. 07. 26    JSHEO      Initial Release 
 * 2022.04.05		HWI1993 GM	JV 로직 적용
 * 2025.06.23		KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_ANL_KPI_RTF_SALES]

	-- Add the parameters for the stored procedure here
	@p_START_DATE				NVARCHAR(8)	

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_ANL_KPI_RTF_SALES';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 변수
    DECLARE @v_start_week      NVARCHAR(8);
    DECLARE @v_delete_yyyymm   NVARCHAR(6);
	DECLARE @v_plan_delete_yyyymm NVARCHAR(6);

	-- 계획 시작, 종료 구간
    DECLARE @v_period_start_date NVARCHAR(8);


	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION PR_DM_ANL_KPI_RTF_SALES;

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------	


	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                                   매출계획 적확도 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--
	BEGIN
	    -- 1.1 매출 실적 I/F 기준 일자
	    SET @v_start_week      = CASE WHEN ISNULL(@p_START_DATE,'') = '' 
		                              THEN CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 당주 월요일
		                              ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CONVERT(DATETIME, @p_START_DATE), 'MON')), 112)
								 END  -- 해당 일자 월요일

        -- 1.2 매출 삭제 시작 월
	    SET @v_delete_yyyymm   = CASE WHEN ISNULL(@p_START_DATE,'') = '' 
		                              THEN CONVERT(CHAR(6), DATEADD(MM, -2, GETDATE()), 112)
		                              ELSE CONVERT(CHAR(6), DATEADD(MM, -2, CONVERT(DATETIME, @p_START_DATE)), 112)
								 END  -- 당월 기준 2달 전 지난 정보 삭제

        -- 1.3 RTF, BP 삭제 시작 월
	    SET @v_plan_delete_yyyymm   = CASE WHEN ISNULL(@p_START_DATE,'') = '' 
		                                   THEN CONVERT(NVARCHAR(6), GETDATE(), 112)
		                                   ELSE CONVERT(NVARCHAR(6), CONVERT(DATETIME, @p_START_DATE), 112)
								      END  -- 당월 정보 삭제

		-- 1.4 RTF 버전 및 계획 삭제, 시작 일자
		SET @v_period_start_date    = CASE WHEN ISNULL(@p_START_DATE,'') = '' 
		                                   THEN CONVERT(NVARCHAR(6), GETDATE(), 112) + '01'
		                                   ELSE CONVERT(NVARCHAR(6), CONVERT(DATETIME, @p_START_DATE), 112) + '01'
								      END  --계획 시작 구간.


		-- 2.1 매출 삭제
		DELETE FROM DM_ANL_KPI_RTF_SALES WHERE YYYYMM >= @v_delete_yyyymm AND MEASURE = 'SALES';

		-- 2.2 RTF, BP  삭제
		DELETE FROM DM_ANL_KPI_RTF_SALES WHERE YYYYMM >= @v_plan_delete_yyyymm AND MEASURE IN ('RTF', 'BP');

		with plan_and_result as (

		
		
		-- BP CUTOFF 정보
		select  sp.[DIVISION_ID]
			   ,sp.[ITEM_ID]
			   ,sp.[FCST_TYPE]
			   ,sp.YYYYMMDD
			   ,sp.qty  qty
		       ,CASE WHEN sp.YYYYMMDD >= @v_start_week THEN sp.qty ELSE 0 END  acc_qty
			   ,'BP'   MEASURE
		  from dm_pln_sales_plan_c sp WITH(NOLOCK)
			  ,(
				SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
				FROM (
						SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, 
								ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ FROM DM_MST_VERSION
						WHERE  VERSION_TYPE = 'SP_W'
						AND    YYYYMMDD < @v_period_start_date

						) VER
				WHERE VER.SEQ = 1
			) target_version
		 where sp.division_id				= target_version.division_id
		   and sp.version_no				= target_version.version_no
		   and sp.YYYYMMDD               	>= @v_period_start_date
		   and sp.measure					= 'RTF_SYS_RP'
		   and sp.qty                       >= 0 

		UNION ALL

		-- RTF CUTOFF 정보
		select  sp.[DIVISION_ID]
			   ,sp.[ITEM_ID]
			   ,sp.[FCST_TYPE]
			   ,sp.YYYYMMDD
			   ,sp.qty  qty
		       ,CASE WHEN sp.YYYYMMDD >= @v_start_week THEN sp.qty ELSE 0 END  acc_qty
			   ,'RTF'   MEASURE
		  from dm_pln_sales_plan_c sp WITH(NOLOCK)
			  ,(
				SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
				FROM (
						SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, 
								ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ FROM DM_MST_VERSION
						WHERE  VERSION_TYPE = 'SP_W'
						AND    YYYYMMDD < @v_period_start_date

						) VER
				WHERE VER.SEQ = 1
			) target_version
		 where sp.division_id				= target_version.division_id
		   and sp.version_no				= target_version.version_no
		   and sp.YYYYMMDD               	>= @v_period_start_date
		   and sp.measure					= 'RTF_SYS_RP'
		   and sp.qty                       >= 0 
		
		UNION ALL

		-- 매출 실적
		select  sp.[DIVISION_ID]
			   ,sp.[ITEM_ID]
			   ,sp.[FCST_TYPE]
			   ,sp.YYYYMMDD
		       ---------------------------------------------------------------------------------------------------------------------------------
			   -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (dm_pln_sales_plan_result에 CELL_PROD_SITE_ID가 추가됨에 따라 SUM 처리 필요)
		       --,sp.qty   qty
		       --,CASE WHEN sp.YYYYMMDD < @v_start_week THEN sp.qty ELSE 0 END  acc_qty
		       ,SUM(sp.qty)   qty
		       ,CASE WHEN sp.YYYYMMDD < @v_start_week THEN SUM(sp.qty) ELSE 0 END  acc_qty
		       ---------------------------------------------------------------------------------------------------------------------------------
			   ,'SALES'  MEASURE
		  from dm_pln_sales_plan_result sp WITH(NOLOCK)
		 where sp.division_id				IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )
		   and sp.measure					= 'RTF_SYS_RP'  --20191121 KHSONG 'RTF_SYS_RP' MEASURE 추가전송
		   and yyyymmdd                     >= @v_delete_yyyymm + '01'
		   and yyyymmdd                     < @v_start_week
		---------------------------------------------------------------------------------------------------------------------------------
		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (dm_pln_sales_plan_result에 CELL_PROD_SITE_ID가 추가됨에 따라 SUM 처리 필요)
		GROUP BY sp.[DIVISION_ID]
			   ,sp.[ITEM_ID]
			   ,sp.[FCST_TYPE]
			   ,sp.YYYYMMDD
		---------------------------------------------------------------------------------------------------------------------------------
		)

		insert into DM_ANL_KPI_RTF_SALES ( 
			   [DIVISION_ID]
			  ,[ITEM_ID]
			  ,[FCST_TYPE]
			  ,[YYYYMM]
			  ,[MEASURE]
			  ,[QTY]
			  ,[ACC_QTY]
			  ,[CREATED_BY]
			  ,[CREATION_DATE]
			  ,[LAST_UPDATED_BY]
			  ,[LAST_UPDATE_DATE]
		   )
		select  x.division_id
		      , X.item_id
		      , X.fcst_type
		      , substring(X.yyyymmdd, 1,6) AS YYYYMM
		      , X.MEASURE
		      , SUM(QTY)           AS QTY
		      , SUM(ACC_QTY)       AS ACC_QTY
			  , 'KPI_RTF_SALES'    AS [CREATED_BY]
			  , getdate()          AS [CREATION_DATE]
			  , 'KPI_RTF_SALES'    AS [LAST_UPDATED_BY]
			  , getdate()          AS [LAST_UPDATE_DATE]
		  from plan_and_result x
		 where x.division_id IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )
		 group 
		    by  x.division_id
		      , X.item_id
		      , X.fcst_type
		      , substring(X.yyyymmdd, 1,6)
		      , X.MEASURE
		;

		-- RTF 준수율 KPI 재생성을 위한 추가 필드 
		-- 대표코드/대표Nick_Name/Biz Type/Class Name/SCM User. (2021.07.22 hjs)
		MERGE INTO DM_ANL_KPI_RTF_SALES AS KPI
		USING (
			   SELECT DIVISION_ID, ITEM_ID, DOE, BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME, MAX(SCM_PIC) AS SCM_PIC
			   FROM   (
					   SELECT DIVISION_ID, ITEM_ID, ISNULL(DOE, ITEM_ID) AS DOE, SCP_EXTRA_SPEC, SCM_PIC, ITEM_CLASS_NAME
							, (
							   SELECT TOP 1 ISNULL(NULLIF(NICK_NAME, ''), '-') 
							   FROM   DBO.SCM_MST_ITEM_SN X WITH(NOLOCK) 
							   WHERE  1=1 AND X.DIVISION_ID = IT.DIVISION_ID 
							   AND X.ITEM_ID = ISNULL(IT.DOE, IT.ITEM_ID)
							  ) AS BASIC_NICK_NAME
							, (SELECT SEGMENT2
							   FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH (NOLOCK)
							   WHERE A.LOOKUP_TYPE = 'OPERATION_GROUP'
							   AND A.SEGMENT1 = (SELECT DBO.FN_GET_ITEM_OPERATION_GROUP(IT.DIVISION_ID, ISNULL(IT.DOE, IT.ITEM_ID)))) AS GROUP_TYPE
					   FROM   SCM_MST_ITEM_SN IT WITH(NOLOCK)
					   WHERE  DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )
					  ) A
			   GROUP  BY DIVISION_ID, ITEM_ID, DOE, BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME
			  ) AS IT
		   ON (
						KPI.YYYYMM        >= @v_delete_yyyymm
					AND KPI.DIVISION_ID   = IT.DIVISION_ID
					AND KPI.ITEM_ID       = IT.ITEM_ID
				  )
		WHEN MATCHED THEN
		UPDATE SET KPI.DOE = IT.DOE
				 , KPI.BASIC_NICK_NAME = IT.BASIC_NICK_NAME
				 , KPI.GROUP_TYPE      = IT.GROUP_TYPE
				 , KPI.ITEM_CLASS_NAME = IT.ITEM_CLASS_NAME
				 , KPI.SCM_PIC         = IT.SCM_PIC 
				 , KPI.accumulated_child_qty = ISNULL((SELECT MAX(ACCUMULATED_CHILD_QTY) AS CELL_QTY 
													   FROM   SCM_MST_MODEL_FINAL_ITEM_BOM_V  BM
													   WHERE  BM.DIVISION_ID  = IT.DIVISION_ID
													   AND    BM.MODEL_ID     = IT.ITEM_ID
													   AND    BM.OPERATION_GROUP_ID ='A'
													   AND    IT.GROUP_TYPE   = 'Pack'
													 ),1)
				 , KPI.QTY_CELL = KPI.QTY * 
											   ISNULL((SELECT MAX(ACCUMULATED_CHILD_QTY) AS CELL_QTY 
													   FROM   SCM_MST_MODEL_FINAL_ITEM_BOM_V  BM
													   WHERE  BM.DIVISION_ID  = IT.DIVISION_ID
													   AND    BM.MODEL_ID     = IT.ITEM_ID
													   AND    BM.OPERATION_GROUP_ID ='A'
													   AND    IT.GROUP_TYPE   = 'Pack'
													 ),1)
				 , KPI.ACC_QTY_CELL = KPI.ACC_QTY * 
											   ISNULL((SELECT MAX(ACCUMULATED_CHILD_QTY) AS CELL_QTY 
													   FROM   SCM_MST_MODEL_FINAL_ITEM_BOM_V  BM
													   WHERE  BM.DIVISION_ID  = IT.DIVISION_ID
													   AND    BM.MODEL_ID     = IT.ITEM_ID
													   AND    BM.OPERATION_GROUP_ID ='A'
													   AND    IT.GROUP_TYPE   = 'Pack'
													 ),1)

													 ;


		-- 자동차 사업부 : Pack Group 정보 Update 로직 추가 (2021.09.16 hjs)
		MERGE INTO DM_ANL_KPI_RTF_SALES AS KPI
		USING (
			   SELECT DIVISION_ID, ITEM_ID, MAX(GROUP_CODE2) AS GROUP_CODE2
                 FROM SCP_MST_FINAL_ITEM WITH(NOLOCK)
                WHERE DIVISION_ID LIKE '81%'
                  AND GROUP_CODE2 IS NOT NULL
                GROUP BY DIVISION_ID, ITEM_ID
			  ) AS IT
		   ON (
						KPI.YYYYMM        >= @v_delete_yyyymm
					AND KPI.DIVISION_ID   = IT.DIVISION_ID
					AND KPI.ITEM_ID       = IT.ITEM_ID
				  )
		WHEN MATCHED THEN
		UPDATE SET KPI.DOE             = IT.GROUP_CODE2
				 , KPI.BASIC_NICK_NAME = IT.GROUP_CODE2  ;


	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                                   매출계획 적확도 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- IF @@TRANCOUNT > 0 

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION PR_DM_ANL_KPI_RTF_SALES;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
