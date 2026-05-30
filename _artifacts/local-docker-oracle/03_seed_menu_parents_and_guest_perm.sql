/*=============================================================================================
 * File         : 03_seed_menu_parents_and_guest_perm.sql
 * Description  : DMF0020 메뉴가 FE 트리에서 보이도록 부모 메뉴 + GUEST 권한 시드
 *              :   1) 부모 메뉴 더미 — 'master' (LV1) + 'DEMAND_MASTER' (LV2)
 *              :   2) 부모 i18n 3 lang
 *              :   3) GUEST 그룹 → DMF0020 권한 (03 SQL 의 BLOCK 7 은 ADMIN/DEMAND_USER 만 → minyonglee1 안 보임)
 *              :   4) GUEST 그룹 → 부모 메뉴 권한 (트리 표시용)
 * Connection   : SCM_MGR @ FREEPDB1
 * Created      : 2026-05-26
 *
 * 사전 조건   : 03_DMF0020_Registration.sql 적재 완료 (DMF0020 row 존재)
 * 멱등성     : MERGE 사용 — 재실행 안전
 *===========================================================================================*/

SET ECHO ON
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE

-- ---------------------------------------------------------------------------------------------
-- BLOCK 1. 부모 메뉴 i18n (KO/EN/CN)
-- ---------------------------------------------------------------------------------------------
MERGE INTO SCM_ADM_MSG_M T
USING (SELECT 'MNU_MASTER' MSG_ID, 'KO' LANG_CD, '마스터' NM FROM DUAL UNION ALL
       SELECT 'MNU_MASTER', 'EN', 'Master'    FROM DUAL UNION ALL
       SELECT 'MNU_MASTER', 'CN', '主数据'    FROM DUAL UNION ALL
       SELECT 'MNU_DEMAND_MASTER', 'KO', '수요 마스터' FROM DUAL UNION ALL
       SELECT 'MNU_DEMAND_MASTER', 'EN', 'Demand Master' FROM DUAL UNION ALL
       SELECT 'MNU_DEMAND_MASTER', 'CN', '需求主数据' FROM DUAL) S
   ON (T.MSG_ID = S.MSG_ID AND T.LANG_CD = S.LANG_CD)
WHEN MATCHED THEN
    UPDATE SET T.MSG_NM = S.NM, T.LAST_UPDATED_BY = 'SYSTEM', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
    INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (S.MSG_ID, S.LANG_CD, S.NM, 'MNU', 'Y',
            'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE);

-- ---------------------------------------------------------------------------------------------
-- BLOCK 2. 부모 메뉴 (master = LV1 root, DEMAND_MASTER = LV2)
-- ---------------------------------------------------------------------------------------------
MERGE INTO SCM_ADM_MNU_M T
USING (SELECT 'master'         MNU_ID, NULL             UPPR, 1 LV, 'MNU_MASTER'         MSG, 'master'         URL, 10 SORT FROM DUAL UNION ALL
       SELECT 'DEMAND_MASTER', 'master',                  2,    'MNU_DEMAND_MASTER',       'demand-master',     20 FROM DUAL) S
   ON (T.MNU_ID = S.MNU_ID)
WHEN MATCHED THEN
    UPDATE SET T.UPPR_MNU_ID = S.UPPR, T.MNU_LV_NO = S.LV, T.MNU_MSG_ID = S.MSG,
               T.MNU_URL = S.URL, T.SORT_ORD = S.SORT, T.MNU_TP_CD = 'FD', T.USE_YN = 'Y',
               T.LAST_UPDATED_BY = 'SYSTEM', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
    INSERT (MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_MSG_ID, MNU_URL, SORT_ORD,
            MNU_TP_CD, USE_YN,
            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (S.MNU_ID, S.UPPR, S.LV, S.MSG, S.URL, S.SORT,
            'FD', 'Y',
            'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE);

-- ---------------------------------------------------------------------------------------------
-- BLOCK 3. GUEST 그룹 → 메뉴 권한 (DMF0020 + 부모 메뉴 트리 표시용)
-- ---------------------------------------------------------------------------------------------
MERGE INTO SCM_ADM_USER_GR_MNU_MPG_M T
USING (SELECT 'GUEST' GR, 'master'         MN FROM DUAL UNION ALL
       SELECT 'GUEST',     'DEMAND_MASTER'    FROM DUAL UNION ALL
       SELECT 'GUEST',     'DMF0020'          FROM DUAL) S
   ON (T.USER_GR_ID = S.GR AND T.MNU_ID = S.MN)
WHEN MATCHED THEN
    UPDATE SET T.USE_YN = 'Y', T.LAST_UPDATED_BY = 'SYSTEM', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
    INSERT (USER_GR_ID, MNU_ID, USE_YN,
            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (S.GR, S.MN, 'Y',
            'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE);

COMMIT;

-- ---------------------------------------------------------------------------------------------
-- BLOCK 4. 검증
-- ---------------------------------------------------------------------------------------------
PROMPT === Menu tree ===
COLUMN MNU_ID FORMAT A20
COLUMN UPPR_MNU_ID FORMAT A20
COLUMN MNU_URL FORMAT A20
COLUMN MNU_MSG_ID FORMAT A30
SELECT MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_URL, MNU_MSG_ID, MNU_TP_CD, USE_YN
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID IN ('master', 'DEMAND_MASTER', 'DMF0020')
 ORDER BY MNU_LV_NO, SORT_ORD;

PROMPT === GUEST permissions ===
COLUMN USER_GR_ID FORMAT A20
SELECT USER_GR_ID, MNU_ID, USE_YN FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE USER_GR_ID = 'GUEST'
 ORDER BY MNU_ID;

PROMPT === DONE: 03_seed_menu_parents_and_guest_perm.sql ===
EXIT
