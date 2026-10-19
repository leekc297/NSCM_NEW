

/*
 * Program ID   : SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY
 * Description  :출하수량 제약(포장재) 등록,수정 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/09/05   kh   			PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 *
 */
CREATE PROCEDURE [dbo].[SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY]

	-- Add the parameters for the stored procedure here
    @p_active_flag         NVARCHAR(MAX),
    @p_division_id         NVARCHAR(MAX),
	@p_opmz_plan_gr_id     NVARCHAR(MAX),
	@p_mdl_gr_nm           NVARCHAR(MAX),
	@p_item_id             NVARCHAR(MAX),
	@p_stage               NVARCHAR(MAX),
	@p_from_ste_id         NVARCHAR(MAX),
	@p_to_ste_id           NVARCHAR(MAX),
	@p_from_yyyymmdd       NVARCHAR(MAX),
	@p_to_yyyymmdd         NVARCHAR(MAX),
	@p_sipm_min_qyt        NVARCHAR(MAX),
	@p_sipm_max_qty        NVARCHAR(MAX),
	@p_sat_sipm_min_qty    NVARCHAR(MAX),
	@p_sat_sipm_max_qty    NVARCHAR(MAX),
	@p_sun_sipm_min_qty    NVARCHAR(MAX),
	@p_sun_sipm_max_qty    NVARCHAR(MAX),
	@p_val_tp_cd           NVARCHAR(MAX),
	@p_value_description   NVARCHAR(MAX),
	@p_valid_yn            NVARCHAR(MAX),
	@p_user_id             NVARCHAR(MAX),

	@p_pre_division_id     NVARCHAR(MAX),
	@p_pre_opmz_plan_gr_id NVARCHAR(MAX),
	@p_pre_mdl_gr_nm       NVARCHAR(MAX),
	@p_pre_item_id         NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag		  NVARCHAR(MAX);
	DECLARE @v_division_id        NVARCHAR(MAX);
	DECLARE @v_opmz_plan_gr_id    NVARCHAR(MAX);
	DECLARE @v_mdl_gr_nm          NVARCHAR(MAX);
	DECLARE @v_item_id            NVARCHAR(MAX);
	DECLARE @v_stage              NVARCHAR(MAX);
	DECLARE @v_from_ste_id        NVARCHAR(MAX);
	DECLARE @v_to_ste_id          NVARCHAR(MAX);
	DECLARE @v_from_yyyymmdd      NVARCHAR(MAX);
	DECLARE @v_to_yyyymmdd        NVARCHAR(MAX);
	DECLARE @v_sipm_min_qyt       NVARCHAR(MAX);
	DECLARE @v_sipm_max_qty       NVARCHAR(MAX);
	DECLARE @v_sat_sipm_min_qty   NVARCHAR(MAX);
	DECLARE @v_sat_sipm_max_qty   NVARCHAR(MAX);
	DECLARE @v_sun_sipm_min_qty   NVARCHAR(MAX);
	DECLARE @v_sun_sipm_max_qty   NVARCHAR(MAX);
	DECLARE @v_val_tp_cd          NVARCHAR(MAX);
	DECLARE @v_value_description  NVARCHAR(MAX);
	DECLARE @v_valid_yn           NVARCHAR(MAX);

	DECLARE @v_pre_division_id        NVARCHAR(MAX);
	DECLARE @v_pre_opmz_plan_gr_id    NVARCHAR(MAX);
	DECLARE @v_pre_mdl_gr_nm          NVARCHAR(MAX);
	DECLARE @v_pre_item_id            NVARCHAR(MAX);
	DECLARE @v_last_updated_by       NVARCHAR(MAX);

	DECLARE @v_Nsipm_min_qyt       NUMERIC(18, 0);
	DECLARE @v_Nsipm_max_qty       NUMERIC(18, 0);
	DECLARE @v_Nsat_sipm_min_qty   NUMERIC(18, 0);
	DECLARE @v_Nsat_sipm_max_qty   NUMERIC(18, 0);
	DECLARE @v_Nsun_sipm_min_qty   NUMERIC(18, 0);
	DECLARE @v_Nsun_sipm_max_qty   NUMERIC(18, 0);


	SET @v_active_flag          = NULL;	
	SET @v_division_id          = NULL;
	SET @v_opmz_plan_gr_id      = NULL;
	SET @v_mdl_gr_nm            = NULL;
	SET @v_item_id              = NULL;
	SET @v_stage                = NULL;
	SET @v_from_ste_id          = NULL;
	SET @v_to_ste_id            = NULL;
	SET @v_from_yyyymmdd        = NULL;
	SET @v_to_yyyymmdd          = NULL;
	SET @v_sipm_min_qyt         = NULL;
	SET @v_sipm_max_qty         = NULL;
	SET @v_sat_sipm_min_qty     = NULL;
	SET @v_sat_sipm_max_qty     = NULL;
	SET @v_sun_sipm_min_qty     = NULL;
	SET @v_sun_sipm_max_qty     = NULL;
	SET @v_val_tp_cd            = NULL;
	SET @v_value_description    = NULL;
	SET @v_valid_yn             = NULL;


	SET @v_pre_division_id      = NULL;
	SET @v_pre_opmz_plan_gr_id  = NULL;
	SET @v_pre_mdl_gr_nm        = NULL;
    SET @v_pre_item_id          = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;

	DECLARE @v_null_val   INTEGER =-99999;

	-- 예외처리 변수 설정
	DECLARE @v_err_code     INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	SET @v_last_updated_by  = @p_user_id

	BEGIN TRY

		-- 트렌젝션 시작
		BEGIN TRAN;


		--insert into test2 (col1, col3)
		--values('SCP0132- Save',
		--		'^@p_division_id       ^'+ @p_division_id      
		--	   +'^@p_opmz_plan_gr_id   ^'+ @p_opmz_plan_gr_id  
		--	   +'^@p_mdl_gr_nm         ^'+ @p_mdl_gr_nm        
		--	   +'^@p_item_id           ^'+ @p_item_id          
		--	   +'^@p_stage             ^'+ @p_stage            
		--	   +'^@p_from_ste_id       ^'+ @p_from_ste_id      
		--	   +'^@p_to_ste_id         ^'+ @p_to_ste_id        
		--	   +'^@p_from_yyyymmdd     ^'+ @p_from_yyyymmdd    
		--	   +'^@p_to_yyyymmdd       ^'+ @p_to_yyyymmdd      
		--	   +'^@p_sipm_min_qyt      ^'+ @p_sipm_min_qyt     
		--	   +'^@p_sipm_max_qty      ^'+ @p_sipm_max_qty     
		--	   +'^@p_sat_sipm_min_qty  ^'+ @p_sat_sipm_min_qty 
		--	   +'^@p_sat_sipm_max_qty  ^'+ @p_sat_sipm_max_qty 
		--	   +'^@p_sun_sipm_min_qty  ^'+ @p_sun_sipm_min_qty 
		--	   +'^@p_sun_sipm_max_qty  ^'+ @p_sun_sipm_max_qty 
		--	   +'^@p_val_tp_cd         ^'+ @p_val_tp_cd        
		--	   +'^@p_value_description ^'+ @p_value_description
		--	   +'^@p_Valid_yn          ^'+ @p_Valid_yn         
		--	   +'^@p_last_updated_by   ^'+ @p_user_id  )
	 
	    



		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);   

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN

			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag		   = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag       , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_division_id         = [dbo].[SCM_ARR_SPL_VAL](@p_division_id       , @v_delimiter , @mst_loop_cnt) ;
				SET @v_opmz_plan_gr_id     = [dbo].[SCM_ARR_SPL_VAL](@p_opmz_plan_gr_id   , @v_delimiter , @mst_loop_cnt) ;
				SET @v_mdl_gr_nm           = [dbo].[SCM_ARR_SPL_VAL](@p_mdl_gr_nm         , @v_delimiter , @mst_loop_cnt) ;
				SET @v_item_id             = [dbo].[SCM_ARR_SPL_VAL](@p_item_id           , @v_delimiter , @mst_loop_cnt) ;
				SET @v_stage               = [dbo].[SCM_ARR_SPL_VAL](@p_stage             , @v_delimiter , @mst_loop_cnt) ;
				SET @v_from_ste_id         = [dbo].[SCM_ARR_SPL_VAL](@p_from_ste_id       , @v_delimiter , @mst_loop_cnt) ;
				SET @v_to_ste_id           = [dbo].[SCM_ARR_SPL_VAL](@p_to_ste_id         , @v_delimiter , @mst_loop_cnt) ;
				SET @v_from_yyyymmdd       = [dbo].[SCM_ARR_SPL_VAL](@p_from_yyyymmdd     , @v_delimiter , @mst_loop_cnt) ;
				SET @v_to_yyyymmdd         = [dbo].[SCM_ARR_SPL_VAL](@p_to_yyyymmdd       , @v_delimiter , @mst_loop_cnt) ;
				SET @v_sipm_min_qyt        = [dbo].[SCM_ARR_SPL_VAL](@p_sipm_min_qyt      , @v_delimiter , @mst_loop_cnt) ;
				SET @v_sipm_max_qty        = [dbo].[SCM_ARR_SPL_VAL](@p_sipm_max_qty      , @v_delimiter , @mst_loop_cnt) ;
				SET @v_sat_sipm_min_qty    = [dbo].[SCM_ARR_SPL_VAL](@p_sat_sipm_min_qty  , @v_delimiter , @mst_loop_cnt) ;
				SET @v_sat_sipm_max_qty    = [dbo].[SCM_ARR_SPL_VAL](@p_sat_sipm_max_qty  , @v_delimiter , @mst_loop_cnt) ;
				SET @v_sun_sipm_min_qty    = [dbo].[SCM_ARR_SPL_VAL](@p_sun_sipm_min_qty  , @v_delimiter , @mst_loop_cnt) ;
				SET @v_sun_sipm_max_qty    = [dbo].[SCM_ARR_SPL_VAL](@p_sun_sipm_max_qty  , @v_delimiter , @mst_loop_cnt) ;
				SET @v_val_tp_cd           = [dbo].[SCM_ARR_SPL_VAL](@p_val_tp_cd         , @v_delimiter , @mst_loop_cnt) ;
				SET @v_value_description   = [dbo].[SCM_ARR_SPL_VAL](@p_value_description , @v_delimiter , @mst_loop_cnt) ;
				SET @v_Valid_yn            = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn          , @v_delimiter , @mst_loop_cnt) ;

				SET @v_pre_division_id     = [dbo].[SCM_ARR_SPL_VAL](@p_pre_division_id    , @v_delimiter, @mst_loop_cnt) ;
				SET @v_pre_opmz_plan_gr_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_opmz_plan_gr_id, @v_delimiter, @mst_loop_cnt) ;
				SET @v_pre_mdl_gr_nm       = [dbo].[SCM_ARR_SPL_VAL](@p_pre_mdl_gr_nm      , @v_delimiter, @mst_loop_cnt) ;
				SET @v_pre_item_id         = [dbo].[SCM_ARR_SPL_VAL](@p_pre_item_id        , @v_delimiter, @mst_loop_cnt) ;

			END

			-- 문자값을 숫자로 변환

		    if @v_sipm_min_qyt ='' 
			BEGIN
				SET @v_Nsipm_min_qyt = NULL
			END
			ELSE
			BEGIN
				-- 빈 문자열이 아닐 경우 숫자로 변환
				SET @v_Nsipm_min_qyt = CONVERT(NUMERIC(18, 0), @v_sipm_min_qyt)
			END

		    if @v_sipm_max_qty ='' 
			BEGIN
				SET @v_Nsipm_max_qty = NULL
			END
			ELSE
			BEGIN
				-- 빈 문자열이 아닐 경우 숫자로 변환
				SET @v_Nsipm_max_qty = CONVERT(NUMERIC(18, 0), @v_sipm_max_qty)
			END

			if @v_sat_sipm_min_qty ='' 
			BEGIN
				SET @v_Nsat_sipm_min_qty = NULL
			END
			ELSE
			BEGIN
				-- 빈 문자열이 아닐 경우 숫자로 변환
				SET @v_Nsat_sipm_min_qty = CONVERT(NUMERIC(18, 0), @v_sat_sipm_min_qty)
			END

			if @v_sat_sipm_max_qty ='' 
			BEGIN
				SET @v_Nsat_sipm_max_qty = NULL
			END
			ELSE
			BEGIN
				-- 빈 문자열이 아닐 경우 숫자로 변환
				SET @v_Nsat_sipm_max_qty = CONVERT(NUMERIC(18, 0), @v_sat_sipm_max_qty)
			END			    

			if @v_sun_sipm_min_qty ='' 
			BEGIN
				SET @v_Nsun_sipm_min_qty = NULL
			END
			ELSE
			BEGIN
				-- 빈 문자열이 아닐 경우 숫자로 변환
				SET @v_Nsun_sipm_min_qty = CONVERT(NUMERIC(18, 0), @v_sun_sipm_min_qty)
			END			
			
			if @v_sun_sipm_max_qty ='' 
			BEGIN
				SET @v_Nsun_sipm_max_qty = NULL
			END
			ELSE
			BEGIN
				-- 빈 문자열이 아닐 경우 숫자로 변환
				SET @v_Nsun_sipm_max_qty = CONVERT(NUMERIC(18, 0), @v_sun_sipm_max_qty)
			END						


			--삭제가 아닌 경우, 중복체크
			IF (@v_active_flag <> 'D')
			BEGIN 
				/***** 중복체크 *****/
				DECLARE @cnt INTEGER;
				SET @cnt = 0;

				----1. KEY중복 체크
				SELECT @cnt = COUNT(*)
				FROM SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY  WITH(NOLOCK)
				WHERE DIVISION_ID	= @v_division_id
				AND OPMZ_PLAN_GR_ID = @v_opmz_plan_gr_id
				AND MDL_GR_NM       = @v_mdl_gr_nm
				AND ITEM_ID         = @v_item_id
				AND NOT (
						    DIVISION_ID     = @v_pre_division_id
						AND OPMZ_PLAN_GR_ID = @v_pre_opmz_plan_gr_id
						AND MDL_GR_NM	    = @v_pre_mdl_gr_nm
						AND ITEM_ID         = @v_pre_item_id
						)

				IF(@cnt > 0)
				BEGIN
					SET @v_err_code    = 99010 ; 
					SET @v_err_message = N' 신규 입력 데이터 중 중복된 데이터가 있습니다.';
					THROW  @v_err_code, @v_err_message , 1; --예외발생
				END
				
				-- 2. 데이타 중복체크
				-- key가 동일하면 key외의 데이타가 동일해야함
				-- 단 VALID_YN이 Y 인 데이타에 한함
			   IF  (@v_active_flag = 'I')
				BEGIN
					SET @cnt = 0;
					SELECT @cnt = COUNT(*)
					FROM SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY  WITH(NOLOCK)
					WHERE DIVISION_ID	= @v_division_id
					AND OPMZ_PLAN_GR_ID = @v_opmz_plan_gr_id
					AND MDL_GR_NM       = @v_mdl_gr_nm
					AND VALID_YN       = 'Y'

					DECLARE @cnt_sub INTEGER;
					IF(@cnt >0 )
					BEGIN
						SELECT @cnt_sub = COUNT(*)
						FROM SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY  WITH(NOLOCK)
						WHERE DIVISION_ID	    = @v_division_id
						AND   OPMZ_PLAN_GR_ID   = @v_opmz_plan_gr_id
						AND   MDL_GR_NM         = @v_mdl_gr_nm
						AND   STAGE             = @v_stage
						AND   FROM_STE_ID       = @v_from_ste_id
						AND   TO_STE_ID         = @v_to_ste_id
						AND   FROM_YYYYMMDD     = @v_from_yyyymmdd
						AND   TO_YYYYMMDD       = @v_to_yyyymmdd
						AND   ISNULL(SIPM_MIN_QYT,@v_null_val)      =  ISNULL(@v_Nsipm_min_qyt,@v_null_val) 
						AND   ISNULL(SIPM_MAX_QTY,@v_null_val)       = ISNULL(@v_Nsipm_max_qty,@v_null_val) 
						AND   ISNULL(SAT_SIPM_MIN_QTY,@v_null_val)   = ISNULL(@v_Nsat_sipm_min_qty,@v_null_val) 
						AND   ISNULL(SAT_SIPM_MAX_QTY,@v_null_val)   = ISNULL(@v_Nsat_sipm_max_qty,@v_null_val) 
						AND   ISNULL(SUN_SIPM_MIN_QTY,@v_null_val)   = ISNULL(@v_Nsun_sipm_min_qty,@v_null_val) 
						AND   ISNULL(SUN_SIPM_MAX_QTY,@v_null_val)   = ISNULL(@v_Nsun_sipm_max_qty,@v_null_val) 
						AND   VALID_YN  ='Y'

						IF(@cnt_sub <> @cnt AND @cnt_sub <> 0)
						BEGIN
							SET @v_err_code    = 99010 ; 
							SET @v_err_message = N' 입력한 데이타의 값이 일치하지 않는 데이타가 있습니다.';
							THROW  @v_err_code, @v_err_message , 1; --예외발생
						END  -- @cnt <> @cnt_sub

					END  -- @cnt >0
				END  -- @v_active_flag = 'I'

				/***** 중복체크 *****/

				/** TYPE 체크  **/
				IF (@v_Nsat_sipm_min_qty IS NULL AND @v_Nsat_sipm_max_qty IS NULL AND @v_Nsun_sipm_min_qty IS NULL AND @v_Nsun_sipm_max_qty IS NULL)
				    SET @v_val_tp_cd ='A'
				ELSE 
				    SET @v_val_tp_cd ='B'
			 
				/** tYPE 체크 END  **/
			END
			 
			IF(@v_active_flag = 'I')
			BEGIN
                INSERT INTO SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY
                (
						 DIVISION_ID
						,OPMZ_PLAN_GR_ID
						,MDL_GR_NM
						,ITEM_ID
						,STAGE
						,FROM_STE_ID
						,TO_STE_ID
						,FROM_YYYYMMDD
						,TO_YYYYMMDD
						,SIPM_MIN_QYT
						,SIPM_MAX_QTY
						,SAT_SIPM_MIN_QTY
						,SAT_SIPM_MAX_QTY
						,SUN_SIPM_MIN_QTY
						,SUN_SIPM_MAX_QTY
						,VAL_TP_CD
						,VALUE_DESCRIPTION
					    ,VALID_YN
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
                )
                VALUES
                (
					   @v_division_id       
					  ,@v_opmz_plan_gr_id   
					  ,@v_mdl_gr_nm         
					  ,@v_item_id           
					  ,@v_stage             
					  ,@v_from_ste_id       
					  ,@v_to_ste_id         
					  ,@v_from_yyyymmdd     
					  ,@v_to_yyyymmdd       
					  ,@v_Nsipm_min_qyt     
					  ,@v_Nsipm_max_qty     
					  ,@v_Nsat_sipm_min_qty 
				      ,@v_Nsat_sipm_max_qty 
				      ,@v_Nsun_sipm_min_qty 
					  ,@v_Nsun_sipm_max_qty 
					  ,@v_val_tp_cd         
					  ,@v_value_description 
					  ,@v_Valid_yn          
                      ,@v_last_updated_by
                      ,GETDATE()
                      ,@v_last_updated_by
                      ,GETDATE()
                )

			END
			ELSE IF( @v_active_flag ='M' )
			BEGIN
			    -- 1.개별 UPDATE
                UPDATE SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY
                SET  DIVISION_ID         = @v_division_id      
                   , OPMZ_PLAN_GR_ID  	 = @v_opmz_plan_gr_id  
                   , MDL_GR_NM        	 = @v_mdl_gr_nm        
                   , ITEM_ID          	 = @v_item_id          
                   , STAGE            	 = @v_stage            
                   , FROM_STE_ID      	 = @v_from_ste_id      
                   , TO_STE_ID        	 = @v_to_ste_id        
                   , FROM_YYYYMMDD    	 = @v_from_yyyymmdd    
                   , TO_YYYYMMDD      	 = @v_to_yyyymmdd      
				   , SIPM_MIN_QYT		 = @v_Nsipm_min_qyt     
				   , SIPM_MAX_QTY	     = @v_Nsipm_max_qty	 
				   , SAT_SIPM_MIN_QTY	 = @v_Nsat_sipm_min_qty 
				   , SAT_SIPM_MAX_QTY	 = @v_Nsat_sipm_max_qty 
				   , SUN_SIPM_MIN_QTY	 = @v_Nsun_sipm_min_qty 
				   , SUN_SIPM_MAX_QTY	 = @v_Nsun_sipm_max_qty 
				   , VAL_TP_CD			 = @v_val_tp_cd        
				   , VALUE_DESCRIPTION	 = @v_value_description
				   , VALID_YN			 = @v_Valid_yn         
				   , LAST_UPDATED_BY	 = @v_last_updated_by
				   , LAST_UPDATE_DATE	 = SYSDATETIME()
                WHERE DIVISION_ID       = @v_pre_division_id    
                AND   OPMZ_PLAN_GR_ID   = @v_pre_opmz_plan_gr_id
                AND   MDL_GR_NM         = @v_pre_mdl_gr_nm      
                AND   ITEM_ID           = @v_pre_item_id   
				;


				-- 2.KEY 제외 전체 UPDATE
                UPDATE SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY
                SET  STAGE            	 = @v_stage            
                   , FROM_STE_ID      	 = @v_from_ste_id      
                   , TO_STE_ID        	 = @v_to_ste_id        
                   , FROM_YYYYMMDD    	 = @v_from_yyyymmdd    
                   , TO_YYYYMMDD      	 = @v_to_yyyymmdd      
				   , SIPM_MIN_QYT		 = @v_Nsipm_min_qyt     
				   , SIPM_MAX_QTY	     = @v_Nsipm_max_qty	 
				   , SAT_SIPM_MIN_QTY	 = @v_Nsat_sipm_min_qty 
				   , SAT_SIPM_MAX_QTY	 = @v_Nsat_sipm_max_qty 
				   , SUN_SIPM_MIN_QTY	 = @v_Nsun_sipm_min_qty 
				   , SUN_SIPM_MAX_QTY	 = @v_Nsun_sipm_max_qty 
				   , VAL_TP_CD			 = @v_val_tp_cd        
				  -- , VALUE_DESCRIPTION	 = @v_value_description
				  -- , VALID_YN			 = @v_Valid_yn         
				   , LAST_UPDATED_BY	 = @v_last_updated_by
				   , LAST_UPDATE_DATE	 = SYSDATETIME()
                WHERE DIVISION_ID       = @v_division_id    
                AND   OPMZ_PLAN_GR_ID   = @v_opmz_plan_gr_id
                AND   MDL_GR_NM         = @v_mdl_gr_nm      
				AND   VALID_YN          ='Y'
				;
			END
			--삭제기능 추가 (2025-07-16)
			ELSE IF(@v_active_flag ='D')
			BEGIN
				
				DELETE SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY
                WHERE DIVISION_ID       = @v_pre_division_id    
                AND   OPMZ_PLAN_GR_ID   = @v_pre_opmz_plan_gr_id
                AND   MDL_GR_NM         = @v_pre_mdl_gr_nm      
                AND   ITEM_ID           = @v_pre_item_id        
			END

		END

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;
			
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

	END TRY
	BEGIN CATCH
		IF (XACT_STATE() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
		BEGIN
			INSERT INTO scm_sys_log_batch (program_name
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

			--IF @@TRANCOUNT > 0
			--	COMMIT WORK;

		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END






 