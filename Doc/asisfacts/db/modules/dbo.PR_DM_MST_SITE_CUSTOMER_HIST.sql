/*
 * Program ID   : PR_DM_MST_SITE_CUSTOMER_HIST
 * Description  : PR_DM_MST_SITE_CUSTOMER_HIST
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20180125 okaniel  Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180726 KHSONG   VALID_YN='N'으로 일괄 업데이트건 History 생성 추가
					 (SCM_MST_SITE 에 UPDATE건중 VALID_YN='N'이면 SCM_MST_SITE_CUSTOMER의 데이터를 
				     VALID_YN='N'으로 일괄 업데이트하면서 HISTORY를 생성)
 * 2020/09/09		P.C.I	[C20200909-000203] LOG 표준화 적용
 * 2021/01/18		KUNI	[C20210115-000214] (1)Sales Site (Sales Customer) - Active 이력 저장관련 오류사항 
											   단일ROW : SCM_MST_SITE_CUSTOMER.INPUT 값으로 저장											
											   (참고) 'ALL' = 'N' 											   
 */
CREATE PROCEDURE [dbo].[PR_DM_MST_SITE_CUSTOMER_HIST] 

	@p_division_id			NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_soldto_code			NVARCHAR(MAX),
	@p_shipto_code			NVARCHAR(MAX),
	@p_rep_yn				NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)
	, @p_valid_yn			NVARCHAR(MAX) = 'Y' -- [C20210115-000214] (1)

AS

BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_SITE_CUSTOMER_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	--[C20200909-000203] LOG 표준화 적용
		-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		
		-- 트랜잭션 (START)
		BEGIN TRANSACTION PR_DM_MST_SITE_CUSTOMER_HIST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

			IF @p_soldto_code = 'ALL' AND @p_shipto_code = 'ALL'  -- 일괄업데이트 진행건인경우 20180726 KHSONG   History 생성 추가
				BEGIN
						INSERT	INTO  [dbo].[SCM_MST_SITE_CUSTOMER_H]
						(									   
								 [HISTORY_SEQ]
								,[DIVISION_ID]
								,[SCM_SITE_ID]
								,[SOLDTO_CODE]
								,[SHIPTO_CODE]
								,[REP_YN]
								,[VALID_YN]
								,[CREATED_BY]
								,[CREATION_DATE]
								,[LAST_UPDATED_BY]
								,[LAST_UPDATE_DATE]
								,[ATTRIBUTE1]
								,[ATTRIBUTE2]
								,[ATTRIBUTE3]
								,[ATTRIBUTE4]
								,[ATTRIBUTE5]
								,[ATTRIBUTE6]
								,[ATTRIBUTE7]
								,[ATTRIBUTE8]
								,[ATTRIBUTE9]
								,[ATTRIBUTE10]
								,[HISTORY_CREATION_DATE]
						)
						SELECT 
								NEXT VALUE FOR SEQ1_SCM_MST_SITE_CUSTOMER_H AS HISTORY_SEQ
								,DIVISION_ID
								,SCM_SITE_ID
								,SOLDTO_CODE
								,SHIPTO_CODE
								,REP_YN
								, @p_valid_yn -- [C20210115-000214] (1)   ----    ,'N' AS VALID_YN
								,CREATED_BY
								,SYSDATETIME()
								,@p_created_by
								,SYSDATETIME()
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,SYSDATETIME()
						 FROM SCM_MST_SITE_CUSTOMER WITH(NOLOCK)
						  WHERE DIVISION_ID = @p_division_id
							and scm_site_id = @p_scm_site_id
						
				END
			ELSE  -- 일괄업데이트건이 아닌 경우
				BEGIN    
					SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_SITE_CUSTOMER_H
				
					   BEGIN

						INSERT	INTO  [dbo].[SCM_MST_SITE_CUSTOMER_H]
						(									   
									 [HISTORY_SEQ]
									,[DIVISION_ID]
									,[SCM_SITE_ID]
									,[SOLDTO_CODE]
									,[SHIPTO_CODE]
									,[REP_YN]
									,[VALID_YN]
									,[CREATED_BY]
									,[CREATION_DATE]
									,[LAST_UPDATED_BY]
									,[LAST_UPDATE_DATE]
									,[ATTRIBUTE1]
									,[ATTRIBUTE2]
									,[ATTRIBUTE3]
									,[ATTRIBUTE4]
									,[ATTRIBUTE5]
									,[ATTRIBUTE6]
									,[ATTRIBUTE7]
									,[ATTRIBUTE8]
									,[ATTRIBUTE9]
									,[ATTRIBUTE10]
									,[HISTORY_CREATION_DATE]
						)
						VALUES  
						(
									 @n_history_seq, 
									 @p_division_id,
									 @p_scm_site_id, 
									 @p_soldto_code, 
									 @p_shipto_code,
									 @p_rep_yn,
									 @p_valid_yn, -- [C20210115-000214] (1)   ---- 'Y'
									 @p_created_by,
									 SYSDATETIME(),
									 @p_created_by,
									 SYSDATETIME(),
									 NULL,
									 NULL,
									 NULL,
									 NULL,
									 NULL,
									 NULL,
									 NULL,
									 NULL,
									 NULL,
									 NULL,
									 SYSDATETIME()
					   );

					   END

			END

		COMMIT WORK;

		END TRY

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  PR_DM_MST_SITE_CUSTOMER_HIST;

	-- ERROR LOG
	SET @v_log_type = 'ERROR';
	SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
	SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
	SET @d_event_date = SYSDATETIME();
	SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	  
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END;

	



