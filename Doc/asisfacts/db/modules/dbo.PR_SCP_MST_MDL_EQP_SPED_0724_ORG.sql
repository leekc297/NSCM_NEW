


/*  
 * Program ID   : PR_SCP_MST_MDL_EQP_SPED
 * Description  : MMD 설비생산속도 정보 라인/모델별(Basic Nickname) 적재하는 프로시저
 *
 *				 - Source : SCM_MMD_EQPT_PRDT_SPEED_SN	(MMD 설비속도) 				
 *							SCM_MST_EQUIPMENT_SN		(FP 설비Master)
 *							SCP_MST_ITEM_BSI_IFO		(Basic NickName 참조)
 *							SCM_MST_DIVISION	
 *
 *				 - Target : SCP_MST_MDL_EQP_SPED
 *							SCP_MST_MDL_EQP_SPED_H
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.03.15	hrkim		Initial Release PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2  
 * 2024.04.26	hrkim		속도가 다른경우 (모델/라인/설비별:MAX, 모델/라인별:평균)
 * 2024.04.29	hrkim		전극라인유형코드값 로직 수정 (FP설비 Master Product_Leve3_Code참조) 
 * 2024.05.13	hrkim		A7400/A8400(AZS Stacking) 속도 단위 변경
 *							- 전극라인유형코드 매핑시 lookup  추가 참조 (OPERATION_ELECTRODE_TYPE)  
 *							- 공정/전극라인유형별 속도단위 매핑 lookup 추가 (OPERATION_ELECTRODE_TYPE_MAPPING)
 * 2024.05.27	hrkim		소수 자릿수 처리 로직 수정 (FLOAT, NUMERIC(20,10)) 
 * 2025.03.18	hrkim		PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
 *							- A3000/A9000 완성 공정만 대상으로 함
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_MST_MDL_EQP_SPED_0724_ORG] 
AS

BEGIN

-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_MDL_EQP_SPED'; --Proc별 이름 설정
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
		SET @v_description = '[81,82,JV]';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

		-------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 품목ID Basic NickName 정보 #SCP_MST_ITEM_BSI_IFO' 
		-------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCP_MST_ITEM_BSI_IFO') is not null drop table #SCP_MST_ITEM_BSI_IFO;

		SELECT ITEM_ID
			  ,SCP_OPERATION_GROUP
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,BASIC_NICK_NAME 
		 INTO #SCP_MST_ITEM_BSI_IFO
		 FROM SCP_MST_ITEM_BSI_IFO WITH(NOLOCK) 
		WHERE 1=1

		-----------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 설비 Product Level3코드에 대한 전극라인유형코드 정보 - #OPERATION_ELECTRODE_TYPE' -- 5/13  추가 
		-----------------------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#OPERATION_ELECTRODE_TYPE') is not null drop table #OPERATION_ELECTRODE_TYPE;

		 SELECT SEGMENT1		AS DIVISION_ID
			   ,SEGMENT2		AS OPERATION_ID
			   ,SEGMENT3		AS ELTR_LN_TP_CD
			   ,MAX(ATTRIBUTE1)	AS EQP_SPED_UNIT_CD 
		  INTO #OPERATION_ELECTRODE_TYPE
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		 WHERE 1=1
		   AND LOOKUP_TYPE = 'OPERATION_ELECTRODE_TYPE'
		   AND VALID_YN = 'Y'
		GROUP BY SEGMENT1
				,SEGMENT2
				,SEGMENT3
   
		-----------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 설비 Product Level3코드에 대한 전극라인유형코드 정보 - #OPERATION_ELECTRODE_TYPE_MAPPING' -- 5/13  추가 
		-----------------------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#OPERATION_ELECTRODE_TYPE_MAPPING') is not null drop table #OPERATION_ELECTRODE_TYPE_MAPPING;

		 SELECT SEGMENT1		AS DIVISION_ID
			   ,SEGMENT2		AS OPERATION_ID
			   ,SEGMENT3		AS EQP_ID_4_3
			   ,MAX(ATTRIBUTE1)	AS ELTR_LN_TP_CD 
		  INTO #OPERATION_ELECTRODE_TYPE_MAPPING
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		 WHERE 1=1
		   AND LOOKUP_TYPE = 'OPERATION_ELECTRODE_TYPE_MAPPING' 
		   AND VALID_YN = 'Y'
		GROUP BY SEGMENT1
				,SEGMENT2
				,SEGMENT3

		-----------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 설비 Product Level3코드에 대한 전극라인유형코드 정보 - #EQUIPMENT_PRODUCT_LEVEL3_CODE' 
		-----------------------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#EQUIPMENT_PRODUCT_LEVEL3_CODE') is not null drop table #EQUIPMENT_PRODUCT_LEVEL3_CODE;

		 SELECT SEGMENT1		AS OPERATION_ID
			   ,SEGMENT2		AS EQP_PRODUCT_LEVEL3_CODE
			   ,MAX(ATTRIBUTE1)	AS ELTR_LN_TP_CD 
		  INTO #EQUIPMENT_PRODUCT_LEVEL3_CODE
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		 WHERE 1=1
		   AND LOOKUP_TYPE = 'EQUIPMENT_PRODUCT_LEVEL3_CODE'
		   AND VALID_YN = 'Y'
		GROUP BY SEGMENT1
				,SEGMENT2

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### FP 설비 Master - #SCM_MST_EQUIPMENT_SN' 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCM_MST_EQUIPMENT_SN') is not null drop table #SCM_MST_EQUIPMENT_SN

		SELECT EM.COMPANY_ID
			  ,EM.DIVISION_ID
			  ,EM.SITE_ID
			  ,EM.PLANT_ID
			  ,EM.FACTORY_ID
			  ,EM.EQUIPMENT_ID
			  ,EM.OPERATION_ID
			  ,EM.ELECTRODE_TYPE 
			  ,CASE  WHEN PL.ELTR_LN_TP_CD IS NOT NULL									THEN PL.ELTR_LN_TP_CD	-- lookup EQUIPMENT_PRODUCT_LEVEL3_CODE : FP설비Product Level3 코드 값에 따른 전극/라인유형
					 WHEN ET.ELTR_LN_TP_CD IS NOT NULL									THEN ET.ELTR_LN_TP_CD   -- lookup OPERATION_ELECTRODE_TYPE_MAPPING : A8000/A8400 설비ID 4번째 3자리에 대한 전극/라인유형 매핑 
					 WHEN EM.OPERATION_ID = 'A7400'	AND EM.ELECTRODE_TYPE = 'A'			THEN 'Anode'			-- CPM 기준 PPM계산시 전극수량 참조를 위함(UI참조 Lookup과 매핑을 위해서도).
					 WHEN EM.OPERATION_ID = 'A7400'	AND EM.ELECTRODE_TYPE = 'C'			THEN 'Cathode'			-- CPM 기준 PPM계산시 전극수량 참조를 위함(UI참조 Lookup과 매핑을 위해서도).
					 WHEN EM.OPERATION_ID like 'P%' OR  EM.OPERATION_ID = 'A9000' 		THEN '-'				
					 ELSE EM.ELECTRODE_TYPE
				END  AS ELTR_LN_TP_CD 
			  ,EM.LINE_ID
		 INTO #SCM_MST_EQUIPMENT_SN 
		 FROM SCM_MST_EQUIPMENT_SN   EM  WITH(NOLOCK)
			  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
					  ON DM.DIVISION_ID	= EM.DIVISION_ID
					 AND DM.VALID_YN		= 'Y'
					 AND DM.ATTRIBUTE3		IN ('81', '82')  -- JV포함 
			  LEFT  JOIN #EQUIPMENT_PRODUCT_LEVEL3_CODE PL	 -- 20240429 추가
					  ON PL.OPERATION_ID			= EM.OPERATION_ID
					 AND PL.EQP_PRODUCT_LEVEL3_CODE = EM.PRODUCT_LEVEL3_CODE 
			  LEFT  JOIN #OPERATION_ELECTRODE_TYPE_MAPPING ET -- A8000/A8400 공정에 대한 전극/라인 유형 매핑 
					  ON ET.DIVISION_ID		= EM.DIVISION_ID
					 AND ET.OPERATION_ID	= EM.OPERATION_ID
					 AND ET.EQP_ID_4_3		= SUBSTRING(EM.EQUIPMENT_ID, 4, 3) 
		WHERE 1=1
		  AND EM.EQUIPMENT_TYPE  = 'M'		-- Main 설비
		  AND EM.ACTIVE_FLAG	 = 'Y' 
		  AND EM.OPERATION_ID   LIKE 'A%'	-- 셀만 

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### FP 설비 Master - #SCM_MST_EQUIPMENT_SN - 소형' 
		-- 2025.03.18 PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
		-- 완성 공정만 대상으로 함 : 셀 : A3000, A9000 
		---------------------------------------------------------------------------------------------------
		INSERT INTO #SCM_MST_EQUIPMENT_SN 
		SELECT EM.COMPANY_ID
			  ,EM.DIVISION_ID
			  ,EM.SITE_ID
			  ,EM.PLANT_ID
			  ,EM.FACTORY_ID
			  ,EM.EQUIPMENT_ID
			  ,EM.OPERATION_ID
			  ,EM.ELECTRODE_TYPE 
			  ,'-'	  AS ELTR_LN_TP_CD 
			  ,EM.LINE_ID
		 FROM SCM_MST_EQUIPMENT_SN   EM  WITH(NOLOCK)
			  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
					  ON DM.DIVISION_ID	= EM.DIVISION_ID
					 AND DM.VALID_YN		= 'Y'
					 AND DM.ATTRIBUTE3		= '40' -- 소형  
		WHERE 1=1
		  AND EM.EQUIPMENT_TYPE  = 'M'		-- Main 설비
		  AND EM.ACTIVE_FLAG	 = 'Y' 
		  AND EM.OPERATION_ID    IN ('A3000', 'A9000') --- LIKE 'A%'	-- 셀만

		------------------------------------------------------------------------------------------------------------------
		--print  convert(varchar(30), getdate(), 121) + N' ### A8000/A8400 공정에 대한 라인유형 매핑이 안된 설비 제외' 
		---- A8000공정의 AZS, ZZS 등 
		------------------------------------------------------------------------------------------------------------------
		--DELETE 
		-- FROM #SCM_MST_EQUIPMENT_SN
		--WHERE 1=1
		--   AND (OPERATION_ID IN ('A8000', 'A8400')  AND ELTR_LN_TP_CD = '-') 



		------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'MMD설비 속도 정보 추출 - #SCM_MMD_EQPT_PRDT_SPEED_SN ' 
		------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCM_MMD_EQPT_PRDT_SPEED_SN') is not null drop table #SCM_MMD_EQPT_PRDT_SPEED_SN

		 SELECT EQP_ID
			   ,BOM_ITEM_ID					AS ITEM_ID
			   ,CONVERT(FLOAT, EQP_SPED)	AS EQP_SPED
		  INTO #SCM_MMD_EQPT_PRDT_SPEED_SN 
		  FROM SCM_MMD_EQPT_PRDT_SPEED_SN with(nolock)
		 WHERE 1=1
		   AND USE_FLAG = 'Y'
		   AND BOM_ITEM_ID NOT LIKE '%:%'	-- 2025.03.18
		   AND BOM_ITEM_ID NOT LIKE '%/%'	-- 2025.03.18

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 설비 Master정보와 Basic Nickname 매핑' 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#BASIC_NICKNAME_MAPPING') is not null drop table #BASIC_NICKNAME_MAPPING

		SELECT SM.EQP_ID
			  ,SM.ITEM_ID
			  ,CONVERT(FLOAT, SM.EQP_SPED)	AS EQP_SPED
			  ,CASE WHEN BI.SCP_OPERATION_GROUP = 'E' 
					THEN SM.ITEM_ID
					ELSE ISNULL(BI.BASIC_NICK_NAME, SM.ITEM_ID)		
				END AS BASIC_NICK_NAME 
			  ,EM.COMPANY_ID
			  ,EM.DIVISION_ID
			  ,EM.SITE_ID
			  ,EM.PLANT_ID
			  ,EM.FACTORY_ID
			  ,EM.EQUIPMENT_ID
			  ,EM.OPERATION_ID
			  ,CASE WHEN EM.ELTR_LN_TP_CD = '-' AND EM.OPERATION_ID = BI.OPERATION_ID
					THEN BI.ELTR_LN_TP_CD
					ELSE EM.ELTR_LN_TP_CD
				END AS ELTR_LN_TP_CD 
			  ,EM.LINE_ID
		INTO #BASIC_NICKNAME_MAPPING 
		FROM #SCM_MMD_EQPT_PRDT_SPEED_SN SM 
			  INNER JOIN #SCM_MST_EQUIPMENT_SN EM
					  ON EM.EQUIPMENT_ID = SM.EQP_ID
			  LEFT  JOIN #SCP_MST_ITEM_BSI_IFO BI
					  ON BI.ITEM_ID		= SM.ITEM_ID
		WHERE 1=1

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' SCP_MST_MDL_EQP_SPED 최종 등록 대상 Target ' 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCP_MST_MDL_EQP_SPED') is not null drop table #SCP_MST_MDL_EQP_SPED

		;WITH EQPB_SPED_MAX AS (
			SELECT  NM.BASIC_NICK_NAME		AS MDL_NM
				   ,NM.COMPANY_ID
				   ,NM.DIVISION_ID
				   ,NM.SITE_ID
				   ,NM.PLANT_ID
				   ,NM.FACTORY_ID
				   ,NM.OPERATION_ID
				   ,NM.ELTR_LN_TP_CD
				   ,NM.LINE_ID
				   ,NM.EQP_ID
				   ,ISNULL(SU.EQP_SPED_UNIT_CD, 'TTT')		AS EQP_SPED_UNIT_CD
				   ,CONVERT(FLOAT, MAX(EQP_SPED))			AS EQP_SPED		-- 동일 설비의 MAX 
			 FROM #BASIC_NICKNAME_MAPPING  NM
				  LEFT JOIN #OPERATION_ELECTRODE_TYPE SU 
						 ON SU.DIVISION_ID		= NM.DIVISION_ID
						AND SU.OPERATION_ID		= NM.OPERATION_ID
						AND SU.ELTR_LN_TP_CD	= NM.ELTR_LN_TP_CD
			WHERE 1=1
			  AND EQP_SPED IS NOT NULL		--- 속도가 NULL 건 제외 
			GROUP BY NM.BASIC_NICK_NAME
				   ,NM.COMPANY_ID
				   ,NM.DIVISION_ID
				   ,NM.SITE_ID
				   ,NM.PLANT_ID
				   ,NM.FACTORY_ID
				   ,NM.OPERATION_ID
				   ,NM.ELTR_LN_TP_CD
				   ,NM.LINE_ID
				   ,NM.EQP_ID
				   ,ISNULL(SU.EQP_SPED_UNIT_CD, 'TTT')
		)
		SELECT  MDL_NM
			   ,COMPANY_ID
			   ,DIVISION_ID
			   ,SITE_ID
			   ,PLANT_ID
			   ,FACTORY_ID
			   ,OPERATION_ID
			   ,ELTR_LN_TP_CD
			   ,LINE_ID
			   ,COUNT(DISTINCT EQP_ID)					AS EQP_NBU
			   ,CONVERT(FLOAT, AVG(EQP_SPED))			AS EQP_SPED		-- 동일 Line 평균 
			   ,MAX(EQP_SPED_UNIT_CD)					AS EQP_SPED_UNIT_CD
			   ,'Y'										AS USE_YN
			   ,'N'										AS UI_UPD_YN 
		 INTO #SCP_MST_MDL_EQP_SPED
		 FROM EQPB_SPED_MAX
		WHERE 1=1
		GROUP BY MDL_NM
			   ,COMPANY_ID
			   ,DIVISION_ID
			   ,SITE_ID
			   ,PLANT_ID
			   ,FACTORY_ID
			   ,OPERATION_ID
			   ,ELTR_LN_TP_CD
			   ,LINE_ID



	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 기 생성 데이터 변경(상태변경 포함)전 이력생성  ' 
		----------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_MDL_EQP_SPED_H (  
			 HISTORY_SEQ
			,HISTORY_CREATION_DATE
			,MDL_NM
			,DIVISION_ID
			,COMPANY_ID
			,SITE_ID
			,PLANT_ID
			,FACTORY_ID
			,LINE_ID
			,OPERATION_ID
			,ELTR_LN_TP_CD
			--------------
			,EQP_NBU
			,EQP_SPED
			,EQP_SPED_UNIT_CD
			,USE_YN
			,UI_UPD_YN
			--------------
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE1
			,ATTRIBUTE2
			,ATTRIBUTE3
			,ATTRIBUTE4
			,ATTRIBUTE5
			,ATTRIBUTE6
			,ATTRIBUTE7
			,ATTRIBUTE8
			,ATTRIBUTE9
			,ATTRIBUTE10
		) 
		SELECT 
			 NEXT VALUE FOR SEQ1_SCP_MST_MDL_EQP_SPED_H AS HISTORY_SEQ
			,GETDATE()									AS HISTORY_CREATION_DATE
			,SP.MDL_NM
			,SP.DIVISION_ID
			,SP.COMPANY_ID
			,SP.SITE_ID
			,SP.PLANT_ID
			,SP.FACTORY_ID
			,SP.LINE_ID
			,SP.OPERATION_ID
			,SP.ELTR_LN_TP_CD
			-----------------
			,SP.EQP_NBU
			,SP.EQP_SPED
			,SP.EQP_SPED_UNIT_CD
			,SP.USE_YN
			,SP.UI_UPD_YN
			-----------------
			,SP.CREATED_BY
			,SP.CREATION_DATE
			,SP.LAST_UPDATED_BY
			,SP.LAST_UPDATE_DATE
			,SP.ATTRIBUTE1
			,SP.ATTRIBUTE2
			,SP.ATTRIBUTE3
			,SP.ATTRIBUTE4
			,SP.ATTRIBUTE5
			,SP.ATTRIBUTE6
			,SP.ATTRIBUTE7
			,SP.ATTRIBUTE8
			,SP.ATTRIBUTE9
			,SP.ATTRIBUTE10
		 FROM SCP_MST_MDL_EQP_SPED SP WITH(NOLOCK)
		WHERE 1=1
		  AND ((NOT EXISTS (SELECT *  -- MMD에 없는 정보 (use_yn = 'Y') 
							FROM #SCP_MST_MDL_EQP_SPED TG WITH(NOLOCK)
						   WHERE 1=1
						     AND TG.MDL_NM			= SP.MDL_NM
							 AND TG.DIVISION_ID		= SP.DIVISION_ID
							 AND TG.COMPANY_ID		= SP.COMPANY_ID
							 AND TG.SITE_ID			= SP.SITE_ID
							 AND TG.PLANT_ID		= SP.PLANT_ID
							 AND TG.FACTORY_ID		= SP.FACTORY_ID
							 AND TG.LINE_ID			= SP.LINE_ID
							 AND TG.OPERATION_ID	= SP.OPERATION_ID
							 AND TG.ELTR_LN_TP_CD	= SP.ELTR_LN_TP_CD
							) 
					AND  SP.USE_YN		= 'Y'
					AND	 SP.UI_UPD_YN	= 'N'
				)   
			   OR 
				   EXISTS (SELECT top 1 *	-- use_yn = 'Y'인 MMD가 존재하는데 값이 일치하지 않는 경우 
							FROM #SCP_MST_MDL_EQP_SPED TG WITH(NOLOCK)
						   WHERE 1=1
						     AND TG.MDL_NM			= SP.MDL_NM
							 AND TG.DIVISION_ID		= SP.DIVISION_ID
							 AND TG.COMPANY_ID		= SP.COMPANY_ID
							 AND TG.SITE_ID			= SP.SITE_ID
							 AND TG.PLANT_ID		= SP.PLANT_ID
							 AND TG.FACTORY_ID		= SP.FACTORY_ID
							 AND TG.LINE_ID			= SP.LINE_ID
							 AND TG.OPERATION_ID	= SP.OPERATION_ID
							 AND TG.ELTR_LN_TP_CD	= SP.ELTR_LN_TP_CD
							 AND (   TG.USE_YN				!= SP.USE_YN 
							      OR TG.UI_UPD_YN			!= SP.UI_UPD_YN
								  OR TG.EQP_NBU				!= SP.EQP_NBU
								  OR TG.EQP_SPED			!= SP.EQP_SPED
								  OR TG.EQP_SPED_UNIT_CD	!= SP.EQP_SPED_UNIT_CD
								  )
							 )
				)
		------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### MMD없는 데이터 상태 Update ' 
		------------------------------------------------------------------------------------------------------------
		UPDATE SP
		  SET USE_YN			= 'N'
			, LAST_UPDATE_DATE	= GETDATE()
			, LAST_UPDATED_BY	= @v_program_name
		 FROM SCP_MST_MDL_EQP_SPED SP WITH(NOLOCK)
		WHERE 1=1
		  AND USE_YN	= 'Y'
		  AND UI_UPD_YN = 'N'  -- UI에서 등록된 데이터는 제외 
		  AND NOT EXISTS  (SELECT *  -- MMD에 없는 정보 (use_yn = 'Y') 
							FROM #SCP_MST_MDL_EQP_SPED TG WITH(NOLOCK)
						   WHERE 1=1
						     AND TG.MDL_NM			= SP.MDL_NM
							 AND TG.DIVISION_ID		= SP.DIVISION_ID
							 AND TG.COMPANY_ID		= SP.COMPANY_ID
							 AND TG.SITE_ID			= SP.SITE_ID
							 AND TG.PLANT_ID		= SP.PLANT_ID
							 AND TG.FACTORY_ID		= SP.FACTORY_ID
							 AND TG.LINE_ID			= SP.LINE_ID
							 AND TG.OPERATION_ID	= SP.OPERATION_ID
							 AND TG.ELTR_LN_TP_CD	= SP.ELTR_LN_TP_CD
							) 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### MERGE INTO SCP_MST_MDL_EQP_SPED ' 
		----------------------------------------------------------------------------------------------------------
		MERGE INTO SCP_MST_MDL_EQP_SPED TGT
		USING (
				SELECT *
				 FROM #SCP_MST_MDL_EQP_SPED SP
				WHERE 1=1
				  AND NOT EXISTS (SELECT *
									FROM SCP_MST_MDL_EQP_SPED TG
								   WHERE 1=1
									 AND TG.MDL_NM				= SP.MDL_NM
									 AND TG.DIVISION_ID			= SP.DIVISION_ID
									 AND TG.COMPANY_ID			= SP.COMPANY_ID
									 AND TG.SITE_ID				= SP.SITE_ID
									 AND TG.PLANT_ID			= SP.PLANT_ID
									 AND TG.FACTORY_ID			= SP.FACTORY_ID
									 AND TG.LINE_ID				= SP.LINE_ID
									 AND TG.OPERATION_ID		= SP.OPERATION_ID
									 AND TG.ELTR_LN_TP_CD		= SP.ELTR_LN_TP_CD
									 AND TG.USE_YN				= SP.USE_YN
									 AND TG.UI_UPD_YN			= SP.UI_UPD_YN
									 AND TG.EQP_NBU				= SP.EQP_NBU
									 AND TG.EQP_SPED			= SP.EQP_SPED
									 AND TG.EQP_SPED_UNIT_CD	= SP.EQP_SPED_UNIT_CD
								)
			) SRC
		 ON (	SRC.MDL_NM				= TGT.MDL_NM
			AND SRC.DIVISION_ID			= TGT.DIVISION_ID
			AND SRC.COMPANY_ID			= TGT.COMPANY_ID
			AND SRC.SITE_ID				= TGT.SITE_ID
			AND SRC.PLANT_ID			= TGT.PLANT_ID
			AND SRC.FACTORY_ID			= TGT.FACTORY_ID
			AND SRC.LINE_ID				= TGT.LINE_ID
			AND SRC.OPERATION_ID		= TGT.OPERATION_ID
			AND SRC.ELTR_LN_TP_CD		= TGT.ELTR_LN_TP_CD
			)
		WHEN MATCHED THEN
			UPDATE SET TGT.LAST_UPDATE_DATE	= SYSDATETIME()
					  ,TGT.LAST_UPDATED_BY	= @v_program_name
					  ,TGT.USE_YN			= SRC.USE_YN
					  ,TGT.UI_UPD_YN		= SRC.UI_UPD_YN
					  ,TGT.EQP_NBU			= SRC.EQP_NBU
					  ,TGT.EQP_SPED			= SRC.EQP_SPED
					  ,TGT.EQP_SPED_UNIT_CD	= SRC.EQP_SPED_UNIT_CD 
		WHEN NOT MATCHED THEN
			INSERT ( MDL_NM
					,DIVISION_ID
					,COMPANY_ID
					,SITE_ID
					,PLANT_ID
					,FACTORY_ID
					,LINE_ID
					,OPERATION_ID
					,ELTR_LN_TP_CD
					,EQP_NBU
					,EQP_SPED
					,EQP_SPED_UNIT_CD
					,USE_YN
					,UI_UPD_YN
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					)
			VALUES ( SRC.MDL_NM
					,SRC.DIVISION_ID
					,SRC.COMPANY_ID
					,SRC.SITE_ID
					,SRC.PLANT_ID
					,SRC.FACTORY_ID
					,SRC.LINE_ID
					,SRC.OPERATION_ID
					,SRC.ELTR_LN_TP_CD
					,SRC.EQP_NBU
					,SRC.EQP_SPED
					,SRC.EQP_SPED_UNIT_CD
					,SRC.USE_YN
					,SRC.UI_UPD_YN
					,@v_program_name
					,GETDATE()
					,@v_program_name
					,GETDATE()
					)
		;


	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

		-------------------------------------------
		-------- 임시테이블 정리
		-------------------------------------------------
		if object_id('tempdb..#SCP_MST_ITEM_BSI_IFO') is not null drop table #SCP_MST_ITEM_BSI_IFO;
		if object_id('tempdb..#EQUIPMENT_PRODUCT_LEVEL3_CODE') is not null drop table #EQUIPMENT_PRODUCT_LEVEL3_CODE;
		if object_id('tempdb..#SCM_MST_EQUIPMENT_SN') is not null drop table #SCM_MST_EQUIPMENT_SN
		if object_id('tempdb..#SCM_MMD_EQPT_PRDT_SPEED_SN') is not null drop table #SCM_MMD_EQPT_PRDT_SPEED_SN
		if object_id('tempdb..#BASIC_NICKNAME_MAPPING') is not null drop table #BASIC_NICKNAME_MAPPING
		if object_id('tempdb..#SCP_MST_MDL_EQP_SPED') is not null drop table #SCP_MST_MDL_EQP_SPED

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
    SET @v_description = N'[81,82,JV]['  + @v_exec_time + ']';  ;            
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
