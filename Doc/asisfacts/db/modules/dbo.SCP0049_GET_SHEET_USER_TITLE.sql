/****************************************************************************************************
* Program ID  : SCP0049_GET_SHEET_CALENDAR_TITILE                                                       
* Description : SCP0049 칼렌더 생성위한 프로시저                                                       
* Usage       : exec SCP0049_GET_SHEET_CALENDAR_TITILE													
* Parameter   : @p_today_yyyymmdd='201712'                                                     
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2020/05/20  khj79	      [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 기준정보
* ex)
* EXEC SCP0049_GET_SHEET_CALENDAR_TITLE @p_today_yyyymm ='20180122' , @p_program_id = 'SCP0049', @p_sheet_name = 'MDM' , @p_user_id = 'khj79'
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SCP0049_GET_SHEET_USER_TITLE]
	 @p_program_id		NVARCHAR(200)
	,@p_sheet_name		NVARCHAR(200)
	,@p_user_id			NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @v_user_col_cnt	INT = 0;

	SELECT @v_user_col_cnt = COUNT(*)
	  FROM [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	 WHERE 1 = 1
	   AND U.PROGRAM_ID = @p_program_id
	   AND U.SHEET_NAME = @p_sheet_name
	   AND U.USER_ID    = @p_user_id;

	--SET @v_user_col_cnt = 0;

	IF @v_user_col_cnt > 0
	BEGIN
		SELECT C.PROGRAM_ID
			 , C.SHEET_NAME
			 , C.COLUMN_NAME
			 , C.COLUMN_LABEL_NAME
			 --,  CASE WHEN C.ATTRIBUTE6 = 'N' AND U.SORT_ORDER_NO IS NULL THEN C.SORT_ORDER_NO + 10
				--	WHEN U.SORT_ORDER_NO IS NULL THEN 0 
				--	ELSE U.SORT_ORDER_NO 
				--END AS SORT_ORDER_NO
			 , C.SORT_ORDER_NO
			 , C.DATA_SORT_METHOD_CODE
			 , C.SMALL_CLASS_LABEL_NAME
			 , C.LARGE_CLASS_LABEL_NAME
			 , '' AS DAY_CODE
			 , C.FIXED_FLAG
			 , C.COLUMN_WIDTH
			 , C.CELL_CONTROL_OBJECT_TYPE_CODE
			 , C.CELL_COMBO_DATA_TYPE
			 , C.DATA_SCALE_NUMBER
			 , C.DATA_MAX_LENGTH
			 , C.HORIZONTAL_ALIGN_CODE
			 , C.UPPERCASE_APPLY_FLAG
			 , (CASE WHEN U.COLUMN_NAME IS NULL THEN 'N' ELSE C.VISIBLE_FLAG END ) AS VISIBLE_FLAG
			 , C.DEFAULT_FLAG
			 , C.USER_SELECTABLE_FLAG
			 , C.VALID_YN
			 , C.ATTRIBUTE1
			 , C.ATTRIBUTE2
			 , C.ATTRIBUTE3
			 , C.ATTRIBUTE4
			 , C.ATTRIBUTE5
		  FROM [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		  LEFT JOIN [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
		  ON 1=1
			AND U.PROGRAM_ID	= C.PROGRAM_ID
		   AND U.SHEET_NAME		= C.SHEET_NAME
		   AND U.COLUMN_NAME	= C.COLUMN_NAME
		   AND U.USER_ID		= @p_user_id
		   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		 WHERE 1 = 1
		   AND C.PROGRAM_ID		= @p_program_id
		   AND C.SHEET_NAME		= @p_sheet_name
		   AND C.VALID_YN		 = 'Y'
		--ORDER BY ISNULL(U.SORT_ORDER_NO , 0) , C.SORT_ORDER_NO
		ORDER BY SORT_ORDER_NO
	END -- END OF IF
	ELSE
	BEGIN
		SELECT C.PROGRAM_ID
			 , C.SHEET_NAME
			 , C.COLUMN_NAME
			 , C.COLUMN_LABEL_NAME
			 , C.SORT_ORDER_NO       
			 , C.DATA_SORT_METHOD_CODE
			 , C.SMALL_CLASS_LABEL_NAME
			 , C.LARGE_CLASS_LABEL_NAME
			 , ''						AS DAY_CODE
			 , C.FIXED_FLAG
			 , C.COLUMN_WIDTH
			 , C.CELL_CONTROL_OBJECT_TYPE_CODE
			 , C.CELL_COMBO_DATA_TYPE
			 , C.DATA_SCALE_NUMBER
			 , C.DATA_MAX_LENGTH
			 , C.HORIZONTAL_ALIGN_CODE
			 , C.UPPERCASE_APPLY_FLAG
			 , C.VISIBLE_FLAG
			 , C.DEFAULT_FLAG
			 , C.USER_SELECTABLE_FLAG
			 , C.VALID_YN
			 , C.ATTRIBUTE1
			 , C.ATTRIBUTE2
			 , C.ATTRIBUTE3
			 , C.ATTRIBUTE4
			 , C.ATTRIBUTE5
		  FROM [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		 WHERE 1 = 1    
		   AND C.PROGRAM_ID		= @p_program_id
		   AND C.SHEET_NAME		= @p_sheet_name
		   AND C.DEFAULT_FLAG	= 'Y'
		   AND C.VISIBLE_FLAG = 'Y'
		   AND C.VALID_YN		= 'Y'

		 UNION ALL

		SELECT C.PROGRAM_ID
			 , C.SHEET_NAME
			 , C.COLUMN_NAME
			 , C.COLUMN_LABEL_NAME
			 , C.SORT_ORDER_NO
			 , C.DATA_SORT_METHOD_CODE
			 , C.SMALL_CLASS_LABEL_NAME
			 , C.LARGE_CLASS_LABEL_NAME
			 , ''							AS DAY_CODE
			 , C.FIXED_FLAG
			 , C.COLUMN_WIDTH
			 , C.CELL_CONTROL_OBJECT_TYPE_CODE
			 , C.CELL_COMBO_DATA_TYPE
			 , C.DATA_SCALE_NUMBER
			 , C.DATA_MAX_LENGTH
		 	 , C.HORIZONTAL_ALIGN_CODE
			 , C.UPPERCASE_APPLY_FLAG
			 , C.VISIBLE_FLAG
			 , C.DEFAULT_FLAG
			 , C.USER_SELECTABLE_FLAG
			 , C.VALID_YN
			 , C.ATTRIBUTE1
			 , C.ATTRIBUTE2
			 , C.ATTRIBUTE3
			 , C.ATTRIBUTE4
			 , C.ATTRIBUTE5
		  FROM [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		 WHERE  1 = 1
		   AND C.PROGRAM_ID		= @p_program_id
		   AND C.SHEET_NAME		= @p_sheet_name
		   AND C.PROGRAM_ID		= @p_program_id
		   AND C.SHEET_NAME		= @p_sheet_name
		   AND C.VISIBLE_FLAG	= 'N'
		   AND    (C.DEFAULT_FLAG = '' or C.DEFAULT_FLAG is null or C.DEFAULT_FLAG = 'N')
		   AND C.VALID_YN		= 'Y'
			ORDER BY SORT_ORDER_NO
	END  -- END OF ELSE
END
