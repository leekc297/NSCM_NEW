/*=============================================================================================
 * File         : 16_DMF0073_version_proc_meta_fix.sql
 * Description  : DMF0073_GET_VERSION_SALESPRICE PROC_M 시그니처 정정
 *              :
 *              : 사고: 2026-06-03 PLS-00306 — 인수 갯수 불일치
 *              :   내가 추측 등록한 시그니처 (periodFrom/type/flagDay/flagWeek/flagManual)
 *              :   ≠ 실제 DB SP signature (USER_ARGUMENTS 조회 결과):
 *              :
 *              : 실제 DB signature (9 인자):
 *              :   1. P_START_YYYYMMDD  IN VARCHAR2
 *              :   2. P_END_YYYYMMDD    IN VARCHAR2
 *              :   3. P_CREATED_BY      IN VARCHAR2
 *              :   4. P_DIVISION_ID     IN VARCHAR2
 *              :   5. P_VERSION_TYPE    IN VARCHAR2
 *              :   6. P_DESCRIPTION     IN VARCHAR2
 *              :   7. P_USER_ID         IN VARCHAR2 → BE 자동 sesUserId
 *              :   8. P_MENU_ID         IN VARCHAR2 → BE 자동 mnuId
 *              :   9. O_RC1             OUT REF CURSOR
 *              :
 *              : (PROC_RESULT 없음 — 단일 cursor SP)
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-03
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0073_GET_VERSION_SALESPRICE';

INSERT ALL
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'startYyyymmdd', 'IN',  'VARCHAR', 1, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'endYyyymmdd',   'IN',  'VARCHAR', 2, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'createdBy',     'IN',  'VARCHAR', 3, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'divisionId',    'IN',  'VARCHAR', 4, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'versionType',   'IN',  'VARCHAR', 5, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'description',   'IN',  'VARCHAR', 6, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'sesUserId',     'IN',  'VARCHAR', 7, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'mnuId',         'IN',  'VARCHAR', 8, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0073_GET_VERSION_SALESPRICE', 'o_rc1',         'OUT', 'CURSOR',  9, 'admin', SYSDATE, 'admin', SYSDATE)
SELECT * FROM DUAL;

COMMIT;

PROMPT === 검증 ===
SELECT COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M
 WHERE PROC_NM = 'DMF0073_GET_VERSION_SALESPRICE' ORDER BY SORT_ORD;
