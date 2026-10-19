
/*
 * Program ID   : PR_SCM_MST_ALTER_BOM_H
 * Description  : Tac TIme Master History 
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2021.03.19   PJG                 Initial Release  (PJ20209642 Digital SCM Level.3 달성을 위한 개선)
 * 2022-07-25   jahn1501            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 변경된 SCPYN 다건 조회 / Plant Id 조건 제외.
 * 2022-10-25   jahn1501   		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - p_si_alt_priority, p_si_scp_yn, ATTRIBUTE11 ~ 20 추가
 * 2025-08-14   twinlove        PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - OPT YN추가
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCM_MST_ALTER_BOM_H_BACK_20251119]
 @p_division_id       NVARCHAR(MAX)
,@p_plant_cd          NVARCHAR(MAX)
,@p_model_id          NVARCHAR(MAX)
,@p_parent_item_id    NVARCHAR(MAX)
,@p_child_item_id     NVARCHAR(MAX)
,@p_alt_id            NVARCHAR(MAX)
,@p_eff_start_date    NVARCHAR(MAX)
,@p_eff_end_date      NVARCHAR(MAX)
,@p_eco_code          NVARCHAR(MAX)
,@p_scp_yn            NVARCHAR(MAX)
,@p_si_alt_priority	  NVARCHAR(MAX)
,@p_si_scp_yn         NVARCHAR(MAX)
,@p_opt_yn			  NVARCHAR(MAX)  -- PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
,@p_creation_date     NVARCHAR(MAX)
,@p_last_updated_by   NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_history_seq	nvarchar(100);
		BEGIN    
			SET @v_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_ALTER_BOM_H
				                                      
			INSERT INTO dbo.SCM_MST_ALTER_BOM_H
						(HISTORY_SEQ                      
						,DIVISION_ID                      
						,PLANT_ID                 
						,PARENT_ITEM_ID     
						,CHILD_ITEM_ID
						,ALT_ID 
						,EFF_START_DATE
						,EFF_END_DATE
						,ECO_CODE                
						,SCP_PLAN_YN
						,CREATION_DATE
						,LAST_UPDATED_BY
						,CREATION_BY
						,SITE_ID
						,BOM_VERSION_ID
						,KEY_DATE
						,PARENT_QTY
						,PARENT_UOM
						,CHILD_QTY
						,CHILD_UOM
						,ALT_PRIORITY
						,ALT_RATE
						,COMMON_CELL_YN
						,CHILD_ITEM_TYPE
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
						,ATTRIBUTE11
						,ATTRIBUTE12
						,ATTRIBUTE13
						,ATTRIBUTE14
						,ATTRIBUTE15
						,ATTRIBUTE16
						,ATTRIBUTE17
						,ATTRIBUTE18
						,ATTRIBUTE19
						,ATTRIBUTE20						
						,OLD_SCP_PLAN_YN
						)           
			SELECT @v_history_seq
				   ,@p_division_id
				   ,@p_plant_cd
				   ,@p_parent_item_id
				   ,@p_child_item_id
				   ,@p_alt_id
				   ,CASE WHEN (@p_eff_start_date IS NULL OR @p_eff_start_date = '') THEN '' ELSE @p_eff_start_date END  
				   ,CASE WHEN (@p_eff_end_date IS NULL OR @p_eff_end_date = '') THEN '' ELSE @p_eff_end_date END  
				   ,@p_eco_code
				   ,@p_scp_yn
				   ,@p_creation_date
				   ,@p_last_updated_by
				   ,CREATION_BY
				   ,SITE_ID
				   ,BOM_VERSION_ID
				   ,KEY_DATE
				   ,PARENT_QTY
				   ,PARENT_UOM
				   ,CHILD_QTY
				   ,CHILD_UOM
				   ,ALT_PRIORITY
				   ,ALT_RATE
				   ,COMMON_CELL_YN
				   ,CHILD_ITEM_TYPE 
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
				   ,@p_si_alt_priority
				   ,@p_si_scp_yn
				   ,@p_opt_yn            -- PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
				   ,ATTRIBUTE14
				   ,ATTRIBUTE15
				   ,ATTRIBUTE16
				   ,ATTRIBUTE17
				   ,ATTRIBUTE18
				   ,ATTRIBUTE19
				   ,ATTRIBUTE20
				   ,SCP_PLAN_YN
				   FROM SCM_MST_ALTER_BOM
				   WHERE DIVISION_ID      = @p_division_id
				   --AND PLANT_ID         = @p_plant_cd
				   AND PARENT_ITEM_ID   = @p_parent_item_id
				   AND CHILD_ITEM_ID    = @p_child_item_id						 
			;
		END
	END;

