
/*====================================================================================================================
 * Program ID   : PR_DM_IF_CHECK_SMS_SEND
 * Description  : DM IF검증후 SMS발송대상 처리
 * OutTable     :
 * Execute      : 
 * Program History
 *====================================================================================================================
 *   Date       In Charge		Description
 *====================================================================================================================
 * 2020.02.27   KHSONG			Initial Release [PS03209094B] SM이관 선행관리 
 * 2021.01.25   P.C.I			[C20210204-000087] 판매법인(G260) 재고 추가
 * 2021.08.31	rosia27			[C20210721-000120] 소형사업부 VMI 실적 수신 BATCH JOB
 * 2021.10.05	rosia27			[C20210917-000233] 판매 법인 재고 IF 알람 로직 수정 
 * 2021.11.05	rosia27			[C20211103-000324] VMI실적 관련 에러 문자 메세지가 발송 관련 건
 * 2024.03.22	jssbae			[E20240319-000706]_안정적인 운영을 위한 ERP 실적관련 프로세스 모니터링 및 작업추가 요청
 * 2025.01.01	P.C.I			[PJ20228272] NERP 대응. RFC Log 변경으로 SMS 전송 로직 수정
 * 2026.01.06	JSSBAE			[E20260106-000753]_EDI Calloff 데이터 IF 로직 개선
 *====================================================================================================================
	● 대상 List
	------------  --------------------------------  -----------------------------   --------------------------   ----------------------------------------------------------
	CATEGORY_ID	  CATEGORY_DESC						BATCH JOB NAME			        사유							 전송기준
	------------  --------------------------------  -----------------------------   --------------------------   ----------------------------------------------------------
	61			  Project Master Batch Error		PR_SCM_MST_PROJECT		        PROJECT 매핑시 필수정보	     배치로그 에러발견시
	62			  Project DV Batch Error			PR_SCM_MST_PROJECT_DV_MASTER	PROJECT 매핑시 필수정보	     배치로그 에러발견시
	63			  Project Item Mapping Batch Error  PR_SCM_MST_PROJECT_ITEM         PROJECT 매핑시 필수정보	     배치로그 에러발견시
	64			  Customer Master Batch Error		PR_SCM_MST_CUSTOMER             Sales Site 등록시 필수정보	 배치로그 에러발견시
	65			  SD0069 EDI Call off Batch Error   PR_DM_DNM_EDI_CALLOFF           CUST_FCST 수신확인 필요	     배치로그 에러 or 고객사별로 일주일동안 수신건이 없을 경우 => [E20260106-000753]_GERP 종료로 모니터링 제거
	66			  Sales Result Batch Error			PR_DM_DNM_SALES_RESULT_IF       ERP 실적. 주요정보		     수신된 데이터가 없는 경우 or 배치로그 에러발견시
	73			  Stock Sales Batch Error			PR_SCM_DNM_STOCK_SALES          판매법인(G260) 재고 			 배치로그 에러 or 당일 수신건이 없을 경우[C20210204-000087]
	79			  VMI 실적 Batch Error				PR_SCM_DNM_MAT_DOCUMENT			VMI 실적						 배치로그 에러 OR 당일 수신건이 없을 경우[C20211103-000324]
	------------  --------------------------------  -----------------------------   --------------------------   ----------------------------------------------------------
 ====================================================================================================================*/
 
CREATE PROCEDURE [dbo].[PR_DM_IF_CHECK_SMS_SEND]
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_IF_CHECK_SMS_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_text			NVARCHAR(200);
	DECLARE @v_code			NVARCHAR(10);
	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
   
    
	---------- 
    BEGIN TRY
	---------- 
      BEGIN
    
		------------------------------------------------------------------------------------------------------- 
		--                                                                                  JOB LIST TABLE 생성
		------------------------------------------------------------------------------------------------------- 
		IF OBJECT_ID (N'tempdb..#BATCH_JOB_NAME', N'U') IS NOT NULL 
			DROP TABLE #BATCH_JOB_NAME

		CREATE TABLE #BATCH_JOB_NAME ( CATEGORY_ID NVARCHAR(10), PROGRAM_NAME NVARCHAR(100));

		INSERT INTO #BATCH_JOB_NAME (CATEGORY_ID, PROGRAM_NAME)
		SELECT '61','PR_SCM_MST_PROJECT'
		UNION ALL
		SELECT '62','PR_SCM_MST_PROJECT_DV_MASTER'
		UNION ALL
		SELECT '63','PR_SCM_MST_PROJECT_ITEM'
		UNION ALL
		SELECT '64','PR_SCM_MST_CUSTOMER'
		--[E20260106-000753]_GERP EDI 종료로 인하여 EDI 주석처리 (START)
		/*
		UNION ALL
		SELECT '65','PR_DM_DNM_EDI_CALLOFF'
		*/
		--[E20260106-000753]_GERP EDI 종료로 인하여 EDI 주석처리 (END)
		UNION ALL
		SELECT '66','PR_DM_DNM_SALES_RESULT_IF'
		UNION ALL
		SELECT '73','PR_SCM_DNM_STOCK_SALES'
		
		------------------------------------------------------------------------------------------------------- 
		--                                                                                       초기화 (BEGIN)
		------------------------------------------------------------------------------------------------------- 

		IF OBJECT_ID (N'tempdb..#TEMP_SCM_LOG_BATCH', N'U') IS NOT NULL 
			DROP TABLE #TEMP_SCM_LOG_BATCH

		SELECT TOP 0 PROGRAM_NAME,LOG_TYPE,LOG_COUNT,LOG_MESSAGE,DESCRIPTION,EVENT_DATE,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,ATTRIBUTE1
		INTO #TEMP_SCM_LOG_BATCH
		FROM [dbo].[SCM_SYS_LOG_BATCH] WITH(NOLOCK) WHERE 1=1
		------------------------------------------------------------------------------------------------------- 
		--                                                                                         초기화 (END)
		------------------------------------------------------------------------------------------------------- 

		------------------------------------------------------------------------------------------------------- 
		--                                                                         BATCH JOB ERROR 대상 (BEGIN)
		------------------------------------------------------------------------------------------------------- 
		INSERT INTO #TEMP_SCM_LOG_BATCH
 		SELECT A.PROGRAM_NAME,A.LOG_TYPE,A.LOG_COUNT,A.LOG_MESSAGE,A.DESCRIPTION,A.EVENT_DATE,A.CREATION_DATE,A.CREATED_BY,A.LAST_UPDATE_DATE,A.LAST_UPDATED_BY,A.ATTRIBUTE1
		FROM [dbo].[SCM_SYS_LOG_BATCH] A WITH(NOLOCK)
		INNER JOIN #BATCH_JOB_NAME B
				ON (A.PROGRAM_NAME = B.PROGRAM_NAME)
		WHERE 1=1
		AND A.LOG_TYPE = 'ERROR'
		AND A.CREATION_DATE >= CONVERT(CHAR(8),GETDATE()-1,112)  -- 하루전까지
		AND (A.ATTRIBUTE1 <> 'DM SMS SEND OK' OR A.ATTRIBUTE1 IS NULL)  -- SMS발송완료대상은 제외, ATTRIBUTE1은 초기값인 대상

		------------------------------------------------------------------------------------------------------- 
		--                                    ERROR 케이스 처리 (update 는 성능이 느려서 delete/insert 로 수행)
		------------------------------------------------------------------------------------------------------- 

		DECLARE @PROGRAM_NAME           NVARCHAR(100);

		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR_C1')
			BEGIN
				CLOSE CURSOR_C1
				DEALLOCATE CURSOR_C1
			END;
		DECLARE CURSOR_C1 CURSOR FAST_FORWARD FOR
		SELECT PROGRAM_NAME	FROM  #TEMP_SCM_LOG_BATCH WHERE 1=1	GROUP BY PROGRAM_NAME

		BEGIN
			OPEN CURSOR_C1;
			FETCH NEXT FROM CURSOR_C1 INTO @PROGRAM_NAME 
		END
		----------------------------------------------------------------------------------------
		WHILE @@FETCH_STATUS = 0   
		----------------------------------------------------------------------------------------
		BEGIN

			DELETE
			FROM [dbo].[SCM_SYS_LOG_BATCH] 
				WHERE 1=1
					and exists (select PROGRAM_NAME from #TEMP_SCM_LOG_BATCH C WITH(NOLOCK) WHERE 1=1
								AND SCM_SYS_LOG_BATCH.PROGRAM_NAME        =   C.PROGRAM_NAME  
								)
				AND LOG_TYPE = 'ERROR'
				AND CREATION_DATE >= CONVERT(CHAR(8),GETDATE()-1,112)  -- 하루전까지
				AND (ATTRIBUTE1 <> 'DM SMS SEND OK' OR ATTRIBUTE1 IS NULL)  -- SMS발송완료대상은 제외, ATTRIBUTE1은 초기값인 대상

			INSERT INTO SCM_SYS_LOG_BATCH
				(PROGRAM_NAME,LOG_TYPE,LOG_COUNT,LOG_MESSAGE,DESCRIPTION,EVENT_DATE,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,ATTRIBUTE1)
			SELECT PROGRAM_NAME,LOG_TYPE,LOG_COUNT,LOG_MESSAGE,DESCRIPTION,EVENT_DATE,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,'DM SMS SEND OK'
				FROM #TEMP_SCM_LOG_BATCH
				  WHERE PROGRAM_NAME = @PROGRAM_NAME

			SET @v_code = ''
			SET @v_code = (SELECT CATEGORY_ID FROM #BATCH_JOB_NAME WHERE PROGRAM_NAME = @PROGRAM_NAME)

			SET @v_text = ''
			SET @v_text = N'[Job오류발생 : ' + @PROGRAM_NAME + N']'
			
			EXEC SCM_ADM_SMS_SEND_BATCH 
								@v_code
							  , @v_text

			FETCH NEXT FROM CURSOR_C1 INTO @PROGRAM_NAME 
		---------------------------------------------------------------------------------------- 
		END;
		----------------------------------------------------------------------------------------

		CLOSE CURSOR_C1;  
		DEALLOCATE CURSOR_C1;

		------------------------------------------------------------------------------------------------------- 
		--                                                                         BATCH JOB ERROR 대상 (END)
		------------------------------------------------------------------------------------------------------- 

		------------------------------------------------------------------------------------------------------- 
		--                                                                    수신된 데이터가 없는 대상 (BEGIN)
		------------------------------------------------------------------------------------------------------- 

		IF CONVERT(CHAR(2),GETDATE(),108) = '08'   --하루 1회 08시에만 수행함.
		--------
		BEGIN
		--------
		--[E20260106-000753]_GERP EDI 종료로 인하여 EDI 주석처리 (START)
		/*
			--------------------------------
			-- (1) PR_DM_DNM_EDI_CALLOFF
			--------------------------------
			IF ( SELECT COUNT(1) FROM LGCE_INF.DBO.XIF_ERP_EDI_CALLOFF_ITEM_R WITH(NOLOCK) 
				 WHERE TRANSFER_CREATE_DATE >= CONVERT(CHAR(8),GETDATE()-7,112)  -- 일주일간 수신데이터가 없는경우
				) < 1  -- 데이터가 존재하지 않는경우
			BEGIN
				SET @v_text = ''
				SET @v_code = ''
				SET @v_text = N'[일주일간 수신데이터가 없음 : ' + 'PR_DM_DNM_EDI_CALLOFF' + N']'
				SET @v_code = (SELECT CATEGORY_ID FROM #BATCH_JOB_NAME WHERE PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF')

				EXEC SCM_ADM_SMS_SEND_BATCH	@v_code, @v_text

			END
		*/
		--[E20260106-000753]_GERP EDI 종료로 인하여 EDI 주석처리 (END)

					

				--------------------------------

				--------------------------------
				-- (2) PR_DM_DNM_SALES_RESULT_IF
				--------------------------------
				IF (SELECT COUNT(*) FROM 
										(SELECT TOP 3 SUBSTRING(TRANSFER_DATE,1,8) + SUBSTRING(TRANSFER_TIME,1,2) AS '1'  -- 24시간동안 3건의 배치작업 데이터
											FROM   xif_erp_sales_result_r_sn WITH(NOLOCK)
												WHERE SUBSTRING(TRANSFER_DATE,1,8) + SUBSTRING(TRANSFER_TIME,1,2) >= CONVERT(VARCHAR(8), GETDATE() -1, 112)+ CONVERT(CHAR(2),GETDATE(),108)  -- 24시간동안의 데이터
										GROUP BY SUBSTRING(TRANSFER_DATE,1,8) + SUBSTRING(TRANSFER_TIME,1,2)  -- 날짜8자리+시간2자리
										) A
				   ) < 3  -- 24시간내에 3번의 작업이 되어야 정상임
					BEGIN
						SET @v_text = ''
						SET @v_code = ''
						SET @v_text = N'[24시간내 3회 미만 작업됨 : ' + 'PR_DM_DNM_SALES_RESULT_IF' + N']'
						SET @v_code = (SELECT CATEGORY_ID FROM #BATCH_JOB_NAME WHERE PROGRAM_NAME = 'PR_DM_DNM_SALES_RESULT_IF')

						EXEC SCM_ADM_SMS_SEND_BATCH 
										  @v_code
										, @v_text

					END

			--------
			END
			--------
			
		IF CONVERT(CHAR(2),GETDATE(),108) = '10'   --하루 1회 10시에만 수행함.[C20210204-000087]
			--------
			BEGIN
			--------
			
				--------------------------------
				-- (3) PR_SCM_DNM_STOCK_SALES
				--------------------------------
				-- [C20210917-000233] 판매 법인 재고 IF 알람 로직 수정 
				IF (
					SELECT COUNT(1) FROM DBO.XIF_ERP_SALES_STOCK_R_SN WITH(NOLOCK) 
						WHERE TRANSFER_DATE = CONVERT(CHAR(8),GETDATE(),112)  -- 당일 수신데이터가 없는경우
				   ) < 1  -- 데이터가 존재하지 않는경우
					BEGIN
						SET @v_text = ''
						SET @v_code = ''
						SET @v_text = N'[당일 수신데이터가 없음 : ' + 'PR_SCM_DNM_STOCK_SALES' + N']'
						SET @v_code = (SELECT CATEGORY_ID FROM #BATCH_JOB_NAME WHERE PROGRAM_NAME = 'PR_SCM_DNM_STOCK_SALES')

						EXEC SCM_ADM_SMS_SEND_BATCH 
										  @v_code
										, @v_text

					END
			--------
			END
			--------

		-- [C20210721-000120] 소형사업부 VMI 실적 수신 BATCH JOB 
		IF CONVERT(CHAR(2), GETDATE(), 108) = '10' -- 하루 1회 10시에만 수행함.
			--------
			BEGIN
			--------
				--------------------------------
				-- (4) PR_SCM_DNM_MAT_DOCUMENT
				--------------------------------
				
				-- [PJ20228272] NERP 대응. RFC Log 변경으로 SMS 전송 로직 수정 Start

				/*
				IF NOT EXISTS (SELECT LOG_TYPE	FROM SCM_SYS_LOG_BATCH 
					WHERE PROGRAM_NAME = N'XIF_ERP_MATERIAL_DOCUMENT_DM_R'
					AND LOG_TYPE='Success of RFC Call' 
					AND CREATION_DATE >= CONVERT(CHAR(10),GETDATE(),120))
					*/
					
				IF NOT EXISTS (SELECT LOG_TYPE	FROM SCM_SYS_LOG_BATCH 
					WHERE PROGRAM_NAME = N'SAPRFC_Batch_NERP'
					AND LOG_TYPE='XIF_ERP_MATERIAL_DOCUMENT_DM_R' 
					AND LOG_MESSAGE = 'INSERT'
					AND LOG_COUNT > 0
					AND CREATION_DATE >= CONVERT(CHAR(10),GETDATE(),120))
					
				-- [PJ20228272] NERP 대응. RFC Log 변경으로 SMS 전송 로직 수정 End

					BEGIN


						SET @v_code = ''
						SET @v_code = '79'

						SET @v_text = ''
						SET @v_text = N'[Job오류발생 : PR_SCM_DNM_MAT_DOCUMENT( VMI 실적 )]'
						EXEC SCM_ADM_SMS_SEND_BATCH 
										@v_code
									  , @v_text

					END
			--------
			END
			--------		
		--[E20240319-000706]_안정적인 운영을 위한 ERP 실적관련 프로세스 모니터링 및 작업추가 요청 20240322
		--일요일 배치 미실행시 해당 문구 발송예정 
		------------------------------------------------------------------------------------------------------------------------
		--1.JOB_RFC.DM_VMI_재고 입출고 실적
		------------------------------------------------------------------------------------------------------------------------
		IF CONVERT(CHAR(2), GETDATE(), 108) = '13' -- 하루 1회 10시에만 수행함.
		BEGIN
			BEGIN
				IF (
						SELECT COUNT(1) FROM DBO.XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK) 
							WHERE TRANSFER_DATE = CONVERT(CHAR(8),GETDATE(),112)  -- 당일 수신데이터가 없는경우
					   ) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							--VMI실적 BATCH ERROR
							SET @v_code = '79'		
							SET @v_text = N'[★★VMI재고입출고실적 ERP배치실행필요★★ : JOB_RFC.DM_VMI_재고 입출고 실적' + N']'

							EXEC SCM_ADM_SMS_SEND_BATCH 
											  @v_code
											, @v_text

						END
			END

			------------------------------------------------------------------------------------------------------------------------
			--2.JOB_RFC.매출 실적 정보
			------------------------------------------------------------------------------------------------------------------------
			BEGIN
				IF (
						SELECT COUNT(1) FROM DBO.XIF_ERP_SALES_RESULT_R_SN WITH(NOLOCK) 
							WHERE TRANSFER_DATE = CONVERT(CHAR(8),GETDATE(),112)  -- 당일 수신데이터가 없는경우
					   ) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[★★매출실적정보 ERP배치실행필요★★ : JOB_RFC.매출 실적 정보' + N']'
							SET @v_code = (SELECT CATEGORY_ID FROM #BATCH_JOB_NAME WHERE PROGRAM_NAME = 'PR_DM_DNM_SALES_RESULT_IF')

							EXEC SCM_ADM_SMS_SEND_BATCH 
											  @v_code
											, @v_text

						END
			END

			------------------------------------------------------------------------------------------------------------------------
			--3.JOB_RFC.판매법인(G260) 재고
			------------------------------------------------------------------------------------------------------------------------
			BEGIN
				IF (
						SELECT COUNT(1) FROM DBO.XIF_ERP_SALES_STOCK_R_SN WITH(NOLOCK) 
							WHERE TRANSFER_DATE = CONVERT(CHAR(8),GETDATE(),112)  -- 당일 수신데이터가 없는경우
					   ) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = ''
							SET @v_text = N'[★★매출실적정보 ERP배치실행필요★★ : JOB_RFC.판매법인(G260) 재고' + N']'
							SET @v_code = (SELECT CATEGORY_ID FROM #BATCH_JOB_NAME WHERE PROGRAM_NAME = 'PR_SCM_DNM_STOCK_SALES')

							EXEC SCM_ADM_SMS_SEND_BATCH 
											  @v_code
											, @v_text

						END
			END

			------------------------------------------------------------------------------------------------------------------------
			--4.전지사업본부 MDF(판매장려금) 실적 정보
			------------------------------------------------------------------------------------------------------------------------
			-- [PJ20228272] NERP 대응. 사용하지 않는 데이터이므로 SMS 전송 목록에서 삭제
			/*
			BEGIN
				IF (
						SELECT COUNT(1) FROM DBO.XIF_ERP_FI_MDF_R_SN WITH(NOLOCK) 
							WHERE TRANSFER_DATE = CONVERT(CHAR(8),GETDATE(),112)  -- 당일 수신데이터가 없는경우
					   ) < 1  -- 데이터가 존재하지 않는경우
						BEGIN
							SET @v_text = ''
							SET @v_code = '98'
							SET @v_text = N'[★★MDF실적정보 ERP배치실행필요★★ : JOB.PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT' + N']'

							EXEC SCM_ADM_SMS_SEND_BATCH 
											  @v_code
											, @v_text

						END
			END*/
	  END
			------------------------------------------------------------------------------------------------------- 
			--                                                                    수신된 데이터가 없는 대상 (END)
			------------------------------------------------------------------------------------------------------- 
      END;

	---------- 
    END TRY
	---------- 

	---------- 
    BEGIN CATCH
	---------- 
        
      
      -- ERROR LOG
	  INSERT INTO SCM_SYS_LOG_BATCH (program_name
										,log_type
										,log_count
										,log_message
										,description
										,event_date
										,creation_date
										,created_by
										,last_update_date
										,last_updated_by)
		VALUES (ERROR_PROCEDURE()
				,'ERROR'
				,NULL
				,ERROR_MESSAGE()
				,NULL
				,SYSDATETIME()
				,SYSDATETIME()
				,ERROR_PROCEDURE()
				,SYSDATETIME()
				,ERROR_PROCEDURE());

      return -1 
	---------- 
    END CATCH;
	---------- 

    -- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description  = N'';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    return 1 


  END;






