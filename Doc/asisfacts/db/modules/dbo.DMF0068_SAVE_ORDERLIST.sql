

/*
 * Program ID   : [DMF0068_SAVE_ORDERLIST]
 * Description  : 소형 수주관리 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/010/03   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 개선과제 이행 - 소형 수주관리 수정
 */
CREATE PROCEDURE [dbo].[DMF0068_SAVE_ORDERLIST]
	 @DMF0068					AS DBO.DMF0068       READONLY
	 ,@P_USER_ID				NVARCHAR(MAX)
	 ,@P_DIVISION_ID			NVARCHAR(MAX)
	 ,@P_VERSION_NO				NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[DMF0068_SAVE_ORDERLIST]';
    DECLARE @v_log_type     NVARCHAR(30);
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	BEGIN TRY

	------------------------------------------------------------------------------------------------------------------
	/*
	입력 기간 validation 체크
	-날짜가 겹치면 안됨
	1.수주종료일이 시작일 보다 같거나 크면 리턴
	2.수주시작일이 종료일보다 같거나 작으면 리턴
	*/
	------------------------------------------------------------------------------------------------------------------

	DECLARE @CUR_PROJECT_CODE NVARCHAR(MAX)
	DECLARE @CUR_MEASURE NVARCHAR(MAX)
	DECLARE @CUR_FROM NVARCHAR(MAX)
	DECLARE @CUR_TO NVARCHAR(MAX)
	DECLARE @CUR_ATTRIBUTE1 NVARCHAR(MAX)

	DECLARE @V_DUP NVARCHAR(MAX)
	SET @V_DUP = ''

	DECLARE CUR CURSOR FOR
	SELECT PROJECT_CODE,MEASURE,YYYYMM_FROM,YYYYMM_TO, ATTRIBUTE1  FROM @DMF0068

	OPEN CUR 
	FETCH NEXT FROM CUR INTO       
	@CUR_PROJECT_CODE, @CUR_MEASURE, @CUR_FROM, @CUR_TO, @CUR_ATTRIBUTE1

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF EXISTS(
			SELECT * FROM DM_PLN_ORDER_MGT 
			WHERE DIVISION_ID = @P_DIVISION_ID
			--AND VERSION_NO = @P_VERSION_NO : --필수값에서 제거..필드 삭제할까?
			AND PROJECT_CODE = @CUR_PROJECT_CODE
			AND MEASURE = @CUR_MEASURE
			AND ATTRIBUTE1 <> @CUR_ATTRIBUTE1 -- 자기자신의 날짜는 제외
			AND (@CUR_TO >= YYYYMM_FROM AND @CUR_FROM <= YYYYMM_TO)
			)
		BEGIN
			SET @V_DUP = 'DUPLICATE'
			--SELECT  'DUPLICATE' AS result_code,  0 AS result_cnt ;
			--RETURN;
		END

		--@DMF0068 자체에서도 중복 잇나 확인
		--로직 검증 필요
		
		IF EXISTS(
			SELECT * FROM @DMF0068 
			WHERE PROJECT_CODE = @CUR_PROJECT_CODE
			AND MEASURE = @CUR_MEASURE
			AND ATTRIBUTE1 <> @CUR_ATTRIBUTE1 -- 자기자신의 날짜는 제외
			AND (@CUR_TO >= YYYYMM_FROM AND @CUR_FROM <= YYYYMM_TO)
			)
		BEGIN
			SET @V_DUP = 'DUPLICATE'
			--SELECT  'DUPLICATE' AS result_code,  0 AS result_cnt ;
			--RETURN;
		END		

		FETCH NEXT FROM CUR INTO
		@CUR_PROJECT_CODE, @CUR_MEASURE, @CUR_FROM, @CUR_TO, @CUR_ATTRIBUTE1
	END

	CLOSE CUR
	DEALLOCATE CUR

	IF @V_DUP = 'DUPLICATE'
	BEGIN
		--SET @v_log_type = 'END';
		--SET @v_log_message = '########## END of procedure ##########';
		--SET @v_description = '';
		--SET @d_event_date = SYSDATETIME();
		--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		SELECT  'DUPLICATE' AS result_code,  0 AS result_cnt ;

	END
	ELSE
	BEGIN

		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-------------------------------------------------

		MERGE INTO DM_PLN_ORDER_MGT AS A
		USING @DMF0068 AS B
		   ON (A.ATTRIBUTE1 = B.ATTRIBUTE1)
		 WHEN MATCHED THEN
		   UPDATE SET 
				A.ATTRIBUTE3 = A.YYYYMM_FROM --날짜 변경했나 여부 확인 위해 변경전 날짜 저장
				,A.ATTRIBUTE4 = A.YYYYMM_TO
				,A.YYYYMM_FROM = B.YYYYMM_FROM
			  ,A.YYYYMM_TO = B.YYYYMM_TO
			  ,A.ORDER_APPROVAL = B.ORDER_APPROVAL
			  ,A.ORDER_NOW = B.ORDER_NOW
			  ,A.LAST_UPDATED_BY = @P_USER_ID
			  ,A.LAST_UPDATE_DATE = GETDATE()
		 WHEN NOT MATCHED THEN
		   INSERT           
				(
					DIVISION_ID
				   --,VERSION_NO
				   ,PROJECT_CODE
				   ,YYYYMM_FROM
				   ,YYYYMM_TO
				   ,MEASURE
				   ,ORDER_APPROVAL
				   ,ORDER_NOW
				   ,CREATED_BY
				   ,CREATION_DATE
				   ,LAST_UPDATED_BY
				   ,LAST_UPDATE_DATE
				   ,ATTRIBUTE1
				   ,ATTRIBUTE2
			   )
		   VALUES
	   			(
					@P_DIVISION_ID
				   --,@P_VERSION_NO
				   ,B.PROJECT_CODE
				   ,B.YYYYMM_FROM
				   ,B.YYYYMM_TO
				   ,B.MEASURE
				   ,B.ORDER_APPROVAL
				   ,B.ORDER_NOW
				   ,@P_USER_ID
				   ,GETDATE()
				   ,@P_USER_ID
				   ,GETDATE()
				   ,NEWID() --자기자신 고유값
				   ,B.ATTRIBUTE2--소속된 메저그룹 고유값
				  /* ,CASE WHEN ISNULL(B.ATTRIBUTE2, '') <> '' THEN B.ATTRIBUTE2
					ELSE
						CASE WHEN (SELECT COUNT(*) FROM DM_PLN_ORDER_MGT
							WHERE DIVISION_ID = @P_DIVISION_ID
							AND VERSION_NO = @P_VERSION_NO
							AND PROJECT_CODE = B.PROJECT_CODE
							AND YYYYMM_FROM = B.YYYYMM_FROM
							AND YYYYMM_TO = B.YYYYMM_TO) > 0
							THEN 
								(
									SELECT TOP 1 CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN CONVERT(VARCHAR(100),NEWID()) ELSE ATTRIBUTE2 END FROM DM_PLN_ORDER_MGT
								WHERE DIVISION_ID = @P_DIVISION_ID
								AND VERSION_NO = @P_VERSION_NO
								AND PROJECT_CODE = B.PROJECT_CODE
								AND YYYYMM_FROM = B.YYYYMM_FROM
								AND YYYYMM_TO = B.YYYYMM_TO
								)
							ELSE NEWID()
							END
				    END
					*/
					
			   )
		;


		DECLARE @ROWCNT INT
		SET @ROWCNT = @@ROWCOUNT

		--------------------------------------------------------------------------------------------------------------------------------------------
		/*
		수정모드(M)이나 실제로는 신규일 경우 ATTRIBUTE2(2쌍의 메저별 고유 값) 이 없음
		따라서 ATTRIBUTE2 값이 없는 데이터 조회하여 
			DIVISION_ID . VERSION_NO, PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO
		가 같은 게 있으면 그 데이터의 ATTRIBUTE2로 저장
		없으면 newid 생성
		=>단일 쿼리로 안되어 커서로 처리

		*/
		--------------------------------------------------------------------------------------------------------------------------------------------
		DECLARE @CUR_DIVISION_ID NVARCHAR(MAX)
		DECLARE @CUR_VERSION_NO NVARCHAR(MAX)
		DECLARE @CUR_ATTRIBUTE2 NVARCHAR(MAX)

		DECLARE CUR2 CURSOR FOR
		SELECT PROJECT_CODE,YYYYMM_FROM,YYYYMM_TO, ATTRIBUTE1  FROM DM_PLN_ORDER_MGT WHERE ISNULL(ATTRIBUTE2, '') = ''

		OPEN CUR2
		FETCH NEXT FROM CUR2 INTO       
		@CUR_PROJECT_CODE, @CUR_FROM, @CUR_TO, @CUR_ATTRIBUTE1

		WHILE @@FETCH_STATUS = 0
		BEGIN

			IF EXISTS(
				SELECT * FROM DM_PLN_ORDER_MGT 
				WHERE DIVISION_ID = @P_DIVISION_ID
				--AND VERSION_NO = @P_VERSION_NO
				AND PROJECT_CODE = @CUR_PROJECT_CODE
				AND YYYYMM_FROM = @CUR_FROM
				AND YYYYMM_TO = @CUR_TO
				)
			BEGIN
				UPDATE DM_PLN_ORDER_MGT
				SET
				ATTRIBUTE2 = 
				(
					SELECT TOP 1 CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN CONVERT(VARCHAR(100),NEWID()) ELSE ATTRIBUTE2 END FROM DM_PLN_ORDER_MGT
									WHERE DIVISION_ID = @P_DIVISION_ID
									--AND VERSION_NO = @P_VERSION_NO
									AND PROJECT_CODE = @CUR_PROJECT_CODE
									AND YYYYMM_FROM = @CUR_FROM
									AND YYYYMM_TO = @CUR_TO		
				)

				WHERE ATTRIBUTE1 = @CUR_ATTRIBUTE1
			END
			ELSE
			BEGIN
				UPDATE DM_PLN_ORDER_MGT
				SET
				ATTRIBUTE2 = NEWID()
				WHERE ATTRIBUTE1 = @CUR_ATTRIBUTE1
			END

		FETCH NEXT FROM CUR2 INTO
		@CUR_PROJECT_CODE, @CUR_FROM, @CUR_TO, @CUR_ATTRIBUTE1
		END

		CLOSE CUR2
		DEALLOCATE CUR2

		-----------------------------------------------------------------------------------



		--------------------------------------------------------------------------
		--수주기간 변경된 것들 있으면 쌍이되는 메저의 수주기간도 같이 변경한다 
		-------------------------------------------------------------------------
		DECLARE CUR3 CURSOR FOR
		SELECT YYYYMM_FROM,YYYYMM_TO, ATTRIBUTE1, ATTRIBUTE2 FROM DM_PLN_ORDER_MGT
		WHERE ATTRIBUTE3 IS NOT NULL 
		AND ATTRIBUTE4 IS NOT NULL 
		AND (YYYYMM_FROM <> ATTRIBUTE3 OR YYYYMM_TO <> ATTRIBUTE4) --날짜가 변경됐는지 여부

		OPEN CUR3
		FETCH NEXT FROM CUR3 INTO       
		@CUR_FROM, @CUR_TO, @CUR_ATTRIBUTE1, @CUR_ATTRIBUTE2

		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE DM_PLN_ORDER_MGT
			SET
			YYYYMM_FROM = @CUR_FROM
			,YYYYMM_TO = @CUR_TO
			WHERE ATTRIBUTE2 = @CUR_ATTRIBUTE2 -- 같은 그룹
			AND ATTRIBUTE1 <> @CUR_ATTRIBUTE1 --자기자신은 제외

		FETCH NEXT FROM CUR3 INTO
		@CUR_FROM, @CUR_TO, @CUR_ATTRIBUTE1, @CUR_ATTRIBUTE2
		END

		CLOSE CUR3
		DEALLOCATE CUR3

		--중복처리 방지 위해 null 처리
		UPDATE DM_PLN_ORDER_MGT
		SET
		ATTRIBUTE3 = NULL
		,ATTRIBUTE4 = NULL
		WHERE ATTRIBUTE3 IS NOT NULL 
		AND ATTRIBUTE4 IS NOT NULL 

		-----------------------------------------------------------------------

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @ROWCNT AS result_cnt ;

		END

	END TRY

	BEGIN CATCH 
		BEGIN

			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END




