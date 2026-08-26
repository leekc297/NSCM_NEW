-- =====================================================================================
-- SDM1020 Project List — [04] MSG/LBL — 신규 채번분만 (INSERT-only)
-- ⭐ 신규 룰(2026-08-19 사용자 확정) 첫 적용: 기존 존재 코드는 MERGE 금지·이관 대상 제외.
--   신규 채번분만 INSERT (NOT EXISTS 멱등 가드 — UPDATE/MERGE 문 없음. 기존 문구 덮어쓰기 0건 보장).
-- 원천: 사내 `_apply_corporate/SDM1020_META_20260819/01_MSG_LBL.sql`(1-1/1-2) +
--   `05_API_BTN_AUTH.sql`(5-1) — 사내 원장 실측 대조 드리프트 0 확인(2026-08-19):
--   MNU_SDM1020 3행 / MSG01002~01007 18행 / MSG_API_SDM1020_* 21행 = 42행, 문구 전건 일치.
-- ⚠ 채번 충돌 가드: 클라우드에서 MSG01002~01007 이 이미 "다른 문구"로 선점되어 있으면
--   (MSG00704->MSG01001 재채번 사고 계보) 실행 중단 -> 재채번. 00_CLOUD_PRECHECK [P7] 이 선검사.
--
-- [재사용 코드 — 이관 제외 (기존 존재 — 본 파일에 INSERT 없음, 목록만 기재)]
--   LBL00001(Div) / LBL00643(Customer) / LBL00855(My Authority) / LBL00856(Reg Status)
--   LBL00857(Reg Complete Date) / LBL00859(Reg Request)
--   MSG00097(Division 미선택) / MSG00108(기간 역전) / MSG00004(수정 내용 없음) / MSG00709(선택 항목 없음)
--   MSG00710(등록/변경 Confirm) / MSG00711(등록요청 성공) / MSG00712(등록요청 실패)
--   MSG00716(입력 리스트 기존재) / MSG00717(조회 리스트 기존재) / MSG00002(저장 성공) / MSG00003(저장 실패)
--   -> 00_CLOUD_PRECHECK [P8] 에서 기존재(3언어) 확인. 부재 코드 발견 시 회신(임의 INSERT 금지).
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


-- [4-2] MSG_API (7 API × 3언어 = 21)
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG_API_' || T.AI, L.LC, T.NM, 'SDM1020 API', 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'SDM1020_main_SEARCH' AI, 'SDM1020 MAIN SEARCH' NM FROM DUAL
    UNION ALL
    SELECT 'SDM1020_main_EXCEL' AI, 'SDM1020 MAIN EXCEL' NM FROM DUAL
    UNION ALL
    SELECT 'SDM1020_main_FILTER' AI, 'SDM1020 MAIN FILTER' NM FROM DUAL
    UNION ALL
    SELECT 'SDM1020_main_SORT' AI, 'SDM1020 MAIN SORT' NM FROM DUAL
    UNION ALL
    SELECT 'SDM1020_main_REQ' AI, 'SDM1020 MAIN REQ' NM FROM DUAL
    UNION ALL
    SELECT 'SDM1020_main_AUTHREQ' AI, 'SDM1020 MAIN AUTHREQ' NM FROM DUAL
    UNION ALL
    SELECT 'SDM1020_period_SEARCH' AI, 'SDM1020 PERIOD SEARCH' NM FROM DUAL
  ) T
 CROSS JOIN (SELECT 'KO' LC FROM DUAL UNION ALL SELECT 'EN' FROM DUAL UNION ALL SELECT 'CN' FROM DUAL) L
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID = 'MSG_API_' || T.AI AND X.LANG_CD = L.LC);

COMMIT;
