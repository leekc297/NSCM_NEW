

CREATE PROCEDURE [dbo].[PR_XIF_SSO_USER_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_SSO_USER_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_SSO_USER_R
-- Destination Table   : TH_UIS_USER_DETAIL
--
-- Create(Update) Date : 2016.08.22
-- Update Date		   : 2022.04.15 1.2 김현

-- Author              : 김 석
-- Version             : 1.0
--						 1.2 2022-04-14 김현 [C20220412-000040]사원 정보 수신 개선 - 법인 코드, 부서 코드 추가 수신
--                           [인터페이스 테이블] : dbo.XIF_SSO_USER_INFO_R => [사원정보 테이블] : dbo.TH_UIS_USER_DETAIL
--                           법인 코드             SA_COMP                    COMPANY       (기존 컬럼)
--                           부서 코드             SA_DEPT                    DEPARTMENT_ID (컬럼 추가)
-- ================================================================================================

-- SSO요청 SEQNO, 배치에서 실행될때 넘김
  @P_IFSEQNO  NVARCHAR(50)
, @OUT_RESULT NVARCHAR(20)  = 'FAIL' OUTPUT

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SSO_USER_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	--DECLARE @COMPANY     NVARCHAR(1000)


	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		IF @P_IFSEQNO = 'NULL' OR @P_IFSEQNO IS NULL
		   SET @P_IFSEQNO = (SELECT MIN(IFSEQNO) FROM [dbo].[SY_XIF_SSO_USER_INFO_R] WITH(NOLOCK)
							  WHERE ISNULL(TRANSFER_FLAG, 'N') = 'N'
							)


		MERGE INTO [dbo].[TH_UIS_USER_DETAIL] A
		USING ( 

				SELECT DISTINCT [IFSEQNO]
					   ,[SA_USER] AS USER_ID
					   ,[SA_NAME]
					   ,[SA_DEPT_NAME_E]
					   ,[SA_JOBX_NAME_E]
					   ,[SSO_EX_FLAG]
					   --2022-04-14 김현 [C20220412-000040]사원 정보 수신 개선 - 법인 코드, 부서 코드 추가 수신
					   ,[SA_COMP]
					   ,[SA_DEPT]
				  FROM [dbo].[SY_XIF_SSO_USER_INFO_R] 
				 WHERE IFSEQNO          = @P_IFSEQNO
				   AND TRANSFER_FLAG    = 'N'

				) B
		ON (           A.USER_ID        =  B.USER_ID
		   )
		WHEN MATCHED THEN
			 UPDATE SET A.USER_NAME     =  B.SA_NAME 
					   ,A.DEPARTMENT    =  B.SA_DEPT_NAME_E   
					   ,A.RANK          =  B.SA_JOBX_NAME_E      
					   ,A.USER_STATUS   =  ( SELECT CASE B.SSO_EX_FLAG WHEN 'D' THEN 'Deleted' ELSE 'normal' END )
					   ,A.UPDATE_ID     =  'PR_XIF_SSO_USER_R'         
					   ,A.UPDATE_DTTM   =  GETDATE()
					   --2022-04-14 김현 [C20220412-000040]사원 정보 수신 개선 - 법인 코드, 부서 코드 추가 수신
					   ,A.COMPANY       =  B.SA_COMP
					   ,A.DEPARTMENT_ID =  B.SA_DEPT
					                
		WHEN NOT MATCHED THEN
			 INSERT (   USER_ID
					   ,USER_NAME
					   ,DEPARTMENT
					   ,RANK
					   ,USER_STATUS
					   ,INSERT_ID
					   ,INSERT_DTTM
					   ,UPDATE_ID
					   ,UPDATE_DTTM
					   --2022-04-14 김현 [C20220412-000040]사원 정보 수신 개선 - 법인 코드, 부서 코드 추가 수신
					   ,COMPANY
					   ,DEPARTMENT_ID
					)
			 VALUES (   B.USER_ID
					   ,B.SA_NAME
					   ,B.SA_DEPT_NAME_E
					   ,B.SA_JOBX_NAME_E
					   ,'normal'     
					   ,'PR_XIF_SSO_USER_R'
					   ,GETDATE()
					   ,'PR_XIF_SSO_USER_R'
					   ,GETDATE()
					   --2022-04-14 김현 [C20220412-000040]사원 정보 수신 개선 - 법인 코드, 부서 코드 추가 수신
					   ,B.SA_COMP
					   ,B.SA_DEPT
					)
		;
		   	  
		SET @ROWCOUNT = @@ROWCOUNT

		UPDATE [dbo].[SY_XIF_SSO_USER_INFO_R]
		   SET TRANSFER_FLAG = 'Y'
			  ,TRANSFER_DATE = GETDATE()
	     WHERE IFSEQNO       = @P_IFSEQNO
		   AND TRANSFER_FLAG = 'N'
		;

		SET @OUT_RESULT = 'SUCCESS'

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END


