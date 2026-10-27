
CREATE   PROCEDURE [dbo].[PR_XIF_MES_WO_PEGGING_S]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_MES_WO_PEGGING_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF
-- Source Table        : FP_PRODUCTION_PLAN_EQUIPMENT_R
-- Destination Table   : XIF_MES_WO_PEGGING_S, XIF_ERP_WO_PEGGING_S
--
-- Create(Update) Date : 2019.02.26
-- Author              : 김 석
-- Version             : 1.0
--                       1.1 2017.05.24   FP-058 Pegging 형성 과정 보완. kimcd
--                       1.2 2017.06.23   SEQUENCE 값 추가. kimcd
--                       1.3 2018.03.06   kimcd work order id 채번 rule 변경에 따른 top, back work order id 부여 방식 변경
--                       1.4 2019.02.26   kimcd Pegging 정보 전송에서 선분산 공정 제외
--                       1.5 2019-06-07   kimcd SCM_ITEM_M에 COMPANY_ID 조인 누락에 따른 오류 보완
--                       1.6 2021-06-09   kimis ESNJ 6동 GMES DB 분리에 따른 변경
--                                        동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--                                        라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
--                       1.7 2024-03-18   KIMJS NERP PLANT_ID 변경에 따른 CONVERSION 반영 및 하드코딩 제거
--						 1.8 2025-12-15   yschoithira	[E20251205-001628] ESMI4동 ESS, 자동차 라인 MES DB통합에 따른 기능개선 건
-- ================================================================================================

-- PARAM PLAN_ID
@P_FP_PLAN_ID NVARCHAR(50) = NULL

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_WO_PEGGING_S'
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
	DECLARE @if_id_code             NVARCHAR(50)  = 'OFP0_OSC1_XIF_MES_WO_PEGGING'
	DECLARE @send_if_seq            NVARCHAR(50)
	DECLARE @send_date              NVARCHAR(50)
	DECLARE @if_seq_next            BIGINT


	-- ================================================
    -- Declare end
	-- ================================================

	SET @send_date = 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                     
		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		    SELECT @if_seq_next = NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ]  -- kimcd add 2017-06-23
		
			DELETE FROM [dbo].[SY_XIF_MES_WO_PEGGING_S]
			 WHERE PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
			;

			INSERT INTO [dbo].[SY_XIF_MES_WO_PEGGING_S]
					   ( IF_SEQ
						,IF_TYPE
						,IF_ID
						,IF_INS_DATE
						,IF_FLAG
						,IF_SND_DATE
						,RSLT_IF_SEQ
						,RSLT_PROC_FLAG
						,RSLT_PROC_MSG
						,PLAN_ID
						,PLANT_ID
						,BUILNO
						,LINE_ID
						,OPERATION_ID
						,WO
						,QTY
						,FROM_WO
						,CREATE_PSN_ID
						,CREATE_DATE
						,UPDATE_PSN_ID
						,UPDATE_DATE
						,ATTR_01  -- @if_seq_next kimcd add 2017-06-23
						,ATTR_02
						,ATTR_03
						,ATTR_04
						,ATTR_05
						,ATTR_06
						,ATTR_07
						,ATTR_08
						,ATTR_09
						,ATTR_10)
				SELECT 
				    'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
            ,IF_TYPE
						--2021-06-10 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
			            -- [E20251205-001628] 변경 FACTORY 면 라인이 달라 ISNULL 추가
            ,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = S.BUILNO)) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = S.BUILNO AND L.LINE_ID = S.TO_LINE_ID ), ISNULL( (SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = S.BUILNO), '')) +'_'+'FP_WO_PEGGING' -- IF_ID : S.TO_LINE_ID <- MES LINE
					  ,IF_INS_DATE
					  ,IF_FLAG
					  ,IF_SND_DATE
					  ,RSLT_IF_SEQ
					  ,RSLT_PROC_FLAG
					  ,RSLT_PROC_MSG
					  ,PLAN_ID
					  ,PLANT_ID
					  ,BUILNO
					  ,TO_LINE_ID
					  ,OPERATION_ID
					  ,WO
					  ,PLAN_QTY
					  ,FROM_WO
					  ,CREATE_PSN_ID
					  ,CREATE_DATE
					  ,UPDATE_PSN_ID
					  ,UPDATE_DATE
					  ,ATTR_01
					  ,ATTR_02
					  ,ATTR_03
					  ,ATTR_04
					  ,ATTR_05
					  ,ATTR_06
					  ,ATTR_07
					  ,ATTR_08
					  ,ATTR_09
					  ,ATTR_10
				FROM (			
				SELECT -- 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
				--SELECT ''
					   'S'                AS IF_TYPE
    				 --2021-06-10 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : IF_ID 위로 이동
					   --,'OFP0'+'_'+( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F WITH(NOLOCK)  WHERE F.FACTORY_ID = SOURCES.TO_FACTORY_ID ) +'_'+'FP_WO_PEGGING' -- kimcd FP-058 FROM_FACTORY_ID에서 TO_FACTORY_ID로 변경. 2017-05-28
					   --,@if_id_code			-- IF_ID
					   ,GETDATE()			  AS IF_INS_DATE
					   ,'N'						  AS IF_FLAG
					   ,NULL					  AS IF_SND_DATE
					   ,NULL					  AS RSLT_IF_SEQ
					   ,NULL					  AS RSLT_PROC_FLAG
					   ,NULL					  AS RSLT_PROC_MSG
					   ,FP_PLAN_ID		  AS PLAN_ID
					   ,F.MES_PLANT_ID  AS PLANT_ID -- PLANT_ID -- 2024-04-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
  					   ,F.FACTORY_ID  AS BUILNO -- BUILNO	-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄
					   --	,TO_FACTORY_ID         AS BUILNO  -- kimcd FP-058 FROM_FACTORY_ID에서 TO_FACTORY_ID로 변경. 2017-05-28 -- [E20251205-001628] DEL
					   ,ISNULL(     CASE WHEN B.ATTRIBUTE1 IS NOT NULL THEN
								 (SELECT TOP 1 C.MES_LINE_ID
								  FROM   [dbo].[SCM_EQUIPMENT_M] C WITH(NOLOCK)
								        ,[dbo].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)
								   WHERE C.COMPANY_ID  = B.ATTRIBUTE1
									 AND C.DIVISION_ID = B.ATTRIBUTE2
									 AND C.SITE_ID     = SOURCES.SITE_ID
									 AND C.PLANT_ID    = B.ATTRIBUTE3
									 AND C.EQUIPMENT_ID = A.EQUIPMENT_ID 
							         AND A.WORK_ORDER_ID = SOURCES.TO_WORK_ORDER_ID
									 AND A.FP_PLAN_ID    = SOURCES.FP_PLAN_ID
									 AND C.OPERATION_ID = SOURCES.TO_OPERATION_ID
								 )
							ELSE (SELECT TOP 1 C.MES_LINE_ID  
							        FROM [dbo].[SCM_EQUIPMENT_M] C WITH(NOLOCK)
									    ,[dbo].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)
								   WHERE C.COMPANY_ID  = A.COMPANY_ID
								     AND C.DIVISION_ID = A.DIVISION_ID
								     AND C.SITE_ID     = A.SITE_ID
								     AND C.PLANT_ID    = A.PLANT_ID
								     AND C.EQUIPMENT_ID = A.EQUIPMENT_ID 
									 AND A.WORK_ORDER_ID = SOURCES.TO_WORK_ORDER_ID
								     AND A.FP_PLAN_ID    = SOURCES.FP_PLAN_ID
						             AND C.OPERATION_ID = SOURCES.TO_OPERATION_ID)
								 END 
							  ,SOURCES.TO_LINE_ID   ) AS TO_LINE_ID
					   --,TO_LINE_ID            -- LINE_ID
					   ,TO_OPERATION_ID       AS OPERATION_ID
					   ,TO_WORK_ORDER_ID		  AS WO
					   ,SOURCES.FROM_QTY	    AS PLAN_QTY		-- QTY   -- kimcd FP-058 TO_QTY에서 FROM_QTY로 변경. 2017-05-28
					   --,ISNULL(TO_QTY, 0) AS PLAN_QTY
					   ,SOURCES.FROM_WORK_ORDER_ID	 AS FROM_WO
					   ,'PR_XIF_MES_WO_PEGGING_S'    AS CREATE_PSN_ID
					   ,GETDATE()				             AS CREATE_DATE
					   ,'PR_XIF_MES_WO_PEGGING_S'    AS UPDATE_PSN_ID
					   ,GETDATE()          AS UPDATE_DATE
					   ,@if_seq_next       AS ATTR_01  --@if_seq_next kimcd add 2017-06-23
					   ,NULL               AS ATTR_02
					   ,NULL               AS ATTR_03
					   ,NULL               AS ATTR_04
					   ,NULL               AS ATTR_05
					   ,NULL               AS ATTR_06
					   ,NULL               AS ATTR_07
					   ,NULL               AS ATTR_08
					   ,NULL               AS ATTR_09
					   ,NULL               AS ATTR_10
				  FROM FP_ORDER_PEGGING_R SOURCES WITH(NOLOCK)
  					   LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  B WITH(NOLOCK)
						    ON  B.LOOKUP_TYPE_CODE = 'BOM_ADD_FOR_RES_SHARE'
						    AND B.SEGMENT1         = SOURCES.PLANT_ID
						    AND B.ACTIVE_FLAG      = 'Y'
                      INNER JOIN FP_MES_FACTORY_M_V F WITH(NOLOCK)			-- [E20251205-001628] VIEW 변경 
                            ON  F.COMPANY_ID = SOURCES.COMPANY_ID
                            AND F.ORG_FACTORY_ID = SOURCES.FROM_FACTORY_ID  -- 2024-03-18 NERP PLANT_ID 변경에 따른 CONVERSION 반영 -- [E20251205-001628] Column 변경 
				  --AND SOURCES.FP_PLAN_ID LIKE '%99'
				 WHERE SOURCES.FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
				   /* kimcd FP-058 정보 형성되지 않아 아래 문장 제거함. 2017-05-28
				    and SOURCES.TO_LINE_ID <> '-' -- 2017.02.27 add to_line_id가 '-'이면 top wo 임.
				    AND sources.from_factory_id != '-' -- 2017.03.24 add from_factory_id가 '-'이면 하위 자재로. IF_ID가 형성되지 않아 오류 발생함
					*/
				 AND   sources.to_factory_id != '-' -- kimcd FP-058 to factory 기반으로 수정 2017-05-28
				 AND   SOURCES.FROM_OPERATION_ID NOT IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'OPERATION_A' AND ACTIVE_FLAG = 'Y') ) S  -- 2019-02-26 kimcd 선분산 공정 Pegging 정보 제거  -- 2024-03-18 OPERATION_ID E0500 하드코딩 제거
			    ;

			-- kimcd FP-058 top work order pegging 2017-05-30 시작
			INSERT INTO [dbo].[SY_XIF_MES_WO_PEGGING_S]
					   ( IF_SEQ
						,IF_TYPE
						,IF_ID
						,IF_INS_DATE
						,IF_FLAG
						,IF_SND_DATE
						,RSLT_IF_SEQ
						,RSLT_PROC_FLAG
						,RSLT_PROC_MSG
						,PLAN_ID
						,PLANT_ID
						,BUILNO
						,LINE_ID
						,OPERATION_ID
						,WO
						,QTY
						,FROM_WO
						,CREATE_PSN_ID
						,CREATE_DATE
						,UPDATE_PSN_ID
						,UPDATE_DATE
						,ATTR_01   -- @if_seq_next kimcd add 2017-06-23
						,ATTR_02
						,ATTR_03
						,ATTR_04
						,ATTR_05
						,ATTR_06
						,ATTR_07
						,ATTR_08
						,ATTR_09
						,ATTR_10)
				  SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   AS IF_SEQ
						,IF_TYPE
						--2021-06-10 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
						-- [E20251205-001628] 변경 FACTORY 면 라인이 달라 ISNULL 추가
            ,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = BASE.BUILNO)) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = BASE.BUILNO AND L.LINE_ID = BASE.LINE_ID ), ISNULL( (SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = BASE.BUILNO), ''))  +'_'+'FP_WO_PEGGING' -- IF_ID : BASE.LINE_ID <- MES LINE
						,IF_INS_DATE
						,IF_FLAG
						,IF_SND_DATE
						,RSLT_IF_SEQ
						,RSLT_PROC_FLAG
						,RSLT_PROC_MSG
						,PLAN_ID
						,PLANT_ID
						,BUILNO
						,LINE_ID
						,OPERATION_ID
						,WO
						,QTY
						,FROM_WO
						,CREATE_PSN_ID
						,CREATE_DATE
						,UPDATE_PSN_ID
						,UPDATE_DATE
						,ATTR_01   -- @if_seq_next kimcd add 2017-06-23
						,ATTR_02
						,ATTR_03
						,ATTR_04
						,ATTR_05
						,ATTR_06
						,ATTR_07
						,ATTR_08
						,ATTR_09
						,ATTR_10
				  FROM (SELECT  'S'                AS IF_TYPE
    						 --2021-06-10 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : IF_ID 위로 이동
							   --,'OFP0'+'_'+( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F WITH(NOLOCK)  WHERE F.FACTORY_ID = SOURCES.TO_FACTORY_ID ) +'_'+'FP_WO_PEGGING' AS IF_ID -- kimcd FP-058 FROM_FACTORY_ID에서 TO_FACTORY_ID로 변경. 2017-05-28
							   ,GETDATE()				AS IF_INS_DATE
							   ,'N'						AS IF_FLAG
							   ,NULL					AS IF_SND_DATE
							   ,NULL					AS RSLT_IF_SEQ
							   ,NULL					AS RSLT_PROC_FLAG
							   ,NULL					AS RSLT_PROC_MSG
							   ,SOURCES.FP_PLAN_ID		AS PLAN_ID
							   ,F.MES_PLANT_ID	   	    AS PLANT_ID -- 2024-03-18 NERP PLANT_ID 변경에 따른 CONVERSION 반영
							   ,F.FACTORY_ID  			AS BUILNO		-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄
							    --,SOURCES.TO_FACTORY_ID   AS BUILNO  -- kimcd FP-058 FROM_FACTORY_ID에서 TO_FACTORY_ID로 변경. 2017-05-28	-- [E20251205-001628] 변경
							   ,MAX(ISNULL(EQP.MES_LINE_ID, SOURCES.TO_LINE_ID)) AS LINE_ID
							   ,SOURCES.TO_OPERATION_ID     AS OPERATION_ID
							   ,RTRIM ( CASE WHEN MAX(EQPC.SEGMENT1) IS NOT NULL AND MAX(IMC.SEGMENT1) IS NOT NULL THEN
											CASE WHEN SOURCES.TO_WORK_ORDER_ID LIKE 'W%' OR SOURCES.TO_WORK_ORDER_ID LIKE 'M%' THEN
												SUBSTRING(SOURCES.TO_WORK_ORDER_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.TO_WORK_ORDER_ID,6,2)) + 50) + SUBSTRING(SOURCES.TO_WORK_ORDER_ID,8,10)
											WHEN SUBSTRING(SOURCES.TO_WORK_ORDER_ID,9,1) = '0' THEN
												CASE WHEN SUBSTRING(SOURCES.TO_WORK_ORDER_ID,6,1) = 'X' THEN
													SUBSTRING(SOURCES.TO_WORK_ORDER_ID,1,5) + 'Y' + SUBSTRING(SOURCES.TO_WORK_ORDER_ID,7,10)
												ELSE
													SUBSTRING(SOURCES.TO_WORK_ORDER_ID,1,4) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.TO_WORK_ORDER_ID,5,2)) + 50) + SUBSTRING(SOURCES.TO_WORK_ORDER_ID,7,10)
												END
											ELSE
												CASE WHEN SUBSTRING(SOURCES.TO_WORK_ORDER_ID,7,1) = 'X' THEN
													SUBSTRING(SOURCES.TO_WORK_ORDER_ID,1,6) + 'Y' + SUBSTRING(SOURCES.TO_WORK_ORDER_ID,8,10)
												ELSE
													SUBSTRING(SOURCES.TO_WORK_ORDER_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.TO_WORK_ORDER_ID,6,2)) + 50) + SUBSTRING(SOURCES.TO_WORK_ORDER_ID,8,10)
												END
											END -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 TOP, Back 로직 WO 로직 수정
										END) AS WO
							   ,MAX(SOURCES.FROM_QTY)		AS QTY		-- QTY   -- kimcd FP-058 TO_QTY에서 FROM_QTY로 변경. 2017-05-28
							   ,SOURCES.FROM_WORK_ORDER_ID  AS FROM_WO
							   ,'PR_XIF_MES_WO_PEGGING_S'   AS CREATE_PSN_ID
							   ,GETDATE()					AS CREATE_DATE
							   ,'PR_XIF_MES_WO_PEGGING_S'   AS UPDATE_PSN_ID
							   ,GETDATE()          AS UPDATE_DATE
							   ,@if_seq_next       AS ATTR_01    -- @if_seq_next kimcd add 2017-06-23
							   ,NULL               AS ATTR_02
							   ,NULL               AS ATTR_03
							   ,NULL               AS ATTR_04
							   ,NULL               AS ATTR_05
							   ,NULL               AS ATTR_06
							   ,NULL               AS ATTR_07
							   ,NULL               AS ATTR_08
							   ,NULL               AS ATTR_09
							   ,NULL               AS ATTR_10
						  FROM [DBO].[FP_ORDER_PEGGING_R] SOURCES WITH(NOLOCK)
                              INNER JOIN FP_MES_FACTORY_M_V F WITH(NOLOCK)		-- [E20251205-001628] VIEW 변경 
                                ON  F.COMPANY_ID = SOURCES.COMPANY_ID
                                AND F.ORG_FACTORY_ID = SOURCES.FROM_FACTORY_ID   -- 2024-03-18 NERP PLANT_ID 변경에 따른 CONVERSION 반영 -- [E20251205-001628] column 변경 
                              ,[DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] PPE WITH(NOLOCK)
								LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]  EQP WITH(NOLOCK)
								ON  EQP.EQUIPMENT_ID = PPE.EQUIPMENT_ID
								AND EQP.OPERATION_ID = PPE.OPERATION_ID
								AND EQP.FACTORY_ID   = PPE.FACTORY_ID
								AND EQP.EQUIPMENT_TYPE = 'M'
								AND EQP.ACTIVE_FLAG    = 'Y'
								LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
								ON  EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
								AND EQPC.SEGMENT1         = EQP.OPERATION_ID
								AND EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
								AND EQPC.ACTIVE_FLAG      = 'Y'
								LEFT OUTER JOIN [DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
								ON  IM.DIVISION_ID  = PPE.DIVISION_ID
								AND IM.SITE_ID      = PPE.SITE_ID
								AND IM.ITEM_ID      = PPE.ITEM_ID
								AND IM.COMPANY_ID   = PPE.COMPANY_ID  -- 2019-06-07 kimcd error fix.
								LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
								ON  IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
								AND IMC.SEGMENT1         = IM.ITEM_CLASS
								AND IMC.ACTIVE_FLAG      = 'Y'
						 WHERE SOURCES.FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
						 AND   sources.to_factory_id != '-' -- kimcd FP-058 to factory 기반으로 수정 2017-05-28
						 AND   SOURCES.FROM_OPERATION_ID NOT IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'OPERATION_A' AND ACTIVE_FLAG = 'Y')  -- 2019-02-26 kimcd 선분산 공정 Pegging 정보 제거  -- 2024-03-18 OPERATION_ID E0500 하드코딩 제거
						 AND   PPE.WORK_ORDER_ID  = SOURCES.TO_WORK_ORDER_ID
						 AND   PPE.FP_PLAN_ID     = SOURCES.FP_PLAN_ID
						 AND   PPE.OPERATION_ID   = SOURCES.TO_OPERATION_ID
						 GROUP BY F.FACTORY_ID		-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄
						 			--	SOURCES.TO_FACTORY_ID	-- [E20251205-001628] 변경
								 ,SOURCES.FP_PLAN_ID
								 ,F.MES_PLANT_ID  -- 2024-03-18 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
								 ,SOURCES.TO_OPERATION_ID
								 ,SOURCES.TO_WORK_ORDER_ID
								 ,SOURCES.FROM_WORK_ORDER_ID ) BASE
				 WHERE BASE.WO IS NOT NULL;
			-- kimcd FP-058 top work order pegging 2017-05-30 끝

			--SET @ROWCOUNT = @@ROWCOUNT
			--EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

			DELETE FROM [dbo].[SY_XIF_ERP_WO_PEGGING_S]
			 WHERE PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
			;

			--UPDATE [dbo].[XIF_ERP_WO_PEGGING_S] SET TRANSFER_FLAG = 'Y'
			INSERT INTO [dbo].[SY_XIF_ERP_WO_PEGGING_S]
						([IFSEQNO]
						,[PLAN_ID]
						,[PLANT_ID]
						,[BUILNO]
						,[LINE_ID]
						,[OPERATION_ID]
						,[WO]
						,[QTY]
						,[FROM_WO]
						,[CREATE_PSN_ID]
						,[CREATE_DATE]
						,[UPDATE_PSN_ID]
						,[UPDATE_DATE]
						,[ATTR_01]
						,[ATTR_02]
						,[ATTR_03]
						,[ATTR_04]
						,[ATTR_05]
						,[ATTR_06]
						,[ATTR_07]
						,[ATTR_08]
						,[ATTR_09]
						,[ATTR_10]
						,[TRANSFER_FLAG]
						,[TRANSFER_DATE])
				 SELECT REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(50), CAST(GETDATE() AS DATETIME), 120), '-', ''), ' ', ''), ':', '') AS IFSEQNO
					    ,FP_PLAN_ID                   -- PLAN_ID     
					    ,PLANT_ID                     -- PLANT_ID    
					    ,TO_FACTORY_ID                -- BUILNO      
					    ,TO_LINE_ID                   -- LINE_ID     
					    ,TO_OPERATION_ID              -- OPERATION_ID
					    ,TO_WORK_ORDER_ID             -- WO          
					    ,SOURCES.FROM_QTY             -- QTY -- kimcd FP-058 TO_QTY에서 FROM_QTY로 변경. 2017-05-28
						--,0 AS PLAN_QTY
					    ,FROM_WORK_ORDER_ID           -- FROM_WO     
					    ,'PR_XIF_MES_WO_PEGGING_S'
					    ,GETDATE()          
					    ,'PR_XIF_MES_WO_PEGGING_S'
					    ,GETDATE()          
					    ,NULL               
					    ,NULL               
					    ,NULL               
					    ,NULL               
					    ,NULL               
					    ,NULL               
					    ,NULL               
					    ,NULL               
					    ,NULL               
					    ,NULL               
					    ,'N'
					    ,NULL
				 FROM FP_ORDER_PEGGING_R SOURCES WITH(NOLOCK)
				WHERE SOURCES.FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
				AND   SOURCES.FROM_OPERATION_ID NOT IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'OPERATION_A' AND ACTIVE_FLAG = 'Y')  -- 2019-02-26 kimcd 선분산 공정 Pegging 정보 제거  -- 2024-03-18 OPERATION_ID E0500 하드코딩 제거
			;

			SET @ROWCOUNT = @@ROWCOUNT

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
