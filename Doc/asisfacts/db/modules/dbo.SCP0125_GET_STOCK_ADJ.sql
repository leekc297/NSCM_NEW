


/*
 * Program ID   : SCP0125_GET_STOCK_ADJ
 * Description  : Workbench - Stock 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/06/24   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/07/14   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Nick Name 추가
 * 2025/09/16   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - CUTOFF DAY 재설정
 * 2025/09/22   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리
 * 2025/10/21   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - MA 재고에 대해서는 AGING으로 놔두고 MU, MJ...에 대해서는 CHAR로 변환 
 *
 */

CREATE PROCEDURE [dbo].[SCP0125_GET_STOCK_ADJ]
	@p_division_id				NVARCHAR(50)
	, @p_plan_start_yyyymmdd	NVARCHAR(8)
	, @p_version_no				NVARCHAR(50)
	, @p_nick_name				NVARCHAR(200)
	, @p_item_id				NVARCHAR(200)

AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	------------------------------------------------------------------------ 
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @P_PLAN_NAME         NVARCHAR(8);
    DECLARE @D_PLAN_NAME         DATETIME;			--[PJ20257329] CUTOFF DAY 재설정 (2025-09-16)
    DECLARE @P_MODELING_ID       NVARCHAR(4000);
    DECLARE @V_CUTOFF_DAY        NVARCHAR(8);
    DECLARE @D_CUTOFF_DAY        DATETIME;
    DECLARE @V_DEMAND_CUTOFF_DAY NVARCHAR(8);
    DECLARE @MAX_TUESDAY         NVARCHAR(8)

	DECLARE @MAT_CONST_TEMP TABLE(
		MAT_ID       NVARCHAR(200)
		,EFF_END_DATE NVARCHAR(8)
    )
    DECLARE @DM_TEMP TABLE(
		 SITE_ID      NVARCHAR(100)
		,ITEM_ID      NVARCHAR(100)
		,INCOTERMS    NVARCHAR(100)
		,PROJECT_CODE NVARCHAR(100)
    )
    DECLARE @OCV_EXCEPT_LIST TABLE(
		 SCM_SITE_ID NVARCHAR(100)
		,ITEM_ID     NVARCHAR(100)
    )
    -- 셀 생산지 버퍼 추가
    DECLARE @CELL_PROD_SITE TABLE(
		  SALES_SITE_ID   NVARCHAR(200)
		, ITEM_ID         NVARCHAR(200)
		, OPERATION_GROUP NVARCHAR(10)
    )

		SELECT  @MAX_TUESDAY = MAX(BASIS_YYYYMMDD)
        FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK) 
        WHERE   BASIS_YYYYMMDD <= CONVERT(NVARCHAR(8),GETDATE(),112)
        AND     DAYOFWEEK = 'TUE'

		SELECT @P_MODELING_ID       = MODELING_ID FROM SCM_MST_MODELING WITH(NOLOCK) WHERE PLAN_CYCLE = 'WEEKLY' AND DIVISION_ID = @p_division_id;
        SELECT @P_PLAN_NAME         = @p_plan_start_yyyymmdd ; --CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
        SELECT @D_PLAN_NAME         = CONVERT(DATETIME, @P_PLAN_NAME); --[PJ20257329] CUTOFF DAY 재설정 (2025-09-16)
        SELECT @V_CUTOFF_DAY        = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(DATETIME, @p_plan_start_yyyymmdd)), 112) ; --CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD
        SELECT @D_CUTOFF_DAY        = CONVERT(DATETIME, @V_CUTOFF_DAY)
		--[PJ20257329] CUTOFF DAY 재설정 (2025-09-16) START
        -- SELECT @V_DEMAND_CUTOFF_DAY = @MAX_TUESDAY; -- 당주 화요일 YYYYMMDD
        SELECT @V_DEMAND_CUTOFF_DAY  = ISNULL(MAX(P.CUTOFF_YYYYMMDD),@MAX_TUESDAY)
                                    --, CONVERT(CHAR(8), DATEADD(DD, -6, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) -- 당주 화요일 YYYYMMDD
                                    FROM   DM_PLN_NET_DEMAND P WITH(NOLOCK)
                                    WHERE  P.DIVISION_ID      = @p_division_id 
                                    AND    P.CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -3, @D_PLAN_NAME), 112) -- 월요일 기준 최근 3일 이내									
                                    AND    P.CUTOFF_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +6, @D_PLAN_NAME), 112) -- 해당 주차 일요일 이전
		--[PJ20257329] CUTOFF DAY 재설정 (2025-09-16) END



		INSERT INTO @MAT_CONST_TEMP
        SELECT   ATTRIBUTE1 AS MAT_ID
                ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(ATTRIBUTE3)),112) AS EFF_END_DATE
        FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
        AND      LU.VALID_YN    = 'Y'
        AND      LU.SEGMENT2    = @p_division_id
        GROUP BY ATTRIBUTE1
        ------------------------------------------------------------------------
        --2nd OCV에 활용된 SUB MDLE 재고는 제외하기 위해서
        ------------------------------------------------------------------------
        INSERT INTO @OCV_EXCEPT_LIST
        SELECT MS.SCM_SITE_ID
              ,CHILD_ITEM_ID
        FROM SCM_MST_BOM_SN_V BOM WITH(NOLOCK)
            INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
                ON BOM.PLANT_ID = MS.PLANT_ID
            INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                AND LU.VALID_YN    = 'Y'
                AND LU.SEGMENT2    = @p_division_id
                AND LU.ATTRIBUTE1  = 'B'
        WHERE   1=1
        AND     MS.SCM_SITE_ID     = LU.SEGMENT4
        AND     BOM.PARENT_ITEM_ID = LU.SEGMENT5
        GROUP BY MS.SCM_SITE_ID, CHILD_ITEM_ID
        ------------------------------------------------------------------------
        -- 셀 생산지 버퍼 추가
        ------------------------------------------------------------------------
        INSERT INTO @CELL_PROD_SITE
        SELECT  LU.SEGMENT3            AS SALES_SITE_ID
               ,LU.SEGMENT4            AS ITEM_ID
               ,'_'+FI.OPERATION_GROUP AS OPERATION_GROUP
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
            INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
                ON  LU.SEGMENT1 = FI.DIVISION_ID
                AND LU.SEGMENT4 = FI.ITEM_ID
        WHERE   LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
        AND     LU.SEGMENT1 = @p_division_id


		------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------

		IF OBJECT_ID('TEMPDB..#SCP_INVENTORY_I') IS NOT NULL
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
		END;

        IF OBJECT_ID('TEMPDB..#NET_DEMAND') IS NOT NULL
		BEGIN 
			DROP TABLE  #NET_DEMAND;
		END;

        IF OBJECT_ID('TEMPDB..#INVENTORY_ORG') IS NOT NULL
		BEGIN 
			DROP TABLE  #INVENTORY_ORG;
		END;

        IF OBJECT_ID('TEMPDB..#INVENTORY_AGING_ORG') IS NOT NULL
		BEGIN 
			DROP TABLE  #INVENTORY_AGING_ORG;
		END;

        --------------------------------------------------------
        -- 속도개선을 위한 DEMAND 참조 TEMP 처리.
        --------------------------------------------------------
        SELECT   DIVISION_ID
                ,SCM_SITE_ID    AS SCM_SITE_ID
                ,ITEM_ID        AS ITEM_ID
                ,INCOTERMS      AS INCOTERMS
                ,PROJECT_CODE   AS PROJECT_CODE
                ,MIN(YYYYMMDD)  AS YYYYMMDD
        INTO    #NET_DEMAND
        FROM    DM_PLN_NET_DEMAND WITH(NOLOCK)
        WHERE   DIVISION_ID = @P_DIVISION_ID
        AND     CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY
        AND     VERSION_NO  = ( 
                                SELECT  MAX(VERSION_NO)
                                FROM    DM_MST_VERSION WITH(NOLOCK)
                                WHERE  VERSION_TYPE IN ('MF_W', 'SF_W')
                                AND     DIVISION_ID = @P_DIVISION_ID
                                AND     YYYYMMDD = @V_DEMAND_CUTOFF_DAY
                             )
        GROUP BY DIVISION_ID
                ,SCM_SITE_ID
                ,ITEM_ID
                ,INCOTERMS
                ,PROJECT_CODE
        ;

        SELECT    A.DIVISION_ID
                , A.CUTOFF_DATE
                , A.PLANT_ID
                , A.SITE_ID
                , A.SCM_SITE_ID
				, A.LOCATION_CODE		--[PJ2025732]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-23)
                , A.STOCK_TYPE
                , A.ITEM_ID
                , A.MES_ITEM_ID
                , A.WIPHOLD_YN
                , A.AVAILABLE_DATE
                , A.OPERATION_ID
                , A.STORAGE_ID
                , SUM(A.SCM_QTY) AS SCM_QTY
        INTO    #INVENTORY_ORG
        FROM    SCM_DNM_STOCK A WITH(NOLOCK)
        INNER JOIN SCM_ITEM_M_SN ITM WITH(NOLOCK)
            ON ITM.COMPANY_ID = A.COMPANY_ID
            AND ITM.DIVISION_ID = A.DIVISION_ID
            AND ITM.SITE_ID     = A.SITE_ID
            AND ITM.ITEM_ID     = A.ITEM_ID
        where   A.DIVISION_ID = @p_division_id
        and     A.CUTOFF_DATE = @V_CUTOFF_DAY
        AND     A.SCM_SITE_ID     IS NOT NULL
        AND     ITM.SCP_FLOW_ID   IS NOT NULL
        GROUP BY  A.DIVISION_ID
                , A.CUTOFF_DATE
                , A.PLANT_ID
                , A.SITE_ID
                , A.SCM_SITE_ID
				, A.LOCATION_CODE		--[PJ2025732]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-23)
                , A.STOCK_TYPE
                , A.ITEM_ID
                , A.MES_ITEM_ID
                , A.WIPHOLD_YN
                , A.AVAILABLE_DATE
                , A.OPERATION_ID
                , A.STORAGE_ID
        ;

        SELECT A.DIVISION_ID
            , A.SCM_SITE_ID
			, A.PLANT_ID
            , A.ITEM_ID
            , A.AVAILABLE_DATE
            , A.WIPHOLD_YN
            , A.CUTOFF_DATE
            , A.SITE_ID
            , SUM(A.QTY) AS QTY
        INTO    #INVENTORY_AGING_ORG
        FROM   SCM_DNM_STOCK_AGING_V A WITH (NOLOCK)
        WHERE A.DIVISION_ID = @p_division_id 
        AND EXISTS (SELECT 1
                    FROM 
                            (SELECT DIVISION_ID, SITE_ID, MAX(CUTOFF_DATE) MAX_CUTOFF_DATE
                            FROM   SCM_DNM_STOCK_AGING_V A
                            WHERE  A.DIVISION_ID   = @p_division_id
                            AND    A.CUTOFF_DATE   >  DATEADD(DD, -7, @D_CUTOFF_DAY)
                            AND    A.CUTOFF_DATE   <= @D_CUTOFF_DAY
                            GROUP BY DIVISION_ID, SITE_ID
                            ) AG 
                    WHERE   AG.division_id = A.division_id
                    AND     AG.site_id      = A.site_id
                    AND     AG.MAX_CUTOFF_DATE = A.cutoff_date
                    )
        AND	   A.SITE_ID IS NOT NULL  
        GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
				, A.PLANT_ID
                , A.ITEM_ID
                , A.AVAILABLE_DATE
                , A.WIPHOLD_YN
                , A.CUTOFF_DATE
                , A.SITE_ID

        --------------------------------------------------------
        -- 1. 창고 재고 : WH
        --------------------------------------------------------
        -- 1.1 SALES 재고
		SELECT 
               A.DIVISION_ID   AS DIVISION_ID
			  ,A.SCM_SITE_ID   AS SCM_SITE_ID 
			  ,A.PLANT_ID
			  ,'-'             AS INCOTERMS -- 뒤에서 별도 UPDATE 
			  ,A.STOCK_TYPE
			  ,A.ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @P_PLAN_NAME) -- 엔진 오류로 Plan 구간 안으로 처리
                    WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @P_PLAN_NAME) -- 엔진 오류로 Plan 구간 안으로 처리
                    WHEN CONVERT(CHAR(8), AVAILABLE_DATE, 112) < @P_PLAN_NAME THEN CONVERT(DATETIME, @P_PLAN_NAME)
                    ELSE                                                           CONVERT(DATE, CONVERT(CHAR(8), AVAILABLE_DATE, 112))  
               END AS AVAILABLE_DATE
			  ,A.SCM_QTY AS QTY -- SCP 사용 QTY
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = '' THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
			  ,B.SITE_TYPE
			 , '-'                        AS location_code -- PLANT 재고 구분용 정보
             , '-'                        AS PROJECT_CODE  -- 뒤에서 별도 UPDATE
             , ISNULL(MSP.SCM_SITE_ID,'') AS CELL_PROD_SITE_ID
             , 'SALES'                    AS FLAG
		INTO   #SCP_INVENTORY_I
        FROM   #INVENTORY_ORG A
		-- FROM   SCM_DNM_STOCK      A WITH (NOLOCK) 
            --소형 생산지 구분을 위한 분리
        INNER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                    FROM   SCM_MST_SITE  WITH(NOLOCK)
	                WHERE  1=1
                    AND    SITE_TYPE        = 'SALES'
                    ) B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND A.SCM_SITE_ID = B.SCM_SITE_ID
        LEFT OUTER JOIN @OCV_EXCEPT_LIST OCV
            ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
            AND A.MES_ITEM_ID = OCV.ITEM_ID
        LEFT OUTER JOIN @CELL_PROD_SITE CPS 
            ON  1=1
            AND A.SCM_SITE_ID = CPS.SALES_SITE_ID
            AND A.ITEM_ID     = CPS.ITEM_ID
        LEFT OUTER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID,PLANT_ID
                            FROM   SCM_MST_SITE  WITH(NOLOCK)
	                	    WHERE  1=1
                            AND    PLANT_ID IS NOT NULL
                        ) MSP
            ON  1=1
            AND A.DIVISION_ID                  = MSP.DIVISION_ID
            AND A.PLANT_ID+CPS.OPERATION_GROUP = MSP.SCM_SITE_ID
		WHERE  1 = 1		
        AND    A.CUTOFF_DATE      = @V_CUTOFF_DAY
        AND    A.DIVISION_ID      = @p_division_id
        AND    OCV.ITEM_ID        IS NULL
		AND A.SCM_SITE_ID IS NOT NULL
		-- 소형은 CEll Biz 용 Demand 만 처리
		AND ((A.DIVISION_ID  = '40' AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
			OR  (A.DIVISION_ID <> '40' )
			)
		;



        ALTER TABLE #SCP_INVENTORY_I ALTER COLUMN INCOTERMS VARCHAR(100) NULL;
        ALTER TABLE #scp_inventory_i ALTER COLUMN location_code VARCHAR(100) NULL;
        ALTER TABLE #scp_inventory_i ALTER COLUMN PROJECT_CODE VARCHAR(100) NULL;

        -- 1.2 SO RESERVE STOCK : RESULT_TYPE = 'B' : 해상재고 대신 TO SITE의 재고로 처리
        INSERT INTO #SCP_INVENTORY_I
		SELECT --DISTINCT 
               A.DIVISION_ID      AS DIVISION_ID
			  ,A.TO_SCM_SITE_ID   AS SCM_SITE_ID
			  ,A.PLANT_ID
			  ,'-'                AS INCOTERMS -- 뒤에서 별도 UPDATE 
			  ,'SO'      AS STOCK_TYPE
			  ,A.ITEM_ID AS ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 ; BOH 처리용 1일 전
              ,CONVERT(DATETIME, @P_PLAN_NAME) AS AVAILABLE_DATE

			  ,A.DELIVERY_QTY AS QTY
			  ,'N'       AS WIPHOLD_YN
			  ,B.SITE_TYPE
			 , '-'             AS location_code -- PLANT 재고 구분용 정보
             , IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT
             , IIF(CPS.ITEM_ID IS NULL,'',A.FROM_SCM_SITE_ID) AS CELL_PROD_SITE_ID
             , 'SALES'         AS FLAG
		FROM   SCM_DNM_INTRANSIT_C  A WITH (NOLOCK)
        INNER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
            FROM   SCM_MST_SITE  WITH(NOLOCK)
			WHERE  1=1
            AND    SITE_TYPE        = 'SALES'
            ) B
            ON  1=1
            AND A.DIVISION_ID    = B.DIVISION_ID
            AND A.TO_SCM_SITE_ID = B.SCM_SITE_ID
        LEFT OUTER JOIN @CELL_PROD_SITE CPS 
            ON  1=1
            AND A.TO_SCM_SITE_ID = CPS.SALES_SITE_ID
            AND A.ITEM_ID        = CPS.ITEM_ID
		WHERE  1 = 1
        AND    A.DIVISION_ID      = @p_division_id
        AND    A.RESULT_DATE      = @V_CUTOFF_DAY
		-- SO Reserve Stock : result_type = 'B' 는 재고로 처리               
        AND    A.RESULT_TYPE      = 'B'                  
		AND    A.VALID_YN         = 'Y'   -- 해상재고    
		AND A.TO_SCM_SITE_ID IS NOT NULL  
		-- 소형은 CEll Biz 용 Demand 만 처리
		AND ((A.DIVISION_ID  = '40' AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
			OR  (A.DIVISION_ID <> '40' )
			)
	   ; 


        -- 1.3 SALES 재고 : INCOTERMS UPDATE
        UPDATE #SCP_INVENTORY_I
        SET    INCOTERMS  = ISNULL(ISNULL(B.MAX_INCOTERMS, C.MAX_INCOTERMS), 'DAP') -- DEMAND 없는 경우 DAP 처리
        FROM   #SCP_INVENTORY_I A
        LEFT JOIN ( SELECT  AA.SCM_SITE_ID, AA.ITEM_ID
				             --  VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함) 
		                   ,MAX(CASE WHEN CC.VMI_YN = 'Y' THEN 'DAP' 
                                ELSE AA.INCOTERMS
                                END ) MAX_INCOTERMS
                    FROM   #NET_DEMAND AA
                     /* FROM   DM_PLN_NET_DEMAND AA WITH(NOLOCK)
                            INNER JOIN (SELECT SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                        FROM   DM_PLN_NET_DEMAND WITH(NOLOCK)
                                        WHERE  DIVISION_ID     = @p_division_id 
                                        AND    CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY -- @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD)
                                        GROUP BY  SCM_SITE_ID
                                        ) BB
                            ON  AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                            AND AA.VERSION_NO      = BB.MAX_VERSION_NO
                            AND AA.DIVISION_ID     = @p_division_id 
                            AND AA.CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY    */

                            LEFT JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN 
                                        FROM   SCM_MST_SITE WITH (NOLOCK)
                                        WHERE  DIVISION_ID = @p_division_id
                                        AND    VMI_YN      = 'Y') CC
                            ON     AA.DIVISION_ID = CC.DIVISION_ID 
                            AND    AA.SCM_SITE_ID = CC.SCM_SITE_ID 
                     GROUP BY AA.SCM_SITE_ID, AA.ITEM_ID
                   ) B
        ON     A.SCM_SITE_ID = B.SCM_SITE_ID 
        AND    A.ITEM_ID     = B.ITEM_ID 
        
        LEFT JOIN ( SELECT AA.SCM_SITE_ID
				            --  VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함) 
		                  , MAX(CASE WHEN CC.VMI_YN = 'Y' THEN 'DAP' 
                                ELSE AA.INCOTERMS
                                END ) MAX_INCOTERMS
                    FROM   #NET_DEMAND AA
                    /* FROM   DM_PLN_NET_DEMAND AA WITH(NOLOCK)
                           INNER JOIN (SELECT SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                       FROM   DM_PLN_NET_DEMAND WITH(NOLOCK)
                                       WHERE  DIVISION_ID     = @p_division_id   
                                       AND    CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY -- @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD)
                                       GROUP BY  SCM_SITE_ID
                                       ) BB
                           ON  AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                           AND AA.VERSION_NO      = BB.MAX_VERSION_NO
                           AND AA.DIVISION_ID     = @p_division_id 
                           AND AA.CUTOFF_YYYYMMDD = @V_DEMAND_CUTOFF_DAY    */

                           LEFT JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN 
                                       FROM   SCM_MST_SITE WITH (NOLOCK)
                                       WHERE  DIVISION_ID = @p_division_id
                                       AND    VMI_YN      = 'Y') CC
                           ON     AA.DIVISION_ID = CC.DIVISION_ID 
                           AND    AA.SCM_SITE_ID = CC.SCM_SITE_ID 
                    GROUP BY AA.SCM_SITE_ID
                   ) C
        ON     A.SCM_SITE_ID = C.SCM_SITE_ID 

		WHERE  1=1
		AND    A.SITE_TYPE       = 'SALES'
		;


        -- 1.4 PLANT 재고
		INSERT INTO   #SCP_INVENTORY_I
		SELECT A.DIVISION_ID   AS DIVISION_ID
			  ,A.SCM_SITE_ID   AS SCM_SITE_ID 
			  ,A.PLANT_ID
			  ,'-'             AS INCOTERMS
			  ,A.STOCK_TYPE
			  ,A.ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @P_PLAN_NAME) -- 엔진 오류로 Plan 구간 안으로 처리
                    WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @P_PLAN_NAME) -- 엔진 오류로 Plan 구간 안으로 처리
                    WHEN CONVERT(CHAR(8), AVAILABLE_DATE, 112) < @P_PLAN_NAME THEN CONVERT(DATETIME, @P_PLAN_NAME)
                    ELSE                                                           CONVERT(DATE, CONVERT(CHAR(8), AVAILABLE_DATE, 112))  
               END AS AVAILABLE_DATE
			  ,A.SCM_QTY AS QTY 
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = '' THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
			  ,B.SITE_TYPE
			 , CASE WHEN ISNULL(op.location_code, '') <> '' OR ISNULL(st.location_code, '') <> '' THEN 'ASSY'
			       ELSE '-'
			   END AS location_code -- PLANT 재고 구분용 정보
             ,''      AS PROJECT_CODE
             ,''      AS CELL_PROD_SITE_ID
             ,'PLANT' AS FLAG
        FROM   #INVENTORY_ORG A
		-- FROM   SCM_DNM_STOCK      A WITH (NOLOCK) 
		INNER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                FROM   SCM_MST_SITE  WITH(NOLOCK)
				WHERE  1=1
                AND    DIVISION_ID      = @p_division_id  
                AND    SITE_TYPE        = 'PLANT'
				AND ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리 : 소형 Pack 제외
					OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
					)
               ) B
			ON     A.DIVISION_ID      = B.DIVISION_ID
			AND    A.SCM_SITE_ID      = B.SCM_SITE_ID
        LEFT JOIN (  SELECT DISTINCT
                               a.operation_id
                            ,  a.location_code
                            ,  a.scm_site_id
                    FROM   scm_mst_location a WITH (NOLOCK)
                            INNER JOIN (SELECT scm_site_id  
                                        FROM   scm_mst_site
                                        WHERE  division_id     = @p_division_id  
                                        AND    valid_yn        = 'Y'
                                        AND    operation_group IN ( 'A' ) 
                                        ) b
                            ON a.scm_site_id = b.scm_site_id 
                    WHERE  a.division_id = @p_division_id --'81'
                    AND    a.valid_yn    = 'Y'
                    AND    location_code = 'PACKAGING' --활성화 전 재고
                    AND    (operation_id IS NOT NULL AND operation_id <> '')
                )  op -- 셀의 operation_id 별 사용대상 조회
			ON   A.operation_id = op.operation_id 
			AND  A.scm_site_id  = op.scm_site_id
        LEFT JOIN (  SELECT DISTINCT
                               a.storage_id
                            ,  a.location_code
                            ,  a.scm_site_id
                    FROM   DBO.scm_mst_location a WITH (NOLOCK)
                            INNER JOIN (SELECT scm_site_id  
                                        FROM   scm_mst_site
                                        WHERE  division_id     = @p_division_id  
                                        AND    valid_yn        = 'Y'
                                        AND    operation_group IN ( 'A' ) 
                                        ) b
                            ON a.scm_site_id = b.scm_site_id 
                    WHERE  a.division_id = @p_division_id --'81'
                    AND    a.valid_yn    = 'Y'
                    AND    location_code = 'PACKAGING' --활성화 전 재고
                    AND    (storage_id IS NOT NULL AND storage_id <> '')
                )  st -- 셀의 storage_id 별 사용대상 조회
			ON   A.storage_id   = st.storage_id 
			AND  A.scm_site_id  = st.scm_site_id
        LEFT OUTER JOIN @OCV_EXCEPT_LIST OCV
            ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
            AND A.MES_ITEM_ID = OCV.ITEM_ID
		WHERE  1 = 1		
        AND    A.CUTOFF_DATE      = @V_CUTOFF_DAY
        AND    A.DIVISION_ID      = @p_division_id
		AND    ISNULL(A.LOCATION_CODE, '') NOT IN ( 'COATING', 'SLITTING'     -- 전극 공정		--[PJ20257329] Location_code가 NULL인 경우, ''으로 처리(2025-09-29)
									,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING' -- 셀공정 : PACKAGING 이전
									)		--[PJ2025732]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-23)
        AND    OCV.ITEM_ID        IS NULL
		AND	   A.SCM_SITE_ID IS NOT NULL  
		;

		--------------------------------------------------------
        -- 2. 활성화 재고 : FOR
        --------------------------------------------------------
		INSERT INTO   #SCP_INVENTORY_I
		SELECT A.DIVISION_ID   AS DIVISION_ID
			  ,A.SCM_SITE_ID   AS SCM_SITE_ID 
			  ,A.PLANT_ID
			  ,'-'             AS INCOTERMS
			  ,'FOR'           AS STOCK_TYPE 
			  ,A.ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              ,CASE WHEN CONVERT(CHAR(8), A.AVAILABLE_DATE, 112) < @P_PLAN_NAME THEN CONVERT(DATE, @P_PLAN_NAME)
                    ELSE A.AVAILABLE_DATE
               END  AS AVAILABLE_DATE
			  ,A.QTY  AS QTY 
              ,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = '' THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
			  ,'PLANT' AS SITE_TYPE
			 , '-'             AS location_code -- PLANT 재고 구분용 정보
              ,''              AS PROJECT_CODE
              , ''             AS CELL_PROD_SITE_ID
              ,'PLANT'         AS FLAG
        FROM    #INVENTORY_AGING_ORG A
        /* FROM   (SELECT A.*
                FROM   SCM_DNM_STOCK_AGING_V A WITH (NOLOCK)
               
               -- 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경
               LEFT JOIN  (SELECT DIVISION_ID, SITE_ID, MAX(CUTOFF_DATE) MAX_CUTOFF_DATE 
                            FROM   SCM_DNM_STOCK_AGING_V A
                            WHERE  A.DIVISION_ID   = @p_division_id
                            AND    A.CUTOFF_DATE   >  DATEADD(DD, -7, @D_CUTOFF_DAY) 
                            AND    A.CUTOFF_DATE   <= @D_CUTOFF_DAY                  
                            GROUP BY DIVISION_ID, SITE_ID   
                           )  C --DIVISION_ID / SITE_ID 별로 최근 일주일이내의 MAX(CUTOFF_DATE) 값
               ON   A.DIVISION_ID     = C.DIVISION_ID
               AND  A.SITE_ID         = C.SITE_ID 
               AND  A.CUTOFF_DATE     = C.MAX_CUTOFF_DATE 

               WHERE A.DIVISION_ID = @p_division_id 
               AND   C.DIVISION_ID IS NOT NULL -- 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경때문에 조건추가함
			   AND	   A.SITE_ID IS NOT NULL  
               ) A */

               -- 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경
               LEFT JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, SITE_TYPE 
                            FROM   SCM_MST_SITE  WITH(NOLOCK) 
                            WHERE  1=1
		                    AND    DIVISION_ID   = @p_division_id
                            AND    SITE_TYPE     = 'PLANT'	
                            AND    ISNULL(OSP_YN, 'N')  = 'N' 
                          ) B
               ON   A.SCM_SITE_ID   = B.SCM_SITE_ID 
        WHERE  B.DIVISION_ID IS NOT NULL -- 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경때문에 조건추가함 


		--------------------------------------------------------
        -- 3. 해상 재고 : INT
        --------------------------------------------------------
        -- 3.1 RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고 
        --    - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' / 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리
        SELECT A.DIVISION_ID  AS DIVISION_ID
              ,A.ITEM_ID
              ,A.TO_SCM_SITE_ID   AS TO_SCM_SITE_ID
			  ,A.FROM_SCM_SITE_ID
              ,A.FINAL_INCOTERMS  AS INCOTERMS
                -- 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              ,CASE WHEN A.ETA_DATE < @P_PLAN_NAME THEN @P_PLAN_NAME
                    ELSE A.ETA_DATE
               END  AS ETA_DATE
	          ,A.DELIVERY_QTY
              ,CASE WHEN TS.SITE_TYPE = 'SALES' AND A.RESULT_TYPE = 'C' THEN '-' -- 법인간 이동 재고에는 Project Code 정보가 없음 
			        WHEN TS.SITE_TYPE = 'SALES' THEN IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) 
			        WHEN TS.SITE_TYPE = 'PLANT' THEN '' -- Plant 도착은 NULL 처리
			        ELSE IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) 
			   END AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT
              ,IIF(CPS.ITEM_ID IS NULL,'',A.FROM_SCM_SITE_ID) AS CELL_PROD_SITE_ID
              ,TS.SITE_TYPE AS FLAG
		INTO   #SCP_INTRANSIT_I
		FROM   SCM_DNM_INTRANSIT_V  A WITH (NOLOCK)
        INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP_ID FROM SCM_MST_FINAL_ITEM_V WITH (NOLOCK)) FI
            ON   A.DIVISION_ID          = FI.DIVISION_ID
            AND  A.ITEM_ID              = FI.ITEM_ID
            AND  FI.OPERATION_GROUP_ID <> 'E' -- 전극 모델은 제외

        INNER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, OPERATION_GROUP
                    FROM   SCM_MST_SITE WITH (NOLOCK) 
                    WHERE  DIVISION_ID = @p_division_id
                    AND    SITE_TYPE   = 'PLANT' 
                    AND    OPERATION_GROUP IN ('A', 'P') -- FROM_SITE 가 전극인 정보 제외
					AND    VALID_YN    = 'Y'	
                    )  FS
            ON   A.DIVISION_ID          = FS.DIVISION_ID
            AND  A.FROM_SCM_SITE_ID     = FS.SCM_SITE_ID
			AND ((FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' )      -- 소형은 CEll Biz 용 Demand 만 처리
				OR  (FS.DIVISION_ID <> '40' )
				)	
			   
        INNER JOIN SCM_MST_SITE TS WITH (NOLOCK) 
            ON  A.DIVISION_ID    = TS.DIVISION_ID
            AND A.TO_SCM_SITE_ID = TS.SCM_SITE_ID
            AND TS.VALID_YN       = 'Y'	
			AND ((TS.DIVISION_ID  = '40' AND TS.SITE_TYPE = 'SALES' )      -- 소형은 CEll Biz 용 Demand 만 처리
				OR  (TS.DIVISION_ID <> '40' )
				)	
        LEFT OUTER JOIN @CELL_PROD_SITE CPS 
            ON  1=1
            AND A.TO_SCM_SITE_ID = CPS.SALES_SITE_ID
            AND A.ITEM_ID        = CPS.ITEM_ID
        WHERE  1=1
        AND    A.DIVISION_ID   = @p_division_id
        AND    A.RESULT_DATE   = @V_CUTOFF_DAY
		AND    A.RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고 - 속도 이슈로 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리
		AND	   A.TO_SCM_SITE_ID IS NOT NULL  


		ALTER TABLE #SCP_INTRANSIT_I ALTER COLUMN PROJECT_CODE VARCHAR(100) NULL;
        -- 3.2 TO SITE가 VMI 정보 : SCM_MST_VMI_INT_SLOC MAPPING 된 것
        --    - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' 사용하지 않고 동일 로직으로 별도 처리함
        INSERT INTO   #SCP_INTRANSIT_I		
		SELECT A.DIVISION_ID
              ,A.ITEM_ID
              ,MS.SCM_SITE_ID              AS TO_SCM_SITE_ID
			  ,MS.PLANT_ID
              ,'DAP'                       AS INCOTERMS -- VMI 임
              -- 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              ,CONVERT(NVARCHAR(8), DATEADD(D, 1, A.CUTOFF_DATE), 112)  AS ETA_DATE -- PLAN 시작일자로 처리	
	          ,ISNULL(A.SCM_QTY, 0)        AS DELIVERY_QTY
              ,'-'                         AS PROJECT_CODE
              , ISNULL(MSP.SCM_SITE_ID,'') AS CELL_PROD_SITE_ID
              ,'SALES'                     AS FLAG
        FROM   #INVENTORY_ORG A
		-- FROM   SCM_DNM_STOCK  A WITH (NOLOCK)
        INNER JOIN SCM_MST_VMI_INT_SLOC MS WITH(NOLOCK)
            ON    A.DIVISION_ID = MS.DIVISION_ID	
            AND   A.PLANT_ID    = MS.PLANT_ID
            AND   A.STORAGE_ID  = MS.STORAGE_ID
            AND   MS.VALID_YN   = 'Y'
			AND   MS.SCM_SITE_ID IS NOT NULL
            --소형 생산지 구분을 위한 분리
        INNER JOIN SCM_MST_SITE MSS WITH(NOLOCK)
            ON A.PLANT_ID = MSS.PLANT_ID
        LEFT OUTER JOIN @OCV_EXCEPT_LIST OCV
            ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
            AND A.MES_ITEM_ID = OCV.ITEM_ID
        LEFT OUTER JOIN @CELL_PROD_SITE CPS 
            ON  1=1
            AND A.SCM_SITE_ID = CPS.SALES_SITE_ID
            AND A.ITEM_ID     = CPS.ITEM_ID
        LEFT OUTER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID,PLANT_ID
                            FROM   SCM_MST_SITE  WITH(NOLOCK)
	                	    WHERE  1=1
                            AND    PLANT_ID IS NOT NULL
                        ) MSP
            ON  1=1
            AND A.DIVISION_ID                  = MSP.DIVISION_ID
            AND A.PLANT_ID+CPS.OPERATION_GROUP = MSP.SCM_SITE_ID
		WHERE  1 = 1		
        AND    A.CUTOFF_DATE      = @V_CUTOFF_DAY
        AND    A.DIVISION_ID      = @p_division_id
        AND    OCV.ITEM_ID        IS NULL
		-- 소형은 CEll Biz 용 Demand 만 처리
		AND ((A.DIVISION_ID  = '40' AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
			OR  (A.DIVISION_ID <> '40' )
			)




		--------------------------------------------------------
        -- INCOTERMS가 있는 DM정보와, 없는 DM정보를 각각 가져옴 -> DUE DATE가 가장 빠른 날짜 기준
        -- 2025.06.26 Philsu Park: 엔진 Input 사용하지 않고 NET Demand 참조.
        --------------------------------------------------------
        INSERT INTO @DM_TEMP
        SELECT SITE_ID
                ,ITEM_ID
                ,INCOTERMS
                ,PROJECT_CODE
        FROM(
            SELECT SITE_ID
                    ,ITEM_ID
                    ,INCOTERMS
                    ,PROJECT_CODE
                    ,ROW_NUMBER() OVER( PARTITION BY SITE_ID,ITEM_ID,INCOTERMS,PROJECT_CODE ORDER BY MIN_DUE ) AS ROW_NUM
            FROM(
                    SELECT   SCM_SITE_ID    AS SITE_ID
                            ,ITEM_ID        AS ITEM_ID
                            ,INCOTERMS      AS INCOTERMS
                            ,PROJECT_CODE   AS PROJECT_CODE
                            ,MIN(YYYYMMDD)  AS MIN_DUE
                    FROM    #NET_DEMAND --SCP_OPT_ENG_DEMAND_SN WITH(NOLOCK) 
                    WHERE   1=1
                    AND     PROJECT_CODE IS NOT NULL --PROJECT_CODE
                    AND     INCOTERMS    IS NOT NULL --INCOTERMS
                    GROUP BY SCM_SITE_ID, ITEM_ID, INCOTERMS, PROJECT_CODE
                    /* SELECT ATTRIBUTE1    AS SITE_ID
                        ,ATTRIBUTE2    AS ITEM_ID
                        ,ATTRIBUTE4    AS INCOTERMS
                        ,ATTRIBUTE5    AS PROJECT_CODE
                        ,MIN(DUE_DATE) AS MIN_DUE          
                    FROM SCP_OPT_ENG_DEMAND_SN WITH(NOLOCK) 
                    WHERE   1=1
					--AND PLAN_ID = @V_PLAN_ID
                    AND     ATTRIBUTE5 IS NOT NULL --PROJECT_CODE
                    AND     ATTRIBUTE4 IS NOT NULL --INCOTERMS
                    GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4,ATTRIBUTE5 */
                    ) DM
            ) RM
        WHERE ROW_NUM =1
        /* UNION ALL
        SELECT SITE_ID
                ,ITEM_ID
                ,INCOTERMS
                ,PROJECT_CODE
        FROM(
            SELECT SITE_ID
                    ,ITEM_ID
                    ,INCOTERMS
                    ,PROJECT_CODE
                    ,ROW_NUMBER() OVER( PARTITION BY SITE_ID,ITEM_ID,PROJECT_CODE ORDER BY MIN_DUE ) AS ROW_NUM
            FROM(
                    SELECT ATTRIBUTE1    AS SITE_ID
                        ,ATTRIBUTE2    AS ITEM_ID
                        ,NULL          AS INCOTERMS
                        ,ATTRIBUTE5    AS PROJECT_CODE
                        ,MIN(DUE_DATE) AS MIN_DUE          
                    FROM SCP_OPT_ENG_DEMAND_SN WITH(NOLOCK) 
                    WHERE   1=1
					--AND     PLAN_ID = @V_PLAN_ID
                    AND     ATTRIBUTE5 IS NOT NULL
                    AND     ATTRIBUTE4 IS NULL
                    GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE5
                    ) DM
            ) RM
        WHERE ROW_NUM =1 */
        --------------------------------------------------------
        -- #SCP_INVENTORY_I 프로젝트 UPDATE
        --------------------------------------------------------
        UPDATE #SCP_INVENTORY_I
        SET #SCP_INVENTORY_I.PROJECT_CODE = DJ.PROJECT_CODE
        FROM #SCP_INVENTORY_I INV
        INNER JOIN(
                    SELECT INV.DIVISION_ID
                            ,INV.SCM_SITE_ID
                            ,INV.PLANT_ID
                            ,INV.INCOTERMS
                            ,INV.STOCK_TYPE
                            ,INV.ITEM_ID
                            ,INV.MDF_ITEM_ID
                            ,INV.AVAILABLE_DATE
                            ,INV.QTY
                            ,INV.WIPHOLD_YN
                            ,INV.SITE_TYPE
                            ,INV.LOCATION_CODE
                            ,DT.PROJECT_CODE
                    FROM(
                        SELECT  INV.DIVISION_ID
                                ,INV.SCM_SITE_ID
                                ,INV.PLANT_ID
                                ,INV.INCOTERMS
                                ,INV.STOCK_TYPE
                                ,INV.ITEM_ID
                                ,IIF(LU.SEGMENT3 IS NULL, INV.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID
                                ,INV.AVAILABLE_DATE
                                ,INV.QTY
                                ,INV.WIPHOLD_YN
                                ,INV.SITE_TYPE
                                ,INV.location_code
                        FROM    #SCP_INVENTORY_I INV WITH(NOLOCK)
                            LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                AND LU.SEGMENT2 = @p_division_id
                                AND INV.ITEM_ID = LU.SEGMENT3
                                AND LU.VALID_YN = 'Y'
                        WHERE   INV.FLAG         = 'SALES'
                        AND     INV.PROJECT_CODE = '-'
                        AND     INV.QTY>0
                        ) INV
                        INNER JOIN @DM_TEMP DT
                            ON  INV.SCM_SITE_ID = DT.SITE_ID
                            AND INV.MDF_ITEM_ID     = DT.ITEM_ID
                            AND (   (INV.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                OR (INV.INCOTERMS = DT.INCOTERMS)
                                OR (INV.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL)
                                )
                    ) DJ
            ON  INV.DIVISION_ID    = DJ.DIVISION_ID
            AND INV.SCM_SITE_ID    = DJ.SCM_SITE_ID
            AND INV.PLANT_ID       = DJ.PLANT_ID
            AND INV.INCOTERMS      = DJ.INCOTERMS
            AND INV.STOCK_TYPE     = DJ.STOCK_TYPE
            AND INV.ITEM_ID        = DJ.ITEM_ID
            AND INV.AVAILABLE_DATE = DJ.AVAILABLE_DATE
            AND INV.QTY            = DJ.QTY
            AND INV.WIPHOLD_YN     = DJ.WIPHOLD_YN
            AND INV.SITE_TYPE      = DJ.SITE_TYPE
            AND INV.LOCATION_CODE  = DJ.LOCATION_CODE

        --------------------------------------------------------
        -- #SCP_INTRANSIT_I 프로젝트 UPDATE
        --------------------------------------------------------
        UPDATE #SCP_INTRANSIT_I
        SET #SCP_INTRANSIT_I.PROJECT_CODE = DJ.PROJECT_CODE
        FROM #SCP_INTRANSIT_I INV
        INNER JOIN (
                    SELECT INV.DIVISION_ID
                            ,INV.ITEM_ID
                            ,INV.TO_SCM_SITE_ID
                            ,INV.FROM_SCM_SITE_ID
                            ,INV.INCOTERMS
                            ,INV.ETA_DATE
                            ,INV.DELIVERY_QTY
                            ,INV.FLAG
                            ,DT.PROJECT_CODE
                    FROM(
                            SELECT DIVISION_ID
                                ,ITEM_ID
                                ,IIF(LU.SEGMENT3 IS NULL, INV.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID
                                ,TO_SCM_SITE_ID
								,FROM_SCM_SITE_ID
                                ,INCOTERMS
                                ,ETA_DATE
                                ,DELIVERY_QTY
                                ,PROJECT_CODE
                                ,FLAG
                            FROM #SCP_INTRANSIT_I INV -- WHERE PROJECT_CODE = '-' AND FLAG ='SALES'
                                LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                    ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                    AND LU.SEGMENT2 = @p_division_id
                                    AND INV.ITEM_ID = LU.SEGMENT3
                                    AND LU.VALID_YN = 'Y'
                            WHERE   INV.FLAG         = 'SALES'
                            AND     INV.PROJECT_CODE = '-'
                            AND     INV.DELIVERY_QTY>0
                            ) INV
                        INNER JOIN @DM_TEMP DT
                            ON  INV.TO_SCM_SITE_ID = DT.SITE_ID
                            AND INV.MDF_ITEM_ID    = DT.ITEM_ID
                            AND (   (INV.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                    OR (INV.INCOTERMS = DT.INCOTERMS)
                                    OR (INV.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL)
                                )
                    )DJ
            ON  INV.DIVISION_ID			= DJ.DIVISION_ID
            AND INV.ITEM_ID				= DJ.ITEM_ID
            AND INV.TO_SCM_SITE_ID		= DJ.TO_SCM_SITE_ID
            AND INV.FROM_SCM_SITE_ID	= DJ.FROM_SCM_SITE_ID
            AND INV.INCOTERMS			= DJ.INCOTERMS
            AND INV.ETA_DATE			= DJ.ETA_DATE
            AND INV.DELIVERY_QTY		= DJ.DELIVERY_QTY
            AND INV.FLAG				= DJ.FLAG

        -- CA별 CP 정보
		SELECT M.DIVISION_ID
			,M.PLANT_ID
			,M.ITEM_ID_ASSY
			,M.ITEM_ID_PROD
			,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
											,M.ITEM_ID_ASSY
											,M.PLANT_ID
									ORDER BY M.VALID_YN DESC 
											,M.ITEM_ID_PROD) PRIORITY_1ST
			,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
											,M.ITEM_ID_ASSY
									ORDER BY M.VALID_YN DESC 
											,M.ITEM_ID_PROD) PRIORITY_2ND
			,ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY
									ORDER BY M.VALID_YN DESC 
											,M.ITEM_ID_PROD) PRIORITY_3RD
		INTO #CP_INFO
		FROM SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK)
		WHERE 1=1
			AND M.VALID_YN = 'Y' ;



		SELECT *, CHG_QTY AS PRE_CHG_QTY, CHG_RSN AS PRE_CHG_RSN
		FROM (
		SELECT 
			@p_division_id			 AS DIVISION_ID
			,@p_plan_start_yyyymmdd  AS CUTOFF_YYYYMMDD
			,a.STOCK_TYPE			 AS SRCE_DIVS_CD
			,a.STOCK_TYPE
			,d.SEGMENT2				 AS STOCK_TYPE_NAME
			,a.PROJECT_CODE 
			,c.NICK_NAME	--Nick Name 추가 (2025-07-14)
			,a.ITEM_ID
			,a.INCOTERMS
			,a.PLANT_ID				AS FROM_SITE_ID 
			,a.SITE_ID				AS SCM_SITE_ID
			--,a.LOCATION_CODE			--[PJ2025732]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-23)
			,CONVERT(date, a.EFECTIVE_DATE, 112)		AS INV_DATE 
			,a.QTY
			, b.CHG_QTY
			, b.CHG_RSN
			, B.CHG_TYPE
			, ISNULL(b.LAST_UPDATED_BY, '') AS LAST_UPDATED_BY
			, ISNULL(b.LAST_UPDATE_DATE, NULL) AS LAST_UPDATE_DATE
		FROM (
			SELECT SITE_ID
					, PLANT_ID
					, ITEM_ID
					, EFECTIVE_DATE
					, STOCK_TYPE
					--, LOCATION_CODE		--[PJ2025732]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-23)
					, SUM(QTY) AS QTY
					, INCOTERMS
					, PROJECT_CODE
					, CELL_PROD_SITE_ID
			FROM (
				SELECT A.SCM_SITE_ID AS SITE_ID	
						, A.PLANT_ID
						, CASE --> 활성화 완료 ASSY Item 재고 : 'CHAR' 버퍼 재고로 처리하고 CHAR Item 으로 Update 처리함
            				WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND a.DESCR LIKE 'WH%' AND A.LOCATION_CODE = '-' AND A.ITEM_ID NOT LIKE 'MA%'	--[PJ20257329]MA 재고에 대해서는 AGING으로 놔두고 MU, MJ...에 대해서는 CHAR로 변환 (2025-10-21)
									THEN ISNULL(ISNULL(ISNULL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD),C3.ITEM_ID_PROD), A.ITEM_ID) 
            				ELSE A.ITEM_ID 
						  END ITEM_ID 
						, CONVERT(VARCHAR(8), ISNULL(A.EFFSTARTDATE, CONVERT(DATETIME, @P_PLAN_NAME)), 112) AS EFECTIVE_DATE
						, A.DESCR AS STOCK_TYPE
						, A.LOCATION_CODE	--[PJ2025732]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-23)
						, QTY AS QTY
            			, INCOTERMS 
						, PROJECT_CODE
						, CELL_PROD_SITE_ID
				FROM   (
						SELECT DIVISION_ID, ITEM_ID, SCM_SITE_ID AS SCM_SITE_ID, PLANT_ID
            					, INCOTERMS 
								,  CONVERT(DATE, CONVERT(CHAR(8), AVAILABLE_DATE, 112))   AS EFFSTARTDATE
								, SUM(QTY)        AS QTY					  
								, CASE WHEN ISNULL(T.WIPHOLD_YN, 'N') = 'N' THEN 'WH'
									ELSE 'WH_HOLD'
								END  AS DESCR
								, location_code
								, PROJECT_CODE
								, CELL_PROD_SITE_ID
								, FLAG
						FROM   #SCP_INVENTORY_I T WITH(NOLOCK)
						WHERE  1=1
						AND    T.STOCK_TYPE <> 'FOR' 
						GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, CONVERT(CHAR(8), AVAILABLE_DATE, 112), ISNULL(T.WIPHOLD_YN, 'N'), INCOTERMS, location_code, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID, PLANT_ID
            			HAVING SUM(T.QTY) > 0		      
            			UNION ALL
						-- 활성화 재고 : FOR 로 처리
						SELECT DIVISION_ID, ITEM_ID, SCM_SITE_ID AS SCM_SITE_ID, PLANT_ID
            					, INCOTERMS 
								, CONVERT(DATE, CONVERT(CHAR(8), AVAILABLE_DATE, 112))   AS EFFSTARTDATE
								, SUM(QTY)       AS QTY
								, CASE WHEN ISNULL(T.WIPHOLD_YN, 'N') = 'N' THEN 'FOR'
									ELSE 'FOR_HOLD'
								END  AS DESCR
								, location_code
								, PROJECT_CODE
								, CELL_PROD_SITE_ID
								, FLAG
						FROM   #SCP_INVENTORY_I T WITH(NOLOCK)
						WHERE  1=1
						AND    T.STOCK_TYPE  = 'FOR' -- 활성화 재고
						AND    T.QTY         > 0 
						GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, CONVERT(CHAR(8), AVAILABLE_DATE, 112), ISNULL(T.WIPHOLD_YN, 'N'), INCOTERMS , location_code, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID, PLANT_ID
						UNION ALL
						-- INTRANSIT SHIPMENT 재고 
						SELECT DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID AS SCM_SITE_ID, FROM_SCM_SITE_ID
            					, INCOTERMS 
								,  CONVERT(DATETIME, ETA_DATE)  AS EFFSTARTDATE
								, SUM(DELIVERY_QTY)             AS QTY
								, 'INT'                         AS DESCR    
								, '-'                           AS location_code
								, PROJECT_CODE
								, CELL_PROD_SITE_ID
								, FLAG
						FROM   #SCP_INTRANSIT_I T WITH(NOLOCK)
						WHERE  1=1
						AND    T.DELIVERY_QTY  > 0 
						AND   (T.ETA_DATE IS NOT NULL OR T.ETA_DATE <> '')
						GROUP BY DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID, ETA_DATE, INCOTERMS, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID, FROM_SCM_SITE_ID
            
						) A
            
				LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
								--, * 
							FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK) 
							WHERE  DIVISION_ID = @p_division_id  
							AND    OPERATION_GROUP IN ('A', 'P')  
							) B
				ON    A.ITEM_ID     = B.ITEM_ID
				AND   A.DIVISION_ID = B.DIVISION_ID 

				LEFT  JOIN SCM_MST_SITE FS WITH(NOLOCK)
						ON FS.DIVISION_ID = A.DIVISION_ID
						AND FS.SCM_SITE_ID = A.SCM_SITE_ID
						AND FS.SITE_TYPE   = 'PLANT'
				LEFT  JOIN #CP_INFO C1
						ON  C1.DIVISION_ID	= A.DIVISION_ID
						AND C1.PLANT_ID		= FS.PLANT_ID
						AND C1.ITEM_ID_ASSY	= A.ITEM_ID
						AND C1.PRIORITY_1ST	= 1
				LEFT  JOIN #CP_INFO C2
						ON  C2.DIVISION_ID	= A.DIVISION_ID
						AND C2.ITEM_ID_ASSY	= A.ITEM_ID
						AND C2.PRIORITY_2ND	= 1
				LEFT  JOIN #CP_INFO C3
						ON  C3.ITEM_ID_ASSY	= A.ITEM_ID
						AND C3.PRIORITY_3RD	= 1            
				--SUBMDLE의 STAGE를 찾기 위해 추가
				LEFT  JOIN (
							SELECT  SM.DIVISION_ID
									,SM.SCM_SITE_ID
									,IM.ITEM_ID
									,IM.SCP_FLOW_ID
									,IM.SCP_OPERATION_GROUP
							FROM    SCM_ITEM_M_SN IM WITH(NOLOCK) 
								INNER JOIN SCM_MST_SITE SM WITH(NOLOCK)
									ON  IM.COMPANY_ID = SM.COMPANY_ID
									AND IM.SCP_OPERATION_GROUP = SM.OPERATION_GROUP
							WHERE   1=1
							AND     IM.SCP_FLOW_ID NOT IN ('P5500', 'P9500') -- SUBMDLE만 걸리도록
							AND     IM.SCP_OPERATION_GROUP = 'P'             -- SUBMDLE만 걸리도록
							) SMC
						ON  A.DIVISION_ID = SMC.DIVISION_ID
						AND A.SCM_SITE_ID = SMC.SCM_SITE_ID
						AND A.ITEM_ID     = SMC.ITEM_ID
				WHERE  1=1
			) AA	--최종 ITEM_ID 별 GROUP BY 
			GROUP BY SITE_ID, PLANT_ID, ITEM_ID, EFECTIVE_DATE, STOCK_TYPE, INCOTERMS, PROJECT_CODE , CELL_PROD_SITE_ID--, location_code
		) AS A
		LEFT JOIN SCP_OPMZ_INV_ADJ b WITH(NOLOCK)
			ON b.DIVISION_ID = @p_division_id AND b.CUTOFF_YYYYMMDD = @p_plan_start_yyyymmdd
			AND a.STOCK_TYPE = b.STOCK_TYPE AND a.PROJECT_CODE = b.PROJECT_CODE AND a.SITE_ID = b.SCM_SITE_ID AND a.ITEM_ID = b.ITEM_ID
			AND a.INCOTERMS = b.INCOTERMS AND a.EFECTIVE_DATE = b.INV_DATE
		LEFT JOIN (
					SELECT DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME
					FROM SCM_MST_ITEM_SN WITH(NOLOCK)
					GROUP BY  DIVISION_ID, ITEM_ID
			) c
			ON c.DIVISION_ID = @p_division_id AND c.ITEM_ID = a.ITEM_ID
		LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL d WITH(NOLOCK) ON LOOKUP_TYPE = 'STOCK_TYPE' AND d.SEGMENT1 = a.STOCK_TYPE
		WHERE 1=1
		AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.ITEM_ID LIKE '%' + @p_item_id + '%' ) 
		AND ( ( @p_nick_name IS NULL OR  @p_nick_name = '' ) OR c.NICK_NAME LIKE '%' + @p_nick_name + '%' ) 

		--Insert 된 정보
		UNION ALL
		SELECT a.DIVISION_ID
			, a.CUTOFF_YYYYMMDD
			, a.SRCE_DIVS_CD
			, a.STOCK_TYPE
			, d.SEGMENT2 AS STOCK_TYPE_NAME
			, a.PROJECT_CODE
			, c.NICK_NAME	--Nick Name 추가 (2025-07-14)
			, a.ITEM_ID
			, a.INCOTERMS
			, a.FROM_SITE_ID 
			, a.SCM_SITE_ID
			--, a.LOCATION_CODE			--[PJ2025732]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-23)
			, CONVERT(date, a.INV_DATE, 112) AS INV_DATE		-- 기준일자
			, a.QTY
			, a.CHG_QTY
			, a.CHG_RSN
			, a.CHG_TYPE
			, ISNULL(a.LAST_UPDATED_BY, '') AS LAST_UPDATED_BY
			, ISNULL(a.LAST_UPDATE_DATE, NULL) AS LAST_UPDATE_DATE
		FROM SCP_OPMZ_INV_ADJ a WITH(NOLOCK)
		LEFT JOIN (
					SELECT DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME
					FROM SCM_MST_ITEM_SN WITH(NOLOCK)
					GROUP BY  DIVISION_ID, ITEM_ID
			) c
			ON c.DIVISION_ID = a.DIVISION_ID AND c.ITEM_ID = a.ITEM_ID
		LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL d WITH(NOLOCK) ON LOOKUP_TYPE = 'STOCK_TYPE' AND d.SEGMENT1 = a.STOCK_TYPE
		WHERE 1=1
		AND a.CHG_TYPE = 'New'
		AND a.DIVISION_ID = @p_division_id
		AND a.CUTOFF_YYYYMMDD = @p_plan_start_yyyymmdd
		AND a.LOCATION_CODE NOT IN ( 'COATING', 'SLITTING'     -- 전극 공정
									,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING' -- 셀공정 : PACKAGING 이전
									)
		AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.ITEM_ID LIKE '%' + @p_item_id + '%' ) 
		AND ( ( @p_nick_name IS NULL OR  @p_nick_name = '' ) OR c.NICK_NAME LIKE '%' + @p_nick_name + '%' ) 
		) STOCK
		ORDER BY DIVISION_ID, CUTOFF_YYYYMMDD, ITEM_ID, STOCK_TYPE, STOCK_TYPE_NAME, PROJECT_CODE, SCM_SITE_ID, INCOTERMS, INV_DATE

        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------		

		IF OBJECT_ID('TEMPDB..#SCP_INVENTORY_I') IS NOT NULL
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
		END;
  
END

