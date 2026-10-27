

CREATE PROCEDURE [dbo].[PR_XIF_FP_MES_WIP_SYNC_R]

-- ================================================================================================
-- Program ID          : FP00900
-- Program Name        : PR_XIF_FP_MES_WIP_SYNC_R
-- Param               :
-- Batch Period        : 1Day
-- Description         : 법인별 수신된 MES WIP을 오창 SCM에 동기화
--
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_FP_MES_WIP_SYNC_R
-- Destination Table   : SCM_STOCK_H
--
-- Create Date		   : 2023.06.16 JYJ  Init
-- Update Date		   : 

-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_FP_MES_WIP_SYNC_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()
    DECLARE @PROC_MSG    NVARCHAR(1000)       = NULL;
	DECLARE @PROC_FLAG   NVARCHAR(1)          = 'N';
	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @IF_ID         NVARCHAR(50)
	DECLARE @SUM_DATE      NVARCHAR(50) -- 2021-08-19   kimcd 일자 변수 추가
    DECLARE @SUM_DTTM      DATETIME     -- 2021-08-19   kimcd 변수명, 데이터 유형 변경
	DECLARE @SHOP_GROUP_ID NVARCHAR(2)  -- 2021-08-19   kimcd 공정군 변수 추가
	DECLARE @MES_IF_ID     NVARCHAR(50)
    DECLARE @SITE_ID       NVARCHAR(30)
	DECLARE @CUTOFF_DATE   DATE
	DECLARE @START_TIME    NVARCHAR(10)  -- 2020-09-23 kimcd 시업 시간 구분자 추가
	DECLARE @i_CNT         INTEGER

	--SYSTEM CODE
	DECLARE @SYSCODE                NVARCHAR(50)

	SELECT @SYSCODE = SEGMENT1-- 기존 Interace id에서 OFP0 값만 치환
	FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
	WHERE  LOOKUP_TYPE_CODE = 'DATABASE_MQ_SYSTEM_CODE'
	AND    ACTIVE_FLAG      = 'Y';

	--CURSOR 선언
	DECLARE CUR_IF_WIP_SYNC CURSOR FOR
		SELECT MES_IF_ID, CUTOFF_DATE, MAX(SITE_ID) AS SITE_ID
        FROM [SY_XIF_FP_MES_WIP_SYNC_R]  WITH(NOLOCK)
        WHERE 1=1
        AND PROC_FLAG = 'N'
        GROUP BY  MES_IF_ID, CUTOFF_DATE
        HAVING COUNT(1) = MAX(ACCUM_COUNT)
        ORDER BY MES_IF_ID, CUTOFF_DATE
		;


	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가 start
		-- ================================================

		SET @v_temp1 = 'STEP OPEN CURSOR'

		OPEN CUR_IF_WIP_SYNC;

		FETCH NEXT FROM CUR_IF_WIP_SYNC INTO   @MES_IF_ID   ,@CUTOFF_DATE	  ,@SITE_ID

		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				BEGIN TRAN

				UPDATE [dbo].[SY_XIF_FP_MES_WIP_SYNC_R] SET
                     PROC_FLAG = 'P'
                    ,PROC_DATE = GETDATE()
                WHERE PROC_FLAG   = 'N'
                  AND MES_IF_ID   = @MES_IF_ID
                  AND CUTOFF_DATE = @CUTOFF_DATE
				  ;

		        -- 실제 업무 Table의 정보를 동일날짜.동일정보 MES WIP 데이타 삭제.
		        DELETE FROM [dbo].[SCM_STOCK_H]
                WHERE CUTOFF_DATE = @CUTOFF_DATE
                AND STORAGE_ID    = 'MES'
                AND SITE_ID       = @SITE_ID
                AND INSERT_ID     = @MES_IF_ID
                AND UPDATE_ID     = 'PR_XIF_FP_MES_WIP_SYNC_R'
				;

				SET @i_CNT =  ( SELECT ISNULL(MAX(SEQ), 0)
							    FROM [dbo].[SCM_STOCK_H] WITH(NOLOCK)
								WHERE CUTOFF_DATE = @CUTOFF_DATE
								AND SITE_ID       = @SITE_ID );

                INSERT INTO [dbo].[SCM_STOCK_H]
                (    [COMPANY_ID]
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
                	,[UNHOLD_EXP_DATE]
                	,[QTY]
                	,[QTY_UOM]
                	,[QTY2]
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
                	,[WIP_TYPE_CODE]
                	,[FORMATION_REWORK_TYPE]
                	,[LOCATION]
                	,[QMS_HOLD_YN]
                	,[MES_MAP_SLOC]
                	,[MES_HOLD_YN]
                	,[INSERT_ID]
                	,[INSERT_TIME]
                	,[UPDATE_ID]
                	,[UPDATE_TIME]
                	,[MES_UNHOLD_DATE]
                	,[QMS_UNHOLD_EXP_DATE]
                	,[SECOND_OCV_TIME]
                    ,[SECOND_OCV_EXP_DATE]
                	,[LONG_TERM_FLAG]
                	,[QLTY_NO_INSP_FLAG]
                	,[LOT_PACKING_TYPE]
                	,[POSITION_CATEGORY]
                	,[DETAIL_POSITION]
                	,[LOT_COUNT]
                	,[COATING_LINE_ID]
                	,[PACK_MOVE_FLAG]
                	,[ELEC_POST_HOLD_YN]
                	,[WORK_REQUEST_MODEL_ID]
                	,[VERSION]
                	,[PROD_SEQ]
                	,[PLM_EC_NO]
                	,MES_ITEM_ID
                	,MES_OPERATION_ID
                	,FROM_SLOC_ID
                ) 
                SELECT [COMPANY_ID]
                    ,[DIVISION_ID]
                    ,[SITE_ID]
                    ,[PLANT_ID]
                    ,[FACTORY_ID]
                    ,[STORAGE_ID]
                    ,[CUTOFF_DATE]
                    ,ROW_NUMBER() OVER ( PARTITION BY IF_ID ORDER BY IF_SEQ DESC ) + @i_CNT  AS [SEQ] --MES WIP  MAX 찾아서 더하기  ROW_NUMBER() OVER ( PARTITION BY @IF_ID ORDER BY A.[ITEM_ID] DESC ) + @i_CNT  AS [SEQ]
                    ,[STOCK_TYPE]
                    ,[ITEM_ID]
                    ,[PRODUCTION_TYPE]
                    ,[AVAILABLE_DATE]
                    ,[REMAIN_LEAD_TIME]
                    ,[UNHOLD_EXP_DATE]
                    ,[QTY]
                    ,[QTY_UOM]
                    ,[QTY2]
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
                    ,[WIP_TYPE_CODE]
                    ,[FORMATION_REWORK_TYPE]
                    ,[LOCATION]
                    ,[QMS_HOLD_YN]
                    ,[MES_MAP_SLOC]
                    ,[MES_HOLD_YN]
                    ,@MES_IF_ID             --SYSCODE +'_OSCM_SCM_WIP_HOLD_SUM'
                    ,GETDATE()
                    ,'PR_XIF_FP_MES_WIP_SYNC_R'  --프로시져명
                    ,GETDATE()
                    ,[MES_UNHOLD_DATE]
                    ,[QMS_UNHOLD_EXP_DATE]
                    ,[SECOND_OCV_TIME]
                    ,[SECOND_OCV_EXP_DATE]
                    ,[LONG_TERM_FLAG]
                    ,[QLTY_NO_INSP_FLAG]
                    ,[LOT_PACKING_TYPE]
                    ,[POSITION_CATEGORY]
                    ,[DETAIL_POSITION]
                    ,[LOT_COUNT]
                    ,[COATING_LINE_ID]
                    ,[PACK_MOVE_FLAG]
                    ,[ELEC_POST_HOLD_YN]
                    ,[WORK_REQUEST_MODEL_ID]
                    ,[VERSION]
                    ,[PROD_SEQ]
                    ,[PLM_EC_NO]
                    ,[MES_ITEM_ID]
                    ,[MES_OPERATION_ID]
                    ,[FROM_SLOC_ID]
                FROM   [SY_XIF_FP_MES_WIP_SYNC_R]  WITH(NOLOCK)
                WHERE  1=1
                AND    PROC_FLAG   = 'P'
                AND    MES_IF_ID   = @MES_IF_ID
                AND    CUTOFF_DATE = @CUTOFF_DATE
                ;

                UPDATE [dbo].[SY_XIF_FP_MES_WIP_SYNC_R] SET
                     PROC_FLAG = 'Y'
                    ,PROC_DATE = GETDATE()
                WHERE PROC_FLAG   = 'P'
                  AND MES_IF_ID   = @MES_IF_ID
                  AND CUTOFF_DATE = @CUTOFF_DATE
                ;

				FETCH NEXT FROM CUR_IF_WIP_SYNC INTO @MES_IF_ID   ,@CUTOFF_DATE	  ,@SITE_ID

				COMMIT TRAN

			END;

		CLOSE CUR_IF_WIP_SYNC;
		DEALLOCATE CUR_IF_WIP_SYNC;  

		-- ================================================
		-- 로직end
		-- ================================================

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		--에러방지 : [16915] 이름이 'CUR_IF_WIP_SYNC'인 커서가 이미 있습니다.
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_IF_WIP_SYNC')
            BEGIN
                CLOSE CUR_IF_WIP_SYNC
                DEALLOCATE CUR_IF_WIP_SYNC
            END

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		--SELECT @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

	SET NOCOUNT OFF;
END
