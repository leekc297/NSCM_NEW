-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SYS0012 — 사내 현재 원문(적용본, 사내 LAST_DDL 2026-10-08 16:51:09, 294줄)
CREATE OR REPLACE PACKAGE BODY         "PKG_SYS0012" AS

    -- [2026-09-15 UIPKG] standalone P_SYS0012_APPROVE 취합
PROCEDURE P_SYS0012_APPROVE (
    P_SES_USER_ID    IN  VARCHAR2,
    P_DATA           IN  CLOB,
    O_RESULT_CURSOR  OUT SYS_REFCURSOR
)
AS
    V_CNT       NUMBER := 0;   -- 승인(상태변경) 건수
    V_GRP_CNT   NUMBER := 0;   -- 그룹매핑 반영 건수
    V_AUTH_CNT  NUMBER := 0;   -- 단위권한 반영 건수
    V_GUEST_CNT NUMBER := 0;   -- GUEST 회수 건수
BEGIN
    -- ── 대상 요청 키를 임시 수집 (JSON 1회 파싱 후 재사용) ──────────────────
    -- REQUEST_ID = USER_ID:GROUP_ID:DIVISION_ID:PLANT_ID (기존 규약 유지)

    -- ① 요청 상태 UPDATE (+ APPROVAL_USER — AS-IS 파리티, 기존 SP 누락분)
    UPDATE SCM_MGR.SCM_MST_AUTH_REQUEST T
       SET T.APPROVAL_RESULT  = 'APPROVED',
           T.APPROVAL_USER    = P_SES_USER_ID,
           T.REJECT_REASON    = NULL,
           T.LAST_UPDATED_BY  = P_SES_USER_ID,
           T.LAST_UPDATE_DATE = SYSDATE
     WHERE (T.USER_ID || ':' || T.GROUP_ID || ':' || T.DIVISION_ID || ':' || T.PLANT_ID) IN (
         SELECT V_REQ FROM JSON_TABLE(P_DATA, '$[*]'
             COLUMNS (V_REQ VARCHAR2(400) PATH '$.REQUEST_ID'))
     );
    V_CNT := SQL%ROWCOUNT;

    -- ② 그룹 매핑 — 없으면 INSERT, 있으면 USE_YN='Y' 로 복원 (AS-IS MERGE 파리티)
    MERGE INTO SCM_MGR.SCM_ADM_USER_GR_MPG_M M
    USING (
        SELECT DISTINCT R.USER_ID, R.GROUP_ID
          FROM SCM_MGR.SCM_MST_AUTH_REQUEST R
         WHERE R.APPROVAL_RESULT = 'APPROVED'
           AND (R.USER_ID || ':' || R.GROUP_ID || ':' || R.DIVISION_ID || ':' || R.PLANT_ID) IN (
               SELECT V_REQ FROM JSON_TABLE(P_DATA, '$[*]'
                   COLUMNS (V_REQ VARCHAR2(400) PATH '$.REQUEST_ID')))
           -- 그룹 마스터에 없는 그룹은 제외 (예: 'CAPA Planner' 미등록 실측)
           AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_M G WHERE G.USER_GR_ID = R.GROUP_ID)
    ) S
       ON (M.USER_GR_ID = S.GROUP_ID AND M.USER_ID = S.USER_ID)
     WHEN MATCHED THEN UPDATE SET
           M.USE_YN           = 'Y',
           M.LAST_UPDATED_BY  = P_SES_USER_ID,
           M.LAST_UPDATE_DATE = SYSDATE
     WHEN NOT MATCHED THEN INSERT
           (USER_GR_ID, USER_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
           VALUES (S.GROUP_ID, S.USER_ID, 'Y', P_SES_USER_ID, SYSDATE, P_SES_USER_ID, SYSDATE);
    V_GRP_CNT := SQL%ROWCOUNT;

    -- ③ 단위(Division) 권한 — UNIT_TP_CD='D'
    --    EDIT_YN: 그룹명이 Viewer 계열이면 'N', 그 외 'Y' (기존 1,866행 실측 관례와 100% 일치)
    INSERT INTO SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
           (USER_GR_ID, USER_ID, UNIT_TP_CD, UNIT_ID, UPPR_UNIT_ID, EDIT_YN, USE_YN,
            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT S.GROUP_ID, S.USER_ID, 'D', S.DIVISION_ID, '/',
           CASE WHEN UPPER(S.GROUP_ID) LIKE '%VIEWER%' THEN 'N' ELSE 'Y' END,
           'Y', P_SES_USER_ID, SYSDATE, P_SES_USER_ID, SYSDATE
      FROM (
        SELECT DISTINCT R.USER_ID, R.GROUP_ID, R.DIVISION_ID
          FROM SCM_MGR.SCM_MST_AUTH_REQUEST R
         WHERE R.APPROVAL_RESULT = 'APPROVED'
           AND (R.USER_ID || ':' || R.GROUP_ID || ':' || R.DIVISION_ID || ':' || R.PLANT_ID) IN (
               SELECT V_REQ FROM JSON_TABLE(P_DATA, '$[*]'
                   COLUMNS (V_REQ VARCHAR2(400) PATH '$.REQUEST_ID')))
           -- ⚠ Oracle 은 '' = NULL → NOT IN ('','-') 는 항상 UNKNOWN(거짓). 개별 조건으로 분리 필수
           AND TRIM(R.DIVISION_ID) IS NOT NULL
           AND TRIM(R.DIVISION_ID) <> '/'
           AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_M G WHERE G.USER_GR_ID = R.GROUP_ID)
      ) S
     WHERE NOT EXISTS (
           SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
            WHERE A.USER_GR_ID = S.GROUP_ID AND A.USER_ID = S.USER_ID
              AND A.UNIT_TP_CD = 'D' AND A.UNIT_ID = S.DIVISION_ID AND A.UPPR_UNIT_ID = '/');
    V_AUTH_CNT := SQL%ROWCOUNT;

    -- ④ GUEST 회수 — 실그룹을 갖게 된 사용자의 GUEST 매핑을 비활성화
    --    (AS-IS 의 DefaultGroupID Guest→승인그룹 전환에 대응. TO-BE 는 해당 컬럼 없음)
    UPDATE SCM_MGR.SCM_ADM_USER_GR_MPG_M M
       SET M.USE_YN           = 'N',
           M.LAST_UPDATED_BY  = P_SES_USER_ID,
           M.LAST_UPDATE_DATE = SYSDATE
     WHERE UPPER(M.USER_GR_ID) = 'GUEST'
       AND M.USE_YN <> 'N'
       AND M.USER_ID IN (
           SELECT DISTINCT R.USER_ID
             FROM SCM_MGR.SCM_MST_AUTH_REQUEST R
            WHERE R.APPROVAL_RESULT = 'APPROVED'
              AND UPPER(R.GROUP_ID) <> 'GUEST'
              AND (R.USER_ID || ':' || R.GROUP_ID || ':' || R.DIVISION_ID || ':' || R.PLANT_ID) IN (
                  SELECT V_REQ FROM JSON_TABLE(P_DATA, '$[*]'
                      COLUMNS (V_REQ VARCHAR2(400) PATH '$.REQUEST_ID'))))
       -- 실제로 활성 실그룹을 보유하게 된 경우에만 회수
       AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M X
                    WHERE X.USER_ID = M.USER_ID
                      AND UPPER(X.USER_GR_ID) <> 'GUEST'
                      AND X.USE_YN = 'Y');
    V_GUEST_CNT := SQL%ROWCOUNT;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE,
           'SUCCESS' AS MSG,
           TO_CHAR(V_CNT) AS EVENT,                 -- 기존 계약 유지(승인 건수)
           TO_CHAR(V_GRP_CNT)   AS GROUP_MAPPED,
           TO_CHAR(V_AUTH_CNT)  AS UNIT_AUTH_ADDED,
           TO_CHAR(V_GUEST_CNT) AS GUEST_REVOKED
      FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DECLARE
            V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
        BEGIN
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_ERR AS MSG, '0' AS EVENT,
                   '0' AS GROUP_MAPPED, '0' AS UNIT_AUTH_ADDED, '0' AS GUEST_REVOKED
              FROM DUAL;
        END;
END P_SYS0012_APPROVE;

    -- [2026-09-15 UIPKG] standalone P_SYS0012_GET_APPROVAL_LIST 취합
PROCEDURE P_SYS0012_GET_APPROVAL_LIST (
    P_SES_USER_ID    IN  VARCHAR2,
    P_USER_ID        IN  VARCHAR2,
    P_START_DATE     IN  VARCHAR2,
    P_END_DATE       IN  VARCHAR2,
    P_STATUS         IN  VARCHAR2,
    P_DIVISION_ID    IN  VARCHAR2,
    P_DEPARTMENT     IN  VARCHAR2,
    O_RC             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR  OUT SYS_REFCURSOR
)
AS
    -- 2026-07-02 보완: PROC_M(9) positional 정합 — P_DIVISION_ID/P_DEPARTMENT IN 추가 (구 5 IN → PLS-00306 원인).
    --   조회조건 5종(Div/UserID(Name)/Department/Approval Result/Request Date) + AS-IS 기준 GRID 컬럼 확장:
    --   COMPANY_ID/WORKING_NAME/SSO_LOCATE(SCM_MST_SSO_USER_INFO) + DEPARTMENT(SSO_DEPT_INFO.DEPT_NAME_KO)
    --   + AUTHORITY(SCM_ADM_USER_GR_M.USER_GR_NM) / APPROVED_BY = AUTH_REQUEST.APPROVAL_USER 우선.
    V_STATUS  VARCHAR2(20) := NVL(P_STATUS, 'REQUEST');
BEGIN
    OPEN O_RC FOR
    SELECT
        (T.USER_ID || ':' || T.GROUP_ID || ':' || T.DIVISION_ID || ':' || T.PLANT_ID) AS REQUEST_ID,
        T.USER_ID                                                AS USER_ID,
        NVL(S.USER_NAME, NVL(U.USER_NM, T.USER_ID))              AS USER_NAME,
        NVL(S.COMPANY_ID, '')                                    AS COMPANY_ID,
        NVL(S.WORKING_NAME, '')                                  AS WORKING_NAME,
        NVL(TRIM(S.SSO_LOCATE), '')                              AS SSO_LOCATE,
        NVL(D.DEPT_NAME_KO, NVL(S.DEPT_ID, ''))                  AS DEPARTMENT,
        T.GROUP_ID                                               AS GROUP_ID,
        NVL(G.USER_GR_NM, T.GROUP_ID)                            AS AUTHORITY,
        T.DIVISION_ID                                            AS DIVISION_ID,
        CASE 
	        WHEN TO_CHAR(T.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI') > TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') THEN 
        		TO_CHAR(T.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI')
        	ELSE 
        		TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') 
        END AS REQUEST_DATE,  
        --TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS REQUEST_DATE,
        CASE
          WHEN T.APPROVAL_RESULT = 'APPROVED'   THEN 'APPROVED'
          WHEN T.APPROVAL_RESULT = 'REJECT'     THEN 'REJECTED'
          WHEN T.APPROVAL_RESULT = 'REQUESTING' THEN 'REQUEST'
          ELSE 'REQUEST'
        END                                                      AS STATUS,
        NVL(T.APPROVAL_USER, NVL(T.LAST_UPDATED_BY, ''))         AS APPROVED_BY,
        CASE WHEN T.APPROVAL_RESULT IN ('APPROVED', 'REJECT')
             THEN TO_CHAR(T.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI')
             ELSE ''
        END                                                      AS APPROVED_DATE,
        NVL(T.REJECT_REASON, '')                                 AS REASON
    FROM SCM_MGR.SCM_MST_AUTH_REQUEST T
    LEFT JOIN SCM_MGR.SCM_ADM_USER_M        U ON U.USER_ID = T.USER_ID
    LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO S ON S.USER_ID = T.USER_ID
    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO D ON D.DEPT_ID = S.DEPT_ID AND D.VALID_YN = 'Y'
    LEFT JOIN SCM_MGR.SCM_ADM_USER_GR_M     G ON G.USER_GR_ID = T.GROUP_ID
    WHERE (P_USER_ID IS NULL
           OR UPPER(T.USER_ID) LIKE '%' || UPPER(P_USER_ID) || '%'
           OR UPPER(NVL(S.USER_NAME, NVL(U.USER_NM, ''))) LIKE '%' || UPPER(P_USER_ID) || '%')
      AND (NVL(P_DIVISION_ID, 'ALL') = 'ALL' OR T.DIVISION_ID = P_DIVISION_ID)
      AND (P_DEPARTMENT IS NULL
           OR UPPER(NVL(D.DEPT_NAME_KO, NVL(S.DEPT_ID, ''))) LIKE '%' || UPPER(P_DEPARTMENT) || '%')
      AND (P_START_DATE IS NULL OR P_START_DATE = '' OR T.CREATION_DATE >= TO_DATE(P_START_DATE, 'YYYYMMDD'))
      AND (P_END_DATE   IS NULL OR P_END_DATE   = '' OR T.CREATION_DATE <  TO_DATE(P_END_DATE,   'YYYYMMDD') + 1)
      AND (
          (V_STATUS = 'ALL' AND T.APPROVAL_RESULT IN ('REQUESTING', 'APPROVED', 'REJECT'))
       OR (V_STATUS = 'REQUEST'  AND T.APPROVAL_RESULT = 'REQUESTING')
       OR (V_STATUS = 'APPROVED' AND T.APPROVAL_RESULT = 'APPROVED')
       OR (V_STATUS = 'REJECTED' AND T.APPROVAL_RESULT = 'REJECT')
      )
    ORDER BY T.CREATION_DATE DESC, T.USER_ID;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        DECLARE
            V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
        BEGIN
            OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;
        END;
END P_SYS0012_GET_APPROVAL_LIST;

    -- [2026-09-15 UIPKG] standalone P_SYS0012_REJECT 취합
PROCEDURE P_SYS0012_REJECT (
    P_SES_USER_ID    IN  VARCHAR2,
    P_DATA           IN  CLOB,
    O_RESULT_CURSOR  OUT SYS_REFCURSOR
)
AS
    V_CNT       NUMBER := 0;   -- 반려(상태변경) 건수
    V_AUTH_CNT  NUMBER := 0;   -- 단위권한 회수 건수
    V_GRP_CNT   NUMBER := 0;   -- 그룹매핑 비활성 건수
BEGIN
    -- ① 요청 상태 UPDATE — 행별 반려사유 매칭 (기존 MAX() 결함 교정)
    MERGE INTO SCM_MGR.SCM_MST_AUTH_REQUEST T
    USING (
        SELECT J.V_REQ, MAX(J.V_REASON) AS V_REASON
          FROM JSON_TABLE(P_DATA, '$[*]'
                 COLUMNS (V_REQ    VARCHAR2(400)  PATH '$.REQUEST_ID',
                          V_REASON VARCHAR2(4000) PATH '$.REJECT_REASON' NULL ON EMPTY)) J
         GROUP BY J.V_REQ
    ) S
       ON (T.USER_ID || ':' || T.GROUP_ID || ':' || T.DIVISION_ID || ':' || T.PLANT_ID = S.V_REQ)
     WHEN MATCHED THEN UPDATE SET
           T.APPROVAL_RESULT  = 'REJECT',
           T.APPROVAL_USER    = P_SES_USER_ID,
           T.REJECT_REASON    = S.V_REASON,
           T.LAST_UPDATED_BY  = P_SES_USER_ID,
           T.LAST_UPDATE_DATE = SYSDATE;
    V_CNT := SQL%ROWCOUNT;

    -- ② 단위(Division) 권한 회수 — AS-IS DELETE TB_FX_UserGroupAuthExtention 파리티
    DELETE FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
     WHERE A.UNIT_TP_CD = 'D'
       AND (A.USER_GR_ID, A.USER_ID, A.UNIT_ID) IN (
           SELECT R.GROUP_ID, R.USER_ID, R.DIVISION_ID
             FROM SCM_MGR.SCM_MST_AUTH_REQUEST R
            WHERE R.APPROVAL_RESULT = 'REJECT'
              AND (R.USER_ID || ':' || R.GROUP_ID || ':' || R.DIVISION_ID || ':' || R.PLANT_ID) IN (
                  SELECT V_REQ FROM JSON_TABLE(P_DATA, '$[*]'
                      COLUMNS (V_REQ VARCHAR2(400) PATH '$.REQUEST_ID')))
              -- ⚠ Oracle 은 '' = NULL → NOT IN ('','-') 함정 회피 (개별 조건 분리)
              AND TRIM(R.DIVISION_ID) IS NOT NULL
              AND TRIM(R.DIVISION_ID) <> '/');
    V_AUTH_CNT := SQL%ROWCOUNT;

    -- ③ 그룹 매핑 비활성 — 남은 단위권한이 없을 때만 (AS-IS NOT EXISTS 파리티)
    UPDATE SCM_MGR.SCM_ADM_USER_GR_MPG_M M
       SET M.USE_YN           = 'N',
           M.LAST_UPDATED_BY  = P_SES_USER_ID,
           M.LAST_UPDATE_DATE = SYSDATE
     WHERE M.USE_YN <> 'N'
       AND (M.USER_GR_ID, M.USER_ID) IN (
           SELECT R.GROUP_ID, R.USER_ID
             FROM SCM_MGR.SCM_MST_AUTH_REQUEST R
            WHERE R.APPROVAL_RESULT = 'REJECT'
              AND (R.USER_ID || ':' || R.GROUP_ID || ':' || R.DIVISION_ID || ':' || R.PLANT_ID) IN (
                  SELECT V_REQ FROM JSON_TABLE(P_DATA, '$[*]'
                      COLUMNS (V_REQ VARCHAR2(400) PATH '$.REQUEST_ID'))))
       AND NOT EXISTS (
           SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
            WHERE A.USER_GR_ID = M.USER_GR_ID
              AND A.USER_ID    = M.USER_ID);
    V_GRP_CNT := SQL%ROWCOUNT;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE,
           'SUCCESS' AS MSG,
           TO_CHAR(V_CNT) AS EVENT,                   -- 기존 계약 유지(반려 건수)
           TO_CHAR(V_AUTH_CNT) AS UNIT_AUTH_REVOKED,
           TO_CHAR(V_GRP_CNT)  AS GROUP_DEACTIVATED
      FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DECLARE
            V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
        BEGIN
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_ERR AS MSG, '0' AS EVENT,
                   '0' AS UNIT_AUTH_REVOKED, '0' AS GROUP_DEACTIVATED
              FROM DUAL;
        END;
END P_SYS0012_REJECT;

END PKG_SYS0012;
/
SHOW ERRORS PACKAGE BODY PKG_SYS0012
