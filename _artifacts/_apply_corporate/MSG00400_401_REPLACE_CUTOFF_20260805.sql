-- =====================================================================================
-- MSG00400/MSG00401 등록 (2026-08-05) — DMF0042 Replace by Cutoff 모달 (hook #114 3점 동기)
-- 용법  : MSG00400 = Replace 확인창 ({0}년{1}월~{2}년{3}월 + {4}=버전 — AS-IS ReplaceByCutOffPopUp L474)
--         MSG00401 = Replace 완료 ({0}건 — L511)
-- ⚠ 한계 : AS-IS 원문 미확보(MSSQL 미도달·클라우드 미러 MSG_M 에도 미등재) — 문구 신설.
--         원문 확보 시 대사·정정 (memory feedback_msg_id_text_reconciliation).
-- 런타임 원천 = 본 테이블 (BE /admin/message → gen:i18n → locales JSON). 로컬 locales 는 선반영됨.
-- DDL   : SCM_ADM_MSG_M 10컬럼 실측 (MSG_ID/LANG_CD/MSG_NM/MSG_DESC/MSG_TP_CD/USE_YN + 감사 4)
-- =====================================================================================
INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG00400', 'KO', '''{0}년 {1}월 ~ {2}년 {3}월'' 기간의 Current 데이터를 Cutoff 버전 [{4}] 데이터로 대체하시겠습니까?', 'DMF0042 Replace by Cutoff 확인', 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MSG_M WHERE MSG_ID='MSG00400' AND LANG_CD='KO');

INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG00400', 'EN', 'Replace the Current data for ''{0}.{1} ~ {2}.{3}'' with the cutoff version [{4}]?', 'DMF0042 Replace by Cutoff confirm', 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MSG_M WHERE MSG_ID='MSG00400' AND LANG_CD='EN');

INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG00400', 'CN', '是否将''{0}年{1}月 ~ {2}年{3}月''期间的Current数据替换为Cutoff版本[{4}]?', 'DMF0042 Replace by Cutoff confirm', 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MSG_M WHERE MSG_ID='MSG00400' AND LANG_CD='CN');

INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG00401', 'KO', '{0}건의 데이터가 대체되었습니다.', 'DMF0042 Replace by Cutoff 완료', 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MSG_M WHERE MSG_ID='MSG00401' AND LANG_CD='KO');

INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG00401', 'EN', '{0} rows have been replaced.', 'DMF0042 Replace by Cutoff done', 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MSG_M WHERE MSG_ID='MSG00401' AND LANG_CD='EN');

INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG00401', 'CN', '已替换{0}条数据。', 'DMF0042 Replace by Cutoff done', 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MSG_M WHERE MSG_ID='MSG00401' AND LANG_CD='CN');

COMMIT;

-- 검증 (기대 6행)
-- SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_ADM_MSG_M WHERE MSG_ID IN ('MSG00400','MSG00401') ORDER BY 1,2;
