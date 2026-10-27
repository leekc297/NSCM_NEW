CREATE PROCEDURE [dbo].[PR_TEST]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_confirm_flag nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B                             **/
/** 프로그램 명   : PSI_AMEND_UI 수량변경분 재계산                                            **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2017.11.10    KSJEON         최초 작성                                                    **/
/** **/
/***********************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;



INSERT INTO [dbo].[TH_UIS_SQL_LOG]
           ([PROG_ID]
           ,[QUERY_ID]
           ,[QUERY_SEQ]
           ,[INST_SEQ]
           ,[QUERY_VALUE]
           ,[JOB_TYPE]
           ,[START_TIME]
           ,[END_TIME]
           ,[INSERT_ID]
           ,[INSERT_TIME])
     VALUES
	 ('===---===',
	 @p_instance_id
           ,0--<QUERY_SEQ, int,>
           ,1--<INST_SEQ, nvarchar(20),>
           ,@p_plan_id--<QUERY_VALUE, nvarchar(4000),>
           ,'ssss-'--<JOB_TYPE, nvarchar(10),>
           ,getDate()--<START_TIME, datetime,>
           ,getDate()--<END_TIME, datetime,>
           ,@p_confirm_flag--<INSERT_ID, nvarchar(100),>
           ,getDate()--<INSERT_TIME, datetime,>)
    )

		WAITFOR DELAY '00:01';  

END
