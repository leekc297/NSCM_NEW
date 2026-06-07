/*=============================================================================================
 * File         : 040_minyonglee1_Permission_Grant.sql
 * Description  : minyonglee1 사용자 그룹에 DMF0003 메뉴 + 모든 버튼 권한 부여
 *              :   memory user_login_id — minyonglee1 표준
 *              :   memory feedback_runtime_error_prevention — admin 그룹 권한 표준
 *===========================================================================================*/

-- ── 1. minyonglee1 의 사용자 그룹 확인 + 메뉴 권한 부여 ────────────────────────────
MERGE INTO SCM_ADM_USER_GR_MNU_MPG_M T
USING (
    SELECT DISTINCT u.USER_GR_ID, 'DMF0003' AS MNU_ID
    FROM SCM_ADM_USER_M u WHERE u.USER_ID = 'minyonglee1'
) S
ON (T.USER_GR_ID = S.USER_GR_ID AND T.MNU_ID = S.MNU_ID)
WHEN MATCHED THEN
    UPDATE SET T.USE_YN = 'Y', T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
    INSERT (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (S.USER_GR_ID, S.MNU_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);


-- ── 2. 자매 화면 DMF0020 권한 그룹 의 권한도 DMF0003 에 동일 부여 (안전망) ────────────────────────────
MERGE INTO SCM_ADM_USER_GR_MNU_MPG_M T
USING (
    SELECT DISTINCT USER_GR_ID, 'DMF0003' AS MNU_ID
    FROM SCM_ADM_USER_GR_MNU_MPG_M
    WHERE MNU_ID = 'DMF0020'  -- 자매 화면
) S
ON (T.USER_GR_ID = S.USER_GR_ID AND T.MNU_ID = S.MNU_ID)
WHEN NOT MATCHED THEN
    INSERT (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (S.USER_GR_ID, S.MNU_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);


-- ── 3. 부모 메뉴 (Demand_Master) 권한도 같은 그룹에 부여 ────────────────────────────
MERGE INTO SCM_ADM_USER_GR_MNU_MPG_M T
USING (
    SELECT DISTINCT USER_GR_ID, 'Demand_Master' AS MNU_ID
    FROM SCM_ADM_USER_GR_MNU_MPG_M
    WHERE MNU_ID = 'DMF0003'
) S
ON (T.USER_GR_ID = S.USER_GR_ID AND T.MNU_ID = S.MNU_ID)
WHEN NOT MATCHED THEN
    INSERT (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (S.USER_GR_ID, S.MNU_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);


-- ── 4. 버튼 권한 부여 — minyonglee1 그룹에 모든 DMF0003 버튼 ────────────────────────────
MERGE INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M T
USING (
    SELECT DISTINCT u.USER_GR_ID, bm.MNU_ID, bm.SHT_NM, bm.MNU_BTN_CD
    FROM SCM_ADM_USER_M u
    CROSS JOIN SCM_ADM_MNU_BTN_MPG_M bm
    WHERE u.USER_ID = 'minyonglee1'
      AND bm.MNU_ID = 'DMF0003'
) S
ON (T.USER_GR_ID = S.USER_GR_ID AND T.MNU_ID = S.MNU_ID AND T.SHT_NM = S.SHT_NM AND T.MNU_BTN_CD = S.MNU_BTN_CD)
WHEN NOT MATCHED THEN
    INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (S.USER_GR_ID, S.MNU_ID, S.SHT_NM, S.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);


COMMIT;


-- ── 검증 ────────────────────────────
SELECT '1.minyonglee1_GROUP' AS K, USER_ID, USER_GR_ID FROM SCM_ADM_USER_M WHERE USER_ID = 'minyonglee1';
SELECT '2.DMF0003_MNU_PERM' AS K, LISTAGG(USER_GR_ID, ', ') WITHIN GROUP (ORDER BY USER_GR_ID) AS GROUPS
FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0003';
SELECT '3.DMF0003_BTN_PERM' AS K, USER_GR_ID, COUNT(*) AS BTN_CNT
FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0003'
GROUP BY USER_GR_ID
ORDER BY USER_GR_ID;
