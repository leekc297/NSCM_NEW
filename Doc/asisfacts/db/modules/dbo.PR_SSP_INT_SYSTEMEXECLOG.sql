

/***************************************************************************************************
 * Program ID   : PR_SSP_INT_SYSTEMEXECLOG 
 * Description  : 
 * OutTable     : 
 * Execute      : EXEC PR_SSP_INT_SYSTEMEXECLOG
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.10.01   SSP Pjt.       Create.
****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_SSP_INT_SYSTEMEXECLOG]
	@JOBID            VARCHAR(50)
   ,@EXECSTARTDTTM    DATETIME
   ,@EXECENDDTTM      DATETIME
   ,@EXECRSLTCODE     NVARCHAR(50) 
   ,@ERRMSG           NVARCHAR(3000)
   ,@INQUIRYSTARTDTTM DATETIME
   ,@INQUIRYENDDTTM   DATETIME
WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRAN

	INSERT INTO dbo.SSP_INT_SYSTEMEXELOG
	           (JOBID
			   ,EXECSTARTDTTM
			   ,EXECENDDTTM
			   ,EXECRSLTCODE
			   ,ERRMSG
			   ,INQUIRYSTARTDTTM
			   ,INQUIRYENDDTTM
			   ,INSUSERID  
			   ,INSDTTM
			   ,UPDUSERID  
			   ,UPDDTTM    
	           )
	     VALUES
	           (@JOBID
	           ,@EXECSTARTDTTM
	           ,@EXECENDDTTM
	           ,@EXECRSLTCODE
	           ,@ERRMSG
	           ,@INQUIRYSTARTDTTM
	           ,@INQUIRYENDDTTM
	           ,'ssp_batch'  
	           ,getdate()
	           ,'ssp_batch'  
	           ,getdate()  
	           )

    DELETE FROM dbo.SSP_INT_SYSTEMEXELOG
	 WHERE EXECENDDTTM < convert(datetime, convert(varchar, getdate(), 112)) - 10

	COMMIT TRAN; 

	SET NOCOUNT OFF;

  
END

