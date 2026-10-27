
CREATE PROCEDURE [dbo].[PR_XIF_FP_ITEM_ASSIGN_SYNC_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_FP_ITEM_ASSIGN_SYNC_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : SCM
-- Destination System  : FP SDB (법인별 MQ)
-- Source Table        : XIF_FP_ITEM_ASSIGN_SYNC_R
-- Destination Table   : SCM_ITEM_LINE_ASSIGN_M, SCM_TACT_TIME_M, SCM_YIELD_M
--
-- Create(Update) Date : 2023.11.29
-- Author              : JYJ
-- Version             : 1.0  2023.07.20  JYJ (Init)
--                       1.1  2023.10.27  kimcd ACTIVE_FLAG 동기화 제거
--                       1.2  2023.11.09  kimcd Item Line Assign은 추가만 함. Tact Time에 설비 갯수 반영
--                       1.3  2023.11.29  kimcd daily capa 추가
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_FP_ITEM_ASSIGN_SYNC_R'
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

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		    -- ================================================
		    -- 로직 추가 start
		    -- ================================================
		
            UPDATE [dbo].[SY_XIF_FP_ITEM_ASSIGN_SYNC_R]
                SET PROC_FLAG = 'P'
            WHERE ISNULL(PROC_FLAG,'N') = 'N'

		    -- MERGE  SCM_ITEM_LINE_ASSIGN_M
            MERGE INTO [dbo].[SCM_ITEM_LINE_ASSIGN_M] TM 
            USING 
            (
                SELECT A.[COMPANY_ID]  AS COMPANY_ID
                   ,A.[DIVISION_ID]    AS DIVISION_ID
                   ,A.[SITE_ID]        AS SITE_ID
                   ,A.[PLANT_ID]       AS PLANT_ID
                   ,A.[FACTORY_ID]     AS FACTORY_ID
                   ,A.[OPERATION_ID]   AS OPERATION_ID
                   ,A.[LINE_ID]        AS LINE_ID
                   ,A.[ITEM_ID]	       AS ITEM_ID
                   ,A.[ELECTRODE_TYPE] AS ELECTRODE_TYPE
                   ,A.[PRIORITY]       AS PRIORITY
                   ,A.[ACTIVE_FLAG]    AS ACTIVE_FLAG
                   ,B.MONTH            AS MONTH
                FROM  (  SELECT A.[COMPANY_ID]
                               ,A.[DIVISION_ID]
                               ,A.[SITE_ID]
                               ,A.[PLANT_ID]
                               ,A.[FACTORY_ID]
                               ,A.[OPERATION_ID]
                               ,A.[LINE_ID]
                               ,A.[ITEM_ID]	
                               ,A.[ELECTRODE_TYPE]
                               ,A.[PRIORITY]
                               ,A.[ACTIVE_FLAG]
				         FROM    ( SELECT P.[COMPANY_ID]
                                         ,P.[DIVISION_ID]
                                         ,P.[SITE_ID]
                                         ,XIA.[PLANT_ID]
                                         ,XIA.[FACTORY_ID]
                                         ,XIA.[OPERATION_ID]
                                         ,XIA.[LINE_ID]
                                         ,XIA.[ITEM_ID]	
                                         ,XIA.[ELECTRODE_TYPE]
                                         ,CONVERT(float, XIA.[PRIORITY]) as PRIORITY
                                         ,XIA.[ACTIVE_FLAG]
							             ,ROW_NUMBER() OVER ( PARTITION BY P.[COMPANY_ID],P.[DIVISION_ID],P.[SITE_ID],XIA.[PLANT_ID],XIA.[FACTORY_ID],XIA.[OPERATION_ID],XIA.[LINE_ID],XIA.[ITEM_ID],XIA.[ELECTRODE_TYPE]
							                                  ORDER BY IF_SEQ DESC ) AS NUM
                                   FROM   SY_XIF_FP_ITEM_ASSIGN_SYNC_R  XIA
                                         INNER JOIN SCM_PLANT_M P
                                             ON P.PLANT_ID = XIA.PLANT_ID
                                   WHERE XIA.PROC_FLAG = 'P'  ) A
						 WHERE A.NUM = 1
                      ) A
                    ,(	 SELECT DISTINCT YEAR+MONTH AS MONTH
                          FROM SCM_SYS_CALENDAR_M
                          WHERE YEAR+MONTH BETWEEN CONVERT(NVARCHAR(6),GETDATE(), 112)
                            AND CONVERT(NVARCHAR(6),DATEADD(MM, 11, GETDATE()), 112) 
                     ) B
            ) B
            ON (    TM.[COMPANY_ID]     = B.[COMPANY_ID]
                AND TM.[DIVISION_ID]    = B.[DIVISION_ID]
                AND TM.[SITE_ID]        = B.[SITE_ID]
                AND TM.[PLANT_ID]       = B.[PLANT_ID]
                AND TM.FACTORY_ID       = B.[FACTORY_ID]
                AND TM.OPERATION_ID     = B.[OPERATION_ID]
                AND TM.[LINE_ID]        = B.[LINE_ID]
                AND TM.[ITEM_ID]        = B.[ITEM_ID]
                AND TM.[ELECTRODE_TYPE] = B.[ELECTRODE_TYPE]
                AND TM.[MONTH]          = B.[MONTH]
             )
            --WHEN MATCHED THEN
            --    UPDATE
            --	SET  TM.PRIORITY    = B.PRIORITY
            --        --,TM.ACTIVE_FLAG = B.ACTIVE_FLAG  2023.10.27  kimcd ACTIVE_FLAG 동기화 제거
            --        ,TM.UPDATE_ID   = @v_proc_name
            --        ,TM.UPDATE_TIME	= GETDATE()
			-- 2023-11-09 kimcd item line assign에서 수정은 하지 않음
            WHEN NOT MATCHED THEN
                INSERT 
                (
                    [COMPANY_ID]
                   ,[DIVISION_ID]
                   ,[SITE_ID]
                   ,[PLANT_ID]
                   ,[FACTORY_ID]
                   ,[OPERATION_ID]
                   ,[LINE_ID]
                   ,[ELECTRODE_TYPE]
                   ,[ITEM_ID]
                   ,[MONTH]
                   ,[PRIORITY]
                   ,[ACTIVE_FLAG]
                   ,[INSERT_ID]
                   ,[INSERT_TIME]
                   ,[UPDATE_ID]
                   ,[UPDATE_TIME]
                )
                VALUES 
                ( 
                    B.[COMPANY_ID]
                   ,B.[DIVISION_ID]
                   ,B.[SITE_ID]
                   ,B.[PLANT_ID]
                   ,B.[FACTORY_ID]
                   ,B.[OPERATION_ID]
                   ,B.[LINE_ID]
                   ,B.[ELECTRODE_TYPE]
                   ,B.[ITEM_ID]
                   ,B.[MONTH]
                   ,B.[PRIORITY]
                   ,'Y'
                   ,@v_proc_name
                   ,GETDATE()
                   ,@v_proc_name
                   ,GETDATE()
                )
                ;	
				
            -- MERGE  SCM_TACT_TIME_M
            MERGE INTO [dbo].[SCM_TACT_TIME_M] TM 
            USING 
            (
                SELECT A.[COMPANY_ID]   AS COMPANY_ID
                    ,A.[DIVISION_ID]    AS DIVISION_ID
                    ,A.[SITE_ID]        AS SITE_ID
                    ,A.[PLANT_ID]       AS PLANT_ID
                    ,A.[FACTORY_ID]     AS FACTORY_ID
                    ,A.[OPERATION_ID]   AS OPERATION_ID
                    ,A.[LINE_ID]        AS LINE_ID
                    ,A.[ITEM_ID]	    AS ITEM_ID
                    ,A.[ELECTRODE_TYPE] AS ELECTRODE_TYPE
                    ,A.[TACT_TIME]      AS TACT_TIME
					,CASE WHEN A.[TACT_TIME] = 0 THEN 0
					 ELSE (ROUND(86400/ A.[TACT_TIME] * ISNULL((SELECT 1-ROUND(SUM(ISNULL(LOSS_RATE,0)),4) 
                                                           FROM   SCM_LOSS_M L WITH(NOLOCK)
	                                                           JOIN ( SELECT SEGMENT1	AS LOSS_CODE
	                                                           		  FROM   SCM_SYS_LOOKUP_VALUE  SSLV WITH(NOLOCK)
	                                                           		  WHERE  LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
	                                                           		  AND    ATTRIBUTE5 = 'Y'
	                                                           	      ) LS
	                                                           ON L.LOSS_CODE	= LS.LOSS_CODE
	                                                       WHERE L.COMPANY_ID     = A.[COMPANY_ID]
	                                                       AND   L.DIVISION_ID    = A.[DIVISION_ID]
	                                                       AND   L.SITE_ID        = A.[SITE_ID]
	                                                       AND   L.PLANT_ID       = A.[PLANT_ID]
	                                                       AND   L.FACTORY_ID     = A.[FACTORY_ID]
	                                                       AND   L.OPERATION_ID   = A.[OPERATION_ID]
	                                                       AND   L.LINE_ID        = A.[LINE_ID]
	                                                       AND   L.ELECTRODE_TYPE = A.[ELECTRODE_TYPE] 
	                                                       AND   L.WORK_MONTH     = B.MONTH ),1), 0) ) END AS DAILY_CAPA  -- 2023-11-29  kimcd daily capa 추가
                    ,B.MONTH            AS MONTH
                FROM  (  SELECT A.[COMPANY_ID]
                               ,A.[DIVISION_ID]
                               ,A.[SITE_ID]
                               ,A.[PLANT_ID]
                               ,A.[FACTORY_ID]
                               ,A.[OPERATION_ID]
                               ,A.[LINE_ID]
                               ,A.[ITEM_ID]	
                               ,A.[ELECTRODE_TYPE]
							   ,ISNULL( A.[TACT_TIME]/
							                 (SELECT COUNT(*) 
							                  FROM   SCM_EQUIPMENT_M   EM WITH(NOLOCK)
							                  WHERE  EM.[COMPANY_ID]     =  A.[COMPANY_ID]
                                              AND    EM.[DIVISION_ID]    = A.[DIVISION_ID]
                                              AND    EM.[SITE_ID]        = A.[SITE_ID]
                                              AND    EM.[PLANT_ID]       = A.[PLANT_ID]
                                              AND    EM.[FACTORY_ID]     = A.[FACTORY_ID]
                                              AND    EM.[OPERATION_ID]   = A.[OPERATION_ID]
                                              AND    EM.[LINE_ID]        = A.[LINE_ID]
                                              AND    EM.[ELECTRODE_TYPE] = A.[ELECTRODE_TYPE]
							                  AND    EM.[ACTIVE_FLAG]    = 'Y'
							                  AND    EM.[EQUIPMENT_TYPE] = 'M'
											  GROUP BY EM.[LINE_ID]), A.[TACT_TIME] ) AS TACT_TIME    -- 2023-11-09 kimcd 설비 갯수로 Tact Time 나누기
				         FROM    ( SELECT P.[COMPANY_ID]
                                         ,P.[DIVISION_ID]
                                         ,P.[SITE_ID]
                                         ,XIA.[PLANT_ID]
                                         ,XIA.[FACTORY_ID]
                                         ,XIA.[OPERATION_ID]
                                         ,XIA.[LINE_ID]
                                         ,XIA.[ITEM_ID]	
                                         ,XIA.[ELECTRODE_TYPE]
                                         ,XIA.[TACT_TIME]
							             ,ROW_NUMBER() OVER ( PARTITION BY P.[COMPANY_ID],P.[DIVISION_ID],P.[SITE_ID],XIA.[PLANT_ID],XIA.[FACTORY_ID],XIA.[OPERATION_ID],XIA.[LINE_ID],XIA.[ITEM_ID],XIA.[ELECTRODE_TYPE]
							                                  ORDER BY IF_SEQ DESC ) AS NUM
                                   FROM   SY_XIF_FP_ITEM_ASSIGN_SYNC_R  XIA
                                         INNER JOIN SCM_PLANT_M P
                                             ON P.PLANT_ID = XIA.PLANT_ID
                                   WHERE XIA.PROC_FLAG = 'P'  ) A
						 WHERE A.NUM = 1
                    ) A
                   ,(    SELECT DISTINCT YEAR+MONTH AS MONTH
                         FROM SCM_SYS_CALENDAR_M
                         WHERE YEAR+MONTH BETWEEN CONVERT(NVARCHAR(6),GETDATE(), 112)
                           AND CONVERT(NVARCHAR(6),DATEADD(MM, 11, GETDATE()), 112) 
                   ) B
            ) B
            ON 
            (     TM.[COMPANY_ID]     = B.[COMPANY_ID]
              AND TM.[DIVISION_ID]    = B.[DIVISION_ID]
              AND TM.[SITE_ID]        = B.[SITE_ID]
              AND TM.[PLANT_ID]       = B.[PLANT_ID]
              AND TM.FACTORY_ID       = B.[FACTORY_ID]
              AND TM.OPERATION_ID     = B.[OPERATION_ID]
              AND TM.[LINE_ID]        = B.[LINE_ID]
              AND TM.[ITEM_ID]        = B.[ITEM_ID]
              AND TM.[ELECTRODE_TYPE] = B.[ELECTRODE_TYPE]
              AND TM.[MONTH]          = B.[MONTH] 
            )
            WHEN MATCHED THEN
          	    UPDATE
          	    SET  TM.[TACT_TIME]  = B.[TACT_TIME]
				    ,TM.[DAILY_CAPA] = B.[DAILY_CAPA]  -- 2023-11-29  kimcd daily capa 추가
                    ,TM.UPDATE_ID    = @v_proc_name
                    ,TM.UPDATE_TIME  = GETDATE()
            WHEN NOT MATCHED THEN
          	    INSERT
                (
                    [COMPANY_ID]
                   ,[DIVISION_ID]
                   ,[SITE_ID]
                   ,[PLANT_ID]
                   ,[FACTORY_ID]
                   ,[OPERATION_ID]
                   ,[LINE_ID]
                   ,[ELECTRODE_TYPE]
                   ,[ITEM_ID]
                   ,[MONTH]
                   ,[TACT_TIME]
				   ,[DAILY_CAPA]  -- 2023-11-29  kimcd daily capa 추가
                   ,[INSERT_ID]
                   ,[INSERT_TIME]
                   ,[UPDATE_ID]
                   ,[UPDATE_TIME]
                )
                VALUES 
                ( 
                    B.[COMPANY_ID]
                   ,B.[DIVISION_ID]
                   ,B.[SITE_ID]
                   ,B.[PLANT_ID]
                   ,B.[FACTORY_ID]
                   ,B.[OPERATION_ID]
                   ,B.[LINE_ID]
                   ,B.[ELECTRODE_TYPE]
                   ,B.[ITEM_ID]
                   ,B.[MONTH]
                   ,B.[TACT_TIME]
				   ,B.[DAILY_CAPA] -- 2023-11-29  kimcd daily capa 추가
                   ,@v_proc_name
                   ,GETDATE()
                   ,@v_proc_name
                   ,GETDATE()
                )
                ;

            -- MERGE  SCM_YIELD_M   	  
			/* yield 수신 보류 2023-10-01 kimcd
            MERGE INTO [dbo].[SCM_YIELD_M] TM 
            USING 
            (    SELECT A.[COMPANY_ID]  AS COMPANY_ID
                       ,A.[DIVISION_ID]   AS DIVISION_ID
                       ,A.[SITE_ID]       AS SITE_ID
                       ,A.[PLANT_ID]      AS PLANT_ID
                       ,A.[FACTORY_ID]    AS FACTORY_ID
                       ,A.[OPERATION_ID]  AS OPERATION_ID
                       ,A.[LINE_ID]       AS LINE_ID
                       ,A.[ITEM_ID]	      AS ITEM_ID
                       ,A.[YIELD]         AS YIELD
                       ,B.MONTH           AS MONTH
                 FROM  (  SELECT P.[COMPANY_ID]
                              ,P.[DIVISION_ID]
                              ,P.[SITE_ID]
                              ,XIA.[PLANT_ID]
                              ,XIA.[FACTORY_ID]
                              ,XIA.[OPERATION_ID]
                              ,XIA.[LINE_ID]
                              ,XIA.[ITEM_ID]	
                              ,AVG(XIA.[YIELD]) AS YIELD
                          FROM   SY_XIF_FP_ITEM_ASSIGN_SYNC_R  XIA
                          INNER JOIN SCM_PLANT_M P
                            ON P.PLANT_ID = XIA.PLANT_ID
                          WHERE XIA.PROC_FLAG = 'P'
                          GROUP BY P.[COMPANY_ID]
                                  ,P.[DIVISION_ID]
                                  ,P.[SITE_ID]
                                  ,XIA.[PLANT_ID]
                                  ,XIA.[FACTORY_ID]
                                  ,XIA.[OPERATION_ID]
                                  ,XIA.[LINE_ID]
                                  ,XIA.[ITEM_ID]
                     ) A
                    ,(  SELECT DISTINCT YEAR+MONTH AS MONTH
                        FROM SCM_SYS_CALENDAR_M
                        WHERE YEAR+MONTH BETWEEN CONVERT(NVARCHAR(6),GETDATE(), 112)
                         AND CONVERT(NVARCHAR(6),DATEADD(MM, 11, GETDATE()), 112)
                    ) B
           ) B
           ON 
           (       TM.[COMPANY_ID]  = B.[COMPANY_ID]
               AND TM.[DIVISION_ID] = B.[DIVISION_ID]
               AND TM.[SITE_ID]     = B.[SITE_ID]
               AND TM.[PLANT_ID]    = B.[PLANT_ID]
               AND TM.FACTORY_ID    = B.[FACTORY_ID]
               AND TM.OPERATION_ID  = B.[OPERATION_ID]
               AND TM.[LINE_ID]     = B.[LINE_ID]
               AND TM.[ITEM_ID]     = B.[ITEM_ID]
               AND TM.[MONTH]       = B.[MONTH] 
           )
           WHEN MATCHED THEN
               UPDATE
                   SET  TM.[YIELD]      = B.[YIELD]
                       ,TM.UPDATE_ID    = @v_proc_name
                       ,TM.UPDATE_TIME  = GETDATE()
           WHEN NOT MATCHED THEN
               INSERT 
               (  
                   [COMPANY_ID]
                  ,[DIVISION_ID]
                  ,[SITE_ID]
                  ,[PLANT_ID]
                  ,[FACTORY_ID]
                  ,[OPERATION_ID]
                  ,[LINE_ID]
                  ,[ITEM_ID]
                  ,[MONTH]
                  ,[YIELD]
                  ,[INSERT_ID]
                  ,[INSERT_TIME]
                  ,[UPDATE_ID]
                  ,[UPDATE_TIME]
               )  
               VALUES 
               ( 
                   B.[COMPANY_ID]
                  ,B.[DIVISION_ID]
                  ,B.[SITE_ID]
                  ,B.[PLANT_ID]
                  ,B.[FACTORY_ID]
                  ,B.[OPERATION_ID]
                  ,B.[LINE_ID]
                  ,B.[ITEM_ID]
                  ,B.[MONTH]
                  ,B.[YIELD]
                  ,@v_proc_name
                  ,GETDATE()
                  ,@v_proc_name
                  ,GETDATE()
               )
               ;*/

            UPDATE [dbo].[SY_XIF_FP_ITEM_ASSIGN_SYNC_R]
                SET PROC_FLAG = 'Y'
                   ,PROC_DATE = getdate()
            WHERE PROC_FLAG = 'P'  
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



