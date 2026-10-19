/*
 * Program ID   : PR_SCP_MST_FORMATION_EXCEPT_LT_HIST
 * Description  : FORMATION EXCEPT LT History 
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2025/09/22   KH 	            Initial Release  PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_FORMATION_EXCEPT_LT_HIST]
	  @p_division_id			NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_item_id			    NVARCHAR(MAX)
	, @p_formation_start_date	NVARCHAR(MAX)
	, @p_formation_end_date		NVARCHAR(MAX)
	, @p_lt_formation    		NVARCHAR(MAX)
    , @p_add_lt_formation    	NVARCHAR(MAX)
	, @p_except_comment			NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_creation_date			DATETIME
	, @p_attribute1				NVARCHAR(MAX)
	, @p_attribute2				NVARCHAR(MAX)
	, @p_attribute3				NVARCHAR(MAX)
	, @p_attribute4				NVARCHAR(MAX)
	, @p_attribute5				NVARCHAR(MAX)
	, @p_attribute6				NVARCHAR(MAX)
	, @p_attribute7				NVARCHAR(MAX)
	, @p_attribute8				NVARCHAR(MAX)
	, @p_attribute9				NVARCHAR(MAX)
	, @p_attribute10			NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
		BEGIN    
			SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_FORMATION_EXCEPT_H

			BEGIN
			INSERT	INTO  SCP_OPMZ_MST_FORMATION_EXCEPT_LT_H (
				 HISTORY_SEQ
				,DIVISION_ID
				,PLANT_SITE_ID
				,ITEM_ID
				,FORMATION_START_DATE
				,FORMATION_END_DATE
				,LT_FORMATION
				,ADD_LT_FORMATION
				,EXCEPT_COMMENT
				,ATTRIBUTE1
				,ATTRIBUTE2
				,ATTRIBUTE3
				,ATTRIBUTE4
				,ATTRIBUTE5
				,ATTRIBUTE6
				,ATTRIBUTE7
				,ATTRIBUTE8
				,ATTRIBUTE9
				,ATTRIBUTE10
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,HISTORY_CREATION_DATE

			)
			VALUES  (
				   @n_history_seq
				, @p_division_id		
				, @p_plant_site_id		
				, @p_item_id			   
				, @p_formation_start_date
				, @p_formation_end_date	
				, @p_lt_formation    	
				, @p_add_lt_formation    
				, @p_except_comment		
				, @p_attribute1			
				, @p_attribute2			
				, @p_attribute3			
				, @p_attribute4			
				, @p_attribute5			
				, @p_attribute6			
				, @p_attribute7			
				, @p_attribute8			
				, @p_attribute9			
				, @p_attribute10		
				, @p_created_by  
				, @p_creation_date 
				, @p_last_updated_by 
				, SYSDATETIME()  
				, SYSDATETIME() 
			);
			END
		END

	END;

