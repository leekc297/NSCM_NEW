
CREATE PROCEDURE [dbo].[PR_XIF_MES_OFF_CALENDAR_S]

-- ================================================================================================
-- Program ID          : FP03580
-- Program Name        : PR_XIF_MES_OFF_CALENDAR_S
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : MES
-- Source Table        : SCM_OFF_CALENDAR_LINE_M, HIS_OFF_CALENDAR_LINE_M, SCM_EQUIPMENT_M
-- 						 SCM_OFF_CALENDAR_LINE_V(2021.03.10)
-- Destination Table   : XIF_MES_OFF_CALENDAR_S
--
-- Create Date		   : 2019.07.31
-- Update Date		   : 2022.08.10

-- Author              : PIYONG
-- Version             : 1.0
--                       2021.04.26   CGJ  통합 CAPA UI 적용 - OFF CALENDAR TABLE을 VIEW TABLE로 변경
--                       2021.06.09   kimis 2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--                                    동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--                                    라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
--                       2022.08.10   kimcd 설비 정보 Option화에 따른 수정
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_OFF_CALENDAR_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	--변수 설정
	DECLARE @ACCUM_DATE	NVARCHAR(14)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			SET @ACCUM_DATE =  REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19), GETDATE(), 120), '-', ''), ':', ''), ' ', '')

			INSERT INTO [SY_XIF_MES_OFF_CALENDAR_S] (
				[IF_SEQ]
				, [IF_TYPE]
				, [IF_ID]
				, [IF_INS_DATE]
				, [IF_FLAG]
				, [OPERATION_ID]
				, [LINE_ID]
				, [OFF_DATE]
				, [OFF_TIME_TERM]
				, [ACCUM_DATE]
				, [ACCUM_COUNT]
				, [INSERT_ID]
				, [INSERT_TIME]
				, [UPDATE_ID]
				, [UPDATE_TIME]
			)
			--2021-06-09 kimis ESNJ 6동 GMES DB 분리에 따른 변경
            SELECT 'OFP0' + SUBSTRING ( CONVERT(NVARCHAR(12), GETDATE(), 112), 3, 6 ) + REPLICATE('0', 10 - LEN( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] ) ) +
			  			    CAST ( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR )
			       ,B.IF_TYPE
			       ,B.IF_ID
			       ,B.IF_INS_DATE
			       ,B.IF_FLAG
			       ,B.OPERATION_ID
			       ,B.LINE_ID
			       ,B.OFF_DATE
			       ,B.OFF_TIME_TERM
			       ,B.ACCUM_DATE
			       ,COUNT(*) OVER (PARTITION BY IF_ID)
			       ,B.INSERT_ID
			       ,B.INSERT_TIME
			       ,B.UPDATE_ID
			       ,B.UPDATE_TIME
	         FROM ( 
	          SELECT --'OFP0' + SUBSTRING ( CONVERT(NVARCHAR(12), GETDATE(), 112), 3, 6 ) + REPLICATE('0', 10 - LEN( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] ) ) +
										-- CAST ( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR ) AS IF_SEQ
					 --	SELECT  ''
							   'S'	AS IF_TYPE
							   /*,'OFP0'+'_'+ISNULL( ( SELECT ISNULL(MES_SOURCE_GROUP,'')
													   FROM SCM_FACTORY_M F WITH (NOLOCK)
													  WHERE F.FACTORY_ID = A.FACTORY_ID ), '' ) +'_'+'FP_OFF_CALENDAR' AS IF_ID */
                               --2021-06-09 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
                               ,'OFP0'+'_'+ISNULL( ( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F WITH(NOLOCK) WHERE F.FACTORY_ID = A.FACTORY_ID)) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = A.FACTORY_ID 
												                                    AND L.LINE_ID = A.LINE_ID ), '' ) +'_'+'FP_OFF_CALENDAR' AS IF_ID    
							   ,GETDATE() AS IF_INS_DATE
							   ,'N' AS IF_FLAG
							   ,OPERATION_ID
							   ,LINE_ID
							   ,CONVERT( NVARCHAR(19), OFF_DATE, 120 ) AS OFF_DATE
							   ,OFF_TIME_TERM
							   ,@ACCUM_DATE AS ACCUM_DATE
							   --,COUNT(*) OVER() AS ACCUM_COUNT
							   ,'PR_XIF_MES_OFF_CALENDAR_S' AS INSERT_ID
							   ,GETDATE() AS INSERT_TIME
							   ,'PR_XIF_MES_OFF_CALENDAR_S' AS UPDATE_ID
							   ,GETDATE() AS UPDATE_TIME
						  FROM (
								SELECT S.FACTORY_ID
									   ,S.OPERATION_ID
									   ,ISNULL(E.MES_LINE_ID, S.LINE_ID) AS LINE_ID
									   ,S.OFF_DATE
									   ,S.OFF_TIME_TERM AS OFF_TIME_TERM
									   ,ROW_NUMBER () OVER ( PARTITION BY S.OPERATION_ID, S.LINE_ID, S.[ELECTRODE_TYPE], S.OFF_DATE
																 ORDER BY S.[UPDATE_TIME] DESC
																												) AS NUM
								  FROM ( 
										SELECT [COMPANY_ID]
											   , [DIVISION_ID]
											   , [SITE_ID]
											   , [PLANT_ID]
											   , [FACTORY_ID]
											   , [OPERATION_ID]
											   , [LINE_ID]
											   , [ELECTRODE_TYPE]
											   , [OFF_DATE]
											   , [OFF_TIME_TERM]
											   , [UPDATE_TIME]
--										  FROM SCM_OFF_CALENDAR_LINE_M WITH (NOLOCK)
										  FROM SCM_OFF_CALENDAR_LINE_V WITH (NOLOCK)							  	    -- 2021.04.26 CGJ 통합 CAPA UI 적용
									     WHERE [OPERATION_ID] LIKE 'P%'													-- PACK공정만 전송
							  			   AND DATEDIFF ( MINUTE , UPDATE_TIME , [dbo].[FN_SITE_TIME]( SITE_ID ) ) < 60	-- LOCAL 시간으로 생성됨
													
									   ) S
									   LEFT OUTER JOIN SCM_LINE_M E -- 2022-08-10 kimcd 기준 정보를 설비에서 라인으로 변경
											   ON S.[COMPANY_ID]	= E.[COMPANY_ID]
											  AND S.[DIVISION_ID]	= E.[DIVISION_ID]
											  AND S.[SITE_ID]		= E.[SITE_ID]
											  AND S.[PLANT_ID]		= E.[PLANT_ID]
											  AND S.[FACTORY_ID]	= E.[FACTORY_ID]
											  AND S.[LINE_ID]		= E.[LINE_ID]
											  AND S.[OPERATION_ID]	= E.[OPERATION_ID]
											  AND S.[ELECTRODE_TYPE] = E.[ELECTRODE_TYPE]
											  AND E.ACTIVE_FLAG = 'Y'
							   ) A
						 WHERE NUM = 1 ) B

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		ROLLBACK TRAN

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
