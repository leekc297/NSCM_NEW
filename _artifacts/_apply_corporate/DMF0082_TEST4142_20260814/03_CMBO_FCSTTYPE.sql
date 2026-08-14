--------------------------------------------------------------------------------------------------
-- [E20260814-WSDIV] 통합테스트 1st No.42 — 40 Div FCST Type 목록 정정 (CMBO 축)
--------------------------------------------------------------------------------------------------
-- 요구 원문 :
--   "40 Div 의 경우 FCST Type 에서 W/S(Chargable), W/S(Free) 항목은 안보여야함"
--   "★ Lookup Code : SALES_TYPE_CODE 기준으로 보여져야 함 (AS 전용여부 Y 인 2건 제외한 모든 항목)"
--   "★ 현재는 SALES_TYPE_CODE2, SALES_TYPE_CODE2_ADD 를 참고 … 해당 Lookup Code 는
--      81, 81_Div 의 DM Planner(W/S) 권한일 경우에만 사용"
--
-- AS-IS 원문 (UP_FX_GetCommonDataList_DM, @CODE='FCST_TYPE', L68~105 — .cs GetFcstType() L8653 호출):
--   IF   @PARAM1 = N'DM Planner (W/S)' → LOOKUP_TYPE='SALES_TYPE_CODE2'                (4종)
--   ELIF @PARAM1 = N'EDIT_MODE'        → SALES_TYPE_CODE2 ∪ SALES_TYPE_CODE2_ADD       (6종)
--   ELSE                                → SALES_TYPE_CODE  AND ISNULL(ATTRIBUTE2,'')<>'Y'
--   ⇒ ELSE 분기에는 **ETC 제외 조건이 없다**. "AS 전용여부" = ATTRIBUTE2 = 'Y' 인 WS·WSF 2건
--      (DESCRIPTION = 'WS팀 전용'). 14 − 2 = **12종(ETC 포함)** 이 정답.
--   ⚠ `AND SEGMENT1 <> 'ETC'` 는 **다른 콤보 코드**의 조건이다 —
--      UP_FX_GetCommonDataList @Code='FCST_TYPE_NOT_ETC'(L3656~3668, 사용화면 DM0003 조회조건).
--      TO-BE 가 이 조건을 DMF0082 셀 콤보에 잘못 옮겨 40 Div 목록이 11종이었다.
--   ⚠ AS-IS 는 division 을 보지 않는다(PARAM1=NowGroupID 만). "40 에서 W/S 노출" 은 AS-IS 결함이고,
--      요구는 여기에 **division 게이트를 추가**하라는 것 → TO-BE 확장으로 반영.
--
-- 구조 (표시용 ↔ 편집용 이원화 — 기존 규약):
--   · FcstTypeByUserGroupDMF0082 = **표시용** 셀 콤보(SHEET_COLUMNS.CELL_COMBO_DATA_TYPE 바인딩).
--       메타 경로는 @divisionId 를 전달하지 않으므로, 미전달 시 SALES_TYPE_CODE 전 14종을 내려
--       원장에 남은 모든 코드의 CODE→NAME 매핑을 보존한다(편집 후보 ⊊ 표시 후보 규약).
--       ⚠ 종전 임시본은 미전달 시 SALES_TYPE_CODE ∪ SALES_TYPE_CODE2 를 UNION 해 A/S 2종이
--         **드롭다운에 중복 표시**됐다(실측 15행) — 단일 룩업으로 정리.
--   · FcstTypeEditDMF0082         = **편집 후보**(FE ForecastPriceGrid L288 이 @divisionId 를 명시 전달).
--       ⚠ FE 는 2026-08-12 부터 이 SQL_ID 를 호출하는데 **등재가 없어 0행**이었다(조용한 빈 콤보).
--------------------------------------------------------------------------------------------------

/* ① 표시용 — 단일 룩업(SALES_TYPE_CODE 14종) + division 전달 시에만 그룹 분기 */
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
SET    SQL_NM = 'DMF0082 FCST Type 표시용 (division 전달 시 W/S 분기 — AS-IS UP_FX_GetCommonDataList_DM)'
     , SQL_DTL_CTN =
'SELECT CODE, NAME, DISPLAY_SEQ FROM (
  /* [E20260814-WSDIV] No.42 — 81 계열 + DM Planner(W/S) 만 SALES_TYPE_CODE2(W/S 4종) */
  SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME, DISPLAY_SEQ
  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  WHERE  LOOKUP_TYPE = ''SALES_TYPE_CODE2''
  AND    VALID_YN = ''Y''
  AND    NVL(TRIM(@divisionId), ''-'') LIKE ''81%''
  AND    EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                 WHERE G.USER_ID = @sesUserId AND G.USER_GR_ID = ''DM Planner (W/S)'' AND G.USE_YN = ''Y'')
  UNION ALL
  /* division 전달 + W/S 자격 아님 → SALES_TYPE_CODE 에서 W/S 전용(ATTRIBUTE2=Y) 2종만 제외 = 12종 */
  SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME, DISPLAY_SEQ
  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  WHERE  LOOKUP_TYPE = ''SALES_TYPE_CODE''
  AND    VALID_YN = ''Y''
  AND    NVL(ATTRIBUTE2, '' '') <> ''Y''
  AND    NVL(TRIM(@divisionId), ''-'') <> ''-''
  AND    NOT ( NVL(TRIM(@divisionId), ''-'') LIKE ''81%''
               AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                           WHERE G.USER_ID = @sesUserId AND G.USER_GR_ID = ''DM Planner (W/S)'' AND G.USE_YN = ''Y'') )
  UNION ALL
  /* division 미전달(메타 셀 콤보 = CODE->NAME 표시 매핑) → 전 코드 1행씩 (중복 없음) */
  SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME, DISPLAY_SEQ
  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  WHERE  LOOKUP_TYPE = ''SALES_TYPE_CODE''
  AND    VALID_YN = ''Y''
  AND    NVL(TRIM(@divisionId), ''-'') = ''-''
) ORDER BY DISPLAY_SEQ, CODE'
     , LAST_UPDATED_BY = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
WHERE  SQL_ID = 'FcstTypeByUserGroupDMF0082';

/* ② 편집 후보 — FE 가 @divisionId 를 명시 전달 (신규 등재) */
MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M T
USING (SELECT 'FcstTypeEditDMF0082' AS SQL_ID FROM DUAL) S
ON (T.SQL_ID = S.SQL_ID)
WHEN NOT MATCHED THEN INSERT
  ( SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN
  , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
VALUES
  ( 'FcstTypeEditDMF0082', 'DM'
  , 'DMF0082 FCST Type 편집후보 (division × DM Planner(W/S) 분기)'
  ,
'SELECT CODE, NAME, DISPLAY_SEQ FROM (
  /* [E20260814-WSDIV] No.42 — 81 계열 + DM Planner(W/S) → SALES_TYPE_CODE2 4종 */
  SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME, DISPLAY_SEQ
  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  WHERE  LOOKUP_TYPE = ''SALES_TYPE_CODE2''
  AND    VALID_YN = ''Y''
  AND    NVL(TRIM(@divisionId), ''-'') LIKE ''81%''
  AND    EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                 WHERE G.USER_ID = @sesUserId AND G.USER_GR_ID = ''DM Planner (W/S)'' AND G.USE_YN = ''Y'')
  UNION ALL
  /* 그 외(40 포함) → SALES_TYPE_CODE 에서 W/S 전용(ATTRIBUTE2=Y) 2종만 제외 = 12종(ETC 포함) */
  SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME, DISPLAY_SEQ
  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  WHERE  LOOKUP_TYPE = ''SALES_TYPE_CODE''
  AND    VALID_YN = ''Y''
  AND    NVL(ATTRIBUTE2, '' '') <> ''Y''
  AND    NOT ( NVL(TRIM(@divisionId), ''-'') LIKE ''81%''
               AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                           WHERE G.USER_ID = @sesUserId AND G.USER_GR_ID = ''DM Planner (W/S)'' AND G.USE_YN = ''Y'') )
) ORDER BY DISPLAY_SEQ, CODE'
  , 'Y', 'admin', SYSDATE, 'admin', SYSDATE );

COMMIT;
