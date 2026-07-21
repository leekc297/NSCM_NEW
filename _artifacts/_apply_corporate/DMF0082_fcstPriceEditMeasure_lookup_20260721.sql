-- =====================================================================
-- DMF0082 #7 — FcstPriceEditMeasure (Insert 행 편집가능 Measure 콤보) 룩업 등록
--   (2026-07-21 — Insert 행 Measure 편집 시 div/site/bucket 필터된 편집가능 measure 만 노출)
--
-- 배경: AS-IS L5839~5846 GetLookupValues('FCST_PRICE_EDIT_MEASURE','DMF0082',div,site,bucket).
--   원천 = UP_FX_GETCOMMONDATALIST_DM L438~463 (다중문 PL/SQL) → 단일 SELECT 로 정합 변환:
--   - VMI_YN(SCM_MST_SITE div+site) SELECT INTO → 스칼라 서브쿼리 NVL(MAX(),'N') (무행 안전).
--   - LOOKUP_TYPE='DM_UI_EDITABLE_MEASURE', SEGMENT1=PROGRAM_ID('DMF0082'), SEGMENT2=DIVISION_ID,
--     VALID_YN='Y', ATTRIBUTE1='Y'(INSERT_YN), VMI 분기(ATTRIBUTE3), Daily 시 LOC 제외.
--   반환 CODE=SEGMENT3(measure), NAME=SEGMENT4(명칭). ORDER BY DISPLAY_SEQ.
--   실측 검증(2026-07-21): div40/site='1X Technologies_US_PAO'/D → MKT_FCST, VMI_In_Req (LOC 제외 정상).
--
-- FE(@bucketType)= 'D'/'W'/'M' 단일문자 전달(AS-IS 'DAILY' → CASE @bucketType='D').
-- MDU_DIVS_CD='DM'. 멱등 MERGE / 감사 'admin' (hook #98). 등록명 = FE getCombo comboId.
-- =====================================================================

MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M t
USING (
  SELECT 'FcstPriceEditMeasure' AS SQL_ID,
         'DM' AS MDU_DIVS_CD,
         'DMF0082 Insert 편집가능 Measure (div/site/bucket)' AS SQL_NM,
         'SELECT L.SEGMENT3 AS CODE, L.SEGMENT4 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WHERE L.LOOKUP_TYPE = ''DM_UI_EDITABLE_MEASURE'' AND L.SEGMENT1 = ''DMF0082'' AND L.SEGMENT2 = @divisionId AND L.VALID_YN = ''Y'' AND L.ATTRIBUTE1 = ''Y'' AND ((NVL((SELECT MAX(VMI_YN) FROM SCM_MST_SITE WHERE DIVISION_ID = @divisionId AND SCM_SITE_ID = @scmSiteId), ''N'') = ''N'' AND L.ATTRIBUTE3 <> ''Y'') OR NVL((SELECT MAX(VMI_YN) FROM SCM_MST_SITE WHERE DIVISION_ID = @divisionId AND SCM_SITE_ID = @scmSiteId), ''N'') = ''Y'') AND L.SEGMENT3 NOT IN (CASE WHEN @bucketType = ''D'' THEN ''LOC'' ELSE CHR(0) END) ORDER BY L.DISPLAY_SEQ' AS SQL_DTL_CTN
  FROM DUAL
) s
ON (t.SQL_ID = s.SQL_ID)
WHEN MATCHED THEN UPDATE SET
  t.MDU_DIVS_CD = s.MDU_DIVS_CD, t.SQL_NM = s.SQL_NM, t.SQL_DTL_CTN = s.SQL_DTL_CTN, t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
  (s.SQL_ID, s.MDU_DIVS_CD, s.SQL_NM, s.SQL_DTL_CTN, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- 원복: DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='FcstPriceEditMeasure'; COMMIT;
