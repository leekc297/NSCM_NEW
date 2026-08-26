-- ============================================================================================
-- DMF0014_GRAYZERO_CLOUD_20260823 / 적용 전 확인 (QA·DEV 각각 실행) — read-only
--   이관 대상 = PKG_DMF0014 **BODY 1본**. (SPEC 은 사내 라이브 == 직전 패키지 실측 동일 → 미동봉)
-- ============================================================================================

PROMPT ===== C1. 대상 객체 존재·상태 (BODY 교체 전 기준선) =====
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') LAST_DDL
FROM   ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0014' ORDER BY OBJECT_TYPE;
-- 기대: PACKAGE / PACKAGE BODY 둘 다 존재. BODY 가 없거나 INVALID 면 직전 패키지부터 확인.

PROMPT ===== C2. ⛔ 선행 패키지(DMF0014_CLOUD_20260818) 적용 여부 =====
-- 본 패키지는 BODY **전체 교체**다. 0818 이 미적용인 클라우드에 이것만 넣으면, 0818 이 함께
-- 싣고 있던 GTT 35종·PR_ 2본·메타가 없어 컴파일 INVALID 또는 런타임 ORA-00942 가 난다.
-- 실측 구분: BODY 가 **직접** 참조하는 GTT = GT_SCFU_RESULTS 1종.
--   GT_DPCF%/GT_DCIM% 35종은 BODY 가 호출하는 PR_DM_PLN_CUST_FCST_TO_MKT_FCST(_40) 의 소비분
--   (= 0818 패키지 03/04 동봉분)이라 **전이 의존**이다. 둘 다 없으면 업로드 후속 배치가 죽는다.
SELECT 'GT_SCFU_RESULTS (BODY 직접)' AS ITEM,
       COUNT(*) AS CNT, 1 AS EXPECTED_MIN
FROM   ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_SCFU_RESULTS'
UNION ALL
SELECT 'GTT(GT_DPCF%/GT_DCIM% — PR_ 전이)' AS ITEM,
       COUNT(*) AS CNT, 35 AS EXPECTED_MIN
FROM   ALL_TABLES
WHERE  OWNER='SCM_MGR' AND TEMPORARY='Y'
AND   (TABLE_NAME LIKE 'GT_DPCF%' OR TABLE_NAME LIKE 'GT_DCIM%' OR TABLE_NAME LIKE 'GT_DPCFRT%')
UNION ALL
SELECT 'PR_DM_PLN_CUST_FCST_TO_MKT_FCST', COUNT(*), 1 FROM ALL_OBJECTS
WHERE  OWNER='SCM_MGR' AND OBJECT_NAME='PR_DM_PLN_CUST_FCST_TO_MKT_FCST' AND OBJECT_TYPE='PROCEDURE'
UNION ALL
SELECT 'PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40', COUNT(*), 1 FROM ALL_OBJECTS
WHERE  OWNER='SCM_MGR' AND OBJECT_NAME='PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40' AND OBJECT_TYPE='PROCEDURE';
-- 하나라도 0 이면 → `DMF0014_CLOUD_20260818` 을 먼저 적용한 뒤 본 패키지를 적용한다.

PROMPT ===== C3. 현재 BODY 세대 (마커) =====
SELECT REGEXP_SUBSTR(TEXT,'E2026[0-9]{4}-[A-Z0-9]+') MARKER, COUNT(*) CNT
FROM   ALL_SOURCE
WHERE  OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY'
AND    REGEXP_LIKE(TEXT,'E2026[0-9]{4}-')
GROUP  BY REGEXP_SUBSTR(TEXT,'E2026[0-9]{4}-[A-Z0-9]+') ORDER BY 1;
-- 적용 전 기대: E20260823-GRAYZERO 0건.
--   E20260818-GRAYWEEK 이 1건이면 0818 세대(회색 주차 = **반려**) — 본 패키지가 0 적재로 바꾼다.
--   둘 다 0 이면 그보다 앞선 세대다(C2 를 반드시 확인).

PROMPT ===== C4. 판정 원천 테이블 접근 (0 적재 판정의 전제) =====
SELECT 'DM_MST_CUSTOMER_FCST' TBL, COUNT(*) ROWS_ANY,
       SUM(CASE WHEN VALID_YN='Y' THEN 1 ELSE 0 END) VALID_Y
FROM   SCM_MGR.DM_MST_CUSTOMER_FCST WHERE ROWNUM <= 100000;
-- 0행이면 **전 칸이 0 으로 적재**된다(마스터가 비면 유효 주차가 하나도 없음) — 데이터 이관 상태 확인 필요.

PROMPT ===== C5. 대상 원장 (적용 후 값 확인 지점) =====
SELECT COUNT(*) PSI_ROWS_UI FROM SCM_MGR.DM_PLN_CUSTOMER_PSI WHERE BATCH_RESULT='UI';
