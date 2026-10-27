
CREATE PROCEDURE [dbo].[PR_XIF_FP_ADD_DEMAND_SYNC_R]

-- ================================================================================================
-- Program ID          :
-- Program Name        : PR_XIF_FP_ADD_DEMAND_SYNC_R
-- Param               :
-- Batch Period        : 30분
-- Description         : WA법인 기타 수요를 수신하여 반영
--
-- Source System       : WA FP
-- Destination System  : SCM FP
-- Source Table        : XIF_FP_ADD_DEMAND_R, XIF_FP_ADD_DEMAND_DETAIL_R
-- Destination Table   : FP_ADDITIONAL_DEMAND_M, FP_ADDITIONAL_DEMAND_DETAIL_M
--
-- Create(Update) Date : 2024-08-11
-- Author              : kimcd
-- Version             : 1.0 2024-08-11 kimcd  Initial creation
-- ================================================================================================

AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name             NVARCHAR(100) = 'PR_XIF_FP_ADD_DEMAND_SYNC_R'
	DECLARE @v_descr                 NVARCHAR(250)
	DECLARE @v_count                 INTEGER	   = 0
	DECLARE @sysdate                 DATETIME2     = GETDATE()
	DECLARE @PROC_MSG                NVARCHAR(1000)        = NULL;
	DECLARE @PROC_FLAG               NVARCHAR(50)          = 'N';
	-- ERROR_LINE
	DECLARE @v_temp1                 NVARCHAR(1000)
	DECLARE @v_temp2                 NVARCHAR(1000)

    IF (SELECT CURSOR_STATUS('GLOBAL','CUR_ADD_DEMAND')) >= -1
    BEGIN
        IF (SELECT CURSOR_STATUS('GLOBAL','CUR_ADD_DEMAND')) > -1
        BEGIN
            CLOSE CUR_ADD_DEMAND
        END

        DEALLOCATE CUR_ADD_DEMAND
    END

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- PROC_FLAG = 'N' 인터페이스된 데이타 추출
	DECLARE CUR_ADD_DEMAND CURSOR FOR
		SELECT P.[IF_SEQ]
		     , P.[REQUEST_ID]
             , P.[APPR_TITLE]
             , P.[DESCRIPTION]
             , P.[MODEL_ID]
             , P.[PRODUCTION_TYPE]
             , P.[ECO_CODE]
             , P.[MARKET]
             , P.[PIC]
             , P.[DUE_DATE]
             , P.[DISCARD_COST]
             , P.[CURRENCY]
             , P.[APPROVAL_STATUS]
             , P.[APPR_DOC_NO]
             , P.[APPR_PLANNER]
             , P.[PLANNING_TIME]
             , P.[COMPLETE_FLAG]
             , P.[INSERT_ID]
             , P.[INSERT_TIME]
             , P.[UPDATE_ID]
             , P.[UPDATE_TIME]
             , P.[ATTRIBUTE1]
             , P.[ATTRIBUTE2]
             , P.[ATTRIBUTE3]
             , P.[ATTRIBUTE4]
             , P.[ATTRIBUTE5]
             , P.[ATTRIBUTE6]
             , P.[ATTRIBUTE7]
             , P.[ATTRIBUTE8]
             , P.[ATTRIBUTE9]
             , P.[ATTRIBUTE10]
             , P.[DEL_FLAG]
             , P.[TEMP_FLAG]
             , P.[REQUEST_TIME]
		 FROM [dbo].SY_XIF_FP_ADD_DEMAND_R P
		 WHERE 1=1
         AND P.PROC_FLAG = 'N'
         AND NOT EXISTS (  SELECT 1 
                           FROM   [dbo].SY_XIF_FP_ADD_DEMAND_R S 
                           INNER JOIN [dbo].SY_XIF_FP_ADD_DEMAND_DETAIL_R D
                               ON  S.[REQUEST_ID]   = D.[REQUEST_ID]
                               AND S.[IF_SEQ]       = D.[ATTRIBUTE10]
                           WHERE S.[REQUEST_ID]    = P.[REQUEST_ID]
                           AND   S.PROC_FLAG       = 'N'
                           GROUP BY S.[REQUEST_ID], S.[IF_SEQ]
                           HAVING MAX(D.ACCUM_COUNT) != COUNT(*) )
         AND EXISTS (  SELECT 1 
                       FROM   [dbo].SY_XIF_FP_ADD_DEMAND_DETAIL_R D
                       WHERE  P.[REQUEST_ID]   = D.[REQUEST_ID]
                         AND  P.[IF_SEQ]       = D.[ATTRIBUTE10]
                       GROUP BY D.[REQUEST_ID], D.[ATTRIBUTE10]
                       HAVING MAX(D.ACCUM_COUNT) = COUNT(*) )
 		ORDER BY P.[IF_SEQ];


	DECLARE @IF_SEQ	          NVARCHAR(50);
	DECLARE @REQUEST_ID       NVARCHAR(50);
	DECLARE @APPR_TITLE       NVARCHAR(200);
	DECLARE @DESCRIPTION      NVARCHAR(400);
	DECLARE @MODEL_ID         NVARCHAR(40);
	DECLARE @PRODUCTION_TYPE  NVARCHAR(30);
	DECLARE @ECO_CODE         NVARCHAR(30);
	DECLARE @MARKET           NVARCHAR(10);
	DECLARE @PIC              NVARCHAR(150);
	DECLARE @DUE_DATE         DATE;
	DECLARE @DISCARD_COST     NUMERIC(20, 5);
	DECLARE @CURRENCY         NVARCHAR(10);
	DECLARE @APPROVAL_STATUS  NVARCHAR(30);
	DECLARE @APPR_DOC_NO      NVARCHAR(100);
	DECLARE @APPR_PLANNER     NVARCHAR(150);
	DECLARE @PLANNING_TIME    DATETIME;
	DECLARE @COMPLETE_FLAG    NVARCHAR(10);
	DECLARE @INSERT_ID        NVARCHAR(150);
	DECLARE @INSERT_TIME      DATETIME;
	DECLARE @UPDATE_ID        NVARCHAR(150);
	DECLARE @UPDATE_TIME      DATETIME;
	DECLARE @ATTRIBUTE1       NVARCHAR(200);
	DECLARE @ATTRIBUTE2       NVARCHAR(200);
	DECLARE @ATTRIBUTE3       NVARCHAR(200);
	DECLARE @ATTRIBUTE4       NVARCHAR(200);
	DECLARE @ATTRIBUTE5       NVARCHAR(200);
	DECLARE @ATTRIBUTE6       NVARCHAR(200);
	DECLARE @ATTRIBUTE7       NVARCHAR(200);
	DECLARE @ATTRIBUTE8       NVARCHAR(200);
	DECLARE @ATTRIBUTE9       NVARCHAR(200);
	DECLARE @ATTRIBUTE10      NVARCHAR(200);
	DECLARE @DEL_FLAG         NVARCHAR(1);
	DECLARE @TEMP_FLAG        NVARCHAR(1);
	DECLARE @REQUEST_TIME     DATETIME;

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가
		-- ================================================

		--  최근 2일 데이터 가져와서 INF 테이블에 존재하지 않는 데이터만 전송
		OPEN CUR_ADD_DEMAND;
		
		FETCH NEXT FROM CUR_ADD_DEMAND INTO 
             @IF_SEQ	   ,@REQUEST_ID     ,@APPR_TITLE          ,@DESCRIPTION      ,@MODEL_ID             ,@PRODUCTION_TYPE          ,@ECO_CODE
	        ,@MARKET       ,@PIC            ,@DUE_DATE            ,@DISCARD_COST     ,@CURRENCY             ,@APPROVAL_STATUS          ,@APPR_DOC_NO
	        ,@APPR_PLANNER ,@PLANNING_TIME  ,@COMPLETE_FLAG       ,@INSERT_ID        ,@INSERT_TIME          ,@UPDATE_ID                ,@UPDATE_TIME
	        ,@ATTRIBUTE1   ,@ATTRIBUTE2     ,@ATTRIBUTE3          ,@ATTRIBUTE4       ,@ATTRIBUTE5           ,@ATTRIBUTE6               ,@ATTRIBUTE7
	        ,@ATTRIBUTE8   ,@ATTRIBUTE9     ,@ATTRIBUTE10         ,@DEL_FLAG         ,@TEMP_FLAG            ,@REQUEST_TIME;

		WHILE (@@FETCH_STATUS = 0)
            BEGIN
                BEGIN TRAN

                UPDATE [dbo].[SY_XIF_FP_ADD_DEMAND_R] SET
                     PROC_FLAG     = 'P'
                WHERE PROC_FLAG    = 'N'
                AND   IF_SEQ       = @IF_SEQ
                ;
                UPDATE [dbo].[SY_XIF_FP_ADD_DEMAND_DETAIL_R] SET
                    PROC_FLAG      = 'P'
                WHERE PROC_FLAG    = 'N'
				AND   REQUEST_ID   = @REQUEST_ID
                AND   ATTRIBUTE10  = @IF_SEQ
                ;
                -- MASTER TABLE
                MERGE INTO  [dbo].[FP_ADDITIONAL_DEMAND_M]   ADM
                USING ( 
                       SELECT @REQUEST_ID		  AS REQUEST_ID
	                         ,@APPR_TITLE		  AS APPR_TITLE
	                         ,@DESCRIPTION		  AS DESCRIPTION
	                         ,@MODEL_ID			  AS MODEL_ID
	                         ,@PRODUCTION_TYPE	  AS PRODUCTION_TYPE
	                         ,@ECO_CODE			  AS ECO_CODE
	                         ,@MARKET			  AS MARKET
	                         ,@PIC				  AS PIC
	                         ,@DUE_DATE			  AS DUE_DATE
	                         ,@DISCARD_COST		  AS DISCARD_COST
	                         ,@CURRENCY			  AS CURRENCY
	                         ,@APPROVAL_STATUS	  AS APPROVAL_STATUS
	                         ,@APPR_DOC_NO		  AS APPR_DOC_NO
	                         ,@APPR_PLANNER		  AS APPR_PLANNER
	                         ,@PLANNING_TIME	  AS PLANNING_TIME
	                         ,@COMPLETE_FLAG	  AS COMPLETE_FLAG
	                         ,@INSERT_ID		  AS INSERT_ID
	                         ,@INSERT_TIME		  AS INSERT_TIME
	                         ,@UPDATE_ID		  AS UPDATE_ID
	                         ,@UPDATE_TIME		  AS UPDATE_TIME
	                         ,@ATTRIBUTE1		  AS ATTRIBUTE1
	                         ,@ATTRIBUTE2		  AS ATTRIBUTE2
	                         ,@ATTRIBUTE3		  AS ATTRIBUTE3
	                         ,@ATTRIBUTE4		  AS ATTRIBUTE4
	                         ,@ATTRIBUTE5		  AS ATTRIBUTE5
	                         ,@ATTRIBUTE6		  AS ATTRIBUTE6
	                         ,@ATTRIBUTE7		  AS ATTRIBUTE7
	                         ,@ATTRIBUTE8		  AS ATTRIBUTE8
	                         ,@ATTRIBUTE9		  AS ATTRIBUTE9
	                         ,@ATTRIBUTE10		  AS ATTRIBUTE10
	                         ,@DEL_FLAG			  AS DEL_FLAG
	                         ,@TEMP_FLAG		  AS TEMP_FLAG
	                         ,@REQUEST_TIME       AS REQUEST_TIME
                    )   XXX
                ON (  ADM.REQUEST_ID       = XXX.REQUEST_ID
                    )
                WHEN MATCHED THEN
                    UPDATE SET ADM.APPR_TITLE	   = XXX.APPR_TITLE
	                         , ADM.DESCRIPTION	   = XXX.DESCRIPTION
	                         , ADM.MODEL_ID		   = XXX.MODEL_ID
	                         , ADM.PRODUCTION_TYPE = XXX.PRODUCTION_TYPE
	                         , ADM.ECO_CODE		   = XXX.ECO_CODE
	                         , ADM.MARKET		   = XXX.MARKET
	                         , ADM.PIC			   = XXX.PIC
	                         , ADM.DUE_DATE		   = XXX.DUE_DATE
	                         , ADM.DISCARD_COST	   = XXX.DISCARD_COST
	                         , ADM.CURRENCY		   = XXX.CURRENCY
	                         , ADM.APPROVAL_STATUS = XXX.APPROVAL_STATUS
	                         , ADM.APPR_DOC_NO	   = XXX.APPR_DOC_NO
	                         , ADM.APPR_PLANNER	   = XXX.APPR_PLANNER
	                         , ADM.PLANNING_TIME   = XXX.PLANNING_TIME
	                         , ADM.COMPLETE_FLAG   = XXX.COMPLETE_FLAG
	                         , ADM.INSERT_ID	   = XXX.INSERT_ID
	                         , ADM.INSERT_TIME	   = XXX.INSERT_TIME
	                         , ADM.UPDATE_ID	   = XXX.UPDATE_ID
	                         , ADM.UPDATE_TIME	   = XXX.UPDATE_TIME
	                         , ADM.ATTRIBUTE1	   = XXX.ATTRIBUTE1
	                         , ADM.ATTRIBUTE2	   = XXX.ATTRIBUTE2
	                         , ADM.ATTRIBUTE3	   = XXX.ATTRIBUTE3
	                         , ADM.ATTRIBUTE4	   = XXX.ATTRIBUTE4
	                         , ADM.ATTRIBUTE5	   = XXX.ATTRIBUTE5
	                         , ADM.ATTRIBUTE6	   = XXX.ATTRIBUTE6
	                         , ADM.ATTRIBUTE7	   = XXX.ATTRIBUTE7
	                         , ADM.ATTRIBUTE8	   = XXX.ATTRIBUTE8
	                         , ADM.ATTRIBUTE9	   = XXX.ATTRIBUTE9
	                         , ADM.ATTRIBUTE10	   = XXX.ATTRIBUTE10
	                         , ADM.DEL_FLAG		   = XXX.DEL_FLAG
	                         , ADM.TEMP_FLAG	   = XXX.TEMP_FLAG
	                         , ADM.REQUEST_TIME    = XXX.REQUEST_TIME
                WHEN NOT MATCHED THEN
                    INSERT 
                        ( [REQUEST_ID]
                        , [APPR_TITLE]
                        , [DESCRIPTION]
                        , [MODEL_ID]
                        , [PRODUCTION_TYPE]
                        , [ECO_CODE]
                        , [MARKET]
                        , [PIC]
                        , [DUE_DATE]
                        , [DISCARD_COST]
                        , [CURRENCY]
                        , [APPROVAL_STATUS]
                        , [APPR_DOC_NO]
                        , [APPR_PLANNER]
                        , [PLANNING_TIME]
                        , [COMPLETE_FLAG]
                        , [INSERT_ID]
                        , [INSERT_TIME]
                        , [UPDATE_ID]
                        , [UPDATE_TIME]
                        , [ATTRIBUTE1]
                        , [ATTRIBUTE2]
                        , [ATTRIBUTE3]
                        , [ATTRIBUTE4]
                        , [ATTRIBUTE5]
                        , [ATTRIBUTE6]
                        , [ATTRIBUTE7]
                        , [ATTRIBUTE8]
                        , [ATTRIBUTE9]
                        , [ATTRIBUTE10]
                        , [DEL_FLAG]
                        , [TEMP_FLAG]
                        , [REQUEST_TIME]
                        )
                    VALUES
                        ( XXX.REQUEST_ID 
						, XXX.APPR_TITLE
						, XXX.DESCRIPTION
						, XXX.MODEL_ID
						, XXX.PRODUCTION_TYPE
						, XXX.ECO_CODE
						, XXX.MARKET
						, XXX.PIC
						, XXX.DUE_DATE
						, XXX.DISCARD_COST
						, XXX.CURRENCY
						, XXX.APPROVAL_STATUS
						, XXX.APPR_DOC_NO
						, XXX.APPR_PLANNER
						, XXX.PLANNING_TIME
						, XXX.COMPLETE_FLAG
						, XXX.INSERT_ID
						, XXX.INSERT_TIME
						, XXX.UPDATE_ID
						, XXX.UPDATE_TIME
						, XXX.ATTRIBUTE1
						, XXX.ATTRIBUTE2
						, XXX.ATTRIBUTE3
						, XXX.ATTRIBUTE4
						, XXX.ATTRIBUTE5
						, XXX.ATTRIBUTE6
						, XXX.ATTRIBUTE7
						, XXX.ATTRIBUTE8
						, XXX.ATTRIBUTE9
						, XXX.ATTRIBUTE10
						, XXX.DEL_FLAG
						, XXX.TEMP_FLAG
						, XXX.REQUEST_TIME
                        );		

                --DETAIL
                MERGE INTO  [dbo].[FP_ADDITIONAL_DEMAND_DETAIL_M]   ADM
                USING ( 
                       SELECT ADR.[REQUEST_ID]
                            , ADR.[REQUEST_SEQ]
                            , ADR.[COMPANY_ID]
                            , ADR.[DIVISION_ID]
                            , ADR.[SITE_ID]
                            , ADR.[PLANT_ID]
                            , ADR.[FACTORY_ID]
                            , ADR.[OPERATION_ID]
                            , ADR.[LINE_ID]
                            , ADR.[EQUIPMENT_ID]
                            , ADR.[ITEM_ID]
                            , ADR.[PLAN_DATE]
                            , ADR.[START_TIME]
                            , ADR.[END_TIME]
                            , ADR.[UOM]
                            , ADR.[PLAN_QTY]
                            , ADR.[ORG_QTY]
                            , ADR.[YIELD]
                            , ADR.[WORK_REQUEST_MODEL_ID]
                            , ADR.[VERSION]
                            , ADR.[COMMENTS]
                            , ADR.[WORK_ORDER_ID]
                            , ADR.[WO_STATUS]
                            , ADR.[RESULT_QTY]
                            , ADR.[COMPLETE_FLAG]
                            , ADR.[INSERT_ID]
                            , ADR.[INSERT_TIME]
                            , ADR.[UPDATE_ID]
                            , ADR.[UPDATE_TIME]
                            , ADR.[ATTRIBUTE1]
                            , ADR.[ATTRIBUTE2]
                            , ADR.[ATTRIBUTE3]
                            , ADR.[ATTRIBUTE4]
                            , ADR.[ATTRIBUTE5]
                            , ADR.[ATTRIBUTE6]
                            , ADR.[ATTRIBUTE7]
                            , ADR.[ATTRIBUTE8]
                            , ADR.[ATTRIBUTE9]
                            , ADR.[ATTRIBUTE10]
                            , ADR.[DEL_FLAG]
                            , ADR.[TEMP_FLAG]
                       FROM   SY_XIF_FP_ADD_DEMAND_DETAIL_R ADR
					   WHERE  ADR.[REQUEST_ID]  = @REQUEST_ID
					   AND    ADR.[ATTRIBUTE10] = @IF_SEQ
                )  ADR
                ON (     ADM.[REQUEST_ID]  = ADR.[REQUEST_ID]
				     AND ADM.[REQUEST_SEQ] = ADR.[REQUEST_SEQ]
                    )
                WHEN MATCHED THEN
                    UPDATE SET ADM.[COMPANY_ID]            = ADR.[COMPANY_ID]
                             , ADM.[DIVISION_ID]           = ADR.[DIVISION_ID]
                             , ADM.[SITE_ID]               = ADR.[SITE_ID]
                             , ADM.[PLANT_ID]              = ADR.[PLANT_ID]
                             , ADM.[FACTORY_ID]            = ADR.[FACTORY_ID]
                             , ADM.[OPERATION_ID]          = ADR.[OPERATION_ID]
                             , ADM.[LINE_ID]               = ADR.[LINE_ID]
                             , ADM.[EQUIPMENT_ID]          = ADR.[EQUIPMENT_ID]
                             , ADM.[ITEM_ID]               = ADR.[ITEM_ID]
                             , ADM.[PLAN_DATE]             = ADR.[PLAN_DATE]
                             , ADM.[START_TIME]            = ADR.[START_TIME]
                             , ADM.[END_TIME]              = ADR.[END_TIME]
                             , ADM.[UOM]                   = ADR.[UOM]
                             , ADM.[PLAN_QTY]              = ADR.[PLAN_QTY]
                             , ADM.[ORG_QTY]               = ADR.[ORG_QTY]
                             , ADM.[YIELD]                 = ADR.[YIELD]
                             , ADM.[WORK_REQUEST_MODEL_ID] = ADR.[WORK_REQUEST_MODEL_ID]
                             , ADM.[VERSION]               = ADR.[VERSION]
                             , ADM.[COMMENTS]              = ADR.[COMMENTS]
                             , ADM.[WORK_ORDER_ID]         = ADR.[WORK_ORDER_ID]
                             , ADM.[WO_STATUS]             = ADR.[WO_STATUS]
                             , ADM.[RESULT_QTY]            = ADR.[RESULT_QTY]
                             , ADM.[COMPLETE_FLAG]         = ADR.[COMPLETE_FLAG]
                             , ADM.[INSERT_ID]             = ADR.[INSERT_ID]
                             , ADM.[INSERT_TIME]           = ADR.[INSERT_TIME]
                             , ADM.[UPDATE_ID]             = ADR.[UPDATE_ID]
                             , ADM.[UPDATE_TIME]           = ADR.[UPDATE_TIME]
                             , ADM.[ATTRIBUTE1]            = ADR.[ATTRIBUTE1]
                             , ADM.[ATTRIBUTE2]            = ADR.[ATTRIBUTE2]
                             , ADM.[ATTRIBUTE3]            = ADR.[ATTRIBUTE3]
                             , ADM.[ATTRIBUTE4]            = ADR.[ATTRIBUTE4]
                             , ADM.[ATTRIBUTE5]            = ADR.[ATTRIBUTE5]
                             , ADM.[ATTRIBUTE6]            = ADR.[ATTRIBUTE6]
                             , ADM.[ATTRIBUTE7]            = ADR.[ATTRIBUTE7]
                             , ADM.[ATTRIBUTE8]            = ADR.[ATTRIBUTE8]
                             , ADM.[ATTRIBUTE9]            = ADR.[ATTRIBUTE9]
                             , ADM.[ATTRIBUTE10]           = ADR.[ATTRIBUTE10]
                             , ADM.[DEL_FLAG]              = ADR.[DEL_FLAG]
                             , ADM.[TEMP_FLAG]             = ADR.[TEMP_FLAG]
                WHEN NOT MATCHED THEN
                    INSERT 
                        ( [REQUEST_ID]
                        , [REQUEST_SEQ]
                        , [COMPANY_ID]
                        , [DIVISION_ID]
                        , [SITE_ID]
                        , [PLANT_ID]
                        , [FACTORY_ID]
                        , [OPERATION_ID]
                        , [LINE_ID]
                        , [EQUIPMENT_ID]
                        , [ITEM_ID]
                        , [PLAN_DATE]
                        , [START_TIME]
                        , [END_TIME]
                        , [UOM]
                        , [PLAN_QTY]
                        , [ORG_QTY]
                        , [YIELD]
                        , [WORK_REQUEST_MODEL_ID]
                        , [VERSION]
                        , [COMMENTS]
                        , [WORK_ORDER_ID]
                        , [WO_STATUS]
                        , [RESULT_QTY]
                        , [COMPLETE_FLAG]
                        , [INSERT_ID]
                        , [INSERT_TIME]
                        , [UPDATE_ID]
                        , [UPDATE_TIME]
                        , [ATTRIBUTE1]
                        , [ATTRIBUTE2]
                        , [ATTRIBUTE3]
                        , [ATTRIBUTE4]
                        , [ATTRIBUTE5]
                        , [ATTRIBUTE6]
                        , [ATTRIBUTE7]
                        , [ATTRIBUTE8]
                        , [ATTRIBUTE9]
                        , [ATTRIBUTE10]
                        , [DEL_FLAG]
                        , [TEMP_FLAG])
                    VALUES 
                        ( ADR.[REQUEST_ID]
                        , ADR.[REQUEST_SEQ]
                        , ADR.[COMPANY_ID]
                        , ADR.[DIVISION_ID]
                        , ADR.[SITE_ID]
                        , ADR.[PLANT_ID]
                        , ADR.[FACTORY_ID]
                        , ADR.[OPERATION_ID]
                        , ADR.[LINE_ID]
                        , ADR.[EQUIPMENT_ID]
                        , ADR.[ITEM_ID]
                        , ADR.[PLAN_DATE]
                        , ADR.[START_TIME]
                        , ADR.[END_TIME]
                        , ADR.[UOM]
                        , ADR.[PLAN_QTY]
                        , ADR.[ORG_QTY]
                        , ADR.[YIELD]
                        , ADR.[WORK_REQUEST_MODEL_ID]
                        , ADR.[VERSION]
                        , ADR.[COMMENTS]
                        , ADR.[WORK_ORDER_ID]
                        , ADR.[WO_STATUS]
                        , ADR.[RESULT_QTY]
                        , ADR.[COMPLETE_FLAG]
                        , ADR.[INSERT_ID]
                        , ADR.[INSERT_TIME]
                        , ADR.[UPDATE_ID]
                        , ADR.[UPDATE_TIME]
                        , ADR.[ATTRIBUTE1]
                        , ADR.[ATTRIBUTE2]
                        , ADR.[ATTRIBUTE3]
                        , ADR.[ATTRIBUTE4]
                        , ADR.[ATTRIBUTE5]
                        , ADR.[ATTRIBUTE6]
                        , ADR.[ATTRIBUTE7]
                        , ADR.[ATTRIBUTE8]
                        , ADR.[ATTRIBUTE9]
                        , ADR.[ATTRIBUTE10]
                        , ADR.[DEL_FLAG]
                        , ADR.[TEMP_FLAG]
                        );	

                UPDATE [dbo].[SY_XIF_FP_ADD_DEMAND_R]
                    SET PROC_FLAG    = 'Y'				
                       ,PROC_DATE    = GETDATE()
                WHERE IF_SEQ         = @IF_SEQ  
                AND PROC_FLAG        = 'P'
                ;

                UPDATE [dbo].[SY_XIF_FP_ADD_DEMAND_DETAIL_R]
                    SET PROC_FLAG    = 'Y'				
                       ,PROC_DATE    = GETDATE()
                WHERE REQUEST_ID   = @REQUEST_ID
                AND   ATTRIBUTE10  = @IF_SEQ 
                AND PROC_FLAG      = 'P'
                ;

        		FETCH NEXT FROM CUR_ADD_DEMAND INTO 
                     @IF_SEQ	   ,@REQUEST_ID     ,@APPR_TITLE          ,@DESCRIPTION      ,@MODEL_ID             ,@PRODUCTION_TYPE          ,@ECO_CODE
        	        ,@MARKET       ,@PIC            ,@DUE_DATE            ,@DISCARD_COST     ,@CURRENCY             ,@APPROVAL_STATUS          ,@APPR_DOC_NO
        	        ,@APPR_PLANNER ,@PLANNING_TIME  ,@COMPLETE_FLAG       ,@INSERT_ID        ,@INSERT_TIME          ,@UPDATE_ID                ,@UPDATE_TIME
        	        ,@ATTRIBUTE1   ,@ATTRIBUTE2     ,@ATTRIBUTE3          ,@ATTRIBUTE4       ,@ATTRIBUTE5           ,@ATTRIBUTE6               ,@ATTRIBUTE7
        	        ,@ATTRIBUTE8   ,@ATTRIBUTE9     ,@ATTRIBUTE10         ,@DEL_FLAG         ,@TEMP_FLAG            ,@REQUEST_TIME;


		        COMMIT TRAN

		    END

		    CLOSE CUR_ADD_DEMAND;
		    DEALLOCATE CUR_ADD_DEMAND;

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
    END TRY

    BEGIN CATCH

        ROLLBACK TRAN

        -- 에러나도 로그는 인서트
        SET @PROC_FLAG      = 'F'
        SET @PROC_MSG       = '[' + CONVERT(NVARCHAR(10), ERROR_NUMBER()) + '] ' + ERROR_MESSAGE()
        SET @v_descr        = ERROR_MESSAGE()
        
		UPDATE [dbo].[SY_XIF_FP_ADD_DEMAND_R]
            SET PROC_FLAG    = @PROC_FLAG			
               ,PROC_MSG     = @PROC_MSG
        WHERE IF_SEQ         = @IF_SEQ  
        AND   PROC_FLAG     IN ('N', 'P')
        ;
        
        UPDATE [dbo].[SY_XIF_FP_ADD_DEMAND_DETAIL_R]
            SET PROC_FLAG    = @PROC_FLAG			
               ,PROC_MSG     = @PROC_MSG
        WHERE REQUEST_ID   = @REQUEST_ID
		AND   ATTRIBUTE10  = @IF_SEQ  
        AND   PROC_FLAG   IN ('N', 'P')
        ;       
        --에러방지 : [16915] 이름이 'CUR_ADD_DEMAND'인 커서가 이미 있습니다.
        IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_ADD_DEMAND')
            BEGIN
                CLOSE CUR_ADD_DEMAND
                DEALLOCATE CUR_ADD_DEMAND
            END
            
        EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

    END CATCH

    SET NOCOUNT OFF
END
