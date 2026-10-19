

CREATE   PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_SITE_MOVE]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS
BEGIN
    ------------------------------------------------------------------------
    -- Procedure 기본조건.
    ------------------------------------------------------------------------
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET ANSI_WARNINGS OFF;
    ------------------------------------------------------------------------
    -- Set Param for Log
    ------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_SITE_MOVE';
    DECLARE @V_PLAN_ID      NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE  DATETIME;
    ------------------------------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_LVL  INT;
    DECLARE @V_ROWS INT;

    BEGIN TRY

        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

        IF OBJECT_ID('TEMPDB..#SM_TARGET')          IS NOT NULL DROP TABLE #SM_TARGET;
        IF OBJECT_ID('TEMPDB..#SM_VM_ITEM_LIST')    IS NOT NULL DROP TABLE #SM_VM_ITEM_LIST;
        IF OBJECT_ID('TEMPDB..#SM_BLOCKED_ROUTING') IS NOT NULL DROP TABLE #SM_BLOCKED_ROUTING;

        ------------------------------------------------------------------------
        -- 0. 재실행 대비: 기존 SITE_MOVE 생성분 삭제
        --    (수요는 DEMAND 프로시저 소관이므로 여기서 삭제하지 않음)
        ------------------------------------------------------------------------
        PRINT ('1. Delete Previous Site Move Rows: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

        DELETE FROM SCP_OPT_ENG_ITEM_SITE_SN        WHERE PLAN_ID = @V_PLAN_ID AND INSERT_ID = 'SITE_MOVE';
        DELETE FROM SCP_OPT_ENG_BOM_SN              WHERE PLAN_ID = @V_PLAN_ID AND INSERT_ID = 'SITE_MOVE';
        DELETE FROM SCP_OPT_ENG_ROUTING_RESOURCE_SN WHERE PLAN_ID = @V_PLAN_ID AND INSERT_ID = 'SITE_MOVE';
        DELETE FROM SCP_OPT_ENG_ROUTING_SN          WHERE PLAN_ID = @V_PLAN_ID AND INSERT_ID = 'SITE_MOVE';
        DELETE FROM SCP_OPT_ENG_ITEM_BOM_ROUTING_SN WHERE PLAN_ID = @V_PLAN_ID AND INSERT_ID = 'SITE_MOVE';
        DELETE FROM SCP_OPT_ENG_BOD_SN              WHERE PLAN_ID = @V_PLAN_ID AND INSERT_ID = 'SITE_MOVE';

        ------------------------------------------------------------------------
        -- 1. 대상 해석 (#SM_TARGET)
        --    룩업에서 SEG1=내 그룹, SEG5(SUFFIX) 존재 + 실제 증량 수요가 생성된 조합만
        --    (수요가 없는 가상코드의 불필요 copy 방지)
        --    * 같은 가상코드에 금지호기 세팅이 다른 다건 룩업이 있으면 행이 여러 개 생기며,
        --      copy 는 DISTINCT 로 1회, 금지호기 삭제는 합집합으로 동작함
        ------------------------------------------------------------------------
        PRINT ('2. Resolve Target: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

        SELECT  DISTINCT
                LU.SEGMENT2                       AS TO_SITE_DEMAND    -- 수요(고객) 사이트
               ,LU.SEGMENT3                       AS TO_SITE_SUPPLY    -- 생산 사이트
               ,LU.SEGMENT4                       AS ORIG_ITEM         -- 원본 모델
               ,LU.SEGMENT5                       AS ITEM_SUFFIX       -- SUFFIX (구분자 포함)
               ,LU.SEGMENT4 + LU.SEGMENT5         AS VIRT_ITEM         -- 가상코드
               ,LU.ATTRIBUTE2                     AS BLOCK_STAGE       -- 금지호기 STAGE
               ,NULLIF(LTRIM(RTRIM(LU.ATTRIBUTE3)), '') AS BLOCK_LINE1 -- 금지호기 LINE(1)
               ,NULLIF(LTRIM(RTRIM(LU.ATTRIBUTE4)), '') AS BLOCK_LINE2 -- 금지호기 LINE(2)
        INTO    #SM_TARGET
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SITE_MOVE'
        AND     LU.VALID_YN    = 'Y'
        AND     LU.SEGMENT1    = @V_GROUP_ID
        AND     ISNULL(LU.SEGMENT5, '-') <> '-'   -- SEG5='-' 는 SUFFIX 없음(수요 증감만, copy 미대상)
        AND     EXISTS (SELECT  1
                        FROM    SCP_OPT_ENG_DEMAND_SN D WITH(NOLOCK)
                        WHERE   D.PLAN_ID    = @V_PLAN_ID
                        AND     D.ATTRIBUTE1 = LU.SEGMENT2
                        AND     D.ATTRIBUTE2 = LU.SEGMENT4 + LU.SEGMENT5
                        AND     D.ATTRIBUTE8 = 'SITE_MOVE')
        ;
        PRINT ('   Target rows: ' + CONVERT(NVARCHAR, @@ROWCOUNT));

        IF EXISTS (SELECT 1 FROM #SM_TARGET)
        BEGIN

            ------------------------------------------------------------------------
            -- 2. 가상코드화 품목 목록 (#SM_VM_ITEM_LIST)
            --    LEVEL -1 : 수요 버퍼 (SEG2, SEG4) - ITEM_SITE DEMAND copy 용
            --    LEVEL  0 : 생산 완제품 (SEG3, SEG4)
            --    LEVEL 1~ : BOM(A1=SITE, A2=PARENT, A14=CHILD) 하위 전개 (최하위까지)
            --    * BOM 은 동일 사이트 내 버퍼 연결이므로 전개는 사이트 내로 닫힘 (소형/전극 전제)
            --    * 재귀 CTE 대신 WHILE 사용: 전극 ELEC_POST->COATING 처럼 동일 품목 STAGE 간
            --      연결이 존재하므로 NOT EXISTS 중복 차단이 없으면 무한루프 발생
            ------------------------------------------------------------------------
            PRINT ('3. Build Virtual Item List: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            CREATE TABLE #SM_VM_ITEM_LIST (
                 SITE_ID     NVARCHAR(150) NOT NULL
                ,ORIG_ITEM   NVARCHAR(150) NOT NULL
                ,VIRT_ITEM   NVARCHAR(200) NOT NULL
                ,ITEM_SUFFIX NVARCHAR(150) NOT NULL
                ,LEVEL_NO    INT           NOT NULL
                ,PRIMARY KEY (SITE_ID, ORIG_ITEM, VIRT_ITEM)
            );

            INSERT INTO #SM_VM_ITEM_LIST (SITE_ID, ORIG_ITEM, VIRT_ITEM, ITEM_SUFFIX, LEVEL_NO)
            SELECT DISTINCT TO_SITE_DEMAND, ORIG_ITEM, VIRT_ITEM, ITEM_SUFFIX, -1 FROM #SM_TARGET
            UNION
            SELECT DISTINCT TO_SITE_SUPPLY, ORIG_ITEM, VIRT_ITEM, ITEM_SUFFIX, 0  FROM #SM_TARGET
            ;

            SET @V_LVL  = 0;
            SET @V_ROWS = 1;
            WHILE @V_ROWS > 0 AND @V_LVL < 20   -- 안전장치: 최대 20 레벨
            BEGIN
                INSERT INTO #SM_VM_ITEM_LIST (SITE_ID, ORIG_ITEM, VIRT_ITEM, ITEM_SUFFIX, LEVEL_NO)
                SELECT  DISTINCT
                        BOM.ATTRIBUTE1                    -- SITE
                       ,BOM.ATTRIBUTE14                   -- CHILD ITEM
                       ,BOM.ATTRIBUTE14 + L.ITEM_SUFFIX
                       ,L.ITEM_SUFFIX
                       ,@V_LVL + 1
                FROM    #SM_VM_ITEM_LIST L
                INNER JOIN SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                    ON  BOM.PLAN_ID    = @V_PLAN_ID
                    AND BOM.ATTRIBUTE1 = L.SITE_ID
                    AND BOM.ATTRIBUTE2 = L.ORIG_ITEM
                WHERE   L.LEVEL_NO = @V_LVL
                AND     ISNULL(BOM.ATTRIBUTE14, '') <> ''
                AND     NOT EXISTS (SELECT  1
                                    FROM    #SM_VM_ITEM_LIST X
                                    WHERE   X.SITE_ID   = BOM.ATTRIBUTE1
                                    AND     X.ORIG_ITEM = BOM.ATTRIBUTE14
                                    AND     X.VIRT_ITEM = BOM.ATTRIBUTE14 + L.ITEM_SUFFIX)
                ;
                SET @V_ROWS = @@ROWCOUNT;
                SET @V_LVL  = @V_LVL + 1;
            END

            SET @V_ROWS = (SELECT COUNT(*) FROM #SM_VM_ITEM_LIST);
            PRINT ('   Item list rows: ' + CONVERT(NVARCHAR, @V_ROWS));

            ------------------------------------------------------------------------
            -- 3.1 ITEM_SITE copy
            --     목록의 (SITE, ITEM) 에 해당하는 모든 행 copy (DEMAND/PRODUCTION 등 CLASS 무관)
            ------------------------------------------------------------------------
            PRINT ('4.1. Copy ITEM_SITE: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN
                (PLAN_ID, BUFFER_ID, SITE_ID, ITEM_ID, GRADE, SITE_TYPE, ITEM_CLASS_ID, INCH, FAB, STAGE
                ,IS_INFINITE, IS_PURCHASED, PURCHASE_PERIOD, IS_NO_CARRY, STORAGE_ID, STORAGE_PER
                ,SETUP_ID, SETUP_GROUP_ID, ITEM_GROUP_ID
                ,USER_ATTB1, USER_ATTB2, USER_ATTB3, USER_ATTB4, USER_ATTB5, USER_ATTB6, USER_ATTB7, USER_ATTB8, USER_ATTB9
                ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME)
            SELECT  S.PLAN_ID
                   ,REPLACE(S.BUFFER_ID, '::' + L.ORIG_ITEM + '::', '::' + L.VIRT_ITEM + '::')
                   ,S.SITE_ID
                   ,L.VIRT_ITEM
                   ,S.GRADE, S.SITE_TYPE, S.ITEM_CLASS_ID, S.INCH, S.FAB, S.STAGE
                   ,S.IS_INFINITE, S.IS_PURCHASED, S.PURCHASE_PERIOD, S.IS_NO_CARRY, S.STORAGE_ID, S.STORAGE_PER
                   ,S.SETUP_ID, S.SETUP_GROUP_ID, S.ITEM_GROUP_ID
                   ,S.USER_ATTB1, S.USER_ATTB2, S.USER_ATTB3, S.USER_ATTB4, S.USER_ATTB5, S.USER_ATTB6, S.USER_ATTB7, S.USER_ATTB8, S.USER_ATTB9
                   ,S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3, S.ATTRIBUTE4, S.ATTRIBUTE5, S.ATTRIBUTE6, S.ATTRIBUTE7, S.ATTRIBUTE8
                   ,S.ATTRIBUTE9, S.ATTRIBUTE10, S.ATTRIBUTE11, S.ATTRIBUTE12, S.ATTRIBUTE13, S.ATTRIBUTE14, S.ATTRIBUTE15
                   ,'SITE_MOVE', GETDATE(), 'SITE_MOVE', GETDATE()
            FROM    SCP_OPT_ENG_ITEM_SITE_SN S WITH(NOLOCK)
            INNER JOIN #SM_VM_ITEM_LIST L
                ON  S.SITE_ID = L.SITE_ID
                AND S.ITEM_ID = L.ORIG_ITEM
            WHERE   S.PLAN_ID = @V_PLAN_ID
            AND     NOT EXISTS (SELECT 1 FROM SCP_OPT_ENG_ITEM_SITE_SN X WITH(NOLOCK)
                                WHERE  X.PLAN_ID   = @V_PLAN_ID
                                AND    X.BUFFER_ID = REPLACE(S.BUFFER_ID, '::' + L.ORIG_ITEM + '::', '::' + L.VIRT_ITEM + '::'))
            ;
            PRINT ('   Copied rows: ' + CONVERT(NVARCHAR, @@ROWCOUNT));

            ------------------------------------------------------------------------
            -- 3.2 BOM copy
            --     BOM_ID 는 PARENT 품목, MATERIAL_BUFFER_ID 는 CHILD 품목 기준으로 각각 치환
            --     [리마인드] BOM_ELEC 은 copy 제외 (확정) - 필요성 확인 시 이 단계 뒤에 추가
            ------------------------------------------------------------------------
            PRINT ('4.2. Copy BOM: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            INSERT INTO SCP_OPT_ENG_BOM_SN
                (PLAN_ID, BOM_ID, OP_SEQ, MATERIAL_CLASS_ID, MATERIAL_BUFFER_ID, PRIORITY, CONSUME_QUANTITY
                ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME)
            SELECT  B.PLAN_ID
                   ,REPLACE(B.BOM_ID, '::' + P.ORIG_ITEM + '::', '::' + P.VIRT_ITEM + '::')
                   ,B.OP_SEQ
                   ,B.MATERIAL_CLASS_ID
                   ,REPLACE(B.MATERIAL_BUFFER_ID, '::' + C.ORIG_ITEM + '::', '::' + C.VIRT_ITEM + '::')
                   ,B.PRIORITY
                   ,B.CONSUME_QUANTITY
                   ,B.ATTRIBUTE1
                   ,P.VIRT_ITEM                     -- A2 = PARENT ITEM
                   ,B.ATTRIBUTE3
                   ,B.ATTRIBUTE4, B.ATTRIBUTE5, B.ATTRIBUTE6, B.ATTRIBUTE7, B.ATTRIBUTE8
                   ,B.ATTRIBUTE9, B.ATTRIBUTE10, B.ATTRIBUTE11, B.ATTRIBUTE12, B.ATTRIBUTE13
                   ,C.VIRT_ITEM                     -- A14 = CHILD ITEM
                   ,B.ATTRIBUTE15
                   ,'SITE_MOVE', GETDATE(), 'SITE_MOVE', GETDATE()
            FROM    SCP_OPT_ENG_BOM_SN B WITH(NOLOCK)
            INNER JOIN #SM_VM_ITEM_LIST P           -- PARENT
                ON  B.ATTRIBUTE1 = P.SITE_ID
                AND B.ATTRIBUTE2 = P.ORIG_ITEM
            INNER JOIN #SM_VM_ITEM_LIST C           -- CHILD (PARENT 와 동일 SUFFIX)
                ON  B.ATTRIBUTE1  = C.SITE_ID
                AND B.ATTRIBUTE14 = C.ORIG_ITEM
                AND C.ITEM_SUFFIX = P.ITEM_SUFFIX
            WHERE   B.PLAN_ID = @V_PLAN_ID
            AND     NOT EXISTS (SELECT 1 FROM SCP_OPT_ENG_BOM_SN X WITH(NOLOCK)
                                WHERE  X.PLAN_ID            = @V_PLAN_ID
                                AND    X.BOM_ID             = REPLACE(B.BOM_ID, '::' + P.ORIG_ITEM + '::', '::' + P.VIRT_ITEM + '::')
                                AND    X.MATERIAL_BUFFER_ID = REPLACE(B.MATERIAL_BUFFER_ID, '::' + C.ORIG_ITEM + '::', '::' + C.VIRT_ITEM + '::'))
            ;
            PRINT ('   Copied rows: ' + CONVERT(NVARCHAR, @@ROWCOUNT));

            ------------------------------------------------------------------------
            -- 3.3 ROUTING_RESOURCE copy
            --     (EE RR: A1=SITE, A2=ITEM, A3=STAGE, A14=MONTH, A15=LINE)
            ------------------------------------------------------------------------
            PRINT ('4.3. Copy ROUTING_RESOURCE: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            INSERT INTO SCP_OPT_ENG_ROUTING_RESOURCE_SN
                (PLAN_ID, ROUTING_ID, OP_SEQ, RESOURCE_CLASS_ID, RESOURCE_ID, LOAD_PER, PRIORITY
                ,START_DATE, END_DATE, SETUP_GROUP_ID, SETUP_ID, GROUP_SETUP_TIME, SETUP_TIME
                ,CONTAINER_CATEGORY, CONTAINER_SIZE
                ,USER_ATTB1, USER_ATTB2, USER_ATTB3, USER_ATTB4, USER_ATTB5, USER_ATTB6, USER_ATTB7, USER_ATTB8, USER_ATTB9
                ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME)
            SELECT  R.PLAN_ID
                   ,REPLACE(R.ROUTING_ID, '::' + L.ORIG_ITEM + '::', '::' + L.VIRT_ITEM + '::')
                   ,R.OP_SEQ, R.RESOURCE_CLASS_ID, R.RESOURCE_ID, R.LOAD_PER, R.PRIORITY
                   ,R.START_DATE, R.END_DATE, R.SETUP_GROUP_ID, R.SETUP_ID, R.GROUP_SETUP_TIME, R.SETUP_TIME
                   ,R.CONTAINER_CATEGORY, R.CONTAINER_SIZE
                   ,R.USER_ATTB1, R.USER_ATTB2, R.USER_ATTB3, R.USER_ATTB4, R.USER_ATTB5, R.USER_ATTB6, R.USER_ATTB7, R.USER_ATTB8, R.USER_ATTB9
                   ,R.ATTRIBUTE1
                   ,L.VIRT_ITEM                     -- A2 = ITEM
                   ,R.ATTRIBUTE3, R.ATTRIBUTE4, R.ATTRIBUTE5, R.ATTRIBUTE6, R.ATTRIBUTE7, R.ATTRIBUTE8
                   ,R.ATTRIBUTE9, R.ATTRIBUTE10, R.ATTRIBUTE11, R.ATTRIBUTE12, R.ATTRIBUTE13, R.ATTRIBUTE14, R.ATTRIBUTE15
                   ,'SITE_MOVE', GETDATE(), 'SITE_MOVE', GETDATE()
            FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN R WITH(NOLOCK)
            INNER JOIN #SM_VM_ITEM_LIST L
                ON  R.ATTRIBUTE1 = L.SITE_ID
                AND R.ATTRIBUTE2 = L.ORIG_ITEM
            WHERE   R.PLAN_ID = @V_PLAN_ID
            ;
            PRINT ('   Copied rows: ' + CONVERT(NVARCHAR, @@ROWCOUNT));

            ------------------------------------------------------------------------
            -- 3.4 ROUTING copy
            --     (EE ROUTING: A1=SITE, A2=ITEM, A3=STAGE, A14=LINE, A15=MONTH)
            ------------------------------------------------------------------------
            PRINT ('4.4. Copy ROUTING: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            INSERT INTO SCP_OPT_ENG_ROUTING_SN
                (PLAN_ID, ROUTING_ID, OP_SEQ, LEAD_TIME, YIELD
                ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME)
            SELECT  R.PLAN_ID
                   ,REPLACE(R.ROUTING_ID, '::' + L.ORIG_ITEM + '::', '::' + L.VIRT_ITEM + '::')
                   ,R.OP_SEQ, R.LEAD_TIME, R.YIELD
                   ,R.ATTRIBUTE1
                   ,L.VIRT_ITEM                     -- A2 = ITEM
                   ,R.ATTRIBUTE3, R.ATTRIBUTE4, R.ATTRIBUTE5, R.ATTRIBUTE6, R.ATTRIBUTE7, R.ATTRIBUTE8
                   ,R.ATTRIBUTE9, R.ATTRIBUTE10, R.ATTRIBUTE11, R.ATTRIBUTE12, R.ATTRIBUTE13, R.ATTRIBUTE14, R.ATTRIBUTE15
                   ,'SITE_MOVE', GETDATE(), 'SITE_MOVE', GETDATE()
            FROM    SCP_OPT_ENG_ROUTING_SN R WITH(NOLOCK)
            INNER JOIN #SM_VM_ITEM_LIST L
                ON  R.ATTRIBUTE1 = L.SITE_ID
                AND R.ATTRIBUTE2 = L.ORIG_ITEM
            WHERE   R.PLAN_ID = @V_PLAN_ID
            AND     NOT EXISTS (SELECT 1 FROM SCP_OPT_ENG_ROUTING_SN X WITH(NOLOCK)
                                WHERE  X.PLAN_ID    = @V_PLAN_ID
                                AND    X.ROUTING_ID = REPLACE(R.ROUTING_ID, '::' + L.ORIG_ITEM + '::', '::' + L.VIRT_ITEM + '::'))
            ;
            PRINT ('   Copied rows: ' + CONVERT(NVARCHAR, @@ROWCOUNT));

            ------------------------------------------------------------------------
            -- 3.5 ITEM_BOM_ROUTING copy
            --     IBR 에는 ATTRIBUTE 가 없으므로 원본 ROUTING(ATTRIBUTE 매칭)과 ROUTING_ID 로 연결
            ------------------------------------------------------------------------
            PRINT ('4.5. Copy ITEM_BOM_ROUTING: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            INSERT INTO SCP_OPT_ENG_ITEM_BOM_ROUTING_SN
                (PLAN_ID, ROUTING_BOM_MAPPING_ID, BUFFER_ID, ROUTING_ID, BOM_ID
                ,EFF_START_DATE, EFF_END_DATE, FROZEN_FENCE, PRIORITY
                ,IN_CONTAINER_CATEGORY, IN_CONTAINER_SIZE, OUT_CONTAINER_CATEGORY, OUT_CONTAINER_SIZE
                ,USER_ATTB1, USER_ATTB2, USER_ATTB3, USER_ATTB4, USER_ATTB5, USER_ATTB6, USER_ATTB7, USER_ATTB8, USER_ATTB9
                ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME)
            SELECT  I.PLAN_ID
                   ,REPLACE(I.ROUTING_BOM_MAPPING_ID, '::' + L.ORIG_ITEM + '::', '::' + L.VIRT_ITEM + '::')
                   ,REPLACE(I.BUFFER_ID,              '::' + L.ORIG_ITEM + '::', '::' + L.VIRT_ITEM + '::')
                   ,REPLACE(I.ROUTING_ID,             '::' + L.ORIG_ITEM + '::', '::' + L.VIRT_ITEM + '::')
                   ,REPLACE(I.BOM_ID,                 '::' + L.ORIG_ITEM + '::', '::' + L.VIRT_ITEM + '::')
                   ,I.EFF_START_DATE, I.EFF_END_DATE, I.FROZEN_FENCE, I.PRIORITY
                   ,I.IN_CONTAINER_CATEGORY, I.IN_CONTAINER_SIZE, I.OUT_CONTAINER_CATEGORY, I.OUT_CONTAINER_SIZE
                   ,I.USER_ATTB1, I.USER_ATTB2, I.USER_ATTB3, I.USER_ATTB4, I.USER_ATTB5, I.USER_ATTB6, I.USER_ATTB7, I.USER_ATTB8, I.USER_ATTB9
                   ,I.ATTRIBUTE1, I.ATTRIBUTE2, I.ATTRIBUTE3, I.ATTRIBUTE4, I.ATTRIBUTE5, I.ATTRIBUTE6, I.ATTRIBUTE7, I.ATTRIBUTE8
                   ,I.ATTRIBUTE9, I.ATTRIBUTE10, I.ATTRIBUTE11, I.ATTRIBUTE12, I.ATTRIBUTE13, I.ATTRIBUTE14, I.ATTRIBUTE15
                   ,'SITE_MOVE', GETDATE(), 'SITE_MOVE', GETDATE()
            FROM    SCP_OPT_ENG_ITEM_BOM_ROUTING_SN I WITH(NOLOCK)
            INNER JOIN SCP_OPT_ENG_ROUTING_SN RO WITH(NOLOCK)
                ON  RO.PLAN_ID    = @V_PLAN_ID
                AND RO.ROUTING_ID = I.ROUTING_ID
                AND ISNULL(RO.INSERT_ID, '') <> 'SITE_MOVE'               -- 원본 ROUTING 만
            INNER JOIN #SM_VM_ITEM_LIST L
                ON  RO.ATTRIBUTE1 = L.SITE_ID
                AND RO.ATTRIBUTE2 = L.ORIG_ITEM
            WHERE   I.PLAN_ID = @V_PLAN_ID
            AND     NOT EXISTS (SELECT 1 FROM SCP_OPT_ENG_ITEM_BOM_ROUTING_SN X WITH(NOLOCK)
                                WHERE  X.PLAN_ID                = @V_PLAN_ID
                                AND    X.ROUTING_BOM_MAPPING_ID = REPLACE(I.ROUTING_BOM_MAPPING_ID, '::' + L.ORIG_ITEM + '::', '::' + L.VIRT_ITEM + '::'))
            ;
            PRINT ('   Copied rows: ' + CONVERT(NVARCHAR, @@ROWCOUNT));

            ------------------------------------------------------------------------
            -- 3.6 BOD copy
            --     SEG3(생산) -> SEG2(수요) 로 가는 원본 모델의 BOD 만 copy
            --     (BOD: A1=FROM_SITE, A2=ITEM, A3=FROM_STAGE, A4=TO_SITE, A5=TO_STAGE)
            --     * 소형/전극은 하위 BOD 개념이 없어 완제품 BOD 만 대상 (설계 문서 참조)
            ------------------------------------------------------------------------
            PRINT ('4.6. Copy BOD: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            INSERT INTO SCP_OPT_ENG_BOD_SN
                (PLAN_ID, BOD_ID, FROM_BUFFER_ID, TO_BUFFER_ID, TRANSPORT_MODE, PRIORITY, TRANSIT_COST
                ,EFF_START_DATE, EFF_END_DATE, DEFAULT_LEAD_TIME
                ,SUNDAY_LEAD_TIME, MONDAY_LEAD_TIME, TUESDAY_LEAD_TIME, WEDNESDAY_LEAD_TIME
                ,THURSDAY_LEAD_TIME, FRIDAY_LEAD_TIME, SATURDAY_LEAD_TIME
                ,RESOURCE_ID, LOAD_PER, CONTAINER_CATEGORY, CONTAINER_SIZE
                ,USER_ATTB1, USER_ATTB2, USER_ATTB3, USER_ATTB4, USER_ATTB5, USER_ATTB6, USER_ATTB7, USER_ATTB8
                ,TYPE
                ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME)
            SELECT  B.PLAN_ID
                   ,REPLACE(B.BOD_ID,         '::' + T.ORIG_ITEM + '::', '::' + T.VIRT_ITEM + '::')
                   ,REPLACE(B.FROM_BUFFER_ID, '::' + T.ORIG_ITEM + '::', '::' + T.VIRT_ITEM + '::')
                   ,REPLACE(B.TO_BUFFER_ID,   '::' + T.ORIG_ITEM + '::', '::' + T.VIRT_ITEM + '::')
                   ,B.TRANSPORT_MODE, B.PRIORITY, B.TRANSIT_COST
                   ,B.EFF_START_DATE, B.EFF_END_DATE, B.DEFAULT_LEAD_TIME
                   ,B.SUNDAY_LEAD_TIME, B.MONDAY_LEAD_TIME, B.TUESDAY_LEAD_TIME, B.WEDNESDAY_LEAD_TIME
                   ,B.THURSDAY_LEAD_TIME, B.FRIDAY_LEAD_TIME, B.SATURDAY_LEAD_TIME
                   ,B.RESOURCE_ID, B.LOAD_PER, B.CONTAINER_CATEGORY, B.CONTAINER_SIZE
                   ,B.USER_ATTB1, B.USER_ATTB2, B.USER_ATTB3, B.USER_ATTB4, B.USER_ATTB5, B.USER_ATTB6, B.USER_ATTB7, B.USER_ATTB8
                   ,B.TYPE
                   ,B.ATTRIBUTE1
                   ,T.VIRT_ITEM                    -- A2 = ITEM
                   ,B.ATTRIBUTE3, B.ATTRIBUTE4, B.ATTRIBUTE5, B.ATTRIBUTE6, B.ATTRIBUTE7, B.ATTRIBUTE8
                   ,B.ATTRIBUTE9, B.ATTRIBUTE10, B.ATTRIBUTE11, B.ATTRIBUTE12, B.ATTRIBUTE13, B.ATTRIBUTE14, B.ATTRIBUTE15
                   ,'SITE_MOVE', GETDATE(), 'SITE_MOVE', GETDATE()
            FROM    SCP_OPT_ENG_BOD_SN B WITH(NOLOCK)
            INNER JOIN (SELECT DISTINCT TO_SITE_DEMAND, TO_SITE_SUPPLY, ORIG_ITEM, VIRT_ITEM FROM #SM_TARGET) T
                ON  B.ATTRIBUTE1 = T.TO_SITE_SUPPLY   -- FROM_SITE = 생산 사이트(SEG3)
                AND B.ATTRIBUTE2 = T.ORIG_ITEM
                AND B.ATTRIBUTE4 = T.TO_SITE_DEMAND   -- TO_SITE   = 수요 사이트(SEG2)
            WHERE   B.PLAN_ID = @V_PLAN_ID
            AND     NOT EXISTS (SELECT 1 FROM SCP_OPT_ENG_BOD_SN X WITH(NOLOCK)
                                WHERE  X.PLAN_ID = @V_PLAN_ID
                                AND    X.BOD_ID  = REPLACE(B.BOD_ID, '::' + T.ORIG_ITEM + '::', '::' + T.VIRT_ITEM + '::'))
            ;
            PRINT ('   Copied rows: ' + CONVERT(NVARCHAR, @@ROWCOUNT));

            ------------------------------------------------------------------------
            -- 4. 금지호기 삭제
            --    가상코드 기준 SITE(SEG3) + ITEM(가상코드) + STAGE(ATTB2) + LINE(ATTB3/4) 매칭.
            --    ROUTING 에서 삭제 대상 ROUTING_ID 확보 후 ROUTING/RR/IBR 연쇄 삭제.
            ------------------------------------------------------------------------
            PRINT ('5. Delete Blocked Line: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113));

            SELECT  DISTINCT RO.ROUTING_ID
            INTO    #SM_BLOCKED_ROUTING
            FROM    SCP_OPT_ENG_ROUTING_SN RO WITH(NOLOCK)
            INNER JOIN #SM_TARGET T
                ON  RO.ATTRIBUTE1  = T.TO_SITE_SUPPLY
                AND RO.ATTRIBUTE2  = T.VIRT_ITEM
                AND RO.ATTRIBUTE3  = T.BLOCK_STAGE
                AND RO.ATTRIBUTE14 IN (T.BLOCK_LINE1, T.BLOCK_LINE2)   -- NULL 은 매칭되지 않음
            WHERE   RO.PLAN_ID = @V_PLAN_ID
            ;
            PRINT ('   Blocked routing rows: ' + CONVERT(NVARCHAR, @@ROWCOUNT));

            DELETE  RO
            FROM    SCP_OPT_ENG_ROUTING_SN RO
            INNER JOIN #SM_BLOCKED_ROUTING BK ON RO.ROUTING_ID = BK.ROUTING_ID
            WHERE   RO.PLAN_ID = @V_PLAN_ID
            ;
            PRINT ('   Deleted ROUTING rows: ' + CONVERT(NVARCHAR, @@ROWCOUNT));

            DELETE  RR
            FROM    SCP_OPT_ENG_ROUTING_RESOURCE_SN RR
            INNER JOIN #SM_BLOCKED_ROUTING BK ON RR.ROUTING_ID = BK.ROUTING_ID
            WHERE   RR.PLAN_ID = @V_PLAN_ID
            ;
            PRINT ('   Deleted ROUTING_RESOURCE rows: ' + CONVERT(NVARCHAR, @@ROWCOUNT));

            DELETE  IB
            FROM    SCP_OPT_ENG_ITEM_BOM_ROUTING_SN IB
            INNER JOIN #SM_BLOCKED_ROUTING BK ON IB.ROUTING_ID = BK.ROUTING_ID
            WHERE   IB.PLAN_ID = @V_PLAN_ID
            ;
            PRINT ('   Deleted ITEM_BOM_ROUTING rows: ' + CONVERT(NVARCHAR, @@ROWCOUNT));

        END -- IF EXISTS #SM_TARGET

        ------------------------------------------------------------------------
        -- 2026.08.31 Minyong Lee : [E20260818-000193] [최적화 알고리즘] 사이트간 물량 이관 반영
        --   룩업 SCP_OPT_ENG_SITE_MOVE_INCOMING
        ------------------------------------------------------------------------
        IF OBJECT_ID('TEMPDB..#SM_IC_TARGET') IS NOT NULL DROP TABLE #SM_IC_TARGET;

        SELECT  IC.VIRT_ITEM
               ,MAP.ORIG_ITEM                                                  -- NULL = 역매핑 실패(차감 스킵)
               ,IC.STOCK_QTY
               ,DMD.SITE_ID                                                    -- NULL = TARGETBIZ 수요 부재(생성/차감 모두 스킵)
               ,DMD.STAGE
               ,DMD.INCOTERMS
               ,DMD.PROJECT_CODE
        INTO    #SM_IC_TARGET
        FROM   (SELECT  LU.SEGMENT3 AS VIRT_ITEM
                       ,SUM(CONVERT(NUMERIC(30,10), LU.ATTRIBUTE1)) AS STOCK_QTY
                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_SITE_MOVE_INCOMING'
                AND     LU.VALID_YN    = 'Y'
                AND     LU.SEGMENT1    = @V_DIVISION_ID
                AND     LU.SEGMENT2    = @V_GROUP_ID
                AND     ISNULL(TRY_CAST(LU.ATTRIBUTE1 AS NUMERIC(30,10)), 0) > 0
                GROUP BY LU.SEGMENT3
               ) IC
        LEFT JOIN (SELECT DISTINCT SEGMENT4 + SEGMENT5 AS VIRT_ITEM, SEGMENT4 AS ORIG_ITEM
                   FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                   WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SITE_MOVE' AND VALID_YN = 'Y'
                   AND    ISNULL(SEGMENT5, '-') <> '-') MAP
            ON  MAP.VIRT_ITEM = IC.VIRT_ITEM
        OUTER APPLY (SELECT TOP 1                                              -- 생성 기준: 가상코드 TARGETBIZ 수요
                            D.ATTRIBUTE1              AS SITE_ID
                           ,D.ATTRIBUTE3              AS STAGE
                           ,ISNULL(D.ATTRIBUTE4, '-') AS INCOTERMS             -- NULL 방어 (STOCK_ID 조합용)
                           ,ISNULL(D.ATTRIBUTE5, '')  AS PROJECT_CODE
                     FROM   SCP_OPT_ENG_DEMAND_ORIGIN_SN D WITH(NOLOCK)
                     WHERE  D.PLAN_ID    = @V_PLAN_ID
                     AND    D.ATTRIBUTE2 = IC.VIRT_ITEM
                     AND    D.ATTRIBUTE3 = 'TARGETBIZ'
                     ORDER BY D.DUE_DATE, D.ATTRIBUTE1, D.ATTRIBUTE4, D.ATTRIBUTE5  -- 결정적 선택
                    ) DMD
        ;

        ------------------------------------------------------------------------
        -- 원본 모델 WH 재고 차감 (사이트/STAGE 무관 전체 대상,
        -- STAGE 우선순위 -> EFFECTIVE_DATE 순 누적, 부족 시 있는 만큼만, 0 행 삭제)
        ------------------------------------------------------------------------
        ;WITH DED AS (
            SELECT  ORIG_ITEM, SUM(STOCK_QTY) AS DED_QTY
            FROM    #SM_IC_TARGET
            WHERE   ORIG_ITEM IS NOT NULL
            AND     SITE_ID   IS NOT NULL                                      -- 생성 스킵(수요 부재) 시 차감도 스킵
            GROUP BY ORIG_ITEM
        ),
        ALLOC AS (
            SELECT  ST.QUANTITY
                   ,ST.UPDATE_ID
                   ,ST.UPDATE_TIME
                   ,DED.DED_QTY
                   ,SUM(ST.QUANTITY) OVER (PARTITION BY DED.ORIG_ITEM
                                           ORDER BY CASE ST.ATTRIBUTE3                    -- STAGE 선차감 우선순위
                                                         WHEN 'TARGETBIZ' THEN 1
                                                         WHEN 'ELEC_POST' THEN 2
                                                         WHEN 'COATING'   THEN 3
                                                         ELSE 4 END                       -- 미정의 STAGE 는 후순위
                                                   ,ST.EFFECTIVE_DATE, ST.STOCK_ID
                                           ROWS UNBOUNDED PRECEDING) AS CUM_QTY
            FROM    SCP_OPT_ENG_INCOMING_STOCK_SN ST
            INNER JOIN DED
                ON  ST.ATTRIBUTE2 = DED.ORIG_ITEM
            LEFT JOIN SCP_OPT_ENG_ITEM_SITE_SN SIM WITH(NOLOCK)
        		ON  ST.PLAN_ID   = SIM.PLAN_ID
        		AND ST.BUFFER_ID = SIM.BUFFER_ID
            WHERE   ST.PLAN_ID = @V_PLAN_ID
            AND     ST.TYPE    = 'WH'
            AND     SIM.ITEM_CLASS_ID <> 'STOCK'
        )
        UPDATE  ALLOC
        SET     QUANTITY    = IIF(CUM_QTY <= DED_QTY, 0, CUM_QTY - DED_QTY)
               ,UPDATE_ID   = 'SITE_MOVE'
               ,UPDATE_TIME = CURRENT_TIMESTAMP
        WHERE   CUM_QTY - QUANTITY < DED_QTY   -- 차감 범위에 걸린 행만 UPDATE
        ;

        -- 차감으로 0 이 된 행 삭제
        DELETE FROM SCP_OPT_ENG_INCOMING_STOCK_SN
        WHERE   PLAN_ID   = @V_PLAN_ID
        AND     TYPE      = 'WH'
        AND     UPDATE_ID = 'SITE_MOVE'
        AND     QUANTITY  = 0
        ;

        ------------------------------------------------------------------------
        -- 가상코드 WH 재고 생성 (계획시작일, 룩업 입력 수량 그대로, TARGETBIZ 수요 기준정보 사용)
        -- STOCK_ID/BUFFER_ID 는 기존 WH 행과 동일 규칙 (INCOTERMS '-' / PROJECT '' 는 표기 생략)
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN
               (PLAN_ID, STOCK_ID, BUFFER_ID, EFFECTIVE_DATE, TYPE, QUANTITY
               ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE15, INSERT_ID)
        SELECT  @V_PLAN_ID                                                     AS PLAN_ID
               ,'WH::'+T.SITE_ID+'::'+T.VIRT_ITEM+'::'+T.STAGE
                    +IIF(T.INCOTERMS='-','','@'+T.INCOTERMS)+IIF(T.PROJECT_CODE='','','@'+T.PROJECT_CODE)
                    +'::'+@V_PLAN_START_YYYYMMDD                               AS STOCK_ID
               ,T.SITE_ID+'::'+T.VIRT_ITEM+'::'+T.STAGE
                    +IIF(T.INCOTERMS='-','','@'+T.INCOTERMS)+IIF(T.PROJECT_CODE='','','@'+T.PROJECT_CODE)
                                                                               AS BUFFER_ID
               ,@V_PLAN_START_YYYYMMDD                                         AS EFFECTIVE_DATE
               ,'WH'                                                           AS TYPE
               ,T.STOCK_QTY                                                    AS QUANTITY
               ,T.SITE_ID                                                      AS ATTRIBUTE1
               ,T.VIRT_ITEM                                                    AS ATTRIBUTE2
               ,T.STAGE                                                        AS ATTRIBUTE3
               ,T.INCOTERMS                                                    AS ATTRIBUTE4
               ,T.PROJECT_CODE                                                 AS ATTRIBUTE5
               ,'SITE_MOVE'                                                    AS ATTRIBUTE15
               ,'SITE_MOVE'                                                    AS INSERT_ID
        FROM    #SM_IC_TARGET T
        WHERE   T.SITE_ID IS NOT NULL                                          -- TARGETBIZ 수요 부재 시 생성 스킵
        AND     NOT EXISTS (SELECT 1 FROM SCP_OPT_ENG_INCOMING_STOCK_SN X WITH(NOLOCK)   -- PK(STOCK_ID) 충돌 가드
                            WHERE X.PLAN_ID  = @V_PLAN_ID
                            AND   X.STOCK_ID = 'WH::'+T.SITE_ID+'::'+T.VIRT_ITEM+'::'+T.STAGE
                                                  +IIF(T.INCOTERMS='-','','@'+T.INCOTERMS)+IIF(T.PROJECT_CODE='','','@'+T.PROJECT_CODE)
                                                  +'::'+@V_PLAN_START_YYYYMMDD)
        ;

        IF OBJECT_ID('TEMPDB..#SM_IC_TARGET') IS NOT NULL DROP TABLE #SM_IC_TARGET;

        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'END',NULL,NULL,NULL,@V_PLAN_ID

    END TRY
    ------------------------------------------------------------------------
    BEGIN CATCH
    ------------------------------------------------------------------------
        SET @V_MESSAGE_TEXT = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'ERROR',NULL,@V_MESSAGE_TEXT,NULL,@V_PLAN_ID
        ------------------------------------------------------------------------
        SELECT @V_DETAIL_DATE = GETDATE()
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,@V_DETAIL_DATE,NULL,@V_MESSAGE_TEXT,'ERROR'
        ------------------------------------------------------------------------
        RAISERROR(@V_MESSAGE_TEXT, 16, 1)
    END CATCH
END
