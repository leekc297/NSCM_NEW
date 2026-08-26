-- =====================================================================================
-- SDM5010 Project Master — [06] MSG/LBL (메뉴 라벨 2종x3 + 신규 MSG 6종x3 + 신규 LBL 1종x3)
-- 2026-08-19 · 감사컬럼 'admin' · 멱등(NOT EXISTS — 기존 코드 문구 불변)
--
-- [재사용 — 실문구 DB 검증 완료 (2026-08-19 사내 실측)]
--   MSG00097 (Division 을 선택하세요.)                 : 조회 Division 미선택
--   MSG00108 (조회 기간이 잘못되었습니다 (시작일 > 종료일).) : 기간 역전
--   MSG00716 (User 는 입력 리스트에 이미 존재합니다.)       : 권한관리 팝업(SDM1010 재사용)
--   MSG00717 (User 는 조회 리스트에 이미 존재합니다.)       : 권한관리 팝업(SDM1010 재사용)
--   MSG01007 (관리자는 권한을 추가할 수 없습니다.)          : 권한관리 팝업(SDM1020 신설분 재사용)
--   MSG00002 (성공적으로 저장되었습니다.) / MSG00003 (저장에 실패하였습니다.) : TAB2 저장
--   LBL00001 (Div) / LBL00643 (Customer) / LBL00857 (Reg Complete Date)   : 조회조건
--   LBL00046 (Cell Type) / LBL00607 (Biz Type)                            : 조회조건 (실측 기존재 → 재사용)
--   LBL00623 (Approve) / LBL00624 (Reject)                                : TAB1 승인/반려 버튼 (실측 기존재 → 재사용)
--
-- [⚠ 지시 대비 실측 조정 — i18n 재사용 원칙(2026-08-14 사용자 확정 룰) 적용]
--   지시서 신규 7코드 중 '기간 3년' 은 실문구 완전 일치 기존재 2건 실측:
--     MSG00164 (KO/EN/CN 번역 완비 · FE 전 화면 소비 20회 실측) ← **재사용 채택**
--     MSG00715 (KO=EN=CN 동일 한글 · FE 소비 0회 — 중복 채번 잔재, 불변 유지)
--   → 신규 채번은 승인/반려 6코드만: MSG01008~MSG01013 (MSG01xxx 대역 max=MSG01007 실측 +1)
--   조회조건 'Cell 유형'/'Biz Type' 도 기존 LBL 실측 기존재 → 재사용 (신규 채번 없음)
--   신규 LBL = LBL00863 (Development Status — 실측 부재, LBL max=LBL00862 실측 +1)
--
-- [신규 MSG 문구 원천 = 설계서 TAB1 '메시지 코드' 실측 — '실해' 오타는 '실패' 로 정정]
-- =====================================================================================

-- [6-1] 메뉴 라벨 (MNU_SDM_Admin=Administration(개요 '샘플 수요 > Administration'), MNU_SDM5010=Project Master)
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT T.MI, L.LC, T.NM, 'SDM5010 신설 2026-08-19', 'MNU', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MNU_SDM_Admin' MI, 'Administration' NM FROM DUAL
    UNION ALL
    SELECT 'MNU_SDM5010' MI, 'Project Master' NM FROM DUAL
  ) T
 CROSS JOIN (SELECT 'KO' LC FROM DUAL UNION ALL SELECT 'EN' FROM DUAL UNION ALL SELECT 'CN' FROM DUAL) L
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID = T.MI AND X.LANG_CD = L.LC);

-- [6-2] 신규 MSG 6종 (승인/반려 confirm·성공·실패) — 3언어 KO=EN=CN (SDM1010/1020 관례)
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT T.MI, L.LC, T.NM, 'SDM5010 신설 2026-08-19', 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG01008' MI, '선택한 프로젝트 등록 요청을 승인하시겠습니까?' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01009' MI, '선택한 프로젝트 등록 요청이 승인되었습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01010' MI, '프로젝트 등록 요청 승인에 실패하였습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01011' MI, '선택한 프로젝트 등록 요청을 반려하시겠습니까?' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01012' MI, '선택한 프로젝트 등록 요청이 반려되었습니다.' NM FROM DUAL
    UNION ALL
    SELECT 'MSG01013' MI, '프로젝트 등록 요청 반려에 실패하였습니다.' NM FROM DUAL
  ) T
 CROSS JOIN (SELECT 'KO' LC FROM DUAL UNION ALL SELECT 'EN' FROM DUAL UNION ALL SELECT 'CN' FROM DUAL) L
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID = T.MI AND X.LANG_CD = L.LC);

-- [6-3] 신규 LBL 1종 (조회조건 '개발 현황')
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'LBL00863', L.LC, 'Development Status', 'SDM5010 신설 2026-08-19', 'LBL', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (SELECT 'KO' LC FROM DUAL UNION ALL SELECT 'EN' FROM DUAL UNION ALL SELECT 'CN' FROM DUAL) L
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID = 'LBL00863' AND X.LANG_CD = L.LC);

COMMIT;
