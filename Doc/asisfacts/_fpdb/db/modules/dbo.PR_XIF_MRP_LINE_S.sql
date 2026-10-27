
CREATE PROCEDURE [dbo].[PR_XIF_MRP_LINE_S]
-- ================================================================================================
-- Program ID          : FP02492
-- Program Name        : PR_XIF_MRP_LINE_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP
-- Destination System  : MRP
-- Source Table        : SCM_LINE_M, SCM_EQUIPMENT_M
-- Destination Table   : XIF_MRP_LINE_S
--
-- Create(Update) Date : 2022.12.01
-- Author              : 김 춘 동
-- Version             : 1.1
--                       2018.05.22 Work Center 정보 추출에서 ELECTRODE_TYPE 값 제거. - 라인 공정 기준으로 동일한 값 추출하도록..
--                                  Order by 절에서 Y가 나중에 나오도록 함. Y가 갱신될 수 있도록..
--                       2022.08.10 kimcd 설비 정보 Option에 따라 ERP Work Center를 라인 Master에서 전송
--                       2022-12-01 kimcd 라인 정보 전송에서 Electrode 정보 추가
--                       2023-06-26 FP Pjt. MES LINE ID 추가
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MRP_LINE_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER       = 0

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE CUR_MRP_LINE CURSOR FOR
	SELECT 	 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MRP_SEND_SEQ] OVER (ORDER BY B.PLANT_ID ,B.OPERATION_ID ,B.FACTORY_ID ,B.LINE_ID ,B.ACTIVE_FLAG ))) + CAST( NEXT VALUE FOR [dbo].[XIF_MRP_SEND_SEQ] OVER (ORDER BY B.PLANT_ID ,B.OPERATION_ID ,B.FACTORY_ID ,B.LINE_ID ,B.ACTIVE_FLAG ) AS NVARCHAR)  AS IF_SEQ
			,B.IF_TYPE
			,B.IF_ID
			,B.IF_INS_DATE
			,B.IF_FLAG
			,B.IF_SND_DATE
			,B.PLANT_ID
			,B.OPERATION_ID
			,B.FACTORY_ID
			,B.LINE_ID
			,B.WORK_CENTER_ID
			,B.OPERATION_NAME
			,B.FACTORY_NAME
			,B.LINE_NAME
			,B.ACTIVE_FLAG
			,B.ELECTRODE_TYPE -- 2022-12-01 kimcd 라인 정보 전송에서 Electrode 정보 추가
			,B.MES_LINE_ID
	FROM   ( SELECT  DISTINCT 
					 'I'                       IF_TYPE
					,'OFP0_OMRP_MRP_LINE_M'    IF_ID
					,GETDATE()                 IF_INS_DATE
					,'N'                       IF_FLAG
					,NULL                      IF_SND_DATE
					,L.PLANT_ID
					,L.OPERATION_ID
					,L.FACTORY_ID
					,L.LINE_ID
					/* 2022-08-10 kimcd 설비 정보 Option화에 따라 조회문 막음
					,(SELECT TOP 1 E1.WORK_CENTER_ID
						FROM   [DBO].[SCM_EQUIPMENT_M]       E1 WITH(NOLOCK)
						WHERE  E1.COMPANY_ID   = L.COMPANY_ID
						AND    E1.DIVISION_ID  = L.DIVISION_ID
						AND    E1.SITE_ID      = L.SITE_ID
						AND    E1.PLANT_ID     = L.PLANT_ID
						AND    E1.FACTORY_ID   = L.FACTORY_ID
						AND    E1.OPERATION_ID = L.OPERATION_ID
						AND    E1.LINE_ID      = L.LINE_ID
						-- AND    ISNULL(E1.ELECTRODE_TYPE,'-') = L.ELECTRODE_TYPE 2018-05-22 kimcd ELECTRODE_TYPE 조건 제거 모두 같은 값이 오도록..
						AND    E1.WORK_CENTER_ID IS NOT NULL -- 2018-05-22 kimcd WORK CENTER 값이 있는 경우만 조회..
						AND    E1.EQUIPMENT_TYPE = 'M'
						ORDER  BY E1.ACTIVE_FLAG DESC, E1.EQUIPMENT_ID) AS WORK_CENTER_ID */
					,L.WORK_CENTER_ID   -- 2022-08-10 kimcd Line Master의 ERP Work Center 사용
					,O.OPERATION_NAME
					,F.FACTORY_NAME
					,L.LINE_NAME
					,L.ACTIVE_FLAG
					,L.ELECTRODE_TYPE -- 2022-12-01 kimcd 라인 정보 전송에서 Electrode 정보 추가
					,L.MES_LINE_ID   --2023-06-26 FP Pjt. MRP 추가 요청
			 FROM   [DBO].[SCM_FACTORY_M]    F WITH(NOLOCK)
				,	[DBO].[SCM_OPERATION_M]  O WITH(NOLOCK)
				,	[DBO].[SCM_LINE_M]       L WITH(NOLOCK)
			WHERE   F.COMPANY_ID   = L.COMPANY_ID
			AND     F.DIVISION_ID  = L.DIVISION_ID
			AND     F.SITE_ID      = L.SITE_ID
			AND     F.PLANT_ID     = L.PLANT_ID
			AND     F.FACTORY_ID   = L.FACTORY_ID
			AND     O.COMPANY_ID   = L.COMPANY_ID
			AND     O.DIVISION_ID  = L.DIVISION_ID
			AND     O.SITE_ID      = L.SITE_ID
			AND     O.OPERATION_ID = L.OPERATION_ID
			AND     L.UPDATE_TIME >= DATEADD(DD, -1, GETDATE()) 
			
			) B
			ORDER BY B.PLANT_ID
					,B.OPERATION_ID
					,B.FACTORY_ID
					,B.LINE_ID
					,B.ELECTRODE_TYPE -- 2022-12-01 kimcd 라인 정보 전송에서 Electrode 정보 추가
					,B.ACTIVE_FLAG  -- 2018-05-22 kimcd Y값이 나중에 조회되도록 Order by 지정

	DECLARE @IF_SEQ         [NVARCHAR](50)
	DECLARE @IF_TYPE        [NVARCHAR](1)
	DECLARE @IF_ID          [NVARCHAR](50)
	DECLARE @IF_INS_DATE    [DATETIME]
	DECLARE @IF_FLAG        [NVARCHAR](1)
	DECLARE @IF_SND_DATE    [DATETIME]
	DECLARE @PLANT_ID       [NVARCHAR](50)
	DECLARE @OPERATION_ID   [NVARCHAR](50)
	DECLARE @FACTORY_ID     [NVARCHAR](50)
	DECLARE @LINE_ID        [NVARCHAR](50)
	DECLARE @WORK_CENTER_ID [NVARCHAR](50)
	DECLARE @OPERATION_NAME [NVARCHAR](200)
	DECLARE @FACTORY_NAME   [NVARCHAR](200)
	DECLARE @LINE_NAME      [NVARCHAR](200)
	DECLARE @ACTIVE_FLAG    [NVARCHAR](1)
	DECLARE @ELECTRODE_TYPE [NVARCHAR](50)  -- 2022-12-01 kimcd 라인 정보 전송에서 Electrode 정보 추가
	DECLARE @MES_LINE_ID    [nvarchar](30)
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
		-- Current 기준 유효한 LINE 정보 전송
		OPEN CUR_MRP_LINE

        FETCH NEXT FROM CUR_MRP_LINE INTO @IF_SEQ
										 ,@IF_TYPE
										 ,@IF_ID
										 ,@IF_INS_DATE
										 ,@IF_FLAG
										 ,@IF_SND_DATE
										 ,@PLANT_ID
										 ,@OPERATION_ID
										 ,@FACTORY_ID
										 ,@LINE_ID
										 ,@WORK_CENTER_ID
										 ,@OPERATION_NAME
										 ,@FACTORY_NAME
										 ,@LINE_NAME
										 ,@ACTIVE_FLAG
										 ,@ELECTRODE_TYPE  -- 2022-12-01 kimcd 라인 정보 전송에서 Electrode 정보 추가
										 ,@MES_LINE_ID
										 ;

        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
			MERGE INTO  [dbo].[SY_XIF_MRP_LINE_S] M
			USING ( SELECT   @IF_SEQ		  AS IF_SEQ
							,@IF_TYPE         AS IF_TYPE
							,@IF_ID           AS IF_ID
							,@IF_INS_DATE     AS IF_INS_DATE
							,@IF_FLAG         AS IF_FLAG
							,@IF_SND_DATE     AS IF_SND_DATE
							,@PLANT_ID        AS PLANT_ID
							,@OPERATION_ID    AS OPERATION_ID
							,@FACTORY_ID      AS FACTORY_ID
							,@LINE_ID         AS LINE_ID
							,@WORK_CENTER_ID  AS WORK_CENTER_ID
							,@OPERATION_NAME  AS OPERATION_NAME
							,@FACTORY_NAME    AS FACTORY_NAME
							,@LINE_NAME       AS LINE_NAME
							,@ACTIVE_FLAG     AS ACTIVE_FLAG
							,@ELECTRODE_TYPE  AS ELECTRODE_TYPE  -- 2022-12-01 kimcd 라인 정보 전송에서 Electrode 정보 추가
							,@MES_LINE_ID     AS MES_LINE_ID
							) B
			ON (	M.[PLANT_ID]     = B.[PLANT_ID]
				AND M.[OPERATION_ID] = B.[OPERATION_ID]
				AND M.[FACTORY_ID]	 = B.[FACTORY_ID]
				AND M.[LINE_ID]		 = B.[LINE_ID]
				AND M.[ATTR_01]      = B.[ELECTRODE_TYPE] ) -- 2022-12-01 kimcd 라인 정보 전송에서 Electrode 정보 추가
			WHEN MATCHED THEN
				UPDATE SET M.[IF_SEQ]         = B.[IF_SEQ]
						 , M.[IF_TYPE]        = B.[IF_TYPE]
						 , M.[IF_ID]          = B.[IF_ID]
						 , M.[IF_INS_DATE]    = B.[IF_INS_DATE]
						 , M.[IF_FLAG]        = B.[IF_FLAG]
						 , M.[IF_SND_DATE]    = B.[IF_SND_DATE]
						 , M.[WORK_CENTER_ID] = B.[WORK_CENTER_ID]
						 , M.[OPERATION_NAME] = B.[OPERATION_NAME]
						 , M.[FACTORY_NAME]   = B.[FACTORY_NAME]
						 , M.[LINE_NAME]      = B.[LINE_NAME]
						 , M.[ACTIVE_FLAG]    = B.[ACTIVE_FLAG]
						 , M.ATTR_02          = B.MES_LINE_ID
			WHEN NOT MATCHED THEN			
				INSERT ( IF_SEQ
						,IF_TYPE
						,IF_ID
						,IF_INS_DATE
						,IF_FLAG
						,IF_SND_DATE
						,PLANT_ID
						,OPERATION_ID
						,FACTORY_ID
						,LINE_ID
						,WORK_CENTER_ID
						,OPERATION_NAME
						,FACTORY_NAME
						,LINE_NAME
						,ACTIVE_FLAG
						,ATTR_01   -- 2022-12-01 kimcd 라인 정보 전송에서 Electrode 정보 추가
						,ATTR_02
						)  
				VALUES ( B.IF_SEQ
						,B.IF_TYPE
						,B.IF_ID
						,B.IF_INS_DATE
						,B.IF_FLAG
						,B.IF_SND_DATE
						,B.PLANT_ID
						,B.OPERATION_ID
						,B.FACTORY_ID
						,B.LINE_ID
						,B.WORK_CENTER_ID
						,B.OPERATION_NAME
						,B.FACTORY_NAME
						,B.LINE_NAME
						,B.ACTIVE_FLAG
						,B.ELECTRODE_TYPE -- 2022-12-01 kimcd 라인 정보 전송에서 Electrode 정보 추가
						,B.MES_LINE_ID
						);

			SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
			FETCH NEXT FROM CUR_MRP_LINE INTO @IF_SEQ
											 ,@IF_TYPE
											 ,@IF_ID
											 ,@IF_INS_DATE
											 ,@IF_FLAG
											 ,@IF_SND_DATE
											 ,@PLANT_ID
											 ,@OPERATION_ID
											 ,@FACTORY_ID
											 ,@LINE_ID
											 ,@WORK_CENTER_ID
											 ,@OPERATION_NAME
											 ,@FACTORY_NAME
											 ,@LINE_NAME
											 ,@ACTIVE_FLAG
											 ,@ELECTRODE_TYPE   -- 2022-12-01 kimcd 라인 정보 전송에서 Electrode 정보 추가
											 ,@MES_LINE_ID
											 ;

		END;  -- WHILE @@FETCH_STATUS = 0
        CLOSE CUR_MRP_LINE;
        DEALLOCATE CUR_MRP_LINE;   -- 메모리 해제

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


