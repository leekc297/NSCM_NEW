

/*
 * Program ID   : PR_SCP_MST_FINAL_ITEM_HIST
 * Description  : Demand Grouping History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.18   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_FINAL_ITEM_HIST]

@p_division_id			NVARCHAR(MAX),
@p_item_id				NVARCHAR(MAX),
@p_nick_name			NVARCHAR(MAX),
@p_item_class			NVARCHAR(MAX),
@p_operation_group		NVARCHAR(MAX),
@p_operation_group_id	NVARCHAR(MAX),
@p_electrode_type		NVARCHAR(MAX),
@p_flow_id				NVARCHAR(MAX),
@p_demand_grouping_days	NVARCHAR(MAX),
@p_created_by			NVARCHAR(MAX),
@p_creation_date		DATETIME,
@p_last_updated_by		NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	BEGIN    
		
		SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_FINAL_ITEM_H	
	
		INSERT INTO SCP_MST_FINAL_ITEM_H
           (history_seq ,division_id ,item_id ,nick_name ,item_class ,operation_group ,operation_group_id
           ,electrode_type ,flow_id ,demand_grouping_days
		   ,created_by ,creation_date ,last_updated_by ,last_update_date ,history_creation_date)
			VALUES  
			(
			  @n_history_seq,@p_division_id,@p_item_id,@p_nick_name,@p_item_class,@p_operation_group,@p_operation_group_id
			, @p_electrode_type,@p_flow_id,@p_demand_grouping_days
			, @p_created_by,@p_creation_date,@p_last_updated_by,SYSDATETIME(),SYSDATETIME()
			);
	END

END




