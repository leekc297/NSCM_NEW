CREATE FUNCTION [dbo].[fn_get_main_group_id]
(
	@P_SITE_ID			NVARCHAR(100),
	@P_ROUTE_ID			NVARCHAR(100),
	@P_OPERATION_ID		NVARCHAR(100),
	@P_ITEM_ID			NVARCHAR(100),
	@P_RESOURCE_MAP_ID	NVARCHAR(100)
)
RETURNS NVARCHAR(100)
AS
/**********************************************************************************************/
/** 프로그램 ID   	: FN_GET_MAIN_GROUP_ID                                      				**/
/** 프로그램 명   	: FN_GET_MAIN_GROUP_ID 		                             		   		**/
/** 설       명	 	: 																		**/
/** VERSION			:	V1.0.0									        					**/
/** ARGUMENT   		:										        						**/
/** LOGIC    		:										        			     		**/
/**------------------------------------------------------------------------------------------**/
/** 작 성 일 자		작 성 자			사	   유											**/
/**==========================================================================================**/
/** 2016.06.03		COCHO			CONNECT_BY_ROOT RESOURCE_ID 가져오기 위한 함수 생성	      */
/**********************************************************************************************/
/*
	SELECT DBO.FN_GET_MAIN_GROUP_ID('MASITE-01','MAIN-ASSY','MAIN-ASSY','MA001SA001SM001','MALINE_002_JIG') 
*/
BEGIN
	DECLARE	@V_RESOURCE_MAP_ID			NVARCHAR(100)
	DECLARE @V_RESOURCE_MAP_LEVEL		INT = 10
	DECLARE @V_TMP_CNT					INT = 1

	DECLARE	@MAIN_GROUP_ID				NVARCHAR(100)


  	WHILE (@V_RESOURCE_MAP_LEVEL > 1)
  	BEGIN
		SELECT 
			@V_RESOURCE_MAP_ID		= A.RESOURCE_MAP_ID,  
			@V_RESOURCE_MAP_LEVEL	= A.RESOURCE_MAP_LEVEL,
			@MAIN_GROUP_ID			=	A.RESOURCE_GROUP_ID
		FROM TH_ENG_OP_RES_GROUP_MAP A
		WHERE 1=1
		AND A.SITE_ID				=	@P_SITE_ID
		AND A.ROUTE_ID				=	@P_ROUTE_ID
		AND A.OPERATION_ID			=	@P_OPERATION_ID
		AND A.ITEM_ID				=	@P_ITEM_ID
		AND A.SUB_RESOURCE_MAP_ID	=	(CASE WHEN @V_TMP_CNT=1 THEN @P_RESOURCE_MAP_ID ELSE @V_RESOURCE_MAP_ID END)

		SET @V_TMP_CNT = @V_TMP_CNT + 1

		IF @V_RESOURCE_MAP_LEVEL < 2 OR @MAIN_GROUP_ID IS NULL
		BEGIN
			RETURN @MAIN_GROUP_ID
		END
  	END

	RETURN @MAIN_GROUP_ID
END
