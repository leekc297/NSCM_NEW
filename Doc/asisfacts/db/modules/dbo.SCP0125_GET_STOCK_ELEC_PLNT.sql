


/*
 * Program ID   : SCP0125_GET_STOCK_ELEC_PLNT
 * Description  : Workbench - Stock(Elec. Plant) 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/09/15   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 *
 */

CREATE PROCEDURE [dbo].[SCP0125_GET_STOCK_ELEC_PLNT]
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
	DECLARE @D_PLAN_NAME         DATETIME;
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

	SELECT  @MAX_TUESDAY = MAX(BASIS_YYYYMMDD)
    FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK) 
    WHERE   BASIS_YYYYMMDD <= CONVERT(NVARCHAR(8),GETDATE(),112)
    AND     DAYOFWEEK = 'TUE'

	SELECT @P_MODELING_ID       = MODELING_ID FROM SCM_MST_MODELING WITH(NOLOCK) WHERE PLAN_CYCLE = 'WEEKLY' AND DIVISION_ID = @p_division_id;
    SELECT @P_PLAN_NAME         = @p_plan_start_yyyymmdd ;		-- 당주 월요일 YYYYMMDD
    SELECT @P_PLAN_NAME         = @p_plan_start_yyyymmdd ;		-- 당주 월요일 YYYYMMDD
    SELECT @V_CUTOFF_DAY        = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(DATETIME, @p_plan_start_yyyymmdd)), 112) ;	-- 지난주 일요일 YYYYMMDD
    SELECT @D_CUTOFF_DAY        = CONVERT(DATETIME, @V_CUTOFF_DAY)
    --SELECT @V_DEMAND_CUTOFF_DAY = @MAX_TUESDAY; -- 당주 화요일 YYYYMMDD
    SELECT @V_DEMAND_CUTOFF_DAY  = ISNULL(MAX(P.CUTOFF_YYYYMMDD),@MAX_TUESDAY)	-- 당주 화요일 YYYYMMDD
                                FROM   DM_PLN_NET_DEMAND P WITH(NOLOCK)
                                WHERE  P.DIVISION_ID      = @p_division_id 
                                AND    P.CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -3, @D_PLAN_NAME), 112) -- 월요일 기준 최근 3일 이내									
                                AND    P.CUTOFF_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +6, @D_PLAN_NAME), 112) -- 해당 주차 일요일 이전



	INSERT INTO @MAT_CONST_TEMP
    SELECT   ATTRIBUTE1 AS MAT_ID
            ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(ATTRIBUTE3)),112) AS EFF_END_DATE
    FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
    WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
    AND      LU.VALID_YN    = 'Y'
    AND      LU.SEGMENT2    = @p_division_id
    GROUP BY ATTRIBUTE1

	IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
	BEGIN 
		DROP TABLE  #DIVISION;
	END;

	SELECT DIVISION_ID 
	INTO #DIVISION
	FROM SCM_MST_DIVISION WITH(NOLOCK)
	WHERE  VALID_YN = 'Y'
	AND    ATTRIBUTE3 <> 'EE'
	AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id) -- 전극 Division 변수
	;


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

    IF OBJECT_ID('TEMPDB..#NET_DEMAND') IS NOT NULL
	BEGIN 
		DROP TABLE  #NET_DEMAND;
	END;

    IF OBJECT_ID('TEMPDB..#INVENTORY_ORG') IS NOT NULL
	BEGIN 
		DROP TABLE  #INVENTORY_ORG;
	END;

    --------------------------------------------------------
    -- 속도개선을 위한 DEMAND 참조 TEMP 처리.
    --------------------------------------------------------

    SELECT    A.DIVISION_ID
            , A.CUTOFF_DATE
            , A.PLANT_ID
            , A.SITE_ID
            , A.SCM_SITE_ID
			, A.LOCATION_CODE
			, A.PRODUCTION_TYPE
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
	AND		(( A.DIVISION_ID = '40' AND ( A.PRODUCTION_TYPE IS NULL OR A.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE') ) )
			OR ( A.DIVISION_ID <> '40' ))		--div 40일 경우 production_type : 'MASS', 'C-MASS', 'M-SAMPLE' 만 조회(NULL 포함)
    AND     A.SCM_SITE_ID     IS NOT NULL
    AND     ITM.SCP_FLOW_ID   IS NOT NULL
    GROUP BY  A.DIVISION_ID
            , A.CUTOFF_DATE
            , A.PLANT_ID
            , A.SITE_ID
            , A.SCM_SITE_ID
            , A.LOCATION_CODE
			, A.PRODUCTION_TYPE
            , A.STOCK_TYPE
            , A.ITEM_ID
            , A.MES_ITEM_ID
            , A.WIPHOLD_YN
            , A.AVAILABLE_DATE
            , A.OPERATION_ID
            , A.STORAGE_ID
    ;


    -- 1.4 PLANT 재고
	--INSERT INTO   #SCP_INVENTORY_I
	SELECT A.DIVISION_ID   AS DIVISION_ID
		,A.SCM_SITE_ID   AS SCM_SITE_ID 
		,A.PLANT_ID
		,CASE WHEN B.OPERATION_GROUP = 'E' THEN '-' 
            ELSE 'DAP'
        END AS INCOTERMS
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
		, A.LOCATION_CODE AS LOCATION_CODE -- PLANT 재고 구분용 정보
        ,CASE WHEN B.OPERATION_GROUP = 'E' THEN '' 
            ELSE '-'
        END AS PROJECT_CODE
        ,'PLANT' AS FLAG
	INTO   #SCP_INVENTORY_I
    FROM   #INVENTORY_ORG A
	INNER JOIN (SELECT DISTINCT S.DIVISION_ID, S.SCM_SITE_ID, S.SITE_TYPE, S.OPERATION_GROUP
				FROM   SCM_MST_SITE S WITH(NOLOCK)

				INNER JOIN #DIVISION D WITH(NOLOCK)
				ON S.DIVISION_ID = D.DIVISION_ID

				WHERE  1=1
				AND    S.SITE_TYPE        = 'PLANT'
				AND    S.OPERATION_GROUP IN ('E', 'A')
            ) B
		ON     A.DIVISION_ID      = B.DIVISION_ID
		AND    A.SCM_SITE_ID      = B.SCM_SITE_ID
	WHERE  1 = 1		
    AND    A.CUTOFF_DATE      = @V_CUTOFF_DAY
    AND    A.LOCATION_CODE IN ( 'COATING', 'SLITTING'     -- 전극 공정
                                ,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING' -- 셀공정 : PACKAGING 이전
                                )
	AND	  (( A.DIVISION_ID = '40' AND ( A.PRODUCTION_TYPE IS NULL OR A.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE') ) )
		  OR ( A.DIVISION_ID <> '40' ))		--div 40일 경우 production_type : 'MASS', 'C-MASS', 'M-SAMPLE' 만 조회(NULL 포함)
	;

    
	--------------------------------------------------------
    -- INCOTERMS가 있는 DM정보와, 없는 DM정보를 각각 가져옴 -> DUE DATE가 가장 빠른 날짜 기준
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
            SELECT ATTRIBUTE1    AS SITE_ID
                ,ATTRIBUTE2    AS ITEM_ID
                ,ATTRIBUTE4    AS INCOTERMS
                ,ATTRIBUTE5    AS PROJECT_CODE
                ,MIN(DUE_DATE) AS MIN_DUE          
            FROM SCP_OPT_ENG_DEMAND_SN WITH(NOLOCK) 
            WHERE   1=1--PLAN_ID = @V_PLAN_ID
            AND     ATTRIBUTE5 IS NOT NULL --PROJECT_CODE
            AND     ATTRIBUTE4 IS NOT NULL --INCOTERMS
            GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4,ATTRIBUTE5
            ) DM
        ) RM
    WHERE ROW_NUM =1
    UNION ALL
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
            WHERE   1=1--PLAN_ID = @V_PLAN_ID
            AND     ATTRIBUTE5 IS NOT NULL
            AND     ATTRIBUTE4 IS NULL
            GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE5
            ) DM
        ) RM
    WHERE ROW_NUM =1

    --------------------------------------------------------
    -- #SCP_INVENTORY_I 프로젝트 UPDATE
    --------------------------------------------------------
    UPDATE #SCP_INVENTORY_I
    SET #SCP_INVENTORY_I.PROJECT_CODE = DJ.PROJECT_CODE
    FROM #SCP_INVENTORY_I INV
    INNER JOIN(
                SELECT INV.DIVISION_ID
                        ,INV.SCM_SITE_ID
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
        AND INV.INCOTERMS      = DJ.INCOTERMS
        AND INV.STOCK_TYPE     = DJ.STOCK_TYPE
        AND INV.ITEM_ID        = DJ.ITEM_ID
        AND INV.AVAILABLE_DATE = DJ.AVAILABLE_DATE
        AND INV.QTY            = DJ.QTY
        AND INV.WIPHOLD_YN     = DJ.WIPHOLD_YN
        AND INV.SITE_TYPE      = DJ.SITE_TYPE
        AND INV.LOCATION_CODE  = DJ.LOCATION_CODE

    



	SELECT *, CHG_QTY AS PRE_CHG_QTY, CHG_RSN AS PRE_CHG_RSN
	FROM (
	SELECT 
		@p_division_id			 AS DIVISION_ID
		,@p_plan_start_yyyymmdd  AS CUTOFF_YYYYMMDD
		,a.STOCK_TYPE			 AS SRCE_DIVS_CD
		,a.STOCK_TYPE
		,d.SEGMENT2				 AS STOCK_TYPE_NAME
		,a.PROJECT_CODE 
		,c.NICK_NAME	
		,a.ITEM_ID
		,a.INCOTERMS
		,a.PLANT_ID				AS FROM_SITE_ID 
		,a.SITE_ID				AS SCM_SITE_ID
		,a.LOCATION_CODE
		,CONVERT(date, a.EFECTIVE_DATE, 112)		AS INV_DATE 
		,a.QTY
		, b.CHG_QTY
		, b.CHG_RSN
		, b.CHG_TYPE
		, ISNULL(b.LAST_UPDATED_BY, '') AS LAST_UPDATED_BY
		, ISNULL(b.LAST_UPDATE_DATE, NULL) AS LAST_UPDATE_DATE
	FROM (
		SELECT SITE_ID
				, PLANT_ID
				, ITEM_ID
				, EFECTIVE_DATE
				, STOCK_TYPE
				, SUM(QTY) AS QTY
				, INCOTERMS
				, LOCATION_CODE
				, PROJECT_CODE
		FROM (
			SELECT A.SCM_SITE_ID AS SITE_ID	
					, A.PLANT_ID
						, CASE WHEN ISNULL(B.CHILD_ITEM_ID, '') = ''  THEN A.ITEM_ID
            				ELSE B.CHILD_ITEM_ID
						END ITEM_ID 

            			/* SITE 가 PLANT SITE 가 아니라 SALES SITE 인경우는 **** BIZ 로 STAGE 생성 */
						, CASE 
            				WHEN A.FLAG  = 'SALES'                              THEN 'ELECBIZ'
            				WHEN A.FLAG  = 'INT'                                THEN 'TARGETBIZ' -- 전극은 Cell PKG 를 Demand로 처리하므로 Cell 도착은 Sales SIte 로 취급
            				WHEN A.LOCATION_CODE NOT IN ('COATING', 'SLITTING') THEN 'TARGETBIZ' -- Cell Plant 재고 Sales SIte 로 취급
								
            				WHEN A.LOCATION_CODE = 'SLITTING' THEN 'ELEC_POST'
            				WHEN A.LOCATION_CODE = 'COATING'  THEN 'COATING'
            				ELSE '-' END STAGE 
						, CONVERT(VARCHAR(8), ISNULL(A.EFFSTARTDATE, CONVERT(DATETIME, @P_PLAN_NAME)), 112) AS EFECTIVE_DATE
						, A.DESCR AS STOCK_TYPE
						--, A.QTY AS QTY -- CELL 재고를 전극으로 전환
						, CASE WHEN ISNULL(B.CHILD_ITEM_ID, '') = ''  THEN A.QTY
            				ELSE A.QTY * ISNULL(B.USAGE, 1)
						END QTY 
            			, INCOTERMS 
						, LOCATION_CODE
						, PROJECT_CODE
			FROM   (
					SELECT DIVISION_ID, ITEM_ID, SCM_SITE_ID AS SCM_SITE_ID, PLANT_ID
            					, INCOTERMS 
								,  CONVERT(DATE, CONVERT(CHAR(8), AVAILABLE_DATE, 112))   AS EFFSTARTDATE
								, SUM(QTY)        AS QTY					  
								, CASE WHEN ISNULL(T.WIPHOLD_YN, 'N') = 'N' THEN 'WH'
									ELSE 'WH_HOLD'
								END  AS DESCR
								, LOCATION_CODE
								, PROJECT_CODE
								, FLAG
					FROM   #SCP_INVENTORY_I T WITH(NOLOCK)
					WHERE  1=1
						GROUP 
            				BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, CONVERT(CHAR(8), AVAILABLE_DATE, 112), ISNULL(T.WIPHOLD_YN, 'N'), INCOTERMS, LOCATION_CODE, PROJECT_CODE, FLAG, PLANT_ID
            		HAVING SUM(T.QTY) > 0		      
            		
            
					) A

				-- CELL 재고를 전극으로 전환하기 위한 정보
				LEFT JOIN (
							SELECT PARENT_ITEM_ID, CHILD_ITEM_ID, MAX(USAGE) AS USAGE
							FROM   SCP_OPT_ENG_BOM_ELEC_SN LU WITH(NOLOCK)
							WHERE  1=1--PLAN_ID = @V_PLAN_ID
							AND    SCP_YN  = 'Y'
							GROUP BY PARENT_ITEM_ID, CHILD_ITEM_ID 
							) B
				ON A.ITEM_ID = B.PARENT_ITEM_ID
			   
				LEFT JOIN SCM_MST_SITE TS WITH (NOLOCK) 
				ON  A.DIVISION_ID = TS.DIVISION_ID
				AND A.SCM_SITE_ID = TS.SCM_SITE_ID
				AND TS.VALID_YN   = 'Y'	

				WHERE  1=1
                ---------------------------------------------------------------------------------------
                -- Demand Exception 대상 중 STOCK_EXCEPTION Flag = 'Y' 인 경우 재고 반영 제외.
                ---------------------------------------------------------------------------------------
                --AND NOT EXISTS (SELECT 1
                --                FROM    (   SELECT  DISTINCT 
                --                                    ISNULL(B.CHILD_ITEM_ID, LV.SEGMENT4)   AS ELEC_ITEM_ID
                --                            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                --                            LEFT OUTER JOIN SCP_MST_BOM_ELEC B WITH (NOLOCK) 
                --                                ON  LV.SEGMENT4 = B.PARENT_ITEM_ID -- ASSY Item
                --                                AND B.SCP_YN    = 'Y'
                --                            WHERE   LV.LOOKUP_TYPE  = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                --                            AND     LV.VALID_YN     = 'Y'
                --                            AND     LV.SEGMENT2     = @p_division_id
                --                            AND     LV.ATTRIBUTE1   = 'ASSY' -- CELL PLAN 제외
                --                            AND     LV.ATTRIBUTE4   = 'Y'    -- STOCK_EXCEPTION
                --                            ) INV_EXCEPTION
                --                WHERE   1=1
                --                AND     INV_EXCEPTION.ELEC_ITEM_ID  = A.ITEM_ID
                --                )
		) AA	--최종 ITEM_ID 별 GROUP BY 
		GROUP BY SITE_ID, PLANT_ID, ITEM_ID, EFECTIVE_DATE, STOCK_TYPE, INCOTERMS, PROJECT_CODE , LOCATION_CODE
	) AS A
	--LEFT JOIN SCP_OPMZ_INV_ELEC_PLNT b WITH(NOLOCK)
	LEFT JOIN SCP_OPMZ_INV_ADJ b WITH(NOLOCK)
		ON b.DIVISION_ID = @p_division_id AND b.CUTOFF_YYYYMMDD = @p_plan_start_yyyymmdd
		AND a.STOCK_TYPE = b.STOCK_TYPE AND a.PROJECT_CODE = b.PROJECT_CODE AND a.SITE_ID = b.SCM_SITE_ID AND a.ITEM_ID = b.ITEM_ID
		AND a.INCOTERMS = b.INCOTERMS AND a.EFECTIVE_DATE = b.INV_DATE AND a.LOCATION_CODE = b.LOCATION_CODE
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
		, c.NICK_NAME	
		, a.ITEM_ID
		, a.INCOTERMS
		, a.FROM_SITE_ID 
		, a.SCM_SITE_ID
		, a.LOCATION_CODE
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
    AND a.LOCATION_CODE IN ( 'COATING', 'SLITTING'     -- 전극 공정
                            ,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING' -- 셀공정 : PACKAGING 이전
                            )
	AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.ITEM_ID LIKE '%' + @p_item_id + '%' ) 
	AND ( ( @p_nick_name IS NULL OR  @p_nick_name = '' ) OR c.NICK_NAME LIKE '%' + @p_nick_name + '%' ) 
	) STOCK
	ORDER BY DIVISION_ID, CUTOFF_YYYYMMDD, ITEM_ID, STOCK_TYPE, STOCK_TYPE_NAME, PROJECT_CODE, SCM_SITE_ID, INCOTERMS, LOCATION_CODE, INV_DATE

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
  
END

