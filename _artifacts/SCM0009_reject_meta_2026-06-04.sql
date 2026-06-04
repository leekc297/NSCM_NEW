-- ============================================================================
-- SCM0009 REJECT — BE 메타 정렬 (placeholder P_SCM0009_REJECT_AUTH → 실제 SP)
-- 작성: 2026-06-04
-- 변경:
--   API_M.API_URL  : P_SCM0009_REJECT_AUTH → UP_FX_RejectAuthRequest
--   PROC_M         : 신규 3 IN + 1 OUT (requestIds CLOB / rejectReason VARCHAR / sesUserId VARCHAR / O_RESULT_CURSOR)
--
-- 주의: FE 가 현재 rejectReason 을 보내지 않음 (handleReject 에서 requestIds 만 전송).
--       이 SP 는 rejectReason 받을 수 있게 작성됨 → FE 수정 시 reject 사유 입력 dialog 추가 필요 (별도 ticket).
-- ============================================================================

-- BLOCK 1: API_M.API_URL 정정
UPDATE SCM_ADM_API_M
   SET API_URL = 'UP_FX_RejectAuthRequest',
       API_MSG_DESC = 'AS-IS UP_FX_SaveApprovalAuthRequest REJECT 분기 (Oracle 신규 작성 2026-06-04, framework SP 의존성 0)',
       LAST_UPDATED_BY = 'SYSTEM',
       LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID = 'API_SCM0009_REJECT';

-- BLOCK 2: PROC_M 정리 + 신규 등록
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM IN ('P_SCM0009_REJECT_AUTH', 'UP_FX_RejectAuthRequest');

INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'UP_FX_RejectAuthRequest' AS PROC_NM,
       'requestIds' AS COL_NM, 'CLOB' AS DATA_TP_CD, 'IN' AS COL_TP_CD, 1 AS SORT_ORD,
       'SYSTEM' AS CB, SYSDATE AS CD, 'SYSTEM' AS LB, SYSDATE AS LD FROM DUAL UNION ALL
SELECT 'UP_FX_RejectAuthRequest', 'rejectReason', 'VARCHAR', 'IN', 2, 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE FROM DUAL UNION ALL
SELECT 'UP_FX_RejectAuthRequest', 'sesUserId',    'VARCHAR', 'IN', 3, 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE FROM DUAL UNION ALL
SELECT 'UP_FX_RejectAuthRequest', 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', 4, 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE FROM DUAL;

COMMIT;

PROMPT === Verify ===
SELECT API_ID, API_URL FROM SCM_ADM_API_M WHERE API_ID = 'API_SCM0009_REJECT';
SELECT COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M WHERE PROC_NM = 'UP_FX_RejectAuthRequest' ORDER BY SORT_ORD;
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = 'UP_FX_REJECTAUTHREQUEST';
