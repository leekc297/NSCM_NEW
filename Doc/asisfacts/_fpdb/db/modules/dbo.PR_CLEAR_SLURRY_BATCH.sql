
--ALTER PROCEDURE [dbo].[PR_CLEAR_SLURRY_BATCH]
CREATE PROCEDURE [dbo].[PR_CLEAR_SLURRY_BATCH]

-- ================================================================================================
-- Program ID          : FP00520-XXX
-- Program Name        : PR_CLEAR_SLURRY_BATCH
-- Param               :
-- Batch Period        : BOM 수신 주기에 따름
-- Description         :
--
-- Source System       : FP
-- Destination System  : FP SDB
-- Source Table        : SCM_SLURRY_RATE_V
-- Destination Table   : SCM_BATCH_M, SCM_SLURRY_RATE_H
--
-- Create Date         : 2017.01.09
-- Update Date		   : 2017.05.25  1.1 PIYONG

-- Author              : kim choon dong
-- Version             : 1.0
--					   : 1.1 메일링 로직 추가 2017-05-25 FP-053
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_CLEAR_SLURRY_BATCH'
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
	DECLARE @COMPANY_ID				[NVARCHAR](30)
	DECLARE @DIVISION_ID			[NVARCHAR](30)
	DECLARE @SITE_ID				[NVARCHAR](30)
	DECLARE @PLANT_ID				[NVARCHAR](30)
	DECLARE @PARENT_ITEM_ID 		[NVARCHAR](50)
	DECLARE @MATERIAL_1				[NVARCHAR](50)
	DECLARE @INPUT_RATE_1			[NUMERIC](20, 10)
	DECLARE @MATERIAL_2				[NVARCHAR](50)
	DECLARE @INPUT_RATE_2			[NUMERIC](20, 10)
	DECLARE @MATERIAL_3				[NVARCHAR](50)
	DECLARE @INPUT_RATE_3			[NUMERIC](20, 10)
	DECLARE @MATERIAL_4				[NVARCHAR](50)
	DECLARE @INPUT_RATE_4			[NUMERIC](20, 10)
	DECLARE @MATERIAL_5				[NVARCHAR](50)
	DECLARE @INPUT_RATE_5			[NUMERIC](20, 10)
	DECLARE @MATERIAL_6				[NVARCHAR](50)
	DECLARE @INPUT_RATE_6			[NUMERIC](20, 10)
	DECLARE @MATERIAL_7				[NVARCHAR](50)
	DECLARE @INPUT_RATE_7			[NUMERIC](20, 10)
	DECLARE @MATERIAL_8				[NVARCHAR](50)
	DECLARE @INPUT_RATE_8			[NUMERIC](20, 10)
	DECLARE @MATERIAL_9				[NVARCHAR](50)
	DECLARE @INPUT_RATE_9			[NUMERIC](20, 10)
	DECLARE @MATERIAL_10			[NVARCHAR](50)
	DECLARE @INPUT_RATE_10			[NUMERIC](20, 10)
	DECLARE @KEY_DATE				[NVARCHAR](12)
	DECLARE @BOM_INSERT_TIME		[DATETIME]
	DECLARE @BATCH_ID				[NVARCHAR](30)
	DECLARE @BATCH_INSERT_TIME		[DATETIME]
	DECLARE @BATCH_CNT				[NUMERIC](10)

	DECLARE @H_MATERIAL_1			[NVARCHAR](50)
	DECLARE @H_INPUT_RATE_1			[NUMERIC](20, 10)
	DECLARE @H_MATERIAL_2			[NVARCHAR](50)
	DECLARE @H_INPUT_RATE_2			[NUMERIC](20, 10)
	DECLARE @H_MATERIAL_3			[NVARCHAR](50)
	DECLARE @H_INPUT_RATE_3			[NUMERIC](20, 10)
	DECLARE @H_MATERIAL_4			[NVARCHAR](50)
	DECLARE @H_INPUT_RATE_4			[NUMERIC](20, 10)
	DECLARE @H_MATERIAL_5			[NVARCHAR](50)
	DECLARE @H_INPUT_RATE_5			[NUMERIC](20, 10)
	DECLARE @H_MATERIAL_6			[NVARCHAR](50)
	DECLARE @H_INPUT_RATE_6			[NUMERIC](20, 10)
	DECLARE @H_MATERIAL_7			[NVARCHAR](50)
	DECLARE @H_INPUT_RATE_7			[NUMERIC](20, 10)
	DECLARE @H_MATERIAL_8			[NVARCHAR](50)
	DECLARE @H_INPUT_RATE_8			[NUMERIC](20, 10)
	DECLARE @H_MATERIAL_9			[NVARCHAR](50)
	DECLARE @H_INPUT_RATE_9			[NUMERIC](20, 10)
	DECLARE @H_MATERIAL_10			[NVARCHAR](50)
	DECLARE @H_INPUT_RATE_10		[NUMERIC](20, 10)

	-- 2017-05-25 PIYONG 메일링을 위한 변수 시작
	DECLARE @V_CheckMail	  NVARCHAR(1) = 'N';
	DECLARE @V_DIVISION_ID	  NVARCHAR(30);
	DECLARE @V_SITE_ID		  NVARCHAR(30);
	DECLARE @V_PLANT_ID		  NVARCHAR(30);
	DECLARE @V_BATCH_ID		  NVARCHAR(30);
	DECLARE @V_ITEM_ID		  NVARCHAR(30);
	DECLARE @V_MAIL			  NVARCHAR(4000);
	DECLARE @MSG			  NVARCHAR(MAX) = '';
	DECLARE @RtnCode            INT
	DECLARE @MAIL_RECEIVER_LIST	NVARCHAR(MAX) = '';
	DECLARE @MAIL_SUBJECT		NVARCHAR(MAX) = '';
	DECLARE @MAIL_BODY			NVARCHAR(MAX) = '';
	-- 2017-05-25 PIYONG 메일링을 위한 변수 끝


	-- 2017-05-25 PIYONG 메일링을 위한 임시 테이블
	DECLARE @vTBL_MAIL_CONTENTS TABLE (
										  V_COMPANY_ID    NVARCHAR(30)
										  ,V_DIVISION_ID  NVARCHAR(30)
										  ,V_SITE_ID	  NVARCHAR(30)
										  ,V_PLANT_ID	  NVARCHAR(30)
										  ,V_BATCH_ID	  NVARCHAR(30)
										  ,V_ITEM_ID	  NVARCHAR(30)
									   )



	DECLARE CUR_BOM CURSOR FOR
		SELECT 	SR.COMPANY_ID
			  , SR.DIVISION_ID
			  , SR.SITE_ID
			  , SR.PLANT_ID
			  , SR.PARENT_ITEM_ID
			  , SR.MATERIAL_1
			  , SR.INPUT_RATE_1
			  , SR.MATERIAL_2
			  , SR.INPUT_RATE_2
			  , SR.MATERIAL_3
			  , SR.INPUT_RATE_3
			  , SR.MATERIAL_4
			  , SR.INPUT_RATE_4
			  , SR.MATERIAL_5
			  , SR.INPUT_RATE_5
			  , SR.MATERIAL_6
			  , SR.INPUT_RATE_6
			  , SR.MATERIAL_7
			  , SR.INPUT_RATE_7
			  , SR.MATERIAL_8
			  , SR.INPUT_RATE_8
			  , SR.MATERIAL_9
			  , SR.INPUT_RATE_9
			  , SR.MATERIAL_10
			  , SR.INPUT_RATE_10
			  , SR.KEY_DATE
			  , SR.BOM_INSERT_TIME
			  , BT.BATCH_ID
			  , BT.INSERT_TIME     AS BATCH_INSERT_TIME
			  , CASE WHEN BT.BATCH_ID IS NOT NULL THEN
					(SELECT COUNT(*)
					 FROM   DBO.SCM_BATCH_M BU WITH(NOLOCK)
					 WHERE  BU.COMPANY_ID  = BT.COMPANY_ID
					 AND	BU.DIVISION_ID = BT.DIVISION_ID
					 AND	BU.SITE_ID     = BT.SITE_ID
					 AND	BU.PLANT_ID    = BT.PLANT_ID
					 AND	BU.BATCH_ID	   = BT.BATCH_ID)
			    ELSE
					0
				END                AS BATCH_CNT
		FROM    SCM_SLURRY_RATE_V SR WITH(NOLOCK)
				LEFT OUTER JOIN SCM_BATCH_M       BT WITH(NOLOCK)
				ON  SR.COMPANY_ID  = BT.COMPANY_ID
				AND SR.DIVISION_ID = BT.DIVISION_ID
				AND SR.SITE_ID     = BT.SITE_ID
				AND SR.PLANT_ID    = BT.PLANT_ID
				AND SR.PARENT_ITEM_ID = BT.ITEM_ID
		ORDER BY SR.[COMPANY_ID]
				,SR.[DIVISION_ID]
				,SR.[SITE_ID]
				,SR.[PLANT_ID]
				,SR.[PARENT_ITEM_ID]
				,BT.[BATCH_ID];

	-- 2017-05-25 PIYONG       SLURRY BATCH 담당자 MAIL 주소 가져오는 CURSOR FP-053
	DECLARE CUR_SLURRY_BATCH_MAIL CURSOR FOR
		SELECT SEGMENT1 AS [DIVISION_ID]
			   , SEGMENT2 AS [SITE_ID]
			   , SEGMENT3 AS [PLANT_ID]
			   , ATTRIBUTE1 AS [MAIL]
		  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
	     WHERE LOOKUP_TYPE_CODE = 'SLURRY_BATCH_MAIL';


	SET @ROWCOUNT = @@ROWCOUNT

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

			-- Main Cursor
			SET @v_temp2 = 'OPEN CUR_BOM Cursor';
			OPEN CUR_BOM;
			FETCH NEXT FROM CUR_BOM INTO	 @COMPANY_ID
											,@DIVISION_ID
											,@SITE_ID
											,@PLANT_ID
											,@PARENT_ITEM_ID
											,@MATERIAL_1
											,@INPUT_RATE_1
											,@MATERIAL_2
											,@INPUT_RATE_2
											,@MATERIAL_3
											,@INPUT_RATE_3
											,@MATERIAL_4
											,@INPUT_RATE_4
											,@MATERIAL_5
											,@INPUT_RATE_5
											,@MATERIAL_6
											,@INPUT_RATE_6
											,@MATERIAL_7
											,@INPUT_RATE_7
											,@MATERIAL_8
											,@INPUT_RATE_8
											,@MATERIAL_9
											,@INPUT_RATE_9
											,@MATERIAL_10
											,@INPUT_RATE_10
											,@KEY_DATE
											,@BOM_INSERT_TIME
											,@BATCH_ID
											,@BATCH_INSERT_TIME
											,@BATCH_CNT;

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @v_temp2 = 'initialize variables';
				SET @H_MATERIAL_1		= '-';
				SET @H_INPUT_RATE_1		= NULL;
				SET @H_MATERIAL_2		= NULL;
				SET @H_INPUT_RATE_2		= NULL;
				SET @H_MATERIAL_3		= NULL;
				SET @H_INPUT_RATE_3		= NULL;
				SET @H_MATERIAL_4		= NULL;
				SET @H_INPUT_RATE_4		= NULL;
				SET @H_MATERIAL_5		= NULL;
				SET @H_INPUT_RATE_5		= NULL;
				SET @H_MATERIAL_6		= NULL;
				SET @H_INPUT_RATE_6		= NULL;
				SET @H_MATERIAL_7		= NULL;
				SET @H_INPUT_RATE_7		= NULL;
				SET @H_MATERIAL_8		= NULL;
				SET @H_INPUT_RATE_8		= NULL;
				SET @H_MATERIAL_9		= NULL;
				SET @H_INPUT_RATE_9		= NULL;
				SET @H_MATERIAL_10		= NULL;
				SET @H_INPUT_RATE_10	= NULL;

				SET @v_temp2 = 'Get history';
				SELECT @H_MATERIAL_1	= [MATERIAL_1]
					 , @H_INPUT_RATE_1	= [INPUT_RATE_1]
					 , @H_MATERIAL_2	= [MATERIAL_2]
					 , @H_INPUT_RATE_2	= [INPUT_RATE_2]
					 , @H_MATERIAL_3	= [MATERIAL_3]
					 , @H_INPUT_RATE_3	= [INPUT_RATE_3]
					 , @H_MATERIAL_4	= [MATERIAL_4]
					 , @H_INPUT_RATE_4	= [INPUT_RATE_4]
					 , @H_MATERIAL_5	= [MATERIAL_5]
					 , @H_INPUT_RATE_5	= [INPUT_RATE_5]
					 , @H_MATERIAL_6	= [MATERIAL_6]
					 , @H_INPUT_RATE_6	= [INPUT_RATE_6]
					 , @H_MATERIAL_7	= [MATERIAL_7]
					 , @H_INPUT_RATE_7	= [INPUT_RATE_7]
					 , @H_MATERIAL_8	= [MATERIAL_8]
					 , @H_INPUT_RATE_8	= [INPUT_RATE_8]
					 , @H_MATERIAL_9	= [MATERIAL_9]
					 , @H_INPUT_RATE_9	= [INPUT_RATE_9]
					 , @H_MATERIAL_10	= [MATERIAL_10]
					 , @H_INPUT_RATE_10 = [INPUT_RATE_10]
				FROM   [DBO].[SCM_SLURRY_RATE_H] WITH(NOLOCK)
				WHERE  [PARENT_ITEM_ID] = @PARENT_ITEM_ID
				AND    [COMPANY_ID]     = @COMPANY_ID
				AND    [DIVISION_ID]    = @DIVISION_ID
				AND    [SITE_ID]        = @SITE_ID
				AND    [PLANT_ID]       = @PLANT_ID;

                SET @v_temp2 = 'compare batch id';
				IF @BATCH_ID IS NOT NULL 
				AND @BATCH_CNT > 1
				AND @BATCH_INSERT_TIME < CONVERT(DATETIME, @KEY_DATE, 112) -- @BOM_INSERT_TIME
				AND CONVERT(DATETIME, @KEY_DATE, 112) <= GETDATE()
				AND @H_MATERIAL_1	  != '-'
				AND (	@H_MATERIAL_1	 != @MATERIAL_1
					 OR @H_INPUT_RATE_1	 != @INPUT_RATE_1
					 OR @H_MATERIAL_2	 != @MATERIAL_2
					 OR @H_INPUT_RATE_2	 != @INPUT_RATE_2
					 OR @H_MATERIAL_3	 != @MATERIAL_3
					 OR @H_INPUT_RATE_3	 != @INPUT_RATE_3
					 OR @H_MATERIAL_4	 != @MATERIAL_4
					 OR @H_INPUT_RATE_4	 != @INPUT_RATE_4
					 OR @H_MATERIAL_5	 != @MATERIAL_5
					 OR @H_INPUT_RATE_5	 != @INPUT_RATE_5
					 OR @H_MATERIAL_6	 != @MATERIAL_6
					 OR @H_INPUT_RATE_6	 != @INPUT_RATE_6
					 OR @H_MATERIAL_7	 != @MATERIAL_7
					 OR @H_INPUT_RATE_7	 != @INPUT_RATE_7
					 OR @H_MATERIAL_8	 != @MATERIAL_8
					 OR @H_INPUT_RATE_8	 != @INPUT_RATE_8
					 OR @H_MATERIAL_9	 != @MATERIAL_9
					 OR @H_INPUT_RATE_9	 != @INPUT_RATE_9
					 OR @H_MATERIAL_10	 != @MATERIAL_10
					 OR @H_INPUT_RATE_10 != @INPUT_RATE_10 )	

					BEGIN
						SET @v_temp2 = 'insert batch history';
						INSERT INTO DBO.HIS_BATCH_M
							([COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[ITEM_ID]
							,[BATCH_ID]
							,[CUD_FLAG]
							,[INSERT_ID]
							,[INSERT_TIME])
						VALUES
							(@COMPANY_ID
							,@DIVISION_ID
							,@SITE_ID
							,@PLANT_ID
							,@PARENT_ITEM_ID
							,@BATCH_ID
							,'D'  -- C Create U update D delete CUD_FLAG
							,@v_proc_name
							,GETDATE());


						--2017-05-25 PIYONG		전자우편 송신을 위한 데이터 생성 FP-053
						INSERT INTO @vTBL_MAIL_CONTENTS(
						    V_COMPANY_ID
							,V_DIVISION_ID
							,V_SITE_ID
							,V_PLANT_ID
							,V_BATCH_ID
							,V_ITEM_ID
						)VALUES(
							@COMPANY_ID
							,@DIVISION_ID
							,@SITE_ID
							,@PLANT_ID
							,@BATCH_ID
							,@PARENT_ITEM_ID
						);
					

						SET @v_temp2 = 'delete batch master';
						DELETE 
						FROM   DBO.SCM_BATCH_M
						WHERE  COMPANY_ID  = @COMPANY_ID
						AND	   DIVISION_ID = @DIVISION_ID
						AND	   SITE_ID     = @SITE_ID
						AND	   PLANT_ID    = @PLANT_ID
						AND	   ITEM_ID     = @PARENT_ITEM_ID
						AND	   BATCH_ID    = @BATCH_ID;
					END;

				SET @v_temp2 = 'compare bom rate';
				IF   (	@H_MATERIAL_1	 != @MATERIAL_1
					 OR @H_INPUT_RATE_1	 != @INPUT_RATE_1
					 OR @H_MATERIAL_2	 != @MATERIAL_2
					 OR @H_INPUT_RATE_2	 != @INPUT_RATE_2
					 OR @H_MATERIAL_3	 != @MATERIAL_3
					 OR @H_INPUT_RATE_3	 != @INPUT_RATE_3
					 OR @H_MATERIAL_4	 != @MATERIAL_4
					 OR @H_INPUT_RATE_4	 != @INPUT_RATE_4
					 OR @H_MATERIAL_5	 != @MATERIAL_5
					 OR @H_INPUT_RATE_5	 != @INPUT_RATE_5
					 OR @H_MATERIAL_6	 != @MATERIAL_6
					 OR @H_INPUT_RATE_6	 != @INPUT_RATE_6
					 OR @H_MATERIAL_7	 != @MATERIAL_7
					 OR @H_INPUT_RATE_7	 != @INPUT_RATE_7
					 OR @H_MATERIAL_8	 != @MATERIAL_8
					 OR @H_INPUT_RATE_8	 != @INPUT_RATE_8
					 OR @H_MATERIAL_9	 != @MATERIAL_9
					 OR @H_INPUT_RATE_9	 != @INPUT_RATE_9
					 OR @H_MATERIAL_10	 != @MATERIAL_10
					 OR @H_INPUT_RATE_10 != @INPUT_RATE_10 )
					 AND CONVERT(DATETIME, @KEY_DATE, 112) <= GETDATE()
					BEGIN
						SET @v_temp2 = 'merge rate history';
						MERGE INTO  [dbo].[SCM_SLURRY_RATE_H] SSR
						USING ( SELECT @COMPANY_ID         AS   [COMPANY_ID]
									  ,@DIVISION_ID        AS   [DIVISION_ID]
									  ,@SITE_ID            AS   [SITE_ID]
									  ,@PLANT_ID           AS   [PLANT_ID]
									  ,@PARENT_ITEM_ID     AS   [PARENT_ITEM_ID]
									  ,@MATERIAL_1         AS   [MATERIAL_1]
									  ,@INPUT_RATE_1       AS   [INPUT_RATE_1]
									  ,@MATERIAL_2         AS   [MATERIAL_2]
									  ,@INPUT_RATE_2       AS   [INPUT_RATE_2]
									  ,@MATERIAL_3         AS   [MATERIAL_3]
									  ,@INPUT_RATE_3       AS   [INPUT_RATE_3]
									  ,@MATERIAL_4         AS   [MATERIAL_4]
									  ,@INPUT_RATE_4       AS   [INPUT_RATE_4]
									  ,@MATERIAL_5         AS   [MATERIAL_5]
									  ,@INPUT_RATE_5       AS   [INPUT_RATE_5]
									  ,@MATERIAL_6         AS   [MATERIAL_6]
									  ,@INPUT_RATE_6       AS   [INPUT_RATE_6]
									  ,@MATERIAL_7         AS   [MATERIAL_7]
									  ,@INPUT_RATE_7       AS   [INPUT_RATE_7]
									  ,@MATERIAL_8         AS   [MATERIAL_8]
									  ,@INPUT_RATE_8       AS   [INPUT_RATE_8]
									  ,@MATERIAL_9         AS   [MATERIAL_9]
									  ,@INPUT_RATE_9       AS   [INPUT_RATE_9]
									  ,@MATERIAL_10        AS   [MATERIAL_10]
									  ,@INPUT_RATE_10      AS   [INPUT_RATE_10]
									  ,@KEY_DATE           AS   [KEY_DATE]
									  ,@BOM_INSERT_TIME    AS   [BOM_INSERT_TIME]
									  ,@BATCH_ID           AS   [BATCH_ID]
									  ,@BATCH_INSERT_TIME  AS   [BATCH_INSERT_TIME]
              			) XXX
						ON (         SSR.COMPANY_ID     = XXX.COMPANY_ID
              					AND  SSR.DIVISION_ID    = XXX.DIVISION_ID
              					AND  SSR.SITE_ID        = XXX.SITE_ID
              					AND  SSR.PLANT_ID       = XXX.PLANT_ID
              					AND  SSR.PARENT_ITEM_ID = XXX.PARENT_ITEM_ID
						)
						WHEN MATCHED THEN
							UPDATE SET [MATERIAL_1]        = XXX.[MATERIAL_1]
									  ,[INPUT_RATE_1]      = XXX.[INPUT_RATE_1]
									  ,[MATERIAL_2]        = XXX.[MATERIAL_2]
									  ,[INPUT_RATE_2]      = XXX.[INPUT_RATE_2]
									  ,[MATERIAL_3]        = XXX.[MATERIAL_3]
									  ,[INPUT_RATE_3]      = XXX.[INPUT_RATE_3]
									  ,[MATERIAL_4]        = XXX.[MATERIAL_4]
									  ,[INPUT_RATE_4]      = XXX.[INPUT_RATE_4]
									  ,[MATERIAL_5]        = XXX.[MATERIAL_5]
									  ,[INPUT_RATE_5]      = XXX.[INPUT_RATE_5]
									  ,[MATERIAL_6]        = XXX.[MATERIAL_6]
									  ,[INPUT_RATE_6]      = XXX.[INPUT_RATE_6]
									  ,[MATERIAL_7]        = XXX.[MATERIAL_7]
									  ,[INPUT_RATE_7]      = XXX.[INPUT_RATE_7]
									  ,[MATERIAL_8]        = XXX.[MATERIAL_8]
									  ,[INPUT_RATE_8]      = XXX.[INPUT_RATE_8]
									  ,[MATERIAL_9]        = XXX.[MATERIAL_9]
									  ,[INPUT_RATE_9]      = XXX.[INPUT_RATE_9]
									  ,[MATERIAL_10]       = XXX.[MATERIAL_10]
									  ,[INPUT_RATE_10]     = XXX.[INPUT_RATE_10]
									  ,[KEY_DATE]          = XXX.[KEY_DATE]
									  ,[BOM_INSERT_TIME]   = XXX.[BOM_INSERT_TIME]
									  ,[BATCH_ID]          = XXX.[BATCH_ID]
									  ,[BATCH_INSERT_TIME] = XXX.[BATCH_INSERT_TIME]
									  ,[UPDATE_ID]         = @v_proc_name
									  ,[UPDATE_TIME]       = GETDATE() 
						WHEN NOT MATCHED THEN
              				INSERT (   [COMPANY_ID]
									  ,[DIVISION_ID]
									  ,[SITE_ID]
									  ,[PLANT_ID]
									  ,[PARENT_ITEM_ID]
									  ,[MATERIAL_1]
									  ,[INPUT_RATE_1]
									  ,[MATERIAL_2]
									  ,[INPUT_RATE_2]
									  ,[MATERIAL_3]
									  ,[INPUT_RATE_3]
									  ,[MATERIAL_4]
									  ,[INPUT_RATE_4]
									  ,[MATERIAL_5]
									  ,[INPUT_RATE_5]
									  ,[MATERIAL_6]
									  ,[INPUT_RATE_6]
									  ,[MATERIAL_7]
									  ,[INPUT_RATE_7]
									  ,[MATERIAL_8]
									  ,[INPUT_RATE_8]
									  ,[MATERIAL_9]
									  ,[INPUT_RATE_9]
									  ,[MATERIAL_10]
									  ,[INPUT_RATE_10]
									  ,[KEY_DATE]
									  ,[BOM_INSERT_TIME]
									  ,[BATCH_ID]
									  ,[BATCH_INSERT_TIME]
									  ,[INSERT_ID]
									  ,[INSERT_TIME]
									  ,[UPDATE_ID]
									  ,[UPDATE_TIME]      
              						)
              				VALUES (   XXX.[COMPANY_ID]
									  ,XXX.[DIVISION_ID]
									  ,XXX.[SITE_ID]
									  ,XXX.[PLANT_ID]
									  ,XXX.[PARENT_ITEM_ID]
									  ,XXX.[MATERIAL_1]
									  ,XXX.[INPUT_RATE_1]
									  ,XXX.[MATERIAL_2]
									  ,XXX.[INPUT_RATE_2]
									  ,XXX.[MATERIAL_3]
									  ,XXX.[INPUT_RATE_3]
									  ,XXX.[MATERIAL_4]
									  ,XXX.[INPUT_RATE_4]
									  ,XXX.[MATERIAL_5]
									  ,XXX.[INPUT_RATE_5]
									  ,XXX.[MATERIAL_6]
									  ,XXX.[INPUT_RATE_6]
									  ,XXX.[MATERIAL_7]
									  ,XXX.[INPUT_RATE_7]
									  ,XXX.[MATERIAL_8]
									  ,XXX.[INPUT_RATE_8]
									  ,XXX.[MATERIAL_9]
									  ,XXX.[INPUT_RATE_9]
									  ,XXX.[MATERIAL_10]
									  ,XXX.[INPUT_RATE_10]
									  ,XXX.[KEY_DATE]
									  ,XXX.[BOM_INSERT_TIME]
									  ,XXX.[BATCH_ID]
									  ,XXX.[BATCH_INSERT_TIME]
									  ,@v_proc_name         
              						  ,GETDATE()            
              						  ,@v_proc_name       
              						  ,GETDATE()       
              						  );
					END;

						   	
				FETCH NEXT FROM CUR_BOM INTO	 @COMPANY_ID
												,@DIVISION_ID
												,@SITE_ID
												,@PLANT_ID
												,@PARENT_ITEM_ID
												,@MATERIAL_1
												,@INPUT_RATE_1
												,@MATERIAL_2
												,@INPUT_RATE_2
												,@MATERIAL_3
												,@INPUT_RATE_3
												,@MATERIAL_4
												,@INPUT_RATE_4
												,@MATERIAL_5
												,@INPUT_RATE_5
												,@MATERIAL_6
												,@INPUT_RATE_6
												,@MATERIAL_7
												,@INPUT_RATE_7
												,@MATERIAL_8
												,@INPUT_RATE_8
												,@MATERIAL_9
												,@INPUT_RATE_9
												,@MATERIAL_10
												,@INPUT_RATE_10
												,@KEY_DATE
												,@BOM_INSERT_TIME
												,@BATCH_ID
												,@BATCH_INSERT_TIME
												,@BATCH_CNT;
			END;
			CLOSE CUR_BOM;
			DEALLOCATE CUR_BOM;      

			--2017-05-25 PIYONG		전자우편 송신을 위한 데이터 생성 시작 FP-053
			SET @v_temp2 = 'CUR_SLURRY_BATCH_MAIL';
			OPEN CUR_SLURRY_BATCH_MAIL;
			FETCH NEXT FROM CUR_SLURRY_BATCH_MAIL INTO @V_DIVISION_ID
													   ,@V_SITE_ID
													   ,@V_PLANT_ID
													   ,@V_MAIL;
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					-- 임시 저장 테이블에서 DIVISION_ID, SITE_ID, PLANT에 속한 BATCH_ID와 ITEM_ID를 가져온다
					DECLARE CUR_MAIL_DATA CURSOR FOR
						  SELECT V_BATCH_ID
								,V_ITEM_ID
							FROM @vTBL_MAIL_CONTENTS
							WHERE V_DIVISION_ID =  @V_DIVISION_ID 
							AND V_SITE_ID =  @V_SITE_ID 
							AND V_PLANT_ID = @V_PLANT_ID
							ORDER BY V_PLANT_ID
								,V_BATCH_ID;


					OPEN CUR_MAIL_DATA;
					FETCH NEXT FROM CUR_MAIL_DATA INTO @V_BATCH_ID
													   ,@V_ITEM_ID;
					WHILE (@@FETCH_STATUS = 0)
					BEGIN
						-- 메일에 표를 보여줄 ROW 데이터를 만든다.
						SET @MSG = @MSG +		'	<tr>'                           +
												'		<td>'						+
																@V_DIVISION_ID      +
												'		</td>'                      +
												'		<td>'						+
																@V_SITE_ID          +
												'		</td>'                      +
												'		<td>'						+
																@V_PLANT_ID         +
												'		</td>'                      +
												'		<td>'						+
																@V_BATCH_ID         +
												'		</td>'                      +
												'		<td>'						+
																@V_ITEM_ID			+
												'		</td>'                      +
												'	</tr>'                          ;

						-- 메일 전송여부를 Y로 설정한다.
						SET @V_CheckMail = 'Y'

						FETCH NEXT FROM CUR_MAIL_DATA INTO @V_BATCH_ID
														   ,@V_ITEM_ID;
					END;
				CLOSE CUR_MAIL_DATA;
				DEALLOCATE CUR_MAIL_DATA;


				SET @v_temp2 = 'SLURRY BATCH MAIL SEND';
				IF @V_CheckMail = 'Y'
					BEGIN
						-- 전송할 메일 기본 정보를 가져온다
						SELECT @MAIL_SUBJECT = [MAIL_SUBJECT]
							   ,@MAIL_BODY = [MAIL_BODY] + '<table width=800 border=1 style=border-collapse:collapse cellpadding=10>' +
														   '	<tr style="FONT-WEIGHT: BOLD;BACKGROUND-COLOR: #f9f9f9;">'            +
														   '		<td>Division</td>'												  +
														   '		<td>Site</td>'													  +
														   '		<td>Plant</td>'													  +
														   '		<td>Batch</td>'													  +
														   '		<td>Parent Material</td>'										  +
														   '	</tr>'																  +
																@MSG																  +
														   '</table>'

							,@MAIL_RECEIVER_LIST = [MAIL_RECEIVER_LIST] + @V_MAIL			
						FROM [SCM_MAILING_LIST_M]
						WHERE MAIL_PKEY = 'FP_MAILING_IF9'

						-- 메일 전송
						EXEC @RTNCODE =  MSDB.DBO.SP_SEND_DBMAIL
											@PROFILE_NAME           = 'FP_MAIL_TEST'
											, @RECIPIENTS             = @MAIL_RECEIVER_LIST
											, @SUBJECT                = @MAIL_SUBJECT
											, @BODY                   = @MAIL_BODY
											; 

						-- 메일 전송 여부를 N으로 변경 , MSG 변수 초기화
						SET @V_CheckMail = 'N';
						SET @MSG = '';

						END


					FETCH NEXT FROM CUR_SLURRY_BATCH_MAIL INTO @V_DIVISION_ID
															   ,@V_SITE_ID
															   ,@V_PLANT_ID
															   ,@V_MAIL ;
				END;
			CLOSE CUR_SLURRY_BATCH_MAIL;
			DEALLOCATE CUR_SLURRY_BATCH_MAIL;
			--2017-05-25 PIYONG		전자우편 송신을 위한 데이터 생성 끝
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp2, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		SELECT ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
