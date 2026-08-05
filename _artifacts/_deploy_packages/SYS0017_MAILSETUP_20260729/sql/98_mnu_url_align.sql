-- 98_mnu_url_align.sql — SYS0017 MNU_URL / ROUTE_PATH 강제 정렬 (Page Not Found 정정)
--
-- 왜 필요한가:
--   `01_P1_meta_wiring.sql` 의 MNU INSERT 는 `WHERE NOT EXISTS (MNU_ID='SYS0017')` 멱등 조건이다.
--   클라우드에 SYS0017 행이 **이미 다른 MNU_URL 로 존재**했다면 INSERT 가 건너뛰어지고,
--   `99_route_path.sql` 은 ROUTE_PATH 만 UPDATE 하므로 **MNU_URL 은 영원히 정정되지 않는다.**
--   viewRegistry(신판)는 ROUTE_PATH 3단(`admin/system/mail-setup`)을 매칭하지 못하고
--   **MNU_URL 마지막 세그먼트**로만 페이지 폴더(`mail-setup`)를 찾으므로 → 404.
--
-- 실행 전 백업 (반드시 결과를 남길 것):
SELECT MNU_ID, MNU_URL, ROUTE_PATH, UPPR_MNU_ID, MNU_TP_CD, MNU_LV_NO, USE_YN
  FROM SCM_ADM_MNU_M WHERE MNU_ID = 'SYS0017';

-- 정정 (자매 SYS0016 notice-setup 과 동일 형태)
UPDATE SCM_ADM_MNU_M
   SET MNU_URL          = 'mail-setup',
       ROUTE_PATH       = 'admin/system/mail-setup',
       USE_YN           = 'Y',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'SYS0017'
   AND (MNU_URL <> 'mail-setup' OR MNU_URL IS NULL
        OR ROUTE_PATH <> 'admin/system/mail-setup' OR ROUTE_PATH IS NULL
        OR USE_YN <> 'Y');
COMMIT;

-- 확인 — VERDICT 가 OK 여야 한다
SELECT MNU_ID, MNU_URL, REGEXP_SUBSTR(MNU_URL,'[^/]+$') AS URL_LEAF, ROUTE_PATH,
       CASE WHEN REGEXP_SUBSTR(MNU_URL,'[^/]+$') = 'mail-setup' THEN 'OK' ELSE 'NG' END AS VERDICT
  FROM SCM_ADM_MNU_M WHERE MNU_ID = 'SYS0017';

-- ⚠️ DB 정정 후에도 404 면 원인은 FE 다 — `barrel.PATCH.md §4` 의 세대 판별로 넘어갈 것.
--    (구판 viewRegistry = MNU_ID 키 정적 맵이라 DB 값과 무관하게 코드 등록이 필요하다)
