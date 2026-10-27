CREATE PROCEDURE [dbo].[PR_UI_FP00625_SAVEALL_AGINGLT]
    @opt_debug nvarchar(5) = 'N',
   @in_USER_ID nvarchar(max) = '-',


@opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP00625_SAVEALL_AGINGLT                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00625_SAVEALL_AGINGLT                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0(Auto)                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021-01-15     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00625_SAVEALL_AGINGLT
*/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  BEGIN TRY
        
 
  DECLARE @sqlraw nvarchar(max)
   DECLARE @v_USER_ID nvarchar(max)
---Optional Parameter Part


  
   SET @v_USER_ID = @in_USER_ID


     BEGIN TRAN



  -- EXEC PR_LOG_PROCESS @sysdate, ....)


-- FP00625 merge_agingLT inserts list
   SET @sqlraw = '
      SELECT A.INSTANCE_ID AS CODE_ID, B.SEGMENT2 AS CODE_NAME, B.SORT_ORDER
           , B.ATTRIBUTE3 AS USE_WOW_STATUS
           , B.ATTRIBUTE1 AS CONFIRM_AREA
           , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID
      FROM (
				SELECT DISTINCT B.INSTANCE_ID
	          	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)
	          	WHERE  B.USER_ID     =  '
 +@v_USER_ID+ '
      		) A
      		, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)
      WHERE A.INSTANCE_ID      = B.SEGMENT1
      AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''
      AND   B.SEGMENT1 IN (
          SELECT  A.SEGMENT1
          FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
          WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE AMEND UI''
          AND    A.ATTRIBUTE1       = ''PSI AMEND UI''
      )
      AND   A.INSTANCE_ID IN (''KR_FORM_A'',''CN_FORM_A'',''CN_FORM_T'',''US_FORM_A'',''PL_FORM_A'')
      ORDER BY B.SORT_ORDER
    '

      iF @opt_debug = 'Y'
      BEGIN
         print @sqlraw
      END ELSE BEGIN
         exec sp_executesql @sqlraw
      END



  -- EXEC PR_LOG_PROCESS @sysdate, ....)


-- FP00625 merge_agingLT updates list
   SET @sqlraw = '
      SELECT A.INSTANCE_ID AS CODE_ID, B.SEGMENT2 AS CODE_NAME, B.SORT_ORDER
           , B.ATTRIBUTE3 AS USE_WOW_STATUS
           , B.ATTRIBUTE1 AS CONFIRM_AREA
           , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID
      FROM (
				SELECT DISTINCT B.INSTANCE_ID
	          	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)
	          	WHERE  B.USER_ID     =  '
 +@v_USER_ID+ '
      		) A
      		, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)
      WHERE A.INSTANCE_ID      = B.SEGMENT1
      AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''
      AND   B.SEGMENT1 IN (
          SELECT  A.SEGMENT1
          FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
          WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE AMEND UI''
          AND    A.ATTRIBUTE1       = ''PSI AMEND UI''
      )
      AND   A.INSTANCE_ID IN (''KR_FORM_A'',''CN_FORM_A'',''CN_FORM_T'',''US_FORM_A'',''PL_FORM_A'')
      ORDER BY B.SORT_ORDER
    '

      iF @opt_debug = 'Y'
      BEGIN
         print @sqlraw
      END ELSE BEGIN
         exec sp_executesql @sqlraw
      END


     COMMIT TRAN

 
  END TRY

  BEGIN CATCH
    --ROLLBACK

    --SET @v_descr = ERROR_MESSAGE()
    --EXEC PR_LOG_PROCESS @sysdate
    --commit;
  END CATCH

  --SET @n_log_count = @n_log_count + 1
  --EXEC PR_LOG_PROCESS @sysdate

END
