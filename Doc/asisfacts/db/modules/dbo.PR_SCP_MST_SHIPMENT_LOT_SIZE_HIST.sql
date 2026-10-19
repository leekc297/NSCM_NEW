

/*
 * Program ID   : PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST
 * Description  : Lot Size History 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/07/19   byunghunjung	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/09/11	hwyoon			Lot Size 입력 시 sales site 추가
 * 2018/12/17	hwyoon			Split Yn 항목 추가
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST]
	@p_division_id		NVARCHAR(MAX),
	@p_operation_group	NVARCHAR(MAX),
	@p_from_site		NVARCHAR(MAX),
	@p_to_site			NVARCHAR(MAX),
	@p_item_id			NVARCHAR(MAX),
	@p_transport_mode	NVARCHAR(MAX),
	@p_lot_size			NVARCHAR(MAX),
	@p_increment		NVARCHAR(MAX),
	@p_split_yn		    NVARCHAR(MAX),
	@p_valid_yn			NVARCHAR(MAX),
	@p_created_by		NVARCHAR(MAX),
	@p_creation_date	DATETIME,
	@p_last_updated_by	NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
		BEGIN    
			SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_SHIPMENT_LOT_SIZE_H

			BEGIN

			INSERT INTO  SCP_MST_SHIPMENT_LOT_SIZE_H (
				history_seq,
				division_id,
				operation_group,
				from_site,
				to_site,
				item_id,
			    transport_mode,
			    lot_size,
				increment,
				SPLIT_YN,
			    valid_yn,
				created_by,
				creation_date,
				last_updated_by,
				last_update_date,
				history_creation_date)
			VALUES  (
				@n_history_seq,
				@p_division_id, 
				@p_operation_group, 
				@p_from_site, 
				@p_to_site, 
				@p_item_id, 
				@p_transport_mode,
				@p_lot_size,
				@p_increment,
				@p_split_yn,
				@p_valid_yn,
				@p_created_by , 
				@p_creation_date, 
				@p_last_updated_by,	
				SYSDATETIME() ,
				SYSDATETIME() 
			);

			END
		END

	END;



