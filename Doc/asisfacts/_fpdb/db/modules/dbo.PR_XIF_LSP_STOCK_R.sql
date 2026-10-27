 

CREATE PROCEDURE [dbo].[PR_XIF_LSP_STOCK_R]

-- ================================================================================================
-- Program ID          : FP00900
-- Program Name        : PR_XIF_LSP_STOCK_R
-- Param               :
-- Batch Period        : 1일 7시(1회)
-- Description         : oWMS재고 정보수신데이타 저장
--
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_LSP_STOCK_R
-- Destination Table   : SCM_STOCK_H
--
-- Create Date		   : 2023.07.26
-- Update Date		   : 2023.11.28
-- Version             : 1.0  JYJ  Init
--                       1.1  kimcd 2023-09-20 STORAGE ID 조회로 수정
--                       1.2  KIMJS 2023-09-30 SCM_BOM_M을 FP_RUNNING_CHANGE_M 으로 변경
--                       1.3  JYJ 2023-10-03 Lookup최종재고수신 관리
--                       1.4  kimcd 2023-10-04 SCM 기주능로 로직 변경. 수량 합산 오류 수정
--                       1.5  JYJ   2023-10-12  G480인경우 1회만 수행(FP계획에 있는 OWMS_STOCK수량기준으로 BOH수량 갱신)
--                       1.6  kimcd 2023-11-09  조건 추가. 수량 누락 보완
--                       1.7  kimcd 2023-11-28  재고 상태 구분용으로 STATUS_STATUS 컬럼 추가 형성
--                       1.8  ohij  2024-03-15  하드코딩 제거
--                       1.8  ohij  2024-10-15  하드코딩 변경
--                       2.1 chkim.68 2024-11-05 WA.FP에서 OC.FP 복사
--                       2.2 kimcd 2024-12-19 CC.FP 기준으로 로직 수정
--                       2.3 chkim.68 2024-12-09 운영 반영
-- ================================================================================================

-- PARAMETER
@P_SITE_ID NVARCHAR(50)

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON
	SET XACT_ABORT ON

	--DECLARE @P_SITE_ID NVARCHAR(50) = 'NULL'
    --DECLARE @P_IF_ID   NVARCHAR(50) = 'NULL'

	-- LOG 용 변수 설정
	DECLARE @V_PROC_NAME   NVARCHAR(100) = 'PR_XIF_LSP_STOCK_R'
	DECLARE @v_descr       NVARCHAR(250)
	DECLARE @v_count       INTEGER	   = 0
	DECLARE @sysdate       DATETIME      = GETDATE()
	DECLARE @v_rtncode	   INTEGER	   = 0		
	
	DECLARE @ROWCOUNT      INTEGER
						   
	-- ERROR_LINE		   
	DECLARE @v_temp1       NVARCHAR(1000)
	DECLARE @v_temp2       NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @MASTER_IF_SEQ         NVARCHAR(50)
	-- ECLARE @COMPANY_ID            NVARCHAR(50)  -- 2024-12-19 kimcd 조건 제거
	DECLARE @GROUP_SEQ             NVARCHAR(50)
    DECLARE @SITE_ID               NVARCHAR(50)
	DECLARE @i_CNT                 INTEGER

	DECLARE @WORKDATE              DATE 
	
	DECLARE @CURRENT_DATETIME      DATETIME
	DECLARE @WORK_START_DATETIME   DATETIME
	DECLARE @CUTOFF_DATE           DATE

	IF (SELECT CURSOR_STATUS('GLOBAL','CUR_IF_OWMS_STOCK')) >= -1
    BEGIN
        IF (SELECT CURSOR_STATUS('GLOBAL','CUR_IF_OWMS_STOCK')) > -1
        BEGIN
            CLOSE CUR_IF_OWMS_STOCK
        END

        DEALLOCATE CUR_IF_OWMS_STOCK
    END

 --   IF (@P_SITE_ID  = '' OR @P_SITE_ID IS NULL)
 --   	BEGIN
 --   		RAISERROR ('Error Paramater: @P_SITE_ID do not have Value.', -- Message text.
 --   				   16, -- Severity.
 --   				   1 -- State.
 --   				   );
 --   	END;

	--IF @P_SITE_ID IS NULL OR @P_SITE_ID = '' OR @P_SITE_ID = 'NULL'
	--   BEGIN
	--       SET @SITE_ID = 'A001'
	--   END
	--ELSE
	--   BEGIN
	--       SET @SITE_ID = @P_SITE_ID
	--   END
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--현재 법인 사이트 프로시져 수행 DATETIME와 각법인 조업시간을 비교하여 사이트 프로시져 수행 DATETIME이 조업시간 이젼이면 CUTOFF_DATE =GETDATE()-1, 이후이면 CUTOFF_DATE = GETDATE()
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	/*
	SELECT @CURRENT_DATETIME = [dbo].[FN_SITE_TIME] (@SITE_ID);
	SELECT @WORK_START_DATETIME =  WORK_START_DATETIME
	FROM (
	      SELECT DISTINCT DATEADD(MI,CONVERT(NUMERIC,ISNULL(V.ATTRIBUTE2, '0')), CONVERT(NVARCHAR(10), GETDATE(), 120) + ' ' +  -- 2020-06-17 PIYONG 시업 시간 이후 late time 적용 CNB 정보 정합성 유지용
				  SUBSTRING(V.SEGMENT2, 1,2 ) +':'+
				  SUBSTRING(V.SEGMENT2, 3,2 ) +':'+
				  SUBSTRING(V.SEGMENT2, 5,2 )) AS WORK_START_DATETIME
          FROM [SCM_SYS_LOOKUP_VALUE] V WITH(NOLOCK)
          WHERE V.LOOKUP_TYPE_CODE	= 'BASIS_START_TIME_PLANT'
            AND V.ACTIVE_FLAG		= 'Y'
            AND V.SEGMENT1			= (SELECT TOP 1 P.PLANT_ID
			                           FROM   SCM_PLANT_M P (NOLOCK)
									   WHERE  P.SITE_ID = @SITE_ID )
	 ) A
	 ;

	 IF @CURRENT_DATETIME >= @WORK_START_DATETIME
	     BEGIN
	       SET @CUTOFF_DATE = GETDATE()  --CUTOFF_DATE 당일(TODAY)적용
		 END
	 ELSE
	     BEGIN
		   SET @CUTOFF_DATE = GETDATE()-1 --CUTOFF_DATE 전일(YESTERDAY)적용
		 END
	*/
	SET @CUTOFF_DATE = GETDATE();  --CUTOFF_DATE 당일(TODAY)적용
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--시스템 테이블 활용 --2024-10-15
	DECLARE @PLANT_ID_WA_E TABLE( CODE NVARCHAR(50) );

	INSERT INTO @PLANT_ID_WA_E 
	  SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_OWMS_STOCK_R' AND SEGMENT1  = 'PLANT_ID_WA_E' AND ACTIVE_FLAG = 'Y'

	DECLARE CUR_IF_OWMS_STOCK CURSOR FOR
        SELECT -- A.ATTRIBUTE5		AS COMPANY_ID -- 2024-12-19 kimcd 조건 제거
        	   A.MASTER_IF_SEQ  AS GROUP_SEQ
        	 , CONVERT(DATE, A.ATTRIBUTE8, 112) AS WORKDATE
        FROM   dbo.SY_XIF_LSP_STOCK_R  A WITH(NOLOCK)
        WHERE  1 = 1
        AND    A.PROC_FLAG = 'N'
        AND    A.MASTER_IF_SEQ LIKE '%' + CONVERT(CHAR(6), GETDATE(), 12) + '%'
        AND    CONVERT(CHAR(8), A.IF_RCV_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
        GROUP  BY -- A.ATTRIBUTE5  -- 2024-12-19 kimcd 조건 제거
        	      A.MASTER_IF_SEQ
        		, A.ATTRIBUTE8
        HAVING  MAX(CONVERT(INT, A.ATTRIBUTE6)) = COUNT(*)
        ;

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가 start
		-- ================================================
			OPEN CUR_IF_OWMS_STOCK;
			FETCH NEXT FROM CUR_IF_OWMS_STOCK INTO -- @COMPANY_ID -- 2024-12-19 kimcd 조건 제거
											     @GROUP_SEQ
                                                ,@WORKDATE

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
				--BEGIN TRAN --2023-10-12 JYJ 주석처리
					BEGIN
                        -- PROC_FLAG = P Update
						UPDATE [dbo].[SY_XIF_LSP_STOCK_R]
						   SET PROC_FLAG = 'P'
						WHERE PROC_FLAG = 'N'
						   AND  MASTER_IF_SEQ  = @GROUP_SEQ
						   AND  ATTRIBUTE8 = CONVERT(VARCHAR(8),@WORKDATE,112) -- @WORKDATE(DATE: YYYY-MM-DD)
						;

						--해당일 데이타 존재시 삭제후 Insert함
						DELETE FROM  [dbo].[SCM_STOCK_H]
                           WHERE  [COMPANY_ID]   IN ( SELECT ATTRIBUTE5
						                              FROM   [dbo].[SY_XIF_LSP_STOCK_R]
						                              WHERE  PROC_FLAG = 'P'
                            						  AND    MASTER_IF_SEQ  = @GROUP_SEQ
						                              AND    ATTRIBUTE8 = CONVERT(VARCHAR(8),@WORKDATE,112) -- @WORKDATE(DATE: YYYY-MM-DD)
													  GROUP  BY ATTRIBUTE5
                                                       ) -- 2024-12-19 kimcd 회사 코드 조건 수정
                           AND    [CUTOFF_DATE]   = DATEADD(D,1,@WORKDATE)  --해당일 데이타 존재시 삭제후 Insert함
                           AND    [STOCK_TYPE]    = 'DW' -- OWMS 재고 구분.. 2024-12-19 kimcd scm fp는 DW 코드 사용
						   AND    [STORAGE_ID]   != '-'  -- OWMS 재고 구분.. 2024-12-19 kimcd 창고 존재 OWMS, 창고  '-'은 셀 포장 대기 재고
						;

                       INSERT INTO [dbo].[SCM_STOCK_H]
                       (
                            [COMPANY_ID]
                           ,[DIVISION_ID]
                           ,[SITE_ID]
                           ,[PLANT_ID]
                           ,[FACTORY_ID]
                           ,[STORAGE_ID]
                           ,[CUTOFF_DATE]
                           ,[SEQ]
                           ,[STOCK_TYPE]
                           ,[ITEM_ID]
                           ,[AVAILABLE_DATE]
                           ,[REMAIN_LEAD_TIME]
                           ,[HOLDING_DATE]
                           ,[QTY]
                           ,[QTY2]
                           ,[OUTSOURCING_FLAG]
                           ,[FP_APPLY_ITEM_ID]
                           ,[FP_APPLY_WIPQTY]
                           ,[WIPHOLD_YN]
						   ,[QMS_HOLD_YN]
						   ,STOCK_STATUS -- kimcd 2023-11-28 재고 상태 구분용으로 STATUS_STATUS 컬럼 추가 형성
                           ,[INSERT_ID]
                           ,[INSERT_TIME]
                           ,[UPDATE_ID]
                           ,[UPDATE_TIME]
                       )
                       SELECT PM.COMPANY_ID     AS COMPANY_ID
                           , PM.DIVISION_ID     AS DIVISION_ID
                           , PM.SITE_ID	        AS SITE_ID
                           , PM.PLANT_ID	    AS PLANT_ID
                           , ISNULL(A.FACTORY_ID,'-')       AS FACTORY_ID
                           , A.STORAGE_ID       AS STORAGE_ID  -- 2023-09-20 kimcd 창고 코드 추가
                           , A.CUTOFF_DATE      AS CUTOFF_DATE
                           , 100000 + ROW_NUMBER() OVER( ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.[PLANT_ID], A.[ITEM_ID], ISNULL(A.STORAGE_ID, '-') DESC ) AS SEQ
                           , 'DW'               AS STOCK_TYPE  -- OWMS 재고 구분.. 2024-12-19 kimcd scm fp는 DW 코드 사용
                           , A.ITEM_ID          AS ITEM_ID
                           , A.CUTOFF_DATE      AS AVAILABLE_DATE
                           , 0                  AS REMAIN_LEAD_TIME
                           , GETDATE()          AS HOLDING_DATE
                           , A.AVAILABLE_QTY    AS QTY
                           , A.AVAILABLE_QTY    AS QTY2
                           , '-'                AS OUTSOURCING_FLAG
                           , A.ITEM_ID          AS FP_APPLY_ITEM_ID
                           , A.AVAILABLE_QTY    AS FP_APPLY_WIPQTY
                           , A.HOLD_YN          AS WIPHOLD_YN
						   , A.QMS_HOLD_YN      AS QMS_HOLD_YN
						   , A.STOCK_STATUS -- kimcd 2023-11-28 재고 상태 구분용으로 STATUS_STATUS 컬럼 추가 형성
                           ,'PR_XIF_LSP_STOCK_R'
                           , GETDATE()
                           , 'PR_XIF_LSP_STOCK_R'
                           , GETDATE()
                       FROM  (  SELECT C.CUTOFF_DATE
                                    ,C.DIVISION_ID
                                    ,C.ITEM_ID
                                    ,SUM(C.AVAILABLE_QTY)    AS AVAILABLE_QTY  -- 2023-10-04 kimcd 합산으로 수정
                                    ,C.PLANT_ID
                                    ,C.STORAGE_ID -- 2023-09-20 kimcd 창고 코드 추가
                                    ,C.COMPANY_ID
                                    ,C.FACTORY_ID
                                    ,C.HOLD_YN
									,C.QMS_HOLD_YN
									,C.STOCK_STATUS -- kimcd 2023-11-28 재고 상태 구분용으로 STATUS_STATUS 컬럼 추가 형성
                                FROM  (  SELECT DATEADD(D,1,CONVERT( DATE, ATTRIBUTE8, 112)) AS CUTOFF_DATE  --시업시간 기준셋팅
                                             ,PROD_GROUP                        AS DIVISION_ID
                                             ,ITEM_ID 							AS ITEM_ID
                                             --,STOCK_QTY - CASE WHEN PLANT_ID = 'G182' THEN BLOCK_QTY	
											 ,STOCK_QTY - CASE WHEN PLANT_ID IN ( SELECT CODE FROM @PLANT_ID_WA_E) THEN BLOCK_QTY	 --2024-10-15														
							    			  ELSE																							
							    				  CASE WHEN  BLOCK_QTY > LONG_QTY THEN  BLOCK_QTY													
							    					   WHEN  BLOCK_QTY < LONG_QTY THEN  LONG_QTY												
							    					   WHEN  BLOCK_QTY = LONG_QTY THEN  BLOCK_QTY												
							    				  END    																					
							    			  END			                    AS AVAILABLE_QTY  -- 2023-10-04 kimcd 수량 로직 GSCM과 동기화
                                             ,PLANT_ID							AS PLANT_ID
                                             ,ISNULL(STORAGE_ID, '-') 			AS STORAGE_ID  -- 2023-09-20 kimcd 창고 코드 추가
                                             ,ATTRIBUTE5                        AS COMPANY_ID
                                             ,ATTRIBUTE9                        AS FACTORY_ID
                                             ,'N'                               AS HOLD_YN
											 ,'N'                               AS QMS_HOLD_YN
											 ,CASE WHEN STOCK_STATUS = '00' THEN STOCK_STATUS END AS STOCK_STATUS -- kimcd 2023-11-28 재고 상태 구분용으로 STATUS_STATUS 컬럼 추가 형성
                                         FROM   DBO.SY_XIF_LSP_STOCK_R WITH(NOLOCK) 
                                         WHERE  1 = 1
                                           AND  MASTER_IF_SEQ	= @GROUP_SEQ
                                           -- AND  ATTRIBUTE5		= @COMPANY_ID
			                               AND  ATTRIBUTE8      = CONVERT(VARCHAR(8),@WORKDATE,112) -- @WORKDATE(DATE: YYYY-MM-DD) 2024-12-19 kimcd @COMPANY_ID 조건 제거 일자 조건 추가
                                           AND  STOCK_QTY       != 0
                                         UNION ALL
                                         SELECT DATEADD(D,1,CONVERT( DATE, ATTRIBUTE8, 112)) AS CUTOFF_DATE --시업시간 기준셋팅
                                             ,PROD_GROUP                        AS DIVISION_ID
                                             ,ITEM_ID 							AS ITEM_ID
                                             --,CASE WHEN PLANT_ID = 'G182' THEN BLOCK_QTY																
											 ,CASE WHEN PLANT_ID IN ( SELECT CODE FROM @PLANT_ID_WA_E ) THEN BLOCK_QTY	--2024-10-15																
							    			  ELSE																							
							    				  CASE WHEN  BLOCK_QTY > LONG_QTY THEN  BLOCK_QTY													
							    					   WHEN  BLOCK_QTY < LONG_QTY THEN  LONG_QTY												
							    					   WHEN  BLOCK_QTY = LONG_QTY THEN  BLOCK_QTY												
							    				  END    																					
							    			  END    							AS AVAILABLE_QTY -- 2023-10-04 kimcd 수량 로직 GSCM과 동기화
                                             ,PLANT_ID							AS PLANT_ID
                                             ,ISNULL(STORAGE_ID, '-') 			AS STORAGE_ID -- 2023-09-20 kimcd 창고 코드 추가
                                             ,ATTRIBUTE5                        AS COMPANY_ID
                                             ,ATTRIBUTE9                        AS FACTORY_ID
                                             ,'Y'                               AS HOLD_YN
											 ,'Y'                               AS QMS_HOLD_YN
											 ,CASE WHEN STOCK_STATUS = '00' THEN STOCK_STATUS END AS STOCK_STATUS -- kimcd 2023-11-28 재고 상태 구분용으로 STATUS_STATUS 컬럼 추가 형성
                                         FROM  DBO.SY_XIF_LSP_STOCK_R WITH(NOLOCK) 
                                         WHERE  1 = 1
                                           AND  MASTER_IF_SEQ	= @GROUP_SEQ
                                           -- AND  ATTRIBUTE5		= @COMPANY_ID
			                               AND  ATTRIBUTE8      = CONVERT(VARCHAR(8),@WORKDATE,112) -- @WORKDATE(DATE: YYYY-MM-DD) 2024-12-19 kimcd @COMPANY_ID 조건 제거 일자 조건 추가
                                           AND  ( BLOCK_QTY       != 0  OR LONG_QTY != 0 )  -- 2023-11-09 kimcd 조건 추가. 수량 누락 보완
                                 ) C
                                GROUP  BY C.CUTOFF_DATE
                                         ,C.DIVISION_ID
                                         ,C.ITEM_ID
										 ,C.PLANT_ID
                                         ,C.STORAGE_ID -- 2023-09-20 kimcd 창고 코드 추가
                                         ,C.COMPANY_ID
                                         ,C.FACTORY_ID
                                         ,C.HOLD_YN
										 ,C.QMS_HOLD_YN
										 ,C.STOCK_STATUS    -- kimcd 2023-11-28 재고 상태 구분용으로 STATUS_STATUS 컬럼 추가 형성
							) A
                            , SCM_PLANT_M  PM (NOLOCK)
                       WHERE  A.DIVISION_ID = PM.DIVISION_ID
                         AND  A.PLANT_ID    = PM.PLANT_ID
                         AND  A.COMPANY_ID  = PM.COMPANY_ID
                       ;

					    SET @ROWCOUNT = @@ROWCOUNT

--2023-10-09 주석처리
/*
					    -- CMA Assy로 품목 변경
					    UPDATE A
					    SET    [FP_APPLY_ITEM_ID] = B.CHILD_ITEM_ID
					    FROM   [dbo].[SCM_STOCK_H] A,
						    (    SELECT A.[COMPANY_ID],
						    			A.[DIVISION_ID],
						    			A.[SITE_ID],
						    			A.[PLANT_ID],
						    			A.[FACTORY_ID],
						    			A.[STORAGE_ID],
						    			A.[CUTOFF_DATE],
						    			A.[SEQ],
						    			B.CHILD_ITEM_ID                AS [CHILD_ITEM_ID],
						    			B.CHILD_QTY                    AS [REQ_QTY],
						    			ROW_NUMBER() OVER (  PARTITION BY  A.[COMPANY_ID],
						    												A.[DIVISION_ID],
						    												A.[SITE_ID],
						    												A.[PLANT_ID],
						    												A.[FACTORY_ID],
						    												A.[STORAGE_ID],
						    												A.[CUTOFF_DATE],
						    												A.[SEQ]
						    									ORDER BY CASE WHEN (B.ALT_PRIORITY  = 1 OR B.ALT_PRIORITY IS NULL) THEN 1 ELSE 2 END,  B.CHILD_ITEM_ID ) AS ROW_NUM
                                FROM   [dbo].[SCM_STOCK_H] A WITH(NOLOCK, INDEX([IX01_SCM_STOCK_H])),
                                       [dbo].[FP_RUNNING_CHANGE_M]   B WITH(NOLOCK), -- 2023-09-30 KIMJS SCM_BOM_M을 FP_RUNNING_CHANGE_M 으로 변경
                                       [dbo].[SCM_ITEM_M]  P WITH(NOLOCK),
                                       [dbo].[SCM_ITEM_M]  C WITH(NOLOCK),  --, INDEX(IX04_SCM_ITEM_M)
                                       [dbo].[FP_ITEM_M]   F WITH(NOLOCK)  -- 2023-09-19 KIMCD FP_ITEM_M 추가
                                WHERE  A.PLANT_ID          = B.PLANT_ID
                                AND    A.FP_APPLY_ITEM_ID  = B.PARENT_ITEM_ID
                                AND    A.CUTOFF_DATE       = DATEADD(D,1,@WORKDATE) --,'2023-09-21' --DATEADD(D,1,@WORKDATE)
                                AND    A.STOCK_TYPE        = 'OWMS'
                                AND    A.COMPANY_ID        = P.COMPANY_ID
                                AND    A.DIVISION_ID       = P.DIVISION_ID
                                AND    A.SITE_ID           = P.SITE_ID
                                AND    A.FP_APPLY_ITEM_ID  = P.ITEM_ID
                                AND    P.FLOW_ID           = 'P5500'
                                AND    A.COMPANY_ID        = C.COMPANY_ID  
                                AND    A.DIVISION_ID       = C.DIVISION_ID 
                                AND    A.SITE_ID           = C.SITE_ID  
                                AND    B.CHILD_ITEM_ID     = F.ITEM_ID
                                AND    B.CHILD_ITEM_ID     = C.ITEM_ID     
                                AND    C.COMPANY_ID        = F.COMPANY_ID
                                AND    C.DIVISION_ID       = F.DIVISION_ID
                                AND    C.SITE_ID           = F.SITE_ID
                                AND    C.ITEM_ID           = F.ITEM_ID
                                AND    C.FLOW_ID           IN ('P5000','P5200') 
                                AND    F.ACTIVE_FLAG       = 'Y'  -- 2023-09-19 KIMCD FP_ITEM_M 추가                                			    	

					    	  ) B
					    WHERE  A.[COMPANY_ID]  = B.[COMPANY_ID]
					    AND	   A.[DIVISION_ID] = B.[DIVISION_ID]
					    AND	   A.[SITE_ID]     = B.[SITE_ID]
					    AND	   A.[PLANT_ID]    = B.[PLANT_ID]
					    AND	   A.[FACTORY_ID]  = B.[FACTORY_ID]
					    AND	   A.[STORAGE_ID]  = B.[STORAGE_ID]
					    AND	   A.[CUTOFF_DATE] = B.[CUTOFF_DATE]
					    AND	   A.[SEQ]         = B.[SEQ]
					    AND    B.[ROW_NUM]     = 1
						;
*/
					    -- 2023-07-27 KIMJS	CMA Assy로 품목 변경
                           --XIF_LOG_HISTORY 저장
						INSERT INTO SY_XIF_LOG_HISTORY (
								[PROC_NAME],
								[LOG_TYPE],
								[LOG_COUNT],
								[MESSAGE],
								[EVENT_DTTM]
							) VALUES (
							    'PR_XIF_LSP_STOCK_R',
								'LOG',
								@ROWCOUNT,
								CONCAT(' @GROUP_SEQ > ', @GROUP_SEQ, ' @WORKDATE > ',@WORKDATE ),  -- 2024-12-19 kimcd @COMPANY_ID 조건 제거
								GETDATE()
							)
						;

						--PROC_FLAG = Y Update
					    UPDATE [dbo].[SY_XIF_LSP_STOCK_R]
						   SET PROC_FLAG = 'Y'
						      ,PROC_DATE = GETDATE()
						WHERE PROC_FLAG        = 'P'
						   AND  MASTER_IF_SEQ  = @GROUP_SEQ
						   AND  ATTRIBUTE8 = CONVERT(VARCHAR(8),@WORKDATE,112)  -- @WORKDATE(DATE: YYYY-MM-DD)
						;

						--2023-10-03 JYJ 최종 OWMS 수신여부 추가
                        MERGE INTO [DBO].[SCM_SYS_LOOKUP_VALUE] A
                        USING ( SELECT  ATTRIBUTE5 AS COMPANY_ID
								       ,CONVERT( NVARCHAR(8), GETDATE(), 112) AS EXEC_DATE
						        FROM   [dbo].[SY_XIF_LSP_STOCK_R]
						        WHERE  PROC_FLAG = 'P'
                            	AND    MASTER_IF_SEQ  = @GROUP_SEQ
						        AND    ATTRIBUTE8 = CONVERT(VARCHAR(8),@WORKDATE,112) -- @WORKDATE(DATE: YYYY-MM-DD)
								GROUP  BY ATTRIBUTE5
                        		  ) B
                        ON  (     A.LOOKUP_TYPE_CODE = 'OWMS_RECEIVE_FLAG'
                        	  AND A.SEGMENT1		= B.COMPANY_ID
                        	)
                        WHEN MATCHED THEN
                        UPDATE SET A.[ATTRIBUTE1]     = B.[EXEC_DATE]
                        		  ,A.[MODIFY_USER_ID] = 'PR_XIF_LSP_STOCK_R'        
                        		  ,A.[MODIFY_DATE]    = GETDATE() 
                        WHEN NOT MATCHED THEN
                        	INSERT ([LOOKUP_TYPE_CODE]
                        		  ,[SEGMENT1]
                        		  ,[SEGMENT2]
                        		  ,[SEGMENT3]
                        		  ,[SEGMENT4]
                        		  ,[SEGMENT5]
                        		  ,[ACTIVE_FLAG]
                        		  ,[CREATE_USER_ID]
                        		  ,[CREATE_DATE]
                        		  ,[MODIFY_USER_ID]
                        		  ,[MODIFY_DATE]
                        		  ,[ATTRIBUTE1]
                        	) VALUES (
                        		'OWMS_RECEIVE_FLAG'
                        	  ,B.COMPANY_ID
                        	  ,'-'
                        	  ,'-'
                        	  ,'-'
                        	  ,'-'
                        	  ,'Y'
                        	  ,'PR_XIF_LSP_STOCK_R'
                        	  ,GETDATE()
                        	  ,'PR_XIF_LSP_STOCK_R'
                        	  ,GETDATE()
                        	  ,B.[EXEC_DATE]
                        	);
					    /* 2023-11-28 kimcd owms 재형성 임시 조치 중단
						--2023-10-12 JYJ 1회만 수행 : FP계획에 있는 OWMS_STOCK수량기준으로 BOH수량 갱신
                        --IF @COMPANY_ID = 'G 480' 
						    BEGIN
							    --EXEC @v_rtncode = [ESWA_BFP_CEPA_A_P01].[dbo].PR_SCM_OF_AMEND_OWMS_STOCK ;

								IF @v_rtncode = 0
								    SET  @v_temp2 = 'LOG'
								ELSE
								    SET  @v_temp2 = 'ERROR'

                                --XIF_LOG_HISTORY 저장
						        INSERT INTO SY_XIF_LOG_HISTORY (
						        		[PROC_NAME],
						        		[LOG_TYPE],
						        		[LOG_COUNT],
						        		[MESSAGE],
						        		[EVENT_DTTM]
						        	) VALUES (
						        	    'PR_XIF_LSP_STOCK_R',
						        		@v_temp2,
						        		@v_rtncode,
						        		CONCAT('CALL PR_SCM_OF_AMEND_OWMS_STOCK > ', @COMPANY_ID  ),
						        		GETDATE()
						        	)
						        ;

							END*/

				    END

			        FETCH NEXT FROM CUR_IF_OWMS_STOCK INTO -- @COMPANY_ID   -- 2024-12-19 kimcd 조건 제거
                                                      @GROUP_SEQ
                                                     ,@WORKDATE
				--COMMIT TRAN
			END;

			CLOSE CUR_IF_OWMS_STOCK;
			DEALLOCATE CUR_IF_OWMS_STOCK;  

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		--COMMIT TRAN

		-- EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    --ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		SELECT @v_descr

		--에러방지 : [16915] 이름이 'CUR_FP_RELEASE'인 커서가 이미 있습니다.
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_IF_OWMS_STOCK')
            BEGIN
                CLOSE CUR_IF_OWMS_STOCK
                DEALLOCATE CUR_IF_OWMS_STOCK
            END

		UPDATE [dbo].[SY_XIF_LSP_STOCK_R] SET
			 PROC_FLAG = 'F'
			,PROC_DATE = GETDATE()
			,PROC_MSG  = @v_descr
		WHERE PROC_FLAG IN ('N', 'P')
		  AND  MASTER_IF_SEQ  = @GROUP_SEQ
		  AND  ATTRIBUTE8 = CONVERT(VARCHAR(8),@WORKDATE,112)
		;

		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

	EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END', NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate


END
