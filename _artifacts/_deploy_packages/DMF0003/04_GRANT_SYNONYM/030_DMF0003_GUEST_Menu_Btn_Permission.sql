/*=============================================================================================
 * File         : 030_DMF0003_GUEST_Menu_Btn_Permission.sql
 * Description  : GUEST 사용자에 DMF0003 모든 버튼 권한 부여 (테스트 환경 only)
 *===========================================================================================*/

DELETE FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_GR_ID = 'GUEST' AND MNU_ID = 'DMF0003';

INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', bm.MNU_ID, bm.SHT_NM, bm.MNU_BTN_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
FROM SCM_ADM_MNU_BTN_MPG_M bm
WHERE bm.MNU_ID = 'DMF0003';

COMMIT;

SELECT COUNT(*) AS GUEST_PERM_CNT FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_GR_ID = 'GUEST' AND MNU_ID = 'DMF0003';
