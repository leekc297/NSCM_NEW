
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




/****************************************************************************************************/
/* Program ID  : SSP0046_GET_SPREAD_TITLE                                                           */
/* Description : Shipment Reqeust 칼럼 해더 데이터                                                  */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/09/06  YJS          INIT 출하요청  */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[SSP0046_GET_SPREAD_TITLE]
    @p_start_dt             NVARCHAR(8),
    @p_end_dt               NVARCHAR(8),
    @p_created_by           NVARCHAR(50),
    @p_sheet_name           NVARCHAR(50),
    @p_division_id          NVARCHAR(20)
AS
BEGIN

    SET NOCOUNT ON;

	set @p_start_dt = CONVERT(CHAR(8), GETDATE(), 112)

    DECLARE @p_program_id      NVARCHAR(50)

    SET @p_program_id = 'SSP0046';
    --SET @p_sheet_name = 'Pack Biz';

    SELECT PROGRAM_ID -- C.PROGRAM_ID
         , C.SHEET_NAME
         , C.COLUMN_NAME
         , C.COLUMN_LABEL_NAME
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
         , C.VISIBLE_FLAG
         , C.DEFAULT_FLAG
         , C.USER_SELECTABLE_FLAG
         , C.VALID_YN
         , C.DIVISION_ID
      FROM SCM_MST_SHEET_COLUMNS C WITH(NOLOCK)
     WHERE 1 = 1
       AND C.PROGRAM_ID  = @p_program_id
       AND C.SHEET_NAME  = @p_sheet_name
       AND C.VALID_YN     = 'Y'
       AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )

    UNION ALL

    SELECT @p_program_id   AS PROGRAM_ID
         , @p_sheet_name AS SHEET_NAME
         , MA.COLUMN_NAME
         , MA.COLUMN_LABEL_NAME
         , MA.SORT_ORDER_NO
         , ''         AS DATA_SORT_METHOD_CODE
         , MA.SMALL_CLASS_LABEL_NAME
         , MA.LARGE_CLASS_LABEL_NAME
         , MA.DAY_CODE
         , ''         AS FIXED_FLAG
         , 70         AS COLUMN_WIDTH
         , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
         , ''         AS CELL_COMBO_DATA_TYPE
         , '0'         AS DATA_SCALE_NUMBER
         , '10'         AS DATA_MAX_LENGTH
         , 'R'        AS HORIZONTAL_ALIGN_CODE
         , ''        AS UPPERCASE_APPLY_FLAG
         , 'Y'        AS VISIBLE_FLAG
         , ''       AS DEFAULT_FLAG
         , ''         AS USER_SELECTABLE_FLAG
         , ''         AS VALID_YN
         , ''            AS DIVISION_ID
     FROM (SELECT 'D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
                , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
                , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                , A.DAYOFWEEK               AS DAY_CODE
                , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
             FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)
            WHERE A.BASIS_YYYYMMDD >= @p_start_dt 
              AND A.BASIS_YYYYMMDD <= @p_end_dt 
			UNION ALL
			SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
				, A.WEEK_NAME          AS COLUMN_LABEL_NAME   
				, A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
				, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
				, ''                   AS DAY_CODE
				, A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
			FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
			WHERE  A.BASIS_YYYYMMDD >= @p_start_dt --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
			AND    A.BASIS_YYYYMMDD <= @p_end_dt --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
			GROUP BY A.BASIS_YYYYMM
					, A.ISO_WEEK 
					, A.WEEK_NAME
					, A.MONTH_NAME        
					, A.BASIS_START_DATE					   
			UNION ALL
			SELECT 'M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
					, A.MONTH_NAME          AS COLUMN_LABEL_NAME
					, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
					, ''                    AS DAY_CODE
					, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
			FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
			WHERE  A.BASIS_YYYYMMDD >= @p_start_dt --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
			AND    A.BASIS_YYYYMMDD <= @p_end_dt --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
			GROUP BY A.BASIS_YYYYMM
					, A.MONTH_NAME						   
          ) MA
     ORDER BY SORT_ORDER_NO
END



