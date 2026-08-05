-- DMF0068 Demand Manager — 컬럼 메타 DIVISION_ID 정정 (2026-07-30)
--
-- 증상 : 화면에 그리드 컬럼이 하나도 보이지 않는다.
-- 원인 : SCM_MST_SHEET_COLUMNS 의 DMF0068 159행이 전부 DIVISION_ID = ' '(공백 1자, DUMP Typ=1 Len=1: 32)
--        로 이관돼 있어, 화면이 부르는 컬럼 조회 API(divisionId='40' 조건)가 0행을 돌려준다.
--        ⚠ NULL 이 아니라 공백이므로 `IS NULL` 조건으로는 잡히지 않는다(1차 시도 0행 매칭).
--        정상 화면(예: DMF0044)은 '40' / '40,82,81,...' 처럼 사업부 토큰을 보유한다.
-- 조치 : DMF0068 은 Division 40 전용이므로 '40' 으로 채운다.
-- ⚠ 기존 행 UPDATE 이므로 적용 전 백업 SELECT 를 먼저 남길 것.

-- [백업] 적용 전 상태 (159행이 공백 1자여야 정상 진단)
SELECT CASE WHEN DIVISION_ID IS NULL THEN '(NULL)'
            ELSE 'LEN=' || LENGTH(DIVISION_ID) || ' [' || DIVISION_ID || ']' END AS DIVISION_ID,
       COUNT(*) AS CNT
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  PROGRAM_ID = 'DMF0068'
GROUP BY CASE WHEN DIVISION_ID IS NULL THEN '(NULL)'
              ELSE 'LEN=' || LENGTH(DIVISION_ID) || ' [' || DIVISION_ID || ']' END;

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
SET    DIVISION_ID      = '40',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
WHERE  PROGRAM_ID  = 'DMF0068'
  AND  SHEET_NAME  = 'ContributeSalesList'
  AND  TRIM(DIVISION_ID) IS NULL;

COMMIT;

-- 검증 : DIVISION_ID='40' 159행 / NULL 0행
SELECT NVL(DIVISION_ID, '(NULL)') AS DIVISION_ID, VISIBLE_FLAG, COUNT(*) AS CNT
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  PROGRAM_ID = 'DMF0068'
GROUP BY DIVISION_ID, VISIBLE_FLAG
ORDER BY 1, 2;
