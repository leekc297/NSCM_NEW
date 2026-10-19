-- =====================================================================================
-- DMF0044 (Sales Reports / MDF Reports) — INSERT 버튼 회수
--   요청: 사용자 지시 2026-09-11 "DMF0044 에서는 INSERT 기능을 사용하지 않는다"
--   원장: REQ:CHAT-20260911-W65
--   마커: E20260911-DMF0044INSOFF
--
-- 적용 축 (실측 근거)
--   [핵심·실효] SCM_ADM_USER_GR_MNU_BTN_MPG_M 2행
--       FE `hasButton('INSERT')` 의 원천 = PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH(BODY L60~73).
--       그 SP 는 이 표만 읽고 `UG.USE_YN='Y' AND GMB.USE_YN='Y'` 로 거른다([E20260826-BTNUSEYN]).
--       => 'N' 이면 mnuBtnAuth 에서 INSERT 제외 → SalesReports.tsx 의
--          `insert: hasButton('INSERT') && searched.dataType === DATA_TYPE.ETC ? handleInsert : false`
--          가 false → **버튼 미렌더 + F8 핫키 미등록** (공용 SubTitle 규약).
--       ⭐ Insert 는 이 화면에서 ETC(Data Type=2) 전용이었으므로 화면 전체에서 사라진다.
--
--   [선언·런타임 무효과] SCM_ADM_MNU_BTN_MPG_M 1행
--       실측: 이 표의 USE_YN 을 필터로 쓰는 곳이 없다 —
--         · PR_GET_MNU_BTN_AUTH  : 이 표 자체를 안 읽음
--         · PKG_NSCM_UI_COMM     : API_URL 해석 시 (MNU_ID,SHT_NM,MNU_BTN_CD) 만, USE_YN 필터 없음
--         · PKG_SYS0008 버튼목록 : MB.USE_YN 필터 없음 (L104~114. L109 의 M.USE_YN 은 SCM_ADM_MSG_M)
--       따라서 동작 변화는 0이고, SYS0009(Menu Button) 화면에서 "이 메뉴는 이 버튼 미사용"을
--       admin 이 알아볼 수 있게 하는 **선언** 목적이다.
--
-- 부수영향 없음 확인
--   · DMF0044 버튼 배선 29행 전수 조회 — MNU_BTN_CD='INSERT' 는 'MDF Reports' 시트에만 존재
--   · 환율 팝업의 자체 Insert 는 FE 에서 hasButton('EXRATE_SAVE') 로 별도 게이트 → 무영향
--   · SCM_ADM_API_M 은 건드리지 않는다(다른 참조 가능성 + 실익 없음)
--
-- 감사컬럼: 'admin' 고정 (메모리 feedback_meta_audit_column_admin_only)
-- 원복    : 99_ROLLBACK.sql
-- =====================================================================================

UPDATE SCM_ADM_USER_GR_MNU_BTN_MPG_M            --[E20260911-DMF0044INSOFF]
   SET USE_YN           = 'N'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID     = 'DMF0044'
   AND SHT_NM     = 'MDF Reports'
   AND MNU_BTN_CD = 'INSERT'
   AND USE_YN     = 'Y';

UPDATE SCM_ADM_MNU_BTN_MPG_M                    --[E20260911-DMF0044INSOFF]
   SET USE_YN           = 'N'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID     = 'DMF0044'
   AND SHT_NM     = 'MDF Reports'
   AND MNU_BTN_CD = 'INSERT'
   AND USE_YN     = 'Y';

COMMIT;
