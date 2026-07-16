-- =====================================================================================================
-- DMF0000_GET_MASTER_CHG_POPUP — Master Change 팝업 조회 (AS-IS MSSQL 1:1 변환)
--   원천: AS-IS dbo.DMF0000_GET_MASTER_CHG_POPUP (LGCE_SCMDEV, 11,487자) — asis.py 추출
--   대상: 사내 OCGSCMD_P01 / SCM_MGR  (+ 클라우드 이관 시 동일)
--   작성: 2026-07-13  DMF0003 MktFcst btnIncotermsChg → DMF0003_MatsterChgPopup 조회 SP
--   변환: NVARCHAR→VARCHAR2 / ISNULL→NVL / GETDATE→SYSDATE / dbo.→SCM_MGR. / WITH(NOLOCK) 제거
--         / SplitForIN→TABLE(..) P.COLUMN_VALUE / String_Split→TABLE(..) P.TOKEN / TB_FX_User→SCM_MST_SSO_USER_INFO
--         / 날짜: FN_NEXT_DAY(SYSDATE,'MON')-7 (기존 DMF0003_GET_MKT_FCST_DATA 동일) / 결과셋→OUT SYS_REFCURSOR
--   ⚠️ AS-IS 처럼 div40 vs 81/82 분기별 컬럼셋 상이 (FE siMain.Query 동적 컬럼).
-- =====================================================================================================
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0000_GET_MASTER_CHG_POPUP
(
    p_division_id    IN  VARCHAR2,
    p_team_id        IN  VARCHAR2,
    p_customer       IN  VARCHAR2,
    p_scm_site_id    IN  VARCHAR2,
    p_project_code   IN  VARCHAR2,
    p_created_by     IN  VARCHAR2,
    p_user_group     IN  VARCHAR2,
    O_CURSOR         OUT SYS_REFCURSOR
)
AS
    v_dept_id   VARCHAR2(4000) := '';
    v_group_id  VARCHAR2(50)   := '';
    v_cnt       NUMBER         := 0;
    v_std_date  VARCHAR2(8);   -- CONVERT(CHAR(8), DATEADD(DD,-7, FN_NEXT_DAY(GETDATE(),'MON')),112)
BEGIN
    -- ------------------------------------------------------------------------------
    --  20200311 KHSONG C20200103-000586 권한그룹 LOOKUP 관리 (GET_ADMIN_GROUP)
    -- ------------------------------------------------------------------------------
    SELECT COUNT(1)
    INTO   v_cnt
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT2    = 'ALL'
    AND    SEGMENT1    = p_user_group;

    IF v_cnt > 0 THEN
        v_group_id := 'ADMIN';
    END IF;

    -- 자기 부서 (PM_TEAM_MAPPING 우선, 없으면 사용자 DEPT_ID)
    BEGIN
        SELECT NVL( (SELECT SEGMENT3
                     FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE  LOOKUP_TYPE = 'PM_TEAM_MAPPING'
                     AND    SEGMENT1    = U.DEPT_ID
                     AND    VALID_YN    = 'Y'
                     AND    ROWNUM      = 1)
                  , U.DEPT_ID )
        INTO   v_dept_id
        FROM   SCM_MGR.SCM_MST_SSO_USER_INFO U
        WHERE  U.USER_ID = p_created_by
        AND    ROWNUM    = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_dept_id := '';
    END;

    v_std_date := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');

    IF (p_division_id <> '40') THEN
        -----------------------------------
        --  DIV : 81,82 조회조건
        -----------------------------------
        OPEN O_CURSOR FOR
        SELECT MKT.DIVISION_ID
             , TEAM.DEPT_NAME_KO AS DEPT_ID
             , MKT.SCM_SITE_ID
             , MKT.PROJECT_CODE
             , PJT.PROJECT_NAME
             , MKT.ITEM_ID AS MODEL
             , ITEM.ITEM_NAME AS MODEL_NAME
             , MKT.FCST_TYPE
             , (SELECT MAX(SEGMENT2) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE' AND SEGMENT1 = MKT.FCST_TYPE) AS FCST_TYPE_NAME
             , MKT.INCOTERMS
             , MKT.PLANT_SITE_ID
             , MKT.DOM_EXP
             , ITEM.NICK_NAME
             , CASE WHEN ((SCM_MGR.FN_GET_DEPT_LIST(p_created_by, TEAM.DEPT_ID) = 'Y') OR v_group_id = 'ADMIN')
                    THEN 'Y' ELSE 'N' END AS EDIT_FLAG
        FROM   SCM_MGR.DM_PLN_MKT_FCST MKT
            LEFT JOIN SCM_MGR.SCM_MST_PROJECT PJT
                ON  MKT.PROJECT_CODE = PJT.PROJECT_CODE
                AND MKT.DIVISION_ID  = PJT.DIVISION_ID
            LEFT JOIN (SELECT * FROM SCM_MGR.SCM_MST_DIVISION WHERE VALID_YN = 'Y') DIV
                ON  PJT.DROP_YN     = 'N'
                AND PJT.DIVISION_ID = DIV.DIVISION_ID
            LEFT JOIN SCM_MGR.SCM_MST_SITE SIT
                ON  MKT.SCM_SITE_ID = SIT.SCM_SITE_ID
                AND MKT.DIVISION_ID = SIT.DIVISION_ID
            LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM
                ON  SIT.DEPT_ID   = TEAM.DEPT_ID
                AND TEAM.VALID_YN = 'Y'
            LEFT JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                ON  MKT.ITEM_ID     = ITEM.ITEM_ID
                AND MKT.DIVISION_ID = ITEM.DIVISION_ID
        WHERE  1 = 1
        AND    NVL(TEAM.DEPT_ID, 'XXX') <> CASE WHEN p_division_id <> '40' THEN 'XXX' ELSE 'YYY' END
        AND    CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE MKT.DIVISION_ID END IN (
                   SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(p_division_id, ',')) P
                   WHERE (CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE MKT.DIVISION_ID END) = P.COLUMN_VALUE)
        AND    CASE WHEN p_customer = 'ALL' THEN 'ALL' ELSE NVL(SIT.END_CUSTOMER, '') END IN (
                   SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(p_customer, ',')) P
                   WHERE (CASE WHEN p_customer = 'ALL' THEN 'ALL' ELSE NVL(SIT.END_CUSTOMER, '') END) = P.COLUMN_VALUE)
        AND    CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE MKT.SCM_SITE_ID END IN (
                   SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(p_scm_site_id, ',')) P
                   WHERE (CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE MKT.SCM_SITE_ID END) = P.COLUMN_VALUE)
        AND    ( p_project_code IS NULL OR p_project_code = 'ALL'  -- [변환] AS-IS MSSQL split('')=전량 → Oracle ''=NULL 시 조건 skip
              OR EXISTS (SELECT 1 FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(p_project_code, ',')) P WHERE MKT.PROJECT_CODE LIKE P.TOKEN || '%')
              OR EXISTS (SELECT 1 FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(p_project_code, ',')) P WHERE PJT.PROJECT_NAME  LIKE P.TOKEN || '%') )
        AND    MKT.YYYYMMDD >= v_std_date
        AND    MKT.MEASURE = 'MKT_FCST'
        AND    MKT.QTY <> 0
        GROUP BY MKT.DIVISION_ID, TEAM.DEPT_ID, TEAM.DEPT_NAME_KO, MKT.SCM_SITE_ID, MKT.PROJECT_CODE
               , PJT.PROJECT_NAME, MKT.ITEM_ID, ITEM.ITEM_NAME, MKT.FCST_TYPE, MKT.INCOTERMS
               , MKT.PLANT_SITE_ID, MKT.DOM_EXP, ITEM.NICK_NAME
        ORDER BY MKT.DIVISION_ID, TEAM.DEPT_ID, TEAM.DEPT_NAME_KO, MKT.SCM_SITE_ID, MKT.PROJECT_CODE
               , PJT.PROJECT_NAME, MKT.ITEM_ID, ITEM.ITEM_NAME, MKT.FCST_TYPE, MKT.INCOTERMS
               , MKT.PLANT_SITE_ID, MKT.DOM_EXP;
    ELSE
        -----------------------------------
        --  DIV : 40 조회조건 (소형 Planner = 해당팀 코드만)
        -----------------------------------
        OPEN O_CURSOR FOR
        SELECT DIVISION_ID, DEPT_ID, SCM_SITE_ID, END_CUSTOMER, MODEL, MODEL_NAME
             , FCST_TYPE, FCST_TYPE_NAME, INCOTERMS, DOM_EXP, NICK_NAME, EDIT_FLAG
        FROM (
            SELECT MKT.DIVISION_ID
                 , TEAM.DEPT_ID AS DEPT_ID2
                 , TEAM.DEPT_NAME_KO AS DEPT_ID
                 , MKT.SCM_SITE_ID
                 , SITE_ITEM.PROJECT_CODE AS END_CUSTOMER
                 , MKT.ITEM_ID AS MODEL
                 , ITEM.ITEM_NAME AS MODEL_NAME
                 , MKT.FCST_TYPE
                 , (SELECT MAX(SEGMENT2) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                    WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE' AND SEGMENT1 = MKT.FCST_TYPE) AS FCST_TYPE_NAME
                 , MKT.INCOTERMS
                 , MKT.DOM_EXP
                 , ITEM.NICK_NAME
                 , CASE WHEN v_group_id = 'ADMIN' OR v_dept_id = TEAM.DEPT_ID THEN 'Y' ELSE 'N' END EDIT_FLAG
            FROM (
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                FROM   SCM_MGR.DM_PLN_MKT_FCST
                WHERE  CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END IN (
                           SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(p_division_id, ',')) P
                           WHERE (CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.COLUMN_VALUE)
                AND    YYYYMMDD >= v_std_date
                AND    MEASURE = 'MKT_FCST'
                AND    QTY <> 0
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
            ) MKT
            INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM SITE_ITEM
                ON  MKT.SCM_SITE_ID    = SITE_ITEM.SCM_SITE_ID
                AND MKT.ITEM_ID        = SITE_ITEM.ITEM_ID
                AND SITE_ITEM.PROJECT_CODE = MKT.PROJECT_CODE
                AND SITE_ITEM.DIVISION_ID  = MKT.DIVISION_ID
            LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO USER_INFO
                ON  SITE_ITEM.OWNER = USER_INFO.USER_ID
            LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM
                ON  USER_INFO.DEPT_ID = TEAM.DEPT_ID
                AND TEAM.VALID_YN     = 'Y'
            LEFT JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                ON  MKT.ITEM_ID     = ITEM.ITEM_ID
                AND MKT.DIVISION_ID = ITEM.DIVISION_ID
            WHERE  1 = 1
            AND    TEAM.DEPT_ID IS NOT NULL
            AND    CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE MKT.DIVISION_ID END IN (
                       SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(p_division_id, ',')) P
                       WHERE (CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE MKT.DIVISION_ID END) = P.COLUMN_VALUE)
            AND    CASE WHEN p_team_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END IN (
                       SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(p_team_id, ',')) P
                       WHERE (CASE WHEN p_team_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.COLUMN_VALUE)
            AND    CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE MKT.SCM_SITE_ID END IN (
                       SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(p_scm_site_id, ',')) P
                       WHERE (CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE MKT.SCM_SITE_ID END) = P.COLUMN_VALUE)
            AND    ( p_project_code IS NULL OR p_project_code = 'ALL'  -- [변환] 빈값=조건 skip (AS-IS split('')=전량)
                  OR EXISTS (SELECT 1 FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(p_project_code, ',')) P
                            WHERE SITE_ITEM.PROJECT_CODE LIKE P.TOKEN || '%') )
        ) MA
        GROUP BY DIVISION_ID, DEPT_ID2, DEPT_ID, SCM_SITE_ID, END_CUSTOMER, MODEL, MODEL_NAME
               , FCST_TYPE, FCST_TYPE_NAME, INCOTERMS, DOM_EXP, NICK_NAME, EDIT_FLAG
        ORDER BY DIVISION_ID, DEPT_ID2, SCM_SITE_ID, END_CUSTOMER, MODEL, MODEL_NAME
               , FCST_TYPE, FCST_TYPE_NAME, INCOTERMS, DOM_EXP;
    END IF;
END;
/
