-- [E20261008-SLASHOBJ] PROCEDURE P_SYS0012_APPROVE — 원복(사내 적용 전 원문)
CREATE OR REPLACE PROCEDURE           "P_SYS0012_APPROVE" (
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
    SELECT S.GROUP_ID, S.USER_ID, 'D', S.DIVISION_ID, '-',
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
           AND TRIM(R.DIVISION_ID) <> '-'
           AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_M G WHERE G.USER_GR_ID = R.GROUP_ID)
      ) S
     WHERE NOT EXISTS (
           SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
            WHERE A.USER_GR_ID = S.GROUP_ID AND A.USER_ID = S.USER_ID
              AND A.UNIT_TP_CD = 'D' AND A.UNIT_ID = S.DIVISION_ID AND A.UPPR_UNIT_ID = '-');
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
/
SHOW ERRORS PROCEDURE P_SYS0012_APPROVE
