
CREATE PROCEDURE [dbo].[PR_XIF_DW_WIP_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_DW_WIP_R
-- Param               :
-- Batch Period        : 1Day
-- Description         : FP00900 재고 정보 전환
--
-- Source System       : DW MES
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_WIP_R
-- Destination Table   : SCM_STOCK_H
--
-- Create Date		   : 2016.08.16
-- Update Date		   : 2017.04.11 1.1
--						 2017.04.11 1.2
--						 2017.04.12 1.3
--						 2017.04.14 2.0
-- Author              : 김 석
-- Version             : 1.0
--						 1.1 WIPHOLD_YN 컬럼 추가 저장
--						 1.2 WIPHOLD_YN 컬럼 추가 저장,  STOCK_STATUS = 'PROC' 이면 FP_APPLY_WIPQTY 값은 0
--                       1.3 FP_APPLY_OPERATION_ID 조회 값 변경
--                       2.0 조회쿼리 변경
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
-- ================================================================================================

-- PARAMETER
@P_SITE_ID NVARCHAR(50) = 'NULL',
@P_IFSEQNO NVARCHAR(50) = 'NULL'


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_WIP_R'
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
		
		--UPDATE [LGCE_INF].[dbo].[XIF_DW_WIP_R] SET TRANSFER_FLAG = 'N' WHERE IFSEQNO = '20161111120010'
		IF @P_IFSEQNO = 'NULL' OR @P_IFSEQNO IS NULL
		   SET @P_IFSEQNO = (SELECT MAX(IFSEQNO) FROM [dbo].[SY_XIF_DW_WIP_SUMMARY_R] WITH(NOLOCK)
							  WHERE TRANSFER_FLAG = 'N'
							)

		UPDATE [dbo].[SY_XIF_DW_WIP_SUMMARY_R]
		   SET TRANSFER_FLAG = 'P'
	     WHERE IFSEQNO       = @P_IFSEQNO
		   AND TRANSFER_FLAG = 'N'
		;

		-- CUTOFF_DATE 기준으로 삭제, 'MES' 조건추가
		--SELECT DISTINCT SITE_ID FROM [dbo].[SCM_STOCK_H]
		DELETE FROM [dbo].[SCM_STOCK_H]
         WHERE CUTOFF_DATE IN ( SELECT DISTINCT CAST(A.[WORKDATE] AS DATE) AS CUTOFF_DATE
		                          FROM [dbo].[SY_XIF_DW_WIP_SUMMARY_R] A WITH(NOLOCK)
	                             WHERE IFSEQNO       = @P_IFSEQNO
		                           AND TRANSFER_FLAG = 'P'
			                 )
		   AND STORAGE_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_DW_WIP_R' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')
		   AND SITE_ID    = case when @P_SITE_ID = 'NULL' OR @P_IFSEQNO IS NULL then SITE_ID else @P_SITE_ID end
		   AND UPDATE_ID  = 'PR_XIF_DW_WIP_R'
		;

		INSERT INTO [dbo].[SCM_STOCK_H]
				   ([COMPANY_ID]
				   ,[DIVISION_ID]
				   ,[SITE_ID]
				   ,[PLANT_ID]
				   ,[FACTORY_ID]
				   ,[STORAGE_ID]
				   ,[CUTOFF_DATE]
				   ,[SEQ]
				   ,[STOCK_TYPE]
				   ,[ITEM_ID]
				   ,[PRODUCTION_TYPE]
				   ,[AVAILABLE_DATE]
				   ,[REMAIN_LEAD_TIME]
				   ,[HOLDING_DATE]
				   ,[QTY]
				   ,[QTY_UOM]
				   ,[STOCK_STATUS]
				   ,[OPERATION_ID]
				   ,[LANE]
				   ,[LINE_ID]
				   ,[OUTSOURCING_FLAG]
				   ,[OUTSOURCING_FACTORY]
				   ,[DESCRIPTION]
				   ,[FP_APPLY_OPERATION_ID]
				   ,[FP_APPLY_ITEM_ID]
				   ,[FP_APPLY_WIPQTY]
				   ,[WIPHOLD_YN]
				   ,[INSERT_ID]
				   ,[INSERT_TIME]
				   ,[UPDATE_ID]
				   ,[UPDATE_TIME]) 
            SELECT A.[COMPANY_ID]
				   ,A.[DIVISION_ID]
				   ,A.[SITE_ID]
				   ,A.[PLANT_ID]
				   ,A.[FACTORY_ID]
				   ,A.[STORAGE_ID]
				   ,A.[CUTOFF_DATE]
				   ,A.[SEQ]
				   ,A.[STOCK_TYPE]
				   ,A.[ITEM_ID]
				   ,A.[PRODUCTION_TYPE]
				   ,A.[AVAILABLE_DATE]
				   ,A.[REMAIN_LEAD_TIME]
				   ,A.[HOLDING_DATE]
				   ,A.[QTY]
				   ,(SELECT ITEM_UOM
				       FROM [DBO].SCM_ITEM_M D
					  INNER JOIN [DBO].[SCM_ITEM_CLASS_M] M
							  ON D.ITEM_CLASS = M.CLASS_ID
							 AND M.USE_FLAG = 'Y'
					  WHERE A.[ITEM_ID] = D.ITEM_ID
						AND A.DIVISION_ID = d.DIVISION_ID
						AND A.SITE_ID  = D.site_id) AS [QTY_UOM]
				   ,A.[STOCK_STATUS]
				   ,A.[OPERATION_ID]
				   ,A.QTY2 / A.QTY
				   ,A.[LINE_ID]
				   ,A.[OUTSOURCING_FLAG]
				   ,A.[OUTSOURCING_FACTORY]
				   ,A.[DESCRIPTION]
				   , CASE SEGMENT4  WHEN 'PRE' THEN
									    ISNULL( ( SELECT TOP 1 F.OPERATION_ID				 
													FROM DBO.SCM_OPERATION_M  O WITH(NOLOCK)
														 ,DBO.SCM_ITEM_M       I WITH(NOLOCK)
														 ,SCM_OPERATION_FLOW_M F WITH(NOLOCK)
													WHERE  I.COMPANY_ID   = A.COMPANY_ID
													AND    I.DIVISION_ID  = A.DIVISION_ID
													AND    I.SITE_ID      = A.SITE_ID
													AND    I.ITEM_ID      = A.ITEM_ID
													AND    F.COMPANY_ID   = I.COMPANY_ID
													AND    F.DIVISION_ID  = I.DIVISION_ID
													AND    F.SITE_ID      = I.SITE_ID
													AND    F.FLOW_ID      = I.FLOW_ID
													AND    F.OPERATION_ID < A.OPERATION_ID 
													AND    O.COMPANY_ID   = F.COMPANY_ID
													AND    O.DIVISION_ID  = F.DIVISION_ID
													AND    O.SITE_ID      = F.SITE_ID
													AND    O.OPERATION_ID = F.OPERATION_ID
													ORDER  BY F.OPERATION_SEQ DESC) , A.OPERATION_ID)
									WHEN 'STATUS' THEN 
										CASE  WHEN A.STOCK_STATUS = 'END' OR  A.STOCK_STATUS = 'EQPT_END' THEN
												A.OPERATION_ID
											  ELSE
												ISNULL( ( SELECT TOP 1 F.OPERATION_ID				 
													FROM DBO.SCM_OPERATION_M  O WITH(NOLOCK)
														 ,DBO.SCM_ITEM_M       I WITH(NOLOCK)
														 ,SCM_OPERATION_FLOW_M F WITH(NOLOCK)
													WHERE  I.COMPANY_ID   = A.COMPANY_ID
													AND    I.DIVISION_ID  = A.DIVISION_ID
													AND    I.SITE_ID      = A.SITE_ID
													AND    I.ITEM_ID      = A.ITEM_ID
													AND    F.COMPANY_ID   = I.COMPANY_ID
													AND    F.DIVISION_ID  = I.DIVISION_ID
													AND    F.SITE_ID      = I.SITE_ID
													AND    F.FLOW_ID      = I.FLOW_ID
													AND    F.OPERATION_ID < A.OPERATION_ID 
													AND    O.COMPANY_ID   = F.COMPANY_ID
													AND    O.DIVISION_ID  = F.DIVISION_ID
													AND    O.SITE_ID      = F.SITE_ID
													AND    O.OPERATION_ID = F.OPERATION_ID
													ORDER  BY F.OPERATION_SEQ DESC) , A.OPERATION_ID)
											   END 
				                    ELSE                  
										ISNULL( SEGMENT4, A.OPERATION_ID)
				                  END AS FP_APPLY_OPERATION_ID
				   , CASE SEGMENT5  WHEN 'PRE' THEN
									    ( SELECT TOP 1 CHILD_ITEM_ID
											FROM [dbo].[SCM_BOM_M] BOM
										  WHERE BOM.COMPANY_ID = A.COMPANY_ID
											AND BOM.DIVISION_ID = A.DIVISION_ID
											AND BOM.SITE_ID = A.SITE_ID
											AND BOM.PLANT_ID = A.PLANT_ID
											AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
											AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID) 
											AND BOM.EFF_START_DATE <= GETDATE()
											AND BOM.EFF_END_DATE > GETDATE()
											)
				                    ELSE                  
										A.[ITEM_ID]
				                  END AS FP_APPLY_ITEM_ID
				   , CASE SEGMENT5  WHEN 'PRE' THEN
										CASE  A.STOCK_STATUS WHEN 'PROC' THEN
																	0
															 ELSE
																  A.QTY *  ( SELECT TOP 1 CHILD_QTY / PARENT_QTY
																			   FROM [dbo].[SCM_BOM_M] BOM
																			  WHERE BOM.COMPANY_ID = A.COMPANY_ID
																				AND BOM.DIVISION_ID = A.DIVISION_ID
																				AND BOM.SITE_ID = A.SITE_ID
																				AND BOM.PLANT_ID = A.PLANT_ID
																				AND BOM.PARENT_ITEM_ID = A.[ITEM_ID]
																				AND EXISTS (SELECT 1 FROM DBO.SCM_ITEM_M WHERE ITEM_TYPE IN('P', 'Q', 'H') AND ITEM_ID = BOM.CHILD_ITEM_ID ) 
																				AND BOM.EFF_START_DATE <= GETDATE()
																				AND BOM.EFF_END_DATE > GETDATE()
																			)
															 END
									   ELSE
											CASE  A.STOCK_STATUS WHEN 'PROC' THEN
																	0
																 ELSE                  
																	A.QTY2
																  END
				                  END AS [FP_APPLY_WIPQTY]
				   ,A.WIPHOLD_YN
				   ,A.[INSERT_ID]
				   ,A.[INSERT_TIME]
				   ,A.[UPDATE_ID]
				   ,A.[UPDATE_TIME]
		      FROM (SELECT CASE WHEN @P_SITE_ID = 'A002' THEN
										CASE WHEN MAX(A.ATTRIBUTE1) IN ( 'G452','A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN
												   'G450'
										      ELSE ISNULL( B.COMPANY_ID, C.COMPANY_ID) END 
						             ELSE
									   ISNULL( B.COMPANY_ID, C.COMPANY_ID)
						            END AS COMPANY_ID
						   ,CASE WHEN @P_SITE_ID = 'A002' THEN
										CASE WHEN MAX(A.ATTRIBUTE1) IN ( 'G452', 'A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN 
												   '81'
										      ELSE ISNULL( B.DIVISION_ID, C.DIVISION_ID)  END 
						             ELSE
									   ISNULL( B.DIVISION_ID, C.DIVISION_ID) 
						            END AS DIVISION_ID
						   ,ISNULL( B.SITE_ID, C.SITE_ID )  AS SITE_ID
						   ,CASE WHEN @P_SITE_ID = 'A002' THEN
						               CASE WHEN MAX(A.ATTRIBUTE1) IN ( 'G452', 'A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN 
											    'G452'
									        ELSE
											    ISNULL( B.PLANT_ID, C.PLANT_ID )
											 END
						             ELSE
									   ISNULL( B.PLANT_ID, C.PLANT_ID )
						            END AS PLANT_ID
						   ,CASE WHEN @P_SITE_ID = 'A002' THEN
										CASE WHEN MAX(A.ATTRIBUTE1) IN ( 'G452', 'A') AND ISNULL( B.FACTORY_ID, C.FACTORY_ID )  = 'E7' THEN 
												   'E8'
										      ELSE ISNULL( B.FACTORY_ID, C.FACTORY_ID ) END 
						             ELSE
									   ISNULL( B.FACTORY_ID, C.FACTORY_ID ) 
						            END AS FACTORY_ID
						   ,'MES' AS STORAGE_ID
						   ,A.WORKDATE AS CUTOFF_DATE
						   ,row_number() over ( partition by A.WORKDATE order by   A.PRODID  desc ) [SEQ]
            			   ,'WIP' AS STOCK_TYPE 
						   ,A.PRODID AS ITEM_ID
						   ,NULL PRODUCTION_TYPE
            			   ,ISNULL(A.UNHOLD_EXP_DATE, '1999-01-01 00:00:00') AS AVAILABLE_DATE --     MAX(   CONVERT(DATETIME, A.UNHOLD_EXP_DATE ) ), '1999-01-01 00:00:00') AS AVAILABLE_DATE
            			   ,0 AS REMAIN_LEAD_TIME
            			   ,ISNULL(MAX(A.HOLD_DATE), '1999-01-01 00:00:00') AS HOLDING_DATE
            			   ,SUM(A.WIPQTY) QTY
						   ,SUM(A.WIPQTY2) AS QTY2
            			   ,'-' AS STOCK_STATUS
						   ,A.PROCID AS OPERATION_ID
						   ,ISNULL(B.LINE_ID,'-') AS LINE_ID
            			   ,'-' AS OUTSOURCING_FLAG
						   ,NULL AS OUTSOURCING_FACTORY
            			   ,NULL AS DESCRIPTION
            			   ,A.IFSEQNO AS INSERT_ID
						   ,A.WIP_TYPE_CODE
						   ,A.WIPHOLD_YN
            			   ,GETDATE() AS INSERT_TIME
            			   ,'PR_XIF_DW_WIP_R' AS UPDATE_ID
            			   ,GETDATE() AS UPDATE_TIME
					  FROM [dbo].[SY_XIF_DW_WIP_SUMMARY_R] A WITH(NOLOCK)
		   LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] B WITH(NOLOCK)
						ON A.EQPTID = B.EQUIPMENT_ID
					   and substring(B.MES_LINE_ID,1,2)  =  B.FACTORY_ID -- 남경에 전극 설비가 planning을 위해서 여러 building에 속해져 있음.
					   and A.procid = B.OPERATION_ID  -- 하나의 설비가 여러 공정에 속할 수 있다고 함.
				INNER JOIN ( SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
									   FROM [DBO].SCM_EQUIPMENT_M A WITH(NOLOCK) ) C
						ON SUBSTRING( CASE WHEN A.WIPSTAT = 'MOVING' THEN 
											    CASE WHEN A.TO_EQSGID ='' THEN 
													      A.EQSGID 
													   ELSE 
														  A.TO_EQSGID 
													   END  
											 ELSE 
												 A.EQSGID 
											 END ,1,2) =  C.FACTORY_ID
				INNER JOIN [DBO].SCM_ITEM_M D
						ON A.PRODID = D.ITEM_ID
					   AND c.DIVISION_ID = d.DIVISION_ID
					   AND ISNULL( B.SITE_ID, C.SITE_ID ) = D.site_id
			    INNER JOIN [DBO].[SCM_ITEM_CLASS_M] M
						ON D.ITEM_CLASS = M.CLASS_ID
					   AND M.USE_FLAG = 'Y'
				     WHERE A.IFSEQNO =  @P_IFSEQNO
					   AND A.TRANSFER_FLAG = 'P'
					   AND ISNULL( B.SITE_ID, C.SITE_ID ) = case when @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL then B.SITE_ID else @P_SITE_ID end
					 GROUP BY  ISNULL( B.COMPANY_ID, C.COMPANY_ID)
							  ,ISNULL( B.DIVISION_ID, C.DIVISION_ID)
							  ,ISNULL( B.SITE_ID, C.SITE_ID )
							  ,ISNULL( B.PLANT_ID, C.PLANT_ID )
							  ,ISNULL( B.FACTORY_ID, C.FACTORY_ID )
							  ,A.WORKDATE 
							  ,A.PRODID
            				  ,ISNULL(  A.UNHOLD_EXP_DATE, '1999-01-01 00:00:00') 
            				  ,A.PROCID 
							  ,ISNULL(B.LINE_ID,'-') 
            				  ,A.IFSEQNO
							  ,A.WIP_TYPE_CODE
							  ,A.WIPHOLD_YN ) A
   LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
				ON W.LOOKUP_TYPE_CODE = 'WIP_OPERATION_STOCK_MAP'
			   AND W.SEGMENT1 = A.OPERATION_ID
			   AND W.SEGMENT3 = A.WIP_TYPE_CODE
			   AND W.ACTIVE_FLAG = 'Y'
;

				   /*
            SELECT  ISNULL( B.COMPANY_ID, C.COMPANY_ID)
                   ,ISNULL( B.DIVISION_ID, C.DIVISION_ID)
                   ,ISNULL( B.SITE_ID, C.SITE_ID )
                   ,ISNULL( B.PLANT_ID, C.PLANT_ID )
                   ,ISNULL( B.FACTORY_ID, C.FACTORY_ID )
                   ,'MES' AS STORAGE_ID
                   ,A.WORKDATE AS CUTOFF_DATE
				   ,row_number() over ( partition by A.WORKDATE order by   A.PRODID  desc ) [SEQ]
            	   ,'WIP' AS STOCK_TYPE 
                   ,A.PRODID AS ITEM_ID
                   ,NULL PRODUCTION_TYPE
            	   ,ISNULL(  A.UNHOLD_EXP_DATE, '1999-01-01 00:00:00') AS AVAILABLE_DATE --     MAX(   CONVERT(DATETIME, A.UNHOLD_EXP_DATE ) ), '1999-01-01 00:00:00') AS AVAILABLE_DATE
            	   ,0 AS REMAIN_LEAD_TIME
            	   ,ISNULL(MAX(A.HOLD_DATE), '1999-01-01 00:00:00') AS HOLDING_DATE
            	   ,SUM(A.WIPQTY) QTY
            	   ,D.ITEM_UOM AS QTY_UOM
            	   ,'-' AS STOCK_STATUS
                   ,A.PROCID AS OPERATION_ID
				   ,ISNULL(B.LINE_ID,'-') AS LINE_ID
            	   ,'-' AS OUTSOURCING_FLAG
                   ,NULL AS OUTSOURCING_FACTORY
            	   ,NULL AS DESCRIPTION
            	   ,A.IFSEQNO
            	   ,GETDATE() AS INSERT_TIME
            	   ,'PR_XIF_DW_WIP_R'
            	   ,GETDATE() AS UPDATE_TIME
              FROM [dbo].[SY_XIF_DW_WIP_SUMMARY_R] A WITH(NOLOCK)
		            LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] B WITH(NOLOCK)
                                ON  A.EQPTID = B.EQUIPMENT_ID
						        and substring(B.MES_LINE_ID,1,2)  =  B.FACTORY_ID -- 남경에 전극 설비가 planning을 위해서 여러 building에 속해져 있음.
					            and A.procid = B.OPERATION_ID  -- 하나의 설비가 여러 공정에 속할 수 있다고 함.
			        INNER JOIN ( SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
                                   FROM [DBO].SCM_EQUIPMENT_M A WITH(NOLOCK)
					           ) C
                                ON  SUBSTRING( CASE WHEN A.WIPSTAT = 'MOVING' THEN 
								                         CASE WHEN A.TO_EQSGID ='' THEN 
													                A.EQSGID 
													           ELSE 
													                A.TO_EQSGID 
												               END  
											         ELSE 
											             A.EQSGID 
											         END ,1,2) =  C.FACTORY_ID
                    INNER JOIN [DBO].SCM_ITEM_M D
					            ON A.PRODID = D.ITEM_ID
								AND c.DIVISION_ID = d.DIVISION_ID
						        AND ISNULL( B.SITE_ID, C.SITE_ID ) = D.site_id
					 INNER JOIN [LGCE_FP_TR].[DBO].[SCM_ITEM_CLASS_M] M
			                    ON D.ITEM_CLASS = M.CLASS_ID
					            AND M.USE_FLAG = 'Y'

             WHERE A.IFSEQNO =  @P_IFSEQNO
			   AND A.TRANSFER_FLAG = 'P'
             GROUP BY  ISNULL( B.COMPANY_ID, C.COMPANY_ID)
                      ,ISNULL( B.DIVISION_ID, C.DIVISION_ID)
                      ,ISNULL( B.SITE_ID, C.SITE_ID )
                      ,ISNULL( B.PLANT_ID, C.PLANT_ID )
                      ,ISNULL( B.FACTORY_ID, C.FACTORY_ID )
                      ,A.WORKDATE 
                      ,A.PRODID
            	      ,ISNULL(  A.UNHOLD_EXP_DATE, '1999-01-01 00:00:00') 
            	      ,A.PROCID 
				      ,ISNULL(B.LINE_ID,'-') 
            	      ,A.IFSEQNO
				      ,D.ITEM_UOM
              ;*/
			/*	                                                                                                                                                               
            SELECT  A.COMPANY_ID
                   ,A.DIVISION_ID
                   ,A.SITE_ID
                   ,A.PLANT_ID
                   ,A.FACTORY_ID
                   ,'MES' AS STORAGE_ID
                   ,A.WORKDATE AS CUTOFF_DATE
            	   ,ROW_NUMBER() OVER( ORDER BY A.[COMPANY_ID], A.[DIVISION_ID], A.[SITE_ID], A.[PLANT_ID], A.[FACTORY_ID], A.[WORKDATE]) AS SEQ
            	   ,'WIP' AS STOCK_TYPE 
                   ,A.PRODID AS ITEM_ID
                   ,A.PRODUCTION_TYPE
            	   ,ISNULL(MAX(   convert(datetime, A.AVAILABLE_DATE ) ), '1999-01-01 00:00:00') AS AVAILABLE_DATE
            	   ,0 AS REMAIN_LEAD_TIME
            	   ,ISNULL(MAX(A.HOLDING_DATE), '1999-01-01 00:00:00') AS HOLDING_DATE
            	   ,SUM(A.WIPQTY) QTY
            	   ,A.ITEM_UOM AS QTY_UOM
            	   ,'-' AS STOCK_STATUS
                   ,A.PROCID AS OPERATION_ID
				   ,MAX(A.LINE_ID) AS LINE_ID
            	   ,'-' AS OUTSOURCING_FLAG
                   ,NULL AS OUTSOURCING_FACTORY
            	   ,NULL AS DESCRIPTION
            	   ,@P_IFSEQNO
            	   ,GETDATE() AS INSERT_TIME
            	   ,'PR_XIF_DW_WIP_R'
            	   ,GETDATE() AS UPDATE_TIME
              FROM (
                    SELECT DISTINCT -- 호기 및 양/음극 정보때문에 중복이 됨. 
					       A.LOTID
						  ,B.[COMPANY_ID]
						  ,B.[DIVISION_ID]
						  ,B.[SITE_ID]
						  ,B.[PLANT_ID]
						  ,B.[FACTORY_ID]
                          ,A.WORKDATE
                          ,A.PRODID
                          ,(
                            SELECT DISTINCT X.PRODUCTION_TYPE
                              FROM [LGCE_FP_TR].[DBO].[FP_PRODUCTION_PLAN_R] X
                             WHERE X.WORK_ORDER_ID = A.WOID
                           ) PRODUCTION_TYPE --PRODUCTION_TYPE WO를 연결해서 WO의 PRODUCTION TYPE을 구함.
                          ,A.WIPQTY
						  ,C.ITEM_UOM
                          ,A.EQSGID
                          ,A.PROCID
					      ,(SELECT TOP 1 X.LINE_ID 
						      FROM DBO.SCM_EQUIPMENT_M X 
						     WHERE X.EQUIPMENT_ID = A.EQPTID) AS LINE_ID
						  ,A.WIPHOLD
						  ,CASE WHEN A.WIPHOLD = 'Y' THEN (SELECT TOP 1 CASE WHEN UNHOLD_SCHD_DATE = 'NULL' THEN NULL ELSE UNHOLD_SCHD_DATE END
															 FROM [LGCE_INF].[dbo].[XIF_DW_WIP_HOLD_HISTORY_R] B
															WHERE B.LOTID = A.LOTID
															  AND B.WIPSEQ = (SELECT MAX(WIPSEQ) 
																				FROM [LGCE_INF].[dbo].[XIF_DW_WIP_HOLD_HISTORY_R]
																			   WHERE LOTID = A.LOTID
																			 )
														   )
						    ELSE NULL
							 END AS AVAILABLE_DATE
						  ,CASE WHEN A.WIPHOLD = 'Y' THEN (SELECT TOP 1 CASE WHEN HOLD_DTTM = 'NULL' THEN NULL ELSE HOLD_DTTM END
															 FROM [LGCE_INF].[dbo].[XIF_DW_WIP_HOLD_HISTORY_R] B
															WHERE B.LOTID = A.LOTID
															  AND B.WIPSEQ = (SELECT MAX(WIPSEQ) 
																				FROM [LGCE_INF].[dbo].[XIF_DW_WIP_HOLD_HISTORY_R]
																			   WHERE LOTID = A.LOTID
																			 )
														   )
						    ELSE NULL
							 END AS HOLDING_DATE
					--SELECT * FROM [LGCE_INF].[DBO].[XIF_DW_WIP_R]
                      FROM [LGCE_INF].[DBO].[XIF_DW_WIP_R] A,
						   [LGCE_FP_TR].[DBO].[SCM_EQUIPMENT_M] B,
						   [LGCE_FP_TR].[DBO].[SCM_ITEM_M] C
					 WHERE A.EQSGID        = B.MES_LINE_ID
					   AND A.PROCID        = B.OPERATION_ID
					   AND B.COMPANY_ID    = C.COMPANY_ID
					   AND B.DIVISION_ID   = C.DIVISION_ID
					   AND B.SITE_ID       = C.SITE_ID
					   AND A.PRODID        = C.ITEM_ID
					   AND B.DIVISION_ID   = CASE SUBSTRING( C.DESCRIPTION, 1,1 ) WHEN 'A' THEN 81 
					                              WHEN 'M' THEN 40 
											  END
					   AND A.TRANSFER_FLAG = 'P'
					   --AND A.IFSEQNO     = '20161122180010'
					   AND A.IFSEQNO       = @P_IFSEQNO
					   AND B.SITE_ID       = case when @P_SITE_ID = 'NULL' then B.SITE_ID else @P_SITE_ID end
					   --AND A.PRODID = 'ASLAN0136A'
                     --AND WIP_TYPE_CODE IN ( 'OUT','INOUT' )   -- 지금은 값이 안 들어옴.. 추후 추가되어야 함.
                    ) A
             GROUP BY A.COMPANY_ID
                     ,A.DIVISION_ID
                     ,A.SITE_ID
                     ,A.PLANT_ID
                     ,A.FACTORY_ID
                     ,A.WORKDATE
                     ,A.PRODID
                     ,A.PRODUCTION_TYPE
					 ,A.ITEM_UOM
                     ,A.PROCID
        ;
		    */

		SET @ROWCOUNT = @@ROWCOUNT

		UPDATE [dbo].[SY_XIF_DW_WIP_SUMMARY_R]
		   SET TRANSFER_FLAG = 'Y'
			  ,TRANSFER_DATE = GETDATE()
	     WHERE IFSEQNO       = @P_IFSEQNO
		   AND TRANSFER_FLAG = 'P'
		;


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




