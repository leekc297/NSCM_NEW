-- DMF0068 Demand Manager — 컬럼 메타 정정 (2026-07-29)
-- 실측: SCM_MST_SHEET_COLUMNS 159행 (고정 16 + M1~M143)
-- 정정 대상: Result / Plan 은 SResult / SPlan 과 SORT_ORDER_NO 가 같은 중복 등록이며
--            조회 프로시저가 값을 반환하지 않아 화면에 빈 열로 노출된다 → 숨김 처리.
--            (삭제하지 않고 VISIBLE_FLAG 만 N — 원복 가능)
-- ⚠ 기존 행 UPDATE 이므로 적용 전 백업 SELECT 를 남길 것.

-- [백업] 적용 전 상태 확인
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, VISIBLE_FLAG, SORT_ORDER_NO
FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE PROGRAM_ID = 'DMF0068' AND COLUMN_NAME IN ('Result', 'Plan');

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
SET    VISIBLE_FLAG     = 'N',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
WHERE  PROGRAM_ID  = 'DMF0068'
  AND  SHEET_NAME  = 'ContributeSalesList'
  AND  COLUMN_NAME IN ('Result', 'Plan')
  AND  VISIBLE_FLAG <> 'N';

COMMIT;

-- 검증 : 가시 컬럼 = 고정 13 + M1~M143 = 156 기대 (Project / Result / Plan 숨김)
SELECT VISIBLE_FLAG, COUNT(*) AS CNT
FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE PROGRAM_ID = 'DMF0068'
GROUP BY VISIBLE_FLAG ORDER BY 1;
