-- ============================================================================
-- [F1] PROJECT_CODE ATTRIBUTE1 : '81,82' -> 'PROJECT'   (모달키 정정)
--
-- 왜 결함인가
--   · CELL_CONTROL_OBJECT_TYPE_CODE='FPModal' 행의 ATTRIBUTE1 은 **모달키** 자리다.
--     지금은 division 목록이 들어가 있다.
--   · DMF0003 에서 같은 값이 'ITEM' 모달키를 덮어 **Model 팝업이 깨진 실사고**가 있었고,
--     그 화면은 코드로 방어 중이다:
--       nscm-fe/features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:264-265
--       "(corp attribute1 이 'ITEM' modalKey 를 division 토큰으로 덮어 Model popup 깨지던 사고 차단)"
--       _modalKey: fb?._modalKey ?? col.attribute1
--     즉 화면이 메타를 **무시**해야만 동작하는 상태 = 메타 위임 원칙 위반.
--
-- 정정값 근거
--   · 같은 컬럼의 정상 등록례 : DMF0020 'Sales Price'.PROJECT_CODE ATTRIBUTE1 = 'PROJECT'
--   · DMF0082 FE 화면 상수     : forecast-price.constants.ts:154  CELL_MODAL_KEY.PROJECT_CODE = 'PROJECT'
--
-- 손실 없음
--   · division 범위는 같은 행의 DIVISION_ID 가 이미 보유한다
--     ('82,81,81_UC,81_HM,81_ST,81_HD,81_HG' — ATTRIBUTE1 '81,82' 의 상위집합).
--   · DMF0082 FE 는 attribute1 을 읽지 않는다(전수 grep 0건) → 즉시 회귀 없음.
-- ============================================================================
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET ATTRIBUTE1       = 'PROJECT',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID  = 'DMF0082'
   AND SHEET_NAME  = 'FcstNPrice'
   AND COLUMN_NAME = 'PROJECT_CODE'
   AND CELL_CONTROL_OBJECT_TYPE_CODE = 'FPModal'   -- 컨트롤이 모달일 때만 (오적용 방지)
   AND ATTRIBUTE1  = '81,82';                      -- 현재값 일치할 때만 (재실행 안전)
-- 기대 1행
