
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_USER_GROUP' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 04    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE]
	@p_DQ_ID                  NVARCHAR(MAX),    -- 단일값 INPUT (ex : 1)
	@p_GROUP_ID               NVARCHAR(MAX),    -- 다중값 INPUT (ex : A,B,C)
	@p_VALID_YN               NVARCHAR(MAX),    -- 단일값 INPUT (ex : Y)
	@p_CREATED_BY             NVARCHAR(MAX),    -- 단일값 INPUT (ex : Tester)
	@p_LAST_UPDATED_BY        NVARCHAR(MAX)     -- 단일값 INPUT (ex : Tester)

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	DECLARE @delete_cnt	    	INTEGER = 0;

	DECLARE @recv_GROUP_ID		NVARCHAR(MAX);
	SET @recv_GROUP_ID = NULL;		
	SET @recv_GROUP_ID = @p_GROUP_ID;

	DECLARE @v_GROUP_ID   		NVARCHAR(MAX);
	DECLARE @v_delimiter        NVARCHAR(1)
	SET @v_delimiter = ','  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- recv init
    SET  @v_GROUP_ID            =  NULL;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION DQ_CREATE_USER_GROUP_DELETE;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_GROUP_ID, @v_delimiter);    
		SELECT @max_loop_cnt;
		
		WHILE LEN(@recv_GROUP_ID) > 0 AND @mst_loop_cnt < @max_loop_cnt

		-- (0)
		BEGIN    
			
		SELECT @max_loop_cnt AS max_loop_cnt
		-- @mst_loop_cnt 1증가
		SET @mst_loop_cnt = @mst_loop_cnt + 1;

		-- 각 컬럼들에 대한 스플릿처리로직 스타트
		BEGIN

		SET @v_GROUP_ID = [dbo].[SCM_ARR_SPL_VAL] (@p_GROUP_ID, @v_delimiter , @mst_loop_cnt) ;    
		
		-- 확인용 변수값 DISPLAY 
		SELECT @v_GROUP_ID AS v_GROUP_ID

		END

          /*--------- MULTI & SINGLE ROW START --------*/

		  /*-- max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행하도록함 --*/
          IF       @mst_loop_cnt <= @max_loop_cnt  
	      -- (1) 
		  BEGIN
		    
			 -- 첫번째 DQ_ID 값 기준으로 delete 수행
			 IF  @mst_loop_cnt = 1
	      -- (2)	 
			 BEGIN
		         DELETE 
		           FROM [dbo].[SCM_ADM_DQ_USER_GROUP]
		             WHERE 1=1
		               AND  [DQ_ID]     =   @p_DQ_ID      
				 -- 확인용
				 SET @delete_cnt = @delete_cnt + 1
				 select    @delete_cnt  as   delete_cnt 
				 -- 확인용
			 END
	      -- (2)	 
		  END
	      -- (1)	 
		END
		-- (0)
     -- IF @@TRANCOUNT > 0 

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION DQ_CREATE_USER_GROUP_DELETE;
      -- ROLLBACK
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

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
