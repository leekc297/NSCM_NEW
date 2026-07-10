-- =====================================================================
-- Excel Upload 2-Step 토스트/알림 MSG 다국어 보정 — MSG00657/658/659 (2026-07-10)
-- 기존: KO=EN=CN 모두 한글(임시). → EN(영어)/CN(중국어) 실번역 반영 (KO 불변).
-- 멱등 MERGE. 사내 + 클라우드 공통.
-- =====================================================================
MERGE INTO SCM_ADM_MSG_M t
USING (
  -- MSG00657 — 오류 행 존재 시 저장 불가 (전량 게이트)
  SELECT 'MSG00657' MSG_ID, 'EN' LANG_CD, 'Cannot save while error rows exist. Please fix the file and re-upload.' MSG_NM FROM DUAL
  UNION ALL SELECT 'MSG00657', 'CN', '存在错误行，无法保存。请修改文件后重新上传。' FROM DUAL
  -- MSG00658 — 먼저 업로드/검증
  UNION ALL SELECT 'MSG00658', 'EN', 'Please upload and validate the file first.' FROM DUAL
  UNION ALL SELECT 'MSG00658', 'CN', '请先上传文件进行验证。' FROM DUAL
  -- MSG00659 — 검증 완료, OK 눌러 저장
  UNION ALL SELECT 'MSG00659', 'EN', 'Validation complete. Review the results and press OK to save.' FROM DUAL
  UNION ALL SELECT 'MSG00659', 'CN', '验证已完成。请确认结果后点击 OK 保存。' FROM DUAL
) s
ON (t.MSG_ID = s.MSG_ID AND t.LANG_CD = s.LANG_CD)
WHEN MATCHED THEN UPDATE SET t.MSG_NM = s.MSG_NM, t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.MSG_ID, s.LANG_CD, s.MSG_NM, NULL, 'MSG', 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);
COMMIT;

-- 검증
SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_ADM_MSG_M WHERE MSG_ID IN ('MSG00657','MSG00658','MSG00659') ORDER BY MSG_ID, LANG_CD;
