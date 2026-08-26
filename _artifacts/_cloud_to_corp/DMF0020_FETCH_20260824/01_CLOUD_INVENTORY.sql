-- ============================================================================================
-- [클라우드에서 실행 #1] DMF0020 역이관 — 대상 객체 실존·상태·세대 확인 (read-only)
--   hook #122 cloud-ui-db-object-fetch. 결과를 그대로 보존할 것(사내 대조 기준선).
-- ============================================================================================

PROMPT ===== I1. DMF0020 계열 객체 전량 (사내 22본과 개수·이름 대조) =====
SELECT OBJECT_TYPE, OBJECT_NAME, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
FROM   ALL_OBJECTS
WHERE  OWNER='SCM_MGR'
AND    OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY')
AND    OBJECT_NAME LIKE '%DMF0020%'
ORDER  BY 1,2;

PROMPT ===== I2. PKG_DMF0020 내부 프로시저 (사내 16개와 대조) =====
SELECT PROCEDURE_NAME
FROM   ALL_PROCEDURES
WHERE  OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0020' AND PROCEDURE_NAME IS NOT NULL
ORDER  BY 1;

PROMPT ===== I3. 소스 규모 (사내: SPEC 195 / BODY 4,619 줄) =====
SELECT NAME, TYPE, COUNT(*) LINES
FROM   ALL_SOURCE
WHERE  OWNER='SCM_MGR'
AND    (NAME LIKE '%DMF0020%' OR NAME='PKG_DMF0020')
GROUP  BY NAME, TYPE ORDER BY 1,2;

PROMPT ===== I4. INVALID 이면 자체 오류인지 (오류 0건 = 재컴파일만 필요) =====
SELECT NAME, TYPE, COUNT(*) ERR_CNT, MIN(LINE) FIRST_LINE
FROM   ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME LIKE '%DMF0020%'
GROUP  BY NAME, TYPE ORDER BY 1;
-- 사내 실측(2026-08-24): INVALID 7본 중 6본이 오류 0건(의존 전파) / P_DMF0020_GET_OWNER_DATA 만 ORA-00907 실오류

PROMPT ===== I5. 클라우드 배선 (사내와 다르면 소스보다 이게 먼저다) =====
SELECT B.SHT_NM, B.MNU_BTN_CD, A.API_URL, B.USE_YN
FROM   SCM_ADM_MNU_BTN_MPG_M B LEFT JOIN SCM_ADM_API_M A ON A.API_ID = B.API_ID
WHERE  B.MNU_ID LIKE 'DMF0020%'
ORDER  BY B.SHT_NM, B.MNU_BTN_CD;
-- 사내 실측 배선 12행 — main/priceBatch 조회는 **단독 SP**, exchange/salesPriceRange/salesPriceTemplate 는 **PKG 경유**
