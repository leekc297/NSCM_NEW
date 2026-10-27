
CREATE PROCEDURE [dbo].[PR_SCM_XLS_USER_LOGIN]
-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_XLS_USER_LOGIN
-- Param               : 
-- Batch Period        : 1 Day
-- Description         : 
-- 
-- Source System       : FP SDB
-- Destination System  : EXCEL
-- Source Table        :
-- Destination Table   : TH_UIS_USER_DETAIL
--
-- Create(Update) Date : 2019.07.30
-- Update Date         : 
--						

-- Author              : PIYONG
-- Version             : 1.0 최초작성

-- ================================================================================================

 @P_USER_ID          VARCHAR(100) = NULL,
 @P_ASIS_PASSWD      VARCHAR(100) = NULL,
 @P_PASSWD_CHANGE_YN CHAR(1) = 'N',
 @P_TOBE_PASSWD      VARCHAR(100) = NULL

AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_XLS_USER_LOGIN'
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
	DECLARE @P_RESULT_CODE   VARCHAR(10)
	DECLARE @P_RESULT_MSG    NVARCHAR(200)

	DECLARE @X_ASIS_PASSWD VARCHAR(255) = NULL

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate


	BEGIN TRY				

		BEGIN TRAN

			SET NOCOUNT ON;
			SET @P_RESULT_CODE    = NULL
			SET @P_RESULT_MSG     = NULL;

			IF  @P_USER_ID IS NULL
			 BEGIN
				 SET @P_RESULT_CODE='NG'
				 SET @P_RESULT_MSG =N'Enter User ID.'
			 END

			IF  @P_ASIS_PASSWD  IS NULL
			 BEGIN
				 SET @P_RESULT_CODE='NG'
				 SET @P_RESULT_MSG =N'Enter User Passwd'
			 END

/*
			--SYMMETRIC 생성
			CREATE MASTER KEY ENCRYPTION BY
			PASSWORD = 'Pa$$w0rdPa$$w0rd'

			CREATE CERTIFICATE Excel_Login
			WITH SUBJECT = 'Excel Login Security Numbers';
 

			CREATE SYMMETRIC KEY EXCEL_SECKEY01
			WITH ALGORITHM = AES_256
			ENCRYPTION BY CERTIFICATE Excel_Login;


			OPEN SYMMETRIC KEY EXCEL_SECKEY01
			DECRYPTION BY CERTIFICATE Excel_Login

*/

			OPEN SYMMETRIC KEY EXCEL_SECKEY01
			DECRYPTION BY CERTIFICATE Excel_Login
			;

		    -- USER 권한 확인

			SELECT @X_ASIS_PASSWD = CONVERT(VARCHAR,DECRYPTBYKEY(A.EXCEL_PASSWD)) --암호화한 값
			  FROM TH_UIS_USER_DETAIL A WITH(NOLOCK)
			 WHERE A.[USER_ID] = @P_USER_ID
			;

			-- 암호비교는 대소문자 구분이 없음.
			IF ( @X_ASIS_PASSWD IS NULL OR @X_ASIS_PASSWD <> @P_ASIS_PASSWD )
				BEGIN
					SET @P_RESULT_CODE='NG'
					SET @P_RESULT_MSG =N'Unregistered User ID or Wrong Passwd.'
				END
			ELSE -- PASSWD 점검통과시
				BEGIN

					SET @P_RESULT_CODE= 'OK'
					SET @P_RESULT_MSG = NULL

					IF @P_PASSWD_CHANGE_YN='Y' 
						BEGIN
							IF @P_TOBE_PASSWD IS NOT NULL
								BEGIN
									OPEN SYMMETRIC KEY EXCEL_SECKEY01
								--	DECRYPTION BY PASSWORD ='Pa$$w0rdPa$$w0rd'
								DECRYPTION BY CERTIFICATE Excel_Login
									;

									UPDATE DBO.TH_UIS_USER_DETAIL
									   SET EXCEL_PASSWD = ENCRYPTBYKEY(KEY_GUID('EXCEL_SECKEY01'),@P_TOBE_PASSWD),
										   EXCEL_PASSWD_CHANGE_DATE = GETDATE()
									 WHERE USER_ID = @P_USER_ID
									;
								END
							ELSE
								BEGIN
									SET @P_RESULT_CODE='NG'
									SET @P_RESULT_MSG =N'Enter New Passwd.'
								END
						END

				  -- 사용자 접속로그 생성
					INSERT DBO.TH_UIS_USER_LOG (
						USER_ID
						, LOGIN_DATE
						,[INSERT_ID]
						,[INSERT_DTTM]
					) VALUES (
						LOWER(@P_USER_ID)
						, GETDATE()
						, LOWER(@P_USER_ID)
						, GETDATE()
					);

				END

		SELECT  @P_RESULT_CODE   AS RESULT_CODE, @P_RESULT_MSG    AS RESULT_MSG;

			IF @P_RESULT_CODE ='OK'
				BEGIN
					SELECT A.[USER_ID]   AS [USER_ID]
						   , A.[USER_NAME] AS [USER_NAME]
					  FROM TH_UIS_USER_DETAIL          A WITH(NOLOCK)
					 WHERE A.[USER_ID] = @P_USER_ID
				END


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
