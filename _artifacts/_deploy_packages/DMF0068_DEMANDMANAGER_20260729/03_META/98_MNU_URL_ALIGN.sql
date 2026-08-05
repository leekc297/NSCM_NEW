-- 98_MNU_URL_ALIGN.sql — 【SCM_MGR 세션】 DMF0068 MNU_URL/ROUTE_PATH NULL-safe 강제 정렬
--
-- ⛔ 왜 별도 파일이 필요한가 (2026-07-30 클라우드 Page Not Found 원인):
--    `99_ROUTE_PATH.sql` 의 조건이 `AND MNU_URL <> 'demand-manager'` 로 **NULL-unsafe** 였다.
--    MNU_URL 이 NULL(또는 공백)인 환경에서는 `NULL <> 'demand-manager'` = UNKNOWN →
--    **UPDATE 가 0행 매칭되어 조용히 아무것도 안 바뀐다.** (커밋도 성공하므로 로그로는 정상처럼 보인다)
--    사내는 MNU_URL 이 'dmf0068' 문자열이라 우연히 통과했고, 클라우드에서만 터졌다.
--    ※ 같은 계열 함정을 SYS0017 에서도 겪었다(`SHEET_COLUMNS.DIVISION_ID` 가 공백 1바이트 `Typ=1 Len=1: 32`).
--
-- 화면 해석 키는 **MNU_URL 마지막 세그먼트 = FE 페이지 폴더명(`demand-manager`)** 이다.
-- (ROUTE_PATH 는 viewRegistry 에서 `'<도메인>/<폴더>'` 2단만 매칭 — 우리 값은 3단이라 쓰이지 않는다)

-- [백업] 적용 전 상태 — DUMP 로 공백/NULL 을 반드시 눈으로 확인
SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, DUMP(MNU_URL) AS MNU_URL_DUMP,
       ROUTE_PATH, MNU_MSG_ID, MNU_DESC, UNIT_TP_CD, USE_YN
  FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0068';

-- [정정] NULL / 공백 / 구 slug 전부 포괄 (NVL + TRIM)
UPDATE SCM_ADM_MNU_M
   SET MNU_URL          = 'demand-manager',
       ROUTE_PATH       = 'demand/demand-waterfall/demand-manager',
       USE_YN           = 'Y',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0068'
   AND (   NVL(TRIM(MNU_URL),    '-') <> 'demand-manager'
        OR NVL(TRIM(ROUTE_PATH), '-') <> 'demand/demand-waterfall/demand-manager'
        OR NVL(USE_YN, '-')           <> 'Y');
COMMIT;

-- [검증] VERDICT 가 OK 여야 한다. 0행이면 메뉴 자체가 없다는 뜻(별도 조치 필요)
SELECT MNU_ID, MNU_URL,
       REGEXP_SUBSTR(MNU_URL, '[^/]+$') AS URL_LEAF,
       ROUTE_PATH, USE_YN,
       CASE WHEN REGEXP_SUBSTR(MNU_URL, '[^/]+$') = 'demand-manager'
            THEN 'OK' ELSE 'NG ← 404 원인' END AS VERDICT
  FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0068';

-- [참고] 상위 체인 — 조상 MNU_URL 이 비어 있으면 구세대 셸에서 경로 조립이 깨진다
SELECT LEVEL AS LV, MNU_ID, UPPR_MNU_ID, MNU_URL, ROUTE_PATH, USE_YN
  FROM SCM_ADM_MNU_M
 START WITH MNU_ID = 'DMF0068'
 CONNECT BY PRIOR UPPR_MNU_ID = MNU_ID
 ORDER BY LV DESC;

-- ⚠️ DB 가 OK 인데도 404 면 FE 다:
--    ① FE 폴더 `features/demand/src/pages/demand-manager/` 배포 여부
--    ② `viewRegistry` 의 `import.meta.glob` 은 **빌드타임** → 배포 후 **재기동/재빌드 필수**
--    ③ 구판 viewRegistry(`VIEW_REGISTRY` 정적 맵, MNU_ID 키)면 코드 1줄 등록 필수:
--         DMF0068: view(() => import('@demand/demand-manager').then(m => ({ default: m.DemandManager }))),
--    ④ 조치 후에도 재현되면 sessionStorage `MDI-store` 삭제 (깨진 탭이 영속됨)
