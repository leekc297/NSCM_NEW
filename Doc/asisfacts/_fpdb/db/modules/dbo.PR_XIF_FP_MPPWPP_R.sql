
CREATE       PROCEDURE [dbo].[PR_XIF_FP_MPPWPP_R]

-- ================================================================================================
-- Program ID          :
-- Program Name        : PR_XIF_FP_MPPWPP_R
-- Param               :
-- Batch Period        : 30분
-- Description         : WA법인 FP(MPP/WPP)변경계획 반영
--
-- Source System       : 오창 FP
-- Destination System  : WA FP
-- Source Table        : FP_MPP_WPP_BASE_PLAN_H, FP_MPP_WPP_BASE_PLAN_M
-- Destination Table   : XIF_FP_MPPWPP_R, XIF_FP_MPPWPP_DETAIL_R
--
-- Create(Update) Date : 2023-06-08
-- Author              : JYJ
-- Version             : 1.0   Initial
--                       1.1 JYJ 2023.09.26 MPP/WPP분리 수신에 대한 수정
--                       1.2 JYJ 2023.10.24 TOP_ITEM_ID추가
--                       1.3 KJS 2023.11.20 TOP_ITEM_ID 구분에 따른 GROUP BY절 추가
--                       1.4 KIMCD 2024.05.29 오류 처리 정보 형성에서 MASTER_IF_SEQ 조건 추가
--                       1.5 yschoithira 2025.11.04 [E20251104-000722] CUR_FP_MPPWPP 속도 개선건
-- ================================================================================================

AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name             NVARCHAR(100) = 'PR_XIF_FP_MPPWPP_R'
	DECLARE @v_descr                 NVARCHAR(250)
	DECLARE @v_count                 INTEGER	   = 0
	DECLARE @sysdate                 DATETIME2     = GETDATE()
	DECLARE @PROC_MSG                NVARCHAR(1000)        = NULL;
	DECLARE @PROC_FLAG               NVARCHAR(50)          = 'N';
	-- ERROR_LINE
	DECLARE @v_temp1                 NVARCHAR(1000)
	DECLARE @v_temp2                 NVARCHAR(1000)

	--변수 설정
	DECLARE @MASTER_IF_SEQ		     NVARCHAR(50)
	DECLARE @PLAN_WEEK			     NVARCHAR(10)
	DECLARE @PLAN_REVISION		     NVARCHAR(100)
	DECLARE @COMPANY_ID			     NVARCHAR(30)
	DECLARE @DIVISION_ID		     NVARCHAR(30)
	DECLARE @SITE_ID			     NVARCHAR(30)
	DECLARE @PLANT_ID			     NVARCHAR(30)
	DECLARE @FACTORY_ID			     NVARCHAR(30)
	DECLARE @INSTANCE_ID		     NVARCHAR(30)
	DECLARE @PLAN_MONTH		         NVARCHAR(6)
	DECLARE @WPP				     NVARCHAR(10)
	DECLARE @MPP				     NVARCHAR(10)
	DECLARE @MRP				     NVARCHAR(10)
	DECLARE @WO  				     NVARCHAR(10)
	DECLARE @PLAN_DESCRIPTION	     NVARCHAR(150)
	DECLARE @PLAN_GROUP_ID           NVARCHAR(30)   -- 2017-11-14 kimcd FP PLAN GROUP - 제품 특성 구분자 추가 전송
    
	DECLARE @PLAN_START_DATE         DATETIME
	DECLARE @PLAN_END_DATE           DATETIME
	DECLARE @WEEK_START_DATE         DATE
	DECLARE @WEEK_END_DATE           DATE

    IF (SELECT CURSOR_STATUS('GLOBAL','CUR_FP_MPPWPP')) >= -1
    BEGIN
        IF (SELECT CURSOR_STATUS('GLOBAL','CUR_FP_MPPWPP')) > -1
        BEGIN
            CLOSE CUR_FP_MPPWPP
        END

        DEALLOCATE CUR_FP_MPPWPP
    END

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- PROC_FLAG = 'N' 인터페이스된 데이타 추출
	DECLARE CUR_FP_MPPWPP CURSOR FOR
		 SELECT  M.[IF_SEQ]
				,M.[PLAN_WEEK]
				,M.[PLAN_REVISION]
				,M.[COMPANY_ID]
				,M.[DIVISION_ID]
				,M.[SITE_ID]
				,M.[PLANT_ID]
				,M.[FACTORY_ID]
				,M.[INSTANCE_ID]
				,M.[PLAN_MONTH]
				,M.[WPP]
				,M.[MPP]
				,M.[MRP]
				,M.[WO]
				,M.[PLAN_DESCRIPTION]
				,M.[PLAN_GROUP_ID]
		 FROM [dbo].SY_XIF_FP_MPPWPP_R M
	 		INNER JOIN (	-- [E20251104-000722] 추가
		 						SELECT  D.[PLAN_WEEK], D.[PLAN_REVISION], D.[MASTER_IF_SEQ]
                       			FROM    [DBO].SY_XIF_FP_MPPWPP_R M
                       				   ,[DBO].SY_XIF_FP_MPPWPP_DETAIL_R D
		                      	WHERE  	M.[PLAN_WEEK]   = D.[PLAN_WEEK]
              					AND 	M.[PLAN_REVISION] = D.[PLAN_REVISION]
		                        AND 	M.[IF_SEQ]        = D.[MASTER_IF_SEQ]
		            AND 	M.PROC_FLAG = 'N'
		                        GROUP BY D.[PLAN_WEEK], D.[PLAN_REVISION], D.[MASTER_IF_SEQ]
		                       	HAVING MAX(D.ACCUM_COUNT) = COUNT(*) 
		 		) D
		 		ON 1=1
		 		AND		M.[PLAN_WEEK]   	= D.[PLAN_WEEK]
              	AND 	M.[PLAN_REVISION] 	= D.[PLAN_REVISION]
		        AND 	M.[IF_SEQ]        	= D.[MASTER_IF_SEQ]
		   
		 WHERE 1=1
         AND M.PROC_FLAG = 'N'
         AND NOT EXISTS (  SELECT 1 
                           FROM   [dbo].SY_XIF_FP_MPPWPP_R S 
                           INNER JOIN [dbo].SY_XIF_FP_MPPWPP_DETAIL_R D
                            ON  S.[PLAN_WEEK]     = D.[PLAN_WEEK]
                            AND S.[PLAN_REVISION]  = D.[PLAN_REVISION]
                            AND S.[IF_SEQ]         = D.[MASTER_IF_SEQ]
                           WHERE S.[FACTORY_ID]     = M.[FACTORY_ID]
                            AND   S.[INSTANCE_ID]   = M.[INSTANCE_ID]
                AND   S.[PLAN_GROUP_ID] = M.[PLAN_GROUP_ID]
                            AND   S.PROC_FLAG       = 'N'
                           GROUP BY S.[PLAN_WEEK], S.[PLAN_REVISION], S.[IF_SEQ]
                           HAVING MAX(D.ACCUM_COUNT) != COUNT(*) )
         -- [E20251104-000722] 삭제
    	/*
         AND EXISTS (  SELECT 1 
                       FROM    [dbo].SY_XIF_FP_MPPWPP_DETAIL_R D
                       WHERE  M.[PLAN_WEEK]   = D.[PLAN_WEEK]
                         AND M.[PLAN_REVISION] = D.[PLAN_REVISION]
                         AND M.[IF_SEQ]        = D.[MASTER_IF_SEQ]
                       GROUP BY D.[PLAN_WEEK], D.[PLAN_REVISION], D.[MASTER_IF_SEQ]
                       HAVING MAX(D.ACCUM_COUNT) = COUNT(*) )
         */
 		ORDER BY M.IF_SEQ;

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가
		-- ================================================

		--  최근 2일 데이터 가져와서 INF 테이블에 존재하지 않는 데이터만 전송
		OPEN CUR_FP_MPPWPP;
		
		FETCH NEXT FROM CUR_FP_MPPWPP INTO 
             @MASTER_IF_SEQ	  ,@PLAN_WEEK             ,@PLAN_REVISION         ,@COMPANY_ID        ,@DIVISION_ID
            ,@SITE_ID         ,@PLANT_ID              ,@FACTORY_ID            ,@INSTANCE_ID       ,@PLAN_MONTH
            ,@WPP             ,@MPP                   ,@MRP                   ,@WO                ,@PLAN_DESCRIPTION
            ,@PLAN_GROUP_ID

		WHILE (@@FETCH_STATUS = 0)
            BEGIN
                BEGIN TRAN

                UPDATE [dbo].[SY_XIF_FP_MPPWPP_R] SET
                     PROC_FLAG     = 'P'
                WHERE PROC_FLAG    = 'N'
                AND IF_SEQ         = @MASTER_IF_SEQ
                ;
                UPDATE [dbo].[SY_XIF_FP_MPPWPP_DETAIL_R] SET
                    PROC_FLAG      = 'P'
                WHERE PROC_FLAG    = 'N'
                AND MASTER_IF_SEQ  = @MASTER_IF_SEQ
                ;
                -- MASTER TABLE
                MERGE INTO  [dbo].[FP_MPP_WPP_BASE_PLAN_H]   MWB
                USING ( 
                       SELECT @PLAN_WEEK      AS  PLAN_WEEK
                           ,@PLAN_REVISION    AS  PLAN_REVISION
                           ,@COMPANY_ID       AS  COMPANY_ID
                           ,@DIVISION_ID      AS  DIVISION_ID
                           ,@SITE_ID          AS  SITE_ID
                           ,@PLANT_ID		  AS  PLANT_ID
                           ,@FACTORY_ID       AS  FACTORY_ID
                           ,@INSTANCE_ID      AS  INSTANCE_ID
                           ,@PLAN_MONTH       AS  PLAN_MONTH
                           ,@WPP              AS  WPP
                           ,@MPP              AS  MPP
                           ,@MRP              AS  MRP
                           ,@WO               AS  WO
                           ,@PLAN_DESCRIPTION AS  PLAN_DESCRIPTION
        ,@PLAN_GROUP_ID    AS  PLAN_GROUP_ID      
                    )   XXX
                ON (  MWB.PLAN_WEEK       = XXX.PLAN_WEEK
                    AND MWB.PLAN_REVISION = XXX.PLAN_REVISION
                    )
                WHEN MATCHED THEN
                    UPDATE SET MWB.[COMPANY_ID] = XXX.COMPANY_ID
                        ,MWB.[DIVISION_ID]      = XXX.DIVISION_ID
                        ,MWB.[SITE_ID]          = XXX.SITE_ID
                        ,MWB.[PLANT_ID]         = XXX.PLANT_ID
                        ,MWB.[FACTORY_ID]       = XXX.FACTORY_ID
                        ,MWB.[INSTANCE_ID]		= XXX.INSTANCE_ID
                        ,MWB.[PLAN_MONTH]       = XXX.PLAN_MONTH
                        ,MWB.[WPP]              = XXX.WPP
                        ,MWB.[MPP]              = XXX.MPP
                        ,MWB.[MRP]              = XXX.MRP
                        ,MWB.[WO]               = XXX.WO
                        ,MWB.[PLAN_DESCRIPTION]	= XXX.PLAN_DESCRIPTION
                  ,MWB.[UPDATE_ID]        = 'PR_XIF_FP_MPPWPP_R'
                        ,MWB.[UPDATE_TIME]      = GETDATE()
                        ,MWB.[PLAN_GROUP_ID]    = XXX.PLAN_GROUP_ID
                WHEN NOT MATCHED THEN
                    INSERT 
                    (    [PLAN_WEEK]
                        ,[PLAN_REVISION]
                        ,[COMPANY_ID]
                        ,[DIVISION_ID]
                        ,[SITE_ID]
                        ,[PLANT_ID]
                        ,[FACTORY_ID]
                        ,[INSTANCE_ID]
                        ,[PLAN_MONTH]
                        ,[WPP]
                        ,[MPP]
                        ,[MRP]
                        ,[WO]
                        ,[PLAN_DESCRIPTION]
                        ,[INSERT_ID]
                        ,[INSERT_TIME]
                        ,[UPDATE_ID]
                        ,[UPDATE_TIME]
                        ,[PLAN_GROUP_ID]
                    )
                    VALUES 
                    (   XXX.[PLAN_WEEK]
                       ,XXX.[PLAN_REVISION]
                       ,XXX.[COMPANY_ID]
                       ,XXX.[DIVISION_ID]
                       ,XXX.[SITE_ID]
                       ,XXX.[PLANT_ID]
                       ,XXX.[FACTORY_ID]
                       ,XXX.[INSTANCE_ID]
                       ,XXX.[PLAN_MONTH]
                       ,XXX.[WPP]
                       ,XXX.[MPP]
                       ,XXX.[MRP]
                       ,XXX.[WO]
                       ,XXX.[PLAN_DESCRIPTION]
                       ,'PR_XIF_FP_MPPWPP_R'
                       ,GETDATE()
                       ,'PR_XIF_FP_MPPWPP_R'
                       ,GETDATE()
                       ,XXX.[PLAN_GROUP_ID]
                    );		

                --DETAIL
                MERGE INTO  [dbo].[FP_MPP_WPP_BASE_PLAN_M]   MWM
                USING ( 
                       SELECT [PLAN_WEEK]
                             ,[PLAN_REVISION]
                             ,[PLAN_DATE]
                             ,[EQUIPMENT_ID]
                             ,[LINE_ID]
                             ,[OPERATION_ID]
                             ,[ITEM_ID]
                             ,[FACTORY_ID]
                             ,[PRODUCTION_TYPE]
                             ,[MARKET]
                             ,[WORK_REQUEST_MODEL_ID]
                             ,[VERSION]
                             ,[PROD_SEQ]
                             ,[PLM_EC_NO]
                             ,MAX([COMPANY_ID]) AS COMPANY_ID
                             ,MAX([DIVISION_ID]) AS DIVISION_ID
                             ,MAX([SITE_ID]) AS SITE_ID
                             ,MAX([PLANT_ID]) AS PLANT_ID
                             ,SUM([PLAN_QTY]) AS PLAN_QTY
                             ,SUM([ROLL_QTY]) AS ROLL_QTY
              ,SUM([JR_QTY]) AS JR_QTY
                            ,SUM([CELL_QTY]) AS CELL_QTY
                             ,SUM([BATCH_QTY]) AS BATCH_QTY
                             ,SUM([ROLL_IN_QTY]) AS ROLL_IN_QTY
                             ,SUM([JR_IN_QTY]) AS JR_IN_QTY
                             ,SUM([CELL_IN_QTY]) AS CELL_IN_QTY
                             ,SUM([BATCH_IN_QTY]) AS BATCH_IN_QTY
                    	   FROM    SY_XIF_FP_MPPWPP_DETAIL_R MDR
                    	   WHERE  MDR.PLAN_WEEK     = @PLAN_WEEK
                    	   AND    MDR.PLAN_REVISION	= @PLAN_REVISION
						   AND    MDR.MASTER_IF_SEQ = @MASTER_IF_SEQ  -- KIMCD 2024.05.29 오류 처리 정보 형성에서 MASTER_IF_SEQ 조건 추가
						   GROUP BY [PLAN_WEEK]
									,[PLAN_REVISION]
									,[PLAN_DATE]
									,[EQUIPMENT_ID]
									,[LINE_ID]
									,[OPERATION_ID]
									,[ITEM_ID]
									,[FACTORY_ID]
									,[PRODUCTION_TYPE]
									,[MARKET]
									,[WORK_REQUEST_MODEL_ID]
									,[VERSION]
									,[PROD_SEQ]
									,[PLM_EC_NO]                -- 2023-11-20 TOP_ITEM_ID 구분에 따른 GROUP BY절 추가
   )  MDR
                ON (  	MWM.[PLAN_WEEK]                 = MDR.[PLAN_WEEK]
                    	AND MWM.[PLAN_REVISION]         = MDR.[PLAN_REVISION]
                    	AND MWM.[PLAN_DATE]             = MDR.[PLAN_DATE]
                    	AND MWM.[EQUIPMENT_ID]          = MDR.[EQUIPMENT_ID]
                    	AND MWM.[LINE_ID]               = MDR.[LINE_ID]
                    	AND MWM.[OPERATION_ID]          = MDR.[OPERATION_ID]
                    	AND MWM.[ITEM_ID]               = MDR.[ITEM_ID]
                    	AND MWM.[FACTORY_ID]            = MDR.[FACTORY_ID]
                    	AND MWM.[PRODUCTION_TYPE]       = MDR.[PRODUCTION_TYPE]
                    	AND MWM.[MARKET]                = MDR.[MARKET]
                    	AND MWM.[WORK_REQUEST_MODEL_ID] = MDR.[WORK_REQUEST_MODEL_ID]
                    	AND MWM.[VERSION]               = MDR.[VERSION]
                    	AND MWM.[PROD_SEQ]              = MDR.[PROD_SEQ]
                    	AND MWM.[PLM_EC_NO]             = MDR.[PLM_EC_NO]
                    )
                WHEN MATCHED THEN
                    UPDATE SET MWM.[COMPANY_ID]   = MDR.[COMPANY_ID]
                        ,MWM.[DIVISION_ID] = MDR.[DIVISION_ID]
                        ,MWM.[SITE_ID]     = MDR.[SITE_ID]
                        ,MWM.[PLANT_ID]    = MDR.[PLANT_ID]
                        ,MWM.[PLAN_QTY]    = MDR.[PLAN_QTY]
                        ,MWM.[ROLL_QTY]    = MDR.[ROLL_QTY]
                        ,MWM.[JR_QTY]      = MDR.[JR_QTY]
                        ,MWM.[CELL_QTY]    = MDR.[CELL_QTY]
                        ,MWM.[BATCH_QTY]   = MDR.[BATCH_QTY]
                        ,MWM.[UPDATE_ID]   = 'PR_XIF_FP_MPPWPP_R'
                        ,MWM.[UPDATE_TIME] = GETDATE()
                        ,MWM.[ROLL_IN_QTY] = MDR.[ROLL_IN_QTY]
                        ,MWM.[JR_IN_QTY]   = MDR.[JR_IN_QTY]
                        ,MWM.[CELL_IN_QTY] = MDR.[CELL_IN_QTY]
                        ,MWM.[BATCH_IN_QTY]= MDR.[BATCH_IN_QTY]
                WHEN NOT MATCHED THEN
                    INSERT 
                    (     [PLAN_WEEK]
                         ,[PLAN_REVISION]
                         ,[COMPANY_ID]
                         ,[DIVISION_ID]
                         ,[SITE_ID]
                         ,[PLANT_ID]
                         ,[FACTORY_ID]
                         ,[LINE_ID]
                         ,[OPERATION_ID]
                         ,[EQUIPMENT_ID]
                         ,[PRODUCTION_TYPE]
                         ,[ITEM_ID]
                         ,[PLAN_DATE]
                         ,[PLAN_QTY]
                         ,[ROLL_QTY]
                         ,[JR_QTY]
                         ,[CELL_QTY]
                         ,[BATCH_QTY]
                         ,[INSERT_ID]
    ,[INSERT_TIME]
                         ,[UPDATE_ID]
                      ,[UPDATE_TIME]
                         ,[MARKET]
                         ,[ROLL_IN_QTY]
                         ,[JR_IN_QTY]
                         ,[CELL_IN_QTY]
                         ,[BATCH_IN_QTY]
                         ,[WORK_REQUEST_MODEL_ID]
                         ,[VERSION]
                         ,[PROD_SEQ]
                         ,[PLM_EC_NO])
                    VALUES 
                    (     MDR.[PLAN_WEEK]
                         ,MDR.[PLAN_REVISION]
                         ,MDR.[COMPANY_ID]
                         ,MDR.[DIVISION_ID]
                         ,MDR.[SITE_ID]
                         ,MDR.[PLANT_ID]
                         ,MDR.[FACTORY_ID]
                         ,MDR.[LINE_ID]
                         ,MDR.[OPERATION_ID]
                         ,MDR.[EQUIPMENT_ID]
                         ,MDR.[PRODUCTION_TYPE]
                         ,MDR.[ITEM_ID]
                         ,MDR.[PLAN_DATE]
                         ,MDR.[PLAN_QTY]
                         ,MDR.[ROLL_QTY]
                         ,MDR.[JR_QTY]
     ,MDR.[CELL_QTY]
                         ,MDR.[BATCH_QTY]
                         ,'PR_XIF_FP_MPPWPP_R'
                         ,GETDATE()
                         ,'PR_XIF_FP_MPPWPP_R'
                         ,GETDATE()
                         ,MDR.[MARKET]
                         ,MDR.[ROLL_IN_QTY]
                         ,MDR.[JR_IN_QTY]
                         ,MDR.[CELL_IN_QTY]
                         ,MDR.[BATCH_IN_QTY]
                         ,MDR.[WORK_REQUEST_MODEL_ID]
                         ,MDR.[VERSION]
                         ,MDR.[PROD_SEQ]
                         ,MDR.[PLM_EC_NO]
                    );	
                
                --MPP인경우 2023.09.28 JYJ MPP로직추가
                IF( @MPP = 'Y')
				    BEGIN
				        SELECT @PLAN_START_DATE = CONVERT(DATETIME,@PLAN_MONTH +'01',112), @PLAN_END_DATE = DATEADD(MM,1,CONVERT(DATETIME, @PLAN_MONTH +'01',112)) ;
				        
						UPDATE A SET  
                             [PLAN_QTY]                = 0
                            ,[PLAN_IN_QTY]             = 0
                            ,[ROLL_IN_QTY]             = 0
                            ,[ROLL_OUT_QTY]            = 0
                            ,[JR_IN_QTY]               = 0
                            ,[JR_OUT_QTY]              = 0
                            ,[BATCH_IN_QTY]            = 0
                            ,[BATCH_OUT_QTY]           = 0
                            ,[CELL_IN_QTY]             = 0
                            ,[CELL_OUT_QTY]            = 0
                            ,[FULL_CLEANING_FLAG]      = NULL		
                            ,[PIG_CLEANING_FLAG]       = NULL
                            ,[MODEL_TYPE_CHANGE_FLAG]  = NULL		
                            ,[SEQ]                     = 0
                            ,[CELL_MATERIAL_ID]        = NULL
                            ,[TOTAL_BATCH]             = NULL
                            ,[SETUP_COLOR_CODE]        = '-'
                            ,[UPDATE_ID]               = @v_proc_name
                            ,[UPDATE_TIME]             = GETDATE()
                        FROM FP_DAILY_PRODUCTIOIN_PLAN_H A 
                        WHERE A.COMPANY_ID     = @COMPANY_ID
                        AND   A.DIVISION_ID    = @DIVISION_ID
                        AND   A.SITE_ID        = @SITE_ID
                        AND   A.PLANT_ID       = @PLANT_ID 
                        AND   A.INSTANCE_TYPE  = @INSTANCE_ID
                        AND   A.PLAN_TYPE      = 'MPP' --'MPP/WPP'
                        AND   A.PLAN_DATE      >= @PLAN_START_DATE
                        AND   A.PLAN_DATE       < @PLAN_END_DATE   -- WPP, MPP 구간 조정해서 초기화					
					    ;
				        
				        MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP
				        USING ( 
				                SELECT MDR.[COMPANY_ID]
                    		    	  ,MDR.[DIVISION_ID]
                    		    	  ,MDR.[SITE_ID]
                    		    	  ,MDR.[PLANT_ID]
                    		    	  ,MDR.[FACTORY_ID]
                    		    	  ,MDR.[LINE_ID]
                    		    	  ,MDR.[OPERATION_ID]
                    		    	  ,MDR.[EQUIPMENT_ID]
                                      ,ISNULL(EM.[ELECTRODE_TYPE],'-') AS ELECTRODE_TYPE
                    		    	  ,MDR.[PRODUCTION_TYPE]
                    		    	  ,MDR.[ITEM_ID]
                    		    	  ,MDR.[PLAN_DATE]
                    		    	  ,MDR.[PLAN_QTY]
                    		    	  ,MDR.[ROLL_QTY]
                    		    	  ,MDR.[JR_QTY]
                    		    	  ,MDR.[CELL_QTY]
                    		    	  ,MDR.[BATCH_QTY]
                    		    	  ,MDR.[MARKET]
                    		    	  ,MDR.[ROLL_IN_QTY]
                    		    	  ,MDR.[JR_IN_QTY]
                    		    	  ,MDR.[CELL_IN_QTY]
                    		    	  ,MDR.[BATCH_IN_QTY]
                    		    	  ,MDR.[WORK_REQUEST_MODEL_ID]
                    		    	  ,MDR.[VERSION]
                		    	  ,MDR.[PROD_SEQ]
                    		    	  ,MDR.[PLM_EC_NO]
									  ,MDR.[ATTR_01] AS TOP_ITEM_ID          -- 2023.10.24 JYJ TOP_ITEM_ID추가
				                FROM  SY_XIF_FP_MPPWPP_DETAIL_R MDR
				                LEFT OUTER JOIN  SCM_EQUIPMENT_M EM (NOLOCK)
                                  ON   MDR.[COMPANY_ID]   = EM.[COMPANY_ID]
                                  AND  MDR.[DIVISION_ID]  = EM.[DIVISION_ID]
                                  AND  MDR.[SITE_ID]      = EM.[SITE_ID]
                                  AND  MDR.[PLANT_ID]     = EM.[PLANT_ID]
                                  AND  MDR.[FACTORY_ID]   = EM.[FACTORY_ID]
                                  AND  MDR.[LINE_ID]      = EM.[LINE_ID]
                                  AND  MDR.[OPERATION_ID] = EM.[OPERATION_ID]
                                  AND  MDR.[EQUIPMENT_ID] = EM.[EQUIPMENT_ID]
				                WHERE  MDR.PLAN_WEEK      = @PLAN_WEEK
				                AND    MDR.PLAN_REVISION  = @PLAN_REVISION  
								AND    MDR.MASTER_IF_SEQ  = @MASTER_IF_SEQ  -- KIMCD 2024.05.29 오류 처리 정보 형성에서 MASTER_IF_SEQ 조건 추가
				                AND    MDR.PLAN_QTY       > 0 
				            ) B
				        ON (    DP.[FACTORY_ID]            = B.[FACTORY_ID]
                            AND DP.[INSTANCE_TYPE]         = @INSTANCE_ID          -- B.[INSTANCE_TYPE]
                            AND DP.[PLAN_TYPE]             = 'MPP'                 -- MPP/WPP -- B.[PLAN_TYPE]
                            AND DP.[ITEM_ID]               = B.[ITEM_ID]
                            AND DP.[LINE_ID]               = B.[LINE_ID]
                            AND DP.[PLAN_DATE]             = B.[PLAN_DATE]
                            AND DP.[OPERATION_ID]          = B.[OPERATION_ID]
                            AND DP.[FP_PRODUCTION_TYPE]    = B.[PRODUCTION_TYPE]
                            AND DP.[MARKET]                = B.[MARKET]
                            AND DP.[EQUIPMENT_ID]          = B.[EQUIPMENT_ID]
                            AND DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
                            AND DP.[VERSION]               = B.[VERSION]
                            AND DP.[PROD_SEQ]              = B.[PROD_SEQ]
                            AND DP.[PLM_EC_NO]             = B.[PLM_EC_NO]         -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
							AND DP.[TOP_ITEM_ID]           = B.[TOP_ITEM_ID]       -- 2023.10.24 JYJ TOP_ITEM_ID추가
				            )
				        WHEN MATCHED THEN
				            UPDATE SET   
                                 DP.[PRODUCTION_TYPE]         = B.[PRODUCTION_TYPE]
                                ,DP.[ELECTRODE_TYPE]          = B.[ELECTRODE_TYPE]
       ,DP.[PLAN_QTY]                = B.[PLAN_QTY]
                                ,DP.[PLAN_IN_QTY]             = B.[PLAN_QTY]
                                ,DP.[ROLL_IN_QTY]             = B.[ROLL_IN_QTY]
                                ,DP.[ROLL_OUT_QTY]            = B.[ROLL_QTY]
                                ,DP.[JR_IN_QTY]               = B.[JR_IN_QTY]
                                ,DP.[JR_OUT_QTY]              = B.[JR_QTY]
                                ,DP.[BATCH_IN_QTY]            = B.[BATCH_IN_QTY]
                                ,DP.[BATCH_OUT_QTY]           = B.[BATCH_QTY]
                                ,DP.[CELL_IN_QTY]             = B.[CELL_IN_QTY]
                                ,DP.[CELL_OUT_QTY]            = B.[CELL_QTY]
                                -- ,DP.[FULL_CLEANING_FLAG]      = B.[FULL_CLEANING_FLAG]		-- 2018-09-14 kimcd 추가 풀 세척					
                                -- ,DP.[PIG_CLEANING_FLAG]       = B.[PIG_CLEANING_FLAG]		-- 2018-12-20 PIYONG 추가 PIG 세정				
                                -- ,DP.[MODEL_TYPE_CHANGE_FLAG]  = B.[MODEL_TYPE_CHANGE_FLAG]	-- 2018-09-14 kimcd 추가 파우치->원각 모델 변경	
                                -- ,DP.[SEQ]                     = B.[SEQ]						-- 2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
                                -- ,DP.[CELL_MATERIAL_ID]        = B.[CELL_MATERIAL_ID]         -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
                                -- ,DP.[TOTAL_BATCH]             = B.[TOTAL_BATCH]              -- 2018-12-11 kimcd  주별 계획 BATCH 합 추가
                                -- ,DP.[SETUP_COLOR_CODE]        = B.SETUP_COLOR_CODE			-- 2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
                                ,DP.[PLAN_GROUP_ID]           = '-'                           -- 2019-02-18 kimcd PLAN GROUP ID 조건을 제거하고 갱신하도록 함
                                -- ,DP.[SHIFT]                   = B.[SHIFT]                    -- 2021-01-27 kimcd 시업 시간 shift 추가
                                ,DP.[UPDATE_ID]               = @v_proc_name
                                ,DP.[UPDATE_TIME]             = GETDATE()
                                ,DP.[LOCATION]                = '-'                           -- 2022-06-09 kimcd LOCATION 항상 갱신하도록 추가
				        WHEN NOT MATCHED THEN
				            INSERT 
				            (
				                 [COMPANY_ID]
                                ,[DIVISION_ID]
                                ,[SITE_ID]
                                ,[PLANT_ID]
                                ,[FACTORY_ID]
                                ,[PLAN_GROUP_ID]
                                ,[INSTANCE_TYPE]
                                ,[TOP_ITEM_ID]
                                ,[ITEM_ID]
                                ,[OPERATION_ID]
                                ,[LOCATION]
                                ,[PRODUCTION_TYPE]
                                ,[MARKET]
                                ,[LINE_ID]
                                ,[ELECTRODE_TYPE]
                                ,[PLAN_DATE]
                                ,[PLAN_QTY]
                                ,[PLAN_IN_QTY]
                                ,[INSERT_ID]
                                ,[INSERT_TIME]
                                ,[UPDATE_ID]
                                ,[UPDATE_TIME]
                                ,[PLAN_TYPE]                 -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
                                ,[EQUIPMENT_ID]              -- 2018-02-23 kimcd 설비 정보 추가
                                ,[FP_PRODUCTION_TYPE]
                                ,[ROLL_IN_QTY]
                                ,[ROLL_OUT_QTY]
                                ,[JR_IN_QTY]
                                ,[JR_OUT_QTY]
                                ,[BATCH_IN_QTY]
                                ,[BATCH_OUT_QTY]
                                ,[CELL_IN_QTY]
                                ,[CELL_OUT_QTY]
                              --,[FULL_CLEANING_FLAG]      -- 2018-09-14 kimcd 추가 풀 세척					
                                --,[PIG_CLEANING_FLAG]		 -- 2018-12-20 PIYONG 추가 PIG 세정				
                                --,[MODEL_TYPE_CHANGE_FLAG]	 -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경	
                                --,[SEQ]                     -- 2018-10-16 PIYONG ADD 전극 생산 우선 순위를 관리하기 위한 SEQ
                                --,[CELL_MATERIAL_ID]        -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
                                --,[TOTAL_BATCH]             -- 2018-12-11 kimcd  주별 계획 BATCH 합 추가
                                --,[SETUP_COLOR_CODE]        -- 2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
                                --,[SHIFT]                   -- 2021-01-27 kimcd 시업 시간 shift 추가
                                ,[WORK_REQUEST_MODEL_ID]
                                ,[VERSION]
                                ,[PROD_SEQ]
                                ,[PLM_EC_NO]                 -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
				        ) 
				        VALUES 
				        (     B.[COMPANY_ID]
                             ,B.[DIVISION_ID]
                             ,B.[SITE_ID]
                        ,B.[PLANT_ID]
                             ,B.[FACTORY_ID]
                             ,'-'             --B.[PLAN_GROUP_ID]
                             ,@INSTANCE_ID    --B.[INSTANCE_ID]
                             ,B.TOP_ITEM_ID   -- 2023-10-24  JYJ 추가
                             ,B.[ITEM_ID]
                             ,B.[OPERATION_ID]
                             ,'-'  --B.[LOCATION]
                             ,B.[PRODUCTION_TYPE]
                             ,B.[MARKET]
                             ,B.[LINE_ID]
                             ,B.[ELECTRODE_TYPE]
                             ,B.[PLAN_DATE]
                             ,B.[PLAN_QTY]
                             ,B.[PLAN_QTY]
                             ,@v_proc_name
                             ,GETDATE()
                             ,@v_proc_name
                             ,GETDATE()
                             ,'MPP' --WPP --  B.[PLAN_TYPE]  -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
                             ,B.[EQUIPMENT_ID]               -- 2018-02-23 kimcd 설비 정보 추가
                             ,B.[PRODUCTION_TYPE]
                             ,B.[ROLL_IN_QTY]
                             ,B.[ROLL_QTY]
                             ,B.[JR_IN_QTY]
                             ,B.[JR_QTY]
                             ,B.[BATCH_IN_QTY]
                             ,B.[BATCH_QTY]
                             ,B.[CELL_IN_QTY]
                             ,B.[CELL_QTY]
                             --,B.[FULL_CLEANING_FLAG]      -- 2018-09-14 kimcd 추가 풀 세척						
                             --,B.[PIG_CLEANING_FLAG]       -- 2018-12-20 PIYONG 추가 PIG 세정					
                             --,B.[MODEL_TYPE_CHANGE_FLAG]  -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경		
                             --,B.[SEQ]                     -- 2018-10-16 PIYONG ADD 전극 생산 우선 순위를 관리하기 위한 SEQ
                             --,B.[CELL_MATERIAL_ID]        -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
                             --,B.[TOTAL_BATCH]             -- 2018-12-11 kimcd  주별 계획 BATCH 합 추가
                             --,B.[SETUP_COLOR_CODE]        -- 2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
                             --,B.[SHIFT]                   -- 2021-01-27 kimcd 시업 시간 shift 추가
                             ,B.[WORK_REQUEST_MODEL_ID]
                             ,B.[VERSION]
                             ,B.[PROD_SEQ]
                             ,B.[PLM_EC_NO]                 -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
				        );	                    
                    
				    END

                --WPP인 경우  2023.09.28 JYJ WPP로직추가
                IF( @WPP = 'Y')
				    BEGIN
				        SELECT TOP 1 @WEEK_START_DATE = WEEKSTART_DATE, @WEEK_END_DATE = WEEKEND_DATE FROM [DBO].SCM_SYS_CALENDAR_M  CM WITH(NOLOCK)  WHERE WEEK =  @PLAN_WEEK
					
						UPDATE A SET  
                             [PLAN_QTY]                = 0
                            ,[PLAN_IN_QTY]             = 0
                            ,[ROLL_IN_QTY]             = 0
                            ,[ROLL_OUT_QTY]            = 0
                            ,[JR_IN_QTY]               = 0
                            ,[JR_OUT_QTY]              = 0
                            ,[BATCH_IN_QTY]            = 0
                            ,[BATCH_OUT_QTY]           = 0
                            ,[CELL_IN_QTY]             = 0
                            ,[CELL_OUT_QTY]            = 0
                            ,[FULL_CLEANING_FLAG]      = NULL		
                            ,[PIG_CLEANING_FLAG]       = NULL
                            ,[MODEL_TYPE_CHANGE_FLAG]  = NULL		
                            ,[SEQ]                     = 0
                            ,[CELL_MATERIAL_ID]        = NULL
                            ,[TOTAL_BATCH]             = NULL
                            ,[SETUP_COLOR_CODE]        = '-'
                            ,[UPDATE_ID]               = @v_proc_name
                            ,[UPDATE_TIME]             = GETDATE()
                        FROM FP_DAILY_PRODUCTIOIN_PLAN_H A 
                        WHERE A.COMPANY_ID     = @COMPANY_ID
                        AND   A.DIVISION_ID    = @DIVISION_ID
                        AND   A.SITE_ID        = @SITE_ID
                        AND   A.PLANT_ID       = @PLANT_ID 
                        AND   A.INSTANCE_TYPE  = @INSTANCE_ID
                        AND   A.PLAN_TYPE      = 'WPP' --'MPP/WPP'
                        AND   A.PLAN_DATE      >= @WEEK_START_DATE
                        AND   A.PLAN_DATE      <= @WEEK_END_DATE   -- WPP, MPP 구간 조정해서 초기화					
					    ;
				        
				        MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP
				        USING ( 
				                SELECT MDR.[COMPANY_ID]
                    		    	  ,MDR.[DIVISION_ID]
                    		    	  ,MDR.[SITE_ID]
                    		    	  ,MDR.[PLANT_ID]
                    		    	  ,MDR.[FACTORY_ID]
                    		    	  ,MDR.[LINE_ID]
                    		    	  ,MDR.[OPERATION_ID]
                    		    	  ,MDR.[EQUIPMENT_ID]
                                      ,ISNULL(EM.[ELECTRODE_TYPE],'-') AS ELECTRODE_TYPE
                    		    	  ,MDR.[PRODUCTION_TYPE]
                    		    	  ,MDR.[ITEM_ID]
                    		    	  ,MDR.[PLAN_DATE]
                    		    	  ,MDR.[PLAN_QTY]
                    		    	  ,MDR.[ROLL_QTY]
                    		    	  ,MDR.[JR_QTY]
                    		    	  ,MDR.[CELL_QTY]
                    		    	  ,MDR.[BATCH_QTY]
                    		    	  ,MDR.[MARKET]
                    		    	  ,MDR.[ROLL_IN_QTY]
                    		    	  ,MDR.[JR_IN_QTY]
                    		    	  ,MDR.[CELL_IN_QTY]
                    		    	  ,MDR.[BATCH_IN_QTY]
                    		    	  ,MDR.[WORK_REQUEST_MODEL_ID]
                    		    	  ,MDR.[VERSION]
                    		    	  ,MDR.[PROD_SEQ]
                    		    	  ,MDR.[PLM_EC_NO]
									  ,MDR.[ATTR_01] AS TOP_ITEM_ID  -- 2023.10.24 JYJ TOP_ITEM_ID추가
				                FROM  SY_XIF_FP_MPPWPP_DETAIL_R MDR
				                LEFT OUTER JOIN  SCM_EQUIPMENT_M EM (NOLOCK)
                                  ON   MDR.[COMPANY_ID]   = EM.[COMPANY_ID]
                                  AND  MDR.[DIVISION_ID]  = EM.[DIVISION_ID]
                                  AND  MDR.[SITE_ID]      = EM.[SITE_ID]
                                  AND  MDR.[PLANT_ID]     = EM.[PLANT_ID]
                                  AND  MDR.[FACTORY_ID]   = EM.[FACTORY_ID]
                                  AND  MDR.[LINE_ID]      = EM.[LINE_ID]
                                  AND  MDR.[OPERATION_ID] = EM.[OPERATION_ID]
                                  AND  MDR.[EQUIPMENT_ID] = EM.[EQUIPMENT_ID]
				                WHERE  MDR.PLAN_WEEK      = @PLAN_WEEK
				                AND    MDR.PLAN_REVISION  = @PLAN_REVISION  
								AND    MDR.MASTER_IF_SEQ  = @MASTER_IF_SEQ  -- KIMCD 2024.05.29 오류 처리 정보 형성에서 MASTER_IF_SEQ 조건 추가
				                AND    MDR.PLAN_QTY       > 0 
				            ) B
				        ON (    DP.[FACTORY_ID]            = B.[FACTORY_ID]
                            AND DP.[INSTANCE_TYPE]         = @INSTANCE_ID        -- B.[INSTANCE_TYPE]
                            AND DP.[PLAN_TYPE]             = 'WPP'               -- WPP -- B.[PLAN_TYPE]
                            AND DP.[ITEM_ID]               = B.[ITEM_ID]
                            AND DP.[LINE_ID]               = B.[LINE_ID]
                            AND DP.[PLAN_DATE]             = B.[PLAN_DATE]
                            AND DP.[OPERATION_ID]          = B.[OPERATION_ID]
                            AND DP.[FP_PRODUCTION_TYPE]    = B.[PRODUCTION_TYPE]
                            AND DP.[MARKET]                = B.[MARKET]
                            AND DP.[EQUIPMENT_ID]          = B.[EQUIPMENT_ID]
                            AND DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
                            AND DP.[VERSION]               = B.[VERSION]
                            AND DP.[PROD_SEQ]              = B.[PROD_SEQ]
                            AND DP.[PLM_EC_NO]             = B.[PLM_EC_NO]       -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
							AND DP.[TOP_ITEM_ID]           = B.[TOP_ITEM_ID]     -- 2023.10.24 JYJ TOP_ITEM_ID추가
				            )
				        WHEN MATCHED THEN
				            UPDATE SET   
                                 DP.[PRODUCTION_TYPE]         = B.[PRODUCTION_TYPE]
                                ,DP.[ELECTRODE_TYPE]          = B.[ELECTRODE_TYPE]
                                ,DP.[PLAN_QTY]                = B.[PLAN_QTY]
                                ,DP.[PLAN_IN_QTY]             = B.[PLAN_QTY]
                                ,DP.[ROLL_IN_QTY]             = B.[ROLL_IN_QTY]
                                ,DP.[ROLL_OUT_QTY]            = B.[ROLL_QTY]
                                ,DP.[JR_IN_QTY]               = B.[JR_IN_QTY]
                                ,DP.[JR_OUT_QTY]              = B.[JR_QTY]
                                ,DP.[BATCH_IN_QTY]            = B.[BATCH_IN_QTY]
                                ,DP.[BATCH_OUT_QTY]           = B.[BATCH_QTY]
                                ,DP.[CELL_IN_QTY]             = B.[CELL_IN_QTY]
                                ,DP.[CELL_OUT_QTY]            = B.[CELL_QTY]
                                -- ,DP.[FULL_CLEANING_FLAG]      = B.[FULL_CLEANING_FLAG]		-- 2018-09-14 kimcd 추가 풀 세척					
                                -- ,DP.[PIG_CLEANING_FLAG]       = B.[PIG_CLEANING_FLAG]		-- 2018-12-20 PIYONG 추가 PIG 세정				
                                -- ,DP.[MODEL_TYPE_CHANGE_FLAG]  = B.[MODEL_TYPE_CHANGE_FLAG]	-- 2018-09-14 kimcd 추가 파우치->원각 모델 변경	
                                -- ,DP.[SEQ]                     = B.[SEQ]						-- 2018-10-16 PIYONG ADD  전극 생산 우선 순위를 관리하기 위한 SEQ
                                -- ,DP.[CELL_MATERIAL_ID]        = B.[CELL_MATERIAL_ID]         -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
                                -- ,DP.[TOTAL_BATCH]             = B.[TOTAL_BATCH]              -- 2018-12-11 kimcd  주별 계획 BATCH 합 추가
                                -- ,DP.[SETUP_COLOR_CODE]        = B.SETUP_COLOR_CODE			-- 2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
                                ,DP.[PLAN_GROUP_ID]           = '-'                           -- 2019-02-18 kimcd PLAN GROUP ID 조건을 제거하고 갱신하도록 함
                                -- ,DP.[SHIFT]                   = B.[SHIFT]                    -- 2021-01-27 kimcd 시업 시간 shift 추가
                              ,DP.[UPDATE_ID]               = @v_proc_name
                 ,DP.[UPDATE_TIME]             = GETDATE()
                                ,DP.[LOCATION]                = '-'                           -- 2022-06-09 kimcd LOCATION 항상 갱신하도록 추가
				        WHEN NOT MATCHED THEN
				            INSERT 
				            (
				                 [COMPANY_ID]
                                ,[DIVISION_ID]
                                ,[SITE_ID]
                                ,[PLANT_ID]
                                ,[FACTORY_ID]
                                ,[PLAN_GROUP_ID]
                                ,[INSTANCE_TYPE]
                                ,[TOP_ITEM_ID]
                                ,[ITEM_ID]
                                ,[OPERATION_ID]
                                ,[LOCATION]
                                ,[PRODUCTION_TYPE]
                                ,[MARKET]
                                ,[LINE_ID]
                                ,[ELECTRODE_TYPE]
                                ,[PLAN_DATE]
                                ,[PLAN_QTY]
                                ,[PLAN_IN_QTY]
                                ,[INSERT_ID]
     ,[INSERT_TIME]
                                ,[UPDATE_ID]
                                ,[UPDATE_TIME]
                                ,[PLAN_TYPE]               -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
                                ,[EQUIPMENT_ID]            -- 2018-02-23 kimcd 설비 정보 추가
                                ,[FP_PRODUCTION_TYPE]
                                ,[ROLL_IN_QTY]
                                ,[ROLL_OUT_QTY]
                                ,[JR_IN_QTY]
                                ,[JR_OUT_QTY]
                                ,[BATCH_IN_QTY]
                                ,[BATCH_OUT_QTY]
                                ,[CELL_IN_QTY]
                                ,[CELL_OUT_QTY]
                                --,[FULL_CLEANING_FLAG]      -- 2018-09-14 kimcd 추가 풀 세척					
                                --,[PIG_CLEANING_FLAG]		 -- 2018-12-20 PIYONG 추가 PIG 세정				
                                --,[MODEL_TYPE_CHANGE_FLAG]	 -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경	
                                --,[SEQ]                     -- 2018-10-16 PIYONG ADD 전극 생산 우선 순위를 관리하기 위한 SEQ
                                --,[CELL_MATERIAL_ID]        -- 2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
                                --,[TOTAL_BATCH]             -- 2018-12-11 kimcd  주별 계획 BATCH 합 추가
                                --,[SETUP_COLOR_CODE]        -- 2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
                                --,[SHIFT]                   -- 2021-01-27 kimcd 시업 시간 shift 추가
                                ,[WORK_REQUEST_MODEL_ID]
                                ,[VERSION]
                                ,[PROD_SEQ]
                                ,[PLM_EC_NO]               -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
				        ) 
				        VALUES 
				        (     B.[COMPANY_ID]
                             ,B.[DIVISION_ID]
                             ,B.[SITE_ID]
                             ,B.[PLANT_ID]
                             ,B.[FACTORY_ID]
                             ,'-'              --B.[PLAN_GROUP_ID]
                             ,@INSTANCE_ID     --B.[INSTANCE_ID]
                             ,B.[TOP_ITEM_ID]  -- 2023.10.24 JYJ TOP_ITEM_ID추가
                             ,B.[ITEM_ID]
                             ,B.[OPERATION_ID]
                             ,'-'  --B.[LOCATION]
                             ,B.[PRODUCTION_TYPE]
                             ,B.[MARKET]
                             ,B.[LINE_ID]
                             ,B.[ELECTRODE_TYPE]
                             ,B.[PLAN_DATE]
                             ,B.[PLAN_QTY]
                             ,B.[PLAN_QTY]
                   ,@v_proc_name
                             ,GETDATE()
   ,@v_proc_name
                             ,GETDATE()
                             ,'WPP'                     -- WPP -- 2018-02-23 kimcd 계획 유형 추가 - RELEASE
                             ,B.[EQUIPMENT_ID]            -- 2018-02-23 kimcd 설비 정보 추가
                             ,B.[PRODUCTION_TYPE]
                             ,B.[ROLL_IN_QTY]
                             ,B.[ROLL_QTY]
                             ,B.[JR_IN_QTY]
                             ,B.[JR_QTY]
                             ,B.[BATCH_IN_QTY]
                             ,B.[BATCH_QTY]
                             ,B.[CELL_IN_QTY]
                             ,B.[CELL_QTY]
                             --,B.[FULL_CLEANING_FLAG]      -- 2018-09-14 kimcd 추가 풀 세척						
                             --,B.[PIG_CLEANING_FLAG]       -- 2018-12-20 PIYONG 추가 PIG 세정					
                             --,B.[MODEL_TYPE_CHANGE_FLAG]  -- 2018-09-14 kimcd 추가 파우치->원각 모델 변경		
                             --,B.[SEQ]                     -- 2018-10-16 PIYONG ADD 전극 생산 우선 순위를 관리하기 위한 SEQ
                             --,B.[CELL_MATERIAL_ID]        --2018-11-06 kimcd 활성화 후 공정 Cell Material ID 값 추가
                             --,B.[TOTAL_BATCH]             --2018-12-11 kimcd  주별 계획 BATCH 합 추가
                             --,B.[SETUP_COLOR_CODE]        --2019-01-09 PIYONG full, pig세정 강화 관련 색 지정
                             --,B.[SHIFT]                   --2021-01-27 kimcd 시업 시간 shift 추가
                             ,B.[WORK_REQUEST_MODEL_ID]
                             ,B.[VERSION]
                             ,B.[PROD_SEQ]
                             ,B.[PLM_EC_NO]               -- 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가
				        );	                    
                    					
					END

                UPDATE [dbo].[SY_XIF_FP_MPPWPP_R]
                    SET PROC_FLAG    = 'Y'				
                       ,PROC_DATE    = GETDATE()
                WHERE IF_SEQ         = @MASTER_IF_SEQ  
                AND PROC_FLAG        = 'P'
                ;

                UPDATE [dbo].[SY_XIF_FP_MPPWPP_DETAIL_R]
                    SET PROC_FLAG    = 'Y'				
                       ,PROC_DATE    = GETDATE()
                WHERE MASTER_IF_SEQ  = @MASTER_IF_SEQ  
                AND PROC_FLAG        = 'P'
                ;

		        FETCH NEXT FROM CUR_FP_MPPWPP INTO 
                     @MASTER_IF_SEQ	  ,@PLAN_WEEK             ,@PLAN_REVISION         ,@COMPANY_ID        ,@DIVISION_ID
                    ,@SITE_ID         ,@PLANT_ID              ,@FACTORY_ID            ,@INSTANCE_ID       ,@PLAN_MONTH
                    ,@WPP             ,@MPP                   ,@MRP                   ,@WO                ,@PLAN_DESCRIPTION
                    ,@PLAN_GROUP_ID

		        COMMIT TRAN

		    END

		    CLOSE CUR_FP_MPPWPP;
		    DEALLOCATE CUR_FP_MPPWPP;

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
    END TRY

    BEGIN CATCH

        ROLLBACK TRAN

        -- 에러나도 로그는 인서트
        SET @PROC_FLAG      = 'F'
        SET @PROC_MSG       = '[' + CONVERT(NVARCHAR(10), ERROR_NUMBER()) + '] ' + ERROR_MESSAGE()
        SET @v_descr        = ERROR_MESSAGE()
        
		UPDATE [dbo].[SY_XIF_FP_MPPWPP_R]
            SET PROC_FLAG    = @PROC_FLAG			
               ,PROC_MSG     = @PROC_MSG
        WHERE IF_SEQ         = @MASTER_IF_SEQ  
        AND PROC_FLAG        IN ('N', 'P')
        ;
        
        UPDATE [dbo].[SY_XIF_FP_MPPWPP_DETAIL_R]
            SET PROC_FLAG    = @PROC_FLAG			
               ,PROC_MSG     = @PROC_MSG
        WHERE MASTER_IF_SEQ  = @MASTER_IF_SEQ  
        AND PROC_FLAG        IN ('N', 'P')
        ;       
        --에러방지 : [16915] 이름이 'CUR_FP_MPPWPP'인 커서가 이미 있습니다.
        IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_FP_MPPWPP')
            BEGIN
                CLOSE CUR_FP_MPPWPP
                DEALLOCATE CUR_FP_MPPWPP
            END
            
        EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

    END CATCH

    SET NOCOUNT OFF
END
