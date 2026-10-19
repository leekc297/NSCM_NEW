/*
 * Program ID   : [SCP0015_SAVE_PLAN_MST_COMFIRM]
 * Description  : PLAN CONFIRM 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/28   PJS   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/17   byunghunjung   전극 제외
 * 실행예제)
 *  EXEC SCP0015_SAVE_PLAN_MST_COMFIRM @p_modeling_id='2',@p_division_id='81',@p_revision_no='20171211-MA-02',@p_confirm_user='2014001'
 */
CREATE PROCEDURE [dbo].[SCP0015_SAVE_PLAN_MST_COMFIRM]
 (
	 @p_modeling_id  	NVARCHAR(1000)
  	,@p_division_id		NVARCHAR(1000)  
	,@p_revision_no		NVARCHAR(1000)
	,@p_confirm_user	NVARCHAR(1000)
 )
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @v_plan_name NVARCHAR(8)='';
	DECLARE @v_plan_type NVARCHAR(2)='';
	DECLARE @v_plan_seq  NVARCHAR(2)='';
    DECLARE @v_plan_id   NVARCHAR(30)='';	
	
		-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0015_SAVE_PLAN_MST_COMFIRM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	
		SET @v_plan_name = [dbo].[FN_SCM_SPLIT](@p_revision_no,1,'-');
		SET @v_plan_type = [dbo].[FN_SCM_SPLIT](@p_revision_no,2,'-');
		SET @v_plan_seq  = [dbo].[FN_SCM_SPLIT](@p_revision_no,3,'-');

		SET @v_plan_id = (
							SELECT b.plan_id
							  FROM dbo.scm_mst_plan A
								   INNER JOIN scm_mst_plan_detail B ON a.division_id=b.division_id
																   AND a.plan_id    =b.plan_id	   
							 WHERE b.modeling_id = @p_modeling_id
							   AND a.division_id = @p_division_id
							   AND a.plan_name   = @v_plan_name
							   AND b.plan_type   = @v_plan_type
							   AND b.plan_seq    = @v_plan_seq 
							) ;
		
		UPDATE scm_mst_plan_detail
		   SET CONFIRM_FLAG =''
			  ,CONFIRM_USER =''
			  ,CONFIRM_DATE =''
		 WHERE modeling_id = @p_modeling_id
		   AND division_id = @p_division_id
		   AND plan_id     = @v_plan_id
		   AND plan_type   = @v_plan_type ;
		   
		UPDATE scm_mst_plan_detail
		   SET CONFIRM_FLAG ='Y'
			  ,CONFIRM_USER = @p_confirm_user
			  ,CONFIRM_DATE = CONVERT(VARCHAR, GETDATE(),120)
		 WHERE modeling_id = @p_modeling_id
		   AND division_id = @p_division_id
		   AND plan_id     = @v_plan_id
		   AND plan_type   = @v_plan_type 
		   AND plan_seq    = @v_plan_seq ;

		--  PRINT '@p_modeling_id = '+ @p_modeling_id;
		--	PRINT '@p_division_id = '+ @p_division_id;
		--	PRINT '@v_plan_id     = '+ @v_plan_id;
		--	PRINT '@v_plan_type   = '+ @v_plan_type;
		--	PRINT '@v_plan_seq    = '+ @v_plan_seq;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		DECLARE @x_seq  INT;
		SET @x_seq=	CONVERT(INT, @v_plan_seq);

		----  엔진결과 외부시스템 인터페이스 처리 실행
		EXEC PR_SCP_PLN_INTERFACE_PLAN 	@p_division_id,	@v_plan_name, @v_plan_type,	@x_seq, @p_confirm_user ;

		-- ESS 전극소요관련 매출 INSERT
		--IF ( @p_division_id ='82')
		--	BEGIN
		--		EXEC dbo.PR_SCM_PLN_MKT_FCST_ESS_ELEC_TRAN;
		--	END;

		COMMIT TRAN;	

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code, (SELECT COUNT(*)  
										FROM scm_mst_plan_detail 
										WHERE modeling_id = @p_modeling_id
									   AND division_id = @p_division_id
									   AND plan_id     = @v_plan_id
									   AND plan_type   = @v_plan_type 
									   AND plan_seq    = @v_plan_seq
									 ) AS result_cnt ;		
		 
		-- 수정결과 반환
		SELECT CONFIRM_FLAG AS CONFIRM_YN
			  ,CONFIRM_USER AS CONFIRM_USER
			  ,CONFIRM_DATE AS CONFIRM_TIME
		 FROM scm_mst_plan_detail	  
		WHERE modeling_id = @p_modeling_id
		   AND division_id = @p_division_id
		   AND plan_id     = @v_plan_id
		   AND plan_type   = @v_plan_type 
		   AND plan_seq    = @v_plan_seq ;

	END TRY

	BEGIN CATCH 
	  BEGIN
	    if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
		VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

		--IF @@TRANCOUNT > 0
		--  COMMIT WORK;
	  END;

	  -- error코드, errror 메시지 반환
	  SELECT 'F' AS result_code;
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END
