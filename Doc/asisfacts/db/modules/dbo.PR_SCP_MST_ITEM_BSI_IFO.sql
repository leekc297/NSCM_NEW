

/*  
 * Program ID   : PR_SCP_MST_ITEM_BSI_IFO
 * Description  : 품목ID 기준 Basic Nick Name 정보를 적재한다. (Basic Model 매핑정보) 
 *				 - Source : SCM_MST_TEM_SN
 *				 - Target : SCP_MST_ITEM_BSI_IFO  
 *							SCP_MST_ITEM_BSI_IFO_H 
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.03.25	hrkim		Initial Release PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2  
 * 2025.03.18	hrkim		PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
 *							- 소형 Final 완성 공정만 대상으로 함
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_MST_ITEM_BSI_IFO] 
AS

BEGIN

-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_ITEM_BSI_IFO'; --Proc별 이름 설정
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

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'FP 품목 Master 기본 정보 - #SCM_MST_ITEM_SN ' 
		----------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCM_MST_ITEM_SN') is not null drop table #SCM_MST_ITEM_SN

		SELECT IM.ITEM_ID
			  ,IM.NICK_NAME 
			  ,IM.DIVISION_ID 
			  ,IM.SCP_OPERATION_GROUP
			  ,IM.DOE					
			  ,IM.APPLIED_MODEL		
			  ,IM.ITEM_TYPE 
			  ,IM.ITEM_CLASS			
			  ,IM.ITEM_CLASS_NAME	
			  ,SUBSTRING(IM.FLOW_ID, 1, 5) AS OPERATION_ID 
			  ,IM.DESCRIPTION
			  ,IM.ACTIVE_FLAG 
			  ,ROW_NUMBER() OVER (PARTITION BY IM.ITEM_ID
									  ORDER BY IM.ACTIVE_FLAG	DESC 
											  ,IM.DOE			DESC 
											  ,IM.APPLIED_MODEL	DESC 
											  ,IM.DESCRIPTION	DESC ) AS ITEM_PRIORITY
		 INTO #SCM_MST_ITEM_SN
		 FROM SCM_MST_ITEM_SN im with(nolock)
		 	  INNER JOIN SCM_MST_DIVISION DM with(nolock)
					  ON DM.DIVISION_ID  = IM.DIVISION_ID
					 AND DM.ATTRIBUTE3   IN ('81', '82') 
		 WHERE 1=1
		   AND ISNULL(IM.ITEM_TYPE, 'Z') != 'R'
		   AND IM.SCP_OPERATION_GROUP IN ('A', 'P')  -- Cell/Pack 정보만 대상으로 함
		   AND IM.ITEM_ID NOT LIKE 'M%'				 -- 2025.03.18 소형 품목 제외 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'FP 품목 Master 기본 정보 - #SCM_MST_ITEM_SN - 소형' 
		-- 2025.03.18 PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산 
		-- 소형 Final 완성 공정만 대상으로 함.
		----------------------------------------------------------------------------------------------------------
		INSERT INTO #SCM_MST_ITEM_SN
		SELECT IM.ITEM_ID
			  ,IM.NICK_NAME 
			  ,IM.DIVISION_ID 
			  ,IM.SCP_OPERATION_GROUP
			  ,IM.DOE					
			  ,IM.APPLIED_MODEL		
			  ,IM.ITEM_TYPE 
			  ,IM.ITEM_CLASS			
			  ,IM.ITEM_CLASS_NAME	
			  ,SUBSTRING(IM.FLOW_ID, 1, 5) AS OPERATION_ID 
			  ,IM.DESCRIPTION
			  ,IM.ACTIVE_FLAG 
			  ,ROW_NUMBER() OVER (PARTITION BY IM.ITEM_ID
									  ORDER BY IM.ACTIVE_FLAG	DESC 
											  ,IM.DOE			DESC 
											  ,IM.APPLIED_MODEL	DESC 
											  ,IM.DESCRIPTION	DESC ) AS ITEM_PRIORITY
		 FROM SCM_MST_ITEM_SN IM with(nolock)
		 	  INNER JOIN SCM_MST_DIVISION DM with(nolock)
					  ON DM.DIVISION_ID  = IM.DIVISION_ID
					 AND DM.ATTRIBUTE3   = '40'
			  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)	-- 소형은 Final Item만 대상으로 함.
					  ON FI.DIVISION_ID	 = IM.DIVISION_ID
					 AND FI.ITEM_ID		 = IM.ITEM_ID
		 WHERE 1=1
		   AND ISNULL(IM.ITEM_TYPE, 'Z') != 'R'
		   AND IM.SCP_OPERATION_GROUP IN ('A', 'P')  -- Cell/Pack 정보만 대상으로 함
		   AND NOT EXISTS (SELECT 'X'
							 FROM #SCM_MST_ITEM_SN AM 
							WHERE 1=1
							  AND AM.ITEM_ID = IM.ITEM_ID) -- AMDMO0001A도 소형 모델 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'Basic Model정보  - #BASIC_MODEL_INFO ' 
		----------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#BASIC_MODEL_INFO') is not null drop table #BASIC_MODEL_INFO

		SELECT IM.*
			  ,AM.DOE	AS  APPLIED_MODEL_DOE
			  ,DS.DOE	AS  DESCRIPTION_DOE 
			  ,CASE WHEN IM.DOE IS NOT NULL	THEN IM.DOE
					WHEN AM.DOE IS NOT NULL	THEN AM.DOE
					WHEN DS.DOE IS NOT NULL	THEN DS.DOE
				END AS APPLIED_DOE 
		 INTO #BASIC_MODEL_INFO
		 FROM #SCM_MST_ITEM_SN IM 
			 LEFT JOIN #SCM_MST_ITEM_SN  AM
					ON AM.ITEM_ID = IM.APPLIED_MODEL
				   AND AM.ITEM_PRIORITY = 1
			 LEFT JOIN #SCM_MST_ITEM_SN  DS
					ON DS.ITEM_ID = IM.DESCRIPTION
				   AND DS.ITEM_PRIORITY = 1
		WHERE 1=1
		  AND IM.ITEM_PRIORITY = 1 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'Basic Model NickName 정보  - #BASIC_NICKNAME_INFO ' 
		----------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#BASIC_NICKNAME_INFO') is not null drop table #BASIC_NICKNAME_INFO

		SELECT BM.*
			  ,IM.NICK_NAME AS BASIC_NICK_NAME 
		 INTO #BASIC_NICKNAME_INFO 
		 FROM #BASIC_MODEL_INFO BM 
			  inner join #SCM_MST_ITEM_SN IM 
					  on IM.ITEM_ID			= BM.APPLIED_DOE 
					 AND IM.ITEM_PRIORITY	= 1 
		WHERE 1=1
		  AND APPLIED_DOE IS NOT  NULL  -- null인 것들은 active_flag 가 'N' 이거나 자동차가 아님!


		-----------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'전극라인유형코드매핑 - #ITEM_CLASS_ELTR_LN_TP_CD_MAPPING ' 
		-----------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#ITEM_CLASS_ELTR_LN_TP_CD_MAPPING') IS NOT NULL	DROP TABLE #ITEM_CLASS_ELTR_LN_TP_CD_MAPPING;
			
		 SELECT SEGMENT1		AS CLASS_ID
			   ,MAX(ATTRIBUTE1)	AS ELTR_LN_TP_CD 
		  INTO #ITEM_CLASS_ELTR_LN_TP_CD_MAPPING   
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		 WHERE 1=1
		   AND LOOKUP_TYPE	= 'ITEM_CLASS_ELTR_LN_TP_CD_MAPPING'
		   AND VALID_YN		= 'Y'
		GROUP BY SEGMENT1


		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'Final 등록 대상 - #SCP_MST_ITEM_BSI_IFO ' 
		----------------------------------------------------------
		--  item_class	item_clasS_name
		--  ES0501		[ANPAN]Anode Notched Pancake
		--  ES0502		[ANPCA]Cathode Notched Pancake
		--  ES1801		[ANCAN]Anode Notched Cut
		--  ES1802		[ANCCA]Cathode Notched Cut
		--  ES0601		[ABCAT]A-Type Bi-Cell
		--  ES0602		[ABCCT]C-Type Bi-Cell
		--  ES1007		[AMCMC]Mono-Type Cell
		--  ES1101		[AHCHC]HALF-Type Cell
		--  ES1015		[AMCST]SRC Mono-Top-Type Cell
		--  ES0701		[AFCFC]Folded Cell
		--  ES0801		[ASCSC]Stacked Cell
		--  ES1701		[AZCZC]Zigzag-Stacked Cell
		----------------------------------------------------------
		----------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCP_MST_ITEM_BSI_IFO') is not null drop table #SCP_MST_ITEM_BSI_IFO

		SELECT BN.ITEM_ID
			  ,BN.SCP_OPERATION_GROUP
			  ,BN.OPERATION_ID
			  ,ISNULL(EL.ELTR_LN_TP_CD, '-')	AS ELTR_LN_TP_CD
			  ,BN.NICK_NAME
			  ,BN.ITEM_TYPE 
			  ,BN.ITEM_CLASS
			  ,BN.ITEM_CLASS_NAME 
			  ,BN.BASIC_NICK_NAME
			  ,BN.APPLIED_DOE
			  ,BN.DOE
			  ,BN.APPLIED_MODEL_DOE
			  ,BN.DESCRIPTION_DOE
			  ,BN.APPLIED_MODEL
			  ,BN.DESCRIPTION
			  ,BN.ACTIVE_FLAG
		INTO #SCP_MST_ITEM_BSI_IFO
		FROM #BASIC_NICKNAME_INFO  BN WITH(NOLOCK)
			 LEFT JOIN #ITEM_CLASS_ELTR_LN_TP_CD_MAPPING  EL 
					ON EL.CLASS_ID = BN.ITEM_CLASS 
		WHERE 1=1

	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

		-- 이력 시퀀스  SEQ1_SCP_MST_ITEM_BSI_IFO_H
		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 변경이력 INSERT INTO SCP_MST_ITEM_BSI_IFO_H ' 
		----------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_ITEM_BSI_IFO_H (
			 HISTORY_SEQ
			,HISTORY_CREATION_DATE
			,ITEM_ID
			,SCP_OPERATION_GROUP
			,OPERATION_ID
			,ELTR_LN_TP_CD
			,NICK_NAME
			,ITEM_TYPE
			,ITEM_CLASS
			,ITEM_CLASS_NAME
			,BASIC_NICK_NAME
			,APPLIED_DOE
			,DOE
			,APPLIED_MODEL_DOE
			,DESCRIPTION_DOE
			,APPLIED_MODEL
			,DESCRIPTION
			,ACTIVE_FLAG
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
		) 
		SELECT 
			 NEXT VALUE FOR SEQ1_SCP_MST_ITEM_BSI_IFO_H AS HISTORY_SEQ
			,GETDATE()									AS HISTORY_CREATION_DATE
			,SP.ITEM_ID
			,SP.SCP_OPERATION_GROUP
			,SP.OPERATION_ID
			,SP.ELTR_LN_TP_CD
			,SP.NICK_NAME
			,SP.ITEM_TYPE
			,SP.ITEM_CLASS
			,SP.ITEM_CLASS_NAME
			,SP.BASIC_NICK_NAME
			,SP.APPLIED_DOE
			,SP.DOE
			,SP.APPLIED_MODEL_DOE
			,SP.DESCRIPTION_DOE
			,SP.APPLIED_MODEL
			,SP.DESCRIPTION
			,SP.ACTIVE_FLAG
			,SP.CREATED_BY
			,SP.CREATION_DATE
			,SP.LAST_UPDATED_BY
			,SP.LAST_UPDATE_DATE
		 FROM SCP_MST_ITEM_BSI_IFO SP
		WHERE 1=1
		  AND EXISTS (SELECT *
							FROM #SCP_MST_ITEM_BSI_IFO TG 
						   WHERE 1=1
							 AND TG.ITEM_ID	= SP.ITEM_ID
							 AND (  -- 변경된 값이 존재할 경우
										 ISNULL(TG.SCP_OPERATION_GROUP	,'Z') != ISNULL(SP.SCP_OPERATION_GROUP	,'Z') 
									 OR ISNULL(TG.OPERATION_ID			,'Z') != ISNULL(SP.OPERATION_ID			,'Z') 
									 OR ISNULL(TG.ELTR_LN_TP_CD			,'Z') != ISNULL(SP.ELTR_LN_TP_CD		,'Z') 
									 OR ISNULL(TG.NICK_NAME				,'Z') != ISNULL(SP.NICK_NAME			,'Z') 
									 OR ISNULL(TG.ITEM_TYPE				,'Z') != ISNULL(SP.ITEM_TYPE			,'Z') 
									 OR ISNULL(TG.ITEM_CLASS			,'Z') != ISNULL(SP.ITEM_CLASS			,'Z') 
									 OR ISNULL(TG.ITEM_CLASS_NAME		,'Z') != ISNULL(SP.ITEM_CLASS_NAME		,'Z') 
									 OR ISNULL(TG.BASIC_NICK_NAME 		,'Z') != ISNULL(SP.BASIC_NICK_NAME 		,'Z') 
									 OR ISNULL(TG.APPLIED_DOE			,'Z') != ISNULL(SP.APPLIED_DOE			,'Z') 
									 OR ISNULL(TG.DOE					,'Z') != ISNULL(SP.DOE					,'Z') 
									 OR ISNULL(TG.APPLIED_MODEL_DOE		,'Z') != ISNULL(SP.APPLIED_MODEL_DOE	,'Z') 
									 OR ISNULL(TG.DESCRIPTION_DOE		,'Z') != ISNULL(SP.DESCRIPTION_DOE		,'Z') 
									 OR ISNULL(TG.APPLIED_MODEL			,'Z') != ISNULL(SP.APPLIED_MODEL		,'Z') 
									 OR ISNULL(TG.DESCRIPTION			,'Z') != ISNULL(SP.DESCRIPTION			,'Z') 
									 OR ISNULL(TG.ACTIVE_FLAG			,'Z') != ISNULL(SP.ACTIVE_FLAG			,'Z') 
							     )
						)

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### MERGE INTO SCP_MST_ITEM_BSI_IFO ' 
		----------------------------------------------------------------------------------------------------------
		MERGE INTO SCP_MST_ITEM_BSI_IFO TGT 
		USING (
				SELECT *
				 FROM #SCP_MST_ITEM_BSI_IFO SP
				WHERE 1=1
				  AND NOT EXISTS (SELECT *
									FROM SCP_MST_ITEM_BSI_IFO TG 
								   WHERE 1=1
									 AND TG.ITEM_ID							  = SP.ITEM_ID
									 AND ISNULL(TG.SCP_OPERATION_GROUP	,'Z') = ISNULL(SP.SCP_OPERATION_GROUP	,'Z') 
									 AND ISNULL(TG.OPERATION_ID			,'Z') = ISNULL(SP.OPERATION_ID			,'Z') 
									 AND ISNULL(TG.ELTR_LN_TP_CD		,'Z') = ISNULL(SP.ELTR_LN_TP_CD			,'Z') 
									 AND ISNULL(TG.NICK_NAME			,'Z') = ISNULL(SP.NICK_NAME				,'Z') 
									 AND ISNULL(TG.ITEM_TYPE			,'Z') = ISNULL(SP.ITEM_TYPE				,'Z') 
									 AND ISNULL(TG.ITEM_CLASS			,'Z') = ISNULL(SP.ITEM_CLASS			,'Z') 
									 AND ISNULL(TG.ITEM_CLASS_NAME		,'Z') = ISNULL(SP.ITEM_CLASS_NAME		,'Z') 
									 AND ISNULL(TG.BASIC_NICK_NAME 		,'Z') = ISNULL(SP.BASIC_NICK_NAME 		,'Z') 
									 AND ISNULL(TG.APPLIED_DOE			,'Z') = ISNULL(SP.APPLIED_DOE			,'Z') 
									 AND ISNULL(TG.DOE					,'Z') = ISNULL(SP.DOE					,'Z') 
									 AND ISNULL(TG.APPLIED_MODEL_DOE	,'Z') = ISNULL(SP.APPLIED_MODEL_DOE		,'Z') 
									 AND ISNULL(TG.DESCRIPTION_DOE		,'Z') = ISNULL(SP.DESCRIPTION_DOE		,'Z') 
									 AND ISNULL(TG.APPLIED_MODEL		,'Z') = ISNULL(SP.APPLIED_MODEL			,'Z') 
									 AND ISNULL(TG.DESCRIPTION			,'Z') = ISNULL(SP.DESCRIPTION			,'Z') 
									 AND ISNULL(TG.ACTIVE_FLAG			,'Z') = ISNULL(SP.ACTIVE_FLAG			,'Z') 
								)
			) SRC
		 ON (	SRC.ITEM_ID				= TGT.ITEM_ID			)
		WHEN MATCHED THEN
			UPDATE SET TGT.LAST_UPDATE_DATE	= SYSDATETIME()
					  ,TGT.LAST_UPDATED_BY	= @v_program_name
					  ,TGT.SCP_OPERATION_GROUP	= SRC.SCP_OPERATION_GROUP	
					  ,TGT.OPERATION_ID			= SRC.OPERATION_ID			
					  ,TGT.ELTR_LN_TP_CD		= SRC.ELTR_LN_TP_CD			
					  ,TGT.NICK_NAME			= SRC.NICK_NAME			
					  ,TGT.ITEM_TYPE			= SRC.ITEM_TYPE			
					  ,TGT.ITEM_CLASS			= SRC.ITEM_CLASS			
					  ,TGT.ITEM_CLASS_NAME		= SRC.ITEM_CLASS_NAME		
					  ,TGT.BASIC_NICK_NAME 		= SRC.BASIC_NICK_NAME 		
					  ,TGT.APPLIED_DOE			= SRC.APPLIED_DOE			
					  ,TGT.DOE					= SRC.DOE					
					  ,TGT.APPLIED_MODEL_DOE	= SRC.APPLIED_MODEL_DOE	
					  ,TGT.DESCRIPTION_DOE		= SRC.DESCRIPTION_DOE		
					  ,TGT.APPLIED_MODEL		= SRC.APPLIED_MODEL		
					  ,TGT.DESCRIPTION			= SRC.DESCRIPTION			
					  ,TGT.ACTIVE_FLAG			= SRC.ACTIVE_FLAG			
		WHEN NOT MATCHED THEN
			INSERT ( ITEM_ID
					,SCP_OPERATION_GROUP	
					,OPERATION_ID			
					,ELTR_LN_TP_CD			
					,NICK_NAME			
					,ITEM_TYPE			
					,ITEM_CLASS			
					,ITEM_CLASS_NAME		
					,BASIC_NICK_NAME 		
					,APPLIED_DOE			
					,DOE					
					,APPLIED_MODEL_DOE	
					,DESCRIPTION_DOE		
					,APPLIED_MODEL		
					,DESCRIPTION			
					,ACTIVE_FLAG			
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					)
			VALUES ( SRC.ITEM_ID
					,SRC.SCP_OPERATION_GROUP	
					,SRC.OPERATION_ID			
					,SRC.ELTR_LN_TP_CD	
					,SRC.NICK_NAME			
					,SRC.ITEM_TYPE			
					,SRC.ITEM_CLASS			
					,SRC.ITEM_CLASS_NAME		
					,SRC.BASIC_NICK_NAME 		
					,SRC.APPLIED_DOE			
					,SRC.DOE					
					,SRC.APPLIED_MODEL_DOE	
					,SRC.DESCRIPTION_DOE		
					,SRC.APPLIED_MODEL		
					,SRC.DESCRIPTION			
					,SRC.ACTIVE_FLAG			
					,@v_program_name
					,GETDATE()
					,@v_program_name
					,GETDATE()
					)
		;


	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

		-----------------------------------------
		------ 임시테이블 정리
		---------------------------------------------
		if object_id('tempdb..#SCM_MST_ITEM_SN') is not null drop table #SCM_MST_ITEM_SN
		if object_id('tempdb..#BASIC_MODEL_INFO') is not null drop table #BASIC_MODEL_INFO
		if object_id('tempdb..#BASIC_NICKNAME_INFO') is not null drop table #BASIC_NICKNAME_INFO
		IF OBJECT_ID('TEMPDB..#ITEM_CLASS_ELTR_LN_TP_CD_MAPPING') IS NOT NULL	DROP TABLE #ITEM_CLASS_ELTR_LN_TP_CD_MAPPING;
		if object_id('tempdb..#SCP_MST_ITEM_BSI_IFO') is not null drop table #SCP_MST_ITEM_BSI_IFO

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
