-- =====================================================================
-- SYS0006 API_TP_CD 룩업 디테일 ROLLBACK (rev2)
--   ① 01 로 새로 INSERT 된 행(CREATED_BY='admin') 삭제
--   ② 01 이 기존 행을 보정(UPDATE)한 환경(클라우드 등)은 삭제하지 않는다 —
--      01 실행 전 [사전 확인] SELECT 결과로 SEGMENT2/DISPLAY_SEQ/DESCRIPTION 을 되돌린다
--   MASTER(CREATED_BY='SYSTEM') 는 대상 아님
-- =====================================================================

DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'API_TP_CD'
   AND SEGMENT3 = '-' AND SEGMENT4 = '-' AND SEGMENT5 = '-'
   AND CREATED_BY = 'admin'
   AND (SEGMENT1, SEGMENT2) IN (('PROC_SELECT', 'LBL00321'), ('PROC_SAVE', 'LBL00322')
                              , ('PROC', 'Procedure'), ('POST', 'Post'), ('EXCELUPLOAD', 'LBL00346'));

COMMIT;
