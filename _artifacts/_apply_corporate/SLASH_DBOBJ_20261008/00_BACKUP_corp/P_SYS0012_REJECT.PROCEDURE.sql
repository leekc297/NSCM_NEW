PROCEDURE           "P_SYS0012_REJECT" (
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
              AND TRIM(R.DIVISION_ID) <> '-');
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