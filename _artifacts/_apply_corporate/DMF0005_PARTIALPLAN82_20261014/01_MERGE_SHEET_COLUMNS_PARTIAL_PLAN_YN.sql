-- =====================================================================================
-- DMF0005 SSPM - production_82 Sheet 에 PARTIAL_PLAN_YN 컬럼 추가  [PARTIALPLAN82]
-- 대상  : SCM_MGR.SCM_MST_SHEET_COLUMNS  (PROGRAM_ID, SHEET_NAME, COLUMN_NAME)
-- 원천  : 같은 화면 기존 행 DMF0005 / Production / PARTIAL_PLAN_YN (DIVISION_ID '82')
--         SOURCE-FRESH: META-ROW SCM_MGR.SCM_MST_SHEET_COLUMNS DMF0005/Production/PARTIAL_PLAN_YN FETCHED=2026-10-14 10:02 DB=ZIOUI1(SERVER_HOST=localhost)
-- 값    : 컬럼 속성(라벨 · 순서 · 정렬 · 폭 · 콤보 · 정렬방향 · 표시 · 입력구분)은 원천 행 그대로.
--         DIVISION_ID · SMALL/LARGE_CLASS_LABEL_NAME 은 production_82 Sheet 기존 27행과 같게 NULL
--         (Sheet 자체가 82 전용이라 사업부 값을 두지 않는다)
-- 성격  : 멱등 · 비파괴 — 이미 행이 있으면 아무것도 바꾸지 않는다 (WHEN NOT MATCHED 만)
-- 실행  : 파일 전체 실행(F5) 가능
-- =====================================================================================

MERGE INTO SCM_MGR.SCM_MST_SHEET_COLUMNS T
USING (
    SELECT 'DMF0005'          AS PROGRAM_ID
         , 'production_82'    AS SHEET_NAME
         , 'PARTIAL_PLAN_YN'  AS COLUMN_NAME
         , 'Partial Plan YN'  AS COLUMN_LABEL_NAME
         , 259                AS SORT_ORDER_NO
         , 'ASC'              AS DATA_SORT_METHOD_CODE
         , 'N'                AS FIXED_FLAG
         , 80                 AS COLUMN_WIDTH
         , 'FPComboBox'       AS CELL_CONTROL_OBJECT_TYPE_CODE
         , 'YesOrNo'          AS CELL_COMBO_DATA_TYPE
         , 'C'                AS HORIZONTAL_ALIGN_CODE
         , 'N'                AS UPPERCASE_APPLY_FLAG
         , 'Y'                AS VISIBLE_FLAG
         , 'Y'                AS DEFAULT_FLAG
         , 'Y'                AS USER_SELECTABLE_FLAG
         , 'Y'                AS VALID_YN
         , 'S'                AS INPUT_TP_CD
      FROM DUAL
) S
ON (    T.PROGRAM_ID  = S.PROGRAM_ID
    AND T.SHEET_NAME  = S.SHEET_NAME
    AND T.COLUMN_NAME = S.COLUMN_NAME )
WHEN NOT MATCHED THEN
    INSERT ( PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO
           , DATA_SORT_METHOD_CODE, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME
           , FIXED_FLAG, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE
           , DATA_SCALE_NUMBER, DATA_MAX_LENGTH, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG
           , VISIBLE_FLAG, DIVISION_ID, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN
           , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, INPUT_TP_CD )
    VALUES ( S.PROGRAM_ID, S.SHEET_NAME, S.COLUMN_NAME, S.COLUMN_LABEL_NAME, S.SORT_ORDER_NO
           , S.DATA_SORT_METHOD_CODE, NULL, NULL
           , S.FIXED_FLAG, S.COLUMN_WIDTH, S.CELL_CONTROL_OBJECT_TYPE_CODE, S.CELL_COMBO_DATA_TYPE
           , NULL, NULL, S.HORIZONTAL_ALIGN_CODE, S.UPPERCASE_APPLY_FLAG
           , S.VISIBLE_FLAG, NULL, S.DEFAULT_FLAG, S.USER_SELECTABLE_FLAG, S.VALID_YN
           , 'admin', SYSDATE, 'admin', SYSDATE, S.INPUT_TP_CD );

COMMIT;

-- 확인 : 1행 (production_82 / PARTIAL_PLAN_YN)
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO
     , CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, VISIBLE_FLAG, DEFAULT_FLAG
     , VALID_YN, INPUT_TP_CD, CREATED_BY, CREATION_DATE
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID  = 'DMF0005'
   AND SHEET_NAME  = 'production_82'
   AND COLUMN_NAME = 'PARTIAL_PLAN_YN';
