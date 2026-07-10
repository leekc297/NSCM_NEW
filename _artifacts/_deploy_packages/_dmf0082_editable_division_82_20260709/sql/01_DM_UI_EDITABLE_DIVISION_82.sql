-- =====================================================================
-- DMF0082 Fcst&Price MGMT — 82 Division 편집불가 LOOKUP 데이터 추가
-- LOOKUP_TYPE = DM_UI_EDITABLE_DIVISION (ATTRIBUTE1='N' = 해당 division 편집불가)
-- 규약: DMF0003/DMF0020 은 40·81 을 'N'(편집불가)로 등록 → 82 만 편집.
--       DMF0082 는 반대 — 40/81/81_ 편집가능(미등록=허용), 82 만 'N'(편집불가) 등록.
-- 대상 DB : SCM_MGR@OCGSCMD_P01 (사내)
-- 작성    : 2026-07-09 / minyonglee1
-- ⚠ 고지 : DMF0082 SP(PKG_DMF0082/GET/SAVE)는 現 이 LOOKUP 미참조(거버넌스 메타).
--          런타임 즉효 없음 — FE/SP 배선 시 발효. 실효 편집배선 = GET_ADMIN_GROUP(_MEASURE).
-- =====================================================================

-- [사전 확인] 기존 DMF0082 행 (0건 예상)
-- SELECT * FROM SCM_ADM_LOOKUP_MASTER_DETAIL
--  WHERE LOOKUP_TYPE='DM_UI_EDITABLE_DIVISION' AND SEGMENT1='DMF0082';

-- [INSERT] 82 = 편집불가 (ATTRIBUTE1='N')
INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
  (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
   DISPLAY_SEQ, VALID_YN, DESCRIPTION, ATTRIBUTE1,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
  ('DM_UI_EDITABLE_DIVISION', 'DMF0082', '82', '-', '-', '-',
   0, 'Y', 'Fcst&Price MGMT', 'N',
   'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE);

COMMIT;

-- [검증] 1건 조회 (82 / ATTRIBUTE1='N')
-- SELECT SEGMENT1, SEGMENT2, ATTRIBUTE1, VALID_YN
--   FROM SCM_ADM_LOOKUP_MASTER_DETAIL
--  WHERE LOOKUP_TYPE='DM_UI_EDITABLE_DIVISION' AND SEGMENT1='DMF0082';

-- [ROLLBACK] (원복 필요 시)
-- DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
--  WHERE LOOKUP_TYPE='DM_UI_EDITABLE_DIVISION' AND SEGMENT1='DMF0082' AND SEGMENT2='82';
-- COMMIT;
