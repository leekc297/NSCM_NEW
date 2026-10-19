




/*  
 * Program ID   : PR_SCP_MST_CAPA_LINE
 * Description  : FP 라인 Master 뷰 참조하여 CPS line Master 데이터를 생성한다.
 *				  CPS UI에서 더미로 등록된 라인이 FP 정식 Line으로 등록되었을시에 더미여부(ATTRIBUTE2)를 'N'으로 변경한다.
 *
 *				 - Source : SCM_LINE_HIERARCHY_CPS_V_SN
 *				 - Target : SCP_MST_CAPA_LINE		-- 조립.팩
 *							SCP_MST_CAPA_ELTR_LINE	-- 전극 
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.10.02	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : Initial Release 
 * 2024.10.10	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 전극은 E2000 공정만 참조.
 * 2024.10.16	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 라인 상위 코드 추가 적재 
 * 2024.10.28	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 라인 정보 없는 Plant/Factory 적재 추가 
 * 2025.01.02	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 더미 라인 site/company/plant/factory 명칭 변경 로직 추가  
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_MST_CAPA_LINE] 
AS

BEGIN

-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_CAPA_LINE'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	BEGIN TRY
	  BEGIN

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'FP Line Master 정보 - #SCM_LINE_HIERARCHY_CPS_V_SN ' 
		----------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCM_LINE_HIERARCHY_CPS_V_SN') is not null drop table #SCM_LINE_HIERARCHY_CPS_V_SN

		SELECT CONVERT(NVARCHAR(60), LH.DIVISION_ID	)			AS DIVISION_ID	 
			 , CONVERT(NVARCHAR(60), LH.COMPANY_ID	)			AS COMPANY_ID	 
			 , CONVERT(NVARCHAR(60), LH.SITE_ID		)			AS SITE_ID		 
			 , CONVERT(NVARCHAR(60), LH.PLANT_ID	)			AS PLANT_ID	 
			 , CONVERT(NVARCHAR(60), LH.FACTORY_ID	)			AS FACTORY_ID	 
			 , CONVERT(NVARCHAR(60), LH.LINE_ID		)			AS LINE_ID		 
			 , '-'												AS OPERATION_ID
			 , '-'												AS ELTR_LN_TP_CD
			 , CONVERT(NVARCHAR(200),MAX(LH.COMPANY_NAME	))	AS COMPANY_NAME
			 , CONVERT(NVARCHAR(200),MAX(LH.SITE_NAME		))	AS SITE_NAME	  
			 , CONVERT(NVARCHAR(200),MAX(LH.PLANT_NAME		))	AS PLANT_NAME  
			 , CONVERT(NVARCHAR(200),MAX(LH.FACTORY_NAME	))	AS FACTORY_NAME
			 , CONVERT(NVARCHAR(200),MAX(LH.LINE_NAME		))	AS LINE_NAME
			 , 'Y'												AS VALID_YN 
			 , MAX(OPERATION_GROUP_ID)							AS ATTRIBUTE1	-- operation_group_id 
			 , 'N'												AS ATTRIBUTE2	-- 더미여부
		 INTO #SCM_LINE_HIERARCHY_CPS_V_SN
		 FROM SCM_LINE_HIERARCHY_CPS_V_SN LH WITH(NOLOCK) 
		WHERE 1=1
		  AND (OPERATION_GROUP_ID IN ('A', 'P') OR OPERATION_ID = 'E2000' ) -- 2024.10.10 조립/팩 이거나 전극 Coating인 경우만 참조 
		GROUP BY LH.DIVISION_ID
			 , LH.COMPANY_ID
			 , LH.SITE_ID
			 , LH.PLANT_ID
			 , LH.FACTORY_ID
			 , LH.LINE_ID

		----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'FP Line Master 정보 - site/company/plant/factory 레벨별 root 정보 추가 ' 
		----------------------------------------------------------------------------------------------------------------------
		INSERT INTO #SCM_LINE_HIERARCHY_CPS_V_SN
		-- Site 
		SELECT DIVISION_ID
			 ,'-'				AS COMPANY_ID
			 ,SITE_ID			AS SITE_ID
			 ,'-'				AS PLANT_ID
			 ,'-'				AS FACTORY_ID
			 ,'-'				AS LINE_ID
			 ,'-'				AS OPERATION_D
			 ,'-'				AS ELTR_LN_TP_CD
			 ,'-'				AS COMPANY_NAME
			 ,MAX(SITE_NAME)	AS SITE_NAME
			 ,'-'				AS PLANT_NAME
			 ,'-'				AS FACTORY_NAME
			 ,'-'				AS LINE_NAME
			 ,MAX(VALID_YN)		AS VALID_YN
			 ,'-'				AS ATTRIBUTE1 -- operation_group 
			 ,'N'				AS ATTRIBUTE2
		 FROM #SCM_LINE_HIERARCHY_CPS_V_SN 
		WHERE 1=1
		GROUP BY DIVISION_ID
				,SITE_ID
		UNION ALL
		-- Company 
		SELECT DIVISION_ID
			 ,COMPANY_ID		AS COMPANY_ID
			 ,SITE_ID			AS SITE_ID
			 ,'-'				AS PLANT_ID
			 ,'-'				AS FACTORY_ID
			 ,'-'				AS LINE_ID
			 ,'-'				AS OPERATION_D
			 ,'-'				AS ELTR_LN_TP_CD
			 ,MAX(COMPANY_NAME)	AS COMPANY_NAME
			 ,MAX(SITE_NAME)	AS SITE_NAME
			 ,'-'				AS PLANT_NAME
			 ,'-'				AS FACTORY_NAME
			 ,'-'				AS LINE_NAME
			 ,MAX(VALID_YN)		AS VALID_YN
			 ,'-'				AS ATTRIBUTE1 -- operation_group 
			 ,'N'				AS ATTRIBUTE2
		 FROM #SCM_LINE_HIERARCHY_CPS_V_SN 
		WHERE 1=1
		GROUP BY DIVISION_ID
				,SITE_ID
				,COMPANY_ID
		UNION ALL
		-- Plant 
		SELECT DIVISION_ID
			 ,COMPANY_ID		AS COMPANY_ID
			 ,SITE_ID			AS SITE_ID
			 ,PLANT_ID			AS PLANT_ID
			 ,'-'				AS FACTORY_ID
			 ,'-'				AS LINE_ID
			 ,'-'				AS OPERATION_D
			 ,'-'				AS ELTR_LN_TP_CD
			 ,MAX(COMPANY_NAME)	AS COMPANY_NAME
			 ,MAX(SITE_NAME	)	AS SITE_NAME
			 ,MAX(PLANT_NAME)	AS PLANT_NAME
			 ,'-'				AS FACTORY_NAME
			 ,'-'				AS LINE_NAME
			 ,MAX(VALID_YN)		AS VALID_YN
			 ,'-'				AS ATTRIBUTE1 -- operation_group 
			 ,'N'				AS ATTRIBUTE2
		 FROM #SCM_LINE_HIERARCHY_CPS_V_SN 
		WHERE 1=1
		GROUP BY DIVISION_ID
				,SITE_ID
				,COMPANY_ID
				,PLANT_ID
		UNION ALL
		-- Factory  (factory부터 operation_group  구별 가능)
		SELECT DIVISION_ID
			 ,COMPANY_ID		AS COMPANY_ID
			 ,SITE_ID			AS SITE_ID
			 ,PLANT_ID			AS PLANT_ID
			 ,FACTORY_ID		AS FACTORY_ID
			 ,'-'				AS LINE_ID
			 ,'-'				AS OPERATION_D
			 ,'-'				AS ELTR_LN_TP_CD
			 ,MAX(COMPANY_NAME)	AS COMPANY_NAME
			 ,MAX(SITE_NAME)	AS SITE_NAME
			 ,MAX(PLANT_NAME)	AS PLANT_NAME
			 ,MAX(FACTORY_NAME)	AS FACTORY_NAME
			 ,'-'				AS LINE_NAME
			 ,MAX(VALID_YN)		AS VALID_YN
			 ,MAX(ATTRIBUTE1)	AS ATTRIBUTE1 -- operation_group 
			 ,'N'				AS ATTRIBUTE2
		 FROM #SCM_LINE_HIERARCHY_CPS_V_SN 
		WHERE 1=1
		GROUP BY DIVISION_ID
				,SITE_ID
				,COMPANY_ID
				,PLANT_ID
				,FACTORY_ID

		----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'FP Line Factory Master 정보 ' 
		----------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCM_MST_FACTORY_SN') is not null drop table #SCM_MST_FACTORY_SN

		SELECT F.DIVISION_ID
			  ,F.COMPANY_ID
			  ,F.SITE_ID
			  ,F.PLANT_ID
			  ,F.FACTORY_ID
			  ,C.COMPANY_NAME
			  ,S.SITE_NAME
			  ,P.PLANT_NAME
			  ,F.FACTORY_NAME
			  ,F.SHOP_GROUP_ID	AS ATTRIBUTE1 -- operation group id   -- select * 
		 INTO #SCM_MST_FACTORY_SN
		 FROM SCM_MST_FACTORY_SN F WITH(NOLOCK)
			  INNER JOIN SCM_MST_PLANT_SN P WITH(NOLOCK)
					  ON P.DIVISION_ID	= F.DIVISION_ID
					 AND P.SITE_ID		= F.SITE_ID
					 AND P.COMPANY_ID	= F.COMPANY_ID
					 AND P.PLANT_ID		= F.PLANT_ID
					 AND P.OUTSOURCING_FLAG = 'N'   -- 외주 packer 구분
			  INNER JOIN SCM_MST_COMPANY_SN C WITH(NOLOCK)
					  ON C.COMPANY_ID	= F.COMPANY_ID
			  INNER JOIN SCM_MST_SITE_SN  S WITH(NOLOCK)
					  ON S.COMPANY_ID	= F.COMPANY_ID
					 AND S.SITE_ID		= F.SITE_ID
		WHERE 1=1
		  AND F.ACTIVE_FLAG = 'Y'
		  AND F.SHOP_GROUP_ID IS NOT NULL

		----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'FP Line Master 정보 - 하위 라인 없는 Plant 추가 ' 
		----------------------------------------------------------------------------------------------------------------------
		MERGE INTO #SCM_LINE_HIERARCHY_CPS_V_SN TGT 
		USING (
				SELECT DIVISION_ID
					  ,COMPANY_ID
					  ,SITE_ID
					  ,PLANT_ID
					  ,MAX(COMPANY_NAME)	AS COMPANY_NAME
					  ,MAX(SITE_NAME   )	AS SITE_NAME   
					  ,MAX(PLANT_NAME  )	AS PLANT_NAME  
				 FROM #SCM_MST_FACTORY_SN  WITH(NOLOCK)
				WHERE 1=1
				GROUP BY DIVISION_ID
					    ,COMPANY_ID
					    ,SITE_ID
					    ,PLANT_ID
			) SRC
		 ON (	SRC.DIVISION_ID	= TGT.DIVISION_ID	
			AND SRC.COMPANY_ID	= TGT.COMPANY_ID
			AND SRC.SITE_ID		= TGT.SITE_ID
			AND SRC.PLANT_ID	= TGT.PLANT_ID
		    )   
		WHEN NOT MATCHED THEN
			INSERT (DIVISION_ID
				   ,COMPANY_ID
				   ,SITE_ID
				   ,PLANT_ID
				   ,FACTORY_ID
				   ,LINE_ID
				   ,OPERATION_ID
				   ,ELTR_LN_TP_CD
				   ,COMPANY_NAME
				   ,SITE_NAME
				   ,PLANT_NAME
				   ,FACTORY_NAME
				   ,LINE_NAME
				   ,VALID_YN
				   ,ATTRIBUTE1		-- shop group id (operation_gorup_id) 
				   ,ATTRIBUTE2)		-- 더미 여부 
			 VALUES (DIVISION_ID
				   ,SRC.COMPANY_ID
				   ,SRC.SITE_ID
				   ,SRC.PLANT_ID
				   ,'-'			-- FACTORY_ID
				   ,'-'			-- line_id 
				   ,'-'			-- operation_id
				   ,'-'			-- eltr_ln_tp_cd 
				   ,SRC.COMPANY_NAME
				   ,SRC.SITE_NAME
				   ,SRC.PLANT_NAME
				   ,'-'			-- line_name
				   ,'-'			-- factory_name
				   ,'Y'			-- valid_yn 
				   ,'-'			-- shop group id (operation_gorup_id) 
				   ,'N' )		-- 더미여부 
				   ; 

		----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'FP Line Master 정보 - 하위 라인 없는 Factory 추가 ' 
		----------------------------------------------------------------------------------------------------------------------
		MERGE INTO #SCM_LINE_HIERARCHY_CPS_V_SN TGT 
		USING (
				SELECT * 
				 FROM #SCM_MST_FACTORY_SN F WITH(NOLOCK)
				WHERE 1=1
			) SRC
		 ON (	SRC.DIVISION_ID	= TGT.DIVISION_ID	
			AND SRC.COMPANY_ID	= TGT.COMPANY_ID
			AND SRC.SITE_ID		= TGT.SITE_ID
			AND SRC.PLANT_ID	= TGT.PLANT_ID
			AND SRC.FACTORY_ID	= TGT.FACTORY_ID
		    )   
		WHEN NOT MATCHED THEN
			INSERT (DIVISION_ID
				   ,COMPANY_ID
				   ,SITE_ID
				   ,PLANT_ID
				   ,FACTORY_ID
				   ,LINE_ID
				   ,OPERATION_ID
				   ,ELTR_LN_TP_CD
				   ,COMPANY_NAME
				   ,SITE_NAME
				   ,PLANT_NAME
				   ,FACTORY_NAME
				   ,LINE_NAME
				   ,VALID_YN
				   ,ATTRIBUTE1		-- shop group id (operation_gorup_id) 
				   ,ATTRIBUTE2)		-- 더미 여부 
			 VALUES (DIVISION_ID
				   ,SRC.COMPANY_ID
				   ,SRC.SITE_ID
				   ,SRC.PLANT_ID
				   ,SRC.FACTORY_ID
				   ,'-'				-- line_id 
				   ,'-'				-- operation_id
				   ,'-'				-- eltr_ln_tp_cd 
				   ,SRC.COMPANY_NAME
				   ,SRC.SITE_NAME
				   ,SRC.PLANT_NAME
				   ,SRC.FACTORY_NAME
				   ,'-'				-- line_name
				   ,'Y'				-- valid_yn 
				   ,ATTRIBUTE1		-- operation_gorup_id(shop group id)
				   ,'N' )			-- 더미여부 
				   ; 

	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 조립팩 : MERGE INTO SCP_MST_CAPA_LINE ' 
		----------------------------------------------------------------------------------------------------------
		MERGE INTO SCP_MST_CAPA_LINE TGT 
		USING (
				SELECT *
				 FROM #SCM_LINE_HIERARCHY_CPS_V_SN  LH
				WHERE 1=1
				  AND LH.ATTRIBUTE1 IN ('-','A', 'P') -- operation_group_id 셀,팩 (site, company, plant는 모두 '-') 
			) SRC
		 ON (	SRC.DIVISION_ID	= TGT.DIVISION_ID	
			AND SRC.COMPANY_ID	= TGT.COMPANY_ID
			AND SRC.SITE_ID		= TGT.SITE_ID
			AND SRC.PLANT_ID	= TGT.PLANT_ID
			AND SRC.FACTORY_ID	= TGT.FACTORY_ID
			AND SRC.LINE_ID		= TGT.LINE_ID
		    )
		WHEN MATCHED THEN
			UPDATE SET TGT.LAST_UPDATE_DATE	= SYSDATETIME()
					  ,TGT.LAST_UPDATED_BY	= @v_program_name
					  ,TGT.ATTRIBUTE1		= SRC.ATTRIBUTE1		-- operation group  10/16	
					  ,TGT.ATTRIBUTE2		= SRC.ATTRIBUTE2		-- 더미여부 	
					  ,TGT.COMPANY_NAME		= SRC.COMPANY_NAME			
					  ,TGT.SITE_NAME		= SRC.SITE_NAME			
					  ,TGT.PLANT_NAME		= SRC.PLANT_NAME			
					  ,TGT.FACTORY_NAME		= SRC.FACTORY_NAME			
					  ,TGT.LINE_NAME		= SRC.LINE_NAME	
					  ,TGT.VALID_YN			= 'Y'
		WHEN NOT MATCHED THEN
			INSERT ( 	DIVISION_ID
					   ,COMPANY_ID
					   ,SITE_ID
					   ,PLANT_ID
					   ,FACTORY_ID
					   ,LINE_ID
					   ,OPERATION_ID
					   ,ELTR_LN_TP_CD
					   ,COMPANY_NAME
					   ,SITE_NAME
					   ,PLANT_NAME
					   ,FACTORY_NAME
					   ,LINE_NAME
					   ,VALID_YN
					   ,ATTRIBUTE1
					   ,ATTRIBUTE2
					   ,CREATED_BY
					   ,CREATION_DATE
					   ,LAST_UPDATED_BY
					   ,LAST_UPDATE_DATE
					)
			VALUES ( SRC.DIVISION_ID
					,SRC.COMPANY_ID
					,SRC.SITE_ID
					,SRC.PLANT_ID
					,SRC.FACTORY_ID
					,SRC.LINE_ID
					,SRC.OPERATION_ID
					,SRC.ELTR_LN_TP_CD
					,SRC.COMPANY_NAME
					,SRC.SITE_NAME
					,SRC.PLANT_NAME
					,SRC.FACTORY_NAME
					,SRC.LINE_NAME
					,SRC.VALID_YN
					,SRC.ATTRIBUTE1
					,SRC.ATTRIBUTE2		
					,@v_program_name
					,SYSDATETIME()
					,@v_program_name
					,SYSDATETIME()
					)
		;

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 전극 : MERGE INTO SCP_MST_CAPA_LINE ' 
		----------------------------------------------------------------------------------------------------------
		MERGE INTO SCP_MST_CAPA_ELTR_LINE TGT 
		USING (
				SELECT *
				 FROM #SCM_LINE_HIERARCHY_CPS_V_SN  LH
				WHERE 1=1
				  AND LH.ATTRIBUTE1 IN ('-',  'E' )  -- operation_group_id 전극 (site, company, plant는 모두 '-') 
			) SRC
		 ON (	SRC.DIVISION_ID	= TGT.DIVISION_ID	
			AND SRC.COMPANY_ID	= TGT.COMPANY_ID
			AND SRC.SITE_ID		= TGT.SITE_ID
			AND SRC.PLANT_ID	= TGT.PLANT_ID
			AND SRC.FACTORY_ID	= TGT.FACTORY_ID
			AND SRC.LINE_ID		= TGT.LINE_ID
		    )
		WHEN MATCHED THEN
			UPDATE SET TGT.LAST_UPDATE_DATE	= SYSDATETIME()
					  ,TGT.LAST_UPDATED_BY	= @v_program_name
					  ,TGT.ATTRIBUTE1		= SRC.ATTRIBUTE1		-- operation group  10/16	
					  ,TGT.ATTRIBUTE2		= SRC.ATTRIBUTE2		-- 더미여부 	
					  ,TGT.COMPANY_NAME		= SRC.COMPANY_NAME			
					  ,TGT.SITE_NAME		= SRC.SITE_NAME			
					  ,TGT.PLANT_NAME		= SRC.PLANT_NAME			
					  ,TGT.FACTORY_NAME		= SRC.FACTORY_NAME			
					  ,TGT.LINE_NAME		= SRC.LINE_NAME	
					  ,TGT.VALID_YN			= 'Y'
		WHEN NOT MATCHED THEN
			INSERT ( 	DIVISION_ID
					   ,COMPANY_ID
					   ,SITE_ID
					   ,PLANT_ID
					   ,FACTORY_ID
					   ,LINE_ID
					   ,OPERATION_ID
					   ,ELTR_LN_TP_CD
					   ,COMPANY_NAME
					   ,SITE_NAME
					   ,PLANT_NAME
					   ,FACTORY_NAME
					   ,LINE_NAME
					   ,VALID_YN
					   ,ATTRIBUTE1
					   ,ATTRIBUTE2
					   ,CREATED_BY
					   ,CREATION_DATE
					   ,LAST_UPDATED_BY
					   ,LAST_UPDATE_DATE
					)
			VALUES ( SRC.DIVISION_ID
					,SRC.COMPANY_ID
					,SRC.SITE_ID
					,SRC.PLANT_ID
					,SRC.FACTORY_ID
					,SRC.LINE_ID
					,SRC.OPERATION_ID
					,SRC.ELTR_LN_TP_CD
					,SRC.COMPANY_NAME
					,SRC.SITE_NAME
					,SRC.PLANT_NAME
					,SRC.FACTORY_NAME
					,SRC.LINE_NAME
					,SRC.VALID_YN
					,SRC.ATTRIBUTE1
					,SRC.ATTRIBUTE2		
					,@v_program_name
					,SYSDATETIME()
					,@v_program_name
					,SYSDATETIME()
					)
		;

	-- begin 2025.01.02 더미 라인 site/company/plant/factory 명칭 변경 로직 추가
	-- begin 2025.01.02 더미 라인 site/company/plant/factory 명칭 변경 로직 추가

	-- 조립.팩
	-- 조립.팩
		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 조립팩 명칭 Update - Site Name  ' -- 2025.01.02 추가
		----------------------------------------------------------------------------------------------------------
		UPDATE CL 
		   SET SITE_NAME		= LH.SITE_NAME
			  ,LAST_UPDATE_DATE	= SYSDATETIME()
			  ,LAST_UPDATED_BY	= @v_program_name+'-S'
		 FROM SCP_MST_CAPA_LINE CL WITH(NOLOCK) 
			  INNER JOIN #SCM_LINE_HIERARCHY_CPS_V_SN  LH
					  ON CL.DIVISION_ID = LH.DIVISION_ID
					 AND CL.SITE_ID		= LH.SITE_ID
					 AND CL.SITE_NAME  != LH.SITE_NAME  -- site name 불일치 건 
		WHERE 1=1
		  AND LH.SITE_ID	!= '-'		-- site 목록		
		  AND LH.COMPANY_ID	 = '-'		-- site 목록		

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 조립팩 명칭 Update - Company Name  ' -- 2025.01.02 추가
		----------------------------------------------------------------------------------------------------------
		UPDATE CL 
		   SET COMPANY_NAME		= LH.COMPANY_NAME
			  ,LAST_UPDATE_DATE	= SYSDATETIME()
			  ,LAST_UPDATED_BY	= @v_program_name+'-C'
		 FROM SCP_MST_CAPA_LINE CL WITH(NOLOCK) 
			  INNER JOIN #SCM_LINE_HIERARCHY_CPS_V_SN  LH
					  ON CL.DIVISION_ID		= LH.DIVISION_ID
					 AND CL.SITE_ID			= LH.SITE_ID
					 AND CL.COMPANY_ID		= LH.COMPANY_ID
					 AND CL.COMPANY_NAME   != LH.COMPANY_NAME  -- company name 불일치 건 
		WHERE 1=1
		  AND LH.COMPANY_ID != '-'		-- company 목록		
		  AND LH.PLANT_ID	 = '-'		-- company 목록			

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 조립팩 명칭 Update - Plant Name  ' -- 2025.01.02 추가
		----------------------------------------------------------------------------------------------------------
		UPDATE CL 
		   SET PLANT_NAME		= LH.PLANT_NAME
			  ,LAST_UPDATE_DATE	= SYSDATETIME()
			  ,LAST_UPDATED_BY	= @v_program_name+'-P'
		 FROM SCP_MST_CAPA_LINE CL WITH(NOLOCK) 
			  INNER JOIN #SCM_LINE_HIERARCHY_CPS_V_SN  LH
					  ON CL.DIVISION_ID		= LH.DIVISION_ID
					 AND CL.SITE_ID			= LH.SITE_ID
					 AND CL.COMPANY_ID		= LH.COMPANY_ID
					 AND CL.PLANT_ID		= LH.PLANT_ID
					 AND CL.PLANT_NAME	   != LH.PLANT_NAME -- plant name 불일치 건
		WHERE 1=1
		  AND LH.PLANT_ID    != '-'		-- plant 목록			
		  AND LH.FACTORY_ID	 = '-'		-- plant 목록		

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 조립팩 명칭 Update - Factory Name  ' -- 2025.01.02 추가
		----------------------------------------------------------------------------------------------------------
		UPDATE CL 
		   SET FACTORY_NAME		= LH.FACTORY_NAME
			  ,LAST_UPDATE_DATE	= SYSDATETIME()
			  ,LAST_UPDATED_BY	= @v_program_name+'-F'
		 FROM SCP_MST_CAPA_LINE CL WITH(NOLOCK) 
			  INNER JOIN #SCM_LINE_HIERARCHY_CPS_V_SN  LH
					  ON CL.DIVISION_ID		= LH.DIVISION_ID
					 AND CL.SITE_ID			= LH.SITE_ID
					 AND CL.COMPANY_ID		= LH.COMPANY_ID
					 AND CL.PLANT_ID		= LH.PLANT_ID
					 AND CL.FACTORY_ID		= LH.FACTORY_ID
					 AND CL.FACTORY_NAME   != LH.FACTORY_NAME -- Factory name 불일치 건
		WHERE 1=1
		  AND LH.FACTORY_ID != '-'		-- factory 목록		
		  AND LH.LINE_ID	 = '-'		-- factory 목록		

	-- 전극
	-- 전극

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 전극 명칭 Update - Site Name  ' -- 2025.01.02 추가
		----------------------------------------------------------------------------------------------------------
		UPDATE CL 
		   SET SITE_NAME		= LH.SITE_NAME
			  ,LAST_UPDATE_DATE	= SYSDATETIME()
			  ,LAST_UPDATED_BY	= @v_program_name+'-S'
		 FROM SCP_MST_CAPA_ELTR_LINE CL WITH(NOLOCK) 
			  INNER JOIN #SCM_LINE_HIERARCHY_CPS_V_SN  LH
					  ON CL.DIVISION_ID = LH.DIVISION_ID
					 AND CL.SITE_ID		= LH.SITE_ID
					 AND CL.SITE_NAME  != LH.SITE_NAME  -- site name 불일치 건 
		WHERE 1=1
		  AND LH.SITE_ID	!= '-'		-- site 목록		
		  AND LH.COMPANY_ID	 = '-'		-- site 목록		

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 전극 명칭 Update - Company Name  ' -- 2025.01.02 추가
		----------------------------------------------------------------------------------------------------------
		UPDATE CL 
		   SET COMPANY_NAME		= LH.COMPANY_NAME
			  ,LAST_UPDATE_DATE	= SYSDATETIME()
			  ,LAST_UPDATED_BY	= @v_program_name+'-C'
		 FROM SCP_MST_CAPA_ELTR_LINE CL WITH(NOLOCK) 
			  INNER JOIN #SCM_LINE_HIERARCHY_CPS_V_SN  LH
					  ON CL.DIVISION_ID		= LH.DIVISION_ID
					 AND CL.SITE_ID			= LH.SITE_ID
					 AND CL.COMPANY_ID		= LH.COMPANY_ID
					 AND CL.COMPANY_NAME   != LH.COMPANY_NAME  -- company name 불일치 건 
		WHERE 1=1
		  AND LH.COMPANY_ID != '-'		-- company 목록		
		  AND LH.PLANT_ID	 = '-'		-- company 목록			

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 전극 명칭 Update - Plant Name  ' -- 2025.01.02 추가
		----------------------------------------------------------------------------------------------------------
		UPDATE CL 
		   SET PLANT_NAME		= LH.PLANT_NAME
			  ,LAST_UPDATE_DATE	= SYSDATETIME()
			  ,LAST_UPDATED_BY	= @v_program_name+'-P'
		 FROM SCP_MST_CAPA_ELTR_LINE CL WITH(NOLOCK) 
			  INNER JOIN #SCM_LINE_HIERARCHY_CPS_V_SN  LH
					  ON CL.DIVISION_ID		= LH.DIVISION_ID
					 AND CL.SITE_ID			= LH.SITE_ID
					 AND CL.COMPANY_ID		= LH.COMPANY_ID
					 AND CL.PLANT_ID		= LH.PLANT_ID
					 AND CL.PLANT_NAME	   != LH.PLANT_NAME -- plant name 불일치 건
		WHERE 1=1
		  AND LH.PLANT_ID    != '-'		-- plant 목록			
		  AND LH.FACTORY_ID	 = '-'		-- plant 목록		

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 전극 명칭 Update - Factory Name  ' -- 2025.01.02 추가
		----------------------------------------------------------------------------------------------------------
		UPDATE CL 
		   SET FACTORY_NAME		= LH.FACTORY_NAME
			  ,LAST_UPDATE_DATE	= SYSDATETIME()
			  ,LAST_UPDATED_BY	= @v_program_name+'-F'
		 FROM SCP_MST_CAPA_ELTR_LINE CL WITH(NOLOCK) 
			  INNER JOIN #SCM_LINE_HIERARCHY_CPS_V_SN  LH
					  ON CL.DIVISION_ID		= LH.DIVISION_ID
					 AND CL.SITE_ID			= LH.SITE_ID
					 AND CL.COMPANY_ID		= LH.COMPANY_ID
					 AND CL.PLANT_ID		= LH.PLANT_ID
					 AND CL.FACTORY_ID		= LH.FACTORY_ID
					 AND CL.FACTORY_NAME   != LH.FACTORY_NAME -- Factory name 불일치 건
		WHERE 1=1
		  AND LH.FACTORY_ID != '-'		-- factory 목록		
		  AND LH.LINE_ID	 = '-'		-- factory 목록		

	-- end 2025.01.02 더미 라인 site/company/plant/factory 명칭 변경 로직 추가
	-- end 2025.01.02 더미 라인 site/company/plant/factory 명칭 변경 로직 추가


	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

		-----------------------------------------
		------ 임시테이블 정리
		---------------------------------------------
		if object_id('tempdb..#SCM_LINE_HIERARCHY_CPS_V_SN') is not null drop table #SCM_LINE_HIERARCHY_CPS_V_SN


	  END			    
	END TRY

	BEGIN CATCH                  
		if (xact_state() <> 0) ROLLBACK TRAN; 

		-- ERROR LOG                  
		SET @v_log_type = N'ERROR';                  
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
		SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
		SET @d_event_date = SYSDATETIME();                  
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name                  
		                          ,@p_log_type      = @v_log_type                  
		                          ,@p_log_count     = @n_log_count                   
		                          ,@p_log_message   = @v_log_message                   
		                          ,@p_description   = @v_description                   
		                          ,@p_event_date    = @d_event_date                   
		                          ,@p_user_id       = @v_batch_user                  
		                          ;                  
		PRINT @v_log_message      + ' : ' + @v_description ;  
		RETURN -1;    
		
    END CATCH;   

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'##### END of procedure #####';                  
    SET @v_description = N'['  + @v_exec_time + ']';  ;            
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
	PRINT @v_log_message      + ' : ' + @v_description ;          
	RETURN 1;    

END
