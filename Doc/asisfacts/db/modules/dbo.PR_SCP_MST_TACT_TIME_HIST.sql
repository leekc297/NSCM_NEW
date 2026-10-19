/*
 * Program ID   : PR_SCP_MST_TACT_TIME_HIST
 * Description  : Tac TIme Master History 
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2018.03.27   byunghunjung		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.17	hwyoon				Tact Time 조회항목 추가(item UOM, UOM Convert)
 * 2019.12.13	hwyoon				Lane Qty 항목 추가(입력/수정 가능)
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_TACT_TIME_HIST]
 @p_division_id       NVARCHAR(MAX)
,@p_plant_site_id     NVARCHAR(MAX)
,@p_item_id           NVARCHAR(MAX)
,@p_operation_id      NVARCHAR(MAX)
,@p_line_id           NVARCHAR(MAX)
,@p_priority          NVARCHAR(MAX)
,@p_tact_time         NVARCHAR(MAX)
,@p_yield             NVARCHAR(MAX)
,@p_item_uom          NVARCHAR(MAX)
,@p_uom_convert_value NVARCHAR(MAX)
,@p_valid_yn          NVARCHAR(MAX)
,@p_created_by        NVARCHAR(MAX)
,@p_creation_date     NVARCHAR(MAX)
,@p_last_updated_by   NVARCHAR(MAX)
,@p_last_update_date  NVARCHAR(MAX)
,@p_lane_qty		  NVARCHAR(MAX)


AS

BEGIN

	--SET NOCOUNT ON;
	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_history_seq	nvarchar(100);
	


	
		BEGIN    
			SET @v_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_TACT_TIME_H
				
				                                      
			INSERT INTO dbo.SCP_MST_TACT_TIME_H        
						(HISTORY_SEQ                      
						,DIVISION_ID                      
						,PLANT_SITE_ID                    
						,ITEM_ID                          
						,OPERATION_ID                     
						,LINE_ID                          
						,PRIORITY                         
						,TACT_TIME                        
						,YIELD                
						,ITEM_UOM
						,UOM_CONVERT_VALUE
						,VALID_YN                         
						,CREATED_BY                       
						,CREATION_DATE                    
						,LAST_UPDATED_BY                  
						,LAST_UPDATE_DATE                 
						,HISTORY_CREATION_DATE
						,ATTRIBUTE1
						)           
					VALUES                                    
						(@v_history_seq            
						,@p_division_id            
						,@p_plant_site_id          
						,@p_item_id                
						,@p_operation_id           
						,@p_line_id                
						,@p_priority               
						,@p_tact_time              
						,@p_yield          
						,@p_item_uom
						,@p_uom_convert_value
						,@p_valid_yn               
						,@p_created_by             
						,@p_creation_date          
						,@p_last_updated_by        
						,@p_last_update_date       						
						,SYSDATETIME()  
						,@p_lane_qty
						);
		END

	
	END;





