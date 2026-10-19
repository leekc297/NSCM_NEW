

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_STOCK_SWITCHING]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    ------------------------------------------------------------------------  
    -- 2025.06.11 Philsu Park Initial Release
    -- BOH Group단위 재고전환 
	------------------------------------------------------------------------  
    -- Procedure 기본조건.PA
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_STOCK_SWITCHING';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    -- Inventory Var.
    DECLARE @V_INV_PLAN_ID          NVARCHAR(100);
    DECLARE @V_INV_STOCK_ID         NVARCHAR(100);
    DECLARE @V_INV_BUFFER_ID        NVARCHAR(100);
    DECLARE @V_INV_EFFECTIVE_DATE   NVARCHAR(100);
    DECLARE @V_INV_TYPE             NVARCHAR(100);
    DECLARE @V_INV_QTY              NUMERIC(20,10);
    DECLARE @V_INV_SITE_ID          NVARCHAR(100);
    DECLARE @V_INV_ITEM_ID          NVARCHAR(100);
    DECLARE @V_INV_STAGE            NVARCHAR(100);
    DECLARE @V_INV_INCOTERMS        NVARCHAR(100);
    DECLARE @V_INV_PROJECT_CODE     NVARCHAR(100);
    DECLARE @V_INV_REMAIN_QTY       NUMERIC(20,10);
    DECLARE @V_INV_VMI_YN           NVARCHAR(100);
    DECLARE @V_SEQ                  INT = 0;

    -- Demand Var.
    DECLARE @V_DM_DEMAND_ID     NVARCHAR(100);
    DECLARE @V_DM_BUFFER_ID     NVARCHAR(100);
    DECLARE @V_DM_SITE_ID       NVARCHAR(100);
    DECLARE @V_DM_ITEM_ID       NVARCHAR(100);
    DECLARE @V_DM_STAGE         VARCHAR(100);
    DECLARE @V_DM_INCOTERMS     NVARCHAR(100);
    DECLARE @V_DM_PROJECT_CODE  NVARCHAR(100);
    DECLARE @V_DM_REMAIN_QTY    NUMERIC(20,10);
    DECLARE @V_DM_BOH_GROUP     NVARCHAR(100);
    DECLARE @V_DM_VMI_YN           NVARCHAR(100);

    DECLARE @BOH_GROUP_T TABLE(
      DIVISION_ID   NVARCHAR(200)
    , BOH_GROUP     NVARCHAR(200)
    , ITEM_ID       NVARCHAR(200)
    )
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    ------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	--BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------  
	BEGIN TRY
        ----------------------------------------------------------------------------------------------------
        -- 0. Data Delete.
        ----------------------------------------------------------------------------------------------------
        DELETE 
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN
        WHERE   PLAN_ID = @V_PLAN_ID+'_BK'
        ;

        -- START 2025-12-15 jongykim2: Demand Group Master
        IF @V_DIVISION_ID = '81'
            BEGIN
                INSERT INTO @BOH_GROUP_T (
                    DIVISION_ID
                  , BOH_GROUP
                  , ITEM_ID
                )
                SELECT T2.DIVISION_ID
                     , T.GROUP_NAME  AS BOH_GROUP
                     , T2.ITEM_ID
                FROM   SCP_MST_ITEM_GROUP T WITH(NOLOCK)
                INNER JOIN SCP_MST_ITEM_GROUP_DETAIL T2 WITH(NOLOCK)
                ON     T2.DIVISION_ID = T.DIVISION_ID
                AND    T2.GROUP_ID = T.GROUP_ID
                WHERE  1 = 1
                AND    T2.DIVISION_ID = @V_DIVISION_ID
                AND    T2.VALID_YN = 'Y'
                AND    T.ATTRIBUTE1 = 'Y';
            END
        ELSE IF @V_DIVISION_ID = '40'
            BEGIN
                INSERT INTO @BOH_GROUP_T (
                    DIVISION_ID
                  , BOH_GROUP
                  , ITEM_ID
                )
                SELECT  SEGMENT2    AS DIVISION_ID
                      , SEGMENT4    AS BOH_GROUP
                      , SEGMENT5    AS ITEM_ID
                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_BOH_GROUP'
                AND     VALID_YN    = 'Y'
                AND     SEGMENT2    = @V_DIVISION_ID
                AND     SEGMENT3    = @V_GROUP_ID
            END
        ;

        -- END 2025-12-15 jongykim2:

        ----------------------------------------------------------------------------------------------------
        -- 1. Update Allocation Target Demand.
        -- 재고와 동일 Item 으로 비교해서 누적 SUM이 > Inventory 인 구간에서부터 남는 Demand로 판단.
        -- 2025.06.12 Philsu Park: 특정 VMI 재고 두배 집계되어있는걸 하나만 쓰기 위해 INV_EXCEPTION 추가.
        -- 2025.06.16 Philsu Park: VMI 재고는 VMI 내에서만 스위칭 가능. 타 지역으로 못넘김.
        ----------------------------------------------------------------------------------------------------
        WITH BOH_GROUP AS (
                        /*SELECT    SEGMENT4      AS BOH_GROUP
                                , SEGMENT5      AS ITEM_ID
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_BOH_GROUP'
                        AND     VALID_YN    = 'Y'
                        AND     SEGMENT2    = @V_DIVISION_ID
                        AND     SEGMENT3    = @V_GROUP_ID*/ -- BLOCKED 2025-12-15 jongykim2: Demand Group Master
                        -- and     SEGMENT4    = 'BMW 48V Gen 1.0 G20LL'
                        -- Added 2025-12-15 jongykim2: Demand Group Master
                        SELECT T.BOH_GROUP
                             , T.ITEM_ID
                        FROM   @BOH_GROUP_T T
                )
            , INV_EXCEPTION AS (
                        SELECT    STOCK_ID
                                , CASE WHEN ISNULL(MST.VMI_YN, 'N') = 'Y'
                                       THEN ROW_NUMBER()OVER(PARTITION BY INV.TYPE, INV.ATTRIBUTE2, INV.ATTRIBUTE3, INV.ATTRIBUTE4, INV.EFFECTIVE_DATE ORDER BY INV.QUANTITY ASC, INV.ATTRIBUTE1 DESC)
                                       ELSE 1
                                   END AS R_NUM
                        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INV WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BG
                            ON  BG.ITEM_ID   = INV.ATTRIBUTE2
                        INNER JOIN SCM_MST_SITE MST WITH(NOLOCK)
                            ON  MST.DIVISION_ID = @V_DIVISION_ID
                            AND MST.SCM_SITE_ID = INV.ATTRIBUTE1
                        WHERE   INV.PLAN_ID = @V_PLAN_ID
                )
            , INVENTORY AS (
                        SELECT    STK.ATTRIBUTE2        AS ITEM_ID
                                , ISNULL(ST.VMI_YN, 'N') AS VMI_YN
                                , SUM(TRY_CONVERT(NUMERIC(20, 10), STK.QUANTITY)) AS QTY
                        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN STK WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BOH
                            ON STK.ATTRIBUTE2 = BOH.ITEM_ID
                        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
                            ON  ST.DIVISION_ID = @V_DIVISION_ID
                            AND ST.SCM_SITE_ID = STK.ATTRIBUTE1
                        WHERE   STK.PLAN_ID = @V_PLAN_ID
                        AND     EXISTS (SELECT  1
                                        FROM    INV_EXCEPTION
                                        WHERE   STOCK_ID    = STK.STOCK_ID
                                        AND     R_NUM       = 1
                                        )
                        AND     ISNULL(ST.VMI_YN, 'N') = 'Y'
                        GROUP BY STK.ATTRIBUTE2, ISNULL(ST.VMI_YN, 'N')
                )
            , DEMAND_ACCU AS (
                        SELECT    DMD.PLAN_ID
                                , DMD.DEMAND_ID
                                , DMD.DUE_DATE
                                , DMD.ATTRIBUTE2 AS ITEM_ID
                                , TRY_CONVERT(NUMERIC(20, 10), DMD.QUANTITY) AS QTY
                                , SUM(TRY_CONVERT(NUMERIC(20, 10), DMD.QUANTITY))OVER(PARTITION BY DMD.ATTRIBUTE2 ORDER BY ISNULL(ST.VMI_YN, 'N') DESC, DMD.DUE_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ACCUM_QTY
                                , IIF(ISNULL(ST.VMI_YN, 'N') = 'Y', ISNULL(VMI.QTY, 0), 0) AS INV_QTY
                        FROM    SCP_OPT_ENG_DEMAND_SN DMD WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BOH
                            ON DMD.ATTRIBUTE2 = BOH.ITEM_ID
                        INNER JOIN SCM_MST_SITE ST WITH(NOLOCK)
                            ON  ST.DIVISION_ID = @V_DIVISION_ID
                            AND ST.SCM_SITE_ID = DMD.ATTRIBUTE1
                        LEFT OUTER JOIN INVENTORY VMI
                            ON  DMD.ATTRIBUTE2  = VMI.ITEM_ID
                            AND VMI.VMI_YN      = 'Y'
                        /* LEFT OUTER JOIN INVENTORY INV
                            ON  DMD.ATTRIBUTE2  = INV.ITEM_ID
                            AND INV.VMI_YN      = 'N' */
                        WHERE   DMD.PLAN_ID     = @V_PLAN_ID
                        AND     ISNULL(ST.VMI_YN, 'N') = 'Y'
                )
            , DEMAND_CALC AS (
                        SELECT    DM.PLAN_ID
                                , DM.DEMAND_ID
                                , DM.DUE_DATE
                                , DM.ITEM_ID
                                , DM.QTY
                                , DM.ACCUM_QTY
                                , DM.INV_QTY
                                , CASE WHEN DM.ACCUM_QTY > DM.INV_QTY THEN IIF(DM.ACCUM_QTY - DM.INV_QTY - DM.QTY > 0, DM.QTY, DM.ACCUM_QTY - DM.INV_QTY) 
                                    ELSE 0 
                                END AS REMAIN_DMD_QTY -- ATTRIBUTE11
                                -- , CASE WHEN DM.ACCUM_QTY > DM.INV_QTY THEN IIF(DM.ACCUM_QTY - DM.INV_QTY - DM.QTY > 0, DM.QTY, DM.ACCUM_QTY - DM.INV_QTY) ELSE 0 END AS ALLOC_DMD_QTY -- ATTRIBUTE10
                                -- , DM.QTY - CASE WHEN DM.ACCUM_QTY > DM.INV_QTY THEN IIF(DM.ACCUM_QTY - DM.INV_QTY - DM.QTY > 0, DM.QTY, DM.ACCUM_QTY - DM.INV_QTY) ELSE 0 END AS TO_BE_DMD_QTY --QUANTITY
                        FROM    DEMAND_ACCU DM
                )
        UPDATE  DMD
        SET       DMD.ATTRIBUTE10 = DEMAND_CALC.REMAIN_DMD_QTY
                , DMD.ATTRIBUTE11 = DEMAND_CALC.REMAIN_DMD_QTY
                , DMD.ATTRIBUTE14 = BOH.BOH_GROUP  --마킹해놓고 시작.
        FROM    SCP_OPT_ENG_DEMAND_SN DMD
        INNER JOIN BOH_GROUP BOH
            ON DMD.ATTRIBUTE2 = BOH.ITEM_ID
        INNER JOIN DEMAND_CALC
            ON  DMD.PLAN_ID     = DEMAND_CALC.PLAN_ID
            AND DMD.DEMAND_ID   = DEMAND_CALC.DEMAND_ID
        WHERE   DMD.PLAN_ID     = @V_PLAN_ID
        ;

        ----------------------------------------------------------------------------------------------------
        -- 2. Update Switching Target Inventory.
        -- Demand와 동일 Item 으로 비교해서 누적 SUM이 > Demand 인 구간에서부터 사용 가능.
        -- 2025.06.12 Philsu Park: 특정 VMI 재고 두배 집계되어있는걸 하나만 쓰기 위해 INV_EXCEPTION 추가.
        -- 2025.06.16 Philsu Park: VMI 재고는 VMI 내에서만 스위칭 가능. 타 지역으로 못넘김.
        ----------------------------------------------------------------------------------------------------
        WITH BOH_GROUP AS (
                        /*SELECT    SEGMENT4      AS BOH_GROUP
                                , SEGMENT5      AS ITEM_ID
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_BOH_GROUP'
                        AND     VALID_YN    = 'Y'
                        AND     SEGMENT2    = @V_DIVISION_ID
                        AND     SEGMENT3    = @V_GROUP_ID*/ -- blocked 2025-12-15 jongykim2
                        -- Added 2025-12-15 jongykim2: Demand Group Master
                        SELECT T.BOH_GROUP
                             , T.ITEM_ID
                        FROM   @BOH_GROUP_T T
                )
            , INV_EXCEPTION AS (
                        SELECT    STOCK_ID
                                , CASE WHEN ISNULL(MST.VMI_YN, 'N') = 'Y'
                                       THEN ROW_NUMBER()OVER(PARTITION BY INV.TYPE, INV.ATTRIBUTE2, INV.ATTRIBUTE3, INV.ATTRIBUTE4, INV.EFFECTIVE_DATE ORDER BY INV.QUANTITY ASC, INV.ATTRIBUTE1 DESC)
                                       ELSE 1
                                   END AS R_NUM
                        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INV WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BG
                            ON  BG.ITEM_ID   = INV.ATTRIBUTE2
                        INNER JOIN SCM_MST_SITE MST WITH(NOLOCK)
                            ON  MST.DIVISION_ID = @V_DIVISION_ID
                            AND MST.SCM_SITE_ID = INV.ATTRIBUTE1
                        WHERE   INV.PLAN_ID = @V_PLAN_ID
                )
            , DEMAND AS (
                        SELECT  D.ATTRIBUTE2 AS ITEM_ID, ISNULL(ST.VMI_YN, 'N') AS VMI_YN, SUM(TRY_CONVERT(NUMERIC(20, 10), D.QUANTITY)) AS QTY
                        FROM    SCP_OPT_ENG_DEMAND_SN D WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BOH
                            ON D.ATTRIBUTE2 = BOH.ITEM_ID
                        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
                            ON  ST.DIVISION_ID = @V_DIVISION_ID
                            AND ST.SCM_SITE_ID = D.ATTRIBUTE1
                        WHERE   D.PLAN_ID = @V_PLAN_ID
                        AND     ISNULL(ST.VMI_YN, 'N') = 'Y'
                        GROUP BY D.ATTRIBUTE2, ISNULL(ST.VMI_YN, 'N')
                )
            , INV_CALC AS (
                        SELECT    INV.PLAN_ID, INV.STOCK_ID, INV.EFFECTIVE_DATE
                                , INV.ATTRIBUTE2 AS ITEM_ID
                                , INV.TYPE
                                , INV.ATTRIBUTE4
                                , TRY_CONVERT(NUMERIC(20, 10), QUANTITY) AS QTY
                                --누적 SUM Order by 시 재고유형(판매쪽에 있는지 등) 검토 필요.
                                , SUM(TRY_CONVERT(NUMERIC(20, 10), QUANTITY))OVER(PARTITION BY INV.ATTRIBUTE2 ORDER BY INV.ATTRIBUTE4 DESC, INV.EFFECTIVE_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ACCUM_QTY
                                -- , VDM.QTY + IIF(ISNULL(ST.VMI_YN, 'N') = 'Y', 0, DM.QTY) AS DEMAND_QTY
                                , ISNULL(VDM.QTY, 0) AS DEMAND_QTY
                        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INV WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BOH
                            ON INV.ATTRIBUTE2 = BOH.ITEM_ID
                        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
                            ON  ST.DIVISION_ID = @V_DIVISION_ID
                            AND ST.SCM_SITE_ID = INV.ATTRIBUTE1
                        LEFT OUTER JOIN DEMAND VDM
                            ON  VDM.ITEM_ID = INV.ATTRIBUTE2
                            AND VDM.VMI_YN  = 'Y'
                        /* LEFT OUTER JOIN DEMAND DM
                            ON  DM.ITEM_ID  = INV.ATTRIBUTE2
                            AND DM.VMI_YN   = 'N' */
                        WHERE   INV.PLAN_ID = @V_PLAN_ID
                        AND     ISNULL(ST.VMI_YN, 'N') = 'Y'
                        AND     EXISTS (SELECT  1
                                        FROM    INV_EXCEPTION
                                        WHERE   STOCK_ID    = INV.STOCK_ID
                                        AND     R_NUM       = 1
                                        )
                )
            , INV_CHANGE AS (
                        SELECT I.PLAN_ID
                            , I.STOCK_ID
                            , I.EFFECTIVE_DATE
                            , I.ITEM_ID
                            , I.[TYPE]
                            , I.ATTRIBUTE4
                            , I.QTY
                            , I.ACCUM_QTY
                            , I.DEMAND_QTY
                            , CASE WHEN I.ACCUM_QTY > I.DEMAND_QTY THEN IIF(I.ACCUM_QTY - I.DEMAND_QTY - I.QTY > 0, I.QTY, I.ACCUM_QTY - I.DEMAND_QTY) ELSE 0 END AS ALLOC_INV_QTY -- ATTRIBUTE10
                            , CASE WHEN I.ACCUM_QTY > I.DEMAND_QTY THEN IIF(I.ACCUM_QTY - I.DEMAND_QTY - I.QTY > 0, I.QTY, I.ACCUM_QTY - I.DEMAND_QTY) ELSE 0 END AS REMAIN_INV_QTY -- ATTRIBUTE11
                            , I.QTY - CASE WHEN I.ACCUM_QTY > I.DEMAND_QTY THEN IIF(I.ACCUM_QTY - I.DEMAND_QTY - I.QTY > 0, I.QTY, I.ACCUM_QTY - I.DEMAND_QTY) ELSE 0 END AS TO_BE_INV_QTY --QUANTITY
                        FROM    INV_CALC I 
                )
        UPDATE  STK
        SET       STK.ATTRIBUTE10 = INV_CHANGE.ALLOC_INV_QTY
                , STK.ATTRIBUTE11 = INV_CHANGE.REMAIN_INV_QTY
                , STK.ATTRIBUTE12 = INV_CHANGE.TO_BE_INV_QTY
                , STK.ATTRIBUTE15 = BOH.BOH_GROUP  --마킹해놓고 시작.
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN STK
        INNER JOIN BOH_GROUP BOH
            ON  STK.ATTRIBUTE2  = BOH.ITEM_ID
        INNER JOIN INV_CHANGE
            ON  STK.PLAN_ID     = INV_CHANGE.PLAN_ID
            AND STK.STOCK_ID    = INV_CHANGE.STOCK_ID
        WHERE   STK.PLAN_ID     = @V_PLAN_ID
        -- AND     CONVERT(NUMERIC(20, 10), STK.QUANTITY) <> INV_CHANGE.TO_BE_INV_QTY
        ;

        SELECT DISTINCT ATTRIBUTE15 AS BOH_GROUP
        INTO   #BOH_GROUP
        FROM   SCP_OPT_ENG_INCOMING_STOCK_SN
        WHERE  PLAN_ID = @V_PLAN_ID
        AND    ATTRIBUTE15 IS NOT NULL
        ;
        
        ------------------------------------------------------------------------
        -- Inventory Switching Start
        -- 2025.07.25 Philsu Park: 2단계로 나눠 돌리는데, 일단 VMI만 한바퀴 돌림.
        ------------------------------------------------------------------------
        IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'DMD_CURSOR')
            BEGIN
                CLOSE DMD_CURSOR
                DEALLOCATE DMD_CURSOR
            END;

        DECLARE DMD_CURSOR CURSOR FOR
            SELECT    DM.DEMAND_ID              AS DEMAND_ID
                    , DM.BUFFER_ID              AS BUFFER_ID
                    , DM.ATTRIBUTE1             AS SITE_ID
                    , DM.ATTRIBUTE2             AS ITEM_ID
                    , DM.ATTRIBUTE3             AS STAGE
                    , DM.ATTRIBUTE4             AS INCOTERMS
                    , DM.ATTRIBUTE5             AS PROJECT_CODE
                    , TRY_CONVERT(NUMERIC(30, 10), DM.ATTRIBUTE10) AS QTY
                    , DM.ATTRIBUTE14            AS BOH_GROUP
                    , ISNULL(ST.VMI_YN, 'N')    AS VMI_YN
                    -- , ATTRIBUTE10 AS REMAIN_QTY
                    -- , ROW_NUMBER()OVER(ORDER BY REMAIN_QTY DESC) RNK
            FROM    SCP_OPT_ENG_DEMAND_SN DM
            LEFT OUTER JOIN SCM_MST_SITE ST
                ON  ST.DIVISION_ID  = @V_DIVISION_ID
                AND ST.SCM_SITE_ID  = DM.ATTRIBUTE1
            WHERE   1=1
            AND     DM.PLAN_ID = @V_PLAN_ID
            -- AND     ISNULL(ATTRIBUTE10, TRY_CONVERT(NUMERIC(30, 10), QUANTITY)) > 0
            AND     TRY_CONVERT(NUMERIC(30, 10), DM.ATTRIBUTE10) > 0
            AND     ISNULL(ST.VMI_YN, 'N') = 'Y'
            AND     EXISTS (SELECT 1 FROM #BOH_GROUP WHERE BOH_GROUP = DM.ATTRIBUTE14)
            ORDER BY BOH_GROUP, VMI_YN DESC, QTY DESC
            FOR UPDATE

        /* 초과 Demand도 재고 부족한걸 찾아주는 조건이 추가로 필요함.  */
        OPEN    DMD_CURSOR
            FETCH NEXT FROM DMD_CURSOR INTO   @V_DM_DEMAND_ID
                                            , @V_DM_BUFFER_ID
                                            , @V_DM_SITE_ID
                                            , @V_DM_ITEM_ID
                                            , @V_DM_STAGE
                                            , @V_DM_INCOTERMS
                                            , @V_DM_PROJECT_CODE
                                            , @V_DM_REMAIN_QTY
                                            , @V_DM_BOH_GROUP
                                            , @V_DM_VMI_YN
            WHILE @@FETCH_STATUS = 0
                BEGIN
                    -- PRINT ('DEMAND Number: ' + @V_DM_DEMAND_ID);
                    IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'INV_CURSOR')
                        BEGIN
                            CLOSE INV_CURSOR
                            DEALLOCATE INV_CURSOR
                        END;

                        DECLARE INV_CURSOR CURSOR FOR
                            SELECT    INV.PLAN_ID
                                    , INV.STOCK_ID
                                    , INV.BUFFER_ID
                                    , INV.EFFECTIVE_DATE
                                    , INV.TYPE
                                    , TRY_CONVERT(NUMERIC(20, 10), INV.ATTRIBUTE11) AS QTY
                                    , INV.ATTRIBUTE1 SITE_ID
                                    , INV.ATTRIBUTE2 ITEM_ID
                                    , INV.ATTRIBUTE3 STAGE
                                    , INV.ATTRIBUTE4 INCOTERMS
                                    , INV.ATTRIBUTE5 PROJECT_CODE
                                    , ISNULL(ST.VMI_YN, 'N') AS VMI_YN
                            FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INV
                            LEFT OUTER JOIN SCM_MST_SITE ST
                                ON  ST.DIVISION_ID  = @V_DIVISION_ID
                                AND ST.SCM_SITE_ID  = INV.ATTRIBUTE1
                            WHERE   INV.PLAN_ID = @V_PLAN_ID
                            AND     ISNULL(TRY_CONVERT(NUMERIC(20, 10), INV.ATTRIBUTE11), 0) > 0
                            AND     INV.ATTRIBUTE15 = @V_DM_BOH_GROUP
                            AND     ISNULL(ST.VMI_YN, 'N') = 'Y'
                            AND     ISNULL(ST.VMI_YN, 'N') = IIF(ISNULL(ST.VMI_YN, 'N') = 'Y', @V_DM_VMI_YN, ISNULL(ST.VMI_YN, 'N'))
                            ORDER BY VMI_YN DESC, QTY
                            FOR UPDATE

                        OPEN INV_CURSOR
                            FETCH NEXT FROM INV_CURSOR INTO   @V_INV_PLAN_ID
                                                            , @V_INV_STOCK_ID
                                                            , @V_INV_BUFFER_ID
                                                            , @V_INV_EFFECTIVE_DATE
                                                            , @V_INV_TYPE
                                                            , @V_INV_REMAIN_QTY
                                                            , @V_INV_SITE_ID
                                                            , @V_INV_ITEM_ID
                                                            , @V_INV_STAGE
                                                            , @V_INV_INCOTERMS
                                                            , @V_INV_PROJECT_CODE
                                                            , @V_INV_VMI_YN
                                WHILE @@FETCH_STATUS = 0
                                    BEGIN
                                        -- PRINT (@V_INV_STOCK_ID + '////' + CAST(@V_INV_REMAIN_QTY AS NVARCHAR(100)));
                                        SELECT @V_SEQ = @V_SEQ+1;

                                        IF ( @V_DM_REMAIN_QTY > 0) AND (@V_INV_REMAIN_QTY <=  @V_DM_REMAIN_QTY )-- Demand ID가 전체 다 Full Pegging 되는 case
                                            BEGIN
                                                
                                                -- Detail Update.
                                                UPDATE  SCP_OPT_ENG_INCOMING_STOCK_SN
                                                SET     ATTRIBUTE11 = 0
                                                WHERE   CURRENT OF INV_CURSOR
                                                ;

                                                INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN
                                                ( PLAN_ID
                                                , STOCK_ID
                                                , BUFFER_ID
                                                , EFFECTIVE_DATE
                                                , TYPE
                                                , QUANTITY
                                                , ATTRIBUTE1
                                                , ATTRIBUTE2
                                                , ATTRIBUTE3
                                                , ATTRIBUTE4
                                                , ATTRIBUTE5
                                                , ATTRIBUTE6
                                                , ATTRIBUTE7
                                                , ATTRIBUTE8
                                                , ATTRIBUTE9
                                                , ATTRIBUTE10
                                                , ATTRIBUTE11
                                                , ATTRIBUTE12
                                                , ATTRIBUTE13
                                                , ATTRIBUTE14
                                                , ATTRIBUTE15
                                                , INSERT_ID
                                                )
                                                    SELECT @V_INV_PLAN_ID AS PLAN_ID
                                                        /* ,TYPE+'::'+SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)+'::'+EFECTIVE_DATE AS STOCK_ID
                                                            ,SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)                              AS BUFFER_ID */
                                                        -- Inventory 위치가 생산사이트이면 ITEM_ID만 변경, 판매사이트면 Demand 기준으로 바꿔치기.(SITE, INCOTERMS, PROJECT_CODE)
                                                        , CASE WHEN @V_INV_INCOTERMS = '-' 
                                                            THEN CONCAT(@V_INV_TYPE, '::', @V_INV_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, '::', @V_INV_EFFECTIVE_DATE, '::', @V_INV_ITEM_ID, '::', CAST(@V_SEQ AS NVARCHAR(1000)))
                                                            ELSE CONCAT(@V_INV_TYPE, '::', @V_DM_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, IIF(@V_DM_INCOTERMS='-', '', '@'+@V_DM_INCOTERMS), IIF(@V_DM_PROJECT_CODE='', '', '@'+@V_DM_PROJECT_CODE), '::', @V_INV_EFFECTIVE_DATE, '::', @V_INV_ITEM_ID, '::', CAST(@V_SEQ AS NVARCHAR(1000)))
                                                            END              AS STOCK_ID
                                                        , CASE WHEN @V_INV_INCOTERMS = '-' 
                                                            THEN CONCAT(@V_INV_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE)
                                                            ELSE CONCAT(@V_DM_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, IIF(@V_DM_INCOTERMS='-', '', '@'+@V_DM_INCOTERMS), IIF(@V_DM_PROJECT_CODE='', '', '@'+@V_DM_PROJECT_CODE))
                                                            END              AS BUFFER_ID
                                                        , @V_INV_EFFECTIVE_DATE AS EFFECTIVE_DATE
                                                        , @V_INV_TYPE           AS TYPE
                                                        , @V_INV_REMAIN_QTY      AS QUANTITY
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_SITE_ID, @V_DM_SITE_ID)            AS ATTRIBUTE1
                                                        , @V_DM_ITEM_ID         AS ATTRIBUTE2
                                                        , @V_INV_STAGE          AS ATTRIBUTE3
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_INCOTERMS, @V_DM_INCOTERMS)        AS ATTRIBUTE4
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_PROJECT_CODE, @V_DM_PROJECT_CODE)  AS ATTRIBUTE5
                                                        , NULL                  AS ATTRIBUTE6
                                                        , @V_INV_SITE_ID        AS ATTRIBUTE7
                                                        , @V_INV_ITEM_ID        AS ATTRIBUTE8
                                                        , @V_INV_INCOTERMS      AS ATTRIBUTE9
                                                        , @V_INV_PROJECT_CODE   AS ATTRIBUTE10
                                                        , @V_DM_DEMAND_ID       AS ATTRIBUTE11
                                                        , @V_DM_BUFFER_ID       AS ATTRIBUTE12
                                                        , NULL                  AS ATTRIBUTE13
                                                        , NULL                  AS ATTRIBUTE14
                                                        , @V_DM_BOH_GROUP       AS ATTRIBUTE15
                                                        , 'INV_CHANGE'          AS INSERT_ID
                                                ;
                                                
                                                SET @V_DM_REMAIN_QTY = @V_DM_REMAIN_QTY - @V_INV_REMAIN_QTY;

                                                --PRINT   'Remain Sale Qty: '+CAST(@V_INV_REMAIN_QTY as NVARCHAR(10));
                                                
                                                --SET @v_qty = 0
                                            END
                                        ELSE IF ( @V_DM_REMAIN_QTY > 0) AND (@V_INV_REMAIN_QTY >  @V_DM_REMAIN_QTY )-- Demand ID가 전체 다 Full Pegging 되는 case
                                            BEGIN
                                                --PRINT 'Fetch 2: Prod qty '+CAST(@V_DM_REMAIN_QTY as NVARCHAR(10))+' > Sale Qty is: '+CAST(@v_sale_qty as NVARCHAR(10));
                                                
                                                -- Detail Update.
                                                UPDATE  SCP_OPT_ENG_INCOMING_STOCK_SN
                                                SET     ATTRIBUTE11 = @V_INV_REMAIN_QTY - @V_DM_REMAIN_QTY
                                                WHERE   CURRENT OF INV_CURSOR
                                                ;

                                                INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN
                                                        ( PLAN_ID
                                                        , STOCK_ID
                                                        , BUFFER_ID
                                                        , EFFECTIVE_DATE
                                                        , TYPE
                                                        , QUANTITY
                                                        , ATTRIBUTE1
                                                        , ATTRIBUTE2
                                                        , ATTRIBUTE3
                                                        , ATTRIBUTE4
                                                        , ATTRIBUTE5
                                                        , ATTRIBUTE6
                                                        , ATTRIBUTE7
                                                        , ATTRIBUTE8
                                                        , ATTRIBUTE9
                                                        , ATTRIBUTE10
                                                        , ATTRIBUTE11
                                                        , ATTRIBUTE12
                                                        , ATTRIBUTE13
                                                        , ATTRIBUTE14
                                                        , ATTRIBUTE15
                                                        , INSERT_ID
                                                        )
                                                    SELECT @V_INV_PLAN_ID AS PLAN_ID
                                                        /* ,TYPE+'::'+SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)+'::'+EFECTIVE_DATE AS STOCK_ID
                                                            ,SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)                              AS BUFFER_ID */
                                                        -- Inventory 위치가 생산사이트이면 ITEM_ID만 변경, 판매사이트면 Demand 기준으로 바꿔치기.(SITE, INCOTERMS, PROJECT_CODE)
                                                        , CASE WHEN @V_INV_INCOTERMS = '-' 
                                                            THEN CONCAT(@V_INV_TYPE, '::', @V_INV_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, '::', @V_INV_EFFECTIVE_DATE, '::', @V_INV_ITEM_ID, '::', CAST(@V_SEQ AS NVARCHAR(1000)))
                                                            ELSE CONCAT(@V_INV_TYPE, '::', @V_DM_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, IIF(@V_DM_INCOTERMS='-', '', '@'+@V_DM_INCOTERMS), IIF(@V_DM_PROJECT_CODE='', '', '@'+@V_DM_PROJECT_CODE), '::', @V_INV_EFFECTIVE_DATE, '::', @V_INV_ITEM_ID, '::', CAST(@V_SEQ AS NVARCHAR(1000)))
                                                            END AS STOCK_ID
                                                        , CASE WHEN @V_INV_INCOTERMS = '-' 
                                                            THEN CONCAT(@V_INV_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE)
                                                            ELSE CONCAT(@V_DM_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, IIF(@V_DM_INCOTERMS='-', '', '@'+@V_DM_INCOTERMS), IIF(@V_DM_PROJECT_CODE='', '', '@'+@V_DM_PROJECT_CODE))
                                                            END AS BUFFER_ID
                                                        , @V_INV_EFFECTIVE_DATE AS EFFECTIVE_DATE
                                                        , @V_INV_TYPE           AS TYPE
                                                        , @V_DM_REMAIN_QTY      AS QUANTITY
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_SITE_ID, @V_DM_SITE_ID)            AS ATTRIBUTE1
                                                        , @V_DM_ITEM_ID         AS ATTRIBUTE2
                                                        , @V_INV_STAGE          AS ATTRIBUTE3
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_INCOTERMS, @V_DM_INCOTERMS)        AS ATTRIBUTE4
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_PROJECT_CODE, @V_DM_PROJECT_CODE)  AS ATTRIBUTE5
                                                        , NULL                  AS ATTRIBUTE6
                                                        , @V_INV_SITE_ID        AS ATTRIBUTE7
                                                        , @V_INV_ITEM_ID        AS ATTRIBUTE8
                                                        , @V_INV_INCOTERMS      AS ATTRIBUTE9
                                                        , @V_INV_PROJECT_CODE   AS ATTRIBUTE10
                                                        , @V_DM_DEMAND_ID       AS ATTRIBUTE11
                                                        , @V_DM_BUFFER_ID       AS ATTRIBUTE12
                                                        , NULL                  AS ATTRIBUTE13
                                                        , NULL                  AS ATTRIBUTE14
                                                        , @V_DM_BOH_GROUP       AS ATTRIBUTE15
                                                        , 'INV_CHANGE'          AS INSERT_ID
                                                ;
                                                
                                                SET @V_DM_REMAIN_QTY = 0;

                                                UPDATE SCP_OPT_ENG_DEMAND_SN
                                                SET     ATTRIBUTE10 = @V_DM_REMAIN_QTY
                                                WHERE   CURRENT OF DMD_CURSOR;
                                                ;
                                    END
                                

                            FETCH NEXT FROM INV_CURSOR INTO   @V_INV_PLAN_ID
                                                            , @V_INV_STOCK_ID
                                                            , @V_INV_BUFFER_ID
                                                            , @V_INV_EFFECTIVE_DATE
                                                            , @V_INV_TYPE
                                                            , @V_INV_REMAIN_QTY
                                                            , @V_INV_SITE_ID
                                                            , @V_INV_ITEM_ID
                                                            , @V_INV_STAGE
                                                            , @V_INV_INCOTERMS
                                                            , @V_INV_PROJECT_CODE
                                                            , @V_INV_VMI_YN
                            END
                        CLOSE INV_CURSOR
                        DEALLOCATE INV_CURSOR

                        -- 2025.07.25 Philsu Park: DM 차감 수량을 무조건 반영해줌.(0이면 다시 안써야됨)
                        -- IF (@V_DM_REMAIN_QTY > 0)
                        BEGIN
                            -- PRINT 'Remain Demand Insert: '+CAST(@V_DM_REMAIN_QTY as NVARCHAR(100));
                            UPDATE  SCP_OPT_ENG_DEMAND_SN
                            SET       ATTRIBUTE10   = @V_DM_REMAIN_QTY
                                    , UPDATE_ID     = 'ALLOC_AT_VMI'
                                    , UPDATE_TIME   = CURRENT_TIMESTAMP
                            WHERE   CURRENT OF DMD_CURSOR
                            ;

                        END

                    FETCH NEXT FROM DMD_CURSOR INTO   @V_DM_DEMAND_ID
                                                    , @V_DM_BUFFER_ID
                                                    , @V_DM_SITE_ID
                                                    , @V_DM_ITEM_ID
                                                    , @V_DM_STAGE
                                                    , @V_DM_INCOTERMS
                                                    , @V_DM_PROJECT_CODE
                                                    , @V_DM_REMAIN_QTY
                                                    , @V_DM_BOH_GROUP
                                                    , @V_DM_VMI_YN
                END
            CLOSE DMD_CURSOR
            DEALLOCATE DMD_CURSOR
        ;

        -- Non-VMI 재고에 대해서 스위칭 가능 수량 업데이트
        -- VMI Demand는 VMI 재고 써먹고도 부족한 Demand + Non_VMI Demand는 전체.
        WITH BOH_GROUP AS (
                        /*SELECT    SEGMENT4      AS BOH_GROUP
                                , SEGMENT5      AS ITEM_ID
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_BOH_GROUP'
                        AND     VALID_YN    = 'Y'
                        AND     SEGMENT2    = @V_DIVISION_ID
                        AND     SEGMENT3    = @V_GROUP_ID*/ -- blocked 2025-12-15 jongykim2
                        -- Added 2025-12-15 jongykim2: Demand Group Master
                        SELECT T.BOH_GROUP
                             , T.ITEM_ID
                        FROM   @BOH_GROUP_T T
                )
            , INV_EXCEPTION AS (
                        SELECT    STOCK_ID
                                , CASE WHEN ISNULL(MST.VMI_YN, 'N') = 'Y'
                                       THEN ROW_NUMBER()OVER(PARTITION BY INV.TYPE, INV.ATTRIBUTE2, INV.ATTRIBUTE3, INV.ATTRIBUTE4, INV.EFFECTIVE_DATE ORDER BY INV.QUANTITY ASC, INV.ATTRIBUTE1 DESC)
                                       ELSE 1
                                   END AS R_NUM
                        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INV WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BG
                            ON  BG.ITEM_ID   = INV.ATTRIBUTE2
                        INNER JOIN SCM_MST_SITE MST WITH(NOLOCK)
                            ON  MST.DIVISION_ID = @V_DIVISION_ID
                            AND MST.SCM_SITE_ID = INV.ATTRIBUTE1
                        WHERE   INV.PLAN_ID = @V_PLAN_ID
                )
            , DEMAND AS (
                        SELECT  D.ATTRIBUTE2 AS ITEM_ID, ISNULL(ST.VMI_YN, 'N') AS VMI_YN, SUM(TRY_CONVERT(NUMERIC(20, 10), IIF(ISNULL(ST.VMI_YN, 'N') = 'Y', D.ATTRIBUTE10, D.QUANTITY))) AS QTY
                        FROM    SCP_OPT_ENG_DEMAND_SN D WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BOH
                            ON D.ATTRIBUTE2 = BOH.ITEM_ID
                        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
                            ON  ST.DIVISION_ID = @V_DIVISION_ID
                            AND ST.SCM_SITE_ID = D.ATTRIBUTE1
                        WHERE   D.PLAN_ID = @V_PLAN_ID
                        GROUP BY D.ATTRIBUTE2, ISNULL(ST.VMI_YN, 'N')
                )
            , INV_CALC AS (
                        SELECT    INV.PLAN_ID, INV.STOCK_ID, INV.EFFECTIVE_DATE
                                , INV.ATTRIBUTE2 AS ITEM_ID
                                , INV.TYPE
                                , INV.ATTRIBUTE4
                                , TRY_CONVERT(NUMERIC(20, 10), QUANTITY) AS QTY
                                --누적 SUM Order by 시 재고유형(판매쪽에 있는지 등) 검토 필요.
                                , SUM(TRY_CONVERT(NUMERIC(20, 10), QUANTITY))OVER(PARTITION BY INV.ATTRIBUTE2 ORDER BY INV.ATTRIBUTE4 DESC, INV.EFFECTIVE_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ACCUM_QTY
                                , ISNULL(VDM.QTY, 0) + IIF(ISNULL(ST.VMI_YN, 'N') = 'Y', 0, ISNULL(DM.QTY, 0)) AS DEMAND_QTY
                        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INV WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BOH
                            ON INV.ATTRIBUTE2 = BOH.ITEM_ID
                        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
                            ON  ST.DIVISION_ID = @V_DIVISION_ID
                            AND ST.SCM_SITE_ID = INV.ATTRIBUTE1
                        LEFT OUTER JOIN DEMAND VDM
                            ON  VDM.ITEM_ID = INV.ATTRIBUTE2
                            AND VDM.VMI_YN  = 'Y'
                        LEFT OUTER JOIN DEMAND DM
                            ON  DM.ITEM_ID  = INV.ATTRIBUTE2
                            AND DM.VMI_YN   = 'N'
                        WHERE   INV.PLAN_ID = @V_PLAN_ID
                        AND     ISNULL(ST.VMI_YN, 'N') = 'N'
                        AND     EXISTS (SELECT  1
                                        FROM    INV_EXCEPTION
                                        WHERE   STOCK_ID    = INV.STOCK_ID
                                        AND     R_NUM       = 1
                                        )
                )
            , INV_CHANGE AS (
                        SELECT I.PLAN_ID
                            , I.STOCK_ID
                            , I.EFFECTIVE_DATE
                            , I.ITEM_ID
                            , I.[TYPE]
                            , I.ATTRIBUTE4
                            , I.QTY
                            , I.ACCUM_QTY
                            , I.DEMAND_QTY
                            , CASE WHEN I.ACCUM_QTY > I.DEMAND_QTY THEN IIF(I.ACCUM_QTY - I.DEMAND_QTY - I.QTY > 0, I.QTY, I.ACCUM_QTY - I.DEMAND_QTY) ELSE 0 END AS ALLOC_INV_QTY -- ATTRIBUTE10
                            , CASE WHEN I.ACCUM_QTY > I.DEMAND_QTY THEN IIF(I.ACCUM_QTY - I.DEMAND_QTY - I.QTY > 0, I.QTY, I.ACCUM_QTY - I.DEMAND_QTY) ELSE 0 END AS REMAIN_INV_QTY -- ATTRIBUTE11
                            , I.QTY - CASE WHEN I.ACCUM_QTY > I.DEMAND_QTY THEN IIF(I.ACCUM_QTY - I.DEMAND_QTY - I.QTY > 0, I.QTY, I.ACCUM_QTY - I.DEMAND_QTY) ELSE 0 END AS TO_BE_INV_QTY --QUANTITY
                        FROM    INV_CALC I 
                )
        UPDATE  STK
        SET       STK.ATTRIBUTE10 = INV_CHANGE.ALLOC_INV_QTY
                , STK.ATTRIBUTE11 = INV_CHANGE.REMAIN_INV_QTY
                , STK.ATTRIBUTE12 = INV_CHANGE.TO_BE_INV_QTY
                , STK.ATTRIBUTE14 = BOH.BOH_GROUP  --마킹해놓고 시작.
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN STK
        INNER JOIN BOH_GROUP BOH
            ON  STK.ATTRIBUTE2  = BOH.ITEM_ID
        INNER JOIN INV_CHANGE
            ON  STK.PLAN_ID     = INV_CHANGE.PLAN_ID
            AND STK.STOCK_ID    = INV_CHANGE.STOCK_ID
        WHERE   STK.PLAN_ID     = @V_PLAN_ID
        -- AND     CONVERT(NUMERIC(20, 10), STK.QUANTITY) <> INV_CHANGE.TO_BE_INV_QTY
        ;

        -- NON VMI의 경우 기존 #BOH_GROUP을 넣지 않고있었고, ATTRIBUTE15를 그대로 사용하면 VMI 재고를 한 번 더 계산할 우려가 있으므로 임시 테이블 분리
        -- 2025.11.06/T.H.KIM/ 상현 책임님 MC/MT 재고 전환을 위해 수정
        SELECT DISTINCT ATTRIBUTE14 AS BOH_GROUP
        INTO   #N_VMI_BOH_GROUP
        FROM   SCP_OPT_ENG_INCOMING_STOCK_SN
        WHERE  PLAN_ID = @V_PLAN_ID
        AND    ATTRIBUTE14 IS NOT NULL

        ;
        ----------------------------------------------------------------------------------------------------
        -- Demand 2차 업데이트.
        -- VMI는 이미 VMI 재고를 한번 친 값을 가져다 쓰고 Non_VMI 는 Demand 수량 그대로 써서 필요량 계산
        ----------------------------------------------------------------------------------------------------
        WITH BOH_GROUP AS (
                        /*SELECT    SEGMENT4      AS BOH_GROUP
                                , SEGMENT5      AS ITEM_ID
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_BOH_GROUP'
                        AND     VALID_YN    = 'Y'
                        AND     SEGMENT2    = @V_DIVISION_ID
                        AND     SEGMENT3    = @V_GROUP_ID*/ -- blocked 2025-12-15 jongykim2
                        -- Added 2025-12-15 jongykim2: Demand Group Master
                        SELECT T.BOH_GROUP
                             , T.ITEM_ID
                        FROM   @BOH_GROUP_T T
                        -- and     SEGMENT4    = 'BMW 48V Gen 1.0 G20LL'
                )
            , INV_EXCEPTION AS (
                        SELECT    STOCK_ID
                                , CASE WHEN ISNULL(MST.VMI_YN, 'N') = 'Y'
                                       THEN ROW_NUMBER()OVER(PARTITION BY INV.TYPE, INV.ATTRIBUTE2, INV.ATTRIBUTE3, INV.ATTRIBUTE4, INV.EFFECTIVE_DATE ORDER BY INV.QUANTITY ASC, INV.ATTRIBUTE1 DESC)
                                       ELSE 1
                                   END AS R_NUM
                        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INV WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BG
                            ON  BG.ITEM_ID   = INV.ATTRIBUTE2
                        INNER JOIN SCM_MST_SITE MST WITH(NOLOCK)
                            ON  MST.DIVISION_ID = @V_DIVISION_ID
                            AND MST.SCM_SITE_ID = INV.ATTRIBUTE1
                        WHERE   INV.PLAN_ID = @V_PLAN_ID
                )
            , INVENTORY AS (
                        SELECT    STK.ATTRIBUTE2        AS ITEM_ID
                                , ISNULL(ST.VMI_YN, 'N') AS VMI_YN
                                , SUM(TRY_CONVERT(NUMERIC(20, 10), STK.QUANTITY)) AS QTY
                        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN STK WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BOH
                            ON STK.ATTRIBUTE2 = BOH.ITEM_ID
                        LEFT OUTER JOIN SCM_MST_SITE ST WITH(NOLOCK)
                            ON  ST.DIVISION_ID = @V_DIVISION_ID
                            AND ST.SCM_SITE_ID = STK.ATTRIBUTE1
                        WHERE   STK.PLAN_ID = @V_PLAN_ID
                        AND     EXISTS (SELECT  1
                                        FROM    INV_EXCEPTION
                                        WHERE   STOCK_ID    = STK.STOCK_ID
                                        AND     R_NUM       = 1
                                        )
                        AND     ISNULL(ST.VMI_YN, 'N') = 'N'
                        GROUP BY STK.ATTRIBUTE2, ISNULL(ST.VMI_YN, 'N')
                )
            , DEMAND_ACCU AS (
                        SELECT    DMD.PLAN_ID
                                , DMD.DEMAND_ID
                                , DMD.DUE_DATE
                                , DMD.ATTRIBUTE2 AS ITEM_ID
                                , TRY_CONVERT(NUMERIC(20, 10), IIF(ISNULL(ST.VMI_YN, 'N') = 'Y', DMD.ATTRIBUTE10, DMD.QUANTITY)) AS QTY
                                , SUM(IIF(ISNULL(ST.VMI_YN, 'N') = 'Y', DMD.ATTRIBUTE10, DMD.QUANTITY))OVER(PARTITION BY DMD.ATTRIBUTE2 ORDER BY ISNULL(ST.VMI_YN, 'N') DESC, DMD.DUE_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ACCUM_QTY
                                -- , IIF(ISNULL(ST.VMI_YN, 'N') = 'Y', ISNULL(VMI.QTY, 0), 0) + ISNULL(INV.QTY, 0) AS INV_QTY
                                , ISNULL(INV.QTY, 0) AS INV_QTY
                        FROM    SCP_OPT_ENG_DEMAND_SN DMD WITH(NOLOCK)
                        INNER JOIN BOH_GROUP BOH
                            ON DMD.ATTRIBUTE2 = BOH.ITEM_ID
                        INNER JOIN SCM_MST_SITE ST WITH(NOLOCK)
                            ON  ST.DIVISION_ID = @V_DIVISION_ID
                            AND ST.SCM_SITE_ID = DMD.ATTRIBUTE1
                        /* LEFT OUTER JOIN INVENTORY VMI
                            ON  DMD.ATTRIBUTE2  = VMI.ITEM_ID
                            AND VMI.VMI_YN      = 'Y' */
                        LEFT OUTER JOIN INVENTORY INV
                            ON  DMD.ATTRIBUTE2  = INV.ITEM_ID
                            AND INV.VMI_YN      = 'N'
                        WHERE   DMD.PLAN_ID     = @V_PLAN_ID
                        -- AND     ISNULL(ST.VMI_YN, 'N') = 'Y'
                )
            , DEMAND_CALC AS (
                        SELECT    DM.PLAN_ID
                                , DM.DEMAND_ID
                                , DM.DUE_DATE
                                , DM.ITEM_ID
                                , DM.QTY
                                , DM.ACCUM_QTY
                                , DM.INV_QTY
                                , CASE WHEN DM.ACCUM_QTY > DM.INV_QTY THEN IIF(DM.ACCUM_QTY - DM.INV_QTY - DM.QTY > 0, DM.QTY, DM.ACCUM_QTY - DM.INV_QTY) 
                                    ELSE 0 
                                END AS REMAIN_DMD_QTY -- ATTRIBUTE11
                                -- , CASE WHEN DM.ACCUM_QTY > DM.INV_QTY THEN IIF(DM.ACCUM_QTY - DM.INV_QTY - DM.QTY > 0, DM.QTY, DM.ACCUM_QTY - DM.INV_QTY) ELSE 0 END AS ALLOC_DMD_QTY -- ATTRIBUTE10
                                -- , DM.QTY - CASE WHEN DM.ACCUM_QTY > DM.INV_QTY THEN IIF(DM.ACCUM_QTY - DM.INV_QTY - DM.QTY > 0, DM.QTY, DM.ACCUM_QTY - DM.INV_QTY) ELSE 0 END AS TO_BE_DMD_QTY --QUANTITY
                        FROM    DEMAND_ACCU DM
                )
        UPDATE  DMD
        SET       DMD.ATTRIBUTE10 = DEMAND_CALC.REMAIN_DMD_QTY
                , DMD.ATTRIBUTE11 = DEMAND_CALC.REMAIN_DMD_QTY
                , DMD.ATTRIBUTE14 = BOH.BOH_GROUP  --마킹해놓고 시작.
        FROM    SCP_OPT_ENG_DEMAND_SN DMD
        INNER JOIN BOH_GROUP BOH
            ON DMD.ATTRIBUTE2 = BOH.ITEM_ID
        INNER JOIN DEMAND_CALC
            ON  DMD.PLAN_ID     = DEMAND_CALC.PLAN_ID
            AND DMD.DEMAND_ID   = DEMAND_CALC.DEMAND_ID
        WHERE   DMD.PLAN_ID     = @V_PLAN_ID
        ;


        ------------------------------------------------------------------------
        -- Inventory Switching Start
        ------------------------------------------------------------------------
        IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'DMD_CURSOR')
            BEGIN
                CLOSE DMD_CURSOR
                DEALLOCATE DMD_CURSOR
            END;

        DECLARE DMD_CURSOR CURSOR FOR
            SELECT    DM.DEMAND_ID              AS DEMAND_ID
                    , DM.BUFFER_ID              AS BUFFER_ID
                    , DM.ATTRIBUTE1             AS SITE_ID
                    , DM.ATTRIBUTE2             AS ITEM_ID
                    , DM.ATTRIBUTE3             AS STAGE
                    , DM.ATTRIBUTE4             AS INCOTERMS
                    , DM.ATTRIBUTE5             AS PROJECT_CODE
                    , TRY_CONVERT(NUMERIC(30, 10), DM.ATTRIBUTE10) AS QTY
                    , DM.ATTRIBUTE14            AS BOH_GROUP
                    , ISNULL(ST.VMI_YN, 'N')    AS VMI_YN
                    -- , ATTRIBUTE10 AS REMAIN_QTY
                    -- , ROW_NUMBER()OVER(ORDER BY REMAIN_QTY DESC) RNK
            FROM    SCP_OPT_ENG_DEMAND_SN DM
            LEFT OUTER JOIN SCM_MST_SITE ST
                ON  ST.DIVISION_ID  = @V_DIVISION_ID
                AND ST.SCM_SITE_ID  = DM.ATTRIBUTE1
            WHERE   1=1
            AND     DM.PLAN_ID = @V_PLAN_ID
            AND     ISNULL(ST.VMI_YN, 'N') = 'N'
            -- AND     ISNULL(ATTRIBUTE10, TRY_CONVERT(NUMERIC(30, 10), QUANTITY)) > 0
            AND     TRY_CONVERT(NUMERIC(30, 10), DM.ATTRIBUTE10) > 0
            AND     EXISTS (SELECT 1 FROM #N_VMI_BOH_GROUP WHERE BOH_GROUP = DM.ATTRIBUTE14)
            ORDER BY BOH_GROUP, VMI_YN DESC, QTY DESC
            FOR UPDATE

        /* 초과 Demand도 재고 부족한걸 찾아주는 조건이 추가로 필요함.  */
        OPEN    DMD_CURSOR
            FETCH NEXT FROM DMD_CURSOR INTO   @V_DM_DEMAND_ID
                                            , @V_DM_BUFFER_ID
                                            , @V_DM_SITE_ID
                                            , @V_DM_ITEM_ID
                                            , @V_DM_STAGE
                                            , @V_DM_INCOTERMS
                                            , @V_DM_PROJECT_CODE
                                            , @V_DM_REMAIN_QTY
                                            , @V_DM_BOH_GROUP
                                            , @V_DM_VMI_YN
            WHILE @@FETCH_STATUS = 0
                BEGIN
                    -- PRINT ('DEMAND Number: ' + @V_DM_DEMAND_ID);
                    IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'INV_CURSOR')
                        BEGIN
                            CLOSE INV_CURSOR
                            DEALLOCATE INV_CURSOR
                        END;

                        DECLARE INV_CURSOR CURSOR FOR
                            SELECT    INV.PLAN_ID
                                    , INV.STOCK_ID
                                    , INV.BUFFER_ID
                                    , INV.EFFECTIVE_DATE
                                    , INV.TYPE
                                    , TRY_CONVERT(NUMERIC(20, 10), INV.ATTRIBUTE11) AS QTY
                                    , INV.ATTRIBUTE1 SITE_ID
                                    , INV.ATTRIBUTE2 ITEM_ID
                                    , INV.ATTRIBUTE3 STAGE
                                    , INV.ATTRIBUTE4 INCOTERMS
                                    , INV.ATTRIBUTE5 PROJECT_CODE
                                    , ISNULL(ST.VMI_YN, 'N') AS VMI_YN
                            FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INV
                            LEFT OUTER JOIN SCM_MST_SITE ST
                                ON  ST.DIVISION_ID  = @V_DIVISION_ID
                                AND ST.SCM_SITE_ID  = INV.ATTRIBUTE1
                            WHERE   INV.PLAN_ID = @V_PLAN_ID
                            AND     ISNULL(TRY_CONVERT(NUMERIC(20, 10), INV.ATTRIBUTE11), 0) > 0
                            AND     INV.ATTRIBUTE14 = @V_DM_BOH_GROUP
                            AND     ISNULL(ST.VMI_YN, 'N') = 'N'
                            AND     ISNULL(ST.VMI_YN, 'N') = IIF(ISNULL(ST.VMI_YN, 'N') = 'Y', @V_DM_VMI_YN, ISNULL(ST.VMI_YN, 'N'))
                            ORDER BY VMI_YN DESC, QTY
                            FOR UPDATE

                        OPEN INV_CURSOR
                            FETCH NEXT FROM INV_CURSOR INTO   @V_INV_PLAN_ID
                                                            , @V_INV_STOCK_ID
                                                            , @V_INV_BUFFER_ID
                                                            , @V_INV_EFFECTIVE_DATE
                                                            , @V_INV_TYPE
                                                            , @V_INV_REMAIN_QTY
                                                            , @V_INV_SITE_ID
                                                            , @V_INV_ITEM_ID
                                                            , @V_INV_STAGE
                                                            , @V_INV_INCOTERMS
                                                            , @V_INV_PROJECT_CODE
                                                            , @V_INV_VMI_YN

                                WHILE @@FETCH_STATUS = 0
                                    BEGIN
                                        -- PRINT (@V_INV_STOCK_ID + '////' + CAST(@V_INV_REMAIN_QTY AS NVARCHAR(100)));
                                        SELECT @V_SEQ = @V_SEQ+1;

                                        IF ( @V_DM_REMAIN_QTY > 0) AND (@V_INV_REMAIN_QTY <=  @V_DM_REMAIN_QTY )-- Demand ID가 전체 다 Full Pegging 되는 case
                                            BEGIN
                                                
                                                -- Detail Update.
                                                UPDATE  SCP_OPT_ENG_INCOMING_STOCK_SN
                                                SET     ATTRIBUTE11 = 0
                                                WHERE   CURRENT OF INV_CURSOR
                                                ;

                                                INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN
                                                ( PLAN_ID
                                                , STOCK_ID
                                                , BUFFER_ID
                                                , EFFECTIVE_DATE
                                                , TYPE
                                                , QUANTITY
                                                , ATTRIBUTE1
                                                , ATTRIBUTE2
                                                , ATTRIBUTE3
                                                , ATTRIBUTE4
                                                , ATTRIBUTE5
                                                , ATTRIBUTE6
                                                , ATTRIBUTE7
                                                , ATTRIBUTE8
                                                , ATTRIBUTE9
                                                , ATTRIBUTE10
                                                , ATTRIBUTE11
                                                , ATTRIBUTE12
                                                , ATTRIBUTE13
                                                , ATTRIBUTE14
                                                , ATTRIBUTE15
                                                , INSERT_ID
                                                )
                                                    SELECT @V_INV_PLAN_ID AS PLAN_ID
                                                        /* ,TYPE+'::'+SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)+'::'+EFECTIVE_DATE AS STOCK_ID
                                                            ,SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)                              AS BUFFER_ID */
                                                        -- Inventory 위치가 생산사이트이면 ITEM_ID만 변경, 판매사이트면 Demand 기준으로 바꿔치기.(SITE, INCOTERMS, PROJECT_CODE)
                                                        , CASE WHEN @V_INV_INCOTERMS = '-' 
                                                            THEN CONCAT(@V_INV_TYPE, '::', @V_INV_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, '::', @V_INV_EFFECTIVE_DATE, '::', @V_INV_ITEM_ID, '::', CAST(@V_SEQ AS NVARCHAR(1000)))
                                                            ELSE CONCAT(@V_INV_TYPE, '::', @V_DM_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, IIF(@V_DM_INCOTERMS='-', '', '@'+@V_DM_INCOTERMS), IIF(@V_DM_PROJECT_CODE='', '', '@'+@V_DM_PROJECT_CODE), '::', @V_INV_EFFECTIVE_DATE, '::', @V_INV_ITEM_ID, '::', CAST(@V_SEQ AS NVARCHAR(1000)))
                                                            END              AS STOCK_ID
                                                        , CASE WHEN @V_INV_INCOTERMS = '-' 
                                                            THEN CONCAT(@V_INV_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE)
                                                            ELSE CONCAT(@V_DM_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, IIF(@V_DM_INCOTERMS='-', '', '@'+@V_DM_INCOTERMS), IIF(@V_DM_PROJECT_CODE='', '', '@'+@V_DM_PROJECT_CODE))
                                                            END              AS BUFFER_ID
                                                        , @V_INV_EFFECTIVE_DATE AS EFFECTIVE_DATE
                                                        , @V_INV_TYPE           AS TYPE
                                                        , @V_INV_REMAIN_QTY      AS QUANTITY
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_SITE_ID, @V_DM_SITE_ID)            AS ATTRIBUTE1
                                                        , @V_DM_ITEM_ID         AS ATTRIBUTE2
                                                        , @V_INV_STAGE          AS ATTRIBUTE3
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_INCOTERMS, @V_DM_INCOTERMS)        AS ATTRIBUTE4
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_PROJECT_CODE, @V_DM_PROJECT_CODE)  AS ATTRIBUTE5
                                                        , NULL                  AS ATTRIBUTE6
                                                        , @V_INV_SITE_ID        AS ATTRIBUTE7
                                                        , @V_INV_ITEM_ID        AS ATTRIBUTE8
                                                        , @V_INV_INCOTERMS      AS ATTRIBUTE9
                                                        , @V_INV_PROJECT_CODE   AS ATTRIBUTE10
                                                        , @V_DM_DEMAND_ID       AS ATTRIBUTE11
                                                        , @V_DM_BUFFER_ID       AS ATTRIBUTE12
                                                        , NULL                  AS ATTRIBUTE13
                                                        , @V_DM_BOH_GROUP       AS ATTRIBUTE14
                                                        , NULL                  AS ATTRIBUTE15
                                                        , 'INV_CHANGE'          AS INSERT_ID
                                                ;
                                                
                                                SET @V_DM_REMAIN_QTY = @V_DM_REMAIN_QTY - @V_INV_REMAIN_QTY;

                                                --PRINT   'Remain Sale Qty: '+CAST(@V_INV_REMAIN_QTY as NVARCHAR(10));
                                                
                                                --SET @v_qty = 0
                                            END
                                        ELSE IF ( @V_DM_REMAIN_QTY > 0) AND (@V_INV_REMAIN_QTY >  @V_DM_REMAIN_QTY )-- Demand ID가 전체 다 Full Pegging 되는 case
                                            BEGIN
                                                --PRINT 'Fetch 2: Prod qty '+CAST(@V_DM_REMAIN_QTY as NVARCHAR(10))+' > Sale Qty is: '+CAST(@v_sale_qty as NVARCHAR(10));
                                                
                                                -- Detail Update.
                                                UPDATE  SCP_OPT_ENG_INCOMING_STOCK_SN
                                                SET     ATTRIBUTE11 = @V_INV_REMAIN_QTY - @V_DM_REMAIN_QTY
                                                WHERE   CURRENT OF INV_CURSOR
                                                ;

                                                INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN
                                                        ( PLAN_ID
                                                        , STOCK_ID
                                                        , BUFFER_ID
                                                        , EFFECTIVE_DATE
                                                        , TYPE
                                                        , QUANTITY
                                                        , ATTRIBUTE1
                                                        , ATTRIBUTE2
                                                        , ATTRIBUTE3
                                                        , ATTRIBUTE4
                                                        , ATTRIBUTE5
                                                        , ATTRIBUTE6
                                                        , ATTRIBUTE7
                                                        , ATTRIBUTE8
                                                        , ATTRIBUTE9
                                                        , ATTRIBUTE10
                                                        , ATTRIBUTE11
                                                        , ATTRIBUTE12
                                                        , ATTRIBUTE13
                                                        , ATTRIBUTE14
                                                        , ATTRIBUTE15
                                                        , INSERT_ID
                                                        )
                                                    SELECT @V_INV_PLAN_ID AS PLAN_ID
                                                        /* ,TYPE+'::'+SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)+'::'+EFECTIVE_DATE AS STOCK_ID
                                                            ,SITE_ID+'::'+ITEM_ID+'::'+STAGE+IIF(INCOTERMS='-','','@'+INCOTERMS)+IIF(PROJECT_CODE ='','','@'+PROJECT_CODE)                              AS BUFFER_ID */
                                                        -- Inventory 위치가 생산사이트이면 ITEM_ID만 변경, 판매사이트면 Demand 기준으로 바꿔치기.(SITE, INCOTERMS, PROJECT_CODE)
                                                        , CASE WHEN @V_INV_INCOTERMS = '-' 
                                                            THEN CONCAT(@V_INV_TYPE, '::', @V_INV_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, '::', @V_INV_EFFECTIVE_DATE, '::', @V_INV_ITEM_ID, '::', CAST(@V_SEQ AS NVARCHAR(1000)))
                                                            ELSE CONCAT(@V_INV_TYPE, '::', @V_DM_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, IIF(@V_DM_INCOTERMS='-', '', '@'+@V_DM_INCOTERMS), IIF(@V_DM_PROJECT_CODE='', '', '@'+@V_DM_PROJECT_CODE), '::', @V_INV_EFFECTIVE_DATE, '::', @V_INV_ITEM_ID, '::', CAST(@V_SEQ AS NVARCHAR(1000)))
                                                            END AS STOCK_ID
                                                        , CASE WHEN @V_INV_INCOTERMS = '-' 
                                                            THEN CONCAT(@V_INV_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE)
                                                            ELSE CONCAT(@V_DM_SITE_ID, '::', @V_DM_ITEM_ID, '::', @V_INV_STAGE, IIF(@V_DM_INCOTERMS='-', '', '@'+@V_DM_INCOTERMS), IIF(@V_DM_PROJECT_CODE='', '', '@'+@V_DM_PROJECT_CODE))
                                                            END AS BUFFER_ID
                                                        , @V_INV_EFFECTIVE_DATE AS EFFECTIVE_DATE
                                                        , @V_INV_TYPE           AS TYPE
                                                        , @V_DM_REMAIN_QTY      AS QUANTITY
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_SITE_ID, @V_DM_SITE_ID)            AS ATTRIBUTE1
                                                        , @V_DM_ITEM_ID         AS ATTRIBUTE2
                                                        , @V_INV_STAGE          AS ATTRIBUTE3
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_INCOTERMS, @V_DM_INCOTERMS)        AS ATTRIBUTE4
                                                        , IIF(@V_INV_INCOTERMS = '-', @V_INV_PROJECT_CODE, @V_DM_PROJECT_CODE)  AS ATTRIBUTE5
                                                        , NULL                  AS ATTRIBUTE6
                                                        , @V_INV_SITE_ID        AS ATTRIBUTE7
                                                        , @V_INV_ITEM_ID        AS ATTRIBUTE8
                                                        , @V_INV_INCOTERMS      AS ATTRIBUTE9
                                                        , @V_INV_PROJECT_CODE   AS ATTRIBUTE10
                                                        , @V_DM_DEMAND_ID       AS ATTRIBUTE11
                                                        , @V_DM_BUFFER_ID       AS ATTRIBUTE12
                                                        , NULL                  AS ATTRIBUTE13
                                                        , @V_DM_BOH_GROUP       AS ATTRIBUTE14
                                                        , NULL                  AS ATTRIBUTE15
                                                        , 'INV_CHANGE'          AS INSERT_ID
                                                ;
                                                
                                                SET @V_DM_REMAIN_QTY = 0;

                                                UPDATE SCP_OPT_ENG_DEMAND_SN
                                                SET     ATTRIBUTE10 = @V_DM_REMAIN_QTY
                                                WHERE   CURRENT OF DMD_CURSOR;
                                                ;
                                    END
                                

                            FETCH NEXT FROM INV_CURSOR INTO   @V_INV_PLAN_ID
                                                            , @V_INV_STOCK_ID
                                                            , @V_INV_BUFFER_ID
                                                            , @V_INV_EFFECTIVE_DATE
                                                            , @V_INV_TYPE
                                                            , @V_INV_REMAIN_QTY
                                                            , @V_INV_SITE_ID
                                                            , @V_INV_ITEM_ID
                                                            , @V_INV_STAGE
                                                            , @V_INV_INCOTERMS
                                                            , @V_INV_PROJECT_CODE
                                                            , @V_INV_VMI_YN
                            END
                        CLOSE INV_CURSOR
                        DEALLOCATE INV_CURSOR

                        -- 2025.07.25 Philsu Park: DM 차감 수량을 무조건 반영해줌.(0이면 다시 안써야됨)
                        -- IF (@V_DM_REMAIN_QTY > 0)
                        BEGIN
                            -- PRINT 'Remain Demand Insert: '+CAST(@V_DM_REMAIN_QTY as NVARCHAR(100));
                            UPDATE  SCP_OPT_ENG_DEMAND_SN
                            SET     ATTRIBUTE10 = @V_DM_REMAIN_QTY
                                    , UPDATE_ID = 'ALLOC_AT_NON_VMI'
                                    , UPDATE_TIME = CURRENT_TIMESTAMP
                            WHERE   CURRENT OF DMD_CURSOR
                            ;

                        END

                    FETCH NEXT FROM DMD_CURSOR INTO   @V_DM_DEMAND_ID
                                                    , @V_DM_BUFFER_ID
                                                    , @V_DM_SITE_ID
                                                    , @V_DM_ITEM_ID
                                                    , @V_DM_STAGE
                                                    , @V_DM_INCOTERMS
                                                    , @V_DM_PROJECT_CODE
                                                    , @V_DM_REMAIN_QTY
                                                    , @V_DM_BOH_GROUP
                                                    , @V_DM_VMI_YN
                END
            CLOSE DMD_CURSOR
            DEALLOCATE DMD_CURSOR
        ;
        
        -- INV 전환한 대상에 대해 수량 업데이트(전환불가수량만큼) -> VMI는 ATTRIBUTE15, NON_VMI는 ATTRIBUTE14 사용
        UPDATE  STK
        SET     STK.QUANTITY = STK.ATTRIBUTE12
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN STK
        WHERE   STK.PLAN_ID = @V_PLAN_ID
        AND     TRY_CONVERT(NUMERIC(20, 10), STK.ATTRIBUTE12) IS NOT NULL
        AND     EXISTS (
                        /*SELECT 1
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_BOH_GROUP'
                        AND     VALID_YN    = 'Y'
                        AND     SEGMENT2    = @V_DIVISION_ID
                        AND     SEGMENT3    = @V_GROUP_ID
                        AND    (SEGMENT4    = STK.ATTRIBUTE15 OR
                                SEGMENT4    = STK.ATTRIBUTE14
                               )*/ -- blocked 2025-12-15 jongykim2
                        -- Added 2025-12-15 jongykim2: Demand Group Master
                        SELECT 'X'
                        FROM   @BOH_GROUP_T T
                        WHERE (BOH_GROUP    = STK.ATTRIBUTE15 OR
                               BOH_GROUP    = STK.ATTRIBUTE14
                              )
                        )
        ;

        -- INV 전환한 대상에 대해 수량 업데이트(할당된 Demand 없는 경우) -> VMI는 ATTRIBUTE15, NON_VMI는 ATTRIBUTE14 사용
        UPDATE  STK
        SET     STK.QUANTITY = CONVERT(NUMERIC(20, 10), STK.QUANTITY) + CONVERT(NUMERIC(20, 10), STK.ATTRIBUTE11)
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN STK
        WHERE   STK.PLAN_ID = @V_PLAN_ID
        -- AND     CONVERT(NUMERIC(20, 10), STK.QUANTITY) = 0
        AND     TRY_CONVERT(NUMERIC(20, 10), STK.ATTRIBUTE11) > 0
        AND     EXISTS (
                        /*SELECT 1
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_BOH_GROUP'
                        AND     VALID_YN    = 'Y'
                        AND     SEGMENT2    = @V_DIVISION_ID
                        AND     SEGMENT3    = @V_GROUP_ID
                        AND    (SEGMENT4    = STK.ATTRIBUTE15 OR
                                SEGMENT4    = STK.ATTRIBUTE14
                               )*/ -- blocked 2025-12-15 jongykim2
                        -- Added 2025-12-15 jongykim2: Demand Group Master
                        SELECT 'X'
                        FROM   @BOH_GROUP_T T
                        WHERE (BOH_GROUP    = STK.ATTRIBUTE15 OR
                               BOH_GROUP    = STK.ATTRIBUTE14
                              )
                        )
        ;

        -- INV 다 넘긴 대상은 삭제.(또는 PLAN_ID에 마킹..)
        UPDATE  STK
        SET     STK.PLAN_ID = CONCAT(STK.PLAN_ID, '_BK')
        FROM    SCP_OPT_ENG_INCOMING_STOCK_SN STK
        WHERE   STK.PLAN_ID = @V_PLAN_ID
        AND     CONVERT(NUMERIC(20, 10), STK.QUANTITY) = 0
        ;
		

        ------------------------------------------------------------------------
        -- Inventory Switching End
        ------------------------------------------------------------------------		

		/* IF OBJECT_ID('TEMPDB..#SCP_INVENTORY_I') IS NOT NULL
		BEGIN 
			DROP TABLE  #SCP_INVENTORY_I;
		END;		

		IF OBJECT_ID('TEMPDB..#SCP_INTRANSIT_I') IS NOT NULL
		BEGIN 
			DROP TABLE  #SCP_INTRANSIT_I;
		END;	

		IF OBJECT_ID('TEMPDB..#CP_INFO') IS NOT NULL
		BEGIN 
			DROP TABLE  #CP_INFO;
		END; */

	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION ;
	------------------------------------------------------------------------
      -- ERROR LOG
	------------------------------------------------------------------------
        SET @V_MESSAGE_TEXT = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'ERROR',NULL,@V_MESSAGE_TEXT,NULL,@V_PLAN_ID
        ------------------------------------------------------------------------
        SELECT @V_DETAIL_DATE = GETDATE()
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,@V_DETAIL_DATE,NULL,@V_MESSAGE_TEXT,'ERROR'
        ------------------------------------------------------------------------
        RAISERROR(@V_PROGRAM_NAME, 16,1)
        ------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------

	------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    IF @V_MESSAGE_TEXT IS NULL 
    ------------------------------------------------------------------------
    BEGIN
	    EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'END',NULL,NULL,NULL,@V_PLAN_ID
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL
    END
    ------------------------------------------------------------------------
  END;
