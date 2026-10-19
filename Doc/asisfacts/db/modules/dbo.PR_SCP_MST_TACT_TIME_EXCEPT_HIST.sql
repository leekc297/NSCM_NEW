/*
 * Program ID   : PR_SCP_MST_TACT_TIME_EXCEPT_HIST
 * Description  : TACT TIME EXCEPT History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.05.09   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.28	hwyoon			  사용여부(use_yn) 컬럼 조회 추가
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_TACT_TIME_EXCEPT_HIST]
	 @p_division_id				NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_operation_id			NVARCHAR(MAX)
	, @p_line_id				NVARCHAR(MAX)
	, @p_tact_time_start_date	NVARCHAR(MAX)
	, @p_tact_time_end_date	    NVARCHAR(MAX)
	, @p_tact_time				NVARCHAR(MAX)
	, @p_yield			        NVARCHAR(MAX)
	, @p_except_comment	        NVARCHAR(MAX)
	, @p_use_yn					NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_creation_date			DATETIME

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
		BEGIN    
			SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_TACT_TIME_EXCEPT_H

			BEGIN
			INSERT	INTO  SCP_MST_TACT_TIME_EXCEPT_H (
				 history_seq
			    ,division_id
			    ,plant_site_id
			    ,item_id
			    ,operation_id
			    ,line_id
			    ,tact_time_start_date
			    ,tact_time_end_date
			    ,tact_time
			    ,yield
			    ,except_comment
				,use_yn
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
				@p_operation_id,
				@p_line_id,
				@p_tact_time_start_date,
				@p_tact_time_end_date,
				@p_tact_time , 
				@p_yield , 
				@p_except_comment ,
				@p_use_yn,
				@p_created_by , 
				@p_creation_date, 
				@p_last_updated_by,	
				SYSDATETIME() ,
				SYSDATETIME() 
			);
			END
		END

	END;

