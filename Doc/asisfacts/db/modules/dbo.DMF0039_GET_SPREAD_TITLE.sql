/****************************************************************************************************/
/* Program ID  : DMF0039_GET_SPREAD_TITLE                                                             */
/* Description :  ESS_SHIPMENT_PRIORITY 칼럼 해더 데이터                                                             */
/* Usage       :   exec DMF0039_GET_SPREAD_TITLE '82','greenzun','20181201','20190531'*/
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/12/03  JYE           ESS_SHIPMENT_PRIORITY  칼럼 해더 데이터  */
/* 2019/09/18  JYE           주단위로 변경   */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0039_GET_SPREAD_TITLE]
 @p_division_id   NVARCHAR(20),
 @p_created_by   NVARCHAR(50),
 @p_start_dt    NVARCHAR(8),
 @p_end_dt    NVARCHAR(8)
AS
BEGIN
 
    SET NOCOUNT ON;
    
 DECLARE @p_program_id    NVARCHAR(50)
 DECLARE @p_sheet_name    NVARCHAR(50)

 SET @p_program_id = 'DMF0039';
 SET @p_sheet_name = 'ESSPriority';

 -- 데이터 칼럼
 SELECT C.PROGRAM_ID
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
  , C.DIVISION_ID
 FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
 WHERE  1 = 1    
  AND    C.PROGRAM_ID  = @p_program_id
  AND    C.SHEET_NAME  = @p_sheet_name
  --AND    C.DEFAULT_FLAG = 'Y'
  AND    C.VALID_YN     = 'Y'
  AND  @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )
  --AND    C.COLUMN_NAME IN ('LAST_UPDATE_DATE', 'LAST_UPDATED_BY')
 UNION ALL
 
 -- 날짜 칼럼
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
    , MA.CELL_CONTROL_OBJECT_TYPE_CODE
    , ''         AS CELL_COMBO_DATA_TYPE
    , '0'         AS DATA_SCALE_NUMBER
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
    'W_' + BASIS_YYYYMMDD    AS COLUMN_NAME
  , SUBSTRING(BASIS_YYYYMMDD, 5, 4)  AS COLUMN_LABEL_NAME 
  , WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
  , MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
  , ''             AS DAY_CODE
  , BASIS_YYYYMMDD      AS SORT_ORDER_NO
  , 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE

     FROM [SCM_SYS_CALENDAR_M] 
  WHERE 
   BASIS_YYYYMMDD >= @p_start_dt
   AND    BASIS_YYYYMMDD <= @p_end_dt
   AND DAYOFWEEK_NO = 2

  --  UNION ALL
 
  --  SELECT 
  --'M_' + MIN(BASIS_START_DATE)    AS COLUMN_NAME
  --, SUBSTRING(BASIS_START_DATE, 5, 4)  AS COLUMN_LABEL_NAME 
  --, WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
  --, MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
  --, ''             AS DAY_CODE
  --, MIN(BASIS_START_DATE)      AS SORT_ORDER_NO
  --, 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE
  --  FROM [dbo].[SCM_SYS_CALENDAR_M]
  --  WHERE  BASIS_YYYYMMDD >= @p_start_dt
  --AND BASIS_YYYYMMDD <= @p_end_dt
  --AND CALENDAR_DAY = '01'
  --  GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTRING(BASIS_START_DATE, 5, 4), MONTH_NAME
 
   ) MA
   ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME

END
