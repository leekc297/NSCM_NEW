
CREATE PROCEDURE [dbo].[PR_XIF_SCM_ITEM_CLASS_INSERT]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_SCM_ITEM_CLASS_INSERT
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : INFDEV
-- Destination System  : FP SDB
-- Source Table        : [LGCE_INF].[dbo].[XIF_MDM_CLASSCODE_OUT_R]
-- Destination Table   : SCM_ITEM_CLASS_LEVEL_M, SCM_ITEM_CLASS_M
--
-- Create Date		   : 2016.08.16
-- Update Date		   : 2017.06.29  piyong 1.1
--                       2018.07.11  kimcd  1.2
--						 2019.03.05  PIYONG 2.0

-- Author              : 김 석
-- Version             : 1.0
--					   : 1.1 SCM_ITEM_CLASS_M에 신규로 생성되는 아이템의 USE_FLAG NULL 되어 있어
--						     FP UI에 보이지 않아 USE_FLAG의 값 'Y'로 입력 되도록 변경  kimcd 요청
--                       1.2 2018-07-11 kimcd item class level master에 level_code를 갱신 컬럼에 추가
--						 2.0 전지재료(LGCMMT) 수신 추가
-- ================================================================================================

-- WORK_DATE
@P_WORK_DATE NVARCHAR(50) = NULL

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SCM_ITEM_CLASS_INSERT'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

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
		 
		IF @P_WORK_DATE IS NULL
		    BEGIN
			    SET @P_WORK_DATE = (SELECT MAX(WORK_DATE) AS WORK_DATE
                                      FROM [dbo].[SY_XIF_MDM_CLASSCODE_OUT_R] WITH(NOLOCK) 
									 WHERE PROC_FLAG = 'N')
			END
		;

		WITH CTE_TABLE(CLASSID, CLASSCODE, CLASSNAME, LEVEL, ISLEAF, PARENTCLASSID, CLASSNAME2) AS
		(
			SELECT A.CLASSID AS LEVEL_ID, 
				   A.CLASSCODE AS LEVEL_CODE, 
				   A.CLASSNAME AS LEVEL_NAME, 
				   0 AS LEVEL, 
				   NULL AS USE_FLAG, 
				   A.PARENTCLASSID, 
				   CAST(A.CLASSNAME + ' > ' AS NVARCHAR) AS CLASSNAME2
			  FROM (
					SELECT * 
					  FROM [dbo].[SY_XIF_MDM_CLASSCODE_OUT_R] A WITH(NOLOCK)
					 WHERE A.WORK_DATE = @P_WORK_DATE
				   ) A      
			 WHERE A.CLASSID IN ( 'LGCMME', 'LGCMMT')		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
			UNION ALL
			SELECT M.CLASSID AS LEVEL_ID, 
				   M.CLASSCODE AS LEVEL_CODE, 
				   M.CLASSNAME AS LEVEL_NAME, 
				   LEVEL + 1, 
				   NULL AS USE_FLAG, 
				   M.PARENTCLASSID, 
				   CAST(N.CLASSNAME + ' > ' + M.CLASSNAME + ' > ' AS NVARCHAR) AS CLASSNAME2
			  FROM (
					SELECT * 
					  FROM [dbo].[SY_XIF_MDM_CLASSCODE_OUT_R] A WITH(NOLOCK)
					 WHERE A.WORK_DATE = @P_WORK_DATE
				   ) M
			  JOIN CTE_TABLE N 
				ON M.PARENTCLASSID = N.CLASSID
		)
		MERGE INTO [dbo].[SCM_ITEM_CLASS_LEVEL_M] A
		USING (
				SELECT CLASSID AS LEVEL_ID, 
					   CLASSCODE AS LEVEL_CODE, 
					   CLASSNAME AS LEVEL_NAME, 
					   LEVEL, 
					   NULL AS USE_FLAG, 
					   NULL AS OPERATION_GROUP_NAME, 
					   NULL AS OPERATION_GROUP_ID, 
					   'SYSTEM' AS INSERT_ID, 
					   GETDATE() AS INSERT_TIME, 
					   'SYSTEM' AS UPDATE_ID, 
					   GETDATE() AS UPDATE_TIME
				  FROM CTE_TABLE
				 WHERE CLASSCODE IS NOT NULL
				   AND CLASSID IS NOT NULL
			  ) B
		   ON (
				A.LEVEL_ID = B.LEVEL_ID
				AND A.LEVEL = B.LEVEL
			  )
		WHEN MATCHED THEN
			UPDATE
			   SET A.LEVEL_NAME  = B.LEVEL_NAME
				   ,A.LEVEL_CODE  = B.LEVEL_CODE  -- 2018-07-11 kimcd 갱신되는 컬럼으로 추가
				   ,A.UPDATE_ID   = 'PR_XIF_SCM_ITEM_CLASS_INSERT'
				   ,A.UPDATE_TIME = GETDATE()

		WHEN NOT MATCHED THEN
			INSERT (
				[LEVEL_ID]
				,[LEVEL_CODE]
				,[LEVEL_NAME]
				,[LEVEL]
				,[USE_FLAG]
				,[OPERATION_GROUP_NAME]
				,[OPERATION_GROUP_ID]
				,[INSERT_ID]
				,[INSERT_TIME]
				,[UPDATE_ID]
				,[UPDATE_TIME]
			) VALUES (
				B.LEVEL_ID
				,B.LEVEL_CODE
				,B.LEVEL_NAME
				,B.LEVEL
				,'Y'
				,B.OPERATION_GROUP_NAME
				,B.OPERATION_GROUP_ID
				,'PR_XIF_SCM_ITEM_CLASS_INSERT'
				,GETDATE()
				,'PR_XIF_SCM_ITEM_CLASS_INSERT'
				,GETDATE()
			)
		;




		MERGE INTO [dbo].[SCM_ITEM_CLASS_M] A
		USING (
				SELECT A.A_CLASSID AS CLASS_ID,
					   A.FULL_CLASSNAME AS CLASS_NAME,
					   A.LEVEL,
					   CASE WHEN A.LEVEL_1_CODE = '' THEN '-' ELSE ISNULL(A.LEVEL_1_CODE, '-') END AS LEVEL_1_CODE,
					   ISNULL(A.LEVEL_1_NAME, '-') AS LEVEL_1_NAME,
					   ISNULL(A.LEVEL_1_ID, '-')   AS LEVEL_1_ID,

					   ISNULL(A.LEVEL_2_CODE, '-') AS LEVEL_2_CODE,
					   ISNULL(A.LEVEL_2_NAME, '-') AS LEVEL_2_NAME,
					   ISNULL(A.LEVEL_2_ID, '-')   AS LEVEL_2_ID,

					   ISNULL(A.LEVEL_3_CODE, '-') AS LEVEL_3_CODE,
					   ISNULL(A.LEVEL_3_NAME, '-') AS LEVEL_3_NAME,
					   ISNULL(A.LEVEL_3_ID, '-')   AS LEVEL_3_ID,

					   ISNULL(A.LEVEL_4_CODE, '-') AS LEVEL_4_CODE,
					   ISNULL(A.LEVEL_4_NAME, '-') AS LEVEL_4_NAME,
					   ISNULL(A.LEVEL_4_ID, '-')   AS LEVEL_4_ID,
					   -----------------------------------------------------------------------------------------------------
				   		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
					   ISNULL(A.LEVEL_5_CODE, '-') AS LEVEL_5_CODE,
					   ISNULL(A.LEVEL_5_NAME, '-') AS LEVEL_5_NAME,
					   ISNULL(A.LEVEL_5_ID, '-')   AS LEVEL_5_ID,

					   ISNULL(A.LEVEL_6_CODE, '-') AS LEVEL_6_CODE,
					   ISNULL(A.LEVEL_6_NAME, '-') AS LEVEL_6_NAME,
					   ISNULL(A.LEVEL_6_ID, '-')   AS LEVEL_6_ID,
					    --2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
					   ------------------------------------------------------------------------------------------------------
					   NULL AS USE_FLAG
				  FROM (
						SELECT A.A_CLASSID,
							   A.FULL_CLASSNAME,
							   B.LEVEL,
							   CASE WHEN B.LEVEL = '1' THEN A_CLASSCODE
									WHEN B.LEVEL = '2' THEN B_CLASSCODE
									WHEN B.LEVEL = '3' THEN C_CLASSCODE
									WHEN B.LEVEL = '4' THEN D_CLASSCODE
									WHEN B.LEVEL = '5' THEN E_CLASSCODE		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN F_CLASSCODE		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_1_CODE,
							   CASE WHEN B.LEVEL = '1' THEN A_CLASSNAME
									WHEN B.LEVEL = '2' THEN B_CLASSNAME
									WHEN B.LEVEL = '3' THEN C_CLASSNAME
									WHEN B.LEVEL = '4' THEN D_CLASSNAME
									WHEN B.LEVEL = '5' THEN E_CLASSNAME		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN F_CLASSNAME		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_1_NAME,
							   CASE WHEN B.LEVEL = '1' THEN A_CLASSID
									WHEN B.LEVEL = '2' THEN B_CLASSID
									WHEN B.LEVEL = '3' THEN C_CLASSID
									WHEN B.LEVEL = '4' THEN D_CLASSID
									WHEN B.LEVEL = '5' THEN E_CLASSID		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN F_CLASSID		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_1_ID,

							  CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN A_CLASSCODE
									WHEN B.LEVEL = '3' THEN B_CLASSCODE
									WHEN B.LEVEL = '4' THEN C_CLASSCODE
									WHEN B.LEVEL = '5' THEN D_CLASSCODE		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN E_CLASSCODE		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_2_CODE,
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN A_CLASSNAME
									WHEN B.LEVEL = '3' THEN B_CLASSNAME
									WHEN B.LEVEL = '4' THEN C_CLASSNAME
									WHEN B.LEVEL = '5' THEN D_CLASSNAME		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN E_CLASSNAME		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_2_NAME,
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN A_CLASSID
									WHEN B.LEVEL = '3' THEN B_CLASSID
									WHEN B.LEVEL = '4' THEN C_CLASSID
									WHEN B.LEVEL = '5' THEN D_CLASSID		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN E_CLASSID		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_2_ID,

							  CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN A_CLASSCODE
									WHEN B.LEVEL = '4' THEN B_CLASSCODE
									WHEN B.LEVEL = '5' THEN C_CLASSCODE		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN D_CLASSCODE		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_3_CODE,
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN A_CLASSNAME
									WHEN B.LEVEL = '4' THEN B_CLASSNAME
									WHEN B.LEVEL = '5' THEN C_CLASSNAME		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN D_CLASSNAME		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_3_NAME,
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN A_CLASSID
									WHEN B.LEVEL = '4' THEN B_CLASSID
									WHEN B.LEVEL = '5' THEN C_CLASSID		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN D_CLASSID		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_3_ID,
 
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN NULL
									WHEN B.LEVEL = '4' THEN A_CLASSCODE
									WHEN B.LEVEL = '5' THEN B_CLASSCODE		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN C_CLASSCODE		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_4_CODE,
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN NULL
									WHEN B.LEVEL = '4' THEN A_CLASSNAME
									WHEN B.LEVEL = '5' THEN B_CLASSNAME		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN C_CLASSNAME		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_4_NAME,
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN NULL
									WHEN B.LEVEL = '4' THEN A_CLASSID
									WHEN B.LEVEL = '5' THEN B_CLASSID		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									WHEN B.LEVEL = '6' THEN C_CLASSID		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
								END AS LEVEL_4_ID,
								-----------------------------------------------------------------------------------------------
								--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN NULL
									WHEN B.LEVEL = '4' THEN NULL
									WHEN B.LEVEL = '5' THEN A_CLASSCODE
									WHEN B.LEVEL = '6' THEN B_CLASSCODE
								END AS LEVEL_5_CODE,
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN NULL
									WHEN B.LEVEL = '4' THEN NULL
									WHEN B.LEVEL = '5' THEN A_CLASSNAME
									WHEN B.LEVEL = '6' THEN B_CLASSNAME
								END AS LEVEL_5_NAME,
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN NULL
									WHEN B.LEVEL = '4' THEN NULL
									WHEN B.LEVEL = '5' THEN A_CLASSID
									WHEN B.LEVEL = '6' THEN B_CLASSID
								END AS LEVEL_5_ID,

							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN NULL
									WHEN B.LEVEL = '4' THEN NULL
									WHEN B.LEVEL = '5' THEN NULL
									WHEN B.LEVEL = '6' THEN A_CLASSCODE
								END AS LEVEL_6_CODE,
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN NULL
									WHEN B.LEVEL = '4' THEN NULL
									WHEN B.LEVEL = '5' THEN NULL
									WHEN B.LEVEL = '6' THEN A_CLASSNAME
								END AS LEVEL_6_NAME,
							   CASE WHEN B.LEVEL = '1' THEN NULL
									WHEN B.LEVEL = '2' THEN NULL
									WHEN B.LEVEL = '3' THEN NULL
									WHEN B.LEVEL = '4' THEN NULL
									WHEN B.LEVEL = '5' THEN NULL
									WHEN B.LEVEL = '6' THEN A_CLASSID
								END AS LEVEL_6_ID
								--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가 끝
								-------------------------------------------------------------------------------------------------
						  FROM (
								SELECT A.CLASSCODE AS A_CLASSCODE,
									   A.CLASSNAME AS A_CLASSNAME,
									   A.CLASSID   AS A_CLASSID,
									   A.FULL_CLASSNAME,

									   B.CLASSCODE AS B_CLASSCODE,
									   B.CLASSNAME AS B_CLASSNAME,
									   B.CLASSID   AS B_CLASSID,

									   C.CLASSCODE AS C_CLASSCODE,
									   C.CLASSNAME AS C_CLASSNAME,
									   C.CLASSID   AS C_CLASSID,

									   D.CLASSCODE AS D_CLASSCODE,
									   D.CLASSNAME AS D_CLASSNAME,
									   D.CLASSID   AS D_CLASSID,
										-------------------------------------------------------------------------------------------
								   		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									   E.CLASSCODE AS E_CLASSCODE,
									   E.CLASSNAME AS E_CLASSNAME,
									   E.CLASSID   AS E_CLASSID,

									   F.CLASSCODE AS F_CLASSCODE,
									   F.CLASSNAME AS F_CLASSNAME,
									   F.CLASSID   AS F_CLASSID
								   		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가 끝
										-------------------------------------------------------------------------------------------
								 FROM (
									   SELECT * FROM [dbo].[SY_XIF_MDM_CLASSCODE_OUT_R] A WITH(NOLOCK)
									    WHERE A.WORK_DATE = @P_WORK_DATE
									  ) A LEFT OUTER JOIN
									  (
									   SELECT * FROM [dbo].[SY_XIF_MDM_CLASSCODE_OUT_R] A WITH(NOLOCK)
									    WHERE A.WORK_DATE = @P_WORK_DATE
									  ) B 
								   ON A.PARENTCLASSID = B.CLASSID                 LEFT OUTER JOIN
									  (
									   SELECT * FROM [dbo].[SY_XIF_MDM_CLASSCODE_OUT_R] A WITH(NOLOCK)
									    WHERE A.WORK_DATE = @P_WORK_DATE
									  ) C
								   ON B.PARENTCLASSID = C.CLASSID                 LEFT OUTER JOIN
									  (
									   SELECT * FROM [dbo].[SY_XIF_MDM_CLASSCODE_OUT_R] A WITH(NOLOCK)
									    WHERE A.WORK_DATE = @P_WORK_DATE
									  ) D 
								   ON C.PARENTCLASSID = D.CLASSID                 LEFT OUTER JOIN
									  (-----------------------------------------------------------------------------------------
								  		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
									   SELECT * FROM [dbo].[SY_XIF_MDM_CLASSCODE_OUT_R] A WITH(NOLOCK)
									    WHERE A.WORK_DATE = @P_WORK_DATE
									  ) E
								   ON D.PARENTCLASSID = E.CLASSID                 LEFT OUTER JOIN
									  (
									   SELECT * FROM [dbo].[SY_XIF_MDM_CLASSCODE_OUT_R] A WITH(NOLOCK)
									    WHERE A.WORK_DATE = @P_WORK_DATE
									  ) F
								   ON E.PARENTCLASSID = F.CLASSID
								   		--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가 끝
										-----------------------------------------------------------------------------------------
							   ) A,
							   DBO.SCM_ITEM_CLASS_LEVEL_M B WITH(NOLOCK)
						 WHERE A.A_CLASSID = B.LEVEL_ID
					   ) A
			  ) B
		   ON (
				A.CLASS_ID = B.CLASS_ID
			  )
		 WHEN MATCHED THEN
			UPDATE
			   SET A.CLASS_NAME   = B.CLASS_NAME
				   ,A.LEVEL        = B.LEVEL
				   ,A.LEVEL_1_CODE = B.LEVEL_1_CODE
				   ,A.LEVEL_1_NAME = B.LEVEL_1_NAME
				   ,A.LEVEL_1_ID   = B.LEVEL_1_ID  
				   ,A.LEVEL_2_CODE = B.LEVEL_2_CODE
				   ,A.LEVEL_2_NAME = B.LEVEL_2_NAME
				   ,A.LEVEL_2_ID   = B.LEVEL_2_ID  
				   ,A.LEVEL_3_CODE = B.LEVEL_3_CODE
				   ,A.LEVEL_3_NAME = B.LEVEL_3_NAME
				   ,A.LEVEL_3_ID   = B.LEVEL_3_ID  
				   ,A.LEVEL_4_CODE = B.LEVEL_4_CODE
				   ,A.LEVEL_4_NAME = B.LEVEL_4_NAME
				   ,A.LEVEL_4_ID   = B.LEVEL_4_ID
					------------------------------------------------------------------
				   	--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
				   ,A.LEVEL_5_CODE = B.LEVEL_5_CODE
				   ,A.LEVEL_5_NAME = B.LEVEL_5_NAME
				   ,A.LEVEL_5_ID   = B.LEVEL_5_ID
				   ,A.LEVEL_6_CODE = B.LEVEL_6_CODE
				   ,A.LEVEL_6_NAME = B.LEVEL_6_NAME
				   ,A.LEVEL_6_ID   = B.LEVEL_6_ID
				   	--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가 끝
					-----------------------------------------------------------------
				   ,A.UPDATE_ID    = 'PR_XIF_SCM_ITEM_CLASS_INSERT'
				   ,A.UPDATE_TIME  = GETDATE()
		 WHEN NOT MATCHED THEN
			INSERT (
				[CLASS_ID]
				,[CLASS_NAME]
				,[LEVEL]
				,[LEVEL_1_CODE]
				,[LEVEL_1_NAME]
				,[LEVEL_1_ID]
				,[LEVEL_2_CODE]
				,[LEVEL_2_NAME]
				,[LEVEL_2_ID]
				,[LEVEL_3_CODE]
				,[LEVEL_3_NAME]
				,[LEVEL_3_ID]
				,[LEVEL_4_CODE]
				,[LEVEL_4_NAME]
				,[LEVEL_4_ID]
				---------------------------------------------------------------------
				--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
				,[LEVEL_5_CODE]
				,[LEVEL_5_NAME]
				,[LEVEL_5_ID]
				,[LEVEL_6_CODE]
				,[LEVEL_6_NAME]
				,[LEVEL_6_ID]
				--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가 끝
				---------------------------------------------------------------------
				,[USE_FLAG]
				,[INSERT_ID]
				,[INSERT_TIME]
				,[UPDATE_ID]
				,[UPDATE_TIME]
			) VALUES (
				B.CLASS_ID
				,B.CLASS_NAME
				,B.LEVEL
				,B.LEVEL_1_CODE
				,B.LEVEL_1_NAME
				,B.LEVEL_1_ID
				,B.LEVEL_2_CODE
				,B.LEVEL_2_NAME
				,B.LEVEL_2_ID
				,B.LEVEL_3_CODE
				,B.LEVEL_3_NAME
				,B.LEVEL_3_ID
				,B.LEVEL_4_CODE
				,B.LEVEL_4_NAME
				,B.LEVEL_4_ID
				-------------------------------------------------------------------
				--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가
				,B.LEVEL_5_CODE
				,B.LEVEL_5_NAME
				,B.LEVEL_5_ID
				,B.LEVEL_6_CODE
				,B.LEVEL_6_NAME
				,B.LEVEL_6_ID
				--2019-03-05 PIYONG CHANGE  전지재료(LGCMMT) 추가 끝
				-------------------------------------------------------------------
				,'Y'
				,'PR_XIF_SCM_ITEM_CLASS_INSERT'
				,GETDATE()
				,'PR_XIF_SCM_ITEM_CLASS_INSERT'
				,GETDATE()
			)
		;

		SET @ROWCOUNT = @@ROWCOUNT

		UPDATE [dbo].[SY_XIF_MDM_CLASSCODE_OUT_R]
		   SET PROC_FLAG = 'Y'
		      ,PROC_DATE = getdate()
		 WHERE WORK_DATE = @P_WORK_DATE

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