-- =====================================================================================
-- DMF0082 클라우드 — 메뉴 버튼 배선 DELETE 3행 보강 (SCM_ADM_MNU_BTN_MPG_M)
--   작성 2026-11-04 · 기준 = 사내 ZIOUI1 실측(2026-10-26 14:59:48 admin 등록 3행, API_ID NULL)
--   QA 실측(2026-11-04 사용자 회신): DMF0082 배선 23행 = 아래 3행 없음
--   멱등: INSERT … NOT EXISTS (이미 있으면 0행) · 기존 행 변경/삭제 없음
--   영향: Delete 버튼 노출 판정(CR-070) 에 쓰이는 행. 화면 오픈/조회 SQL ERROR 와는 별개 항목
--   실행: SCM_MGR · 파일 전체 실행(F5)
-- =====================================================================================

-- PRE: 현재 있는 DELETE 행 (QA 기대 0행)
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN
  FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0082' AND MNU_BTN_CD = 'DELETE'
 ORDER BY SHT_NM;

INSERT INTO SCM_ADM_MNU_BTN_MPG_M
       (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0082', X.SHT_NM, 'DELETE', NULL, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (SELECT 'FcstNPrice' AS SHT_NM FROM DUAL
        UNION ALL SELECT 'fcstNPrice' FROM DUAL
        UNION ALL SELECT 'futurePriceInfo' FROM DUAL) X
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M B
                    WHERE B.MNU_ID = 'DMF0082'
                      AND B.SHT_NM = X.SHT_NM
                      AND B.MNU_BTN_CD = 'DELETE');

COMMIT;

-- POST: 기대 3행 (FcstNPrice / fcstNPrice / futurePriceInfo, USE_YN=Y) · 전체 배선 26행
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN
  FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0082' AND MNU_BTN_CD = 'DELETE'
 ORDER BY SHT_NM;

SELECT COUNT(*) AS BTN_MPG_CNT
  FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0082';
