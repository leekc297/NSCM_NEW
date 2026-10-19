/****************************************************************************************************/  
/* Program ID  : DMF0020_GET_SPREAD_TITLE                                                             */  
/* Description : Procedure 작성 가이드                                                              */  
/* Usage       : Procedure 작성 시 참조하세요!                                                      */  
/* Parameter   :                                                                                    */  
/*                                                                                                  */  
/*--------------------------------------------------------------------------------------------------*/  
/* Date        In Charge    Description                                                             */  
/*--------------------------------------------------------------------------------------------------*/  
/* 2021/03/04  kuniid         [C20210127-000163] GSCM Sales Price 일괄입력 기능 개선 요청 */
/****************************************************************************************************/  
create PROCEDURE [dbo].[DMF0020_GET_SPREAD_TITLE_SAVE_PRICE]  
 @p_start_dt  NVARCHAR(8),  
    @p_end_dt    NVARCHAR(8),  
 @p_created_by   NVARCHAR(50),  
 @p_division_id   NVARCHAR(50)  
AS  
BEGIN  
   
    SET NOCOUNT ON;    
  
 DECLARE  @p_program_id   NVARCHAR(50)='DMF0020'  
 DECLARE  @p_sheet_name   NVARCHAR(50)='Sales Price Save All'  
  
 DECLARE @i_Count int=0;  
  
 -- 1. 등록여부  
    SELECT  @i_Count = Count(*)  
    FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)  
    --     , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)  
    WHERE  1 = 1  
    --AND    U.PROGRAM_ID  = C.PROGRAM_ID  
    --AND    U.SHEET_NAME  = C.SHEET_NAME  
    --AND    U.COLUMN_NAME = C.COLUMN_NAME  
    AND    U.PROGRAM_ID  = @p_program_id  
    AND    U.SHEET_NAME  = @p_sheet_name    
    AND    U.USER_ID     = @p_created_by  
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'  
  
 -- 2.   
 --IF @i_Count = 0   
 BEGIN  
  -- 일반 데이터 칼럼  
  SELECT  
     C.PROGRAM_ID  
         , C.SHEET_NAME  
         , C.COLUMN_NAME  
         , C.COLUMN_LABEL_NAME  
         , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO  
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
   --, CASE C.VALID_YN  WHEN 'Y' THEN -- 20180607 추가  
   --  CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END  
   -- ELSE C.VALID_YN END VALID_YN  
   , 0 AS SEQ  
   --INTO #tmpTitleO  
   FROM [SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)  
   WHERE 1 = 1  
    AND    C.PROGRAM_ID  = @p_program_id  
    AND    C.SHEET_NAME  = @p_sheet_name  
    AND    ( C.DEFAULT_FLAG = 'Y' OR   
     (    C.VISIBLE_FLAG = 'N'  
     AND    C.DEFAULT_FLAG = ''  
     AND    C.VALID_YN     = 'Y'  
     )  
     )    
    AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )  -- 20180604 division 추가  
  -- 날짜 데이터 칼럼  
  UNION ALL  
  SELECT   
   @p_program_id   AS PROGRAM_ID  
   , @p_sheet_name AS SHEET_NAME  
   , MA.COLUMN_NAME  
   , MA.COLUMN_LABEL_NAME  
   , MA.SORT_ORDER_NO  
   , ''         AS DATA_SORT_METHOD_CODE  
   , MA.SMALL_CLASS_LABEL_NAME  
   , MA.LARGE_CLASS_LABEL_NAME  
   , MA.DAY_CODE  
   , ''         AS FIXED_FLAG  
   , 120         AS COLUMN_WIDTH  
   , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE  
   , ''         AS CELL_COMBO_DATA_TYPE  
   --, '2'         AS DATA_SCALE_NUMBER  
   , '3'         AS DATA_SCALE_NUMBER -- 20181029  
   , ''         AS DATA_MAX_LENGTH  
   , 'R'        AS HORIZONTAL_ALIGN_CODE  
   , 'Y'        AS UPPERCASE_APPLY_FLAG  
   , 'Y'        AS VISIBLE_FLAG  
   , ''         AS DEFAULT_FLAG  
   , ''         AS USER_SELECTABLE_FLAG  
   , ''         AS VALID_YN  
   , ''   AS DIVISION_ID  
  FROM  (  
   SELECT   
    'W_' + MIN(BASIS_START_DATE)    AS COLUMN_NAME  
    , SUBSTRING(BASIS_START_DATE, 5, 4)  AS COLUMN_LABEL_NAME   
    , WEEK_NAME          AS SMALL_CLASS_LABEL_NAME  
    , MONTH_NAME         AS LARGE_CLASS_LABEL_NAME  
    , ''             AS DAY_CODE  
    , MIN(BASIS_START_DATE)      AS SORT_ORDER_NO  
    , 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE  
   FROM [dbo].[SCM_SYS_CALENDAR_M]  
   WHERE  BASIS_YYYYMMDD >= @p_start_dt  
    AND    BASIS_YYYYMMDD <= @p_end_dt  
   GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTRING(BASIS_START_DATE, 5, 4), MONTH_NAME  
  
   UNION ALL  
   
   SELECT   
    'M_' + MIN(BASIS_START_DATE)    AS COLUMN_NAME  
    , SUBSTRING(BASIS_START_DATE, 5, 4)  AS COLUMN_LABEL_NAME   
    , WEEK_NAME          AS SMALL_CLASS_LABEL_NAME  
    , MONTH_NAME         AS LARGE_CLASS_LABEL_NAME  
    , ''             AS DAY_CODE  
    , MIN(BASIS_START_DATE)      AS SORT_ORDER_NO  
    , 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE  
   FROM [dbo].[SCM_SYS_CALENDAR_M]  
   WHERE  BASIS_YYYYMMDD >= @p_start_dt  
    AND BASIS_YYYYMMDD <= @p_end_dt  
    AND CALENDAR_DAY = '01'  
   GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTRING(BASIS_START_DATE, 5, 4), MONTH_NAME  
   
  ) MA  
  ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME  
  
--  ORDER BY SEQ, SORT_ORDER_NO   
  
 END  
 --ELSE --IF @i_Count <> 0   
 --BEGIN  
 -- -- 일반 데이터 칼럼  
 -- SELECT U.PROGRAM_ID  
 --   , U.SHEET_NAME  
 --   , U.COLUMN_NAME  
 --   , C.COLUMN_LABEL_NAME  
 --   , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO  
 --   , U.DATA_SORT_METHOD_CODE  
 --   , C.SMALL_CLASS_LABEL_NAME  
 --   , C.LARGE_CLASS_LABEL_NAME  
 --   , '' AS DAY_CODE  
 --   , C.FIXED_FLAG  
 --   , C.COLUMN_WIDTH  
 --   , C.CELL_CONTROL_OBJECT_TYPE_CODE  
 --   , C.CELL_COMBO_DATA_TYPE  
 --   , C.DATA_SCALE_NUMBER  
 --   , C.DATA_MAX_LENGTH  
 --   , C.HORIZONTAL_ALIGN_CODE  
 --   , C.UPPERCASE_APPLY_FLAG  
 --   , C.VISIBLE_FLAG  
 --   , C.DEFAULT_FLAG  
 --   , C.USER_SELECTABLE_FLAG  
 --   --, C.VALID_YN  
 --   , CASE C.VALID_YN  WHEN 'Y' THEN -- 20180607 추가  
 --    CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END  
 --   ELSE C.VALID_YN END VALID_YN  
 --   , 1 AS SEQ  
 -- FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)  
 --   , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)  
 -- WHERE  1 = 1  
 -- AND    U.PROGRAM_ID  = C.PROGRAM_ID  
 -- AND    U.SHEET_NAME  = C.SHEET_NAME  
 -- AND    U.COLUMN_NAME = C.COLUMN_NAME  
 -- AND    U.PROGRAM_ID  = @p_program_id  
 -- AND    U.SHEET_NAME  = @p_sheet_name  
 -- AND    U.USER_ID     = @p_created_by  
 -- AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'      
 -- AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )  -- 20180604 division 추가  
 -- UNION ALL  
 -- SELECT C.PROGRAM_ID  
 --   , C.SHEET_NAME  
 --   , C.COLUMN_NAME  
 --   , C.COLUMN_LABEL_NAME  
 --   , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO  
 --   , C.DATA_SORT_METHOD_CODE  
 --   , C.SMALL_CLASS_LABEL_NAME  
 --   , C.LARGE_CLASS_LABEL_NAME  
 --   , '' AS DAY_CODE  
 --   , C.FIXED_FLAG  
 --   , C.COLUMN_WIDTH  
 --   , C.CELL_CONTROL_OBJECT_TYPE_CODE  
 --   , C.CELL_COMBO_DATA_TYPE  
 --   , C.DATA_SCALE_NUMBER  
 --   , C.DATA_MAX_LENGTH  
 --   , C.HORIZONTAL_ALIGN_CODE  
 --   , C.UPPERCASE_APPLY_FLAG  
 --   , C.VISIBLE_FLAG  
 --   , C.DEFAULT_FLAG  
 --   , C.USER_SELECTABLE_FLAG  
 --   , C.VALID_YN  
 --   , 2 AS SEQ  
 -- FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)  
 -- WHERE  1 = 1      
 -- AND    C.PROGRAM_ID  = @p_program_id  
 -- AND    C.SHEET_NAME  = @p_sheet_name  
 -- AND    C.VISIBLE_FLAG = 'N'  
 -- AND    C.DEFAULT_FLAG = ''  
 -- AND    C.VALID_YN     = 'Y'  
 -- AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )  -- 20180604 division 추가  
 -- --ORDER BY SEQ, SORT_ORDER_NO     
 -- -- 날짜 데이터 칼럼  
 -- UNION ALL  
 -- SELECT   
 --  @p_program_id   AS PROGRAM_ID  
 --  , @p_sheet_name AS SHEET_NAME  
 --  , MA.COLUMN_NAME  
 --  , MA.COLUMN_LABEL_NAME  
 --  , MA.SORT_ORDER_NO  
 --  , ''         AS DATA_SORT_METHOD_CODE  
 --  , MA.SMALL_CLASS_LABEL_NAME  
 --  , MA.LARGE_CLASS_LABEL_NAME  
 --  , MA.DAY_CODE  
 --  , ''         AS FIXED_FLAG  
 --  , 120         AS COLUMN_WIDTH  
 --  , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE  
 --  , ''         AS CELL_COMBO_DATA_TYPE  
 --  --, '2'         AS DATA_SCALE_NUMBER  
 --  , '3'         AS DATA_SCALE_NUMBER -- 20181029  
 --  , ''         AS DATA_MAX_LENGTH  
 --  , 'R'        AS HORIZONTAL_ALIGN_CODE  
 --  , 'Y'        AS UPPERCASE_APPLY_FLAG  
 --  , 'Y'        AS VISIBLE_FLAG  
 --  , ''         AS DEFAULT_FLAG  
 --  , ''         AS USER_SELECTABLE_FLAG  
 --  , ''         AS VALID_YN  
 --  , ''   AS DIVISION_ID  
 -- FROM  (  
 --  SELECT   
 --   'W_' + MIN(BASIS_START_DATE)    AS COLUMN_NAME  
 --   , SUBSTRING(BASIS_START_DATE, 5, 4)  AS COLUMN_LABEL_NAME   
 --   , WEEK_NAME          AS SMALL_CLASS_LABEL_NAME  
 --   , MONTH_NAME         AS LARGE_CLASS_LABEL_NAME  
 --   , ''             AS DAY_CODE  
 --   , MIN(BASIS_START_DATE)      AS SORT_ORDER_NO  
 --   , 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE  
 --  FROM [dbo].[SCM_SYS_CALENDAR_M]  
 --  WHERE  BASIS_YYYYMMDD >= @p_start_dt  
 --   AND    BASIS_YYYYMMDD <= @p_end_dt  
 --  GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTRING(BASIS_START_DATE, 5, 4), MONTH_NAME  
  
 --  UNION ALL  
   
 --  SELECT   
 --   'M_' + MIN(BASIS_START_DATE)    AS COLUMN_NAME  
 --   , SUBSTRING(BASIS_START_DATE, 5, 4)  AS COLUMN_LABEL_NAME   
 --   , WEEK_NAME          AS SMALL_CLASS_LABEL_NAME  
 --   , MONTH_NAME         AS LARGE_CLASS_LABEL_NAME  
 --   , ''             AS DAY_CODE  
 --   , MIN(BASIS_START_DATE)      AS SORT_ORDER_NO  
 --   , 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE  
 --  FROM [dbo].[SCM_SYS_CALENDAR_M]  
 --  WHERE  BASIS_YYYYMMDD >= @p_start_dt  
 --   AND BASIS_YYYYMMDD <= @p_end_dt  
 --   AND CALENDAR_DAY = '01'  
 --  GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTRING(BASIS_START_DATE, 5, 4), MONTH_NAME  
   
 -- ) MA  
 -- ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME  
 --END  
  
END  
  
