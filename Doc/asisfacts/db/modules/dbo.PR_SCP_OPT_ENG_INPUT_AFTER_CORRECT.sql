


CREATE   PROCEDURE [dbo].[PR_SCP_OPT_ENG_INPUT_AFTER_CORRECT]
     @P_PLAN_ID     NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS 
BEGIN
    --2025.02.05 Y.S.H Initial Release
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_INPUT_AFTER_CORRECT';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
    ------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_PLAN_START_YYYYMM NVARCHAR(6);
    DECLARE @V_PLAN_END_YYYYMM   NVARCHAR(6);


    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID

    ------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	--BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------  
	BEGIN TRY
        ------------------------------------------------------------------------
        -- Get Plan Mater Info
        ------------------------------------------------------------------------
        SELECT @V_PLAN_START_YYYYMM = LEFT(PLAN_START_DATE,6)
              ,@V_PLAN_END_YYYYMM   = LEFT(PLAN_END_DATE,6)
        FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        WHERE  PLAN_ID = @V_PLAN_ID
        ------------------------------------------------------------------------
        -- Data UPDATE
        --2025.05.27 Philsu Park: FROZENCARRYOVERDATE 값이 Fix를 보지 않게 제외.
        ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_RESOURCE_SN
        SET SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERDATE           = A.FROZENCARRYOVERDATE
           ,SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERSETUPGROUPNAME = A.FROZENCARRYOVERSETUPGROUPNAME
           ,SCP_OPT_ENG_RESOURCE_SN.FROZENCARRYOVERSETUPITEMNAME  = A.FROZENCARRYOVERSETUPITEMNAME
        FROM(
            SELECT	 SFP2.PLAN_ID                 AS PLAN_ID
            		,SFP2.RESOURCE_ID	          AS RESOURCE_ID
            		--,SFP2.EFFECTIVE_DATE+':000000' AS FROZENCARRYOVERDATE
                    ,CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE,SFP2.EFFECTIVE_DATE)),112)+':000000' AS FROZENCARRYOVERDATE
            		,SFP2.ATTRIBUTE1              AS SITE_ID
            		,'LINE'				          AS RESOURCE_TYPE
            		,LU.SETUP_GROUP_ID	          AS FROZENCARRYOVERSETUPGROUPNAME
            		,LU.SETUP_ID		          AS FROZENCARRYOVERSETUPITEMNAME
            		,SFP2.ATTRIBUTE3	          AS GROUP_SETUP_CONTROL_CODE
            		,SFP2.ATTRIBUTE3	          AS ITEM_SETUP_CONTROL_CODE
            FROM	(SELECT ROW_NUMBER() OVER ( PARTITION BY PLAN_ID, RESOURCE_ID ORDER BY EFFECTIVE_DATE DESC, ATTRIBUTE2 DESC) AS ROWNUM
            			  ,SFP.* 	
            		 FROM   SCP_OPT_ENG_FROZEN_PLAN_SN SFP WITH(NOLOCK) 
            		 WHERE  PLAN_ID = @V_PLAN_ID 
                     AND    SFP.ATTRIBUTE13 != 'LOOKUP_PROD_FIX' --2025.05.27 Philsu Park: FROZENCARRYOVERDATE 값이 Fix를 보지 않게 제외.
            		) SFP2
            		LEFT OUTER JOIN (
            				SELECT  LU.SEGMENT2    AS DIVISION_ID
            					   ,LU.SEGMENT3    AS SCM_SITE_ID
            					   ,LU.SEGMENT4    AS LINE_ID
            					   ,ITS.ITEM_ID    AS ITEM_ID
            					   ,LU.ATTRIBUTE1  AS SETUP_GROUP_ID
            					   ,IIF(LU.ATTRIBUTE2='',NULL,LU.ATTRIBUTE2) AS SETUP_ID
            					   ,CONVERT(INT,CONVERT(NUMERIC(20,1),LU.ATTRIBUTE3)*86400)  AS GROUP_SETUP_TIME
            					   ,CONVERT(INT,CONVERT(NUMERIC(20,1),LU.ATTRIBUTE4)*86400)  AS SETUP_TIME
            				FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            				LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            				ON      ITS.SITE_ID = LU.SEGMENT3
            				--AND     ITS.STAGE      = 'ASSY'
            				AND     ITS.STAGE      IN ('ASSY', 'MDLE', 'PACK')
            				AND     ITS.SETUP_GROUP_ID = LU.SEGMENT5
            				WHERE   LU.SEGMENT2    = @V_DIVISION_ID
            				AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SETUP'
            				AND     ITS.PLAN_ID    = @V_PLAN_ID
                            AND     LU.VALID_YN    = 'Y'
            			)LU 
            			ON  SFP2.ATTRIBUTE1 = LU.SCM_SITE_ID
            			AND SFP2.ATTRIBUTE2 = LU.ITEM_ID
            			--AND SFP2.ATTRIBUTE3 = 'ASSY'
            			AND SFP2.ATTRIBUTE3 IN ('ASSY', 'MDLE', 'PACK')
            			AND SFP2.ATTRIBUTE14   = LU.LINE_ID
            WHERE 1=1
            AND   SFP2.ROWNUM = 1
            ) A
        WHERE   SCP_OPT_ENG_RESOURCE_SN.PLAN_ID       = @V_PLAN_ID
        AND     SCP_OPT_ENG_RESOURCE_SN.RESOURCE_TYPE = 'LINE'
        AND     SCP_OPT_ENG_RESOURCE_SN.RESOURCE_ID   = A.RESOURCE_ID
        ------------------------------------------------------------------------
        --BOD 중 TO_BUFFER나 FROM_BUFFER가 ITEM_SITE에 없는 데이터는 삭제
        ------------------------------------------------------------------------
        DELETE FROM SCP_OPT_ENG_BOD_SN 
        FROM SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK)
            INNER JOIN (
                        SELECT PLAN_ID
                              ,BOD_ID
                        FROM(
                            SELECT A.PLAN_ID
                                  ,A.BOD_ID
                            FROM SCP_OPT_ENG_BOD_SN A WITH(NOLOCK)
                                LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN B WITH(NOLOCK)
                                ON  A.PLAN_ID = B.PLAN_ID 
                                AND A.TO_BUFFER_ID = B.BUFFER_ID
                            WHERE 1=1
                            AND A.PLAN_ID = @V_PLAN_ID
                            AND B.PLAN_ID IS NULL
                            UNION ALL
                            SELECT A.PLAN_ID
                                  ,A.BOD_ID
                            FROM SCP_OPT_ENG_BOD_SN A WITH(NOLOCK)
                                LEFT OUTER JOIN SCP_OPT_ENG_ITEM_SITE_SN B WITH(NOLOCK)
                                ON  A.PLAN_ID = B.PLAN_ID 
                                AND A.FROM_BUFFER_ID = B.BUFFER_ID
                            WHERE 1=1
                            AND A.PLAN_ID = @V_PLAN_ID
                            AND B.PLAN_ID IS NULL
                            ) A
                        GROUP BY A.PLAN_ID, A.BOD_ID
                    ) DEL
        ON  BOD.PLAN_ID = DEL.PLAN_ID
        AND BOD.BOD_ID  = DEL.BOD_ID
        WHERE BOD.PLAN_ID = @V_PLAN_ID
        ------------------------------------------------------------------------
        -- SCHEDULED_MOVE에 bod가 없으면 삭제
        -- BOD가 없는 SCHEDULED MOVE가 있어도 엔진이 돌아가는지 검증을 위해 주석처리
        ------------------------------------------------------------------------
        DELETE FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN 
		FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN     a   with(nolock)		
		    left join SCP_OPT_ENG_BOD_SN b with(nolock)
		    on  a.plan_id = b.plan_id
		    and a.FROM_BUFFER_ID = b.FROM_BUFFER_ID
		    and a.TO_BUFFER_ID = b.TO_BUFFER_ID
		    and a.TRANSPORT_MODE = b.TRANSPORT_MODE
		WHERE a.PLAN_ID = @V_PLAN_ID
		and  b.BOD_ID IS NULL
        ------------------------------------------------------------------------
        -- LOAD PER UPDATE -> LOAD PER * YIELD
        ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_ROUTING_RESOURCE_SN
        SET SCP_OPT_ENG_ROUTING_RESOURCE_SN.LOAD_PER = SCP_OPT_ENG_ROUTING_RESOURCE_SN.LOAD_PER*SCP_OPT_ENG_ROUTING_SN.YIELD
        FROM SCP_OPT_ENG_ROUTING_RESOURCE_SN
            LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN 
            ON  SCP_OPT_ENG_ROUTING_RESOURCE_SN.PLAN_ID    = SCP_OPT_ENG_ROUTING_SN.PLAN_ID
            AND SCP_OPT_ENG_ROUTING_RESOURCE_SN.ROUTING_ID = SCP_OPT_ENG_ROUTING_SN.ROUTING_ID
        WHERE SCP_OPT_ENG_ROUTING_RESOURCE_SN.PLAN_ID = @V_PLAN_ID
        AND SCP_OPT_ENG_ROUTING_RESOURCE_SN.RESOURCE_CLASS_ID IN ('LINE', 'Dummy_LINE') -- 2026.08.25 : LINE_PERSONNEL (구)제약 재사용 관련 수정

        ------------------------------------------------------------------------
        -- FROZEN PLAN QUANTITY -> QUANTITY / YIELD
        -- 2026.07.09 Minyong Lee : [E20260708-001247] 최적화_YIELD 감안 Frozen 수량 보정 로직 오류 수정 요청
        ------------------------------------------------------------------------
        UPDATE A
        SET A.QUANTITY  = A.QUANTITY / ISNULL(B.YIELD,1)
        FROM SCP_OPT_ENG_FROZEN_PLAN_SN A
            INNER JOIN SCP_OPT_ENG_ROUTING_SN B
                ON  A.PLAN_ID       = B.PLAN_ID
                AND A.ROUTING_BOM_MAPPING_ID = 'RB' + B.ROUTING_ID
        WHERE A.PLAN_ID = @V_PLAN_ID
        ------------------------------------------------------------------------
        -- Delete Garbage Demand Data
        ------------------------------------------------------------------------
        DELETE FROM SCP_OPT_ENG_DEMAND_SN
        WHERE   PLAN_ID = @V_PLAN_ID
        AND     ATTRIBUTE13 = 'GROUP_DEMAND'

        ------------------------------------------------------------------------
        --MATERIAL CONSTRAINTS
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_ITEM_BOM_ROUTING_SN(PLAN_ID,ROUTING_BOM_MAPPING_ID,BUFFER_ID,ROUTING_ID,BOM_ID,EFF_START_DATE,EFF_END_DATE,FROZEN_FENCE,PRIORITY
                                                    ,IN_CONTAINER_CATEGORY,IN_CONTAINER_SIZE,OUT_CONTAINER_CATEGORY,OUT_CONTAINER_SIZE)
        SELECT @V_PLAN_ID AS PLAN_ID
              ,'RB'+SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST'+'::-::-' AS ROUTING_BOM_MAPPING_ID
              ,SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST'               AS BUFFER_ID                                             
              ,SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST'+'::-::-'      AS ROUTING_ID                                                       
              ,NULL                                                           AS BOM_ID        
              ,EFF_END_DATE                                                   AS EFF_START_DATE
              ,@V_PLAN_END_YYYYMMDD                                           AS EFF_END_DATE
              ,NULL                                                           AS FROZEN_FENCE
              ,1                                                              AS PRIORITY
              ,NULL                                                           AS IN_CONTAINER_CATEGORY
              ,NULL                                                           AS IN_CONTAINER_SIZE
              ,NULL                                                           AS OUT_CONTAINER_CATEGORY
              ,NULL                                                           AS OUT_CONTAINER_SIZE
        FROM(
            -- START 2025.11.19 jongykim2: Schelduled Reciept Information
            SELECT   LU.PLANT_SITE_ID AS SCM_SITE_ID
                    ,LU.ITEM_ID AS P_ITEM_ID
                    ,LU.ITEM_ID_CHILD AS C_ITEM_ID
                    ,LU.TO_EXPC_QTY AS CON_QTY
					,CONVERT(NVARCHAR(8),DATEADD(DAY,1,LU.TO_YYYYMMDD),112) AS EFF_END_DATE
                    ,ITS.STAGE     AS P_STAGE
            FROM     SCP_OPMZ_VIRTUAL_BOM LU WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON     LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            ON  ITS.PLAN_ID = @V_PLAN_ID
            AND LU.ITEM_ID = ITS.ITEM_ID
            AND ITS.ITEM_CLASS_ID NOT IN ('DEMAND') 
            AND ITS.STAGE NOT IN ('ASY_AGING')
            AND LU.PLANT_SITE_ID = ITS.SITE_ID
            WHERE    1 = 1
            AND      LU.DIVISION_ID     = @V_DIVISION_ID
            AND      PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND      PG.VALID_YN        = 'Y'
            AND      LU.VALID_YN        = 'Y'
            -- END 2025.11.19 jongykim2: Schelduled Reciept Information
            /* -- BLOCKED 2025.11.19 jongykim2
            SELECT   LU.SEGMENT4   AS SCM_SITE_ID
                    ,LU.SEGMENT5   AS P_ITEM_ID
                    ,LU.ATTRIBUTE1 AS C_ITEM_ID
                    ,LU.ATTRIBUTE2 AS CON_QTY
                    --,LU.ATTRIBUTE2 AS EFF_END_DATE
					,CONVERT(NVARCHAR(8),DATEADD(DAY,1,LU.ATTRIBUTE3),112) AS EFF_END_DATE
                    ,ITS.STAGE     AS P_STAGE
            FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            ON  ITS.PLAN_ID = @V_PLAN_ID
            AND LU.SEGMENT5 = ITS.ITEM_ID
            AND ITS.ITEM_CLASS_ID NOT IN ('DEMAND') 
            AND ITS.STAGE NOT IN ('ASY_AGING')
            AND LU.SEGMENT4 = ITS.SITE_ID
            WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
            AND      LU.VALID_YN    = 'Y'
            AND      LU.SEGMENT2    = @V_DIVISION_ID
            AND      LU.SEGMENT3    = @V_GROUP_ID */
            ) MC
        GROUP BY SCM_SITE_ID, C_ITEM_ID, EFF_END_DATE
        
        INSERT INTO SCP_OPT_ENG_ROUTING_SN(PLAN_ID,ROUTING_ID,OP_SEQ,LEAD_TIME,YIELD,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3)
        SELECT @V_PLAN_ID
              ,SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST'+'::-::-' AS ROUTING_ID
              ,0                                                         AS OP_SEQ
              ,0                                                         AS LEAD_TIME
              ,1                                                         AS YIELD
              ,SCM_SITE_ID                                               AS ATTRIBUTE1
              ,C_ITEM_ID                                                 AS ATTRIBUTE2
              ,'MATERIAL_CONST'                                          AS ATTRIBUTE3
        FROM(
            -- START 2025.11.19 jongykim2: Schelduled Reciept Information
            SELECT   LU.PLANT_SITE_ID AS SCM_SITE_ID
                    ,LU.ITEM_ID AS P_ITEM_ID
                    ,LU.ITEM_ID_CHILD AS C_ITEM_ID
                    ,LU.TO_EXPC_QTY AS CON_QTY
					,CONVERT(NVARCHAR(8),DATEADD(DAY,1,LU.TO_YYYYMMDD),112) AS EFF_END_DATE
            FROM     SCP_OPMZ_VIRTUAL_BOM LU WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON       LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            WHERE    1 = 1
            AND      LU.DIVISION_ID     = @V_DIVISION_ID
            AND      PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND      PG.VALID_YN        = 'Y'
            AND      LU.VALID_YN        = 'Y'
            -- END 2025.11.19 jongykim2: Schelduled Reciept Information
            /* -- BLOCKED 2025.11.19 jongykim2
            SELECT   LU.SEGMENT4   AS SCM_SITE_ID
                    ,LU.SEGMENT5   AS P_ITEM_ID
                    ,LU.ATTRIBUTE1   AS C_ITEM_ID
                    ,LU.ATTRIBUTE2 AS CON_QTY
                    --,LU.ATTRIBUTE2 AS EFF_END_DATE
					,CONVERT(NVARCHAR(8),DATEADD(DAY,1,LU.ATTRIBUTE3),112) AS EFF_END_DATE
            FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
            AND      LU.VALID_YN    = 'Y'
            AND      LU.SEGMENT2    = @V_DIVISION_ID
            AND      LU.SEGMENT3    = @V_GROUP_ID */
        ) MC
        GROUP BY SCM_SITE_ID, C_ITEM_ID

        INSERT INTO SCP_OPT_ENG_BOM_SN (PLAN_ID,BOM_ID,OP_SEQ,MATERIAL_CLASS_ID,MATERIAL_BUFFER_ID,PRIORITY,CONSUME_QUANTITY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE14,ATTRIBUTE15)
        SELECT @V_PLAN_ID                                       AS PLAN_ID
              ,SCM_SITE_ID+'::'+P_ITEM_ID+'::'+P_STAGE          AS BOM_ID
              ,0                                                AS OP_SEQ
              ,'MATERIAL_CONST'                                 AS MATERIAL_CLASS_ID
              ,SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST' AS MATERIAL_BUFFER_ID
              ,1                                                AS PRIORITY
              ,CON_QTY                                          AS CONSUME_QUANTITY
              ,SCM_SITE_ID                                      AS ATTRIBUTE1
              ,P_ITEM_ID                                        AS ATTRIBUTE2
              ,P_STAGE                                          AS ATTRIBUTE3
              ,C_ITEM_ID                                        AS ATTRIBUTE14
              ,'MATERIAL_CONST'                                 AS ATTRIBUTE15
        FROM(
            -- START 2025.11.19 jongykim2: Schelduled Reciept Information
            SELECT   LU.PLANT_SITE_ID AS SCM_SITE_ID
                    ,LU.ITEM_ID AS P_ITEM_ID
                    ,LU.ITEM_ID_CHILD AS C_ITEM_ID
                    ,LU.TO_EXPC_QTY AS CON_QTY
                    ,LU.TO_YYYYMMDD AS EFF_END_DATE
                    ,ITS.STAGE     AS P_STAGE
            FROM     SCP_OPMZ_VIRTUAL_BOM LU WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON       LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            ON  ITS.PLAN_ID = @V_PLAN_ID
            AND LU.ITEM_ID = ITS.ITEM_ID
            AND ITS.ITEM_CLASS_ID NOT IN ('DEMAND') 
            AND ITS.STAGE NOT IN ('ASY_AGING')
            AND LU.PLANT_SITE_ID = ITS.SITE_ID
            WHERE    1 = 1
            AND      LU.DIVISION_ID     = @V_DIVISION_ID
            AND      PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND      PG.VALID_YN        = 'Y'
            AND      LU.VALID_YN        = 'Y'
            -- END 2025.11.19 jongykim2: Schelduled Reciept Information
            /* -- BLOCKED 2025.11.19 jongykim2
            SELECT   LU.SEGMENT4   AS SCM_SITE_ID
                    ,LU.SEGMENT5   AS P_ITEM_ID
                    ,LU.ATTRIBUTE1 AS C_ITEM_ID
                    ,LU.ATTRIBUTE2 AS CON_QTY
                    ,LU.ATTRIBUTE3 AS EFF_END_DATE
                    ,ITS.STAGE     AS P_STAGE
            FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN ITS WITH(NOLOCK)
            ON  ITS.PLAN_ID = @V_PLAN_ID
            AND LU.SEGMENT5 = ITS.ITEM_ID
            AND ITS.ITEM_CLASS_ID NOT IN ('DEMAND') 
            AND ITS.STAGE NOT IN ('ASY_AGING')
            AND LU.SEGMENT4 = ITS.SITE_ID
            WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
            AND      LU.VALID_YN    = 'Y'
            AND      LU.SEGMENT2    = @V_DIVISION_ID
            AND      LU.SEGMENT3    = @V_GROUP_ID */
            ) MC
        
        INSERT INTO SCP_OPT_ENG_ITEM_SITE_SN (PLAN_ID,BUFFER_ID,SITE_ID,ITEM_ID,GRADE,SITE_TYPE,ITEM_CLASS_ID,INCH,FAB,STAGE,IS_INFINITE,IS_PURCHASED,PURCHASE_PERIOD
                                             ,IS_NO_CARRY,STORAGE_ID,STORAGE_PER,SETUP_ID,SETUP_GROUP_ID,ITEM_GROUP_ID,ATTRIBUTE3)
        SELECT @V_PLAN_ID                                       AS PLAN_ID
              ,SCM_SITE_ID+'::'+C_ITEM_ID+'::'+'MATERIAL_CONST' AS BUFFER_ID
              ,SCM_SITE_ID                                      AS SITE_ID
              ,C_ITEM_ID                                        AS ITEM_ID
              ,'MATERIAL_CONST'                                 AS GRADE
              ,NULL                                             AS SITE_TYPE
              ,'MATERIAL'                                       AS ITEM_CLASS_ID
              ,NULL                                             AS INCH
              ,NULL                                             AS FAB
              ,'M0'                                             AS STAGE
              ,NULL                                             AS IS_INFINITE
              ,NULL                                             AS IS_PURCHASED
              ,NULL                                             AS PURCHASE_PERIOD
              ,NULL                                             AS IS_NO_CARRY
              ,NULL                                             AS STORAGE_ID
              ,NULL                                             AS STORAGE_PER
              ,NULL                                             AS SETUP_ID
              ,NULL                                             AS SETUP_GROUP_ID
              ,NULL                                             AS ITEM_GROUP_ID
              ,'MATERIAL'                                       AS ATTRIBUTE3
        FROM(
            -- START 2025.11.19 jongykim2: Schelduled Reciept Information
            SELECT   LU.PLANT_SITE_ID   AS SCM_SITE_ID
                    ,LU.ITEM_ID   AS P_ITEM_ID
                    ,LU.ITEM_ID_CHILD AS C_ITEM_ID
                    ,LU.TO_EXPC_QTY AS CON_QTY
                    ,LU.TO_YYYYMMDD AS EFF_END_DATE
            FROM     SCP_OPMZ_VIRTUAL_BOM LU WITH(NOLOCK)
            INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
            ON       LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
            WHERE    1 = 1
            AND      LU.DIVISION_ID     = @V_DIVISION_ID
            AND      PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
            AND      PG.VALID_YN        = 'Y'
            AND      LU.VALID_YN        = 'Y'
            -- END 2025.11.19 jongykim2: Schelduled Reciept Information
            /* -- BLOCKED 2025.11.19 jongykim2
            SELECT   LU.SEGMENT4   AS SCM_SITE_ID
                    ,LU.SEGMENT5   AS P_ITEM_ID
                    ,LU.ATTRIBUTE1 AS C_ITEM_ID
                    ,LU.ATTRIBUTE2 AS CON_QTY
                    ,LU.ATTRIBUTE3 AS EFF_END_DATE
            FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
            AND      LU.VALID_YN    = 'Y'
            AND      LU.SEGMENT2    = @V_DIVISION_ID
            AND      LU.SEGMENT3    = @V_GROUP_ID */
            ) MC
        GROUP BY SCM_SITE_ID, C_ITEM_ID
        ------------------------------------------------------------------------
        --MATERIAL CONSTRAINTS - BOM UPDATE IN ITEM_BOM_ROUTING
        ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_ITEM_BOM_ROUTING_SN 
        SET SCP_OPT_ENG_ITEM_BOM_ROUTING_SN.BOM_ID = PM.BOM_ID
        FROM SCP_OPT_ENG_ITEM_BOM_ROUTING_SN IBR WITH(NOLOCK)
            INNER JOIN (
                        -- START 2025.11.03 jongykim2: Schelduled Reciept Information
                        SELECT  BOM.PLAN_ID
                               ,BOM.BOM_ID
                        FROM    SCP_OPMZ_VIRTUAL_BOM LU WITH(NOLOCK)
                        INNER JOIN SCP_OPMZ_PLAN_GR_M PG WITH(NOLOCK)
                        ON      LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                INNER JOIN SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                        		    ON   BOM.PLAN_ID			= @V_PLAN_ID
                        		    AND  BOM.MATERIAL_CLASS_ID  = 'MATERIAL_CONST'
                        		    AND  LU.ITEM_ID			= BOM.ATTRIBUTE2
                                    AND  LU.PLANT_SITE_ID   = BOM.ATTRIBUTE1
                        WHERE   1 = 1
                        AND     LU.DIVISION_ID     = @V_DIVISION_ID
                        AND     PG.OPMZ_PLAN_GR_NAME = @V_GROUP_ID
                        AND     PG.VALID_YN        = 'Y'
                        AND     LU.VALID_YN        = 'Y'
                        -- END 2025.11.03 jongykim2: Schelduled Reciept Information
                        /* -- BLOCKED 2025.11.03 jongykim2
                        SELECT  BOM.PLAN_ID
                               ,BOM.BOM_ID
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                INNER JOIN SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                        		    ON   BOM.PLAN_ID			= @V_PLAN_ID
                        		    AND  BOM.MATERIAL_CLASS_ID  = 'MATERIAL_CONST'
                        		    AND  LU.SEGMENT5			= BOM.ATTRIBUTE2
                                    AND  LU.SEGMENT4            = BOM.ATTRIBUTE1
                        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
                        AND     LU.VALID_YN    = 'Y'
                        AND     LU.SEGMENT2    = @V_DIVISION_ID
                        AND     LU.SEGMENT3    = @V_GROUP_ID */
                        ) PM
                ON  IBR.PLAN_ID   = PM.PLAN_ID
                AND IBR.BUFFER_ID = PM.BOM_ID
                AND IBR.BOM_ID IS NULL
                AND IBR.PLAN_ID   = @V_PLAN_ID

        ------------------------------------------------------------------------
        --IS NO CARRY이면서 재고가 있는 경우는 Extra TABLE에 옮긴 후 삭제 
        --소형만 적용
        ------------------------------------------------------------------------
        IF @V_DIVISION_ID = '40'
            BEGIN
                -- Transfer to XTR Table for Extra Stock
                INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_XTR_SN
                SELECT  STK.PLAN_ID	
                	   ,STK.STOCK_ID
                	   ,STK.BUFFER_ID
                	   ,STK.EFFECTIVE_DATE
                	   ,STK.TYPE
                	   ,STK.QUANTITY
                	   ,STK.ATTRIBUTE1
                	   ,STK.ATTRIBUTE2
                	   ,STK.ATTRIBUTE3
                	   ,STK.ATTRIBUTE4
                	   ,STK.ATTRIBUTE5
                	   ,STK.ATTRIBUTE6
                	   ,STK.ATTRIBUTE7
                	   ,STK.ATTRIBUTE8
                	   ,STK.ATTRIBUTE9
                	   ,STK.ATTRIBUTE10
                	   ,STK.ATTRIBUTE11
                	   ,STK.ATTRIBUTE12
                	   ,STK.ATTRIBUTE13
                	   ,STK.ATTRIBUTE14
                	   ,STK.ATTRIBUTE15
                	   ,STK.INSERT_ID
                	   ,STK.INSERT_TIME
                	   ,STK.UPDATE_ID
                	   ,STK.UPDATE_TIME
                FROM   SCP_OPT_ENG_INCOMING_STOCK_SN STK WITH(NOLOCK)
                       INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIM WITH(NOLOCK)
                			ON  STK.PLAN_ID   = SIM.PLAN_ID
                			AND STK.BUFFER_ID = SIM.BUFFER_ID
                			--AND SIM.IS_NO_CARRY = '1'
                			AND SIM.ITEM_CLASS_ID = 'STOCK'
                WHERE  STK.PLAN_ID = @V_PLAN_ID
                
                -- Clear XTR Stcok
                DELETE FROM   SCP_OPT_ENG_INCOMING_STOCK_SN 
                    FROM SCP_OPT_ENG_INCOMING_STOCK_SN STK
                       INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SIM WITH(NOLOCK)
                			ON  STK.PLAN_ID   = SIM.PLAN_ID
                			AND STK.BUFFER_ID = SIM.BUFFER_ID
                			--AND SIM.IS_NO_CARRY = '1'
                			AND SIM.ITEM_CLASS_ID = 'STOCK'
                WHERE  STK.PLAN_ID = @V_PLAN_ID
                
                -- Clear XTR Item Site
                DELETE FROM   SCP_OPT_ENG_ITEM_SITE_SN 
                WHERE  PLAN_ID = @V_PLAN_ID
                --AND    IS_NO_CARRY = '1'
                AND    ITEM_CLASS_ID = 'STOCK'
            END
        ;
        ------------------------------------------------------------------------
        -- FIX 반영할 때 FIX의 수량*완성TACK(단위 : 초) 만큼 EVERY_CALENDAR에 반영
        -- AFTER에서 ROUTING_RESOURCE의 LOAD PER 값을 수정하기 때문에 AFTER에서 진행
        -- 2025.09.12 Philsu Park: Fix Item에 해당하는 Load_Per 값을 사용하게 수정.
        -- [E20260824-000215] [최적화 알고리즘] Prod fix 진행시 Resource Every Calendar 오류 개선
        ------------------------------------------------------------------------
        WITH PROD_FIX AS (
            SELECT  PF.RESOURCE_ID      AS RESOURCE_ID
                    -- ,LK.ATTRIBUTE2                   AS ITEM_ID
                    ,PF.EFFECTIVE_DATE                   AS START_DATE
                    ,CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, PF.EFFECTIVE_DATE, 112)), 112) AS END_DATE
                    ,CONVERT(INT,PF.QUANTITY)*RS.LOAD_PER AS FIXED_VAL
            FROM    SCP_OPT_ENG_FROZEN_PLAN_SN PF WITH(NOLOCK)
            INNER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN RS WITH(NOLOCK)
                ON  RS.PLAN_ID      = @V_PLAN_ID
                AND RS.RESOURCE_ID  = PF.RESOURCE_ID
                AND RS.ATTRIBUTE2   = PF.ATTRIBUTE2
                AND RS.START_DATE  <= PF.EFFECTIVE_DATE
                AND RS.END_DATE    >= CONVERT(NVARCHAR, DATEADD(DAY, 1, CONVERT(DATE, PF.EFFECTIVE_DATE, 112)), 112)
            WHERE   PF.PLAN_ID = @V_PLAN_ID
            AND     PF.ATTRIBUTE13 = 'LOOKUP_PROD_FIX'
        )
        UPDATE  EC
        SET      EC.DAILY_VALUE = CEILING(IIF(FIX.FIXED_VAL>86400,86400,FIX.FIXED_VAL))
                ,EC.UPDATE_ID   = EC.UPDATE_ID + '_AFTER'
                ,EC.UPDATE_TIME = GETDATE()
        FROM    SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN EC
        INNER JOIN PROD_FIX FIX
            ON  EC.RESOURCE_ID  = FIX.RESOURCE_ID
            AND EC.START_DATE   = FIX.START_DATE
        WHERE   1=1
        AND     EC.PLAN_ID          = @V_PLAN_ID
        AND     EC.CALENDAR_LEVEL   = 'L6'
        ;
        /* UPDATE  SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN
        SET     SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN.DAILY_VALUE = CEILING(IIF(FIX.FIX_QTY*RS.LOAD_PER>86400,86400,FIX.FIX_QTY*RS.LOAD_PER))
               ,SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN.UPDATE_ID   = EC.UPDATE_ID + '_AFTER'
               ,SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN.UPDATE_TIME = GETDATE()
        FROM    SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN EC WITH(NOLOCK) 
            INNER JOIN SCP_OPT_ENG_ROUTING_RESOURCE_SN RS WITH(NOLOCK)
                ON  EC.PLAN_ID = RS.PLAN_ID
                AND EC.RESOURCE_ID = RS.RESOURCE_ID
                AND EC.START_DATE >= RS.START_DATE
                AND EC.END_DATE   <= RS.END_DATE
            INNER JOIN (
                        SELECT  SEGMENT5+'::'+ATTRIBUTE1     AS RESOURCE_ID
                               ,ATTRIBUTE3                   AS FIX_DATE
                               ,SUM(CONVERT(INT,ATTRIBUTE4)) AS FIX_QTY
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_PROD_FIX'
                        AND     SEGMENT2    = @V_DIVISION_ID
                        AND     SEGMENT3    = @V_GROUP_ID
                        AND     VALID_YN    = 'Y'
                        GROUP BY SEGMENT5, ATTRIBUTE1, ATTRIBUTE3
                       ) FIX
                ON  EC.RESOURCE_ID = FIX.RESOURCE_ID
                AND EC.START_DATE  = FIX.FIX_DATE
        WHERE   1=1
        AND     EC.PLAN_ID= @V_PLAN_ID
        AND     EC.CALENDAR_LEVEL = 'L6'
        ; */

        -- 2026.08.25 : LINE_PERSONNEL (구)제약 재사용 관련 수정
        INSERT INTO SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN(
               PLAN_ID                                     
              ,RESOURCE_ID                                 
              ,[TYPE]                                      
              ,[START_DATE]                                
              ,END_DATE                                    
              ,DAILY_VALUE                                 
              ,CALENDAR_LEVEL                              
              ,ATTRIBUTE1                                  
              ,ATTRIBUTE2                                  
              ,ATTRIBUTE15
              ,INSERT_ID
              ,INSERT_TIME
              ,UPDATE_ID
              ,UPDATE_TIME
             )                                             
        SELECT  ECT.PLAN_ID                                     AS PLAN_ID
               ,LP.SEGMENT3+'::'+LP.SEGMENT5                    AS RESOURCE_ID
               ,ECT.TYPE                                        AS TYPE
               -- 2026.09.03 Minyong Lee : 라인제약 구간(ATTB3/ATTB4) 교차 적용
               ,GREATEST(ECT.START_DATE, LP.ATTRIBUTE3)         AS SATRT_DATE
               ,LEAST(ECT.END_DATE, CONVERT(NVARCHAR(8),DATEADD(DAY,1,CONVERT(DATE,LP.ATTRIBUTE4,112)),112))          AS END_DATE
               -- 2026.09.03 Minyong Lee : 원본 라인 1개만 존재 시 86400, 2개 이상 시 MAX
               ,CASE WHEN COUNT(DISTINCT ECT.ATTRIBUTE15) = 1
                     THEN CONVERT(INT,86400)*LP.ATTRIBUTE2
                     ELSE CONVERT(INT,MAX(CONVERT(NUMERIC(18,10),ECT.DAILY_VALUE)))*LP.ATTRIBUTE2
                END AS DAILY_VALUE
               ,ECT.CALENDAR_LEVEL                              AS CALENDAR_LEVEL
               ,LP.SEGMENT3                                     AS SITE_ID
               ,NULL                                            AS ITEM_ID
               ,SEGMENT5                                        AS LINE_ID
               ,'PROD_FIX_LINE_PERSONNEL'                       AS INSERT_ID
               ,GETDATE()                                       AS INSERT_TIME
               ,'PROD_FIX_LINE_PERSONNEL'                       AS UPDATE_ID
               ,GETDATE()                                       AS UPDATE_TIME
        FROM    SCP_OPT_ENG_RESOURCE_EVERY_CALENDAR_SN ECT
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LP WITH(NOLOCK)
                ON  LP.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_LINE_PERSONNEL'
                AND LP.SEGMENT2 = @V_DIVISION_ID
                AND ECT.ATTRIBUTE1  = LP.SEGMENT3
                AND ECT.ATTRIBUTE15 = LP.SEGMENT4
                AND LP.VALID_YN = 'Y'
        WHERE   ECT.PLAN_ID = @V_PLAN_ID
        AND     ECT.CALENDAR_LEVEL = 'L6'
          -- 2026.09.03 Minyong Lee : 교차 구간 역전 시 미생성
          -- 2026.09.07 Minyong Lee : END_DATE가 < (미만) 기준이므로 START_DATE = END_DATE(0일 구간) 제외 → <= 를 < 로 변경
          AND GREATEST(ECT.START_DATE, LP.ATTRIBUTE3) < LEAST(ECT.END_DATE, CONVERT(NVARCHAR(8),DATEADD(DAY,1,CONVERT(DATE,LP.ATTRIBUTE4,112)),112))
        GROUP BY ECT.PLAN_ID, LP.SEGMENT3, LP.SEGMENT5, ECT.TYPE, ECT.CALENDAR_LEVEL, LP.ATTRIBUTE2
               -- 2026.09.03 : 교차 구간 컬럼 추가 (START_DATE/END_DATE는 GREATEST/LEAST 인자로 필요)
               , ECT.START_DATE, ECT.END_DATE, LP.ATTRIBUTE3, LP.ATTRIBUTE4

        ------------------------------------------------------------------------
        -- 2025.06.24 Philsu Park
        -- 소형 속도개선을 위한 Test.
        -- 강교수님 요청: Demand 기준 BOD LT + 선행생산 LT를 DUE_DATE 에서 차감해서 User_Attb1 에 제공.
        -- 2025.11.04 Minyong Lee : Lookup -> UI 전환 (cover_day)
        ------------------------------------------------------------------------
        IF @V_DIVISION_ID = '40'
            BEGIN
                WITH LEAD_TIME AS (
                                    SELECT    BOD.PLAN_ID
                                            , BOD.FROM_BUFFER_ID
                                            , BOD.TO_BUFFER_ID
                                            , BOD.ATTRIBUTE1 AS FROM_SITE_ID
                                            , BOD.ATTRIBUTE2 AS FROM_ITEM_ID
                                            , BOD.ATTRIBUTE3 AS FROM_STAGE
                                            , GREATEST(MIN(EFF_START_DATE), @V_PLAN_START_YYYYMMDD) AS EFF_START_DATE
                                            , MIN(ISNULL(BOD.DEFAULT_LEAD_TIME, 0)) AS DEFAULT_BOD_LT
                                    FROM    SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK)
                                    WHERE   BOD.PLAN_ID = @V_PLAN_ID
                                    AND     BOD.PRIORITY = 1
                                    GROUP BY BOD.PLAN_ID, BOD.FROM_BUFFER_ID, BOD.TO_BUFFER_ID, BOD.ATTRIBUTE1, BOD.ATTRIBUTE2, BOD.ATTRIBUTE3
                                    )
                    , MIN_COVER AS (
                                    --SELECT	 LV.SEGMENT3                                        AS SITE_ID
                                    --        ,ISNULL(BOM.ATTRIBUTE2, LV.SEGMENT4)                AS ITEM_ID
                                    --        ,IIF(LV.SEGMENT5 = 'CELLBIZ', LV.SEGMENT5, 'CHAR')  AS STAGE
                                    --        ,CASE WHEN LV.ATTRIBUTE1 <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
                                    --            ELSE LV.ATTRIBUTE1
                                    --        END                                                AS FROM_YYYYMMDD
                                    --        ,CASE WHEN IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2) >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
                                    --            ELSE IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2)
                                    --        END                                                AS TO_YYYYMMDD
                                    --        ,SUM(CONVERT(INT, LV.ATTRIBUTE3))					AS VAL
                                    --FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                                    --LEFT OUTER JOIN SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                                    --    ON  BOM.PLAN_ID     = @V_PLAN_ID
                                    --    AND BOM.ATTRIBUTE1  = LV.SEGMENT3
                                    --    AND BOM.ATTRIBUTE14 = LV.SEGMENT4
                                    --    AND LV.SEGMENT5    IN ('ASSY', 'ASY_AGING')
                                    --    AND BOM.ATTRIBUTE3  = 'CHAR'
                                    --WHERE   LV.LOOKUP_TYPE	= 'SCP_OPT_ENG_CONST_SAFETY_STOCK'
                                    --AND     LV.VALID_YN		= 'Y'
                                    --AND     LV.SEGMENT2		= @V_DIVISION_ID
                                    --AND     LV.ATTRIBUTE2   > @V_PLAN_START_YYYYMMDD -- +1일이 되지 않아서 등호 제거
                                    --AND     LV.ATTRIBUTE1   < @V_PLAN_END_YYYYMMDD   --END DATE가 하루 추가된 날짜이기 때문에, 등호 제거
                                    --AND     EXISTS (SELECT  1
                                    --                FROM    SCP_OPT_ENG_MODEL_LIST_N_SN MDL WITH(NOLOCK)
                                    --                WHERE   MDL.PLAN_ID = @V_PLAN_ID
                                    --                AND     MDL.ITEM_ID = LV.SEGMENT4
                                    --                AND     MDL.STAGE   = LV.SEGMENT5
                                    --                )
                                    --GROUP BY LV.SEGMENT3, ISNULL(BOM.ATTRIBUTE2, LV.SEGMENT4), IIF(LV.SEGMENT5 = 'CELLBIZ', LV.SEGMENT5, 'CHAR')
                                    --        ,CASE WHEN LV.ATTRIBUTE1 <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
                                    --                ELSE LV.ATTRIBUTE1
                                    --            END
                                    --        ,CASE WHEN IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2) >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
                                    --                ELSE IIF(LV.ATTRIBUTE2<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,LV.ATTRIBUTE2),112),LV.ATTRIBUTE2)
                                    --            END

                                    -- 2025.11.04 Minyong Lee : Lookup -> UI 전환 (cover_day)
                                    SELECT  CV.SCM_SITE_ID                               AS SITE_ID
                                          , ISNULL(BOM.ATTRIBUTE2, CV.ITEM_ID)           AS ITEM_ID
                                          , IIF(CV.STAGE = 'CELLBIZ', CV.STAGE, 'CHAR')  AS STAGE
                                          , CASE
                                                WHEN CV.FROM_YYYYMMDD <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
                                                ELSE CV.FROM_YYYYMMDD
                                            END                                          AS FROM_YYYYMMDD
                                          , CASE
                                                WHEN IIF(CV.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,CV.TO_YYYYMMDD),112),CV.TO_YYYYMMDD) >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
                                                ELSE IIF(CV.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,CV.TO_YYYYMMDD),112),CV.TO_YYYYMMDD)
                                            END                                          AS TO_YYYYMMDD
                                          , SUM(CV.TYPE_APPLY_DAY)		                 AS VAL
                                    FROM    SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY CV WITH(NOLOCK)
                                        LEFT OUTER JOIN SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                                            ON  BOM.PLAN_ID     = @V_PLAN_ID
                                            AND BOM.ATTRIBUTE1  = CV.SCM_SITE_ID
                                            AND BOM.ATTRIBUTE14 = CV.ITEM_ID
                                            AND CV.STAGE        IN ('ASSY', 'ASY_AGING')
                                            AND BOM.ATTRIBUTE3  = 'CHAR'
                                    WHERE   1=1
                                    AND     CV.VALUE_TYPE     = 'MIN'
                                    AND     CV.VALID_YN       = 'Y'
                                    AND     CV.DIVISION_ID    = @V_DIVISION_ID
                                    AND     CV.TO_YYYYMMDD    >= @V_PLAN_START_YYYYMMDD
                                    AND     CV.FROM_YYYYMMDD  < @V_PLAN_END_YYYYMMDD
                                    AND     EXISTS (SELECT  1
                                                    FROM    SCP_OPT_ENG_MODEL_LIST_N_SN MDL WITH(NOLOCK)
                                                    WHERE   MDL.PLAN_ID = @V_PLAN_ID
                                                    AND     MDL.ITEM_ID = CV.ITEM_ID
                                                    AND     MDL.STAGE   = CV.STAGE
                                                    )
                                    GROUP BY CV.SCM_SITE_ID
                                           , ISNULL(BOM.ATTRIBUTE2, CV.ITEM_ID)
                                           , IIF(CV.STAGE = 'CELLBIZ', CV.STAGE, 'CHAR')
                                           , CASE
                                                 WHEN CV.FROM_YYYYMMDD <= @V_PLAN_START_YYYYMMDD THEN @V_PLAN_START_YYYYMMDD
                                                 ELSE CV.FROM_YYYYMMDD
                                             END
                                           , CASE
                                                 WHEN IIF(CV.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,CV.TO_YYYYMMDD),112),CV.TO_YYYYMMDD) >= @V_PLAN_END_YYYYMMDD THEN @V_PLAN_END_YYYYMMDD
                                                 ELSE IIF(CV.TO_YYYYMMDD<>'99991231',CONVERT(NVARCHAR(8),DATEADD(DAY,1,CV.TO_YYYYMMDD),112),CV.TO_YYYYMMDD)
                                             END
                                    )
                    , ASY_AGING_LT AS (
                                    SELECT  RT.LEAD_TIME, ISNULL(RT.ATTRIBUTE12, @V_PLAN_START_YYYYMMDD) FROM_YYYYMMDD, ISNULL(RT.ATTRIBUTE13, @V_PLAN_END_YYYYMMDD) TO_YYYYMMDD, BOM.ATTRIBUTE1 AS SITE_ID, BOM.ATTRIBUTE2 AS ITEM_ID, BOm.ATTRIBUTE3 AS STAGE
                                    FROM    SCP_OPT_ENG_BOM_SN BOM WITH(NOLOCK)
                                    LEFT OUTER JOIN SCP_OPT_ENG_ROUTING_SN RT WITH(NOLOCK)
                                        ON  BOM.PLAN_ID     = RT.PLAN_ID
                                        AND BOM.ATTRIBUTE1  = RT.ATTRIBUTE1
                                        AND BOM.ATTRIBUTE14 = RT.ATTRIBUTE2
                                        AND BOM.ATTRIBUTE15 = RT.ATTRIBUTE3
                                    WHERE   BOM.PLAN_ID     = @V_PLAN_ID
                                    AND     BOM.ATTRIBUTE3  = 'CHAR'
                                    )
                UPDATE  DMD
                SET     USER_ATTB1 = ISNULL(CONVERT(NVARCHAR, DATEADD(DAY, (-1)*(ISNULL(LT.DEFAULT_BOD_LT,0) + ISNULL(MCV.VAL, 0) + ISNULL(MCV2.VAL, 0) + ISNULL(AGL2.LEAD_TIME, 0) + ISNULL(AGL.LEAD_TIME, 0)), CONVERT(DATE, DMD.DUE_DATE, 112)), 112), DMD.DUE_DATE)
                FROM    SCP_OPT_ENG_DEMAND_SN DMD
                LEFT OUTER JOIN LEAD_TIME LT
                    ON  DMD.PLAN_ID     = LT.PLAN_ID
                    AND DMD.BUFFER_ID   = LT.TO_BUFFER_ID
                LEFT OUTER JOIN MIN_COVER MCV
                    ON  LT.FROM_SITE_ID     = MCV.SITE_ID
                    AND LT.FROM_ITEM_ID     = MCV.ITEM_ID
                    AND LT.FROM_STAGE       = MCV.STAGE
                    AND LT.EFF_START_DATE  >= MCV.FROM_YYYYMMDD
                    AND LT.EFF_START_DATE   < MCV.TO_YYYYMMDD
                LEFT OUTER JOIN MIN_COVER MCV2
                    ON  DMD.ATTRIBUTE1  = MCV2.SITE_ID
                    AND DMD.ATTRIBUTE2  = MCV2.ITEM_ID
                    AND DMD.ATTRIBUTE3  = MCV2.STAGE
                    AND DMD.DUE_DATE   >= MCV2.FROM_YYYYMMDD
                    AND DMD.DUE_DATE    < MCV2.TO_YYYYMMDD
                LEFT OUTER JOIN ASY_AGING_LT AGL
                    ON  LT.FROM_SITE_ID     = AGL.SITE_ID
                    AND LT.FROM_ITEM_ID     = AGL.ITEM_ID
                    AND LT.FROM_STAGE       = AGL.STAGE
                    AND LT.EFF_START_DATE  >= AGL.FROM_YYYYMMDD
                    AND LT.EFF_START_DATE   < AGL.TO_YYYYMMDD
                LEFT OUTER JOIN ASY_AGING_LT AGL2
                    ON  DMD.ATTRIBUTE1  = AGL2.SITE_ID
                    AND DMD.ATTRIBUTE2  = AGL2.ITEM_ID
                    AND DMD.ATTRIBUTE3  = AGL2.STAGE
                    AND DMD.DUE_DATE   >= AGL2.FROM_YYYYMMDD
                    AND DMD.DUE_DATE    < AGL2.TO_YYYYMMDD
                WHERE   DMD.PLAN_ID     = @V_PLAN_ID
                ;
            END

	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;
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
