
/*
 * Program ID   : SCM0002_GET_TITLESET_POPUP
 * Description  : Column Setting, Measure Setting
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.21   정병훈         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.31		JYE			DIVISION_ID 별로 칼럼 해더 리턴
 */

CREATE PROCEDURE [dbo].[DMF0002_GET_TITLESET_POPUP]
  @p_program_id   NVARCHAR(Max),
  @p_sheet_name   NVARCHAR(Max),
  @p_column_type  NVARCHAR(Max),
  @p_user_id  NVARCHAR(Max),
  @p_division_id NVARCHAR(Max)		-- 20180604 소형 추가
AS
BEGIN
	-- SET NOCOUNT ON;
	EXEC [dbo].[SCM0002_SET_DEFAULT_TITLESET_POPUP] @p_program_id , @p_sheet_name, @p_column_type, @p_user_id
	
	IF (@p_division_id = '')	-- 20180604 소형. 분기 추가
		BEGIN



    IF @p_column_type = 'C' -- Column
	    BEGIN
			SELECT b.program_id
				 , b.sheet_name
				 , b.column_name
				 , b.column_label_name
				 , b.small_class_label_name
				 , b.large_class_label_name
				 , b.data_sort_method_code
                 , b.column_width
                 , b.sort_order_no
				 , u.sub_total_flag
				 , dbo.fn_scm_sys_nvl(dbo.fn_scm_sys_nvl(u.data_sort_method_code, b.data_sort_method_code), 'ASC') AS user_sort_method_code
				 , u.sort_order_no AS user_sort_order_no
				 ,  (CASE ISNULL(u.column_name,'@@')
					 WHEN '@@' THEN'N'
					 ELSE 'Y'
					 END)              user_flag
				 , dbo.FN_SCM_SYS_NVL(b.default_flag, 'N') AS default_flag
				 , dbo.FN_SCM_SYS_NVL(b.user_selectable_flag, 'Y') AS user_selectable_flag
				 ,'N' AS total_use_flag  
			 FROM scm_mst_sheet_columns b  WITH(NOLOCK)
			 LEFT OUTER JOIN scm_mst_titleset_user u  WITH(NOLOCK) ON u.program_id = b.program_id AND u.sheet_name = b.sheet_name AND u.column_name = b.column_name AND u.user_id = @p_user_id
		    WHERE   b.program_id             = @p_program_id
			  AND   b.sheet_name             = @p_sheet_name			  
			  AND   b.valid_yn				 = 'Y'
			  AND   b.visible_flag           = 'Y'
			 
			ORDER BY b.sort_order_no;
		END;
    ELSE   -- Measure
	    BEGIN
			SELECT b.program_id
				 , b.sheet_name
				 , b.column_name				 
				 , b.column_label_name       
				 , b.small_class_label_name
				 , b.large_class_label_name    
				 , u.data_sort_method_code 
				 , b.sort_order_no
				 , NULL AS sub_total_flag
				 , NULL AS user_sort_method_code
				 , u.sort_order_no AS user_sort_order_no
				 --, 'Y'                            user_selectable_flag
				 , b.USER_SELECTABLE_FLAG
				 ,  (CASE ISNULL(u.column_name,'@@')
					WHEN '@@' THEN'N'
					ELSE 'Y'
					END)                user_flag
				 , [dbo].[FN_SCM_SYS_NVL](b.default_flag, 'N')       default_flag
				 , 'N' AS total_use_flag
			 FROM  scm_mst_sheet_measure b  WITH(NOLOCK)
			 LEFT OUTER JOIN  scm_mst_titleset_user u  WITH(NOLOCK) ON u.program_id = b.program_id AND u.sheet_name = b.sheet_name AND u.column_name = b.column_name AND u.user_id = @p_user_id
		    WHERE   b.program_id             = @p_program_id
			  AND   b.sheet_name             = @p_sheet_name
			  AND   b.valid_yn				 = 'Y'

			ORDER BY b.sort_order_no;
       END;


		END
	ELSE	-- 20180604 소형. ESLE 내용 추가
		BEGIN

			IF @p_column_type = 'C' -- Column
			BEGIN

					SELECT b.program_id
						 , b.sheet_name
						 , b.column_name
						 , b.column_label_name
						 , b.small_class_label_name
						 , b.large_class_label_name
						 , b.data_sort_method_code
						 , b.column_width
						 , b.sort_order_no
						 , u.sub_total_flag
						 , dbo.fn_scm_sys_nvl(dbo.fn_scm_sys_nvl(u.data_sort_method_code, b.data_sort_method_code), 'ASC') AS user_sort_method_code
						 , u.sort_order_no AS user_sort_order_no
						 ,  (CASE ISNULL(u.column_name,'@@')
							 WHEN '@@' THEN'N'
							 ELSE 'Y'
							 END)              user_flag
						 , dbo.FN_SCM_SYS_NVL(b.default_flag, 'N') AS default_flag
						 , dbo.FN_SCM_SYS_NVL(b.user_selectable_flag, 'Y') AS user_selectable_flag
						 ,'N' AS total_use_flag  
					 FROM scm_mst_sheet_columns b  WITH(NOLOCK)
					 LEFT OUTER JOIN scm_mst_titleset_user u  WITH(NOLOCK) ON u.program_id = b.program_id AND u.sheet_name = b.sheet_name AND u.column_name = b.column_name AND u.user_id = @p_user_id
					WHERE   b.program_id             = @p_program_id
					  AND   b.sheet_name             = @p_sheet_name			  
					  AND   b.valid_yn				 = 'Y'
					  AND   b.visible_flag           = 'Y'
					  AND @p_division_id IN (SELECT token FROM dbo.String_Split(b.DIVISION_ID ,',') )		-- 20180604 division 추가
					ORDER BY b.sort_order_no;
			END;
		ELSE   -- Measure
			BEGIN
				SELECT b.program_id
					 , b.sheet_name
					 , b.column_name				 
					 , b.column_label_name       
					 , b.small_class_label_name
					 , b.large_class_label_name    
					 , u.data_sort_method_code 
					 , b.sort_order_no
					 , NULL AS sub_total_flag
					 , NULL AS user_sort_method_code
					 , u.sort_order_no AS user_sort_order_no
					 --, 'Y'                            user_selectable_flag
					 , b.USER_SELECTABLE_FLAG
					 ,  (CASE ISNULL(u.column_name,'@@')
						WHEN '@@' THEN'N'
						ELSE 'Y'
						END)                user_flag
					 , [dbo].[FN_SCM_SYS_NVL](b.default_flag, 'N')       default_flag
					 , 'N' AS total_use_flag
				 FROM  scm_mst_sheet_measure b  WITH(NOLOCK)
				 LEFT OUTER JOIN  scm_mst_titleset_user u  WITH(NOLOCK) ON u.program_id = b.program_id AND u.sheet_name = b.sheet_name AND u.column_name = b.column_name AND u.user_id = @p_user_id
				WHERE   b.program_id             = @p_program_id
				  AND   b.sheet_name             = @p_sheet_name
				  AND   b.valid_yn				 = 'Y'
				  AND @p_division_id IN (SELECT token FROM dbo.String_Split(b.DIVISION_ID ,',') )		-- 20180604 division 추가
				ORDER BY b.sort_order_no;
		   END;
			 
		END;

END

-- USE [LGCE_SCMDEV]
