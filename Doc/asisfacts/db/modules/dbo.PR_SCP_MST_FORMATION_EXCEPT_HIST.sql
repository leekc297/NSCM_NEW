/*
 * Program ID   : PR_SCP_MST_FORMATION_EXCEPT_HIST
 * Description  : FORMATION EXCEPT History 
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2018.05.09   byunghunjung		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.04.08	hwyoon				[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_FORMATION_EXCEPT_HIST]
	  @p_division_id			NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_item_id			    NVARCHAR(MAX)
	, @p_formation_start_date	NVARCHAR(MAX)
	, @p_formation_end_date		NVARCHAR(MAX)
	, @p_formation_yield		NVARCHAR(MAX)
	, @p_char_yield				NVARCHAR(MAX)
	, @p_formation_total_yield	NVARCHAR(MAX)
	, @p_except_comment			NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_creation_date			DATETIME

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
		BEGIN    
			SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_FORMATION_EXCEPT_H

			BEGIN
			INSERT	INTO  SCP_MST_FORMATION_EXCEPT_H (
				history_seq
				,division_id
				,plant_site_id
				,item_id
				,formation_start_date
				,formation_end_date
				,formation_yield
				,CHAR_YIELD
				,FORMATION_TOTAL_YIELD
				,except_comment
				,created_by
				,creation_date
				,last_updated_by
				,last_update_date
				,history_creation_date)
			VALUES  (
				@n_history_seq,
				@p_division_id, 
				@p_plant_site_id, 
				@p_item_id, 
				@p_formation_start_date,
				@p_formation_end_date,
				CASE WHEN ISNULL(@p_formation_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @p_formation_yield) / 100)) end,
				CASE WHEN ISNULL(@p_char_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @p_char_yield) / 100)) end,
				CASE WHEN ISNULL(@p_formation_total_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @p_formation_total_yield) / 100)) end,
				@p_except_comment ,
				@p_created_by , 
				@p_creation_date, 
				@p_last_updated_by,	
				SYSDATETIME() ,
				SYSDATETIME() 
			);
			END
		END

	END;

