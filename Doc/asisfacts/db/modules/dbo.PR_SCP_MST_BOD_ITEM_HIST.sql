/*
 * Program ID   : PR_SCP_MST_BOD_ITEM_HIST
 * Description  : BOD ITEM History 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/09/10   ygkim			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/11/23   hwyoon			SAFETY_STOCK 추가
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_BOD_ITEM_HIST]
 @p_seq				 NVARCHAR(MAX)
,@p_bod_id           NVARCHAR(MAX)
,@p_division_id      NVARCHAR(MAX)
,@p_item_id			 NVARCHAR(MAX)
,@p_priority         NVARCHAR(MAX)
,@p_from_yyyymmdd    NVARCHAR(MAX)
,@p_to_yyyymmdd      NVARCHAR(MAX)
,@p_safety_stock	 NVARCHAR(MAX)
,@p_valid_yn         NVARCHAR(MAX)
,@p_created_by       NVARCHAR(MAX)
,@p_creation_date    DATETIME
,@p_last_updated_by  NVARCHAR(MAX)
,@p_last_update_date DATETIME

AS

BEGIN

	--SET NOCOUNT ON;
	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_history_seq nvarchar(100);
	
		BEGIN    
			SET @v_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_BOD_ITEM_H
			
			INSERT INTO dbo.scp_mst_bod_item_h
					   (
							HISTORY_SEQ
						   ,SEQ
						   ,DIVISION_ID
						   ,BOD_ID
						   ,ITEM_ID
						   ,PRIORITY
						   ,FROM_YYYYMMDD
						   ,TO_YYYYMMDD
						   ,SAFETY_STOCK
						   ,VALID_YN
						   ,CREATED_BY
						   ,CREATION_DATE
						   ,LAST_UPDATED_BY
						   ,LAST_UPDATE_DATE
						   ,HISTORY_CREATION_DATE
					   )
				 VALUES
					   (
						@v_history_seq                   																			
					   ,@p_seq                        																			
					   ,@p_division_id                   																			
					   ,@p_bod_id                     																			
					   ,@p_item_id                       																			
					   ,@p_priority                     																			
					   ,@p_from_yyyymmdd                  																			
					   ,@p_to_yyyymmdd    
					   ,@p_safety_stock               																			
					   ,@p_valid_yn                      																			
					   ,@p_created_by                    																			
					   ,@p_creation_date                 																			
					   ,@p_last_updated_by               																			
					   ,@p_last_update_date              																			
					   ,SYSDATETIME()  
					   );
		END

	
	END;





