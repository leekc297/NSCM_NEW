



/*
 * Program ID   : SCP0053_GET_SCP_BOM
 * Description  : SCP BOM 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/03/11   PJG                     Initial Release (PJ20209642 Digital SCM Level.3 달성을 위한 개선)
 * 2021/04/30   PJG                     MODEL_NAME, PARENT_ITEM_NAME, CHILD_ITEM_NAME 을 NICK_NAME 으로 변경
 * 2022/10/25   jahn1501   		        PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Simulator Alt Priority, Simulator SCP YN 컬럼 추가
 * 2023/06/15   chaan			V1.1.1  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 활성화 코드 분리
 * 2025.07.24   hrkim					PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : 하드 코딩 공정 조건 변경 (SCP_PLAN_OPERATION lookup 참조) 
 *
 */

CREATE PROCEDURE [dbo].[SCP0053_GET_SCP_BOM_TW_20250813]
      @p_division_id        NVARCHAR(MAX)
    , @p_plant_site_id		NVARCHAR(MAX)
    , @p_model_id   		NVARCHAR(MAX)
    , @p_parent_id          NVARCHAR(MAX)
    , @p_child_id           NVARCHAR(MAX)
    , @p_alter_bom          NVARCHAR(MAX)
    , @debug_mode			NVARCHAR(20)        = 'F'
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


    --DECLARE @p_division_id      NVARCHAR(MAX)       = N'81'
    --DECLARE @p_plant_site_id    NVARCHAR(MAX)       = N''
    --DECLARE @p_model_id         NVARCHAR(MAX)       = N'APFMCCX48-A1'
    --DECLARE @p_parent_id        NVARCHAR(MAX)       = N''
    --DECLARE @p_child_id         NVARCHAR(MAX)       = N''
    --DECLARE @p_alter_bom        NVARCHAR(MAX)       = N'ALL'
    --DECLARE @debug_mode			NVARCHAR(20)        = N'F'

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final 공정 정보 - Cell Packaging/Assembly' 
	-- 2025.07.24 하드 코딩 공정 조건 변경 (SCP_PLAN_OPERATION lookup 참조)   
	------------------------------------------------------------------------------------------------------------------
	 DECLARE @SCP_CELL_FINAL_OPERATION TABLE
	 (
		   OPERATION_ID					NVARCHAR(30)	NULL
	 )

	INSERT INTO @SCP_CELL_FINAL_OPERATION
	SELECT SEGMENT1 AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'	 -- 공정그룹(Cell)
	   AND LK.ATTRIBUTE1  = 'Y'	 -- FInal Operation
	------------------------------------------------------------------------------------------------------------------

	IF OBJECT_ID (N'tempdb..#TblSCP0053_ParentItem', N'U') IS NOT NULL
		DROP TABLE #TblSCP0053_ParentItem;

    SELECT DISTINCT
            ITEM_ID
    INTO    #TblSCP0053_ParentItem
    FROM    SCM_MST_ITEM_SN
    WHERE   1=1
		AND DIVISION_ID = @p_division_id
		AND SCP_OPERATION_GROUP IN ('P', 'A')

--TESTING : NOK
--select * from #TblSCP0053_ParentItem;return;

	IF OBJECT_ID (N'tempdb..#TblSCP0053_ChildItem', N'U') IS NOT NULL
		DROP TABLE #TblSCP0053_ChildItem;

    SELECT  DISTINCT
            ITEM_ID
    INTO    #TblSCP0053_ChildItem
    FROM    SCM_MST_ITEM_SN
    WHERE   1=1
		AND DIVISION_ID = @p_division_id
		AND (SCP_OPERATION_GROUP = 'P' OR (SCP_OPERATION_GROUP = 'A' AND SCP_FLOW_ID IN (SELECT OPERATION_ID  FROM @SCP_CELL_FINAL_OPERATION))) -- 2025.07.24 하드 코딩 공정 조건 변경 (SCP_PLAN_OPERATION lookup 참조)
		-- 2025.07.24 변경전 AND (SCP_OPERATION_GROUP = 'P' OR (SCP_OPERATION_GROUP = 'A' AND SCP_FLOW_ID IN ('A3000', 'A9000')))


--TESTING : NOK
--select * from #TblSCP0053_ParentItem;
--select * from #TblSCP0053_ChildItem;return;



	-- ALTER BOM 에 해당하는 것만 검색시
    IF (@p_alter_bom = 'ALTER')
	BEGIN
	    PRINT 'ALTER';

	    IF OBJECT_ID (N'tempdb..#TblSCP0053_AlterRaw', N'U') IS NOT NULL
		    DROP TABLE #TblSCP0053_AlterRaw;

        SELECT    A.DIVISION_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.MODEL_ID
                , A.PARENT_ITEM_ID
                , A.CHILD_ITEM_ID
                , MIN(A.CHILD_QTY) AS CHILD_QTY
                , MIN(A.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
                , MIN(A.SORT_ORDER) AS SORT_ORDER
                , CONVERT(int, MIN(A.NLEVEL)) AS NLEVEL
                , MIN(B.SCP_OPERATION_GROUP) AS SCP_OPERATION_GROUP
                , MIN(B.SCP_FLOW_ID) AS SCP_FLOW_ID
        INTO    #TblSCP0053_AlterRaw
        FROM    SCM_MST_BOM_SN A WITH (NOLOCK)
                INNER JOIN SCM_MST_ALTER_BOM_MODEL C WITH (NOLOCK) ON
                        A.DIVISION_ID = C.DIVISION_ID
	                AND A.SITE_ID = C.SITE_ID
					AND A.PLANT_ID = C.PLANT_ID
					AND A.PARENT_ITEM_ID = C.PARENT_ITEM_ID
					AND A.CHILD_ITEM_ID = C.CHILD_ITEM_ID
                    AND ( (@p_plant_site_id IS NULL OR @p_plant_site_id = '') OR C.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')) )
                    AND (((@p_model_id IS NULL OR @p_model_id = '') AND (@p_parent_id IS NULL OR @p_parent_id = '') AND (@p_child_id IS NULL OR @p_child_id = '')) OR
							((C.PARENT_ITEM_ID IN (@p_model_id, @p_parent_id, @p_child_id)) OR (C.CHILD_ITEM_ID IN (@p_model_id, @p_parent_id, @p_child_id))))
                LEFT OUTER JOIN SCM_MST_ITEM_SN B WITH (NOLOCK) ON
                        A.DIVISION_ID = B.DIVISION_ID
                    AND A.SITE_ID = B.SITE_ID
                JOIN #TblSCP0053_ParentItem P ON
                        A.PARENT_ITEM_ID = P.ITEM_ID
                JOIN #TblSCP0053_ChildItem I ON
		                A.CHILD_ITEM_ID = I.ITEM_ID
        WHERE   1=1
            AND ( (@p_plant_site_id IS NULL OR @p_plant_site_id = '') OR A.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')) )
            AND ((@p_model_id IS NULL OR @p_model_id = '') OR (A.MODEL_ID = @p_model_id))
            AND ((@p_parent_id IS NULL OR @p_parent_id = '') OR (A.PARENT_ITEM_ID = @p_parent_id))
            AND ((@p_child_id IS NULL OR @p_child_id = '') OR (A.CHILD_ITEM_ID = @p_child_id))
            AND A.PARENT_ITEM_ID != '*'
        GROUP BY A.DIVISION_ID, A.SITE_ID , A.PLANT_ID , A.MODEL_ID , A.PARENT_ITEM_ID , A.CHILD_ITEM_ID


		SELECT    A.DIVISION_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.MODEL_ID
                , (
	                SELECT TOP 1
			                --X.ITEM_NAME
			                ISNULL(NULLIF(NICK_NAME,''),'-')
		                FROM SCM_MST_ITEM_SN X(NOLOCK)
		                WHERE X.DIVISION_ID = A.DIVISION_ID
		                AND X.ITEM_ID     = A.MODEL_ID
                ) AS MODEL_NAME
                , A.PARENT_ITEM_ID
                , (
	                SELECT TOP 1
			                --X.ITEM_NAME
			                ISNULL(NULLIF(NICK_NAME,''),'-')
		                FROM SCM_MST_ITEM_SN X(NOLOCK)
		                WHERE X.DIVISION_ID = A.DIVISION_ID
		                AND X.ITEM_ID     = A.PARENT_ITEM_ID
                ) AS PARENT_ITEM_NAME
                , A.CHILD_ITEM_ID
                , (
	                SELECT TOP 1
			                --X.ITEM_NAME
			                ISNULL(NULLIF(NICK_NAME,''),'-')
		                FROM SCM_MST_ITEM_SN X(NOLOCK)
		                WHERE X.DIVISION_ID = A.DIVISION_ID
		                AND X.ITEM_ID     = A.CHILD_ITEM_ID
                ) AS CHILD_ITEM_NAME
                , MIN(A.SORT_ORDER)
                , B.ALT_ID
                , B.ALT_PRIORITY
                , B.EFF_START_DATE
                , B.EFF_END_DATE
                , C.SCP_PLAN_YN
                , C.COMMON_CELL_YN
                , B.ECO_CODE
                , A.NLEVEL
                , FLOOR(C.ATTRIBUTE11) AS SI_ALT_PRIORITY
                , C.ATTRIBUTE12 AS SI_SCP_YN
        FROM    #TblSCP0053_AlterRaw A
                INNER MERGE JOIN    (
                                        SELECT    B.DIVISION_ID
                                                , B.SITE_ID
                                                , B.PLANT_ID
                                                , B.PARENT_ITEM_ID
                                                , B.CHILD_ITEM_ID
                                                , B.EFF_START_DATE
                                                , B.EFF_END_DATE
                                                , B.ALT_ID
                                                , B.ECO_CODE
                                                , CONVERT(int, B.ALT_PRIORITY) AS ALT_PRIORITY
                                                , ROW_NUMBER() OVER(PARTITION BY B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.PARENT_ITEM_ID, B.CHILD_ITEM_ID
                                                                    ORDER BY B.KEY_DATE DESC, B.BOM_VERSION_ID) AS SEQ	--최신 KEY_DATE
                                        FROM    SCM_MST_BOM_ENG_SN B(NOLOCK)
                                        WHERE   B.DIVISION_ID = @p_division_id
                                            AND B.EFF_END_DATE > DATEADD(dd, -7, dbo.fn_next_day(GETDATE(), 'MON'))
                                    ) B ON
                        A.DIVISION_ID       = B.DIVISION_ID
			        AND A.SITE_ID           = B.SITE_ID
				    AND A.PARENT_ITEM_ID    = B.PARENT_ITEM_ID
				    AND A.CHILD_ITEM_ID     = B.CHILD_ITEM_ID
				    AND B.SEQ = 1
			    LEFT OUTER JOIN SCM_MST_ALTER_BOM C (NOLOCK) ON
			            A.DIVISION_ID       = C.DIVISION_ID
					AND A.PLANT_ID          = C.PLANT_ID
					AND A.PARENT_ITEM_ID    = C.PARENT_ITEM_ID
					AND A.CHILD_ITEM_ID     = C.CHILD_ITEM_ID
					AND B.ALT_ID            = C.ALT_ID
					AND B.ALT_PRIORITY      = C.ALT_PRIORITY
                    AND ((@p_parent_id IS NULL OR @p_parent_id = '') OR (C.PARENT_ITEM_ID = @p_parent_id))
                    AND ((@p_child_id IS NULL OR @p_child_id = '') OR (C.CHILD_ITEM_ID = @p_child_id))
        WHERE   C.SCP_PLAN_YN IS NOT NULL
        GROUP BY  A.DIVISION_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.MODEL_ID
                , A.PARENT_ITEM_ID
                , A.CHILD_ITEM_ID
                , B.ALT_ID
                , B.ALT_PRIORITY
				, B.EFF_START_DATE
				, B.EFF_END_DATE
				, C.SCP_PLAN_YN
				, C.COMMON_CELL_YN
				, B.ECO_CODE
				, A.NLEVEL
                , C.ATTRIBUTE11
				, C.ATTRIBUTE12
 	    ORDER BY  A.SITE_ID
				, A.PLANT_ID
				, A.MODEL_ID
				, A.NLEVEL
				, A.PARENT_ITEM_ID
				, B.ALT_ID
				, B.ALT_PRIORITY
				, A.CHILD_ITEM_ID;
	END
	-- 모델/PARENT/CHILD 검색시
	ELSE IF (@p_alter_bom = 'ALL')
	BEGIN
	    PRINT 'ALL';

	    IF OBJECT_ID (N'tempdb..#TblSCP0053_Raw', N'U') IS NOT NULL
		    DROP TABLE #TblSCP0053_Raw;

        SELECT	* 
        INTO    #TblSCP0053_Raw
	    FROM	SCM_MST_ITEM_SN WITH (NOLOCK)
	    WHERE	ITEM_ID IN (@p_model_id, @p_parent_id, @p_child_id)
		    AND DIVISION_ID = @p_division_id

    --TESTING : NOK
    --select * from #TblSCP0053_Raw;return;

	    IF OBJECT_ID (N'tempdb..#TblSCP0053_AllRaw', N'U') IS NOT NULL
		    DROP TABLE #TblSCP0053_AllRaw;

		SELECT	  A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.MODEL_ID
				, A.PARENT_ITEM_ID
				, A.CHILD_ITEM_ID
				, MIN(A.CHILD_QTY) AS CHILD_QTY
				, MIN(A.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
				, MIN(A.SORT_ORDER) AS SORT_ORDER
				, CONVERT(int, MIN(A.NLEVEL)) AS NLEVEL
				, MIN(B.SCP_OPERATION_GROUP) AS SCP_OPERATION_GROUP
				, MIN(B.SCP_FLOW_ID) AS SCP_FLOW_ID
        INTO    #TblSCP0053_AllRaw
		FROM	SCM_MST_BOM_SN A WITH (NOLOCK)
				LEFT OUTER JOIN #TblSCP0053_Raw B WITH (NOLOCK) ON 
						A.DIVISION_ID = B.DIVISION_ID
					AND A.SITE_ID = B.SITE_ID
                JOIN #TblSCP0053_ParentItem P ON
                        A.PARENT_ITEM_ID = P.ITEM_ID
                JOIN #TblSCP0053_ChildItem I ON
		                A.CHILD_ITEM_ID = I.ITEM_ID
		WHERE	1=1
			AND ( (@p_plant_site_id IS NULL OR @p_plant_site_id = '') OR A.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')) )
			AND ((@p_model_id IS NULL OR @p_model_id = '') OR (A.MODEL_ID = @p_model_id))
			AND ((@p_parent_id IS NULL OR @p_parent_id = '') OR (A.PARENT_ITEM_ID = @p_parent_id))
			AND ((@p_child_id IS NULL OR @p_child_id = '') OR (A.CHILD_ITEM_ID = @p_child_id))
			AND A.PARENT_ITEM_ID != '*'
		GROUP BY A.DIVISION_ID, A.SITE_ID , A.PLANT_ID , A.MODEL_ID , A.PARENT_ITEM_ID , A.CHILD_ITEM_ID

--TESTING : NOK
--select * from #TblSCP0053_AllRaw;return;

		SELECT	  A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.MODEL_ID
				, (
					SELECT TOP 1
							--X.ITEM_NAME
							ISNULL(NULLIF(NICK_NAME,''),'-')
					FROM	SCM_MST_ITEM_SN X(NOLOCK)
					WHERE	X.DIVISION_ID = A.DIVISION_ID
						AND X.ITEM_ID     = A.MODEL_ID
				  ) AS MODEL_NAME
				, A.PARENT_ITEM_ID
				, (
					SELECT TOP 1
							--X.ITEM_NAME
							ISNULL(NULLIF(NICK_NAME,''),'-')
					FROM	SCM_MST_ITEM_SN X(NOLOCK)
					WHERE	X.DIVISION_ID = A.DIVISION_ID
						AND X.ITEM_ID     = A.PARENT_ITEM_ID
				  ) AS PARENT_ITEM_NAME
				, A.CHILD_ITEM_ID
				, (
					SELECT TOP 1
							--X.ITEM_NAME
							ISNULL(NULLIF(NICK_NAME,''),'-')
					FROM	SCM_MST_ITEM_SN X(NOLOCK)
					WHERE	X.DIVISION_ID = A.DIVISION_ID
						AND X.ITEM_ID     = A.CHILD_ITEM_ID
				  ) AS CHILD_ITEM_NAME
				, MIN(A.SORT_ORDER)
				, B.ALT_ID
				, B.ALT_PRIORITY
				, B.EFF_START_DATE
				, B.EFF_END_DATE
				, C.SCP_PLAN_YN
				, C.COMMON_CELL_YN
				, B.ECO_CODE
				, A.NLEVEL
				, C.ATTRIBUTE11 AS SI_ALT_PRIORITY
				, C.ATTRIBUTE12 AS SI_SCP_YN
		  FROM	#TblSCP0053_AllRaw A
			   INNER MERGE JOIN
		       (
					SELECT	  DIVISION_ID
							, SITE_ID
							, PLANT_ID
							, PARENT_ITEM_ID
							, CHILD_ITEM_ID
							, EFF_START_DATE
							, EFF_END_DATE
							, ALT_ID
							, ECO_CODE
							, CONVERT(int, ALT_PRIORITY) AS ALT_PRIORITY
							, ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, SITE_ID, PLANT_ID, PARENT_ITEM_ID, CHILD_ITEM_ID
												ORDER BY KEY_DATE DESC, BOM_VERSION_ID) AS SEQ	--최신 KEY_DATE
				    FROM	SCM_MST_BOM_ENG_SN B(NOLOCK)
					WHERE	DIVISION_ID = @p_division_id
						AND ( (@p_plant_site_id IS NULL OR @p_plant_site_id = '') OR PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')) )
						AND EFF_END_DATE  > DATEADD(dd, -7, dbo.fn_next_day(GETDATE(), 'MON'))
			   ) B ON ( A.DIVISION_ID       = B.DIVISION_ID
			        AND A.SITE_ID           = B.SITE_ID
					AND A.PARENT_ITEM_ID    = B.PARENT_ITEM_ID
				    AND A.CHILD_ITEM_ID     = B.CHILD_ITEM_ID
				    AND B.SEQ               = 1)
				LEFT OUTER JOIN SCM_MST_ALTER_BOM C(NOLOCK) ON
						A.DIVISION_ID = C.DIVISION_ID
					AND A.PLANT_ID = C.PLANT_ID
					AND A.PARENT_ITEM_ID = C.PARENT_ITEM_ID
					AND A.CHILD_ITEM_ID = C.CHILD_ITEM_ID
					AND ((@p_parent_id IS NULL OR @p_parent_id = '') OR (C.PARENT_ITEM_ID = @p_parent_id))
					AND ((@p_child_id IS NULL OR @p_child_id = '') OR (C.CHILD_ITEM_ID = @p_child_id))
		GROUP BY  A.DIVISION_ID
				, A.SITE_ID 
				, A.PLANT_ID 
				, A.MODEL_ID 
				, A.PARENT_ITEM_ID 
				, A.CHILD_ITEM_ID
				, B.ALT_ID
				, B.ALT_PRIORITY
				, B.EFF_START_DATE
				, B.EFF_END_DATE
				, C.SCP_PLAN_YN
				, C.COMMON_CELL_YN
				, B.ECO_CODE
				, A.NLEVEL
				, C.ATTRIBUTE11
				, C.ATTRIBUTE12
		ORDER BY  A.SITE_ID
				, A.PLANT_ID
				, A.MODEL_ID
				, A.NLEVEL
				, A.PARENT_ITEM_ID
				, B.ALT_ID
				, B.ALT_PRIORITY
				, A.CHILD_ITEM_ID;
	END



	IF OBJECT_ID (N'tempdb..#TblSCP0053_Raw', N'U') IS NOT NULL
		DROP TABLE #TblSCP0053_Raw;
	IF OBJECT_ID (N'tempdb..#TblSCP0053_ParentItem', N'U') IS NOT NULL
		DROP TABLE #TblSCP0053_ParentItem;
	IF OBJECT_ID (N'tempdb..#TblSCP0053_ChildItem', N'U') IS NOT NULL
		DROP TABLE #TblSCP0053_ChildItem;
	IF OBJECT_ID (N'tempdb..#TblSCP0053_AllRaw', N'U') IS NOT NULL
		DROP TABLE #TblSCP0053_AllRaw;
	IF OBJECT_ID (N'tempdb..#TblSCP0053_AlterRaw', N'U') IS NOT NULL
		DROP TABLE #TblSCP0053_AlterRaw;
END

