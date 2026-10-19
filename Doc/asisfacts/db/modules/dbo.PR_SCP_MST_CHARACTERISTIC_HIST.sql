

/*
 * Program ID   : PR_SCP_MST_CHARACTERISTIC_HIST
 * Description  : Plant Capa History 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018.12.20   hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_CHARACTERISTIC_HIST]
 @p_division_id       NVARCHAR(MAX)
,@p_plant_site_id     NVARCHAR(MAX)
,@p_item_id           NVARCHAR(MAX)
,@p_daily_capa_qty    NVARCHAR(MAX)
,@p_valid_yn          NVARCHAR(MAX)
,@p_created_by        NVARCHAR(MAX)
,@p_creation_date     NVARCHAR(MAX)
,@p_last_updated_by   NVARCHAR(MAX)
--,@p_last_update_date  NVARCHAR(MAX)


AS

BEGIN

	--SET NOCOUNT ON;
	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_history_seq	nvarchar(100);	
	
		BEGIN    
			SET @v_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_CHAR_CAPA_H
				
				                                      
			INSERT INTO dbo.SCP_MST_CHAR_CAPA_H        
						(HISTORY_SEQ                      
						,DIVISION_ID                      
						,PLANT_SITE_ID                    
						,ITEM_ID                                             
						,DAILY_CAPA_QTY                            
						,VALID_YN                         
						,CREATED_BY                       
						,CREATION_DATE                    
						,LAST_UPDATED_BY                  
						,LAST_UPDATE_DATE                 
						,HISTORY_CREATION_DATE
						)           
					VALUES                                    
						(@v_history_seq            
						,@p_division_id            
						,@p_plant_site_id          
						,@p_item_id                             
						,@p_daily_capa_qty                  
						,@p_valid_yn               
						,@p_created_by             
						,@p_creation_date          
						,@p_last_updated_by        
						,SYSDATETIME()       						
						,SYSDATETIME()  
						);
		END

	
	END;







