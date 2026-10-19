
/*************************************************************************************************
* Program ID  : DMF0070_AUTO_PR_REQUEST                                               
* Description : Procedure 작성 가이드                                                             
* Usage       : PR Request 자동 생성
* Parameter   :                                                                                  
* 
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                           
*------------------------------------------------------------------------------------------------SPQ
* 2024-01-25   kjj		 신규생성
--EXEC DMF0070_AUTO_PR_REQUEST 
***************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF0070_AUTO_PR_REQUEST]

AS  
BEGIN
/*

--대상추출 과 분리하여 PR_REQUEST만 생성


--전주 화요일에 추출된 것들 대상
--	-1:일요일, 0:월요일, 1:화요일, 2:수요일, 3:목요일, 4:금요일, 5:토요일
SELECT DATEADD(WK, DATEDIFF(WK,0, DATEADD(WEEK,-1,GETDATE())), 1)


--메인테이블 변경
DM_PLN_BNP_IN_PR_DETAIL_AUTO
=>DM_PLN_AUTO_PR_CHECK




--채번규칙 변경
프로젝트 별
=>프로젝트별 / 아이템별


--실제 반영시 주석해제해야할것
1.'전주 화요일에 발송된 것들만 대상'
2.데이터 가져올때 week+1 한 부분에서 +1 삭제


*/
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	SET ANSI_WARNINGS ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0070_AUTO_PR_REQUEST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_log_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_insert_count INTEGER = 0;
    DECLARE @n_input_count     INTEGER = 0;
    DECLARE @n_logo_count      INTEGER = 0;
	DECLARE @n_Invalid_item		nvarchar(50)
	DECLARE @n_msg			nvarchar(1000)
	DECLARE @V_BF_REQ_NO	NVARCHAR(30)
	DECLARE @V_BF_QTY		INT = 0;
	DECLARE @V_THIS_QTY		INT = 0;

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure @@@##########';
	SET @v_log_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_BATCH'
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 


	BEGIN TRANSACTION

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------
			--메일발송 주기(케이스 별)
			/*
			*1차
		(A) Incoterms= EXW => D-91(13주)
		(B) Incoterms = C* or F*, Country=KR => D-119(17주)
		(C) Incoterms = D*, Country=JP => D-119(17주)
		(D) Incoterms = D*, Country = not KR => D-175(25주)


			*2차
		(A) Incoterms= EXW => D-20 (3주 전)
		(B) Incoterms = C* or F*, Country=KR => D-48 (7주 전)
		(C) Incoterms = D*, Country=JP => D-48 (7주 전)
		(D) Incoterms = D*, Country = not KR => D-104 (15주 전)
			*/
		DECLARE @V_SUB_QRY NVARCHAR(MAX) = ''

		DECLARE   @CUR_DIVISION			NVARCHAR(100)
				, @CUR_INCOTERMS		NVARCHAR(100)
				, @CUR_COUNTRY			NVARCHAR(100)
				, @CUR_BNP_WEEK			NVARCHAR(100)--BNP IN 출하시점
				, @CUR_DATA_WEEK		NVARCHAR(150)--DATA 생성 시점(대상추출 메일발송은 DATA 생성시점의 1주 전)
				, @V_CUR_NOT_COND			NVARCHAR(1000)--NOT 조건으로 지정된 건


			----------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### BNP IN 대상 가져오기' 
			----------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_BNP_TARGET_LIST') IS NOT NULL
				DROP TABLE #TMP_BNP_TARGET_LIST;

			CREATE TABLE #TMP_BNP_TARGET_LIST(
				DIVISION_ID		NVARCHAR(100),
				PROJECT_CODE	NVARCHAR(100),
				SCM_SITE_ID		NVARCHAR(100),
				ITEM_ID			NVARCHAR(100),
				DOM_EXP			NVARCHAR(100),	
				FCST_TYPE		NVARCHAR(100),	
				INCOTERMS		NVARCHAR(100),	
				MEASURE			NVARCHAR(100),	
				PLANT_SITE_ID	NVARCHAR(100),
				YYYYMMDD		NVARCHAR(10),
				QTY				NUMERIC(30,10),
				BNP_YYYYMMDD	NVARCHAR(10), --BNP IN의 YYYYMMDD : 나중에 역산하여 찾기가 어려우므로 미리 계산된 값을 저장

				PUCH_MGR			NVARCHAR(100),
				PUCH_GROUP			NVARCHAR(100),
				PR_HEADER			NVARCHAR(100),
				STORAGE_ID			NVARCHAR(100),
				STORAGE_PLANT_ID	NVARCHAR(100),
				ITEM_DETAIL			NVARCHAR(100),
				UOM					NVARCHAR(100)
			)

			SET @V_SUB_QRY = ''

			DECLARE CUR_GUIDE_LIST CURSOR FAST_FORWARD FOR
			SELECT SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
			WHERE LOOKUP_TYPE = 'AUTO_PR_CHECK_CRITERIA' 
			AND VALID_YN = 'Y'
			ORDER BY DISPLAY_SEQ 

			OPEN CUR_GUIDE_LIST;
			FETCH NEXT FROM CUR_GUIDE_LIST INTO @CUR_DIVISION, @CUR_INCOTERMS, @CUR_COUNTRY, @CUR_BNP_WEEK, @CUR_DATA_WEEK

			WHILE @@FETCH_STATUS = 0
			BEGIN

				IF @V_SUB_QRY <> '' 
				BEGIN
					SET @V_SUB_QRY = @V_SUB_QRY + N'
					UNION
					'
				END

				SET @V_SUB_QRY = @V_SUB_QRY + N'
					SELECT 
					MF.DIVISION_ID
					,MF.PROJECT_CODE
					, MF.SCM_SITE_ID
					, MF.ITEM_ID
					, MF.DOM_EXP
					, MF.FCST_TYPE
					, MF.INCOTERMS
					, ''BNPIn'' MEASURE
					, MF.PLANT_SITE_ID
					, MF.YYYYMMDD
					, MF.QTY
					, CONVERT(VARCHAR, DATEADD(WEEK, -' + @CUR_BNP_WEEK + ', MF.YYYYMMDD), 112)  BNP_YYYYMMDD

					,(
						SELECT TOP 1 SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
							WHERE LOOKUP_TYPE = ''DM_PR_PUCH''
					) PUCH_MGR
					,(
						SELECT TOP 1 SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
							WHERE LOOKUP_TYPE = ''DM_PR_PUCH''
					) PUCH_GROUP
					,'' ( '' + MF.PROJECT_CODE + '' ) '' 
						+ (
							SELECT TOP 1 PROJECT_NAME FROM SCM_MST_PROJECT WITH(NOLOCK) 
							WHERE DIVISION_ID = MF.DIVISION_ID 
							AND PROJECT_CODE = MF.PROJECT_CODE)
						+ LUP.SEGMENT2
							PR_HEADER -- (Project Code) + Project + ''물량''(룩업관리)
					--,LUP.SEGMENT4 STORAGE_ID -- SLOC(룩업관리)
					--, LUP.SEGMENT3 STORAGE_PLANT_ID--(룩업관리) => 별도 쿼리 해오다가 룩업관리로 변경함
					--, LUP.SEGMENT5 ITEM_DETAIL--(룩업관리)
					,MSND.STORAGE_ID
					,MSND.STORAGE_PLANT_ID
					,MSND.PR_ITEM_DETAIL ITEM_DETAIL
					, (
						SELECT ITEM_UOM 
						FROM  DM_MST_ITEM_SINGLE_V
						WHERE DIVISION_ID = MF.DIVISION_ID 
						AND ITEM_ID = MF.ITEM_ID
					) UOM
					FROM DM_PLN_MKT_FCST MF WITH(NOLOCK)
					INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK) 
						ON LUP.LOOKUP_TYPE = ''AUTO_PR_CHECK_TEXT''
						AND LUP.SEGMENT1 = MF.DIVISION_ID
						AND LUP.VALID_YN = ''Y''
					INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
						ON MF.DIVISION_ID = MS.DIVISION_ID
						AND MF.SCM_SITE_ID = MS.SCM_SITE_ID
					INNER JOIN DM_PLN_AUTO_PR_CHECK MSND WITH(NOLOCK)
						ON MSND.DIVISION_ID = MF.DIVISION_ID
						AND MSND.PROJECT_CODE = MF.PROJECT_CODE
						AND MSND.SCM_SITE_ID = MF.SCM_SITE_ID
						AND MSND.ITEM_ID = MF.ITEM_ID
						AND MSND.DOM_EXP = MF.DOM_EXP
						AND MSND.INCOTERMS = MF.INCOTERMS
						AND MSND.PLANT_SITE_ID = MF.PLANT_SITE_ID
						AND MSND.MKT_FCST_DATE = MF.YYYYMMDD
						AND MSND.AUTO_FLAG = ''Y''
						AND ISNULL(MSND.BNP_IN_DATE, '''') = ''''--BNP IN 데이터 생성 안된것만

						AND MSND.MAIL_INFO_DATE = CONVERT(VARCHAR,DATEADD(WK, DATEDIFF(WK,0, DATEADD(WEEK,-1,GETDATE())), 1), 112) --전주 화요일에 발송된 것들만 대상
						AND ISNULL(MSND.STORAGE_PLANT_ID, '''') <> '''' --Plant Site 가 입력된 것들만
						AND ISNULL(MSND.STORAGE_ID, '''') <> '''' --SLOC 가 입력된 것들만

					WHERE MF.MEASURE = ''MKT_FCST''
					AND ISNULL(MF.ATTRIBUTE9, '''') = '''' -- 확정되지 않은 것들
					AND
					(
						(
							MF.YYYYMMDD >= 
							(
									SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
									WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(WEEK, ' + CONVERT(VARCHAR,@CUR_DATA_WEEK) + ', GETDATE()), 112)
							)
							AND MF.YYYYMMDD <=
							(
									SELECT BASIS_END_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
									WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(WEEK, ' + CONVERT(VARCHAR,@CUR_DATA_WEEK) + ', GETDATE()), 112)
							)
						) 
						OR
						(
							MF.YYYYMMDD >= 
							(
									SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
									WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(WEEK, ' + CONVERT(VARCHAR,@CUR_DATA_WEEK - 10) + ', GETDATE()), 112) --2차처리는 1차의 10주 뒤
							)
							AND MF.YYYYMMDD <=
							(
									SELECT BASIS_END_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
									WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(WEEK, ' + CONVERT(VARCHAR,@CUR_DATA_WEEK) + ', GETDATE()), 112)--To는 1차발송일과 동일
							)
						)
					)
					'
			
					--SELECT @CUR_BNP_WEEK
					--INCOTERMS
					IF @CUR_INCOTERMS <> '-'
					BEGIN
						IF CHARINDEX ('*', @CUR_INCOTERMS) > 0
						BEGIN
							SET @V_SUB_QRY = @V_SUB_QRY + N'
								AND MF.INCOTERMS LIKE ''' + REPLACE(@CUR_INCOTERMS,'*', '%') + '''
							'
						END
						ELSE IF CHARINDEX ('NOT_', @CUR_INCOTERMS) > 0
						BEGIN
						/*
						--Not 의 규칙
						1)Not_로 등록
						2)여러개일 경우는 ,로 구분
						*/
							DECLARE CUR_NOT_COND CURSOR FAST_FORWARD FOR
							SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@CUR_INCOTERMS		, ',')

							OPEN CUR_NOT_COND;
							FETCH NEXT FROM CUR_NOT_COND INTO @V_CUR_NOT_COND

							WHILE @@FETCH_STATUS = 0
							BEGIN

								SET @V_SUB_QRY = @V_SUB_QRY + N'
									AND MF.INCOTERMS <> ''' + REPLACE(@V_CUR_NOT_COND,'NOT_', '') + '''
								'

							FETCH NEXT FROM CUR_NOT_COND INTO @V_CUR_NOT_COND
							END

							CLOSE CUR_NOT_COND;
							DEALLOCATE CUR_NOT_COND;

						END
						ELSE
						BEGIN
							SET @V_SUB_QRY = @V_SUB_QRY + N'
								AND MF.INCOTERMS = ''' + @CUR_INCOTERMS + '''
							'
							END
					END

					--COUNTRY
					IF @CUR_COUNTRY <> '-'
					BEGIN
						IF CHARINDEX ('*', @CUR_COUNTRY) > 0
						BEGIN
							SET @V_SUB_QRY = @V_SUB_QRY + N'
								AND MS.COUNTRY LIKE ''' + REPLACE(@CUR_COUNTRY,'*', '%') + '''
							'
						END
						ELSE IF CHARINDEX ('NOT_', @CUR_COUNTRY) > 0
						BEGIN

						/*
							SET @V_SUB_QRY = @V_SUB_QRY + N'
								AND MS.COUNTRY <> ''' + REPLACE(@CUR_COUNTRY,'NOT ', '') + '''
							'
							*/
							/*
							--Not 의 규칙
							1)Not_로 등록
							2)여러개일 경우는 ,로 구분
							*/
							DECLARE CUR_NOT_COND CURSOR FAST_FORWARD FOR
							SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@CUR_COUNTRY		, ',')

							OPEN CUR_NOT_COND;
							FETCH NEXT FROM CUR_NOT_COND INTO @V_CUR_NOT_COND

							WHILE @@FETCH_STATUS = 0
							BEGIN

								SET @V_SUB_QRY = @V_SUB_QRY + N'
									AND MS.COUNTRY <> ''' + REPLACE(@V_CUR_NOT_COND,'NOT_', '') + '''
								'

							FETCH NEXT FROM CUR_NOT_COND INTO @V_CUR_NOT_COND
							END

							CLOSE CUR_NOT_COND;
							DEALLOCATE CUR_NOT_COND;
						END
						ELSE
						BEGIN
						SET @V_SUB_QRY = @V_SUB_QRY + N'
							AND MS.COUNTRY = ''' + @CUR_COUNTRY + '''
						'
						END
					END
			

			FETCH NEXT FROM CUR_GUIDE_LIST INTO @CUR_DIVISION, @CUR_INCOTERMS, @CUR_COUNTRY, @CUR_BNP_WEEK, @CUR_DATA_WEEK
			END

			CLOSE CUR_GUIDE_LIST;
			DEALLOCATE CUR_GUIDE_LIST;

			--PRINT @V_SUB_QRY
			INSERT #TMP_BNP_TARGET_LIST
			EXEC (@V_SUB_QRY)

			--select * from #TMP_BNP_TARGET_LIST


			----------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### BNP IN 데이터 생성' 
			----------------------------------------------------------------------------------------------------------------------------------------------------------


			--머지구문으로 변경
			--기존에 있던 승인나지 않은 데이터 수량 업데이트
			MERGE INTO DM_PLN_MKT_FCST AS A
			USING #TMP_BNP_TARGET_LIST AS B
			   ON (
						A.DIVISION_ID        =   B.DIVISION_ID      
						AND A.PROJECT_CODE       =   B.PROJECT_CODE   
						AND A.SCM_SITE_ID        =   B.SCM_SITE_ID  
						AND A.ITEM_ID            =   B.ITEM_ID      
						AND A.DOM_EXP            =   B.DOM_EXP      
						AND A.FCST_TYPE          =   B.FCST_TYPE    
						AND A.INCOTERMS          =   B.INCOTERMS    						   
						AND A.MEASURE			 =	 B.MEASURE						   
						AND A.PLANT_SITE_ID      =   B.PLANT_SITE_ID
						AND A.YYYYMMDD           =   B.BNP_YYYYMMDD --룩업에 등록된BNPIN WEEK
						AND ISNULL(A.ATTRIBUTE9, '') = '' --승인나지 않은 것 					   
				)
			WHEN MATCHED THEN
				UPDATE SET 
				A.QTY = B.QTY
				,LAST_UPDATED_BY = 'SCM_BATCH'
				,LAST_UPDATE_DATE = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT 
						(DIVISION_ID    
						,PROJECT_CODE   
						,SCM_SITE_ID    
						,ITEM_ID        
						,DOM_EXP        
						,FCST_TYPE      
						,INCOTERMS      
						,MEASURE        
						,PLANT_SITE_ID  
						,YYYYMMDD       
						,QTY            
						,CREATED_BY     
						,CREATION_DATE     
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
					)
				VALUES
				(
							B.DIVISION_ID 
							,B.PROJECT_CODE 
							,B.SCM_SITE_ID	 
							,B.ITEM_ID       
							,B.DOM_EXP      
							,B.FCST_TYPE   
							,B.INCOTERMS    
							,B.MEASURE    	 
							,B.PLANT_SITE_ID 
							,B.BNP_YYYYMMDD     --룩업에 등록된BNPIN WEEK 
							,B.QTY         
							,'SCM_BATCH'   
							,GETDATE()		 
							,'SCM_BATCH'    
							,GETDATE()
				)
				;
			----------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### BNP IN YYYYMMDD를 메일발송 테이블의 BNP_IN_DATE에 저장' --추후 BNP IN 생성여부 판단 수월하게 하기 위함
			----------------------------------------------------------------------------------------------------------------------------------------------------------

			UPDATE ATO
			SET
				ATO.BNP_IN_DATE = T_LIST.BNP_YYYYMMDD
			FROM DM_PLN_AUTO_PR_CHECK ATO
			INNER JOIN #TMP_BNP_TARGET_LIST T_LIST
				ON ATO.DIVISION_ID = T_LIST.DIVISION_ID
				AND ATO.PROJECT_CODE = T_LIST.PROJECT_CODE
				AND ATO.SCM_SITE_ID = T_LIST.SCM_SITE_ID
				AND ATO.ITEM_ID = T_LIST.ITEM_ID
				AND ATO.DOM_EXP = T_LIST.DOM_EXP
				AND ATO.FCST_TYPE = T_LIST.FCST_TYPE
				AND ATO.INCOTERMS = T_LIST.INCOTERMS
				AND ATO.PLANT_SITE_ID = T_LIST.PLANT_SITE_ID
				AND ATO.MKT_FCST_DATE = T_LIST.YYYYMMDD

			IF	(SELECT COUNT(*) FROM #TMP_BNP_TARGET_LIST) > 0
			BEGIN

				----------------------------------------------------------------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N' ### PR Request 데이터 생성' 
				----------------------------------------------------------------------------------------------------------------------------------------------------------
				DECLARE @V_REQUEST_NO NVARCHAR(30)
					, @V_MAX_NO	NVARCHAR(30)
					, @V_SUM_QTY INT
					, @V_MAX_SEQ INT
					, @V_SEQ INT


				--프로젝트 별 / 아이템ID별로 REQUEST_NO가 따로 채번되어야 함

				DECLARE		
				@V_CURSSP_DIVISION_ID	NVARCHAR(500)
				, @V_CURSSP_PROJECT_CODE	NVARCHAR(500)
				, @V_CURSSP_SCM_SITE_ID	NVARCHAR(500)
				, @V_CURSSP_ITEM_ID	NVARCHAR(500)
				, @V_CURSSP_DOM_EXP	NVARCHAR(500)
				, @V_CURSSP_FCST_TYPE	NVARCHAR(500)
				, @V_CURSSP_INCOTERMS	NVARCHAR(500)
				, @V_CURSSP_PLANT_SITE_ID	NVARCHAR(500)
				, @V_CURSSP_BNP_YYYYMMDD	NVARCHAR(500) --BNP IN YYYYMMDD
				, @V_CURSSP_UOM	NVARCHAR(500)
				, @V_CURSSP_QTY	NUMERIC(30,10)
				, @V_CURSSP_STORAGE_ID	NVARCHAR(500)
				, @V_CURSSP_STORAGE_PLANT_ID	NVARCHAR(500)
				, @V_CURSSP_PUCH_MGR	NVARCHAR(500)
				, @V_CURSSP_PUCH_GROUP	NVARCHAR(500)
				, @V_CURSSP_PR_HEADER	NVARCHAR(MAX)
				, @V_CURSSP_ITEM_DETAIL	NVARCHAR(MAX)



				-- MKT FCST 테이블 접근을 위한 변수
				DECLARE @V_DIVISION_ID	NVARCHAR(30)
					, @V_PROJECT_CODE	NVARCHAR(50)
					, @V_SCM_SITE_ID	NVARCHAR(30)
					, @V_ITEM_ID		NVARCHAR(50)
					, @V_DOM_EXP		NVARCHAR(3)
					, @V_FCST_TYPE		NVARCHAR(20)
					, @V_INCOTERMS		NVARCHAR(10)
					, @V_MEASURE		NVARCHAR(50)
					, @V_YYYYMMDD		NVARCHAR(8)
					, @V_PLANT_SITE_ID	NVARCHAR(30)
					, @V2_REQUEST_NO	NVARCHAR(30)


				DECLARE CUR_BNP_PJT_LIST CURSOR FAST_FORWARD FOR
				SELECT	
					DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
											, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
											, BNP_YYYYMMDD --BNP IN YYYYMMDD
											, UOM, QTY, STORAGE_ID, STORAGE_PLANT_ID
											, PUCH_MGR, PUCH_GROUP, PR_HEADER, ITEM_DETAIL
				FROM #TMP_BNP_TARGET_LIST--프로젝트 코드


				OPEN CUR_BNP_PJT_LIST;
				FETCH NEXT FROM CUR_BNP_PJT_LIST INTO 
				@V_CURSSP_DIVISION_ID	
					, @V_CURSSP_PROJECT_CODE	
					, @V_CURSSP_SCM_SITE_ID	
					, @V_CURSSP_ITEM_ID	
					, @V_CURSSP_DOM_EXP	
					, @V_CURSSP_FCST_TYPE	
					, @V_CURSSP_INCOTERMS	
					, @V_CURSSP_PLANT_SITE_ID	
					, @V_CURSSP_BNP_YYYYMMDD	 --BNP IN YYYYMMDD
					, @V_CURSSP_UOM	
					, @V_CURSSP_QTY	
					, @V_CURSSP_STORAGE_ID	
					, @V_CURSSP_STORAGE_PLANT_ID	
					, @V_CURSSP_PUCH_MGR	
					, @V_CURSSP_PUCH_GROUP	
					, @V_CURSSP_PR_HEADER	
					, @V_CURSSP_ITEM_DETAIL	


				WHILE @@FETCH_STATUS = 0
				BEGIN



					/*
					V_REQUEST_NO 채번
					*/

			
					SELECT @V_MAX_NO = MAX(REQUEST_NO)
					FROM DM_PLN_PR_DETAIL
					WHERE REQUEST_NO LIKE CONVERT(CHAR(8), GETDATE(), 112) + '%'
					AND PROJECT_CODE = @V_CURSSP_PROJECT_CODE
					AND ITEM_ID = @V_CURSSP_ITEM_ID

					IF @V_MAX_NO IS NOT NULL 
					BEGIN

						--기존의 MAX 값 + 1
						SELECT @V_MAX_NO = MAX(REQUEST_NO)
						FROM DM_PLN_PR_DETAIL
						WHERE REQUEST_NO LIKE CONVERT(CHAR(8), GETDATE(), 112) + '%'

						SET @V_REQUEST_NO = CONCAT(CONVERT(CHAR(8), GETDATE(), 112), DBO.FN_ZERO_LPAD(RIGHT(@V_MAX_NO, 6) + 1, 6))
					END
					ELSE
					BEGIN
						--SET @V_REQUEST_NO = CONVERT(CHAR(8), GETDATE(), 112) + '000001'
			
						--없을 경우에는 기존의 MAX 값 + 1
						SELECT @V_MAX_NO = MAX(REQUEST_NO)
						FROM DM_PLN_PR_DETAIL
						WHERE REQUEST_NO LIKE CONVERT(CHAR(8), GETDATE(), 112) + '%'

						IF @V_MAX_NO IS NOT NULL 
						BEGIN
							SET @V_REQUEST_NO = CONCAT(CONVERT(CHAR(8), GETDATE(), 112), DBO.FN_ZERO_LPAD(RIGHT(@V_MAX_NO, 6) + 1, 6))
						END
						ELSE
						BEGIN
							SET @V_REQUEST_NO = CONVERT(CHAR(8), GETDATE(), 112) + '000001'
						END
				
					END
			
					----------------------------------------------------------------

					/*
					ITEM_SEQ 채번
					*/
					SELECT @V_MAX_SEQ = MAX(ITEM_SEQ)
					FROM DM_PLN_PR_DETAIL
					WHERE REQUEST_NO = @V_REQUEST_NO

					IF @V_MAX_SEQ IS NOT NULL 
					BEGIN
						SET @V_SEQ = @V_SEQ + 1
					END
					ELSE
					BEGIN
						SET @V_SEQ = 1
					END

					--PR_ITEM_DETAIL 값이 없으면 PR 자동화 요청물량 입력

					IF (ISNULL(@V_CURSSP_ITEM_DETAIL, '') = '')
					BEGIN
						SET @V_CURSSP_ITEM_DETAIL = N'PR 자동화 요청물량'
					END


					INSERT INTO DM_PLN_PR_DETAIL
							( REQUEST_NO, ITEM_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
							, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
							, YYYYMMDD, UOM, PLAN_QTY, STORAGE_ID, STORAGE_PLANT_ID
							, PUCH_MGR, PUCH_GROUP, PR_HEADER, PR_ITEM_DETAIL, CREATED_BY
							, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, SSP_TRANSFER_FLAG
							, ATTRIBUTE1
							)
					VALUES
					(
						@V_REQUEST_NO
						--row_number() OVER( ORDER BY PROJECT_CODE,SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,INCOTERMS,YYYYMMDD )
						,@V_SEQ
						, @V_CURSSP_DIVISION_ID			
						, @V_CURSSP_PROJECT_CODE	
						, @V_CURSSP_SCM_SITE_ID	
						, @V_CURSSP_ITEM_ID	
						, @V_CURSSP_DOM_EXP	
						, @V_CURSSP_FCST_TYPE	
						, @V_CURSSP_INCOTERMS	
						, @V_CURSSP_PLANT_SITE_ID	
						, @V_CURSSP_BNP_YYYYMMDD	 --BNP IN YYYYMMDD
						, @V_CURSSP_UOM	
						, @V_CURSSP_QTY	
						, @V_CURSSP_STORAGE_ID	
						, @V_CURSSP_STORAGE_PLANT_ID	
						, @V_CURSSP_PUCH_MGR	
						, @V_CURSSP_PUCH_GROUP	
						, @V_CURSSP_PR_HEADER	
						, @V_CURSSP_ITEM_DETAIL	
							, 'SCM_BATCH'
							, GETDATE(), 'SCM_BATCH', GETDATE(), 'N'
							, 'SCM_BATCH'
					)

					----------------------------------------------------------------------------------------------------------------------------------------------------------
					print  convert(varchar(30), getdate(), 121) + N' ### ESS 프로시저 호출' 
					----------------------------------------------------------------------------------------------------------------------------------------------------------

					/*
					SELECT TOP 1
						@V_DIVISION_ID	= DIVISION_ID	
						, @V_PROJECT_CODE	= PROJECT_CODE	
						, @V_SCM_SITE_ID	= SCM_SITE_ID	
						, @V_ITEM_ID		= ITEM_ID		
						, @V_DOM_EXP		= DOM_EXP		
						, @V_FCST_TYPE		= FCST_TYPE		
						, @V_INCOTERMS		= INCOTERMS		
						, @V_MEASURE		= 'BNPIn'		
						, @V_YYYYMMDD		= BNP_YYYYMMDD	--BNP IN YYYYMMDD	
						, @V_PLANT_SITE_ID	= PLANT_SITE_ID	
					FROM #TMP_BNP_TARGET_LIST
					WHERE PROJECT_CODE = @V_CUR_PROJECT_CODE
					*/
					-- ESS 프로시저 호출	------------------------------------------------------------------------------------
					-- 트랜잭션 문제가 해결이 안된 관계로 여기서 처리하고, 문제 발생시 DM_PLN_PR_DETAIL 삭제 및 DM_PLN_MKT_FCST UPDATE 한다.
			
					DECLARE @V_MSG NVARCHAR(1000)

					--select @V_REQUEST_NO,@V_CURSSP_DIVISION_ID

					-- 임시로 
					EXEC PR_SSP_ANL_ESS_REQ @V_REQUEST_NO, @V_CURSSP_DIVISION_ID, @V_MSG OUTPUT


				FETCH NEXT FROM CUR_BNP_PJT_LIST INTO
				@V_CURSSP_DIVISION_ID	
					, @V_CURSSP_PROJECT_CODE	
					, @V_CURSSP_SCM_SITE_ID	
					, @V_CURSSP_ITEM_ID	
					, @V_CURSSP_DOM_EXP	
					, @V_CURSSP_FCST_TYPE	
					, @V_CURSSP_INCOTERMS	
					, @V_CURSSP_PLANT_SITE_ID	
					, @V_CURSSP_BNP_YYYYMMDD	 --BNP IN YYYYMMDD
					, @V_CURSSP_UOM	
					, @V_CURSSP_QTY	
					, @V_CURSSP_STORAGE_ID	
					, @V_CURSSP_STORAGE_PLANT_ID	
					, @V_CURSSP_PUCH_MGR	
					, @V_CURSSP_PUCH_GROUP	
					, @V_CURSSP_PR_HEADER	
					, @V_CURSSP_ITEM_DETAIL			

				END
				CLOSE CUR_BNP_PJT_LIST;
				DEALLOCATE CUR_BNP_PJT_LIST;

				----------------------------------------------------------------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N' ### PR Request 메일발송' 
				----------------------------------------------------------------------------------------------------------------------------------------------------------

			DECLARE @TABLE_BODY			NVARCHAR(MAX)
					, @v_body_contents	NVARCHAR(MAX)
					, @v_head_cont		NVARCHAR(MAX)
					, @v_body_cont		NVARCHAR(MAX)
					--, @v_to_mail		NVARCHAR(150)
					, @v_mail_title		NVARCHAR(100)
					, @v_cnt int
					, @v_i int

				SET @TABLE_BODY = ''
				SET @v_body_contents = ''
				SET @v_head_cont = ''
				SET @v_body_cont = ''
				SET @v_mail_title = ''

				DECLARE	 @v_to_mail		NVARCHAR(150) = ''

				DECLARE   @V_ITEM_SEQ			INT
						, @V_ITEM_NAME			NVARCHAR(50)
						, @V_UOM				NVARCHAR(8)
						, @V_PLAN_QTY			NUMERIC(30,10)
						, @V_CREATED_BY			NVARCHAR(150)
						, @V_LAST_UPDATE_DATE	DATETIME
						, @V_CURSOR_YYYYMMDD	NVARCHAR(10)


				DECLARE @T_MAIL_ADDR TABLE (
				ADDR	NVARCHAR(150)
				, SEQ	INT				IDENTITY(0,1)
				)

				INSERT INTO @T_MAIL_ADDR ( ADDR )
				SELECT A.SEGMENT1
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
				WHERE A.LOOKUP_TYPE = 'DM_PR_MAIL_ADDR'
					AND A.VALID_YN = 'Y'

				SELECT @V_CNT = COUNT(*), @V_I = 0, @v_to_mail = ''
				FROM @T_MAIL_ADDR

				WHILE ( @V_I < @V_CNT )
				BEGIN
		
					SELECT @V_TO_MAIL = @V_TO_MAIL + ADDR  + ';' -- + CASE WHEN @V_I <> 0 THEN ';'  ELSE '' END + ADDR
					FROM @T_MAIL_ADDR
					WHERE SEQ = @V_I


					SET @V_I = @V_I + 1
				END

				-----------------------------
				--SET @v_mail_title = N'[GSCM] PR Requested'
				SET @v_mail_title = N'[SCM] PR Requested'     -- [E20230721-001841] 용어 수정  GSCM->SCM
				SET @v_body_contents = N'하기와 같이 PR Request 가 접수 되었습니다. 기 확보된 재고 Allo 후 PR 생성 바랍니다.'
				SET @v_body_cont = '';
				SET @v_head_cont = N'<TR>
					<TH>Request No</TH>
					<TH>Div</TH>
					<TH>Project Code</TH>
					<TH>Seq.</TH>
					<TH>Model</TH>
					<TH>Model Name</TH>
					<TH>UOM</TH>
					<TH>To Site</TH>
					<TH>Request Date</TH>
					<TH>Request Qty</TH>
					<TH>Requestor</TH>
					<TH>Update date</TH>
					</TR>'

				DECLARE CUR_SEND CURSOR FAST_FORWARD FOR
				SELECT
					A.REQUEST_NO
					, A.DIVISION_ID
					, A.PROJECT_CODE
					, A.ITEM_SEQ
					, A.ITEM_ID
					, B.ITEM_NAME
					, A.UOM
					, A.SCM_SITE_ID
					, A.YYYYMMDD
					, A.PLAN_QTY
					, A.CREATED_BY
					, A.LAST_UPDATE_DATE
				FROM DM_PLN_PR_DETAIL A
				LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B 
					ON A.DIVISION_ID = B.DIVISION_ID 
					AND A.ITEM_ID = B.ITEM_ID
				INNER JOIN #TMP_BNP_TARGET_LIST TMP
					ON A.DIVISION_ID = TMP.DIVISION_ID
					AND A.PROJECT_CODE = TMP.PROJECT_CODE
					AND A.SCM_SITE_ID = TMP.SCM_SITE_ID
					AND A.ITEM_ID = TMP.ITEM_ID
					AND A.DOM_EXP = TMP.DOM_EXP
					AND A.FCST_TYPE = TMP.FCST_TYPE
					AND A.INCOTERMS = TMP.INCOTERMS
					AND A.PLANT_SITE_ID = TMP.PLANT_SITE_ID
					AND A.YYYYMMDD = TMP.BNP_YYYYMMDD
					AND A.UOM = TMP.UOM
					AND A.STORAGE_ID = TMP.STORAGE_ID
					AND A.STORAGE_PLANT_ID = TMP.STORAGE_PLANT_ID
				--20240430 SM TRANSFER_FLAG가 Y인건에 대해서만, 메일 발송하는 대상으로 수정
				WHERE A.SSP_TRANSFER_FLAG = 'Y'
				ORDER BY REQUEST_NO, ITEM_SEQ

				OPEN CUR_SEND;
				FETCH NEXT FROM CUR_SEND INTO @V2_REQUEST_NO, @V_DIVISION_ID, @V_PROJECT_CODE, @V_ITEM_SEQ, @V_ITEM_ID, @V_ITEM_NAME
								, @V_UOM, @V_SCM_SITE_ID, @V_CURSOR_YYYYMMDD, @V_PLAN_QTY, @V_CREATED_BY, @V_LAST_UPDATE_DATE
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<TR>'
					SET @v_body_cont = @v_body_cont+ '<TD>' + ISNULL(@V2_REQUEST_NO,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_DIVISION_ID,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_PROJECT_CODE,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(CONVERT(NVARCHAR(5), @V_ITEM_SEQ),'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_ITEM_ID,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_ITEM_NAME,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_UOM,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_SCM_SITE_ID,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(CONVERT(NVARCHAR(10), CAST(@V_CURSOR_YYYYMMDD AS DATETIME), 120),'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD ALIGN="RIGHT">'	+ DBO.FN_GET_NUMER_TO_STRING(@V_PLAN_QTY,0) + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_CREATED_BY,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(CONVERT(NVARCHAR(10), @V_LAST_UPDATE_DATE, 120),'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '</TR>'
		
					FETCH NEXT FROM CUR_SEND INTO @V2_REQUEST_NO, @V_DIVISION_ID, @V_PROJECT_CODE, @V_ITEM_SEQ, @V_ITEM_ID, @V_ITEM_NAME
								, @V_UOM, @V_SCM_SITE_ID, @V_CURSOR_YYYYMMDD, @V_PLAN_QTY, @V_CREATED_BY, @V_LAST_UPDATE_DATE
		
				END
	
				CLOSE CUR_SEND;
				DEALLOCATE CUR_SEND;

					SET @TABLE_BODY = ' <html>
									<head>
											<title>Untitled Document</title>
											<style>
												* {margin:0;padding:0;}
												body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
												table {border-collapse:collapse;width:100%;}
												table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
												table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
												table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
												table tbody td {padding:6px 8px;font-size:12px}
												table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
												.hori-table table thead td {text-align:center;padding:3px;}  
												.hori-table table tbody td {text-align:center;padding:3px;}
												.vertical-table, .hori-table {margin-bottom:20px;}
											</style>
											</head>
											<body>' +'</br>'+
													'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' +
													'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
												'<table style=''border-top:2px solid #c8294b; width:1450px;''>
												<thead>' + ISNULL(@v_head_cont,'') +'</thead>
												<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
												</div>
											</body>
									</html>';
				
		/*
					EXEC SCM_ADM_MAIL_SEND
						'kjj0070@lgespartner.com'				--//'kahonmalu@lgensol.com'
						, @v_mail_title
						, @TABLE_BODY
						, 'Y'
		*/
		
				--//메일 발송
				IF DB_NAME() <> 'LGCE_SCMDEV'
				BEGIN
					EXEC SCM_ADM_MAIL_SEND
						@v_to_mail					--//'kahonmalu@lgensol.com'
						, @v_mail_title
						, @TABLE_BODY
						, 'Y'
					;


			
					--MAIL 발송 LOG 저장
					EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
						'MAIL'
						, '-'
						, @v_program_name
						, @v_division_id
						, @V_REQUEST_NO
						, ''
						, ''
						, ''
						, ''
						, ''
						, ''
						, ''
						, '' --p_send_pgm
						, @v_to_mail
					;
				END
					

			END
	
	
		IF XACT_STATE() > 0 and @@trancount > 0
		BEGIN
			COMMIT TRAN 
		END
	------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		-- 트랜잭션 (END)
		--select XACT_STATE() as xact_state_1, @@trancount 
		--select XACT_STATE() as xact_state_2, @@trancount, 'A21'
		IF @@trancount > 0
		BEGIN 
			ROLLBACK TRAN
		END
		
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_log_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MSG;  /*-- 에러메시지 DISPLAY --*/

		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_BATCH';


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure @@@##########';
    SET @v_log_description = 'input_count: ' + Convert(NVARCHAR(10), @n_input_count) ;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_BATCH';

END










