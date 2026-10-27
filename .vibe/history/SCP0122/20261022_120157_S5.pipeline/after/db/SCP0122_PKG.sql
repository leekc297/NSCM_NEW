-- PKG_SCP0122 — 생성: tools/Harness/gen-pkg.js 2026-10-22 · 화면 SCP0122→SCP0122 PlanActivityMgmt · As-is SP 3개
-- 이식 규칙: Doc/_dev_rules(DB 변환 규칙) · To-be_v2_converted/06_Packages 선례 · ISNULL→NVL, GETDATE→SYSDATE, TOP n→FETCH FIRST n ROWS ONLY, +(문자열)→||, CONVERT→TO_CHAR/TO_DATE, 임시테이블→GTT/WITH, @@ROWCOUNT→SQL%ROWCOUNT · ⭐ 널 센티널 = '/' (ISNULL(x,'')→NVL(x,'/') · 원래 '-' 데이터 유지 · 과도기 빈값 IN ('-','/') — 사용자 2026-10-15, check-pkg P39/P40, port_pkg.md §센티널)
-- 배포 후: SCP0122_registration.sql 재실행(PROC_M 이 ALL_ARGUMENTS 로 확정) → FE pnpm gen:procedures
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCP0122
AS
    PROCEDURE P_SCP0121_GET_SEARCH_INFO (
        P_USER_ID        IN  VARCHAR2,  -- As-is @p_user_id nvarchar(600)
        O_RC1            OUT SYS_REFCURSOR,
        O_RC2            OUT SYS_REFCURSOR,
        O_RC3            OUT SYS_REFCURSOR,
        O_RC4            OUT SYS_REFCURSOR,
        O_RC5            OUT SYS_REFCURSOR,
        O_RC6            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0122_GET_PLAN_ACTIVITY_MGMT (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_PLAN_GROUP_ID  IN  VARCHAR2,  -- As-is @p_plan_group_id nvarchar(-1)
        P_PRS_CD         IN  VARCHAR2,  -- As-is @p_prs_cd nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT (
        P_DATA           IN  CLOB,            -- 그리드 변경행 JSON 배열(FE sendRows) — As-is: @p_active_flag, @p_prs_cd, @p_plan_gr_id, @p_actv_cd, @p_actv_seq, @p_pre_actv_cd, @p_user_id
        P_USER_ID        IN  VARCHAR2,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );
END PKG_SCP0122;
/

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCP0122
AS
    /* ------------------------------------------------------------
       SCP최적화계획그룹활동이력 (As-is SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST)
       - 화면이 직접 부르지 않고 저장에서만 부르므로 패키지 내부 전용(스펙 미노출)
       - As-is CATCH 는 오류를 삼키지만(로그 후 COMMIT) 예외 전파 규약(#137)으로 RAISE
       ------------------------------------------------------------ */
    PROCEDURE P_SCP_OPMZ_PLAN_GR_ACTV_HIST (
        P_PRS_CD            IN  VARCHAR2,
        P_PLAN_GR_ID        IN  VARCHAR2,
        P_ACTV_CD           IN  VARCHAR2,
        P_ACTV_SEQ          IN  VARCHAR2,
        P_VALID_YN          IN  VARCHAR2,
        P_CREATED_BY        IN  VARCHAR2,
        P_CREATION_DATE     IN  DATE,
        P_LAST_UPDATED_BY   IN  VARCHAR2
    ) IS
        V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST';
        D_EVENT_DATE    DATE;
        V_ERR_MSG       VARCHAR2(4000);
    BEGIN
        -- 시작 LOG
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', '', D_EVENT_DATE);

        INSERT INTO SCP_OPMZ_PLAN_GR_ACTV_H (
               HISTORY_SEQ, HISTORY_CREATION_DATE, OPMZ_PRS_CD, OPMZ_PLAN_GR_ID, OPMZ_ACTV_CD, OPMZ_ACTV_SEQ, VALID_YN,
               CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        ) VALUES (
               SEQ1_SCP_OPMZ_PLAN_GR_ACTV_H.NEXTVAL, D_EVENT_DATE, P_PRS_CD, P_PLAN_GR_ID, P_ACTV_CD, TO_NUMBER(P_ACTV_SEQ), P_VALID_YN,
               P_CREATED_BY, P_CREATION_DATE, P_LAST_UPDATED_BY, SYSDATE
        );

        -- 종료 LOG
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', '', SYSDATE);

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            INSERT INTO SCM_SYS_LOG_BATCH (
                   PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION,
                   EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY
            ) VALUES (
                   V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MSG, NULL,
                   SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME
            );
            RAISE;
    END P_SCP_OPMZ_PLAN_GR_ACTV_HIST;

/*
 * Program ID   : P_SCP0121_GET_SEARCH_INFO
 * Description  : SCP0122 PlanActivityMgmt — As-is SCP0121_GET_SEARCH_INFO 이식 (GET, 시트 'Plan Activity Mgmt' / 버튼 SEARCH_INFO)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.22   harness        [TobeGen] 골격 생성
 * 2026.10.22   harness        [PortPkg] As-is 본문 이식 — #division_info/#line_master/#osp_plant_info → GT_0121_* GTT(PKG_SCP0121 공용)
 */
PROCEDURE P_SCP0121_GET_SEARCH_INFO (
        P_USER_ID        IN  VARCHAR2,  -- As-is @p_user_id nvarchar(600)
        O_RC1            OUT SYS_REFCURSOR,
        O_RC2            OUT SYS_REFCURSOR,
        O_RC3            OUT SYS_REFCURSOR,
        O_RC4            OUT SYS_REFCURSOR,
        O_RC5            OUT SYS_REFCURSOR,
        O_RC6            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사 없음: As-is @p_user_id 기본값 '' — 빈값이면 Plan Group 전체 조회

    -- GTT 초기화 (#107 — TRUNCATE 금지)
    DELETE FROM GT_0121_DIVISION_INFO;
    DELETE FROM GT_0121_LINE_MASTER;
    DELETE FROM GT_0121_OSP_PLANT_INFO;

    -- 사업부 정보 (전극 EE 사업부 → 원 사업부 매핑)
    INSERT INTO GT_0121_DIVISION_INFO (DIVISION_ID, ORG_DIVISION_ID, DIVISION_DV)
    SELECT D.DIVISION_ID
         , R.DIVISION_ID   AS ORG_DIVISION_ID
         , D.ATTRIBUTE3    AS DIVISION_DV
      FROM SCM_MST_DIVISION D
     INNER JOIN SCM_MST_DIVISION R
             ON D.ATTRIBUTE4 = R.ATTRIBUTE4
            AND ( (D.ATTRIBUTE3 != 'EE' AND D.DIVISION_ID = R.DIVISION_ID)
                  OR
                  (D.ATTRIBUTE3 =  'EE' AND R.ATTRIBUTE3 != 'EE')
                )
     WHERE D.VALID_YN = 'Y'
       AND R.VALID_YN = 'Y';

    -- 라인 마스터 (SCP_PLAN_OPERATION 룩업 공정 범위)
    INSERT INTO GT_0121_LINE_MASTER (COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, FACTORY_NAME, OPERATION_ID, LINE_ID, LINE_NAME)
    SELECT L.COMPANY_ID
         , L.DIVISION_ID
         , L.SITE_ID
         , L.PLANT_ID
         , L.FACTORY_ID
         , F.FACTORY_NAME
         , L.OPERATION_ID
         , L.LINE_ID
         , MAX(L.LINE_NAME) AS LINE_NAME
      FROM SCM_MST_LINE_SN L
     INNER JOIN SCM_MST_FACTORY_SN F
             ON F.COMPANY_ID = L.COMPANY_ID
            AND F.FACTORY_ID = L.FACTORY_ID
     WHERE EXISTS (SELECT 1
                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL OP
                    WHERE OP.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                      AND OP.VALID_YN = 'Y'
                      AND OP.SEGMENT1 = L.OPERATION_ID
                      AND OP.SEGMENT4 LIKE '%' || L.DIVISION_ID || '%')
       AND L.ACTIVE_FLAG = 'Y'
     GROUP BY L.COMPANY_ID, L.DIVISION_ID, L.SITE_ID, L.PLANT_ID, L.FACTORY_ID, F.FACTORY_NAME, L.OPERATION_ID, L.LINE_ID;

    -- [PJ20257329] OSP Plant 및 라인 (2025-09-03)
    INSERT INTO GT_0121_OSP_PLANT_INFO (PLANT_ID, PLANT_NAME, DIVISION_ID, SCM_SITE_ID, LINE_ID, LINE_NAME, OPERATION_ID, VALID_YN, LAST_UPDATE_DATE)
    SELECT SITE.PLANT_ID
         , V.VENDOR_NAME   AS PLANT_NAME
         , OSP.DIVISION_ID
         , OSP.SCM_SITE_ID
         , OSP.LINE_ID
         , OSP.LINE_NAME
         , OSP.OPERATION_ID
         , OSP.VALID_YN
         , OSP.LAST_UPDATE_DATE
      FROM SCM_MST_LINE_OSP OSP
     INNER JOIN SCM_MST_SITE SITE
             ON OSP.DIVISION_ID = SITE.DIVISION_ID
            AND OSP.SCM_SITE_ID = SITE.SCM_SITE_ID
      LEFT OUTER JOIN SCM_MST_VENDOR V
             ON V.VENDOR_CODE = SITE.PLANT_ID
            AND SITE.COMPANY_ID = V.COMPANY_ID
     WHERE OSP.VALID_YN = 'Y'
       AND SITE.VALID_YN = 'Y';

    -- 1. Plant id 정보 (As-is 문자열 + 은 NULL 전파 — CASE 로 동일화)
    OPEN O_RC1 FOR
        SELECT DISTINCT
               L.PLANT_ID                                   AS CODE
             , CASE WHEN L.PLANT_ID IS NULL OR P.PLANT_NAME IS NULL THEN NULL
                    ELSE L.PLANT_ID || ' ' || P.PLANT_NAME END AS NAME
             , D.DIVISION_ID
             , D.ORG_DIVISION_ID
             , 1                                            AS SEQ
          FROM GT_0121_LINE_MASTER L
         INNER JOIN GT_0121_DIVISION_INFO D
                 ON L.DIVISION_ID = D.ORG_DIVISION_ID
                AND L.OPERATION_ID =  CASE WHEN D.DIVISION_DV = 'EE' THEN 'E2000' ELSE L.OPERATION_ID END
                AND L.OPERATION_ID != CASE WHEN D.DIVISION_DV = 'EE' THEN 'Z'     ELSE 'E2000'        END
          LEFT JOIN (SELECT DISTINCT PLANT_ID, PLANT_NAME
                       FROM SCP_MST_CAPA_LINE) P
                 ON P.PLANT_ID = L.PLANT_ID
        UNION
        SELECT PLANT_ID                                     AS CODE
             , CASE WHEN PLANT_ID IS NULL OR PLANT_NAME IS NULL THEN NULL
                    ELSE PLANT_ID || ' ' || PLANT_NAME END  AS NAME
             , DIVISION_ID
             , DIVISION_ID                                  AS ORG_DIVISION_ID
             , 2                                            AS SEQ
          FROM GT_0121_OSP_PLANT_INFO
         ORDER BY SEQ, DIVISION_ID, CODE;

    -- 2. Factory id 정보 ('-' = As-is 실값 행 — 82 사업부 Factory 없음 선택지)
    OPEN O_RC2 FOR
        SELECT DISTINCT
               L.FACTORY_ID                                 AS CODE
             , CASE WHEN L.FACTORY_ID IS NULL OR L.FACTORY_NAME IS NULL THEN NULL
                    ELSE L.FACTORY_ID || ' ' || L.FACTORY_NAME END AS NAME
             , D.DIVISION_ID
             , D.ORG_DIVISION_ID
          FROM GT_0121_LINE_MASTER L
         INNER JOIN GT_0121_DIVISION_INFO D
                 ON L.DIVISION_ID = D.ORG_DIVISION_ID
                AND L.OPERATION_ID =  CASE WHEN D.DIVISION_DV = 'EE' THEN 'E2000' ELSE L.OPERATION_ID END
                AND L.OPERATION_ID != CASE WHEN D.DIVISION_DV = 'EE' THEN 'Z'     ELSE 'E2000'        END
        UNION
        SELECT '-' AS CODE, '-' AS NAME, '82' AS DIVISION_ID, '82' AS ORG_DIVISION_ID
          FROM DUAL;

    -- 3. Line id 정보 (As-is: 1번 분기 구분자 공백 3칸, OSP 분기 1칸)
    OPEN O_RC3 FOR
        SELECT A.CODE, A.NAME, A.DIVISION_ID, A.ORG_DIVISION_ID, A.OPERATION_ID, A.PLANT_ID, A.FACTORY_ID
             , 1 AS SEQ
          FROM (SELECT DISTINCT
                       L.LINE_ID                            AS CODE
                     , CASE WHEN L.LINE_ID IS NULL OR L.LINE_NAME IS NULL THEN NULL
                            ELSE L.LINE_ID || '   ' || L.LINE_NAME END AS NAME
                     , D.DIVISION_ID
                     , D.ORG_DIVISION_ID
                     , L.OPERATION_ID
                     , L.PLANT_ID
                     , L.FACTORY_ID
                  FROM GT_0121_LINE_MASTER L
                 INNER JOIN GT_0121_DIVISION_INFO D
                         ON L.DIVISION_ID = D.ORG_DIVISION_ID
                        AND L.OPERATION_ID =  CASE WHEN D.DIVISION_DV = 'EE' THEN 'E2000' ELSE L.OPERATION_ID END
                        AND L.OPERATION_ID != CASE WHEN D.DIVISION_DV = 'EE' THEN 'Z'     ELSE 'E2000'        END
               ) A
         INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LD
                 ON LD.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION'
                AND LD.VALID_YN = 'Y'
                AND LD.SEGMENT1 = A.DIVISION_ID
                AND LD.SEGMENT2 = A.OPERATION_ID
        UNION
        SELECT LINE_ID                                      AS CODE
             , CASE WHEN LINE_ID IS NULL OR LINE_NAME IS NULL THEN NULL
                    ELSE LINE_ID || ' ' || LINE_NAME END    AS NAME
             , DIVISION_ID
             , DIVISION_ID                                  AS ORG_DIVISION_ID
             , OPERATION_ID
             , PLANT_ID
             , '-'                                          AS FACTORY_ID
             , 2                                            AS SEQ
          FROM GT_0121_OSP_PLANT_INFO
         ORDER BY SEQ, DIVISION_ID, CODE;

    -- 4. Plan Group 정보 ([PJ20257329] 삭제 Plan Group 미표시 2025-09-03 · 정렬 Group Name 2025-10-20)
    OPEN O_RC4 FOR
        SELECT OPMZ_PLAN_GR_ID     AS CODE
             , OPMZ_PLAN_GR_NAME   AS NAME
             , DIVISION_ID
          FROM SCP_OPMZ_PLAN_GR_M
         WHERE VALID_YN = 'Y'
           AND (P_USER_ID IS NULL OR OWNR_LST_CTN LIKE '%' || P_USER_ID || '%')
         ORDER BY OPMZ_PLAN_GR_NAME;

    -- 5. Prod Frozen Target 대상 정보
    OPEN O_RC5 FOR
        SELECT SEGMENT1      AS CODE
             , DESCRIPTION   AS NAME
             , SEGMENT2      AS DIVISION_ID
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'OPMZ_TGT_DIVS_CD'
           AND VALID_YN = 'Y';

    -- 6. 사업부별 Operation 정보 ([PJ20257329] 2025-09-03)
    OPEN O_RC6 FOR
        SELECT DISTINCT
               B.SEGMENT2                                   AS CODE
             , CASE WHEN B.SEGMENT2 IS NULL OR OP.OPERATION_NAME IS NULL THEN NULL
                    ELSE B.SEGMENT2 || ' ' || OP.OPERATION_NAME END AS NAME
             , B.SEGMENT1                                   AS DIVISION_ID
             , 1                                            AS SEQ
          FROM SCM_ADM_LOOKUP_MASTER A
         INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
                 ON A.LOOKUP_TYPE = B.LOOKUP_TYPE
                AND B.VALID_YN = 'Y'
          LEFT JOIN SCM_OPERATION_M_SN OP
                 ON B.SEGMENT2 = OP.OPERATION_ID
                AND OP.ACTIVE_FLAG = 'Y'
         WHERE A.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION'
           AND A.VALID_YN = 'Y'
        UNION
        SELECT OPERATION_ID                                 AS CODE
             , CASE WHEN OPERATION_ID IS NULL THEN NULL
                    ELSE OPERATION_ID || ' ' || OPERATION_ID END AS NAME
             , DIVISION_ID
             , 2                                            AS SEQ
          FROM GT_0121_OSP_PLANT_INFO
         ORDER BY SEQ, DIVISION_ID, CODE;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0121_GET_SEARCH_INFO] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_USER_ID='||P_USER_ID);
END P_SCP0121_GET_SEARCH_INFO;

/*
 * Program ID   : P_SCP0122_GET_PLAN_ACTIVITY_MGMT
 * Description  : SCP0122 PlanActivityMgmt — As-is SCP0122_GET_PLAN_ACTIVITY_MGMT 이식 (GET, 시트 'Plan Activity Mgmt' / 버튼 SEARCH)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.22   harness        [TobeGen] 골격 생성
 * 2026.10.22   harness        [PortPkg] As-is 본문 이식 — 결과셋 15컬럼 As-is 동일
 */
PROCEDURE P_SCP0122_GET_PLAN_ACTIVITY_MGMT (
        P_DIVISION_ID    IN  VARCHAR2,  -- As-is @p_division_id nvarchar(-1)
        P_PLAN_GROUP_ID  IN  VARCHAR2,  -- As-is @p_plan_group_id nvarchar(-1)
        P_PRS_CD         IN  VARCHAR2,  -- As-is @p_prs_cd nvarchar(-1)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    -- 필수값 검사 없음: As-is 는 NULL 파라미터를 오류 없이 0건으로 돌려준다(= 비교 불일치)

    OPEN O_RC1 FOR
        SELECT B.DIVISION_ID
             , A.OPMZ_PRS_CD
             , D.SEGMENT2          AS OPMZ_PRS_NAME
             , A.OPMZ_PLAN_GR_ID
             , B.OPMZ_PLAN_GR_NAME
             , A.OPMZ_ACTV_SEQ
             , A.OPMZ_ACTV_CD
             , A.OPMZ_ACTV_CD      AS OPMZ_ACTV_NAME
             , C.ATTRIBUTE4        AS LINK_UI_TYPE
             , C.ATTRIBUTE5        AS PROGRAM_NAME
             , C.ATTRIBUTE6        AS CONFIRM_YN
             , C.ATTRIBUTE7        AS AUTO_YN
             , C.ATTRIBUTE8        AS OPTION_YN
             , A.OPMZ_ACTV_CD      AS PRE_OPMZ_ACTV_CD
             , A.OPMZ_ACTV_SEQ     AS PRE_OPMZ_ACTV_SEQ
          FROM SCP_OPMZ_PLAN_GR_ACTV_M A
         INNER JOIN SCP_OPMZ_PLAN_GR_M B
                 ON B.OPMZ_PLAN_GR_ID = A.OPMZ_PLAN_GR_ID
         INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C
                 ON C.LOOKUP_TYPE = 'OPMZ_ACTV_CD'
                AND C.SEGMENT1 = A.OPMZ_ACTV_CD
         INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D
                 ON D.LOOKUP_TYPE = 'OPMZ_PRS_CD'
                AND D.SEGMENT1 = A.OPMZ_PRS_CD
         WHERE B.DIVISION_ID     = UPPER(RTRIM(P_DIVISION_ID))     -- 원장 전건 대문자·뒤 공백 없음 — As-is CI 콜레이션 동등
           AND A.OPMZ_PLAN_GR_ID = UPPER(RTRIM(P_PLAN_GROUP_ID))
           AND A.OPMZ_PRS_CD     = UPPER(RTRIM(P_PRS_CD))
         ORDER BY A.OPMZ_ACTV_SEQ;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0122_GET_PLAN_ACTIVITY_MGMT] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_DIVISION_ID='||P_DIVISION_ID||','||'P_PLAN_GROUP_ID='||P_PLAN_GROUP_ID||','||'P_PRS_CD='||P_PRS_CD);
END P_SCP0122_GET_PLAN_ACTIVITY_MGMT;

/*
 * Program ID   : P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT
 * Description  : SCP0122 PlanActivityMgmt — As-is SCP0122_SAVE_PLAN_ACTIVITY_MGMT 이식 (SAVE, 시트 'Plan Activity Mgmt' / 버튼 SAVE)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.22   harness        [TobeGen] 골격 생성
 * 2026.10.22   harness        [PortPkg] As-is 본문 이식 — '^' 배열 7개 → P_DATA JSON_TABLE · rowStatus I/U(M)/D · 행마다 이력 적재
 */
PROCEDURE P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT (
        P_DATA           IN  CLOB,            -- 그리드 변경행 JSON 배열(FE sendRows) — As-is: @p_active_flag, @p_prs_cd, @p_plan_gr_id, @p_actv_cd, @p_actv_seq, @p_pre_actv_cd, @p_user_id
        P_USER_ID        IN  VARCHAR2,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'SCP0122_SAVE_PLAN_ACTIVITY_MGMT';
    D_EVENT_DATE    DATE;
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    IF P_DATA IS NULL OR P_USER_ID IS NULL THEN RAISE_INVALID('Please check required input values.'); END IF;

    -- 시작 LOG (D_EVENT_DATE 는 As-is 와 같이 이력 CREATION_DATE 로 넘긴다)
    D_EVENT_DATE := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', '', D_EVENT_DATE);

    -- As-is '^' 배열 순번 루프 → JSON 배열 행 순서(ORDINALITY)
    FOR R IN (SELECT J.ROW_STATUS, J.OPMZ_PRS_CD, J.OPMZ_PLAN_GR_ID, J.OPMZ_ACTV_CD, J.OPMZ_ACTV_SEQ, J.PRE_OPMZ_ACTV_CD
                FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
                         RN                FOR ORDINALITY,
                         ROW_STATUS        VARCHAR2(10)   PATH '$.rowStatus',
                         OPMZ_PRS_CD       VARCHAR2(4000) PATH '$.opmzPrsCd',
                         OPMZ_PLAN_GR_ID   VARCHAR2(4000) PATH '$.opmzPlanGrId',
                         OPMZ_ACTV_CD      VARCHAR2(4000) PATH '$.opmzActvCd',
                         OPMZ_ACTV_SEQ     VARCHAR2(4000) PATH '$.opmzActvSeq',
                         PRE_OPMZ_ACTV_CD  VARCHAR2(4000) PATH '$.preOpmzActvCd'
                     )) J
               ORDER BY J.RN)
    LOOP
        V_ROW_CNT := V_ROW_CNT + 1;   -- As-is result_cnt = 처리 행수(@max_loop_cnt)

        -- HISTORY INSERT (As-is: 플래그와 무관하게 행마다 신규값으로 적재)
        P_SCP_OPMZ_PLAN_GR_ACTV_HIST(R.OPMZ_PRS_CD, R.OPMZ_PLAN_GR_ID, R.OPMZ_ACTV_CD, R.OPMZ_ACTV_SEQ, 'Y',
                                     P_USER_ID, D_EVENT_DATE, P_USER_ID);

        IF R.ROW_STATUS = 'I' THEN
            INSERT INTO SCP_OPMZ_PLAN_GR_ACTV_M (
                   OPMZ_PRS_CD, OPMZ_PLAN_GR_ID, OPMZ_ACTV_CD, OPMZ_ACTV_SEQ, VALID_YN,
                   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            ) VALUES (
                   R.OPMZ_PRS_CD, R.OPMZ_PLAN_GR_ID, R.OPMZ_ACTV_CD, TO_NUMBER(R.OPMZ_ACTV_SEQ), 'Y',
                   P_USER_ID, SYSDATE, P_USER_ID, SYSDATE
            );

        ELSIF R.ROW_STATUS IN ('U', 'M') THEN   -- As-is 'M' = To-Be rowStatus 'U'
            UPDATE SCP_OPMZ_PLAN_GR_ACTV_M
               SET OPMZ_ACTV_CD     = R.OPMZ_ACTV_CD
                 , OPMZ_ACTV_SEQ    = TO_NUMBER(R.OPMZ_ACTV_SEQ)
                 , LAST_UPDATED_BY  = P_USER_ID
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE OPMZ_PRS_CD      = UPPER(RTRIM(R.OPMZ_PRS_CD))       -- 원장 전건 대문자·뒤 공백 없음 — As-is CI 콜레이션 동등
               AND OPMZ_PLAN_GR_ID  = UPPER(RTRIM(R.OPMZ_PLAN_GR_ID))
               AND OPMZ_ACTV_CD     = UPPER(RTRIM(R.PRE_OPMZ_ACTV_CD));

        ELSIF R.ROW_STATUS = 'D' THEN
            DELETE FROM SCP_OPMZ_PLAN_GR_ACTV_M
             WHERE OPMZ_PRS_CD      = UPPER(RTRIM(R.OPMZ_PRS_CD))
               AND OPMZ_PLAN_GR_ID  = UPPER(RTRIM(R.OPMZ_PLAN_GR_ID))
               AND OPMZ_ACTV_CD     = UPPER(RTRIM(R.PRE_OPMZ_ACTV_CD));
        END IF;
    END LOOP;

    -- 종료 LOG
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', '', SYSDATE);

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        -- As-is CATCH 와 같이 ERROR 행을 SCM_SYS_LOG_BATCH 에 남긴다(롤백 후 적재·커밋)
        INSERT INTO SCM_SYS_LOG_BATCH (
               PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION,
               EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY
        ) VALUES (
               V_PROGRAM_NAME, 'ERROR', NULL, SUBSTR(V_ERR_MSG, 1, 1000), NULL,
               SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME
        );
        COMMIT;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || SUBSTR(P_DATA, 1, 200));
END P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT;

END PKG_SCP0122;
/
-- 컴파일 확인: SELECT NAME, TYPE, LINE, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SCP0122' ORDER BY TYPE, SEQUENCE;
