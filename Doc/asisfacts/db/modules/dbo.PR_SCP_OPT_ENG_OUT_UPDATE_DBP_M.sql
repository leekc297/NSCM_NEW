




/*  
 * Program ID   : PR_SCP_OPT_ENG_OUT_UPDATE_DBP_M
 * Description  : Demand Buffer Pegging 최적화 ODS 테이블 Update
 *				 - Pegging Path 정보 
 *				 - ATTRIBUTE13 : 보정된 parentpeggingid
 *				 - ATTRIBUTE14 : Demand별 pegging 순서  
 *				 - ATTRIBUTE15 : peggingid path 
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2026.03.27	hrkim		Initial Release : PJ20264226 Next SCM Pilot 설계 및 개발
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_OUT_UPDATE_DBP_M]
	@P_PLAN_ID	NVARCHAR(100)	= NULL
AS

BEGIN

-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	DECLARE @V_PLAN_ID				NVARCHAR(100)	= @P_PLAN_ID;
	DECLARE @V_DIVISION_ID			NVARCHAR(50)	= '';
	DECLARE @V_PLAN_START_YYYYMMDD	NVARCHAR(8)		= '';
	DECLARE @V_PLAN_END_YYYYMMDD	NVARCHAR(8)		= '';
	DECLARE @V_PLAN_GROUP			NVARCHAR(100)	= ''

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_OPT_ENG_OUT_UPDATE_DBP_M';
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
		SET @v_description = CONCAT('[plan_id=', ISNULL(@V_PLAN_ID,''),  ']')
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

		if object_id('tempdb..#base_data') is not null	drop table #base_data;
		if object_id('tempdb..#result') is not null		drop table #result;

		select bp.demandpeggingid
			, isnull(cp.parentpeggingid, bp.parentpeggingid) as parentpeggingid
		into #base_data
		from scp_opt_eng_out_demand_buffer_pegging_sn  bp with(nolock)
			 left join scp_opt_eng_out_demand_consume_pegging_sn cp with(nolock) 
					on cp.plan_id			= bp.plan_id
				   and cp.demandpeggingid	= bp.parentpeggingid
		where 1=1
		  and bp.plan_id = @v_plan_id


		create index #base_data_idx1 on #base_data( parentpeggingid, demandpeggingid)

		;with recursive_data as (
			select bd.*
				  ,convert(integer, 1)  as depth 
				  ,convert(nvarchar(4000), bd.demandpeggingid)	as id_path
			 from #base_data bd 
			where (parentpeggingid is null					  -- 전극외
				or parentpeggingid in ('nan_C' , 'nan_A') )   -- 전극 
			union all
			select bd.*
				  ,convert(integer, rd.depth + 1)  as depth 
				  ,convert(nvarchar(4000), concat(rd.id_path, '>', bd.demandpeggingid)) as id_path 
			 from #base_data bd 
				  inner join recursive_data rd 
						  on rd.demandpeggingid = bd.parentpeggingid
		) 
		select   rd.demandpeggingid
				,rd.depth
				,rd.id_path
				,rd.parentpeggingid
		into #result
		from recursive_data rd
			 inner join scp_opt_eng_out_demand_buffer_pegging_sn bp with(nolock)
					 on bp.plan_id			= @v_plan_id
					and bp.demandpeggingid = rd.demandpeggingid 
		where 1=1


	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

		update bp
		   set bp.attribute13 = rd.parentpeggingid
			  ,bp.attribute14 = rd.depth
			  ,bp.attribute15 = rd.id_path
		from scp_opt_eng_out_demand_buffer_pegging_sn bp with(nolock)
			 inner join #result rd
				 	on bp.demandpeggingid = rd.demandpeggingid 
		where 1=1
		  and bp.plan_id = @v_plan_id
		  
		  SET @n_log_count = @@ROWCOUNT;

	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

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
    SET @v_description = CONCAT('[plan_id=', ISNULL(@V_PLAN_ID,''),  ']['  + @v_exec_time + ']') ;          
    SET @d_event_date  = SYSDATETIME()  ;                 
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
