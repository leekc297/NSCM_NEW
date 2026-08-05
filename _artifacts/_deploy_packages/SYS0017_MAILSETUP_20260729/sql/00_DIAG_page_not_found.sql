-- 00_DIAG_page_not_found.sql — SYS0017 메뉴 클릭 시 "Page Not Found" 원인 판별 (클라우드에서 실행)
-- 화면 해석은 ROUTE_PATH 가 아니라 **MNU_URL 의 마지막 세그먼트 = 페이지 폴더명** 으로 매칭된다.
--   viewRegistry(신판) findLoader 후보 = [ROUTE_PATH('<도메인>/<폴더>' 2단만 유효), MNU_URL leaf, URL_ALIASES[leaf]]
--   사내 ROUTE_PATH 는 'admin/system/mail-setup' (3단) 이라 **ROUTE_PATH 로는 매칭되지 않고 MNU_URL leaf 로 매칭된다.**
--   → MNU_URL 이 'mail-setup' 이 아니면 신판에서 무조건 404.

-- [1] ⭐ 핵심 — MNU_URL leaf 가 'mail-setup' 인가? (NG 면 98_mnu_url_align.sql 실행)
SELECT MNU_ID, MNU_URL,
       REGEXP_SUBSTR(MNU_URL, '[^/]+$')                 AS URL_LEAF,
       CASE WHEN REGEXP_SUBSTR(MNU_URL,'[^/]+$') = 'mail-setup'
            THEN 'OK' ELSE 'NG ← 404 원인' END          AS VERDICT,
       ROUTE_PATH, UPPR_MNU_ID, USE_YN, MNU_TP_CD, MNU_LV_NO
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID = 'SYS0017';

-- [2] 자매 화면과 형태 비교 (SYS0016 notice-setup 이 정상 동작 기준선)
SELECT MNU_ID, MNU_URL, ROUTE_PATH, UPPR_MNU_ID, MNU_TP_CD, MNU_LV_NO, USE_YN
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID IN ('SYS0004','SYS0015','SYS0016','SYS0017')
 ORDER BY MNU_ID;

-- [3] 상위 경로 (UPPR 체인) — 조상 MNU_URL 이 비어 있으면 구판 셸에서 경로 조립이 깨진다
SELECT LEVEL AS LV, MNU_ID, UPPR_MNU_ID, MNU_URL, ROUTE_PATH, USE_YN
  FROM SCM_ADM_MNU_M
 START WITH MNU_ID = 'SYS0017'
 CONNECT BY PRIOR UPPR_MNU_ID = MNU_ID
 ORDER BY LV DESC;

-- [4] 메뉴 권한 (메뉴가 보이니 통과했을 것 — 그룹 누락 확인용)
SELECT USER_GR_ID, MNU_ID, USE_YN FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID = 'SYS0017' ORDER BY USER_GR_ID;

-- [5] PKG / SYNONYM 존재 (404 와 무관하나 진입 후 조회 실패 판별용)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS
 WHERE OBJECT_NAME = 'PKG_SYS0017' ORDER BY OWNER, OBJECT_TYPE;
