PROCEDURE PR_SCP_ANL_MAT_SUPPLY_BATCH
(
      P_SCP_PLAN_START_YYYYMMDD      IN VARCHAR2
    , P_MRP_PLAN_START_YYYYMMDD      IN VARCHAR2
)
/*
 * Program ID   : PR_SCP_ANL_MAT_SUPPLY_BATCH
 * Description  : 자재 제약 가시화 집계 => SCP_ANL_MAT_SUPPLY 에 저장
 * Program History
 *================================================================================================================================================
 *   Date       In Charge                           Description
 *================================================================================================================================================
 * 2024/01/18	chaan					V1.2.1		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial release - 집계일자를 특정해서 집계하기 위해 프로시저 분리
 * 2025.08.01   hrkim								PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 공정 하드코딩 변경
 * 2026.07.06  ZIONEX  [PJ202650304]  NextSCM Migration
 */
IS
    V_TEST_MODE                     VARCHAR2(1 CHAR)     := 'F';
    /* V_TEST_MODE                     VARCHAR2(1 CHAR)     := 'T'; */

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME                  VARCHAR2(150 CHAR)   := 'PR_SCP_ANL_MAT_SUPPLY_BATCH';
    V_LOG_TYPE                      VARCHAR2(30 CHAR);       /* START/END/ERROR/... */
    N_LOG_COUNT                     NUMBER               := 0;
    V_LOG_MESSAGE                   VARCHAR2(1000 CHAR);
    V_DESCRIPTION                   VARCHAR2(500 CHAR);
    V_D_EVENT_DATE                  DATE                 := SYSDATE;

    V_ELAPSED_TIME_BEG              TIMESTAMP            := SYSTIMESTAMP;

    V_CURR_DATE                     DATE;
    V_TODAY                         VARCHAR2(8 CHAR)     := '';
    V_THIS_MONDAY                   VARCHAR2(8 CHAR)     := '';
    V_LAST_MONDAY                   VARCHAR2(8 CHAR)     := '';
    V_THIS_THURSDAY                 VARCHAR2(8 CHAR)     := '';
    V_SCP_PLAN_START_YYYYMMDD       VARCHAR2(8 CHAR)     := '';
    V_MRP_PLAN_START_YYYYMMDD       VARCHAR2(8 CHAR)     := '';
    V_MRP_PLAN_START_YYYYMMDD_PRE   VARCHAR2(8 CHAR)     := '';
    V_SCP_PLAN_LIMIT_YYYYMMDD       VARCHAR2(8 CHAR)     := '';

    V_ERR_MSG                       VARCHAR2(4000 CHAR);
BEGIN
    /* ---------------------------------------------------------------------------------------------------------------- */
    /* [PJ20257329] Cell 완성 공정 하드 코딩 변경 (임시테이블 변수) */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' SCP Cell Final 공정 정보 - Cell Packaging/Assembly');
    /* ---------------------------------------------------------------------------------------------------------------- */
    DELETE FROM GT_SCP0103_SCP_CELL_FINAL_OP;

    INSERT INTO GT_SCP0103_SCP_CELL_FINAL_OP
    SELECT DISTINCT SEGMENT1 AS OPERATION_ID
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK
     WHERE 1=1
       AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
       AND LK.SEGMENT3	  = 'A'	 /* 공정그룹 (Cell) */
       AND LK.ATTRIBUTE1  = 'Y';	 /* Final Operation */
    /* ---------------------------------------------------------------------------------------------------------------- */
    /* [PJ20257329] Cell 계획 공정 하드 코딩 변경 (임시테이블 변수) */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' SCP Cell 계획 공정 정보 전체');
    /* ---------------------------------------------------------------------------------------------------------------- */
    DELETE FROM GT_SCP0103_SCP_CELL_PLAN_OP_ALL;

    INSERT INTO GT_SCP0103_SCP_CELL_PLAN_OP_ALL
    SELECT DISTINCT SEGMENT1 AS OPERATION_ID
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK
     WHERE 1=1
       AND LK.LOOKUP_TYPE	= 'SCP_PLAN_OPERATION'
       AND LK.SEGMENT3	    = 'A'  /* 공정그룹 (Cell) */
       AND LK.VALID_YN		= 'Y';  /* SCP 계획 공정 여부 */
    /* ---------------------------------------------------------------------------------------------------------------- */

    BEGIN

        V_LOG_TYPE         := 'START';
        V_LOG_MESSAGE      := '########## Start of procedure ##########';
        V_DESCRIPTION      := '';

        IF V_TEST_MODE <> 'T' THEN
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_D_EVENT_DATE);
        END IF;

        V_CURR_DATE   := SYSDATE;
        V_TODAY       := TO_CHAR(V_CURR_DATE, 'YYYYMMDD');

        V_THIS_MONDAY   := TO_CHAR((V_CURR_DATE - 1) + (2 - (MOD(TRUNC(V_CURR_DATE - 1) - TRUNC(V_CURR_DATE - 1, 'IW') + 1, 7) + 1)), 'YYYYMMDD');
        V_LAST_MONDAY   := TO_CHAR(TRUNC(CASE WHEN (MOD(TRUNC(V_CURR_DATE) - TRUNC(V_CURR_DATE, 'IW') + 1, 7) + 1) = 1 THEN V_CURR_DATE - 1 ELSE V_CURR_DATE END, 'IW'), 'YYYYMMDD');
        V_THIS_THURSDAY := TO_CHAR(V_CURR_DATE + (5 - (MOD(TRUNC(V_CURR_DATE) - TRUNC(V_CURR_DATE, 'IW') + 1, 7) + 1)), 'YYYYMMDD');

        DBMS_OUTPUT.PUT_LINE('@v_this_monday : ' || V_THIS_MONDAY);
        DBMS_OUTPUT.PUT_LINE('@v_last_monday : ' || V_LAST_MONDAY);
        DBMS_OUTPUT.PUT_LINE('@v_this_thursday : ' || V_THIS_THURSDAY);
        /* return; */

        IF V_TODAY >= V_THIS_THURSDAY THEN /* 현재일자가 목요일이후면 목요일, 아니면 월요일로 @v_mrp_plan_start_yyyymmdd 설정 */

            V_MRP_PLAN_START_YYYYMMDD	:=	V_THIS_THURSDAY;

            BEGIN
                SELECT PLAN_START_YYYYMMDD
                  INTO V_SCP_PLAN_START_YYYYMMDD
                  FROM (
                            SELECT PLAN_START_YYYYMMDD
                            FROM    SCP_PLAN_VERSION_V
                            WHERE   1=1
                                AND PLAN_TYPE		='FN'
                                AND CONFIRM_FLAG	='Y'
                                AND PLAN_START_YYYYMMDD	<= V_THIS_THURSDAY
                            GROUP BY PLAN_START_YYYYMMDD
                            ORDER BY PLAN_START_YYYYMMDD DESC
                       )
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;
        ELSE

            V_MRP_PLAN_START_YYYYMMDD	:=	V_THIS_MONDAY;

            BEGIN
                SELECT PLAN_START_YYYYMMDD
                  INTO V_SCP_PLAN_START_YYYYMMDD
                  FROM (
                            SELECT PLAN_START_YYYYMMDD
                            FROM    SCP_PLAN_VERSION_V
                            WHERE   1=1
                                AND PLAN_TYPE		='FN'
                                AND CONFIRM_FLAG	='Y'
                                AND PLAN_START_YYYYMMDD	<= V_LAST_MONDAY
                            GROUP BY PLAN_START_YYYYMMDD
                            ORDER BY PLAN_START_YYYYMMDD DESC
                       )
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;
        END IF;

        /* 특정 날짜의 데이터를 집계 할 때는 여기서 @v_mrp_plan_start_yyyymmdd, @v_scp_plan_start_yyyymmdd 를 특정 날짜로 설정한다 */
        /* SET @v_scp_plan_start_yyyymmdd  = '20231030'; --testing */
        /* SET @v_mrp_plan_start_yyyymmdd  = '20231106'; --testing */
        /* rollback tran;return; */

        /* 파라미터가 비었으면 현재 날짜 기준으로 계획일자 구한다 */
        IF (P_SCP_PLAN_START_YYYYMMDD IS NOT NULL) AND (RTRIM(P_SCP_PLAN_START_YYYYMMDD) IS NOT NULL) THEN   /* 원본 (x <> '') : Oracle 은 ''=NULL 이라 항상 UNKNOWN -> RTRIM(x) IS NOT NULL 로 1:1 재현(CV-029) */
            V_SCP_PLAN_START_YYYYMMDD  := P_SCP_PLAN_START_YYYYMMDD;
        END IF;

        IF (P_MRP_PLAN_START_YYYYMMDD IS NOT NULL) AND (RTRIM(P_MRP_PLAN_START_YYYYMMDD) IS NOT NULL) THEN   /* 원본 (x <> '') : Oracle 은 ''=NULL 이라 항상 UNKNOWN -> RTRIM(x) IS NOT NULL 로 1:1 재현(CV-029) */
            V_MRP_PLAN_START_YYYYMMDD  := P_MRP_PLAN_START_YYYYMMDD;
        END IF;

        /* 생산계획 기간을  MRP_PLAN_START_YYYYMMDD + 365일로 제한 */
        V_SCP_PLAN_LIMIT_YYYYMMDD := TO_CHAR(TO_DATE(V_SCP_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 365, 'YYYYMMDD');

        /* mrp 계획 시작 전날(반제품 재고(BOH) 쿼리용) */
        V_MRP_PLAN_START_YYYYMMDD_PRE := TO_CHAR(TO_DATE(V_MRP_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');

        DBMS_OUTPUT.PUT_LINE('@v_mrp_plan_start_yyyymmdd : ' || V_MRP_PLAN_START_YYYYMMDD);
        DBMS_OUTPUT.PUT_LINE('@v_scp_plan_start_yyyymmdd : ' || V_SCP_PLAN_START_YYYYMMDD);
        DBMS_OUTPUT.PUT_LINE('@v_scp_plan_limit_yyyymmdd : ' || V_SCP_PLAN_LIMIT_YYYYMMDD);
        /* rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('DELETE dbo.SCP_ANL_MAT_SUPPLY - BEGIN');

        DELETE
        FROM    SCP_ANL_MAT_SUPPLY
        WHERE   1=1
            AND SCP_PLAN_START_YYYYMMDD = V_SCP_PLAN_START_YYYYMMDD
            AND MRP_PLAN_START_YYYYMMDD = V_MRP_PLAN_START_YYYYMMDD;

        DBMS_OUTPUT.PUT_LINE('DELETE dbo.SCP_ANL_MAT_SUPPLY - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;


        DBMS_OUTPUT.PUT_LINE('#TBL_SCP0103_OPERATION_GROUOP - BEGIN');
        DELETE FROM GT_SCP0103_OPERATION_GROUOP;

        INSERT INTO GT_SCP0103_OPERATION_GROUOP
        SELECT    B.SEGMENT1    AS OPERATION_ID
                , B.SEGMENT3    AS OPERATION_GROUP
        FROM    SCM_ADM_LOOKUP_MASTER A
              , SCM_ADM_LOOKUP_MASTER_DETAIL B
        WHERE   A.LOOKUP_TYPE = B.LOOKUP_TYPE
            AND A.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
            AND A.VALID_YN = 'Y'
            AND B.VALID_YN = 'Y';
        DBMS_OUTPUT.PUT_LINE('#TBL_SCP0103_OPERATION_GROUOP - END');


        DBMS_OUTPUT.PUT_LINE('DIVISION_SITE - BEGIN');

        DELETE FROM GT_SCP0103_PLANT_ALL;

        INSERT INTO GT_SCP0103_PLANT_ALL
        SELECT    COMPANY_ID
                , DIVISION_ID
                , SCM_SITE_ID
                , PLANT_ID
                , OPERATION_GROUP
        FROM    SCM_MST_SITE B
        WHERE	1=1
            AND VALID_YN = 'Y'
            AND COMPANY_ID IS NOT NULL
            AND PLANT_ID IS NOT NULL
        GROUP BY  COMPANY_ID
                , DIVISION_ID
                , SCM_SITE_ID
                , PLANT_ID
                , OPERATION_GROUP;

        /* IF OBJECT_ID('tempdb..#TBL_SCP0103_DIVISION_SITE') IS NOT NULL */
        /* DROP TABLE #TBL_SCP0103_DIVISION_SITE; */

        /* SELECT DISTINCT */
        /* A.COMPANY_ID */
        /* , C.DIVISION_ID */
        /* , ISNULL(C.ORIGIN_DIVISION_ID, A.DIVISION_ID)       AS ORIGIN_DIVISION_ID */
        /* , C.OPERATION_GROUP */
        /* , A.PLANT_ID */
        /* , C.SCM_SITE_ID */
        /* , ISNULL(C.LINE_ID, '-')                            AS LINE_ID */
        /* , C.OPERATION_ID */
        /* INTO    #TBL_SCP0103_DIVISION_SITE */
        /* FROM    ( */
        /* SELECT    ATTRIBUTE2    AS DIVISION_ID */
        /* , ATTRIBUTE1    AS ORIGIN_DIVISION_ID */
        /* , SEGMENT2      AS OPERATION_GROUP */
        /* , SEGMENT3      AS SCM_SITE_ID */
        /* , SEGMENT4      AS LINE_ID */
        /* , SEGMENT5      AS OPERATION_ID */
        /* FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) */
        /* WHERE   1=1 */
        /* AND LOOKUP_TYPE = 'EE_PRODUCTION_PLAN' */
        /* AND SEGMENT1    = 'SCP' */
        /* AND VALID_YN    = 'Y' */
        /* GROUP BY  ATTRIBUTE2 */
        /* , ATTRIBUTE1 */
        /* , SEGMENT2 */
        /* , SEGMENT3 */
        /* , SEGMENT4 */
        /* , SEGMENT5 */
        /* UNION ALL */
        /* SELECT    ATTRIBUTE1    AS DIVISION_ID */
        /* , ATTRIBUTE1    AS ORIGIN_DIVISION_ID */
        /* , SEGMENT2      AS OPERATION_GROUP */
        /* , SEGMENT3      AS SCM_SITE_ID */
        /* , SEGMENT4      AS LINE_ID */
        /* , SEGMENT5      AS OPERATION_ID */
        /* FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) */
        /* WHERE   1=1 */
        /* AND LOOKUP_TYPE = 'EE_PRODUCTION_PLAN' */
        /* AND SEGMENT1    = 'SCP' */
        /* AND VALID_YN    = 'Y' */
        /* GROUP BY  ATTRIBUTE2 */
        /* , ATTRIBUTE1 */
        /* , SEGMENT2 */
        /* , SEGMENT3 */
        /* , SEGMENT4 */
        /* , SEGMENT5 */
        /* ) C */
        /* LEFT JOIN dbo.SCM_MST_SITE A WITH(NOLOCK) ON */
        /* C.ORIGIN_DIVISION_ID    = A.DIVISION_ID */
        /* AND C.SCM_SITE_ID           = A.SCM_SITE_ID */
        /* LEFT JOIN ( */
        /* SELECT  PLANT_ID */
        /* FROM    dbo.SCM_DNM_MAT_MRP_SUPPLY */
        /* WHERE   1=1 */
        /* AND CUTOFF_DATE = @v_mrp_plan_start_yyyymmdd */
        /* GROUP BY PLANT_ID */
        /* ) B ON */
        /* A.PLANT_ID = B.PLANT_ID */
        /* WHERE   1=1 */
        /* AND A.VALID_YN = 'Y' */
        /* AND ISNULL(A.COMPANY_ID, '') <> '' */
        /* AND ISNULL(A.PLANT_ID, '') <> '' */
        /* AND ISNULL(C.OPERATION_ID, '') <> ''; */

        DBMS_OUTPUT.PUT_LINE('DIVISION_SITE - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;

/* TESTING : OK */
/* select * from #TBL_SCP0103_DIVISION_SITE;rollback tran;return; */


        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;

        DBMS_OUTPUT.PUT_LINE('PLANT - BEGIN');
        DELETE FROM GT_SCP0103_PLANT;

        INSERT INTO GT_SCP0103_PLANT
        SELECT DISTINCT
                CASE
                    WHEN OPERATION_GROUP =  'E' AND INSTR(DIVISION_ID, '_') > 1 THEN 'EE_' || SUBSTR(DIVISION_ID, 4, 2)
                    WHEN OPERATION_GROUP =  'E' AND INSTR(DIVISION_ID, '_') = 0 THEN 'EE'
                    WHEN OPERATION_GROUP <> 'E' THEN DIVISION_ID
                    ELSE ''
                  END AS DIVISION_ID
                , SUBSTR(DIVISION_ID, 1, 2)          AS ORIGIN_DIVISION_ID
                , PLANT_ID
        FROM    SCM_MST_SITE A
        WHERE   1=1
--          AND A.DEPT_ID   = 'PLANT'    --  2026.10.21 AJS 사이트 부서 칸 삭제 → 아이템 원장 부서
            AND A.SITE_TYPE = 'PLANT'    --  2026.10.21 AJS 사이트 부서 칸 삭제 → 아이템 원장 부서
            AND A.PLANT_ID IS NOT NULL
            AND A.VALID_YN  = 'Y';

/* TESTING : OK */
/* select * from #TBL_SCP0103_PLANT;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('PLANT - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;

        DBMS_OUTPUT.PUT_LINE('EE PLANT - BEGIN');
        DELETE FROM GT_SCP0103_EE_PLANT;

        INSERT INTO GT_SCP0103_EE_PLANT
        SELECT    B.SEGMENT1 AS ASSY_DIVISION_ID
                , B.SEGMENT2 AS ASSY_PLANT_ID
                , B.SEGMENT3 AS ELEC_DIVISION_ID
                , B.SEGMENT4 AS ELEC_PLANT_ID
        FROM    SCM_ADM_LOOKUP_MASTER A
              , SCM_ADM_LOOKUP_MASTER_DETAIL B
        WHERE   A.LOOKUP_TYPE   = B.LOOKUP_TYPE
            AND A.LOOKUP_TYPE   = 'EE_ASSY_PLANT_MAPPING'
            AND A.VALID_YN      = 'Y'
            AND B.VALID_YN      = 'Y';
        DBMS_OUTPUT.PUT_LINE('EE PLANT - END');

/* TESTING : OK */
/* select * from #TBL_SCP0103_PLANT;return; */

        DBMS_OUTPUT.PUT_LINE('OPERATION - BEGIN');
        DELETE FROM GT_SCP0103_OPERATION;

        INSERT INTO GT_SCP0103_OPERATION
        SELECT  SEGMENT4 AS OPERATION_ID
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE   1=1
            AND LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
            AND VALID_YN    = 'Y'
        GROUP BY SEGMENT4;
        DBMS_OUTPUT.PUT_LINE('OPERATION - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;

/* TESTING : OK */
/* select * from #TBL_SCP0103_OPERATION;return; */


        DBMS_OUTPUT.PUT_LINE('ITEM/OPERATION(모든 아이템에 대해 OPERATION 매핑) - BEGIN');
        DELETE FROM GT_SCP0103_ITEM_OPERATION;

        INSERT INTO GT_SCP0103_ITEM_OPERATION
        SELECT DISTINCT
                  A.COMPANY_ID
                , A.DIVISION_ID
                , A.ITEM_ID
                , B.SEGMENT4    AS OPERATION_ID
        FROM    SCM_MST_ITEM_SN A
              , (
                                SELECT  *
                                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL
                                WHERE   1=1
                                    AND LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                    AND VALID_YN    = 'Y'
                            ) B
        WHERE   A.SCP_FLOW_ID = B.SEGMENT2;
        DBMS_OUTPUT.PUT_LINE('ITEM/OPERATION(모든 아이템에 대해 OPERATION 매핑) - END');


        DBMS_OUTPUT.PUT_LINE('#TBL_SCP0103_ITEM_UOM - BEGIN');
        DELETE FROM GT_SCP0103_ITEM_UOM;

        INSERT INTO GT_SCP0103_ITEM_UOM
        SELECT    DIVISION_ID
                , ITEM_ID
                , ITEM_UOM  AS UOM
        FROM    SCM_MST_ITEM_SN
        WHERE   1=1
            AND ACTIVE_FLAG    = 'Y'
        GROUP BY  DIVISION_ID
                , ITEM_ID
                , ITEM_UOM;
        DBMS_OUTPUT.PUT_LINE('#TBL_SCP0103_ITEM_UOM - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;
/* TESTING : OK */
/* select * from #TBL_SCP0103_ITEM_UOM;return; */


        DBMS_OUTPUT.PUT_LINE('Summary SCP Plan - BEGIN ===============================================================================================================================================================');

        DBMS_OUTPUT.PUT_LINE('생산계획에 적용할 수율 목록 - BEGIN');
        DELETE FROM GT_SCP0103_YIELD;

        INSERT INTO GT_SCP0103_YIELD
        SELECT	  A.DIVISION_ID
                , A.PLANT_SITE_ID
                , A.ITEM_ID
                , A.OPERATION_ID
                , A.TACT_TIME_START_DATE
                , A.TACT_TIME_END_DATE
                , AVG(A.YIELD)        AS YIELD
        FROM    SCP_MST_TACT_TIME_EXCEPT A
              , GT_SCP0103_OPERATION B
        WHERE   1=1
            AND A.OPERATION_ID = B.OPERATION_ID
            /* LINE 무시 AND A.LINE_ID  = '-' */
            /* 유동적이므로 SCM_ADM_LOOKUP_MASTER_DETAIL로 대체 AND A.OPERATION_ID IN ('E2000', 'A3000', 'A9000', 'P5500', 'P9500') */
            AND A.YIELD   <> 0
            AND A.USE_YN   = 'Y'
        GROUP BY  A.DIVISION_ID
                , A.PLANT_SITE_ID
                , A.ITEM_ID
                , A.OPERATION_ID
                , A.TACT_TIME_START_DATE
                , A.TACT_TIME_END_DATE;
        DBMS_OUTPUT.PUT_LINE('생산계획에 적용할 수율 목록 - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;

/* TESTING : OK */
/* select * from #TBL_SCP0103_YIELD;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('생산계획에 해당하는 최종 PLAN SEQ 구하기 - BEGIN');
        DELETE FROM GT_SCP0103_SCP_PLAN_TYPE;

        INSERT INTO GT_SCP0103_SCP_PLAN_TYPE
        SELECT	  A.DIVISION_ID
                , A.PLAN_NAME
                , A.PLAN_ID
                , A.PLAN_TYPE
                , A.PLAN_SEQ
        FROM	(
                    SELECT	  D.DIVISION_ID
                            , P.PLAN_NAME
                            , D.PLAN_ID
                            , D.PLAN_TYPE
                            , MAX(D.PLAN_SEQ) PLAN_SEQ
                            , ROW_NUMBER() OVER (PARTITION BY D.DIVISION_ID ORDER BY D.PLAN_ID DESC) RN
                            , DENSE_RANK() OVER (ORDER BY D.DIVISION_ID ASC) ROWIDX
                    FROM    SCM_MST_PLAN_DETAIL D
                          , SCM_MST_PLAN P
                    WHERE   1=1
                        AND D.DIVISION_ID  = P.DIVISION_ID
                        AND D.PLAN_ID      = P.PLAN_ID
                        AND D.PLAN_STATUS  = '1'
                        AND D.CONFIRM_FLAG = 'Y'
                        AND D.PLAN_TYPE    = 'FN'
                        AND P.PLAN_NAME     = V_SCP_PLAN_START_YYYYMMDD
                    GROUP BY D.DIVISION_ID, P.PLAN_NAME, D.PLAN_ID, D.PLAN_TYPE
                ) A
        WHERE	1=1
            AND RN = 1;
            /* AND LEFT(DIVISION_ID, 2) <> 'EE'; -- EE 사업부는 생산계획에서 제외하고 실 사업부들(81/82/40) 집계가 끝난후 실사업부들의 계획을 MRP->PLANT 로 찾아 취합한다. */

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_TYPE;return; */
        DBMS_OUTPUT.PUT_LINE('생산계획에 해당하는 최종 PLAN SEQ 구하기 - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;


        DBMS_OUTPUT.PUT_LINE('최종 PLAN SEQ 에 해당하는 생산 계획 찾기 - BEGIN');
        DELETE FROM GT_SCP0103_SCP_FN;

        INSERT INTO GT_SCP0103_SCP_FN
        SELECT	  A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.OPERATION_GROUP
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.MEASURE
                , A.YYYYMMDD
                , A.QTY
                , A.DIVISION_NAME
                , A.OPERATION_GROUP_NAME
                , A.SCM_SITE_DESCRIPTION
                , A.NICK_NAME
                , A.ORIGIN_DIVISION_ID
                , A.ELECTRODE_TYPE
        FROM    SCP_ANL_PRODUCTION_PLAN_C A
              , GT_SCP0103_SCP_PLAN_TYPE B
              , GT_SCP0103_OPERATION C
        WHERE   1=1
            AND A.DIVISION_ID           = B.DIVISION_ID
                        /* A.ORIGIN_DIVISION_ID    = B.DIVISION_ID */
            AND A.PLAN_START_YYYYMMDD   = B.PLAN_NAME
            AND A.PLAN_TYPE             = B.PLAN_TYPE
            AND A.SEQ                   = B.PLAN_SEQ
            AND A.OPERATION_ID = C.OPERATION_ID
            AND A.YYYYMMDD <= V_SCP_PLAN_LIMIT_YYYYMMDD /* 생산계획 기간을  MRP_PLAN_START_YYYYMMDD + 365일로 제한 */
            AND A.MEASURE IN ('PROD_PLAN_AMEND')
            AND A.LINE_ID <> '-'
            AND A.QTY	  <> 0;
            /* AND LEFT(A.DIVISION_ID, 2) <> 'EE'; -- EE 사업부는 생산계획에서 제외하고 실 사업부들(81/82/40) 집계가 끝난후 실사업부들의 계획을 MRP->PLANT 로 찾아 취합한다. */

        DBMS_OUTPUT.PUT_LINE('최종 PLAN SEQ 에 해당하는 생산 계획 찾기 - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;
/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_FN;rollback tran;return; */


        DBMS_OUTPUT.PUT_LINE('최종 PLAN SEQ 에 해당하는 생산 계획 찾기 - LINE제거 - BEGIN');
        DELETE FROM GT_SCP0103_SCP_FN_LINE;

        INSERT INTO GT_SCP0103_SCP_FN_LINE
        SELECT	  A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.OPERATION_ID
                , A.MEASURE
                , A.YYYYMMDD
                , SUM(A.QTY)                AS QTY
                , A.DIVISION_NAME
                , A.OPERATION_GROUP_NAME
                , A.SCM_SITE_DESCRIPTION
                , A.NICK_NAME
                , A.ORIGIN_DIVISION_ID
                , A.ELECTRODE_TYPE
        FROM	GT_SCP0103_SCP_FN A
        WHERE   1=1
        GROUP BY  A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.OPERATION_ID
                , A.MEASURE
                , A.YYYYMMDD
                , A.DIVISION_NAME
                , A.OPERATION_GROUP_NAME
                , A.SCM_SITE_DESCRIPTION
                , A.NICK_NAME
                , A.ORIGIN_DIVISION_ID
                , A.ELECTRODE_TYPE;
        DBMS_OUTPUT.PUT_LINE('최종 PLAN SEQ 에 해당하는 생산 계획 찾기 - LINE제거 - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;
/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_FN_LINE;rollback tran;return; */


        DBMS_OUTPUT.PUT_LINE('생산계획이 있는 모델 목록만 구하기 - BEGIN');
        DELETE FROM GT_SCP0103_SCP_MODEL_PROD_PLAN_AMEND;

        INSERT INTO GT_SCP0103_SCP_MODEL_PROD_PLAN_AMEND
        SELECT  ITEM_ID
        FROM    GT_SCP0103_SCP_FN_LINE
        GROUP BY ITEM_ID;
        DBMS_OUTPUT.PUT_LINE('생산계획이 있는 모델 목록만 구하기 - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;
/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND;rollback tran;return; */
/* select * from #TBL_SCP0103_SCP_PLAN_TYPE; */
/* select * from #TBL_SCP0103_SCP_FN_LINE;rollback tran;return; */
/* ??????????? */


        DBMS_OUTPUT.PUT_LINE('BOM TREE - BEGIN ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');

        DBMS_OUTPUT.PUT_LINE('BASE BOM 참조 데이터 추출 - BEGIN');
        DELETE FROM GT_SCP0103_SCP_TREE_RAW;

        INSERT INTO GT_SCP0103_SCP_TREE_RAW
        SELECT    B.COMPANY_ID
                , B.DIVISION_ID
                , B.SITE_ID
                , B.PLANT_ID
                , B.PARENT_ITEM_ID
                , B.CHILD_ITEM_ID
                , B.BOM_VERSION_ID
                , B.KEY_DATE
                , B.BOM_VERSION_LINE
                , B.PARENT_QTY
                , B.PARENT_UOM
                , B.CHILD_QTY
                , B.CHILD_UOM
                , B.ALT_ID
                , B.ALT_PRIORITY
                , B.ALT_RATE
                , B.EFF_START_DATE
                , B.EFF_END_DATE
                , B.ECO_CODE
                , B.PHANTOM
                , B.STANDARD_FLAG
                , B.ACTIVE_FLAG
                , B.DESCRIPTION
                , CAST(NVL(B.CHILD_QTY, 0.0) / CASE WHEN NVL(B.PARENT_QTY, 1.0) != 0 THEN B.PARENT_QTY ELSE 1.0 END AS NUMBER(20, 10))  AS ACCUMULATED_CHILD_QTY
                , TO_CHAR(CAST(NVL(B.ALT_PRIORITY, 0) AS NUMBER(4)), 'FM000')	                                            AS ACC_PRIORITY
                , R.SCP_FLOW_ID														                                            AS PARENT_FLOW_ID
                , R.SCP_OPERATION_GROUP												                                            AS PARENT_OPERATION_GROUP
                , R.ACTIVE_FLAG														                                            AS PARENT_ACTIVE_FLAG
                , I.SCP_FLOW_ID													                                                AS CHILD_FLOW_ID
                , I.SCP_OPERATION_GROUP											                                                AS CHILD_OPERATION_GROUP
                , I.ITEM_CLASS														                                            AS CHILD_ITEM_CLASS
                , I.ACTIVE_FLAG													                                                AS CHILD_ACTIVE_FLAG
                , CASE
                    WHEN I.ITEM_CLASS = 'ES0301'				THEN 'ANODE'
                    WHEN I.ITEM_CLASS = 'ES0302'				THEN 'CATHODE'
                    WHEN I.ITEM_CLASS IN ('ES0303', 'ES0305')	THEN 'ONESIDE'
                    ELSE											 '-'
                  END																                                AS CHILD_ELEC_TYPE
                , ROW_NUMBER() OVER (PARTITION BY B.COMPANY_ID
                                        , B.DIVISION_ID
                                        , B.SITE_ID
                                        , B.PLANT_ID
                                        , B.PARENT_ITEM_ID
                                        , B.CHILD_ITEM_ID
                                 ORDER BY	  B.BOM_VERSION_ID DESC
                                        , B.KEY_DATE       DESC
                                 )												                                AS KEY_DATE_RN
        FROM    SCM_MST_BOM_ENG_SN B
              , SCM_MST_ITEM_SN R
              , SCM_MST_ITEM_SN I
        WHERE   1=1
            AND R.ITEM_ID(+)		= B.PARENT_ITEM_ID
            AND R.COMPANY_ID(+)	= B.COMPANY_ID
            AND R.DIVISION_ID(+)	= B.DIVISION_ID
            AND R.SITE_ID(+)		= B.SITE_ID
            AND R.ACTIVE_FLAG(+)	= 'Y'
            AND I.ITEM_ID(+)		    = B.CHILD_ITEM_ID
            AND I.COMPANY_ID(+)	    = B.COMPANY_ID
            AND I.DIVISION_ID(+)	    = B.DIVISION_ID
            AND I.SITE_ID(+)		    = B.SITE_ID
            AND I.ACTIVE_FLAG(+)	    = 'Y'
            AND EFF_START_DATE <= TO_DATE(V_MRP_PLAN_START_YYYYMMDD, 'YYYYMMDD')
            AND (EFF_END_DATE IS NULL OR EFF_END_DATE >= TO_DATE(V_MRP_PLAN_START_YYYYMMDD, 'YYYYMMDD'));
        DBMS_OUTPUT.PUT_LINE('BASE BOM 참조 데이터 추출 - DONE');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;
/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_TREE_RAW;rollback tran;return; */


        DBMS_OUTPUT.PUT_LINE('BASE BOM 참조 데이터 ALT_ID_PRIORITY 정렬 - BEGIN');
        DELETE FROM GT_SCP0103_SCP_TREE_RAW_TEMP;

        INSERT INTO GT_SCP0103_SCP_TREE_RAW_TEMP
        SELECT	  A.DIVISION_ID
                , A.PLANT_ID
                , A.PARENT_ITEM_ID
                , A.CHILD_ITEM_ID
                , A.PARENT_QTY
                , A.CHILD_QTY
                , A.ALT_ID
                , A.ALT_PRIORITY
                , A.ALT_RATE
                , A.ACCUMULATED_CHILD_QTY
                , A.ACC_PRIORITY
                , A.PARENT_FLOW_ID
                , A.PARENT_OPERATION_GROUP
                , A.KEY_DATE_RN
                , A.CHILD_FLOW_ID
                , A.CHILD_OPERATION_GROUP
                , A.CHILD_ITEM_CLASS
                , A.CHILD_ELEC_TYPE
                , A.PLANT_PRIORITY
                , TO_CHAR(DENSE_RANK() OVER (PARTITION BY  A.DIVISION_ID
                                                , A.PARENT_ITEM_ID
                                                , A.ALT_ID
                                    ORDER BY A.ALT_PRIORITY) - 1, 'FM000')	AS ALT_ID_PRIORITY
        FROM	(
                    SELECT	  DIVISION_ID
                            , PLANT_ID
                            , PARENT_ITEM_ID
                            , CHILD_ITEM_ID
                            , PARENT_QTY
                            , CHILD_QTY
                            , ALT_ID
                            , ALT_PRIORITY
                            , ALT_RATE
                            , ACCUMULATED_CHILD_QTY
                            , ACC_PRIORITY
                            , PARENT_FLOW_ID
                            , PARENT_OPERATION_GROUP
                            , KEY_DATE_RN
                            , CHILD_FLOW_ID
                            , CHILD_OPERATION_GROUP
                            , CHILD_ITEM_CLASS
                            , CHILD_ELEC_TYPE
                            , ROW_NUMBER() OVER (PARTITION BY	  DIVISION_ID
                                                        , PARENT_ITEM_ID
                                                        , CHILD_ITEM_ID
                                            ORDER BY PLANT_ID ) AS PLANT_PRIORITY
                    FROM	GT_SCP0103_SCP_TREE_RAW
                    WHERE	1=1
                        AND KEY_DATE_RN = 1
                ) A
        WHERE	1=1;
            /* AND PLANT_PRIORITY = 1 */

            /* INDEX 생성 (원본 NONCLUSTERED INDEX — GTT는 세션 임시테이블이라 보조인덱스 제거) */
        DBMS_OUTPUT.PUT_LINE('BASE BOM 참조 데이터 ALT_ID_PRIORITY 정렬 - DONE');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;
/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_TREE_RAW_TEMP;rollback;return; */


        DBMS_OUTPUT.PUT_LINE('ALT ID 1순위 데이터를 대상으로 전개 - BOM TREE - BEGIN');
        DELETE FROM GT_SCP0103_SCP_TREE;

        INSERT INTO GT_SCP0103_SCP_TREE
        WITH TREE_MODEL ( NLEVEL, DIVISION_ID, PLANT_ID, MODEL_ID, PARENT_ITEM_ID, CHILD_ITEM_ID, CONCATENATE_ITEM, ACC_PRIORITY, ALT_ID, ALT_PRIORITY, PARENT_QTY, CHILD_QTY, ACCUMULATED_CHILD_QTY, T_ACCUMULATED_CHILD_QTY, PARENT_FLOW_ID, PARENT_OPERATION_GROUP, CHILD_FLOW_ID, CHILD_OPERATION_GROUP, CHILD_ITEM_CLASS, CHILD_ELEC_TYPE ) AS
        (
            SELECT	  CAST(1 AS NUMBER(10))															        AS NLEVEL
                    , C.DIVISION_ID
                    , C.PLANT_ID
                    , C.PARENT_ITEM_ID															        AS MODEL_ID
                    , C.PARENT_ITEM_ID
                    , C.CHILD_ITEM_ID
                    , CAST(C.PARENT_ITEM_ID || '^' || C.CHILD_ITEM_ID AS VARCHAR2(4000 CHAR))		    AS CONCATENATE_ITEM
                    , CAST('1' || NVL(C.ACC_PRIORITY, '000') AS VARCHAR2(1000 CHAR))			    AS ACC_PRIORITY
                    , C.ALT_ID
                    , C.ALT_PRIORITY
                    , CAST(C.PARENT_QTY AS NUMBER(23, 10))                                            AS PARENT_QTY
                    , CAST(C.CHILD_QTY AS NUMBER(23, 10))                                             AS CHILD_QTY
                    , CAST(C.ACCUMULATED_CHILD_QTY AS NUMBER(23, 10))                                 AS ACCUMULATED_CHILD_QTY
                    , CAST(0.0 AS NUMBER(23, 10))                                                     AS T_ACCUMULATED_CHILD_QTY
                    , C.PARENT_FLOW_ID
                    , C.PARENT_OPERATION_GROUP
                    , C.CHILD_FLOW_ID
                    , C.CHILD_OPERATION_GROUP
                    , C.CHILD_ITEM_CLASS
                    , C.CHILD_ELEC_TYPE
            FROM	GT_SCP0103_SCP_TREE_RAW_TEMP C
            WHERE	1=1
                AND C.ALT_ID_PRIORITY = '000' /* - 1순위만 */
            UNION ALL
            SELECT	  CAST(T.NLEVEL + 1 AS NUMBER(10))	                                                 AS NLEVEL
                    , C.DIVISION_ID
                    , C.PLANT_ID
                    , T.MODEL_ID
                    , C.PARENT_ITEM_ID
                    , C.CHILD_ITEM_ID
                    , CAST(T.CONCATENATE_ITEM || '^' || C.CHILD_ITEM_ID AS VARCHAR2(4000 CHAR))		AS CONCATENATE_ITEM
                    , CAST(T.ACC_PRIORITY || NVL(C.ACC_PRIORITY, '000') AS VARCHAR2(1000 CHAR))	AS ACC_PRIORITY
                    , C.ALT_ID
                    , C.ALT_PRIORITY
                    , CAST(C.PARENT_QTY AS NUMBER(23, 10))                                            AS PARENT_QTY
                    , CAST(C.CHILD_QTY AS NUMBER(23, 10))                                             AS CHILD_QTY
                    , CAST(T.ACCUMULATED_CHILD_QTY * C.ACCUMULATED_CHILD_QTY AS NUMBER(23, 10))		AS ACCUMULATED_CHILD_QTY
                    , CAST(T.ACCUMULATED_CHILD_QTY AS NUMBER(23, 10))                                 AS T_ACCUMULATED_CHILD_QTY
                    , C.PARENT_FLOW_ID
                    , C.PARENT_OPERATION_GROUP
                    , C.CHILD_FLOW_ID
                    , C.CHILD_OPERATION_GROUP
                    , C.CHILD_ITEM_CLASS
                    , C.CHILD_ELEC_TYPE
            FROM    TREE_MODEL T
                  , GT_SCP0103_SCP_TREE_RAW_TEMP C
            WHERE   1=1
                AND C.DIVISION_ID     = T.DIVISION_ID
                AND C.PLANT_ID		  = T.PLANT_ID
                AND C.PARENT_ITEM_ID  = T.CHILD_ITEM_ID
                AND C.ALT_ID_PRIORITY = '000' /* - 1순위만 */
                AND T.NLEVEL <= 15
        )
        SELECT	  NLEVEL
                , DIVISION_ID
                , PLANT_ID
                , MODEL_ID
                , PARENT_ITEM_ID
                , CHILD_ITEM_ID
                , CONCATENATE_ITEM
                , ACC_PRIORITY
                , ALT_ID
                , ALT_PRIORITY
                , PARENT_QTY
                , CHILD_QTY
                , ACCUMULATED_CHILD_QTY
                , T_ACCUMULATED_CHILD_QTY
                , PARENT_FLOW_ID
                , PARENT_OPERATION_GROUP
                , CHILD_FLOW_ID
                , CHILD_OPERATION_GROUP
                , CHILD_ITEM_CLASS
                , CHILD_ELEC_TYPE
        FROM	TREE_MODEL T
        WHERE	1=1;
        DBMS_OUTPUT.PUT_LINE('ALT ID 1순위 데이터를 대상으로 전개 - BOM TREE - DONE');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_TREE;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('BOM TREE - SEMI - BEGIN');
        DELETE FROM GT_SCP0103_SCP_TREE_KEYS;

        INSERT INTO GT_SCP0103_SCP_TREE_KEYS
        SELECT	  A.DIVISION_ID
                , A.PLANT_ID
                , A.MODEL_ID
                , A.CHILD_ITEM_ID
                , SUM(A.ACCUMULATED_CHILD_QTY)  AS ACCUMULATED_CHILD_QTY
        FROM    GT_SCP0103_SCP_TREE A
        GROUP BY  A.DIVISION_ID
                , A.PLANT_ID
                , A.MODEL_ID
                , A.CHILD_ITEM_ID;
        DBMS_OUTPUT.PUT_LINE('BOM TREE - SEMI - END');
/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_TREE_KEYS;rollback tran;return; */


        DBMS_OUTPUT.PUT_LINE('MODEL/CHILD(비자재 포함) 소요수량 정보 - BEGIN');
        DELETE FROM GT_SCP0103_SCP_TREE_PROD;

        INSERT INTO GT_SCP0103_SCP_TREE_PROD
        SELECT	  T.DIVISION_ID
                , T.PLANT_ID
                , T.MODEL_ID
                , I.OPERATION_GROUP			    AS MODEL_OPERATION_GROUP
                , I.FLOW_ID					    AS MODEL_FLOW_ID
                , T.CHILD_ITEM_ID
                , T.CHILD_ITEM_CLASS
                , T.CHILD_OPERATION_GROUP
                , SUM(T.ACCUMULATED_CHILD_QTY)	AS ACCUMULATED_CHILD_QTY
                , COUNT(1)						AS PATH_CNT
        FROM    GT_SCP0103_SCP_TREE T
              , SCP_MST_FINAL_ITEM I
        WHERE   1=1
            AND I.DIVISION_ID(+)	= T.DIVISION_ID
            AND I.ITEM_ID(+)		= T.MODEL_ID
        GROUP BY	  T.DIVISION_ID
                    , T.PLANT_ID
                    , T.MODEL_ID
                    , I.OPERATION_GROUP
                    , I.FLOW_ID
                    , T.CHILD_ITEM_ID
                    , T.CHILD_ITEM_CLASS
                    , T.CHILD_OPERATION_GROUP;
        DBMS_OUTPUT.PUT_LINE('MODEL/CHILD(비자재 포함) 소요수량 정보 - DONE');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_TREE_PROD;rollback tran;return; */
/* select * from #TBL_SCP0103_SCP_TREE_RAW;return; */

        DELETE FROM GT_SCP0103_OPERATION_GROUP_PROD;

        INSERT INTO GT_SCP0103_OPERATION_GROUP_PROD
        SELECT    DIVISION_ID
                , PLANT_ID
                , MODEL_OPERATION_GROUP     AS OPERATION_GROUP
                , MODEL_FLOW_ID             AS OPERATION_ID
                , CHILD_ITEM_ID             AS MATERIAL
        FROM    GT_SCP0103_SCP_TREE_PROD
        WHERE   1=1
            AND MODEL_OPERATION_GROUP IS NOT NULL
        GROUP BY  DIVISION_ID
                , PLANT_ID
                , MODEL_OPERATION_GROUP
                , MODEL_FLOW_ID
                , CHILD_ITEM_ID;
/* TESTING : OK */
/* select * from #TBL_SCP0103_OPERATION_GROUP_PROD;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('생산계획에 해당하는 MODEL/CHILD(비자재 포함) 필터링 - BEGIN');
        DELETE FROM GT_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP;

        INSERT INTO GT_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP
        SELECT	  A.DIVISION_ID
                , A.PLANT_ID
                , A.MODEL_ID
                , A.MODEL_OPERATION_GROUP
                , A.MODEL_FLOW_ID
                , A.CHILD_ITEM_ID
                , A.CHILD_ITEM_CLASS
                , A.CHILD_OPERATION_GROUP
                , A.ACCUMULATED_CHILD_QTY
                , A.PATH_CNT
        FROM	GT_SCP0103_SCP_TREE_PROD A
              , GT_SCP0103_SCP_MODEL_PROD_PLAN_AMEND B
        WHERE   A.MODEL_ID = B.ITEM_ID;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND; */
/* select * from #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP;rollback tran;return; */

        DELETE FROM GT_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND;

        INSERT INTO GT_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND
        SELECT	  A.DIVISION_ID
                , A.PLANT_ID
                , A.MODEL_ID
                , SUBSTR(A.MODEL_FLOW_ID, 1, 5) AS MODEL_FLOW_ID
                , A.CHILD_ITEM_ID
                , AVG(A.ACCUMULATED_CHILD_QTY)  AS ACCUMULATED_CHILD_QTY
        FROM    GT_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP A
        GROUP BY  A.DIVISION_ID
                , A.PLANT_ID
                , A.MODEL_ID
                , SUBSTR(A.MODEL_FLOW_ID, 1, 5)
                , A.CHILD_ITEM_ID;
        DBMS_OUTPUT.PUT_LINE('생산계획에 해당하는 MODEL/CHILD(비자재 포함) 필터링 - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;
        DBMS_OUTPUT.PUT_LINE('BOM TREE - END ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
        DBMS_OUTPUT.PUT_LINE('Summary SCP Plan - END ===============================================================================================================================================================');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_MODEL_PROD_PLAN_AMEND; */
/* select * from #TBL_SCP0103_SCP_TREE_PROD; */
/* select * from #TBL_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND;rollback tran;return; */


        DBMS_OUTPUT.PUT_LINE('Summary MRP - BEGIN ===============================================================================================================================================================');

        DELETE FROM GT_SCP0103_RAW;

        INSERT INTO GT_SCP0103_RAW
        SELECT  *
        FROM    SCM_DNM_MAT_MRP_SUPPLY
        WHERE   1=1
            AND CUTOFF_DATE = V_MRP_PLAN_START_YYYYMMDD;

/* TESTING : OK */
/* select  * from #TBL_SCP0103_RAW;return; */

        DBMS_OUTPUT.PUT_LINE('MRP - BEGIN');
        DELETE FROM GT_SCP0103_MRP_TEMP;

        INSERT INTO GT_SCP0103_MRP_TEMP
        SELECT    V_SCP_PLAN_START_YYYYMMDD                                            AS SCP_PLAN_START_YYYYMMDD
                , V_MRP_PLAN_START_YYYYMMDD                                            AS MRP_PLAN_START_YYYYMMDD
                , CASE
                    WHEN A.DATA_TYPE = 'S' THEN 'I'
                    WHEN A.DATA_TYPE = 'M' THEN 'P'
                    ELSE '-'
                  END                                                                   AS PSI
                , CAST(
                    CASE
                        WHEN A.DATA_TYPE = 'S' THEN 'BALANCE'
                        WHEN A.DATA_TYPE = 'M' THEN 'SUPPLY_PLAN'
                        ELSE '-'
                    END AS VARCHAR2(100 CHAR))                                          AS MEASURE
                , G.COMPANY_ID                                                          AS COMPANY
                , P.DIVISION_ID
                , P.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.ITEM_ID                                                             AS MATERIAL
                , O.OPERATION_GROUP
                , CAST('-' AS VARCHAR2(20 CHAR))                                        AS OPERATION_ID
                , CAST('-' AS VARCHAR2(100 CHAR))                                       AS ITEM_ID
                , A.RTA                                                                 AS YYYYMMDD
                , C.BASIS_YYYYMM                                                        AS YYYYMM
                , SUBSTR(C.BASIS_YYYYMM, -6) || C.ISO_WEEK                              AS WEEK
                , SUBSTR(C.ISO_YYYYMM, -6) || C.ISO_WEEK                                AS ISO_WEEK
                , A.ATTR_07                                                             AS UOM
                , CAST('-' AS VARCHAR2(300 CHAR))                                       AS NICKNAME
                , CASE
                    /* [PJ20257329] 변경전 WHEN I.FLOW_ID IN ('A3000', 'A9000', 'F6200', 'F7000', 'F7100', 'F7200', 'F7300') THEN I.NICK_NAME */
                    WHEN I.FLOW_ID IN (SELECT OPERATION_ID FROM GT_SCP0103_SCP_CELL_PLAN_OP_ALL) THEN I.NICK_NAME /* [PJ20257329] Cell 계획 공정 하드 코딩 변경 */
                    ELSE
                        CASE
                        WHEN I.OPERATION_GROUP = 'P' THEN (
                                                            SELECT  NICK_NAME
                                                            FROM    SCP_MST_FINAL_ITEM B
                                                            WHERE   1=1
                                                                AND B.DIVISION_ID   = I.DIVISION_ID
                                                                AND B.ITEM_ID       = I.ITEM_ID
                                                        )
                        ELSE ''
                        END
                    END AS CELL_MODEL_NICKNAME
                , A.ATTR_01                                                             AS SUPPLIER
                , A.ATTR_08                                                             AS ITEM_CATEGORY
                , A.QTY
                , CAST(NULL AS NUMBER(20, 10))                                          AS CELL_CF
                , CAST(NULL AS NUMBER(20, 10))                                          AS YIELD_RATE
                , CAST(NULL AS VARCHAR2(4000 CHAR))                                     AS REMARK
                , CAST(A.ATTR_06 AS VARCHAR2(200 CHAR))                                 AS ATTRIBUTE1 /* 반제품코드 */
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE2 /* '-' : 반제품 제외 수량, 'SUM' : 반제품 포함 수량, 'SEMI' 반제품 수량 */
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE3
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE4
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE5
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE6
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE7
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE8
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE9
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE10
        FROM    GT_SCP0103_RAW A
              , (
                                SELECT    PLANT_ID
                                        , COMPANY_ID
                                FROM    GT_SCP0103_PLANT_ALL
                                GROUP BY  PLANT_ID
                                        , COMPANY_ID
                          ) G
              , (
                                /* SELECT    PLANT_ID */
                                /* , OPERATION_GROUP */
                                /* FROM    #TBL_SCP0103_PLANT_ALL */
                                /* GROUP BY  PLANT_ID */
                                /* , OPERATION_GROUP */
                                SELECT    PLANT_ID
                                        , MATERIAL
                                        , OPERATION_GROUP
                                FROM    (
                                            SELECT    PLANT_ID
                                                    , MATERIAL
                                                    , OPERATION_GROUP
                                                    , ROW_NUMBER() OVER (PARTITION BY PLANT_ID, MATERIAL ORDER BY OPERATION_GROUP) RN
                                            FROM    GT_SCP0103_OPERATION_GROUP_PROD
                                            GROUP BY  DIVISION_ID
                                                    , PLANT_ID
                                                    , OPERATION_GROUP
                                                    , MATERIAL
                                        ) A
                                WHERE   1=1
                                    AND RN = 1
                          ) O
              , GT_SCP0103_PLANT P
              , SCM_SYS_CALENDAR_M C
              , SCP_MST_FINAL_ITEM I
        WHERE   A.PLANT_ID           = G.PLANT_ID(+)
            AND A.PLANT_ID      = O.PLANT_ID(+)
            AND A.ITEM_ID       = O.MATERIAL(+)
            AND A.PLANT_ID      = P.PLANT_ID(+)
            AND A.RTA           = C.BASIS_YYYYMMDD(+)
            AND A.ITEM_ID       = I.ITEM_ID(+);

/* TESTING : OK */
/* select  * from #TBL_SCP0103_RAW; */
/* select  * from #TBL_SCP0103_MRP_TEMP;rollback tran;return; */

        DELETE FROM GT_SCP0103_SUPPLIER;

        INSERT INTO GT_SCP0103_SUPPLIER
        SELECT    MATERIAL
                , SUPPLIER
        FROM    GT_SCP0103_MRP_TEMP
        WHERE   1=1
            AND SUPPLIER IS NOT NULL
        GROUP BY  MATERIAL
                , SUPPLIER;

/* TESTING : OK */
/* select  * from #TBL_SCP0103_SUPPLIER; */

        UPDATE   GT_SCP0103_MRP_TEMP A
        SET      A.SUPPLIER = (
                                SELECT B.SUPPLIER
                                FROM   GT_SCP0103_SUPPLIER B
                                WHERE  B.MATERIAL = A.MATERIAL
                                    AND ROWNUM = 1
                              )
        WHERE   1=1
            AND A.MEASURE = 'BALANCE'
            AND A.SUPPLIER IS NULL
            AND EXISTS (
                            SELECT 1
                            FROM   GT_SCP0103_SUPPLIER B
                            WHERE  B.MATERIAL = A.MATERIAL
                       );

/* TESTING : OK */
/* select  * from #TBL_SCP0103_SUPPLIER; */
/* select  * from #TBL_SCP0103_MRP_TEMP;rollback tran;return; */

        DELETE FROM GT_SCP0103_MRP_I;

        INSERT INTO GT_SCP0103_MRP_I
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.CELL_MODEL_NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_MRP_TEMP A
        WHERE   1=1
            AND A.PSI = 'I';
/* TESTING : OK */
/* select  * from #TBL_SCP0103_MRP_I;rollback tran;return; */

        DELETE FROM GT_SCP0103_MRP_I_MATERIAL;

        INSERT INTO GT_SCP0103_MRP_I_MATERIAL
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.ITEM_CATEGORY
        FROM    GT_SCP0103_MRP_I A
        GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.ITEM_CATEGORY;
/* TESTING : OK */
/* select * from #TBL_SCP0103_MRP_I_MATERIAL;rollback tran;return; */

        DELETE FROM GT_SCP0103_MRP_P;

        INSERT INTO GT_SCP0103_MRP_P
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.CELL_MODEL_NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_MRP_TEMP A
        WHERE   1=1
            AND A.PSI = 'P';

/* TESTING : OK */
/* select  * from #TBL_SCP0103_MRP_P;rollback tran;return; */

        /* REQUIREMENT UOM 변환용 */
        DELETE FROM GT_SCP0103_MRP_P_UOM;

        INSERT INTO GT_SCP0103_MRP_P_UOM
        SELECT    A.MATERIAL
                , A.UOM
        FROM    GT_SCP0103_MRP_P A
        WHERE   1=1
            AND A.UOM IS NOT NULL
        GROUP BY  A.MATERIAL
                , A.UOM;

        DBMS_OUTPUT.PUT_LINE('MRP - END');


        DBMS_OUTPUT.PUT_LINE('반제품 재고 - BEGIN');

        DBMS_OUTPUT.PUT_LINE('반제품 재고 - #TBL_SCP0103_MRP_P_SEMI_TEMP - BEGIN');
        DELETE FROM GT_SCP0103_MRP_P_SEMI_TEMP;

        INSERT INTO GT_SCP0103_MRP_P_SEMI_TEMP
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , CAST('-' AS VARCHAR2(20 CHAR))    AS OPERATION_ID
                , B.PROD_ITEM_ID		            AS ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.CELL_MODEL_NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , CAST(NULL AS NUMBER(20, 10))      AS QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , CAST(NULL AS VARCHAR2(200 CHAR))  AS ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_MRP_P A

                CROSS JOIN LATERAL (
                                SELECT    COLUMN_VALUE     AS PROD_ITEM_ID
                                FROM    TABLE(STRING_SPLIT(A.ATTRIBUTE1, '^'))
                                GROUP BY  COLUMN_VALUE
                            ) B
                JOIN GT_SCP0103_ITEM_OPERATION C ON
                        A.COMPANY            = C.COMPANY_ID
                    AND A.ORIGIN_DIVISION_ID = C.DIVISION_ID
                    AND B.PROD_ITEM_ID       = C.ITEM_ID
        WHERE   1=1
            AND UPPER(A.ITEM_CATEGORY) IN ('CATHODE ACTIVE MATERIAL', 'ANODE ACTIVE MATERIAL');

        DBMS_OUTPUT.PUT_LINE('반제품 재고 - #TBL_SCP0103_MRP_P_SEMI_TEMP - END');
/* TESTING : OK */
/* select  * from #TBL_SCP0103_MRP_P_SEMI_TEMP;rollback tran;return; */

        DELETE FROM GT_SCP0103_MRP_P_ITEM_CATEGORY;

        INSERT INTO GT_SCP0103_MRP_P_ITEM_CATEGORY
        SELECT    A.MATERIAL
                , A.ITEM_CATEGORY
        FROM    (
                    SELECT    MATERIAL
                            , ITEM_CATEGORY
                    FROM    GT_SCP0103_MRP_P
                    WHERE   1=1
                        AND ITEM_CATEGORY IS NOT NULL
                    UNION ALL
                    SELECT    MATERIAL
                            , ITEM_CATEGORY
                    FROM    GT_SCP0103_MRP_I_MATERIAL
                    WHERE   1=1
                        AND ITEM_CATEGORY IS NOT NULL
                ) A
        GROUP BY  A.MATERIAL
                , A.ITEM_CATEGORY;

        /* SCP PLAN 'P' 필터용 */
        DELETE FROM GT_SCP0103_MRP_P_PLAN_KEYS;

        INSERT INTO GT_SCP0103_MRP_P_PLAN_KEYS
        SELECT    A.COMPANY
                /* , A.DIVISION_ID */
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
        FROM    GT_SCP0103_MRP_P A
        GROUP BY  A.COMPANY
                /* , A.DIVISION_ID */
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL;
/* TESTING : OK */
/* select  * from #TBL_SCP0103_MRP_P_PLAN_KEYS;rollback tran;return; */

        /* SCP PLAN 반제품추가용(A9000) */
        DELETE FROM GT_SCP0103_MRP_P_MATERIAL;

        INSERT INTO GT_SCP0103_MRP_P_MATERIAL
        SELECT  A.MATERIAL
        FROM    GT_SCP0103_MRP_P A
        GROUP BY A.MATERIAL;

/* TESTING : OK */
/* select  * from #TBL_SCP0103_MRP_P_MATERIAL;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('SEMI 에 해당하는 MODEL 목록 - #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL - BEGIN');

        DELETE FROM GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW;

        INSERT INTO GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW
        SELECT    T.COMPANY_ID
                , T.DIVISION_ID
                , T.PLANT_ID
                , I.FLOW_ID                    AS OPERATION_ID
                , T.MODEL_ID                   AS CP_ITEM_ID
                , M.ITEM_ID_ASSY               AS CA_ITEM_ID
                , T.CHILD_ITEM_ID              AS MATERIAL
                , G.ITEM_CATEGORY
                , T.ACCUMULATED_CHILD_QTY
                , T.ALT_PRIORITY
        FROM    SCM_MST_BOM_SN T
              , SCP_MST_FINAL_ITEM I
              , SCP_MST_CELL_PROD_ASSY_MAP M
              , GT_SCP0103_MRP_P_MATERIAL C
              , GT_SCP0103_MRP_P_ITEM_CATEGORY G
        WHERE   1=1
            AND I.DIVISION_ID          = T.DIVISION_ID
            AND I.ITEM_ID              = T.MODEL_ID
            AND I.OPERATION_GROUP      = 'A'
            AND I.ATTRIBUTE8           = 'CP'
            AND M.DIVISION_ID          = T.DIVISION_ID
            AND M.PLANT_ID             = T.PLANT_ID
            AND M.ITEM_ID_PROD         = T.MODEL_ID
            AND M.CELL_TYPE            = 'CA1'
            AND T.CHILD_ITEM_ID        = C.MATERIAL
            AND T.CHILD_ITEM_ID        = G.MATERIAL(+)
            AND T.ALT_PRIORITY = 'Y';

/* TESTING : NOK */
/* select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW;rollback tran;return; */

        DELETE FROM GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP;

        INSERT INTO GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP
        SELECT    A.COMPANY_ID
                , A.DIVISION_ID
                , A.PLANT_ID
                , A.OPERATION_ID
                , A.CP_ITEM_ID
                , A.CA_ITEM_ID
                , A.MATERIAL
                , A.ITEM_CATEGORY
                , SUM(A.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
        FROM    GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW A
        GROUP BY  A.COMPANY_ID
                , A.DIVISION_ID
                , A.PLANT_ID
                , A.OPERATION_ID
                , A.CP_ITEM_ID
                , A.CA_ITEM_ID
                , A.ITEM_CATEGORY
                , A.MATERIAL;

/* TESTING : OK */
/* select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP;rollback tran;return; */

        DELETE FROM GT_SCP0103_MRP_MODEL_SEMI_MATERIAL;

        INSERT INTO GT_SCP0103_MRP_MODEL_SEMI_MATERIAL
        SELECT    A.COMPANY_ID
                , A.DIVISION_ID
                , A.PLANT_ID
                , A.OPERATION_ID
                , A.CP_ITEM_ID
                , A.CA_ITEM_ID
                , A.MATERIAL
                , A.ITEM_CATEGORY
                , SUM(A.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
        FROM    GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP A
        WHERE   1=1
            AND UPPER(A.ITEM_CATEGORY) IN ('CATHODE ACTIVE MATERIAL', 'ANODE ACTIVE MATERIAL')
        GROUP BY  A.COMPANY_ID
                , A.DIVISION_ID
                , A.PLANT_ID
                , A.OPERATION_ID
                , A.CP_ITEM_ID
                , A.CA_ITEM_ID
                , A.MATERIAL
                , A.ITEM_CATEGORY;

/* TESTING : OK */
/* select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL;rollback tran;return; */

        DELETE FROM GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_EE;

        INSERT INTO GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_EE
        SELECT    A.COMPANY_ID
                , A.DIVISION_ID
                , A.PLANT_ID
                , A.OPERATION_ID
                , A.CP_ITEM_ID
                , A.CA_ITEM_ID
                , A.MATERIAL
                , A.ITEM_CATEGORY
                , SUM(A.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
        FROM    GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP A
              , SCM_MST_MODEL_FINAL_ITEM_BOM_V B
        WHERE   1=1
            AND A.DIVISION_ID           = B.DIVISION_ID
            AND A.PLANT_ID              = B.PLANT_ID
            AND A.CA_ITEM_ID            = B.MODEL_ID
            AND B.OPERATION_GROUP_ID    = 'E'
        GROUP BY  A.COMPANY_ID
                , A.DIVISION_ID
                , A.PLANT_ID
                , A.OPERATION_ID
                , A.CP_ITEM_ID
                , A.CA_ITEM_ID
                , A.MATERIAL
                , A.ITEM_CATEGORY;

        DBMS_OUTPUT.PUT_LINE('SEMI 에 해당하는 MODEL 목록 - #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL - END');

/* TESTING : OK */
/* select  * from #TBL_SCP0103_MRP_MODEL_SEMI_MATERIAL_EE;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('반제품 재고 - #TBL_SCP0103_MRP_P_SEMI - BEGIN');
        DELETE FROM GT_SCP0103_MRP_P_SEMI;

        INSERT INTO GT_SCP0103_MRP_P_SEMI
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.UOM
                , V_MRP_PLAN_START_YYYYMMDD        AS  YYYYMMDD
        FROM    GT_SCP0103_MRP_P_SEMI_TEMP A
        GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.UOM;


        DBMS_OUTPUT.PUT_LINE('반제품 재고 - #TBL_SCP0103_SCM_DNM_STOCK - BEGIN');
        DELETE FROM GT_SCP0103_SCM_DNM_STOCK;

        INSERT INTO GT_SCP0103_SCM_DNM_STOCK
        SELECT    A.COMPANY_ID
                , B.ELEC_DIVISION_ID    AS DIVISION_ID
                , B.ELEC_PLANT_ID       AS PLANT_ID
                , A.ITEM_ID
                , A.QTY_UOM
                , A.CUTOFF_DATE
                , O.OPERATION_GROUP
                , SUM(A.SCM_QTY)        AS QTY
        FROM    SCM_DNM_STOCK A
              , (
                                SELECT    ASSY_DIVISION_ID
                                        , ASSY_PLANT_ID
                                        , ELEC_DIVISION_ID
                                        , ELEC_PLANT_ID
                                FROM    GT_SCP0103_EE_PLANT
                          ) B
              , (
                                SELECT    PLANT_ID
                                        , OPERATION_GROUP
                                FROM    GT_SCP0103_PLANT_ALL
                                GROUP BY  PLANT_ID
                                        , OPERATION_GROUP
                          ) O
        WHERE   1=1
            AND A.DIVISION_ID    = B.ASSY_DIVISION_ID(+)
            AND A.PLANT_ID       = B.ASSY_PLANT_ID(+)
            AND A.PLANT_ID           = O.PLANT_ID(+)
            AND SCM_SITE_ID IS NOT NULL
            AND CUTOFF_DATE = V_MRP_PLAN_START_YYYYMMDD_PRE
        GROUP BY  A.COMPANY_ID
                , B.ELEC_DIVISION_ID
                , B.ELEC_PLANT_ID
                , A.ITEM_ID
                , A.QTY_UOM
                , A.CUTOFF_DATE
                , O.OPERATION_GROUP;

        DBMS_OUTPUT.PUT_LINE('반제품 재고 - #TBL_SCP0103_SCM_DNM_STOCK - END');

/* TESTING : OK */
/* select  * from #TBL_SCP0103_SCM_DNM_STOCK;rollback tran;return; */

        /* SEMI STOCK 상세내역 - 반제품코드(ITEM_ID) 별로 볼 때 이 테이블 조회 */
        DBMS_OUTPUT.PUT_LINE('반제품 재고 - #TBL_SCP0103_MRP_P_SEMI_STOCK - BEGIN');
        DELETE FROM GT_SCP0103_MRP_P_SEMI_STOCK;

        INSERT INTO GT_SCP0103_MRP_P_SEMI_STOCK
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , 'I'                                                           AS PSI
                , CAST('BALANCE' AS VARCHAR2(100 CHAR))                         AS MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , V_MRP_PLAN_START_YYYYMMDD_PRE                                 AS YYYYMMDD
                , A.UOM
                , B.QTY_UOM                                                     AS SEMI_UOM
                , B.QTY                                                         AS SEMI_QTY
                , T.ACCUMULATED_CHILD_QTY                                       AS CF
                , NVL(B.QTY, 0.0) * NVL(T.ACCUMULATED_CHILD_QTY, 0.0)           AS QTY
                , CAST('SEMI' AS VARCHAR2(200 CHAR))                            AS ATTRIBUTE2
        FROM    GT_SCP0103_MRP_P_SEMI A
              , GT_SCP0103_SCM_DNM_STOCK B
              , GT_SCP0103_SCP_TREE_KEYS T
        WHERE   A.COMPANY               = B.COMPANY_ID(+)
            AND A.ORIGIN_DIVISION_ID    = B.DIVISION_ID(+)
            AND A.PLANT_ID              = B.PLANT_ID(+)
            AND A.ITEM_ID               = B.ITEM_ID(+)
            AND A.OPERATION_GROUP       = B.OPERATION_GROUP(+)
/* SEMI STOCK 은 MRP 계획 시작전 일자로 집계                        AND A.YYYYMMDD              = B.CUTOFF_DATE; */
            AND A.ORIGIN_DIVISION_ID	= T.DIVISION_ID(+)
            AND A.PLANT_ID		        = T.PLANT_ID(+)
            AND A.ITEM_ID		        = T.MODEL_ID(+)
            AND A.MATERIAL              = T.CHILD_ITEM_ID(+);

        DBMS_OUTPUT.PUT_LINE('반제품 재고 - #TBL_SCP0103_MRP_P_SEMI_STOCK - END');
        DBMS_OUTPUT.PUT_LINE('반제품 재고 - END');

/* TESTING : OK */
/* select * from #TBL_SCP0103_MRP_P_SEMI_STOCK;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('반제품 재고 - 자재별 합계 - BEGIN');
        DELETE FROM GT_SCP0103_MRP_P_SEMI_STOCK_SUM;

        INSERT INTO GT_SCP0103_MRP_P_SEMI_STOCK_SUM
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.COMPANY
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.YYYYMMDD
                , A.UOM
                , A.OPERATION_GROUP
                , CASE WHEN NVL(SUM(A.QTY), 0) < 0 THEN 0 ELSE SUM(A.QTY) END         AS QTY
        FROM    GT_SCP0103_MRP_P_SEMI_STOCK A
        GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.COMPANY
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.UOM
                , A.OPERATION_GROUP
                , A.YYYYMMDD;
        DBMS_OUTPUT.PUT_LINE('반제품 재고 - 자재별 합계 - END');

/* TESTING : OK */
/* select  * from #TBL_SCP0103_MRP_P_SEMI_STOCK_SUM;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('재고 + 반제품 합산 - BEGIN');
        DELETE FROM GT_SCP0103_MRP_I_TEMP;

        INSERT INTO GT_SCP0103_MRP_I_TEMP
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , 'I'                                       AS PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.CELL_MODEL_NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , CASE WHEN NVL(A.QTY, 0) < 0 THEN 0 ELSE A.QTY END         AS QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_MRP_I A
        GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.CELL_MODEL_NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10;

/* TESTING : OK */
/* select  * from #TBL_SCP0103_MRP_I_TEMP;rollback tran;return; */

        DELETE FROM GT_SCP0103_MRP_I_ALL;

        INSERT INTO GT_SCP0103_MRP_I_ALL
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , 'I'                                       AS PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.CELL_MODEL_NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.QTY                             /* 반제품 제외 수량 (Operation Group 'E' 일때 표시) */
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_MRP_I_TEMP A;

        INSERT INTO GT_SCP0103_MRP_I_ALL
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , 'I'                                       AS PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , CAST('SUM' AS VARCHAR2(100 CHAR))         AS ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.CELL_MODEL_NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , (NVL(A.QTY, 0.0) + NVL(B.QTY, 0.0))      AS QTY /* 반제품 포함 수량 (Operation Group 'A' 일때 표시) */
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_MRP_I_TEMP A
              , GT_SCP0103_MRP_P_SEMI_STOCK_SUM B
        WHERE   A.COMPANY               = B.COMPANY(+)
            AND A.ORIGIN_DIVISION_ID    = B.ORIGIN_DIVISION_ID(+)
            AND A.PLANT_ID              = B.PLANT_ID(+)
            AND A.MATERIAL              = B.MATERIAL(+)
            AND A.OPERATION_GROUP       = B.OPERATION_GROUP(+);
/* #TBL_SCP0103_MRP_I 는 계획일자 전날자로 집계                         AND A.YYYYMMDD              = B.YYYYMMDD */
        DBMS_OUTPUT.PUT_LINE('재고 + 반제품 합산 - BEGIN');
        DBMS_OUTPUT.PUT_LINE('재고 + 반제품 합산 - END');
/* TESTING : OK */
/* select  * from #TBL_SCP0103_MRP_I_ALL;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('Summary MRP - END ===============================================================================================================================================================');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;


        DBMS_OUTPUT.PUT_LINE('생산계획 취합 - BEGIN');
        DELETE FROM GT_SCP0103_SCP_PLAN;

        INSERT INTO GT_SCP0103_SCP_PLAN
        SELECT	  A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.OPERATION_ID
                , A.MEASURE
                , A.YYYYMMDD
                , A.QTY
                , A.DIVISION_NAME
                , A.OPERATION_GROUP_NAME
                , A.SCM_SITE_DESCRIPTION
                , A.NICK_NAME
                , A.ORIGIN_DIVISION_ID
                , A.ELECTRODE_TYPE
                , B.YIELD AS YIELD_RATE
        FROM    GT_SCP0103_SCP_FN_LINE A
              , GT_SCP0103_YIELD B
/* A.DIVISION_ID           = B.DIVISION_ID */
        WHERE   A.ORIGIN_DIVISION_ID    = B.DIVISION_ID(+)
            AND A.SCM_SITE_ID           = B.PLANT_SITE_ID(+)
            AND A.ITEM_ID               = B.ITEM_ID(+)
            AND A.OPERATION_ID          = B.OPERATION_ID(+)
            AND A.YYYYMMDD BETWEEN B.TACT_TIME_START_DATE(+) AND B.TACT_TIME_END_DATE(+);
        DBMS_OUTPUT.PUT_LINE('생산계획 취합 - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;
/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN;rollback tran;return; */

        /* MATERIAL 최초 매핑 */
        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD - BEGIN');
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1;

        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1
        SELECT    V_SCP_PLAN_START_YYYYMMDD   											AS SCP_PLAN_START_YYYYMMDD
                , V_MRP_PLAN_START_YYYYMMDD                                            AS MRP_PLAN_START_YYYYMMDD
                , 'S'                                                                   AS PSI
                , 'PROD_PLAN_AMEND'														AS MEASURE
                , G.COMPANY_ID                                                          AS COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.SCM_SITE_ID
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , U.UOM
                , A.QTY
                , A.YIELD_RATE
        FROM    GT_SCP0103_SCP_PLAN A
              , GT_SCP0103_OPERATION O
              , GT_SCP0103_PLANT_ALL G
              , GT_SCP0103_ITEM_UOM U
        WHERE   A.OPERATION_ID          = O.OPERATION_ID
            AND A.ORIGIN_DIVISION_ID    = G.DIVISION_ID(+)
            AND A.SCM_SITE_ID           = G.SCM_SITE_ID(+)
            AND A.ORIGIN_DIVISION_ID	= U.DIVISION_ID(+)
            AND A.ITEM_ID		        = U.ITEM_ID(+);
/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1;rollback tran;return; */

        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT;

        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , G.PLANT_ID
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.UOM
                , A.QTY
                , A.YIELD_RATE
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1 A
              , GT_SCP0103_PLANT_ALL G
        WHERE   A.COMPANY               = G.COMPANY_ID(+)
            AND A.ORIGIN_DIVISION_ID    = G.DIVISION_ID(+)
            AND A.SCM_SITE_ID           = G.SCM_SITE_ID(+);

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT;rollback tran;return; */

        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE;

        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , B.CHILD_ITEM_ID                                                       AS MATERIAL
                , O.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.UOM
                , AVG(A.QTY)                                                            AS QTY
                , AVG(B.ACCUMULATED_CHILD_QTY)                                          AS CELL_CF
                , AVG(A.YIELD_RATE)                                                     AS YIELD_RATE
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT A
              , GT_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND B
              , GT_SCP0103_OPERATION_GROUOP O
        WHERE   1=1
            AND A.ORIGIN_DIVISION_ID    = B.DIVISION_ID
            AND A.PLANT_ID              = B.PLANT_ID
            AND A.ITEM_ID               = B.MODEL_ID
            AND A.OPERATION_ID          = B.MODEL_FLOW_ID
            AND A.OPERATION_ID          = O.OPERATION_ID(+)
        GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , O.OPERATION_GROUP
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , B.CHILD_ITEM_ID
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.UOM;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE;rollback tran;return; */

        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL;

        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL                                                           AS MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , C.BASIS_YYYYMM                                                        AS YYYYMM
                , SUBSTR(C.BASIS_YYYYMM, -6) || C.ISO_WEEK                              AS WEEK
                , SUBSTR(C.ISO_YYYYMM, -6) || C.ISO_WEEK                                AS ISO_WEEK
                , A.UOM
                , M.NICK_NAME                                                           AS NICKNAME
                , S.SUPPLIER
                , I.ITEM_CATEGORY
                , AVG(A.QTY)                                                            AS QTY
                , AVG(A.CELL_CF)                                                        AS CELL_CF
                , AVG(A.YIELD_RATE)                                                     AS YIELD_RATE
                , CAST(NULL AS VARCHAR2(4000 CHAR))	                                    AS REMARK
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE1
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE2
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE3
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE4
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE5
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE6
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE7
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE8
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE9
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE10
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE A
              , GT_SCP0103_MRP_P_ITEM_CATEGORY I
              , SCM_SYS_CALENDAR_M C
              , SCM_MST_ITEM_SN M
              , GT_SCP0103_SUPPLIER S
        WHERE   A.MATERIAL              = I.MATERIAL(+)
            AND A.YYYYMMDD              = C.BASIS_YYYYMMDD(+)
            AND A.ORIGIN_DIVISION_ID    = M.DIVISION_ID(+)
            AND A.ITEM_ID               = M.ITEM_ID(+)
            AND A.MATERIAL              = S.MATERIAL(+)
        GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , C.BASIS_YYYYMM
                , SUBSTR(C.BASIS_YYYYMM, -6) || C.ISO_WEEK
                , SUBSTR(C.ISO_YYYYMM, -6) || C.ISO_WEEK
                , A.UOM
                , M.NICK_NAME
                , S.SUPPLIER
                , I.ITEM_CATEGORY;

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD - END');

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL where MATERIAL IN ('RAAGP0006A');rollback tran;return; */

        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD;

        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL A
/* 'P' Material로만 Filter x                    INNER JOIN #TBL_SCP0103_MRP_P_MATERIAL B ON */
/* 'P' Material로만 Filter x                            A.MATERIAL          = B.MATERIAL; */
              , GT_SCP0103_MRP_P_PLAN_KEYS B
        WHERE   A.COMPANY				= B.COMPANY
                    /* AND A.DIVISION_ID			= B.DIVISION_ID */
/* 전극사업부는 사업부/plant 달라지므로 material 로만 filter                        AND A.ORIGIN_DIVISION_ID	= B.ORIGIN_DIVISION_ID */
/* 전극사업부는 사업부/plant 달라지므로 material 로만 filter                        AND A.PLANT_ID				= B.PLANT_ID */
            AND A.MATERIAL				= B.MATERIAL;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP - BEGIN');
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP;

        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP
        SELECT    V_SCP_PLAN_START_YYYYMMDD   											AS SCP_PLAN_START_YYYYMMDD
                , V_MRP_PLAN_START_YYYYMMDD                                            AS MRP_PLAN_START_YYYYMMDD
                , 'S'                                                                   AS PSI
                , 'PROD_PLAN_AMEND'														AS MEASURE
                , G.COMPANY_ID                                                          AS COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , G.PLANT_ID
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , U.UOM
                , AVG(A.QTY)                                                            AS QTY
                , AVG(A.YIELD_RATE)                                                     AS YIELD_RATE
        FROM    GT_SCP0103_SCP_PLAN A
              , GT_SCP0103_OPERATION O
              , GT_SCP0103_PLANT_ALL G
              , GT_SCP0103_ITEM_UOM U
        WHERE   A.OPERATION_ID          = O.OPERATION_ID
            AND A.DIVISION_ID           = G.DIVISION_ID(+)
            AND A.SCM_SITE_ID           = G.SCM_SITE_ID(+)
            AND A.ORIGIN_DIVISION_ID	= U.DIVISION_ID(+)
            AND A.ITEM_ID		        = U.ITEM_ID(+)
        GROUP BY  G.COMPANY_ID
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , G.PLANT_ID
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , U.UOM;

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP - END');

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL - BEGIN');
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL;

        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , B.MATERIAL
                , O.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.UOM
                , AVG(A.QTY)                                                            AS QTY
                , AVG(B.ACCUMULATED_CHILD_QTY)                                          AS CELL_CF
                , AVG(A.YIELD_RATE)                                                     AS YIELD_RATE
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP A
              , GT_SCP0103_MRP_MODEL_SEMI_MATERIAL B
              , GT_SCP0103_OPERATION_GROUOP O
        WHERE   1=1
            AND A.COMPANY               = B.COMPANY_ID
            AND A.DIVISION_ID           = B.DIVISION_ID
            AND A.PLANT_ID              = B.PLANT_ID
            AND A.OPERATION_ID          = B.OPERATION_ID
            AND A.ITEM_ID               = B.CA_ITEM_ID
            AND A.OPERATION_ID          = O.OPERATION_ID(+)
        GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , B.MATERIAL
                , O.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.UOM;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL - BEGIN');
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL;

        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , C.BASIS_YYYYMM                                                        AS YYYYMM
                , SUBSTR(C.BASIS_YYYYMM, -6) || C.ISO_WEEK                              AS WEEK
                , SUBSTR(C.ISO_YYYYMM, -6) || C.ISO_WEEK                                AS ISO_WEEK
                , A.UOM
                , M.NICK_NAME                                                           AS NICKNAME
                , S.SUPPLIER
                , I.ITEM_CATEGORY
                , AVG(A.QTY)                                                            AS QTY
                , AVG(A.CELL_CF)                                                        AS CELL_CF
                , AVG(A.YIELD_RATE)                                                     AS YIELD_RATE
                , CAST(NULL AS VARCHAR2(4000 CHAR))	                                    AS REMARK
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE1
                , CAST('SEMI' AS VARCHAR2(200 CHAR))                                    AS ATTRIBUTE2
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE3
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE4
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE5
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE6
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE7
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE8
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE9
                , CAST(NULL AS VARCHAR2(200 CHAR))	                                    AS ATTRIBUTE10
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL A
              , GT_SCP0103_MRP_P_ITEM_CATEGORY I
              , SCM_SYS_CALENDAR_M C
              , SCM_MST_ITEM_SN M
              , GT_SCP0103_SUPPLIER S
        WHERE   A.MATERIAL              = I.MATERIAL(+)
            AND A.YYYYMMDD              = C.BASIS_YYYYMMDD(+)
            AND A.ORIGIN_DIVISION_ID    = M.DIVISION_ID(+)
            AND A.ITEM_ID               = M.ITEM_ID(+)
            AND A.MATERIAL              = S.MATERIAL(+)
        GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , C.BASIS_YYYYMM
                , SUBSTR(C.BASIS_YYYYMM, -6) || C.ISO_WEEK
                , SUBSTR(C.ISO_YYYYMM, -6) || C.ISO_WEEK
                , A.UOM
                , M.NICK_NAME
                , S.SUPPLIER
                , I.ITEM_CATEGORY;

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL - END');

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI - BEGIN');

        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI;

        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL A
              , GT_SCP0103_MRP_P_PLAN_KEYS B
        WHERE   A.COMPANY				= B.COMPANY
                    /* AND A.DIVISION_ID			= B.DIVISION_ID */
/* 전극사업부는 사업부/plant 달라지므로 material 로만 filter                        AND A.ORIGIN_DIVISION_ID	= B.ORIGIN_DIVISION_ID */
/* 전극사업부는 사업부/plant 달라지므로 material 로만 filter                        AND A.PLANT_ID				= B.PLANT_ID */
            AND A.MATERIAL				= B.MATERIAL;

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI - END');

/* TESTING : OK */
/* --select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND - BEGIN');
        /* 빈테이블 생성 */
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD - BEGIN');
        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND
        SELECT  *
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD;
        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD - END');

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI - BEGIN');
        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND
        SELECT  *
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI;
        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI - END');
/* 전극사업부 & 'A' 취합전 */
/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE - BEGIN');
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE;

        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , CASE
                    WHEN INSTR(DIVISION_ID, '_') > 1 THEN 'EE_' || SUBSTR(DIVISION_ID, 4, 2)
                    WHEN INSTR(DIVISION_ID, '_') = 0 THEN 'EE'
                    ELSE DIVISION_ID
                  END AS DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND A
        WHERE   1=1
                /* 2025.07.2 변경전 AND OPERATION_ID            IN ('A3000', 'A9000'); */
                AND OPERATION_ID            IN (SELECT OPERATION_ID FROM GT_SCP0103_SCP_CELL_FINAL_OP); /* [PJ20257329] Cell 완성 공정 하드 코딩 변경 */

/* TESTING: OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;rollback tran;return; */

        INSERT INTO GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND
        SELECT  *
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE - END');


        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - SCP-TEMP-REQUIREMENT - BEGIN');
        DELETE FROM GT_SCP0103_SCP_PLAN_TEMP_REQUIREMENT;

        INSERT INTO GT_SCP0103_SCP_PLAN_TEMP_REQUIREMENT
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , 'REQUIREMENT'									AS MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , B.UOM     /* REQRUIREMENT UOM 은 MRP -> 'P' UOM */
                , A.NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , (NVL(A.QTY, 0) * NVL(A.CELL_CF, 1) / NVL(A.YIELD_RATE, 1))				AS QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND A
              , GT_SCP0103_MRP_P_UOM B
        WHERE   A.MATERIAL  = B.MATERIAL(+);

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - SCP-TEMP-REQUIREMENT - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;
/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_TEMP_REQUIREMENT;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - SCP-FINAL - BEGIN');
        DELETE FROM GT_SCP0103_SCP_PLAN_FINAL;

        INSERT INTO GT_SCP0103_SCP_PLAN_FINAL
        SELECT    CAST(A.SCP_PLAN_START_YYYYMMDD AS VARCHAR2(8 CHAR))	AS SCP_PLAN_START_YYYYMMDD
                , CAST(A.MRP_PLAN_START_YYYYMMDD AS VARCHAR2(8 CHAR))	AS MRP_PLAN_START_YYYYMMDD
                , CAST(A.PSI AS VARCHAR2(1 CHAR))						AS PSI
                , CAST(A.MEASURE AS VARCHAR2(100 CHAR))					AS MEASURE
                , CAST(A.COMPANY AS VARCHAR2(200 CHAR))					AS COMPANY
                , CAST(A.DIVISION_ID AS VARCHAR2(30 CHAR))				AS DIVISION_ID
                , CAST(A.ORIGIN_DIVISION_ID AS VARCHAR2(30 CHAR))		AS ORIGIN_DIVISION_ID
                , CAST(A.PLANT_ID AS VARCHAR2(50 CHAR))					AS PLANT_ID
                , CAST(A.MATERIAL AS VARCHAR2(50 CHAR))					AS MATERIAL
                , CAST(A.OPERATION_GROUP AS VARCHAR2(20 CHAR))			AS OPERATION_GROUP
                , CAST(A.OPERATION_ID AS VARCHAR2(20 CHAR))				AS OPERATION_ID
                , CAST(A.ITEM_ID AS VARCHAR2(100 CHAR))					AS ITEM_ID
                , CAST(A.YYYYMMDD AS VARCHAR2(8 CHAR))					AS YYYYMMDD
                , CAST(A.YYYYMM AS VARCHAR2(6 CHAR))					AS YYYYMM
                , CAST(A.WEEK AS VARCHAR2(8 CHAR))						AS WEEK
                , CAST(A.ISO_WEEK AS VARCHAR2(8 CHAR))					AS ISO_WEEK
                , CAST(A.UOM AS VARCHAR2(20 CHAR))						AS UOM
                , CAST(A.NICKNAME AS VARCHAR2(300 CHAR))				AS NICKNAME
                , CAST(A.SUPPLIER AS VARCHAR2(200 CHAR))				AS SUPPLIER
                , CAST(A.ITEM_CATEGORY AS VARCHAR2(200 CHAR))			AS ITEM_CATEGORY
                , CAST(AVG(A.QTY) AS NUMBER(20, 10))					AS QTY
                , CAST(AVG(A.CELL_CF) AS NUMBER(20, 10))				AS CELL_CF
                , CAST(AVG(A.YIELD_RATE) AS NUMBER(20, 10))			AS YIELD_RATE
                , CAST(A.REMARK AS VARCHAR2(4000 CHAR))					AS REMARK
                , CAST(A.ATTRIBUTE1 AS VARCHAR2(200 CHAR))				AS ATTRIBUTE1
                , CAST(A.ATTRIBUTE2 AS VARCHAR2(200 CHAR))				AS ATTRIBUTE2
                , CAST(A.ATTRIBUTE3 AS VARCHAR2(200 CHAR))				AS ATTRIBUTE3
                , CAST(A.ATTRIBUTE4 AS VARCHAR2(200 CHAR))				AS ATTRIBUTE4
                , CAST(A.ATTRIBUTE5 AS VARCHAR2(200 CHAR))				AS ATTRIBUTE5
                , CAST(A.ATTRIBUTE6 AS VARCHAR2(200 CHAR))				AS ATTRIBUTE6
                , CAST(A.ATTRIBUTE7 AS VARCHAR2(200 CHAR))				AS ATTRIBUTE7
                , CAST(A.ATTRIBUTE8 AS VARCHAR2(200 CHAR))				AS ATTRIBUTE8
                , CAST(A.ATTRIBUTE9 AS VARCHAR2(200 CHAR))				AS ATTRIBUTE9
                , CAST(A.ATTRIBUTE10 AS VARCHAR2(200 CHAR))				AS ATTRIBUTE10
        FROM    GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND A
        GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM /* PROD_PLAN_AMEND UOM 은 생산계획 오리지널 UOM */
                , A.NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_FINAL;rollback tran;return; */

        INSERT INTO GT_SCP0103_SCP_PLAN_FINAL
        SELECT    CAST(A.SCP_PLAN_START_YYYYMMDD AS VARCHAR2(8 CHAR))
                , CAST(A.MRP_PLAN_START_YYYYMMDD AS VARCHAR2(8 CHAR))
                , CAST(A.PSI AS VARCHAR2(1 CHAR))
                , CAST(A.MEASURE AS VARCHAR2(100 CHAR))
                , CAST(A.COMPANY AS VARCHAR2(200 CHAR))
                , CAST(A.DIVISION_ID AS VARCHAR2(30 CHAR))
                , CAST(A.ORIGIN_DIVISION_ID AS VARCHAR2(30 CHAR))
                , CAST(A.PLANT_ID AS VARCHAR2(50 CHAR))
                , CAST(A.MATERIAL AS VARCHAR2(50 CHAR))
                , CAST(A.OPERATION_GROUP AS VARCHAR2(20 CHAR))
                , CAST(A.OPERATION_ID AS VARCHAR2(20 CHAR))
                , CAST(A.ITEM_ID AS VARCHAR2(100 CHAR))
                , CAST(A.YYYYMMDD AS VARCHAR2(8 CHAR))
                , CAST(A.YYYYMM AS VARCHAR2(6 CHAR))
                , CAST(A.WEEK AS VARCHAR2(8 CHAR))
                , CAST(A.ISO_WEEK AS VARCHAR2(8 CHAR))
                , CAST(A.UOM AS VARCHAR2(20 CHAR)) /* REQUIREMENT UOM 은 MRP로 맞춤 */
                , CAST(A.NICKNAME AS VARCHAR2(300 CHAR))
                , CAST(A.SUPPLIER AS VARCHAR2(200 CHAR))
                , CAST(A.ITEM_CATEGORY AS VARCHAR2(200 CHAR))
                , CAST(AVG(A.QTY) AS NUMBER(20, 10))			AS QTY
                , CAST(AVG(A.CELL_CF) AS NUMBER(20, 10))		AS CELL_CF
                , CAST(AVG(A.YIELD_RATE) AS NUMBER(20, 10))	AS YIELD_RATE
                , CAST(A.REMARK AS VARCHAR2(4000 CHAR))
                , CAST(A.ATTRIBUTE1 AS VARCHAR2(200 CHAR))
                , CAST(A.ATTRIBUTE2 AS VARCHAR2(200 CHAR))
                , CAST(A.ATTRIBUTE3 AS VARCHAR2(200 CHAR))
                , CAST(A.ATTRIBUTE4 AS VARCHAR2(200 CHAR))
                , CAST(A.ATTRIBUTE5 AS VARCHAR2(200 CHAR))
                , CAST(A.ATTRIBUTE6 AS VARCHAR2(200 CHAR))
                , CAST(A.ATTRIBUTE7 AS VARCHAR2(200 CHAR))
                , CAST(A.ATTRIBUTE8 AS VARCHAR2(200 CHAR))
                , CAST(A.ATTRIBUTE9 AS VARCHAR2(200 CHAR))
                , CAST(A.ATTRIBUTE10 AS VARCHAR2(200 CHAR))
        FROM    GT_SCP0103_SCP_PLAN_TEMP_REQUIREMENT A
        GROUP BY  A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_FINAL;rollback tran;return; */

        /* 실사업부이면서 전극 ITEM_CATEGORY 전극 제외 */
        DELETE FROM GT_SCP0103_SCP_PLAN_FINAL
        WHERE   1=1
            AND SUBSTR(DIVISION_ID, 1, 2)      <> 'EE'
            AND OPERATION_GROUP           = 'A'
            AND UPPER(ITEM_CATEGORY)      IN ('ANODE ACTIVE MATERIAL', 'CATHODE ACTIVE MATERIAL');

        /* 전극사업부이면서 전극 전극 ITEM_CATEGORY 이외 제외 */
        DELETE FROM GT_SCP0103_SCP_PLAN_FINAL
        WHERE   1=1
            AND SUBSTR(DIVISION_ID, 1, 2)      = 'EE'
            AND OPERATION_GROUP           = 'A'
            AND UPPER(ITEM_CATEGORY) NOT IN ('ANODE ACTIVE MATERIAL', 'CATHODE ACTIVE MATERIAL');

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_FINAL;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - SCP-FINAL - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;
/* TESTING : OK */
/* select * from #TBL_SCP0103_MRP;rollback tran;return; */
/* select * from #TBL_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD;rollback tran;return; */
/* select * from #TBL_SCP0103_SCP_PLAN_FINAL;rollback tran;return; */


        DBMS_OUTPUT.PUT_LINE('MRP - 재고 취합 - BEGIN');
        DELETE FROM GT_SCP0103_ALL;

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - SCP-FINAL- #TBL_SCP0103_MRP_I_ALL - BEGIN');
        INSERT INTO GT_SCP0103_ALL
        SELECT    CAST(A.SCP_PLAN_START_YYYYMMDD AS VARCHAR2(8 CHAR))		AS SCP_PLAN_START_YYYYMMDD
                , CAST(A.MRP_PLAN_START_YYYYMMDD AS VARCHAR2(8 CHAR))		AS MRP_PLAN_START_YYYYMMDD
                , CAST(A.PSI AS VARCHAR2(1 CHAR))							AS PSI
                , CAST(A.MEASURE AS VARCHAR2(100 CHAR))						AS MEASURE
                , CAST(A.COMPANY AS VARCHAR2(200 CHAR))						AS COMPANY
                , CAST(A.DIVISION_ID AS VARCHAR2(30 CHAR))					AS DIVISION_ID
                , CAST(A.ORIGIN_DIVISION_ID AS VARCHAR2(30 CHAR))			AS ORIGIN_DIVISION_ID
                , CAST(A.PLANT_ID AS VARCHAR2(50 CHAR))						AS PLANT_ID
                , CAST(A.MATERIAL AS VARCHAR2(50 CHAR))						AS MATERIAL
                , CAST(A.OPERATION_GROUP AS VARCHAR2(20 CHAR))			    AS OPERATION_GROUP
                , CAST(A.OPERATION_ID AS VARCHAR2(20 CHAR))					AS OPERATION_ID
                , CAST(A.ITEM_ID AS VARCHAR2(100 CHAR))						AS ITEM_ID
                , CAST(A.YYYYMMDD AS VARCHAR2(8 CHAR))						AS YYYYMMDD
                , CAST(A.YYYYMM AS VARCHAR2(6 CHAR))						AS YYYYMM
                , CAST(A.WEEK AS VARCHAR2(8 CHAR))							AS WEEK
                , CAST(A.ISO_WEEK AS VARCHAR2(8 CHAR))						AS ISO_WEEK
                , CAST(A.UOM AS VARCHAR2(20 CHAR))							AS UOM
                , CAST(A.NICKNAME AS VARCHAR2(300 CHAR))					AS NICKNAME
                , CAST(A.SUPPLIER AS VARCHAR2(200 CHAR))					AS SUPPLIER
                , CAST(A.ITEM_CATEGORY AS VARCHAR2(200 CHAR))				AS ITEM_CATEGORY
                , CAST(A.QTY AS NUMBER(20, 10))							AS QTY
                , CAST(A.CELL_CF AS NUMBER(20, 10))						AS CELL_CF
                , CAST(A.YIELD_RATE AS NUMBER(20, 10))					AS YIELD_RATE
                , CAST(A.REMARK AS VARCHAR2(4000 CHAR))						AS REMARK
                , CAST(A.ATTRIBUTE1 AS VARCHAR2(200 CHAR))					AS ATTRIBUTE1
                , CAST(A.ATTRIBUTE2 AS VARCHAR2(200 CHAR))					AS ATTRIBUTE2
                , CAST(A.ATTRIBUTE3 AS VARCHAR2(200 CHAR))					AS ATTRIBUTE3
                , CAST(A.ATTRIBUTE4 AS VARCHAR2(200 CHAR))					AS ATTRIBUTE4
                , CAST(A.ATTRIBUTE5 AS VARCHAR2(200 CHAR))					AS ATTRIBUTE5
                , CAST(A.ATTRIBUTE6 AS VARCHAR2(200 CHAR))					AS ATTRIBUTE6
                , CAST(A.ATTRIBUTE7 AS VARCHAR2(200 CHAR))					AS ATTRIBUTE7
                , CAST(A.ATTRIBUTE8 AS VARCHAR2(200 CHAR))					AS ATTRIBUTE8
                , CAST(A.ATTRIBUTE9 AS VARCHAR2(200 CHAR))					AS ATTRIBUTE9
                , CAST(A.ATTRIBUTE10 AS VARCHAR2(200 CHAR))					AS ATTRIBUTE10
        FROM    GT_SCP0103_MRP_I_ALL A;
        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - SCP-FINAL- #TBL_SCP0103_MRP_I_ALL - END');

/* TESTINNG : OK */
/* select * from #TBL_SCP0103_ALL;rollback tran;return; */

        /* 기초재고를 반제품별로 내역을 추적하기 위해 집계 테이블에 MATERIAL/ITEM 별 재고 내역 추가 */
        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - SCP-FINAL- #TBL_SCP0103_MRP_P_SEMI_STOCK - BEGIN');
        INSERT INTO GT_SCP0103_ALL
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , C.BASIS_YYYYMM                                                        AS YYYYMM
                , SUBSTR(C.BASIS_YYYYMM, -6) || C.ISO_WEEK                              AS WEEK
                , SUBSTR(C.ISO_YYYYMM, -6) || C.ISO_WEEK                                AS ISO_WEEK
                , A.UOM
                , CAST('-' AS VARCHAR2(300 CHAR))                                       AS NICKNAME
                , CAST(B.SUPPLIER AS VARCHAR2(200 CHAR))                                AS SUPPLIER
                /* , M.ITEM_CATEGORY */
                , I.ITEM_CATEGORY
                , A.QTY
                , A.CF                                                                  AS CELL_CF
                , CAST(NULL AS NUMBER(20, 10))                                          AS YIELD_RATE
                , CAST(NULL AS VARCHAR2(4000 CHAR))                                     AS REMARK
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE1
                , A.ATTRIBUTE2
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE3
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE4
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE5
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE6
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE7
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE8
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE9
                , CAST(NULL AS VARCHAR2(200 CHAR))                                      AS ATTRIBUTE10
        FROM    GT_SCP0103_MRP_P_SEMI_STOCK A
              , GT_SCP0103_SUPPLIER B
              , SCM_SYS_CALENDAR_M C
              , GT_SCP0103_MRP_P_ITEM_CATEGORY I
        WHERE   A.MATERIAL = B.MATERIAL(+)
            AND A.YYYYMMDD                  = C.BASIS_YYYYMMDD(+)
            AND A.MATERIAL              = I.MATERIAL(+);
        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - SCP-FINAL- #TBL_SCP0103_MRP_P_SEMI_STOCK - END');
        DBMS_OUTPUT.PUT_LINE('MRP - 재고 취합 - END');

/* TESTING : OK */
/* select * from #TBL_SCP0103_ALL;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP - SUPPLY_PLAN 취합 - BEGIN');
        INSERT INTO GT_SCP0103_ALL
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , A.OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_MRP_P A;

/* TESTING : OK */
/* select * from #TBL_SCP0103_ALL;rollback tran;return; */

        /* 전극사업부 & Operation Group : A  조회를 위해 MRP 재고, SUPPLU_PLAN 데이터중 Operation Group : E 인 데이터를 => A 로 한 셋트 복사한다 */
        INSERT INTO GT_SCP0103_ALL
        SELECT	  A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , CAST('A' AS VARCHAR2(20 CHAR))			AS OPERATION_GROUP
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
        FROM    GT_SCP0103_ALL A
        WHERE   1=1
            AND A.MEASURE                   IN ('BALANCE', 'SUPPLY_PLAN')
            AND SUBSTR(A.DIVISION_ID, 1, 2) = 'EE'
            AND A.OPERATION_GROUP           = 'E'
            AND UPPER(A.ITEM_CATEGORY)      IN ('ANODE ACTIVE MATERIAL', 'CATHODE ACTIVE MATERIAL');

        DBMS_OUTPUT.PUT_LINE('MRP - SUPPLY_PLAN 취합 - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;

/* TESTING : OK */
/* select * from #TBL_SCP0103_ALL;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - SCP - BEGIN');
        INSERT INTO GT_SCP0103_ALL
        SELECT  *
        FROM    GT_SCP0103_SCP_PLAN_FINAL;
        DBMS_OUTPUT.PUT_LINE('MRP 와 생산계획 취합 - SCP - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;

/* TESTING : OK */
/* select * from #TBL_SCP0103_SCP_PLAN_FINAL;rollback tran;return; */
/* select * from #TBL_SCP0103_ALL;rollback tran;return; */

        /* DELETE #TBL_SCP0103_ALL */
        /* WHERE   1=1 */
        /* AND LEFT(DIVISION_ID, 2) = 'EE' */
        /* AND  ATTRIBUTE3 = 'A'--OPERATION_GROUP */
        /* AND UPPER(ITEM_CATEGORY) NOT IN ('ANODE ACTIVE MATERIAL', 'CATHODE ACTIVE MATERIAL'); --전극사업부 A3000, A9000 은 Anode, Cathode 인 것만 취합 */

/* TESTING : OK */
/* select * from #TBL_SCP0103_ALL;rollback tran;return; */

        DBMS_OUTPUT.PUT_LINE('최종 집계테이블에 추가 - BEGIN');
        INSERT INTO SCP_ANL_MAT_SUPPLY
        SELECT    A.SCP_PLAN_START_YYYYMMDD
                , A.MRP_PLAN_START_YYYYMMDD
                , A.PSI
                , A.MEASURE
                , A.COMPANY
                , A.DIVISION_ID
                , A.ORIGIN_DIVISION_ID
                , A.PLANT_ID
                , A.MATERIAL
                , NVL(A.OPERATION_GROUP, '-')
                , A.OPERATION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.YYYYMM
                , A.WEEK
                , A.ISO_WEEK
                , A.UOM
                , A.NICKNAME
                , A.SUPPLIER
                , A.ITEM_CATEGORY
                , A.QTY
                , A.CELL_CF
                , A.YIELD_RATE
                , A.REMARK
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
                , 'scm_batch'   AS CREATED_BY
                , SYSDATE       AS CREATION_DATE
                , 'scm_batch'   AS LAST_UPDATED_BY
                , SYSDATE       AS LAST_UPDATE_DATE
        FROM    GT_SCP0103_ALL A
        WHERE   A.COMPANY IS NOT NULL;
        DBMS_OUTPUT.PUT_LINE('최종 집계테이블에 추가 - END');
        DBMS_OUTPUT.PUT_LINE('ELAPSED_TIME : ' || TO_CHAR(SYSTIMESTAMP - V_ELAPSED_TIME_BEG)); V_ELAPSED_TIME_BEG := SYSTIMESTAMP;
/* TESTING : OK */
/* select * from #TBL_SCP0103_ALL;rollback tran;return; */
/* select * from dbo.SCP_ANL_MAT_SUPPLY;rollback tran;return; */

        V_LOG_TYPE     := 'END';
        V_LOG_MESSAGE  := '########## END of procedure ##########';
        V_DESCRIPTION  := '';

        IF V_TEST_MODE <> 'T' THEN
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_D_EVENT_DATE);
        END IF;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;

            IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
                ROLLBACK;
            END IF;

            /* PRINT N'ERROR_PROCEDURE()' select ERROR_PROCEDURE(); */

            IF V_TEST_MODE <> 'T' THEN
                INSERT INTO SCM_SYS_LOG_BATCH
                (
                      PROGRAM_NAME
                    , LOG_TYPE
                    , LOG_COUNT
                    , LOG_MESSAGE
                    , DESCRIPTION
                    , EVENT_DATE
                    , CREATION_DATE
                    , CREATED_BY
                    , LAST_UPDATE_DATE
                    , LAST_UPDATED_BY
                )
                VALUES
                (
                      NVL($$PLSQL_UNIT, V_PROGRAM_NAME)
                    , 'ERROR'
                    , NULL
                    , SUBSTR(V_ERR_MSG, 1, 1000)
                    , NULL
                    , SYSDATE
                    , SYSDATE
                    , $$PLSQL_UNIT
                    , SYSDATE
                    , $$PLSQL_UNIT
                );
                COMMIT;
            END IF;

            /* error코드, errror 메시지 반환 */
            DBMS_OUTPUT.PUT_LINE('result_code : F');
            DBMS_OUTPUT.PUT_LINE('ERRO_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                 || ' ERROR_NO : ' || TO_CHAR(SQLCODE)
                                 || ' ERROR_MSG : ' || V_ERR_MSG);
    END;


    BEGIN /* 임시테이블 및 커서 제거 */
        DELETE FROM GT_SCP0103_ALL;
        DELETE FROM GT_SCP0103_EE_PLANT;
        DELETE FROM GT_SCP0103_ITEM_OPERATION;
        DELETE FROM GT_SCP0103_ITEM_UOM;
        /* #TBL_SCP0103_MRP : 원본 DROP만 존재(미생성 죽은코드) */
        DELETE FROM GT_SCP0103_MRP_I;
        DELETE FROM GT_SCP0103_MRP_I_ALL;
        DELETE FROM GT_SCP0103_MRP_I_MATERIAL;
        DELETE FROM GT_SCP0103_MRP_I_TEMP;
        /* #TBL_SCP0103_MRP_MODEL_SEMI : 원본 DROP만 존재(미생성 죽은코드) */
        DELETE FROM GT_SCP0103_MRP_MODEL_SEMI_MATERIAL;
        DELETE FROM GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_EE;
        DELETE FROM GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP;
        DELETE FROM GT_SCP0103_MRP_MODEL_SEMI_MATERIAL_TEMP_RAW;

        DELETE FROM GT_SCP0103_MRP_P;
        DELETE FROM GT_SCP0103_MRP_P_ITEM_CATEGORY;
        DELETE FROM GT_SCP0103_MRP_P_MATERIAL;
        DELETE FROM GT_SCP0103_MRP_P_PLAN_KEYS;
        DELETE FROM GT_SCP0103_MRP_P_SEMI;
        DELETE FROM GT_SCP0103_MRP_P_SEMI_STOCK;
        DELETE FROM GT_SCP0103_MRP_P_SEMI_STOCK_SUM;
        DELETE FROM GT_SCP0103_MRP_P_SEMI_TEMP;
        DELETE FROM GT_SCP0103_MRP_P_UOM;
        DELETE FROM GT_SCP0103_MRP_TEMP;
        DELETE FROM GT_SCP0103_OPERATION;
        DELETE FROM GT_SCP0103_OPERATION_GROUOP;
        DELETE FROM GT_SCP0103_OPERATION_GROUP_PROD;
        DELETE FROM GT_SCP0103_PLANT;
        DELETE FROM GT_SCP0103_PLANT_ALL;
        DELETE FROM GT_SCP0103_RAW;
        DELETE FROM GT_SCP0103_SCM_DNM_STOCK;
        /* #TBL_SCP0103_SCP : 원본 DROP만 존재(미생성 죽은코드) */
        DELETE FROM GT_SCP0103_SCP_FN;
        DELETE FROM GT_SCP0103_SCP_FN_LINE;
        DELETE FROM GT_SCP0103_SCP_MODEL_PROD_PLAN_AMEND;
        DELETE FROM GT_SCP0103_SCP_PLAN;
        DELETE FROM GT_SCP0103_SCP_PLAN_FINAL;
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND;
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_EE;
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD;
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT;
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_PLANT_TREE;
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP1;
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_PROD_TEMP_ALL;
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI;
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_ALL;
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_MATERAIL;
        DELETE FROM GT_SCP0103_SCP_PLAN_PROD_PLAN_AMEND_SEMI_TEMP;
        DELETE FROM GT_SCP0103_SCP_PLAN_TEMP_REQUIREMENT;
        DELETE FROM GT_SCP0103_SCP_PLAN_TYPE;
        DELETE FROM GT_SCP0103_SCP_TREE;
        DELETE FROM GT_SCP0103_SCP_TREE_KEYS;
        DELETE FROM GT_SCP0103_SCP_TREE_PROD;
        DELETE FROM GT_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND;
        DELETE FROM GT_SCP0103_SCP_TREE_PROD_PROD_PLAN_AMEND_TEMP;
        DELETE FROM GT_SCP0103_SCP_TREE_RAW;
        DELETE FROM GT_SCP0103_SCP_TREE_RAW_TEMP;
        DELETE FROM GT_SCP0103_SUPPLIER;
        DELETE FROM GT_SCP0103_YIELD;
    END; /* 임시테이블 및 커서 제거 */
END;