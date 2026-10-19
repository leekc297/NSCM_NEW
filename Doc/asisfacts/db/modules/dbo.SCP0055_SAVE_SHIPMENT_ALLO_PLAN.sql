

 
CREATE PROCEDURE [dbo].[SCP0055_SAVE_SHIPMENT_ALLO_PLAN]
	@P_SITE_ID				NVARCHAR(MAX),
	@P_NICK_NAME            NVARCHAR(MAX),
	@P_DEPT_ID              NVARCHAR(MAX),
	@P_PLAN_DATE            NVARCHAR(8),
	@P_GAP_DATE             NVARCHAR(8),
	@P_NOTE                 NVARCHAR(MAX),
	@P_PROGRAM_ID			NVARCHAR(10) = 'SCP0055',
	@P_USER_ID				NVARCHAR(30)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	-- 기존 정보 백업
	UPDATE SCM_SHIP_ALLO_REPORT
	   SET VALID = 'N',
	       UPDDTTM = GETDATE(),
		   UPDUSER = @P_USER_ID
	 WHERE SITE_ID = @P_SITE_ID
	   AND NICK_NAME    = @P_NICK_NAME
	   AND DEPT_ID      = @P_DEPT_ID
	   AND PLAN_DATE    = @P_PLAN_DATE
	   AND GAP_DATE     = 'ALL';

	-- 신규 정보 생성
	INSERT INTO SCM_SHIP_ALLO_REPORT (
	                                   SITE_ID,
									   NICK_NAME,
									   DEPT_ID,
									   PLAN_DATE,
									   GAP_DATE,
									   NOTE,
									   VALID,
									   INSDTTM,
									   INSUSER
	                                 )
							  VALUES (
							           @P_SITE_ID,
									   @P_NICK_NAME,
									   @P_DEPT_ID,
									   @P_PLAN_DATE,
									   'ALL',
									   @P_NOTE,
									   'Y',
									   GETDATE(),
									   @P_USER_ID
							         );
END
