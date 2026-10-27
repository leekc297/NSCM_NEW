
/*
 * Program ID   : PR_XLS_OPT_SAVE_PLAN_AMEND_DATA
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.20   FP Pjt.         Create.
 * 2024.11.19   shineuiho67     [MEMO] 컬럼 추가 // SELECT 'NG' as ret, '' as msg  ->  SELECT 'NG' as ret, ERROR_MESSAGE() as msg 로 수정 // @QTY = iif Null 처리 추가
 * 2024.11.21   shineuiho67     ` | 구분자 변경 : , ; 에서 그리고, NULL 처리 추가(memo컬럼) 
 * 2025.09.03   kimcd           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *                                  PR_XLS_SAVE_PLAN_AMEND_DATA -> PR_XLS_OPT_SAVE_PLAN_AMEND_DATA 복사해서 형성
 *                                  Insert를 Merge로 수정
 * 2025-11-05  shineuiho7    [PJ2025-50540] SCP/FP 통합 계획 수립을 위한 시뮬레이터Tool 구축 및 UI 개선 : WORKING_DAY 추가
 *
 ex) 
    exec PR_XLS_OPT_SAVE_PLAN_AMEND_DATA 'UC_CELL_A`UC_CELL_A-20250924-06`G670`81_UC`PLAN`A003`G671`AB`-`A5000`ABA01`Anode``2025-08-27`ACEN4101I-A1-140`ANPAN2122A`MASS`D`-`-`52402`-`1`-``E101A-140`Assy #01`Notching``Notching (Anode)#1140`UC_CELL_A`1`1.0000000000```0.7777777000','shineuiho7'
 */

CREATE  PROCEDURE [dbo].[PR_XLS_OPT_SAVE_PLAN_AMEND_DATA]
	  @p_DataString             NVARCHAR(MAX)
    , @p_userid	    			NVARCHAR(50)    
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_DataString			nvarchar(MAX)
	DECLARE @v_userid			    nvarchar(50)

    DECLARE @Pos INT
    DECLARE @NextPos INT
    DECLARE @Row NVARCHAR(4000)
    DECLARE @INSTANCE_ID NVARCHAR(150)
    DECLARE @FP_PLAN_ID NVARCHAR(150)
    DECLARE @COMPANY_ID NVARCHAR(150)
    DECLARE @DIVISION_ID NVARCHAR(150)
    DECLARE @CATEGORY_ID NVARCHAR(150)
    DECLARE @SITE_ID NVARCHAR(150)
    DECLARE @PLANT_ID NVARCHAR(150)
    DECLARE @FACTORY_ID NVARCHAR(150)
    DECLARE @LOCATION NVARCHAR(150)
    DECLARE @OPERATION_ID NVARCHAR(150)
    DECLARE @LINE_ID NVARCHAR(150)
    DECLARE @ELECTRODE_TYPE NVARCHAR(150)
    DECLARE @EQUIPMENT_ID NVARCHAR(150)
    DECLARE @PLAN_DATE NVARCHAR(150)
    DECLARE @MODEL_ID NVARCHAR(150)
    DECLARE @ITEM_ID NVARCHAR(150)
    DECLARE @PRODUCTION_TYPE NVARCHAR(150)
    DECLARE @MARKET NVARCHAR(150)
    DECLARE @VERSION NVARCHAR(150)
    DECLARE @PLM_EC_NO NVARCHAR(150)
    DECLARE @CELL_OUT_QTY NVARCHAR(150)
    DECLARE @ITEM_TYPE NVARCHAR(150)
    DECLARE @SEQ numeric(20,0)
    DECLARE @CUSTOMER_ID NVARCHAR(150)
    DECLARE @BOH_QTY NVARCHAR(150)
    DECLARE @NICK_NAME NVARCHAR(150)
    DECLARE @LINE_NAME NVARCHAR(150)
    DECLARE @OPERATION_NAME NVARCHAR(150)
    DECLARE @MODE NVARCHAR(150)
    DECLARE @KEYS_MODEL NVARCHAR(150)
    DECLARE @INSTANCE_ID2 NVARCHAR(150)
    DECLARE @RowNum numeric(20,0)
    DECLARE @QTY numeric(20,10)
    DECLARE @CRUD NVARCHAR(150)
    DECLARE @MEMO NVARCHAR(700)

	DECLARE @WORKING_DAY numeric(20,10) -- 2025-11-05  shineuiho7    [PJ2025-50540] SCP/FP 통합 계획 수립을 위한 시뮬레이터Tool 구축 및 UI 개선 : WORKING_DAY 추가

    set     @v_DataString	= @p_DataString
    set     @v_userid	    = @p_userid

    BEGIN TRY
        -- 트랜잭션 시작
        --BEGIN TRANSACTION

        -- 데이터를 세미콜론으로 구분하여 처리
        SET @Pos = 1
        WHILE @Pos > 0
        BEGIN
             -- 세미콜론으로 구분된 각 행 추출

            SET @NextPos = CHARINDEX('|', @v_DataString, @Pos)

            IF @NextPos = 0

                SET @Row = SUBSTRING(@v_DataString, @Pos, LEN(@v_DataString))

            ELSE

                SET @Row = SUBSTRING(@v_DataString, @Pos, @NextPos - @Pos)


            -- 각 행을 콤마로 나누어 데이터 처리

            DECLARE @tempTable TABLE (Value NVARCHAR(4000))

            delete from @tempTable

            INSERT INTO @tempTable (Value)
            SELECT Value FROM dbo.fn_splitstring(@Row, '`')


            -- 커서를 사용하지 않고 직접 값을 추출하여 할당

            SELECT

                @INSTANCE_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY),
                @FP_PLAN_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY),
                @COMPANY_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY),
                @DIVISION_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 3 ROWS FETCH NEXT 1 ROWS ONLY),
                @CATEGORY_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY),
                @SITE_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 5 ROWS FETCH NEXT 1 ROWS ONLY),
                @PLANT_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 6 ROWS FETCH NEXT 1 ROWS ONLY),
                @FACTORY_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 7 ROWS FETCH NEXT 1 ROWS ONLY),
                @LOCATION = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 8 ROWS FETCH NEXT 1 ROWS ONLY),
                @OPERATION_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 9 ROWS FETCH NEXT 1 ROWS ONLY),
                @LINE_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 10 ROWS FETCH NEXT 1 ROWS ONLY),
                @ELECTRODE_TYPE = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 11 ROWS FETCH NEXT 1 ROWS ONLY),
                @EQUIPMENT_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 12 ROWS FETCH NEXT 1 ROWS ONLY),
                @PLAN_DATE = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 13 ROWS FETCH NEXT 1 ROWS ONLY),
                @MODEL_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 14 ROWS FETCH NEXT 1 ROWS ONLY),
                @ITEM_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 15 ROWS FETCH NEXT 1 ROWS ONLY),
                @PRODUCTION_TYPE = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 16 ROWS FETCH NEXT 1 ROWS ONLY),
                @MARKET = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 17 ROWS FETCH NEXT 1 ROWS ONLY),
                @VERSION = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 18 ROWS FETCH NEXT 1 ROWS ONLY),
                @PLM_EC_NO = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 19 ROWS FETCH NEXT 1 ROWS ONLY),
                @CELL_OUT_QTY = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 20 ROWS FETCH NEXT 1 ROWS ONLY),
                @ITEM_TYPE = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 21 ROWS FETCH NEXT 1 ROWS ONLY),
                @SEQ = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 22 ROWS FETCH NEXT 1 ROWS ONLY),
                @CUSTOMER_ID = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 23 ROWS FETCH NEXT 1 ROWS ONLY),
                @BOH_QTY = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 24 ROWS FETCH NEXT 1 ROWS ONLY),
                @NICK_NAME = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 25 ROWS FETCH NEXT 1 ROWS ONLY),
                @LINE_NAME = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 26 ROWS FETCH NEXT 1 ROWS ONLY),
                @OPERATION_NAME = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 27 ROWS FETCH NEXT 1 ROWS ONLY),
                @MODE = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 28 ROWS FETCH NEXT 1 ROWS ONLY),
                @KEYS_MODEL = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 29 ROWS FETCH NEXT 1 ROWS ONLY),
                @INSTANCE_ID2 = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 30 ROWS FETCH NEXT 1 ROWS ONLY),
                @RowNum = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 31 ROWS FETCH NEXT 1 ROWS ONLY),
                @QTY = iif((SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 32 ROWS FETCH NEXT 1 ROWS ONLY) = 'NULL',
                            null,
                           (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 32 ROWS FETCH NEXT 1 ROWS ONLY)),
                @CRUD = (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 33 ROWS FETCH NEXT 1 ROWS ONLY),
                @MEMO = iif((SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 34 ROWS FETCH NEXT 1 ROWS ONLY) = 'NULL',
                            null,
                           (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 34 ROWS FETCH NEXT 1 ROWS ONLY)),
                
				-- 2025-11-05  shineuiho7    [PJ2025-50540] SCP/FP 통합 계획 수립을 위한 시뮬레이터Tool 구축 및 UI 개선 : WORKING_DAY 추가
				@WORKING_DAY = iif((SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 35 ROWS FETCH NEXT 1 ROWS ONLY) = 'NULL',
                            null,
                           (SELECT Value FROM @tempTable ORDER BY (SELECT NULL) OFFSET 35 ROWS FETCH NEXT 1 ROWS ONLY))
						   

            -- 테이블에 삽입



			MERGE INTO [dbo].[BUF_AMEND_PLAN_R_XLS] APR
				USING ( SELECT  @INSTANCE_ID      AS INSTANCE_ID,
								@FP_PLAN_ID       AS FP_PLAN_ID, 
								@COMPANY_ID       AS COMPANY_ID, 
								@DIVISION_ID      AS DIVISION_ID, 
								@CATEGORY_ID      AS CATEGORY_ID, 
								@SITE_ID          AS SITE_ID, 
								@PLANT_ID         AS PLANT_ID, 
								@FACTORY_ID       AS FACTORY_ID, 
								@LOCATION         AS LOCATION, 
								@OPERATION_ID     AS OPERATION_ID, 
								@LINE_ID          AS LINE_ID, 
								@ELECTRODE_TYPE   AS ELECTRODE_TYPE, 
								@EQUIPMENT_ID     AS EQUIPMENT_ID, 
								@PLAN_DATE        AS PLAN_DATE, 
								@MODEL_ID         AS MODEL_ID, 
								@ITEM_ID          AS ITEM_ID, 
								@PRODUCTION_TYPE  AS PRODUCTION_TYPE, 
								@MARKET           AS MARKET, 
								@VERSION          AS VERSION, 
								@PLM_EC_NO        AS PLM_EC_NO, 
								@CELL_OUT_QTY     AS CELL_OUT_QTY, 
								@ITEM_TYPE        AS ITEM_TYPE, 
								@SEQ              AS SEQ, 
								@CUSTOMER_ID      AS CUSTOMER_ID, 
								@BOH_QTY          AS BOH_QTY, 
								@NICK_NAME        AS NICK_NAME, 
								@LINE_NAME        AS LINE_NAME, 
								@OPERATION_NAME   AS OPERATION_NAME, 
								@MODE             AS MODE, 
								@KEYS_MODEL       AS KEYS_MODEL, 
								@INSTANCE_ID2     AS INSTANCE_ID2, 
								@RowNum           AS RowNum, 
								@QTY              AS QTY, 
								@CRUD             AS CRUD, 
								@MEMO             AS MEMO,
								-- 2025-11-05  shineuiho7    [PJ2025-50540] SCP/FP 통합 계획 수립을 위한 시뮬레이터Tool 구축 및 UI 개선 : WORKING_DAY 추가
								@WORKING_DAY   AS WORKING_DAY

								) XXX 
			ON (     APR.INSTANCE_ID           = XXX.INSTANCE_ID            -- FP 정보
                 AND APR.FP_PLAN_ID            = XXX.FP_PLAN_ID             -- FP 정보
                 AND APR.CATEGORY_ID           = XXX.CATEGORY_ID            -- PLAN
                 AND APR.PLANT_ID			   = XXX.PLANT_ID
                 AND APR.ITEM_ID			   = XXX.ITEM_ID
                 AND APR.OPERATION_ID		   = XXX.OPERATION_ID
                 AND APR.FACTORY_ID			   = XXX.FACTORY_ID
                 AND ISNULL(APR.LOCATION,'-')			   = ISNULL(XXX.LOCATION,'-')
				 AND APR.PRODUCTION_TYPE	   = XXX.PRODUCTION_TYPE
				 AND APR.MARKET				   = XXX.MARKET
				 AND APR.LINE_ID			   = XXX.LINE_ID
				 AND ISNULL(APR.ELECTRODE_TYPE,'-')		   = ISNULL(XXX.ELECTRODE_TYPE,'-')
				 AND ISNULL(APR.EQUIPMENT_ID,'-')          = ISNULL(XXX.EQUIPMENT_ID,'-')           -- 전극만 사용
				 AND APR.PLAN_DATE			   = XXX.PLAN_DATE
				 AND APR.MODEL_ID              = XXX.MODEL_ID
				 AND ISNULL(APR.VERSION,'-')               = ISNULL(XXX.VERSION,'-') )              -- 전극만 사용. 환산자용
			WHEN MATCHED THEN
				UPDATE SET 	[PLM_EC_NO]      = XXX.[PLM_EC_NO]     , 
							[CELL_OUT_QTY]   = XXX.[QTY]           ,  -- 계획 수량 변경됬는 지 검증하는 기준 컬럼으로 QTY 값 입력
							[ITEM_TYPE]      = XXX.[ITEM_TYPE]     , 
							[SEQ]            = XXX.[SEQ]           , 
							[CUSTOMER_ID]    = XXX.[CUSTOMER_ID]   , 
							[BOH_QTY]        = XXX.[BOH_QTY]       , 
							[NICK_NAME]      = XXX.[NICK_NAME]     , 
							[LINE_NAME]      = XXX.[LINE_NAME]     , 
							[OPERATION_NAME] = XXX.[OPERATION_NAME], 
							[MODE]           = XXX.[MODE]          , 
							[KEYS_MODEL]     = XXX.[KEYS_MODEL]    , 
							[INSTANCE_ID2]   = XXX.[INSTANCE_ID2]  , 
							[RowNum]         = XXX.[RowNum]        , 
							[QTY]            = XXX.[QTY]           , 
							[CRUD]           = XXX.[CRUD]          , 
							[UPDATE_ID]      = @v_userid       ,
							[UPDATE_TIME]    = getdate()       ,
							[MEMO]           = XXX.[MEMO]    ,
							-- 2025-11-05  shineuiho7    [PJ2025-50540] SCP/FP 통합 계획 수립을 위한 시뮬레이터Tool 구축 및 UI 개선 : WORKING_DAY 추가
							[WORKING_DAY]            = XXX.[WORKING_DAY]            

			WHEN NOT MATCHED THEN
				INSERT (
                        [INSTANCE_ID], 
                        [FP_PLAN_ID], 
                        [COMPANY_ID], 
                        [DIVISION_ID], 
                        [CATEGORY_ID], 
                        [SITE_ID], 
                        [PLANT_ID], 
                        [FACTORY_ID], 
                        [LOCATION], 
                        [OPERATION_ID], 
                        [LINE_ID], 
                        [ELECTRODE_TYPE], 
                        [EQUIPMENT_ID], 
                        [PLAN_DATE], 
                        [MODEL_ID], 
                        [ITEM_ID], 
                        [PRODUCTION_TYPE], 
                        [MARKET], 
                        [VERSION], 
                        [PLM_EC_NO], 
                        [CELL_OUT_QTY], 
                        [ITEM_TYPE], 
                        [SEQ], 
                        [CUSTOMER_ID], 
                        [BOH_QTY], 
                        [NICK_NAME], 
                        [LINE_NAME], 
                        [OPERATION_NAME], 
                        [MODE], 
                        [KEYS_MODEL], 
                        [INSTANCE_ID2], 
                        [RowNum], 
                        [QTY], 
                        [CRUD], 
                        [INSERT_ID], [INSERT_TIME], [UPDATE_ID], [UPDATE_TIME], [MEMO], [WORKING_DAY] ) ---- 2025-11-05  shineuiho7    [PJ2025-50540] SCP/FP 통합 계획 수립을 위한 시뮬레이터Tool 구축 및 UI 개선 : WORKING_DAY 추가

            VALUES (@INSTANCE_ID, 
                        @FP_PLAN_ID, 
                        @COMPANY_ID, 
                        @DIVISION_ID, 
                        @CATEGORY_ID, 
                        @SITE_ID, 
                        @PLANT_ID, 
                        @FACTORY_ID, 
                        @LOCATION, 
                        @OPERATION_ID, 
                        @LINE_ID, 
                        @ELECTRODE_TYPE, 
                        @EQUIPMENT_ID, 
                        @PLAN_DATE, 
                        @MODEL_ID, 
                        @ITEM_ID, 
                        @PRODUCTION_TYPE, 
                        @MARKET, 
                        @VERSION, 
                        @PLM_EC_NO, 
                        @QTY,   --  [CELL_OUT_QTY] -- 계획 수량 변경됬는 지 검증하는 기준 컬럼으로 QTY 값 입력
                        @ITEM_TYPE, 
                        @SEQ, 
                        @CUSTOMER_ID, 
                        @BOH_QTY, 
                        @NICK_NAME, 
                        @LINE_NAME, 
                        @OPERATION_NAME, 
                        @MODE, 
                        @KEYS_MODEL, 
                        @INSTANCE_ID2, 
                        @RowNum, 
                        @QTY, 
                        @CRUD, 
                        @v_userid, getdate(), @v_userid, getdate(),
                        @MEMO,
						-- 2025-11-05  shineuiho7    [PJ2025-50540] SCP/FP 통합 계획 수립을 위한 시뮬레이터Tool 구축 및 UI 개선 : WORKING_DAY 추가
						@WORKING_DAY

						);

            
            -- 다음 위치로 이동

            SET @Pos = CASE WHEN @NextPos > 0 THEN @NextPos + 1 ELSE 0 END
            
        End

        -- 트랜잭션 커밋
        --Commit TRANSACTION


        
        select 'OK' as ret, '' as msg

    END TRY
    BEGIN CATCH
        SELECT 'NG' as ret, ERROR_MESSAGE() as msg
        -- 에러 발생 시 롤백
        --IF @@TRANCOUNT > 0
        --    ROLLBACK TRANSACTION
       
       PRINT 'NG|' + ERROR_MESSAGE()
    END CATCH
End
        



