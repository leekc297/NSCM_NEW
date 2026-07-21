-- =====================================================================
-- DMF0082 (Fcst&Price MGMT) #2 — SALES_BUCKET 요일비트 룩업 등록
--   (2026-07-20 — 최신분석 보완: Insert 행 Site/Incoterms 변경 시 배분 요일비트 캐스케이드)
--
-- 배경:
--   AS-IS DMF0082_FcstNPrice_Mgmt.cs L5862~5874 — ScmSiteId/Incoterms 변경 시
--   GetLookupValues('SALES_BUCKET', div, site, incoterms) 로 행 BUCKET(요일비트) 세팅 →
--   이후 월/주/일 배분의 "할당 요일" 원천. TO-BE 는 이 룩업이 미등록이라 Insert 행이 항상
--   기본요일(40=월)로만 배분되던 결함(#2). 본 SQL 로 룩업 등록.
--
-- 원천/규약 (실측 2026-07-20 ora.py):
--   - 원천 테이블 = SCM_MGR.DM_MST_BUCKET_CONVERSION (Division 40 = 243행/44 site 보유 실측).
--   - AS-IS UP_FX_GETCOMMONDATALIST_DM L563~586 SALES_BUCKET 분기 = 아래 PIVOT 과 동일.
--   - 반환 BUCKET = SUN||MON||TUE||WED||THU||FRI||SAT (SUN-first 7비트) — PKG_DMF0082
--     GET_MAIN_DATA(L3483) 의 기존 행 BUCKET 규약과 동일. FE(ForecastPriceGridUtils.dowSunFirst)
--     가 SUN-first 로 읽도록 교정 완료 → 룩업/GET/FE 3자 정합.
--   - FE 호출: apiClient.getCombo({comboId:'SalesBucket', divisionId, scmSiteId, incoterms}).
--     결과 rows[0].CODE = 요일비트. 매칭 0건이면 PIVOT 이 '0000000' 반환 → FE 가 기본요일로 취급.
--
-- MDU_DIVS_CD='DM' (MktFcstEditMeasure 등 DM 도메인 룩업 관례 동일).
-- 멱등 MERGE / 감사 'admin' (hook #98 §1.1). 콤보 등록명 = FE key ('SalesBucket', 룰 combo-registry).
-- =====================================================================

MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M t
USING (
  SELECT 'SalesBucket' AS SQL_ID,
         'DM' AS MDU_DIVS_CD,
         'Sales Bucket 요일비트(SUN-first) — div/site/incoterms' AS SQL_NM,
         'SELECT BUCKET AS CODE, BUCKET AS NAME FROM (SELECT (NVL(SUN,0)||NVL(MON,0)||NVL(TUE,0)||NVL(WED,0)||NVL(THU,0)||NVL(FRI,0)||NVL(SAT,0)) AS BUCKET FROM (SELECT YYYYMMDD, CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER FROM SCM_MGR.DM_MST_BUCKET_CONVERSION WHERE DIVISION_ID = @divisionId AND SCM_SITE_ID = @scmSiteId AND INCOTERMS = @incoterms) A PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD IN (''SUN'' AS SUN, ''MON'' AS MON, ''TUE'' AS TUE, ''WED'' AS WED, ''THU'' AS THU, ''FRI'' AS FRI, ''SAT'' AS SAT)) PVT)' AS SQL_DTL_CTN
  FROM DUAL
) s
ON (t.SQL_ID = s.SQL_ID)
WHEN MATCHED THEN UPDATE SET
  t.MDU_DIVS_CD = s.MDU_DIVS_CD,
  t.SQL_NM = s.SQL_NM,
  t.SQL_DTL_CTN = s.SQL_DTL_CTN,
  t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin',
  t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
  (s.SQL_ID, s.MDU_DIVS_CD, s.SQL_NM, s.SQL_DTL_CTN, 'Y',
   'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- 검증 (적용 후 실행 권장):
-- SELECT SQL_ID, MDU_DIVS_CD, USE_YN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='SalesBucket';
-- 실동작(예: div40 첫 site/incoterms):
-- SELECT BUCKET AS CODE FROM (SELECT (NVL(SUN,0)||NVL(MON,0)||NVL(TUE,0)||NVL(WED,0)||NVL(THU,0)||NVL(FRI,0)||NVL(SAT,0)) BUCKET
--   FROM (SELECT YYYYMMDD, CASE WHEN BUCKET_PER='Y' THEN 1 ELSE 0 END BUCKET_PER FROM SCM_MGR.DM_MST_BUCKET_CONVERSION
--         WHERE DIVISION_ID='40' AND SCM_SITE_ID='1X Technologies_US_PAO' AND INCOTERMS='FCA') A
--   PIVOT(MAX(BUCKET_PER) FOR YYYYMMDD IN('SUN' SUN,'MON' MON,'TUE' TUE,'WED' WED,'THU' THU,'FRI' FRI,'SAT' SAT)) PVT);

-- 원복 (ROLLBACK — 신규 등록이므로 삭제):
-- DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='SalesBucket';
-- COMMIT;
