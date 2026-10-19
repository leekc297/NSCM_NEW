

CREATE PROCEDURE [dbo].[PR_SCM_DNM_INPT_PRDN_DDLY]
AS
/*
 * Program ID   : PR_SCM_DNM_INPT_PRDN_DDLY
 * Description  : DW 투입/생산실적 일데이터 적재 
 *					-- 소스 테이블 : XIF_DW_INPT_PRDN_R_SN
 *					-- 타겟 테이블 : SCM_DNM_INPT_PRDN_DDLY
 *				
 *				* DW 원천 테이블 : GDW_DW_MGR.VIFO_GDW_PRD_INPUT_DAILY_YLD_H
 *				* DW ESMI 배치(서머타임 적용 기준 한국시간 20시 배치) 
 *				* DW 표준리포트 월마감 완료일의 ESMI 배치
 *				* DW 표준리포트의 월마감 완료일은 원천 시스템 마감상황에 따라 유동적임
 *				* 아주 가끔씩 월마감 완료됐는데 그 다음날에 특정사이트 배치 재수행하는 경우 있음
 *				* 월 마감되면 그 다음날 기준 첫 사이트 배치(한국 06시) 배치때 전월 데이터 삭제됨.
 * 
 * 
 * Program History
 * 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.06.19	hrkim		   Initial Release PJ2024-50026 / LGES2024-002455   Capa. 관리 시스템 구축
 * 2024.06.27	hrkim		   월말일 확인 check 로직 주석처리 (당월IF 데이터 처리를 위해)  
 * 2024.06.28	hrkim		   DW월마감 이후 특정 사이트(플랜트)만 재적재하는 경우 대비 사이트/플랜트별 처리  
 * 
 */

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
	DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_INPT_PRDN_DDLY';
	DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
	DECLARE @n_log_count    INTEGER = 0;
	DECLARE @v_log_message  NVARCHAR(1000);
	DECLARE @v_description  NVARCHAR(500);
	DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 

	-- 시작 LOG
	SET @v_log_type    = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date  = SYSDATETIME();
	
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  BEGIN TRY
    BEGIN

	  BEGIN TRAN

	  /*===================================== 인터페이스 대상 =====================================*/	  
 		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 인터페이스 처리 대상 데이터 상태 처리' 
		---------------------------------------------------------------------------------------------------
		UPDATE XIF_DW_INPT_PRDN_R_SN 
		   SET TRANSFER_FLAG = 'P' 
         WHERE TRANSFER_FLAG = 'N';

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 인터페이스 처리 대상 데이터 추출' 
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('dbo.XIF_DW_INPT_PRDN_R_SN$') IS NOT NULL DROP TABLE XIF_DW_INPT_PRDN_R_SN$
		SELECT * 
			  ,SUBSTRING(MIN(CAL_YMD_ID)				OVER (PARTITION BY IFSEQNO), 1, 6)		AS TG_YM 
			  ,MIN(CAL_YMD_ID)						    OVER (PARTITION BY IFSEQNO)				AS FROM_YMD 
			  ,MAX(CAL_YMD_ID)						    OVER (PARTITION BY IFSEQNO)				AS TO_YMD 
			  ,COUNT(*)								    OVER (PARTITION BY IFSEQNO)				AS TG_CNT 
			  ,CONVERT(NUMERIC, ISNULL(MAX(ATTRIBUTE1)  OVER (PARTITION BY IFSEQNO), 0))		AS IF_CNT 
		INTO   XIF_DW_INPT_PRDN_R_SN$
		FROM   XIF_DW_INPT_PRDN_R_SN WITH(NOLOCK)
		WHERE  TRANSFER_FLAG = 'P'

		SET @n_log_count = @@ROWCOUNT;
	  
		-----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 인터페이스 처리 대상 IFSEQNO 건수 및 최종 여부 ' 
		-----------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('dbo.TGT_IFSEQNO$') IS NOT NULL DROP TABLE TGT_IFSEQNO$

		;WITH TARGET_LIST AS ( 
		  SELECT DISTINCT IFSEQNO
						, TG_YM
						, FROM_YMD
						, TO_YMD
						, TG_CNT
						, IF_CNT
						, SITE_ID	-- 6/28
						, PLANT_ID	-- 6/28
						, CONVERT(NVARCHAR(8), DATEADD(DAY, -1, DATEADD(MONTH, 1, CONVERT(DATE, FROM_YMD, 112))), 112)  AS TO_YMD_CHK
						, CASE WHEN FROM_YMD LIKE '%01' 
									AND TG_CNT = IF_CNT
									--- 6/27  AND TO_YMD = CONVERT(NVARCHAR(8), DATEADD(DAY, -1, DATEADD(MONTH, 1, CONVERT(DATE, FROM_YMD, 112))), 112)
							   THEN 'Y'
							   ELSE 'N'
						  END  IS_VALID
		   FROM XIF_DW_INPT_PRDN_R_SN$
		)
		SELECT *
			 ,ROW_NUMBER() OVER (PARTITION BY TG_YM
											 ,IS_VALID
											 ,SITE_ID	-- 사이트별 (DW 월마감이후 특정 사이트(일부 플랜트?)만 재적재하는 경우 있을 수 있음) 6/28 추가
											 ,PLANT_ID	-- 플랜트별 (DW 월마감이후 특정 사이트(일부 플랜트?)만 재적재하는 경우 있을 수 있음) 6/28 추가
									 ORDER BY IFSEQNO DESC ) AS RN 
	     INTO TGT_IFSEQNO$
		 FROM TARGET_LIST TL

		-----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Target테이블 기 등록 데이터 삭제  (Delete)' 
		-----------------------------------------------------------------------------------------------------------
		DELETE TG
		  FROM TGT_IFSEQNO$ TI
			   INNER JOIN SCM_DNM_INPT_PRDN_DDLY TG WITH(NOLOCK)
					   ON TG.CAL_YMD_ID BETWEEN TI.FROM_YMD
											AND TI.TO_YMD 
					  AND TG.SITE_ID	= TI.SITE_ID	-- 6/28
					  AND TG.PLANT_ID	= TI.PLANT_ID	-- 6/28
		 WHERE 1=1
		   AND TI.IS_VALID = 'Y'
		   AND TI.RN		= 1 

		-----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Target테이블 등록 (Insert)' 
		-----------------------------------------------------------------------------------------------------------
		INSERT INTO SCM_DNM_INPT_PRDN_DDLY (
				CAL_YMD_ID
			,   SITE_ID
			,   PRODUCT_ID
			,   MATERIAL_ID
			,   LOT_TYPE_ID
			,   LINE_ID
			,   PROCESS_ID
			,   EQPT_ID
			,   AREA_ID
			,   PLANT_ID
			,   CONVERT_RATE
			,   CONV_VAR
			,   LOT_TYPE_NAME_KO
			,   INPUT_QTY
			,   OUT_INPUT_QTY
			,   DEFECT_QTY
			,   OUT_DEFECT_QTY
			,   GOOD_QTY
			,   OUT_GOOD_QTY
			,   CREATED_BY
			,   CREATION_DATE
			,   LAST_UPDATED_BY
			,   LAST_UPDATE_DATE
			,   ATTRIBUTE1
			,   ATTRIBUTE2
			,   ATTRIBUTE3
			,   ATTRIBUTE4
			,   ATTRIBUTE5
			,   ATTRIBUTE6
			,   ATTRIBUTE7
			,   ATTRIBUTE8
			,   ATTRIBUTE9
			,   ATTRIBUTE10
			,   ATTRIBUTE11
			,   ATTRIBUTE12
			,   ATTRIBUTE13
			,   ATTRIBUTE14
			,   ATTRIBUTE15
		)
		SELECT 
				SC.CAL_YMD_ID
			,   SC.SITE_ID
			,   SC.PRODUCT_ID
			,   SC.MATERIAL_ID
			,   SC.LOT_TYPE_ID
			,   SC.LINE_ID
			,   SC.PROCESS_ID
			,   SC.EQPT_ID
			,   SC.AREA_ID
			,   SC.PLANT_ID
			,   SC.CONVERT_RATE
			,   SC.CONV_VAR
			,   SC.LOT_TYPE_NAME_KO
			,   SC.INPUT_QTY
			,   SC.OUT_INPUT_QTY
			,   SC.DEFECT_QTY
			,   SC.OUT_DEFECT_QTY
			,   SC.GOOD_QTY
			,   SC.OUT_GOOD_QTY
			,	@v_program_name							AS CREATED_BY
			,	getdate()								AS CREATION_DATE
			,	@v_program_name							AS LAST_UPDATED_BY
			,	getdate()								AS LAST_UPDATE_DATE 
			,   SC.ATTRIBUTE1
			,   SC.ATTRIBUTE2
			,   SC.ATTRIBUTE3
			,   SC.ATTRIBUTE4
			,   SC.ATTRIBUTE5
			,   SC.ATTRIBUTE6
			,   SC.ATTRIBUTE7
			,   SC.ATTRIBUTE8
			,   SC.ATTRIBUTE9
			,   SC.IFSEQNO								AS ATTRIBUTE10 -- 사용안함  
			,   SC.ATTRIBUTE11
			,   SC.ATTRIBUTE12
			,   SC.ATTRIBUTE13
			,   SC.ATTRIBUTE14
			,   SC.ATTRIBUTE15
		  FROM TGT_IFSEQNO$ TI
			   INNER JOIN XIF_DW_INPT_PRDN_R_SN$ SC WITH(NOLOCK)
					   ON SC.IFSEQNO	= TI.IFSEQNO 
					  AND SC.CAL_YMD_ID BETWEEN TI.FROM_YMD 
											AND TI.TO_YMD 
					  AND SC.SITE_ID	= TI.SITE_ID	-- 6/28
					  AND SC.PLANT_ID	= TI.PLANT_ID	-- 6/28
		 WHERE 1=1
		   AND TI.IS_VALID = 'Y'
		   AND TI.RN		= 1 


		-----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 처리 완료된 데이터 상태 처리' 
		-----------------------------------------------------------------------------------------------------------
		UPDATE SC 
		   SET SC.TRANSFER_FLAG = CASE WHEN TI.IS_VALID = 'Y' AND TI.RN = 1
									THEN 'Y'
									ELSE 'Z'
								END 
			  ,SC.TRANSFER_DATE = GETDATE()
		  FROM XIF_DW_INPT_PRDN_R_SN SC
			   INNER JOIN TGT_IFSEQNO$ TI WITH(NOLOCK)
					   ON SC.IFSEQNO = TI.IFSEQNO 
		 WHERE 1=1
		   AND SC.TRANSFER_FLAG = 'P'


	  COMMIT TRAN

      IF OBJECT_ID('dbo.XIF_DW_INPT_PRDN_R_SN$') IS NOT NULL DROP TABLE XIF_DW_INPT_PRDN_R_SN$
      IF OBJECT_ID('dbo.TGT_IFSEQNO$') IS NOT NULL DROP TABLE TGT_IFSEQNO$

    END
  END TRY

  BEGIN CATCH
		ROLLBACK TRAN
		-- ERROR LOG
		SET @v_log_type    = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		RETURN -1;

  END CATCH;

		SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
							 REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
		-- 종료 LOG
		SET @v_log_type    = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = N'['  + @v_exec_time + ']';  ;            
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		RETURN 1;

END;
