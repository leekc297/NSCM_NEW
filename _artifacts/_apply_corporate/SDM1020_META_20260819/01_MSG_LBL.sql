-- =====================================================================================
-- SDM1020 Project List — [01] MSG/LBL (메뉴 3 + 신규 MSG 6종×3언어)
-- 2026-08-19 · 원천 = 화면설계서 20260814 · SDM1010_04_META_20260812.sql 관례 승계 · 멱등(NOT EXISTS)
-- 재사용(신규 채번 없음 — 실문구 DB 검증 완료):
--   LBL00001(Div=사업부) / LBL00643(Customer=고객) / LBL00855(My Authority=나의 권한)
--   LBL00856(Reg Status=등록 상태) / LBL00857(Reg Complete Date=등록 완료일) / LBL00859(Reg Request=등록요청 버튼)
--   MSG00097 / MSG00108 / MSG00004(수정한 내용이 없습니다) / MSG00709 / MSG00710 / MSG00711 / MSG00712
--   MSG00716 / MSG00717 / MSG00002(저장 성공) / MSG00003(저장 실패)
-- 신규 = MSG01002~MSG01007 (MSG01001 사용 중 — 사용 최대치 실측 후 +1)
-- =====================================================================================

-- [1-1] 메뉴 라벨 MNU_SDM1020 (3언어, SDM1010 MNU_SDM1010 패턴)
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT T.MI, T.LC, T.NM, 'SDM1020 신설 2026-08-19', 'MNU', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MNU_SDM1020' MI, 'KO' LC, 'Project List' NM FROM DUAL
    UNION ALL
    SELECT 'MNU_SDM1020' MI, 'EN' LC, 'Project List' NM FROM DUAL
    UNION ALL
    SELECT 'MNU_SDM1020' MI, 'CN' LC, 'Project List' NM FROM DUAL
  ) T
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID = T.MI AND X.LANG_CD = T.LC);

-- [1-2] 신규 MSG 6종 (권한요청 5 + 관리자 추가불가 1) — 3언어 KO=EN=CN (SDM1010 관례)
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT T.MI, T.LC, T.NM, 'SDM1020 신설 2026-08-19', 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG01002' MI, 'KO' LC, '권한요청 항목이 없습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01002' MI, 'EN' LC, '권한요청 항목이 없습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01002' MI, 'CN' LC, '권한요청 항목이 없습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01003' MI, 'KO' LC, '권한요청 하시겠습니까?' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01003' MI, 'EN' LC, '권한요청 하시겠습니까?' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01003' MI, 'CN' LC, '권한요청 하시겠습니까?' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01004' MI, 'KO' LC, '권한요청을 취소 하시겠습니까?' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01004' MI, 'EN' LC, '권한요청을 취소 하시겠습니까?' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01004' MI, 'CN' LC, '권한요청을 취소 하시겠습니까?' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01005' MI, 'KO' LC, '성공적으로 권한요청 되었습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01005' MI, 'EN' LC, '성공적으로 권한요청 되었습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01005' MI, 'CN' LC, '성공적으로 권한요청 되었습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01006' MI, 'KO' LC, '권한요청에 실패하였습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01006' MI, 'EN' LC, '권한요청에 실패하였습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01006' MI, 'CN' LC, '권한요청에 실패하였습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01007' MI, 'KO' LC, '관리자는 권한을 추가할 수 없습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01007' MI, 'EN' LC, '관리자는 권한을 추가할 수 없습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01007' MI, 'CN' LC, '관리자는 권한을 추가할 수 없습니다.' NM FROM DUAL
  ) T
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID = T.MI AND X.LANG_CD = T.LC);

COMMIT;
