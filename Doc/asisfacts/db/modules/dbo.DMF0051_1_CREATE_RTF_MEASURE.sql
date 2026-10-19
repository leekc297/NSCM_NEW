/*
 **************************************************************************************************
 * Program ID  : [DMF0051_1_CREATE_RTF_MEASURE]
 * Description : Procedure 작성 가이드                                                              
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                    
 *                                                                                                  
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description                                                             
 *--------------------------------------------------------------------------------------------------
 * 2023/07/19	CHANO0612	사업계획 프로젝트
 * 2023.10.03	chano0612	사업계획3차 수정
  * 2024.03.18	kjj				화면에서 BP 컷오프 수행
 **************************************************************************************************
*/
CREATE PROCEDURE [dbo].[DMF0051_1_CREATE_RTF_MEASURE]
--DECLARE
    @p_division_id  NVARCHAR(30)
	,@P_RTF_VER		NVARCHAR(50) --2024.03.18
	,@P_BPYEAR			NVARCHAR(4)
AS
/*
  EXEC DMF0051_1_CREATE_RTF_MEASURE @p_division_id='82' 
*/
BEGIN

	-- LOG 용 변수 설정
	DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = N'DMF0051_1_CREATE_RTF_MEASURE';
	DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
	DECLARE @n_log_count    INTEGER = 0;
	DECLARE @v_log_message  NVARCHAR(1000);
	DECLARE @v_description  NVARCHAR(500);      
	DECLARE @v_table_id     NVARCHAR(150) = N'DM_PLN_BIZPLAN_C'; 
	DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = N'START';
	SET @v_log_message = N'########## Start of procedure ##########';
	SET @v_description = @v_table_id + ' : ' + @p_division_id;
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

		IF OBJECT_ID (N'tempdb..#TMP_RTF', N'U') IS NOT NULL 		
			DROP TABLE #TMP_RTF

		IF OBJECT_ID (N'tempdb..#RTF', N'U') IS NOT NULL 		
			DROP TABLE #RTF

		IF OBJECT_ID (N'tempdb..#SCP_TEMP', N'U') IS NOT NULL 		
			DROP TABLE #SCP_TEMP

		CREATE TABLE #TMP_RTF(
			  DIVISION_ID	 NVARCHAR(MAX)
			  ,PLAN_ID		 NVARCHAR(MAX)
			  ,SALES_SITE	 NVARCHAR(MAX)
			  ,BIZ_TYPE		 NVARCHAR(MAX)
			  ,CUST			 NVARCHAR(MAX)
			  ,PROJECT		 NVARCHAR(MAX)
			  ,PROJECT_DESC	 NVARCHAR(MAX)
			  ,MODEL		 NVARCHAR(MAX)
			  ,MODEL_CODE	 NVARCHAR(MAX)
			  ,CELL_NICKNAME NVARCHAR(MAX)
			  ,CELL_CODE	 NVARCHAR(MAX)
			  ,ELECTRODE	 NVARCHAR(MAX)
			  ,CELL			 NVARCHAR(MAX)
			  ,PACK			 NVARCHAR(MAX)
			  ,UNIT			 NVARCHAR(MAX)
			  ,INCOTERMS	 NVARCHAR(MAX)
			  ,MEASURE		 NVARCHAR(MAX)
			  ,YYYYMM 		 NVARCHAR(MAX)
			  ,OSP_YN 		 NVARCHAR(MAX)
			  ,ATTRIBUTE1	 NVARCHAR(MAX)
			  ,ATTRIBUTE2	 NVARCHAR(MAX)
			  ,QTY			 INT
		)

		DECLARE @v_PLAN_ID NVARCHAR(30)
		DECLARE @v_YYYYMMDD NVARCHAR(8)
		DECLARE @v_PLAN_START_DATE NVARCHAR(6)


		--SELECT @v_PLAN_ID = MAX(PLAN_ID) FROM SCP_ANL_BUSINESS_PLAN_RTF_DM WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id 
		--===================== 최신 PLAN_ID 구해오기 ========================================================================================
		--SELECT @v_PLAN_ID = MAX(PLAN_ID) FROM SCP_ANL_BUSINESS_PLAN_RTF_DM WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id 
		SET @v_PLAN_ID = @P_RTF_VER--2024.03.18 넘겨준 값 사용


		SELECT @v_PLAN_START_DATE = PLAN_START_DATE FROM SCP_ANL_BUSINESS_PLAN_INFO WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND PLAN_ID = SUBSTRING(@v_PLAN_ID, 1, 21)--LEN(@v_PLAN_ID)-4)
		--===================== 최신 PLAN_ID 구해오기 ========================================================================================
		--SELECT @v_PLAN_ID = MAX(PLAN_ID) FROM SCP_ANL_BUSINESS_PLAN_RTF_DM WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id 

		SET @v_YYYYMMDD =  SUBSTRING(@v_PLAN_ID, 1, 8);--사용안함...

		BEGIN
			SELECT ROW_NUMBER() OVER (ORDER BY YYYYMM ASC) AS SEQ
			    ,DIVISION_ID,PLAN_ID,SALES_SITE,BIZ_TYPE,CUST,PROJECT,PROJECT_DESC,MODEL,MODEL_CODE,CELL_NICKNAME,CELL_CODE
				--,ELECTRODE,CELL,PACK
				, CASE 
					WHEN LEN(a.ELECTRODE) > 8 THEN 
						(SELECT TOP 1 COMPANY_ID  
							FROM SCM_MST_SITE WITH(NOLOCK) 
							WHERE 1=1--DIVISION_ID = a.DIVISION_ID 
							AND PLANT_ID LIKE a.ELECTRODE+'%'
						) 
					ELSE 
						(SELECT TOP 1 COMPANY_ID  
							FROM SCM_MST_PLANT_SN WITH(NOLOCK) 
							WHERE 1=1-- DIVISION_ID = a.DIVISION_ID 
							AND PLANT_ID = a.ELECTRODE
						) 
					END ELECTRODE
				, CASE 
					WHEN attribute3 = 'Y' THEN 
						(SELECT TOP 1 COMPANY_ID  
							FROM SCM_MST_SITE WITH(NOLOCK) 
							WHERE DIVISION_ID = a.DIVISION_ID 
							AND PLANT_ID    LIKE a.PACK+'%'
						) 
					ELSE 
						(SELECT TOP 1 COMPANY_ID  
							FROM SCM_MST_PLANT_SN WITH(NOLOCK) 
							WHERE DIVISION_ID = a.DIVISION_ID 
							AND PLANT_ID = a.PACK
						) 
					END PACK
				, CASE 
					WHEN LEN(a.CELL) > 8 THEN 
						(SELECT TOP 1 COMPANY_ID  
							FROM SCM_MST_SITE WITH(NOLOCK) 
							WHERE DIVISION_ID = a.DIVISION_ID 
							AND PLANT_ID LIKE a.CELL+'%'
						) 
					ELSE 
						(SELECT TOP 1 COMPANY_ID  
							FROM SCM_MST_PLANT_SN WITH(NOLOCK) 
							WHERE DIVISION_ID = a.DIVISION_ID 
							AND PLANT_ID = a.CELL
						) 
					END CELL

				 , CASE WHEN biz_type = 'Pack' THEN  a.PACK
						WHEN biz_type = 'Cell' THEN  a.CELL
						ELSE '-'
				   END attribute1  -- Plant Code
				 , CASE WHEN biz_type = 'Pack'  
							 THEN CASE WHEN attribute3 = 'Y' THEN (SELECT TOP 1 COMPANY_ID  FROM SCM_MST_SITE WITH(NOLOCK) WHERE DIVISION_ID = a.DIVISION_ID AND PLANT_ID LIKE a.PACK+'%') 
									   ELSE (SELECT TOP 1 COMPANY_ID  FROM SCM_MST_PLANT_SN WITH(NOLOCK) WHERE DIVISION_ID = a.DIVISION_ID AND PLANT_ID = a.PACK) 
								  END 
						WHEN biz_type = 'Cell'  
							 THEN CASE WHEN attribute3 = 'Y' THEN (SELECT TOP 1 COMPANY_ID  FROM SCM_MST_SITE WITH(NOLOCK) WHERE DIVISION_ID = a.DIVISION_ID AND PLANT_ID LIKE a.CELL+'%') 
									   ELSE (SELECT TOP 1 COMPANY_ID  FROM SCM_MST_PLANT_SN WITH(NOLOCK) WHERE DIVISION_ID = a.DIVISION_ID AND PLANT_ID = a.CELL) 
								  END 
						ELSE '-'
				   END attribute2 -- Prod Corp ID
	   
				, attribute3 osp_yn

				---
			
				,UNIT,INCOTERMS,MEASURE
				,CASE WHEN YYYYMM = 'M1_QTY' THEN 'M01_QTY' 
					  WHEN YYYYMM = 'M2_QTY' THEN 'M02_QTY' 
					  WHEN YYYYMM = 'M3_QTY' THEN 'M03_QTY' 
					  WHEN YYYYMM = 'M4_QTY' THEN 'M04_QTY' 
					  WHEN YYYYMM = 'M5_QTY' THEN 'M05_QTY' 
					  WHEN YYYYMM = 'M6_QTY' THEN 'M06_QTY' 
					  WHEN YYYYMM = 'M7_QTY' THEN 'M07_QTY' 
					  WHEN YYYYMM = 'M8_QTY' THEN 'M08_QTY' 
					  WHEN YYYYMM = 'M9_QTY' THEN 'M09_QTY' 
					  ELSE YYYYMM
				 END YYYYMM
				,[VALUE] AS QTY 
			INTO #SCP_TEMP
			FROM SCP_ANL_BUSINESS_PLAN_RTF_DM a  WITH(NOLOCK) UNPIVOT (VALUE FOR YYYYMM IN (
				 M1_QTY,M2_QTY,M3_QTY,M4_QTY,M5_QTY,M6_QTY,M7_QTY,M8_QTY,M9_QTY,M10_QTY
				,M11_QTY,M12_QTY,M13_QTY,M14_QTY,M15_QTY,M16_QTY,M17_QTY,M18_QTY,M19_QTY,M20_QTY
				,M21_QTY,M22_QTY,M23_QTY,M24_QTY,M25_QTY,M26_QTY,M27_QTY,M28_QTY,M29_QTY,M30_QTY
				,M31_QTY,M32_QTY,M33_QTY,M34_QTY,M35_QTY,M36_QTY,M37_QTY,M38_QTY,M39_QTY,M40_QTY
				,M41_QTY,M42_QTY,M43_QTY,M44_QTY,M45_QTY,M46_QTY,M47_QTY,M48_QTY,M49_QTY,M50_QTY
				,M51_QTY,M52_QTY,M53_QTY,M54_QTY,M55_QTY,M56_QTY,M57_QTY,M58_QTY,M59_QTY,M60_QTY)) AS A
			WHERE PLAN_ID = @v_PLAN_ID AND DIVISION_ID = @p_division_id

		END

		DECLARE @s INT = 1;
		DECLARE @COUNT INT = 0;

		SELECT @COUNT = COUNT(*) FROM #SCP_TEMP

		BEGIN

			WHILE @s <= @COUNT
			BEGIN

				INSERT INTO #TMP_RTF (DIVISION_ID,PLAN_ID,SALES_SITE,BIZ_TYPE,CUST,PROJECT,PROJECT_DESC,MODEL,MODEL_CODE,CELL_NICKNAME,CELL_CODE
                                     ,ELECTRODE,CELL,PACK,UNIT,INCOTERMS,MEASURE,QTY,YYYYMM,OSP_YN,ATTRIBUTE1,ATTRIBUTE2)
				SELECT DIVISION_ID,PLAN_ID,SALES_SITE,BIZ_TYPE,CUST,PROJECT,PROJECT_DESC,MODEL,MODEL_CODE,CELL_NICKNAME,CELL_CODE,ELECTRODE,CELL,PACK,UNIT,INCOTERMS,MEASURE,QTY
					,SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, CONVERT(INT, SUBSTRING(YYYYMM, 2, 2))-1, @v_PLAN_START_DATE + '01'), 112), 1, 6) YYYYMM
					,OSP_YN,ATTRIBUTE1, ATTRIBUTE2
				FROM #SCP_TEMP
				WHERE SEQ = @s
				
			    SET @s = @s + 1
			END
			
		END
	

		DECLARE @VERSION_NO NVARCHAR(30)

		BEGIN
			SELECT @VERSION_NO = MAX(VERSION_NO) FROM DM_MST_VERSION WITH(NOLOCK) 
			WHERE VERSION_TYPE = 'BP_M' 
			AND DIVISION_ID = @p_division_id 
			--AND SUBSTRING(VERSION_NO, 1, 4) = '24BP'--하드코딩 제거

			AND SUBSTRING(VERSION_NO, 1, 2) = SUBSTRING(@P_BPYEAR, 3,2)
			AND SUBSTRING(VERSION_NO, 3, 5) = 'BP_DM'
			AND SUBSTRING(VERSION_NO, 14, 3) = (select WEEK_NAME FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112))

			DELETE FROM DM_PLN_BIZPLAN_C WHERE VERSION_NO = @VERSION_NO AND MEASURE = 'RTF' AND DIVISION_ID = @p_division_id

			INSERT INTO DM_PLN_BIZPLAN_C(
					SEQ,DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
					,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY
					,MEASURE,YYYYMM,QTY,PROJECT_NAME,CELL_PROD_SITE,EXT_INT
					,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK,CELL_PER_PACK,PERIOD_YYMM
					,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,OTHER_PRICE,TOTAL_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID
					,ATTRIBUTE1, ATTRIBUTE2
					,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					)
			SELECT 
					ROW_NUMBER() OVER (ORDER BY B.ELECTRODE, B.CELL, B.PACK ASC) AS SEQ ,A.DIVISION_ID,A.VERSION_NO,A.CUTOFF_TYPE,A.CUTOFF_YYYYMMDD,A.DEPT_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID
					,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS,A.ITEM_USE,A.UNIT_ENERGY,A.CURRENCY
					,'RTF' MEASURE,A.YYYYMM,ISNULL(B.QTY, 0) QTY,A.PROJECT_NAME,A.CELL_PROD_SITE,A.EXT_INT
					,A.PRODUCT_GROUP,A.ALT_SIM_YN,A.CELL_CODE,A.CELL_PER_MODULE,A.MODULE_PER_PACK,A.CELL_PER_PACK,A.PERIOD_YYMM
					,A.SCENARIO_TYPE,A.BASE_PRICE,A.METAL_LINK_PRICE,A.OTHER_PRICE,A.TOTAL_PRICE,A.METAL_LINK_YN,A.WORK_YYYYMMDD,B.OSP_YN, B.ELECTRODE, B.CELL, B.PACK
					,B.ATTRIBUTE1, B.ATTRIBUTE2
					,'SYSTEM' CREATED_BY,GETDATE() CREATION_DATE,'SYSTEM' LAST_UPDATED_BY,GETDATE() LAST_UPDATE_DATE			
			FROM DM_PLN_BIZPLAN_C A  WITH(NOLOCK) 

			INNER JOIN #TMP_RTF B 
			--LEFT JOIN #TMP_RTF B 
			ON  A.DIVISION_ID  = B.DIVISION_ID 
			AND A.SCM_SITE_ID  = B.SALES_SITE 
			AND A.PROJECT_CODE = B.PROJECT 
			AND A.ITEM_ID      = B.MODEL_CODE 
			AND A.INCOTERMS    = B.INCOTERMS 
			AND A.YYYYMM       = B.YYYYMM

			WHERE 1=1 
			AND   A.VERSION_NO = @VERSION_NO
			AND   A.MEASURE    = 'Business_Plan'

            SET @n_log_count = @@ROWCOUNT;

		END

		IF OBJECT_ID (N'tempdb..#TMP_RTF', N'U') IS NOT NULL 		
			DROP TABLE #TMP_RTF

		IF OBJECT_ID (N'tempdb..#RTF', N'U') IS NOT NULL 		
			DROP TABLE #RTF

		IF OBJECT_ID (N'tempdb..#SCP_TEMP', N'U') IS NOT NULL 		
			DROP TABLE #SCP_TEMP

    -----------------------------------------------------------
    -- 실행 Logic END --
    -----------------------------------------------------------
    -- TXN LOG
    SET @v_log_type = N'TXN';    
    SET @v_log_message = N'INSERT INTO '+@v_table_id + ' : ' + @p_division_id;
    SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
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
    SET @v_description = @p_division_id;;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
								
	--------------------------------------------------
    -- RTF 기준 'BP Conf' 배분 작업 Call
	--------------------------------------------------
    EXEC [dbo].[DMF0051_1_RTF_RATIO_DIVIDE_BIZPLAN] @p_division_id, @VERSION_NO, @P_RTF_VER;

    return 1 

    _RETURN_ERR_CODE:          
        BEGIN          
             RETURN -1          
        END;  

END