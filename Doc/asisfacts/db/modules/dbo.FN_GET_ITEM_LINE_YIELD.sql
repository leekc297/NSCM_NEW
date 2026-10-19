CREATE FUNCTION [dbo].[FN_GET_ITEM_LINE_YIELD]
      (@p_division_id         nvarchar(50),
       @p_scm_site_id         nvarchar(50),
       @p_item_id             nvarchar(50),
       @p_line_id             nvarchar(50),
       @p_operation_id        nvarchar(50),
       @p_yyyymmdd            nvarchar(8))
      RETURNS NUMERIC(20,10)
AS
/*
 * Program ID   : FN_GET_ITEM_LINE_YIELD  
 * Description  : 특정사이트,특정일자,특정item,특정라인,특정공정코드에 해당하는 fp YIELD
 * Parameter    :p_division_id,p_scm_site_id,p_item_id,p_line_id,p_operation_id,p_yyyymmdd
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.07   yydok         Initial Release 
 * 2018.03.13   yydok         활성화수율은 라인평균수율로 리턴, 수율이 없으면 1리턴(100%)
 * 2018.04.05   yydok         yield 0이면 1, 1이상이면 1로 적용하는 로직반영
 * 2018.08.27   YYDOK         활성화 예외구간 반영로직 제거
 * 2020.03.12   KSG           PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time Table 변경
 */
BEGIN
  
  DECLARE @x_yield           numeric(20,10) ;
--  DECLARE @x_count           int = 0;  

 IF SUBSTRING(@p_operation_id,1,1) <> 'F' --활성화가 아니면
   BEGIN

          BEGIN
               SELECT TOP 1 @x_yield = X.YIELD
                 FROM 
                (
                SELECT ISNULL((case when yield <= 0 then 1
                                               when yield > 1  then 1
                                               else yield
                                          end) ,1) AS YIELD
                  FROM SCM_MST_YIELD_VER_H_V WITH(NOLOCK)
                 WHERE 1=1
                   AND DIVISION_ID    = @p_division_id
                   AND @p_scm_site_id LIKE PLANT_ID+'%'
                   AND OPERATION_ID   = @p_operation_id
                   AND LINE_ID        = @p_line_id
                   AND ITEM_ID        = @p_item_id
                   AND MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
                union all
                SELECT ISNULL((case when yield <= 0 then 1
                                               when yield > 1  then 1
                                               else yield
                                          end) ,1) AS YIELD
                  FROM SCP_MST_TACT_TIME with(nolock)
                 WHERE DIVISION_ID    = @p_division_id
                   AND ITEM_ID        = @p_item_id
                   AND PLANT_SITE_ID  = @p_scm_site_id
                   AND LINE_ID        = @p_line_id
                ) X
                   ;     
          END

  END
ELSE
  BEGIN
        SELECT @x_yield = MAX (case when yield <= 0 then 1
                                    when yield > 1  then 1
                                    else yield
                               end) 
          FROM SCM_MST_YIELD_VER_H_V WITH(NOLOCK)
         WHERE 1=1
           AND DIVISION_ID    = @p_division_id
           AND @p_scm_site_id LIKE PLANT_ID+'%'
           AND OPERATION_ID   = @p_operation_id
           --AND LINE_ID        = @p_line_id
           AND ITEM_ID        = @p_item_id
           AND MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
           ;     

  END

/* -- PJ20209642  START
 IF SUBSTRING(@p_operation_id,1,1) <> 'F' --활성화가 아니면
   BEGIN

          BEGIN
               SELECT TOP 1 @x_yield = X.YIELD
                 FROM 
                (
                SELECT ISNULL((case when yield <= 0 then 1
                                               when yield > 1  then 1
                                               else yield
                                          end) ,1) AS YIELD
                  FROM SCM_MST_YIELD_SN WITH(NOLOCK)
                 WHERE 1=1
                   AND DIVISION_ID    = @p_division_id
                   AND @p_scm_site_id LIKE PLANT_ID+'%'
                   AND OPERATION_ID   = @p_operation_id
                   AND LINE_ID        = @p_line_id
                   AND ITEM_ID        = @p_item_id
                   AND MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
                union all
                SELECT ISNULL((case when yield <= 0 then 1
                                               when yield > 1  then 1
                                               else yield
                                          end) ,1) AS YIELD
                  FROM SCP_MST_TACT_TIME with(nolock)
                 WHERE DIVISION_ID    = @p_division_id
                   AND ITEM_ID        = @p_item_id
                   AND PLANT_SITE_ID  = @p_scm_site_id
                   AND LINE_ID        = @p_line_id
                ) X
                   ;     
          END

  END
ELSE
  BEGIN
        SELECT @x_yield = MAX (case when yield <= 0 then 1
                                    when yield > 1  then 1
                                    else yield
                               end) 
          FROM SCM_MST_YIELD_SN WITH(NOLOCK)
         WHERE 1=1
           AND DIVISION_ID    = @p_division_id
           AND @p_scm_site_id LIKE PLANT_ID+'%'
           AND OPERATION_ID   = @p_operation_id
           --AND LINE_ID        = @p_line_id
           AND ITEM_ID        = @p_item_id
           AND MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
           ;     

  END
*/ -- PJ20209642  END

  IF (@x_yield = 0)
     BEGIN
          SET @x_yield = 1; 
     END;
   
  RETURN isnull(@x_yield,1);

END
;
