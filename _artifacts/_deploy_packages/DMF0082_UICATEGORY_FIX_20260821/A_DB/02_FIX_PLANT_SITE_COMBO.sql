-- ============================================================================
-- [F2] PLANT_SITE_ID 콤보 : 'PlantByDivisionCompany' -> 'FromSiteByDivision'
--
-- 왜 결함인가 — 같은 화면에서 값 도메인이 갈린다 (division 81 실측)
--   · 그리드 셀 'PlantByDivisionCompany' = SCM_MST_PLANT_SN.PLANT_ID   → 'EG00','G832','HQ04'  (12건)
--   · 조회조건 'PlantSitebyEndCustomer'  = SCM_AXIS_V.SITE_ID          → 'HQ07-A','HQ05-W'     (28건)
--   · 같은 화면 'Sales Price Save All' 시트 = 'FromSiteByDivision'      = SCM_MST_SITE.SCM_SITE_ID (27건)
--   교집합 실측: 플랜트코드 ∩ 사이트코드 = **0건** / 사이트 계열 2종끼리는 27건 일치.
--   ⇒ 그리드에서 고른 값은 조회조건으로 영영 검색되지 않고, GET 이 사이트 코드를 주면
--      셀 콤보 목록에 없어 **CODE raw 노출**이 된다.
--
-- 계보 (왜 이렇게 됐나)
--   AS-IS DMF0003 'Mkt Fcst'.PLANT_SITE_ID = FromSiteByDivision (사이트 코드)
--     → TO-BE DMF0003 이 PlantByDivisionCompany(플랜트 코드)로 **변경**
--     → TO-BE DMF0082 가 그 변경본을 복사 (라벨·DIVISION_ID 문자열까지 동일, SORT 만 210→121)
--
-- 정정 근거 (사용자 확정 2026-08-21)
--   "DMF0003 도 표준이 아니다. AS-IS 의 사전정보를 기준으로 COMBO 를 사용하면
--    FromSiteByDivision 가 적용되는 것이 맞다."
--   `FromSiteByDivision` 은 SCM_ADM_CMBO_SQL_M 에 등록 상태(USE_YN='Y') — 신규 등록 불필요.
-- ============================================================================
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET CELL_COMBO_DATA_TYPE = 'FromSiteByDivision',
       LAST_UPDATED_BY      = 'admin',
       LAST_UPDATE_DATE     = SYSDATE
 WHERE PROGRAM_ID  = 'DMF0082'
   AND SHEET_NAME  = 'FcstNPrice'
   AND COLUMN_NAME = 'PLANT_SITE_ID'
   AND CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox'
   AND CELL_COMBO_DATA_TYPE = 'PlantByDivisionCompany';   -- 현재값 일치 시에만 (멱등)
-- 기대 1행
