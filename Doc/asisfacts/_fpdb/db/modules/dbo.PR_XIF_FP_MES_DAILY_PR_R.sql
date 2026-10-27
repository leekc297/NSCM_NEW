
CREATE PROCEDURE [dbo].[PR_XIF_FP_MES_DAILY_PR_R]
--ALTER PROCEDURE [dbo].[PR_XIF_FP_MES_DAILY_PR_R]

-- ================================================================================================
-- Program ID          : FP0XXXXX
-- Program Name        : PR_XIF_FP_MES_DAILY_PR_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : FP(PFP0:MQ)
-- Destination System  : SCM(OFP0)
-- Source Table        : SCM_DAILY_PRODUCT_RESULT_H
-- Destination Table   : XIF_FP_MES_DAILY_PR_R
--
-- Create Date		   : 2023.06.06
-- Update Date		   : 


-- Author              : JYJ
-- Version             : 1.0 2023-06-01 jyj WA MES Daily Production Result 오창(OFP0)I/F 송신
--					                        Lookup 에서 DATABASE_MQ_SYSTEM_CODE 값으로  법인별 SYSCODE로 Interface ID 채번
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- ================================================
    -- Declare start
	-- ================================================
	-- LOG 용 변수 설정
	DECLARE @v_proc_name             NVARCHAR(100)         = 'PR_XIF_FP_MES_DAILY_PR_R';
	DECLARE @PROC_MSG                NVARCHAR(1000)        = NULL;
	DECLARE @PROC_FLAG               NVARCHAR(50)          = 'N';
	DECLARE @v_descr                 NVARCHAR(250)
	DECLARE @v_count                 INTEGER	            = 0
	DECLARE @sysdate                 DATETIME              = GETDATE()
						             
	DECLARE @ROWCOUNT                INTEGER
	DECLARE @DATA_COUNT              INTEGER = 0
	DECLARE @MAX_COUNT               INTEGER = 0

    DECLARE @INX                     INTEGER = 0;
    DECLARE @MAX_NUM                 INTEGER = 0;
	-- ERROR_LINE		             
	DECLARE @v_temp1                 NVARCHAR(1000)
	DECLARE @v_temp2                 NVARCHAR(1000)

	DECLARE @M_IF_ID NVARCHAR(50)
	DECLARE @M_SITE_ID NVARCHAR(50)
	DECLARE @M_GNRT_DTTM DATETIME
	DECLARE @IF_SEQ                  NVARCHAR(50)
	DECLARE @IF_ID                   NVARCHAR(50)
    DECLARE @COMPANY_ID              NVARCHAR(30)
    DECLARE @DIVISION_ID             NVARCHAR(30)
    DECLARE @SITE_ID                 NVARCHAR(30)
    DECLARE @PLANT_ID                NVARCHAR(30)
    DECLARE @FACTORY_ID              NVARCHAR(30)
    DECLARE @TOP_ITEM_ID             NVARCHAR(30)
    DECLARE @ITEM_ID                 NVARCHAR(150)
    DECLARE @OPERATION_ID            NVARCHAR(30)
    DECLARE @LOCATION                NVARCHAR(30)
    DECLARE @PRODUCTION_TYPE         NVARCHAR(30)
    DECLARE @MARKET                  NVARCHAR(30)
    DECLARE @LINE_ID                 NVARCHAR(30)
    DECLARE @ELECTRODE_TYPE          NVARCHAR(50)
    DECLARE @PLAN_DATE               DATETIME
    DECLARE @ACTUAL_QTY              NUMERIC(20,4)
    DECLARE @ACTUAL_GOOD_QTY         NUMERIC(20,4)
    DECLARE @ACTUAL_SCRAP_QTY        NUMERIC (20,4)
    DECLARE @QTY                     NUMERIC(18,5)
    DECLARE @QTY_LANE                NUMERIC(18,5)
    DECLARE @DFCT_QTY2               NUMERIC(18,5)
    DECLARE @LOSS_QTY2               NUMERIC(18,5)
    DECLARE @PRDT_REQ_QTY2           NUMERIC(18,5)
    DECLARE @TOP_COATING_QTY2        NUMERIC(18,5)
    DECLARE @YIELD_LOSS_QTY          NUMERIC(18,5)
    DECLARE @EQUIPMENT_ID            NVARCHAR(30)
    DECLARE @FP_PRODUCTION_TYPE      NVARCHAR(30)
    DECLARE @ROLL_IN_QTY             NUMERIC(20,5)
    DECLARE @ROLL_OUT_QTY            NUMERIC(20,5)
    DECLARE @JR_IN_QTY               NUMERIC(20,5)
    DECLARE @JR_OUT_QTY              NUMERIC(20,5)
    DECLARE @BATCH_IN_QTY            NUMERIC(20,5)
    DECLARE @BATCH_OUT_QTY           NUMERIC(20,5)
    DECLARE @CELL_IN_QTY             NUMERIC(20,5)
    DECLARE @CELL_OUT_QTY            NUMERIC(20,5)
    DECLARE @CELL_MATERIAL_ID        NVARCHAR(40)
    DECLARE @TOP_JR_OUT_QTY          NUMERIC(20,5)
    DECLARE @WORK_REQUEST_MODEL_ID   NVARCHAR(50)
    DECLARE @VERSION                 NVARCHAR(10)
    DECLARE @PROD_SEQ                NVARCHAR(50)
    DECLARE @PLM_EC_NO               NVARCHAR(50)
    DECLARE @GNRT_DTTM               DATETIME 
    DECLARE @ACCUM_COUNT             DECIMAL(18,5)


   DECLARE @TAB TABLE
   (
        [TID]                  INT IDENTITY(1,1)    NOT NULL PRIMARY KEY,
        [IF_ID]                [NVARCHAR](50),
        [SITE_ID]              [NVARCHAR](50),
        [GNRT_DTTM]            DATETIME,
		[ROW_COUNT]            INTEGER,
		[ACCUM_COUNT]          DECIMAL(18,5)
    );
	-- ================================================
    -- Declare end
	-- ================================================


	IF (SELECT CURSOR_STATUS('GLOBAL','CUR_FP_DPR')) >= -1
    BEGIN
        IF (SELECT CURSOR_STATUS('GLOBAL','CUR_FP_DPR')) > -1
        BEGIN
            CLOSE CUR_FP_DPR
        END

        DEALLOCATE CUR_FP_DPR
    END
    --###########################################
    --본처리
    --###########################################


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	INSERT INTO @TAB
    (   
          [IF_ID],    [SITE_ID],    [GNRT_DTTM],    [ROW_COUNT],    [ACCUM_COUNT]
    )
    SELECT IF_ID, SITE_ID, GNRT_DTTM
	      , COUNT(*), CAST(ISNULL(MAX(ACCUM_COUNT),0) AS INT)
    FROM  SY_XIF_FP_MES_DAILY_PR_R  WITH(NOLOCK)
    WHERE PROC_FLAG      = 'N'
    AND   IF_TYPE        = 'S'
	GROUP BY IF_ID,SITE_ID, GNRT_DTTM
	HAVING ( COUNT(1) = MAX(ACCUM_COUNT) 
				 OR ( COUNT(1) = 1 AND MAX(ACCUM_COUNT) = 0 )	-- 전체를 수신받지 못한 경우에는 처리하지 않음,실적이 없는 날은 ACCUM_COUNT가 0 으로 수신
			   )
	ORDER BY IF_ID, SITE_ID, GNRT_DTTM

    -- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	SELECT @INX     = 1
          ,@MAX_NUM = COUNT(*)
    FROM @TAB;

	WHILE @INX <= @MAX_NUM
    BEGIN
        BEGIN TRY

            BEGIN
                SELECT    
				     @M_IF_ID          = IF_ID         
                   , @M_SITE_ID        = SITE_ID       
                   , @M_GNRT_DTTM      = GNRT_DTTM
                FROM  @TAB
                WHERE TID = @INX;

                DECLARE CUR_FP_DPR CURSOR FOR
                SELECT D.IF_SEQ                 AS IF_SEQ
			         , D.COMPANY_ID             AS COMPANY_ID
                     , D.DIVISION_ID            AS DIVISION_ID
                     , D.SITE_ID                AS SITE_ID
                     , D.PLANT_ID               AS PLANT_ID
                     , D.FACTORY_ID             AS FACTORY_ID
                     , D.TOP_ITEM_ID            AS TOP_ITEM_ID
                     , D.ITEM_ID                AS ITEM_ID
                     , D.OPERATION_ID           AS OPERATION_ID
                     , D.LOCATION               AS LOCATION
                     , D.PRODUCTION_TYPE        AS PRODUCTION_TYPE
                     , D.MARKET                 AS MARKET
                     , D.LINE_ID                AS LINE_ID
                     , D.ELECTRODE_TYPE         AS ELECTRODE_TYPE
                     , D.PLAN_DATE              AS PLAN_DATE
                     , D.ACTUAL_QTY             AS ACTUAL_QTY
                     , D.ACTUAL_GOOD_QTY        AS ACTUAL_GOOD_QTY
                     , D.ACTUAL_SCRAP_QTY       AS ACTUAL_SCRAP_QTY
                     , D.QTY                    AS QTY
                     , D.QTY_LANE               AS QTY_LANE
                     , D.DFCT_QTY2              AS DFCT_QTY2
                     , D.LOSS_QTY2              AS LOSS_QTY2
                     , D.PRDT_REQ_QTY2          AS PRDT_REQ_QTY2
                     , D.TOP_COATING_QTY2       AS TOP_COATING_QTY2
                     , D.YIELD_LOSS_QTY         AS YIELD_LOSS_QTY
                     , D.EQUIPMENT_ID           AS EQUIPMENT_ID
                     , D.FP_PRODUCTION_TYPE     AS FP_PRODUCTION_TYPE
                     , D.ROLL_IN_QTY            AS ROLL_IN_QTY
                     , D.ROLL_OUT_QTY           AS ROLL_OUT_QTY
                     , D.JR_IN_QTY              AS JR_IN_QTY
                     , D.JR_OUT_QTY             AS JR_OUT_QTY
                     , D.BATCH_IN_QTY           AS BATCH_IN_QTY
                     , D.BATCH_OUT_QTY          AS BATCH_OUT_QTY
                     , D.CELL_IN_QTY            AS CELL_IN_QTY
                     , D.CELL_OUT_QTY           AS CELL_OUT_QTY
                     , D.CELL_MATERIAL_ID       AS CELL_MATERIAL_ID
                     , D.TOP_JR_OUT_QTY         AS TOP_JR_OUT_QTY
                     , D.WORK_REQUEST_MODEL_ID  AS WORK_REQUEST_MODEL_ID
                     , D.VERSION                AS VERSION
                     , D.PROD_SEQ               AS PROD_SEQ
                     , D.PLM_EC_NO              AS PLM_EC_NO
                     , D.GNRT_DTTM              AS GNRT_DTTM
                     , D.ACCUM_COUNT            AS ACCUM_COUNT
                FROM  SY_XIF_FP_MES_DAILY_PR_R D WITH(NOLOCK)
                WHERE D.PROC_FLAG      = 'N'
                AND   D.IF_ID          = @M_IF_ID
		        AND   D.SITE_ID        = @M_SITE_ID
			    AND   D.GNRT_DTTM      = @M_GNRT_DTTM
                ORDER BY D.IF_SEQ;

				SET @v_temp1 = 'STEP OPEN CURSOR'

                OPEN CUR_FP_DPR
                FETCH NEXT FROM CUR_FP_DPR INTO @IF_SEQ
                    ,@COMPANY_ID           	 ,@DIVISION_ID         ,@SITE_ID           ,@PLANT_ID           ,@FACTORY_ID           ,@TOP_ITEM_ID          
                    ,@ITEM_ID              	 ,@OPERATION_ID        ,@LOCATION          ,@PRODUCTION_TYPE    ,@MARKET               ,@LINE_ID              
                    ,@ELECTRODE_TYPE       	 ,@PLAN_DATE           ,@ACTUAL_QTY        ,@ACTUAL_GOOD_QTY    ,@ACTUAL_SCRAP_QTY     ,@QTY                  
                    ,@QTY_LANE             	 ,@DFCT_QTY2           ,@LOSS_QTY2         ,@PRDT_REQ_QTY2      ,@TOP_COATING_QTY2     ,@YIELD_LOSS_QTY       
                    ,@EQUIPMENT_ID         	 ,@FP_PRODUCTION_TYPE  ,@ROLL_IN_QTY       ,@ROLL_OUT_QTY       ,@JR_IN_QTY            ,@JR_OUT_QTY           
                    ,@BATCH_IN_QTY         	 ,@BATCH_OUT_QTY       ,@CELL_IN_QTY       ,@CELL_OUT_QTY       ,@CELL_MATERIAL_ID     ,@TOP_JR_OUT_QTY       
                    ,@WORK_REQUEST_MODEL_ID	 ,@VERSION             ,@PROD_SEQ          ,@PLM_EC_NO          ,@GNRT_DTTM            ,@ACCUM_COUNT          
        	    							
                WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
            	BEGIN

				     BEGIN TRAN

 		             UPDATE [dbo].[SY_XIF_FP_MES_DAILY_PR_R] SET
                         PROC_FLAG     = 'P'
                     WHERE PROC_FLAG   = 'N'
			          AND IF_SEQ       = @IF_SEQ
					  ;

            	 	 MERGE INTO SCM_DAILY_PRODUCT_RESULT_H DH
			         USING ( 
			             SELECT  @COMPANY_ID            AS COMPANY_ID
                                ,@DIVISION_ID           AS DIVISION_ID
                                ,@SITE_ID               AS SITE_ID
                                ,@PLANT_ID              AS PLANT_ID
                                ,@FACTORY_ID            AS FACTORY_ID
                                ,@TOP_ITEM_ID           AS TOP_ITEM_ID
                                ,@ITEM_ID               AS ITEM_ID
                                ,@OPERATION_ID          AS OPERATION_ID
                                ,@LOCATION              AS LOCATION
                                ,@PRODUCTION_TYPE       AS PRODUCTION_TYPE
                                ,@MARKET                AS MARKET
                                ,@LINE_ID               AS LINE_ID
                                ,@ELECTRODE_TYPE        AS ELECTRODE_TYPE
                                ,@PLAN_DATE             AS PLAN_DATE
                                ,@ACTUAL_QTY            AS ACTUAL_QTY
                                ,@ACTUAL_GOOD_QTY       AS ACTUAL_GOOD_QTY
                                ,@ACTUAL_SCRAP_QTY      AS ACTUAL_SCRAP_QTY
                                ,@QTY                   AS QTY
                                ,@QTY_LANE              AS QTY_LANE
                                ,@DFCT_QTY2             AS DFCT_QTY2
                                ,@LOSS_QTY2             AS LOSS_QTY2
                                ,@PRDT_REQ_QTY2         AS PRDT_REQ_QTY2
                                ,@TOP_COATING_QTY2      AS TOP_COATING_QTY2
                                ,@YIELD_LOSS_QTY        AS YIELD_LOSS_QTY
                                ,@EQUIPMENT_ID          AS EQUIPMENT_ID
                                ,@FP_PRODUCTION_TYPE    AS FP_PRODUCTION_TYPE
                                ,@ROLL_IN_QTY           AS ROLL_IN_QTY
                                ,@ROLL_OUT_QTY          AS ROLL_OUT_QTY
                                ,@JR_IN_QTY             AS JR_IN_QTY
                                ,@JR_OUT_QTY            AS JR_OUT_QTY
                                ,@BATCH_IN_QTY          AS BATCH_IN_QTY
                                ,@BATCH_OUT_QTY         AS BATCH_OUT_QTY
                                ,@CELL_IN_QTY           AS CELL_IN_QTY
                                ,@CELL_OUT_QTY          AS CELL_OUT_QTY
                                ,@CELL_MATERIAL_ID      AS CELL_MATERIAL_ID
                                ,@TOP_JR_OUT_QTY        AS TOP_JR_OUT_QTY
                                ,@WORK_REQUEST_MODEL_ID AS WORK_REQUEST_MODEL_ID
                                ,@VERSION               AS VERSION
                                ,@PROD_SEQ              AS PROD_SEQ
                                ,@PLM_EC_NO             AS PLM_EC_NO
                                ,@GNRT_DTTM             AS GNRT_DTTM
                                ,@ACCUM_COUNT           AS ACCUM_COUNT
			          ) S
			          ON (
			                    DH.COMPANY_ID            = S.COMPANY_ID
                            AND DH.DIVISION_ID           = S.DIVISION_ID
                            AND DH.SITE_ID               = S.SITE_ID
                            AND DH.PLANT_ID              = S.PLANT_ID
				            AND DH.FACTORY_ID            = S.FACTORY_ID
                            AND DH.TOP_ITEM_ID           = S.TOP_ITEM_ID
                            AND DH.ITEM_ID               = S.ITEM_ID
                            AND DH.OPERATION_ID          = S.OPERATION_ID
                            AND DH.MARKET                = S.MARKET
                            AND DH.LINE_ID               = S.LINE_ID
                            AND DH.ELECTRODE_TYPE        = S.ELECTRODE_TYPE
                            AND DH.PLAN_DATE             = S.PLAN_DATE
                            AND DH.EQUIPMENT_ID          = S.EQUIPMENT_ID
                            AND DH.FP_PRODUCTION_TYPE    = S.FP_PRODUCTION_TYPE
                            AND DH.WORK_REQUEST_MODEL_ID = S.WORK_REQUEST_MODEL_ID
                            AND DH.VERSION               = S.VERSION
                            AND DH.PROD_SEQ              = S.PROD_SEQ
                            AND DH.PLM_EC_NO             = S.PLM_EC_NO
			          ) 
			          WHEN MATCHED THEN
			          	UPDATE SET 
			          	    DH.LOCATION              = S.LOCATION
			          	   ,DH.PRODUCTION_TYPE       = S.PRODUCTION_TYPE
			          	   ,DH.ACTUAL_QTY            = S.ACTUAL_QTY
			          	   ,DH.ACTUAL_GOOD_QTY       = S.ACTUAL_GOOD_QTY
			          	   ,DH.ACTUAL_SCRAP_QTY      = S.ACTUAL_SCRAP_QTY
			          	   ,DH.QTY                   = S.QTY
			          	   ,DH.QTY_LANE              = S.QTY_LANE
			          	   ,DH.DFCT_QTY2             = S.DFCT_QTY2
			          	   ,DH.LOSS_QTY2             = S.LOSS_QTY2
			          	   ,DH.PRDT_REQ_QTY2         = S.PRDT_REQ_QTY2
			          	   ,DH.TOP_COATING_QTY2      = S.TOP_COATING_QTY2
			          	   ,DH.YIELD_LOSS_QTY        = S.YIELD_LOSS_QTY
			          	   ,DH.ROLL_IN_QTY           = S.ROLL_IN_QTY
			          	   ,DH.ROLL_OUT_QTY          = S.ROLL_OUT_QTY
			          	   ,DH.JR_IN_QTY             = S.JR_IN_QTY
			          	   ,DH.JR_OUT_QTY            = S.JR_OUT_QTY
			          	   ,DH.BATCH_IN_QTY          = S.BATCH_IN_QTY
			          	   ,DH.BATCH_OUT_QTY         = S.BATCH_OUT_QTY
			          	   ,DH.CELL_IN_QTY           = S.CELL_IN_QTY
			          	   ,DH.CELL_OUT_QTY          = S.CELL_OUT_QTY
			          	   ,DH.CELL_MATERIAL_ID      = S.CELL_MATERIAL_ID
			          	   ,DH.TOP_JR_OUT_QTY        = S.TOP_JR_OUT_QTY
			          WHEN NOT MATCHED THEN
			          	INSERT (
                                COMPANY_ID
                               ,DIVISION_ID
                               ,SITE_ID
                               ,PLANT_ID
                               ,FACTORY_ID
                               ,TOP_ITEM_ID
                               ,ITEM_ID
                               ,OPERATION_ID
                               ,LOCATION
                               ,PRODUCTION_TYPE
                               ,MARKET
                               ,LINE_ID
                               ,ELECTRODE_TYPE
                               ,PLAN_DATE
                               ,ACTUAL_QTY
                               ,ACTUAL_GOOD_QTY
                               ,ACTUAL_SCRAP_QTY
                               ,INSERT_ID
                               ,INSERT_TIME
                               ,UPDATE_ID
                               ,UPDATE_TIME
                               ,QTY
                               ,QTY_LANE
                               ,DFCT_QTY2
                               ,LOSS_QTY2
                               ,PRDT_REQ_QTY2
                               ,TOP_COATING_QTY2
                               ,YIELD_LOSS_QTY
                               ,EQUIPMENT_ID
                               ,FP_PRODUCTION_TYPE
                               ,ROLL_IN_QTY
                               ,ROLL_OUT_QTY
                               ,JR_IN_QTY
                               ,JR_OUT_QTY
                               ,BATCH_IN_QTY
                               ,BATCH_OUT_QTY
                               ,CELL_IN_QTY
                               ,CELL_OUT_QTY
                               ,CELL_MATERIAL_ID
                               ,TOP_JR_OUT_QTY
                               ,WORK_REQUEST_MODEL_ID
                               ,VERSION
                               ,PROD_SEQ
                               ,PLM_EC_NO					  
			          	) VALUES ( 
                               S.COMPANY_ID
                              ,S.DIVISION_ID
                              ,S.SITE_ID
                              ,S.PLANT_ID
                              ,S.FACTORY_ID
                              ,S.TOP_ITEM_ID
                              ,S.ITEM_ID
                              ,S.OPERATION_ID
                              ,S.LOCATION
                              ,S.PRODUCTION_TYPE
                              ,S.MARKET
                              ,S.LINE_ID
                              ,S.ELECTRODE_TYPE
                              ,S.PLAN_DATE
                              ,S.ACTUAL_QTY
                              ,S.ACTUAL_GOOD_QTY
                              ,S.ACTUAL_SCRAP_QTY
                              ,'PR_XIF_FP_MES_DAILY_PR_R'
                              ,GETDATE()
                              ,'PR_XIF_FP_MES_DAILY_PR_R'
                              ,GETDATE()
                              ,S.QTY
                              ,S.QTY_LANE
                              ,S.DFCT_QTY2
                              ,S.LOSS_QTY2
                              ,S.PRDT_REQ_QTY2
                              ,S.TOP_COATING_QTY2
                              ,S.YIELD_LOSS_QTY
                              ,S.EQUIPMENT_ID
                              ,S.FP_PRODUCTION_TYPE
                              ,S.ROLL_IN_QTY
                              ,S.ROLL_OUT_QTY
                              ,S.JR_IN_QTY
                              ,S.JR_OUT_QTY
                              ,S.BATCH_IN_QTY
                              ,S.BATCH_OUT_QTY
                              ,S.CELL_IN_QTY
                              ,S.CELL_OUT_QTY
                              ,S.CELL_MATERIAL_ID
                              ,S.TOP_JR_OUT_QTY
                              ,S.WORK_REQUEST_MODEL_ID
                              ,S.VERSION
                              ,S.PROD_SEQ
                              ,S.PLM_EC_NO
			          		);
            	 
                     UPDATE [dbo].[SY_XIF_FP_MES_DAILY_PR_R] SET
                         PROC_FLAG     = 'Y'
                        ,PROC_DATE     = GETDATE()
                     WHERE PROC_FLAG   = 'P'
                       AND IF_SEQ      = @IF_SEQ
                     ;

            	     FETCH NEXT FROM CUR_FP_DPR INTO @IF_SEQ
                        ,@COMPANY_ID           	   ,@DIVISION_ID           ,@SITE_ID           ,@PLANT_ID           ,@FACTORY_ID           ,@TOP_ITEM_ID          
                        ,@ITEM_ID              	   ,@OPERATION_ID          ,@LOCATION          ,@PRODUCTION_TYPE    ,@MARKET               ,@LINE_ID              
                        ,@ELECTRODE_TYPE       	   ,@PLAN_DATE             ,@ACTUAL_QTY        ,@ACTUAL_GOOD_QTY    ,@ACTUAL_SCRAP_QTY     ,@QTY                  
                        ,@QTY_LANE             	   ,@DFCT_QTY2             ,@LOSS_QTY2         ,@PRDT_REQ_QTY2      ,@TOP_COATING_QTY2     ,@YIELD_LOSS_QTY       
                        ,@EQUIPMENT_ID         	   ,@FP_PRODUCTION_TYPE    ,@ROLL_IN_QTY       ,@ROLL_OUT_QTY       ,@JR_IN_QTY            ,@JR_OUT_QTY           
                        ,@BATCH_IN_QTY         	   ,@BATCH_OUT_QTY         ,@CELL_IN_QTY       ,@CELL_OUT_QTY       ,@CELL_MATERIAL_ID     ,@TOP_JR_OUT_QTY       
                        ,@WORK_REQUEST_MODEL_ID	   ,@VERSION               ,@PROD_SEQ          ,@PLM_EC_NO          ,@GNRT_DTTM            ,@ACCUM_COUNT   
            	 
            	 
            	 	COMMIT TRAN
            	 
                    SET @v_count = @v_count + 1
            	 
                END  -- WHILE @@FETCH_STATUS = 0
			    
			    CLOSE CUR_FP_DPR;
                DEALLOCATE CUR_FP_DPR;   -- 메모리 해제

			END

        END TRY
        
        BEGIN CATCH
            ROLLBACK TRAN
        	
			SET @PROC_FLAG      = 'F'
            SET @PROC_MSG       = '[' + CONVERT(NVARCHAR(10), ERROR_NUMBER()) + '] ' + ERROR_MESSAGE()
			SET @v_descr        = Left(@PROC_MSG,250)
		
			--에러방지 : [16915] 이름이 'CUR_FP_DPR'인 커서가 이미 있습니다.
			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_FP_DPR')
                BEGIN
                    CLOSE CUR_FP_DPR
                    DEALLOCATE CUR_FP_DPR
                END		

        	EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
        
        END CATCH
    
	    SET @INX = @INX + 1
	END

	SET @v_temp1     = 'STEP END PROCEDURE'
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @v_count, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

    SET NOCOUNT OFF
END
