

/*
 * Program ID   : PR_SCP_MST_JIG_HIST
 * Description  : Jig Master History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/18   hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/11/01	hwyoon			Operation ID 조회 추가
 *
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_JIG_HIST]
	@p_jig_seq			NVARCHAR(MAX),
	@p_division_id 		NVARCHAR(MAX),
	@p_scm_site_id		NVARCHAR(MAX),
	@p_operation_id		NVARCHAR(MAX),
	@p_jig_name			NVARCHAR(MAX),
	@p_valid_yn			NVARCHAR(MAX),
	@p_created_by		NVARCHAR(MAX),
	@p_creation_date	NVARCHAR(MAX),
	@p_last_updated_by	NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_JIG_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	BEGIN    
		SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_JIG_H

		INSERT	INTO  SCP_MST_JIG_H (									   
						HISTORY_SEQ, DIVISION_ID, SCM_SITE_ID, OPERATION_ID, JIG_SEQ, JIG_NAME, VALID_YN 
						,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE)
		VALUES  
					(
					 @n_history_seq, @p_division_id, @p_scm_site_id, @p_operation_id, @p_jig_seq, @p_jig_name, @p_valid_yn
					,@p_created_by, @p_creation_date, @p_last_updated_by, SYSDATETIME(), SYSDATETIME()
					);
	END

			
END;







