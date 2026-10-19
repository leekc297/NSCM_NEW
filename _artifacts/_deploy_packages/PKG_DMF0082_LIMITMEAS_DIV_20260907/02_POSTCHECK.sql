-- ============================================================================================
-- PKG_DMF0082_LIMITMEAS_DIV_20260907 — 적용 후 검증
--   P1) 객체 상태 : PACKAGE BODY = VALID / 컴파일 에러 0
--   P2) 정정 마커 : [E20260907-LIMITMEAS-DIV] 2곳 (GET_MAIN_DATA / GET_MAIN_DATA_CURRENT)
--   P3) 구 판정 잔존 0 : LIMIT 강제 'N' 이 더 이상 GTT_TEMP_INTO_GROUP_MEASURE(내 그룹) 를 근거로 하지 않음
--   P4) 데이터 전제 : 이 division 에 SCM_FCST 시간창(A1/A2/A3) + LIMIT_MEASURE(A4) 행이 존재
-- ============================================================================================

-- P1
SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') AS last_ddl
FROM   all_objects
WHERE  owner = 'SCM_MGR' AND object_name = 'PKG_DMF0082'
ORDER  BY object_type;

SELECT COUNT(*) AS compile_errors
FROM   all_errors
WHERE  owner = 'SCM_MGR' AND name = 'PKG_DMF0082' AND type = 'PACKAGE BODY';
-- 기대: compile_errors = 0

-- P2 — 정정 마커 2곳
SELECT COUNT(*) AS marker_cnt
FROM   all_source
WHERE  owner = 'SCM_MGR' AND name = 'PKG_DMF0082' AND type = 'PACKAGE BODY'
AND    INSTR(text, 'E20260907-LIMITMEAS-DIV') > 0;
-- 기대: marker_cnt = 2

-- P3 — 구 판정(V_LIMIT_CNT 경유 강제 'N') 실행 코드 잔존 0
--   V_LIMIT_CNT 는 선언 2행 + 정정 주석 2행이 남아 단순 COUNT 는 4 가 정상이다.
--   판정은 **실행 구문**(INTO / IF) 기준으로 한다.
SELECT COUNT(*) AS old_limit_stmt
FROM   all_source
WHERE  owner = 'SCM_MGR' AND name = 'PKG_DMF0082' AND type = 'PACKAGE BODY'
AND   (INSTR(UPPER(text), 'INTO   V_LIMIT_CNT') > 0
       OR REGEXP_LIKE(text, '^\s*IF\s+V_LIMIT_CNT', 'i'));
-- 기대: old_limit_stmt = 0   (사내 실측 2026-09-07 = 0)

-- P4 — 잠금 유발 데이터 전제 (division 별 시간창 + LIMIT_MEASURE)
SELECT SEGMENT3 AS division_id
     , SEGMENT1 AS user_group
     , SEGMENT4 AS measure
     , ATTRIBUTE1 AS edit_day
     , ATTRIBUTE2 AS from_time
     , ATTRIBUTE3 AS to_time
     , ATTRIBUTE4 AS limit_measure
FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
AND    SEGMENT2    = 'DMF0082'
AND    VALID_YN    = 'Y'
AND    ATTRIBUTE4 IS NOT NULL
ORDER  BY SEGMENT3, SEGMENT1;
-- 사내 실측(2026-09-07): 21행 — 전 division 이 SCM_FCST → 'MKT_FCST' 단일 패턴.
--   40 = MON 1000~1900 / 81 계열 = TUE (division 별 시각 상이)

-- P5 — 지금 이 순간 잠겨야 하는 (division, measure) 목록 (적용 효과 즉시 확인용)
SELECT L.SEGMENT3 AS division_id
     , TRIM(LM.TOKEN) AS locked_measure
     , MIN(L.ATTRIBUTE1) AS edit_day
     , MIN(L.ATTRIBUTE2) AS from_time
     , MIN(L.ATTRIBUTE3) AS to_time
FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(L.ATTRIBUTE4, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(L.ATTRIBUTE4, ','), 0) + 1) LM
WHERE  L.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
AND    L.VALID_YN    = 'Y'
AND    L.SEGMENT2    = 'DMF0082'
AND    REPLACE(L.ATTRIBUTE4, ' ', '') IS NOT NULL
AND   (REPLACE(L.ATTRIBUTE1, ' ', '') IS NULL
       OR INSTR(',' || REPLACE(L.ATTRIBUTE1, ' ', '') || ',',
                ',' || TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') || ',') > 0)
AND   (REPLACE(L.ATTRIBUTE2, ' ', '') IS NULL OR L.ATTRIBUTE2 <= TO_CHAR(SYSDATE, 'HH24MI'))
AND   (REPLACE(L.ATTRIBUTE3, ' ', '') IS NULL OR L.ATTRIBUTE3 >= TO_CHAR(SYSDATE, 'HH24MI'))
AND    NOT EXISTS (SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L3
                   WHERE  L3.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                   AND    L3.VALID_YN    = 'Y'
                   AND    L3.SEGMENT2    = L.SEGMENT2
                   AND    L3.SEGMENT3    = L.SEGMENT3
                   AND    L3.SEGMENT1    = TRIM(LM.TOKEN))
GROUP BY L.SEGMENT3, TRIM(LM.TOKEN)
ORDER BY 1, 2;
-- 월요일 10:00~19:00 사이에 실행하면 (40, MKT_FCST) 1행. 그 시간 밖이면 0행 = 잠금 없음(정상).
