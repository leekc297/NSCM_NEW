-- =====================================================================================================
-- DMF0082 FcstNPrice — MEASURE 정적 컬럼을 맨 뒤로 정렬
--   대상: 사내 OCGSCMD_P01 / SCM_MGR  (+ 클라우드 이관 시 동일 실행)
--   작성: 2026-07-13
-- =====================================================================================================
-- [배경] MEASURE 컬럼 grid 표시를 위해 titleset 'C'(USER_INQUIRY_COLUMN_TYPE_CODE='C') 에 MEASURE 를
--        전 사용자(43명) 추가(2026-07-12)하며 SORT_ORDER_NO=85 로 넣어, ITEM_ID(80) 뒤·Model(NICK_NAME 100) 앞에 배치됨.
-- [수정] MEASURE 를 정적 컬럼 맨 뒤로 이동. SHEET_COLUMNS 의 설계 SORT_ORDER_NO(=450, 타 정적컬럼 max 430 보다 뒤)에 정렬.
--        FE 는 USER_SORT_ORDER_NO(=titleset SORT_ORDER_NO) 순으로 컬럼 배치 → 450 이면 맨 뒤.
-- =====================================================================================================

UPDATE SCM_MGR.SCM_MST_TITLESET_USER
   SET SORT_ORDER_NO    = 450
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID  = 'DMF0082'
   AND SHEET_NAME  = 'FcstNPrice'
   AND COLUMN_NAME = 'MEASURE'
   AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

COMMIT;

-- 검증: 43행, SORT_ORDER_NO=450
-- SELECT COUNT(*), MIN(SORT_ORDER_NO), MAX(SORT_ORDER_NO) FROM SCM_MGR.SCM_MST_TITLESET_USER
--  WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND COLUMN_NAME='MEASURE' AND USER_INQUIRY_COLUMN_TYPE_CODE='C';
