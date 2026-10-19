
/*
 * Program ID   : SCP0087_GET_MDM_CLASS_MASTER
 * Description  : SCM_MST_ITEM_CLASS_M 조회 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/11/08   kmj				Initial Release - [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 */

CREATE PROCEDURE [dbo].[SCP0087_GET_MDM_CLASS_MASTER]
	@p_class_id				NVARCHAR(50),
	@p_class_name			NVARCHAR(50),
	@p_use_flag				NVARCHAR(1),
	@debug_mode				NVARCHAR(1) = 'T'

AS
BEGIN
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

		-- INSERT
		INSERT INTO  SCM_MST_ITEM_CLASS_M
		       ( CLASS_ID
				,CLASS_NAME
				,ITEM_TYPE
				,PROCESS_GROUP
				,PROCESS_DETAIL
				,LEVEL
				,LEVEL_1_CODE
				,LEVEL_1_NAME
				,LEVEL_1_ID
				,LEVEL_2_CODE
				,LEVEL_2_NAME
				,LEVEL_2_ID
				,LEVEL_3_CODE
				,LEVEL_3_NAME
				,LEVEL_3_ID
				,LEVEL_4_CODE
				,LEVEL_4_NAME
				,LEVEL_4_ID
				,USE_FLAG
				,INSERT_ID
				,INSERT_TIME
				,UPDATE_ID
				,UPDATE_TIME
				,MODEL_ATTRIBUTE
				,MODEL_ATTRIBUTE_SEQ
				,SKIP_ROUTE_FLAG
				,DEFAULT_OPERATION_ID
				,SCP_FLOW_ID
				,SCP_OPERATION_GROUP
				,SCP_OPERATION_GROUP_ID
				,LEVEL_5_CODE
				,LEVEL_5_NAME
				,LEVEL_5_ID
				,LEVEL_6_CODE
				,LEVEL_6_NAME
				,LEVEL_6_ID)
		SELECT  CLASS_ID
				,CLASS_NAME
				,NULL AS ITEM_TYPE
				,NULL AS PROCESS_GROUP
				,NULL AS PROCESS_DETAIL
				,LEVEL
				,LEVEL_1_CODE
				,LEVEL_1_NAME
				,LEVEL_1_ID
				,LEVEL_2_CODE
				,LEVEL_2_NAME
				,LEVEL_2_ID
				,LEVEL_3_CODE
				,LEVEL_3_NAME
				,LEVEL_3_ID
				,LEVEL_4_CODE
				,LEVEL_4_NAME
				,LEVEL_4_ID
				,USE_FLAG
				,INSERT_ID
				,INSERT_TIME
				,UPDATE_ID
				,UPDATE_TIME
				,MODEL_ATTRIBUTE
				,MODEL_ATTRIBUTE_SEQ
				,SKIP_ROUTE_FLAG
				,DEFAULT_OPERATION_ID
				,SCP_FLOW_ID
				,SCP_OPERATION_GROUP
				,SCP_OPERATION_GROUP_ID
				,LEVEL_5_CODE
				,LEVEL_5_NAME
				,LEVEL_5_ID
				,LEVEL_6_CODE
				,LEVEL_6_NAME
				,LEVEL_6_ID
		 FROM  SCM_MST_ITEM_CLASS_SN M WITH(NOLOCK)
		WHERE  NOT EXISTS(
				SELECT CLASS_ID FROM SCM_MST_ITEM_CLASS_M S WITH(NOLOCK)
				WHERE S.CLASS_ID = M.CLASS_ID
		)
		;

		-- 조회
		SELECT  
			CLASS_ID
			, CLASS_NAME
			, ITEM_TYPE
			, PROCESS_GROUP
			, PROCESS_DETAIL
			, LEVEL
			, LEVEL_1_CODE
			, LEVEL_1_NAME
			, LEVEL_1_ID
			, LEVEL_2_CODE
			, LEVEL_2_NAME
			, LEVEL_2_ID
			, LEVEL_3_CODE
			, LEVEL_3_NAME
			, LEVEL_3_ID
			, LEVEL_4_CODE
			, LEVEL_4_NAME
			, LEVEL_4_ID
			, USE_FLAG
			, INSERT_ID
			, INSERT_TIME
			, UPDATE_ID
			, UPDATE_TIME
		FROM  SCM_MST_ITEM_CLASS_M A WITH(NOLOCK)
		WHERE 1=1
		AND ((@p_class_id	IS NULL OR @p_class_id		= '') OR A.CLASS_ID		LIKE N'%'+@p_class_id+'%')
		AND ((@p_class_name IS NULL OR @p_class_name	= '') OR A.CLASS_NAME	LIKE N'%'+@p_class_name+'%')
		AND ((@p_use_flag	IS NULL OR @p_use_flag		= '') OR A.USE_FLAG		= @p_use_flag)
		;
END
