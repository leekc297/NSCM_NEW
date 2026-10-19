
/*
 * Program ID   : SCM0002_SET_DEFAULT_TITLESET_POPUP
 * Description  : Column Setting, Measure Setting
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.21   정병훈         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.19	윤혜원		   유저컬럼 조회 조건 수정
 *
 */

CREATE PROCEDURE [dbo].[SCM0002_SET_DEFAULT_TITLESET_POPUP]
  @p_program_id   NVARCHAR(Max),
  @p_sheet_name   NVARCHAR(Max),
  @p_column_type  NVARCHAR(Max),
  @p_user_id	  NVARCHAR(Max)
AS
BEGIN
	SET NOCOUNT ON;

    IF @p_column_type = 'C'
	    BEGIN
         -- Column
        INSERT INTO scm_mst_titleset_user
              ( user_id    , program_id   , sheet_name           , user_inquiry_column_type_code
              , column_name, sort_order_no, data_sort_method_code
              , created_by, creation_date, last_updated_by, last_update_date)

        SELECT @p_user_id    , b.program_id   , b.sheet_name           , @p_column_type
             , b.column_name, RANK() OVER (ORDER BY b.sort_order_no)  , [dbo].[FN_SCM_SYS_NVL](b.data_sort_method_code,'ASC')
             , @p_user_id, sysdatetime(), @p_user_id, sysdatetime()
        FROM   scm_mst_sheet_columns b  WITH(NOLOCK)
        WHERE  b.program_id           = @p_program_id
        AND    b.sheet_name           = [dbo].[FN_SCM_SYS_NVL](@p_sheet_name, b.sheet_name)
        AND    b.valid_yn          = 'Y'
        --AND    b.user_selectable_flag = 'Y'
        AND    b.default_flag         = 'Y'
		AND	   ISNULL(b.ATTRIBUTE6,'Y')<>'N'
        AND    NOT EXISTS (SELECT 1 FROM scm_mst_titleset_user u
                           WHERE  u.user_id          = @p_user_id
                           AND    u.program_id       = b.program_id
                           AND    u.sheet_name       = b.sheet_name
                           AND    u.user_inquiry_column_type_code = @p_column_type)
		END;
    ELSE
	    BEGIN
        -- Measure
        INSERT INTO scm_mst_titleset_user
              ( user_id    , program_id   , sheet_name           , user_inquiry_column_type_code
              , column_name, sort_order_no, data_sort_method_code
              , created_by, creation_date, last_updated_by, last_update_date)

        SELECT @p_user_id    , b.program_id   , b.sheet_name, @p_column_type
             , b.column_name, b.sort_order_no, NULL
             , @p_user_id, sysdatetime(), @p_user_id, sysdatetime()
        FROM   scm_mst_sheet_measure b  WITH(NOLOCK)
        WHERE  b.program_id           = @p_program_id
        AND    b.sheet_name           = [dbo].[FN_SCM_SYS_NVL](@p_sheet_name, b.sheet_name)
        AND    b.default_flag         = 'Y'
        AND    NOT EXISTS (SELECT 1 FROM scm_mst_titleset_user u
                           WHERE  u.user_id          = @p_user_id
                           AND    u.program_id       = b.program_id
                           AND    u.sheet_name       = b.sheet_name
                           AND    u.user_inquiry_column_type_code = @p_column_type)
       END;
END
