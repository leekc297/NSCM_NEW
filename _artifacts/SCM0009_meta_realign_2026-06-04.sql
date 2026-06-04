-- ============================================================================
-- SCM0009 권한 승인 — BE 메타 정정 (placeholder P_SCM0009_* → 실제 Oracle SP)
-- 작성: 2026-06-04
-- 변경:
--   API_M.API_URL  : P_SCM0009_GET_APPROVAL_LIST → UP_FX_GetApprovalAuthRequest (정정 완료)
--   PROC_M         : P_SCM0009_GET_APPROVAL_LIST (없음) → UP_FX_GetApprovalAuthRequest (신규 4 IN + 1 OUT)
--   APPROVE/REJECT : 추후 (Save SP 변환 + 외부 framework 의존성 5종 확인 후 별도 처리)
-- ============================================================================

-- BLOCK 1: API_M.API_URL 정정 (GET)
UPDATE SCM_ADM_API_M
   SET API_URL = 'UP_FX_GetApprovalAuthRequest',
       API_MSG_DESC = 'AS-IS UP_FX_GetApprovalAuthRequest (Oracle 정밀 변환 2026-06-04)',
       LAST_UPDATED_BY = 'SYSTEM',
       LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID = 'API_SCM0009_GET_APPROVAL_LIST';

-- BLOCK 2: PROC_M 정리 + 신규 등록 (positional camelCase = FE JSON key 순서)
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM IN ('P_SCM0009_GET_APPROVAL_LIST', 'UP_FX_GetApprovalAuthRequest');

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'UP_FX_GetApprovalAuthRequest' AS PROC_NM,
       'userId' AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN' AS COL_TP_CD, 1 AS SORT_ORD,
       'SYSTEM' AS CB, SYSDATE AS CD, 'SYSTEM' AS LB, SYSDATE AS LD FROM DUAL UNION ALL
SELECT 'UP_FX_GetApprovalAuthRequest', 'startDate', 'VARCHAR', 'IN', 2, 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE FROM DUAL UNION ALL
SELECT 'UP_FX_GetApprovalAuthRequest', 'endDate',   'VARCHAR', 'IN', 3, 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE FROM DUAL UNION ALL
SELECT 'UP_FX_GetApprovalAuthRequest', 'status',    'VARCHAR', 'IN', 4, 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE FROM DUAL UNION ALL
SELECT 'UP_FX_GetApprovalAuthRequest', 'O_RC1',     'CURSOR',  'OUT', 5, 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE FROM DUAL;

COMMIT;

PROMPT === Verify ===
PROMPT --- API_M
SELECT API_ID, API_URL FROM SCM_ADM_API_M WHERE API_ID = 'API_SCM0009_GET_APPROVAL_LIST';
PROMPT --- PROC_M
SELECT COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M WHERE PROC_NM = 'UP_FX_GetApprovalAuthRequest' ORDER BY SORT_ORD;
PROMPT --- SP existence
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = 'UP_FX_GETAPPROVALAUTHREQUEST';
